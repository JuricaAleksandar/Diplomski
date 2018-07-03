--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:08:13 07/02/2018
-- Design Name:   
-- Module Name:   D:/Diplomski/Top/switch_debouncer_tb.vhd
-- Project Name:  Top
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: switch_debouncer
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
 
ENTITY switch_debouncer_tb IS
END switch_debouncer_tb;
 
ARCHITECTURE behavior OF switch_debouncer_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT switch_debouncer
    PORT(
         iCLK : IN  std_logic;
         iRST : IN  std_logic;
         iMODE : IN  std_logic_vector(1 downto 0);
         oMODE : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal iCLK : std_logic := '0';
   signal iRST : std_logic := '0';
   signal iMODE : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal oMODE : std_logic_vector(1 downto 0);

   -- Clock period definitions
   constant iCLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: switch_debouncer PORT MAP (
          iCLK => iCLK,
          iRST => iRST,
          iMODE => iMODE,
          oMODE => oMODE
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
      iMODE <= "00";
		wait for iCLK_period;
		iMODE <= "10";
		wait for iCLK_period;
		iMODE <= "00";
		wait for iCLK_period;
		iMODE <= "10";
		wait for iCLK_period;
		iMODE <= "00";
		wait for iCLK_period;
		iMODE <= "10";
		wait for iCLK_period;
		iMODE <= "00";
		wait for iCLK_period;
		iMODE <= "10";
		wait for iCLK_period;
		iMODE <= "11";
		wait for 5 ms;
		iMODE <= "10";
      wait;
   end process;

END;
