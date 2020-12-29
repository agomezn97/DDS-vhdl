----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.12.2020 20:52:04
-- Design Name: 
-- Module Name: nco_tb - Behavioral
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

entity NCA is
    port (
        i_Clk  : in Std_Logic;
        i_Wave : in Std_Logic_Vector(15 downto 0);
        i_Amp  : in Std_Logic_Vector(7 downto 0);
        --
        o_Wave : out Std_Logic_Vector(15 downto 0)
    );
end NCA ;

architecture arch of NCA is

    signal w_Mult : Unsigned(23 downto 0);

begin

    w_Mult <= Unsigned(i_Wave)*Unsigned(i_Amp);

    process (i_Clk)
    begin
        if rising_edge(i_Clk) then
            o_Wave <= Std_Logic_Vector( w_Mult(23 downto 8) );
        end if;
    end process;


end architecture ; 
