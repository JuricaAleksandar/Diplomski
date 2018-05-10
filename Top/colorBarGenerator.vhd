----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:15:49 05/10/2018 
-- Design Name: 
-- Module Name:    colorBarGenerator - Behavioral 
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

entity colorBarGenerator is
    Port ( iCLK : in  STD_LOGIC;
           inRST : in  STD_LOGIC;
			  oDONE : out STD_LOGIC;
           oCMD_EN : out  STD_LOGIC;
           oCMD_INSTR : out  STD_LOGIC_VECTOR (2 downto 0);
           oCMD_BL : out  STD_LOGIC_VECTOR (5 downto 0);
           oCMD_BYTE_ADDR : out  STD_LOGIC_VECTOR (29 downto 0);
           iCMD_EMPTY : in  STD_LOGIC;
           iCMD_FULL : in  STD_LOGIC;
           oWR_EN : out  STD_LOGIC;
           oWR_MASK : out  STD_LOGIC_VECTOR (3 downto 0);
           oWR_DATA : out  STD_LOGIC_VECTOR (31 downto 0);
           iWR_FULL : in  STD_LOGIC;
           iWR_EMPTY : in  STD_LOGIC;
           iWR_COUNT : in  STD_LOGIC_VECTOR (6 downto 0);
           iWR_UNDERRUN : in  STD_LOGIC;
           iWR_ERROR : in  STD_LOGIC);
end colorBarGenerator;

architecture Behavioral of colorBarGenerator is

	type tGEN_STATE is (IDLE, SET_DATA, NOP, SET_CMD, DONE);
	signal sSTATE, sNEXT_STATE : tGEN_STATE;
	signal sCOUNT : integer range 0 to 70;
	signal sPOS_X : STD_LOGIC_VECTOR (10 downto 0);
	signal sPOS_Y : STD_LOGIC_VECTOR (9 downto 0);
	signal sRGB : STD_LOGIC_VECTOR (23 downto 0);
	signal sWE : STD_LOGIC;
	signal sEN : STD_LOGIC;

begin

	process(iCLK, inRST) begin
		if(inRST = '0') then
			sCOUNT <= 0;
		elsif(iCLK'event and iCLK = '1') then
			if(sEN = '1') then
				sCOUNT <= sCOUNT + 1;
			else
				sCOUNT <= 0;
			end if;
		end if;
	end process;

	process(iCLK, inRST) begin
		if(inRST = '0') then
			sPOS_X <= (others => '0');
			sPOS_Y <= (others => '0');
		elsif(iCLK'event and iCLK = '1') then
			if(sWE = '1') then
				sPOS_X <= sPOS_X + 64;
				if(sPOS_X = 1024) then
					sPOS_Y <= sPOS_Y + 1;
					sPOS_X <= (others => '0');
				end if;
			end if;
		end if;
	end process;

	process(iCLK, inRST) begin
		if(inRST = '0') then
			sSTATE <= IDLE;
		elsif(iCLK'event and iCLK = '1') then
			sSTATE <= sNEXT_STATE;
		end if;
	end process;

	process(sSTATE, sCOUNT, iWR_EMPTY, sPOS_Y) begin
		case sSTATE is
			when IDLE =>
				if(iWR_EMPTY = '1') then
					sNEXT_STATE <= SET_DATA;
				else
					sNEXT_STATE <= IDLE;
				end if;
			when SET_DATA =>
				if (sCOUNT = 64) then
					sNEXT_STATE <= NOP;
				else
					sNEXT_STATE <= SET_DATA;
				end if;
			when NOP =>
				sNEXT_STATE <= SET_CMD;
			when SET_CMD =>
				if(sPOS_Y < 768) then
					sNEXT_STATE <= IDLE;
				else
					sNEXT_STATE <= DONE;
				end if;
			when others =>
				sNEXT_STATE <= DONE;
		end case;
	end process;

	process(sSTATE) begin
		case sSTATE is
			when IDLE =>
			  oDONE <= '0';
           oCMD_EN <= '0';
			  oWR_EN <= '0';
			  sWE <= '0';
			  sEN <= '0';
			  
			when SET_DATA =>
			  oDONE <= '0';
           oCMD_EN <= '0';
			  oWR_EN <= '1';
			  sWE <= '0';
			  sEN <= '1';
			
			when NOP =>
			  oDONE <= '0';
           oCMD_EN <= '0';
			  oWR_EN <= '0';
			  sWE <= '1';
			  sEN <= '0';
			  
			when SET_CMD =>
			  oDONE <= '0';
           oCMD_EN <= '1';
			  oWR_EN <= '0';
			  sWE <= '0';
			  sEN <= '0';
			  
			when others =>
			  oDONE <= '1';
           oCMD_EN <= '0';
			  oWR_EN <= '0';
			  sWE <= '0';
			  sEN <= '0';
			  
		end case;
	end process;

	sRGB <= (others => '1') when sPOS_X < 128
			else (23 downto 8 => '1', others => '0') when (sPOS_X >= 128 and sPOS_X < 256)
			else (15 downto 0 => '1', others => '0') when (sPOS_X >= 256 and sPOS_X < 384)
			else (15 downto 8 => '1', others => '0') when (sPOS_X >= 384 and sPOS_X < 512)
			else (23 downto 16 => '1', 7 downto 0 => '1', others => '0') when (sPOS_X >= 512 and sPOS_X < 640)
			else (23 downto 16 => '1', others => '0') when (sPOS_X >= 640 and sPOS_X < 768)
			else (7 downto 0 => '1', others => '0') when (sPOS_X >= 768 and sPOS_X < 896)
			else (23 downto 0 => '0');

	oCMD_BYTE_ADDR <= "000000" & sPOS_Y(9 downto 0) & "000" & sPOS_X(9 downto 0) & '0';
	oCMD_INSTR <= (others => '0');
	oCMD_BL <= (others => '1');
	oWR_MASK <= (others => '0');
	oWR_DATA <= (7 downto 0 => '0') & sRGB;

end Behavioral;

