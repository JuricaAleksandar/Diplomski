----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:43:07 06/29/2018 
-- Design Name: 
-- Module Name:    calculate_chroma - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity calculate_chroma is
    Port ( iCLK : in  STD_LOGIC;
           iRST : in  STD_LOGIC;
			  iSTART : in STD_LOGIC;
			  iRESTART : in STD_LOGIC;
           iRGB : in  STD_LOGIC_VECTOR (23 downto 0);
           oUV : out  STD_LOGIC_VECTOR (15 downto 0));
end calculate_chroma;

architecture Behavioral of calculate_chroma is

	type tSTATE is
	(
		IDLE,
		STAGE1,
		STAGE2,
		STAGE3,
		WAIT_RESULT,
		DONE
	);

	signal sSTATE, sNEXT_STATE : tSTATE;

	signal sA, sU_B, sV_B : STD_LOGIC_VECTOR (17 downto 0);
	signal sU_P, sV_P : STD_LOGIC_VECTOR (47 downto 0);
	
	signal sOPMODE : STD_LOGIC_VECTOR (7 downto 0);
	signal sCEP, sCEM : STD_LOGIC;
	signal sRSTP, sRSTM : STD_LOGIC;
	
	signal sRGB : STD_LOGIC_VECTOR (23 downto 0);
	signal sRGB_EN : STD_LOGIC;
	
begin

	u_component_calculate : DSP48A1
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
      P => sU_P,                   -- 48-bit output: data output
      -- Cascade Ports: 48-bit (each) input: Ports to cascade from one DSP48 to another
      PCIN => (others => '0'),             -- 48-bit input: P cascade input (if used, connect to PCOUT of another DSP48A1)
      -- Control Input Ports: 1-bit (each) input: Clocking and operation mode
      CLK => iCLK,               -- 1-bit input: clock input
      OPMODE => sOPMODE,         -- 8-bit input: operation mode input
      -- Data Ports: 18-bit (each) input: Data input and output ports
      A => sA,                   -- 18-bit input: A data input
      B => sU_B,                   -- 18-bit input: B data input (connected to fabric or BCOUT of adjacent DSP48A1)
      C => (others => '0'),                   -- 48-bit input: C data input
      CARRYIN => '0',       -- 1-bit input: carry input signal (if used, connect to CARRYOUT pin of another
                                -- DSP48A1)

      D => (others => '0'),                   -- 18-bit input: B pre-adder data input
      -- Reset/Clock Enable Input Ports: 1-bit (each) input: Reset and enable input ports
      CEA => '0',               -- 1-bit input: active high clock enable input for A registers
      CEB => '0',               -- 1-bit input: active high clock enable input for B registers
      CEC => '0',               -- 1-bit input: active high clock enable input for C registers
      CECARRYIN => '0',   -- 1-bit input: active high clock enable input for CARRYIN registers
      CED => '0',               -- 1-bit input: active high clock enable input for D registers
      CEM => sCEM,               -- 1-bit input: active high clock enable input for multiplier registers
      CEOPMODE => '0',     -- 1-bit input: active high clock enable input for OPMODE registers
      CEP => sCEP,               -- 1-bit input: active high clock enable input for P registers
      RSTA => '0',             -- 1-bit input: reset input for A pipeline registers
      RSTB => '0',             -- 1-bit input: reset input for B pipeline registers
      RSTC => '0',             -- 1-bit input: reset input for C pipeline registers
      RSTCARRYIN => '0', -- 1-bit input: reset input for CARRYIN pipeline registers
      RSTD => '0',             -- 1-bit input: reset input for D pipeline registers
      RSTM => sRSTM,             -- 1-bit input: reset input for M pipeline registers
      RSTOPMODE => '0',   -- 1-bit input: reset input for OPMODE pipeline registers
      RSTP => sRSTP             -- 1-bit input: reset input for P pipeline registers
   );
	
	v_component_calculate : DSP48A1
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
      P => sV_P,                   -- 48-bit output: data output
      -- Cascade Ports: 48-bit (each) input: Ports to cascade from one DSP48 to another
      PCIN => (others => '0'),             -- 48-bit input: P cascade input (if used, connect to PCOUT of another DSP48A1)
      -- Control Input Ports: 1-bit (each) input: Clocking and operation mode
      CLK => iCLK,               -- 1-bit input: clock input
      OPMODE => sOPMODE,         -- 8-bit input: operation mode input
      -- Data Ports: 18-bit (each) input: Data input and output ports
      A => sA,                   -- 18-bit input: A data input
      B => sV_B,                   -- 18-bit input: B data input (connected to fabric or BCOUT of adjacent DSP48A1)
      C => (others => '0'),                   -- 48-bit input: C data input
      CARRYIN => '0',       -- 1-bit input: carry input signal (if used, connect to CARRYOUT pin of another
                                -- DSP48A1)

      D => (others => '0'),                   -- 18-bit input: B pre-adder data input
      -- Reset/Clock Enable Input Ports: 1-bit (each) input: Reset and enable input ports
      CEA => '0',               -- 1-bit input: active high clock enable input for A registers
      CEB => '0',               -- 1-bit input: active high clock enable input for B registers
      CEC => '0',               -- 1-bit input: active high clock enable input for C registers
      CECARRYIN => '0',   -- 1-bit input: active high clock enable input for CARRYIN registers
      CED => '0',               -- 1-bit input: active high clock enable input for D registers
      CEM => sCEM,               -- 1-bit input: active high clock enable input for multiplier registers
      CEOPMODE => '0',     -- 1-bit input: active high clock enable input for OPMODE registers
      CEP => sCEP,               -- 1-bit input: active high clock enable input for P registers
      RSTA => '0',             -- 1-bit input: reset input for A pipeline registers
      RSTB => '0',             -- 1-bit input: reset input for B pipeline registers
      RSTC => '0',             -- 1-bit input: reset input for C pipeline registers
      RSTCARRYIN => '0', -- 1-bit input: reset input for CARRYIN pipeline registers
      RSTD => '0',             -- 1-bit input: reset input for D pipeline registers
      RSTM => sRSTM,             -- 1-bit input: reset input for M pipeline registers
      RSTOPMODE => '0',   -- 1-bit input: reset input for OPMODE pipeline registers
      RSTP => sRSTP             -- 1-bit input: reset input for P pipeline registers
   );
	
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sRGB <= (others => '0');
		elsif(iCLK'event and iCLK = '1') then
			if(sRGB_EN = '1') then
				sRGB <= iRGB;
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
	
	process(sSTATE, iSTART, iRESTART) begin
		case sSTATE is
			when IDLE =>
				if(iSTART = '1') then
					sNEXT_STATE <= STAGE1;
				else
					sNEXT_STATE <= IDLE;
				end if;
				
			when STAGE1 =>
				sNEXT_STATE <= STAGE2;
				
			when STAGE2 =>
				sNEXT_STATE <= STAGE3;
				
			when STAGE3 =>
				sNEXT_STATE <= WAIT_RESULT;
				
			when WAIT_RESULT =>
				sNEXT_STATE <= DONE;
				
			when others =>
				if(iRESTART = '1') then
					sNEXT_STATE <= IDLE;
				else
					sNEXT_STATE <= DONE;
				end if;
				
		end case;
	end process;
	
	process(sSTATE, sRGB) begin
		sRGB_EN <= '0';
	
		sCEM <= '1';
		sCEP <= '1';
		sRSTM <= '0';
		sRSTP <= '0';
		
		sA <= (others => '0');
		sU_B <= (others => '0');
		sV_B <= (others => '0');
		
		case sSTATE is
			when IDLE =>
				sRGB_EN <= '1';
				sRSTM <= '1';
				sRSTP <= '1';
				
			when STAGE1 =>
				sA <= '0' & sRGB(23 downto 16) & "000000000";
				sU_B <= "111111111110110101";
				sV_B <= "000000000100111010";
				
			when STAGE2 =>
				sA <= '0' & sRGB(15 downto 8) & "000000000";
				sU_B <= "111111111101101101";
				sV_B <= "111111111011111001";
				
			when STAGE3 =>
				sA <= '0' & sRGB(7 downto 0) & "000000000";
				sU_B <= "000000000011011111";
				sV_B <= "111111111111001101";
				
			when WAIT_RESULT =>
				sCEM <= '0';
				
			when others =>
				sCEM <= '0';
				sCEP <= '0';
		
		end case;
	end process;
	
	sOPMODE <= "00001001";
	oUV <= sU_P(25 downto 18) & sV_P(25 downto 18);
	
end Behavioral;

