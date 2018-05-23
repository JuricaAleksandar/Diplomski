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

entity spiFlashController is
    Port ( iCLK : in  STD_LOGIC;
           inRST : in  STD_LOGIC;
           oSCLK : out  STD_LOGIC;
           onCS : out  STD_LOGIC;
           ioSIO : inout  STD_LOGIC_VECTOR (3 downto 0);
           onRESET : out  STD_LOGIC);
end spiFlashController;

architecture Behavioral of spiFlashController is

	type tREADER_STATE is (
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
								READY
								);
	signal sSTATE, sNEXT_STATE : tREADER_STATE;
	
	signal sT : STD_LOGIC_VECTOR (3 downto 0);
	signal sIN : STD_LOGIC_VECTOR (3 downto 0);
	signal sOUT : STD_LOGIC_VECTOR (3 downto 0);
	signal sMOSI_SHREG : STD_LOGIC_VECTOR (31 downto 0);
	signal sMOSI_REG_IN : STD_LOGIC_VECTOR (31 downto 0);
	signal sCONTROL : STD_LOGIC;
	signal sBIT_CNT_EN : STD_LOGIC;
	signal sBIT_COUNTER : STD_LOGIC_VECTOR (5 downto 0);
	signal sCLK : STD_LOGIC;
	signal sCLK_EN : STD_LOGIC;
	signal sIN_SHREG_1 : STD_LOGIC_VECTOR (7 downto 0);
	signal sRECEIVE : STD_LOGIC;
	signal sCOUNTER : STD_LOGIC_VECTOR (7 downto 0);
	signal sCNT_EN : STD_LOGIC;
	
begin
	
	sOUT <= "000" & sMOSI_SHREG(31);
	oSCLK <= sCLK;
	onRESET <= '1';
	
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
	process(iCLK, inRST) begin
		if(inRST = '0') then
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
	process(iCLK, inRST) begin
		if(inRST = '0') then
			sCLK <= '0';
		elsif(iCLK'event and iCLK = '1') then
			if(sCLK_EN = '1') then
				sCLK <= not sCLK;
			else
				sCLK <= '0';
			end if;
		end if;
	end process;
	
	-- MOSI shift register
	process(iCLK, inRST) begin
		if(inRST = '0') then
			sMOSI_SHREG <= (others => '0');
		elsif(iCLK'event and iCLK = '1') then
			if(sCONTROL = '0') then
				if(sCLK = '1') then
					sMOSI_SHREG <= sMOSI_SHREG(30 downto 0) & '0';
				end if;
			else
				sMOSI_SHREG <= sMOSI_REG_IN;
			end if;
		end if;
	end process;

	-- SIO1 input shift register
	process(iCLK, inRST) begin
		if(inRST = '0') then
			sIN_SHREG_1 <= (others => '0');
		elsif(iCLK'event and iCLK = '1') then
			if(sCLK = '1' and sRECEIVE = '1') then
				sIN_SHREG_1 <= sIN_SHREG_1(6 downto 0) & sIN(1);
			end if;
		end if;
	end process;

	-- Transaction bits counter
	process(iCLK, inRST) begin
		if(inRST = '0') then
			sBIT_COUNTER <= (others => '0');
		elsif(iCLK'event and iCLK = '1') then
			if(sBIT_CNT_EN = '1') then
				if(sCLK = '0') then
					sBIT_COUNTER <= sBIT_COUNTER + 1;
				end if;
			else
				sBIT_COUNTER <= (others => '0');
			end if;
		end if;
	end process;

	-- Flash reader automate
	process(iCLK, inRST) begin
		if(inRST = '0') then
			sSTATE <= IDLE;
		elsif(iCLK'event and iCLK = '1') then
			sSTATE <= sNEXT_STATE;
		end if;
	end process;

	process(sSTATE, sBIT_COUNTER, sIN_SHREG_1,  sCOUNTER) begin
		case sSTATE is
			when IDLE =>
					sNEXT_STATE <= WREN_CMD;
					
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
				if(sIN_SHREG_1(1) = '1') then
					sNEXT_STATE <= IDLE2;
				elsif(sIN_SHREG_1(6) = '1' and sIN_SHREG_1(0) = '0') then
					sNEXT_STATE <= READY;
				else
					sNEXT_STATE <= IDLE;
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
				
			when others =>
				sNEXT_STATE <= READY;
				
		end case;
	end process;

	process(sSTATE, iCLK) begin
	
		case sSTATE is		
			when IDLE|IDLE1|IDLE2 =>
				sT <= (others => '1');
				onCS <= '1';
				sCLK_EN <= '0';
				sCONTROL <= '0';
				sMOSI_REG_IN <= (others => '0');
				sBIT_CNT_EN <= '0';
				sRECEIVE <= '0';
				sCNT_EN <= '1';
				
			when WREN_CMD =>
				sT <= (0 => '0', others => '1');
				onCS <= '1';
				sCLK_EN <= '0';
				sCONTROL <= '1';
				sMOSI_REG_IN <= x"06000000"; -- 0x06 CMD
				sBIT_CNT_EN <= '0';
				sRECEIVE <= '0';
				sCNT_EN <= '0';
				
			when SEND|SEND1|SEND2 =>
				sT <= (0 => '0', others => '1');
				onCS <= '0';
				sCLK_EN <= '1';
				sCONTROL <= '0';
				sMOSI_REG_IN <= (others => '0');
				sBIT_CNT_EN <= '1';
				sRECEIVE <= '0';
				sCNT_EN <= '0';
				
			when END_CMD =>
				sT <= (0 => '0', others => '1');
				onCS <= '0';
				sCLK_EN <= '0';
				sCONTROL <= '0';
				sMOSI_REG_IN <= (others => '0');
				sBIT_CNT_EN <= '0';
				sRECEIVE <= '0';
				sCNT_EN <= '0';
			
			when RDSR_CMD =>
				sT <= (0 => '0', others => '1');
				onCS <= '1';
				sCLK_EN <= '0';
				sCONTROL <= '1';
				sMOSI_REG_IN <= x"05000000"; -- 0x05 CMD
				sBIT_CNT_EN <= '0';
				sRECEIVE <= '0';
				sCNT_EN <= '0';
			
			when RECEIVE1 =>
				sT <= (others => '1');
				onCS <= '0';
				sCLK_EN <= '1';
				sCONTROL <= '0';
				sMOSI_REG_IN <= (others => '0');
				sBIT_CNT_EN <= '1';
				sRECEIVE <= '1';
				sCNT_EN <= '0';
			
			when END_CMD1 =>
				sT <= (others => '1');
				onCS <= '0';
				sCLK_EN <= '0';
				sCONTROL <= '0';
				sMOSI_REG_IN <= (others => '0');
				sBIT_CNT_EN <= '0';
				sRECEIVE <= '1';
				sCNT_EN <= '0';
			
			when WRSR_CMD =>
				sT <= (0 => '0', others => '1');
				onCS <= '1';
				sCLK_EN <= '0';
				sCONTROL <= '1';
				sMOSI_REG_IN <= x"01400000"; -- 0x01 CMD 0x40 DATA
				sBIT_CNT_EN <= '0';
				sRECEIVE <= '0';
				sCNT_EN <= '0';
			
			when others =>
				sT <= (others => '1');
				onCS <= '1';
				sCLK_EN <= '0';
				sCONTROL <= '0';
				sMOSI_REG_IN <= (others => '0');
				sBIT_CNT_EN <= '0';
				sRECEIVE <= '0';
				sCNT_EN <= '0';
				
		end case;
	end process;

end Behavioral;

