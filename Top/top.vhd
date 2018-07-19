----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:48:43 04/27/2018 
-- Design Name: 
-- Module Name:    memCntrlTop - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity top is
    Port ( iCLK_DIFF_P : in  STD_LOGIC;
           iCLK_DIFF_N : in  STD_LOGIC;
			  iCLK : in STD_LOGIC;
           inRST : in  STD_LOGIC;
			  onRAM_CS : out STD_LOGIC;
			  onRAM_WE : out STD_LOGIC;
			  onRAM_CAS : out STD_LOGIC;
			  onRAM_RAS : out STD_LOGIC;
			  onRAM_CLK : out STD_LOGIC;
			  oRAM_CLK : out STD_LOGIC;
			  oRAM_CKE : out STD_LOGIC;
			  oRAM_ODT : out STD_LOGIC;
			  oRAM_UDM : out STD_LOGIC;
			  oRAM_LDM : out STD_LOGIC;
			  oRAM_BADDR : out STD_LOGIC_VECTOR (2 downto 0);
			  oRAM_ADDR : out STD_LOGIC_VECTOR (13 downto 0);
			  ioRAM_UDQS : inout STD_LOGIC;
			  ionRAM_UDQS : inout STD_LOGIC;
			  ioRAM_LDQS : inout STD_LOGIC;
			  ionRAM_LDQS : inout STD_LOGIC;
			  ioRAM_DQ : inout STD_LOGIC_VECTOR (15 downto 0);
			  ioRZQ : inout STD_LOGIC;
			  ioZIO : inout STD_LOGIC;
		     onBLANK : out STD_LOGIC;
			  onSYNC : out STD_LOGIC;
			  onPSAVE : out STD_LOGIC;
		     oH_SYNC : out STD_LOGIC;
			  oV_SYNC : out STD_LOGIC;
			  oRGB : out STD_LOGIC_VECTOR (23 downto 0);
			  oVGA_CLK : out STD_LOGIC;
			  oSCLK : out  STD_LOGIC;
			  onCS : out  STD_LOGIC;
           ioSIO : inout  STD_LOGIC_VECTOR (3 downto 0);
           onRESET : out  STD_LOGIC;
			  iFILTER_MODE : in STD_LOGIC_VECTOR (1 downto 0);
			  iIMAGE_SELECT : in STD_LOGIC_VECTOR (2 downto 0);
			  iSPLIT_SCREEN : in STD_LOGIC;
			  iDELAY_ON : in STD_LOGIC;
			  oLCD_L : out STD_LOGIC;
			  oLCD_RS : out STD_LOGIC;
			  oLCD_RW : out STD_LOGIC;
			  oLCD_EN : out STD_LOGIC;
			  oLCD_DATA : out STD_LOGIC_VECTOR (3 downto 0);
			  oLED : out STD_LOGIC_VECTOR (5 downto 0));
end top;

architecture Behavioral of top is
	
	signal sINV_RST : STD_LOGIC;
	signal sCLK : STD_LOGIC;
	signal sRST : STD_LOGIC;
	signal sCALIB_DONE : STD_LOGIC;
	
	--- Port 1 command signals ---
	signal sP1_CMD_CLK : STD_LOGIC;
	signal sP1_CMD_EN : STD_LOGIC;
	signal sP1_CMD_INSTR : STD_LOGIC_VECTOR (2 downto 0);
	signal sP1_CMD_BL : STD_LOGIC_VECTOR (5 downto 0);
	signal sP1_CMD_BYTE_ADDR : STD_LOGIC_VECTOR (29 downto 0);
	signal sP1_CMD_FULL : STD_LOGIC;
	
	--- Port 1 write signals ---
	signal sP1_WR_CLK : STD_LOGIC;
	signal sP1_WR_EN : STD_LOGIC;
	signal sP1_WR_MASK : STD_LOGIC_VECTOR (3 downto 0);
	signal sP1_WR_DATA : STD_LOGIC_VECTOR (31 downto 0);
	signal sP1_WR_COUNT : STD_LOGIC_VECTOR (6 downto 0);
	
	--- Port 1 read signals ---
	signal sP1_RD_CLK : STD_LOGIC;
	signal sP1_RD_EN : STD_LOGIC;
	signal sP1_RD_DATA : STD_LOGIC_VECTOR (31 downto 0);
	signal sP1_RD_COUNT : STD_LOGIC_VECTOR (6 downto 0);
	
	--- Port 2 command signals ---
	signal sP2_CMD_CLK : STD_LOGIC;
	signal sP2_CMD_EN : STD_LOGIC;
	signal sP2_CMD_INSTR : STD_LOGIC_VECTOR (2 downto 0);
	signal sP2_CMD_BL : STD_LOGIC_VECTOR (5 downto 0);
	signal sP2_CMD_BYTE_ADDR : STD_LOGIC_VECTOR (29 downto 0);
	
	--- Port 2 write signals ---
	signal sP2_WR_CLK : STD_LOGIC;
	signal sP2_WR_EN : STD_LOGIC;
	signal sP2_WR_MASK : STD_LOGIC_VECTOR (3 downto 0);
	signal sP2_WR_DATA : STD_LOGIC_VECTOR (31 downto 0);
	
	--- Port 3 command signals ---
	signal sP3_CMD_CLK : STD_LOGIC;
	signal sP3_CMD_EN : STD_LOGIC;
	signal sP3_CMD_INSTR : STD_LOGIC_VECTOR (2 downto 0);
	signal sP3_CMD_BL : STD_LOGIC_VECTOR (5 downto 0);
	signal sP3_CMD_BYTE_ADDR : STD_LOGIC_VECTOR (29 downto 0);
	signal sP3_CMD_FULL : STD_LOGIC;
	
	--- Port 3 read signals ---
	signal sP3_RD_CLK : STD_LOGIC;
	signal sP3_RD_EN : STD_LOGIC;
	signal sP3_RD_DATA : STD_LOGIC_VECTOR (31 downto 0);
	signal sP3_RD_EMPTY : STD_LOGIC;
	signal sP3_RD_COUNT : STD_LOGIC_VECTOR (6 downto 0);

	signal sLOCKED : STD_LOGIC;
	signal sVGA_CLK : STD_LOGIC;
	signal snVGA_CLK : STD_LOGIC;
	
	signal sPIXEL_Y, sPIXEL_X : STD_LOGIC_VECTOR(10 downto 0);
	signal sVIDEO_ON, sVIDEO_ON_DELAY, sH_SYNC, sV_SYNC : STD_LOGIC;
	
	signal sFLASH_CLK : STD_LOGIC;
	signal sFLASH_DONE : STD_LOGIC;
	signal sFILTER_DONE : STD_LOGIC;
	signal sSTART : STD_LOGIC;
	
	signal sFILTER_DONE_REG : STD_LOGIC;
	signal sBLANK : STD_LOGIC;
	signal sSPLIT_SCREEN_REG : STD_LOGIC;
	
	signal sFILTER_READ_DONE : STD_LOGIC;
	signal sFILTER_MODE : STD_LOGIC_VECTOR (1 downto 0);
	signal sSPLIT_SCREEN : STD_LOGIC;
	signal sDELAY_ON : STD_LOGIC;
	signal sIMAGE_SELECT : STD_LOGIC_VECTOR (2 downto 0);
	
begin
	
	oLED <= '0' & sFILTER_DONE_REG & sFILTER_DONE & sFILTER_READ_DONE & sFLASH_DONE & sCALIB_DONE;
	
	sw_db : entity work.switch_debouncer
	port map
	(
		iCLK => sCLK,
		iRST => sRST,
		iMODE => iFILTER_MODE,
		iIMAGE_SELECT => iIMAGE_SELECT,
		iSPLIT_SCREEN => iSPLIT_SCREEN,
		iDELAY_ON => iDELAY_ON,
		oMODE => sFILTER_MODE,
		oIMAGE_SELECT => sIMAGE_SELECT,
		oSPLIT_SCREEN => sSPLIT_SCREEN,
		oDELAY_ON => sDELAY_ON
	);
	
	lcd : entity work.lcd_controller
   port map
	(
		iCLK => sCLK,
		iRST => sRST,
		iMODE => sFILTER_MODE,
		iSPLIT_SCREEN => sSPLIT_SCREEN,
		oRS => oLCD_RS,
		oRW => oLCD_RW,
		oEN => oLCD_EN,
		oL => oLCD_L,
		oDATA => oLCD_DATA
	);
	
	imcb : entity work.memControllerBlock
	generic map(
			C3_SIMULATION => "TRUE"
	)
	port map(
		c3_sys_clk_p  					=>  iCLK_DIFF_P,
		c3_sys_clk_n    				=>  iCLK_DIFF_N,
		c3_sys_rst_i    				=>  sINV_RST,                        
		c3_clk0							=>  sCLK,
		c3_rst0							=>  sRST,
		c3_calib_done      			=>  sCALIB_DONE,
		mcb3_rzq        				=>  ioRZQ,
		mcb3_zio        				=>  ioZIO,
	
		mcb3_dram_dq       			=>  ioRAM_DQ,  
		mcb3_dram_a        			=>  oRAM_ADDR,  
		mcb3_dram_ba      			=>  oRAM_BADDR,
		mcb3_dram_ras_n   			=>  onRAM_RAS,                        
		mcb3_dram_cas_n  				=>  onRAM_CAS,                        
		mcb3_dram_we_n    			=>  onRAM_WE,                          
		mcb3_dram_odt   				=>  oRAM_ODT,
		mcb3_dram_cke     			=>  oRAM_CKE,                          
		mcb3_dram_ck      			=>  oRAM_CLK,                          
		mcb3_dram_ck_n    			=>  onRAM_CLK,       
		mcb3_dram_dqs     			=>  ioRAM_LDQS,                          
		mcb3_dram_dqs_n 				=>  ionRAM_LDQS,
		mcb3_dram_udqs 				=>  ioRAM_UDQS,            
		mcb3_dram_udqs_n   			=>  ionRAM_UDQS,  
		mcb3_dram_udm 					=>  oRAM_UDM,     
		mcb3_dram_dm 					=>  oRAM_LDM,
		
		c3_p1_cmd_clk              =>  sP1_CMD_CLK,
		c3_p1_cmd_en               =>  sP1_CMD_EN,
		c3_p1_cmd_instr            =>  sP1_CMD_INSTR,
		c3_p1_cmd_bl               =>  sP1_CMD_BL,
		c3_p1_cmd_byte_addr        =>  sP1_CMD_BYTE_ADDR,
		c3_p1_cmd_empty            =>  open,
		c3_p1_cmd_full             =>  sP1_CMD_FULL,
		
		c3_p1_wr_clk               =>  sP1_WR_CLK,
		c3_p1_wr_en                =>  sP1_WR_EN,
		c3_p1_wr_mask              =>  sP1_WR_MASK,
		c3_p1_wr_data              =>  sP1_WR_DATA,
		c3_p1_wr_full              =>  open,
		c3_p1_wr_empty             =>  open,
		c3_p1_wr_count             =>  sP1_WR_COUNT,
		c3_p1_wr_underrun          =>  open,
		c3_p1_wr_error             =>  open,
		
		c3_p1_rd_clk               =>  sP1_RD_CLK,
		c3_p1_rd_en                =>  sP1_RD_EN,
		c3_p1_rd_data              =>  sP1_RD_DATA,
		c3_p1_rd_full              =>  open,
		c3_p1_rd_empty             =>  open,
		c3_p1_rd_count             =>  sP1_RD_COUNT,
		c3_p1_rd_overflow          =>  open,
		c3_p1_rd_error             =>  open,
		
		c3_p2_cmd_clk              =>  sP2_CMD_CLK,
		c3_p2_cmd_en               =>  sP2_CMD_EN,
		c3_p2_cmd_instr            =>  sP2_CMD_INSTR,
		c3_p2_cmd_bl               =>  sP2_CMD_BL,
		c3_p2_cmd_byte_addr        =>  sP2_CMD_BYTE_ADDR,
		c3_p2_cmd_empty            =>  open,
		c3_p2_cmd_full             =>  open,
		
		c3_p2_wr_clk               =>  sP2_WR_CLK,
		c3_p2_wr_en                =>  sP2_WR_EN,
		c3_p2_wr_mask              =>  sP2_WR_MASK,
		c3_p2_wr_data              =>  sP2_WR_DATA,
		c3_p2_wr_full              =>  open,
		c3_p2_wr_empty             =>  open,
		c3_p2_wr_count             =>  open,
		c3_p2_wr_underrun          =>  open,
		c3_p2_wr_error             =>  open,
		
		c3_p3_cmd_clk              =>  sP3_CMD_CLK,
		c3_p3_cmd_en               =>  sP3_CMD_EN,
		c3_p3_cmd_instr            =>  sP3_CMD_INSTR,
		c3_p3_cmd_bl               =>  sP3_CMD_BL,
		c3_p3_cmd_byte_addr        =>  sP3_CMD_BYTE_ADDR,
		c3_p3_cmd_empty            =>  open,
		c3_p3_cmd_full             =>  sP3_CMD_FULL,
		
		c3_p3_rd_clk               =>  sP3_RD_CLK,
		c3_p3_rd_en                =>  sP3_RD_EN,
		c3_p3_rd_data              =>  sP3_RD_DATA,
		c3_p3_rd_full              =>  open,
		c3_p3_rd_empty             =>  sP3_RD_EMPTY,
		c3_p3_rd_count             =>  sP3_RD_COUNT,
		c3_p3_rd_overflow          =>  open,
		c3_p3_rd_error             =>  open
	);
	
	flash : entity work.spi_module
	port map(
		iCLK => sCLK,
		iRST => sRST,
		iIMAGE_SELECT => sIMAGE_SELECT,
		oCLK => sFLASH_CLK,
		oSCLK => oSCLK,
		onCS => onCS,
		ioSIO => ioSIO,
		onRESET => onRESET,
		iCALIB_DONE => sCALIB_DONE,
		oDONE => sFLASH_DONE,
		oCMD_EN => sP2_CMD_EN,
		oCMD_INSTR => sP2_CMD_INSTR,
		oCMD_BL => sP2_CMD_BL,
		oCMD_BYTE_ADDR => sP2_CMD_BYTE_ADDR,
		oWR_EN => sP2_WR_EN,
		oWR_MASK => sP2_WR_MASK,
		oWR_DATA => sP2_WR_DATA
	);
	
	mf : entity work.median_filter
	port map(
		iCLK => sCLK,
		iRST => sRST,
		iSTART => sFLASH_DONE,
		iMODE => sFILTER_MODE,
		iDELAY_ON => sDELAY_ON,
		oCMD_EN => sP1_CMD_EN,
		oCMD_INSTR => sP1_CMD_INSTR,
		oCMD_BL => sP1_CMD_BL,
		oCMD_BYTE_ADDR => sP1_CMD_BYTE_ADDR,
		iCMD_FULL => sP1_CMD_FULL,
		oRD_EN => sP1_RD_EN,
		iRD_DATA => sP1_RD_DATA,
		iRD_COUNT => sP1_RD_COUNT,
		oWR_EN => sP1_WR_EN,
	   oWR_MASK => sP1_WR_MASK,
		oWR_DATA => sP1_WR_DATA,
		iWR_COUNT => sP1_WR_COUNT,
		oDONE => sFILTER_DONE,
		oLOAD_IMAGE_DONE => sFILTER_READ_DONE
	);
	
	pbuffer : entity work.pixel_buffer
	port map(
		iWR_CLK => sCLK,
		iRD_CLK => sVGA_CLK,
		iRST => sRST,
		iSPLIT_SCREEN => sSPLIT_SCREEN,
		iDONE => sFILTER_DONE_REG,
		oCMD_EN => sP3_CMD_EN,
		oCMD_INSTR => sP3_CMD_INSTR,
		oCMD_BL => sP3_CMD_BL,
		oCMD_BYTE_ADDR => sP3_CMD_BYTE_ADDR,
		iCMD_FULL => sP3_CMD_FULL,
		oRD_EN => sP3_RD_EN,
		iRD_DATA => sP3_RD_DATA,
		iRD_EMPTY => sP3_RD_EMPTY,
		iRD_COUNT => sP3_RD_COUNT,
		iVIDEO_ON => sVIDEO_ON,
		iSTART => sSTART,
		oRGB => oRGB,
		oBLANK => sBLANK
	);
	
	ivgasync : entity work.vga_sync
	port map(
		iCLK => sVGA_CLK,
		inRST => sLOCKED,
		iSPLIT_SCREEN => sSPLIT_SCREEN,
		oPIXEL_X => sPIXEL_X,
		oPIXEL_Y => sPIXEL_Y,
		oVIDEO_ON_DELAY => sVIDEO_ON_DELAY,
		oVIDEO_ON => sVIDEO_ON, 
		oH_SYNC => sH_SYNC, 
		oV_SYNC => sV_SYNC
	);
	
	dcm65MHz : entity work.dcm65MHz
	port map(
		CLK_IN => iCLK,
		CLK_OUT => sVGA_CLK,
		RESET  => sINV_RST,
		LOCKED => sLOCKED
	);
	
	CLK_ODDR2 : ODDR2            
	generic map(
		DDR_ALIGNMENT  =>  "NONE",
		INIT           =>  '0',
		SRTYPE         =>  "SYNC"
	)                              
	port map                       
	(
		Q              =>  oVGA_CLK,
		C0             =>  sVGA_CLK,
		C1             =>  snVGA_CLK,
		CE             =>  '1',
		D0             =>  '1',
		D1             =>  '0',
		R              =>  '0',
		S              =>  '0'
	);
	
	process(sCLK, sRST) begin
		if(sRST = '1') then
			sFILTER_DONE_REG <= '0';
		elsif(sCLK'event and sCLK = '1') then
			if(sSPLIT_SCREEN_REG /= sSPLIT_SCREEN or sFLASH_DONE = '0') then
				sFILTER_DONE_REG <= '0';
			elsif(sDELAY_ON = '1') then
				sFILTER_DONE_REG <= '1';
			else
				sFILTER_DONE_REG <= sFILTER_DONE;
			end if;
		end if;
	end process;
	
	process(sCLK) begin
		if(sCLK'event and sCLK = '1') then
			sSPLIT_SCREEN_REG <= sSPLIT_SCREEN;
		end if;
	end process;
	
	--- VGA signals ---
	onSYNC <= sH_SYNC and sV_SYNC;	
	onBLANK <= sVIDEO_ON_DELAY when sBLANK = '0'
		else '0';	
	onPSAVE <= '1';
	oH_SYNC <= sH_SYNC;
	oV_SYNC <= sV_SYNC;
	snVGA_CLK <= not sVGA_CLK;
	
	onRAM_CS <= '0';

	sINV_RST <= not inRST;
	
	--- SDRAM controller port clocks ---
	sP1_CMD_CLK <= sCLK;
	sP1_WR_CLK <= sCLK;
	sP1_RD_CLK <= sCLK;
	sP2_CMD_CLK <= sFLASH_CLK;
	sP2_WR_CLK <= sFLASH_CLK;
	sP3_CMD_CLK <= sCLK;
	sP3_RD_CLK <= sCLK;
	
	sSTART <= '1' when (sPIXEL_X = 1343 and sPIXEL_Y = 805)
				else '0';
	
end Behavioral;

