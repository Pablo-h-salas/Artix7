CmodA735T Readme

The CmodA735tDemo project was designed as a simple testing platform
for the Digilent Cmod A7-35T board. It was developed on Windows 7 using
Vivado 2016.2. The project has been tested on Centos 6.8 using Vivado 2016.2.
Any version of Vivado 2015.2 or later should generate a bit file without issues. 
I don't know if the Web version of Vivado supports the XC7A35T device.

The idea for CmodA735tDemo is to have access to the XADC, GPIO, buttons,
LEDs and external SRAM to verify that they are operational. CmodA735tDemo
uses a variety of components that I've created in past years. These
components are encapsulated in CmodA735T_test.dcp which is provided in 
Xilinx dcp format. CmodA735T_test.dcp was built using Vivado 2015.2 targeting
the XC7A35T-1CPG236C device. It includes:
  UART_RegAccess
  pwm
  
  
CmodA735T_test.dcp:
  UART_RegAccess is a debug utility IP that uses a UART interface. It's 
  main purpose is to provide access to FPGA internal resources from any 
  computer equipped with a USB UART. It was designed to be an easy way to 
  write/read FPGA registers either from typing commands into a terminal or
  using a program. The UART interface is part of UART_RegAccess.It is 
  parameterized to support a user selected number of registers, each having 
  a user selected width ( in 4-bit CHARS ), and user selected UART baud rate. 
  The version supplied in CmodA735T_test has the input parameters set to the 
  following values:
    DBG_UART : UART_RegAccess 
    generic map(
      CLK_RATE        => 100000000, -- 100 MHz
      BAUD_RATE       => 921600,    -- 921600
      NUM_REGISTERS   => 16,        -- 16 registers
      REGISTER_CHARS  => 8,         -- 32-bit register width
      ADDRESS_CHARS   => 1)         -- 4-bit register address with
    The UART is fixed for 8-bit data, no parity, 1 stop bit, no hardware or 
    software flow control
    
  All 16 registers are used in CmodA735T_test to access the XC7A35T resources.
    
  pwm was designed for use in an oven controller to create PWM outputs synchronized to
  power line zero voltage crossings. It works fine for lighting the tri-color LED on
  the Cmod A7-35T for test purposes. 

Using UART_RegAccess:
  The UART used in UART_RegAccess has a fifo depth of 1 meaning that software
  writing to FPGA registers through the UART_RegAccess IP can over-write data 
  as there is no flow control. This is not an issue when a user is typing commands 
  into a terminal and easily resolved by adding a small delay between back-to-back 
  write commands performed in software.

  Between UART_RegAccess and an FPGA, data is transferred as std_logic_vectors. 
  Between UART_RegAccess and the UART, data is in the form of ascii encoded hex 
  digits ( 7-bits ). Commands are single ascii encoded characters ( 7-bits ).
  The UART_RegAccess Command set is pretty simple in the version supplied with CmodA735T_test:
    ascii 'W' writes to an FPGA register
    ascii 'R' reads from an FPGA register
    
  Command fields are delimited by an ascii space ' '. User input is expected to be 
  in uppercase. Command lines are delimited with an ascii carriage return or line feed.
    
  The format for writing to a register is: 'W Reg# data'. As an example to write 
  0x0123ABCD to the 32-bit Reg10 using a keyboard and terminal connected to UART_RegAccess 
  the command would be 'W A 0123ABCD' <ENTER> 
  Leading zeros in data input ignored. As an example using a program to write 0x00000005 
  to Reg1 the command string would be 'W 1 5/n'.
  
  The format for reading a FPGA register is: 'R reg#'. UART_RegAccess responds 
  with a formatted string in the form '0xReg# 0xdata'. So if you type in the command 
  'R F' to read Reg15 UART_RegAccess sends the string '0xF 0x00000000' assuming that 
  Reg15 held the value X"00000000".
  
  It helps to set up your terminal program to enhance readability. In Putty I use 
  the following non-default settings:
    Terminal
      Auto wrap mode initially on
      Implicit CR in every LF
      Implicit LF in every CR
          Local echo: force on

CmodA735tDemo IO:          
It is important to note that the GPIO in CmodA735tDemo has been consolidated into 3 distinct
groups. Group A IO are the pins on the left side of the board (pins 1..14 and 17..23)
excluding the analog inputs. Group B IO are the pins on the right side of the board
(pins 26..48). The ordering of the IO is such that IOGroupA(0) is opposite IOGroupB(0). The
pins opposite the analog inputs on IOGroupB are the 2 highest bits. This was done to allow
shorting IOGroupA and IOGroupB pins together to verify that all of the IO work. CmodA735tDemo
was designed to ensure that either IOGroupA or IOGroupB or output pins for both groups are in 
tri-state to avoid contention. The PMOD IO output enables are independent of the other GPIO 
so its pins should NOT be shorted to any of the IOGroupA or IOGroupB pins without EXTREME CARE.       
IOGroupA has 21 GPIO
IOGroupB has 23 GPIO
PMOD has 8 GPIO


Software:
To simplify using the CmodA735tDemo CmodA735tDemo/Src/C7Test.py is a Python program 
that allows you to  easily read the FPGA temperature sensor, set the GPIO, read
GPIO, change the tricolor LED display and read or write any address in the external 
SRAM. Usage is fairly well documented in the file C7Test.py. I addition, it illustrates
using the UART_RegAccess through a UART.

Using the demo:

  Demo Requirements:
    Cmod A7-35T
    Python 2.7
    Pyserial 2.7
    Vivado 2015.2 or later

To create a configuration file:
  - Open Vivado ( ISE does not support the Cmod A7 devices ) and create
    a new project named CmodA735tDemo. The device is a XC7A35T-1CPG236C.
  - Add Design sources from CmodA735tDemo\Src:
    - CmodA735T_Demo.vhd
    - CmodA735T_test.dcp
  - Add IP from CmodA735tDemo\Src:
    - clk_wiz_0.xci  
  - Add Constraints from CmodA735tDemo\Src:
    CmodA735tDemo.xdc
  - Generate a bitstream
  - attach the Cmod A7-35T to a USB port or hub on your PC
  - configure the FPGA
  - close Vivado. (See Note 1)
  - run CmodA735tDemo\Software\C7Test.py
  
Cmod A7-35T BTN0 is used as an asynchronous reset   

NOTES:
  (1) The design of the programming/UART interface on the Cmod A7-35T
      presents problems for programs using the UART while Vivado is using
      the JTAG interface. In theory, they are enumerated as separate ports
      but trying to use C7Test.py while Vivado is running will cause both to
      lose connections as Vivado continuously checks the connection to the hw-server. 
      You will have to unplug/plug the USB cable to continue when this 
      happens. In Windows the Adept Utility and C7Test in a DOS box seem
      to co-exist so I use the Adept Utility to program the device.
  (2) As the USB port provides power for the Cmod A7-35T configuring the FPGA
      on one platform and using the board on another is a bit of a problem. One
      way around this is to use a USB 2.0 switch. It is then possible to configure
      the board on one PC and run CyTest.py on another if required.     