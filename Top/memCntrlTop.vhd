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
			  oLED : out STD_LOGIC_VECTOR (7 downto 0);
			  iSW : in STD_LOGIC_VECTOR (2 downto 0);
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
	signal sPLL_CLK : STD_LOGIC;
	signal snPLL_CLK : STD_LOGIC;
	
	signal sRGB : STD_LOGIC_VECTOR(23 downto 0);
	
	signal sPIXEL_Y, sPIXEL_X : STD_LOGIC_VECTOR(10 downto 0);
	signal sVIDEO_ON, sH_SYNC, sV_SYNC : STD_LOGIC;
	
begin
	
	onRAM_CS <= '0';

	snPLL_CLK <= not sPLL_CLK;

	sINV_RST <= not inRST;
	
	sP0_CMD_CLK <= sCLK;
	sP0_WR_CLK <= sCLK;
	sP0_RD_CLK <= sCLK;
	sP1_CMD_CLK <= sCLK;
	sP1_WR_CLK <= sCLK;
	sP1_RD_CLK <= sCLK;
	
	sWR_RGB <= (others => '0') when iSW = "000"
			else (7 downto 0 => '1', others => '0') when iSW = "001"
			else (15 downto 8 => '1', others => '0') when iSW = "010"
			else (15 downto 0 => '1', others => '0') when iSW = "011"
			else (23 downto 16 => '1', others => '0') when iSW = "100"
			else (23 downto 16 => '1', 7 downto 0 => '1', others => '0') when iSW = "101"
			else (23 downto 8 => '1', others => '0') when iSW = "110"
			else (others => '1');
	
	sP0_WR_DATA <= (7 downto 0 => '0') & sWR_RGB;
	
	ivgasync : entity work.vgaSync
		port map(
			iCLK => sPLL_CLK,
         inRST => sLOCKED,
		   oPIXEL_X => sPIXEL_X,
		   oPIXEL_Y => sPIXEL_Y,
		   oVIDEO_ON => sVIDEO_ON, 
		   oH_SYNC => sH_SYNC, 
		   oV_SYNC => sV_SYNC );
	
	pll00 : entity work.pll0
		port map(
    CLK_IN => iCLK,
    CLK_OUT => sPLL_CLK,
    RESET  => sINV_RST,
    LOCKED => sLOCKED);
	
	imcb : entity work.memControllerBlock
		generic map(
			C3_SIMULATION => "TRUE")
		port map (

		c3_sys_clk_p  =>         iCLK_DIFF_P,
		c3_sys_clk_n    =>       iCLK_DIFF_N,
		c3_sys_rst_i    =>       sINV_RST,                        

		mcb3_dram_dq       =>    ioRAM_DQ,  
		mcb3_dram_a        =>    oRAM_ADDR,  
		mcb3_dram_ba       =>    oRAM_BADDR,
		mcb3_dram_ras_n    =>    onRAM_RAS,                        
		mcb3_dram_cas_n    =>    onRAM_CAS,                        
		mcb3_dram_we_n     =>    onRAM_WE,                          
		mcb3_dram_odt    =>      oRAM_ODT,
		mcb3_dram_cke      =>    oRAM_CKE,                          
		mcb3_dram_ck       =>    oRAM_CLK,                          
		mcb3_dram_ck_n     =>    onRAM_CLK,       
		mcb3_dram_dqs      =>    ioRAM_LDQS,                          
		mcb3_dram_dqs_n  =>      ionRAM_LDQS,
		mcb3_dram_udqs  =>       ioRAM_UDQS,            
		mcb3_dram_udqs_n    =>   ionRAM_UDQS,  
		mcb3_dram_udm  =>        oRAM_UDM,     
		mcb3_dram_dm  =>       oRAM_LDM,
		
		c3_clk0											 =>  sCLK,
		c3_rst0											 =>  sRST,
		c3_calib_done      							 =>  sCALIB_DONE,
		mcb3_rzq        								 =>  ioRZQ,
		mcb3_zio        								 =>  ioZIO,

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

	process(sCLK, sRST) begin
		if(sRST = '1') then
			sOLD_DATA <= (others => '0');
		elsif(sCLK'event and sCLK = '1') then
			sOLD_DATA <= sP0_RD_DATA;
		end if;
	end process;

	process(sCLK, sRST) begin
		if(sRST = '1') then
			sSTATE <= IDLE;
		elsif(sCLK'event and sCLK = '1') then
			sSTATE <= sNEXT_STATE;
		end if;
	end process;

	process(sSTATE, sCALIB_DONE, sP0_RD_EMPTY) begin
		case sSTATE is
			when IDLE =>
				if(sCALIB_DONE = '1') then
					sNEXT_STATE <= SET_DATA;
				else
					sNEXT_STATE <= IDLE;
				end if;			
			when SET_DATA =>
				sNEXT_STATE <= NOP;
			when NOP =>
				sNEXT_STATE <= SET_CMD;
			when SET_CMD =>
				sNEXT_STATE <= DONE;
			when DONE =>
				sNEXT_STATE <= SET_CMD1;
			when SET_CMD1 =>
				sNEXT_STATE <= WAIT_DATA;
			when WAIT_DATA =>
				if(sP0_RD_EMPTY = '0') then
					sNEXT_STATE <= READ_DATA;
				else
					sNEXT_STATE <= WAIT_DATA;
				end if;
			when READ_DATA =>
				sNEXT_STATE <= DONE1;
			when others =>
				sNEXT_STATE <= IDLE;
		end case;
	end process;

	process(sSTATE, sWR_RGB, sP0_RD_DATA) begin
		case sSTATE is
			when IDLE =>
				sP0_CMD_INSTR <= "000";
				sP0_CMD_BL <= (others => '0');
				sP0_CMD_BYTE_ADDR <= (others => '0');
				sP0_CMD_EN <= '0';
				sP0_WR_EN <= '0';
				sP0_WR_MASK <= (others => '0');
				sP0_RD_EN <= '0';
				sLED <= (others => '0');
				sWE <= '0';
				sRGB <= (others => '0');
				
			when SET_DATA =>
				sP0_CMD_INSTR <= "000";
				sP0_CMD_BL <= (others => '0');
				sP0_CMD_BYTE_ADDR <= (others => '0');
				sP0_CMD_EN <= '0';
				sP0_WR_EN <= '1';
				sP0_WR_MASK <= (others => '0');
				sP0_RD_EN <= '0';
				sLED <= (others => '0');
				sWE <= '0';
				sRGB <= (others => '0');
				
			when NOP =>
				sP0_CMD_INSTR <= "000";
				sP0_CMD_BL <= (others => '0');
				sP0_CMD_BYTE_ADDR <= (others => '0');
				sP0_CMD_EN <= '0';
				sP0_WR_EN <= '0';
				sP0_WR_MASK <= (others => '0');
				sP0_RD_EN <= '0';
				sLED <= (others => '0');
				sWE <= '0';
				sRGB <= (others => '0');
				
			when SET_CMD =>
				sP0_CMD_INSTR <= "000";
				sP0_CMD_BL <= (others => '0');
				sP0_CMD_BYTE_ADDR <= (others => '0');
				sP0_CMD_EN <= '1';
				sP0_WR_EN <= '0';
				sP0_WR_MASK <= (others => '0');
				sP0_RD_EN <= '0';
				sLED <= (others => '0');
				sWE <= '0';
				sRGB <= (others => '0');
				
			when DONE =>
				sP0_CMD_INSTR <= "001";
				sP0_CMD_BL <= (others => '0');
				sP0_CMD_BYTE_ADDR <= (others => '0');
				sP0_CMD_EN <= '0';
				sP0_WR_EN <= '0';
				sP0_WR_MASK <= (others => '0');
				sP0_RD_EN <= '0';
				sLED <= (others => '0');
				sWE <= '0';
				sRGB <= (others => '0');
				
			when SET_CMD1 =>
				sP0_CMD_INSTR <= "001";
				sP0_CMD_BL <= (others => '0');
				sP0_CMD_BYTE_ADDR <= (others => '0');
				sP0_CMD_EN <= '1';
				sP0_WR_EN <= '0';
				sP0_WR_MASK <= (others => '0');
				sP0_RD_EN <= '0';
				sLED <= (others => '0');
				sWE <= '0';
				sRGB <= (others => '0');
				
			when WAIT_DATA =>
				sP0_CMD_INSTR <= "001";
				sP0_CMD_BL <= (others => '0');
				sP0_CMD_BYTE_ADDR <= (others => '0');
				sP0_CMD_EN <= '0';
				sP0_WR_EN <= '0';
				sP0_WR_MASK <= (others => '0');
				sP0_RD_EN <= '1';
				sLED <= (others => '0');
				sWE <= '0';
				sRGB <= (others => '0');
				
			when READ_DATA =>
				sP0_CMD_INSTR <= "001";
				sP0_CMD_BL <= (others => '0');
				sP0_CMD_BYTE_ADDR <= (others => '0');
				sP0_CMD_EN <= '0';
				sP0_WR_EN <= '0';
				sP0_WR_MASK <= (others => '0');
				sP0_RD_EN <= '0';
				sLED <= "00" & sOLD_DATA(23 downto 22) & sOLD_DATA(15 downto 14) & sOLD_DATA(7 downto 6);
				sWE <= '1';
				sRGB <= sOLD_DATA(23 downto 0);
				
			when others =>
				sP0_CMD_INSTR <= "000";
				sP0_CMD_BL <= (others => '0');
				sP0_CMD_BYTE_ADDR <= (others => '0');
				sP0_CMD_EN <= '0';
				sP0_WR_EN <= '0';
				sP0_WR_MASK <= (others => '0');
				sP0_RD_EN <= '0';
				sLED <= (others => '0');
				sWE <= '0';
				sRGB <= (others => '0');
				
		end case;
	end process;
	
	process(sCLK, sRST) begin
		if(sRST = '1') then
			oLED <= (others => '0');
		elsif(sCLK'event and sCLK = '1') then
			if(sWE = '1') then
				oLED <= sLED;
			end if;
		end if;
	end process;
	
	process(sCLK, sRST) begin
		if(sRST = '1') then
			oRGB <= (others => '0');
		elsif(sCLK'event and sCLK = '1') then
			if(sWE = '1') then
				oRGB <= sRGB;
			end if;
		end if;
	end process;
	
	CLK_ODDR2 : ODDR2            
	generic map                    
	(DDR_ALIGNMENT  =>  "NONE",
	 INIT           =>  '0',
	 SRTYPE         =>  "SYNC")                              
	port map                       
	(Q              =>  oCLK,
	 C0             =>  sPLL_CLK,
	 C1             =>  snPLL_CLK,
	 CE             =>  '1',
	 D0             =>  '1',
	 D1             =>  '0',
	 R              =>  '0',
	 S              =>  '0');
	
	sP1_CMD_INSTR <= "000";
	sP1_CMD_BL <= (others => '0');
	sP1_CMD_BYTE_ADDR <= (others => '0');
	sP1_CMD_EN <= '0';
	sP1_WR_EN <= '0';
	sP1_WR_MASK <= (others => '0');
	sP1_RD_EN <= '0';
	
	onSYNC <= sH_SYNC and sV_SYNC;
	onBLANK <= sVIDEO_ON;
	onPSAVE <= '1';
	oH_SYNC <= sH_SYNC;
	oV_SYNC <= sV_SYNC;
	
end Behavioral;

