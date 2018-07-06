----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:00:52 07/04/2018 
-- Design Name: 
-- Module Name:    lcd_controller - Behavioral 
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

entity lcd_controller is
	 Generic
	 (
		CLK_PERIOD : integer := 10; 				-- ns 
		COUNTER_WIDTH : integer := 21; 			-- 15.500.000 / CLK_PERIOD <= 2^COUNTER_WIDTH
		ENABLE_COUNTER_WIDTH : integer := 19 	-- 4301150 / CLK_PERIOD <= 2^ENABLE_COUNTER_WIDTH
	 ); 
    Port
	 (
		iCLK : in  STD_LOGIC;
		iRST : in  STD_LOGIC;
		iMODE : in  STD_LOGIC_VECTOR (1 downto 0);
		iSPLIT_SCREEN : in STD_LOGIC;
		oRS : out  STD_LOGIC;
		oRW : out  STD_LOGIC;
		oEN : out  STD_LOGIC;
		oL : out STD_LOGIC;
		oDATA : out  STD_LOGIC_VECTOR (3 downto 0)
	 );
	 
end lcd_controller;

architecture Behavioral of lcd_controller is

	type tINIT_SEQ_ROM is array(0 to 13) of STD_LOGIC_VECTOR(4 + ENABLE_COUNTER_WIDTH - 1 downto 0);
	type tDISPLAY_MEMORY is array(0 to 63) of STD_LOGIC_VECTOR(3 downto 0);
	type tLCD_STATE is 
	(
		POWER_ON,
		INITIALISATION,
		RST_ROM_ADDR,
		IDLE,
		SEND_LINE1,
		SET_DDRAM_ADDR1,
		SET_DDRAM_ADDR2,
		SEND_LINE2,
		SET_DDRAM_ADDR3,
		SET_DDRAM_ADDR4
	);
	
	constant cRS_SETUP_TIME : integer := 150/CLK_PERIOD;
	constant cENABLE_PULSE_WIDTH : integer := 400/CLK_PERIOD;
	constant cENABLE_PULSE_CYCLE_PERIOD : integer := 600/CLK_PERIOD;
	
	constant c15ms_WAIT_PERIOD : integer := 15500000/CLK_PERIOD;
	constant c4ms_WAIT_PERIOD : integer := 4300000/CLK_PERIOD;	
	constant c120us_WAIT_PERIOD : integer := 120000/CLK_PERIOD;
	constant c2ms_WAIT_PERIOD : integer := 1800000/CLK_PERIOD;
	constant c45us_WAIT_PERIOD : integer := 45000/CLK_PERIOD;
	
	constant cINIT_SEQ_ROM : tINIT_SEQ_ROM :=
	(
		"0011" & (ENABLE_COUNTER_WIDTH - 1 downto 0 => '0') + c4ms_WAIT_PERIOD,
		"0011" & (ENABLE_COUNTER_WIDTH - 1 downto 0 => '0') + c120us_WAIT_PERIOD,
		"0011" & (ENABLE_COUNTER_WIDTH - 1 downto 0 => '0') + c4ms_WAIT_PERIOD,
		"0010" & (ENABLE_COUNTER_WIDTH - 1 downto 0 => '0') + c45us_WAIT_PERIOD,
		"0010" & (ENABLE_COUNTER_WIDTH - 1 downto 0 => '0'),
		"1000" & (ENABLE_COUNTER_WIDTH - 1 downto 0 => '0') + c45us_WAIT_PERIOD,
		"0000" & (ENABLE_COUNTER_WIDTH - 1 downto 0 => '0'),
		"1000" & (ENABLE_COUNTER_WIDTH - 1 downto 0 => '0') + c45us_WAIT_PERIOD,
		"0000" & (ENABLE_COUNTER_WIDTH - 1 downto 0 => '0'),
		"0001" & (ENABLE_COUNTER_WIDTH - 1 downto 0 => '0') + c2ms_WAIT_PERIOD,
		"0000" & (ENABLE_COUNTER_WIDTH - 1 downto 0 => '0'),
		"0110" & (ENABLE_COUNTER_WIDTH - 1 downto 0 => '0') + c45us_WAIT_PERIOD,
		"0000" & (ENABLE_COUNTER_WIDTH - 1 downto 0 => '0'),
		"1100" & (ENABLE_COUNTER_WIDTH - 1 downto 0 => '0') + c45us_WAIT_PERIOD
	);
	
	signal sLCD_STATE, sLCD_NEXT_STATE : tLCD_STATE;
	signal sTEXT_ROM : tDISPLAY_MEMORY;
	
	signal sCNT_EN, sSEQ_EN : STD_LOGIC;
	signal sPWR_ON_COUNTER : STD_LOGIC_VECTOR (COUNTER_WIDTH - 1 downto 0);
	signal sENABLE_SEQUENCE : STD_LOGIC_VECTOR (1 downto 0);
	signal sENABLE_COUNTER, sINSTR_WAIT_TIME : STD_LOGIC_VECTOR (ENABLE_COUNTER_WIDTH - 1 downto 0);
	signal sENABLE : STD_LOGIC;
	signal sROM_ADDR : STD_LOGIC_VECTOR (5 downto 0);
	signal sROM_ADDR_RST, sROM_ADDR_EN : STD_LOGIC; 
	signal sMODE : STD_LOGIC_VECTOR (1 downto 0);
	signal sSPLIT_SCREEN : STD_LOGIC;
	signal sREWRITE : STD_LOGIC;
	signal sDONE : STD_LOGIC;
	
begin

	oRW <= '0';
	oL <= '1';
	
	process(iMODE,iSPLIT_SCREEN) begin
		sTEXT_ROM <=
	(
		--- M ---
		0 => "0100",
		1 => "1101",
		--- o ---
		2 => "0110",
		3 => "1111",
		--- d ---
		4 => "0110",
		5 => "0100",
		--- e ---
		6 => "0110",
		7 => "0101",
		--- : ---
		8 => "0011",
		9 => "1010",
		--- blank ---
		22 => "0010",
		23 => "0000",
		24 => "0010",
		25 => "0000",
		26 => "0010",
		27 => "0000",
		28 => "0010",
		29 => "0000",
		30 => "0010",
		31 => "0000",
		--- S ---
		32 => "0101",
		33 => "0011",
		--- p ---
		34 => "0111",
		35 => "0000",
		--- l ---
		36 => "0110",
		37 => "1100",
		--- i ---
		38 => "0110",
		39 => "1001",
		--- t ---
		40 => "0111",
		41 => "0100",
		--- - ---
		42 => "0010",
		43 => "1101",
		--- s ---
		44 => "0111",
		45 => "0011",
		--- c ---
		46 => "0110",
		47 => "0011",
		--- r ---
		48 => "0111",
		49 => "0010",
		--- e ---
		50 => "0110",
		51 => "0101",
		--- e ---
		52 => "0110",
		53 => "0101",
		--- n ---
		54 => "0110",
		55 => "1110",
		--- : ---
		56 => "0011",
		57 => "1010",
		others => "0000"
	);
		case iMODE is
			when "00" =>
				--- D ---
				sTEXT_ROM(10) <= "0100";
				sTEXT_ROM(11) <= "0100";
				--- i ---
				sTEXT_ROM(12) <= "0110";
				sTEXT_ROM(13) <= "1001";
				--- r ---
				sTEXT_ROM(14) <= "0111";
				sTEXT_ROM(15) <= "0010";
				--- e ---
				sTEXT_ROM(16) <= "0110";
				sTEXT_ROM(17) <= "0101";
				--- c ---
				sTEXT_ROM(18) <= "0110";
				sTEXT_ROM(19) <= "0011";
				--- t ---
				sTEXT_ROM(20) <= "0111";
				sTEXT_ROM(21) <= "0100";
				
			when "01" =>
				--- 1 ---
				sTEXT_ROM(10) <= "0011";
				sTEXT_ROM(11) <= "0001";
				--- x ---
				sTEXT_ROM(12) <= "0111";
				sTEXT_ROM(13) <= "1000";
				--- 9 ---
				sTEXT_ROM(14) <= "0011";
				sTEXT_ROM(15) <= "1001";
				--- blank ---
				sTEXT_ROM(16) <= "0010";
				sTEXT_ROM(17) <= "0000";
				sTEXT_ROM(18) <= "0010";
				sTEXT_ROM(19) <= "0000";
				sTEXT_ROM(20) <= "0010";
				sTEXT_ROM(21) <= "0000";
				
			when "10" =>
				--- 9 ---
				sTEXT_ROM(10) <= "0011";
				sTEXT_ROM(11) <= "1001";
				--- x ---
				sTEXT_ROM(12) <= "0111";
				sTEXT_ROM(13) <= "1000";
				--- 1 ---
				sTEXT_ROM(14) <= "0011";
				sTEXT_ROM(15) <= "0001";
				--- blank ---
				sTEXT_ROM(16) <= "0010";
				sTEXT_ROM(17) <= "0000";
				sTEXT_ROM(18) <= "0010";
				sTEXT_ROM(19) <= "0000";
				sTEXT_ROM(20) <= "0010";
				sTEXT_ROM(21) <= "0000";

			when others =>
				--- 3 ---
				sTEXT_ROM(10) <= "0011";
				sTEXT_ROM(11) <= "0011";
				--- x ---
				sTEXT_ROM(12) <= "0111";
				sTEXT_ROM(13) <= "1000";
				--- 3 ---
				sTEXT_ROM(14) <= "0011";
				sTEXT_ROM(15) <= "0011";
				--- blank ---
				sTEXT_ROM(16) <= "0010";
				sTEXT_ROM(17) <= "0000";
				sTEXT_ROM(18) <= "0010";
				sTEXT_ROM(19) <= "0000";
				sTEXT_ROM(20) <= "0010";
				sTEXT_ROM(21) <= "0000";
				
		end case;
		
		case iSPLIT_SCREEN is
			when '0' =>
				--- O ---
				sTEXT_ROM(58) <= "0100";
				sTEXT_ROM(59) <= "1111";
				--- f ---
				sTEXT_ROM(60) <= "0110";
				sTEXT_ROM(61) <= "0110";
				--- f ---
				sTEXT_ROM(62) <= "0110";
				sTEXT_ROM(63) <= "0110";
				
			when others =>
				--- O ---
				sTEXT_ROM(58) <= "0100";
				sTEXT_ROM(59) <= "1111";
				--- n ---
				sTEXT_ROM(60) <= "0110";
				sTEXT_ROM(61) <= "1110";
				--- blank ---
				sTEXT_ROM(62) <= "0010";
				sTEXT_ROM(63) <= "0000";
				
		end case;
	end process;
	
	--- Input change detection ---
	process(iCLK) begin
		if(iCLK'event and iCLK = '1') then
			sMODE <= iMODE;
			sSPLIT_SCREEN <= iSPLIT_SCREEN;
		end if;
	end process;
	
	process(iCLK) begin
		if(iCLK'event and iCLK = '1') then
			if(sMODE /= iMODE or sSPLIT_SCREEN /= iSPLIT_SCREEN) then
				sREWRITE <= '1';
			elsif(sDONE = '1') then
				sREWRITE <= '0';
			end if;
		end if;
	end process;
	
	--- ROM address generator ---
	process(iCLK) begin
		if(iCLK'event and iCLK = '1') then
			if(sROM_ADDR_RST = '1') then
				sROM_ADDR <= (others => '0');
			elsif(sENABLE_SEQUENCE = "11" and sROM_ADDR_EN = '1') then
				sROM_ADDR <= sROM_ADDR + 1;
			end if;
		end if;
	end process;
	
	--- Instruction sending sequence ---
	process(iCLK) begin
		if(iCLK'event and iCLK = '1') then
			if(sSEQ_EN = '1') then
				sENABLE_COUNTER <= sENABLE_COUNTER + 1;
				if(sENABLE_COUNTER < cENABLE_PULSE_WIDTH) then
					sENABLE <= '1';
					sENABLE_SEQUENCE <= "00";
				elsif(sENABLE_COUNTER < cENABLE_PULSE_WIDTH + cENABLE_PULSE_CYCLE_PERIOD) then
					sENABLE <= '0';
					sENABLE_SEQUENCE <= "01";
				elsif(sENABLE_COUNTER < cENABLE_PULSE_WIDTH + cENABLE_PULSE_CYCLE_PERIOD + sINSTR_WAIT_TIME) then
					sENABLE <= '0';
					sENABLE_SEQUENCE <= "10";
				else
					sENABLE <= '0';
					sENABLE_SEQUENCE <= "11";
					sENABLE_COUNTER <= (others => '0');
				end if;
			else
				sENABLE <= '0';
				sENABLE_SEQUENCE <= "00";
				sENABLE_COUNTER <= (others => '0');
			end if;
		end if;
	end process;
	
	--- Power on timer ---
	process(iCLK) begin
		if(iCLK'event and iCLK = '1') then
			if(sCNT_EN = '1') then
				sPWR_ON_COUNTER <= sPWR_ON_COUNTER + 1;
			end if;
		end if;
	end process;
	
	--- FSM register --- 
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sLCD_STATE <= POWER_ON;
		elsif(iCLK'event and iCLK = '1') then
			sLCD_STATE <= sLCD_NEXT_STATE;
		end if;
	end process;

	--- FSM transition logic ---
	process(sLCD_STATE, sPWR_ON_COUNTER, sENABLE_SEQUENCE, sROM_ADDR, sREWRITE) begin
		case sLCD_STATE is
			when POWER_ON =>
				if(sPWR_ON_COUNTER < c15ms_WAIT_PERIOD) then
					sLCD_NEXT_STATE <= POWER_ON;
				else
					sLCD_NEXT_STATE <= INITIALISATION;
				end if;
				
			when INITIALISATION =>
				if(sROM_ADDR = 13 and sENABLE_SEQUENCE = "11") then
					sLCD_NEXT_STATE <= RST_ROM_ADDR;
				else
					sLCD_NEXT_STATE <= INITIALISATION;
				end if;
			
			when RST_ROM_ADDR =>
				sLCD_NEXT_STATE <= SEND_LINE1;
				
			when SEND_LINE1 =>
				if(sROM_ADDR = 31 and sENABLE_SEQUENCE = "11") then
					sLCD_NEXT_STATE <= SET_DDRAM_ADDR1;
				else
					sLCD_NEXT_STATE <= SEND_LINE1;
				end if;
				
			when SET_DDRAM_ADDR1 =>
				if(sENABLE_SEQUENCE = "11") then
					sLCD_NEXT_STATE <= SET_DDRAM_ADDR2;
				else
					sLCD_NEXT_STATE <= SET_DDRAM_ADDR1;
				end if;
			
			when SET_DDRAM_ADDR2 =>
				if(sENABLE_SEQUENCE = "11") then
					sLCD_NEXT_STATE <= SEND_LINE2;
				else
					sLCD_NEXT_STATE <= SET_DDRAM_ADDR2;
				end if;
			
			when SEND_LINE2 =>
				if(sROM_ADDR = 63 and sENABLE_SEQUENCE = "11") then
					sLCD_NEXT_STATE <= SET_DDRAM_ADDR3;
				else
					sLCD_NEXT_STATE <= SEND_LINE2;
				end if;
				
			when SET_DDRAM_ADDR3 =>
				if(sENABLE_SEQUENCE = "11") then
					sLCD_NEXT_STATE <= SET_DDRAM_ADDR4;
				else
					sLCD_NEXT_STATE <= SET_DDRAM_ADDR3;
				end if;
			
			when SET_DDRAM_ADDR4 =>
				if(sENABLE_SEQUENCE = "11") then
					sLCD_NEXT_STATE <= IDLE;
				else
					sLCD_NEXT_STATE <= SET_DDRAM_ADDR4;
				end if;
			
			when IDLE =>
				if(sREWRITE = '1') then
					sLCD_NEXT_STATE <= SEND_LINE1;
				else
					sLCD_NEXT_STATE <= IDLE;
				end if;
			
		end case;
	end process;

	--- FSM output logic ---
	process(sLCD_STATE, sENABLE, sROM_ADDR, sTEXT_ROM) begin
		sCNT_EN <= '0';
		oRS <= '0';
		oEN <= '0';
		sSEQ_EN <= '1';
		sINSTR_WAIT_TIME <= (others => '0');
		sROM_ADDR_RST <= '1';
		sROM_ADDR_EN <= '0';
		sDONE <= '0';
		
		case sLCD_STATE is
			when POWER_ON =>
				sCNT_EN <= '1';
				oDATA <= "0000";
				sSEQ_EN <= '0';
				
			when INITIALISATION =>
				oDATA <= cINIT_SEQ_ROM(CONV_INTEGER(sROM_ADDR))(4 + ENABLE_COUNTER_WIDTH - 1 downto ENABLE_COUNTER_WIDTH);
				oEN <= sENABLE;
				sINSTR_WAIT_TIME <= cINIT_SEQ_ROM(CONV_INTEGER(sROM_ADDR))(ENABLE_COUNTER_WIDTH - 1 downto 0);
				sROM_ADDR_EN <= '1';
				sROM_ADDR_RST <= '0';
				
			when RST_ROM_ADDR =>
				oDATA <= "0000";
				sSEQ_EN <= '0';
				sROM_ADDR_EN <= '1';
			
			when SEND_LINE1|SEND_LINE2 =>
				oDATA <= sTEXT_ROM(CONV_INTEGER(sROM_ADDR));
				oEN <= sENABLE;
				oRS <= '1';
				sINSTR_WAIT_TIME <= (ENABLE_COUNTER_WIDTH - 1 downto 0 => '0') + c45us_WAIT_PERIOD;
				sROM_ADDR_RST <= '0';
				sROM_ADDR_EN <= '1';
				
			when SET_DDRAM_ADDR1 =>	
				oRS <= '0';
				oDATA <= "1100";
				oEN <= sENABLE;
				sROM_ADDR_RST <= '0';
				sDONE <= '1';
				
			when SET_DDRAM_ADDR3 =>	
				oRS <= '0';
				oDATA <= "1000";
				oEN <= sENABLE;
				sROM_ADDR_RST <= '0';
				
			when SET_DDRAM_ADDR2|SET_DDRAM_ADDR4 =>	
				oRS <= '0';
				oDATA <= "0000";
				oEN <= sENABLE;
				sINSTR_WAIT_TIME <= (ENABLE_COUNTER_WIDTH - 1 downto 0 => '0') + c45us_WAIT_PERIOD;
				sROM_ADDR_RST <= '0';
				
			when others =>
				oDATA <= "0000";
				sSEQ_EN <= '0';
				
		end case;
	end process;

end Behavioral;

