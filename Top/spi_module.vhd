----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:40:02 07/13/2018 
-- Design Name: 
-- Module Name:    spi_module - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity spi_module is
	Port ( iCLK : in  STD_LOGIC;
           iRST : in  STD_LOGIC;
			  iIMAGE_SELECT : in STD_LOGIC_VECTOR (2 downto 0);
			  oCLK : out STD_LOGIC;
           oSCLK : out  STD_LOGIC;
           onCS : out  STD_LOGIC;
           ioSIO : inout  STD_LOGIC_VECTOR (3 downto 0);
           onRESET : out  STD_LOGIC;
			  iCALIB_DONE : in STD_LOGIC;
			  oDONE : out STD_LOGIC;
           oCMD_EN : out  STD_LOGIC;
           oCMD_INSTR : out  STD_LOGIC_VECTOR (2 downto 0);
           oCMD_BL : out  STD_LOGIC_VECTOR (5 downto 0);
           oCMD_BYTE_ADDR : out  STD_LOGIC_VECTOR (29 downto 0);
           oWR_EN : out  STD_LOGIC;
           oWR_MASK : out  STD_LOGIC_VECTOR (3 downto 0);
           oWR_DATA : out  STD_LOGIC_VECTOR (31 downto 0));
end spi_module;

architecture Behavioral of spi_module is

	signal sFLASH_RD_START : STD_LOGIC;
	signal sFLASH_RD_ADDR : STD_LOGIC_VECTOR (23 downto 0);
	signal sFLASH_READY : STD_LOGIC;
	signal sFLASH_DATA_VALID : STD_LOGIC;
	signal sFLASH_DATA : STD_LOGIC_VECTOR (7 downto 0);
	signal sCLK, sLOCKED : STD_LOGIC;

begin

	spi_module_clk : entity work.spi_clock_50mhz
	port map(
		CLK_IN1 => iCLK,
		CLK_OUT1 => sCLK,
		RESET => iRST,
		LOCKED => sLOCKED
	);

	sfc : entity work.spi_flash_controller
	port map(
		iCLK => sCLK,
		inRST => sLOCKED,
		iRD_START => sFLASH_RD_START,
		iRD_ADDR => sFLASH_RD_ADDR,
		oREADY => sFLASH_READY,
		oDATA_VALID => sFLASH_DATA_VALID,
		oDATA => sFLASH_DATA,
		oSCLK => oSCLK,
		onCS => onCS,
		ioSIO => ioSIO,
		onRESET => onRESET
	);

	f2r : entity work.flash_to_ram
	port map(
		iCLK => sCLK,
		inRST => sLOCKED,
		iIMAGE_SELECT => iIMAGE_SELECT,
		iCALIB_DONE => iCALIB_DONE,
		iREADY => sFLASH_READY,
		iDATA_VALID => sFLASH_DATA_VALID,
		iDATA => sFLASH_DATA,
		oRD_START => sFLASH_RD_START,
		oRD_ADDR => sFLASH_RD_ADDR,
		oDONE => oDONE,
		oCMD_EN => oCMD_EN,
		oCMD_INSTR => oCMD_INSTR,
		oCMD_BL => oCMD_BL,
		oCMD_BYTE_ADDR => oCMD_BYTE_ADDR,
		oWR_EN => oWR_EN,
		oWR_MASK => oWR_MASK,
		oWR_DATA => oWR_DATA
	);

	oCLK <= sCLK;

end Behavioral;

