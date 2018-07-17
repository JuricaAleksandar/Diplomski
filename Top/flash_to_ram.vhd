----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:59:30 05/24/2018 
-- Design Name: 
-- Module Name:    flash2RAM - Behavioral 
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

entity flash_to_ram is
    Port ( iCLK : in  STD_LOGIC;
           inRST : in  STD_LOGIC;
			  iIMAGE_SELECT : in STD_LOGIC_VECTOR (2 downto 0);
			  iCALIB_DONE : in STD_LOGIC;
           iREADY : in  STD_LOGIC;
           iDATA_VALID : in  STD_LOGIC;
           iDATA : in  STD_LOGIC_VECTOR (7 downto 0);
           oRD_START : out  STD_LOGIC;
           oRD_ADDR : out  STD_LOGIC_VECTOR (23 downto 0);
			  oDONE : out STD_LOGIC;
           oCMD_EN : out  STD_LOGIC;
           oCMD_INSTR : out  STD_LOGIC_VECTOR (2 downto 0);
           oCMD_BL : out  STD_LOGIC_VECTOR (5 downto 0);
           oCMD_BYTE_ADDR : out  STD_LOGIC_VECTOR (29 downto 0);
           oWR_EN : out  STD_LOGIC;
           oWR_MASK : out  STD_LOGIC_VECTOR (3 downto 0);
           oWR_DATA : out  STD_LOGIC_VECTOR (31 downto 0)
           );
end flash_to_ram;

architecture Behavioral of flash_to_ram is

	type tTRANSFER_STATE is
	(
		IDLE,
		SET_FLASH_ADDR,
		SET_FLASH_CMD,
		INC_FLASH_ADDR,
		WAIT_DATA,
		READ_DATA,
		SET_RAM_CMD,
		DONE
	);
	
	signal sSTATE, sNEXT_STATE : tTRANSFER_STATE;

	signal sWR_DATA : STD_LOGIC_VECTOR (23 downto 0);
	signal sBYTE_COUNTER : STD_LOGIC_VECTOR (1 downto 0);
	signal sPIXEL_COUNTER : STD_LOGIC_VECTOR (5 downto 0);
	signal sREG_EN : STD_LOGIC;
	signal sRD_COUNT : STD_LOGIC_VECTOR (7 downto 0);
	signal sFLASH_ADDR : STD_LOGIC_VECTOR (23 downto 0);
	signal sPOS_X : STD_LOGIC_VECTOR (3 downto 0);
	signal sPOS_Y : STD_LOGIC_VECTOR (8 downto 0);
	signal sFLASH_ADDR_EN : STD_LOGIC;
	signal sRAM_ADDR_EN : STD_LOGIC;
	signal sCLR_REG : STD_LOGIC;
	signal sWR_EN : STD_LOGIC;
	signal sWAIT : STD_LOGIC;
	signal sIMAGE_SELECT : STD_LOGIC_VECTOR (2 downto 0);
	signal sSEL_EN : STD_LOGIC;
	signal sFLASH_ADDR_SET : STD_LOGIC;
	signal sFLASH_ADDR_IN : STD_LOGIC_VECTOR (23 downto 0);
	signal sRESTART, sRESTARTED : STD_LOGIC;
	
begin

	-- Image selection register
	process(iCLK) begin
		if(iCLK'event and iCLK = '1') then
			if(sSEL_EN = '1') then
				sIMAGE_SELECT <= iIMAGE_SELECT;
			end if;
		end if;
	end process;
	
	process(iCLK) begin
		if(iCLK'event and iCLK = '1') then
			if(sRESTARTED = '1') then
				sRESTART <= '0';
			elsif(sIMAGE_SELECT /= iIMAGE_SELECT) then
				sRESTART <= '1';
			end if;
		end if;
	end process;

	-- Ram write enable
	process(iCLK, inRST) begin
		if(inRST = '0') then
			sWR_EN <= '0';
			sWAIT <= '0';
		elsif(iCLK'event and iCLK = '1') then
			if(sBYTE_COUNTER = 3) then
				if(sWAIT = '0') then
					sWR_EN <= '1';
					sWAIT <= '1';
				else
					sWR_EN <= '0';
				end if;
			else
				sWR_EN <= '0';
				sWAIT <= '0';
			end if;
		end if;
	end process;

	-- Registers
	process(iCLK, inRST) begin
		if(inRST = '0') then
			sWR_DATA <= (others => '0');
			sBYTE_COUNTER <= (others => '0');
			sPIXEL_COUNTER <= (others => '0');
		elsif(iCLK'event and iCLK = '1') then
			if(sREG_EN = '1') then
				sWR_DATA <= sWR_DATA(15 downto 0) & iDATA; -- Shifting received bytes to form RGB pixels
				if(sBYTE_COUNTER = 3) then
					sPIXEL_COUNTER <= sPIXEL_COUNTER + 1; -- Pixel counter
					sBYTE_COUNTER <= (0 => '1', others => '0'); -- Pixel bytes counter
				else
					sBYTE_COUNTER <= sBYTE_COUNTER + 1; -- Pixel bytes counter
				end if;
			elsif(sCLR_REG = '1') then
				sPIXEL_COUNTER <= (others => '0'); -- Pixel counter
				sBYTE_COUNTER <= (others => '0'); -- Pixel bytes counter
			end if;
		end if;
	end process;
	
	-- Flash adress generator
	process(sIMAGE_SELECT) begin
		case sIMAGE_SELECT is
			when "000" =>
				sFLASH_ADDR_IN <= (others => '0');
			when "001" =>
				sFLASH_ADDR_IN <= (20 => '1', others => '0');
			when "010" =>
				sFLASH_ADDR_IN <= (21 => '1', others => '0');
			when "011" =>
				sFLASH_ADDR_IN <= (21 downto 20 => '1', others => '0');
			when "100" =>
				sFLASH_ADDR_IN <= (22 => '1', others => '0');
			when "101" =>
				sFLASH_ADDR_IN <= (22 => '1', 20 => '1', others => '0');
			when "110" =>
				sFLASH_ADDR_IN <= (22 downto 21 => '1', others => '0');
			when others =>
				sFLASH_ADDR_IN <= (22 downto 20 => '1', others => '0');
		end case;
	end process;

	-- Flash address generator
	process(iCLK) begin
		if(iCLK'event and iCLK = '1') then
			if(sFLASH_ADDR_SET = '1') then
				sFLASH_ADDR <= sFLASH_ADDR_IN;
			elsif(sFLASH_ADDR_EN = '1') then
				sFLASH_ADDR <= sFLASH_ADDR + sRD_COUNT;
			end if;
		end if;
	end process;

	-- RAM address generator
	process(iCLK, inRST) begin
		if(inRST = '0') then
			sPOS_X <= (others => '0');
			sPOS_Y <= (others => '0');
		elsif(iCLK'event and iCLK = '1') then
			if(sRAM_ADDR_EN = '1') then
				sPOS_X <= sPOS_X + 1;
				if(sPOS_X = 15) then
					sPOS_Y <= sPOS_Y + 1;
				end if;
			end if;
		end if;
	end process;

	-- State machine register
	process(iCLK, inRST) begin
		if(inRST = '0') then
			sSTATE <= IDLE;
		elsif(iCLK'event and iCLK = '1') then
			sSTATE <= sNEXT_STATE;
		end if;
	end process;

	process(sSTATE, iREADY, iCALIB_DONE, iDATA_VALID, sPIXEL_COUNTER, sBYTE_COUNTER, sPOS_Y, sPOS_X, sRESTART) begin
		case sSTATE is
			when IDLE =>
				if(iREADY = '1' and iCALIB_DONE = '1') then
					sNEXT_STATE <= SET_FLASH_ADDR;
				else
					sNEXT_STATE <= IDLE;
				end if;
				
			when SET_FLASH_ADDR =>
				sNEXT_STATE <= SET_FLASH_CMD;
				
			when SET_FLASH_CMD =>
				sNEXT_STATE <= INC_FLASH_ADDR;
				
			when INC_FLASH_ADDR =>
				sNEXT_STATE <= WAIT_DATA;
				
			when WAIT_DATA =>
				if(iDATA_VALID = '1') then
					sNEXT_STATE <= READ_DATA;
				else
					sNEXT_STATE <= WAIT_DATA;
				end if;
				
			when READ_DATA =>
				if(sPIXEL_COUNTER < 31) then
					sNEXT_STATE <= WAIT_DATA;
				else
					if(sBYTE_COUNTER < 3) then
						sNEXT_STATE <= WAIT_DATA;
					else
						sNEXT_STATE <= SET_RAM_CMD;
					end if;
				end if;
				
			when SET_RAM_CMD =>
				if(sPOS_Y = 511 and sPOS_X = 15) then
					sNEXT_STATE <= DONE;
				else
					sNEXT_STATE <= SET_FLASH_CMD;
				end if;
				
			when others =>
				if(sRESTART = '0') then
					sNEXT_STATE <= DONE;
				else
					sNEXT_STATE <= IDLE;
				end if;
				
		end case;
	end process;

	process(sSTATE) begin
		oRD_START <= '0';
		oDONE <= '0';
		oCMD_EN <= '0';
		sREG_EN <= '0';
		sRAM_ADDR_EN <= '0';
		sFLASH_ADDR_EN <= '0';
		sCLR_REG <= '0';
		sSEL_EN <= '0';
		sFLASH_ADDR_SET <= '0';
		sRESTARTED <= '0';
		
		case sSTATE is
			when IDLE =>
				sSEL_EN <= '1';
				sRESTARTED <= '1';
				
			when SET_FLASH_ADDR =>
				sFLASH_ADDR_SET <= '1';
				
			when WAIT_DATA =>
				
			when SET_FLASH_CMD =>
				oRD_START <= '1';
				
			when INC_FLASH_ADDR =>
				sFLASH_ADDR_EN <= '1';
				
			when READ_DATA =>
				sREG_EN <= '1';
				
			when SET_RAM_CMD =>
				oCMD_EN <= '1';
				sRAM_ADDR_EN <= '1';
				sCLR_REG <= '1';
			
			when others =>
				oDONE <= '1';
			
		end case;
	end process;

	oWR_EN <= sWR_EN;
	oRD_ADDR <= sFLASH_ADDR;
	sRD_COUNT <= (6 downto 5 => '1', others => '0');
	oCMD_BYTE_ADDR <= "0000000" & sPOS_Y & "000" & sPOS_X & "0000000";
	oCMD_INSTR <= (others => '0');
	oCMD_BL <= (4 downto 0 => '1', others => '0');
	oWR_MASK <= (others => '0');
	oWR_DATA <= x"00" & sWR_DATA;

end Behavioral;