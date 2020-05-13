library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Adder is
    port (
        clk     : in std_logic;
        rst     : in std_logic;
        enbl    : in std_logic;
        add_sub : in std_logic; -- add = 0, sub = 1
        in_a    : in std_logic_vector(31 downto 0);
        in_b    : in std_logic_vector(31 downto 0);

        out_c   : out std_logic_vector(31 downto 0)
    );
end entity;

architecture with_operators of Adder is
    signal in_b_signal               : std_logic_vector(31 downto 0);
    signal out_c_signal              : std_logic_vector(31 downto 0);
begin
    process (in_a, in_b, rst, enbl, out_c_signal)
    begin
        if (rst = '1') then
            out_c_signal <= (others => '0');
        elsif (enbl = '1' ) then
            if add_sub = '1' then
                in_b_signal <= std_logic_vector(unsigned(not(in_b)) + 1);
            else
                in_b_signal <= in_b;
            end if;
            out_c_signal <= std_logic_vector(signed(in_a) + signed(in_b_signal));
        end if;
        out_c <= out_c_signal;
    end process;
end architecture;

