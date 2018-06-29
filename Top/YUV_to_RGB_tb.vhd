--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:37:07 06/29/2018
-- Design Name:   
-- Module Name:   D:/Diplomski/Top/YUV_to_RGB_tb.vhd
-- Project Name:  Top
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: YUV_to_RGB
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
 
ENTITY YUV_to_RGB_tb IS
END YUV_to_RGB_tb;
 
ARCHITECTURE behavior OF YUV_to_RGB_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT YUV_to_RGB
    PORT(
         iCLK : IN  std_logic;
         iRST : IN  std_logic;
         iYUV : IN  std_logic_vector(23 downto 0);
         oRGB : OUT  std_logic_vector(23 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal iCLK : std_logic := '0';
   signal iRST : std_logic := '0';
   signal iYUV : std_logic_vector(23 downto 0) := (others => '0');

 	--Outputs
   signal oRGB : std_logic_vector(23 downto 0);

   -- Clock period definitions
   constant iCLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: YUV_to_RGB PORT MAP (
          iCLK => iCLK,
          iRST => iRST,
          iYUV => iYUV,
          oRGB => oRGB
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
		iYUV <= x"123456";
      wait for 100 ns;	
		iRST <= '0';
      wait for iCLK_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
