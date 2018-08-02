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

entity switch_debouncer is
    Port ( iCLK : in  STD_LOGIC;											-- Input clock signal
           iRST : in  STD_LOGIC;											-- Input reset signal
			  iIMAGE_SELECT : in STD_LOGIC_VECTOR (2 downto 0);	-- Image selecting switch input
           iMODE : in  STD_LOGIC_VECTOR (1 downto 0);				-- Mode selecting switch input
           iSPLIT_SCREEN : in  STD_LOGIC;								-- Split screen selecting switch input
			  iDELAY_ON : in STD_LOGIC;									-- Delay selecting switch input
			  oIMAGE_SELECT : out STD_LOGIC_VECTOR (2 downto 0);	-- Image selcting switch signal(debounced)
           oMODE : out  STD_LOGIC_VECTOR (1 downto 0);			-- Mode selecting switch signal(debounced)
           oSPLIT_SCREEN : out  STD_LOGIC;							-- Split screen selecting switch signal(debounced)
			  oDELAY_ON : out STD_LOGIC									-- Delay selecting switch signal(debounced)
			);
end switch_debouncer;

architecture Behavioral of switch_debouncer is

	signal sMODE_INPUT_FF : STD_LOGIC_VECTOR (1 downto 0);		-- Mode input register signal
	signal sMODE_COMPARE_FF : STD_LOGIC_VECTOR (1 downto 0);		-- Mode compare value register signal
	signal sMODE_OUTPUT_FF : STD_LOGIC_VECTOR (1 downto 0);		-- Mode output register signal
	signal sMODE_COUNTER : STD_LOGIC_VECTOR (19 downto 0);		-- 10ms counter signal for mode switch debouncing
	signal sMODE_SET : STD_LOGIC;											-- Counter terminal count/mode output register clock enable signal
	
	signal sIM_SEL_INPUT_FF : STD_LOGIC_VECTOR (2 downto 0);		-- Image select input register signal
	signal sIM_SEL_COMPARE_FF : STD_LOGIC_VECTOR (2 downto 0);	-- Image select compare value register signal
	signal sIM_SEL_OUTPUT_FF : STD_LOGIC_VECTOR (2 downto 0);	-- Image select output register signal
	signal sIM_SEL_COUNTER : STD_LOGIC_VECTOR (19 downto 0);		-- 10ms counter signal for image selecting switches dobuncing
	signal sIM_SEL_SET : STD_LOGIC;										-- Counter terminal count/image select output register clock enable signal
	
	signal sSS_INPUT_FF : STD_LOGIC;										-- Split screen input register signal
	signal sSS_COMPARE_FF : STD_LOGIC;									-- Split screen compare value register signal
	signal sSS_OUTPUT_FF : STD_LOGIC;									-- Split screen output register signal
	signal sSS_COUNTER : STD_LOGIC_VECTOR (19 downto 0);			-- 10ms counter signal for split screen switch dobuncing
	signal sSS_SET : STD_LOGIC;											-- Counter terminal count/split screen output register clock enable signal
	
	signal sDELAY_INPUT_FF : STD_LOGIC;									-- Delay input register signal
	signal sDELAY_COMPARE_FF : STD_LOGIC;								-- Delay compare value register signal
	signal sDELAY_OUTPUT_FF : STD_LOGIC;								-- Delay output register signal
	signal sDELAY_COUNTER : STD_LOGIC_VECTOR (19 downto 0);		-- 10ms counter signal for image selecting switches dobuncing
	signal sDELAY_SET : STD_LOGIC;										-- Counter terminal count/delay output register clock enable signal
	
	attribute ASYNC_REG : string;
	
	attribute ASYNC_REG of sMODE_INPUT_FF : signal is "TRUE";
	attribute ASYNC_REG of sMODE_COMPARE_FF : signal is "TRUE";
	attribute ASYNC_REG of sIM_SEL_INPUT_FF : signal is "TRUE";
	attribute ASYNC_REG of sIM_SEL_COMPARE_FF : signal is "TRUE";
	attribute ASYNC_REG of sSS_INPUT_FF : signal is "TRUE";
	attribute ASYNC_REG of sSS_COMPARE_FF : signal is "TRUE";
	attribute ASYNC_REG of sDELAY_INPUT_FF : signal is "TRUE";
	attribute ASYNC_REG of sDELAY_COMPARE_FF : signal is "TRUE";
	
begin
	
	-- Mode debouncing 10ms counter and output register clock enable logic 
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sMODE_COUNTER <= (others => '0');
			sMODE_SET <= '1';
		elsif(iCLK'event and iCLK = '1') then
			if(sMODE_SET = '0') then
				if((sMODE_INPUT_FF /= sMODE_COMPARE_FF)) then
					sMODE_COUNTER <= (others => '0');
				elsif(sMODE_COUNTER = (19 downto 0 => '1')) then
					sMODE_SET <= '1';
				end if;
				sMODE_COUNTER <= sMODE_COUNTER + 1;
			elsif ((sMODE_INPUT_FF /= sMODE_COMPARE_FF)) then
				sMODE_SET <= '0';
			end if;
		end if;
	end process;
	
	-- Mode debouncing registers
	process(iCLK) begin
		if(iCLK'event and iCLK = '1') then
			sMODE_INPUT_FF <= iMODE;
			sMODE_COMPARE_FF <= sMODE_INPUT_FF;
			if(sMODE_SET = '1') then
				sMODE_OUTPUT_FF <= sMODE_COMPARE_FF;
			end if;
		end if;
	end process;
	
	-- Image selection debouncing 10ms counter and output register clock enable logic
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sIM_SEL_COUNTER <= (others => '0');
			sIM_SEL_SET <= '1';
		elsif(iCLK'event and iCLK = '1') then
			if(sIM_SEL_SET = '0') then
				if((sIM_SEL_INPUT_FF /= sIM_SEL_COMPARE_FF)) then
					sIM_SEL_COUNTER <= (others => '0');
				elsif(sIM_SEL_COUNTER = (19 downto 0 => '1')) then
					sIM_SEL_SET <= '1';
				end if;
				sIM_SEL_COUNTER <= sIM_SEL_COUNTER + 1;
			elsif ((sIM_SEL_INPUT_FF /= sIM_SEL_COMPARE_FF)) then
				sIM_SEL_SET <= '0';
			end if;
		end if;
	end process;
	
	-- Image select debouncing registers
	process(iCLK) begin
		if(iCLK'event and iCLK = '1') then
			sIM_SEL_INPUT_FF <= iIMAGE_SELECT;
			sIM_SEL_COMPARE_FF <= sIM_SEL_INPUT_FF;
			if(sIM_SEL_SET = '1') then
				sIM_SEL_OUTPUT_FF <= sIM_SEL_COMPARE_FF;
			end if;
		end if;
	end process;
	
	-- Split screen debouncing 10ms counter and output register clock enable logic
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sSS_COUNTER <= (others => '0');
			sSS_SET <= '1';
		elsif(iCLK'event and iCLK = '1') then
			if(sSS_SET = '0') then
				if(sSS_INPUT_FF /= sSS_COMPARE_FF) then
					sSS_COUNTER <= (others => '0');
				elsif(sSS_COUNTER = (19 downto 0 => '1')) then
					sSS_SET <= '1';
				end if;
				sSS_COUNTER <= sSS_COUNTER + 1;
			elsif((sSS_INPUT_FF /= sSS_COMPARE_FF)) then
				sSS_SET <= '0';
			end if;
		end if;
	end process;
	
	-- Split screen debouncing registers
	process(iCLK) begin
		if(iCLK'event and iCLK = '1') then
			sSS_INPUT_FF <= iSPLIT_SCREEN;
			sSS_COMPARE_FF <= sSS_INPUT_FF;
			if(sSS_SET = '1') then
				sSS_OUTPUT_FF <= sSS_COMPARE_FF;
			end if;
		end if;
	end process;
	
	-- Delay switch debouncing 10ms counter and output register clock enable logic
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sDELAY_COUNTER <= (others => '0');
			sDELAY_SET <= '1';
		elsif(iCLK'event and iCLK = '1') then
			if(sDELAY_SET = '0') then
				if(sDELAY_INPUT_FF /= sDELAY_COMPARE_FF) then
					sDELAY_COUNTER <= (others => '0');
				elsif(sDELAY_COUNTER = (19 downto 0 => '1')) then
					sDELAY_SET <= '1';
				end if;
				sDELAY_COUNTER <= sDELAY_COUNTER + 1;
			elsif((sDELAY_INPUT_FF /= sDELAY_COMPARE_FF)) then
				sDELAY_SET <= '0';
			end if;
		end if;
	end process;
	
	-- Delay debouncing registers
	process(iCLK) begin
		if(iCLK'event and iCLK = '1') then
			sDELAY_INPUT_FF <= iDELAY_ON;
			sDELAY_COMPARE_FF <= sDELAY_INPUT_FF;
			if(sDELAY_SET = '1') then
				sDELAY_OUTPUT_FF <= sDELAY_COMPARE_FF;
			end if;
		end if;
	end process;
	
	oMODE <= sMODE_OUTPUT_FF;
	oIMAGE_SELECT <= sIM_SEL_OUTPUT_FF;
	oSPLIT_SCREEN <= sSS_OUTPUT_FF;
	oDELAY_ON <= sDELAY_OUTPUT_FF;
	
end Behavioral;

