----------------------------------------------------------------------------------
-- diseño : MiCircuito
-- funcion: parpadear un led 
-- Autor: Pablo Salas
-- fecha: 16/01/2024
----------------------------------------------------------------------------------
--                                     LIBRERIA
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;
use IEEE.NUMERIC_STD.ALL;
----------------------------------------------------------------------------------
--                                     ENTIDAD
----------------------------------------------------------------------------------

entity MiCircuito is
generic(
    G_SIZE_OUT  : natural := 5);
Port (
      clk       : in std_logic;     -- 12MHz
      led       : out std_logic_vector(G_SIZE_OUT-1 downto 0) );
end MiCircuito;

----------------------------------------------------------------------------------
--                                   ARQUITECTURA
----------------------------------------------------------------------------------
architecture Behavioral of MiCircuito is
--                             Definicion de tipos y señales
type matriz6x5 is array (0 to 5) of std_logic_vector(G_SIZE_OUT-1 downto 0);

signal counter   : std_logic_vector(24 downto 0)            := (others => '0');
signal led_state : std_logic_vector(G_SIZE_OUT-1 downto 0)  := "00111"; -- v1 v2 R G B
signal i         : integer                                  := 0;

constant patron1 : matriz6x5 := (
                    "00111",
                    "10111",
                    "01111",
                    "00011",
                    "00101",
                    "00110");
begin
    process(clk)
    begin
        if rising_edge(clk) then 
            counter <= counter + std_logic_vector(to_unsigned(1,25));
            if counter = std_logic_vector(to_unsigned(0,25)) then
                        led_state   <= patron1(i);
                        if (i<5) then
                        i           <= i+1;
                        else
                        i           <= 0;
                        end if;                    
            end if;
        end if;
     led <= led_state;
    end process;


end Behavioral;
