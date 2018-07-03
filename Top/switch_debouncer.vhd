----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:40:29 07/02/2018 
-- Design Name: 
-- Module Name:    switch_debouncer - Behavioral 
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

entity switch_debouncer is
    Port ( iCLK : in  STD_LOGIC;
           iRST : in  STD_LOGIC;
           iMODE : in  STD_LOGIC_VECTOR (1 downto 0);
           iSPLIT_SCREEN : in  STD_LOGIC;
           oMODE : out  STD_LOGIC_VECTOR (1 downto 0);
           oSPLIT_SCREEN : out  STD_LOGIC
			);
end switch_debouncer;

architecture Behavioral of switch_debouncer is
	
	type t2BIT_FF is array (0 to 2) of STD_LOGIC_VECTOR(1 downto 0);
	
	signal sMODE_FF : t2BIT_FF;
	signal sMODE_COUNTER : STD_LOGIC_VECTOR (19 downto 0);
	signal sMODE_SET : STD_LOGIC;
	
	signal sSS_FF : STD_LOGIC_VECTOR (2 downto 0);
	signal sSS_COUNTER : STD_LOGIC_VECTOR (19 downto 0);
	signal sSS_SET : STD_LOGIC;
	
begin
	
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sMODE_COUNTER <= (others => '0');
			sMODE_SET <= '0';
		elsif(iCLK'event and iCLK = '1') then
			if(sMODE_SET = '0') then
				if((sMODE_FF(0) /= sMODE_FF(1))) then
					sMODE_COUNTER <= (others => '0');
				elsif(sMODE_COUNTER = (19 downto 0 => '1')) then
					sMODE_SET <= '1';
				end if;
				sMODE_COUNTER <= sMODE_COUNTER + 1;
			elsif ((sMODE_FF(0) /= sMODE_FF(1))) then
				sMODE_SET <= '0';
			end if;
		end if;
	end process;
	
	process(iCLK) begin
		if(iCLK'event and iCLK = '1') then
			sMODE_FF(0) <= iMODE;
			sMODE_FF(1) <= sMODE_FF(0);
			if(sMODE_SET = '1') then
				sMODE_FF(2) <= sMODE_FF(1);
			end if;
		end if;
	end process;
	
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sSS_COUNTER <= (others => '0');
			sSS_SET <= '0';
		elsif(iCLK'event and iCLK = '1') then
			if(sSS_SET = '0') then
				if((sSS_FF(0) /= sSS_FF(1))) then
					sSS_COUNTER <= (others => '0');
				elsif(sSS_COUNTER = (19 downto 0 => '1')) then
					sSS_SET <= '1';
				end if;
				sSS_COUNTER <= sSS_COUNTER + 1;
			elsif((sSS_FF(0) /= sSS_FF(1))) then
				sSS_SET <= '0';
			end if;
		end if;
	end process;
	
	process(iCLK) begin
		if(iCLK'event and iCLK = '1') then
			sSS_FF(0) <= iSPLIT_SCREEN;
			sSS_FF(1) <= sSS_FF(0);
			if(sSS_SET = '1') then
				sSS_FF(2) <= sSS_FF(1);
			end if;
		end if;
	end process;
	
	oMODE <= sMODE_FF(2);
	oSPLIT_SCREEN <= sSS_FF(2);
	
end Behavioral;

