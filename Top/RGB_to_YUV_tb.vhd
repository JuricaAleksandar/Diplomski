--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:47:59 06/28/2018
-- Design Name:   
-- Module Name:   D:/Diplomski/Top/RGB_to_YUV_tb.vhd
-- Project Name:  Top
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: RGB_to_YUV
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
 
ENTITY RGB_to_YUV_tb IS
END RGB_to_YUV_tb;
 
ARCHITECTURE behavior OF RGB_to_YUV_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT RGB_to_YUV
    PORT(
         iCLK : IN  std_logic;
         iRST : IN  std_logic;
         iWR_DONE : IN  std_logic;
         iWR_EN : IN  std_logic;
         iWR_ADDR : IN  std_logic_vector(3 downto 0);
         iRGB : IN  std_logic_vector(23 downto 0);
         oWR_DONE : OUT  std_logic;
         oWR_EN : OUT  std_logic;
         oWR_ADDR : OUT  std_logic_vector(3 downto 0);
         oYUV : OUT  std_logic_vector(23 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal iCLK : std_logic := '0';
   signal iRST : std_logic := '0';
   signal iWR_DONE : std_logic := '0';
   signal iWR_EN : std_logic := '0';
   signal iWR_ADDR : std_logic_vector(3 downto 0) := (others => '0');
   signal iRGB : std_logic_vector(23 downto 0) := (others => '0');

 	--Outputs
   signal oWR_DONE : std_logic;
   signal oWR_EN : std_logic;
   signal oWR_ADDR : std_logic_vector(3 downto 0);
   signal oYUV : std_logic_vector(23 downto 0);

   -- Clock period definitions
   constant iCLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RGB_to_YUV PORT MAP (
          iCLK => iCLK,
          iRST => iRST,
          iWR_DONE => iWR_DONE,
          iWR_EN => iWR_EN,
          iWR_ADDR => iWR_ADDR,
          iRGB => iRGB,
          oWR_DONE => oWR_DONE,
          oWR_EN => oWR_EN,
          oWR_ADDR => oWR_ADDR,
          oYUV => oYUV
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
      wait for 105 ns;		
		iRST <= '0';
		wait for 100 ns;
		iWR_EN <= '1';
		iRGB <= x"A0A0A0";
		iWR_ADDR <= x"0";
      wait for iCLK_period;
		iRGB <= x"A3A3A3";
		iWR_ADDR <= x"1";
      wait for iCLK_period;
		iRGB <= x"A0A0A0";
		iWR_ADDR <= x"2";
      wait for iCLK_period;
		iRGB <= x"A3A3A3";
		iWR_ADDR <= x"3";
      wait for iCLK_period;
		iRGB <= x"A0A0A0";
		iWR_ADDR <= x"4";
      wait for iCLK_period;
		iRGB <= x"A3A3A3";
		iWR_ADDR <= x"5";
      wait for iCLK_period;
		iRGB <= x"A0A0A0";
		iWR_ADDR <= x"6";
      wait for iCLK_period;
		iRGB <= x"A3A3A3";
		iWR_ADDR <= x"7";
      wait for iCLK_period;
		iRGB <= x"A0A0A0";
		iWR_ADDR <= x"8";
      wait for iCLK_period;
		iWR_EN <= '0';
		iWR_DONE <= '1';
		wait for iCLK_period;
		iWR_DONE <= '0';
      -- insert stimulus here 

      wait;
   end process;

END;
