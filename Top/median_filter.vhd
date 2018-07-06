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
           iRD_COUNT : in  STD_LOGIC_VECTOR (6 downto 0);
			  oWR_EN : out  STD_LOGIC;
			  oWR_MASK : out  STD_LOGIC_VECTOR (3 downto 0);
			  oWR_DATA : out  STD_LOGIC_VECTOR (31 downto 0);
			  iWR_FULL : in  STD_LOGIC;
			  iWR_EMPTY : in  STD_LOGIC;
			  iWR_COUNT : in  STD_LOGIC_VECTOR (6 downto 0);
			  oLOAD_IMAGE_DONE : out STD_LOGIC;
			  oDONE : out STD_LOGIC);
			  
end median_filter;

architecture Behavioral of median_filter is

	signal sCMD_PORT_STATE : STD_LOGIC;
	signal sWR_DONE, sWR_DONE_DELAY : STD_LOGIC;
	signal sWR_EN, sWR_EN_DELAY : STD_LOGIC;
	signal sWR_ADDR, sWR_ADDR_DELAY : STD_LOGIC_VECTOR (3 downto 0);
	signal sRGB_DATA_IN : STD_LOGIC_VECTOR (23 downto 0);
	signal sY_DATA_IN, sY_DATA_OUT : STD_LOGIC_VECTOR (7 downto 0);
	signal sUV_DATA : STD_LOGIC_VECTOR (15 downto 0);
	signal sREADY : STD_LOGIC;
	signal sRGB_DATA_OUT : STD_LOGIC_VECTOR (23 downto 0);
	signal sSORT_DATA_VALID, sCONV_DATA_VALID : STD_LOGIC;
	
	signal sRD_CMD_EN : STD_LOGIC;
	signal sRD_CMD_INSTR : STD_LOGIC_VECTOR (2 downto 0);
	signal sRD_CMD_BL : STD_LOGIC_VECTOR (5 downto 0);
	signal sRD_CMD_BYTE_ADDR : STD_LOGIC_VECTOR (29 downto 0);
	
	signal sWR_CMD_EN : STD_LOGIC;
	signal sWR_CMD_INSTR : STD_LOGIC_VECTOR (2 downto 0);
	signal sWR_CMD_BL : STD_LOGIC_VECTOR (5 downto 0);
	signal sWR_CMD_BYTE_ADDR : STD_LOGIC_VECTOR (29 downto 0);
	
	signal sRTOF_RESTART : STD_LOGIC;
	signal sRTOF_RESTARTED : STD_LOGIC;
	signal sFTOR_RESTART : STD_LOGIC;
	signal sFTOR_RESTARTED : STD_LOGIC;
	
	signal sUV_CONV_START : STD_LOGIC;
	signal sFILTER_DATA, sFILTER_DATA_REG : STD_LOGIC_VECTOR (23 downto 0);
	signal sFILTER_DATA_VALID, sFILTER_DATA_VALID_REG : STD_LOGIC;
	signal sDIRECT_WRITE : STD_LOGIC;
	signal sMODE_IN_EN : STD_LOGIC_VECTOR(1 downto 0);
	signal sMODE : STD_LOGIC_VECTOR (1 downto 0);
	
begin

	oCMD_EN <= sWR_CMD_EN when sCMD_PORT_STATE = '1'
		else sRD_CMD_EN;
		
	oCMD_INSTR <= sWR_CMD_INSTR when sCMD_PORT_STATE = '1'
		else sRD_CMD_INSTR;
		
	oCMD_BL <= sWR_CMD_BL when sCMD_PORT_STATE = '1'
		else sRD_CMD_BL;
		
	oCMD_BYTE_ADDR <= sWR_CMD_BYTE_ADDR when sCMD_PORT_STATE = '1'
		else sRD_CMD_BYTE_ADDR;

	sFILTER_DATA <= sRGB_DATA_IN when sMODE = "00"
		else sRGB_DATA_OUT; 
	
	sFILTER_DATA_VALID <= sDIRECT_WRITE when sMODE = "00"
		else sCONV_DATA_VALID;

	process(iCLK) begin
		if(iCLK'event and iCLK = '1') then
			if(sMODE_IN_EN = "11") then
				sMODE <= iMODE;
			end if;
		end if;
	end process;

	process(iCLK, iRST) begin
		if(iRST = '1') then
			sRTOF_RESTART <= '0';
		elsif(iCLK'event and iCLK = '1') then
			if(sRTOF_RESTARTED = '1') then
				sRTOF_RESTART <= '0';
			elsif(sMODE /= iMODE and sMODE_IN_EN = "11") then
				sRTOF_RESTART <= '1';
			end if;
		end if;
	end process;
	
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sFTOR_RESTART <= '0';
		elsif(iCLK'event and iCLK = '1') then
			if(sFTOR_RESTARTED = '1') then
				sFTOR_RESTART <= '0';
			elsif(sMODE /= iMODE and sMODE_IN_EN = "11") then
				sFTOR_RESTART <= '1';
			end if;
		end if;
	end process;

	r2f : entity work.ram_to_filter
	port map(
		iCLK => iCLK,
		iRST => iRST,
		iCMD_PORT_STATE => sCMD_PORT_STATE,
		iSTART => iSTART,
		iMODE => sMODE,
		iRESTART => sRTOF_RESTART,
		oRESTARTED => sRTOF_RESTARTED,
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
		iRD_COUNT => iRD_COUNT,
		oUV_CONV_START => sUV_CONV_START,
		oWR_EN => sWR_EN,
      oWR_ADDR => sWR_ADDR,
	   oWR_DATA => sRGB_DATA_IN,
		oWR_DONE => sWR_DONE,
		oDIRECT_WRITE_EN => sDIRECT_WRITE,
		oDONE => oLOAD_IMAGE_DONE,
		oMODE_IN_EN => sMODE_IN_EN(0)
	);
	
	conv1 : entity work.RGB_to_YUV
	port map
	(
		iCLK => iCLK,
		iRST => iRST,
		iUV_START => sUV_CONV_START,
		iUV_RESTART => '1',
		iWR_DONE => sWR_DONE,
		iWR_EN => sWR_EN,
		iWR_ADDR => sWR_ADDR,
		iRGB => sRGB_DATA_IN,
		oWR_EN => sWR_EN_DELAY,
      oWR_ADDR => sWR_ADDR_DELAY,
		oWR_DONE => sWR_DONE_DELAY,
		oY => sY_DATA_IN,
		oUV => sUV_DATA
	);
	
	sort_y : entity work.selection_sort
	port map
	(
		iCLK => iCLK,
		iRST => iRST,
		iWR_EN => sWR_EN_DELAY,
		iWR_ADDR => sWR_ADDR_DELAY,
		iWR_DATA => sY_DATA_IN,
		iSTART => sWR_DONE_DELAY,
		oDATA => sY_DATA_OUT,
		oDATA_VALID => sSORT_DATA_VALID,
		oREADY => sREADY
	);

	conv2 : entity work.YUV_to_RGB
	port map
	(
		iCLK => iCLK,
		iRST => iRST,
		iDATA_VALID => sSORT_DATA_VALID,
		iYUV => sY_DATA_OUT & sUV_DATA,
		oDATA_VALID => sCONV_DATA_VALID,
		oRGB => sRGB_DATA_OUT
	);
	
	f2r : entity work.filter_to_ram
	port map(
		iCLK => iCLK,
		iRST => iRST,
		iRESTART => sFTOR_RESTART,
		oRESTARTED => sFTOR_RESTARTED,
		oWR_CMD => sCMD_PORT_STATE,
		iDATA_VALID => sFILTER_DATA_VALID,
		iDATA => sFILTER_DATA,
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
		oMODE_IN_EN => sMODE_IN_EN(1)
	);

end Behavioral;

