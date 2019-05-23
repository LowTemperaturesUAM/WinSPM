unit FT2232CSPIUnit;

interface

uses
  Windows;

type FTC_STATUS = Integer;

const MAX_NUM_DEVICE_NAME_CHARS = 200;

type TDeviceName = array [0..(MAX_NUM_DEVICE_NAME_CHARS - 1)] of Char;
type PDeviceName = ^TDeviceName;

type FtcChipSelectPins = record
  bADBUS3ChipSelectPinState: LongBool;
  bADBUS4GPIOL1PinState: LongBool;
  bADBUS5GPIOL2PinState: LongBool;
  bADBUS6GPIOL3PinState: LongBool;
  bADBUS7GPIOL4PinState: LongBool;
end;

type PFtcChipSelectPins = ^FtcChipSelectPins;

type FtcInputOutputPins = record
  bPin1InputOutputState: LongBool;
  bPin1LowHighState: LongBool;
  bPin2InputOutputState: LongBool;
  bPin2LowHighState: LongBool;
  bPin3InputOutputState: LongBool;
  bPin3LowHighState: LongBool;
  bPin4InputOutputState: LongBool;
  bPin4LowHighState: LongBool;

  bPin5InputOutputState: LongBool;
  bPin5LowHighState: LongBool;
  bPin6InputOutputState: LongBool;
  bPin6LowHighState: LongBool;
  bPin7InputOutputState: LongBool;
  bPin7LowHighState: LongBool;
  bPin8InputOutputState: LongBool;
  bPin8LowHighState: LongBool;



end;

type PFtcInputOutputPins = ^FtcInputOutputPins;

type FtcLowHighPins = record
  bPin1LowHighState: LongBool;
  bPin2LowHighState: LongBool;
  bPin3LowHighState: LongBool;
  bPin4LowHighState: LongBool;
end;

type PFtcLowHighPins = ^FtcLowHighPins;

type FtcInitCondition = record
  //bClockPinStateBeforeChipSelect: LongBool;
  //bClockPinStateAfterChipSelect: LongBool;
  bClockPinState: LongBool;
  bDataOutPinState: LongBool;
  bChipSelectPinState: LongBool;
  dwChipSelectPin: Dword;
end;

type PFtcInitCondition = ^FtcInitCondition;

const MAX_WRITE_CONTROL_BYTES_BUFFER_SIZE = 255;    // 256 bytes

type WriteControlByteBuffer = array[0..(MAX_WRITE_CONTROL_BYTES_BUFFER_SIZE - 1)] of Byte;
type PWriteControlByteBuffer = ^WriteControlByteBuffer;

const MAX_WRITE_DATA_BYTES_BUFFER_SIZE = 65535;    // 64k bytes

type WriteDataByteBuffer = array[0..(MAX_WRITE_DATA_BYTES_BUFFER_SIZE - 1)] of Byte;
type PWriteDataByteBuffer = ^WriteDataByteBuffer;

type FtcWaitDataWrite = record
  bWaitDataWriteComplete: LongBool;
  dwWaitDataWritePin: Dword;
  bDataWriteCompleteState: LongBool;
  dwDataWriteTimeoutmSecs: Dword;
end;

type PFtcWaitDataWrite = ^FtcWaitDataWrite;

type FtcHigherOutputPins = record
  bPin1State: LongBool;
  bPin1ActiveState: LongBool;
  bPin2State: LongBool;
  bPin2ActiveState: LongBool;
  bPin3State: LongBool;
  bPin3ActiveState: LongBool;
  bPin4State: LongBool;
  bPin4ActiveState: LongBool;
end;

type PFtcHigherOutputPins = ^FtcHigherOutputPins;

const MAX_READ_DATA_BYTES_BUFFER_SIZE = 65535;    // 64k bytes

type ReadDataByteBuffer = array[0..(MAX_READ_DATA_BYTES_BUFFER_SIZE - 1)] of Byte;
type PReadDataByteBuffer = ^ReadDataByteBuffer;

const MAX_READ_CMDS_DATA_BYTES_BUFFER_SIZE = 131071;  // 128K bytes 

type ReadCmdSequenceDataByteBuffer = array[0..(MAX_READ_CMDS_DATA_BYTES_BUFFER_SIZE - 1)] of Byte;
type PReadCmdSequenceDataByteBuffer = ^ReadCmdSequenceDataByteBuffer;

const MAX_NUM_DLL_VERSION_CHARS = 10;

type TDllVersion = array [0..(MAX_NUM_DLL_VERSION_CHARS - 1)] of Char;
type PDllVersion = ^TDllVersion;

const MAX_NUM_ERROR_MESSAGE_CHARS = 200;

type TErrorMessage = array [0..(MAX_NUM_ERROR_MESSAGE_CHARS - 1)] of Char;
type PErrorMessage = ^TErrorMessage;

type TFT2232CSPI = class
 public
  constructor create;
  function  GetNumDevices(pdwNumDevices: PDword): FTC_STATUS;
  function  GetDeviceNameLocID(dwDeviceNameIndex: Dword; pDeviceNameBuffer: PDeviceName; dwBufferSize: Dword; pdwLocationID: PDword): FTC_STATUS;
  function  OpenEx(DeviceName: String; dwLocationID: Dword; pFtHandle: PDword): FTC_STATUS;
  function  Open(pFtHandle: PDword): FTC_STATUS;
  function  Close(fthandle: Dword): FTC_STATUS;
  function  InitDevice(fthandle: Dword; dwClockDivisor: Dword): FTC_STATUS;
  function  GetClock(dwClockDivisor: Dword; pdwClockFrequencyHz: PDword): FTC_STATUS;
  function  SetClock(fthandle: Dword; dwClockDivisor: Dword; pdwClockFrequencyHz: PDword): FTC_STATUS;
  function  SetLoopback(fthandle: Dword; bLoopbackState: LongBool): FTC_STATUS;
  function  SetGPIOs(fthandle: Dword; ChipSelectsDisableStates: PFtcChipSelectPins; HighInputOutputPins: PFtcInputOutputPins): FTC_STATUS;
    function  SetHiSpeedDeviceGPIOs(fthandle: Dword; ChipSelectsDisableStates: PFtcChipSelectPins; HighInputOutputPins: PFtcInputOutputPins): FTC_STATUS;

  function  GetGPIOs(fthandle: Dword; HighPinsInputData: PFtcLowHighPins): FTC_STATUS;
  function  Write(fthandle: Dword; pWriteStartCondition: PFtcInitCondition; bClockOutDataBitsMSBFirst: LongBool; bClockOutDataBitsPosEdge: LongBool; dwNumControlBitsToWrite: Dword; pWriteControlBuffer: PWriteControlByteBuffer; dwNumControlBytesToWrite: Dword; bWriteDataBits: LongBool; dwNumDataBitsToWrite: Dword; pWriteDataBuffer: PWriteDataByteBuffer; dwNumDataBytesToWrite: Dword; pWaitDataWriteComplete: PFtcWaitDataWrite; pHighPinsWriteActiveStates: PFtcHigherOutputPins): FTC_STATUS;
  function  Read(fthandle: Dword; pReadStartCondition: PFtcInitCondition; bClockOutControlBitsMSBFirst: LongBool; bClockOutControlBitsPosEdge: LongBool; dwNumControlBitsToWrite: Dword; pWriteControlBuffer: PWriteControlByteBuffer; dwNumControlBytesToWrite: Dword; bClockInDataBitsMSBFirst: LongBool; bClockInDataBitsPosEdge: LongBool; dwNumDataBitsToRead: Dword; pReadDataBuffer: PReadDataByteBuffer; pdwNumDataBytesReturned: PDword; pHighPinsReadActiveStates: PFtcHigherOutputPins): FTC_STATUS;
  function  ClearDeviceCmdSequence(fthandle: Dword): FTC_STATUS;
  function  AddDeviceWriteCmd(fthandle: Dword; pWriteStartCondition: PFtcInitCondition; bClockOutDataBitsMSBFirst: LongBool; bClockOutDataBitsPosEdge: LongBool; dwNumControlBitsToWrite: Dword; pWriteControlBuffer: PWriteControlByteBuffer; dwNumControlBytesToWrite: Dword; bWriteDataBits: LongBool; dwNumDataBitsToWrite: Dword; pWriteDataBuffer: PWriteDataByteBuffer; dwNumDataBytesToWrite: Dword; pHighPinsWriteActiveStates: PFtcHigherOutputPins): FTC_STATUS;
  function  AddDeviceReadCmd(fthandle: Dword; pReadStartCondition: PFtcInitCondition; bClockOutControlBitsMSBFirst: LongBool; bClockOutControlBitsPosEdge: LongBool; dwNumControlBitsToWrite: Dword; pWriteControlBuffer: PWriteControlByteBuffer; dwNumControlBytesToWrite: Dword; bClockInDataBitsMSBFirst: LongBool; bClockInDataBitsPosEdge: LongBool; dwNumDataBitsToRead: Dword; pHighPinsReadActiveStates: PFtcHigherOutputPins): FTC_STATUS;
  function  ExecuteDeviceCmdSequence(fthandle: Dword; ReadCmdSequenceDataByteBuffer: PReadCmdSequenceDataByteBuffer; pdwNumBytesReturned: PDword): FTC_STATUS;
  function  GetDllVersion(DllVersionBuffer: pDllVersion; dwBufferSize: Dword): FTC_STATUS;
  function  GetErrorCodeString(Language: String; StatusCode: FTC_STATUS; pErrorMessageBuffer: PErrorMessage; dwBufferSize: Dword): FTC_STATUS;
end;


const
  FT2232CSPI_DLL_Name = 'ftcspi.dll';
  otra_DLL_Name ='ftd2xx.dll';

  ADBUS3ChipSelect = 0;
  ADBUS4GPIOL1 = 1;
  ADBUS5GPIOL2 = 2;
  ADBUS6GPIOL3 = 3;
  ADBUS7GPIOL4 = 4;

  ADBUS2DataIn = 0;
  ACBUS0GPIOH1 = 1;
  ACBUS1GPIOH2 = 2;
  ACBUS2GPIOH3 = 3;
  ACBUS3GPIOH4 = 4;

  FTC_SUCCESS = 0;
  FTC_FAILED_TO_COMPLETE_COMMAND = 20;
  FTC_NO_COMMAND_SEQUENCE = 52;

  ENGLISH = 'EN';


implementation

function SPI_GetNumDevices(pdwNumDevices: PDword): FTC_STATUS; stdcall ; External FT2232CSPI_DLL_Name name 'SPI_GetNumDevices';
function SPI_GetDeviceNameLocID(dwDeviceNameIndex: Dword; pDeviceNameBuffer: PDeviceName; dwBufferSize: Dword; pdwLocationID: PDword): FTC_STATUS; stdcall ; External FT2232CSPI_DLL_Name name 'SPI_GetDeviceNameLocID';
function SPI_OpenEx(DeviceName: String; dwLocationID: Dword; pFtHandle: PDword): FTC_STATUS; stdcall ; External FT2232CSPI_DLL_Name name 'SPI_OpenEx';
function SPI_Open(pFtHandle: PDword): FTC_STATUS; stdcall ; External FT2232CSPI_DLL_Name name 'SPI_Open';
function SPI_Close(fthandle: Dword): FTC_STATUS; stdcall ; External FT2232CSPI_DLL_Name name 'SPI_Close';
function SPI_InitDevice(fthandle: Dword; dwClockFrequencyValue: Dword): FTC_STATUS; stdcall ; External FT2232CSPI_DLL_Name name 'SPI_InitDevice';
function SPI_GetClock(dwClockDivisor: Dword; pdwClockFrequencyHz: PDword): FTC_STATUS; stdcall ; External FT2232CSPI_DLL_Name name 'SPI_GetClock';
function SPI_SetClock(fthandle: Dword; dwClockDivisor: Dword; pdwClockFrequencyHz: PDword): FTC_STATUS; stdcall ; External FT2232CSPI_DLL_Name name 'SPI_SetClock';
function SPI_SetLoopback(fthandle: Dword; bLoopbackState: LongBool): FTC_STATUS; stdcall ; External FT2232CSPI_DLL_Name name 'SPI_SetLoopback';
function SPI_SetGPIOs(fthandle: Dword; ChipSelectsDisableStates: PFtcChipSelectPins; HighInputOutputPins: PFtcInputOutputPins): FTC_STATUS; stdcall ; External FT2232CSPI_DLL_Name name 'SPI_SetGPIOs';
function SPI_SetHiSpeedDeviceGPIOs(fthandle: Dword; ChipSelectsDisableStates: PFtcChipSelectPins; HighInputOutputPins: PFtcInputOutputPins): FTC_STATUS; stdcall ; External FT2232CSPI_DLL_Name name 'SPI_SetHiSpeedDeviceGPIOs';

function SPI_GetGPIOs(fthandle: Dword; HighPinsInputData: PFtcLowHighPins): FTC_STATUS; stdcall ; External FT2232CSPI_DLL_Name name 'SPI_GetGPIOs';
function SPI_Write(fthandle: Dword; pWriteStartCondition: PFtcInitCondition; bClockOutDataBitsMSBFirst: LongBool; bClockOutDataBitsPosEdge: LongBool; dwNumControlBitsToWrite: Dword; pWriteControlBuffer: PWriteControlByteBuffer; dwNumControlBytesToWrite: Dword; bWriteDataBits: LongBool; dwNumDataBitsToWrite: Dword; pWriteDataBuffer: PWriteDataByteBuffer; dwNumDataBytesToWrite: Dword; pWaitDataWriteComplete: PFtcWaitDataWrite; pHighPinsWriteActiveStates: PFtcHigherOutputPins): FTC_STATUS; stdcall ; External FT2232CSPI_DLL_Name name 'SPI_Write';
function SPI_Read(fthandle: Dword; pReadStartCondition: PFtcInitCondition; bClockOutControlBitsMSBFirst: LongBool; bClockOutControlBitsPosEdge: LongBool; dwNumControlBitsToWrite: Dword; pWriteControlBuffer: PWriteControlByteBuffer; dwNumControlBytesToWrite: Dword; bClockInDataBitsMSBFirst: LongBool; bClockInDataBitsPosEdge: LongBool; dwNumDataBitsToRead: Dword; pReadDataBuffer: PReadDataByteBuffer; pdwNumDataBytesReturned: PDword; pHighPinsReadActiveStates: PFtcHigherOutputPins): FTC_STATUS; stdcall ; External FT2232CSPI_DLL_Name name 'SPI_Read';
function SPI_ClearDeviceCmdSequence(fthandle: Dword): FTC_STATUS; stdcall ; External FT2232CSPI_DLL_Name name 'SPI_ClearDeviceCmdSequence';
function SPI_AddDeviceWriteCmd(fthandle: Dword; pWriteStartCondition: PFtcInitCondition; bClockOutDataBitsMSBFirst: LongBool; bClockOutDataBitsPosEdge: LongBool; dwNumControlBitsToWrite: Dword; pWriteControlBuffer: PWriteControlByteBuffer; dwNumControlBytesToWrite: Dword; bWriteDataBits: LongBool; dwNumDataBitsToWrite: Dword; pWriteDataBuffer: PWriteDataByteBuffer; dwNumDataBytesToWrite: Dword; pHighPinsWriteActiveStates: PFtcHigherOutputPins): FTC_STATUS; stdcall ; External FT2232CSPI_DLL_Name name 'SPI_AddDeviceWriteCmd';
function SPI_AddDeviceReadCmd(fthandle: Dword; pReadStartCondition: PFtcInitCondition; bClockOutControlBitsMSBFirst: LongBool; bClockOutControlBitsPosEdge: LongBool; dwNumControlBitsToWrite: Dword; pWriteControlBuffer: PWriteControlByteBuffer; dwNumControlBytesToWrite: Dword; bClockInDataBitsMSBFirst: LongBool; bClockInDataBitsPosEdge: LongBool; dwNumDataBitsToRead: Dword; pHighPinsReadActiveStates: PFtcHigherOutputPins): FTC_STATUS; stdcall ; External FT2232CSPI_DLL_Name name 'SPI_AddDeviceReadCmd';
function SPI_ExecuteDeviceCmdSequence(fthandle: Dword; ReadCmdSequenceDataByteBuffer: PReadCmdSequenceDataByteBuffer; pdwNumBytesReturned: PDword): FTC_STATUS; stdcall ; External FT2232CSPI_DLL_Name name 'SPI_ExecuteDeviceCmdSequence';
function SPI_GetDllVersion(DllVersionBuffer: pDllVersion; dwBufferSize: Dword): FTC_STATUS; stdcall ; External FT2232CSPI_DLL_Name name 'SPI_GetDllVersion';
function SPI_GetErrorCodeString(Language: PChar; StatusCode: FTC_STATUS; ErrorMessageBuffer: PErrorMessage; dwBufferSize: Dword): FTC_STATUS; stdcall ; External FT2232CSPI_DLL_Name name 'SPI_GetErrorCodeString';


constructor TFT2232CSPI.create;
begin
end;

function  TFT2232CSPI.GetNumDevices(pdwNumDevices: PDword): FTC_STATUS;
begin
  Result := SPI_GetNumDevices(pdwNumDevices);
end;

function  TFT2232CSPI.GetDeviceNameLocID(dwDeviceNameIndex: Dword; pDeviceNameBuffer: PDeviceName;
                                         dwBufferSize: Dword; pdwLocationID: PDword): FTC_STATUS;
begin
  Result := SPI_GetDeviceNameLocID(dwDeviceNameIndex, pDeviceNameBuffer, dwBufferSize, pdwLocationID);
end;

function  TFT2232CSPI.OpenEx(DeviceName: String; dwLocationID: Dword; pFtHandle: PDword): FTC_STATUS;
begin
  Result := SPI_OpenEx(DeviceName, dwLocationID, pFtHandle);
end;

function  TFT2232CSPI.Open(pFtHandle: PDword): FTC_STATUS;
begin
  Result := SPI_Open(pFtHandle);
end;

function  TFT2232CSPI.Close(fthandle: Dword): FTC_STATUS;
begin
  Result := SPI_Close(fthandle);
end;

function  TFT2232CSPI.InitDevice(fthandle: Dword; dwClockDivisor: Dword): FTC_STATUS;
begin
  Result := SPI_InitDevice(fthandle, dwClockDivisor);
end;

function  TFT2232CSPI.GetClock(dwClockDivisor: Dword; pdwClockFrequencyHz: PDword): FTC_STATUS;
begin
  Result := SPI_GetClock(dwClockDivisor, pdwClockFrequencyHz);
end;

function  TFT2232CSPI.SetClock(fthandle: Dword; dwClockDivisor: Dword; pdwClockFrequencyHz: PDword): FTC_STATUS;
begin
  Result := SPI_SetClock(fthandle, dwClockDivisor, pdwClockFrequencyHz);
end;

function  TFT2232CSPI.SetLoopback(fthandle: Dword; bLoopbackState: LongBool): FTC_STATUS;
begin
  Result := SPI_SetLoopback(fthandle, bLoopbackState);
end;

function  TFT2232CSPI.SetGPIOs(fthandle: Dword; ChipSelectsDisableStates: PFtcChipSelectPins; HighInputOutputPins: PFtcInputOutputPins): FTC_STATUS;
begin
  Result := SPI_SetGPIOs(fthandle, ChipSelectsDisableStates, HighInputOutputPins);
end;

function  TFT2232CSPI.SetHiSpeedDeviceGPIOs(fthandle: Dword; ChipSelectsDisableStates: PFtcChipSelectPins; HighInputOutputPins: PFtcInputOutputPins): FTC_STATUS;
begin
  Result := SPI_SetHiSpeedDeviceGPIOs(fthandle, ChipSelectsDisableStates, HighInputOutputPins);
end;





function  TFT2232CSPI.GetGPIOs(fthandle: Dword; HighPinsInputData: PFtcLowHighPins): FTC_STATUS;
begin
  Result := SPI_GetGPIOs(fthandle, HighPinsInputData);
end;

function  TFT2232CSPI.Write(fthandle: Dword; pWriteStartCondition: PFtcInitCondition; bClockOutDataBitsMSBFirst: LongBool;
                            bClockOutDataBitsPosEdge: LongBool; dwNumControlBitsToWrite: Dword; pWriteControlBuffer: PWriteControlByteBuffer;
                            dwNumControlBytesToWrite: Dword; bWriteDataBits: LongBool; dwNumDataBitsToWrite: Dword;
                            pWriteDataBuffer: PWriteDataByteBuffer; dwNumDataBytesToWrite: Dword; pWaitDataWriteComplete: PFtcWaitDataWrite;
                            pHighPinsWriteActiveStates: PFtcHigherOutputPins): FTC_STATUS;
begin
  Result := SPI_Write(fthandle, pWriteStartCondition, bClockOutDataBitsMSBFirst, bClockOutDataBitsPosEdge, dwNumControlBitsToWrite, pWriteControlBuffer, dwNumControlBytesToWrite, bWriteDataBits, dwNumDataBitsToWrite, pWriteDataBuffer, dwNumDataBytesToWrite, pWaitDataWriteComplete, pHighPinsWriteActiveStates);
end;

function  TFT2232CSPI.Read(fthandle: Dword; pReadStartCondition: PFtcInitCondition; bClockOutControlBitsMSBFirst: LongBool;
                           bClockOutControlBitsPosEdge: LongBool; dwNumControlBitsToWrite: Dword; pWriteControlBuffer: PWriteControlByteBuffer;
                           dwNumControlBytesToWrite: Dword; bClockInDataBitsMSBFirst: LongBool; bClockInDataBitsPosEdge: LongBool;
                           dwNumDataBitsToRead: Dword; pReadDataBuffer: PReadDataByteBuffer; pdwNumDataBytesReturned: PDword;
                           pHighPinsReadActiveStates: PFtcHigherOutputPins): FTC_STATUS;
begin
  Result := SPI_Read(fthandle, pReadStartCondition, bClockOutControlBitsMSBFirst, bClockOutControlBitsPosEdge, dwNumControlBitsToWrite, pWriteControlBuffer, dwNumControlBytesToWrite, bClockInDataBitsMSBFirst, bClockInDataBitsPosEdge, dwNumDataBitsToRead, pReadDataBuffer, pdwNumDataBytesReturned, pHighPinsReadActiveStates);
end;

function  TFT2232CSPI.ClearDeviceCmdSequence(fthandle: Dword): FTC_STATUS;
begin
  Result := SPI_ClearDeviceCmdSequence(fthandle);
end;

function  TFT2232CSPI.AddDeviceWriteCmd(fthandle: Dword; pWriteStartCondition: PFtcInitCondition;
                                        bClockOutDataBitsMSBFirst: LongBool; bClockOutDataBitsPosEdge: LongBool;
                                        dwNumControlBitsToWrite: Dword; pWriteControlBuffer: PWriteControlByteBuffer;
                                        dwNumControlBytesToWrite: Dword; bWriteDataBits: LongBool; dwNumDataBitsToWrite: Dword;
                                        pWriteDataBuffer: PWriteDataByteBuffer; dwNumDataBytesToWrite: Dword;
                                        pHighPinsWriteActiveStates: PFtcHigherOutputPins): FTC_STATUS;
begin
  Result := SPI_AddDeviceWriteCmd(fthandle, pWriteStartCondition, bClockOutDataBitsMSBFirst, bClockOutDataBitsPosEdge, dwNumControlBitsToWrite, pWriteControlBuffer, dwNumControlBytesToWrite, bWriteDataBits, dwNumDataBitsToWrite, pWriteDataBuffer, dwNumDataBytesToWrite, pHighPinsWriteActiveStates);
end;

function  TFT2232CSPI.AddDeviceReadCmd(fthandle: Dword; pReadStartCondition: PFtcInitCondition; bClockOutControlBitsMSBFirst: LongBool;
                                       bClockOutControlBitsPosEdge: LongBool; dwNumControlBitsToWrite: Dword;
                                       pWriteControlBuffer: PWriteControlByteBuffer; dwNumControlBytesToWrite: Dword;
                                       bClockInDataBitsMSBFirst: LongBool; bClockInDataBitsPosEdge: LongBool;
                                       dwNumDataBitsToRead: Dword; pHighPinsReadActiveStates: PFtcHigherOutputPins): FTC_STATUS;
begin
  Result := SPI_AddDeviceReadCmd(fthandle, pReadStartCondition, bClockOutControlBitsMSBFirst, bClockOutControlBitsPosEdge, dwNumControlBitsToWrite, pWriteControlBuffer, dwNumControlBytesToWrite, bClockInDataBitsMSBFirst, bClockInDataBitsPosEdge, dwNumDataBitsToRead, pHighPinsReadActiveStates);
end;

function  TFT2232CSPI.ExecuteDeviceCmdSequence(fthandle: Dword; ReadCmdSequenceDataByteBuffer: PReadCmdSequenceDataByteBuffer;
                                         pdwNumBytesReturned: PDword): FTC_STATUS;
begin
  Result := SPI_ExecuteDeviceCmdSequence(fthandle, ReadCmdSequenceDataByteBuffer, pdwNumBytesReturned);
end;

function  TFT2232CSPI.GetDllVersion(DllVersionBuffer: pDllVersion; dwBufferSize: Dword): FTC_STATUS;
begin
  Result := SPI_GetDllVersion(DllVersionBuffer, dwBufferSize);
end;

function  TFT2232CSPI.GetErrorCodeString(Language: String; StatusCode: FTC_STATUS; pErrorMessageBuffer: PErrorMessage; dwBufferSize: Dword): FTC_STATUS;
begin
  Result := SPI_GetErrorCodeString(PChar(Language), StatusCode, pErrorMessageBuffer, dwBufferSize);
end;

end.
