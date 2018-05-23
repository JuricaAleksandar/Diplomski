--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:13:00 05/18/2018
-- Design Name:   
-- Module Name:   D:/Diplomski/Top/spiFlashController_tb.vhd
-- Project Name:  Top
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: spiFlashController
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
 
ENTITY spiFlashController_tb IS
END spiFlashController_tb;
 
ARCHITECTURE behavior OF spiFlashController_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT spiFlashController
    PORT(
         iCLK : IN  std_logic;
         inRST : IN  std_logic;
         oSCLK : OUT  std_logic;
         onCS : OUT  std_logic;
         ioSIO : INOUT  std_logic_vector(3 downto 0);
         onRESET : OUT  std_logic
        );
    END COMPONENT;
    
	 component MX25L25635E
	 port(
			SCLK : in STD_LOGIC;
		    CS : in STD_LOGIC;
		    SI : inout STD_LOGIC; 
		    SO : inout STD_LOGIC; 
		    WP : inout STD_LOGIC;
		    HOLD : inout STD_LOGIC;
		    RESET : inout STD_LOGIC
			);
	 end component;

   --Inputs
   signal iCLK : std_logic := '0';
   signal inRST : std_logic := '0';

	--BiDirs
   signal ioSIO : std_logic_vector(3 downto 0);

 	--Outputs
   signal oSCLK : std_logic;
   signal onCS : std_logic;
   signal onRESET : std_logic;

   -- Clock period definitions
   constant iCLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: spiFlashController PORT MAP (
          iCLK => iCLK,
          inRST => inRST,
          oSCLK => oSCLK,
          onCS => onCS,
          ioSIO => ioSIO,
          onRESET => onRESET
        );
	
	flashMem : MX25L25635E
	port map
	(
		SCLK => oSCLK,
		CS => onCS,
		RESET => onRESET,
		SI => ioSIO(0),
		SO => ioSIO(1),
		WP => ioSIO(2),
		HOLD => ioSIO(3)
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
      wait for 300 us;	
		inRST <= '1';

      wait;
   end process;

END;
