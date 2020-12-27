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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity nco_tb is
--  Port ( );
end nco_tb;

architecture Behavioral of nco_tb is

    constant CLK_PERIOD:    Time    := 5 ns;
    constant N:             Integer := 16;

    component nco is
        generic (g_ACC_WIDTH: Integer);                                   -- Accumulator bit width
    
        port (
            i_clk:        in Std_Logic;                                   -- Clock signal 
            i_enable:     in Std_Logic;                                   -- Enable oscillator
            i_FTW:        in Std_Logic_Vector(g_ACC_WIDTH-1 downto 0);      -- Frequency Tuning Word (for the acc.)
            i_WaveSelect:  in Std_Logic_Vector(1 downto 0);                -- Wave selection 
         
            o_Wave:     out Std_Logic_Vector(15 downto 0));             -- Wave output
    end component;

    signal sys_clk, reset, enable: Std_Logic := '0';
    signal ftw_sig:        Std_Logic_Vector(N-1 downto 0);
    signal wv_select_sig:  Std_Logic_Vector(1 downto 0);          
    signal output_sig:     Std_Logic_Vector(15 downto 0);

begin

    dut: nco
        generic map (g_ACC_WIDTH => N)

        port map (
            i_clk         => sys_clk,      
            i_enable      => enable,  
            i_FTW         => ftw_sig,
            i_WaveSelect  => wv_select_sig,
         
            o_Wave      => output_sig
        );

    -- Clock generation:
    clk_process: process
    begin
        sys_clk <= '0';
        wait for CLK_PERIOD/2;
        sys_clk <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Stimulus
    stim: process
    begin
        reset <= '1';
        wait for 2*CLK_PERIOD;
        reset <= '0';
        wv_select_sig <= "01";
        ftw_sig <= (4 => '1', others => '0');
        wait for CLK_PERIOD;
        enable <= '1';
        wait for 100 us;
        wv_select_sig <= "11";
        wait for 100 us;
        wv_select_sig <= "10";
        wait for 100 us;
        ftw_sig <= (5 => '1', others => '0');
        wait for 100 us;
        wv_select_sig <= "00";
        wait for 100 us;
    end process;




end Behavioral;

