----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:44:19 06/05/2018 
-- Design Name: 
-- Module Name:    median_filter - Behavioral 
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

entity median_filter is
    Port ( iCLK : in  STD_LOGIC;
           iRST : in  STD_LOGIC;
			  iSTART : in STD_LOGIC;
			  iMODE : in STD_LOGIC_VECTOR (1 downto 0);
			  oCMD_EN : out  STD_LOGIC;
           oCMD_INSTR : out  STD_LOGIC_VECTOR (2 downto 0);
           oCMD_BL : out  STD_LOGIC_VECTOR (5 downto 0);
           oCMD_BYTE_ADDR : out  STD_LOGIC_VECTOR (29 downto 0);
           iCMD_EMPTY : in  STD_LOGIC;
           iCMD_FULL : in  STD_LOGIC;
           oRD_EN : out  STD_LOGIC;
           iRD_DATA : in  STD_LOGIC_VECTOR (31 downto 0);
           iRD_FULL : in  STD_LOGIC;
           iRD_EMPTY : in  STD_LOGIC;
           iRD_OVERFLOW : in  STD_LOGIC;
           iRD_ERROR : in  STD_LOGIC;
           iRD_COUNT : in  STD_LOGIC_VECTOR (6 downto 0);
			  oWR_EN : out  STD_LOGIC;
			  oWR_MASK : out  STD_LOGIC_VECTOR (3 downto 0);
			  oWR_DATA : out  STD_LOGIC_VECTOR (31 downto 0);
			  iWR_FULL : in  STD_LOGIC;
			  iWR_EMPTY : in  STD_LOGIC;
			  iWR_COUNT : in  STD_LOGIC_VECTOR (6 downto 0);
			  iWR_UNDERRUN : in  STD_LOGIC;
			  iWR_ERROR : in  STD_LOGIC;
			  oDONE : out STD_LOGIC);
end median_filter;

architecture Behavioral of median_filter is

	signal sCMD_PORT_STATE : STD_LOGIC;
	signal sWR_DONE : STD_LOGIC;
	signal sWR_EN : STD_LOGIC;
	signal sWR_ADDR : STD_LOGIC_VECTOR (3 downto 0);
	signal sWR_DATA : STD_LOGIC_VECTOR (23 downto 0);
	signal sREADY_VECTOR : STD_LOGIC_VECTOR (2 downto 0);
	signal sREADY : STD_LOGIC;
	signal sREAD_DATA : STD_LOGIC_VECTOR (23 downto 0);
	signal sDATA_VALID : STD_LOGIC_VECTOR (2 downto 0);
	
	signal sRD_CMD_EN : STD_LOGIC;
	signal sRD_CMD_INSTR : STD_LOGIC_VECTOR (2 downto 0);
	signal sRD_CMD_BL : STD_LOGIC_VECTOR (5 downto 0);
	signal sRD_CMD_BYTE_ADDR : STD_LOGIC_VECTOR (29 downto 0);
	
	signal sWR_CMD_EN : STD_LOGIC;
	signal sWR_CMD_INSTR : STD_LOGIC_VECTOR (2 downto 0);
	signal sWR_CMD_BL : STD_LOGIC_VECTOR (5 downto 0);
	signal sWR_CMD_BYTE_ADDR : STD_LOGIC_VECTOR (29 downto 0);
	
begin

	sREADY <= sREADY_VECTOR(2) and sREADY_VECTOR(1) and sREADY_VECTOR(0);

	oCMD_EN <= sWR_CMD_EN when sCMD_PORT_STATE = '1'
		else sRD_CMD_EN;
		
	oCMD_INSTR <= sWR_CMD_INSTR when sCMD_PORT_STATE = '1'
		else sRD_CMD_INSTR;
		
	oCMD_BL <= sWR_CMD_BL when sCMD_PORT_STATE = '1'
		else sRD_CMD_BL;
		
	oCMD_BYTE_ADDR <= sWR_CMD_BYTE_ADDR when sCMD_PORT_STATE = '1'
		else sRD_CMD_BYTE_ADDR;

	r2f : entity work.ram_to_filter
	port map(
		iCLK => iCLK,
		iRST => iRST,
		iCMD_PORT_STATE => sCMD_PORT_STATE,
		iSTART => iSTART,
		iMODE => iMODE,
		iREADY_WR => sREADY,
		oCMD_EN => sRD_CMD_EN,
		oCMD_INSTR => sRD_CMD_INSTR,
		oCMD_BL => sRD_CMD_BL,
		oCMD_BYTE_ADDR => sRD_CMD_BYTE_ADDR,
		iCMD_EMPTY => iCMD_EMPTY,
		iCMD_FULL => iCMD_FULL,
		oRD_EN => oRD_EN,
		iRD_DATA => iRD_DATA,
		iRD_FULL => iRD_FULL,
		iRD_EMPTY => iRD_EMPTY,
		iRD_OVERFLOW => iRD_OVERFLOW,
		iRD_ERROR => iRD_ERROR,
		iRD_COUNT => iRD_COUNT,
		oWR_EN => sWR_EN,
      oWR_ADDR => sWR_ADDR,
	   oWR_DATA => sWR_DATA,
		oDONE => sWR_DONE
	);
	
	sort_red : entity work.selection_sort
	port map
	(
		iCLK => iCLK,
		iRST => iRST,
		iWR_EN => sWR_EN,
		iWR_ADDR => sWR_ADDR,
		iWR_DATA => sWR_DATA(23 downto 16),
		iSTART => sWR_DONE,
		oDATA => sREAD_DATA(23 downto 16),
		oDATA_VALID => sDATA_VALID(2),
		oREADY => sREADY_VECTOR(2)
	);

	sort_green : entity work.selection_sort
	port map
	(
		iCLK => iCLK,
		iRST => iRST,
		iWR_EN => sWR_EN,
		iWR_ADDR => sWR_ADDR,
		iWR_DATA => sWR_DATA(15 downto 8),
		iSTART => sWR_DONE,
		oDATA => sREAD_DATA(15 downto 8),
		oDATA_VALID => sDATA_VALID(1),
		oREADY => sREADY_VECTOR(1)
	);
	
	sort_blue : entity work.selection_sort
	port map
	(
		iCLK => iCLK,
		iRST => iRST,
		iWR_EN => sWR_EN,
		iWR_ADDR => sWR_ADDR,
		iWR_DATA => sWR_DATA(7 downto 0),
		iSTART => sWR_DONE,
		oDATA => sREAD_DATA(7 downto 0),
		oDATA_VALID => sDATA_VALID(0),
		oREADY => sREADY_VECTOR(0)
	);

	f2r : entity work.filter_to_ram
	port map(
		iCLK => iCLK,
		iRST => iRST,
		oWR_CMD => sCMD_PORT_STATE,
		iDATA_VALID => sDATA_VALID,
		iDATA => sREAD_DATA,
		oDONE => oDONE,
		oCMD_EN => sWR_CMD_EN,
		oCMD_INSTR => sWR_CMD_INSTR,
		oCMD_BL => sWR_CMD_BL,
		oCMD_BYTE_ADDR => sWR_CMD_BYTE_ADDR,
		iCMD_EMPTY => iCMD_EMPTY,
		iCMD_FULL => iCMD_FULL,
		oWR_EN => oWR_EN,
		oWR_MASK => oWR_MASK,
		oWR_DATA => oWR_DATA,
		iWR_FULL => iWR_FULL,
		iWR_EMPTY => iWR_EMPTY,
		iWR_COUNT => iWR_COUNT,
		iWR_UNDERRUN => iWR_UNDERRUN,
		iWR_ERROR => iWR_ERROR
	);

end Behavioral;

