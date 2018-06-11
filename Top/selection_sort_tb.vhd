--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:10:35 06/04/2018
-- Design Name:   
-- Module Name:   D:/Diplomski/Top/median_filter_tb.vhd
-- Project Name:  Top
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: median_filter
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
 
ENTITY selection_sort_tb IS
END selection_sort_tb;
 
ARCHITECTURE behavior OF selection_sort_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT selection_sort
    PORT(
         iCLK : IN  std_logic;
         iRST: IN  std_logic;
         iWR_EN : IN  std_logic;
         iWR_ADDR : IN  std_logic_vector(3 downto 0);
         iWR_DATA : IN  std_logic_vector(7 downto 0);
         iSTART : IN  std_logic;
         oDATA : OUT  std_logic_vector(7 downto 0);
         oDATA_VALID : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal iCLK : std_logic := '0';
   signal iRST: std_logic := '0';
   signal iWR_EN : std_logic := '0';
   signal iWR_ADDR : std_logic_vector(3 downto 0) := (others => '0');
   signal iWR_DATA : std_logic_vector(7 downto 0) := (others => '0');
   signal iSTART : std_logic := '0';

 	--Outputs
   signal oDATA : std_logic_vector(7 downto 0);
   signal oDATA_VALID : std_logic;

   -- Clock period definitions
   constant iCLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: selection_sort PORT MAP (
          iCLK => iCLK,
          iRST=> inRST,
          iWR_EN => iWR_EN,
          iWR_ADDR => iWR_ADDR,
          iWR_DATA => iWR_DATA,
          iSTART => iSTART,
          oDATA => oDATA,
          oDATA_VALID => oDATA_VALID
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
      iRST<= '1';
		iSTART <= '0';
      wait for 100 ns;	
		iRST<= '0';
		iWR_ADDR <= x"0";
		iWR_DATA <= x"0a";
		iWR_EN <= '1';
      wait for iCLK_period;
		iWR_ADDR <= x"1";
		iWR_DATA <= x"09";
		wait for iCLK_period;
		iWR_ADDR <= x"2";
		iWR_DATA <= x"08";
		wait for iCLK_period;
		iWR_ADDR <= x"3";
		iWR_DATA <= x"07";
		wait for iCLK_period;
		iWR_ADDR <= x"4";
		iWR_DATA <= x"06";
		wait for iCLK_period;
		iWR_ADDR <= x"5";
		iWR_DATA <= x"05";
		wait for iCLK_period;
		iWR_ADDR <= x"6";
		iWR_DATA <= x"04";
		wait for iCLK_period;
		iWR_ADDR <= x"7";
		iWR_DATA <= x"03";
		wait for iCLK_period;
		iWR_ADDR <= x"8";
		iWR_DATA <= x"02";
		wait for iCLK_period;
		iWR_DATA <= x"01";
		iWR_EN <= '0';
      wait for iCLK_period*5;
		iSTART <= '1';
		wait for iCLK_period;
		iSTART <= '0';
		wait for 10 us;
		iSTART <= '1';
		wait for iCLK_period;
		iSTART <= '0';
		wait;
   end process;

END;
