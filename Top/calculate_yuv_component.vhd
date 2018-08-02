----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:09:47 06/28/2018 
-- Design Name: 
-- Module Name:    calculate_y - Behavioral 
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

entity calculate_yuv_components is
	 Generic ( OUTPUT_COMPONENT : STRING := "Y");
    Port ( iCLK : in  STD_LOGIC;											-- Input clock signal
           iRGB : in  STD_LOGIC_VECTOR (23 downto 0);				-- Input pixel value in RGB color space
           oCOMP : out  STD_LOGIC_VECTOR (7 downto 0));			-- Output Y,U or V component
end calculate_yuv_components;

architecture Behavioral of calculate_yuv_components is

	signal sFS_A, sFS_B : STD_LOGIC_VECTOR (17 downto 0);			-- First stage A and B inputs for DSP48A1
	signal sFS_C, sFS_RES : STD_LOGIC_VECTOR (47 downto 0);		-- First stage C input signal and first stage result signal (FS_A * FS_B + FS_C = FS_RES)
	signal sFS_OPMODE : STD_LOGIC_VECTOR (7 downto 0);				-- First stage operation mode configuration signal
	
	signal sSS_A, sSS_B : STD_LOGIC_VECTOR (17 downto 0);			-- Second stage A and B inputs for DSP48A1
	signal sSS_RES : STD_LOGIC_VECTOR (47 downto 0);				-- Second stage result signal (SS_A * SS_B + FS_RES = SS_RES)
	signal sSS_OPMODE : STD_LOGIC_VECTOR (7 downto 0);				-- Second stage operation mode configuration signal
	
	signal sTS_A, sTS_B : STD_LOGIC_VECTOR (17 downto 0);			-- Third stage A and B inputs for DSP48A1
	signal sTS_RES : STD_LOGIC_VECTOR (47 downto 0);				-- Third stage result signal (TS_A * TS_B + SS_RES = TS_RES)
	signal sTS_OPMODE : STD_LOGIC_VECTOR (7 downto 0);				-- Third stage operation mode configuration signal

	signal sRGB : STD_LOGIC_VECTOR (23 downto 0);					-- Input delay signal

begin
	
	-- Input signal delay register
	process(iCLK) begin
		if(iCLK'event and iCLK = '1') then
			sRGB <= iRGB;
		end if;
	end process;

	first_stage : DSP48A1
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
      PCOUT => sFS_RES,           -- 48-bit output: P cascade output (if used, connect to PCIN of another DSP48A1)
      -- Data Ports: 1-bit (each) output: Data input and output ports
      CARRYOUT => open,     -- 1-bit output: carry output (if used, connect to CARRYIN pin of another
                                -- DSP48A1)

      CARRYOUTF => open,   -- 1-bit output: fabric carry output
      M => open,                   -- 36-bit output: fabric multiplier data output
      P => open,                   -- 48-bit output: data output
      -- Cascade Ports: 48-bit (each) input: Ports to cascade from one DSP48 to another
      PCIN => (others => '0'),             -- 48-bit input: P cascade input (if used, connect to PCOUT of another DSP48A1)
      -- Control Input Ports: 1-bit (each) input: Clocking and operation mode
      CLK => iCLK,               -- 1-bit input: clock input
      OPMODE => sFS_OPMODE,         -- 8-bit input: operation mode input
      -- Data Ports: 18-bit (each) input: Data input and output ports
      A => sFS_A,                   -- 18-bit input: A data input
      B => sFS_B,                   -- 18-bit input: B data input (connected to fabric or BCOUT of adjacent DSP48A1)
      C => sFS_C,                   -- 48-bit input: C data input
      CARRYIN => '0',       -- 1-bit input: carry input signal (if used, connect to CARRYOUT pin of another
                                -- DSP48A1)

      D => (others => '0'),                   -- 18-bit input: B pre-adder data input
      -- Reset/Clock Enable Input Ports: 1-bit (each) input: Reset and enable input ports
      CEA => '0',               -- 1-bit input: active high clock enable input for A registers
      CEB => '0',               -- 1-bit input: active high clock enable input for B registers
      CEC => '0',               -- 1-bit input: active high clock enable input for C registers
      CECARRYIN => '0',   -- 1-bit input: active high clock enable input for CARRYIN registers
      CED => '0',               -- 1-bit input: active high clock enable input for D registers
      CEM => '1',               -- 1-bit input: active high clock enable input for multiplier registers
      CEOPMODE => '0',     -- 1-bit input: active high clock enable input for OPMODE registers
      CEP => '1',               -- 1-bit input: active high clock enable input for P registers
      RSTA => '0',             -- 1-bit input: reset input for A pipeline registers
      RSTB => '0',             -- 1-bit input: reset input for B pipeline registers
      RSTC => '0',             -- 1-bit input: reset input for C pipeline registers
      RSTCARRYIN => '0', -- 1-bit input: reset input for CARRYIN pipeline registers
      RSTD => '0',             -- 1-bit input: reset input for D pipeline registers
      RSTM => '0',             -- 1-bit input: reset input for M pipeline registers
      RSTOPMODE => '0',   -- 1-bit input: reset input for OPMODE pipeline registers
      RSTP => '0'              -- 1-bit input: reset input for P pipeline registers
   );
	
	second_stage : DSP48A1
   generic map (
      A0REG => 0,              -- First stage A input pipeline register (0/1)
      A1REG => 1,              -- Second stage A input pipeline register (0/1)
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
      PCOUT => sSS_RES,           -- 48-bit output: P cascade output (if used, connect to PCIN of another DSP48A1)
      -- Data Ports: 1-bit (each) output: Data input and output ports
      CARRYOUT => open,     -- 1-bit output: carry output (if used, connect to CARRYIN pin of another
                                -- DSP48A1)

      CARRYOUTF => open,   -- 1-bit output: fabric carry output
      M => open,                   -- 36-bit output: fabric multiplier data output
      P => open,                   -- 48-bit output: data output
      -- Cascade Ports: 48-bit (each) input: Ports to cascade from one DSP48 to another
      PCIN => sFS_RES,             -- 48-bit input: P cascade input (if used, connect to PCOUT of another DSP48A1)
      -- Control Input Ports: 1-bit (each) input: Clocking and operation mode
      CLK => iCLK,               -- 1-bit input: clock input
      OPMODE => sSS_OPMODE,         -- 8-bit input: operation mode input
      -- Data Ports: 18-bit (each) input: Data input and output ports
      A => sSS_A,                   -- 18-bit input: A data input
      B => sSS_B,                   -- 18-bit input: B data input (connected to fabric or BCOUT of adjacent DSP48A1)
      C => (others => '0'),                   -- 48-bit input: C data input
      CARRYIN => '0',       -- 1-bit input: carry input signal (if used, connect to CARRYOUT pin of another
                                -- DSP48A1)

      D => (others => '0'),                   -- 18-bit input: B pre-adder data input
      -- Reset/Clock Enable Input Ports: 1-bit (each) input: Reset and enable input ports
      CEA => '1',               -- 1-bit input: active high clock enable input for A registers
      CEB => '0',               -- 1-bit input: active high clock enable input for B registers
      CEC => '0',               -- 1-bit input: active high clock enable input for C registers
      CECARRYIN => '0',   -- 1-bit input: active high clock enable input for CARRYIN registers
      CED => '0',               -- 1-bit input: active high clock enable input for D registers
      CEM => '1',               -- 1-bit input: active high clock enable input for multiplier registers
      CEOPMODE => '0',     -- 1-bit input: active high clock enable input for OPMODE registers
      CEP => '1',               -- 1-bit input: active high clock enable input for P registers
      RSTA => '0',             -- 1-bit input: reset input for A pipeline registers
      RSTB => '0',             -- 1-bit input: reset input for B pipeline registers
      RSTC => '0',             -- 1-bit input: reset input for C pipeline registers
      RSTCARRYIN => '0', -- 1-bit input: reset input for CARRYIN pipeline registers
      RSTD => '0',             -- 1-bit input: reset input for D pipeline registers
      RSTM => '0',             -- 1-bit input: reset input for M pipeline registers
      RSTOPMODE => '0',   -- 1-bit input: reset input for OPMODE pipeline registers
      RSTP => '0'              -- 1-bit input: reset input for P pipeline registers
   );
	
	third_stage : DSP48A1
   generic map (
      A0REG => 1,              -- First stage A input pipeline register (0/1)
      A1REG => 1,              -- Second stage A input pipeline register (0/1)
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
      P => sTS_RES,                   -- 48-bit output: data output
      -- Cascade Ports: 48-bit (each) input: Ports to cascade from one DSP48 to another
      PCIN => sSS_RES,             -- 48-bit input: P cascade input (if used, connect to PCOUT of another DSP48A1)
      -- Control Input Ports: 1-bit (each) input: Clocking and operation mode
      CLK => iCLK,               -- 1-bit input: clock input
      OPMODE => sTS_OPMODE,         -- 8-bit input: operation mode input
      -- Data Ports: 18-bit (each) input: Data input and output ports
      A => sTS_A,                   -- 18-bit input: A data input
      B => sTS_B,                   -- 18-bit input: B data input (connected to fabric or BCOUT of adjacent DSP48A1)
      C => (others => '0'),                   -- 48-bit input: C data input
      CARRYIN => '0',       -- 1-bit input: carry input signal (if used, connect to CARRYOUT pin of another
                                -- DSP48A1)

      D => (others => '0'),                   -- 18-bit input: B pre-adder data input
      -- Reset/Clock Enable Input Ports: 1-bit (each) input: Reset and enable input ports
      CEA => '1',               -- 1-bit input: active high clock enable input for A registers
      CEB => '0',               -- 1-bit input: active high clock enable input for B registers
      CEC => '0',               -- 1-bit input: active high clock enable input for C registers
      CECARRYIN => '0',   -- 1-bit input: active high clock enable input for CARRYIN registers
      CED => '0',               -- 1-bit input: active high clock enable input for D registers
      CEM => '1',               -- 1-bit input: active high clock enable input for multiplier registers
      CEOPMODE => '0',     -- 1-bit input: active high clock enable input for OPMODE registers
      CEP => '1',               -- 1-bit input: active high clock enable input for P registers
      RSTA => '0',             -- 1-bit input: reset input for A pipeline registers
      RSTB => '0',             -- 1-bit input: reset input for B pipeline registers
      RSTC => '0',             -- 1-bit input: reset input for C pipeline registers
      RSTCARRYIN => '0', -- 1-bit input: reset input for CARRYIN pipeline registers
      RSTD => '0',             -- 1-bit input: reset input for D pipeline registers
      RSTM => '0',             -- 1-bit input: reset input for M pipeline registers
      RSTOPMODE => '0',   -- 1-bit input: reset input for OPMODE pipeline registers
      RSTP => '0'              -- 1-bit input: reset input for P pipeline registers
   );
	
	sFS_A <= '0' & sRGB(23 downto 16) & "000000000"; -- First stage A input for DSP48A1, R component value
	sFS_C <= x"000000020000"; -- First stage C input for DSP48A1, 0.5 in decimal
	sFS_OPMODE <= "00001101";
	
	sSS_A <= '0' & sRGB(15 downto 8) & "000000000"; -- Second stage A input for DSP48A1, G component value
	sSS_OPMODE <= "00000101";
	
	sTS_A <= '0' & sRGB(7 downto 0) & "000000000"; -- Third stage A input for DSP48A1, B component value
	sTS_OPMODE <= "00000101";
	
	Y_COMP : if (OUTPUT_COMPONENT = "Y") generate begin
		sFS_B <= "000000000010011001"; -- First stage B input for DSP48A1, 0.299 decimal
		sSS_B <= "000000000100101100"; -- Second stage B input for DSP48A1, 0.587 decimal
		sTS_B <= "000000000000111010"; -- Third stage B input for DSP48A1, 0.114 decimal
	end generate Y_COMP;
	
	U_COMP : if (OUTPUT_COMPONENT = "U") generate begin
		sFS_B <= "111111111110110101"; -- First stage B input for DSP48A1, -0.14713 decimal
		sSS_B <= "111111111101101101"; -- Second stage B input for DSP48A1, -0.28886 decimal
		sTS_B <= "000000000011011111"; -- Third stage B input for DSP48A1, 0.436 decimal
	end generate U_COMP;
	
	V_COMP : if (OUTPUT_COMPONENT = "V") generate begin
		sFS_B <= "000000000100111010"; -- First stage B input for DSP48A1, 0.615 decimal
		sSS_B <= "111111111011111001"; -- Second stage B input for DSP48A1, -0.51499 decimal
		sTS_B <= "111111111111001101"; -- Third stage B input for DSP48A1, -0.10001 decimal
	end generate V_COMP;

	oCOMP <= sTS_RES(25 downto 18);

end Behavioral;

