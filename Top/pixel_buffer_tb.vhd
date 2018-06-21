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
 
ENTITY pixel_buffer_tb IS
END pixel_buffer_tb;
 
ARCHITECTURE behavior OF pixel_buffer_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
	 
	 component vga_sync is
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
	signal iDONE : std_logic;

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
	
	--- Port 3 command signals ---
	signal sP3_CMD_CLK : STD_LOGIC;
	signal sP3_CMD_EN : STD_LOGIC;
	signal sP3_CMD_INSTR : STD_LOGIC_VECTOR (2 downto 0);
	signal sP3_CMD_BL : STD_LOGIC_VECTOR (5 downto 0);
	signal sP3_CMD_BYTE_ADDR : STD_LOGIC_VECTOR (29 downto 0);
	signal sP3_CMD_EMPTY : STD_LOGIC;
	signal sP3_CMD_FULL : STD_LOGIC;
	
	--- Port 3 read signals ---
	signal sP3_RD_CLK : STD_LOGIC;
	signal sP3_RD_EN : STD_LOGIC;
	signal sP3_RD_DATA : STD_LOGIC_VECTOR (31 downto 0);
	signal sP3_RD_FULL : STD_LOGIC;
	signal sP3_RD_EMPTY : STD_LOGIC;
	signal sP3_RD_COUNT : STD_LOGIC_VECTOR (6 downto 0);
	signal sP3_RD_OVERFLOW : STD_LOGIC;
	signal sP3_RD_ERROR : STD_LOGIC;

	signal sINV_RST : STD_LOGIC;
	
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
	sP3_CMD_CLK <= sCLK;
	sP3_RD_CLK <= sCLK;
	
	-- Instantiate the Unit Under Test (UUT)
   uut: entity work.pixel_buffer PORT MAP (
          iWR_CLK => sCLK,
          iRD_CLK => sPIXEL_CLK,
          iRST => sRST,
			 iDONE => iDONE,
          oCMD_EN => sP3_CMD_EN,
          oCMD_INSTR => sP3_CMD_INSTR,
          oCMD_BL => sP3_CMD_BL,
          oCMD_BYTE_ADDR => sP3_CMD_BYTE_ADDR,
          iCMD_EMPTY => sP3_CMD_EMPTY,
          iCMD_FULL => sP3_CMD_FULL,
          oRD_EN => sP3_RD_EN,
          iRD_DATA => sP3_RD_DATA,
          iRD_FULL => sP3_RD_FULL,
          iRD_EMPTY => sP3_RD_EMPTY,
          iRD_OVERFLOW => sP3_RD_OVERFLOW,
          iRD_ERROR => sP3_RD_ERROR,
          iRD_COUNT => sP3_RD_COUNT,
			 iVIDEO_ON => oVIDEO_ON,
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

		c3_p1_cmd_clk              =>  sCLK,
		c3_p1_cmd_en               =>  '0',
		c3_p1_cmd_instr            =>  (others => '0'),
		c3_p1_cmd_bl               =>  (others => '0'),
		c3_p1_cmd_byte_addr        =>  (others => '0'),
		c3_p1_cmd_empty            =>  open,
		c3_p1_cmd_full             =>  open,
		
		c3_p1_wr_clk               =>  sCLK,
		c3_p1_wr_en                =>  '0',
		c3_p1_wr_mask              =>  (others => '0'),
		c3_p1_wr_data              =>  (others => '0'),
		c3_p1_wr_full              =>  open,
		c3_p1_wr_empty             =>  open,
		c3_p1_wr_count             =>  open,
		c3_p1_wr_underrun          =>  open,
		c3_p1_wr_error             =>  open,
		
		c3_p1_rd_clk               =>  sCLK,
		c3_p1_rd_en                =>  '0',
		c3_p1_rd_data              =>  open,
		c3_p1_rd_full              =>  open,
		c3_p1_rd_empty             =>  open,
		c3_p1_rd_count             =>  open,
		c3_p1_rd_overflow          =>  open,
		c3_p1_rd_error             =>  open,
		
		c3_p2_cmd_clk              =>  sCLK,
		c3_p2_cmd_en               =>  '0',
		c3_p2_cmd_instr            =>  (others => '0'),
		c3_p2_cmd_bl               =>  (others => '0'),
		c3_p2_cmd_byte_addr        =>  (others => '0'),
		c3_p2_cmd_empty            =>  open,
		c3_p2_cmd_full             =>  open,
		
		c3_p2_wr_clk               =>  sCLK,
		c3_p2_wr_en                =>  '0',
		c3_p2_wr_mask              =>  (others => '0'),
		c3_p2_wr_data              =>  (others => '0'),
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
		c3_p3_cmd_empty            =>  sP3_CMD_EMPTY,
		c3_p3_cmd_full             =>  sP3_CMD_FULL,
		
		c3_p3_rd_clk               =>  sP3_RD_CLK,
		c3_p3_rd_en                =>  sP3_RD_EN,
		c3_p3_rd_data              =>  sP3_RD_DATA,
		c3_p3_rd_full              =>  sP3_RD_FULL,
		c3_p3_rd_empty             =>  sP3_RD_EMPTY,
		c3_p3_rd_count             =>  sP3_RD_COUNT,
		c3_p3_rd_overflow          =>  sP3_RD_OVERFLOW,
		c3_p3_rd_error             =>  sP3_RD_ERROR
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

	vgasync0 : vga_sync
    Port map( iCLK => sPIXEL_CLK,
           inRST => inRST,
           oPIXEL_X => oPIXEL_X,
           oPIXEL_Y => oPIXEL_Y,
           oVIDEO_ON => oVIDEO_ON,
			  oH_SYNC => open,
			  oV_SYNC => open);

	iSTART <= '1' when (oPIXEL_X = 1342 and (oPIXEL_Y = 15 or oPIXEL_Y = 45))--805)
				else '0';

   -- Stimulus process
   stim_proc: process
   begin		
      inRST <= '0';
		iDONE <= '0';
      wait for 100 us;	
		inRST <= '1';
		wait for 100 us;
		iDONE <= '1';
		wait for 300 us;
		iDONE <= '0';
		wait for 500 us;
		iDONE <= '1';
      wait;
   end process;

END;
