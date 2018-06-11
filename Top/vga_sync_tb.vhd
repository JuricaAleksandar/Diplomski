--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:05:07 04/13/2018
-- Design Name:   
-- Module Name:   D:/BScRad/vgaSync_tb.vhd
-- Project Name:  BScRad
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: vgaSync
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
 
ENTITY vga_sync_tb IS
END vga_sync_tb;
 
ARCHITECTURE behavior OF vga_sync_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT vga_sync
    PORT(
         iCLK : IN  std_logic;
         inRST : IN  std_logic;
         oPIXEL_X : OUT  std_logic_vector(10 downto 0);
         oPIXEL_Y : OUT  std_logic_vector(10 downto 0);
         oVIDEO_ON : OUT  std_logic;
         oH_SYNC : OUT  std_logic;
         oV_SYNC : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal iCLK : std_logic := '0';
   signal inRST : std_logic := '0';

 	--Outputs
   signal oPIXEL_X : std_logic_vector(10 downto 0);
   signal oPIXEL_Y : std_logic_vector(10 downto 0);
   signal oVIDEO_ON : std_logic;
   signal oH_SYNC : std_logic;
   signal oV_SYNC : std_logic;

   -- Clock period definitions
   constant iCLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: vga_sync PORT MAP (
          iCLK => iCLK,
          inRST => inRST,
          oPIXEL_X => oPIXEL_X,
          oPIXEL_Y => oPIXEL_Y,
          oVIDEO_ON => oVIDEO_ON,
          oH_SYNC => oH_SYNC,
          oV_SYNC => oV_SYNC
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
      wait for 100 ns;
		inRST <= '1';
      wait;
   end process;

END;
