library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm_tb is
--  Port ( );
end fsm_tb;

architecture Behavioral of fsm_tb is
    component fsm
       Port (clk     : in std_logic;
          sw      : in std_logic_vector(6 downto 0);
          seg     : out std_logic_vector(6 downto 0);
          led     : out std_logic_vector(6 downto 0);
          an      : out std_logic_vector(3 downto 0);
          btnC    : in std_logic_vector(0 downto 0)
             );
    end component;
    signal clk_tb  : std_logic;
    signal seg_tb  : std_logic_vector(6 downto 0);
    signal an_tb   : std_logic_vector(3 downto 0);
    signal btnC_tb : std_logic_vector(0 downto 0);
    signal sw_tb : std_logic_vector (6 downto 0);
    signal led_tb : std_logic_vector (6 downto 0);
    
begin

    dut: entity work.fsm port map (sw=> sw_tb,led=>led_tb,clk => clk_tb, seg => seg_tb, an => an_tb, btnC => btnC_tb);
    
    clk_process :process
    begin
        clk_tb <= '0';
        wait for 5 ns;
        clk_tb <= '1';
        wait for 5 ns;
    end process;
    
    sim_process: process
    begin
        --t=0
        sw_tb<="0000000";   --correct code 
        btnC_tb(0) <= '0';
        wait for 100 us;
        --t=100
        
        
        
        -- short pulse, shouldn't work
        btnC_tb(0) <= '1';
        wait for 200 us;
        btnC_tb(0) <= '0';
        wait for 500 us;
        --t=800 desired output not change in stage but buttonc Should be 1  wrong count=0

        -- short pulse, glitch, then another short pulse
        -- together they should have worked, but due to the glitch in between they shouldn't
        btnC_tb(0) <= '1';
        wait for 350 us;
        btnC_tb(0) <= '0';
        wait for 10 us;
        btnC_tb(0) <= '1';
        wait for 350 us;
        btnC_tb(0) <= '0';
        wait for 700 us;
        --t=2210us desired output is button is 1 for 800-1150 then 810-1160us 
        
        
        
        sw_tb<="0100000";
        -- Wrong password so system count up wrong counter
        btnC_tb(0) <= '1';
        wait for 700 us;--t=2910 btnc should be 1 
        btnC_tb(0) <= '0';
        wait for 500 us;--t=3610 btnc should be one and stage should be 1 
        
         sw_tb<="0000000";   
        -- long pulse, should work, state should go from "zero" to "one"
        btnC_tb(0) <= '1';
        wait for 700 us;--t=4310 btnc should be 1 
        btnC_tb(0) <= '0';
        wait for 500 us;--t=4810 btnc should be one and stage should be 1 

        
        -- now state transition test
        btnC_tb(0) <= '1'; -- this will not work !! because the debouncing period works both ways, we should have waited approx. 150 ms more for this.
        wait for 1 ms;
    
        btnC_tb(0) <= '0';
        wait for 1 ms;--t=6810 
        
        
        
        
       
        btnC_tb(0) <= '1'; -- now this will work
        wait for 1 ms;
        btnC_tb(0) <= '0';
        wait for 1 ms; --Desired output wrong count should be 1
        --t=8810

        btnC_tb(0) <= '1'; -- now this will work
        wait for 1 ms;
        btnC_tb(0) <= '0';
        wait for 1 ms;

        sw_tb<="0000001"; -- state from "one " to "two" 
        btnC_tb(0) <= '1';
        wait for 1 ms;
        btnC_tb(0) <= '0'; 
        wait for 1 ms;
        --Desired output stage should be 2 and wrong count should be 0
        --t=10810
        
        
        btnC_tb(0) <= '1';
        wait for 1 ms;
        btnC_tb(0) <= '0';
        wait for 1 ms; --Desired output wrong count should be 1
        --t=12810
        
        
         sw_tb<="0000010";
        btnC_tb(0) <= '1'; -- state from "two" to "zero"
        wait for 1 ms;
        btnC_tb(0) <= '0';
        wait for 1 ms;
        --t=14810
        
        
        -- For lockout mode:
        btnC_tb(0) <= '1';--wrong count 1
        wait for 1 ms;
        btnC_tb(0) <= '0';
        wait for 1 ms;
        --t=16810
        
        btnC_tb(0) <= '1';--wrong count 2
        wait for 1 ms;
        btnC_tb(0) <= '0';
        wait for 1 ms;
        --t=18810
        
        btnC_tb(0) <= '1';--wrong count 3
        wait for 1 ms;
        btnC_tb(0) <= '0';
        wait for 1 ms;
        --t=20810
        
        btnC_tb(0) <= '1';--wrong count 4
        wait for 1 ms;
        btnC_tb(0) <= '0';
        wait for 1 ms;
        --t=22810
        
        btnC_tb(0) <= '1';--wrong count 5
        wait for 1 ms;
        btnC_tb(0) <= '0';
        wait for 1 ms;
        --t=24610
        
        btnC_tb(0) <= '1';--wrong count 6
        wait for 1 ms;
        btnC_tb(0) <= '0';
        wait for 1 ms;
        --t=26610
        --system lockout
        
          btnC_tb(0) <= '1';--wrong count not change it is already lockout
        wait for 1 ms;
        btnC_tb(0) <= '0';
        wait for 1 ms;
        --t=28610
        

        
        -- now long press test
        btnC_tb(0) <= '1'; -- state from "lockout" to "zero"
        wait for 10 ms;
        btnC_tb(0) <= '0';        
        wait;
        --stage should be 0 and lockout should be 0
    end process;

end Behavioral;
