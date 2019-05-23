Attribute VB_Name = "FTCSPI_Module"
' Copyright (c) 2008  Future Technology Devices International Ltd.
'
' Module Name
'
'
' Abstract:
'
'    Visual Basic program, to test the FTCSPI.DLL. The FTCSPI.DLL is used to control the FT2232H dual hi-speed device
'    and the FT4232H quad hi-speed device to simulate the Serial Peripheral Interface(SPI) synchronous serial protocol
'    to communicate with SPI devices connected to FT2232H dual hi-speed devices and FT4232H quad hi-speed devices.
'
' Historial de Revisiones:
'
'  Ver.1.0  27/08/2008  Kirke Ashton    Created.
'  Ver.1.1  29/04/2012  Adaptación y ampliación por Juan Antonio Higuera

Option Explicit

'----------------------------------------------------------------------
' TIPOS-ESTRUCTURAS DE DATOS
'----------------------------------------------------------------------

Public Type FTC_CHIP_SELECT_PINS
    bADBUS3ChipSelectPinState As Long 'Boolean
    bADBUS4GPIOL1PinState As Long 'Boolean
    bADBUS5GPIOL2PinState As Long 'Boolean
    bADBUS6GPIOL3PinState As Long 'Boolean
    bADBUS7GPIOL4PinState As Long 'Boolean
End Type
    
Public Type FTC_INPUT_OUTPUT_PINS
    bPin1InputOutputState As Long 'Boolean
    bPin1LowHighState As Long 'Boolean
    bPin2InputOutputState As Long 'Boolean
    bPin2LowHighState As Long 'Boolean
    bPin3InputOutputState As Long 'Boolean
    bPin3LowHighState As Long 'Boolean
    bPin4InputOutputState As Long 'Boolean
    bPin4LowHighState As Long 'Boolean
End Type

Public Type FTH_INPUT_OUTPUT_PINS
    bPin1InputOutputState As Long 'Boolean
    bPin1LowHighState As Long 'Boolean
    bPin2InputOutputState As Long 'Boolean
    bPin2LowHighState As Long 'Boolean
    bPin3InputOutputState As Long 'Boolean
    bPin3LowHighState As Long 'Boolean
    bPin4InputOutputState As Long 'Boolean
    bPin4LowHighState As Long 'Boolean
    bPin5InputOutputState As Long 'Boolean
    bPin5LowHighState As Long 'Boolean
    bPin6InputOutputState As Long 'Boolean
    bPin6LowHighState As Long 'Boolean
    bPin7InputOutputState As Long 'Boolean
    bPin7LowHighState As Long 'Boolean
    bPin8InputOutputState As Long 'Boolean
    bPin8LowHighState As Long 'Boolean
End Type
    
Public Type FTC_LOW_HIGH_PINS
    bPin1LowHighState As Long 'Boolean
    bPin2LowHighState As Long 'Boolean
    bPin3LowHighState As Long 'Boolean
    bPin4LowHighState As Long 'Boolean
End Type

Public Type FTH_LOW_HIGH_PINS
    bPin1LowHighState As Long 'Boolean
    bPin2LowHighState As Long 'Boolean
    bPin3LowHighState As Long 'Boolean
    bPin4LowHighState As Long 'Boolean
    bPin5LowHighState As Long 'Boolean
    bPin6LowHighState As Long 'Boolean
    bPin7LowHighState As Long 'Boolean
    bPin8LowHighState As Long 'Boolean
End Type
    
Public Type FTC_INIT_CONDITION
    bClockPinState As Long 'Boolean
    bDataOutPinState As Long 'Boolean
    bChipSelectPinState As Long 'Boolean
    ChipSelectPin As CHIPSELECPINS  '<<<Long
End Type
    
Public Type FTC_WAIT_DATA_WRITE
    bWaitDataWriteComplete As Long 'Boolean
    WaitDataWritePin As WAITDATAWRITEPINS '<<<Long
    bDataWriteCompleteState As Long 'Boolean
    DataWriteTimeoutmSecs As Long
End Type
    
Public Type FTC_HIGHER_OUTPUT_PINS
    bPin1State As Long 'Boolean
    bPin1ActiveState As Long 'Boolean
    bPin2State As Long 'Boolean
    bPin2ActiveState As Long 'Boolean
    bPin3State As Long 'Boolean
    bPin3ActiveState As Long 'Boolean
    bPin4State As Long 'Boolean
    bPin4ActiveState As Long 'Boolean
End Type

Public Type FTH_HIGHER_OUTPUT_PINS
    bPin1State As Long 'Boolean
    bPin1ActiveState As Long 'Boolean
    bPin2State As Long 'Boolean
    bPin2ActiveState As Long 'Boolean
    bPin3State As Long 'Boolean
    bPin3ActiveState As Long 'Boolean
    bPin4State As Long 'Boolean
    bPin4ActiveState As Long 'Boolean
    bPin5State As Long 'Boolean
    bPin5ActiveState As Long 'Boolean
    bPin6State As Long 'Boolean
    bPin6ActiveState As Long 'Boolean
    bPin7State As Long 'Boolean
    bPin7ActiveState As Long 'Boolean
    bPin8State As Long 'Boolean
    bPin8ActiveState As Long 'Boolean
End Type

Public Type FTC_CLOSE_FINAL_STATE_PINS
    bTCKPinState As Long 'Boolean
    bTCKPinActiveState As Long 'Boolean
    bTDIPinState As Long 'Boolean
    bTDIPinActiveState As Long 'Boolean
    bTMSPinState As Long 'Boolean
    bTMSPinActiveState As Long 'Boolean
End Type


'----------------------------------------------------------------------
' DECLARACION DE FUNCIONES DE LA LIBRERIA FTCSPI.DLL
'----------------------------------------------------------------------

' DECLARACION DE FUNCIONES PARA DISPOSITIVOS DE VELOCIDAD NORMAL 2232D... Versión 1.2 de FTCSPI.DLL
Public Declare Function SPI_GetNumDevices Lib "ftcspi" (ByRef NumDevices As Long) As Long
Public Declare Function SPI_GetDeviceNameLocID Lib "ftcspi" (ByVal DeviceNameIndex As Long, ByVal DeviceName As String, ByVal BufferSize As Long, ByRef lpLocationID As Long) As Long
Public Declare Function SPI_OpenEx Lib "ftcspi" (ByVal DeviceName As String, ByVal LocationID As Long, ByRef ftHandle As Long) As Long
Public Declare Function SPI_Open Lib "ftcspi" (ByRef ftHandle As Long) As Long
Public Declare Function SPI_Close Lib "ftcspi" (ByVal ftHandle As Long) As Long
Public Declare Function SPI_InitDevice Lib "ftcspi" (ByVal ftHandle As Long, ByVal ClockDivisor As Long) As Long
Public Declare Function SPI_GetClock Lib "ftcspi" (ByVal ClockDivisor As Long, ByRef lpClockFrequencyHz As Long) As Long
Public Declare Function SPI_SetClock Lib "ftcspi" (ByVal ftHandle As Long, ByVal ClockDivisor As Long, ByRef lpClockFrequencyHz As Long) As Long
Public Declare Function SPI_SetLoopback Lib "ftcspi" (ByVal ftHandle As Long, ByVal bLoopbackState As Boolean) As Long
Public Declare Function SPI_SetGPIOs Lib "ftcspi" (ByVal ftHandle As Long, ByRef pChipSelectsDisableStates As FTC_CHIP_SELECT_PINS, ByRef pHighInputOutputPinsData As FTC_INPUT_OUTPUT_PINS) As Long
Public Declare Function SPI_GetGPIOs Lib "ftcspi" (ByVal ftHandle As Long, ByRef pHighPinsInputData As FTC_LOW_HIGH_PINS) As Long
Public Declare Function SPI_Write Lib "ftcspi" (ByVal ftHandle As Long, ByRef pWriteStartCondition As FTC_INIT_CONDITION, ByVal bClockOutDataBitsMSBFirst As Boolean, ByVal bClockOutDataBitsPosEdge As Boolean, ByVal NumControlBitsToWrite As Long, WriteControlBuffer As Any, ByVal NumControlBytesToWrite As Long, ByVal bWriteDataBits As Boolean, ByVal NumDataBitsToWrite As Long, WriteDataBuffer As Any, ByVal NumDataBytesToWrite As Long, ByRef pWaitDataWriteComplete As FTC_WAIT_DATA_WRITE, ByRef pHighPinsWriteActiveStates As FTC_HIGHER_OUTPUT_PINS) As Long
Public Declare Function SPI_Read Lib "ftcspi" (ByVal ftHandle As Long, ByRef pReadStartCondition As FTC_INIT_CONDITION, ByVal bClockOutDataBitsMSBFirst As Boolean, ByVal bClockOutDataBitsPosEdge As Boolean, ByVal NumControlBitsToWrite As Long, WriteControlBuffer As Any, ByVal NumControlBytesToWrite As Long, ByVal bClockInDataBitsMSBFirst As Boolean, ByVal bClockInDataBitsPosEdge As Boolean, ByVal NumDataBitsToRead As Long, ReadDataBuffer As Any, ByRef lpNumDataBytesReturned As Long, ByRef pHighPinsWriteActiveStates As FTC_HIGHER_OUTPUT_PINS) As Long
Public Declare Function SPI_ClearDeviceCmdSequence Lib "ftcspi" (ByVal ftHandle As Long) As Long
Public Declare Function SPI_AddDeviceWriteCmd Lib "ftcspi" (ByVal ftHandle As Long, ByRef pWriteStartCondition As FTC_INIT_CONDITION, ByVal bClockOutDataBitsMSBFirst As Boolean, ByVal bClockOutDataBitsPosEdge As Boolean, ByVal NumControlBitsToWrite As Long, WriteControlBuffer As Any, ByVal NumControlBytesToWrite As Long, ByVal bWriteDataBits As Boolean, ByVal NumDataBitsToWrite As Long, WriteDataBuffer As Any, ByVal NumDataBytesToWrite As Long, ByRef pHighPinsWriteActiveStates As FTC_HIGHER_OUTPUT_PINS) As Long
Public Declare Function SPI_AddDeviceReadCmd Lib "ftcspi" (ByVal ftHandle As Long, ByRef pReadStartCondition As FTC_INIT_CONDITION, ByVal bClockOutDataBitsMSBFirst As Boolean, ByVal bClockOutDataBitsPosEdge As Boolean, ByVal NumControlBitsToWrite As Long, WriteControlBuffer As Any, ByVal NumControlBytesToWrite As Long, ByVal bClockInDataBitsMSBFirst As Boolean, ByVal bClockInDataBitsPosEdge As Boolean, ByVal NumDataBitsToRead As Long, ByRef pHighPinsWriteActiveStates As FTC_HIGHER_OUTPUT_PINS) As Long
Public Declare Function SPI_ExecuteDeviceCmdSequence Lib "ftcspi" (ByVal ftHandle As Long, ReadCmdSequenceDataBuffer As Any, ByRef lpNumBytesReturned As Long) As Long
Public Declare Function SPI_GetDllVersion Lib "ftcspi" (ByVal DllVersion As String, ByVal BufferSize As Long) As Long
Public Declare Function SPI_GetErrorCodeString Lib "ftcspi" (ByVal Language As String, ByVal StatusCode As Long, ByVal ErrorMessage As String, ByVal BufferSize As Long) As Long


' DECLARACION DE FUNCIONES PARA DISPOSITIVOS DE ALTA VELOCIDAD 2232H, 4232H... Versión 2.0 de FTCSPI.DLL
Public Declare Function SPI_GetNumHiSpeedDevices Lib "ftcspi" (ByRef NumHiSpeedDevices As Long) As Long
Public Declare Function SPI_GetHiSpeedDeviceNameLocIDChannel Lib "ftcspi" (ByVal DeviceNameIndex As Long, ByVal DeviceName As String, ByVal DeviceNameBufferSize As Long, ByRef lpLocationID As Long, ByVal Channel As String, ByVal ChannelBufferSize As Long, ByRef lpHiSpeedDeviceType As Long) As Long
Public Declare Function SPI_OpenHiSpeedDevice Lib "ftcspi" (ByVal DeviceName As String, ByVal LocationID As Long, ByVal Channel As String, ByRef ftHandle As Long) As Long
Public Declare Function SPI_GetHiSpeedDeviceType Lib "ftcspi" (ByVal ftHandle As Long, ByRef lpHiSpeedDeviceType As Long) As Long
'<<<Public Declare Function SPI_Close Lib "ftcspi" (ByVal ftHandle As Long) As Long
Public Declare Function SPI_CloseDevice Lib "ftcspi" (ByVal ftHandle As Long, ByRef pCloseFinalStatePinsData As FTC_CLOSE_FINAL_STATE_PINS) As Long
'<<<Public Declare Function SPI_InitDevice Lib "ftcspi" (ByVal ftHandle As Long, ByVal ClockDivisor As Long) As Long
Public Declare Function SPI_TurnOnDivideByFiveClockingHiSpeedDevice Lib "ftcspi" (ByVal ftHandle As Long) As Long
Public Declare Function SPI_TurnOffDivideByFiveClockingHiSpeedDevice Lib "ftcspi" (ByVal ftHandle As Long) As Long
Public Declare Function SPI_SetDeviceLatencyTimer Lib "ftcspi" (ByVal ftHandle As Long, ByVal TimerValue As Byte) As Long
Public Declare Function SPI_GetDeviceLatencyTimer Lib "ftcspi" (ByVal ftHandle As Long, ByRef lpTimerValue As Byte) As Long
Public Declare Function SPI_GetHiSpeedDeviceClock Lib "ftcspi" (ByVal ClockDivisor As Long, ByRef lpClockFrequencyHz As Long) As Long
'<<<Public Declare Function SPI_GetClock Lib "ftcspi" (ByVal ClockDivisor As Long, ByRef lpClockFrequencyHz As Long) As Long
'<<<Public Declare Function SPI_SetClock Lib "ftcspi" (ByVal ftHandle As Long, ByVal ClockDivisor As Long, ByRef lpClockFrequencyHz As Long) As Long
'<<<Public Declare Function SPI_SetLoopback Lib "ftcspi" (ByVal ftHandle As Long, ByVal bLoopbackState As Boolean) As Long
Public Declare Function SPI_SetHiSpeedDeviceGPIOs Lib "ftcspi" (ByVal ftHandle As Long, ByRef pChipSelectsDisableStates As FTC_CHIP_SELECT_PINS, ByRef pHighInputOutputPinsData As FTH_INPUT_OUTPUT_PINS) As Long
Public Declare Function SPI_GetHiSpeedDeviceGPIOs Lib "ftcspi" (ByVal ftHandle As Long, ByRef pHighPinsInputData As FTH_LOW_HIGH_PINS) As Long
Public Declare Function SPI_WriteHiSpeedDevice Lib "ftcspi" (ByVal ftHandle As Long, ByRef pWriteStartCondition As FTC_INIT_CONDITION, ByVal bClockOutDataBitsMSBFirst As Boolean, ByVal bClockOutDataBitsPosEdge As Boolean, ByVal NumControlBitsToWrite As Long, WriteControlBuffer As Any, ByVal NumControlBytesToWrite As Long, ByVal bWriteDataBits As Boolean, ByVal NumDataBitsToWrite As Long, WriteDataBuffer As Any, ByVal NumDataBytesToWrite As Long, ByRef pWaitDataWriteComplete As FTC_WAIT_DATA_WRITE, ByRef pHighPinsWriteActiveStates As FTH_HIGHER_OUTPUT_PINS) As Long
Public Declare Function SPI_ReadHiSpeedDevice Lib "ftcspi" (ByVal ftHandle As Long, ByRef pReadStartCondition As FTC_INIT_CONDITION, ByVal bClockOutDataBitsMSBFirst As Boolean, ByVal bClockOutDataBitsPosEdge As Boolean, ByVal NumControlBitsToWrite As Long, WriteControlBuffer As Any, ByVal NumControlBytesToWrite As Long, ByVal bClockInDataBitsMSBFirst As Boolean, ByVal bClockInDataBitsPosEdge As Boolean, ByVal NumDataBitsToRead As Long, ReadDataBuffer As Any, ByRef lpNumDataBytesReturned As Long, ByRef pHighPinsReadActiveStates As FTH_HIGHER_OUTPUT_PINS) As Long
'<<<Public Declare Function SPI_ClearDeviceCmdSequence Lib "ftcspi" (ByVal ftHandle As Long) As Long
Public Declare Function SPI_AddHiSpeedDeviceWriteCmd Lib "ftcspi" (ByVal ftHandle As Long, ByRef pWriteStartCondition As FTC_INIT_CONDITION, ByVal bClockOutDataBitsMSBFirst As Boolean, ByVal bClockOutDataBitsPosEdge As Boolean, ByVal NumControlBitsToWrite As Long, WriteControlBuffer As Any, ByVal NumControlBytesToWrite As Long, ByVal bWriteDataBits As Boolean, ByVal NumDataBitsToWrite As Long, WriteDataBuffer As Any, ByVal NumDataBytesToWrite As Long, ByRef pHighPinsWriteActiveStates As FTH_HIGHER_OUTPUT_PINS) As Long
Public Declare Function SPI_AddHiSpeedDeviceReadCmd Lib "ftcspi" (ByVal ftHandle As Long, ByRef pReadStartCondition As FTC_INIT_CONDITION, ByVal bClockOutDataBitsMSBFirst As Boolean, ByVal bClockOutDataBitsPosEdge As Boolean, ByVal NumControlBitsToWrite As Long, WriteControlBuffer As Any, ByVal NumControlBytesToWrite As Long, ByVal bClockInDataBitsMSBFirst As Boolean, ByVal bClockInDataBitsPosEdge As Boolean, ByVal NumDataBitsToRead As Long, ByRef pHighPinsReadActiveStates As FTH_HIGHER_OUTPUT_PINS) As Long
'<<<Public Declare Function SPI_ExecuteDeviceCmdSequence Lib "ftcspi" (ByVal ftHandle As Long, ReadCmdSequenceDataBuffer As Any, ByRef lpNumBytesReturned As Long) As Long
'<<<Public Declare Function SPI_GetDllVersion Lib "ftcspi" (ByVal DllVersion As String, ByVal BufferSize As Long) As Long
'<<<Public Declare Function SPI_GetErrorCodeString Lib "ftcspi" (ByVal Language As String, ByVal StatusCode As Long, ByVal ErrorMessage As String, ByVal BufferSize As Long) As Long

Public Declare Function Sleep Lib "kernel32" (ByVal Milliseconds As Integer) As Long


'----------------------------------------------------------------------
' CONSTANTES
'----------------------------------------------------------------------
' CÓDIGOS DE RETORNO DE FUNCIONES DE LIBRERIA

'Anulados porque están repetidos en D2XX
'''Public Const FT_SUCCESS = 0
'''Public Const FT_OK = 0                    ' Este me gusta más porque es más corto
'''Public Const FT_INVALID_HANDLE = 1
'''Public Const FT_DEVICE_NOT_FOUND = 2
'''Public Const FT_DEVICE_NOT_OPENED = 3
'''Public Const FT_IO_ERROR = 4
'''Public Const FT_INSUFFICIENT_RESOURCES = 5
'''Public Const FT_INVALID_PARAMETER = 6
'''Public Const FT_INVALID_BAUD_RATE = 7
'''Public Const FT_DEVICE_NOT_OPENED_FOR_ERASE = 8
'''Public Const FT_DEVICE_NOT_OPENED_FOR_WRITE = 9
'''Public Const FT_FAILED_TO_WRITE_DEVICE = 10
'''Public Const FT_EEPROM_READ_FAILED = 11
'''Public Const FT_EEPROM_WRITE_FAILED = 12
'''Public Const FT_EEPROM_ERASE_FAILED = 13
'''Public Const FT_EEPROM_NOT_PRESENT = 14
'''Public Const FT_EEPROM_NOT_PROGRAMMED = 15
'''Public Const FT_INVALID_ARGS = 16
'''Public Const FT_NOT_SUPPORTED = 17
'''Public Const FT_OTHER_ERROR = 18
'''
'''Public Const FTC_FAILED_TO_COMPLETE_COMMAND = 20            ' cannot change, error code mapped from FT2232c classes
'''Public Const FTC_FAILED_TO_SYNCHRONIZE_DEVICE_MPSSE = 21    ' cannot change, error code mapped from FT2232c classes
'''Public Const FTC_INVALID_DEVICE_NAME_INDEX = 22             ' cannot change, error code mapped from FT2232c classes
'''Public Const FTC_NULL_DEVICE_NAME_BUFFER_POINTER = 23       ' cannot change, error code mapped from FT2232c classes
'''Public Const FTC_DEVICE_NAME_BUFFER_TOO_SMALL = 24          ' cannot change, error code mapped from FT2232c classes
'''Public Const FTC_INVALID_DEVICE_NAME = 25                   ' cannot change, error code mapped from FT2232c classes
'''Public Const FTC_INVALID_LOCATION_ID = 26                   ' cannot change, error code mapped from FT2232c classes
'''Public Const FTC_DEVICE_IN_USE = 27                         ' cannot change, error code mapped from FT2232c classes
'''Public Const FTC_TOO_MANY_DEVICES = 28                      ' cannot change, error code mapped from FT2232c classes
'''
'''Public Const FTC_NULL_CHANNEL_BUFFER_POINTER = 29           ' cannot change, error code mapped from FT2232h classes
'''Public Const FTC_CHANNEL_BUFFER_TOO_SMALL = 30              ' cannot change, error code mapped from FT2232h classes
'''Public Const FTC_INVALID_CHANNEL = 31                       ' cannot change, error code mapped from FT2232h classes
'''Public Const FTC_INVALID_TIMER_VALUE = 32                   ' cannot change, error code mapped from FT2232h classes
'''
'''Public Const FTC_INVALID_CLOCK_DIVISOR = 33
'''Public Const FTC_NULL_INPUT_BUFFER_POINTER = 34
'''Public Const FTC_NULL_CHIP_SELECT_BUFFER_POINTER = 35
'''Public Const FTC_NULL_INPUT_OUTPUT_BUFFER_POINTER = 36
'''Public Const FTC_NULL_OUTPUT_PINS_BUFFER_POINTER = 37
'''Public Const FTC_NULL_INITIAL_CONDITION_BUFFER_POINTER = 38
'''Public Const FTC_NULL_WRITE_CONTROL_BUFFER_POINTER = 39
'''Public Const FTC_NULL_WRITE_DATA_BUFFER_POINTER = 40
'''Public Const FTC_NULL_WAIT_DATA_WRITE_BUFFER_POINTER = 41
'''Public Const FTC_NULL_READ_DATA_BUFFER_POINTER = 42
'''Public Const FTC_NULL_READ_CMDS_DATA_BUFFER_POINTER = 43
'''Public Const FTC_INVALID_NUMBER_CONTROL_BITS = 44
'''Public Const FTC_INVALID_NUMBER_CONTROL_BYTES = 45
'''Public Const FTC_NUMBER_CONTROL_BYTES_TOO_SMALL = 46
'''Public Const FTC_INVALID_NUMBER_WRITE_DATA_BITS = 47
'''Public Const FTC_INVALID_NUMBER_WRITE_DATA_BYTES = 48
'''Public Const FTC_NUMBER_WRITE_DATA_BYTES_TOO_SMALL = 49
'''Public Const FTC_INVALID_NUMBER_READ_DATA_BITS = 50
'''Public Const FTC_INVALID_INIT_CLOCK_PIN_STATE = 51
'''Public Const FTC_INVALID_FT2232C_CHIP_SELECT_PIN = 52
'''Public Const FTC_INVALID_FT2232C_DATA_WRITE_COMPLETE_PIN = 53
'''Public Const FTC_DATA_WRITE_COMPLETE_TIMEOUT = 54
'''Public Const FTC_INVALID_CONFIGURATION_HIGHER_GPIO_PIN = 55
'''Public Const FTC_COMMAND_SEQUENCE_BUFFER_FULL = 56
'''Public Const FTC_NO_COMMAND_SEQUENCE = 57
'''Public Const FTC_NULL_CLOSE_FINAL_STATE_BUFFER_POINTER = 58
'''Public Const FTC_NULL_DLL_VERSION_BUFFER_POINTER = 59
'''Public Const FTC_DLL_VERSION_BUFFER_TOO_SMALL = 60
'''Public Const FTC_NULL_LANGUAGE_CODE_BUFFER_POINTER = 61
'''Public Const FTC_NULL_ERROR_MESSAGE_BUFFER_POINTER = 62
'''Public Const FTC_ERROR_MESSAGE_BUFFER_TOO_SMALL = 63
'''Public Const FTC_INVALID_LANGUAGE_CODE = 64
'''Public Const FTC_INVALID_STATUS_CODE = 65


' En Función SPI_GetHiSpeedDeviceNameLocIDChannel el parámetro lpHiSpeedDeviceType será:
Public Enum hiSpeedDeviceTypes
    FT2232H_Device_Type = 1
    FT4232H_Device_Type = 2
End Enum

Public Enum CHIPSELECPINS
   ADBUS3ChipSelect = 0
   ADBUS4GPIOL1 = 1
   ADBUS5GPIOL2 = 2
   ADBUS6GPIOL3 = 3
   ADBUS7GPIOL4 = 4
End Enum

Public Enum WAITDATAWRITEPINS
   ADBUS2DataIn = 0
   ACBUS0GPIOH1 = 1
   ACBUS1GPIOH2 = 2
   ACBUS2GPIOH3 = 3
   ACBUS3GPIOH4 = 4
   ACBUS4GPIOH5 = 5
   ACBUS5GPIOH6 = 6
   ACBUS6GPIOH7 = 7
   ACBUS7GPIOH8 = 8
End Enum

' TAMAÑOS DE BUFFERS O CADENAS INTERCAMBIADAS CON LAS FUNCIONES DE LIBREARIA
Public Const WRITE_CONTROL_BUFFER_SIZE = 256    ' En WriteControlBuffer de SPI_WriteHiSpeedDevice, SPI_Write, SPI_Read,....
Public Const WRITE_DATA_BUFFER_SIZE = 65536     ' En WriteDataBuffer de SPI_WriteHiSpeedDevice, SPI_Write,....
Public Const READ_DATA_BUFFER_SIZE = 65536      ' En ReadDataBuffer de SPI_ReadHiSpeedDevice, SPI_Read,....
Public Const READ_CMDS_DATA_BUFFER_SIZE = 131071 ' En ReadCmdSequenceDataBuffer de SPI_ExecuteDeviceCmdSequence

Public Const MAX_NUM_DEVICE_NAME_CHARS = 200    ' En SPI_GetDeviceNameLocID, SPI_GetHiSpeedDeviceNameLocIDChannel (PDF dice 50 y 100 respectivamente???)
Public Const MAX_NUM_CHANNEL_CHARS = 5          ' En SPI_GetHiSpeedDeviceNameLocIDChannel
Public Const MAX_NUM_DLL_VERSION_CHARS = 10     ' En SPI_GetDllVersion
Public Const MAX_NUM_ERROR_MESSAGE_CHARS = 200  ' En SPI_GetErrorCodeString (PDF dice 100??)







'''' 1 Command Processor for MPSSE and MCU Host Bus Emulation
''''
'''' 1.1 Overview
'''' The FT2232 incorporates a command processor called the Multi-Protocol Synchronous Serial
'''' Engine (MPSSE). The purpose of the MPSSE command processor is to communicate with
'''' devices which use synchronous protocols (such as JTAG or SPI) in an efficient manner.
''''
'''' The MPSSE Command Processor unit is controlled using a SETUP command. Various
'''' commands are used to clock data out of and into the chip, as well as controlling the other I/O lines.
'''' If disabled the MPSSE is held reset and will not have any effect on the rest of the chip. When
'''' enabled, it will take its commands and data from the OUT data written to the OUT pipe in the chip.
'''' This is done by simply using the normal WRITE command, as if data were being writen to a COM
'''' port. Any data read will be passed back in the normal IN pipe. This is done using the normal
'''' READ command, as if data were being read from a COM port.
'''
'''
'''
'''
''''GPIOL3,GPIOL2,GPIOL1,GPIOL0, CS, DI, DO, SK
'''
'''' Clock Data Bytes Out on +ve Clock Edge MSB First (no Read)
'''' Use if TCK/SK starts at '1'.
'''' 0x10,
'''' LengthL,
'''' LengthH,
'''' Byte1
'''' ..
'''' Byte65536 (Max)
''''
'''' This will clock out bytes on TDI/DO from 1 to 65536 depending on the Length bytes. A length of
'''' 0x0000 will do 1 byte, and a length of 0xFFFF will do 65536 bytes. The data is sent MSB first. Bit 7
'''' of the first byte is placed on TDI/DO then the TCK/SK pin is clocked. The data will change to the
'''' next bit on the rising edge of the TCK/SK pin.
''''
'''' ATENCIÓN: Aunque este comando puede manda 65536 datos, aquí está limitado a 32767
'''Public Function MPSSE_DataOut(Data() As Byte) As String
'''   Dim Buffer As String, i As Integer
'''   Dim NBytes As Integer, NBytesH As Byte, NBytesL As Byte
'''
'''   NBytes = UBound(Data) + 1     ' +1 porque el indice empieza en 0 -> ubound=3-> 0,1,2,3: 4 Bytes
'''   Buffer = Buffer + Chr(MPSSE_CmdWriteDO)
'''   Integer2HL NBytes, NBytesH, NBytesL
'''   Buffer = Buffer + Chr(NBytesL) + Chr(NBytesH)
'''   For i = 0 To UBound(Data)
'''      Buffer = Buffer + Chr(Data)
'''   Next i
'''
'''   MPSSE_DataOut = Buffer
'''End Function
'''
'''
'''' Set Data Bits Low Byte
'''' 0x80,
'''' 0xValue,
'''' 0xDirection
'''' This will setup the direction of the first 8 lines and force a value on the bits that are set as output. A
'''''1' in the Direction byte will make that bit an output.
'''Public Function MPSSE_SetDataBitsL(DataVal As Byte, DataDir As Byte) As String
'''   Dim Buffer As String
'''   Dim NBytes As Long, NBytesH As Byte, NBytesL As Byte
'''
'''
'''   'DataVal = FTPinsL2Byte(SK, DOut, DInp, CS, GPIOL0, GPIOL1, GPIOL2, GPIOL3)
'''   'DataDir = FTPinsL2Byte(SK, DOut, DInp, CS, GPIOL0, GPIOL1, GPIOL2, GPIOL3)
'''
'''   Buffer = Buffer + Chr(MPSSE_CmdSetPortL)
'''
'''   MPSSE_SetDataBitsL = Buffer
'''End Function

'''Public Function FTPinsL2Byte(SK As Byte, DOut As Byte, DInp As Byte, CS As Byte, GPIOL0 As Byte, GPIOL1 As Byte, GPIOL2 As Byte, GPIOL3 As Byte) As Byte
'''   Dim Dato As Byte
'''   Dato = (GPIOL3 * 128) + (GPIOL2 * 64) + (GPIOL1 * 32) + (GPIOL0 * 16) + (CS * 8) + (DInp * 4) + (DOut * 2) + SK
'''   FTPinsL2Byte = Dato
'''End Function
'''
'''
'''Public Function Bit2Byte(B7 As Byte, B6 As Byte, B5 As Byte, B4 As Byte, B3 As Byte, B2 As Byte, B1 As Byte, B0 As Byte) As Byte
'''   Dim Dato As Byte
'''   Dato = (B7 * 128) + (B6 * 64) + (B5 * 32) + (B4 * 16) + (B3 * 8) + (B2 * 4) + (B1 * 2) + B0
'''   Bit2Byte = Dato
'''End Function

'''' Send Immediate
'''' 0x87
'''' This will make the chip flush its buffer back to the PC.Public Function MPSSE_SendInmediate() As String
'''Public Function MPSSE_SendInmediate() As String
'''   MPSSE_SendInmediate = Chr(MPSSE_CmdSendInmediate)
'''End Function

