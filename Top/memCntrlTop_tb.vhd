--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:16:34 04/27/2018
-- Design Name:   
-- Module Name:   D:/MCB/memCntrlTop_tb.vhd
-- Project Name:  MCB
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: memCntrlTop
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

library unisim;
use unisim.vcomponents.all;


ENTITY memCntrlTop_tb IS
END memCntrlTop_tb;
 
ARCHITECTURE behavior OF memCntrlTop_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT memCntrlTop
    PORT(
         iCLK_DIFF_P : IN  std_logic;
         iCLK_DIFF_N : IN  std_logic;
			iCLK : IN std_logic;
         inRST : IN  std_logic;
         onRAM_CS : OUT  std_logic;
         onRAM_WE : OUT  std_logic;
         onRAM_CAS : OUT  std_logic;
         onRAM_RAS : OUT  std_logic;
         onRAM_CLK : OUT  std_logic;
         oRAM_CLK : OUT  std_logic;
         oRAM_CKE : OUT  std_logic;
         oRAM_ODT : OUT  std_logic;
         oRAM_UDM : OUT  std_logic;
         oRAM_LDM : OUT  std_logic;
         oRAM_BADDR : OUT  std_logic_vector(2 downto 0);
         oRAM_ADDR : OUT  std_logic_vector(13 downto 0);
         ioRAM_UDQS : INOUT  std_logic;
         ionRAM_UDQS : INOUT  std_logic;
         ioRAM_LDQS : INOUT  std_logic;
         ionRAM_LDQS : INOUT  std_logic;
         ioRAM_DQ : INOUT  std_logic_vector(15 downto 0);
         ioRZQ : INOUT  std_logic;
         ioZIO : INOUT  std_logic;
         oLED : OUT  std_logic_vector(7 downto 0);
			iSW : IN std_logic_vector(2 downto 0);
			onBLANK : out STD_LOGIC; 
			onSYNC : out STD_LOGIC;
		   onPSAVE : out STD_LOGIC;
		   oH_SYNC : out STD_LOGIC;
		   oV_SYNC : out STD_LOGIC;
			oRGB : out STD_LOGIC_VECTOR(23 downto 0);
		   oCLK : out STD_LOGIC
        );
    END COMPONENT;
    
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
	signal iCLK : std_logic;
   signal inRST : std_logic;
	signal iSW : std_logic_vector(2 downto 0);

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
   signal oLED : std_logic_vector(7 downto 0);
	signal onBLANK : STD_LOGIC; 
	signal onSYNC : STD_LOGIC;
	signal onPSAVE : STD_LOGIC;
	signal oH_SYNC : STD_LOGIC;
	signal oV_SYNC : STD_LOGIC;
	signal oRGB : STD_LOGIC_VECTOR(23 downto 0);
	signal oCLK : STD_LOGIC;

   -- Clock period definitions
   constant iCLK_DIFF_period : time := 20 ns;
	constant iCLK_period : time := 41.67 ns;
 
	signal mcb3_dram_dm_vector, mcb3_dram_dqs_vector, mcb3_dram_dqs_n_vector : std_logic_vector(1 downto 0);
	signal mcb3_command : std_logic_vector(2 downto 0);
 
BEGIN
 
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
	
	-- Instantiate the Unit Under Test (UUT)
   uut: memCntrlTop PORT MAP (
          iCLK_DIFF_P => iCLK_DIFF_P,
          iCLK_DIFF_N => iCLK_DIFF_N,
			 iCLK => iCLK,
          inRST => inRST,
          onRAM_CS => onRAM_CS,
          onRAM_WE => onRAM_WE,
          onRAM_CAS => onRAM_CAS,
          onRAM_RAS => onRAM_RAS,
          onRAM_CLK => onRAM_CLK,
          oRAM_CLK => oRAM_CLK,
          oRAM_CKE => oRAM_CKE,
          oRAM_ODT => oRAM_ODT,
          oRAM_UDM => oRAM_UDM,
          oRAM_LDM => oRAM_LDM,
          oRAM_BADDR => oRAM_BADDR,
          oRAM_ADDR => oRAM_ADDR,
          ioRAM_UDQS => ioRAM_UDQS,
          ionRAM_UDQS => ionRAM_UDQS,
          ioRAM_LDQS => ioRAM_LDQS,
          ionRAM_LDQS => ionRAM_LDQS,
          ioRAM_DQ => ioRAM_DQ,
          ioRZQ => ioRZQ,
          ioZIO => ioZIO,
          oLED => oLED,
			 iSW => iSW,
			 onBLANK => onBLANK,
			 onSYNC => onSYNC,
			 onPSAVE => onPSAVE,
		    oH_SYNC => oH_SYNC,
			 oV_SYNC => oV_SYNC,
			 oRGB => oRGB,
			 oCLK => oCLK
        );

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
	
	CLK_process :process
   begin
		iCLK <= '1';
		wait for iCLK_period/2;
		iCLK <= '0';
		wait for iCLK_period/2;
   end process;	
 
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
	
   -- Stimulus process
   stim_proc: process
   begin		
      inRST <= '0';
		iSW <= "101";
      wait for 200 us;	
		inRST <= '1';
      wait;
   end process;

END;
