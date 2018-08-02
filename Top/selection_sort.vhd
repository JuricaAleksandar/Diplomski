----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:30:15 06/04/2018 
-- Design Name: 
-- Module Name:    median_filter - Behavioral 
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

entity selection_sort is
	 Generic (SORT_TYPE : CHARACTER := 'U');
    Port ( iCLK : in  STD_LOGIC;
           iRST : in  STD_LOGIC;
           iWR_EN : in  STD_LOGIC;
           iWR_ADDR : in  STD_LOGIC_VECTOR (3 downto 0);
           iWR_DATA : in  STD_LOGIC_VECTOR (7 downto 0);
			  iSTART : in STD_LOGIC;
			  iRESTART : in STD_LOGIC;
           oDATA : out  STD_LOGIC_VECTOR (7 downto 0);
           oDATA_VALID : out  STD_LOGIC;
			  oREADY : out STD_LOGIC);
end selection_sort;

architecture Behavioral of selection_sort is

	type tFILTER_STATE is
	(
		IDLE,
		PREPARE,
		COMPARE,
		INC_IN_CNT,
		SET_NEW_MIN,
		SWAP1,
		SWAP2,
		SWAP3,
		INC_OUT_CNT,
		DONE
	);
	
	type tPIXEL_ARRAY is array (0 to 8) of STD_LOGIC_VECTOR (7 downto 0);

	signal sPIXEL_BUFFER : tPIXEL_ARRAY;
	signal sIN_LOOP_CNT : STD_LOGIC_VECTOR (3 downto 0);
	signal sOUT_LOOP_CNT : STD_LOGIC_VECTOR (2 downto 0);
	signal sIN_CNT_EN, sOUT_CNT_EN : STD_LOGIC;
	signal sSORT_CURRENT_STATE, sSORT_NEXT_STATE : tFILTER_STATE;
	signal sMIN_IND, sNEW_MIN_IND : STD_LOGIC_VECTOR (3 downto 0);
	signal sMIN_WR_EN : STD_LOGIC;
	signal sIN_CNT_CONTROL : STD_LOGIC;
	signal sSWAP_REG, sSWAP_REG_INPUT, sINPUT : STD_LOGIC_VECTOR (7 downto 0);
	signal sSWAP_REG_EN : STD_LOGIC;
	signal sPBUFF_IN_CONTROL : STD_LOGIC_VECTOR (1 downto 0);
	
begin
	
	U_SORT : if (SORT_TYPE = 'U') generate begin
		sINPUT <= iWR_DATA;
		oDATA <= sPIXEL_BUFFER(4);
	end generate U_SORT;
	
	S_SORT : if (SORT_TYPE = 'S') generate begin
		sINPUT <= iWR_DATA + 128;
		oDATA <= sPIXEL_BUFFER(4) - 128;
	end generate S_SORT;
	
	--- Pixel buffer
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sPIXEL_BUFFER <= (others => (others => '0'));
		elsif(iCLK'event and iCLK = '1') then
			if(sPBUFF_IN_CONTROL = "01") then
				sPIXEL_BUFFER(CONV_INTEGER(sOUT_LOOP_CNT)) <= sPIXEL_BUFFER(CONV_INTEGER(sMIN_IND));
			elsif(sPBUFF_IN_CONTROL = "10") then
				sPIXEL_BUFFER(CONV_INTEGER(sMIN_IND)) <= sSWAP_REG;
			elsif(sPBUFF_IN_CONTROL = "11") then
				if(iWR_EN = '1') then
					sPIXEL_BUFFER(CONV_INTEGER(iWR_ADDR)) <= sINPUT;
				end if;
			end if;
		end if;
	end process;
	
	--- Min element index register
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sMIN_IND <= (others => '0');
		elsif(iCLK'event and iCLK = '1') then
			if(sMIN_WR_EN = '1') then
				sMIN_IND <= sNEW_MIN_IND;
			end if;
		end if;
	end process;
	
	--- Loop counters
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sIN_LOOP_CNT <= (others => '0');
			sOUT_LOOP_CNT <= (others => '0');
		elsif(iCLK'event and iCLK = '1') then
			if(sOUT_CNT_EN = '1') then
				sOUT_LOOP_CNT <= sOUT_LOOP_CNT + 1;
			end if;
			
			if(sIN_CNT_EN = '1') then
				if(sIN_CNT_CONTROL = '1') then
					sIN_LOOP_CNT <= sIN_LOOP_CNT + 1;
				else
					sIN_LOOP_CNT <= ('0' & sOUT_LOOP_CNT) + 1;
				end if;
			end if;
		end if;
	end process;

	--- Swap register
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sSWAP_REG <= (others => '0');
		elsif(iCLK'event and iCLK = '1') then
			if(sSWAP_REG_EN = '1') then
				sSWAP_REG <= sSWAP_REG_INPUT;
			end if;
		end if;
	end process;

	--- Filter automate
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sSORT_CURRENT_STATE <= IDLE;
		elsif(iCLK'event and iCLK = '1') then
			sSORT_CURRENT_STATE <= sSORT_NEXT_STATE;
		end if;
	end process;

	process(sSORT_CURRENT_STATE, iSTART, iRESTART, sIN_LOOP_CNT, sOUT_LOOP_CNT, sPIXEL_BUFFER, sMIN_IND) begin
		case sSORT_CURRENT_STATE is
			when IDLE =>
				if(iSTART = '1') then
					sSORT_NEXT_STATE <= PREPARE;
				else
					sSORT_NEXT_STATE <= IDLE;
				end if;
				
			when PREPARE =>
				sSORT_NEXT_STATE <= COMPARE;
				
			when COMPARE =>
				if(sIN_LOOP_CNT < 9) then
					if(sPIXEL_BUFFER(CONV_INTEGER(sIN_LOOP_CNT)) < sPIXEL_BUFFER(CONV_INTEGER(sMIN_IND))) then
						sSORT_NEXT_STATE <= SET_NEW_MIN;
					else
						sSORT_NEXT_STATE <= INC_IN_CNT;
					end if;
				else
					if(sMIN_IND = ('0' & sOUT_LOOP_CNT)) then 
						sSORT_NEXT_STATE <= INC_OUT_CNT;
					else
						sSORT_NEXT_STATE <= SWAP1;
					end if;
				end if;
				
			when SET_NEW_MIN =>
				sSORT_NEXT_STATE <= INC_IN_CNT;
				
			when INC_IN_CNT =>
				sSORT_NEXT_STATE <= COMPARE;
				
			when SWAP1 =>
				sSORT_NEXT_STATE <= SWAP2;
				
			when SWAP2 =>
				sSORT_NEXT_STATE <= SWAP3;
			
			when SWAP3 =>
				sSORT_NEXT_STATE <= INC_OUT_CNT;
				
			when INC_OUT_CNT =>
				if(sOUT_LOOP_CNT < 7) then
					sSORT_NEXT_STATE <= PREPARE;
				else
					sSORT_NEXT_STATE <= DONE;
				end if;
			
			when others =>
				if(iRESTART = '1') then
					sSORT_NEXT_STATE <= IDLE;
				else
					sSORT_NEXT_STATE <= DONE;
				end if;
				
		end case;
	end process;

	process(sSORT_CURRENT_STATE, sOUT_LOOP_CNT, sIN_LOOP_CNT, sPIXEL_BUFFER) begin
		sOUT_CNT_EN <= '0';
		sIN_CNT_EN <= '0';
		sIN_CNT_CONTROL <= '1';
		sMIN_WR_EN <= '0';
		sNEW_MIN_IND <= (others => '0');		
		sPBUFF_IN_CONTROL <= "00";
		sSWAP_REG_EN <= '0';
		sSWAP_REG_INPUT <= (others => '0');
		oDATA_VALID <= '0';
		oREADY <= '0';
		
		case sSORT_CURRENT_STATE is
			when IDLE =>
				sPBUFF_IN_CONTROL <= "11";
				oREADY <= '1';
				
			when PREPARE =>
				sMIN_WR_EN <= '1';
				sNEW_MIN_IND <= '0' & sOUT_LOOP_CNT;
				sIN_CNT_CONTROL <= '0';
				sIN_CNT_EN <= '1';
				
			when COMPARE =>
				
			when SET_NEW_MIN =>
				sMIN_WR_EN <= '1';
				sNEW_MIN_IND <= sIN_LOOP_CNT;
				
			when INC_IN_CNT =>
				sIN_CNT_EN <= '1';
				
			when SWAP1 =>
				sSWAP_REG_EN <= '1';
				sSWAP_REG_INPUT <= sPIXEL_BUFFER(CONV_INTEGER(sOUT_LOOP_CNT));
				
			when SWAP2 =>
				sPBUFF_IN_CONTROL <= "01";
			
			when SWAP3 =>
				sPBUFF_IN_CONTROL <= "10";
			
			when INC_OUT_CNT =>
				sOUT_CNT_EN <= '1';
			
			when others =>
				oDATA_VALID <= '1';
				
		end case;
	end process;

end Behavioral;

