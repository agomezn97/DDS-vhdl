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

entity DDS_tb is
end DDS_tb;

architecture SIM of DDS_tb is

    constant CLK_PERIOD : Time    := 5 ns;
    constant ACC_WIDTH  : Natural := 16;

    component DDS_top is
        generic (g_ACC_WIDTH : Natural);
    
        port (
            i_Clk        : in  Std_Logic;
            i_Enable     : in  Std_Logic;
            i_FTW        : in  Std_Logic_Vector(g_ACC_WIDTH-1 downto 0);
            i_Amp        : in  Std_Logic_Vector(7 downto 0);
            i_WaveSelect : in  Std_Logic_Vector(1 downto 0);
            --
            o_Wave       : out Std_Logic_Vector(15 downto 0)
        );
    end component;

    signal SysClk     : Std_Logic := '0';
    signal Enable     : Std_Logic := '0';
    signal FTW        : Std_Logic_Vector(ACC_WIDTH-1 downto 0);
    signal Amp        : Std_Logic_Vector(7 downto 0) := (others => '1');
    signal WaveSelect : Std_Logic_Vector(1 downto 0);
    signal WaveOut    : Std_Logic_Vector(15 downto 0);


begin

    -- Clock generation
    SysClk <= not SysClk after CLK_PERIOD/2;

    DUT: DDS_top
        generic map (g_ACC_WIDTH => ACC_WIDTH)

        port map (
            i_Clk        => SysClk,
            i_Enable     => Enable,
            i_FTW        => FTW,
            i_Amp        => Amp,
            i_WaveSelect => WaveSelect,
            --
            o_Wave       => WaveOut
        );


 
    -- Stimulus
    STIM: process
    begin

        WaveSelect <= "01";
        FTW <= (4 => '1', others => '0');
        wait for CLK_PERIOD;
        Enable <= '1';
        wait for 100 us;
        WaveSelect <= "11";
        wait for 100 us;
        WaveSelect <= "10";
        wait for 100 us;
        FTW <= (5 => '1', others => '0');
        wait for 100 us;
        WaveSelect <= "00";
        wait for 100 us;
        Amp <= "01000000";
        wait for 100 us;
        WaveSelect <= "11";
        wait for 100 us;
        WaveSelect <= "10";
        wait for 100 us;
        FTW <= (5 => '1', others => '0');
        wait for 100 us;
        WaveSelect <= "00";
        Amp <= "10000000";
        wait for 100 us;
    end process;

end SIM;

