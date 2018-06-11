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
 
ENTITY spi_flash_controller_tb IS
END spi_flash_controller_tb;
 
ARCHITECTURE behavior OF spi_flash_controller_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT spi_flash_controller
    PORT(
         iCLK : IN  std_logic;
         inRST : IN  std_logic;
			iRD_EN : in STD_LOGIC;
			iRD_START : in STD_LOGIC;
			iRD_ADDR : in STD_LOGIC_VECTOR (23 downto 0);
			iRD_COUNT : in STD_LOGIC_VECTOR (7 downto 0);
			oDATA_VALID : out STD_LOGIC;
			oDATA : out STD_LOGIC_VECTOR (7 downto 0);
			oREADY : out STD_LOGIC;
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
	signal iRD_EN : STD_LOGIC;
	signal iRD_START : STD_LOGIC;
	signal iRD_ADDR : STD_LOGIC_VECTOR (23 downto 0);
	signal iRD_COUNT : STD_LOGIC_VECTOR (7 downto 0);
	
	--BiDirs
   signal ioSIO : std_logic_vector(3 downto 0);

 	--Outputs
   signal oSCLK : std_logic;
   signal onCS : std_logic;
   signal onRESET : std_logic;
	signal oDATA_VALID : STD_LOGIC;
	signal oDATA : STD_LOGIC_VECTOR (7 downto 0);
	signal oREADY : STD_LOGIC;
	
   -- Clock period definitions
   constant iCLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: spi_flash_controller PORT MAP (
          iCLK => iCLK,
          inRST => inRST,
			 iRD_EN => iRD_EN,
			 iRD_START => iRD_START,
			 iRD_ADDR => iRD_ADDR,
			 iRD_COUNT => iRD_COUNT,
			 oREADY => oREADY,
			 oDATA_VALID => oDATA_VALID,
			 oDATA => oDATA,
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
		iRD_EN <= '0';
		iRD_START <= '0';
		iRD_ADDR <= (others => '0');
		iRD_COUNT <= (others => '0');
      inRST <= '0';
      wait for 300 us;	
		inRST <= '1';
		wait for 20 us;
		iRD_START <= '1';
		iRD_ADDR <= (others => '0');
		iRD_COUNT <= (6 downto 5 => '1', others => '0');
		wait for iCLK_period;
		iRD_ADDR <= (others => '0');
		iRD_COUNT <= (others => '0');
		iRD_START <= '0';
		iRD_EN <= '1';
      wait;
   end process;

END;
