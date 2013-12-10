------------------------------------------------------------------------------------------
----------------------------    Global PCI    --------------------------------------------    
------------------------------------------------------------------------------------------    


package GLOBAL_PCI_CONFIG is

-- Clocks until Master has to assign IRDY after FRAME is set and GNT is given

  constant c_MasterTimeOut : integer := 8;

-- Clocks until Target has to assign DEVSEL after FRAME

  constant c_DevselTimeOut : integer := 4;
  
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
