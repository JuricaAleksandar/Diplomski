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
			  iSTART : in STD_LOGIC;
			  iRESTART : in STD_LOGIC;
			  oRESTARTED : out STD_LOGIC;
			  oWR_CMD : out STD_LOGIC;
			  iDATA_VALID : in STD_LOGIC;
			  iDATA : in STD_LOGIC_VECTOR (23 downto 0);
			  oDONE : out STD_LOGIC;
           oCMD_EN : out  STD_LOGIC;
           oCMD_INSTR : out  STD_LOGIC_VECTOR (2 downto 0);
           oCMD_BL : out  STD_LOGIC_VECTOR (5 downto 0);
           oCMD_BYTE_ADDR : out  STD_LOGIC_VECTOR (29 downto 0);
           oWR_EN : out  STD_LOGIC;
           oWR_MASK : out  STD_LOGIC_VECTOR (3 downto 0);
           oWR_DATA : out  STD_LOGIC_VECTOR (31 downto 0);
           iWR_COUNT : in  STD_LOGIC_VECTOR (6 downto 0);
			  oMODE_IN_EN : out STD_LOGIC);
end filter_to_ram;

architecture Behavioral of filter_to_ram is
	
	constant cH_WIDTH : integer := 3;
	constant	cV_WIDTH : integer := 8;
	constant cH_SIZE : STD_LOGIC_VECTOR (cH_WIDTH downto 0) := (others => '1');
	constant cV_SIZE : STD_LOGIC_VECTOR (cV_WIDTH downto 0) := (others => '1');
	
	type tSTATE is
	(
		RESTARTED,
		IDLE,
		ADD_TO_FIFO,
		SET_CMD,
		DONE
	);

	signal sF2R_CURRENT_STATE, sF2R_NEXT_STATE : tSTATE;
	signal sPOS_X : STD_LOGIC_VECTOR (cH_WIDTH downto 0);
	signal sPOS_Y : STD_LOGIC_VECTOR (cV_WIDTH	downto 0);
	signal sPOS_EN : STD_LOGIC;
	
begin
	
	oCMD_BYTE_ADDR <= "0000000" & sPOS_Y & "001" & sPOS_X & "0000000";
	oCMD_INSTR <= (others => '0');
	oCMD_BL <= (5 => '0', others => '1');
	oWR_MASK <= (others => '0');
	oWR_DATA <= (7 downto 0 => '0') & iDATA;
	
	--- RAM address generator ---
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sPOS_X <= (others => '0');
			sPOS_Y <= (others => '0'); 
		elsif(iCLK'event and iCLK = '1') then
			if(sPOS_EN = '1') then
				sPOS_X <= sPOS_X + 1;
				if(sPOS_X = cH_SIZE) then
					sPOS_Y <= sPOS_Y + 1;
				end if;
			end if;
		end if;
	end process;
	
	--- FSM register ---
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sF2R_CURRENT_STATE <= RESTARTED;
		elsif(iCLK'event and iCLK = '1') then
			sF2R_CURRENT_STATE <= sF2R_NEXT_STATE;
		end if;
	end process;

	--- Next state logic ---
	process(sF2R_CURRENT_STATE, iSTART, iRESTART, iDATA_VALID, iWR_COUNT, sPOS_X, sPOS_Y) begin
		case sF2R_CURRENT_STATE is
			when RESTARTED =>
				if(iSTART = '1') then
					sF2R_NEXT_STATE <= IDLE;
				else
					sF2R_NEXT_STATE <= RESTARTED;
				end if;
			
			when IDLE =>
				if(iDATA_VALID = '1') then
					sF2R_NEXT_STATE <= ADD_TO_FIFO;
				else
					sF2R_NEXT_STATE <= IDLE;
				end if;
				
			when ADD_TO_FIFO =>
				if(iWR_COUNT >= 31) then
					sF2R_NEXT_STATE <= SET_CMD;
				else
					sF2R_NEXT_STATE <= IDLE;
				end if;			
			
			when SET_CMD =>
				if(sPOS_X = cH_SIZE and sPOS_Y = cV_SIZE) then
					sF2R_NEXT_STATE <= DONE;
				else
					sF2R_NEXT_STATE <= IDLE;
				end if;
			
			when others =>
				if(iRESTART = '1') then
					sF2R_NEXT_STATE <= RESTARTED;
				else
					sF2R_NEXT_STATE <= DONE;
				end if;
			
		end case;
	end process;
	
	--- State output logic --- 
	process(sF2R_CURRENT_STATE) begin
		oCMD_EN <= '0';
		oDONE <= '0';
		sPOS_EN <= '0';
		oWR_EN <= '0';
		oWR_CMD <= '0';
		oRESTARTED <= '0';
		oMODE_IN_EN <= '0';
		
		case sF2R_CURRENT_STATE is
			when IDLE =>
			
			when ADD_TO_FIFO =>
				oWR_EN <= '1';
				
			when SET_CMD =>
				oCMD_EN <= '1';
				sPOS_EN <= '1';
				oWR_CMD <= '1';
			
			when DONE =>
				oDONE <= '1';
				oMODE_IN_EN <= '1';
			
			when others =>
				oRESTARTED <= '1';
				oMODE_IN_EN <= '1';
			
		end case;
	end process;

end Behavioral;

