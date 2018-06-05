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
 
ENTITY median_filter_tb IS
END median_filter_tb;
 
ARCHITECTURE behavior OF median_filter_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT median_filter
    PORT(
         iCLK : IN  std_logic;
         inRST : IN  std_logic;
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
   signal inRST : std_logic := '0';
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
   uut: median_filter PORT MAP (
          iCLK => iCLK,
          inRST => inRST,
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
      inRST <= '0';
		iSTART <= '0';
      wait for 100 ns;	
		inRST <= '1';
		iWR_ADDR <= x"0";
		iWR_DATA <= x"11";
		iWR_EN <= '1';
      wait for iCLK_period;
		iWR_ADDR <= x"1";
		iWR_DATA <= x"02";
		wait for iCLK_period;
		iWR_ADDR <= x"2";
		iWR_DATA <= x"53";
		wait for iCLK_period;
		iWR_ADDR <= x"3";
		iWR_DATA <= x"04";
		wait for iCLK_period;
		iWR_ADDR <= x"4";
		iWR_DATA <= x"75";
		wait for iCLK_period;
		iWR_ADDR <= x"5";
		iWR_DATA <= x"06";
		wait for iCLK_period;
		iWR_ADDR <= x"6";
		iWR_DATA <= x"03";
		wait for iCLK_period;
		iWR_ADDR <= x"7";
		iWR_DATA <= x"08";
		wait for iCLK_period;
		iWR_ADDR <= x"8";
		iWR_DATA <= x"19";
		wait for iCLK_period;
		iWR_DATA <= x"01";
		iWR_EN <= '0';
      wait for iCLK_period*5;
		iSTART <= '1';
		wait for iCLK_period;
		iSTART <= '0';
		wait;
   end process;

END;
