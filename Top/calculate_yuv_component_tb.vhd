--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:29:28 07/16/2018
-- Design Name:   
-- Module Name:   D:/Diplomski/Top/calc_luma_tb.vhd
-- Project Name:  Top
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: calculate_luma
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
 
ENTITY calc_luma_tb IS
END calc_luma_tb;
 
ARCHITECTURE behavior OF calc_luma_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT calculate_luma
    PORT(
         iCLK : IN  std_logic;
         iRST : IN  std_logic;
         iRGB : IN  std_logic_vector(23 downto 0);
         oY : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal iCLK : std_logic := '0';
   signal iRST : std_logic := '0';
   signal iRGB : std_logic_vector(23 downto 0) := (others => '0');

 	--Outputs
   signal oY : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant iCLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: calculate_luma PORT MAP (
          iCLK => iCLK,
          iRST => iRST,
          iRGB => iRGB,
          oY => oY
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
      iRST <= '1';
      wait for 100 ns;	
		iRST <= '0';
		iRGB <= x"e2897d";
      wait for iCLK_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
