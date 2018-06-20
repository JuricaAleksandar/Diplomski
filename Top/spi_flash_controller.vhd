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
           iRST : in  STD_LOGIC;
			  iCALIB_DONE : in STD_LOGIC;
			  iRD_EN : in STD_LOGIC;
			  iRD_START : in STD_LOGIC;
			  iRD_ADDR : in STD_LOGIC_VECTOR (23 downto 0);
			  iRD_COUNT : in STD_LOGIC_VECTOR (7 downto 0);
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
	
	signal sT : STD_LOGIC_VECTOR (3 downto 0);
	signal sIN : STD_LOGIC_VECTOR (3 downto 0);
	signal sOUT : STD_LOGIC_VECTOR (3 downto 0);
	signal sMOSI_SHREG : STD_LOGIC_VECTOR (31 downto 0);
	signal sMOSI_REG_IN : STD_LOGIC_VECTOR (31 downto 0);
	signal sCONTROL : STD_LOGIC;
	signal sEN : STD_LOGIC;
	signal sBIT_COUNTER : STD_LOGIC_VECTOR (8 downto 0);
	signal sSPI_CLK : STD_LOGIC;
	signal snSPI_CLK : STD_LOGIC;
	signal sMISO_SHREG : STD_LOGIC_VECTOR (7 downto 0);
	signal sREC_STATUS : STD_LOGIC;
	signal sREC_DATA : STD_LOGIC;
	signal sCOUNTER : STD_LOGIC_VECTOR (23 downto 0); ---- 3 downto 0
	signal sCNT_EN : STD_LOGIC;
	signal sDATA : STD_LOGIC_VECTOR (7 downto 0);
	signal sDATA_VALID : STD_LOGIC;
	signal sDATA_VALID_REG : STD_LOGIC;
	signal sRD_COUNT : STD_LOGIC_VECTOR (7 downto 0);
	
	attribute clock_signal : string;
	attribute clock_signal of sSPI_CLK : signal is "yes";
	
begin
	
	sOUT <= "000" & sMOSI_SHREG(31);
	snSPI_CLK <= not sSPI_CLK;
	oDATA_VALID <= sDATA_VALID_REG;
	oDATA <= sDATA;
	
	-- SPI clock output register
	CLK_ODDR2 : ODDR2            
	generic map(
		DDR_ALIGNMENT  =>  "NONE",
		INIT           =>  '0',
		SRTYPE         =>  "SYNC"
	)                              
	port map                       
	(
		Q              =>  oSCLK,
		C0             =>  sSPI_CLK,
		C1             =>  snSPI_CLK,
		CE             =>  '1',
		D0             =>  '1',
		D1             =>  '0',
		R              =>  '0',
		S              =>  '0'
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
	
	-- Requested byte count register
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sRD_COUNT <= (others => '0');
		elsif(iCLK'event and iCLK = '1') then
			if(iRD_START = '1') then
				sRD_COUNT <= iRD_COUNT;
			end if;
		end if;
	end process;
	
	-- Cycle counter
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sCOUNTER <= (others => '0');
		elsif(iCLK'event and iCLK = '1') then
			if(sCNT_EN = '1') then
				sCOUNTER <= sCOUNTER + 1;
			else
				sCOUNTER <= (others => '0');
			end if;
		end if;
	end process;
	
	-- SPI clock generator
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sSPI_CLK <= '0';
		elsif(iCLK'event and iCLK = '1') then
			if(sEN = '1') then
				sSPI_CLK <= not sSPI_CLK;
			else
				sSPI_CLK <= '0';
			end if;
		end if;
	end process;
	
	-- MOSI shift register
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sMOSI_SHREG <= (others => '0');
		elsif(iCLK'event and iCLK = '1') then
			if(sCONTROL = '0') then
				if(sSPI_CLK = '1') then
					sMOSI_SHREG <= sMOSI_SHREG(30 downto 0) & '0';
				end if;
			else
				sMOSI_SHREG <= sMOSI_REG_IN;
			end if;
		end if;
	end process;

	-- MISO shift register
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sMISO_SHREG <= (others => '0');
		elsif(iCLK'event and iCLK = '1') then
			if(sSPI_CLK = '1') then
				if (sREC_STATUS = '1') then
					sMISO_SHREG <= sMISO_SHREG(6 downto 0) & sIN(1);
				elsif (sREC_DATA = '1') then
					sMISO_SHREG <= sMISO_SHREG(3 downto 0) & sIN;
				end if;
			end if;
		end if;
	end process;

	-- Transaction bits counter
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sBIT_COUNTER <= (others => '0');
		elsif(iCLK'event and iCLK = '1') then
			if(sEN = '1') then
				if(sSPI_CLK = '0') then
					sBIT_COUNTER <= sBIT_COUNTER + 1;
				end if;
			else
				sBIT_COUNTER <= (others => '0');
			end if;
		end if;
	end process;

	-- Output registers
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sDATA <= (others => '0');
			sDATA_VALID <= '0';
			sDATA_VALID_REG <= '0';
		elsif(iCLK'event and iCLK = '1') then
				if(sREC_DATA = '1' and sBIT_COUNTER(0) = '0' and sBIT_COUNTER /= 40) then
					sDATA <= sMISO_SHREG;
					sDATA_VALID <= '1';
				end if;
				if(iRD_EN = '1' and sDATA_VALID = '1') then
					sDATA_VALID <= '0';
				end if;
				sDATA_VALID_REG <= sDATA_VALID;
		end if;
	end process;

	-- Flash reader automate
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sSTATE <= RESET_SETUP;
		elsif(iCLK'event and iCLK = '1') then
			sSTATE <= sNEXT_STATE;
		end if;
	end process;

	process(sSTATE, sBIT_COUNTER, sMISO_SHREG,  sCOUNTER, iRD_START, sRD_COUNT, iCALIB_DONE) begin
		case sSTATE is			
			when RESET_SETUP =>
				if(sCOUNTER = 3) then
					sNEXT_STATE <= RESETTING;
				else
					sNEXT_STATE <= RESET_SETUP;
				end if;
			
			when RESETTING =>
				if(sCOUNTER = 1010) then
					sNEXT_STATE <= RESET_RECOVERY;
				else
					sNEXT_STATE <= RESETTING;
				end if;
			
			when RESET_RECOVERY =>
				if(sCOUNTER = 10002000) then
					sNEXT_STATE <= IDLE;
				else
					sNEXT_STATE <= RESET_RECOVERY;
				end if;
					
			when IDLE =>
				if(iCALIB_DONE = '1') then
					sNEXT_STATE <= WREN_CMD;
				else
					sNEXT_STATE <= IDLE;
				end if;
					
			when WREN_CMD =>
				sNEXT_STATE <= SEND;
				
			when SEND =>
				if(sBIT_COUNTER = 8) then
					sNEXT_STATE <= END_CMD;
				else
					sNEXT_STATE <= SEND;
				end if;
				
			when END_CMD =>
				sNEXT_STATE <= IDLE1;
				
			when IDLE1 =>
				if(sCOUNTER < 10) then
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
					if(sMISO_SHREG(1) = '1') then
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
				if(sBIT_COUNTER = 16) then
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
				if(sBIT_COUNTER(8 downto 1) - 20 = sRD_COUNT) then
					sNEXT_STATE <= END_CMD2;
				else
					sNEXT_STATE <= RECEIVE2;
				end if;
				
			when END_CMD2 =>
				sNEXT_STATE <= READY;
				
		end case;
	end process;

	process(sSTATE, iRD_ADDR) begin
		sT <= (others => '1');
		oREADY <= '0';
		sREC_STATUS <= '0';
		sREC_DATA <= '0';
		sCONTROL <= '0';
		sCNT_EN <= '0';
		sMOSI_REG_IN <= (others => '0');
		onRESET <= '1';
		
		case sSTATE is		
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
				onCS <= '1';
				sEN <= '0';
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
				onCS <= '1';
				sEN <= '0';
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
				onCS <= '1';
				sEN <= '0';
				sCONTROL <= '1';
				sMOSI_REG_IN <= x"01400000"; -- 0x01 CMD 0x40 DATA
				
			when QREAD_CMD =>
				sT <= (0 => '0', others => '1');
				onCS <= '1';
				sEN <= '0';
				sCONTROL <= '1';
				sMOSI_REG_IN <= x"6B" & iRD_ADDR; -- 0x6B CMD Input DATA
			
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

