-- =================== NUMERIC CONTROLLED OSCILLATOR =============================
-- File: NCO.vhd 
--
-- Dependencies: Accumulator.vhd
--               SineLUT_ROM.vhd
-- 
-- 
-- Created by rtlogik
-- ===============================================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity NCO is
    generic (g_ACC_WIDTH: Natural);                                   -- Accumulator bit width

    port (
        i_Clk        : in Std_Logic;                                  -- Clock signal 
        i_Enable     : in Std_Logic;                                  -- Enable oscillator
        i_FTW        : in Std_Logic_Vector(g_ACC_WIDTH-1 downto 0);   -- Frequency Tuning Word (for the acc.)
        i_WaveSelect : in Std_Logic_Vector(1 downto 0);               -- Wave selection 
        --
        o_Wave       : out Std_Logic_Vector(15 downto 0)              -- Wave output
        );             
end NCO;

architecture STRUCTURAL of NCO is
    
    ---- Components declaration ---
    component Accumulator is
        generic (g_WIDTH: Natural);
        
        port (
            i_Clk    : in  Std_Logic;                                 -- Clock signal 
            i_Enable : in  Std_Logic;                                 -- Counter enable signal
            i_Updown : in  Std_Logic;                                 -- Up-Down count if asserted (for triangle waves)
            i_FTW    : in  Std_Logic_Vector(g_WIDTH-1 downto 0);      -- Frequency Tuning Word 
            --
            o_Count  : out Std_Logic_Vector(g_WIDTH-1 downto 0));     -- Counter output
    end component;

    component SineLUT_ROM is
        port (
            i_Clk  : in Std_Logic;                                    -- Clock signal
            i_En   : in Std_Logic;                                    -- Enable signal
            i_Addr : in Std_Logic_Vector(9 downto 0);                 -- Memory addres 
            --
            o_Data : out Std_Logic_Vector(15 downto 0)                -- Output data
        );
    end component;

    ---- Signals declaration ----
    signal w_Updown       : Std_Logic;
    signal w_LutEn        : Std_Logic;
    signal w_Phase        : Std_Logic_Vector(g_ACC_WIDTH-1 downto 0);
    signal w_SineWave     : Std_Logic_Vector(15 downto 0);
    signal w_SquareWave   : Signed(15 downto 0);
    signal w_SawtoothWave : Signed(15 downto 0);
    signal w_TriangleWave : Signed(15 downto 0);

begin --================================= Architecture ====================================--
    
    ---- Components instantiation ----
    Acc_1: Accumulator
        generic map (g_WIDTH => g_ACC_WIDTH)

        port map (
            i_Clk    => i_Clk,
            i_Enable => i_Enable,
            i_Updown => w_Updown,
            i_FTW    => i_FTW,
            --
            o_Count  => w_Phase
        );
        
    SineROM_1: SineLUT_ROM
        port map(
            i_Clk    => i_Clk,
            i_En     => w_LutEn,
            i_Addr   => w_Phase(g_ACC_WIDTH-1 downto g_ACC_WIDTH-10),
            --
            o_Data   => w_SineWave
        );

    w_Updown <= '1' when i_WaveSelect = "11" else
                '0';
    
    w_LutEn  <= '1' when i_WaveSelect = "00" else
                '0';

    ---------------------------------
    -- Waveform assignment
    ---------------------------------
    w_SawtoothWave <= Signed(w_Phase(g_ACC_WIDTH-1 downto g_ACC_WIDTH-16)) - 32768;
    w_TriangleWave <= Signed(w_Phase(g_ACC_WIDTH-1 downto g_ACC_WIDTH-16)) - 32768;
    w_SquareWave   <= (w_SquareWave'left => '1', others => '0') when w_Phase(15) = '0' else
                      (w_SquareWave'left => '0', others => '1');
    -- w_SineWave directly from ROM
    
    ----------------------------------
    -- Output mux
    ----------------------------------
    with i_WaveSelect select
        o_Wave <= w_SineWave                        when "00",
                  Std_Logic_Vector(w_SquareWave)    when "01",
                  Std_Logic_Vector(w_SawtoothWave)  when "10",
                  Std_Logic_Vector(w_TriangleWave)  when "11",
                  (others => '0') when others;

end STRUCTURAL;
