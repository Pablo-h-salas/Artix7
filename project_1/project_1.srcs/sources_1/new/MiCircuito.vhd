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
Port (  clk : in std_logic;     -- 12MHz
        led : out std_logic );
end MiCircuito;

----------------------------------------------------------------------------------
--                                   ARQUITECTURA
----------------------------------------------------------------------------------
architecture Behavioral of MiCircuito is
--                             Declaracion de señales
signal counter : std_logic_vector(24 downto 0) := (others => '0');
signal led_state : std_logic := '0';

begin
    process(clk)
    begin
        if rising_edge(clk) then 
            counter <= counter + std_logic_vector(to_unsigned(1,25));
            if counter = std_logic_vector(to_unsigned(0,25)) then
                led_state <= not led_state;
            end if;
        end if;
     led <= led_state;
    end process;


end Behavioral;
