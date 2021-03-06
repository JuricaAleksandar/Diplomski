----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:52:27 06/06/2018 
-- Design Name: 
-- Module Name:    ram_to_filter - Behavioral 
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

entity ram_to_filter is
    Port ( iCLK : in  STD_LOGIC;
           iRST : in  STD_LOGIC;
			  iSTART : in STD_LOGIC;
			  iRESTART : in STD_LOGIC;
			  oRESTARTED : out STD_LOGIC;
			  iCMD_PORT_STATE : in STD_LOGIC;
			  iDELAY_ON : in STD_LOGIC;
			  iMODE : in STD_LOGIC_VECTOR (1 downto 0);
			  iREADY_WR : in STD_LOGIC;
			  oDONE : out STD_LOGIC;
			  oCMD_EN : out  STD_LOGIC;
           oCMD_INSTR : out  STD_LOGIC_VECTOR (2 downto 0);
           oCMD_BL : out  STD_LOGIC_VECTOR (5 downto 0);
           oCMD_BYTE_ADDR : out  STD_LOGIC_VECTOR (29 downto 0);
           iCMD_FULL : in  STD_LOGIC;
           oRD_EN : out  STD_LOGIC;
           iRD_DATA : in  STD_LOGIC_VECTOR (31 downto 0);
           iRD_COUNT : in  STD_LOGIC_VECTOR (6 downto 0);
			  oWR_EN : out  STD_LOGIC;
           oWR_ADDR : out  STD_LOGIC_VECTOR (3 downto 0);
           oWR_DATA : out  STD_LOGIC_VECTOR (23 downto 0);
			  oWR_DONE : out STD_LOGIC;
			  oDIRECT_WRITE_EN : out STD_LOGIC;
			  oMODE_IN_EN : out STD_LOGIC);
			  
end ram_to_filter;

architecture Behavioral of ram_to_filter is

	constant cH_WIDTH : integer := 8;
	constant	cV_WIDTH : integer := 8;
	constant cH_SIZE : STD_LOGIC_VECTOR (cH_WIDTH downto 0) := (others => '1');
	constant cV_SIZE : STD_LOGIC_VECTOR (cV_WIDTH downto 0) := (others => '1');
	
	type tSTATE is
	(
		IDLE,
		SET_BL,
		GEN_ADDR,
		CHECK_ADDR,
		Y_LOW,
		Y_HIGH,
		X_LOW,
		X_HIGH,
		SET_CMD,
		WAIT_CMD_PORT,
		CHECK_COUNT,
		WAIT_FIFO,
		WAIT_DATA,
		DIRECT_WRITE_PREPARE,
		DIRECT_WRITE,
		CHECK_READY,
		WRITE_PIXEL,
		WRITE_PADDING,
		INC_BASE_ADDR,
		DELAY,
		DONE
	);

	signal sR2F_CURRENT_STATE, sR2F_NEXT_STATE : tSTATE;

	signal sCMD_CNT : STD_LOGIC_VECTOR (3 downto 0);
	signal sCMD_CNT_EN : STD_LOGIC;
	signal sBASE_POS_X : STD_LOGIC_VECTOR (cH_WIDTH downto 0);
	signal sBASE_POS_Y: STD_LOGIC_VECTOR (cV_WIDTH downto 0);
	signal sBASE_POS_EN : STD_LOGIC;
	signal sCMD_COUNT : STD_LOGIC_VECTOR (3 downto 0);
	signal sCMD_CNT_CONTROL : STD_LOGIC;
	signal sPOS_X_OFFSET : STD_LOGIC_VECTOR (cH_WIDTH downto 0);
	signal sPOS_Y_OFFSET : STD_LOGIC_VECTOR (cV_WIDTH downto 0);
	signal sPOS_X : STD_LOGIC_VECTOR (cH_WIDTH downto 0);
	signal sPOS_Y : STD_LOGIC_VECTOR (cV_WIDTH downto 0);
	signal sPOS_X_CONTROL, sPOS_Y_CONTROL : STD_LOGIC;
	signal sPOS_X_EN, sPOS_Y_EN : STD_LOGIC;
	signal sCMD_BL, sCMD_BL_REG : STD_LOGIC_VECTOR (5 downto 0);
	signal sCMD_BL_EN : STD_LOGIC;
	signal sCMD_BL_CONTROL : STD_LOGIC;
	signal sREAD_PIX_CNT : STD_LOGIC_VECTOR (3 downto 0);
	signal sREAD_PIX_EN : STD_LOGIC;
	signal sREAD_PIX_RST : STD_LOGIC;
	signal sBUFFER_ADDR: STD_LOGIC_VECTOR (3 downto 0);
	signal sBUF_ADDR_RST : STD_LOGIC;
	signal sDELAY_COUNTER : STD_LOGIC_VECTOR (11 downto 0);
	signal sDELAY_CNT_EN : STD_LOGIC;
	
begin

	oWR_ADDR <= sBUFFER_ADDR;

	oCMD_BL <= sCMD_BL_REG;
	
	sCMD_BL <= "000010" when iMODE = "11"
		else "001000" when iMODE = "01"
		else (others => '0');
		
	sCMD_COUNT <= x"3" when iMODE = "11"
		else x"1" when iMODE = "01" or iMODE = "00"
		else x"9";
	
	sPOS_X_OFFSET <= (0 => '1', others => '0') when iMODE = "11"
		else (2 => '1', others => '0') when iMODE = "01"
		else (others => '0');
		
	sPOS_Y_OFFSET <= (0 => '1', others => '0') when iMODE = "11"
		else (2 => '1', others => '0') when iMODE = "10"
		else (others => '0');
	
	oCMD_BYTE_ADDR <= "0000000" & sPOS_Y & "000" & sPOS_X & "00";
	
	oCMD_INSTR <= "011" when iMODE = "11" or iMODE = "10"
		else "001";
	
	process(iCLK) begin
		if(iCLK'event and iCLK = '1') then
			if(sDELAY_CNT_EN = '1') then
				sDELAY_COUNTER <= sDELAY_COUNTER + 1;
			else
				sDELAY_COUNTER <= (others => '0');
			end if;
		end if;
	end process;
	
	--- Buffer address generator
	process(iCLK) begin
		if(iCLK'event and iCLK = '1') then
			if(iRST = '1' or sBUF_ADDR_RST = '1') then
				sBUFFER_ADDR <= (others => '0');
			else
				sBUFFER_ADDR <= sBUFFER_ADDR + 1;
			end if;
		end if;
	end process;
	
	--- Read pixel counter
	process(iCLK) begin
		if(iCLK'event and iCLK = '1') then
			if(iRST = '1' or sREAD_PIX_RST = '1') then
				sREAD_PIX_CNT <= (others => '0');
			elsif(sREAD_PIX_EN = '1') then
				sREAD_PIX_CNT <= sREAD_PIX_CNT + sCMD_BL_REG(3 downto 0) + 1;
			end if;
		end if;
	end process;
	
	--- Burst lenght register
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sCMD_BL_REG <= (others => '0');
		elsif(iCLK'event and iCLK = '1') then
			if(sCMD_BL_EN = '1') then
				if(sCMD_BL_CONTROL = '1') then
					sCMD_BL_REG <= sCMD_BL;
				else
					sCMD_BL_REG <= sCMD_BL_REG - 1;
				end if;
			end if;		
		end if;
	end process;
	
	--- Pixel x address generator
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sPOS_X <= (others => '0');
		elsif(iCLK'event and iCLK = '1') then
			if(sPOS_X_EN = '1') then
				if(sPOS_X_CONTROL = '1') then
					sPOS_X <= sPOS_X + 1;
				else
					sPOS_X <= sBASE_POS_X - sPOS_X_OFFSET;
				end if;
			end if;
		end if;
	end process;
	
	--- Pixel y address generator
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sPOS_Y <= (others => '0');
		elsif(iCLK'event and iCLK = '1') then
			if(sPOS_Y_EN = '1') then
				if(sPOS_Y_CONTROL = '1') then
					sPOS_Y <= sPOS_Y + 1;
				else
					sPOS_Y <= sBASE_POS_Y - sPOS_Y_OFFSET;
				end if;
			end if;
		end if;
	end process;
	
	--- Base pixel address generator
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sBASE_POS_X <= (others => '0');
			sBASE_POS_Y <= (others => '0');
		elsif(iCLK'event and iCLK = '1') then
			if(sBASE_POS_EN = '1') then
				sBASE_POS_X <= sBASE_POS_X + 1;
				if(sBASE_POS_X = cH_SIZE) then
					sBASE_POS_Y <= sBASE_POS_Y + 1;
				end if;
			end if;
		end if;
	end process;

	--- Read command counter
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sCMD_CNT <= (others => '0');
		elsif(iCLK'event and iCLK = '1') then
			if(sCMD_CNT_EN = '1') then
				if(sCMD_CNT_CONTROL = '1') then
					sCMD_CNT <= sCMD_CNT + 1;
				else
					sCMD_CNT <= (others => '0');
				end if;
			end if;
		end if;
	end process;

	--- FSM register 
	process(iCLK, iRST) begin
		if(iRST = '1') then
			sR2F_CURRENT_STATE <= IDLE;
		elsif(iCLK'event and iCLK = '1') then
			sR2F_CURRENT_STATE <= sR2F_NEXT_STATE;
		end if;
	end process;
	
	--- FSM next state generator
	process(sR2F_CURRENT_STATE, iDELAY_ON, iRESTART, sDELAY_COUNTER, iMODE, iCMD_PORT_STATE, sCMD_BL_REG, iSTART, sCMD_CNT, iRD_COUNT, sCMD_COUNT, sBASE_POS_Y, sBASE_POS_X, sPOS_Y, sPOS_X, sPOS_Y_OFFSET, sPOS_X_OFFSET, sREAD_PIX_CNT, iREADY_WR, sBUFFER_ADDR, iCMD_FULL) begin
		case sR2F_CURRENT_STATE is
			when IDLE =>
				if(iSTART = '1') then
					sR2F_NEXT_STATE <= SET_BL;
				else
					sR2F_NEXT_STATE <= IDLE;
				end if;
				
			when SET_BL =>
				sR2F_NEXT_STATE <= GEN_ADDR;
				
			when GEN_ADDR =>
				sR2F_NEXT_STATE <= CHECK_ADDR;
				
			when CHECK_ADDR =>
				if((sPOS_Y - sBASE_POS_Y) > sPOS_Y_OFFSET and sBASE_POS_Y < sPOS_Y_OFFSET) then
					sR2F_NEXT_STATE <= Y_LOW;
				elsif(sPOS_Y < sPOS_Y_OFFSET and sBASE_POS_Y > cV_SIZE - sPOS_Y_OFFSET) then
					sR2F_NEXT_STATE <= Y_HIGH;
				elsif(sPOS_X > sBASE_POS_X and sBASE_POS_X < sPOS_X_OFFSET) then
					sR2F_NEXT_STATE <= X_LOW;
				elsif(('0' & sPOS_X) + ('0' & sCMD_BL_REG) > cH_SIZE) then
					sR2F_NEXT_STATE <= X_HIGH;
				else
					sR2F_NEXT_STATE <= SET_CMD;
				end if;
				
			when Y_LOW|X_LOW|X_HIGH =>
				sR2F_NEXT_STATE <= CHECK_ADDR;
				
			when Y_HIGH =>
				sR2F_NEXT_STATE <= CHECK_COUNT;
			
			when SET_CMD =>
				if(iCMD_PORT_STATE = '1') then
					sR2F_NEXT_STATE <= WAIT_CMD_PORT;
				else
					sR2F_NEXT_STATE <= CHECK_COUNT;
				end if;
			
			when WAIT_CMD_PORT =>
				if(iCMD_PORT_STATE = '1') then
					sR2F_NEXT_STATE <= WAIT_CMD_PORT;
				else
					sR2F_NEXT_STATE <= CHECK_COUNT;
				end if;
			
			when CHECK_COUNT =>
				if(sCMD_CNT < sCMD_COUNT) then
					if(iCMD_FULL = '0') then
						sR2F_NEXT_STATE <= CHECK_ADDR;
					else
						sR2F_NEXT_STATE <= WAIT_FIFO;
					end if;
				else
					sR2F_NEXT_STATE <= WAIT_DATA;
				end if;
				
			when WAIT_FIFO =>
				if(iCMD_FULL = '1') then
					sR2F_NEXT_STATE <= WAIT_FIFO;
				else
					sR2F_NEXT_STATE <= CHECK_ADDR;
				end if;
				
			when WAIT_DATA =>
				if(iRD_COUNT < sREAD_PIX_CNT) then
					sR2F_NEXT_STATE <= WAIT_DATA;
				else
					if(iMODE = "00") then
						sR2F_NEXT_STATE <= DIRECT_WRITE_PREPARE;
					else
						sR2F_NEXT_STATE <= CHECK_READY;
					end if;
				end if;
				
			when DIRECT_WRITE_PREPARE =>
				sR2F_NEXT_STATE <= DIRECT_WRITE;
				
			when DIRECT_WRITE =>
				sR2F_NEXT_STATE <= INC_BASE_ADDR;
				
			when CHECK_READY =>
				if(iREADY_WR = '1') then
					sR2F_NEXT_STATE <= WRITE_PIXEL;
				else
					sR2F_NEXT_STATE <= CHECK_READY;
				end if;
			
			when WRITE_PIXEL =>
				if(sBUFFER_ADDR < 8) then
					if(sBUFFER_ADDR < sREAD_PIX_CNT - 1) then
						sR2F_NEXT_STATE <= WRITE_PIXEL;
					else
						sR2F_NEXT_STATE <= WRITE_PADDING;
					end if;
				else
					sR2F_NEXT_STATE <= INC_BASE_ADDR;
				end if;
			
			when WRITE_PADDING =>
				if(sBUFFER_ADDR < 8) then
					sR2F_NEXT_STATE <= WRITE_PADDING;
				else
					sR2F_NEXT_STATE <= INC_BASE_ADDR;
				end if;
			
			when INC_BASE_ADDR =>
				if(sBASE_POS_Y = cV_SIZE and sBASE_POS_X = cH_SIZE) then
					sR2F_NEXT_STATE <= DONE;
				elsif(iDELAY_ON = '1') then
					sR2F_NEXT_STATE <= DELAY;
				else
					sR2F_NEXT_STATE <= SET_BL;
				end if;
			
			when DELAY =>
				if(sDELAY_COUNTER = x"1FF") then
					sR2F_NEXT_STATE <= SET_BL;
				else
					sR2F_NEXT_STATE <= DELAY;
				end if;
			
			when others =>
				if(iRESTART = '1') then
					sR2F_NEXT_STATE <= IDLE;
				else
					sR2F_NEXT_STATE <= DONE;
				end if;
			
		end case;
	end process;
	
	process(sR2F_CURRENT_STATE, iRD_DATA, sBUFFER_ADDR) begin
		oCMD_EN <= '0';
		sCMD_CNT_CONTROL <= '0';
		sBASE_POS_EN <= '0';
		sCMD_CNT_EN <= '0';
		oRD_EN <= '0';
		sPOS_X_CONTROL <= '0';
		sPOS_X_EN <= '0';
		sPOS_Y_CONTROL <= '0';
		sPOS_Y_EN <= '0';
		sCMD_BL_CONTROL <= '0';
		sCMD_BL_EN <= '0';
		sREAD_PIX_EN <= '0';
		sREAD_PIX_RST <= '0';
		sBUF_ADDR_RST <= '1';
		oWR_EN <= '0';
		oWR_DATA <= (others => '0');
		oWR_DONE <= '0';
		oDONE <= '0';
		oRESTARTED <= '0';
		oDIRECT_WRITE_EN <= '0';
		oMODE_IN_EN <= '0';
		sDELAY_CNT_EN <= '0';
		
		case sR2F_CURRENT_STATE is
			when IDLE =>
				oRESTARTED <= '1';
				oMODE_IN_EN <= '1';
				
			when CHECK_ADDR|CHECK_COUNT|CHECK_READY|WAIT_DATA|WAIT_FIFO =>
		
			when SET_BL =>
				sCMD_BL_CONTROL <= '1';
				sCMD_BL_EN <= '1';
				
			when GEN_ADDR =>
				sPOS_X_EN <= '1';
				sPOS_Y_EN <= '1';
			
			when Y_LOW =>
				sPOS_Y_EN <= '1';
				sPOS_Y_CONTROL <= '1';
				sCMD_CNT_CONTROL <= '1';
				sCMD_CNT_EN <= '1';
				
			when Y_HIGH =>
				sCMD_CNT_CONTROL <= '1';
				sCMD_CNT_EN <= '1';
				
			when X_LOW =>
				sPOS_X_EN <= '1';
				sPOS_X_CONTROL <= '1';
				sCMD_BL_EN <= '1';
				
			when X_HIGH =>
				sCMD_BL_EN <= '1';
				
			when SET_CMD =>
				oCMD_EN <= '1';
				sCMD_CNT_CONTROL <= '1';
				sCMD_CNT_EN <= '1';
				sPOS_Y_EN <= '1';
				sPOS_Y_CONTROL <= '1';
				sREAD_PIX_EN <= '1';
				
			when WAIT_CMD_PORT =>
				oCMD_EN <= '1';
			
			when DIRECT_WRITE_PREPARE =>
				oDIRECT_WRITE_EN <= '1';
				oWR_DATA <= iRD_DATA(23 downto 0);
			
			when DIRECT_WRITE =>
				oRD_EN <= '1';
				oWR_DATA <= iRD_DATA(23 downto 0);
			
			when WRITE_PIXEL =>
				oWR_EN <= '1';
				oRD_EN <= '1';
				oWR_DATA <= iRD_DATA(23 downto 0);
				sBUF_ADDR_RST <= '0';
				
			when WRITE_PADDING =>
				oWR_EN <= '1';
				oWR_DATA <= (others => '0');
				sBUF_ADDR_RST <= '0';
				
			when INC_BASE_ADDR =>
				oWR_DONE <= '1';
				sBASE_POS_EN <= '1';
				sCMD_CNT_EN <= '1';
				sREAD_PIX_RST <= '1';
			
			when DELAY =>
				sDELAY_CNT_EN <= '1';
			
			when others =>
				oDONE <= '1';
				oMODE_IN_EN <= '1';
				
		end case;
	end process;

end Behavioral;

