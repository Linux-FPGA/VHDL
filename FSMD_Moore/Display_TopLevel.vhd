----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/14/2024 07:46:48 PM
-- Design Name: 
-- Module Name: Display_TopLevel - Behavioral
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

entity Display_TopLevel is
    Port ( hex4_0 : in STD_LOGIC_VECTOR (3 downto 0);
           hex4_1 : in STD_LOGIC_VECTOR (3 downto 0);
           hex4_2 : in STD_LOGIC_VECTOR (3 downto 0);
           hex4_3 : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           sseg : out STD_LOGIC_VECTOR (7 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0));
end Display_TopLevel;

architecture Behavioral of Display_TopLevel is
    signal input0, input1, input2, input3 :STD_LOGIC_VECTOR(7 downto 0);
begin

    hex2sseg0: entity work.Hex4_To_Sseg
    port map(
        hex => hex4_0,
        sseg => input0);        
    hex2sseg1: entity work.Hex4_To_Sseg
    port map(
        hex => hex4_1,
        sseg => input1);
    hex2sseg2: entity work.Hex4_To_Sseg
    port map(
        hex => hex4_2,
        sseg => input2);
    hex2sseg3: entity work.Hex4_To_Sseg
    port map(
        hex => hex4_3,
        sseg => input3);
        
    DispMux: entity work.DispMux
    port map(
        clk => clk,
        rst => rst,
        in0 => input0,
        in1 => input1,
        in2 => input2,
        in3 => input3,
        an => an,
        sseg => sseg);

end Behavioral;
