--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:35:32 05/25/2018
-- Design Name:   
-- Module Name:   D:/Diplomski/Top/flash2RAM_tb.vhd
-- Project Name:  Top
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: flash2RAM
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
 
ENTITY flash_to_ram_tb IS
END flash_to_ram_tb;
 
ARCHITECTURE behavior OF flash_to_ram_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT flash_to_ram
    PORT(
         iCLK : IN  std_logic;
         inRST : IN  std_logic;
         iREADY : IN  std_logic;
			iIMAGE_SELECT : IN std_logic_vector(2 downto 0);
			iCALIB_DONE : IN std_logic;
         iDATA_VALID : IN  std_logic;
         iDATA : IN  std_logic_vector(7 downto 0);
         oRD_START : OUT  std_logic;
         oRD_ADDR : OUT  std_logic_vector(23 downto 0);
         oDONE : OUT  std_logic;
         oCMD_EN : OUT  std_logic;
         oCMD_INSTR : OUT  std_logic_vector(2 downto 0);
         oCMD_BL : OUT  std_logic_vector(5 downto 0);
         oCMD_BYTE_ADDR : OUT  std_logic_vector(29 downto 0);
         oWR_EN : OUT  std_logic;
         oWR_MASK : OUT  std_logic_vector(3 downto 0);
         oWR_DATA : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    
	 COMPONENT spi_flash_controller
    PORT(
         iCLK : IN  std_logic;
         inRST : IN  std_logic;
			iRD_START : in STD_LOGIC;
			iRD_ADDR : in STD_LOGIC_VECTOR (23 downto 0);
			oDATA_VALID : out STD_LOGIC;
			oDATA : out STD_LOGIC_VECTOR (7 downto 0);
			oREADY : out STD_LOGIC;
         oSCLK : OUT  std_logic;
         onCS : OUT  std_logic;
         ioSIO : INOUT  std_logic_vector(3 downto 0);
         onRESET : OUT  std_logic
        );
    END COMPONENT;
    
	 COMPONENT MX25L25635E
	 PORT(
			SCLK : in STD_LOGIC;
		    CS : in STD_LOGIC;
		    SI : inout STD_LOGIC; 
		    SO : inout STD_LOGIC; 
		    WP : inout STD_LOGIC;
		    HOLD : inout STD_LOGIC;
		    RESET : inout STD_LOGIC
			);
	 END COMPONENT;

	signal ioSIO : std_logic_vector(3 downto 0);

 	--Outputs
   signal oSCLK : std_logic;
   signal onCS : std_logic;
   signal onRESET : std_logic;

   --Inputs
   signal iCLK : std_logic := '0';
   signal inRST : std_logic := '0';
	signal iCALIB_DONE : std_logic := '0';
   signal iREADY : std_logic := '0';
   signal iDATA_VALID : std_logic := '0';
   signal iDATA : std_logic_vector(7 downto 0) := (others => '0');
   signal iCMD_EMPTY : std_logic := '0';
   signal iCMD_FULL : std_logic := '0';
   signal iWR_FULL : std_logic := '0';
   signal iWR_EMPTY : std_logic := '0';
   signal iWR_COUNT : std_logic_vector(6 downto 0) := (others => '0');
   signal iWR_UNDERRUN : std_logic := '0';
   signal iWR_ERROR : std_logic := '0';
	signal iIMAGE_SELECT : std_logic_vector(2 downto 0);
	
 	--Outputs
   signal oRD_START : std_logic;
   signal oRD_ADDR : std_logic_vector(23 downto 0);
   signal oRD_COUNT : std_logic_vector(7 downto 0);
   signal oDONE : std_logic;
   signal oCMD_EN : std_logic;
   signal oCMD_INSTR : std_logic_vector(2 downto 0);
   signal oCMD_BL : std_logic_vector(5 downto 0);
   signal oCMD_BYTE_ADDR : std_logic_vector(29 downto 0);
   signal oWR_EN : std_logic;
   signal oWR_MASK : std_logic_vector(3 downto 0);
   signal oWR_DATA : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant iCLK_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: flash_to_ram PORT MAP (
          iCLK => iCLK,
          inRST => inRST,
          iREADY => iREADY,
			 iIMAGE_SELECT => iIMAGE_SELECT,
			 iCALIB_DONE => iCALIB_DONE,
          iDATA_VALID => iDATA_VALID,
          iDATA => iDATA,
          oRD_START => oRD_START,
          oRD_ADDR => oRD_ADDR,
          oDONE => oDONE,
          oCMD_EN => oCMD_EN,
          oCMD_INSTR => oCMD_INSTR,
          oCMD_BL => oCMD_BL,
          oCMD_BYTE_ADDR => oCMD_BYTE_ADDR,
          oWR_EN => oWR_EN,
          oWR_MASK => oWR_MASK,
          oWR_DATA => oWR_DATA
        );
	
	spi: spi_flash_controller PORT MAP (
          iCLK => iCLK,
          inRST => inRST,
			 iRD_START => oRD_START,
			 iRD_ADDR => oRD_ADDR,
			 oREADY => iREADY,
			 oDATA_VALID => iDATA_VALID,
			 oDATA => iDATA,
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
		iIMAGE_SELECT <= "000";
      inRST <= '0';
		iCALIB_DONE <= '1';
      wait for 300 us;	
		inRST <= '1';
		wait until oDONE = '1';
		wait for 2*iCLK_period;
		inRST <= '0';
		wait for 2*iCLK_period;
		inRST <= '1';
		wait;
   end process;

END;
