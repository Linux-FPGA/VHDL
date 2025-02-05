----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/26/2024 11:51:57 AM
-- Design Name: 
-- Module Name: debouncer_ASMD - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity debouncer_ASMD is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           input : in STD_LOGIC;
           db : out STD_LOGIC);
end debouncer_ASMD;

architecture Behavioral of debouncer_ASMD is

 constant N: integer := 20;
    type state_type is (ZERO, Wait1_1, Wait1_2, Wait1_3, ONE, Wait0_1, Wait0_2, Wait0_3);
    signal state_reg, state_next : state_type;
    signal q_reg, q_next : unsigned(N-1 downto 0);
    signal m_tick : STD_LOGIC;
begin
    
    --this process controls register current and next
    process(clk,reset)
    begin
        if reset = '1' then
            q_reg <= (others => '0');
        elsif rising_edge(clk) then
            q_reg <= q_next;
       end if;
    end process;
    
        -- counter 10 ms tick
    --this process controls keep counting until it reaches to maximux value = (20^20 - 1) = 1048575 (bianry : 1111_1111_1111_1111_1111) 
    --  T = 2^N / F => T = 1048575 / (100-000-000) = 0.01 s = 10 ms
    process(q_reg,q_next)
    begin
        q_next <= q_reg + 1;
        m_tick <= '1' when q_reg <= 0 else '0';
    end process;
    -------------------------------------------
    
    --State register
    process(clk,reset)
    begin
        if(reset = '1') then
            state_reg <= ZERO;
        elsif rising_edge(clk) then
            state_reg <= state_next;
        end if;
     end process;
     
    --next state, output logic.
    process(state_reg, state_next)
    begin
        state_next <= state_reg;
        db <= '0';
        case state_reg is
            when ZERO =>
                if(input = '1') then
                    state_next <= Wait1_1;
                else
                    state_next <= ZERO;
                end if;
            
            when Wait1_1 =>
                if(input = '0') then
                    state_next <= ZERO;
                else         
                    if(m_tick = '1') then
                        state_next <= Wait1_2;
                    end if;
                end if;
                
            when Wait1_2 =>
                if (input = '0') then
                    state_next <= ZERO;
                else
                    if(m_tick = '1') then
                        state_next <= Wait1_3;
                    end if;
                end if;
            
            when Wait1_3 =>
                if(input = '0') then
                    state_next <= Zero;
                else
                    if(m_tick = '1') then
                        state_next <= ONE;
                    end if;
                end if ; 
                
                
            When One =>  
                db <= '1';
                if(input = '1') then
                    State_next <= ONE;
                else
                    if(m_tick = '1') then
                        state_next <= Wait0_1;
                    end if;
                end if;
                
                
            when wait0_1 =>
                if(input = '1') then
                    state_next <= ONE;
                else
                    if(m_tick = '1') then
                        state_next <= Wait0_2;
                    end if;
                end if;
            
            when Wait0_2 =>
                if(input = '1') then
                    state_next <= ONE;
                else 
                    if(m_tick <= '1') then
                        state_next <= Wait0_3;
                    end if;
                end if;
            
            when Wait0_3 =>
                if(input = '1') then
                    state_next <= ONE;
                else 
                    if(m_tick = '1') then
                        state_next <= ZERO;
                    end if;
                end if;
                
        end case;
    end process;


end Behavioral;
