----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:44:20 04/13/2018 
-- Design Name: 
-- Module Name:    vga_sync - Behavioral 
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

entity vga_sync is
    Port ( iCLK : in  STD_LOGIC;										-- Input clock signal
           inRST : in  STD_LOGIC;									-- Input reset signal
			  iSPLIT_SCREEN : in STD_LOGIC;							-- Input split screen indication signal
           oPIXEL_X : out  STD_LOGIC_VECTOR (10 downto 0);	-- Horizontal pixel counter output
           oPIXEL_Y : out  STD_LOGIC_VECTOR (10 downto 0);	-- Vertical pixel counter output
           oVIDEO_ON_DELAY : out  STD_LOGIC;						-- Delayed video on(blanking) signal output 
			  oVIDEO_ON : out STD_LOGIC;								-- Video on(blanking) signal output 
			  oH_SYNC : out STD_LOGIC;									-- Horizontal VGA synchronization signal
			  oV_SYNC : out STD_LOGIC);								-- Vertical VGA synchronization signal
end vga_sync;

architecture Behavioral of vga_sync is

	constant cH_DISPLAY : natural := 1024;							-- Horizontal display size
	constant cH_FP : natural := 24;									-- Horizontal front porch size
	constant cH_BP : natural := 160;									-- Horizontal back porch size
	constant cH_RETR : natural := 136;								-- Horizontal retrace size
	
	constant cV_DISPLAY : natural := 768;							-- Vertical display size
	constant cV_FP : natural := 3;									-- Vertical front porch size
	constant cV_BP : natural := 29;									-- Vertical back porch size
	constant cV_RETR : natural := 6;									-- Vertical retrace size

	signal sH_COUNT, sH_COUNT_NEXT : STD_LOGIC_VECTOR (10 downto 0);	-- Horizontal pixel counters
	signal sV_COUNT, sV_COUNT_NEXT : STD_LOGIC_VECTOR (10 downto 0);	-- Vertical pixel counters
	
	signal sH_SYNC : STD_LOGIC;										-- Horizontal synchronization signal
	signal sV_SYNC : STD_LOGIC;										-- Vertical synchronization signal
	
	signal sVIDEO_ON, sVIDEO_ON_DELAY : STD_LOGIC;				-- Video on(blanking) signals, current and one-cycle delayed
	
	signal sSPLIT_SCREEN_VIDEO_ON, sSINGLE_IMAGE_VIDEO_ON : STD_LOGIC;	-- Split screen and signle image display mode indicator signals
	
begin
	
	-- Horizontal and vertical counter logic
	process(iCLK, inRST) begin
		if(inRST = '0') then
			sH_COUNT_NEXT <= (others => '0');
			sV_COUNT_NEXT <= (others => '0');
		elsif(iCLK'event and iCLK ='1') then
			if(sH_COUNT_NEXT = cH_DISPLAY + cH_FP + cH_BP + cH_RETR - 1) then
				sH_COUNT_NEXT <= (others => '0');
				if(sV_COUNT_NEXT = cV_DISPLAY + cV_FP + cV_BP + cV_RETR - 1) then
					sV_COUNT_NEXT <= (others => '0');
				else
					sV_COUNT_NEXT <= sV_COUNT_NEXT + 1;
				end if;
			else
				sH_COUNT_NEXT <= sH_COUNT_NEXT + 1;
			end if;
		end if;
	end process;
	
	-- Horizontal synchronization signal logic
	sH_SYNC <= '0' when (sH_COUNT_NEXT > cH_DISPLAY + cH_FP and sH_COUNT_NEXT <= cH_DISPLAY + cH_FP + cH_RETR)
					else '1';
	
	-- Vertical synchronization signal logic
	sV_SYNC <= '0' when (sV_COUNT_NEXT > cV_DISPLAY + cV_FP and sV_COUNT_NEXT <= cV_DISPLAY + cV_FP + cV_RETR)
					else '1';			

	-- Single image video on signal logic for displaying 512x512 image(centered) 
	sSINGLE_IMAGE_VIDEO_ON <= '1' when (sH_COUNT_NEXT < cH_DISPLAY/2 + 256 and sH_COUNT_NEXT >= cH_DISPLAY/2 - 256 and sV_COUNT_NEXT < cV_DISPLAY/2 + 256 and sV_COUNT_NEXT >= cV_DISPLAY/2 - 256)
					else '0';
	
	-- Split screen video on signal logic for displaying two 512x512 images side by side
	sSPLIT_SCREEN_VIDEO_ON <= '1' when (sH_COUNT_NEXT < cH_DISPLAY and sV_COUNT_NEXT < cV_DISPLAY/2 + 256 and sV_COUNT_NEXT >= cV_DISPLAY/2 - 256)
					else '0';		
					
	-- Selected video on signal, dependant on state of split screen signal
	sVIDEO_ON <= sSINGLE_IMAGE_VIDEO_ON when iSPLIT_SCREEN = '0'
		else sSPLIT_SCREEN_VIDEO_ON;
		
	
	process(iCLK,inRST) begin
		if(inRST = '0') then
			sH_COUNT <= (others => '0');
			sV_COUNT <= (others => '0');
			sVIDEO_ON_DELAY <= '0';
		elsif(iCLK'event and iCLK = '1') then
			sH_COUNT <= sH_COUNT_NEXT;
			sV_COUNT <= sV_COUNT_NEXT;
			sVIDEO_ON_DELAY <= sVIDEO_ON;
		end if;
	end process;

	-- Module output signal assignment
	oPIXEL_X <= sH_COUNT;
	oPIXEL_Y <= sV_COUNT;
	oVIDEO_ON_DELAY <= sVIDEO_ON_DELAY;
	oVIDEO_ON <= sVIDEO_ON;
	oH_SYNC <= sH_SYNC;
	oV_SYNC <= sV_SYNC;

end Behavioral;

