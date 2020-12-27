----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.12.2020 13:51:30
-- Design Name: 
-- Module Name: accumulator_tb - Behavioral
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

entity accumulator_tb is
--  Port ( );
end accumulator_tb;

architecture Behavioral of accumulator_tb is

    -- Component declaration:
    component accumulator is
        generic (WIDTH: integer := 24);
        
        port (
            clk:    in  Std_Logic;                              -- Clock signal 
            reset:  in  Std_Logic;                              -- Asynchronous reset
            enable: in  Std_Logic;                              -- Counter enable signal
            updown: in  Std_Logic;                              -- Up-Down count if asserted (for triangle waves)
            FTW:    in  Std_Logic_Vector(WIDTH-1 downto 0);     -- Frequency Tuning Word 
            
            count:  out Std_Logic_Vector(WIDTH-1 downto 0));    -- Counter output
    end component;

    constant CLK_PERIOD:    time := 8 ns;                       -- 125 Mhz
    constant N:             integer := 16;

    -- Signal declarations:
    signal sys_clk:         Std_Logic := '0';
    signal reset, enable:   Std_Logic := '0';
    signal updown_sig:      Std_Logic := '0';
    signal ftw_sig:         Std_Logic_Vector(N-1 downto 0);
    signal count_out:       Std_Logic_Vector(N-1 downto 0);


begin

-- Component instantiation
uut: accumulator
    generic map (WIDTH => N)

    port map (
        clk     => sys_clk,
        reset   => reset,
        enable  => enable,
        updown  => updown_sig,
        FTW     => ftw_sig,
        
        count   => count_out
    );

    -- Clock generation
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
        ftw_sig <= (4 => '1', others => '0');
        wait for 2*CLK_PERIOD;
        reset <= '0';
        wait for CLK_PERIOD;
        enable <= '1';
        wait for 100 us;
        ftw_sig <= (5 => '1', others => '0');
        wait for 100 us;
        updown_sig <= '1';
        wait for 800 us;
        
    end process;


end Behavioral;
