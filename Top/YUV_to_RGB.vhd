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
			iYUV : in  STD_LOGIC_VECTOR (23 downto 0);
			oRGB : out  STD_LOGIC_VECTOR (23 downto 0)
		);
end YUV_to_RGB;

architecture Behavioral of YUV_to_RGB is

	signal sRGB_C : STD_LOGIC_VECTOR (47 downto 0);

	signal sR_P : STD_LOGIC_VECTOR (47 downto 0);
	signal sR_A, sR_B : STD_LOGIC_VECTOR (17 downto 0);
	
	signal sB_P : STD_LOGIC_VECTOR (47 downto 0);
	signal sB_A, sB_B : STD_LOGIC_VECTOR (17 downto 0);
	
	signal sRB_OPMODE : STD_LOGIC_VECTOR (7 downto 0);
	signal sRB_CEM, sRB_CEP : STD_LOGIC;
	signal sRB_RSTM, sRB_RSTP : STD_LOGIC;
	
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

	sRGB_C <= "0000000000000000000000" & iYUV(23 downto 16) & "000000000000000000";

	sR_A <= '0' & iYUV(7 downto 0) & "000000000";
	sR_B <= "000000001001000111";
	
	sB_A <= '0' & iYUV(15 downto 8) & "000000000";
	sB_B <= "000000010000010000";
	
	sRB_OPMODE <= "00001101";
	sRB_CEM <= '1';
	sRB_CEP <= '1';
	sRB_RSTM <= '0';
	sRB_RSTP <= '0';
	
	oRGB <= sR_P(25 downto 18) & x"00" & sB_P(25 downto 18);
	
end Behavioral;

