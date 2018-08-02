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
			iCLK : in STD_LOGIC;										-- Input clock signal
			iRST : in STD_LOGIC;										-- Input reset signal
			iWR_DONE : in STD_LOGIC;								-- Input write done signal, to be delayed in this module
			iWR_EN : in STD_LOGIC;									-- Input write enable signal, to be delayed in this module
			iWR_ADDR : in  STD_LOGIC_VECTOR (3 downto 0);	-- Input write address, to be delayed in this module
			iRGB : in  STD_LOGIC_VECTOR (23 downto 0);		-- Input pixel value in RGB color space
			oWR_DONE : out STD_LOGIC;								-- Output of delayed input write done signal
			oWR_EN : out STD_LOGIC;									-- Output of delayed input write enable signal
			oWR_ADDR : out  STD_LOGIC_VECTOR (3 downto 0);	-- Output of delayed input write address signal
			oYUV : out  STD_LOGIC_VECTOR (23 downto 0)		-- Output pixel value in YUV color space
		);
		
end RGB_to_YUV;

architecture Behavioral of RGB_to_YUV is
	
	signal sWR_DONE_DELAY : STD_LOGIC_VECTOR (4 downto 0); -- Delayed signal of input write done signal
	signal sWR_EN_DELAY : STD_LOGIC_VECTOR (4 downto 0); -- Delayed signal of input write enable signal
	signal sWR_ADDR_DELAY : STD_LOGIC_VECTOR (19 downto 0); -- Delayed signal of input write address signal
	
begin
	
	calc_luma_y : entity work.calculate_yuv_components
	generic map
	(
		OUTPUT_COMPONENT => "Y"
	)
	port map
	(
		iCLK => iCLK, -- Clock signal
		iRGB => iRGB, -- Reset signal
		oCOMP => oYUV(23 downto 16) -- Y component 
	);
	
	calc_chroma_u : entity work.calculate_yuv_components
	generic map
	(
		OUTPUT_COMPONENT => "U"
	)
	port map
	(
		iCLK => iCLK, -- Clock signal
		iRGB => iRGB, -- Reset signal
		oCOMP => oYUV(15 downto 8) -- U component 
	);
	
	calc_chroma_v : entity work.calculate_yuv_components
	generic map
	(
		OUTPUT_COMPONENT => "V"
	)
	port map
	(
		iCLK => iCLK, -- Clock signal
		iRGB => iRGB, -- Reset signal
		oCOMP => oYUV(7 downto 0) -- V component 
	);
	
	-- 4 clock period delay register (shift register)
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

