----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:07:50 05/11/2018 
-- Design Name: 
-- Module Name:    pixelBuffer - Behavioral 
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
--library UNISIM;
--use UNISIM.VComponents.all;

entity pixel_buffer is
    Port ( iWR_CLK : in  STD_LOGIC;
			  iRD_CLK : in STD_LOGIC;
           iRST : in  STD_LOGIC;
			  iDONE : in STD_LOGIC;
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
			  iVIDEO_ON : in STD_LOGIC;
			  iSTART : in STD_LOGIC;
			  oRGB : out STD_LOGIC_VECTOR (23 downto 0));
end pixel_buffer;

architecture Behavioral of pixel_buffer is

	constant H_RESOLUTION : natural := 512;
	constant V_RESOLUTION : natural := 512;

	type tREAD_STATE is
	(
		IDLE,
		SET_CMD,
		WAIT_UPDATE,
		WAIT_DATA,
		WAIT_FIFO,
		WAIT_EMPTY,
		RST_ALL
	);
	
	signal sSTATE, sNEXT_STATE : tREAD_STATE;

	signal sFIFO_FULL : STD_LOGIC;
	signal sFIFO_EMPTY : STD_LOGIC;
	signal sFIFO_RD_EN : STD_LOGIC;
	signal sFIFO_WR_EN : STD_LOGIC;
	signal sPOS_X : STD_LOGIC_VECTOR(5 downto 0);
	signal sPOS_Y : STD_LOGIC_VECTOR(8 downto 0);
	signal sPOS_WE : STD_LOGIC;
	signal sCOMBINED_EN : STD_LOGIC;
	signal sFIFO_BURST_COUNT : STD_LOGIC_VECTOR(3 downto 0);
	signal sREAD_COUNT : STD_LOGIC_VECTOR(2 downto 0);
	signal sBURST_READ : STD_LOGIC;
	signal sFIFI_RD_EN_CLR : STD_LOGIC;
	signal sPOS_CLR : STD_LOGIC;
	
begin
		
	oCMD_INSTR <= "001"; -- Read instuction code
	oCMD_BL <= (5 downto 3 => '0',others => '1'); -- Burst length 8
	oCMD_BYTE_ADDR <= "0000000" & sPOS_Y & "001" & sPOS_X & "00000";
		
	sCOMBINED_EN <= sFIFO_RD_EN and iVIDEO_ON;
		
	sFIFO_WR_EN <= '1' when (iRD_COUNT > 0 and sFIFO_FULL = '0') else '0';
	
	oRD_EN <= '1' when (iRD_COUNT > 0 and sFIFO_FULL = '0') else '0';
		
	process(iRD_CLK, iRST) begin
		if(iRST = '1') then
			sFIFO_RD_EN <= '0';
		elsif(iRD_CLK'event and iRD_CLK = '1') then
			if(sFIFO_FULL = '1' and iSTART = '1' and sFIFO_EMPTY = '0') then
				sFIFO_RD_EN <= '1';
			elsif(sFIFI_RD_EN_CLR = '1') then
				sFIFO_RD_EN <= '0';
			end if;
		end if;
	end process;
		
	-- Read pixel counter --
	process(iWR_CLK, iRST) begin
		if(iRST = '1') then
			sREAD_COUNT <= (others => '0');
			sBURST_READ <= '0';
		elsif(iWR_CLK'event and iWR_CLK = '1') then
			if(sFIFO_WR_EN = '1') then
				if(sREAD_COUNT = 6) then
					sBURST_READ <= '1';
					sREAD_COUNT <= sREAD_COUNT + 1;
				elsif(sREAD_COUNT = 7) then
					sREAD_COUNT <= (others => '0');
					sBURST_READ <= '0';
				else
					sREAD_COUNT <= sREAD_COUNT + 1;
					sBURST_READ <= '0';
				end if;
			else
				sBURST_READ <= '0';
			end if;
		end if;
	end process;
	
	-- Read fifo stored burst counter --
	process(iWR_CLK, iRST) begin
		if(iRST = '1') then
			sFIFO_BURST_COUNT <= (others => '0');
		elsif(iWR_CLK'event and iWR_CLK = '1') then
			if(sPOS_WE = '1' and sBURST_READ = '0') then
				sFIFO_BURST_COUNT <= sFIFO_BURST_COUNT + 1;
			elsif(sPOS_WE = '0' and sBURST_READ = '1') then
				sFIFO_BURST_COUNT <= sFIFO_BURST_COUNT - 1;
			else
				sFIFO_BURST_COUNT <= sFIFO_BURST_COUNT;
			end if;			
		end if;
	end process;
	
	-- Read address generator --
	process(iWR_CLK, iRST) begin
		if(iRST = '1') then
			sPOS_X <= (others => '0');
			sPOS_Y <= (others => '0');
		elsif(iWR_CLK'event and iWR_CLK = '1') then
			if(sPOS_WE = '1') then
				if(sPOS_X = H_RESOLUTION/8 - 1) then
					sPOS_X <= (others => '0');
					if(sPOS_Y = V_RESOLUTION - 1) then
						sPOS_Y <= (others => '0');
					else
						sPOS_Y <= sPOS_Y + 1;
					end if;
				else
					sPOS_X <= sPOS_X + 1;
				end if;
			elsif(sPOS_CLR = '1') then
				sPOS_X <= (others => '0');
				sPOS_Y <= (others => '0');
			end if;
		end if;
	end process;
		
	-- Memory reader automate --
	process(iWR_CLK, iRST) begin
		if(iRST = '1') then
			sSTATE <= IDLE;
		elsif(iWR_CLK'event and iWR_CLK = '1') then
			sSTATE <= sNEXT_STATE;
		end if;
	end process;
	
	process(sSTATE, sFIFO_BURST_COUNT, iCMD_FULL, sFIFO_FULL, sFIFO_EMPTY, iDONE, iRD_EMPTY) begin
		case sSTATE is
			when IDLE =>
				if(sFIFO_FULL = '0' and iDONE = '1') then
					sNEXT_STATE <= SET_CMD;
				else
					sNEXT_STATE <= IDLE;
				end if;
				
			when SET_CMD =>
				if(iDONE = '0') then
					sNEXT_STATE <= WAIT_EMPTY;
				else
					sNEXT_STATE <= WAIT_UPDATE;
				end if;
			
			when WAIT_EMPTY =>
				if(iRD_EMPTY = '1' and sFIFO_EMPTY = '1') then
					sNEXT_STATE <= RST_ALL;
				else
					sNEXT_STATE <= WAIT_EMPTY;
				end if;
				
			when RST_ALL =>
				sNEXT_STATE <= IDLE;
				
			when WAIT_UPDATE =>
				sNEXT_STATE <= WAIT_DATA;
				
			when WAIT_DATA =>
				if(sFIFO_FULL = '1') then
					sNEXT_STATE <= WAIT_FIFO;
				else
					if(sFIFO_BURST_COUNT < 8 and iCMD_FULL ='0') then
						sNEXT_STATE <= SET_CMD;
					else
						sNEXT_STATE <= WAIT_DATA;
					end if;
				end if;
				
			when others =>
				if(sFIFO_FULL = '0') then
					sNEXT_STATE <= WAIT_DATA;
				else
					sNEXT_STATE <= WAIT_FIFO;
				end if;
				
		end case;
	end process;
	
	process(sSTATE) begin
		case sSTATE is
			when SET_CMD =>
				oCMD_EN <= '1';
				sPOS_WE <= '1';
				sFIFI_RD_EN_CLR <= '0';
				sPOS_CLR <= '0';
				
			when RST_ALL =>
				oCMD_EN <= '0';
				sPOS_WE <= '0';
				sFIFI_RD_EN_CLR <= '1';
				sPOS_CLR <= '1';
				
			when others =>
				oCMD_EN <= '0';
				sPOS_WE <= '0';
				sFIFI_RD_EN_CLR <= '0';
				sPOS_CLR <= '0';
				
		end case;
	end process;
	
	fifo : entity work.fif0
		port map(
		 rst => iRST,
		 wr_clk => iWR_CLK,
		 rd_clk => iRD_CLK,
		 din => iRD_DATA(23 downto 0),
		 wr_en => sFIFO_WR_EN,
		 rd_en => sCOMBINED_EN,
		 dout => oRGB,
		 full => open,
		 empty => sFIFO_EMPTY,
		 prog_full => sFIFO_FULL
  );
  
  
end Behavioral;

