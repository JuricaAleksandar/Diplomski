----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:31:52 06/26/2018 
-- Design Name: 
-- Module Name:    YUV_to_RGB - Behavioral 
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

entity YUV_to_RGB is
		Port
		(
			iCLK : in STD_LOGIC;
			iRST : in STD_LOGIC;
			iYUV : in  STD_LOGIC_VECTOR (23 downto 0);
			oRGB : out  STD_LOGIC_VECTOR (23 downto 0)
		);
end YUV_to_RGB;

architecture Behavioral of YUV_to_RGB is

begin

	

end Behavioral;

