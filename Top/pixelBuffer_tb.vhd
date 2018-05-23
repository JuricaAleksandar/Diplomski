--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:23:01 05/11/2018
-- Design Name:   
-- Module Name:   D:/Diplomski/Top/pixelBuffer_tb.vhd
-- Project Name:  Top
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: pixelBuffer
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
USE ieee.std_logic_unsigned.ALL;
 
library unisim;
use unisim.vcomponents.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY pixelBuffer_tb IS
END pixelBuffer_tb;
 
ARCHITECTURE behavior OF pixelBuffer_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
	 
	 component vgaSync is
    Port ( iCLK : in  STD_LOGIC;
           inRST : in  STD_LOGIC;
           oPIXEL_X : out  STD_LOGIC_VECTOR (10 downto 0);
           oPIXEL_Y : out  STD_LOGIC_VECTOR (10 downto 0);
           oVIDEO_ON : out  STD_LOGIC;
			  oH_SYNC : out STD_LOGIC;
			  oV_SYNC : out STD_LOGIC);
	end component;

	 component ddr2_model_c3 is
    port (
      ck      : in    std_logic;
      ck_n    : in    std_logic;
      cke     : in    std_logic;
      cs_n    : in    std_logic;
      ras_n   : in    std_logic;
      cas_n   : in    std_logic;
      we_n    : in    std_logic;
      dm_rdqs : inout std_logic_vector(1 downto 0);
      ba      : in    std_logic_vector(2 downto 0);
      addr    : in    std_logic_vector(13 downto 0);
      dq      : inout std_logic_vector(15 downto 0);
      dqs     : inout std_logic_vector(1 downto 0);
      dqs_n   : inout std_logic_vector(1 downto 0);
      rdqs_n  : out   std_logic_vector(1 downto 0);
      odt     : in    std_logic
      );
  end component;
 
	signal mcb3_enable1 : std_logic;
	signal mcb3_enable2 : std_logic;

   --Inputs
   signal iCLK_DIFF_P : std_logic;
   signal iCLK_DIFF_N : std_logic;
   signal inRST : std_logic;

	--BiDirs
   signal ioRAM_UDQS : std_logic;
   signal ionRAM_UDQS : std_logic;
   signal ioRAM_LDQS : std_logic;
   signal ionRAM_LDQS : std_logic;
   signal ioRAM_DQ : std_logic_vector(15 downto 0);
   signal ioRZQ : std_logic;
   signal ioZIO : std_logic;

 	--Outputs
   signal onRAM_CS : std_logic;
   signal onRAM_WE : std_logic;
   signal onRAM_CAS : std_logic;
   signal onRAM_RAS : std_logic;
   signal onRAM_CLK : std_logic;
   signal oRAM_CLK : std_logic;
   signal oRAM_CKE : std_logic;
   signal oRAM_ODT : std_logic;
   signal oRAM_UDM : std_logic;
   signal oRAM_LDM : std_logic;
   signal oRAM_BADDR : std_logic_vector(2 downto 0);
   signal oRAM_ADDR : std_logic_vector(13 downto 0);
 
	signal sCLK : STD_LOGIC;
	signal sRST : STD_LOGIC;
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

	signal sINV_RST : STD_LOGIC;
	signal sDONE : STD_LOGIC;
  -- Clock period definitions
   constant iCLK_DIFF_period : time := 20 ns;
	constant sPIXEL_CLK_period : time := 15.39 ns;
 
	signal mcb3_dram_dm_vector, mcb3_dram_dqs_vector, mcb3_dram_dqs_n_vector : std_logic_vector(1 downto 0);
	signal mcb3_command : std_logic_vector(2 downto 0);   
 
	signal oRGB : std_logic_vector (23 downto 0);
	signal iFIFO_RD_EN : std_logic;
	
	signal sPIXEL_CLK : std_logic;
	signal oPIXEL_X : STD_LOGIC_VECTOR (10 downto 0);
	signal oPIXEL_Y : STD_LOGIC_VECTOR (10 downto 0);
	signal oVIDEO_ON : STD_LOGIC;
	signal iSTART : STD_LOGIC;
 
BEGIN
 
	onRAM_CS <= '0';
	sP0_CMD_CLK <= sCLK;
	sP0_WR_CLK <= sCLK;
	sP0_RD_CLK <= sCLK;
	sP1_CMD_CLK <= sCLK;
	sP1_WR_CLK <= sCLK;
	sP1_RD_CLK <= sCLK;
 
	sP1_CMD_INSTR <= "000";
	sP1_CMD_BL <= (others => '0');
	sP1_CMD_BYTE_ADDR <= (others => '0');
	sP1_CMD_EN <= '0';
	sP1_WR_EN <= '0';
	sP1_WR_MASK <= (others => '1');
	sP1_RD_EN <= '0';
	sP1_WR_DATA <= (others => '0');
	sP0_WR_DATA <= (others => '0');
	sP0_WR_MASK <= (others => '1');
	sP0_WR_EN <= '0';
 
	-- Instantiate the Unit Under Test (UUT)
   uut: entity work.pixelBuffer PORT MAP (
          iWR_CLK => sCLK,
          iRD_CLK => sPIXEL_CLK,
          inRST => sDONE,
          oCMD_EN => sP0_CMD_EN,
          oCMD_INSTR => sP0_CMD_INSTR,
          oCMD_BL => sP0_CMD_BL,
          oCMD_BYTE_ADDR => sP0_CMD_BYTE_ADDR,
          iCMD_EMPTY => sP0_CMD_EMPTY,
          iCMD_FULL => sP0_CMD_FULL,
          oRD_EN => sP0_RD_EN,
          iRD_DATA => sP0_RD_DATA,
          iRD_FULL => sP0_RD_FULL,
          iRD_EMPTY => sP0_RD_EMPTY,
          iRD_OVERFLOW => sP0_RD_OVERFLOW,
          iRD_ERROR => sP0_RD_ERROR,
          iRD_COUNT => sP0_RD_COUNT,
			 iFIFO_RD_EN => oVIDEO_ON,
			 iSTART => iSTART,
			 oRGB => oRGB
        );
 
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
	
	zio_pulldown3 : PULLDOWN port map(O => ioZIO);
   rzq_pulldown3 : PULLDOWN port map(O => ioRZQ);
	
	u_mem_c3 : ddr2_model_c3 port map(
        ck        => oRAM_CLK,
        ck_n      => onRAM_CLK,
        cke       => oRAM_CKE,
        cs_n      => onRAM_CS,
        ras_n     => onRAM_RAS,
        cas_n     => onRAM_CAS,
        we_n      => onRAM_WE,
        dm_rdqs   => mcb3_dram_dm_vector ,
        ba        => oRAM_BADDR,
        addr      => oRAM_ADDR,
        dq        => ioRAM_DQ,
        dqs       => mcb3_dram_dqs_vector,
        dqs_n     => mcb3_dram_dqs_n_vector,
        rdqs_n    => open,
        odt       => oRAM_ODT
      );

	mcb3_command <= (onRAM_RAS & onRAM_CAS & onRAM_WE);

    process(oRAM_CLK)
    begin
      if (rising_edge(oRAM_CLK)) then
        if (inRST = '0') then
          mcb3_enable1   <= '0';
          mcb3_enable2 <= '0';
        elsif (mcb3_command = "100") then
          mcb3_enable2 <= '0';
        elsif (mcb3_command = "101") then
          mcb3_enable2 <= '1';
        else
          mcb3_enable2 <= mcb3_enable2;
        end if;
        mcb3_enable1     <= mcb3_enable2;
      end if;
    end process;

-----------------------------------------------------------------------------
--read
-----------------------------------------------------------------------------
    mcb3_dram_dqs_vector(1 downto 0)               <= (ioRAM_UDQS & ioRAM_LDQS)
                                                           when (mcb3_enable2 = '0' and mcb3_enable1 = '0')
							   else "ZZ";
    mcb3_dram_dqs_n_vector(1 downto 0)             <= (ionRAM_UDQS & ionRAM_LDQS)
                                                           when (mcb3_enable2 = '0' and mcb3_enable1 = '0')
							   else "ZZ";
    
-----------------------------------------------------------------------------
--write
-----------------------------------------------------------------------------
    ioRAM_LDQS          <= mcb3_dram_dqs_vector(0)
                              when ( mcb3_enable1 = '1') else 'Z';

    ioRAM_UDQS          <= mcb3_dram_dqs_vector(1)
                              when (mcb3_enable1 = '1') else 'Z';


    ionRAM_LDQS        <= mcb3_dram_dqs_n_vector(0)
                              when (mcb3_enable1 = '1') else 'Z';
    ionRAM_UDQS         <= mcb3_dram_dqs_n_vector(1)
                              when (mcb3_enable1 = '1') else 'Z';

   
   
	mcb3_dram_dm_vector <= (oRAM_UDM & oRAM_LDM);

    -- Clock process definitions
   CLK_DIFF_P_process :process
   begin
		iCLK_DIFF_P <= '0';
		wait for iCLK_DIFF_period/2;
		iCLK_DIFF_P <= '1';
		wait for iCLK_DIFF_period/2;
   end process;
 
   CLK_DIFF_N_process :process
   begin
		iCLK_DIFF_N <= '1';
		wait for iCLK_DIFF_period/2;
		iCLK_DIFF_N <= '0';
		wait for iCLK_DIFF_period/2;
   end process;
	
	PIXEL_CLK_process :process
   begin
		sPIXEL_CLK <= '0';
		wait for sPIXEL_CLK_period/2;
		sPIXEL_CLK <= '1';
		wait for sPIXEL_CLK_period/2;
   end process;
 
	sINV_RST <= not inRST;

	vgasync0 : vgaSync
    Port map( iCLK => sPIXEL_CLK,
           inRST => inRST,
           oPIXEL_X => oPIXEL_X,
           oPIXEL_Y => oPIXEL_Y,
           oVIDEO_ON => oVIDEO_ON,
			  oH_SYNC => open,
			  oV_SYNC => open);

	iSTART <= '1' when (oPIXEL_X = 1342 and oPIXEL_Y = 15)--805)
				else '0';

   -- Stimulus process
   stim_proc: process
   begin		
      inRST <= '0';
		sDONE <= '0';
      wait for 100 us;	
		inRST <= '1';
		wait for 100 us;
		sDONE <= '1';
      wait;
   end process;

END;
