Attribute VB_Name = "USB_SPI_ParaBorrar"
' Parámetros:
' ReadData()   Matriz en la que se devuelve los datos de las conversiones A/D,
'              ReadData(0) -> Ch1_ADC, ReadData(1) -> Ch2_ADC, ....
'              Se redimensiona aquí según número de canales ADC (numADCChannels)
Public Function ADC_Read(ReadData() As Integer) As Long
   Dim FT_Out_Buffer As String
   Dim FT_In_Buffer As String
   Dim ReceivesBytes As Long
   Dim BytesToReceive As Long, BytesReturned As Long
   Dim BytesWritten As Long
   Dim ReadDataBuffer(16) As Byte, lngReadData As Long
   Dim Write_Count As Long
   Dim c As Integer, b As Integer
   
   On Error Resume Next
   
' Tabla de patillas de salida del puerto L
'      GPIOL3,GPIOL2,GPIOL1,GPIOL0, CS, DI, DO, SK
' &HDF=  1      1      0      1     1   1   1   1
' &HBB=  1S     0E     1S     1S    1S  0E  1S  1S
' &HFF=  1      1      1      1     1   1   1   1
' &HEF=  1      1      1      0     1   1   1   1

' Inicio de conversión, pulso en CONVST A
   FT_Out_Buffer = Chr(MPSSE_CmdSetPortL) & Chr(&HDF) & Chr(&HBB)                  ' GPIOL1=SOC_ADC=0, resto a 1, DI=input y GPIOL2=entradas(0), resto salidas(1)
   FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSetPortL) & Chr(&HFF) & Chr(&HBB)  ' GPIOL1=SOC_ADC=1, resto a 1, DI=input y GPIOL2=entradas(0), resto salidas(1)
   
' Datos inutiles para esperar a que termine conversión (2-4 µseg)
   For b = 1 To 5    ' Envío algo que no moleste: El dato anterior, MPSSE_CmdSetPortL+&HFF+&HBB
      FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSetPortL) & Chr(&HFF) & Chr(&HBB) ' GPIOL1=SOC_ADC=1, resto a 1, DI=input y GPIOL2=entradas(0), resto salidas(1)
   Next b
   
' Lectura de datos ADC, bajo CS_ADC
   FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSetPortL) & Chr(&HEF) & Chr(&HBB)   ' GPIOL0=CS_ADC=0, resto a 1, DI=input y GPIOL2=entradas(0), resto salidas(1)
   ' Leer 12(11+1) bytes: 6 canales x 2 bytes/canal, -1 por que con 0 es leer 1 byte en flanco de bajada de reloj
   FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdReadDI) & Chr((2 * numADCChannels) - 1) & Chr(&H0)
   FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSendInmediate)                      ' Ejecutar los comandos en cola.
   FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSetPortL) & Chr(&HFF) & Chr(&HBB)   ' Set CS_ADC=1
      
' Envío efectivo de todo el buffer
   Write_Count = Len(FT_Out_Buffer)
   FT_Sta = FT_Write(SPI_Hdl, FT_Out_Buffer, Write_Count, BytesWritten)
   If FT_Sta <> FT_OK Then SPI_ErrorReport "FT_Write", FT_Sta
   
' Recuperación de datos leidos, deben estar en el buffer de RxFIFO (2Kbytes)
' Espera a que se lean lo datos
   BytesToReceive = 2 * numADCChannels                ' Por cada canal A/D debo recibir 2 bytes, 6Ch x 2 =12bytes (ADC 16 bits, ¿que pasa con 18bits?)
   Do
      FT_Sta = Get_USB_Device_QueueStatus(ReceivesBytes)
   Loop Until (ReceivesBytes >= BytesToReceive) Or (FT_Sta <> FT_OK)
  
   If FT_Sta <> FT_OK Then
      SPI_ErrorReport "Get_USB_Device_QueueStatus", FT_Sta
      Exit Function
   End If
   
' Lectura de los datos leidos del ADC
   FT_In_Buffer = Space(ReceivesBytes)
   ReDim ReadData(numADCChannels - 1)     ' Dimensiono según el núm. de canales ADC
   FT_Sta = FT_Read(SPI_Hdl, FT_In_Buffer, ReceivesBytes, BytesReturned)
   If FT_Sta = FT_OK Then
      c = 0                               ' Comienzo leyendo canal 0 ADC (V1 según datasheet)
      ' Los datos se transmite en modo big-endian (El byte de mayor peso primero, como en el formato Motorola)
      For b = 1 To BytesReturned Step 2
         ReadData(c) = CVIb(Mid(FT_In_Buffer, b, 2))  'Big-endian H*256+L
         c = c + 1
      Next b
   Else
      SPI_ErrorReport "ADC_Read", FT_Sta
   End If

   ADC_Read = FT_Sta
   
End Function


' DACRegister     Número de registro de DAC (0 a 15)
Public Function DAC_Write_ADC_Read(DACRegister As Byte, WriteData() As Integer, ReadData() As Integer) As Long
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
   Dim NumADCChan As Integer  ' Número de canales ADC a leer, Si es 3 se leerá V1, V2, V3, si es 1 sólo V1

   NumADCChan = 2
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

      ' Inicio de conversión ADC, pulso en CONVST A
      FT_Out_Buffer = FT_Out_Buffer & Chr(&H80) & Chr(&HDF) & Chr(&HBB) ' GPIOL1=SOC_ADC=0, resto a 1, DI=input y GPIOL2=entradas(0), resto salidas(1)
      FT_Out_Buffer = FT_Out_Buffer & Chr(&H80) & Chr(&HFF) & Chr(&HBB) ' GPIOL1=SOC_ADC=1, resto a 1, DI=input y GPIOL2=entradas(0), resto salidas(1)

      ' Datos inutiles para esperar a que termine conversión (2-4 µseg)
      FT_Out_Buffer = FT_Out_Buffer & Chr(&H80) & Chr(&HFF) & Chr(&HBB) ' GPIOL1=SOC_ADC=1, resto a 1, DI=input y GPIOL2=entradas(0), resto salidas(1)
      FT_Out_Buffer = FT_Out_Buffer & Chr(&H80) & Chr(&HFF) & Chr(&HBB) ' GPIOL1=SOC_ADC=1, resto a 1, DI=input y GPIOL2=entradas(0), resto salidas(1)
      FT_Out_Buffer = FT_Out_Buffer & Chr(&H80) & Chr(&HFF) & Chr(&HBB) ' GPIOL1=SOC_ADC=1, resto a 1, DI=input y GPIOL2=entradas(0), resto salidas(1)
      FT_Out_Buffer = FT_Out_Buffer & Chr(&H80) & Chr(&HFF) & Chr(&HBB) ' GPIOL1=SOC_ADC=1, resto a 1, DI=input y GPIOL2=entradas(0), resto salidas(1)
      FT_Out_Buffer = FT_Out_Buffer & Chr(&H80) & Chr(&HFF) & Chr(&HBB) ' GPIOL1=SOC_ADC=1, resto a 1, DI=input y GPIOL2=entradas(0), resto salidas(1)

      ' Lectura de datos ADC, bajo CS_ADC
      FT_Out_Buffer = FT_Out_Buffer & Chr(&H80) & Chr(&HEF) & Chr(&HBB) ' GPIOL0=CS_ADC=0, resto a 1, DI=input y GPIOL2=entradas(0), resto salidas(1)
      FT_Out_Buffer = FT_Out_Buffer & Chr(&H20) & Chr((2 * NumADCChan) - 1) & Chr(&H0) ' Leer 4(3+1)bytes, 2 canales*2 bytes/ch en flanco de bajada de reloj
      FT_Out_Buffer = FT_Out_Buffer & Chr(&H87)                         ' Ejecutar los comandos en cola.
      FT_Out_Buffer = FT_Out_Buffer & Chr(&H80) & Chr(&HFF) & Chr(&HBB) ' Set CS_ADC=1
   Next i

   Write_Count = Len(FT_Out_Buffer)
   Do
      ' Escritura de todo, nuevos valores de DAC, pulso CONVST y clocking de lectura de datos
      FT_Sta = FT_Write(SPI_Hdl, FT_Out_Buffer, Write_Count, BytesWritten)
      If FT_Sta <> FT_OK Then SPI_ErrorReport "FT_Write", FT_Sta

      ' Recuperación de datos leidos, deben estar en el buffer de RxFIFO (2Kbytes)
      ' Espera a que se lean lo datos
      BytesToReceive = (UBound(WriteData) + 1) * 2 * NumADCChan ' Por cada dato envíado debo recibir 6 Ch x 2 bytes=12bytes (ADC 16 bits, ¿que pasa con 18bits?)
      Do
         FT_Sta = Get_USB_Device_QueueStatus(ReceivesBytes)
      Loop Until (ReceivesBytes >= BytesToReceive) Or (FT_Sta <> FT_OK)

      If FT_Sta <> FT_OK Then
         SPI_ErrorReport "Get_USB_Device_QueueStatus", FT_Sta
         Exit Function
      End If

      FT_In_Buffer = Space(ReceivesBytes)       ' Preparación-dimensionado de buffer de lectura
      FT_Sta = FT_Read(SPI_Hdl, FT_In_Buffer, ReceivesBytes, BytesReturned)
      If FT_Sta = FT_OK Then
         i = 0
         For b = 1 To BytesReturned Step 4 '2  ' Cada 2 bytes(16bits) un datoADC
            ReadDataBuffer(0) = CByte(Asc(Mid(FT_In_Buffer, b, 1)))
            ReadDataBuffer(1) = CByte(Asc(Mid(FT_In_Buffer, b + 1, 1)))
            lngReadData = ReadDataBuffer(0) * 256& + ReadDataBuffer(1)
            If lngReadData > &H7FFF Then lngReadData = lngReadData - &H10000
            ReadData(i) = CInt(lngReadData)
            i = i + 1         ' Avanzo el indice de la matriz de datos leidos
         Next b
      Else
         SPI_ErrorReport "DAC_Write_ADC_Read", FT_Sta
      End If

      ' Incremento de número de repeticiones de ciclo.
      NLoop = NLoop + 1
   Loop While NLoop < 4

   DAC_Write_ADC_Read = FT_Sta
End Function



Public Function USBSPI_SetConfig(SPIHandle As Long, SPIClkFreq As Long) As Long
   Dim Clock_Divisor As Long
   Dim CSDisableStates As FTC_CHIP_SELECT_PINS
   Dim HighIOPinsData As FTH_INPUT_OUTPUT_PINS
   '???Dim HighPinsInputData As FTH_LOW_HIGH_PINS

   
   Clock_Divisor = (6000000# / SPIClkFreq) - 1
   '???SPI_Ret = SPI_GetClock(Clock_Divisor, ClkFreq)
   '???SPI_Ret = SPI_SetClock(SPI_Hdl, Clock_Divisor, ClkFreq)
   SPI_Ret = SPI_InitDevice(SPIHandle, Clock_Divisor)
   SPI_Ret = SPI_SetDeviceLatencyTimer(SPIHandle, 2)       ' Latencia al mínimo de  2 mseg
   
' Defino cuales de los 5 CS (TM/CS + GPIOL0-3) voy a utilizar (False=Activo)
   CSDisableStates.bADBUS3ChipSelectPinState = False  ' En FT4232H, TMS/CS
   CSDisableStates.bADBUS4GPIOL1PinState = False      ' En FT4232H, GPIOL0
   CSDisableStates.bADBUS5GPIOL2PinState = True       ' En FT4232H, GPIOL1
   CSDisableStates.bADBUS6GPIOL3PinState = True       ' En FT4232H, GPIOL2
   CSDisableStates.bADBUS7GPIOL4PinState = True       ' En FT4232H, GPIOL3
   
' En FT423H no existen fisicamente estos pines I/O: GPIOH1-8
' Configuración en modo entrada/salida, False=Entrada, True=Salida
   HighIOPinsData.bPin1InputOutputState = False    ' Pin 1 False=Entrada, True=Salida
   HighIOPinsData.bPin2InputOutputState = False    ' Pin 2 False=Entrada, True=Salida
   HighIOPinsData.bPin3InputOutputState = False    ' Pin 3 False=Entrada, True=Salida
   HighIOPinsData.bPin4InputOutputState = False    ' Pin 4 False=Entrada, True=Salida
   HighIOPinsData.bPin5InputOutputState = True     ' Pin 5 False=Entrada, True=Salida
   HighIOPinsData.bPin6InputOutputState = False    ' Pin 6 False=Entrada, True=Salida
   HighIOPinsData.bPin7InputOutputState = True     ' Pin 7 False=Entrada, True=Salida
   HighIOPinsData.bPin8InputOutputState = True     ' Pin 8 False=Entrada, True=Salida
   
' Configuración estado 0 ó de patillas de salida. Si Pin es salida,  False=0, True=1
   HighIOPinsData.bPin1LowHighState = False
   HighIOPinsData.bPin2LowHighState = False
   HighIOPinsData.bPin3LowHighState = False
   HighIOPinsData.bPin4LowHighState = False
   HighIOPinsData.bPin5LowHighState = False
   HighIOPinsData.bPin6LowHighState = False
   HighIOPinsData.bPin7LowHighState = False
   HighIOPinsData.bPin8LowHighState = False
   
   SPI_Ret = SPI_SetHiSpeedDeviceGPIOs(SPIHandle, CSDisableStates, HighIOPinsData)
   
   If SPI_Ret <> FT_OK Then SPI_ErrorReport " USBSPI_GetDeviceInfo", SPI_Ret
   USBSPI_SetConfig = SPI_Ret
End Function
