--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:49:34 06/29/2018
-- Design Name:   
-- Module Name:   D:/Diplomski/Top/calculate_chroma_tb.vhd
-- Project Name:  Top
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: calculate_chroma
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
 
ENTITY calculate_chroma_tb IS
END calculate_chroma_tb;
 
ARCHITECTURE behavior OF calculate_chroma_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT calculate_chroma
    PORT(
         iCLK : IN  std_logic;
         iRST : IN  std_logic;
         iSTART : IN  std_logic;
         iRESTART : IN  std_logic;
         iRGB : IN  std_logic_vector(23 downto 0);
         oUV : OUT  std_logic_vector(15 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal iCLK : std_logic := '0';
   signal iRST : std_logic := '0';
   signal iSTART : std_logic := '0';
   signal iRESTART : std_logic := '0';
   signal iRGB : std_logic_vector(23 downto 0) := (others => '0');

 	--Outputs
   signal oUV : std_logic_vector(15 downto 0);

   -- Clock period definitions
   constant iCLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: calculate_chroma PORT MAP (
          iCLK => iCLK,
          iRST => iRST,
          iSTART => iSTART,
          iRESTART => iRESTART,
          iRGB => iRGB,
          oUV => oUV
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
      iRGB <= x"A3A3A3";
		iRST <= '1';
      wait for 100 ns;	
		iRST <= '0';
      wait for iCLK_period*10;
		iSTART <= '1';
		wait for iCLK_period;
		iSTART <= '0';
      -- insert stimulus here 

      wait;
   end process;

END;
