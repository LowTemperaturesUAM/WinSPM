unit SPIDLLFuncUnit;

interface

uses
  Windows, Classes, SysUtils,  Dialogs, Controls, FT2232CSPIUnit;

type FtcOpenedDevice = record
  ftHandle: Dword;
  DeviceName: String;
end;

type FtcLocationID = record
  dwLocationID: Dword;
  DeviceName: String;
end;

type TBitLengths = array[0..9999] of integer;

type FtcBitLengths = record
  BitLengths: TBitLengths;
  iNumBitLengths: integer;
end;

procedure DisplayFT2232CSPIDllError(ProgFunctionName, DllFunctionName: String; ftStatus: FTC_STATUS);
function  GetSPIDeviceNames(var DeviceNames: TStringList): Boolean;
function  OpenSPIDevice(DeviceName: String; dwClockDivisor: Dword; pdwClockFrequencyHz: PDword): Boolean;
function  CloseSPIDevice(DeviceName: String; var DisplayLines: TStringList): Boolean;
function  Program_93LC56B_Device(bErase, bWriteWait: Boolean; WordValue: String; bBufferSPICommands: Boolean; var DisplayLines: TStringList): FTC_STATUS;
function  Program_MCP42XXX_Device(bErase: Boolean; WordValue: String; bPotentiometer0, bPotentiometer1: Boolean;
                                  bBufferSPICommands: Boolean; var DisplayLines: TStringList): FTC_STATUS;
function  Write_DS1305_Device(bBufferSPICommands: Boolean; var DisplayLines: TStringList;
                              dwNumControlBitsToWrite, dwNumControlBytesToWrite: Dword;
                              pWriteControlBuffer: PWriteControlByteBuffer; bWriteDataBits: Boolean;
                              dwNumDataBitsToWrite, dwNumDataBytesToWrite: Dword;
                              pWriteDataBuffer: PWriteDataByteBuffer): FTC_STATUS;                                  
function  Program_DS1305_Device(bErase: Boolean; bBufferSPICommands: Boolean; var DisplayLines: TStringList): FTC_STATUS;
function  Program_M95128_Device(bErase, bPageWrite: Boolean; WordValue: String; var DisplayLines: TStringList): FTC_STATUS;
function  Program_M95020_Device(bErase, bPageWrite: Boolean; WordValue: String; var DisplayLines: TStringList): FTC_STATUS;
function  Program_External_Device(DeviceName: String; ExternalDeviceIndex: Integer;
                                  dwClockDivisor: Dword; bErase, bWriteWait, bPageWrite: Boolean;
                                  WordValue: String; bPotentiometer0, bPotentiometer1: Boolean;
                                  bBufferSPICommands: Boolean; var DisplayLines: TStringList): Boolean;
function  Read_93C56_Device(bBufferSPICommands: Boolean; dwDeviceHandleIndex: Dword; var DisplayLines: TStringList): FTC_STATUS;
function  Read_DS1305_Device(bBufferSPICommands: Boolean; dwDeviceHandleIndex: Dword; var DisplayLines: TStringList): FTC_STATUS;
function  Read_M95128_Device(bBlockRead, bBufferSPICommands: Boolean; dwDeviceHandleIndex: Dword; var DisplayLines: TStringList): FTC_STATUS;
function  Read_M95020_Device(bBlockRead, bBufferSPICommands: Boolean; dwDeviceHandleIndex: Dword; var DisplayLines: TStringList): FTC_STATUS;
procedure Read_External_Device(DeviceName: String; ExternalDeviceIndex: Integer; dwClockDivisor: Dword;
                               bBlockRead, bBufferSPICommands: Boolean; var DisplayLines: TStringList);
procedure Execute93LC56BDeviceCommandSequence(ExecftHandle: Dword; dwDeviceIndex: Dword; DeviceName: String; var DisplayLines: TStringList);
procedure ExecuteMCP42XXXDeviceCommandSequence(ExecftHandle: Dword; dwDeviceIndex: Dword; DeviceName: String; var DisplayLines: TStringList);
procedure ExecuteDS1305DeviceCommandSequence(ExecftHandle: Dword; dwDeviceIndex: Dword; DeviceName: String; var DisplayLines: TStringList);
procedure ExecuteM95128DeviceCommandSequence(ExecftHandle: Dword; dwDeviceIndex: Dword; DeviceName: String; var DisplayLines: TStringList);
procedure ExecuteM95020DeviceCommandSequence(ExecftHandle: Dword; dwDeviceIndex: Dword; DeviceName: String; var DisplayLines: TStringList);
function  ExecuteSPIDeviceCommandSequence(DeviceName: String; ExternalDeviceIndex: Integer; var DisplayLines: TStringList): Boolean;

var
  FT2232CSPI: TFT2232CSPI;
  FT2232CSPIDll: Boolean;
  ftHandle: Dword;
  dwNumOpenedDevices: Dword;
  ftHandles : array[0..49] of FtcOpenedDevice;
  LocationIDs : array[0..49] of FtcLocationID;
  DeviceBitLengths : Array [0 .. 49] of FtcBitLengths;

const

  //MaxFreq93LC56BClockDivisor = 1;   // equivalent to 3MHz
  MaxFreq93LC56BClockDivisor = 3;   // equivalent to 1.5MHz
  MaxFreqMCP42XXXClockDivisor = 0;   // equivalent to 6MHz
  MaxFreqDS1305ClockDivisor = 3;   // equivalent to 1.5MHz
  MaxFreqM95128ClockDivisor = 5;   // equivalent to 1.0MHz
  MaxFreqM95020ClockDivisor = 5;   // equivalent to 1.0MHz

  MaxSPI93LC56BChipSizeInWords = 128;
  MaxSPI93LC56BChipSizeInBytes = (MaxSPI93LC56BChipSizeInWords * 2);

  SPIM95128MemoryReadWriteInBytes = 1280;

  MaxSPIM95020ChipSizeInBytes = 256;

  NumSPIChips = 5;
  SPIChips: array[0..(NumSPIChips - 1)] of String = ('93LC56B', 'MCP42XXX', 'DS1305','M95128', 'M95020');

  SPI93LC56BChipIndex = 0;
  SPIMCP42XXXChipIndex = 1;
  SPIDS1305ChipIndex = 2;
  SPIM95128ChipIndex = 3;
  SPIM95020ChipIndex = 4;

  SPI93LC56BEWENCmdIndex = 0;
  SPI93LC56BEWDSCmdIndex = 1;
  SPI93LC56BERALCmdIndex = 2;

  SPIM95128WRENCmdIndex = 0;
  SPIM95128WRDICmdIndex = 1;
  SPIM95128WRSRCmdIndex = 2;

  SPIM95020WRENCmdIndex = 0;
  SPIM95020WRDICmdIndex = 1;
  SPIM95020WRSRCmdIndex = 2;

  MCP42XXXChipWriteCmd = 16; //$10
  MCP42XXXChipShutdownCmd = 32; //$20

  DS1305ChipWriteEnableCmd = 0;
  DS1305ChipWriteDisableCmd = $40;

  MCP42XXXChipPotentiometer0SelectBit = 1; //$01
  MCP42XXXChipPotentiometer1SelectBit = 2; //$01

implementation

//uses DateTimeDialogUnit;//DSSPI

procedure DisplayFT2232CSPIDllError(ProgFunctionName, DllFunctionName: String; ftStatus: FTC_STATUS);
var
  ErrorMsg: TErrorMessage;
begin
  FT2232CSPI.GetErrorCodeString(ENGLISH, ftStatus, @ErrorMsg, MAX_NUM_ERROR_MESSAGE_CHARS);

  ShowMessage('Program function name = ' + ProgFunctionName +
              ', FT2232CSPI Dll function name = ' + DllFunctionName +
              ', Error message = ' + ErrorMsg);
end;

function GetSPIDeviceNames(var DeviceNames: TStringList): Boolean;
var
  ftStatus: FTC_STATUS;
  dwNumDevices, dwDeviceIndex: Dword;
  DeviceName: TDeviceName;
  dwLocationID: Dword;
begin
  ftStatus := -1;

  if (FT2232CSPIDll = True) then
  begin
    dwNumDevices := 0;
    ftStatus := FT2232CSPI.GetNumDevices(@dwNumDevices);

    if (ftStatus = FTC_SUCCESS) then
    begin
      if (dwNumDevices > 0) then
      begin
        for dwDeviceIndex := 0 to 49 do
        begin
          LocationIDs[dwDeviceIndex].DeviceName := '';
          LocationIDs[dwDeviceIndex].dwLocationID := 0;
        end;

        dwDeviceIndex := 0;
        repeat
          ftStatus := FT2232CSPI.GetDeviceNameLocID(dwDeviceIndex, @DeviceName, MAX_NUM_DEVICE_NAME_CHARS, @dwLocationID);

          DeviceNames.Add(DeviceName);

          LocationIDs[dwDeviceIndex].DeviceName := DeviceName;
          LocationIDs[dwDeviceIndex].dwLocationID := dwLocationID;

          Inc(dwDeviceIndex);
        until ((dwDeviceIndex >= dwNumDevices) or (ftStatus <> FTC_SUCCESS));

        if (ftStatus <> FTC_SUCCESS) then
          DisplayFT2232CSPIDllError('GetNames', 'GetDeviceNameLocID', ftStatus);
      end
      else
        ShowMessage('No FT2232C dual types devices connected.');
    end
    else
      DisplayFT2232CSPIDllError('GetNames', 'GetNumDevices', ftStatus);
  end;

  if (ftStatus = FTC_SUCCESS) then
    Result := True
  else
    Result := False;
end;

function  OpenSPIDevice(DeviceName: String; dwClockDivisor: Dword; pdwClockFrequencyHz: PDword): Boolean;
var
  ftStatus: FTC_STATUS;
  dwLocationID: Dword;
  dwDeviceHandleIndex: Dword;
  bDeviceStored: Boolean;
begin
  ftStatus := -1;

  if (FT2232CSPIDll = True) then
  begin
    for dwDeviceHandleIndex := 0 to 49 do
    begin
      if (LocationIDs[dwDeviceHandleIndex].DeviceName = DeviceName) then
        dwLocationID := LocationIDs[dwDeviceHandleIndex].dwLocationID;
    end;

    ftStatus := FT2232CSPI.OpenEx(DeviceName, dwLocationID, @ftHandle);

    if (ftStatus = FTC_SUCCESS) then
    begin
      ftStatus := FT2232CSPI.InitDevice(ftHandle, dwClockDivisor);

      if (ftStatus = FTC_SUCCESS) then
      begin
        ftStatus := FT2232CSPI.GetClock(dwClockDivisor, pdwClockFrequencyHz);

        if (ftStatus = FTC_SUCCESS) then
        begin
          ftStatus := FT2232CSPI.ClearDeviceCmdSequence(ftHandle);

          if (ftStatus = FTC_SUCCESS) then
          begin
            bDeviceStored := False;

            for dwDeviceHandleIndex := 0 to 49 do
            begin
              if ((ftHandles[dwDeviceHandleIndex].DeviceName = '') and
                  (ftHandles[dwDeviceHandleIndex].ftHandle = 0) and (not bDeviceStored)) then
              begin
                ftHandles[dwDeviceHandleIndex].ftHandle := ftHandle;
                ftHandles[dwDeviceHandleIndex].DeviceName := DeviceName;
                bDeviceStored := True;
              end;
            end;

            Inc(dwNumOpenedDevices);
          end
          else
            DisplayFT2232CSPIDllError('OpenSPIDevice', 'ClearDeviceCmdSequence', ftStatus);
        end
        else
          DisplayFT2232CSPIDllError('OpenSPIDevice', 'GetClock', ftStatus);
      end
      else
        DisplayFT2232CSPIDllError('OpenSPIDevice', 'InitDevice', ftStatus);

      if (ftStatus <> FTC_SUCCESS) then
      begin
        FT2232CSPI.Close(ftHandle);

        ftHandle := 0;
      end;
    end
    else
      DisplayFT2232CSPIDllError('OpenSPIDevice', 'OpenEx', ftStatus);
  end;

  if (ftStatus = FTC_SUCCESS) then
    Result := True
  else
    Result := False;
end;

function  CloseSPIDevice(DeviceName: String; var DisplayLines: TStringList): Boolean;
var
  ftStatus: FTC_STATUS;
  dwDeviceHandleIndex: Dword;
begin
  ftStatus := -1;

  if (ftHandle <> 0) then
  begin
    ftStatus := FT2232CSPI.Close(ftHandle);

    if (ftStatus = FTC_SUCCESS) then
    begin
      if (dwNumOpenedDevices > 1) then
      begin
        fthandle := 0;

        for dwDeviceHandleIndex := 0 to 49 do
        begin
          if (ftHandles[dwDeviceHandleIndex].DeviceName = DeviceName) then
          begin
            ftHandles[dwDeviceHandleIndex].ftHandle := ftHandle;
            ftHandles[dwDeviceHandleIndex].DeviceName := '';
          end;
        end;
      end
      else
      begin
        fthandle := 0;

        for dwDeviceHandleIndex := 0 to 49 do
        begin
          if (ftHandles[dwDeviceHandleIndex].DeviceName = DeviceName) then
          begin
            ftHandles[dwDeviceHandleIndex].ftHandle := ftHandle;
            ftHandles[dwDeviceHandleIndex].DeviceName := '';
          end;
        end;
      end;

      if (dwNumOpenedDevices > 0) then
        Dec(dwNumOpenedDevices);
    end
    else
      DisplayFT2232CSPIDllError('CloseSPIDevice', 'Close', ftStatus);

    ftHandle := 0;
  end
  else
    DisplayLines.Add('Selected device has not been opened.');

  if (ftStatus = FTC_SUCCESS) then
    Result := True
  else
    Result := False;  
end;

function SPI_EWEN_EWDS_ERAL_93LC56B_Device(pWriteStartCondition: PFtcInitCondition; dwSPICmdIndex: Dword; bBufferSPICommands: Boolean): FTC_STATUS;
var
  ftStatus: FTC_STATUS;
  ControlByte1, ControlByte2: Dword;
  WriteControlBuffer: WriteControlByteBuffer;
  WriteDataBuffer: WriteDataByteBuffer;
  WaitDataWriteComplete: FtcWaitDataWrite;
  HighPinsWriteActiveStates: FtcHigherOutputPins;
begin
  case dwSPICmdIndex of
    SPI93LC56BEWENCmdIndex: ControlByte1 := $9F; // set up write enable command
    SPI93LC56BEWDSCmdIndex: ControlByte1 := $87; // set up write disable command
    SPI93LC56BERALCmdIndex: ControlByte1 := $97; // set up erase all command
  end;

  ControlByte2 := $FF;

  WriteControlBuffer[0] := ControlByte1;
  WriteControlBuffer[1] := ControlByte2;

  WaitDataWriteComplete.bWaitDataWriteComplete := False;

  if (not bBufferSPICommands) then
  begin
    ftStatus := FT2232CSPI.Write(fthandle, pWriteStartCondition, True, False,
                                 11, @WriteControlBuffer, 2, False, 0, @WriteDataBuffer,
                                 0, @WaitDataWriteComplete, @HighPinsWriteActiveStates);

    if (ftStatus <> FTC_SUCCESS) then
      DisplayFT2232CSPIDllError('SPI_EWEN_EWDS_ERAL_93LC56B_Device', 'Write', ftStatus);
  end
  else
  begin
    ftStatus := FT2232CSPI.AddDeviceWriteCmd(fthandle, pWriteStartCondition, True, False,
                                             11, @WriteControlBuffer, 2, False, 0,
                                             @WriteDataBuffer, 0, @HighPinsWriteActiveStates);

    if (ftStatus <> FTC_SUCCESS) then
      DisplayFT2232CSPIDllError('SPI_EWEN_EWDS_ERAL_93LC56B_Device', 'AddDeviceWriteCmd', ftStatus);
  end;

  Result := ftStatus;
end;

function  Program_93LC56B_Device(bErase, bWriteWait: Boolean; WordValue: String; bBufferSPICommands: Boolean; var DisplayLines: TStringList): FTC_STATUS;
var
  ftStatus: FTC_STATUS;
  WriteStartCondition: FtcInitCondition;
  dwLocationAddress, dwWriteDataBufferIndex: Dword;
  ControlLocAddress1, ControlLocAddress2: Byte;
  WriteControlBuffer: WriteControlByteBuffer;
  dwNumDataBitsToWrite, dwNumDataBytesToWrite: Dword;
  WriteDataBuffer: WriteDataByteBuffer;
  WordValueStr, HexWordValueStr: string;
  dwWordValue: Dword;
  WaitDataWriteComplete: FtcWaitDataWrite;
  HighPinsWriteActiveStates: FtcHigherOutputPins;
begin
  //WriteStartCondition.bClockPinStateBeforeChipSelect := False;
  //WriteStartCondition.bClockPinStateAfterChipSelect := False;
  WriteStartCondition.bClockPinState := False;
  WriteStartCondition.bDataOutPinState := False;
  WriteStartCondition.bChipSelectPinState := False;
  WriteStartCondition.dwChipSelectPin := ADBUS3ChipSelect;

  if (not bErase) then
  begin
    // enable writing
    ftStatus := SPI_EWEN_EWDS_ERAL_93LC56B_Device(@WriteStartCondition, SPI93LC56BEWENCmdIndex, bBufferSPICommands);

    if (ftStatus = FTC_SUCCESS) then
    begin
      dwLocationAddress := 0;

      repeat
        // set up write command and address
        ControlLocAddress1 := $A0;
        ControlLocAddress1 := (ControlLocAddress1 or ((dwLocationAddress div 8) AND $0F));

        // shift left 5 bits ie make bottom 3 bits the 3 MSB's
        ControlLocAddress2 := ((dwLocationAddress AND $07) * 32);

        WriteControlBuffer[0] := ControlLocAddress1;
        WriteControlBuffer[1] := ControlLocAddress2;

        WordValueStr := WordValue;

        if (WordValueStr = '') then
          dwWordValue := dwLocationAddress
        else
        begin
          HexWordValueStr := '$';
          HexWordValueStr := HexWordValueStr + WordValueStr;

          dwWordValue := StrToInt(HexWordValueStr);
        end;

        dwNumDataBitsToWrite := 16;
        dwNumDataBytesToWrite := 2;
        // write data
        WriteDataBuffer[0] := (dwWordValue AND $FF);
        WriteDataBuffer[1] := ((dwWordValue DIV 256) AND $FF);

        WaitDataWriteComplete.bWaitDataWriteComplete := False;
        if bWriteWait then
        begin
          WaitDataWriteComplete.bWaitDataWriteComplete := True;
          WaitDataWriteComplete.dwWaitDataWritePin := ADBUS2DataIn;
          WaitDataWriteComplete.bDataWriteCompleteState := True;
          WaitDataWriteComplete.dwDataWriteTimeoutmSecs := 5000;
        end;

        if (not bBufferSPICommands) then
        begin
          ftStatus := FT2232CSPI.Write(fthandle, @WriteStartCondition, True, False,
                                       11, @WriteControlBuffer, 2, True, dwNumDataBitsToWrite, @WriteDataBuffer,
                                       dwNumDataBytesToWrite, @WaitDataWriteComplete, @HighPinsWriteActiveStates);

          if (ftStatus = FTC_SUCCESS) then
      //      DisplayLines.Add('93LC56B - Write Loc Addr : ' + HexWrdToStr(dwLocationAddress) + ' Data : ' + HexWrdToStr(dwWordValue))
          else
            DisplayFT2232CSPIDllError('Program_93LC56B_Device', 'Write', ftStatus);
        end
        else
        begin
          ftStatus := FT2232CSPI.AddDeviceWriteCmd(fthandle, @WriteStartCondition, True, False,
                                                   11, @WriteControlBuffer, 2, True, dwNumDataBitsToWrite,
                                                   @WriteDataBuffer, dwNumDataBytesToWrite, @HighPinsWriteActiveStates);

          if (ftStatus = FTC_SUCCESS) then
    //        DisplayLines.Add('93LC56B - Added Write Loc Addr Command : ' + HexWrdToStr(dwLocationAddress) + ' Data : ' + HexWrdToStr(dwWordValue))
          else
            DisplayFT2232CSPIDllError('Program_93LC56B_Device', 'Added Word Write Command', ftStatus);
        end;

        Inc(dwLocationAddress)
      until ((dwLocationAddress >= MaxSPI93LC56BChipSizeInWords) or (ftStatus <> FTC_SUCCESS));
    end;

    if (ftStatus = FTC_SUCCESS) then
      // disable writing
      ftStatus := SPI_EWEN_EWDS_ERAL_93LC56B_Device(@WriteStartCondition, SPI93LC56BEWDSCmdIndex, bBufferSPICommands);

    if (ftStatus <> FTC_SUCCESS) then
      DisplayLines.Add('Write - Failed');
  end
  else
  begin
    // enable writing
    ftStatus := SPI_EWEN_EWDS_ERAL_93LC56B_Device(@WriteStartCondition, SPI93LC56BEWENCmdIndex, bBufferSPICommands);

    if (ftStatus = FTC_SUCCESS) then
    begin
      // erase all
      ftStatus := SPI_EWEN_EWDS_ERAL_93LC56B_Device(@WriteStartCondition, SPI93LC56BERALCmdIndex, bBufferSPICommands);

      if (ftStatus = FTC_SUCCESS) then
      begin
        // disable writing
        ftStatus := SPI_EWEN_EWDS_ERAL_93LC56B_Device(@WriteStartCondition, SPI93LC56BEWDSCmdIndex, bBufferSPICommands);

        if (ftStatus = FTC_SUCCESS) then
        begin
          if (not bBufferSPICommands) then
            DisplayLines.Add('Erase - Success')
          else
            DisplayLines.Add('Added Erase Command - Success');
        end;
      end;
    end;

    if (ftStatus <> FTC_SUCCESS) then
    begin
      if (not bBufferSPICommands) then
        DisplayLines.Add('Erase - Failed')
      else
        DisplayLines.Add('Added Erase Command - Failed');
    end
  end;

  Result := ftStatus;
end;

function  Program_MCP42XXX_Device(bErase: Boolean; WordValue: String; bPotentiometer0, bPotentiometer1: Boolean;
                                  bBufferSPICommands: Boolean; var DisplayLines: TStringList): FTC_STATUS;
var
  ftStatus: FTC_STATUS;
  WriteStartCondition: FtcInitCondition;
  CommandByte: Byte;
  WriteControlBuffer: WriteControlByteBuffer;
  WordValueStr, HexWordValueStr: string;
  dwWordValue: Dword;
  dwNumDataBitsToWrite, dwNumDataBytesToWrite: Dword;
  WriteDataBuffer: WriteDataByteBuffer;
  WaitDataWriteComplete: FtcWaitDataWrite;
  HighPinsWriteActiveStates: FtcHigherOutputPins;  
begin
  //WriteStartCondition.bClockPinStateBeforeChipSelect := False;
  //WriteStartCondition.bClockPinStateAfterChipSelect := False;
  WriteStartCondition.bClockPinState := False;
  WriteStartCondition.bDataOutPinState := False;
  WriteStartCondition.bChipSelectPinState := True;
  WriteStartCondition.dwChipSelectPin := ADBUS3ChipSelect;

  if (not bErase) then
  begin
    CommandByte := MCP42XXXChipWriteCmd;

    if bPotentiometer1 then
      CommandByte := (CommandByte or MCP42XXXChipPotentiometer1SelectBit);

    if bPotentiometer0 then
      CommandByte := (CommandByte or MCP42XXXChipPotentiometer0SelectBit);

    WriteControlBuffer[0] := CommandByte;

    WordValueStr := WordValue;

    HexWordValueStr := '$';
    HexWordValueStr := HexWordValueStr + WordValueStr;

    dwWordValue := StrToInt(HexWordValueStr);

    WriteControlBuffer[1] := (dwWordValue AND $FF);

    WaitDataWriteComplete.bWaitDataWriteComplete := False;

    if (not bBufferSPICommands) then
    begin
      ftStatus := FT2232CSPI.Write(fthandle, @WriteStartCondition, True, False,
                                   16, @WriteControlBuffer, 2, False, dwNumDataBitsToWrite, @WriteDataBuffer,
                                   dwNumDataBytesToWrite, @WaitDataWriteComplete, @HighPinsWriteActiveStates);

      if (ftStatus = FTC_SUCCESS) then
 //       DisplayLines.Add('MCP42XXX - Write Data Byte : ' + HexByteToStr(dwWordValue))
      else
        DisplayFT2232CSPIDllError('Program_MCP42XXX_Device', 'Write', ftStatus);
    end
    else
    begin
      ftStatus := FT2232CSPI.AddDeviceWriteCmd(fthandle, @WriteStartCondition, True, False,
                                               16, @WriteControlBuffer, 2, False, dwNumDataBitsToWrite,
                                               @WriteDataBuffer, dwNumDataBytesToWrite, @HighPinsWriteActiveStates);

      if (ftStatus = FTC_SUCCESS) then
  //      DisplayLines.Add('MCP42XXX - Added Write Data Byte Command : ' + HexByteToStr(dwWordValue))
      else
        DisplayFT2232CSPIDllError('Program_MCP42XXX_Device', 'Added Byte Write Command', ftStatus);
    end;

    if (ftStatus <> FTC_SUCCESS) then
    begin
      if (not bBufferSPICommands) then
        DisplayLines.Add('Write - Failed')
      else
        DisplayLines.Add('Added Write Command - Failed');
    end;
  end
  else
  begin
    CommandByte := MCP42XXXChipShutdownCmd;

    if bPotentiometer1 then
      CommandByte := (CommandByte or MCP42XXXChipPotentiometer1SelectBit);

    if bPotentiometer0 then
      CommandByte := (CommandByte or MCP42XXXChipPotentiometer0SelectBit);

    WriteControlBuffer[0] := CommandByte;
    WriteControlBuffer[1] := 0;

    WaitDataWriteComplete.bWaitDataWriteComplete := False;

    if (not bBufferSPICommands) then
    begin
      ftStatus := FT2232CSPI.Write(fthandle, @WriteStartCondition, True, False,
                                   16, @WriteControlBuffer, 2, False, dwNumDataBitsToWrite, @WriteDataBuffer,
                                   dwNumDataBytesToWrite, @WaitDataWriteComplete, @HighPinsWriteActiveStates);

      if (ftStatus = FTC_SUCCESS) then
        DisplayLines.Add('MCP42XXX - Write Shutdown Command')
      else
        DisplayFT2232CSPIDllError('Program_MCP42XXX_Device', 'Write', ftStatus);
    end
    else
    begin
      ftStatus := FT2232CSPI.AddDeviceWriteCmd(fthandle, @WriteStartCondition, True, False,
                                               16, @WriteControlBuffer, 2, False, dwNumDataBitsToWrite,
                                               @WriteDataBuffer, dwNumDataBytesToWrite, @HighPinsWriteActiveStates);

      if (ftStatus = FTC_SUCCESS) then
        DisplayLines.Add('MCP42XXX - Added Write Shutdown Command')
      else
        DisplayFT2232CSPIDllError('Program_MCP42XXX_Device', 'Added Byte Write Command', ftStatus);
    end;    

    if (ftStatus <> FTC_SUCCESS) then
    begin
      if (not bBufferSPICommands) then
        DisplayLines.Add('Shutdown - Failed')
      else
        DisplayLines.Add('Added Shutdown Command - Failed');
    end
  end;

  Result := ftStatus;
end;

function  Write_DS1305_Device(bBufferSPICommands: Boolean; var DisplayLines: TStringList;
                              dwNumControlBitsToWrite, dwNumControlBytesToWrite: Dword;
                              pWriteControlBuffer: PWriteControlByteBuffer; bWriteDataBits: Boolean;
                              dwNumDataBitsToWrite, dwNumDataBytesToWrite: Dword;
                              pWriteDataBuffer: PWriteDataByteBuffer): FTC_STATUS;
var
  ftStatus: FTC_STATUS;
  WriteStartCondition: FtcInitCondition;
  WaitDataWriteComplete: FtcWaitDataWrite;
  HighPinsWriteActiveStates: FtcHigherOutputPins;
  DataByteIndex: Integer;  
begin
  //WriteStartCondition.bClockPinStateBeforeChipSelect := True;
  //WriteStartCondition.bClockPinStateAfterChipSelect := False;
  WriteStartCondition.bClockPinState := False;
  WriteStartCondition.bDataOutPinState := False;
  WriteStartCondition.bChipSelectPinState := False;
  WriteStartCondition.dwChipSelectPin := ADBUS4GPIOL1;

  WaitDataWriteComplete.bWaitDataWriteComplete := False;

  if (not bBufferSPICommands) then
  begin
    ftStatus := FT2232CSPI.Write(fthandle, @WriteStartCondition, False, False,
                                 dwNumControlBitsToWrite, pWriteControlBuffer, dwNumControlBytesToWrite,
                                 bWriteDataBits, dwNumDataBitsToWrite, pWriteDataBuffer,
                                 dwNumDataBytesToWrite, @WaitDataWriteComplete, @HighPinsWriteActiveStates);

    if (ftStatus = FTC_SUCCESS) then
    begin
 //     DisplayLines.Add('DS1305 - Write Address Byte : ' + HexByteToStr(pWriteControlBuffer[0]));

      if (dwNumControlBytesToWrite > 1) then
  //      DisplayLines.Add('DS1305 - Write Data Byte : ' + HexByteToStr(pWriteControlBuffer[1]));

      if bWriteDataBits then
      begin
        for DataByteIndex := 0 to (dwNumDataBytesToWrite - 1) do
   //       DisplayLines.Add('DS1305 - Write Data Byte : ' + HexByteToStr(pWriteDataBuffer[DataByteIndex]));
      end;
    end
    else
      DisplayFT2232CSPIDllError('Write_DS1305_Device', 'Write', ftStatus);
  end
  else
  begin
    ftStatus := FT2232CSPI.AddDeviceWriteCmd(fthandle, @WriteStartCondition, False, False,
                                             16, pWriteControlBuffer, 2, bWriteDataBits, dwNumDataBitsToWrite,
                                             pWriteDataBuffer, dwNumDataBytesToWrite, @HighPinsWriteActiveStates);

    if (ftStatus = FTC_SUCCESS) then
    begin
  //    DisplayLines.Add('DS1305 - Added Write Address Byte Command : ' + HexByteToStr(pWriteControlBuffer[0]));
   //   DisplayLines.Add('DS1305 - Added Write Data Byte Command : ' + HexByteToStr(pWriteControlBuffer[1]));

      if bWriteDataBits then
      begin
        for DataByteIndex := 0 to (dwNumDataBytesToWrite - 1) do
     //     DisplayLines.Add('DS1305 - Added Write Data Byte Command : ' + HexByteToStr(pWriteDataBuffer[DataByteIndex]));
      end;
    end
    else
      DisplayFT2232CSPIDllError('Write_DS1305_Device', 'Added Byte Write Command', ftStatus);
  end;
end;

function  Program_DS1305_Device(bErase: Boolean; bBufferSPICommands: Boolean; var DisplayLines: TStringList): FTC_STATUS;
var
  ftStatus: FTC_STATUS;
  AddressByte, CommandRegisterByte: Byte;
  WriteControlBuffer: WriteControlByteBuffer;
  bWriteDataBits: Boolean;
  dwNumDataBitsToWrite, dwNumDataBytesToWrite: Dword;
  WriteDataBuffer: WriteDataByteBuffer;
  TimeSeconds, TimeMinutes, TimeHours, DayOfWeek, DayOfMonth, MonthOfYear, YearOfCentury: Byte;  
begin
  ftStatus := FTC_SUCCESS;

  if (not bErase) then
  begin
 //   if DateTimeDialog.ShowModal = mrOK then
    begin
      AddressByte := 143; // Control Register address $8F
      CommandRegisterByte := DS1305ChipWriteEnableCmd; // $00 Enable write

      WriteControlBuffer[0] := AddressByte;
      WriteControlBuffer[1] := CommandRegisterByte;

      bWriteDataBits := False;

      ftStatus := Write_DS1305_Device(bBufferSPICommands, DisplayLines, 16, 2,
                                      @WriteControlBuffer, bWriteDataBits, dwNumDataBitsToWrite,
                                      dwNumDataBytesToWrite, @WriteDataBuffer);

      if (ftStatus = FTC_SUCCESS) then
      begin
        AddressByte := 128; //192; // Time seconds Register address $80
        //AddressByte := 134; // Months Register address $86

        WriteControlBuffer[0] := AddressByte;
        //WriteControlBuffer[1] := 8; //153; // Year 99 $99

        bWriteDataBits := True;

  //      TimeSeconds := DateTimeDialog.GetTimeSeconds;
        TimeSeconds := ((TimeSeconds div 10) SHL 4);
   //     TimeSeconds := TimeSeconds + (DateTimeDialog.GetTimeSeconds mod 10);
        WriteDataBuffer[0] := TimeSeconds; //$47;  // Start at 47 seconds, value written to address $80
  //      TimeMinutes := DateTimeDialog.GetTimeMinutes;
        TimeMinutes := ((TimeMinutes div 10) SHL 4);
   //     TimeMinutes := TimeMinutes + (DateTimeDialog.GetTimeMinutes mod 10);
        WriteDataBuffer[1] := TimeMinutes; //$14; // Start at 14 miniutes, value written to address $81
  //      TimeHours := DateTimeDialog.GetTimeHours;
        TimeHours := ((TimeHours div 10) SHL 4);
    //    TimeHours := TimeHours + (DateTimeDialog.GetTimeHours mod 10);
        WriteDataBuffer[2] := TimeHours; //$62; // 24 hour clock, PM, start at 2 hours, value written to address $82
  //      DayOfWeek := DateTimeDialog.GetDayOfWeek;
        WriteDataBuffer[3] := DayOfWeek; //3; // Start at 3rd day of the week, value written to address $83
   //     DayOfMonth := DateTimeDialog.GetDayOfMonth;
        DayOfMonth := ((DayOfMonth div 10) SHL 4);
   //     DayOfMonth := DayOfMonth + (DateTimeDialog.GetDayOfMonth mod 10);
        WriteDataBuffer[4] := DayOfMonth; //$14; // Start at 14 day of the month, value written to address $84
  //      MonthOfYear := DateTimeDialog.GetMonthOfYear;
        MonthOfYear := ((MonthOfYear div 10) SHL 4);
    //    MonthOfYear := MonthOfYear + (DateTimeDialog.GetMonthOfYear mod 10);
        WriteDataBuffer[5] := MonthOfYear; //8; // Start at 8th month, value written to address $85
 //       YearOfCentury := DateTimeDialog.GetYearOfCentury;
        YearOfCentury := ((YearOfCentury div 10) SHL 4);
  //      YearOfCentury := YearOfCentury + (DateTimeDialog.GetYearOfCentury mod 10);
        WriteDataBuffer[6] := YearOfCentury; //$98; // Start at 98th year, value written to address $86

        WriteDataBuffer[7] := 0; // Disable alarm, value written to address $87
        WriteDataBuffer[8] := 0; // Disable alarm, value written to address $88
        WriteDataBuffer[9] := 0; // Disable alarm, value written to address $89
        WriteDataBuffer[10] := 0; // Disable alarm, value written to address $8A
        WriteDataBuffer[11] := 0; // Disable alarm, value written to address $8B
        WriteDataBuffer[12] := 0; // Disable alarm, value written to address $8C
        WriteDataBuffer[13] := 0; // Disable alarm, value written to address $8D
        WriteDataBuffer[14] := 0; // Disable alarm, value written to address $8E
        WriteDataBuffer[15] := DS1305ChipWriteDisableCmd; // Disable write, value written to address $8F

        dwNumDataBitsToWrite := 128; //120;
        dwNumDataBytesToWrite := 16; //15;

        ftStatus := Write_DS1305_Device(bBufferSPICommands, DisplayLines, 8, 1,
                                        @WriteControlBuffer, bWriteDataBits, dwNumDataBitsToWrite,
                                        dwNumDataBytesToWrite, @WriteDataBuffer);
      end;
    end;
  end
  else
  begin
  end;

  Result := ftStatus;
end;

function TimedoutMsecs(StartTime, EndTime: TTimeStamp; TimeoutMsecs: Integer): Boolean;
var
  ElapsedTimeDays, TotalElapsedTimeMsecs: Integer;
begin
  // The Data field indicates the number of calendar days since the start of the calendar (the number of days since 1/1/0001 plus one)
  ElapsedTimeDays := (EndTime.Date - StartTime.Date);

  if (ElapsedTimeDays = 0) then
    // The Time field species the number of milliseconds that have elapsed since midnight
    TotalElapsedTimeMsecs := (EndTime.Time - StartTime.Time)
  else
  begin
    // Convert the number of elapsed days to milliseconds
    TotalElapsedTimeMsecs := (((((ElapsedTimeDays) * 24) * 60) * 60) * 1000);
    TotalElapsedTimeMsecs := ((TotalElapsedTimeMsecs - StartTime.Time) + EndTime.Time);
  end;

  TimedoutMsecs := (TotalElapsedTimeMsecs >= TimeoutMsecs);
end;

function Wait_Until_M95128_Device_Write_Completed: Boolean;
var
  ftStatus: FTC_STATUS;
  bWriteCompleted: Boolean;
  ReadStartCondition: FtcInitCondition;
  ControlByte1: Byte;
  dwNumControlBitsToWrite, dwNumControlBytesToWrite: Dword;
  WriteControlBuffer: WriteControlByteBuffer;
  dwNumDataBitsRead: Dword;
  ReadDataBuffer: ReadDataByteBuffer;
  dwNumDataBytesReturned: Dword;
  WaitDataWriteComplete: FtcWaitDataWrite;
  HighPinsWriteActiveStates: FtcHigherOutputPins;
  ReadStatusRegister: Byte;
  StartTime: TTimeStamp;
  EndTime: TTimeStamp;
  bTimeout: boolean;
begin
  bWriteCompleted := False;
  
  ReadStartCondition.bClockPinState := False;
  ReadStartCondition.bDataOutPinState := False;
  ReadStartCondition.bChipSelectPinState := True;
  ReadStartCondition.dwChipSelectPin := ADBUS5GPIOL2;

  ControlByte1 := $05; // set up read status register command
  dwNumControlBitsToWrite := 8;
  dwNumControlBytesToWrite := 1;

  dwNumDataBitsRead := 8;

  bTimeout := False;

  StartTime := DateTimeToTimeStamp(Now);

  repeat
    WriteControlBuffer[0] := ControlByte1;
    
    ftStatus := FT2232CSPI.Read(fthandle, @ReadStartCondition, True, False, dwNumControlBitsToWrite,
                                @WriteControlBuffer, dwNumControlBytesToWrite, True, True, dwNumDataBitsRead,
                                @ReadDataBuffer, @dwNumDataBytesReturned, @HighPinsWriteActiveStates);

    if (ftStatus = FTC_SUCCESS) then
    begin
      if (dwNumDataBytesReturned = 1) then
      begin
        // Check Write-In-Progress (WIP) bit
        ReadStatusRegister := (ReadDataBuffer[$00] and $01);

        if (ReadStatusRegister = 0) then
          bWriteCompleted := True;

        if (not bWriteCompleted) then
        begin
          sleep(0); // give up timeslice
          
          EndTime := DateTimeToTimeStamp(Now);
          bTimeout := TimedoutMsecs(StartTime, EndTime, 5000);

          if bTimeout then
            DisplayFT2232CSPIDllError('Wait_Until_M95128_Device_Write_Completed', 'Timeout expired waiting for write complete', ftStatus);
        end;
      end
      else
        DisplayFT2232CSPIDllError('Wait_Until_M95128_Device_Write_Completed', 'Incorrect number of data bytes returned', ftStatus);
    end
    else
      DisplayFT2232CSPIDllError('Wait_Until_M95128_Device_Write_Completed', 'Read', ftStatus);
  until (bWriteCompleted or bTimeout or (ftStatus <> FTC_SUCCESS));

  Result := bWriteCompleted;
end;

function SPI_WREN_WRDI_WRSR_M95128_Device(pWriteStartCondition: PFtcInitCondition; dwSPICmdIndex, dwWriteStatusRegister: Dword): FTC_STATUS;
var
  ftStatus: FTC_STATUS;
  ControlByte1, ControlByte2: Dword;
  dwNumControlBitsToWrite, dwNumControlBytesToWrite: Dword;
  WriteControlBuffer: WriteControlByteBuffer;
  WriteDataBuffer: WriteDataByteBuffer;
  WaitDataWriteComplete: FtcWaitDataWrite;
  HighPinsWriteActiveStates: FtcHigherOutputPins;
  bWriteCompleted: Boolean;
begin
  ControlByte2 := $00;

  case dwSPICmdIndex of
    SPIM95128WRENCmdIndex:
    begin
      ControlByte1 := $06; // set up write enable command
      dwNumControlBitsToWrite := 8;
      dwNumControlBytesToWrite := 1;
    end;
    SPIM95128WRDICmdIndex:
    begin
      ControlByte1 := $04; // set up write disable command
      dwNumControlBitsToWrite := 8;
      dwNumControlBytesToWrite := 1;
    end;
    SPIM95128WRSRCmdIndex:
    begin
      ControlByte1 := $01; // set up write status register command
      ControlByte2 := (dwWriteStatusRegister AND $FF);
      dwNumControlBitsToWrite := 16;
      dwNumControlBytesToWrite := 2;
    end;
  end;

  WriteControlBuffer[0] := ControlByte1;
  WriteControlBuffer[1] := ControlByte2;

  WaitDataWriteComplete.bWaitDataWriteComplete := False;

  ftStatus := FT2232CSPI.Write(fthandle, pWriteStartCondition, True, False,
                               dwNumControlBitsToWrite, @WriteControlBuffer, dwNumControlBytesToWrite,
                               False, 0, @WriteDataBuffer, 0,
                               @WaitDataWriteComplete, @HighPinsWriteActiveStates);

  if (ftStatus = FTC_SUCCESS) then
  begin
    // Do not return until write has completed
    bWriteCompleted := Wait_Until_M95128_Device_Write_Completed;

    if (not bWriteCompleted) then
      ftStatus := FTC_FAILED_TO_COMPLETE_COMMAND;
  end
  else
    DisplayFT2232CSPIDllError('SPI_WREN_WRDI_M95128_Device', 'Write', ftStatus);

  Result := ftStatus;
end;

function  Program_M95128_Device(bErase, bPageWrite: Boolean; WordValue: String; var DisplayLines: TStringList): FTC_STATUS;
var
  ftStatus: FTC_STATUS;
  WriteStartCondition: FtcInitCondition;
  WordValueStr, HexWordValueStr: string;
  dwWordValue: Dword;
  dwLocationAddress: Dword;
  dwNumControlBitsToWrite, dwNumControlBytesToWrite: Dword;
  WriteControlBuffer: WriteControlByteBuffer;  
  dwNumDataBitsToWrite, dwNumDataBytesToWrite: Dword;
  WriteDataBuffer: WriteDataByteBuffer;
  WaitDataWriteComplete: FtcWaitDataWrite;
  HighPinsWriteActiveStates: FtcHigherOutputPins;
  bWriteCompleted: Boolean;
  DataByteIndex: Integer;  
begin
  WriteStartCondition.bClockPinState := False;
  WriteStartCondition.bDataOutPinState := False;
  WriteStartCondition.bChipSelectPinState := True;
  WriteStartCondition.dwChipSelectPin := ADBUS5GPIOL2;

  ftStatus := SPI_WREN_WRDI_WRSR_M95128_Device(@WriteStartCondition, SPIM95128WRENCmdIndex, 0);

  if (ftStatus = FTC_SUCCESS) then
  begin
    // Enable writing to the whole memory block 0000h - 3FFFh
    ftStatus := SPI_WREN_WRDI_WRSR_M95128_Device(@WriteStartCondition, SPIM95128WRSRCmdIndex, $00);

    if (ftStatus = FTC_SUCCESS) then
    begin
      dwLocationAddress := 0;
      //dwLocationAddress := 12288; //$3000 //0;

      if (not bErase) then
      begin
        if (WordValue = '') then
          dwWordValue := 0
        else
        begin
          WordValueStr := WordValue;

          HexWordValueStr := '$';
          HexWordValueStr := HexWordValueStr + WordValueStr;

          dwWordValue := StrToInt(HexWordValueStr);
        end;
      end
      else
        dwWordValue := 65535; //$FFFF

      repeat
        WriteControlBuffer[0] := $02; // set up write to memory command
        //WriteControlBuffer[1] := (dwLocationAddress AND $FF);
        //WriteControlBuffer[2] := ((dwLocationAddress DIV 256) AND $FF);
        WriteControlBuffer[1] := ((dwLocationAddress DIV 256) AND $FF);
        WriteControlBuffer[2] := (dwLocationAddress AND $FF);

        dwNumControlBitsToWrite := 24;
        dwNumControlBytesToWrite := 3;

        if (not bPageWrite) then
        begin
          // write data
          WriteDataBuffer[0] := (dwWordValue AND $FF);

          dwNumDataBitsToWrite := 8;
          dwNumDataBytesToWrite := 1;
        end
        else
        begin
          for DataByteIndex := 0 to (64 - 1) do
            WriteDataBuffer[DataByteIndex] := (dwWordValue AND $FF);

          dwNumDataBitsToWrite := (64 * 8);
          dwNumDataBytesToWrite := 64;
        end;

        WaitDataWriteComplete.bWaitDataWriteComplete := False;

        ftStatus := SPI_WREN_WRDI_WRSR_M95128_Device(@WriteStartCondition, SPIM95128WRENCmdIndex, 0);

        if (ftStatus = FTC_SUCCESS) then
          ftStatus := FT2232CSPI.Write(fthandle, @WriteStartCondition, True, False,
                                       dwNumControlBitsToWrite, @WriteControlBuffer, dwNumControlBytesToWrite,
                                       True, dwNumDataBitsToWrite, @WriteDataBuffer, dwNumDataBytesToWrite,
                                       @WaitDataWriteComplete, @HighPinsWriteActiveStates);

        if (ftStatus = FTC_SUCCESS) then
        begin
          // Do not return until write has completed
          bWriteCompleted := Wait_Until_M95128_Device_Write_Completed;

          if bWriteCompleted then
          begin
            //if (ftStatus = FTC_SUCCESS) then
            //  ftStatus := SPI_WREN_WRDI_WRSR_M95128_Device(@WriteStartCondition, SPIM95128WRDICmdIndex, 0);

            if (not bPageWrite) then
            begin
      //        DisplayLines.Add('M95128 - Write Loc Addr : ' + HexWrdToStr(dwLocationAddress) + ' Data : ' + HexByteToStr(WriteDataBuffer[0]));

              dwLocationAddress := dwLocationAddress + 1;
            end
            else
            begin
              for DataByteIndex := 0 to (64 - 1) do
              begin
      //          DisplayLines.Add('M95128 - Write Loc Addr : ' + HexWrdToStr(dwLocationAddress) + ' Data : ' + HexByteToStr(WriteDataBuffer[0]));

                dwLocationAddress := dwLocationAddress + 1;
              end;
            end;
          end
          else
            ftStatus := FTC_FAILED_TO_COMPLETE_COMMAND;
        end
        else
          DisplayFT2232CSPIDllError('Program_M95128_Device', 'Write', ftStatus);

        if ((WordValue = '') and (dwWordValue <> 65535)) then
        begin
          if ((dwWordValue = 0) or ((dwWordValue mod 255) <> 0)) then
            dwWordValue := dwWordValue + 1
          else
            dwWordValue := 0;
        end;
      //until ((dwLocationAddress > 16383) or (ftStatus <> FTC_SUCCESS));
      //until ((dwLocationAddress >= 512) or (ftStatus <> FTC_SUCCESS));
      until ((dwLocationAddress >= SPIM95128MemoryReadWriteInBytes) or (ftStatus <> FTC_SUCCESS));
    end;

    if (ftStatus = FTC_SUCCESS) then
      ftStatus := SPI_WREN_WRDI_WRSR_M95128_Device(@WriteStartCondition, SPIM95128WRDICmdIndex, 0);
  end;

  if (ftStatus <> FTC_SUCCESS) then
  begin
    if (not bErase) then
      DisplayLines.Add('M95128 Write - Failed')
    else
      DisplayLines.Add('M95128 Erase - Failed');
  end;

  Result := ftStatus;
end;

function Wait_Until_M95020_Device_Write_Completed: Boolean;
var
  ftStatus: FTC_STATUS;
  bWriteCompleted: Boolean;
  ReadStartCondition: FtcInitCondition;
  ControlByte1: Byte;
  dwNumControlBitsToWrite, dwNumControlBytesToWrite: Dword;
  WriteControlBuffer: WriteControlByteBuffer;
  dwNumDataBitsRead: Dword;
  ReadDataBuffer: ReadDataByteBuffer;
  dwNumDataBytesReturned: Dword;
  WaitDataWriteComplete: FtcWaitDataWrite;
  HighPinsWriteActiveStates: FtcHigherOutputPins;
  ReadStatusRegister: Byte;
  StartTime: TTimeStamp;
  EndTime: TTimeStamp;
  bTimeout: boolean;
begin
  bWriteCompleted := False;
  
  ReadStartCondition.bClockPinState := False;
  ReadStartCondition.bDataOutPinState := False;
  ReadStartCondition.bChipSelectPinState := True;
  ReadStartCondition.dwChipSelectPin := ADBUS6GPIOL3;

  ControlByte1 := $05; // set up read status register command
  dwNumControlBitsToWrite := 8;
  dwNumControlBytesToWrite := 1;

  dwNumDataBitsRead := 8;

  bTimeout := False;

  StartTime := DateTimeToTimeStamp(Now);

  repeat
    WriteControlBuffer[0] := ControlByte1;
    
    ftStatus := FT2232CSPI.Read(fthandle, @ReadStartCondition, True, False, dwNumControlBitsToWrite,
                                @WriteControlBuffer, dwNumControlBytesToWrite, True, True, dwNumDataBitsRead,
                                @ReadDataBuffer, @dwNumDataBytesReturned, @HighPinsWriteActiveStates);

    if (ftStatus = FTC_SUCCESS) then
    begin
      if (dwNumDataBytesReturned = 1) then
      begin
        // Check Write-In-Progress (WIP) bit
        ReadStatusRegister := (ReadDataBuffer[$00] and $01);

        if (ReadStatusRegister = 0) then
          bWriteCompleted := True;

        if (not bWriteCompleted) then
        begin
          sleep(0); // give up timeslice
          
          EndTime := DateTimeToTimeStamp(Now);
          bTimeout := TimedoutMsecs(StartTime, EndTime, 5000);

          if bTimeout then
            DisplayFT2232CSPIDllError('Wait_Until_M95020_Device_Write_Completed', 'Timeout expired waiting for write complete', ftStatus);
        end;
      end
      else
        DisplayFT2232CSPIDllError('Wait_Until_M95020_Device_Write_Completed', 'Incorrect number of data bytes returned', ftStatus);
    end
    else
      DisplayFT2232CSPIDllError('Wait_Until_M95020_Device_Write_Completed', 'Read', ftStatus);
  until (bWriteCompleted or bTimeout or (ftStatus <> FTC_SUCCESS));

  Result := bWriteCompleted;
end;

function SPI_WREN_WRDI_WRSR_M95020_Device(pWriteStartCondition: PFtcInitCondition; dwSPICmdIndex, dwWriteStatusRegister: Dword): FTC_STATUS;
var
  ftStatus: FTC_STATUS;
  ControlByte1, ControlByte2: Dword;
  dwNumControlBitsToWrite, dwNumControlBytesToWrite: Dword;
  WriteControlBuffer: WriteControlByteBuffer;
  WriteDataBuffer: WriteDataByteBuffer;
  WaitDataWriteComplete: FtcWaitDataWrite;
  HighPinsWriteActiveStates: FtcHigherOutputPins;
  bWriteCompleted: Boolean;
begin
  ControlByte2 := $00;

  case dwSPICmdIndex of
    SPIM95020WRENCmdIndex:
    begin
      ControlByte1 := $06; // set up write enable command
      dwNumControlBitsToWrite := 8;
      dwNumControlBytesToWrite := 1;
    end;
    SPIM95020WRDICmdIndex:
    begin
      ControlByte1 := $04; // set up write disable command
      dwNumControlBitsToWrite := 8;
      dwNumControlBytesToWrite := 1;
    end;
    SPIM95020WRSRCmdIndex:
    begin
      ControlByte1 := $01; // set up write status register command
      ControlByte2 := (dwWriteStatusRegister AND $FF);
      dwNumControlBitsToWrite := 16;
      dwNumControlBytesToWrite := 2;
    end;
  end;

  WriteControlBuffer[0] := ControlByte1;
  WriteControlBuffer[1] := ControlByte2;

  WaitDataWriteComplete.bWaitDataWriteComplete := False;

  ftStatus := FT2232CSPI.Write(fthandle, pWriteStartCondition, True, False,
                               dwNumControlBitsToWrite, @WriteControlBuffer, dwNumControlBytesToWrite,
                               False, 0, @WriteDataBuffer, 0,
                               @WaitDataWriteComplete, @HighPinsWriteActiveStates);

  if (ftStatus = FTC_SUCCESS) then
  begin
    // Do not return until write has completed
    bWriteCompleted := Wait_Until_M95020_Device_Write_Completed;

    if (not bWriteCompleted) then
      ftStatus := FTC_FAILED_TO_COMPLETE_COMMAND;
  end
  else
    DisplayFT2232CSPIDllError('SPI_WREN_WRDI_M95020_Device', 'Write', ftStatus);

  Result := ftStatus;
end;

function  Program_M95020_Device(bErase, bPageWrite: Boolean; WordValue: String; var DisplayLines: TStringList): FTC_STATUS;
var
  ftStatus: FTC_STATUS;
  WriteStartCondition: FtcInitCondition;
  WordValueStr, HexWordValueStr: string;
  dwWordValue: Dword;
  dwLocationAddress: Dword;
  dwNumControlBitsToWrite, dwNumControlBytesToWrite: Dword;
  WriteControlBuffer: WriteControlByteBuffer;  
  dwNumDataBitsToWrite, dwNumDataBytesToWrite: Dword;
  WriteDataBuffer: WriteDataByteBuffer;
  WaitDataWriteComplete: FtcWaitDataWrite;
  HighPinsWriteActiveStates: FtcHigherOutputPins;
  bWriteCompleted: Boolean;
  DataByteIndex: Integer;  
begin
  WriteStartCondition.bClockPinState := False;
  WriteStartCondition.bDataOutPinState := False;
  WriteStartCondition.bChipSelectPinState := True;
  WriteStartCondition.dwChipSelectPin := ADBUS6GPIOL3;

  ftStatus := SPI_WREN_WRDI_WRSR_M95020_Device(@WriteStartCondition, SPIM95020WRENCmdIndex, 0);

  if (ftStatus = FTC_SUCCESS) then
  begin
    // Enable writing to the whole memory block 00h - FFh
    ftStatus := SPI_WREN_WRDI_WRSR_M95020_Device(@WriteStartCondition, SPIM95020WRSRCmdIndex, $00);

    if (ftStatus = FTC_SUCCESS) then
    begin
      dwLocationAddress := 0;

      if (not bErase) then
      begin
        if (WordValue = '') then
          dwWordValue := 0
        else
        begin
          WordValueStr := WordValue;

          HexWordValueStr := '$';
          HexWordValueStr := HexWordValueStr + WordValueStr;

          dwWordValue := StrToInt(HexWordValueStr);
        end;
      end
      else
        dwWordValue := 65535; //$FFFF

      repeat
        WriteControlBuffer[0] := $02; // set up write to memory command
        WriteControlBuffer[1] := (dwLocationAddress AND $FF);

        dwNumControlBitsToWrite := 16;
        dwNumControlBytesToWrite := 2;

        if (not bPageWrite) then
        begin
          // write data
          WriteDataBuffer[0] := (dwWordValue AND $FF);

          dwNumDataBitsToWrite := 8;
          dwNumDataBytesToWrite := 1;
        end
        else
        begin
          for DataByteIndex := 0 to (16 - 1) do
            WriteDataBuffer[DataByteIndex] := (dwWordValue AND $FF);

          dwNumDataBitsToWrite := (16 * 8);
          dwNumDataBytesToWrite := 16;
        end;

        WaitDataWriteComplete.bWaitDataWriteComplete := False;

        ftStatus := SPI_WREN_WRDI_WRSR_M95020_Device(@WriteStartCondition, SPIM95020WRENCmdIndex, 0);

        if (ftStatus = FTC_SUCCESS) then
          ftStatus := FT2232CSPI.Write(fthandle, @WriteStartCondition, True, False,
                                       dwNumControlBitsToWrite, @WriteControlBuffer, dwNumControlBytesToWrite,
                                       True, dwNumDataBitsToWrite, @WriteDataBuffer, dwNumDataBytesToWrite,
                                       @WaitDataWriteComplete, @HighPinsWriteActiveStates);

        if (ftStatus = FTC_SUCCESS) then
        begin
          // Do not return until write has completed
          bWriteCompleted := Wait_Until_M95020_Device_Write_Completed;

          if bWriteCompleted then
          begin
            //if (ftStatus = FTC_SUCCESS) then
            //  ftStatus := SPI_WREN_WRDI_WRSR_M95020_Device(@WriteStartCondition, SPIM95020WRDICmdIndex, 0);

            if (not bPageWrite) then
            begin
   //           DisplayLines.Add('M95020 - Write Loc Addr : ' + HexWrdToStr(dwLocationAddress) + ' Data : ' + HexByteToStr(WriteDataBuffer[0]));

              dwLocationAddress := dwLocationAddress + 1;
            end
            else
            begin
              for DataByteIndex := 0 to (16 - 1) do
              begin
     //           DisplayLines.Add('M95020 - Write Loc Addr : ' + HexWrdToStr(dwLocationAddress) + ' Data : ' + HexByteToStr(WriteDataBuffer[0]));

                dwLocationAddress := dwLocationAddress + 1;
              end;
            end;
          end
          else
            ftStatus := FTC_FAILED_TO_COMPLETE_COMMAND;
        end
        else
          DisplayFT2232CSPIDllError('Program_M95020_Device', 'Write', ftStatus);

        if ((WordValue = '') and (dwWordValue <> 65535)) then
          dwWordValue := dwWordValue + 1;
      until ((dwLocationAddress >= MaxSPIM95020ChipSizeInBytes) or (ftStatus <> FTC_SUCCESS));
    end;

    if (ftStatus = FTC_SUCCESS) then
      ftStatus := SPI_WREN_WRDI_WRSR_M95020_Device(@WriteStartCondition, SPIM95020WRDICmdIndex, 0);
  end;

  if (ftStatus <> FTC_SUCCESS) then
  begin
    if (not bErase) then
      DisplayLines.Add('M95020 Write - Failed')
    else
      DisplayLines.Add('M95020 Erase - Failed');
  end;

  Result := ftStatus;
end;

function  Program_External_Device(DeviceName: String; ExternalDeviceIndex: Integer;
                                  dwClockDivisor: Dword; bErase, bWriteWait, bPageWrite: Boolean;
                                  WordValue: String; bPotentiometer0, bPotentiometer1: Boolean;
                                  bBufferSPICommands: Boolean; var DisplayLines: TStringList): Boolean;
var
  ftStatus: FTC_STATUS;
  dwDeviceIndex, dwDeviceHandleIndex: Dword;
  ChipSelectsDisableStates: FtcChipSelectPins;
  HighInputOutputPins: FtcInputOutputPins;
begin
  if (FT2232CSPIDll = True) then
  begin
    ftHandle := 0;
    for dwDeviceIndex := 0 to 49 do
    begin
      if ((ftHandles[dwDeviceIndex].DeviceName = DeviceName) and (ftHandle = 0)) then
      begin
        ftHandle := ftHandles[dwDeviceIndex].ftHandle;

        dwDeviceHandleIndex := dwDeviceIndex;
      end;
    end;

    if (ftHandle <> 0) then
    begin
      ftStatus := FT2232CSPI.InitDevice(ftHandle, dwClockDivisor);

      if (ftStatus = FTC_SUCCESS) then
      begin
        if (ExternalDeviceIndex = SPI93LC56BChipIndex) then
          ChipSelectsDisableStates.bADBUS3ChipSelectPinState := False
        else
        begin
          ChipSelectsDisableStates.bADBUS3ChipSelectPinState := True; // MCP42XXX
          ChipSelectsDisableStates.bADBUS4GPIOL1PinState := False; // DS1305
          ChipSelectsDisableStates.bADBUS5GPIOL2PinState := True; // M95128
          ChipSelectsDisableStates.bADBUS6GPIOL3PinState := True; // M95020
          ChipSelectsDisableStates.bADBUS7GPIOL4PinState := False; // not used
        end;

        HighInputOutputPins.bPin1InputOutputState := True;
        HighInputOutputPins.bPin1LowHighState := False;
        HighInputOutputPins.bPin2InputOutputState := True;
        HighInputOutputPins.bPin2LowHighState := False;
        HighInputOutputPins.bPin3InputOutputState := True;
        HighInputOutputPins.bPin3LowHighState := False;
        HighInputOutputPins.bPin4InputOutputState := True;
        HighInputOutputPins.bPin4LowHighState := False;

        ftStatus := FT2232CSPI.SetGPIOs(ftHandle, @ChipSelectsDisableStates, @HighInputOutputPins);

        if (ftStatus = FTC_SUCCESS) then
        begin
          case ExternalDeviceIndex of
            SPI93LC56BChipIndex: ftStatus := Program_93LC56B_Device(bErase, bWriteWait, WordValue, bBufferSPICommands, DisplayLines);
            SPIMCP42XXXChipIndex: ftStatus := Program_MCP42XXX_Device(bErase, WordValue, bPotentiometer0, bPotentiometer1, bBufferSPICommands, DisplayLines);
            SPIDS1305ChipIndex: ftStatus := Program_DS1305_Device(bErase, bBufferSPICommands, DisplayLines);
            SPIM95128ChipIndex: ftStatus := Program_M95128_Device(bErase, bPageWrite, WordValue, DisplayLines);
            SPIM95020ChipIndex: ftStatus := Program_M95020_Device(bErase, bPageWrite, WordValue, DisplayLines);
          end;
        end
        else
          DisplayFT2232CSPIDllError('Program_External_Device', 'SetGPIOs', ftStatus);
      end
      else
        DisplayFT2232CSPIDllError('Program_External_Device', 'InitDevice', ftStatus);
    end
    else
      DisplayLines.Add('Selected device has not been opened.');
  end;

  if (ftStatus = FTC_SUCCESS) then
    Result := True
  else
    Result := False;
end;

function Read_93C56_Device(bBufferSPICommands: Boolean; dwDeviceHandleIndex: Dword; var DisplayLines: TStringList): FTC_STATUS;
var
  ftStatus: FTC_STATUS;
  ReadStartCondition: FtcInitCondition;
  dwLocationAddress, dwReadDataBufferIndex: Dword;
  ControlLocAddress1, ControlLocAddress2: Byte;
  WriteControlBuffer: WriteControlByteBuffer;
  dwNumDataBitsRead: Dword;
  ReadDataBuffer: ReadDataByteBuffer;
  dwNumDataBytesReturned: Dword;
  HighPinsWriteActiveStates: FtcHigherOutputPins;
  dwReadWordValue: Dword;
begin
  //ReadStartCondition.bClockPinStateBeforeChipSelect := False;
  //ReadStartCondition.bClockPinStateAfterChipSelect := False;
  ReadStartCondition.bClockPinState := False;
  ReadStartCondition.bDataOutPinState := False;
  ReadStartCondition.bChipSelectPinState := False;
  ReadStartCondition.dwChipSelectPin := ADBUS3ChipSelect;

  dwLocationAddress := 0;

  repeat
    // set up read command and address
    ControlLocAddress1 := $C0;
    ControlLocAddress1 := (ControlLocAddress1 or ((dwLocationAddress div 8) AND $0F));

    // shift left 5 bits ie make bottom 3 bits the 3 MSB's
    ControlLocAddress2 := ((dwLocationAddress AND $07) * 32);

    WriteControlBuffer[0] := ControlLocAddress1;
    WriteControlBuffer[1] := ControlLocAddress2;

    dwNumDataBitsRead := 16;

    if (not bBufferSPICommands) then
    begin
      ftStatus := FT2232CSPI.Read(fthandle, @ReadStartCondition, True, False, 11,
                                  @WriteControlBuffer, 2, True, False, dwNumDataBitsRead,
                                  @ReadDataBuffer, @dwNumDataBytesReturned, @HighPinsWriteActiveStates);

      if (ftStatus = FTC_SUCCESS) then
      begin
        if (dwNumDataBytesReturned = 2) then
        begin
          dwReadWordValue := ((ReadDataBuffer[1] * 256) or ReadDataBuffer[0]);

   //       DisplayLines.Add('93LC56B - Read Loc Addr : ' + HexWrdToStr(dwLocationAddress) + ' Data : ' + HexWrdToStr(dwReadWordValue));
        end
        else
          DisplayFT2232CSPIDllError('Read_93C56_Device', 'Word Read - 2 bytes not returned', ftStatus);
      end
      else
       DisplayFT2232CSPIDllError('Read_93C56_Device', 'Word Read', ftStatus);
    end
    else
    begin
      ftStatus := FT2232CSPI.AddDeviceReadCmd(fthandle, @ReadStartCondition, True, False,
                                              11, @WriteControlBuffer, 2, True, False,
                                              dwNumDataBitsRead, @HighPinsWriteActiveStates);

      if (ftStatus = FTC_SUCCESS) then
      begin
  //      DisplayLines.Add('Added Read Loc Addr Command : ' + HexWrdToStr(dwLocationAddress));

        DeviceBitLengths[dwDeviceHandleIndex].BitLengths[DeviceBitLengths[dwDeviceHandleIndex].iNumBitLengths] := dwNumDataBitsRead;
        Inc(DeviceBitLengths[dwDeviceHandleIndex].iNumBitLengths);
      end
      else
        DisplayFT2232CSPIDllError('Read_93C56_Device', 'Added Word Read Command', ftStatus);
    end;

    Inc(dwLocationAddress);
  until ((dwLocationAddress >= MaxSPI93LC56BChipSizeInWords) or (ftStatus <> FTC_SUCCESS));

  Result := ftStatus;
end;

function  Read_DS1305_Device(bBufferSPICommands: Boolean; dwDeviceHandleIndex: Dword; var DisplayLines: TStringList): FTC_STATUS;
var
  ftStatus: FTC_STATUS;
  AddressByte, CommandRegisterByte: Byte;
  WriteControlBuffer: WriteControlByteBuffer;
  bWriteDataBits: Boolean;
  dwNumDataBitsToWrite, dwNumDataBytesToWrite: Dword;
  WriteDataBuffer: WriteDataByteBuffer;
  ReadStartCondition: FtcInitCondition;
  dwNumDataBitsRead: Dword;  
  ReadDataBuffer: ReadDataByteBuffer;
  dwNumDataBytesReturned: Dword;
  HighPinsWriteActiveStates: FtcHigherOutputPins;
  DataByteIndex: Integer;
  TimeSeconds, TimeMinutes, TimeHours, DayOfWeek, DayOfMonth, MonthOfYear, YearOfCentury: Word;
//  ReadDateTime: TDateTime;
begin
  ftStatus := FTC_SUCCESS;

  AddressByte := 143; // Control Register address $8F
  CommandRegisterByte := DS1305ChipWriteDisableCmd; // $40 Disable write

  WriteControlBuffer[0] := AddressByte;
  WriteControlBuffer[1] := CommandRegisterByte;

  bWriteDataBits := False;

  ftStatus := Write_DS1305_Device(bBufferSPICommands, DisplayLines, 16, 2,
                                  @WriteControlBuffer, bWriteDataBits, dwNumDataBitsToWrite,
                                  dwNumDataBytesToWrite, @WriteDataBuffer);

  if (ftStatus = FTC_SUCCESS) then
  begin
    //ReadStartCondition.bClockPinStateBeforeChipSelect := True;
    //ReadStartCondition.bClockPinStateAfterChipSelect := False;
    ReadStartCondition.bClockPinState := False;
    ReadStartCondition.bDataOutPinState := False;
    ReadStartCondition.bChipSelectPinState := False;
    ReadStartCondition.dwChipSelectPin := ADBUS4GPIOL1;

    // set up read address ie seconds
    AddressByte := $00;

    WriteControlBuffer[0] := AddressByte;

    dwNumDataBitsRead := (16 * 8);

    if (not bBufferSPICommands) then
    begin
      ftStatus := FT2232CSPI.Read(fthandle, @ReadStartCondition, False, False, 8,
                                  @WriteControlBuffer, 1, False, True, dwNumDataBitsRead,
                                  @ReadDataBuffer, @dwNumDataBytesReturned, @HighPinsWriteActiveStates);

      if (ftStatus = FTC_SUCCESS) then
      begin
        if (dwNumDataBytesReturned = 16) then
        begin
{          for DataByteIndex := 0 to (dwNumDataBytesReturned - 1) do
   //         DisplayLines.Add('DS1305 - Read Loc Addr : ' + HexByteToStr(AddressByte) + ' Data : ' + HexByteToStr(ReadDataBuffer[DataByteIndex]));

          TimeSeconds := ReadDataBuffer[$00];
          TimeSeconds := (((TimeSeconds and $F0) SHR 4) * 10);
          TimeSeconds := TimeSeconds + (ReadDataBuffer[$00] and $0F);
          TimeMinutes := ReadDataBuffer[$01];
          TimeMinutes := (((TimeMinutes and $F0) SHR 4) * 10);
          TimeMinutes := TimeMinutes + (ReadDataBuffer[$01] and $0F);
          TimeHours := ReadDataBuffer[$02];
          TimeHours := (((TimeHours and $F0) SHR 4) * 10);
          TimeHours := TimeHours + (ReadDataBuffer[$02] and $0F);
          DayOfWeek := ReadDataBuffer[$03];
          DayOfMonth := ReadDataBuffer[$04];
          DayOfMonth := (((DayOfMonth and $F0) SHR 4) * 10);
          DayOfMonth := DayOfMonth + (ReadDataBuffer[$04] and $0F);
          MonthOfYear := ReadDataBuffer[$05];
          MonthOfYear := (((MonthOfYear and $F0) SHR 4) * 10);
          MonthOfYear := MonthOfYear + (ReadDataBuffer[$05] and $0F);
          YearOfCentury := ReadDataBuffer[$06];
          YearOfCentury := (((YearOfCentury and $F0) SHR 4) * 10);
          YearOfCentury := YearOfCentury + (ReadDataBuffer[$06] and $0F);
          YearOfCentury := YearOfCentury + 2000;

   //       ReadDateTime := EncodeDateTime(YearOfCentury, MonthOfYear, DayOfMonth, TimeHours, TimeMinutes, TimeSeconds, 0);
          DisplayLines.Add(FormatDateTime('dddd, d mmmm, yyyy, " " h:mm:ss am/pm', ReadDateTime));  }
        end
        else
          DisplayFT2232CSPIDllError('Read_DS1305_Device', 'Incorrect number of data bytes returned', ftStatus);
      end
      else
       DisplayFT2232CSPIDllError('Read_DS1305_Device', 'Word Read', ftStatus);
    end
    else
    begin
      ftStatus := FT2232CSPI.AddDeviceReadCmd(fthandle, @ReadStartCondition, False, True,
                                              8, @WriteControlBuffer, 1, False, True,
                                              dwNumDataBitsRead, @HighPinsWriteActiveStates);

      if (ftStatus = FTC_SUCCESS) then
      begin
  //      DisplayLines.Add('Added Read Loc Addr Command : ' + HexByteToStr(AddressByte));

        DeviceBitLengths[dwDeviceHandleIndex].BitLengths[DeviceBitLengths[dwDeviceHandleIndex].iNumBitLengths] := dwNumDataBitsRead;
        Inc(DeviceBitLengths[dwDeviceHandleIndex].iNumBitLengths);
      end
      else
        DisplayFT2232CSPIDllError('Read_DS1305_Device', 'Added Byte Read Command', ftStatus);
    end;
  end;

  Result := ftStatus;
end;

function  Read_M95128_Device(bBlockRead, bBufferSPICommands: Boolean; dwDeviceHandleIndex: Dword; var DisplayLines: TStringList): FTC_STATUS;
var
  ftStatus: FTC_STATUS;
  ReadStartCondition: FtcInitCondition;
  dwLocationAddress: Dword;
  dwNumControlBitsToWrite, dwNumControlBytesToWrite: Dword;
  WriteControlBuffer: WriteControlByteBuffer;  
  dwNumDataBitsRead: Dword;
  ReadDataBuffer: ReadDataByteBuffer;
  dwNumDataBytesReturned: Dword;
  WaitDataWriteComplete: FtcWaitDataWrite;
  HighPinsWriteActiveStates: FtcHigherOutputPins;
  DataByteIndex: Integer;
begin
  ReadStartCondition.bClockPinState := False;
  ReadStartCondition.bDataOutPinState := False;
  ReadStartCondition.bChipSelectPinState := True;
  ReadStartCondition.dwChipSelectPin := ADBUS5GPIOL2;

  dwLocationAddress := 0;
  //dwLocationAddress := 12288; //$3000 //0;

  repeat
    WriteControlBuffer[0] := $03; // set up read from memory command
    //WriteControlBuffer[1] := (dwLocationAddress AND $FF);
    //WriteControlBuffer[2] := ((dwLocationAddress DIV 256) AND $FF);
    WriteControlBuffer[1] := ((dwLocationAddress DIV 256) AND $FF);
    WriteControlBuffer[2] := (dwLocationAddress AND $FF);

    dwNumControlBitsToWrite := 24;
    dwNumControlBytesToWrite := 3;

    if ((dwLocationAddress = 0) or ((dwLocationAddress mod 256) = 0)) then
    begin
    if (not bBlockRead) then
      dwNumDataBitsRead := 8
    else
      dwNumDataBitsRead := (64 * 8);
    end;

    if (not bBufferSPICommands) then
    begin
      ftStatus := FT2232CSPI.Read(fthandle, @ReadStartCondition, True, False, dwNumControlBitsToWrite,
                                  @WriteControlBuffer, dwNumControlBytesToWrite, True, True, dwNumDataBitsRead,
                                  @ReadDataBuffer, @dwNumDataBytesReturned, @HighPinsWriteActiveStates);

      if (ftStatus = FTC_SUCCESS) then
      begin
        if (dwNumDataBytesReturned = (dwNumDataBitsRead div 8)) then
        begin
          if (not bBlockRead) then
          begin
     //       DisplayLines.Add('M95128 - Read Loc Addr : ' + HexWrdToStr(dwLocationAddress) + ' Data : ' + HexByteToStr(ReadDataBuffer[0]));

            dwLocationAddress := dwLocationAddress + 1;
          end
          else
          begin
            for DataByteIndex := 0 to (dwNumDataBytesReturned - 1) do
            begin
     //         DisplayLines.Add('M95128 - Read Loc Addr : ' + HexWrdToStr(dwLocationAddress) + ' Data : ' + HexByteToStr(ReadDataBuffer[DataByteIndex]));

              dwLocationAddress := dwLocationAddress + 1;
            end;
          end;
        end
        else
          DisplayFT2232CSPIDllError('Read_M95128_Device', 'Incorrect number of data bytes returned', ftStatus);
      end
      else
        DisplayFT2232CSPIDllError('Read_M95128_Device', 'Byte Read', ftStatus);
    end
    else
    begin
      ftStatus := FT2232CSPI.AddDeviceReadCmd(fthandle, @ReadStartCondition, True, False,
                                              dwNumControlBitsToWrite, @WriteControlBuffer, dwNumControlBytesToWrite,
                                              True, False, dwNumDataBitsRead, @HighPinsWriteActiveStates);

      if (ftStatus = FTC_SUCCESS) then
      begin
  //      DisplayLines.Add('Added Read Loc Addr Command : ' + HexWrdToStr(dwLocationAddress));

        DeviceBitLengths[dwDeviceHandleIndex].BitLengths[DeviceBitLengths[dwDeviceHandleIndex].iNumBitLengths] := dwNumDataBitsRead;
        Inc(DeviceBitLengths[dwDeviceHandleIndex].iNumBitLengths);

        if (not bBlockRead) then
          dwLocationAddress := dwLocationAddress + 1
        else
          dwLocationAddress := dwLocationAddress + 64;
      end
      else
        DisplayFT2232CSPIDllError('Read_M95128_Device', 'Added Word Read Command', ftStatus);
    end;
  //until ((dwLocationAddress > 16383) or (ftStatus <> FTC_SUCCESS));
  //until ((dwLocationAddress >= 512) or (ftStatus <> FTC_SUCCESS));
  until ((dwLocationAddress >= SPIM95128MemoryReadWriteInBytes) or (ftStatus <> FTC_SUCCESS));

  Result := ftStatus;
end;

function  Read_M95020_Device(bBlockRead, bBufferSPICommands: Boolean; dwDeviceHandleIndex: Dword; var DisplayLines: TStringList): FTC_STATUS;
var
  ftStatus: FTC_STATUS;
  ReadStartCondition: FtcInitCondition;
  dwLocationAddress: Dword;
  dwNumControlBitsToWrite, dwNumControlBytesToWrite: Dword;
  WriteControlBuffer: WriteControlByteBuffer;  
  dwNumDataBitsRead: Dword;
  ReadDataBuffer: ReadDataByteBuffer;
  dwNumDataBytesReturned: Dword;
  WaitDataWriteComplete: FtcWaitDataWrite;
  HighPinsWriteActiveStates: FtcHigherOutputPins;
  DataByteIndex: Integer;
begin
  ReadStartCondition.bClockPinState := False;
  ReadStartCondition.bDataOutPinState := False;
  ReadStartCondition.bChipSelectPinState := True;
  ReadStartCondition.dwChipSelectPin := ADBUS6GPIOL3;

  dwLocationAddress := 0;

  repeat
    WriteControlBuffer[0] := $03; // set up read from memory command
    WriteControlBuffer[1] := (dwLocationAddress AND $FF);

    dwNumControlBitsToWrite := 16;
    dwNumControlBytesToWrite := 2;

    if (not bBlockRead) then
      dwNumDataBitsRead := 8
    else
      dwNumDataBitsRead := (16 * 8);

    if (not bBufferSPICommands) then
    begin
      ftStatus := FT2232CSPI.Read(fthandle, @ReadStartCondition, True, False, dwNumControlBitsToWrite,
                                  @WriteControlBuffer, dwNumControlBytesToWrite, True, True, dwNumDataBitsRead,
                                  @ReadDataBuffer, @dwNumDataBytesReturned, @HighPinsWriteActiveStates);

      if (ftStatus = FTC_SUCCESS) then
      begin
        if (dwNumDataBytesReturned = (dwNumDataBitsRead div 8)) then
        begin
          if (not bBlockRead) then
          begin
    //        DisplayLines.Add('M95020 - Read Loc Addr : ' + HexWrdToStr(dwLocationAddress) + ' Data : ' + HexByteToStr(ReadDataBuffer[0]));

            dwLocationAddress := dwLocationAddress + 1;
          end
          else
          begin
            for DataByteIndex := 0 to (dwNumDataBytesReturned - 1) do
            begin
    //          DisplayLines.Add('M95020 - Read Loc Addr : ' + HexWrdToStr(dwLocationAddress) + ' Data : ' + HexByteToStr(ReadDataBuffer[DataByteIndex]));

              dwLocationAddress := dwLocationAddress + 1;
            end;
          end;
        end
        else
          DisplayFT2232CSPIDllError('Read_M95020_Device', 'Incorrect number of data bytes returned', ftStatus);
      end
      else
        DisplayFT2232CSPIDllError('Read_M95020_Device', 'Byte Read', ftStatus);
    end
    else
    begin
      ftStatus := FT2232CSPI.AddDeviceReadCmd(fthandle, @ReadStartCondition, True, False,
                                              dwNumControlBitsToWrite, @WriteControlBuffer, dwNumControlBytesToWrite,
                                              True, False, dwNumDataBitsRead, @HighPinsWriteActiveStates);

      if (ftStatus = FTC_SUCCESS) then
      begin
   //     DisplayLines.Add('Added Read Loc Addr Command : ' + HexWrdToStr(dwLocationAddress));

        DeviceBitLengths[dwDeviceHandleIndex].BitLengths[DeviceBitLengths[dwDeviceHandleIndex].iNumBitLengths] := dwNumDataBitsRead;
        Inc(DeviceBitLengths[dwDeviceHandleIndex].iNumBitLengths);

        if (not bBlockRead) then
          dwLocationAddress := dwLocationAddress + 1
        else
          dwLocationAddress := dwLocationAddress + 16;
      end
      else
        DisplayFT2232CSPIDllError('Read_M95020_Device', 'Added Word Read Command', ftStatus);
    end;
  until ((dwLocationAddress >= MaxSPIM95020ChipSizeInBytes) or (ftStatus <> FTC_SUCCESS));
  
  Result := ftStatus;
end;

procedure Read_External_Device(DeviceName: String; ExternalDeviceIndex: Integer; dwClockDivisor: Dword;
                               bBlockRead, bBufferSPICommands: Boolean; var DisplayLines: TStringList);
var
  ftStatus: FTC_STATUS;
  dwDeviceIndex, dwDeviceHandleIndex: Dword;
  ChipSelectsDisableStates: FtcChipSelectPins;
  HighInputOutputPins: FtcInputOutputPins;  
begin
  if (FT2232CSPIDll = True) then
  begin
    ftHandle := 0;
    for dwDeviceIndex := 0 to 49 do
    begin
      if ((ftHandles[dwDeviceIndex].DeviceName = DeviceName) and (ftHandle = 0)) then
      begin
        ftHandle := ftHandles[dwDeviceIndex].ftHandle;

        dwDeviceHandleIndex := dwDeviceIndex;
      end;
    end;

    if (ftHandle <> 0) then
    begin
      ftStatus := FT2232CSPI.InitDevice(ftHandle, dwClockDivisor);

      if (ftStatus = FTC_SUCCESS) then
      begin
        if (ExternalDeviceIndex = SPI93LC56BChipIndex) then
          ChipSelectsDisableStates.bADBUS3ChipSelectPinState := False
        else
        begin
          ChipSelectsDisableStates.bADBUS3ChipSelectPinState := True; // MCP42XXX
          ChipSelectsDisableStates.bADBUS4GPIOL1PinState := False; // DS1305
          ChipSelectsDisableStates.bADBUS5GPIOL2PinState := True; // M95128
          ChipSelectsDisableStates.bADBUS6GPIOL3PinState := True; // M95020
          ChipSelectsDisableStates.bADBUS7GPIOL4PinState := False; // not used
        end;

        HighInputOutputPins.bPin1InputOutputState := True;
        HighInputOutputPins.bPin1LowHighState := False;
        HighInputOutputPins.bPin2InputOutputState := True;
        HighInputOutputPins.bPin2LowHighState := False;
        HighInputOutputPins.bPin3InputOutputState := True;
        HighInputOutputPins.bPin3LowHighState := False;
        HighInputOutputPins.bPin4InputOutputState := True;
        HighInputOutputPins.bPin4LowHighState := False;        

        ftStatus := FT2232CSPI.SetGPIOs(ftHandle, @ChipSelectsDisableStates, @HighInputOutputPins);

        if (ftStatus = FTC_SUCCESS) then
        begin
          case ExternalDeviceIndex of
            SPI93LC56BChipIndex: ftStatus := Read_93C56_Device(bBufferSPICommands, dwDeviceHandleIndex, DisplayLines);
            SPIDS1305ChipIndex: ftStatus := Read_DS1305_Device(bBufferSPICommands, dwDeviceHandleIndex, DisplayLines);
            SPIM95128ChipIndex: ftStatus := Read_M95128_Device(bBlockRead, bBufferSPICommands, dwDeviceHandleIndex, DisplayLines);
            SPIM95020ChipIndex: ftStatus := Read_M95020_Device(bBlockRead, bBufferSPICommands, dwDeviceHandleIndex, DisplayLines);
          end;
        end
        else
          DisplayFT2232CSPIDllError('Program_External_Device', 'SetGPIOs', ftStatus);          
      end
      else
        DisplayFT2232CSPIDllError('Read_External_Device', 'InitDevice', ftStatus);
    end
    else
      DisplayLines.Add('Selected device has not been opened.');
  end;
end;

procedure Execute93LC56BDeviceCommandSequence(ExecftHandle: Dword; dwDeviceIndex: Dword; DeviceName: String; var DisplayLines: TStringList);
var
  ftStatus: FTC_STATUS;
  ReadDataBuffer: ReadDataByteBuffer;
  dwNumBytesReturned, dwNumDataBytesToBeReturned: Dword;
  BitLengthsIndex, BitLength, NumDataBytes, DataByteIndex: integer;
  dwLocationAddress, dwReadWordValue: Dword;
begin
  ftStatus := FT2232CSPI.ExecuteDeviceCmdSequence(ExecftHandle, @ReadDataBuffer, @dwNumBytesReturned);

  if (ftStatus = FTC_SUCCESS) then
  begin
    if (dwNumBytesReturned > 0) then
    begin
      dwNumDataBytesToBeReturned := 0;

      for BitLengthsIndex := 0 to (DeviceBitLengths[dwDeviceIndex].iNumBitLengths - 1) do
      begin
        BitLength := DeviceBitLengths[dwDeviceIndex].BitLengths[BitLengthsIndex];

        NumDataBytes := (BitLength div 8);

        if ((BitLength mod 8) > 0) then
          Inc(NumDataBytes);

        dwNumDataBytesToBeReturned := (dwNumDataBytesToBeReturned + NumDataBytes);
      end;

      DataByteIndex := 0;
      dwLocationAddress := 0;
      while (DataByteIndex < MaxSPI93LC56BChipSizeInBytes) do
      begin
        dwReadWordValue := ((ReadDataBuffer[(DataByteIndex + 1)] * 256) or ReadDataBuffer[DataByteIndex]);

  //      DisplayLines.Add(DeviceName + '(93LC56B) - Read Loc Addr : ' + HexWrdToStr(dwLocationAddress) + ' Data : ' + HexWrdToStr(dwReadWordValue));

        DataByteIndex := (DataByteIndex + 2);
        Inc(dwLocationAddress);
      end;

      if (dwNumBytesReturned <> dwNumDataBytesToBeReturned) then
        DisplayLines.Add(DeviceName + '(93LC56B) - ' + 'Incorrect number of data bytes returned.')
    end
    else
      DisplayLines.Add(DeviceName + '(93LC56B) - ' + 'No data returned.')
  end
  else
  begin
    if (ftStatus = FTC_NO_COMMAND_SEQUENCE) then
      DisplayLines.Add(DeviceName + '(93LC56B) - ' + 'No command sequence found.')
    else
      DisplayFT2232CSPIDllError('Execute93LC56BDeviceCommandSequence', 'ExecuteDeviceCmdSequence', ftStatus);
  end;

  DeviceBitLengths[dwDeviceIndex].iNumBitLengths := 0;
end;

procedure ExecuteMCP42XXXDeviceCommandSequence(ExecftHandle: Dword; dwDeviceIndex: Dword; DeviceName: String; var DisplayLines: TStringList);
var
  ftStatus: FTC_STATUS;
  ReadDataBuffer: ReadDataByteBuffer;
  dwNumBytesReturned: Dword;
begin
  ftStatus := FT2232CSPI.ExecuteDeviceCmdSequence(ExecftHandle, @ReadDataBuffer, @dwNumBytesReturned);

  if (ftStatus = FTC_SUCCESS) then
  begin
    if (dwNumBytesReturned > 0) then
      DisplayLines.Add(DeviceName + '(MCP42XXX) - ' + 'Data returned, incorrect.')
    else
      DisplayLines.Add(DeviceName + '(MCP42XXX) - ' + 'No data returned, correct.');
  end
  else
  begin
    if (ftStatus = FTC_NO_COMMAND_SEQUENCE) then
      DisplayLines.Add(DeviceName + '(MCP42XXX) - ' + 'No command sequence found.')
    else
      DisplayFT2232CSPIDllError('ExecuteMCP42XXXDeviceCommandSequence', 'ExecuteDeviceCmdSequence', ftStatus);
  end;

  DeviceBitLengths[dwDeviceIndex].iNumBitLengths := 0;
end;

procedure ExecuteDS1305DeviceCommandSequence(ExecftHandle: Dword; dwDeviceIndex: Dword; DeviceName: String; var DisplayLines: TStringList);
var
  ftStatus: FTC_STATUS;
  ReadDataBuffer: ReadDataByteBuffer;
  dwNumBytesReturned, dwNumDataBytesToBeReturned: Dword;
  BitLengthsIndex, BitLength, NumDataBytes, DataByteIndex: integer;
  dwReadWordValue: Dword;
begin
  ftStatus := FT2232CSPI.ExecuteDeviceCmdSequence(ExecftHandle, @ReadDataBuffer, @dwNumBytesReturned);

  if (ftStatus = FTC_SUCCESS) then
  begin
    if (dwNumBytesReturned > 0) then
    begin
      dwNumDataBytesToBeReturned := 0;

      for BitLengthsIndex := 0 to (DeviceBitLengths[dwDeviceIndex].iNumBitLengths - 1) do
      begin
        BitLength := DeviceBitLengths[dwDeviceIndex].BitLengths[BitLengthsIndex];

        NumDataBytes := (BitLength div 8);

        if ((BitLength mod 8) > 0) then
          Inc(NumDataBytes);

        dwNumDataBytesToBeReturned := (dwNumDataBytesToBeReturned + NumDataBytes);
      end;

      DataByteIndex := 0;
      while (DataByteIndex < MaxSPI93LC56BChipSizeInBytes) do
      begin
//        dwReadWordValue := ((ReadDataBuffer[(DataByteIndex + 1)] * 256) or ReadDataBuffer[DataByteIndex]);

  //      DisplayLines.Add(DeviceName + '(DS1305) - Read Data Value : ' + HexWrdToStr(dwReadWordValue));

        DataByteIndex := (DataByteIndex + 2);
      end;

      if (dwNumBytesReturned <> dwNumDataBytesToBeReturned) then
        DisplayLines.Add(DeviceName + '(DS1305) - ' + 'Incorrect number of data bytes returned.')
    end
    else
      DisplayLines.Add(DeviceName + '(DS1305) - ' + 'No data returned.')
  end
  else
  begin
    if (ftStatus = FTC_NO_COMMAND_SEQUENCE) then
      DisplayLines.Add(DeviceName + '(DS1305) - ' + 'No command sequence found.')
    else
      DisplayFT2232CSPIDllError('ExecuteDS1305DeviceCommandSequence', 'ExecuteDeviceCmdSequence', ftStatus);
  end;

  DeviceBitLengths[dwDeviceIndex].iNumBitLengths := 0;
end;

procedure ExecuteM95128DeviceCommandSequence(ExecftHandle: Dword; dwDeviceIndex: Dword; DeviceName: String; var DisplayLines: TStringList);
var
  ftStatus: FTC_STATUS;
  ReadDataBuffer: ReadDataByteBuffer;
  dwNumBytesReturned, dwNumDataBytesToBeReturned: Dword;
  BitLengthsIndex, BitLength, NumDataBytes, DataByteIndex: integer;
  dwLocationAddress: Dword;
begin
  ftStatus := FT2232CSPI.ExecuteDeviceCmdSequence(ExecftHandle, @ReadDataBuffer, @dwNumBytesReturned);

  if (ftStatus = FTC_SUCCESS) then
  begin
    if (dwNumBytesReturned > 0) then
    begin
      dwNumDataBytesToBeReturned := 0;

      for BitLengthsIndex := 0 to (DeviceBitLengths[dwDeviceIndex].iNumBitLengths - 1) do
      begin
        BitLength := DeviceBitLengths[dwDeviceIndex].BitLengths[BitLengthsIndex];

        NumDataBytes := (BitLength div 8);

        if ((BitLength mod 8) > 0) then
          Inc(NumDataBytes);

        dwNumDataBytesToBeReturned := (dwNumDataBytesToBeReturned + NumDataBytes);
      end;

      DataByteIndex := 0;
      while (DataByteIndex < SPIM95128MemoryReadWriteInBytes) do
      begin
  //      DisplayLines.Add(DeviceName + '(M95128) - Read Loc Addr : ' + HexWrdToStr(dwLocationAddress) + ' Data : ' + HexByteToStr(ReadDataBuffer[DataByteIndex]));

        DataByteIndex := (DataByteIndex + 1);
      end;

      if (dwNumBytesReturned <> dwNumDataBytesToBeReturned) then
        DisplayLines.Add(DeviceName + '(M95128) - ' + 'Incorrect number of data bytes returned.')
    end
    else
      DisplayLines.Add(DeviceName + '(M95128) - ' + 'No data returned.')
  end
  else
  begin
    if (ftStatus = FTC_NO_COMMAND_SEQUENCE) then
      DisplayLines.Add(DeviceName + '(M95128) - ' + 'No command sequence found.')
    else
      DisplayFT2232CSPIDllError('ExecuteM95128DeviceCommandSequence', 'ExecuteDeviceCmdSequence', ftStatus);
  end;

  DeviceBitLengths[dwDeviceIndex].iNumBitLengths := 0;
end;

procedure ExecuteM95020DeviceCommandSequence(ExecftHandle: Dword; dwDeviceIndex: Dword; DeviceName: String; var DisplayLines: TStringList);
var
  ftStatus: FTC_STATUS;
  ReadDataBuffer: ReadDataByteBuffer;
  dwNumBytesReturned, dwNumDataBytesToBeReturned: Dword;
  BitLengthsIndex, BitLength, NumDataBytes, DataByteIndex: integer;
  dwLocationAddress: Dword;
begin
  ftStatus := FT2232CSPI.ExecuteDeviceCmdSequence(ExecftHandle, @ReadDataBuffer, @dwNumBytesReturned);

  if (ftStatus = FTC_SUCCESS) then
  begin
    if (dwNumBytesReturned > 0) then
    begin
      dwNumDataBytesToBeReturned := 0;

      for BitLengthsIndex := 0 to (DeviceBitLengths[dwDeviceIndex].iNumBitLengths - 1) do
      begin
        BitLength := DeviceBitLengths[dwDeviceIndex].BitLengths[BitLengthsIndex];

        NumDataBytes := (BitLength div 8);

        if ((BitLength mod 8) > 0) then
          Inc(NumDataBytes);

        dwNumDataBytesToBeReturned := (dwNumDataBytesToBeReturned + NumDataBytes);
      end;

      DataByteIndex := 0;
      while (DataByteIndex < MaxSPIM95020ChipSizeInBytes) do
      begin
//        DisplayLines.Add(DeviceName + '(M95020) - Read Loc Addr : ' + HexWrdToStr(dwLocationAddress) + ' Data : ' + HexByteToStr(ReadDataBuffer[DataByteIndex]));

        DataByteIndex := (DataByteIndex + 1);
      end;

      if (dwNumBytesReturned <> dwNumDataBytesToBeReturned) then
        DisplayLines.Add(DeviceName + '(M95020) - ' + 'Incorrect number of data bytes returned.')
    end
    else
      DisplayLines.Add(DeviceName + '(M95020) - ' + 'No data returned.')
  end
  else
  begin
    if (ftStatus = FTC_NO_COMMAND_SEQUENCE) then
      DisplayLines.Add(DeviceName + '(M95020) - ' + 'No command sequence found.')
    else
      DisplayFT2232CSPIDllError('ExecuteM95020DeviceCommandSequence', 'ExecuteDeviceCmdSequence', ftStatus);
  end;

  DeviceBitLengths[dwDeviceIndex].iNumBitLengths := 0;
end;

function  ExecuteSPIDeviceCommandSequence(DeviceName: String; ExternalDeviceIndex: Integer; var DisplayLines: TStringList): Boolean;
var
  dwDeviceIndex, dwDeviceHandleIndex: Dword;
  ExecftHandle: Dword;
begin
  if (FT2232CSPIDll = True) then
  begin
    ExecftHandle := 0;
    for dwDeviceHandleIndex := 0 to 49 do
    begin
      if ((ftHandles[dwDeviceHandleIndex].DeviceName = DeviceName) and (ExecftHandle = 0)) then
      begin
        ExecftHandle := ftHandles[dwDeviceHandleIndex].ftHandle;

        dwDeviceIndex := dwDeviceHandleIndex;
      end;
    end;

    if (ExecftHandle <> 0) then
    begin
      case ExternalDeviceIndex of
        SPI93LC56BChipIndex: Execute93LC56BDeviceCommandSequence(ExecftHandle, dwDeviceIndex, DeviceName, DisplayLines);
        SPIMCP42XXXChipIndex: ExecuteMCP42XXXDeviceCommandSequence(ExecftHandle, dwDeviceIndex, DeviceName, DisplayLines);
        SPIDS1305ChipIndex: ExecuteDS1305DeviceCommandSequence(ExecftHandle, dwDeviceIndex, DeviceName, DisplayLines);
        SPIM95128ChipIndex: ExecuteM95128DeviceCommandSequence(ExecftHandle, dwDeviceIndex, DeviceName, DisplayLines);
        SPIM95020ChipIndex: ExecuteM95020DeviceCommandSequence(ExecftHandle, dwDeviceIndex, DeviceName, DisplayLines);
      end;
    end
    else
      DisplayLines.Add('Selected device has not been opened.');
  end;
end;

end.
