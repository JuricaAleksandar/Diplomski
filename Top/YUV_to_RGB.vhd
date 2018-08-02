----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:31:52 06/26/2018 
-- Design Name: 
-- Module Name:    YUV_to_RGB - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity YUV_to_RGB is
		Port
		(
			iCLK : in STD_LOGIC;									-- Input clock signal
			iRST : in STD_LOGIC;									-- Input reset
			iDATA_VALID : in STD_LOGIC;						-- Data valid input signal, when set YUV pixel is loaded to input register
			iYUV : in  STD_LOGIC_VECTOR (23 downto 0);	-- Input pixel value in YUV color space
			oRD_DONE : out STD_LOGIC;							-- Output read done signal, set when input pixel is loaded to input register
			oDATA_VALID : out STD_LOGIC;						-- Data valid output signal, set when pixel conversion is done
			oRGB : out  STD_LOGIC_VECTOR (23 downto 0)	-- Output pixel value in RGB color space
		);
end YUV_to_RGB;

architecture Behavioral of YUV_to_RGB is

	type tSTATE is	-- Converter states
	(
		IDLE,
		STAGE1,
		STAGE2,
		STAGE3,
		DONE
	);

	signal sYUV2RGB_CURRENT_STATE, sYUV2RGB_NEXT_STATE : tSTATE; -- Converter state signals

	signal sRGB_C : STD_LOGIC_VECTOR (47 downto 0); -- C input for all three DSP48A1 instances

	signal sR_P : STD_LOGIC_VECTOR (47 downto 0); -- P output of DSP48A1 for red component
	signal sR_A, sR_B : STD_LOGIC_VECTOR (17 downto 0); -- A and B inputs of DSP48A1 instance for red component 
	
	signal sG_P : STD_LOGIC_VECTOR (47 downto 0); -- P output of DSP48A1 for green component
	signal sG_A, sG_B : STD_LOGIC_VECTOR (17 downto 0); --  A and B inputs of DSP48A1 for green component
	
	signal sB_P : STD_LOGIC_VECTOR (47 downto 0); -- P output of DSP48A1 for blue component
	signal sB_A, sB_B : STD_LOGIC_VECTOR (17 downto 0); --  A and B inputs of DSP48A1 for blue component
	
	signal sRB_OPMODE, sG_OPMODE : STD_LOGIC_VECTOR (7 downto 0); -- DSP48A1 operation mode configuration signals
	signal sRB_CEM, sRB_CEP, sG_CEM, sG_CEP : STD_LOGIC; -- DSP48A1 registers clock enable signals
	signal sRB_RSTM, sRB_RSTP, sG_RSTM, sG_RSTP : STD_LOGIC; -- DSP48A1 registers reset signals
	
	signal sYUV : STD_LOGIC_VECTOR (23 downto 0); -- Input pixel value delayed signal
	signal sINPUT_EN : STD_LOGIC; -- Input pixel register enable signal
	
begin

	r_component_calculate : DSP48A1
   generic map (
      A0REG => 0,              -- First stage A input pipeline register (0/1)
      A1REG => 0,              -- Second stage A input pipeline register (0/1)
      B0REG => 0,              -- First stage B input pipeline register (0/1)
      B1REG => 0,              -- Second stage B input pipeline register (0/1)
      CARRYINREG => 0,         -- CARRYIN input pipeline register (0/1)
      CARRYINSEL => "OPMODE5", -- Specify carry-in source, "CARRYIN" or "OPMODE5" 
      CARRYOUTREG => 0,        -- CARRYOUT output pipeline register (0/1)
      CREG => 0,               -- C input pipeline register (0/1)
      DREG => 0,               -- D pre-adder input pipeline register (0/1)
      MREG => 1,               -- M pipeline register (0/1)
      OPMODEREG => 0,          -- Enable=1/disable=0 OPMODE input pipeline registers
      PREG => 1,               -- P output pipeline register (0/1)
      RSTTYPE => "SYNC"        -- Specify reset type, "SYNC" or "ASYNC" 
   )
   port map (
      -- Cascade Ports: 18-bit (each) output: Ports to cascade from one DSP48 to another
      BCOUT => open,           -- 18-bit output: B port cascade output
      PCOUT => open,           -- 48-bit output: P cascade output (if used, connect to PCIN of another DSP48A1)
      -- Data Ports: 1-bit (each) output: Data input and output ports
      CARRYOUT => open,     -- 1-bit output: carry output (if used, connect to CARRYIN pin of another
                                -- DSP48A1)

      CARRYOUTF => open,   -- 1-bit output: fabric carry output
      M => open,                   -- 36-bit output: fabric multiplier data output
      P => sR_P,                   -- 48-bit output: data output
      -- Cascade Ports: 48-bit (each) input: Ports to cascade from one DSP48 to another
      PCIN => (others => '0'),             -- 48-bit input: P cascade input (if used, connect to PCOUT of another DSP48A1)
      -- Control Input Ports: 1-bit (each) input: Clocking and operation mode
      CLK => iCLK,               -- 1-bit input: clock input
      OPMODE => sRB_OPMODE,         -- 8-bit input: operation mode input
      -- Data Ports: 18-bit (each) input: Data input and output ports
      A => sR_A,                   -- 18-bit input: A data input
      B => sR_B,                   -- 18-bit input: B data input (connected to fabric or BCOUT of adjacent DSP48A1)
      C => sRGB_C,                   -- 48-bit input: C data input
      CARRYIN => '0',       -- 1-bit input: carry input signal (if used, connect to CARRYOUT pin of another
                                -- DSP48A1)

      D => (others => '0'),                   -- 18-bit input: B pre-adder data input
      -- Reset/Clock Enable Input Ports: 1-bit (each) input: Reset and enable input ports
      CEA => '0',               -- 1-bit input: active high clock enable input for A registers
      CEB => '0',               -- 1-bit input: active high clock enable input for B registers
      CEC => '0',               -- 1-bit input: active high clock enable input for C registers
      CECARRYIN => '0',   -- 1-bit input: active high clock enable input for CARRYIN registers
      CED => '0',               -- 1-bit input: active high clock enable input for D registers
      CEM => sRB_CEM,               -- 1-bit input: active high clock enable input for multiplier registers
      CEOPMODE => '0',     -- 1-bit input: active high clock enable input for OPMODE registers
      CEP => sRB_CEP,               -- 1-bit input: active high clock enable input for P registers
      RSTA => '0',             -- 1-bit input: reset input for A pipeline registers
      RSTB => '0',             -- 1-bit input: reset input for B pipeline registers
      RSTC => '0',             -- 1-bit input: reset input for C pipeline registers
      RSTCARRYIN => '0', -- 1-bit input: reset input for CARRYIN pipeline registers
      RSTD => '0',             -- 1-bit input: reset input for D pipeline registers
      RSTM => sRB_RSTM,             -- 1-bit input: reset input for M pipeline registers
      RSTOPMODE => '0',   -- 1-bit input: reset input for OPMODE pipeline registers
      RSTP => sRB_RSTP              -- 1-bit input: reset input for P pipeline registers
   );
	
	g_component_calculate : DSP48A1
   generic map (
      A0REG => 0,              -- First stage A input pipeline register (0/1)
      A1REG => 0,              -- Second stage A input pipeline register (0/1)
      B0REG => 0,              -- First stage B input pipeline register (0/1)
      B1REG => 0,              -- Second stage B input pipeline register (0/1)
      CARRYINREG => 0,         -- CARRYIN input pipeline register (0/1)
      CARRYINSEL => "OPMODE5", -- Specify carry-in source, "CARRYIN" or "OPMODE5" 
      CARRYOUTREG => 0,        -- CARRYOUT output pipeline register (0/1)
      CREG => 0,               -- C input pipeline register (0/1)
      DREG => 0,               -- D pre-adder input pipeline register (0/1)
      MREG => 1,               -- M pipeline register (0/1)
      OPMODEREG => 0,          -- Enable=1/disable=0 OPMODE input pipeline registers
      PREG => 1,               -- P output pipeline register (0/1)
      RSTTYPE => "SYNC"        -- Specify reset type, "SYNC" or "ASYNC" 
   )
   port map (
      -- Cascade Ports: 18-bit (each) output: Ports to cascade from one DSP48 to another
      BCOUT => open,           -- 18-bit output: B port cascade output
      PCOUT => open,           -- 48-bit output: P cascade output (if used, connect to PCIN of another DSP48A1)
      -- Data Ports: 1-bit (each) output: Data input and output ports
      CARRYOUT => open,     -- 1-bit output: carry output (if used, connect to CARRYIN pin of another
                                -- DSP48A1)

      CARRYOUTF => open,   -- 1-bit output: fabric carry output
      M => open,                   -- 36-bit output: fabric multiplier data output
      P => sG_P,                   -- 48-bit output: data output
      -- Cascade Ports: 48-bit (each) input: Ports to cascade from one DSP48 to another
      PCIN => (others => '0'),             -- 48-bit input: P cascade input (if used, connect to PCOUT of another DSP48A1)
      -- Control Input Ports: 1-bit (each) input: Clocking and operation mode
      CLK => iCLK,               -- 1-bit input: clock input
      OPMODE => sG_OPMODE,         -- 8-bit input: operation mode input
      -- Data Ports: 18-bit (each) input: Data input and output ports
      A => sG_A,                   -- 18-bit input: A data input
      B => sG_B,                   -- 18-bit input: B data input (connected to fabric or BCOUT of adjacent DSP48A1)
      C => sRGB_C,                   -- 48-bit input: C data input
      CARRYIN => '0',       -- 1-bit input: carry input signal (if used, connect to CARRYOUT pin of another
                                -- DSP48A1)

      D => (others => '0'),                   -- 18-bit input: B pre-adder data input
      -- Reset/Clock Enable Input Ports: 1-bit (each) input: Reset and enable input ports
      CEA => '0',               -- 1-bit input: active high clock enable input for A registers
      CEB => '0',               -- 1-bit input: active high clock enable input for B registers
      CEC => '0',               -- 1-bit input: active high clock enable input for C registers
      CECARRYIN => '0',   -- 1-bit input: active high clock enable input for CARRYIN registers
      CED => '0',               -- 1-bit input: active high clock enable input for D registers
      CEM => sG_CEM,               -- 1-bit input: active high clock enable input for multiplier registers
      CEOPMODE => '0',     -- 1-bit input: active high clock enable input for OPMODE registers
      CEP => sG_CEP,               -- 1-bit input: active high clock enable input for P registers
      RSTA => '0',             -- 1-bit input: reset input for A pipeline registers
      RSTB => '0',             -- 1-bit input: reset input for B pipeline registers
      RSTC => '0',             -- 1-bit input: reset input for C pipeline registers
      RSTCARRYIN => '0', -- 1-bit input: reset input for CARRYIN pipeline registers
      RSTD => '0',             -- 1-bit input: reset input for D pipeline registers
      RSTM => sG_RSTM,             -- 1-bit input: reset input for M pipeline registers
      RSTOPMODE => '0',   -- 1-bit input: reset input for OPMODE pipeline registers
      RSTP => sG_RSTP              -- 1-bit input: reset input for P pipeline registers
   );
	
	b_component_calculate : DSP48A1
   generic map (
      A0REG => 0,              -- First stage A input pipeline register (0/1)
      A1REG => 0,              -- Second stage A input pipeline register (0/1)
      B0REG => 0,              -- First stage B input pipeline register (0/1)
      B1REG => 0,              -- Second stage B input pipeline register (0/1)
      CARRYINREG => 0,         -- CARRYIN input pipeline register (0/1)
      CARRYINSEL => "OPMODE5", -- Specify carry-in source, "CARRYIN" or "OPMODE5" 
      CARRYOUTREG => 0,        -- CARRYOUT output pipeline register (0/1)
      CREG => 0,               -- C input pipeline register (0/1)
      DREG => 0,               -- D pre-adder input pipeline register (0/1)
      MREG => 1,               -- M pipeline register (0/1)
      OPMODEREG => 0,          -- Enable=1/disable=0 OPMODE input pipeline registers
      PREG => 1,               -- P output pipeline register (0/1)
      RSTTYPE => "SYNC"        -- Specify reset type, "SYNC" or "ASYNC" 
   )
   port map (
      -- Cascade Ports: 18-bit (each) output: Ports to cascade from one DSP48 to another
      BCOUT => open,           -- 18-bit output: B port cascade output
      PCOUT => open,           -- 48-bit output: P cascade output (if used, connect to PCIN of another DSP48A1)
      -- Data Ports: 1-bit (each) output: Data input and output ports
      CARRYOUT => open,     -- 1-bit output: carry output (if used, connect to CARRYIN pin of another
                                -- DSP48A1)

      CARRYOUTF => open,   -- 1-bit output: fabric carry output
      M => open,                   -- 36-bit output: fabric multiplier data output
      P => sB_P,                   -- 48-bit output: data output
      -- Cascade Ports: 48-bit (each) input: Ports to cascade from one DSP48 to another
      PCIN => (others => '0'),             -- 48-bit input: P cascade input (if used, connect to PCOUT of another DSP48A1)
      -- Control Input Ports: 1-bit (each) input: Clocking and operation mode
      CLK => iCLK,               -- 1-bit input: clock input
      OPMODE => sRB_OPMODE,         -- 8-bit input: operation mode input
      -- Data Ports: 18-bit (each) input: Data input and output ports
      A => sB_A,                   -- 18-bit input: A data input
      B => sB_B,                   -- 18-bit input: B data input (connected to fabric or BCOUT of adjacent DSP48A1)
      C => sRGB_C,                   -- 48-bit input: C data input
      CARRYIN => '0',       -- 1-bit input: carry input signal (if used, connect to CARRYOUT pin of another
                                -- DSP48A1)

      D => (others => '0'),                   -- 18-bit input: B pre-adder data input
      -- Reset/Clock Enable Input Ports: 1-bit (each) input: Reset and enable input ports
      CEA => '0',               -- 1-bit input: active high clock enable input for A registers
      CEB => '0',               -- 1-bit input: active high clock enable input for B registers
      CEC => '0',               -- 1-bit input: active high clock enable input for C registers
      CECARRYIN => '0',   -- 1-bit input: active high clock enable input for CARRYIN registers
      CED => '0',               -- 1-bit input: active high clock enable input for D registers
      CEM => sRB_CEM,               -- 1-bit input: active high clock enable input for multiplier registers
      CEOPMODE => '0',     -- 1-bit input: active high clock enable input for OPMODE registers
      CEP => sRB_CEP,               -- 1-bit input: active high clock enable input for P registers
      RSTA => '0',             -- 1-bit input: reset input for A pipeline registers
      RSTB => '0',             -- 1-bit input: reset input for B pipeline registers
      RSTC => '0',             -- 1-bit input: reset input for C pipeline registers
      RSTCARRYIN => '0', -- 1-bit input: reset input for CARRYIN pipeline registers
      RSTD => '0',             -- 1-bit input: reset input for D pipeline registers
      RSTM => sRB_RSTM,             -- 1-bit input: reset input for M pipeline registers
      RSTOPMODE => '0',   -- 1-bit input: reset input for OPMODE pipeline registers
      RSTP => sRB_RSTP              -- 1-bit input: reset input for P pipeline registers
   );
	
	-- Input pixel value register
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sYUV <= (others => '0');
		elsif(iCLK'event and iCLK = '1') then
			if(sINPUT_EN = '1') then
				sYUV <= iYUV;
			end if;
		end if;
	end process;
	
	-- FSM register
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sYUV2RGB_CURRENT_STATE <= IDLE;
		elsif(iCLK'event and iCLK = '1') then
			sYUV2RGB_CURRENT_STATE <= sYUV2RGB_NEXT_STATE;
		end if;
	end process;
	
	-- FSM next state logic
	process(sYUV2RGB_CURRENT_STATE, iDATA_VALID) begin
		case sYUV2RGB_CURRENT_STATE is
			when IDLE =>
				if(iDATA_VALID = '1') then
					sYUV2RGB_NEXT_STATE <= STAGE1;
				else
					sYUV2RGB_NEXT_STATE <= IDLE;
				end if;
				
			when STAGE1 =>
				sYUV2RGB_NEXT_STATE <= STAGE2;
				
			when STAGE2 =>
				sYUV2RGB_NEXT_STATE <= STAGE3;
				
			when STAGE3 =>
				sYUV2RGB_NEXT_STATE <= DONE;
				
			when others =>
				sYUV2RGB_NEXT_STATE <= IDLE;
				
		end case;
	end process;
	
	-- FSM state output logic
	process(sYUV2RGB_CURRENT_STATE, sYUV) begin
		sRB_CEM <= '1';					-- Red and blue component DSP48A1 instances M register clock enable
		sRB_CEP <= '1';					-- Red and blue component DSP48A1 instances P register clock enable
		sRB_RSTM <= '0';					-- Red and blue component DSP48A1 instances M register reset
		sRB_RSTP <= '0';					-- Red and blue component DSP48A1 instances P register reset
		sG_CEM <= '1';						-- Green component DSP48A1 instance M register clock enable
		sG_CEP <= '1';						-- Green component DSP48A1 instance P register clock enable
		sG_RSTM <= '0';					-- Green component DSP48A1 instance M register reset
		sG_RSTP <= '0';					-- Green component DSP48A1 instance P register reset
		sG_A <= (others => '0');		-- Green component DSP48A1 instance A input
		sG_B <= (others => '0');		-- Green component DSP48A1 instance B input
		sG_OPMODE <= (others => '0'); -- Green component DSP48A1 instance operation mode configuration signal
		sINPUT_EN <= '0';					-- Input pixel register clock enable
		oDATA_VALID <= '0';				-- Output data valid signal
		oRD_DONE <= '1';					-- Data valid output signal
		
		case sYUV2RGB_CURRENT_STATE is
			when IDLE =>
				sINPUT_EN <= '1';
				sRB_RSTM <= '1';
				sRB_RSTP <= '1';
				sG_RSTM <= '1';
				sG_RSTP <= '1';
				oRD_DONE <= '0';
				
			when STAGE1 =>
				if(sYUV(7) = '0') then
					sG_A <= '0' & sYUV(7 downto 0) & "000000000";
				else
					sG_A <= '1' & sYUV(7 downto 0) & "111111111";
				end if;
				sG_B <= "111111111100110110";
				sG_OPMODE <= "00001101";
				
			when STAGE2 =>
				if(sYUV(15) = '0') then
					sG_A <= '0' & sYUV(15 downto 8) & "000000000";
				else
					sG_A <= '1' & sYUV(15 downto 8) & "111111111";
				end if;
				sG_B <= "111111111011010111";
				sG_OPMODE <= "00001101";
				
			when STAGE3 =>
				sRB_CEM <= '0';
				sRB_CEP <= '0';
				sG_OPMODE <= "00001001";
				
			when others =>
				sRB_CEM <= '0';
				sRB_CEP <= '0';	
				sG_CEM <= '0';
				sG_CEP <= '0';
				oDATA_VALID <= '1';
			
		end case;
	end process;
	
	sR_A <= '0' & sYUV(7 downto 0) & "000000000" when sYUV(7) = '0' -- if V component has positive value set value of all other bits to 0 else set value of all other bits to 1
		else '1' & sYUV(7 downto 0) & "111111111";
		
	sR_B <= "000000001001000111"; -- 1.13983 decimal, to be multiplied by V component value
	
	sB_A <= '0' & sYUV(15 downto 8) & "000000000" when sYUV(15) = '0' -- if U component has positive value set value of all other bits to 0 else set value of all other bits to 1
		else '1' & sYUV(15 downto 8) & "111111111";
	
	sB_B <= "000000010000010000"; -- 2.03211 decimal, to be multiplied by U component value
	sRGB_C <= "0000000000000000000000" & sYUV(23 downto 16) & "000000000000000000";
	sRB_OPMODE <= "00001101";
	oRGB <= sR_P(25 downto 18) & sG_P(25 downto 18) & sB_P(25 downto 18);
	
end Behavioral;

