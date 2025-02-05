----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/14/2024 07:36:42 PM
-- Design Name: 
-- Module Name: DispMux - Behavioral
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
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dispmux is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           in0 : in STD_LOGIC_VECTOR (7 downto 0);
           in1 : in STD_LOGIC_VECTOR (7 downto 0);
           in2 : in STD_LOGIC_VECTOR (7 downto 0);
           in3 : in STD_LOGIC_VECTOR (7 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           sseg : out STD_LOGIC_VECTOR (7 downto 0));
end dispmux;

architecture Behavioral of dispmux is
    constant N: integer := 19;
    signal q_reg, q_next: unsigned (N-1 downto 0);
    signal sel: STD_LOGIC_VECTOR (1 downto 0);
begin   
    --register
    process(clk, rst)
        begin
        if rst = '1' then
            q_reg <= (others => '0');
        elsif (clk'event and clk = '1') then
            q_reg <= q_next;
        end if;
    end process;
    
    process(q_reg, q_next)
    begin
        q_next <= q_reg + 1;
        sel <= STD_LOGIC_VECTOR(q_reg(N-1 downto N-2));
    end process;
    
    process(sel)
    begin
        case sel is
            when "00" => 
                an <= "1110";
                sseg <= in0;
            when "01" =>
                an <= "1101";
                sseg <= in1;
            when "10" =>
                an <= "1011";
                sseg <= in2;
            when "11" =>
                an <= "0111";
                sseg <= in3;
        end case;
    end process;
 
end Behavioral;
