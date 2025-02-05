----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/14/2024 07:35:14 PM
-- Design Name: 
-- Module Name: Hex4_To_Sseg - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Hex4_To_Sseg is
    Port ( hex : in STD_LOGIC_VECTOR (3 downto 0);
           sseg : out STD_LOGIC_VECTOR (7 downto 0));
end Hex4_To_Sseg;

architecture Behavioral of Hex4_To_Sseg is

begin
    with hex select
        sseg(7 downto 0) <=
             "00000011" when "0000", --0
            "10011111" when "0001",  --1
            "00100101" when "0010",  --2
            "00001101" when "0011",  --3
            "10011001" when "0100",  --4
            "01001001" when "0101",  --5
            "01000001" when "0110",  --6
            "00011111" when "0111",  --7
            "00000001" when "1000",  --8
            "00001001" when "1001",  --9
            "00000101" when "1010",  --a
            "11000001" when "1011",  --b
            "01100011" when "1100",  --c
            "10000101" when "1101",  --d
            "01100001" when "1110",  --e
            "01110001" when "1111";  --f

end Behavioral;
