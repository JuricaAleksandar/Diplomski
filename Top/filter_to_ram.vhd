----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:22:24 06/11/2018 
-- Design Name: 
-- Module Name:    filter_to_ram - Behavioral 
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

entity filter_to_ram is
    Port ( iCLK : in  STD_LOGIC;
           iRST : in  STD_LOGIC;
			  oWR_CMD : out STD_LOGIC;
			  iDATA_VALID : in STD_LOGIC_VECTOR (2 downto 0);
			  iDATA : in STD_LOGIC_VECTOR (23 downto 0);
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
end filter_to_ram;

architecture Behavioral of filter_to_ram is
	
	type tSTATE is
	(
		IDLE,
		ADD_TO_FIFO,
		SET_CMD,
		DONE
	);

	signal sSTATE, sNEXT_STATE : tSTATE;
	signal sPOS_X : STD_LOGIC_VECTOR (3 downto 0);
	signal sPOS_Y : STD_LOGIC_VECTOR (8	downto 0);
	signal sPOS_EN : STD_LOGIC;
	signal sDATA_VALID_REG : STD_LOGIC_VECTOR (2 downto 0);
	signal sREG_CLR : STD_LOGIC;
	
begin
	
	oCMD_BYTE_ADDR <= "0000000" & sPOS_Y & "001" & sPOS_X & "0000000";
	oCMD_INSTR <= (others => '0');
	oCMD_BL <= (5 => '0', others => '1');
	oWR_MASK <= (others => '0');
	oWR_DATA <= (7 downto 0 => '0') & iDATA;
	
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sDATA_VALID_REG <= (others => '0');
		elsif(iCLK'event and iCLK = '1') then
			if(sREG_CLR = '0') then
				if(iDATA_VALID(0) = '1') then
					sDATA_VALID_REG(0) <= '1';
				end if;
				if(iDATA_VALID(1) = '1') then
					sDATA_VALID_REG(1) <= '1';
				end if;
				if(iDATA_VALID(2) = '1') then
					sDATA_VALID_REG(2) <= '1';
				end if;
			else
				sDATA_VALID_REG <= (others => '0');
			end if;
		end if;
	end process;
	
	--- RAM address generator
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sPOS_X <= (others => '0');
			sPOS_Y <= (others => '0');
		elsif(iCLK'event and iCLK = '1') then
			if(sPOS_EN = '1') then
				sPOS_X <= sPOS_X + 1;
				if(sPOS_X = 15) then
					sPOS_Y <= sPOS_Y + 1;
				end if;
			end if;
		end if;
	end process;
	
	--- FSM register
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sSTATE <= IDLE;
		elsif(iCLK'event and iCLK = '1') then
			sSTATE <= sNEXT_STATE;
		end if;
	end process;

	process(sSTATE, sDATA_VALID_REG, iWR_COUNT, sPOS_X, sPOS_Y) begin
		case sSTATE is
			when IDLE =>
				if(sDATA_VALID_REG = "111") then
					sNEXT_STATE <= ADD_TO_FIFO;
				else
					sNEXT_STATE <= IDLE;
				end if;
				
			when ADD_TO_FIFO =>
				if(iWR_COUNT = 31) then
					sNEXT_STATE <= SET_CMD;
				else
					sNEXT_STATE <= IDLE;
				end if;
			
			when SET_CMD =>
				if(sPOS_X = 15 and sPOS_Y = 511) then
					sNEXT_STATE <= DONE;
				else
					sNEXT_STATE <= IDLE;
				end if;
			
			when others =>
				sNEXT_STATE <= DONE;
			
		end case;
	end process;
	
	process(sSTATE) begin
		oCMD_EN <= '0';
		oDONE <= '0';
		sPOS_EN <= '0';
		oWR_EN <= '0';
		sREG_CLR <= '0';
		oWR_CMD <= '0';
				
		case sSTATE is
			when IDLE =>
			
			when ADD_TO_FIFO =>
				sREG_CLR <= '1';
				oWR_EN <= '1';
				
			when SET_CMD =>
				oCMD_EN <= '1';
				sPOS_EN <= '1';
				oWR_CMD <= '1';
			
			when others =>
				oDONE <= '1';
			
		end case;
	end process;

end Behavioral;

