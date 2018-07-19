----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:21:49 06/26/2018 
-- Design Name: 
-- Module Name:    RGB_to_YUV - Behavioral 
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

entity RGB_to_YUV is
		Port
		(
			iCLK : in STD_LOGIC;
			iRST : in STD_LOGIC;
			iWR_DONE : in STD_LOGIC;
			iWR_EN : in STD_LOGIC;
			iWR_ADDR : in  STD_LOGIC_VECTOR (3 downto 0);
			iRGB : in  STD_LOGIC_VECTOR (23 downto 0);
			oWR_DONE : out STD_LOGIC;
			oWR_EN : out STD_LOGIC;
			oWR_ADDR : out  STD_LOGIC_VECTOR (3 downto 0);
			oYUV : out  STD_LOGIC_VECTOR (23 downto 0)
		);
		
end RGB_to_YUV;

architecture Behavioral of RGB_to_YUV is
	
	signal sWR_DONE_DELAY : STD_LOGIC_VECTOR (4 downto 0);
	signal sWR_EN_DELAY : STD_LOGIC_VECTOR (4 downto 0);
	signal sWR_ADDR_DELAY : STD_LOGIC_VECTOR (19 downto 0);
	
begin
	
	calc_luma_y : entity work.calculate_yuv_components
	generic map
	(
		OUTPUT_COMPONENT => "Y"
	)
	port map
	(
		iCLK => iCLK,
		iRGB => iRGB,
		oCOMP => oYUV(23 downto 16)
	);
	
	calc_chroma_u : entity work.calculate_yuv_components
	generic map
	(
		OUTPUT_COMPONENT => "U"
	)
	port map
	(
		iCLK => iCLK,
		iRGB => iRGB,
		oCOMP => oYUV(15 downto 8)
	);
	
	calc_chroma_v : entity work.calculate_yuv_components
	generic map
	(
		OUTPUT_COMPONENT => "V"
	)
	port map
	(
		iCLK => iCLK,
		iRGB => iRGB,
		oCOMP => oYUV(7 downto 0)
	);
	
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sWR_DONE_DELAY <= (others => '0');
			sWR_EN_DELAY <= (others => '0');
			sWR_ADDR_DELAY <= (others => '0');
		elsif(iCLK'event and iCLK = '1') then
			sWR_DONE_DELAY <= sWR_DONE_DELAY(3 downto 0) & iWR_DONE;
			sWR_EN_DELAY <= sWR_EN_DELAY(3 downto 0) & iWR_EN;
			sWR_ADDR_DELAY <= sWR_ADDR_DELAY(15 downto 0) & iWR_ADDR;
		end if;
	end process;
	
	oWR_DONE <= sWR_DONE_DELAY(4);
	oWR_EN <= sWR_EN_DELAY(4);
	oWR_ADDR <= sWR_ADDR_DELAY(19 downto 16);
	
end Behavioral;

