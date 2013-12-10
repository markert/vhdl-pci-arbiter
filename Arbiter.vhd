library ieee;
use ieee.std_logic_1164.all;
use work.PROTOCOL.all;
use work.FUNCTIONS.all;
use work.ARBITER_CONFIG.all;
use work.GLOBAL_PCI_CONFIG.all;



entity PCI_ARB is

  port (
    RESET_i, CLOCK  : in  bit;
    FRAME_i, IRDY_i : in  std_ulogic;
    REQ_i           : in  std_ulogic_vector
    (c_Agents - 1 downto 0);
    GNT_o           : out std_ulogic_vector
    (c_Agents - 1 downto 0)
    );

end entity PCI_ARB;


architecture TIME_SLOTS of PCI_ARB is

-- c_Agents is the number of Agents attached to the bus
-- c_AckTimer is the number of clocks a master gets maximal priority

-- Indicate master with maximal priority
  signal s_Token : integer range 0 to c_Agents := 0;

-- signal to increment token  
  signal s_Ack : std_ulogic := '0';

-- timer for token shifting  
  signal s_AckTimer : integer range 0 to c_AckTimer := 0;

-- counter for master timeout  
  signal s_MasterTimeout : integer range 0 to 8 := 0;

-- equal to GNT_o  
  signal s_GntSet : std_ulogic_vector (c_Agents - 1 downto 0) :=
    SetBitVector(0, c_Agents-1, '0');
  signal s_GntSet_prev : std_ulogic_vector (c_Agents - 1 downto 0);

-- 0 shows that master got problem and will not be granted    
  signal s_ReqValid : std_ulogic_vector (c_Agents - 1 downto 0) :=
    (others => '1');

  

begin

------------------------------------------------------------------------------------------
----------------------------    Ring Counter    ------------------------------------------    
------------------------------------------------------------------------------------------ 
  
  RING_COUNTER : process (CLOCK, RESET_i)
  begin  -- process RING_COUNTER
    if (RESET_i = '0') then
      s_Token <= 0;
    elsif (s_Ack = '1' and CLOCK'event and CLOCK = '1') then
      s_Token <= (s_Token + 1) mod c_Agents;
    end if;
  end process RING_COUNTER;

------------------------------------------------------------------------------------------
----------------------------    Priority Logic    ----------------------------------------    
------------------------------------------------------------------------------------------ 

  PRIORITY_LOGIC : process (REQ_i, RESET_i, CLOCK)

    variable v_Req : std_ulogic_vector (c_Agents - 1 downto 0);
    variable v_Gnt : std_ulogic_vector (c_Agents - 1 downto 0);
    
  begin  -- process PRIORITY_LOGIC
    if RESET_i = '0' then
      GNT_o         <= (others => '1');
      s_GntSet      <= (others => '0');
      s_GntSet_prev <= (others => '0');
      
    elsif (CLOCK = '1' and CLOCK'event) then
      
      s_GntSet_prev <= s_GntSet;

-- multiplex request inputs with respect to token position

      for j in 0 to c_Agents - 1 loop
        v_Req(j) := REQ_i((j + s_Token) mod c_Agents);
        if s_ReqValid((j + s_Token) mod c_Agents) = '0' then
          v_Req(j) := '1';
        end if;
      end loop;  -- j

-- set v_gnt

      for i in 0 to c_Agents - 1 loop
        if v_Req(i) = '0' then
          v_Gnt(i) := '0';
          for j in i+1 to c_Agents - 1 loop
            v_Gnt(j) := '1';
          end loop;  -- j
          exit;
        else
          v_Gnt(i) := '1';
        end if;
      end loop;  -- i

-- Arbitration parking of primary master, if no request is set

      for i in 0 to c_Agents -1 loop
        if IsEven(v_Gnt) = '1' then
          if s_ReqValid((i + s_Token) mod c_Agents) = '1' then
            v_Gnt(i) := '0';
            exit;
          end if;
        else
          exit;
        end if;
      end loop;  -- i

-- attach v_gnt of Priority Logic to correct GNT_o of the PCI Bus

      for i in 0 to c_Agents - 1 loop
        --GNT_o((i + s_Token) mod c_Agents)    <= v_Gnt(i);
        s_GntSet((i + s_Token) mod c_Agents) <= v_Gnt(i);
      end loop;  -- i
      
      if (FRAME_i /= '0' and IRDY_i /= '0' and
          s_GntSet /= s_GntSet_prev) then
        GNT_o <= (others => '1');
      else
        GNT_o <= s_GntSet;
      end if;
      
    end if;

  end process PRIORITY_LOGIC;

------------------------------------------------------------------------------------------
----------------------------    Ring Counter Timer    ------------------------------------    
------------------------------------------------------------------------------------------ 

  ACK_TIMER : process(CLOCK, RESET_i, s_AckTimer)
  begin
    if (RESET_i = '0') then
      s_Ack      <= '0';
      s_AckTimer <= 0;
      
    else
      
      if (CLOCK = '1' and CLOCK'event) then
        s_AckTimer <= (s_AckTimer + 1) mod c_AckTimer;
      end if;

      if (s_AckTimer = c_AckTimer - 1) then
        s_Ack <= '1';
      else
        s_Ack <= '0';
      end if;
      
    end if;
  end process ACK_TIMER;

------------------------------------------------------------------------------------------
----------------------------    Timeout Detection    -------------------------------------    
------------------------------------------------------------------------------------------ 

  MASTER_TIMEOUT_DETECTION : process (RESET_i, CLOCK)
  begin  -- process MASTER_TIMEOUT_DETECTION

    if (CLOCK = '1' and CLOCK'event) then
      
      if RESET_i = '0' then
        s_MasterTimeout <= 0;
        s_ReqValid      <= (others => '1');

-- set masters s_ReqValid 0 when master violates time constraints
        
      elsif (s_MasterTimeout = c_MasterTimeOut) then
        s_MasterTimeout <= 0;
        for i in 0 to c_Agents - 1 loop
          if s_GntSet(i) = '0' then
            s_ReqValid(i) <= '0';
          end if;
        end loop;  -- i

-- increment and reset Time Out timer
        
      elsif (s_MasterTimeout /= c_MasterTimeOut) then
        if (FRAME_i = '0' and IRDY_i = '1') then
          s_MasterTimeout <= s_MasterTimeout + 1;
        elsif IRDY_i = '0' then
          s_MasterTimeout <= 0;
        end if;
      end if;

-- Reset s_ReqValid to 1 if master removes REQ_i

      for j in 0 to c_Agents - 1 loop
        if REQ_i(j) = '1' and s_ReqValid(j) = '0' then
          s_ReqValid(j) <= '1';
        end if;
      end loop;  -- j
      
    end if;
    
  end process MASTER_TIMEOUT_DETECTION;
  

end architecture TIME_SLOTS;


