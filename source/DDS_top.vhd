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

entity DDS_top is
    generic (g_ACC_WIDTH : Natural := 24);

    port (
        i_Clk        : in  Std_Logic;
        i_Enable     : in  Std_Logic;
        i_FTW        : in  Std_Logic_Vector(g_ACC_WIDTH-1 downto 0);
        i_Amp        : in  Std_Logic_Vector(7 downto 0);
        i_WaveSelect : in  Std_Logic_Vector(1 downto 0);
        --
        o_Wave       : out Std_Logic_Vector(15 downto 0)
    );
end DDS_top;

architecture arch of DDS_top is

    component NCO is
        generic (g_ACC_WIDTH: Natural);                                   -- Accumulator bit width
        port (
            i_Clk        : in Std_Logic;                                  -- Clock signal 
            i_Enable     : in Std_Logic;                                  -- Enable oscillator
            i_FTW        : in Std_Logic_Vector(g_ACC_WIDTH-1 downto 0);   -- Frequency Tuning Word (for the acc.)
            i_WaveSelect : in Std_Logic_Vector(1 downto 0);               -- Wave selection 
            --
            o_Wave       : out Std_Logic_Vector(15 downto 0)              -- Wave output
        );             
    end component;

    signal w_WaveNCO : Std_Logic_Vector(15 downto 0);
    signal r_Mult    : Signed(31 downto 0);

begin   --========================== ARCHITECTURE =================================--

    NCO_1 : NCO
        generic map (g_ACC_WIDTH => g_ACC_WIDTH)

        port map (
            i_Clk        => i_Clk,
            i_Enable     => i_Enable,
            i_FTW        => i_FTW,
            i_WaveSelect => i_WaveSelect,
            --
            o_Wave       => w_WaveNCO
        );

    -- Amplitude change
    r_Mult <= to_Integer(Unsigned(i_Amp)) * Signed(w_WaveNCO);
    
    o_Wave <= Std_Logic_Vector( r_Mult(23 downto 8) );

end architecture ; 