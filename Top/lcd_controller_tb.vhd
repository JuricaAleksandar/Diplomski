--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:46:34 07/04/2018
-- Design Name:   
-- Module Name:   D:/Diplomski/Top/lcd_controller_tb.vhd
-- Project Name:  Top
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: lcd_controller
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY lcd_controller_tb IS
END lcd_controller_tb;
 
ARCHITECTURE behavior OF lcd_controller_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT lcd_controller
    PORT(
         iCLK : IN  std_logic;
         iRST : IN  std_logic;
         iMODE : IN  std_logic_vector(1 downto 0);
			iSPLIT_SCREEN : IN std_logic;
         oRS : OUT  std_logic;
         oRW : OUT  std_logic;
         oEN : OUT  std_logic;
			oL : OUT std_logic;
         oDATA : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal iCLK : std_logic := '0';
   signal iRST : std_logic := '0';
   signal iMODE : std_logic_vector(1 downto 0) := (others => '0');
	signal iSPLIT_SCREEN : std_logic;

 	--Outputs
   signal oRS : std_logic;
   signal oRW : std_logic;
   signal oEN : std_logic;
   signal oDATA : std_logic_vector(3 downto 0);
	signal oL : std_logic;

   -- Clock period definitions
   constant iCLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: lcd_controller PORT MAP (
          iCLK => iCLK,
          iRST => iRST,
          iMODE => iMODE,
			 iSPLIT_SCREEN => iSPLIT_SCREEN,
          oRS => oRS,
          oRW => oRW,
          oEN => oEN,
			 oL => oL,
          oDATA => oDATA
        );

   -- Clock process definitions
   iCLK_process :process
   begin
		iCLK <= '0';
		wait for iCLK_period/2;
		iCLK <= '1';
		wait for iCLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		iSPLIT_SCREEN <= '0';
		iMODE <= "11";
      iRST <= '1';
      wait for 100 ns;	
		iRST <= '0';
		wait for 40 ms;
		iMODE <= "01";
     
      wait;
   end process;

END;
