----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:26:31 05/17/2018 
-- Design Name: 
-- Module Name:    spiFlashController - Behavioral 
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

library UNISIM;
use UNISIM.VComponents.all;

entity spi_flash_controller is
    Port ( iCLK : in  STD_LOGIC;											-- Input clock signal
           inRST : in  STD_LOGIC;										-- Input reset signal(inverse logic)
			  iRD_START : in STD_LOGIC;									-- Input read start signal
			  iRD_ADDR : in STD_LOGIC_VECTOR (23 downto 0);			-- Input read address
			  oREADY : out STD_LOGIC;										-- Output ready flag
			  oDATA_VALID : out STD_LOGIC;								-- Output data valid flag
			  oDATA : out STD_LOGIC_VECTOR (7 downto 0);				-- Output data bus
           oSCLK : out  STD_LOGIC;										-- SPI flash clock
           onCS : out  STD_LOGIC;										-- SPI flash chip select(inverse logic)
           ioSIO : inout  STD_LOGIC_VECTOR (3 downto 0);			-- Input/output bidirectional 4-bit data bus
           onRESET : out  STD_LOGIC);									-- SPI flash reset(inverse logic)
end spi_flash_controller;

architecture Behavioral of spi_flash_controller is

	-- SPI flash controller FSM states
	type tREADER_STATE is 
	(
		RESET_COUNTER,
		RESET_SETUP,
		RESETTING,
		RESET_RECOVERY,
		IDLE,
		WREN_CMD,
		SEND,
		END_CMD,
		IDLE1,
		RDSR_CMD,
		SEND1,
		RECEIVE1,
		END_CMD1,
		IDLE2,
		WRSR_CMD,
		SEND2,
		READY,
		QREAD_CMD,
		SEND3,
		DUMMY,
		RECEIVE2,
		END_CMD2
	);
	
	signal sSPI_CURRENT_STATE, sSPI_NEXT_STATE : tREADER_STATE;
	
	signal snCLK : STD_LOGIC;																	-- Inverted clock signal(used as one of the inputs of ODDR register)	
	signal sT : STD_LOGIC_VECTOR (3 downto 0);											-- Tri-state buffer control signal
	signal sIN : STD_LOGIC_VECTOR (3 downto 0);											-- Inputs from tri-state buffers
	signal sOUT : STD_LOGIC_VECTOR (3 downto 0);											-- Outputs to tri-state buffer
	signal sMOSI_SHREG : STD_LOGIC_VECTOR (31 downto 0);								-- MOSI shift register signal 
	signal sMOSI_REG_IN : STD_LOGIC_VECTOR (31 downto 0);								-- MOSI shift register input signal
	signal sCONTROL : STD_LOGIC;																-- Control signal for MOSI shift register(0 - shift, 1 - write to register)
	signal sEN, snEN : STD_LOGIC;																-- Output SPI clock enable signals
	signal sBIT_COUNTER : STD_LOGIC_VECTOR (8 downto 0) := (others => '0');		-- Data transfer bit counter signal
	signal sMISO_SHREG : STD_LOGIC_VECTOR (7 downto 0);								-- MISO shift register signal
	signal sREC_STATUS : STD_LOGIC;															-- Receiving status signal
	signal sREC_DATA : STD_LOGIC;																-- Receiving data signal
	signal sCOUNTER : STD_LOGIC_VECTOR (22 downto 0) := (others => '0');			-- Clock cycle counter
	signal sCNT_EN : STD_LOGIC;																-- Transaction bit counter clock enable signal
	signal sDATA : STD_LOGIC_VECTOR (7 downto 0);										-- Output data register signal
	signal sDATA_VALID : STD_LOGIC;															-- Output data valid signal
	signal sMOSI_SEL : STD_LOGIC;																-- MOSI selection signal, 0 - MOSI register loaded with FSM output, 1 - MOSI register loaded with input read address
	
begin
	
	sOUT <= "000" & sMOSI_SHREG(31);
	snCLK <= not iCLK;
	oDATA_VALID <= sDATA_VALID;
	oDATA <= sDATA;
	snEN <= not sEN;
	
	-- SPI clock output DDR register
	CLK_ODDR2 : ODDR2            
	generic map(
		DDR_ALIGNMENT  =>  "NONE",
		INIT           =>  '1',
		SRTYPE         =>  "SYNC"
	)                              
	port map                       
	(
		Q              =>  oSCLK,
		C0             =>  iCLK,
		C1             =>  snCLK,
		CE             =>  sEN,
		D0             =>  '0',
		D1             =>  '1',
		R              =>  '0',
		S              =>  snEN
	);
	
	-- Four input/output tri-state buffers for cmd, address and data signals
	sio0 : IOBUF
	port map
	(
		T => sT(0),
		I => sOUT(0),
		O => sIN(0),
		IO => ioSIO(0)
	);
	
	sio1 : IOBUF
	port map
	(
		T => sT(1),
		I => sOUT(1),
		O => sIN(1),
		IO => ioSIO(1)
	);
	
	sio2 : IOBUF
	port map
	(
		T => sT(2),
		I => sOUT(2),
		O => sIN(2),
		IO => ioSIO(2)
	);
	
	sio3 : IOBUF
	port map
	(
		T => sT(3),
		I => sOUT(3),
		O => sIN(3),
		IO => ioSIO(3)
	);
	
	-- Cycle counter
	process(iCLK) begin
		if(iCLK'event and iCLK = '1') then
			if(sCNT_EN = '1') then
				sCOUNTER <= sCOUNTER + 1;
			else
				sCOUNTER <= (others => '0');
			end if;
		end if;
	end process;
	
	-- MOSI shift register
	process(iCLK, inRST) begin
		if(inRST = '0') then
			sMOSI_SHREG <= (others => '0');
		elsif(iCLK'event and iCLK = '1') then
			if(sCONTROL = '0') then
				sMOSI_SHREG <= sMOSI_SHREG(30 downto 0) & '0';
			else
				if(sMOSI_SEL = '0') then
					sMOSI_SHREG <= sMOSI_REG_IN;
				else
					sMOSI_SHREG <= x"6B" & iRD_ADDR;
				end if;
			end if;
		end if;
	end process;

	-- MISO shift register
	process(iCLK, inRST) begin
		if(inRST = '0') then
			sMISO_SHREG <= (others => '0');
		elsif(iCLK'event and iCLK = '1') then
			if (sREC_STATUS = '1') then
				sMISO_SHREG <= sMISO_SHREG(6 downto 0) & sIN(1);
			elsif (sREC_DATA = '1') then
				sMISO_SHREG <= sMISO_SHREG(3 downto 0) & sIN;
			end if;
		end if;
	end process;

	-- Transaction bits counter
	process(iCLK) begin
		if(iCLK'event and iCLK = '1') then
			if(sEN = '1') then
				sBIT_COUNTER <= sBIT_COUNTER + 1;
			else
				sBIT_COUNTER <= (others => '0');
			end if;
		end if;
	end process;

	-- Output registers
	process(iCLK, inRST) begin
		if(inRST = '0') then
			sDATA <= (others => '0');
			sDATA_VALID <= '0';
		elsif(iCLK'event and iCLK = '1') then
			if(sREC_DATA = '1' and sBIT_COUNTER(0) = '1' and sBIT_COUNTER /= 41) then
				sDATA <= sMISO_SHREG;
				sDATA_VALID <= '1';
			end if;
			if(sDATA_VALID = '1') then
				sDATA_VALID <= '0';
			end if;
		end if;
	end process;

	-- Flash controller FSM register
	process(iCLK, inRST) begin
		if(inRST = '0') then
			sSPI_CURRENT_STATE <= RESET_COUNTER;
		elsif(iCLK'event and iCLK = '1') then
			sSPI_CURRENT_STATE <= sSPI_NEXT_STATE;
		end if;
	end process;

	-- Flash controller FSM transition logic
	process(sSPI_CURRENT_STATE, sBIT_COUNTER, sMISO_SHREG,  sCOUNTER, iRD_START) begin
		case sSPI_CURRENT_STATE is		
			when RESET_COUNTER =>
				sSPI_NEXT_STATE <= RESET_SETUP;
				
			when RESET_SETUP =>
				if(sCOUNTER = 2) then
					sSPI_NEXT_STATE <= RESETTING;
				else
					sSPI_NEXT_STATE <= RESET_SETUP;
				end if;
			
			when RESETTING =>
				if(sCOUNTER = 552) then
					sSPI_NEXT_STATE <= RESET_RECOVERY;
				else
					sSPI_NEXT_STATE <= RESETTING;
				end if;
			
			when RESET_RECOVERY =>
				if(sCOUNTER = 5100552) then 
					sSPI_NEXT_STATE <= IDLE; 
				else
					sSPI_NEXT_STATE <= RESET_RECOVERY;
				end if;
					
			when IDLE =>
				sSPI_NEXT_STATE <= WREN_CMD;
					
			when WREN_CMD =>
				sSPI_NEXT_STATE <= SEND;
				
			when SEND =>
				if(sBIT_COUNTER = 7) then
					sSPI_NEXT_STATE <= END_CMD;
				else
					sSPI_NEXT_STATE <= SEND;
				end if;
				
			when END_CMD =>
				sSPI_NEXT_STATE <= IDLE1;
				
			when IDLE1 =>
				if(sCOUNTER < 6) then
					sSPI_NEXT_STATE <= IDLE1;
				else
					sSPI_NEXT_STATE <= RDSR_CMD;
				end if;
				
			when RDSR_CMD =>
				sSPI_NEXT_STATE <= SEND1;
				
			when SEND1 =>
				if(sBIT_COUNTER = 8) then
					sSPI_NEXT_STATE <= RECEIVE1;
				else
					sSPI_NEXT_STATE <= SEND1;
				end if;
				
			when RECEIVE1 =>
				if(sBIT_COUNTER = 16) then
					sSPI_NEXT_STATE <= END_CMD1;
				else
					sSPI_NEXT_STATE <= RECEIVE1;
				end if;
				
			when END_CMD1 =>
				if(sMISO_SHREG(0) = '0') then
					if(sMISO_SHREG(1) = '1' and sMISO_SHREG(6) = '0') then
						sSPI_NEXT_STATE <= IDLE2;
					elsif(sMISO_SHREG(6) = '1') then
						sSPI_NEXT_STATE <= READY;
					else
						sSPI_NEXT_STATE <= IDLE;
					end if;
				else
					sSPI_NEXT_STATE <= IDLE1;
				end if;
				
			when IDLE2 =>
				sSPI_NEXT_STATE <= WRSR_CMD;
				
			when WRSR_CMD =>
				sSPI_NEXT_STATE <= SEND2;
				
			when SEND2 =>
				if(sBIT_COUNTER = 15) then
					sSPI_NEXT_STATE <= END_CMD;
				else
					sSPI_NEXT_STATE <= SEND2;
				end if;
				
			when READY =>
				if(iRD_START = '1') then
					sSPI_NEXT_STATE <= QREAD_CMD;
				else
					sSPI_NEXT_STATE <= READY;
				end if;
				
			when QREAD_CMD =>
				sSPI_NEXT_STATE <= SEND3;
				
			when SEND3 =>
				if(sBIT_COUNTER = 32) then
					sSPI_NEXT_STATE <= DUMMY;
				else
					sSPI_NEXT_STATE <= SEND3;
				end if;
			
			when DUMMY =>
				if(sBIT_COUNTER = 40) then
					sSPI_NEXT_STATE <= RECEIVE2;
				else
					sSPI_NEXT_STATE <= DUMMY;
				end if;
				
			when RECEIVE2 =>
				if(sBIT_COUNTER = 234) then
					sSPI_NEXT_STATE <= END_CMD2;
				else
					sSPI_NEXT_STATE <= RECEIVE2;
				end if;
				
			when others =>
				sSPI_NEXT_STATE <= READY;
				
		end case;
	end process;
	
	-- Flash controller FSM output logic
	process(sSPI_CURRENT_STATE) begin
		sT <= (others => '1');
		oREADY <= '0';
		sREC_STATUS <= '0';
		sREC_DATA <= '0';
		sCONTROL <= '0';
		sCNT_EN <= '0';
		sMOSI_REG_IN <= (others => '0');
		onRESET <= '1';
		sMOSI_SEL <= '0';
		
		case sSPI_CURRENT_STATE is		
			when RESET_COUNTER =>
				onCS <= '1';
				sEN <= '0';
				
			when IDLE|IDLE1|IDLE2|RESET_SETUP|RESET_RECOVERY =>
				onCS <= '1';
				sEN <= '0';
				sCNT_EN <= '1';
				
			when RESETTING =>
				onCS <= '1';
				sEN <= '0';
				sCNT_EN <= '1';
				onRESET <= '0';
				
			when WREN_CMD =>
				sT <= (0 => '0', others => '1');
				onCS <= '0';
				sEN <= '1';
				sCONTROL <= '1';
				sMOSI_REG_IN <= x"06000000"; -- 0x06 CMD
				
			when SEND|SEND1|SEND2|SEND3 =>
				sT <= (0 => '0', others => '1');
				onCS <= '0';
				sEN <= '1';
				
			when END_CMD =>
				sT <= (0 => '0', others => '1');
				onCS <= '0';
				sEN <= '0';
			
			when RDSR_CMD =>
				sT <= (0 => '0', others => '1');
				onCS <= '0';
				sEN <= '1';
				sCONTROL <= '1';
				sMOSI_REG_IN <= x"05000000"; -- 0x05 CMD
			
			when RECEIVE1 =>
				onCS <= '0';
				sEN <= '1';
				sREC_STATUS <= '1';
			
			when END_CMD1 =>
				onCS <= '0';
				sEN <= '0';
				sREC_STATUS <= '1';
			
			when WRSR_CMD =>
				sT <= (0 => '0', others => '1');
				onCS <= '0';
				sEN <= '1';
				sCONTROL <= '1';
				sMOSI_REG_IN <= x"01400000"; -- 0x01 CMD 0x40 DATA
				
			when QREAD_CMD =>
				sT <= (0 => '0', others => '1');
				onCS <= '0';
				sEN <= '1';
				sCONTROL <= '1';
				sMOSI_SEL <= '1';
			
			when DUMMY =>
				onCS <= '0';
				sEN <= '1';
				
			when RECEIVE2 =>
				onCS <= '0';
				sEN <= '1';
				sREC_DATA <= '1';
			
			when END_CMD2 =>
				onCS <= '0';
				sEN <= '0';
				sREC_DATA <= '1';
				
			when others =>
				onCS <= '1';
				sEN <= '0';
				oREADY <= '1';
				
		end case;
	end process;

end Behavioral;

