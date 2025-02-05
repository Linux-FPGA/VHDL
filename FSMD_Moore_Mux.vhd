----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/31/2025 09:22:23 AM
-- Design Name: 
-- Module Name: FSMD_Moore_Mux - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FSMD_Moore_Mux is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           btnu : in STD_LOGIC;
           btnd : in STD_LOGIC;
           btnl : in STD_LOGIC;
           btnr : in STD_LOGIC;
           btnc : in STD_LOGIC;
           output : out STD_LOGIC_VECTOR (15 downto 0));
end FSMD_Moore_Mux;

architecture Behavioral of FSMD_Moore_Mux is
    signal cal, subtract, sel_out, max_tick, start_counting, enable_sel : STD_LOGIC := '0';
    signal sel  :STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
    signal b2h :STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
    signal internal_memory, button_press, button_result : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');

    type state_addsub_type is (IDLE, Adder, Sub);
    signal state_reg_addsub, state_next_addsub : state_addsub_type;
    
    type state_type is (Mux0, Button0, Button1, Button2, Button3, Mux1);
    signal state_reg, state_next : state_type;
    
    signal btnu_reg,btnd_reg,btnl_reg, btnr_reg, btnc_reg : STD_LOGIC := '0';
    
    constant SECOND : integer :=  150000000;
    signal count : integer range 0 to SECOND := 0;
    
begin
------------------------------------------------------------ counter counts 1.5 second to display button press. 
    --count 2s
    process(clk,rst,count,max_tick,cal)
    begin
        if(rst = '1') then
            count <= 0;
            max_tick <= '0';
        elsif rising_edge (clk) then
            if(start_counting = '1') then
                if(count = SECOND - 1) then
                    count <= 0;
                    max_tick <= '1';
                else    
                    count <= count + 1 ;
                    max_tick <= '0';
                end if;
            else
                count <= 0;
            end if;
         end if;
     end process;
  ---------------------------------------------------------------  
    --copy input to register
    process(clk,rst,btnu_reg, btnd_reg,btnl_reg, btnr_reg, btnc_reg)
    begin
        if (rst = '1') then
            btnu_reg <= '0';
            btnd_reg <= '0';
            btnl_reg <= '0';
            btnr_reg <= '0';
            btnc_reg <= '0';
        elsif rising_edge (clk) then  
            btnu_reg <= btnu;
            btnd_reg <= btnd;
            btnl_reg <= btnl;
            btnr_reg <= btnr;
            btnc_reg <= btnc;
        end if;
    end process;
  -----------------------------------------------------------------------  Controller switches from IDLE to add and subtract    
    --state register
    process(clk,rst)
    begin
        if(rst = '1') then
            state_reg_addsub <= IDLE;
        elsif rising_edge (clk) then
            state_reg_addsub <= state_next_addsub;
        end if;
    end process;
    
    -- next-state/output-logic/ Switch IDLE, Adder and Sub
    process(state_reg_addsub,state_next_addsub,btnc_reg, cal,subtract)
    begin
        state_next_addsub <= state_reg_addsub;
        cal <= '0';
        case state_reg_addsub is
            when IDLE =>
                if (btnc_reg = '1') then
                    state_next_addsub <= Adder;
                else
                    state_next_addsub <= IDLE;
                end if;
            
            when Adder =>
                cal <= '1';
                subtract <= '0';
                if (btnc_reg = '1') then
                    state_next_addsub <= Sub;
                else
                    state_next_addsub <= Adder;
                end if;
            
            when Sub =>
                cal <= '1';
                subtract <= '1';
                if(btnc_reg = '1') then
                    state_next_addsub <= IDLE;
                else
                    state_next_addsub <= Sub;
                end if;
                
        end case;
     end process;
 ------------------------------------------------------------------ controller how and when calculate value when button press.    
      --state register
    process(clk,rst)
    begin
        if(rst = '1') then
            state_reg <= Mux0;
        elsif rising_edge (clk) then
            state_reg <= state_next;
        end if;
    end process;
     
    --state-next/output logic / Switch Mux0 -> Mux1
    process(state_reg,state_next, btnu_reg, btnd_reg, btnl_reg, btnr_reg, btnc_reg, start_counting,sel, sel_out,max_tick)
    begin
        state_next <= state_reg;
        sel_out <= '0';
        start_counting <= '0';
        enable_sel <= '0';
        case state_reg is
            when Mux0 =>
                if(btnu_reg = '1') then
                    state_next <= Button0;
                else
                    if(btnd_reg = '1') then
                        state_next <= Button1;
                    else
                        if (btnl_reg = '1') then
                            state_next <= Button2;
                        else
                            if(btnr_reg = '1') then
                                state_next <= Button3;
                            else
                                state_next <= Mux0;
                            end if;
                        end if;
                    end if;
                end if;
           
           when Button0 => 
                sel <= "00";
                enable_sel <= '1';
                if(cal = '1') then
                    state_next <= Mux1;
                else
                    state_next <= Mux0;
                end if;
           
           when Button1 =>
                sel <= "01";
                enable_sel <= '1';
                if(cal = '1') then
                    state_next <= Mux1;
                else
                    state_next <= Mux0;
                end if;
          
          when Button2 =>
                sel <= "10";
                enable_sel <= '1';
                if(cal = '1') then
                    state_next <= Mux1;
                else
                    state_next <= Mux0;
                end if;
          
          when Button3 =>
                sel <= "11";
                enable_sel <= '1';
                if(cal = '1') then
                    state_next <= Mux1;
                else
                    state_next <= Mux0;   
                end if;
           
          when Mux1 => 
                start_counting <= '1';
                sel_out <= '1';
                enable_sel <= '0';
                    if(max_tick = '1') then
                        state_next <= Mux0;
                    else
                        state_next <= Mux1;
                    end if;
         end case;
     end process;   
                
  ------------------------------------------------------------------------------- register to convert button press to value to feed to adder and subtraction. 
  
  process(clk, rst, sel, b2h, enable_sel)
begin
    if (rst = '1') then
        b2h <= (others => '0');
    elsif rising_edge(clk) then
        
        if(enable_sel = '1') then
            -- Normal behavior when enable_sel = '1'
            with sel select 
                b2h(15 downto 0) <=
                    "0000000000000001" when "00",
                    "0000000000000101" when "01",
                    "0000000000001010" when "10",
                    "0000000000010100" when "11",
                    "0000000000000000" when others;
        else
            b2h(15 downto 0) <= "0000000000000000"; -- Equivalent to when sel = "11"
        end if;
    end if;
end process;
  
---------------------------------------------------------------------------------------------------------------- register to convert button press to value. 


    process(btnu_reg,btnd_reg,btnl_reg,btnr_reg,clk,rst)
    begin
        if (rst = '1') then
            button_press <= (others => '0');
       elsif rising_edge (clk)  then
                if(btnu_reg = '1') then
                    button_press <= "0000000000000001";
                elsif(btnd_reg = '1') then
                    button_press <= "0000000000000101";
                elsif(btnl_reg = '1') then
                    button_press <= "0000000000001010";
                elsif(btnr_reg = '1') then
                    button_press <= "0000000000010100";
            end if;
        end if;
    end process;
-------------------------------------------------------------------------------------------data path to update the calculation. 
   process(internal_memory,b2h,button_press, clk,rst)
    begin   
        if(rst = '1') then
            internal_memory <= (others => '0');
        elsif rising_edge (clk) then
            if(cal = '1') then              
                if(subtract = '0') then
                    internal_memory <= STD_LOGIC_VECTOR(unsigned(internal_memory) + unsigned(b2h));                 
                elsif(subtract = '1') then
                    internal_memory <= STD_LOGIC_VECTOR(unsigned(internal_memory) - unsigned(b2h));                   
                end if;               
            end if;
        end if;
    end process;
    --------------------------------------------Mux to show button press in 1s and switch to calculation value.          
   process(sel_out)
   begin
        case sel_out is
            when '0' => 
                output <= internal_memory;
            when '1'=>
                output <= button_press;
            when others => 
                output <= "0000000000000000";
        end case;
   end process;  
                    

end Behavioral;
