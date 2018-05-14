----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:44:20 04/13/2018 
-- Design Name: 
-- Module Name:    vgaSync - Behavioral 
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity vgaSync is
    Port ( iCLK : in  STD_LOGIC;
           inRST : in  STD_LOGIC;
           oPIXEL_X : out  STD_LOGIC_VECTOR (10 downto 0);
           oPIXEL_Y : out  STD_LOGIC_VECTOR (10 downto 0);
           oVIDEO_ON : out  STD_LOGIC;
			  oH_SYNC : out STD_LOGIC;
			  oV_SYNC : out STD_LOGIC);
end vgaSync;

architecture Behavioral of vgaSync is

	constant cH_DISPLAY : natural := 1024;
	constant cH_FP : natural := 24;
	constant cH_BP : natural := 160;
	constant cH_RETR : natural := 136;
	
	constant cV_DISPLAY : natural := 768;
	constant cV_FP : natural := 3;
	constant cV_BP : natural := 29;
	constant cV_RETR : natural := 6;

	signal sH_COUNT, sH_COUNT_NEXT : STD_LOGIC_VECTOR (10 downto 0);
	signal sV_COUNT, sV_COUNT_NEXT : STD_LOGIC_VECTOR (10 downto 0);
	
	signal sH_SYNC, sH_SYNC_NEXT : STD_LOGIC;
	signal sV_SYNC, sV_SYNC_NEXT : STD_LOGIC;
	
	signal sVIDEO_ON, sVIDEO_ON_NEXT : STD_LOGIC;
	
begin

--	process(iCLK, inRST) begin
--		if(inRST = '0') then
--			sH_COUNT_NEXT <= (others => '0');
--		elsif(iCLK'event and iCLK ='1') then
--			if(sH_COUNT_NEXT = cH_DISPLAY + cH_FP + cH_BP + cH_RETR - 1) then
--				sH_COUNT_NEXT <= (others => '0');
--			else
--				sH_COUNT_NEXT <= sH_COUNT_NEXT + 1;
--			end if;
--		end if;
--	end process;
--
--	process(iCLK,inRST) begin
--		if(inRST = '0') then
--			sV_COUNT_NEXT <= (others => '0');
--		elsif(iCLK'event and iCLK ='1') then
--			if(sH_COUNT_NEXT = cH_DISPLAY + cH_FP + cH_BP + cH_RETR - 1) then
--				sV_COUNT_NEXT <= sV_COUNT_NEXT + 1;
--			elsif(sV_COUNT_NEXT = cV_DISPLAY + cV_FP + cV_BP + cV_RETR - 1) then
--				sV_COUNT_NEXT <= (others => '0');
--			end if;
--		end if;
--	end process;
	
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

	sH_SYNC_NEXT <= '0' when (sH_COUNT_NEXT >= cH_DISPLAY + cH_FP and sH_COUNT_NEXT < cH_DISPLAY + cH_FP + cH_RETR)
					else '1';
					
	sV_SYNC_NEXT <= '0' when (sV_COUNT_NEXT >= cV_DISPLAY + cV_FP and sV_COUNT_NEXT < cV_DISPLAY + cV_FP + cV_RETR)
					else '1';			

	sVIDEO_ON_NEXT <= '1' when (sH_COUNT_NEXT < cH_DISPLAY and sV_COUNT_NEXT < cV_DISPLAY)
					else '0';
					
	process(iCLK,inRST) begin
		if(inRST = '0') then
			sH_COUNT <= (others => '0');
			sV_COUNT <= (others => '0');
			sH_SYNC <= '1';
			sV_SYNC <= '1';
			sVIDEO_ON <= '0';
		elsif(iCLK'event and iCLK = '1') then
			sH_COUNT <= sH_COUNT_NEXT;
			sV_COUNT <= sV_COUNT_NEXT;
			sH_SYNC <= sH_SYNC_NEXT;
			sV_SYNC <= sV_SYNC_NEXT;
			sVIDEO_ON <= sVIDEO_ON_NEXT;
		end if;
	end process;

	oPIXEL_X <= sH_COUNT;
	oPIXEL_Y <= sV_COUNT;
	oVIDEO_ON <= sVIDEO_ON;
	oH_SYNC <= sH_SYNC;
	oV_SYNC <= sV_SYNC;

end Behavioral;

