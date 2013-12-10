------------------------------------------------------------------------------------------
----------------------------    Global PCI    --------------------------------------------    
------------------------------------------------------------------------------------------    


package GLOBAL_PCI_CONFIG is

-- Clocks until Master has to assign IRDY after FRAME is set and GNT is given

  constant c_MasterTimeOut : integer := 8;

-- Clocks until Target has to assign DEVSEL after FRAME

  constant c_DevselTimeOut : integer := 4;

-- Number of 8 Bit Memory Registers that are implemented in the 4kb Memory block. 
-- This value may be changed in order to reduce the compilation time in vhdl2gates. 
-- It does not affect the functionality.
-- The internal memory address space can access up to 4096 Byte. vhdl2gates will
-- calculate the modulo of the address, if there are not enough memory registers
-- implemented.
  
  constant c_MemoryBlocks : integer := 256;
  
end GLOBAL_PCI_CONFIG;


------------------------------------------------------------------------------------------
----------------------------    Arbiter    -----------------------------------------------    
------------------------------------------------------------------------------------------    


package ARBITER_CONFIG is

-- number of agents attached to the bus

  constant c_Agents : integer := 4;

-- number of clocks master gets maximal priority  

  constant c_AckTimer : integer := 8;

end ARBITER_CONFIG;