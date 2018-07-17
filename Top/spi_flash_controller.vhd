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
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity spi_flash_controller is
    Port ( iCLK : in  STD_LOGIC;
           inRST : in  STD_LOGIC;
			  iRD_START : in STD_LOGIC;
			  iRD_ADDR : in STD_LOGIC_VECTOR (23 downto 0);
			  oREADY : out STD_LOGIC;
			  oDATA_VALID : out STD_LOGIC;
			  oDATA : out STD_LOGIC_VECTOR (7 downto 0);
           oSCLK : out  STD_LOGIC;
           onCS : out  STD_LOGIC;
           ioSIO : inout  STD_LOGIC_VECTOR (3 downto 0);
           onRESET : out  STD_LOGIC);
end spi_flash_controller;

architecture Behavioral of spi_flash_controller is

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
	
	signal sSTATE, sNEXT_STATE : tREADER_STATE;
	
	signal snCLK : STD_LOGIC;
	
	signal sT : STD_LOGIC_VECTOR (3 downto 0);
	signal sIN : STD_LOGIC_VECTOR (3 downto 0);
	signal sOUT : STD_LOGIC_VECTOR (3 downto 0);
	signal sMOSI_SHREG : STD_LOGIC_VECTOR (31 downto 0);
	signal sMOSI_REG_IN : STD_LOGIC_VECTOR (31 downto 0);
	signal sCONTROL : STD_LOGIC;
	signal sEN, snEN : STD_LOGIC;
	signal sBIT_COUNTER : STD_LOGIC_VECTOR (8 downto 0) := (others => '0');
	signal sMISO_SHREG : STD_LOGIC_VECTOR (7 downto 0);
	signal sREC_STATUS : STD_LOGIC;
	signal sREC_DATA : STD_LOGIC;
	signal sCOUNTER : STD_LOGIC_VECTOR (22 downto 0) := (others => '0');
	signal sCNT_EN : STD_LOGIC;
	signal sDATA : STD_LOGIC_VECTOR (7 downto 0);
	signal sDATA_VALID : STD_LOGIC;
	signal sRD_COUNT : STD_LOGIC_VECTOR (7 downto 0);
	
	signal sCONTROL_VECTOR : STD_LOGIC_VECTOR (35 downto 0);
	signal sMOSI_SEL : STD_LOGIC;
	
begin
	
	sOUT <= "000" & sMOSI_SHREG(31);
	snCLK <= not iCLK;
	oDATA_VALID <= sDATA_VALID;
	oDATA <= sDATA;
	snEN <= not sEN;
	
	-- SPI clock output register
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

	-- Flash reader automate
	process(iCLK, inRST) begin
		if(inRST = '0') then
			sSTATE <= RESET_COUNTER;
		elsif(iCLK'event and iCLK = '1') then
			sSTATE <= sNEXT_STATE;
		end if;
	end process;

	process(sSTATE, sBIT_COUNTER, sMISO_SHREG,  sCOUNTER, iRD_START) begin
		case sSTATE is		
			when RESET_COUNTER =>
				sNEXT_STATE <= RESET_SETUP;
				
			when RESET_SETUP =>
				if(sCOUNTER = 2) then
					sNEXT_STATE <= RESETTING;
				else
					sNEXT_STATE <= RESET_SETUP;
				end if;
			
			when RESETTING =>
				if(sCOUNTER = 552) then
					sNEXT_STATE <= RESET_RECOVERY;
				else
					sNEXT_STATE <= RESETTING;
				end if;
			
			when RESET_RECOVERY =>
				if(sCOUNTER = 5100552) then 
					sNEXT_STATE <= IDLE; 
				else
					sNEXT_STATE <= RESET_RECOVERY;
				end if;
					
			when IDLE =>
				sNEXT_STATE <= WREN_CMD;
					
			when WREN_CMD =>
				sNEXT_STATE <= SEND;
				
			when SEND =>
				if(sBIT_COUNTER = 7) then
					sNEXT_STATE <= END_CMD;
				else
					sNEXT_STATE <= SEND;
				end if;
				
			when END_CMD =>
				sNEXT_STATE <= IDLE1;
				
			when IDLE1 =>
				if(sCOUNTER < 6) then
					sNEXT_STATE <= IDLE1;
				else
					sNEXT_STATE <= RDSR_CMD;
				end if;
				
			when RDSR_CMD =>
				sNEXT_STATE <= SEND1;
				
			when SEND1 =>
				if(sBIT_COUNTER = 8) then
					sNEXT_STATE <= RECEIVE1;
				else
					sNEXT_STATE <= SEND1;
				end if;
				
			when RECEIVE1 =>
				if(sBIT_COUNTER = 16) then
					sNEXT_STATE <= END_CMD1;
				else
					sNEXT_STATE <= RECEIVE1;
				end if;
				
			when END_CMD1 =>
				if(sMISO_SHREG(0) = '0') then
					if(sMISO_SHREG(1) = '1' and sMISO_SHREG(6) = '0') then
						sNEXT_STATE <= IDLE2;
					elsif(sMISO_SHREG(6) = '1') then
						sNEXT_STATE <= READY;
					else
						sNEXT_STATE <= IDLE;
					end if;
				else
					sNEXT_STATE <= IDLE1;
				end if;
				
			when IDLE2 =>
				sNEXT_STATE <= WRSR_CMD;
				
			when WRSR_CMD =>
				sNEXT_STATE <= SEND2;
				
			when SEND2 =>
				if(sBIT_COUNTER = 15) then
					sNEXT_STATE <= END_CMD;
				else
					sNEXT_STATE <= SEND2;
				end if;
				
			when READY =>
				if(iRD_START = '1') then
					sNEXT_STATE <= QREAD_CMD;
				else
					sNEXT_STATE <= READY;
				end if;
				
			when QREAD_CMD =>
				sNEXT_STATE <= SEND3;
				
			when SEND3 =>
				if(sBIT_COUNTER = 32) then
					sNEXT_STATE <= DUMMY;
				else
					sNEXT_STATE <= SEND3;
				end if;
			
			when DUMMY =>
				if(sBIT_COUNTER = 40) then
					sNEXT_STATE <= RECEIVE2;
				else
					sNEXT_STATE <= DUMMY;
				end if;
				
			when RECEIVE2 =>
				if(sBIT_COUNTER = 234) then
					sNEXT_STATE <= END_CMD2;
				else
					sNEXT_STATE <= RECEIVE2;
				end if;
				
			when others =>
				sNEXT_STATE <= READY;
				
		end case;
	end process;
	
	process(sSTATE) begin
		sT <= (others => '1');
		oREADY <= '0';
		sREC_STATUS <= '0';
		sREC_DATA <= '0';
		sCONTROL <= '0';
		sCNT_EN <= '0';
		sMOSI_REG_IN <= (others => '0');
		onRESET <= '1';
		sMOSI_SEL <= '0';
		
		case sSTATE is		
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

