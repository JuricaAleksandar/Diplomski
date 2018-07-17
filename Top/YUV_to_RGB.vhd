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
			iCLK : in STD_LOGIC;
			iRST : in STD_LOGIC;
			iDATA_VALID : in STD_LOGIC;
			iYUV : in  STD_LOGIC_VECTOR (23 downto 0);
			oRD_DONE : out STD_LOGIC;
			oDATA_VALID : out STD_LOGIC;
			oRGB : out  STD_LOGIC_VECTOR (23 downto 0)
		);
end YUV_to_RGB;

architecture Behavioral of YUV_to_RGB is

	type tSTATE is
	(
		IDLE,
		STAGE1,
		STAGE2,
		STAGE3,
		DONE
	);

	signal sSTATE, sNEXT_STATE : tSTATE;

	signal sRGB_C : STD_LOGIC_VECTOR (47 downto 0);

	signal sR_P : STD_LOGIC_VECTOR (47 downto 0);
	signal sR_A, sR_B : STD_LOGIC_VECTOR (17 downto 0);
	
	signal sG_P : STD_LOGIC_VECTOR (47 downto 0);
	signal sG_A, sG_B : STD_LOGIC_VECTOR (17 downto 0);
	
	signal sB_P : STD_LOGIC_VECTOR (47 downto 0);
	signal sB_A, sB_B : STD_LOGIC_VECTOR (17 downto 0);
	
	signal sRB_OPMODE, sG_OPMODE : STD_LOGIC_VECTOR (7 downto 0);
	signal sRB_CEM, sRB_CEP, sG_CEM, sG_CEP : STD_LOGIC;
	signal sRB_RSTM, sRB_RSTP, sG_RSTM, sG_RSTP : STD_LOGIC;
	
	signal sYUV : STD_LOGIC_VECTOR (23 downto 0);
	signal sINPUT_EN : STD_LOGIC;
	
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
	
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sYUV <= (others => '0');
		elsif(iCLK'event and iCLK = '1') then
			if(sINPUT_EN = '1') then
				sYUV <= iYUV;
			end if;
		end if;
	end process;
	
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sSTATE <= IDLE;
		elsif(iCLK'event and iCLK = '1') then
			sSTATE <= sNEXT_STATE;
		end if;
	end process;
	
	process(sSTATE, iDATA_VALID) begin
		case sSTATE is
			when IDLE =>
				if(iDATA_VALID = '1') then
					sNEXT_STATE <= STAGE1;
				else
					sNEXT_STATE <= IDLE;
				end if;
				
			when STAGE1 =>
				sNEXT_STATE <= STAGE2;
				
			when STAGE2 =>
				sNEXT_STATE <= STAGE3;
				
			when STAGE3 =>
				sNEXT_STATE <= DONE;
				
			when others =>
				sNEXT_STATE <= IDLE;
				
		end case;
	end process;
	
	process(sSTATE, sYUV) begin
		sRB_CEM <= '1';
		sRB_CEP <= '1';
		sRB_RSTM <= '0';
		sRB_RSTP <= '0';
		sG_CEM <= '1';
		sG_CEP <= '1';
		sG_RSTM <= '0';
		sG_RSTP <= '0';
		sG_A <= (others => '0');
		sG_B <= (others => '0');
		sG_OPMODE <= (others => '0');
		sINPUT_EN <= '0';
		oDATA_VALID <= '0';
		oRD_DONE <= '1';
		
		case sSTATE is
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
	
	sR_A <= '0' & sYUV(7 downto 0) & "000000000" when sYUV(7) = '0'
		else '1' & sYUV(7 downto 0) & "111111111";
		
	sR_B <= "000000001001000111";
	
	sB_A <= '0' & sYUV(15 downto 8) & "000000000" when sYUV(15) = '0'
		else '1' & sYUV(15 downto 8) & "111111111";
	
	sB_B <= "000000010000010000";
	sRGB_C <= "0000000000000000000000" & sYUV(23 downto 16) & "000000000000000000";
	sRB_OPMODE <= "00001101";
	oRGB <= sR_P(25 downto 18) & sG_P(25 downto 18) & sB_P(25 downto 18);
	
end Behavioral;

