----------------------------------------------------------------------------------
-- diseño : SRAM
-- funcion: Emplear la SRAM del CMODA7
-- Autor: Pablo Salas
-- fecha: 10/07/2024
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
entity SRAM is
generic(
            G_ADDR_SIZE  :   natural    := 19;
            G_DATA_SIZE  :   natural    := 8);
            
    Port ( clk      : in    STD_LOGIC; 
           MemAdr   : out   STD_LOGIC_VECTOR (G_ADDR_SIZE-1 downto 0);
           MemDB    : inout STD_LOGIC_VECTOR (G_DATA_SIZE-1 downto 0);
           RamOEn   : out   STD_LOGIC;  -- 0 lectura, X escritura
           RamWEn   : out   STD_LOGIC;  -- 0 escritura, 1 lectura?
           RamCEn   : out   STD_LOGIC); -- 0 normal, 1 standby
end SRAM;
----------------------------------------------------------------------------------
--                                   ARQUITECTURA
----------------------------------------------------------------------------------
architecture Behavioral of SRAM is
--          Definicion de tipos y señales
signal addrMem      : std_logic_vector(G_ADDR_SIZE-1 downto 0)  := (others => '0');
signal data         : std_logic_vector(G_DATA_SIZE-1 downto 0)  := (others => '0');
signal outputEnable : std_logic                                 := '0';
signal writeEnable  : std_logic                                 := '1';
signal chipEnable   : std_logic                                 := '0';

begin

process(clk)
begin
    if rising_edge(clk) then
        -- escribir en memoria 
        writeEnable <= '0';
        for i in 0 to 9 loop    
            addrMem <= std_logic_vector(to_unsigned(i,G_ADDR_SIZE));
            data    <= std_logic_vector(to_unsigned(i,G_DATA_SIZE));
        end loop;
        -- si al leer la direccion 8 aparece un 8 entonces encender un led 
    end if;
MemAdr  <= addrMem;
MemDB   <= data;
RamOEn  <= outputEnable;
RamWEn  <= writeEnable;
RamCEn  <= chipEnable;
end process;
end Behavioral;
