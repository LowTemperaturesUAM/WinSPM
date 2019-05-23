Attribute VB_Name = "D2XX_Module"
Option Explicit

'xxx Public fMainForm As DEMO_EEPROM

'===========================
'CLASSIC INTERFACE
'===========================
Public Declare Function FT_ListDevices Lib "FTD2XX.DLL" (ByVal arg1 As Long, ByVal arg2 As String, ByVal dwFlags As Long) As Long
Public Declare Function FT_GetNumDevices Lib "FTD2XX.DLL" Alias "FT_ListDevices" (ByRef arg1 As Long, ByVal arg2 As String, ByVal dwFlags As Long) As Long

Public Declare Function FT_Open Lib "FTD2XX.DLL" (ByVal intDeviceNumber As Integer, ByRef lngHandle As Long) As Long
Public Declare Function FT_OpenEx Lib "FTD2XX.DLL" (ByVal arg1 As String, ByVal arg2 As Long, ByRef lngHandle As Long) As Long
Public Declare Function FT_Close Lib "FTD2XX.DLL" (ByVal lngHandle As Long) As Long
Public Declare Function FT_Read Lib "FTD2XX.DLL" (ByVal lngHandle As Long, ByVal lpszBuffer As String, ByVal lngBufferSize As Long, ByRef lngBytesReturned As Long) As Long
Public Declare Function FT_Write Lib "FTD2XX.DLL" (ByVal lngHandle As Long, ByVal lpszBuffer As String, ByVal lngBufferSize As Long, ByRef lngBytesWritten As Long) As Long
Public Declare Function FT_WriteByte Lib "FTD2XX.DLL" Alias "FT_Write" (ByVal lngHandle As Long, ByRef lpszBuffer As Any, ByVal lngBufferSize As Long, ByRef lngBytesWritten As Long) As Long
Public Declare Function FT_SetBaudRate Lib "FTD2XX.DLL" (ByVal lngHandle As Long, ByVal lngBaudRate As Long) As Long
Public Declare Function FT_SetDataCharacteristics Lib "FTD2XX.DLL" (ByVal lngHandle As Long, ByVal byWordLength As Byte, ByVal byStopBits As Byte, ByVal byParity As Byte) As Long
Public Declare Function FT_SetFlowControl Lib "FTD2XX.DLL" (ByVal lngHandle As Long, ByVal intFlowControl As Integer, ByVal byXonChar As Byte, ByVal byXoffChar As Byte) As Long
Public Declare Function FT_SetDtr Lib "FTD2XX.DLL" (ByVal lngHandle As Long) As Long
Public Declare Function FT_ClrDtr Lib "FTD2XX.DLL" (ByVal lngHandle As Long) As Long
Public Declare Function FT_SetRts Lib "FTD2XX.DLL" (ByVal lngHandle As Long) As Long
Public Declare Function FT_ClrRts Lib "FTD2XX.DLL" (ByVal lngHandle As Long) As Long
Public Declare Function FT_GetModemStatus Lib "FTD2XX.DLL" (ByVal lngHandle As Long, ByRef lngModemStatus As Long) As Long
Public Declare Function FT_SetChars Lib "FTD2XX.DLL" (ByVal lngHandle As Long, ByVal byEventChar As Byte, ByVal byEventCharEnabled As Byte, ByVal byErrorChar As Byte, ByVal byErrorCharEnabled As Byte) As Long
Public Declare Function FT_Purge Lib "FTD2XX.DLL" (ByVal lngHandle As Long, ByVal lngMask As Long) As Long
Public Declare Function FT_SetTimeouts Lib "FTD2XX.DLL" (ByVal lngHandle As Long, ByVal lngReadTimeout As Long, ByVal lngWriteTimeout As Long) As Long
Public Declare Function FT_GetQueueStatus Lib "FTD2XX.DLL" (ByVal lngHandle As Long, ByRef lngRxBytes As Long) As Long
Public Declare Function FT_SetBreakOn Lib "FTD2XX.DLL" (ByVal lngHandle As Long) As Long
Public Declare Function FT_SetBreakOff Lib "FTD2XX.DLL" (ByVal lngHandle As Long) As Long
Public Declare Function FT_GetStatus Lib "FTD2XX.DLL" (ByVal lngHandle As Long, ByRef lngRxBytes As Long, ByRef lngTxBytes As Long, ByRef lngEventsDWord As Long) As Long
Public Declare Function FT_SetEventNotification Lib "FTD2XX.DLL" (ByVal lngHandle As Long, ByVal dwEventMask As Long, ByVal pVoid As Long) As Long
Public Declare Function FT_ResetDevice Lib "FTD2XX.DLL" (ByVal lngHandle As Long) As Long
'Public Declare Function FT_SetDivisor Lib "FTD2XX.DLL" (ByVal lngHandle As Long, ByVal shDivisor) As Short

'Public Declare Function FT_GetEventStatus Lib "FTD2XX.DLL" (ByVal lngHandle As Long, ByRef lngEventsDWord As Long) As Long

 Public Declare Function FT_GetBitMode Lib "FTD2XX.DLL" (ByVal lngHandle As Long, ByRef intData As Any) As Long
 Public Declare Function FT_SetBitMode Lib "FTD2XX.DLL" (ByVal lngHandle As Long, ByVal intMask As Byte, ByVal intMode As Byte) As Long

Public Declare Function FT_SetLatencyTimer Lib "FTD2XX.DLL" (ByVal handle As Long, ByVal pucTimer As Byte) As Long
Public Declare Function FT_GetLatencyTimer Lib "FTD2XX.DLL" (ByVal handle As Long, ByRef ucTimer As Long) As Long



'=============================
'FT_W32 API
'=============================

Public Declare Function FT_W32_CreateFile Lib "FTD2XX.DLL" (ByVal lpszName As String, ByVal dwAccess As Long, ByVal dwShareMode As Long, ByRef lpSecurityAttributes As LPSECURITY_ATTRIBUTES, ByVal dwCreate As Long, ByVal dwAttrsAndFlags As Long, ByVal hTemplate As Long) As Long
Public Declare Function FT_W32_CloseHandle Lib "FTD2XX.DLL" (ByVal ftHandle As Long) As Long
Public Declare Function FT_W32_ReadFile Lib "FTD2XX.DLL" (ByVal lngHandle As Long, ByVal lpszBuffer As String, ByVal lngBufferSize As Long, ByRef lngBytesReturned As Long, ByRef lpftOverlapped As lpOverlapped) As Long
Public Declare Function FT_W32_WriteFile Lib "FTD2XX.DLL" (ByVal lngHandle As Long, ByVal lpszBuffer As String, ByVal lngBufferSize As Long, ByRef lngBytesWritten As Long, ByRef lpftOverlapped As lpOverlapped) As Long
Public Declare Function FT_W32_GetOverlappedResult Lib "FTD2XX.DLL" (ByVal lngHandle As Long, ByRef lpftOverlapped As lpOverlapped, ByRef lpdwBytesTransferred As Long, ByVal bWait As Boolean) As Long
Public Declare Function FT_W32_GetCommState Lib "FTD2XX.DLL" (ByVal lngHandle, ByRef lpftDCB As FTDCB) As Long
Public Declare Function FT_W32_SetCommState Lib "FTD2XX.DLL" (ByVal lngHandle, ByRef lpftDCB As FTDCB) As Long
Public Declare Sub Sleep Lib "kernel32" (ByVal dwMilliseconds As Long)

Public Declare Function CreateEvent Lib "kernel32" Alias "CreateEventA" (ByVal lpEventAttributes As Long, ByVal bManualReset As Long, ByVal bInitialState As Long, ByVal lpName As String) As Long
Public Declare Function WaitForSingleObject Lib "kernel32" (ByVal hHandle As Long, ByVal dwMilliseconds As Long) As Long
Public Declare Function SetEvent Lib "kernel32" (ByVal hHandle As Long) As Long
Public Declare Function CreateThread Lib "kernel32" (lpThreadAttributes As Any, ByVal dwStackSize As Long, ByVal lpStartAddress As Long, lpParameter As Any, ByVal dwCreationFlags As Long, lpThreadID As Long) As Long
Public Declare Function TerminateThread Lib "kernel32" (ByVal hThread As Long, ByVal dwExitCode As Long) As Long
Public Declare Function CloseHandle Lib "kernel32" (ByVal hObject As Long) As Long

'====================================================================
'APIGID32.DLL by DESAWARE Inc. (www.desaware.com), see Dan Appleman's
'"Visual Basic Programmer's Guide to the WIN32-API"; here used to get
'the addresses of the VB-bytearrays:
'====================================================================
Public Declare Function agGetAddressForObject& Lib "apigid32.dll" (object As Any)

'==============================================================
'Declarations for the EEPROM-accessing functions in FTD2XX.dll:
'==============================================================
Public Declare Function FT_EE_Program Lib "FTD2XX.DLL" (ByVal lngHandle As Long, ByRef lpData As FT_PROGRAM_DATA) As Long
Public Declare Function FT_EE_Read Lib "FTD2XX.DLL" (ByVal lngHandle As Long, ByRef lpData As FT_PROGRAM_DATA) As Long
Public Declare Function FT_EE_UASize Lib "FTD2XX.DLL" (ByVal lngHandle As Long, ByRef lpdwSize As Long) As Long
Public Declare Function FT_EE_UAWrite Lib "FTD2XX.DLL" (ByVal lngHandle As Long, ByVal pucData As String, ByVal dwDataLen As Long) As Long
Public Declare Function FT_EE_UARead Lib "FTD2XX.DLL" (ByVal lngHandle As Long, ByVal pucData As String, ByVal dwDataLen As Long, ByRef lpdwBytesRead As Long) As Long

Public Type LPSECURITY_ATTRIBUTES
  nLength As Long
  lpSecurityDescriptor As Long
  bInheritHandle As Long
End Type

Public Type lpOverlapped
  Internal As Long
  InternalHigh As Long
  Offset As Long
  OffsetHigh As Long
  hEvent As Long
End Type

Public Type FTDCB
    DCBlength As Long                   'sizeof (FTDCB)
    BaudRate As Long                    '9600
'    fBinary As Long                     '= 1 Binary mode (skip EOF check)
'    fParity As Long                     '= 1 Enable parity checking
'    fOutxCtsFlow As Long                '= 1 CTS handshaking on output
'    fOutxDsrFlow As Long                '= 1 DSR handshaking on output
'    fDtrControl As Long                 '= 2 DTR flow control
'    fDsrSensitivity As Long             '= 1 DSR Sensitivity
'    fTXContinueOnXoff As Long           '= 1 Continue TX when Xoff sent
'    fOutX As Long                       '= 1 Enable output X-on/X-off
'    fInX As Long                        '= 1 Enable input X-on/X-off
'    fErrorChar As Long                  '= 1 Enable error replacement
'    fNull As Long                       '= 1 Enable null stripping
'    fRtsControl As Long                 '= 2 RTS flow control
'    fAbortOnError As Long               '= 1 Abort all reads and writes on error
'    fDummy2 As Long                     '= 17 Reserved
'    wReserved As Integer                'Not currently used
'    XonLim As Integer                   'Transmit X-on threshold
'    XoffLim As Integer                  'Transmit X-off threshold
'    ByteSize As Byte                    'Number of bits/ byte, 7-8
'    Parity As Byte                      '0-4= None, Odd, Even, Mark, Space
'    StopBits As Byte                    '0, 2 = 1, 2
'    XonChar As Byte                     'TX and RX X-ON character
'    XoffChar As Byte                    'TX and RX X-OFF character
'    ErrorChar As Byte                   'Eror replacement char
'    EofChar As Byte                     'End of input Character
'    EvtChar As Byte                     'Received event character
'    wReserved1 As Integer               'BCD (0x0200 => USB2)
End Type




'====================================================================
'Type definition as equivalent for C-structure "ft_program_data" used
'in FT_EE_READ and FT_EE_WRITE;
'ATTENTION! The variables "Manufacturer", "ManufacturerID",
'"Description" and "SerialNumber" are passed as POINTERS to
'locations of Bytearrays. Each Byte in these arrays will be
'filled with one character of the whole string.
'(See below, calls to "agGetAddressForObject")
'=====================================================================


Public Type FT_PROGRAM_DATA

    signature1 As Long                  '0x00000000
    signature2 As Long                  '0xFFFFFFFF
    version As Long                     '0

    VendorId As Integer                 '0x0403
    ProductId As Integer                '0x6001
    Manufacturer As Long                '32 "FTDI"
    ManufacturerId As Long              '16 "FT"
    description As Long                 '64 "USB HS Serial Converter"
    serialNumber As Long                '16 "FT000001" if fixed, or NULL
    MaxPower As Integer                 ' // 0 < MaxPower <= 500
    PnP As Integer                      ' // 0 = disabled, 1 = enabled
    SelfPowered As Integer              ' // 0 = bus powered, 1 = self powered
    RemoteWakeup As Integer             ' // 0 = not capable, 1 = capable
     'Rev4 extensions:
    Rev4 As Byte                        ' // true if Rev4 chip, false otherwise
    IsoIn As Byte                       ' // true if in endpoint is isochronous
    IsoOut As Byte                      ' // true if out endpoint is isochronous
    PullDownEnable As Byte              ' // true if pull down enabled
    SerNumEnable As Byte                ' // true if serial number to be used
    USBVersionEnable As Byte            ' // true if chip uses USBVersion
    USBVersion As Integer               ' // BCD (0x0200 => USB2)
    'FT2232C extensions:
    Rev5 As Byte                        'non-zero if Rev5 chip, zero otherwise
    IsoInA As Byte                      'non-zero if in endpoint is isochronous
    IsoInB As Byte                      'non-zero if in endpoint is isochronous
    IsoOutA As Byte                     'non-zero if out endpoint is isochronous
    IsoOutB As Byte                     'non-zero if out endpoint is isochronous
    PullDownEnable5 As Byte             'non-zero if pull down enabled
    SerNumEnable5 As Byte               'non-zero if serial number to be used
    USBVersionEnable5 As Byte           'non-zero if chip uses USBVersion
    USBVersion5 As Integer              'BCD 0x110 = USB 1.1, BCD 0x200 = USB 2.0
    AlsHighCurrent As Byte              'non-zero if interface is high current
    BlsHighCurrent As Byte              'non-zero if interface is high current
    IFAlsFifo As Byte                   'non-zero if interface is 245 FIFO
    IFAlsFifoTar As Byte                'non-zero if interface is 245 FIFO CPU target
    IFAlsFastSer As Byte                'non-zero if interface is Fast Serial
    AlsVCP As Byte                      'non-zero if interface is to use VCP drivers
    IFBlsFifo As Byte                   'non-zero if interface is 245 FIFO
    IFBlsFifoTar As Byte                'non-zero if interface is 245 FIFO CPU target
    IFBlsFastSer As Byte                'non-zero if interface is Fast Serial
    BlsVCP As Byte                      'non-zero if interface is to use VCP drivers
    'FT232R extensions
    UseExtOSC As Byte                   'non-zero use ext osc
    HighDriveIOs As Byte                'non-zero to use High Drive IO's
    EndPointSize As Byte                '64 Do not change
    PullDownEnableR As Byte             'non-zeero if pull down enabled
    SerNumEnableR As Byte               'non-zero if pull serial number enabled
    InvertTXD As Byte                   'non-zero if invert TXD
    InvertRXD As Byte                   'non-zero if invert RXD
    InvertRTS As Byte                   'non-zero if invert RTS
    InvertCTS As Byte                   'non-zero if invert CTS
    InvertDTR As Byte                   'non-zero if invert DTR
    InvertDSR As Byte                   'non-zero if invert DSR
    InvertDCD As Byte                   'non-zero if invert DCD
    InvertRI As Byte                    'non-zero if invert RI
    Cbus0 As Byte                       'Cbus Mux control
    Cbus1 As Byte                       'Cbus Mux control
    Cbus2 As Byte                       'Cbus Mux control
    Cbus3 As Byte                       'Cbus Mux control
    Cbus4 As Byte                       'Cbus Mux control
    RIsVCP As Byte                      'non-zero if using VCP driver
    
    
   'FT2232H Extensions
   PullDownEnable7 As Byte          ' non-zero if pull down enabled
   SerNumEnable7 As Byte            ' non-zero if serial number to be used
   ALSlowSlew As Byte               ' non-zero if AL pins have slow slew
   ALSchmittInput As Byte           ' non-zero if AL pins are Schmitt input
   ALDriveCurrent As Byte           ' valid values are 4mA, 8mA, 12mA, 16mA
   AHSlowSlew As Byte               ' non-zero if AH pins have slow slew
   AHSchmittInput As Byte           ' non-zero if AH pins are Schmitt input
   AHDriveCurrent As Byte           ' valid values are 4mA, 8mA, 12mA, 16mA
   BLSlowSlew As Byte               ' non-zero if BL pins have slow slew
   BLSchmittInput As Byte           ' non-zero if BL pins are Schmitt input
   BLDriveCurrent As Byte           ' valid values are 4mA, 8mA, 12mA, 16mA
   BHSlowSlew As Byte               ' non-zero if BH pins have slow slew
   BHSchmittInput As Byte           ' non-zero if BH pins are Schmitt input
   BHDriveCurrent As Byte           ' valid values are 4mA, 8mA, 12mA, 16mA
   IFAIsFifo7 As Byte               ' non-zero if interface is 245 FIFO
   IFAIsFifoTar7 As Byte            ' non-zero if interface is 245 FIFO CPU target
   IFAIsFastSer7 As Byte            ' non-zero if interface is Fast serial
   AIsVCP7 As Byte                  ' non-zero if interface is to use VCP drivers
   IFBIsFifo7 As Byte               ' non-zero if interface is 245 FIFO
   IFBIsFifoTar7 As Byte            ' non-zero if interface is 245 FIFO CPU target
   IFBIsFastSer7 As Byte            ' non-zero if interface is Fast serial
   BIsVCP7 As Byte                  ' non-zero if interface is to use VCP drivers
   PowerSaveEnable As Byte          ' non-zero if using BCBUS7 to save power for self-powered designs
    
    'FT4232H Extensions
    PullDownEnable8 As Byte            ' non-zero if pull down enabled
    SerNumEnable8 As Byte              ' non-zero if serial number to be used
    ASlowSlew As Byte                  ' non-zero if AL pins have slow slew
    ASchmittInput As Byte              ' non-zero if AL pins are Schmitt input
    ADriveCurrent As Byte              ' valid values are 4mA, 8mA, 12mA, 16mA
    BSlowSlew As Byte                  ' non-zero if AH pins have slow slew
    BSchmittInput As Byte              ' non-zero if AH pins are Schmitt input
    BDriveCurrent As Byte              ' valid values are 4mA, 8mA, 12mA, 16mA
    CSlowSlew As Byte                  ' non-zero if BL pins have slow slew
    CSchmittInput As Byte              ' non-zero if BL pins are Schmitt input
    CDriveCurrent As Byte              ' valid values are 4mA, 8mA, 12mA, 16mA
    DSlowSlew As Byte                  ' non-zero if BH pins have slow slew
    DSchmittInput As Byte              ' non-zero if BH pins are Schmitt input
    DDriveCurrent As Byte              ' valid values are 4mA, 8mA, 12mA, 16mA
    ARIIsTXDEN As Byte                 ' non-zero if port A uses RI as RS485 TXDEN
    BRIIsTXDEN As Byte                 ' non-zero if port B uses RI as RS485 TXDEN
    CRIIsTXDEN As Byte                 ' non-zero if port C uses RI as RS485 TXDEN
    DRIIsTXDEN As Byte                 ' non-zero if port D uses RI as RS485 TXDEN
    AIsVCP8 As Byte                    ' non-zero if interface is to use VCP drivers
    BIsVCP8 As Byte                    ' non-zero if interface is to use VCP drivers
    CIsVCP8 As Byte                    ' non-zero if interface is to use VCP drivers
    DIsVCP8 As Byte                    ' non-zero if interface is to use VCP drivers
End Type



'  Device information

Public Type FT_DEVICE_LIST_INFO_NODE
   Flags As Long
   Type As Long
   ID As Long
   LocId As Integer
   serialNumber As String * 16
   description  As String * 64
   ftHandle As Long
End Type


'''Public Type FT_DEVICE_INFO_NODE
'''    DeviceIndex As Long
'''    Flags As Long
'''    DeviceType As Long
'''    DeviceID As Long
'''    LocationID As Long
'''    serialNumber As String
'''    description As String
'''    DeviceHandle As Long
'''End Type




'----------------------------------------------------------------------
' CONSTANTES
'----------------------------------------------------------------------

' Device information flags
Public Const FT_FLAGS_OPENED = 1
Public Const FT_FLAGS_HISPEED = 2

' CÓDIGOS DE RETORNO DE FUNCIONES DE LIBRERIA
Public Const FT_SUCCESS = 0
Public Const FT_OK = 0
Public Const FT_INVALID_HANDLE = 1
Public Const FT_DEVICE_NOT_FOUND = 2
Public Const FT_DEVICE_NOT_OPENED = 3
Public Const FT_IO_ERROR = 4
Public Const FT_INSUFFICIENT_RESOURCES = 5
Public Const FT_INVALID_PARAMETER = 6
Public Const FT_INVALID_BAUD_RATE = 7
Public Const FT_DEVICE_NOT_OPENED_FOR_ERASE = 8
Public Const FT_DEVICE_NOT_OPENED_FOR_WRITE = 9
Public Const FT_FAILED_TO_WRITE_DEVICE = 10
Public Const FT_EEPROM_READ_FAILED = 11
Public Const FT_EEPROM_WRITE_FAILED = 12
Public Const FT_EEPROM_ERASE_FAILED = 13
Public Const FT_EEPROM_NOT_PRESENT = 14
Public Const FT_EEPROM_NOT_PROGRAMMED = 15
Public Const FT_INVALID_ARGS = 16
Public Const FT_NOT_SUPPORTED = 17
Public Const FT_OTHER_ERROR = 18

Public Const FTC_FAILED_TO_COMPLETE_COMMAND = 20            ' cannot change, error code mapped from FT2232c classes
Public Const FTC_FAILED_TO_SYNCHRONIZE_DEVICE_MPSSE = 21    ' cannot change, error code mapped from FT2232c classes
Public Const FTC_INVALID_DEVICE_NAME_INDEX = 22             ' cannot change, error code mapped from FT2232c classes
Public Const FTC_NULL_DEVICE_NAME_BUFFER_POINTER = 23       ' cannot change, error code mapped from FT2232c classes
Public Const FTC_DEVICE_NAME_BUFFER_TOO_SMALL = 24          ' cannot change, error code mapped from FT2232c classes
Public Const FTC_INVALID_DEVICE_NAME = 25                   ' cannot change, error code mapped from FT2232c classes
Public Const FTC_INVALID_LOCATION_ID = 26                   ' cannot change, error code mapped from FT2232c classes
Public Const FTC_DEVICE_IN_USE = 27                         ' cannot change, error code mapped from FT2232c classes
Public Const FTC_TOO_MANY_DEVICES = 28                      ' cannot change, error code mapped from FT2232c classes

Public Const FTC_NULL_CHANNEL_BUFFER_POINTER = 29           ' cannot change, error code mapped from FT2232h classes
Public Const FTC_CHANNEL_BUFFER_TOO_SMALL = 30              ' cannot change, error code mapped from FT2232h classes
Public Const FTC_INVALID_CHANNEL = 31                       ' cannot change, error code mapped from FT2232h classes
Public Const FTC_INVALID_TIMER_VALUE = 32                   ' cannot change, error code mapped from FT2232h classes

Public Const FTC_INVALID_CLOCK_DIVISOR = 33
Public Const FTC_NULL_INPUT_BUFFER_POINTER = 34
Public Const FTC_NULL_CHIP_SELECT_BUFFER_POINTER = 35
Public Const FTC_NULL_INPUT_OUTPUT_BUFFER_POINTER = 36
Public Const FTC_NULL_OUTPUT_PINS_BUFFER_POINTER = 37
Public Const FTC_NULL_INITIAL_CONDITION_BUFFER_POINTER = 38
Public Const FTC_NULL_WRITE_CONTROL_BUFFER_POINTER = 39
Public Const FTC_NULL_WRITE_DATA_BUFFER_POINTER = 40
Public Const FTC_NULL_WAIT_DATA_WRITE_BUFFER_POINTER = 41
Public Const FTC_NULL_READ_DATA_BUFFER_POINTER = 42
Public Const FTC_NULL_READ_CMDS_DATA_BUFFER_POINTER = 43
Public Const FTC_INVALID_NUMBER_CONTROL_BITS = 44
Public Const FTC_INVALID_NUMBER_CONTROL_BYTES = 45
Public Const FTC_NUMBER_CONTROL_BYTES_TOO_SMALL = 46
Public Const FTC_INVALID_NUMBER_WRITE_DATA_BITS = 47
Public Const FTC_INVALID_NUMBER_WRITE_DATA_BYTES = 48
Public Const FTC_NUMBER_WRITE_DATA_BYTES_TOO_SMALL = 49
Public Const FTC_INVALID_NUMBER_READ_DATA_BITS = 50
Public Const FTC_INVALID_INIT_CLOCK_PIN_STATE = 51
Public Const FTC_INVALID_FT2232C_CHIP_SELECT_PIN = 52
Public Const FTC_INVALID_FT2232C_DATA_WRITE_COMPLETE_PIN = 53
Public Const FTC_DATA_WRITE_COMPLETE_TIMEOUT = 54
Public Const FTC_INVALID_CONFIGURATION_HIGHER_GPIO_PIN = 55
Public Const FTC_COMMAND_SEQUENCE_BUFFER_FULL = 56
Public Const FTC_NO_COMMAND_SEQUENCE = 57
Public Const FTC_NULL_CLOSE_FINAL_STATE_BUFFER_POINTER = 58
Public Const FTC_NULL_DLL_VERSION_BUFFER_POINTER = 59
Public Const FTC_DLL_VERSION_BUFFER_TOO_SMALL = 60
Public Const FTC_NULL_LANGUAGE_CODE_BUFFER_POINTER = 61
Public Const FTC_NULL_ERROR_MESSAGE_BUFFER_POINTER = 62
Public Const FTC_ERROR_MESSAGE_BUFFER_TOO_SMALL = 63
Public Const FTC_INVALID_LANGUAGE_CODE = 64
Public Const FTC_INVALID_STATUS_CODE = 65

' Word Lengths
Public Const FT_BITS_8 = 8
Public Const FT_BITS_7 = 7

' Stop Bits
Public Const FT_STOP_BITS_1 = 0
Public Const FT_STOP_BITS_1_5 = 1
Public Const FT_STOP_BITS_2 = 2

' Parity
Public Const FT_PARITY_NONE = 0
Public Const FT_PARITY_ODD = 1
Public Const FT_PARITY_EVEN = 2
Public Const FT_PARITY_MARK = 3
Public Const FT_PARITY_SPACE = 4

' Flow Control
Public Const FT_FLOW_NONE = &H0
Public Const FT_FLOW_RTS_CTS = &H100
Public Const FT_FLOW_DTR_DSR = &H200
Public Const FT_FLOW_XON_XOFF = &H400

' Purge rx and tx buffers
Public Const FT_PURGE_RX = 1
Public Const FT_PURGE_TX = 2

' Modem Status
Public Const FT_MODEM_STATUS_CTS = &H10
Public Const FT_MODEM_STATUS_DSR = &H20
Public Const FT_MODEM_STATUS_RI = &H40
Public Const FT_MODEM_STATUS_DCD = &H80

Public Const FT_EVENT_RXCHAR As Long = 1
Public Const FT_EVENT_MODEM_STATUS = 2

Const WAIT_ABANDONED As Long = &H80
Const WAIT_FAILD As Long = &HFFFFFFFF
Const WAIT_OBJECT_0 As Long = &H0
Const WAIT_TIMEOUT As Long = &H102

' Flags for FT_ListDevices
Public Const FT_LIST_BY_NUMBER_ONLY = &H80000000
Public Const FT_LIST_BY_INDEX = &H40000000
Public Const FT_LIST_ALL = &H20000000

' Flags for FT_OpenEx
Public Const FT_OPEN_BY_SERIAL_NUMBER = 1
Public Const FT_OPEN_BY_DESCRIPTION = 2

'Device type flags
Public Const FT_DEVICE_232BM = 0
Public Const FT_DEVICE_232AM = 1
Public Const FT_DEVICE_100AX = 2
Public Const FT_DEVICE_UNKNOWN = 3
Public Const FT_DEVICE_2232C = 4
Public Const FT_DEVICE_232R = 5
Public Const FT_DEVICE_2232H = 6
Public Const FT_DEVICE_4232H = 7
Public Const FT_DEVICE_232H = 8
Public Const FT_DEVICE_X_SERIES = 9


'BIT Bang modes
Public Const FT_BITBANG_RESET = 0           'Reset mode
Public Const FT_BITBANG_ASYNC = 1           'Asynchronous Bit Bang
Public Const FT_BITBANG_MPSSE = 2           'MPSSE Bit bang
Public Const FT_BITBANG_SYNC = 4            'Synchronous Bit Bang mode
Public Const FT_BITBANG_MCU = 8             'MCU port mode
Public Const FT_BITBANG_FAST_OPTO = 16      'Fast Opto Isolated serial mode
Public Const FT_BITBANG_CBUS = 32           'CBUS Bit Bang mode
Public Const FT_BITMODE_SYNC_FIFO = 64

Private Const INFINITE As Long = 1000   '&HFFFFFFFF

Global hThread As Long
Global hThreadID As Long
Global hEvent As Long
Global EventMask As Long

Global lngHandle As Long
 
    

'xxxSub Main()
'xxx    Set fMainForm = New DEMO_EEPROM
'xxx    fMainForm.Show
'xxxEnd Sub

