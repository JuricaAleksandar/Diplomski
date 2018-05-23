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

entity memCntrlTop is
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
			  oRGB : out STD_LOGIC_VECTOR(23 downto 0);
			  oCLK : out STD_LOGIC);
end memCntrlTop;

architecture Behavioral of memCntrlTop is
	
	type tSTATE is (IDLE, SET_DATA, NOP, SET_CMD, DONE, SET_CMD1, WAIT_DATA, READ_DATA, DONE1);
	
	signal sSTATE, sNEXT_STATE : tSTATE;
	
	signal sINV_RST : STD_LOGIC;
	signal sCLK : STD_LOGIC;
	signal sRST : STD_LOGIC;
	signal sWR_RGB : STD_LOGIC_VECTOR (23 downto 0);
	
	signal sCALIB_DONE : STD_LOGIC;
	
	--- Port 0 command signals ---
	signal sP0_CMD_CLK : STD_LOGIC;
	signal sP0_CMD_EN : STD_LOGIC;
	signal sP0_CMD_INSTR : STD_LOGIC_VECTOR (2 downto 0);
	signal sP0_CMD_BL : STD_LOGIC_VECTOR (5 downto 0);
	signal sP0_CMD_BYTE_ADDR : STD_LOGIC_VECTOR (29 downto 0);
	signal sP0_CMD_EMPTY : STD_LOGIC;
	signal sP0_CMD_FULL : STD_LOGIC;
	
	--- Port 0 write signals ---
	signal sP0_WR_CLK : STD_LOGIC;
	signal sP0_WR_EN : STD_LOGIC;
	signal sP0_WR_MASK : STD_LOGIC_VECTOR (3 downto 0);
	signal sP0_WR_DATA : STD_LOGIC_VECTOR (31 downto 0);
	signal sP0_WR_FULL : STD_LOGIC;
	signal sP0_WR_EMPTY  : STD_LOGIC;
	signal sP0_WR_COUNT : STD_LOGIC_VECTOR (6 downto 0);
	signal sP0_WR_UNDERRUN : STD_LOGIC;
	signal sP0_WR_ERROR : STD_LOGIC;
	
	--- Port 0 read signals ---
	signal sP0_RD_CLK : STD_LOGIC;
	signal sP0_RD_EN : STD_LOGIC;
	signal sP0_RD_DATA : STD_LOGIC_VECTOR (31 downto 0);
	signal sP0_RD_FULL : STD_LOGIC;
	signal sP0_RD_EMPTY : STD_LOGIC;
	signal sP0_RD_COUNT : STD_LOGIC_VECTOR (6 downto 0);
	signal sP0_RD_OVERFLOW : STD_LOGIC;
	signal sP0_RD_ERROR : STD_LOGIC;
	
	--- Port 1 command signals ---
	signal sP1_CMD_CLK : STD_LOGIC;
	signal sP1_CMD_EN : STD_LOGIC;
	signal sP1_CMD_INSTR : STD_LOGIC_VECTOR (2 downto 0);
	signal sP1_CMD_BL : STD_LOGIC_VECTOR (5 downto 0);
	signal sP1_CMD_BYTE_ADDR : STD_LOGIC_VECTOR (29 downto 0);
	signal sP1_CMD_EMPTY : STD_LOGIC;
	signal sP1_CMD_FULL : STD_LOGIC;
	
	--- Port 1 write signals ---
	signal sP1_WR_CLK : STD_LOGIC;
	signal sP1_WR_EN : STD_LOGIC;
	signal sP1_WR_MASK : STD_LOGIC_VECTOR (3 downto 0);
	signal sP1_WR_DATA : STD_LOGIC_VECTOR (31 downto 0);
	signal sP1_WR_FULL : STD_LOGIC;
	signal sP1_WR_EMPTY  : STD_LOGIC;
	signal sP1_WR_COUNT : STD_LOGIC_VECTOR (6 downto 0);
	signal sP1_WR_UNDERRUN : STD_LOGIC;
	signal sP1_WR_ERROR : STD_LOGIC;
	
	--- Port 1 read signals ---
	signal sP1_RD_CLK : STD_LOGIC;
	signal sP1_RD_EN : STD_LOGIC;
	signal sP1_RD_DATA : STD_LOGIC_VECTOR (31 downto 0);
	signal sP1_RD_FULL : STD_LOGIC;
	signal sP1_RD_EMPTY : STD_LOGIC;
	signal sP1_RD_COUNT : STD_LOGIC_VECTOR (6 downto 0);
	signal sP1_RD_OVERFLOW : STD_LOGIC;
	signal sP1_RD_ERROR : STD_LOGIC;
	
	signal sOLD_DATA : STD_LOGIC_VECTOR (31 downto 0);
	signal sLED : STD_LOGIC_VECTOR (7 downto 0);
	signal sWE : STD_LOGIC;
	
	signal sLOCKED : STD_LOGIC;
	signal sGEN_CLK : STD_LOGIC;
	signal snPLL_CLK : STD_LOGIC;
	
	signal sRGB : STD_LOGIC_VECTOR(23 downto 0);
	
	signal sPIXEL_Y, sPIXEL_X : STD_LOGIC_VECTOR(10 downto 0);
	signal sVIDEO_ON, sH_SYNC, sV_SYNC : STD_LOGIC;
	
	signal sDONE : STD_LOGIC;
	signal sSTART : STD_LOGIC;
	
begin
	
	ivgasync : entity work.vgaSync
	port map(
		iCLK => sGEN_CLK,
		inRST => sLOCKED,
		oPIXEL_X => sPIXEL_X,
		oPIXEL_Y => sPIXEL_Y,
		oVIDEO_ON => sVIDEO_ON, 
		oH_SYNC => sH_SYNC, 
		oV_SYNC => sV_SYNC
	);
	
	dcm65MHz : entity work.dcm65MHz
	port map(
		CLK_IN => iCLK,
		CLK_OUT => sGEN_CLK,
		RESET  => sINV_RST,
		LOCKED => sLOCKED
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

		c3_p0_cmd_clk                           =>  sP0_CMD_CLK,
		c3_p0_cmd_en                            =>  sP0_CMD_EN,
		c3_p0_cmd_instr                         =>  sP0_CMD_INSTR,
		c3_p0_cmd_bl                            =>  sP0_CMD_BL,
		c3_p0_cmd_byte_addr                     =>  sP0_CMD_BYTE_ADDR,
		c3_p0_cmd_empty                         =>  sP0_CMD_EMPTY,
		c3_p0_cmd_full                          =>  sP0_CMD_FULL,
		
		c3_p0_wr_clk                            =>  sP0_WR_CLK,
		c3_p0_wr_en                             =>  sP0_WR_EN,
		c3_p0_wr_mask                           =>  sP0_WR_MASK,
		c3_p0_wr_data                           =>  sP0_WR_DATA,
		c3_p0_wr_full                           =>  sP0_WR_FULL,
		c3_p0_wr_empty                          =>  sP0_WR_EMPTY,
		c3_p0_wr_count                          =>  sP0_WR_COUNT,
		c3_p0_wr_underrun                       =>  sP0_WR_UNDERRUN,
		c3_p0_wr_error                          =>  sP0_WR_ERROR,
		
		c3_p0_rd_clk                            =>  sP0_RD_CLK,
		c3_p0_rd_en                             =>  sP0_RD_EN,
		c3_p0_rd_data                           =>  sP0_RD_DATA,
		c3_p0_rd_full                           =>  sP0_RD_FULL,
		c3_p0_rd_empty                          =>  sP0_RD_EMPTY,
		c3_p0_rd_count                          =>  sP0_RD_COUNT,
		c3_p0_rd_overflow                       =>  sP0_RD_OVERFLOW,
		c3_p0_rd_error                          =>  sP0_RD_ERROR,
		
		c3_p1_cmd_clk                           =>  sP1_CMD_CLK,
		c3_p1_cmd_en                            =>  sP1_CMD_EN,
		c3_p1_cmd_instr                         =>  sP1_CMD_INSTR,
		c3_p1_cmd_bl                            =>  sP1_CMD_BL,
		c3_p1_cmd_byte_addr                     =>  sP1_CMD_BYTE_ADDR,
		c3_p1_cmd_empty                         =>  sP1_CMD_EMPTY,
		c3_p1_cmd_full                          =>  sP1_CMD_FULL,
		
		c3_p1_wr_clk                            =>  sP1_WR_CLK,
		c3_p1_wr_en                             =>  sP1_WR_EN,
		c3_p1_wr_mask                           =>  sP1_WR_MASK,
		c3_p1_wr_data                           =>  sP1_WR_DATA,
		c3_p1_wr_full                           =>  sP1_WR_FULL,
		c3_p1_wr_empty                          =>  sP1_WR_EMPTY,
		c3_p1_wr_count                          =>  sP1_WR_COUNT,
		c3_p1_wr_underrun                       =>  sP1_WR_UNDERRUN,
		c3_p1_wr_error                          =>  sP1_WR_ERROR,
		
		c3_p1_rd_clk                            =>  sP1_RD_CLK,
		c3_p1_rd_en                             =>  sP1_RD_EN,
		c3_p1_rd_data                           =>  sP1_RD_DATA,
		c3_p1_rd_full                           =>  sP1_RD_FULL,
		c3_p1_rd_empty                          =>  sP1_RD_EMPTY,
		c3_p1_rd_count                          =>  sP1_RD_COUNT,
		c3_p1_rd_overflow                       =>  sP1_RD_OVERFLOW,
		c3_p1_rd_error                          =>  sP1_RD_ERROR
	);

	CBR : entity work.colorBarGenerator
	port map(
	  iCLK => sCLK,
	  inRST => sCALIB_DONE,
	  oDONE => sDONE,
	  oCMD_EN => sP0_CMD_EN,
	  oCMD_INSTR => sP0_CMD_INSTR,
	  oCMD_BL => sP0_CMD_BL,
	  oCMD_BYTE_ADDR => sP0_CMD_BYTE_ADDR,
	  iCMD_EMPTY => sP0_CMD_EMPTY,
	  iCMD_FULL => sP0_CMD_FULL,
	  oWR_EN => sP0_WR_EN,
	  oWR_MASK => sP0_WR_MASK,
	  oWR_DATA => sP0_WR_DATA,
	  iWR_FULL => sP0_WR_FULL,
	  iWR_EMPTY => sP0_WR_EMPTY,
	  iWR_COUNT => sP0_WR_COUNT,
	  iWR_UNDERRUN => sP0_WR_UNDERRUN,
	  iWR_ERROR => sP0_WR_ERROR
	);
	
	CLK_ODDR2 : ODDR2            
	generic map(
		DDR_ALIGNMENT  =>  "NONE",
		INIT           =>  '0',
		SRTYPE         =>  "SYNC"
	)                              
	port map                       
	(
		Q              =>  oCLK,
		C0             =>  sGEN_CLK,
		C1             =>  snPLL_CLK,
		CE             =>  '1',
		D0             =>  '1',
		D1             =>  '0',
		R              =>  '0',
		S              =>  '0'
	);
	
	pbuffer : entity work.pixelBuffer
	port map(
		iWR_CLK => sCLK,
		iRD_CLK => sGEN_CLK,
		inRST => sDONE,
		oCMD_EN => sP1_CMD_EN,
		oCMD_INSTR => sP1_CMD_INSTR,
		oCMD_BL => sP1_CMD_BL,
		oCMD_BYTE_ADDR => sP1_CMD_BYTE_ADDR,
		iCMD_EMPTY => sP1_CMD_EMPTY,
		iCMD_FULL => sP1_CMD_FULL,
		oRD_EN => sP1_RD_EN,
		iRD_DATA => sP1_RD_DATA,
		iRD_FULL => sP1_RD_FULL,
		iRD_EMPTY => sP1_RD_EMPTY,
		iRD_OVERFLOW => sP1_RD_OVERFLOW,
		iRD_ERROR => sP1_RD_ERROR,
		iRD_COUNT => sP1_RD_COUNT,
		iFIFO_RD_EN => sVIDEO_ON,
		iSTART => sSTART,
		oRGB => oRGB
	);
	
	sP1_WR_EN <= '0';
	sP1_WR_MASK <= (others => '0');
	sP1_WR_DATA <= (others => '0');
	sP0_RD_EN <= '0';
	
	onSYNC <= sH_SYNC and sV_SYNC;
	onBLANK <= sVIDEO_ON;
	onPSAVE <= '1';
	oH_SYNC <= sH_SYNC;
	oV_SYNC <= sV_SYNC;
	
	onRAM_CS <= '0';

	snPLL_CLK <= not sGEN_CLK;

	sINV_RST <= not inRST;
	
	sP0_CMD_CLK <= sCLK;
	sP0_WR_CLK <= sCLK;
	sP0_RD_CLK <= sCLK;
	sP1_CMD_CLK <= sCLK;
	sP1_WR_CLK <= sCLK;
	sP1_RD_CLK <= sCLK;
	
	sSTART <= '1' when (sPIXEL_X = 1342 and sPIXEL_Y = 805)
				else '0';
	
end Behavioral;

