library ieee;
use ieee.std_logic_1164.all;


package PROTOCOL is

-- Design Subtypes

  subtype ulogic_QuadWord is std_ulogic_vector (63 downto 0);
  subtype ulogic_DoubleWord is std_ulogic_vector (31 downto 0);
  subtype ulogic_Word is std_ulogic_vector (15 downto 0);
  subtype ulogic_Byte is std_ulogic_vector (7 downto 0);
  subtype ulogic_Nibble is std_ulogic_vector (3 downto 0);
  subtype ulogic_Bit is std_ulogic;

  subtype BV_QuadWord is bit_vector (63 downto 0);
  subtype BV_DoubleWord is bit_vector (31 downto 0);
  subtype BV_Word is bit_vector (15 downto 0);
  subtype BV_Byte is bit_vector (7 downto 0);
  subtype BV_Nibble is bit_vector (3 downto 0);
  subtype BV_Bit is bit;

  subtype BV_Config_Ad is bit_vector (5 downto 0);
  subtype BV_Mem_Ad is bit_vector (11 downto 0);


-- Design Constants

  constant c_CBE_Interrupt_Ack  : std_ulogic_vector (3 downto 0) := "0000";
  constant c_CBE_Special_Cycle  : std_ulogic_vector (3 downto 0) := "0001";
  constant c_CBE_IO_Read        : std_ulogic_vector (3 downto 0) := "0010";
  constant c_CBE_IO_Write       : std_ulogic_vector (3 downto 0) := "0011";
  constant c_CBE_Mem_Read       : std_ulogic_vector (3 downto 0) := "0110";
  constant c_CBE_Mem_Write      : std_ulogic_vector (3 downto 0) := "0111";
  constant c_CBE_Config_Read    : std_ulogic_vector (3 downto 0) := "1010";
  constant c_CBE_Config_Write   : std_ulogic_vector (3 downto 0) := "1011";
  constant c_CBE_Mem_Read_Mul   : std_ulogic_vector (3 downto 0) := "1100";
  constant c_CBE_Dual_Add_Cycle : std_ulogic_vector (3 downto 0) := "1101";
  constant c_CBE_Mem_Read_line  : std_ulogic_vector (3 downto 0) := "1110";
  constant c_CBE_Mem_Write_Inv  : std_ulogic_vector (3 downto 0) := "1111";

  constant c_BV_CBE_Interrupt_Ack  : bit_vector (3 downto 0) := "0000";
  constant c_BV_CBE_Special_Cycle  : bit_vector (3 downto 0) := "0001";
  constant c_BV_CBE_IO_Read        : bit_vector (3 downto 0) := "0010";
  constant c_BV_CBE_IO_Write       : bit_vector (3 downto 0) := "0011";
  constant c_BV_CBE_Mem_Read       : bit_vector (3 downto 0) := "0110";
  constant c_BV_CBE_Mem_Write      : bit_vector (3 downto 0) := "0111";
  constant c_BV_CBE_Config_Read    : bit_vector (3 downto 0) := "1010";
  constant c_BV_CBE_Config_Write   : bit_vector (3 downto 0) := "1011";
  constant c_BV_CBE_Mem_Read_Mul   : bit_vector (3 downto 0) := "1100";
  constant c_BV_CBE_Dual_Add_Cycle : bit_vector (3 downto 0) := "1101";
  constant c_BV_CBE_Mem_Read_line  : bit_vector (3 downto 0) := "1110";
  constant c_BV_CBE_Mem_Write_Inv  : bit_vector (3 downto 0) := "1111";

  constant Disable : bit := '0';
  constant Enable  : bit := '1';

  constant NotSet : bit := '0';
  constant Set    : bit := '1';

  constant PCI : bit := '0';
  constant INT : bit := '1';

  constant Mem : bit := '0';
  constant IO  : bit := '1';

  constant No  : bit := '0';
  constant Yes : bit := '1';

  constant Read  : bit := '0';
  constant Write : bit := '1';

  constant Reset_Counter : integer := 0;

  constant c_ulogic_DWord_Z  : std_ulogic_vector (31 downto 0) := (others => 'Z');
  constant c_ulogic_Word_Z   : std_ulogic_vector (15 downto 0) := (others => 'Z');
  constant c_ulogic_Byte_Z   : std_ulogic_vector (7 downto 0)  := (others => 'Z');
  constant c_ulogic_Nibble_Z : std_ulogic_vector (3 downto 0)  := (others => 'Z');

  constant c_BV_QWord_0  : bit_vector (63 downto 0) := (others => '0');
  constant c_BV_DWord_0  : bit_vector (31 downto 0) := (others => '0');
  constant c_BV_Word_0   : bit_vector (15 downto 0) := (others => '0');
  constant c_BV_Byte_0   : bit_vector (7 downto 0)  := (others => '0');
  constant c_BV_Nibble_0 : bit_vector (3 downto 0)  := (others => '0');

  constant c_ulogic_DWord_0  : std_ulogic_vector (31 downto 0) := (others => '0');
  constant c_ulogic_Word_0   : std_ulogic_vector (15 downto 0) := (others => '0');
  constant c_ulogic_Byte_0   : std_ulogic_vector (7 downto 0)  := (others => '0');
  constant c_ulogic_Nibble_0 : std_ulogic_vector (3 downto 0)  := (others => '0');

-- Type Definitions

  type Base_Addr_Reg is array (0 to 5) of std_ulogic_vector (31 downto 0);
  type Base_Addr_Range is array (0 to 5) of std_ulogic_vector (31 downto 12);
  type Base_Addr_Type is array (0 to 5) of bit;
  type Base_Addr_Reg_BV is array (0 to 5) of bit_vector (31 downto 0);

  type Data_Buffer_Array is array (0 to 15) of bit_vector (31 downto 0);
  type Data_BE is array (0 to 15) of bit_vector (3 downto 0);


  type CONFIGURATION_SPACE is record
                                Device_ID                  : bit_vector (15 downto 0);
                                Vendor_ID                  : bit_vector (15 downto 0);
                                Status                     : bit_vector (15 downto 0);
                                Command                    : bit_vector (15 downto 0);
                                Class_Code                 : bit_vector (23 downto 0);
                                Revision_ID                : bit_vector (7 downto 0);
                                BIST                       : bit_vector (7 downto 0);
                                Header_Type                : bit_vector (7 downto 0);
                                Latency_Timer              : bit_vector (7 downto 0);
                                Cacheline_Size             : bit_vector (7 downto 0);
                                Base_Address_Registers     : Base_Addr_Reg_BV;
                                Cardbus_CIS_Pointer        : bit_vector (31 downto 0);
                                Subsystem_ID               : bit_vector (15 downto 0);
                                Subsystem_Vendor_ID        : bit_vector (15 downto 0);
                                Expansion_ROM_Base_Address : bit_vector (31 downto 0);
                                Capabilities_Pointer       : bit_vector (7 downto 0);
                                Max_Lat                    : bit_vector (7 downto 0);
                                Min_Gnt                    : bit_vector (7 downto 0);
                                Interrupt_Pin              : bit_vector (7 downto 0);
                                Interrupt_line             : bit_vector (7 downto 0);
                              end record CONFIGURATION_SPACE;
  
  type CONFIGURATION_COMMAND is record
                                  Address : bit_vector (31 downto 0);
                                  Data    : bit_vector (31 downto 0);
                                end record CONFIGURATION_COMMAND;
  
  type Master_State is
    (cs_Idle, cs_Addr, cs_S_Tar, cs_Dr_Bus, cs_Turn_Ar,
     cs_M_Data); 

  type Lock_State is
    (cs_Free, cs_Busy);
  
  type Target_State is
    (cs_Idle, cs_B_Busy, cs_S_Data, cs_Backoff, cs_Turn_ar);
  
  type DATA_BUFFER is record
                        Data       : Data_Buffer_Array;
                        BE         : Data_BE;
                        Valid_Data : integer range 0 to 15;
                      end record DATA_BUFFER; 
  
end PROTOCOL;


