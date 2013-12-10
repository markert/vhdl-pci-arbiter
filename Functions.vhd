library ieee;
use ieee.std_logic_1164.all;
use work.PROTOCOL.all;


package FUNCTIONS is

-- set all values of a bit_vector to '0' or '1'
  
  function SetBitVector (Start, Stop : integer; Value : std_ulogic)
    return std_ulogic_vector;

-- check if bit_vector got even number of ones    
  
  function IsEven (TestVector : std_ulogic_vector)
    return std_ulogic;

-- check if Bus Operation is write    
  
  function Is_Write (TestVector : std_ulogic_vector (3 downto 0))
    return bit;

-- check if Bus Operation is read    
  
  function Is_Read (TestVector : std_ulogic_vector (3 downto 0))
    return bit;

-- Convert Bit Vector to Standard uLogic Vector    
  
  function BVtoSLV (TestVector : bit_vector)
    return std_ulogic_vector;

-- Convert Bit Vector to Standard Logic Vector     
  
  function BVtoSLSV (TestVector : bit_vector)
    return std_logic_vector;

-- Convert Standard Logic Vector to Bit Vector
  
  function SLVtoBV (TestVector : std_ulogic_vector)
    return bit_vector;
  
  
  
end FUNCTIONS;



package body FUNCTIONS is
  
  function SLVtoBV (TestVector : std_ulogic_vector)
    return bit_vector is

    variable OutVector : bit_vector (TestVector'left downto TestVector'right);
    
  begin
    
    for i in TestVector'left downto TestVector'right loop
      if (TestVector(i) = '1') then
        OutVector (i) := '1';
      else
        OutVector (i) := '0';
      end if;
    end loop;  -- i

    return OutVector;

  end function SLVtoBV;

  function BVtoSLV (TestVector : bit_vector)
    return std_ulogic_vector is

    variable OutVector : std_ulogic_vector (TestVector'left downto TestVector'right);
    
  begin
    
    for i in TestVector'left downto TestVector'right loop
      if (TestVector(i) = '1') then
        OutVector (i) := '1';
      else
        OutVector (i) := '0';
      end if;
    end loop;  -- i

    return OutVector;

  end function BVtoSLV;

  function BVtoSLSV (TestVector : bit_vector)
    return std_logic_vector is

    variable OutVector : std_logic_vector (TestVector'left downto TestVector'right);
    
  begin
    
    for i in TestVector'left downto TestVector'right loop
      if (TestVector(i) = '1') then
        OutVector (i) := '1';
      else
        OutVector (i) := '0';
      end if;
    end loop;  -- i

    return OutVector;

  end function BVtoSLSV;

  function SetBitVector (Start, Stop : integer; Value : std_ulogic)
    return std_ulogic_vector is

    variable TempVector : std_ulogic_vector (Stop downto Start);

  begin
    
    for i in Start to Stop loop
      TempVector(i) := Value;
    end loop;
    return TempVector;
  end function SetBitVector;



  function IsEven (TestVector : std_ulogic_vector)
    return std_ulogic is

    variable OutBit : std_ulogic;

  begin
    if(TestVector(TestVector'left) /= 'Z') then
      OutBit := TestVector(TestVector'left);
      for i in TestVector'left - 1 downto TestVector'right loop
        OutBit := OutBit xor TestVector (i);
      end loop;  -- i

      OutBit := not(OutBit);
    else
      OutBit := 'Z';
    end if;

    return OutBit;
  end function IsEven;



  function Is_Write (TestVector : std_ulogic_vector (3 downto 0))
    return bit is

    variable isWrite : bit := '0';
    
  begin
    if (TestVector = c_CBE_Mem_Write or TestVector = c_CBE_IO_Write or
        TestVector = c_CBE_Config_Write or TestVector = c_CBE_Mem_Write_Inv) then
      isWrite := '1';
    end if;

    return isWrite;

  end function Is_Write;



  function Is_Read (TestVector : std_ulogic_vector (3 downto 0))
    return bit is

    variable isRead : bit := '0';
    
  begin
    if (TestVector = c_CBE_IO_Read or
        TestVector = c_CBE_Config_Read) then
      isRead := '1';
    end if;

    return isRead;

  end function Is_Read;
  


end FUNCTIONS;

