-- Copyright 2017 Pedro Cuadra <pjcuadra@gmail.com>
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License. */

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- use IEEE.STD_LOGIC_ARITH.ALL;
-- use IEEE.STD_LOGIC_UNSIGNED.ALL;

--  A testbench has no ports.
entity next_state_lkup_table_tb is
end next_state_lkup_table_tb;

architecture behav of next_state_lkup_table_tb is
   --  Declaration of the component that will be instantiated.
   component next_state_lkup_table_c is
     generic (
       output : integer := 2;
       input  : integer := 1;
       memory : integer := 4);
     port (
       input_val  : in std_logic_vector(input - 1 downto 0);
       curr_state : in std_logic_vector((input * memory) - 1 downto 0);
       next_state : out std_logic_vector((input * memory) - 1 downto 0));
   end component;

   --  Specifies which entity is bound with the component.
   for nxt_st_lkp: next_state_lkup_table_c use entity work.next_state_lkup_table(shift_reg);
   signal input: std_logic_vector(0 downto 0);
   signal curr_state: std_logic_vector(3 downto 0);
   signal next_state: std_logic_vector(3 downto 0);
begin
   --  Component instantiation.
   nxt_st_lkp: next_state_lkup_table_c
    generic map(
        output => 2,
        input  => 1,
        memory => 4
    )
    port map (
      input_val => input,
      curr_state => curr_state,
      next_state => next_state
    );

   --  This process does the real job.
   process
      type pattern_type is record
         --  The inputs of the adder.
         input : std_logic_vector(0 downto 0);
         curr_state : std_logic_vector(3 downto 0);
      end record;
      --  The patterns to apply.
      type pattern_array is array (natural range <>) of pattern_type;
      constant patterns : pattern_array :=
        (("0", "0000"),
         ("0", "1000"),
         ("0", "0100"),
         ("0", "0010"),
         ("0", "0001"),
         ("1", "0000"),
         ("1", "1000"),
         ("1", "0100"),
         ("1", "0010"),
         ("1", "0001"));
   begin
      --  Check each pattern.
      for i in patterns'range loop
         --  Set the inputs.
         input <= patterns(i).input;
         curr_state <= patterns(i).curr_state;

         --  Wait for the results.
         wait for 1 ns;
         --  Check the outputs.
         -- assert s = patterns(i).s
         --    report "bad sum value" severity error;
         -- assert co = patterns(i).co
         --    report "bad carry out value" severity error;
      end loop;
      assert false report "end of test" severity note;
      --  Wait forever; this will finish the simulation.
      wait;
   end process;
end behav;
