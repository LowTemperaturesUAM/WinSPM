Attribute VB_Name = "USB_SPI"
Option Explicit


Public StartCondition As FTC_INIT_CONDITION
'Public ClockOutDataBitsMSBFirst As Boolean, ClockOutDataBitsPosEdge As Boolean
Public ClockOutDataBitsMSBFirst As Long, ClockOutDataBitsPosEdge As Long
Public NumCtrlBytes As Long, NumCtrlBits As Long
Public NumDataBytes As Long, NumDataBits As Long
Public WaitDataWriteComplete As FTC_WAIT_DATA_WRITE
Public HighPinsWriteActiveStates As FTH_HIGHER_OUTPUT_PINS
Public HighPinsReadActiveStates As FTH_HIGHER_OUTPUT_PINS


Public NumControlBitsToWrite As Long, NumControlBytesToWrite As Long
Public NumDataBitsToRead As Long, NumDataBytesReturned As Long
Public ClockInDataBitsMSBFirst As Boolean, ClockInDataBitsPosEdge As Boolean



Public SPI_Hdl As Long     ' Manejador del dispositivo USB abierto y en uso
Public SPI2_Hdl As Long    ' Manejador del dispositivo USB abierto y en uso
Public SPI_Ret As Long     ' Código devuelto por todas las funciones de la librería FTCSPI.DLL
Public FT_Sta As Long      ' Código devuelto por todas las funciones de la librería FTD2XX.DLL


Private Const SPI_CLOCKFREQ = 1000000                             ' Frecuencia del reloj SPI en Hz
Public Const SPI_CLOCK_DIVISOR = (30000000# / SPI_CLOCKFREQ) - 1  ' 29 para 1MHz, 14 para 2 MHz

'Public Type DeviceNameLocIDChannels
'   DeviceName As String
'   LocId As Long
'End Type



Public Enum ErrorReportModes
   ErrorMode_Mute = 0
   ErrorMode_Msg = 1
   ErrorMode_Disable = 9
End Enum



' Variables de módulo: Gestión de errores
Private ErrorReportMode As ErrorReportModes

Private LastError_ErrOrigin As String
Private LastError_Descrip As String
Private LastError_Number As Long

Public Const numADCChannels = 6           ' Numero de canales de entrada que tiene el convertidor ADC


Public Sub DAC_Read_Config()
   
' Condiciones de inicio de señales SPI-Master (CS, CLK, MOSI)
   StartCondition.ChipSelectPin = ADBUS3ChipSelect  ' Este el pin que usaré de CS
   StartCondition.bChipSelectPinState = True        ' ¿Como estará el CS cuando esté desactivado? (True=1, False=0)
   StartCondition.bClockPinState = True           ' ¿Como estará el CLK cuando esté desactivado? (True=1, False=0)
   StartCondition.bDataOutPinState = False          ' ¿Como estará el MOSI cuando esté desactivado? (True=1, False=0)

'xxx StartCondition.bClockPinState = False
 
' Polaridad del reloj y orden de envío y recepción de bits
   ClockOutDataBitsMSBFirst = True    ' Los datos se envian primero el bit MSB, al final el LSB
   ClockOutDataBitsPosEdge = StartCondition.bClockPinState    ' Los datos se envía en el flanco de bajada del reloj
   ClockInDataBitsMSBFirst = True     ' Los datos se reciben primero el bit MSB, al final el LSB
   ClockInDataBitsPosEdge = StartCondition.bClockPinState     ' Los datos se reciben en el flanco de bajada del reloj
   
   
   HighPinsReadActiveStates.bPin1State = False
   HighPinsReadActiveStates.bPin1ActiveState = False
   HighPinsReadActiveStates.bPin2State = False
   HighPinsReadActiveStates.bPin2ActiveState = False
   HighPinsReadActiveStates.bPin3State = False
   HighPinsReadActiveStates.bPin3ActiveState = False
   HighPinsReadActiveStates.bPin4State = False
   HighPinsReadActiveStates.bPin4ActiveState = False
   HighPinsReadActiveStates.bPin5State = False
   HighPinsReadActiveStates.bPin5ActiveState = False
   HighPinsReadActiveStates.bPin6State = False
   HighPinsReadActiveStates.bPin6ActiveState = False
   HighPinsReadActiveStates.bPin7State = False
   HighPinsReadActiveStates.bPin7ActiveState = False
   HighPinsReadActiveStates.bPin8State = False
   HighPinsReadActiveStates.bPin8ActiveState = False
   
   NumControlBytesToWrite = 1
   NumControlBitsToWrite = NumControlBytesToWrite * 8
   NumDataBitsToRead = 16

End Sub


Public Function DAC_Read2(ReadCommand As Byte, ReadData As Long) As Long
   Dim WriteControlBuffer(2) As Byte
   Dim ReadDataBuffer(2) As Byte
   
' Preparación buffers y variables para usar función de librería
   WriteControlBuffer(0) = ReadCommand
   
   SPI_Ret = SPI_ReadHiSpeedDevice(SPI_Hdl, StartCondition, ClockOutDataBitsMSBFirst, ClockOutDataBitsPosEdge, _
               NumControlBitsToWrite, WriteControlBuffer(0), NumControlBytesToWrite, _
               ClockInDataBitsMSBFirst, ClockInDataBitsPosEdge, NumDataBitsToRead, ReadDataBuffer(0), NumDataBytesReturned, HighPinsWriteActiveStates)
               
   If SPI_Ret = FT_OK Then
      ReadData = ReadDataBuffer(0) * 256& + ReadDataBuffer(1)
   End If
   
   If SPI_Ret <> FT_OK Then SPI_ErrorReport "DAC_Read", SPI_Ret
   DAC_Read2 = SPI_Ret
   
End Function




Public Function DAC_Read32(ReadCommand As Byte, ReadData As Long) As Long
   Dim StartCondition As FTC_INIT_CONDITION
   Dim NumControlBitsToWrite As Long, NumControlBytesToWrite As Long
   Dim WriteControlBuffer(2) As Byte
   Dim NumDataBitsToRead As Long, NumDataBytesReturned As Long
   Dim ReadDataBuffer(2) As Byte
   Dim ClockOutDataBitsMSBFirst As Boolean, ClockOutDataBitsPosEdge As Boolean
   Dim ClockInDataBitsMSBFirst As Boolean, ClockInDataBitsPosEdge As Boolean
'   Dim ClockOutDataBitsMSBFirst As Long, ClockOutDataBitsPosEdge As Long
'   Dim ClockInDataBitsMSBFirst As Long, ClockInDataBitsPosEdge As Long
   Dim HighPinsWriteActiveStates As FTH_HIGHER_OUTPUT_PINS
   
' Condiciones de inicio de señales SPI-Master (CS, CLK, MOSI)
   StartCondition.ChipSelectPin = ADBUS3ChipSelect  ' Este el pin que usaré de CS
   StartCondition.bChipSelectPinState = True        ' ¿Como estará el CS cuando esté desactivado? (True=1, False=0)
   StartCondition.bClockPinState = True           ' ¿Como estará el CLK cuando esté desactivado? (True=1, False=0)
   StartCondition.bDataOutPinState = False          ' ¿Como estará el MOSI cuando esté desactivado? (True=1, False=0)

'xxx StartCondition.bClockPinState = False
 
' Polaridad del reloj y orden de envío y recepción de bits
   ClockOutDataBitsMSBFirst = True    ' Los datos se envian primero el bit MSB, al final el LSB
   ClockOutDataBitsPosEdge = StartCondition.bClockPinState    ' Los datos se envía en el flanco de bajada del reloj
   ClockInDataBitsMSBFirst = True     ' Los datos se reciben primero el bit MSB, al final el LSB
   ClockInDataBitsPosEdge = StartCondition.bClockPinState     ' Los datos se reciben en el flanco de bajada del reloj
   
   
   HighPinsWriteActiveStates.bPin1State = False
   HighPinsWriteActiveStates.bPin1ActiveState = False
   HighPinsWriteActiveStates.bPin2State = False
   HighPinsWriteActiveStates.bPin2ActiveState = False
   HighPinsWriteActiveStates.bPin3State = False
   HighPinsWriteActiveStates.bPin3ActiveState = False
   HighPinsWriteActiveStates.bPin4State = False
   HighPinsWriteActiveStates.bPin4ActiveState = False
   HighPinsWriteActiveStates.bPin5State = False
   HighPinsWriteActiveStates.bPin5ActiveState = False
   HighPinsWriteActiveStates.bPin6State = False
   HighPinsWriteActiveStates.bPin6ActiveState = False
   HighPinsWriteActiveStates.bPin7State = False
   HighPinsWriteActiveStates.bPin7ActiveState = False
   HighPinsWriteActiveStates.bPin8State = False
   HighPinsWriteActiveStates.bPin8ActiveState = False
   
' Preparación buffers y variables para usar función de librería
   WriteControlBuffer(0) = ReadCommand
   NumControlBytesToWrite = 1
   NumControlBitsToWrite = NumControlBytesToWrite * 8
   NumDataBitsToRead = 16
   
   SPI_Ret = SPI_ReadHiSpeedDevice(SPI_Hdl, StartCondition, ClockOutDataBitsMSBFirst, ClockOutDataBitsPosEdge, _
               NumControlBitsToWrite, WriteControlBuffer(0), NumControlBytesToWrite, _
               ClockInDataBitsMSBFirst, ClockInDataBitsPosEdge, NumDataBitsToRead, ReadDataBuffer(0), NumDataBytesReturned, HighPinsWriteActiveStates)
               
   If SPI_Ret = FT_OK Then
      'NumDataBytesReturned
'      ReadData = ReadDataBuffer(0) * 65536# + ReadDataBuffer(1) * 256# + ReadDataBuffer(2)
      ReadData = ReadDataBuffer(0) * 256& + ReadDataBuffer(1)
   End If
   
   If SPI_Ret <> FT_OK Then SPI_ErrorReport "DAC_Read", SPI_Ret
   DAC_Read32 = SPI_Ret
   
End Function










Public Function DAC_Read(ReadCommand As Long, ReadData As Long) As Long
   Dim StartCondition As FTC_INIT_CONDITION
   Dim NumControlBitsToWrite As Long, NumControlBytesToWrite As Long
   Dim WriteControlBuffer(2) As Byte
   Dim NumDataBitsToRead As Long, NumDataBytesReturned As Long
   Dim ReadDataBuffer(2) As Byte
   Dim ClockOutDataBitsMSBFirst As Boolean, ClockOutDataBitsPosEdge As Boolean
   Dim ClockInDataBitsMSBFirst As Boolean, ClockInDataBitsPosEdge As Boolean
'   Dim ClockOutDataBitsMSBFirst As Long, ClockOutDataBitsPosEdge As Long
'   Dim ClockInDataBitsMSBFirst As Long, ClockInDataBitsPosEdge As Long
   Dim HighPinsWriteActiveStates As FTH_HIGHER_OUTPUT_PINS
   
' Condiciones de inicio de señales SPI-Master (CS, CLK, MOSI)
   StartCondition.ChipSelectPin = ADBUS3ChipSelect  ' Este el pin que usaré de CS
   StartCondition.bChipSelectPinState = True        ' ¿Como estará el CS cuando esté desactivado? (True=1, False=0)
   StartCondition.bClockPinState = True           ' ¿Como estará el CLK cuando esté desactivado? (True=1, False=0)
   StartCondition.bDataOutPinState = False          ' ¿Como estará el MOSI cuando esté desactivado? (True=1, False=0)

' Polaridad del reloj y orden de envío y recepción de bits
   ClockOutDataBitsMSBFirst = True    ' Los datos se envian primero el bit MSB, al final el LSB
   ClockOutDataBitsPosEdge = StartCondition.bClockPinState    ' Los datos se envía en el flanco de bajada del reloj
   ClockInDataBitsMSBFirst = True     ' Los datos se reciben primero el bit MSB, al final el LSB
   ClockInDataBitsPosEdge = StartCondition.bClockPinState     ' Los datos se reciben en el flanco de bajada del reloj
   
   
   HighPinsWriteActiveStates.bPin1State = False
   HighPinsWriteActiveStates.bPin1ActiveState = False
   HighPinsWriteActiveStates.bPin2State = False
   HighPinsWriteActiveStates.bPin2ActiveState = False
   HighPinsWriteActiveStates.bPin3State = False
   HighPinsWriteActiveStates.bPin3ActiveState = False
   HighPinsWriteActiveStates.bPin4State = False
   HighPinsWriteActiveStates.bPin4ActiveState = False
   HighPinsWriteActiveStates.bPin5State = False
   HighPinsWriteActiveStates.bPin5ActiveState = False
   HighPinsWriteActiveStates.bPin6State = False
   HighPinsWriteActiveStates.bPin6ActiveState = False
   HighPinsWriteActiveStates.bPin7State = False
   HighPinsWriteActiveStates.bPin7ActiveState = False
   HighPinsWriteActiveStates.bPin8State = False
   HighPinsWriteActiveStates.bPin8ActiveState = False
   
' Preparación buffers y variables para usar función de librería
   WriteControlBuffer(2) = ReadCommand And &HFF
   WriteControlBuffer(1) = (ReadCommand \ 256) And &HFF
   WriteControlBuffer(0) = (ReadCommand \ 65536#) And &HFF
   NumControlBytesToWrite = 3
   NumControlBitsToWrite = NumControlBytesToWrite * 8
   NumDataBitsToRead = 24
   
   SPI_Ret = SPI_ReadHiSpeedDevice(SPI_Hdl, StartCondition, ClockOutDataBitsMSBFirst, ClockOutDataBitsPosEdge, _
               NumControlBitsToWrite, WriteControlBuffer(0), NumControlBytesToWrite, _
               ClockInDataBitsMSBFirst, ClockInDataBitsPosEdge, NumDataBitsToRead, ReadDataBuffer(0), NumDataBytesReturned, HighPinsWriteActiveStates)
               
   If SPI_Ret = FT_OK Then
      'NumDataBytesReturned
      ReadData = ReadDataBuffer(0) * 65536 + ReadDataBuffer(1) * 256& + ReadDataBuffer(2)
   End If
   
   If SPI_Ret <> FT_OK Then SPI_ErrorReport "DAC_Read", SPI_Ret
   DAC_Read = SPI_Ret
   
End Function


Public Function USBSPI_Write(ControlByte As Byte, DataWord As Integer) As Long
   Dim StartCondition As FTC_INIT_CONDITION
   Dim ClockOutDataBitsMSBFirst As Boolean, ClockOutDataBitsPosEdge As Boolean
'   Dim ClockOutDataBitsMSBFirst As Long, ClockOutDataBitsPosEdge As Long
   Dim NumCtrlBytes As Long, NumCtrlBits As Long
   Dim NumDataBytes As Long, NumDataBits As Long
   Dim DataBuffer(1) As Byte
   Dim ControlBuffer(0) As Byte
   Dim WaitDataWriteComplete As FTC_WAIT_DATA_WRITE
   Dim HighPinsWriteActiveStates As FTH_HIGHER_OUTPUT_PINS
   
   
' Condiciones de inicio de señales SPI-Master (CS, CLK, MOSI)
   StartCondition.ChipSelectPin = ADBUS3ChipSelect  ' Este el pin que usaré de CS
   StartCondition.bChipSelectPinState = True        ' ¿Como estará el CS cuando esté desactivado? (True=1, False=0)
   StartCondition.bClockPinState = True            ' ¿Como estará el CLK cuando esté desactivado? (True=1, False=0)
   StartCondition.bDataOutPinState = False          ' ¿Como estará el MOSI cuando esté desactivado? (True=1, False=0)
   
'xxx    StartCondition.bClockPinState = False
   
' Polaridad del reloj y orden de envío de bits
   ClockOutDataBitsMSBFirst = True    ' Los datos se envian primero el bit MSB, al final el LSB
   ClockOutDataBitsPosEdge = StartCondition.bClockPinState   ' Los datos se envían en el flanco de bajada del reloj
   
' Condiciones para que la escritura se dé por completada
   WaitDataWriteComplete.bWaitDataWriteComplete = False  ' No esperes nada, envía y regresa
   WaitDataWriteComplete.WaitDataWritePin = ADBUS2DataIn
   WaitDataWriteComplete.bDataWriteCompleteState = True
   WaitDataWriteComplete.DataWriteTimeoutmSecs = 10     ' Si se activa la espera, aguanta hasta 10mseg como máximo
   
   HighPinsWriteActiveStates.bPin1State = False
   HighPinsWriteActiveStates.bPin1ActiveState = False
   HighPinsWriteActiveStates.bPin2State = False
   HighPinsWriteActiveStates.bPin2ActiveState = False
   HighPinsWriteActiveStates.bPin3State = False
   HighPinsWriteActiveStates.bPin3ActiveState = False
   HighPinsWriteActiveStates.bPin4State = False
   HighPinsWriteActiveStates.bPin4ActiveState = False
   HighPinsWriteActiveStates.bPin5State = False
   HighPinsWriteActiveStates.bPin5ActiveState = False
   HighPinsWriteActiveStates.bPin6State = False
   HighPinsWriteActiveStates.bPin6ActiveState = False
   HighPinsWriteActiveStates.bPin7State = False
   HighPinsWriteActiveStates.bPin7ActiveState = False
   HighPinsWriteActiveStates.bPin8State = False
   HighPinsWriteActiveStates.bPin8ActiveState = False
   
' Preparación buffers y variables para usar función de librería
   ControlBuffer(0) = ControlByte
   NumCtrlBytes = 1
   NumCtrlBits = NumCtrlBytes * 8
         
   DataBuffer(1) = (DataWord And &HFF)             ' Byte Bajo
   DataBuffer(0) = ((DataWord \ 256) And &HFF)     ' Byte Alto
   NumDataBytes = 2
   NumDataBits = NumDataBytes * 8
   
'   SPI_Ret = SPI_WriteHiSpeedDevice(SPI_Hdl, StartCondition, True, False, NumCtrlBits, ControlBuffer(0), NumCtrlBytes, True, NumDataBits, DataBuffer(0), NumDataBytes, WaitDataWriteComplete, HighPinsWriteActiveStates)
   SPI_Ret = SPI_WriteHiSpeedDevice(SPI_Hdl, StartCondition, ClockOutDataBitsMSBFirst, ClockOutDataBitsPosEdge, _
               NumCtrlBits, ControlBuffer(0), NumCtrlBytes, True, NumDataBits, DataBuffer(0), NumDataBytes, WaitDataWriteComplete, _
               HighPinsWriteActiveStates)

   If frmSPITest.chkTestADC.Value = vbChecked Then    ' Hay que hacer test también del ADC??
      SPI_Ret = SPI_WriteHiSpeedDevice(SPI2_Hdl, StartCondition, ClockOutDataBitsMSBFirst, ClockOutDataBitsPosEdge, _
                  NumCtrlBits, ControlBuffer(0), NumCtrlBytes, True, NumDataBits, DataBuffer(0), NumDataBytes, WaitDataWriteComplete, _
                  HighPinsWriteActiveStates)
   End If

   If SPI_Ret <> FT_OK Then SPI_ErrorReport "USBSPI_Write", SPI_Ret
   USBSPI_Write = SPI_Ret
   
End Function


Public Function USBSPI_GetDeviceInfo(DevIndex As Long, DevName As String, LocId As Long, DevChannel As String, DevType As Long) As Long
   On Error Resume Next
   
   ' Preparación de buffers de datos usados por librería
   DevName = String(MAX_NUM_DEVICE_NAME_CHARS, Chr(0))
   DevChannel = String(MAX_NUM_CHANNEL_CHARS, Chr(0))
   
   SPI_Ret = SPI_GetHiSpeedDeviceNameLocIDChannel(DevIndex, DevName, MAX_NUM_DEVICE_NAME_CHARS, LocId, DevChannel, MAX_NUM_CHANNEL_CHARS, DevType)
   If (SPI_Ret = FT_OK) Then
      DevName = DLL2VBString(DevName)
      DevChannel = DLL2VBString(DevChannel)
   End If
   
   If SPI_Ret <> FT_OK Then SPI_ErrorReport " USBSPI_GetDeviceInfo", SPI_Ret
   SPI_Ret = USBSPI_GetDeviceInfo
   
End Function



Public Function DLL2VBString(ByRef DLLString As String) As String
    Dim VBString As String
    Dim DllCharCntr As Long
    Dim VBCharCntr As Long
    Dim DLLStrCharArray() As Byte
    Dim VBStrCharArray() As Byte
        
    DllCharCntr = 0

    DLLStrCharArray = StrConv(DLLString, vbFromUnicode)   ' Convert string.

    While (DLLStrCharArray(DllCharCntr) <> 0)
        DllCharCntr = DllCharCntr + 1
    Wend
        
    ReDim VBStrCharArray(0 To (DllCharCntr - 1)) As Byte
    For VBCharCntr = 0 To (DllCharCntr - 1)
        VBStrCharArray(VBCharCntr) = DLLStrCharArray(VBCharCntr)
    Next

    DLL2VBString = StrConv(VBStrCharArray, vbUnicode)
End Function



Public Function SPI_GetNumChannels() As Long
'''' get the number of connected devices
'''   Dim Device_Count As Long
'''
'''    FT_Status = FT_ListDevices(Device_Count, 0, FT_LIST_NUMBER_ONLY)
'''    If FT_Status = FT_OK Then
'''        GetFTDeviceCount = FT_Device_Count          ' return the number of devices
'''    Else
'''        FT_Error_Report "GetFTDeviceCount", FT_Result ' show error message
'''        GetFTDeviceCount = 0                        ' return 0 devices
'''    End If
'''
'''
'''    ' see if anything connected
'''    X = GetFTDeviceCount
'''    If X = 0 Then
'''        Form1.shpOK.BackColor = Yellow
'''        Form1.lblStatus.Caption = "No FTDI devices found. Please connect the meter and re-try"
'''        Exit Sub
'''    End If
'''
'''    ' get the descriptions and look for DLP module channel A
'''    For I = 0 To FT_Device_Count - 1
'''        DeviceDescription = GetFTDeviceDescription(I)
'''        If FT_Result = FT_OK Then
'''            If DeviceDescription = OurDevice Then
'''                FoundDevice = True
'''                Exit For
'''            End If
'''        End If
'''    Next
'''
'''End Function
'''
'''Public Function SPI_Close() As Long
'''   FT_Status = FT_Close(SPI_HANDLE)
'''   If FT_Status <> FT_OK Then SPI_ErrorReport "FT_Close", FT_Status
'''   SPI_Close = FT_Status
End Function











Public Function SPI_ErrorReport_Mode(ErrorMode As ErrorReportModes)
   ErrorReportMode = ErrorMode
   
   If ErrorReportMode = ErrorMode_Disable Then
      LastError_Descrip = ""
      LastError_Number = 0
      LastError_ErrOrigin = ""
   End If
End Function

Public Function SPI_GetLastError(ErrDescription As String) As Long
   ErrDescription = LastError_Descrip
   SPI_GetLastError = LastError_Number
End Function

Public Sub SPI_ErrorReport(ErrOrigin As String, ErrNumber As Long)
   Dim Str As String
   
   If ErrorReportMode = ErrorMode_Disable Then Exit Sub
 
    Select Case ErrNumber
        Case FT_INVALID_HANDLE
            Str = ErrOrigin & " - Invalid Handle"
        Case FT_DEVICE_NOT_FOUND
            Str = ErrOrigin & " - Device Not Found"
        Case FT_DEVICE_NOT_OPENED
            Str = ErrOrigin & " - Device Not Opened"
        Case FT_IO_ERROR
            Str = ErrOrigin & " - General IO Error"
        Case FT_INSUFFICIENT_RESOURCES
            Str = ErrOrigin & " - Insufficient Resources"
        Case FT_INVALID_PARAMETER
            Str = ErrOrigin & " - Invalid Parameter"
        Case FT_INVALID_BAUD_RATE
            Str = ErrOrigin & " - Invalid Baud Rate"
        Case FT_DEVICE_NOT_OPENED_FOR_ERASE
            Str = ErrOrigin & " - Device not opened for Erase"
        Case FT_DEVICE_NOT_OPENED_FOR_WRITE
            Str = ErrOrigin & " - Device not opened for Write"
        Case FT_FAILED_TO_WRITE_DEVICE
            Str = ErrOrigin & " - Failed to write Device"
        Case FT_EEPROM_READ_FAILED
            Str = ErrOrigin & " - EEPROM read failed"
        Case FT_EEPROM_WRITE_FAILED
            Str = ErrOrigin & " - EEPROM write failed"
        Case FT_EEPROM_ERASE_FAILED
            Str = ErrOrigin & " - EEPROM erase failed"
        Case FT_EEPROM_NOT_PRESENT
            Str = ErrOrigin & " - EEPROM not present"
        Case FT_EEPROM_NOT_PROGRAMMED
            Str = ErrOrigin & " - EEPROM not programmed"
        Case FT_INVALID_ARGS
            Str = ErrOrigin & " - Invalid Arguments"
        Case FT_NOT_SUPPORTED
            Str = ErrOrigin & " - not supported"
        Case FT_OTHER_ERROR
            Str = ErrOrigin & " - other error"
      Case FTC_INVALID_NUMBER_CONTROL_BYTES
         Str = "FTC_INVALID_NUMBER_CONTROL_BYTES"
      Case FTC_INVALID_NUMBER_READ_DATA_BITS
         Str = "FTC_INVALID_NUMBER_READ_DATA_BITS"
      Case FTC_DEVICE_IN_USE
         Str = "FTC_DEVICE_IN_USE"
      Case FTC_DEVICE_IN_USE
         Str = "FTC_DEVICE_IN_USE"
      Case FTC_INVALID_INIT_CLOCK_PIN_STATE
         Str = "INVALID_INIT_CLOCK_PIN_STATE"
      Case Else
            Str = ErrOrigin & " - Cód. Error " & CStr(ErrNumber)
   End Select
    
    LastError_Descrip = Str
    LastError_ErrOrigin = ErrOrigin
    LastError_Number = ErrNumber
        
   If ErrorReportMode = ErrorMode_Msg Then
      MsgBox "Se ha producido el error " & CStr(ErrNumber) & " al ejecutar " & ErrOrigin & ":" & vbCrLf & _
      LastError_Descrip, vbOKOnly + vbExclamation, "Error de comunicación SPI"
   End If
    
End Sub








Public Sub DAC_Write_Config()

' Condiciones de inicio de señales SPI-Master (CS, CLK, MOSI)
   StartCondition.ChipSelectPin = ADBUS3ChipSelect  ' Este el pin que usaré de CS
   StartCondition.bChipSelectPinState = True        ' ¿Como estará el CS cuando esté desactivado? (True=1, False=0)
   StartCondition.bClockPinState = True            ' ¿Como estará el CLK cuando esté desactivado? (True=1, False=0)
   StartCondition.bDataOutPinState = False          ' ¿Como estará el MOSI cuando esté desactivado? (True=1, False=0)

' Polaridad del reloj y orden de envío de bits
   ClockOutDataBitsMSBFirst = True    ' Los datos se envian primero el bit MSB, al final el LSB
   ClockOutDataBitsPosEdge = StartCondition.bClockPinState   ' Los datos se envían en el flanco de bajada del reloj

' Condiciones para que la escritura se dé por completada
   WaitDataWriteComplete.bWaitDataWriteComplete = False  ' No esperes nada, envía y regresa
   WaitDataWriteComplete.WaitDataWritePin = ADBUS2DataIn
   WaitDataWriteComplete.bDataWriteCompleteState = True
   WaitDataWriteComplete.DataWriteTimeoutmSecs = 100     ' Si se activa la espera, aguanta hasta 100mseg como máximo
   
   HighPinsWriteActiveStates.bPin1State = False
   HighPinsWriteActiveStates.bPin1ActiveState = False
   HighPinsWriteActiveStates.bPin2State = False
   HighPinsWriteActiveStates.bPin2ActiveState = False
   HighPinsWriteActiveStates.bPin3State = False
   HighPinsWriteActiveStates.bPin3ActiveState = False
   HighPinsWriteActiveStates.bPin4State = False
   HighPinsWriteActiveStates.bPin4ActiveState = False
   HighPinsWriteActiveStates.bPin5State = False
   HighPinsWriteActiveStates.bPin5ActiveState = False
   HighPinsWriteActiveStates.bPin6State = False
   HighPinsWriteActiveStates.bPin6ActiveState = False
   HighPinsWriteActiveStates.bPin7State = False
   HighPinsWriteActiveStates.bPin7ActiveState = False
   HighPinsWriteActiveStates.bPin8State = False
   HighPinsWriteActiveStates.bPin8ActiveState = False

   NumCtrlBytes = 1
   NumCtrlBits = NumCtrlBytes * 8

   NumDataBytes = 2
   NumDataBits = NumDataBytes * 8

End Sub


Public Function DAC_Write(ControlByte As Byte, DataWord As Integer) As Long
   Dim DataBuffer(1) As Byte
   Dim ControlBuffer(0) As Byte
   
' Preparación buffers y variables para usar función de librería
   ControlBuffer(0) = ControlByte
         
   DataBuffer(1) = (DataWord And &HFF)             ' Byte Bajo
   DataBuffer(0) = ((DataWord \ 256) And &HFF)     ' Byte Alto
   
   SPI_Ret = SPI_WriteHiSpeedDevice(SPI_Hdl, StartCondition, ClockOutDataBitsMSBFirst, ClockOutDataBitsPosEdge, _
               NumCtrlBits, ControlBuffer(0), NumCtrlBytes, True, NumDataBits, DataBuffer(0), NumDataBytes, WaitDataWriteComplete, _
               HighPinsWriteActiveStates)

   If SPI_Ret <> FT_OK Then SPI_ErrorReport "DAC_Write", SPI_Ret
   DAC_Write = SPI_Ret
   
End Function






Public Function Get_USB_Device_QueueStatus(ReceivesBytes As Long) As Long
' return the number of bytes waiting to be read

   FT_Sta = FT_GetQueueStatus(SPI_Hdl, ReceivesBytes)
   If FT_Sta <> FT_OK Then
      SPI_ErrorReport "FT_GetQueueStatus", FT_Sta
   End If
   Get_USB_Device_QueueStatus = FT_Sta

End Function


Public Function DAC_ReadCmd(ReadCommand As Byte, ReadData As Long) As Long
   Dim FT_Out_Buffer As String
   Dim FT_In_Buffer As String
   Dim FT_Q_Bytes As Long
   Dim BytesReturned As Long
   Dim BytesWritten As Long
   Dim ReadDataBuffer(2) As Byte
   Dim Write_Count As Long
   
   
   FT_Out_Buffer = Chr(&H80) & Chr(&HF7) & Chr(&HB)                  ' CS=0, resto a 1, CS=output, DI=input, DO=output, SK=output
   FT_Out_Buffer = FT_Out_Buffer & Chr(&H10) & Chr(&H2) & Chr(&H0)   ' Escribir 3 bytes en flanco de bajada de reloj
   FT_Out_Buffer = FT_Out_Buffer & Chr(ReadCommand) & Chr(&H0) & Chr(&H0)   ' Comando a escribir el resto 0,0
   FT_Out_Buffer = FT_Out_Buffer & Chr(&H87)                         ' Ejecutar los comandos en cola.
   FT_Out_Buffer = FT_Out_Buffer & Chr(&H80) & Chr(&HFF) & Chr(&HB)  ' Set CS=1, DO=1 para que al leer D=1->RD=1
   
   
   FT_Out_Buffer = FT_Out_Buffer & Chr(&H80) & Chr(&HF7) & Chr(&HB)  ' CS=0, resto a 1, CS=output, DI=input, DO=output, SK=output
   FT_Out_Buffer = FT_Out_Buffer & Chr(&H20) & Chr(&H2) & Chr(&H0)   ' Leer 3 bytes en flanco de bajada de reloj
   FT_Out_Buffer = FT_Out_Buffer & Chr(&H87)                         ' Ejecutar los comandos en cola.
   FT_Out_Buffer = FT_Out_Buffer & Chr(&H80) & Chr(&HFD) & Chr(&HB)  ' Set CS=1, DO=1 para que al leer D=1->RD=1
   
   Write_Count = Len(FT_Out_Buffer)
      
   FT_Sta = FT_Write(SPI_Hdl, FT_Out_Buffer, Write_Count, BytesWritten)
   If FT_Sta <> FT_OK Then SPI_ErrorReport "FT_Write", FT_Sta
   
   ' Espera a que se lean lo datos
   Do
      FT_Sta = Get_USB_Device_QueueStatus(FT_Q_Bytes)
   Loop Until (FT_Q_Bytes = 3) Or (FT_Sta <> FT_OK)

   If FT_Sta <> FT_OK Then
      SPI_ErrorReport "Get_USB_Device_QueueStatus", FT_Sta
      Exit Function
   End If
   
   'If Read_Count = 1 Then Read_Result = Read_Count
   FT_In_Buffer = Space(256) 'FT_Q_Bytes)
   FT_Sta = FT_Read(SPI_Hdl, FT_In_Buffer, FT_Q_Bytes, BytesReturned)
   If FT_Sta = FT_OK Then
      ReadDataBuffer(0) = CByte(Asc(Mid(FT_In_Buffer, 1, 1)))
      ReadDataBuffer(1) = CByte(Asc(Mid(FT_In_Buffer, 2, 1)))
      ReadDataBuffer(2) = CByte(Asc(Mid(FT_In_Buffer, 3, 1)))
      'ReadData = ReadDataBuffer(0) * 65536# + ReadDataBuffer(1) * 256# + ReadDataBuffer(2)
      ReadData = ReadDataBuffer(1) * 256& + ReadDataBuffer(2)
   Else
      SPI_ErrorReport "DAC_Read", FT_Sta
   End If
   

   
   'Mid(FT_Out_Buffer, OutIndex + 1, 1) = Chr(I)
   'OutIndex = OutIndex + 1
   
   'Dim Write_Result As Long
   'Public Sub SendBytes(NumberOfBytes As Long)
   'Dim I As Long

   'I = Write_USB_Device_Buffer(NumberOfBytes)
   'OutIndex = OutIndex - I

   'FT_Sta = FT_Write(SPI_Hdl, FT_Out_Buffer, Write_Count, Write_Result)
   'If FT_Sta <> FT_OK Then FT_Error_Report "FT-Write", FT_Sta
   'Write_USB_Device_Buffer = Write_Result
   
   
'   If SPI_Ret <> FT_OK Then SPI_ErrorReport "DAC_Read", SPI_Ret
   DAC_ReadCmd = FT_Sta
   
End Function


' DACRegister     Número de registro de DAC (0 a 15)
Public Function DAC_WriteCmd(DACRegister As Byte, WriteData() As Integer) As Long
   Dim FT_Out_Buffer As String
   Dim BytesWritten As Long
   Dim Write_Count As Long
   Dim DataH As Byte, DataL As Byte
   Dim i As Integer
   Dim NLoop As Integer
   
   NumDataBytes = UBound(WriteData) + 1
   
   For i = 0 To UBound(WriteData)
      FT_Out_Buffer = FT_Out_Buffer & Chr(&H80) & Chr(&HF7) & Chr(&HB)  ' CS=0, resto a 1, CS=output, DI=input, DO=output, SK=output
      FT_Out_Buffer = FT_Out_Buffer & Chr(&H10)                         ' Orden: Transmitir en flanco de bajada de reloj
      FT_Out_Buffer = FT_Out_Buffer & Chr(2) & Chr(0)                   ' Número de bytes menos 1 a transmitir L y H
      Integer2HL WriteData(i), DataH, DataL
      FT_Out_Buffer = FT_Out_Buffer & Chr(DACRegister) & Chr(DataH) & Chr(DataL) ' Datos a escribir
      FT_Out_Buffer = FT_Out_Buffer & Chr(&H87)                         ' Ejecutar los comandos en cola.
      FT_Out_Buffer = FT_Out_Buffer & Chr(&H80) & Chr(&HFF) & Chr(&HB)  ' Set CS=1, DO=1 para que al leer D=1->RD=1
   Next i
   
   Write_Count = Len(FT_Out_Buffer)
   Do
      FT_Sta = FT_Write(SPI_Hdl, FT_Out_Buffer, Write_Count, BytesWritten)
      If FT_Sta <> FT_OK Then SPI_ErrorReport "FT_Write", FT_Sta
      If frmSPITest.chkTestADC.Value = vbChecked Then    ' Hay que hacer test también del ADC??
         FT_Sta = FT_Write(SPI2_Hdl, FT_Out_Buffer, Write_Count, BytesWritten)
      End If
      If FT_Sta <> FT_OK Then SPI_ErrorReport "FT_Write", FT_Sta
      NLoop = NLoop + 1
   Loop While NLoop < 4
   
   DAC_WriteCmd = FT_Sta
End Function


' DACRegister     Número de registro de DAC (0 a 15)
Public Function DAC_WriteReadCmd(DACRegister As Byte, WriteData() As Integer, ReadData() As Integer) As Long
   Dim FT_Out_Buffer As String
   Dim FT_In_Buffer As String
   Dim BytesWritten As Long
   Dim Write_Count As Long
   Dim ReadCommand As Byte
   Dim DataH As Byte, DataL As Byte
   Dim i As Long, b As Long
   Dim NLoop As Integer
   Dim BytesToReceive As Long, ReceivesBytes As Long
   Dim BytesReturned As Long
   Dim ReadDataBuffer(2) As Byte, lngReadData As Long
   
   
   NumDataBytes = UBound(WriteData) + 1
   
   For i = 0 To UBound(WriteData)
      ' Escritura de un nuevo valor de DAC
      FT_Out_Buffer = FT_Out_Buffer & Chr(&H80) & Chr(&HF7) & Chr(&HB)  ' CS=0, resto a 1, CS=output, DI=input, DO=output, SK=output
      FT_Out_Buffer = FT_Out_Buffer & Chr(&H10)                         ' Orden: Transmitir en flanco de bajada de reloj
      FT_Out_Buffer = FT_Out_Buffer & Chr(2) & Chr(0)                   ' Número de bytes menos 1 a transmitir L y H
      Integer2HL WriteData(i), DataH, DataL
      FT_Out_Buffer = FT_Out_Buffer & Chr(DACRegister) & Chr(DataH) & Chr(DataL) ' Datos a escribir
      FT_Out_Buffer = FT_Out_Buffer & Chr(&H87)                         ' Ejecutar los comandos en cola.
      FT_Out_Buffer = FT_Out_Buffer & Chr(&H80) & Chr(&HFF) & Chr(&HB)  ' Set CS=1, DO=1 para que al leer D=1->RD=1
   
      ' Comando de solicitud de lectura de un registro
      ReadCommand = &H80 + DACRegister                                  ' Para leer un registro MSB=RD=1
      FT_Out_Buffer = FT_Out_Buffer & Chr(&H80) & Chr(&HF7) & Chr(&HB)  ' CS=0, resto a 1, CS=output, DI=input, DO=output, SK=output
      FT_Out_Buffer = FT_Out_Buffer & Chr(&H10) & Chr(&H2) & Chr(&H0)   ' Escribir 3 bytes en flanco de bajada de reloj
      FT_Out_Buffer = FT_Out_Buffer & Chr(ReadCommand) & Chr(&H0) & Chr(&H0)   ' Comando a escribir el resto 0,0
      FT_Out_Buffer = FT_Out_Buffer & Chr(&H87)                         ' Ejecutar los comandos en cola.
      FT_Out_Buffer = FT_Out_Buffer & Chr(&H80) & Chr(&HFF) & Chr(&HB)  ' Set CS=1, DO=1 para que al leer D=1->RD=1
   
      ' Lectura del contenido del registro solicitado
      FT_Out_Buffer = FT_Out_Buffer & Chr(&H80) & Chr(&HF7) & Chr(&HB)  ' CS=0, resto a 1, CS=output, DI=input, DO=output, SK=output
      FT_Out_Buffer = FT_Out_Buffer & Chr(&H20) & Chr(&H2) & Chr(&H0)   ' Leer 3 bytes en flanco de bajada de reloj
      FT_Out_Buffer = FT_Out_Buffer & Chr(&H87)                         ' Ejecutar los comandos en cola.
      FT_Out_Buffer = FT_Out_Buffer & Chr(&H80) & Chr(&HFD) & Chr(&HB)  ' Set CS=1, DO=1 para que al leer D=1->RD=1
   
   Next i
   
   Write_Count = Len(FT_Out_Buffer)
   Do
      ' Escritura de todo, nuevos valores de DAC, comando de lectura y clocking de lectura de datos
      FT_Sta = FT_Write(SPI_Hdl, FT_Out_Buffer, Write_Count, BytesWritten)
      If FT_Sta <> FT_OK Then SPI_ErrorReport "FT_Write", FT_Sta
      
      ' Recuperación de datos leidos, deben estar en el buffer de RxFIFO (2Kbytes)
      ' Espera a que se lean lo datos
      BytesToReceive = (UBound(WriteData) + 1) * 3  ' Por cada dato envíado debo recibir 3 bytes
      Do
         FT_Sta = Get_USB_Device_QueueStatus(ReceivesBytes)
      Loop Until (ReceivesBytes = BytesToReceive) Or (FT_Sta <> FT_OK)

      If FT_Sta <> FT_OK Then
         SPI_ErrorReport "Get_USB_Device_QueueStatus", FT_Sta
         Exit Function
      End If
   
      FT_In_Buffer = Space(ReceivesBytes)       ' Preparación-dimensionado de buffer de lectura
      FT_Sta = FT_Read(SPI_Hdl, FT_In_Buffer, ReceivesBytes, BytesReturned)
      If FT_Sta = FT_OK Then
         i = 0
         For b = 1 To BytesReturned Step 3
            ReadDataBuffer(0) = CByte(Asc(Mid(FT_In_Buffer, b, 1)))
            ReadDataBuffer(1) = CByte(Asc(Mid(FT_In_Buffer, b + 1, 1)))
            ReadDataBuffer(2) = CByte(Asc(Mid(FT_In_Buffer, b + 2, 1)))
            lngReadData = ReadDataBuffer(1) * 256& + ReadDataBuffer(2)
            If lngReadData > &H7FFF Then lngReadData = lngReadData - &H10000
            ReadData(i) = CInt(lngReadData)
            i = i + 1         ' Avanzo el indice de la matriz de datos leidos
         Next b
      Else
         SPI_ErrorReport "DAC_Read", FT_Sta
      End If
            
      ' Incremento de número de repeticiones de ciclo.
      NLoop = NLoop + 1
   Loop While NLoop < 4
   
   DAC_WriteReadCmd = FT_Sta
End Function


'Public Function ADC_WriteRead(DACRegister As Byte, WriteData() As Integer, ReadData() As Integer) As Long
Public Function USBSPI_WriteADC(ControlByte As Byte, DataWord As Integer) As Long
   Dim StartCondition As FTC_INIT_CONDITION
   Dim ClockOutDataBitsMSBFirst As Boolean, ClockOutDataBitsPosEdge As Boolean
'   Dim ClockOutDataBitsMSBFirst As Long, ClockOutDataBitsPosEdge As Long
   Dim NumCtrlBytes As Long, NumCtrlBits As Long
   Dim NumDataBytes As Long, NumDataBits As Long
   Dim DataBuffer(1) As Byte
   Dim ControlBuffer(0) As Byte
   Dim WaitDataWriteComplete As FTC_WAIT_DATA_WRITE
   Dim HighPinsWriteActiveStates As FTH_HIGHER_OUTPUT_PINS
   Dim ASt As Boolean
   
' Condiciones de inicio de señales SPI-Master (CS, CLK, MOSI)
   StartCondition.ChipSelectPin = ADBUS4GPIOL1     ' Este el pin que usaré de CS
   StartCondition.bChipSelectPinState = True        ' ¿Como estará el CS cuando esté desactivado? (True=1, False=0)
   StartCondition.bClockPinState = True            ' ¿Como estará el CLK cuando esté desactivado? (True=1, False=0)
   StartCondition.bDataOutPinState = False          ' ¿Como estará el MOSI cuando esté desactivado? (True=1, False=0)
   
'xxx    StartCondition.bClockPinState = False
   
' Polaridad del reloj y orden de envío de bits
   ClockOutDataBitsMSBFirst = True    ' Los datos se envian primero el bit MSB, al final el LSB
   ClockOutDataBitsPosEdge = StartCondition.bClockPinState   ' Los datos se envían en el flanco de bajada del reloj
   
' Condiciones para que la escritura se dé por completada
   WaitDataWriteComplete.bWaitDataWriteComplete = False  ' No esperes nada, envía y regresa
   WaitDataWriteComplete.WaitDataWritePin = ADBUS2DataIn
   WaitDataWriteComplete.bDataWriteCompleteState = True
   WaitDataWriteComplete.DataWriteTimeoutmSecs = 10     ' Si se activa la espera, aguanta hasta 10mseg como máximo
   
   HighPinsWriteActiveStates.bPin1State = False
   HighPinsWriteActiveStates.bPin1ActiveState = False
   HighPinsWriteActiveStates.bPin2State = False
   HighPinsWriteActiveStates.bPin2ActiveState = False
   HighPinsWriteActiveStates.bPin3State = False
   HighPinsWriteActiveStates.bPin3ActiveState = False
   HighPinsWriteActiveStates.bPin4State = False
   HighPinsWriteActiveStates.bPin4ActiveState = False
   HighPinsWriteActiveStates.bPin5State = False
   HighPinsWriteActiveStates.bPin5ActiveState = False
   HighPinsWriteActiveStates.bPin6State = False
   HighPinsWriteActiveStates.bPin6ActiveState = False
   HighPinsWriteActiveStates.bPin7State = False
   HighPinsWriteActiveStates.bPin7ActiveState = False
   HighPinsWriteActiveStates.bPin8State = False
   HighPinsWriteActiveStates.bPin8ActiveState = False
   
   ASt = True
   HighPinsWriteActiveStates.bPin1State = True
   HighPinsWriteActiveStates.bPin1ActiveState = ASt
   HighPinsWriteActiveStates.bPin2State = True
   HighPinsWriteActiveStates.bPin2ActiveState = ASt
   HighPinsWriteActiveStates.bPin3State = True
   HighPinsWriteActiveStates.bPin3ActiveState = ASt
   HighPinsWriteActiveStates.bPin4State = True
   HighPinsWriteActiveStates.bPin4ActiveState = ASt
   HighPinsWriteActiveStates.bPin5State = True
   HighPinsWriteActiveStates.bPin5ActiveState = ASt
   HighPinsWriteActiveStates.bPin6State = True
   HighPinsWriteActiveStates.bPin6ActiveState = ASt
   HighPinsWriteActiveStates.bPin7State = True
   HighPinsWriteActiveStates.bPin7ActiveState = ASt
   HighPinsWriteActiveStates.bPin8State = True
   HighPinsWriteActiveStates.bPin8ActiveState = ASt
   
   
' Preparación buffers y variables para usar función de librería
   ControlBuffer(0) = ControlByte
   NumCtrlBytes = 1
   NumCtrlBits = NumCtrlBytes * 8
         
   DataBuffer(1) = (DataWord And &HFF)             ' Byte Bajo
   DataBuffer(0) = ((DataWord \ 256) And &HFF)     ' Byte Alto
   NumDataBytes = 2
   NumDataBits = NumDataBytes * 8
   
'   SPI_Ret = SPI_WriteHiSpeedDevice(SPI_Hdl, StartCondition, True, False, NumCtrlBits, ControlBuffer(0), NumCtrlBytes, True, NumDataBits, DataBuffer(0), NumDataBytes, WaitDataWriteComplete, HighPinsWriteActiveStates)
   SPI_Ret = SPI_WriteHiSpeedDevice(SPI_Hdl, StartCondition, ClockOutDataBitsMSBFirst, ClockOutDataBitsPosEdge, _
               NumCtrlBits, ControlBuffer(0), NumCtrlBytes, True, NumDataBits, DataBuffer(0), NumDataBytes, WaitDataWriteComplete, _
               HighPinsWriteActiveStates)

   If frmSPITest.chkTestADC.Value = vbChecked Then    ' Hay que hacer test también del ADC??
      SPI_Ret = SPI_WriteHiSpeedDevice(SPI2_Hdl, StartCondition, ClockOutDataBitsMSBFirst, ClockOutDataBitsPosEdge, _
                  NumCtrlBits, ControlBuffer(0), NumCtrlBytes, True, NumDataBits, DataBuffer(0), NumDataBytes, WaitDataWriteComplete, _
                  HighPinsWriteActiveStates)
   End If

   If SPI_Ret <> FT_OK Then SPI_ErrorReport "USBSPI_Write", SPI_Ret
   USBSPI_WriteADC = SPI_Ret
   
End Function




   
   
   

' Convierte los datos del ADC (complemento a 2) en tensión
Public Sub ADCData2Volt(ADCData() As Integer, ADCVolt() As Single)
   Dim i As Long, Volt As Single

   ReDim ADCVolt(UBound(ADCData))
   For i = 0 To UBound(ADCData)
      ADCVolt(i) = ADCData(i) / 3276.8
   Next i

End Sub



