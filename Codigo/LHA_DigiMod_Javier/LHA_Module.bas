Attribute VB_Name = "LHA_Module"
Option Explicit

' Con los chip FT4232H ó FT2232H es posible comunicarse utilizando la librería FTD2XX.DLL de nivel más bajo
' o la librería FTCSPI.DLL que a partir de llamadas a funciones de FTD2XX.DLL, tiene funciones ya pensadas
' para manejar los puertos SPI, sin necesidad de conocer los comandos del MPSSE.
' Las funciones de la librería FTD2XX.DLL comienzan for FT_ mientras que las de FTCSPI.DLL comienzan por SPI_
' Hay cosas que no se pueden hacer con las funciones SPI_ como por ejemplo alternar comando de escritura y
' y lectura como los necesarios para el scan del microscopio 1DAC-1ADC-1DAC-1ADC..... por eso he utilizado
' directamente la librería FTD2XX encadenando comandos MPSSE
' El código fuente de FTCSPI.DLL está publicado en fuentes como FTCSPI.cpp y FT2232cMpsseSpi.cpp
'
' El prototipo inicial se desarrollo con el FT4232H por tener 4 canales aunque finalmente sólo 2 pueden ser SPI
' igual que el FT2232H. El FT4232H tien 4 canales de 8 bits y el FT2232H 2 canales de 16 bits, como vamos a necesitar
' usar bits extras como OS2:0 para el ADC es más cómodo usar el FT2232H así sól hay que abrir un canal para tener
' 1 SPI y 8 bits de propósito general

'************************************************************************************************
'                                            DECLARACIONES DE API WINDOWS
'************************************************************************************************
' Para conversiones en entornos de 16 bits usar hMemCpy en lugar de RtlMoveMemory
'Private Declare Sub hMemCpy Lib "KERNEL32" Alias "RtlMoveMemory" (hpvDest As Any, hpvSource As Any, ByVal cbCopy As Long)

#If Win32 Then
   Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" ( _
   hpvDest As Any, hpvSource As Any, ByVal cbCopy As Long)
#Else
   Declare Sub CopyMemory Lib "KERNEL" Alias "hmemcpy" ( _
   hpvDest As Any, hpvSource As Any, ByVal cbCopy As Long)
#End If

' Para hacer cambios entre formatos Intel y Motorola (big endian)
Public Declare Function ntohl Lib "wsock32.dll" (ByVal A As Long) As Long
Public Declare Function ntohs Lib "wsock32.dll" (ByVal A As Long) As Integer


'************************************************************************************************
'                                COMANDOS MPSSE Y PATILLAS LHA FT2232H
'************************************************************************************************
Public Const MPSSE_BadCommand = &HFA         ' If detects a bad command send back 2 bytes to the PC: 0xFA + the bad command byte.
Public Const MPSSE_CmdWriteDO = &H10         ' Clock Data Bytes Out on +ve Clock Edge MSB First (no Read)
Public Const MPSSE_CmdWriteDO2 = &H11         ' Clock Data Bytes Out on -ve Clock Edge MSB First (no Read)

Public Const MPSSE_CmdSendInmediate = &H87   ' This will make the chip flush its buffer back to the PC.
Public Const MPSSE_CmdSetPortL = &H80        ' Set Data Bits Low Byte
Public Const MPSSE_CmdSetPortH = &H82        ' Set Data Bits High Byte
Public Const MPSSE_CmdReadPortH = &H83       ' Read Data Bits High Byte
Public Const MPSSE_CmdReadDI = &H20          ' Clock Data Bytes In on +ve Clock Edge MSB First (no Write) Lengh=0->1byte

Public Enum MPSSEpins   ' MPSSE están sólo en canal A y B del FT4232H, GPIOH7:0 sólo en FT2232H
   SPI_SK = 1           ' SK = SPI Serial Clock
   SPI_DO = 2           ' DO = SPI MOSI (Master Output, Slave Input)
   SPI_DI = 4           ' DI = SPI MISO (Master Input, Slave Output)
   SPI_CS = 8           ' CS = SPI Chip Select
   SPI_GPIOL0 = 16      ' GPIOL0= Pin 0, Low Byte General Purpose I/0
   SPI_GPIOL1 = 32      ' GPIOL1= Pin 1, Low Byte General Purpose I/0
   SPI_GPIOL2 = 64      ' GPIOL2= Pin 2, Low Byte General Purpose I/0
   SPI_GPIOL3 = 128     ' GPIOL3= Pin 3, Low Byte General Purpose I/0
   GPIOH0 = 1           ' GPIOH0= Pin 0, High Byte General Purpose I/0
   GPIOH1 = 2           ' GPIOH1= Pin 1, High Byte General Purpose I/0
   GPIOH2 = 4           ' GPIOH2= Pin 2, High Byte General Purpose I/0
   GPIOH3 = 8           ' GPIOH3= Pin 3, High Byte General Purpose I/0
   GPIOH4 = 16          ' GPIOH4= Pin 4, High Byte General Purpose I/0
   GPIOH5 = 32          ' GPIOH5= Pin 5, High Byte General Purpose I/0
   GPIOH6 = 64          ' GPIOH6= Pin 6, High Byte General Purpose I/0
   GPIOH7 = 128         ' GPIOH7= Pin 7, High Byte General Purpose I/0
End Enum

'''Public Enum xGPIOHpins   ' Estos sólo están disponible en el FT2232H ya que sus canales son de 16 bits
'''   SPI_GPIOH0 = 1       ' GPIOH0= Pin 0, High Byte General Purpose I/0
'''   SPI_GPIOH1 = 2       ' GPIOH1= Pin 1, High Byte General Purpose I/0
'''   SPI_GPIOH2 = 4       ' GPIOH2= Pin 2, High Byte General Purpose I/0
'''   SPI_GPIOH3 = 8       ' GPIOH3= Pin 3, High Byte General Purpose I/0
'''   SPI_GPIOH4 = 16      ' GPIOH4= Pin 4, High Byte General Purpose I/0
'''   SPI_GPIOH5 = 32      ' GPIOH5= Pin 5, High Byte General Purpose I/0
'''   SPI_GPIOH6 = 64      ' GPIOH6= Pin 6, High Byte General Purpose I/0
'''   SPI_GPIOH7 = 128     ' GPIOH7= Pin 7, High Byte General Purpose I/0
'''End Enum

Public Enum LHApins
   pSK = SPI_SK            ' Serial clock
   pDO = SPI_DO            ' SPI MOSI (Master Output, Slave(ADC/DAC) Input)
   pDI = SPI_DI            ' SPI MISO (Master Input, Slave(ADC/DAC) Output)
   pDACcs = SPI_CS         ' CS_DAC   (Chip Select DAC0-3), Salida
   
  ' JB: Comentados y puestos más abajo correctamente
  ' pADCcs = SPI_GPIOL0     ' CS_ADC   (Chip Select ADC), Salida
  ' pADCsoc = SPI_GPIOL1    ' CONVSTA  (Start of Convertion ADC), Salida
  ' pDAC2cs = SPI_GPIOL2    ' CS_DAC2  (Chip Select DAC4-7), Salida
  ' pNC = SPI_GPIOL3        ' No conectado, de momento...
   
  ' pADCos0 = SPI_GPIOL2    ' Sólo en proto, porque es un FT4232H
  ' pADCos1 = SPI_GPIOL3    '
  ' pADCos2 = 0             ' En proto siempre a 0
  
  ' JB: Descripciones por actualizar
   pADCcs = SPI_GPIOL0     ' CS_ADC   (Chip Select ADC), Salida
   pDAC2cs = SPI_GPIOL1    ' CS_DAC2  (Chip Select DAC4-7), Salida
   pAttcs = SPI_GPIOL2     ' No conectado, de momento...
   pADCsoc = SPI_GPIOL3    ' CONVSTA  (Start of Convertion ADC), Salida
  
  
  
End Enum

Public Enum LHA_GPIOHpins
   borrame = 0
   'zzz pADCos0 = GPIOH0        ' OS0 Filtro digital ADC, Salida
   'zzz pADCos1 = GPIOH1        ' OS1 Filtro digital ADC, Salida
   'zzz pADCos2 = GPIOH2        ' OS2 Filtro digital ADC, Salida
   ' JB: Estaba ya comentado, yo actualizo abajo:
   
   pADCos0 = GPIOH0        ' OS0 Filtro digital ADC, Salida
   pADCos1 = GPIOH1        ' OS1 Filtro digital ADC, Salida
   pADCos2 = GPIOH2        ' OS2 Filtro digital ADC, Salida
   pDIOcs = GPIOH3
   
   
End Enum

'************************************************************************************************
'                                VARIABLES PÚBLICAS DEL MÓDULO
'************************************************************************************************
Private SPIpins As LHApins             ' Estado de pines de salida bus SPI del MPSSE
Private SPIdir As LHApins              ' Dirección E ó S de pines bus SPI del MPSSE
Private cSPIdir As String * 1          ' Lo mismo que SPI pero en formato caracter, Chr(SPIdir)
Private GPIOHpins As LHA_GPIOHpins     ' Estado de pines de salida bus GPIOH del MPSSE
Private GPIOHdir As LHA_GPIOHpins      ' Dirección E ó S de pines bus GPIOH del MPSSE

Private ADCFilterLevel As Integer      ' NIvel del filtro digital ADC (0-6) 0=Sin filtro



'---------------------------------------------------------------------------------------------------
' LHAProto_SetADCFilter: Cambia el estado del filtro digital del ADC
'---------------------------------------------------------------------------------------------------
' Cambia el estado de los bits O2:0, actualiza el valor de variable pública ADCFilterLevel
' Parámetros:
' DFilterLevel (0 a 6)    Nivel de filtro digital del ADC (0=sin filtro, 1=Oversamplig 2, 2=OS4, 3=OS8...)
Public Function LHAProto_SetADCFilter(DFilterLevel As Integer) As Long
   Dim FT_Out_Buffer As String
   Dim BytesToWrite As Long, BytesWritten As Long
 
 
' JB: función que no debería hacer nada
 
' Configuración del filtro digital del ADC.
   If DFilterLevel > 6 Then DFilterLevel = 6    ' El filtro debe estar entre 0 y 6 (0=sin filtro)
   If DFilterLevel < 0 Then DFilterLevel = 0
   SPIpins = &H3F
   Select Case DFilterLevel
      Case 1
         SPIpins = SPIpins + pADCos0                  ' OS2=0, OS1=0, OS0=1, 2 Oversampling, (BW=22KHz)
      Case 2
         SPIpins = SPIpins + pADCos1                   ' OS2=0, OS1=1, OS0=0, 4 Oversampling, (BW=18.5KHz)
      Case 3
         SPIpins = SPIpins + pADCos1 + pADCos0        ' OS2=0, OS1=1, OS0=1, 8 Oversampling, (BW=11.9KHz)
      Case 4
         SPIpins = SPIpins + pADCos2                   ' OS2=1, OS1=0, OS0=0, 16 Oversampling, (BW=6KHz)
      Case 5
         SPIpins = SPIpins + pADCos2 + pADCos0        ' OS2=1, OS1=0, OS0=1, 32 Oversampling, (BW=3KHz)
      Case 6
         SPIpins = SPIpins + pADCos2 + pADCos1        ' OS2=1, OS1=1, OS0=0, 64 Oversampling, (BW=1.5KHz)
      Case Else                               ' OS2=0, OS1=0, OS0=0,  No Oversampling, Sin Filtro, (BW=22KHz)
   End Select
   
' Establecimiento byte GPIOH7:0 (Filtro digital ADC)
' JB:   FT_Out_Buffer = Chr(MPSSE_CmdSetPortL) & Chr(SPIpins) & Chr(SPIdir)     ' Cambio estado pines puerto GPIOH
 ' JB:  BytesToWrite = Len(FT_Out_Buffer)                                          ' Num. bytes a escribir en un microframe USB (125µs)
   
 ' JB:  FT_Sta = FT_Write(SPI_Hdl, FT_Out_Buffer, BytesToWrite, BytesWritten)
  ' JB: If FT_Sta <> FT_OK Then
 ' JB:     SPI_ErrorReport "LHA_SetADCFilter", FT_Sta
  ' JB: Else
    ' JB:  ADCFilterLevel = DFilterLevel       ' Si todo fue bien guardo nuevo filtro en variable pública
' JB:   End If
   
   LHAProto_SetADCFilter = FT_Sta
End Function



'---------------------------------------------------------------------------------------------------
' LHA_SetADCFilter: Cambia el estado del filtro digital del ADC
'---------------------------------------------------------------------------------------------------
' Cambia el estado de los bits O2:0, actualiza el valor de variable pública ADCFilterLevel
' Parámetros:
' DFilterLevel (0 a 6)    Nivel de filtro digital del ADC (0=sin filtro, 1=Oversamplig 2, 2=OS4, 3=OS8...)
Public Function LHA_SetADCFilter(DFilterLevel As Integer) As Long
   Dim FT_Out_Buffer As String
   Dim BytesToWrite As Long, BytesWritten As Long
 
   GPIOHpins = (GPIOHpins And (&H8))    ' JB:Ini de la variable. Forzamos el CS_DIO a 1 y los parámetros del OS a 0 para luego sumar
                                        ' JB: ¿no falta una or? Con el and aseguras los 0´s pero no los 1s


' Configuración del filtro digital del ADC.
   If DFilterLevel > 6 Then DFilterLevel = 6    ' El filtro debe estar entre 0 y 6 (0=sin filtro)
   If DFilterLevel < 0 Then DFilterLevel = 0
   Select Case DFilterLevel                                 ' JB: Cambio formato, en vez de igualar se suma
      Case 1
         GPIOHpins = GPIOHpins + pADCos0                   ' OS2=0, OS1=0, OS0=1, 2 Oversampling, (BW=22KHz)
      Case 2
         GPIOHpins = GPIOHpins + pADCos1                    ' OS2=0, OS1=1, OS0=0, 4 Oversampling, (BW=18.5KHz)
      Case 3
         GPIOHpins = GPIOHpins + pADCos1 + pADCos0          ' OS2=0, OS1=1, OS0=1, 8 Oversampling, (BW=11.9KHz)
      Case 4
         GPIOHpins = GPIOHpins + pADCos2                   ' OS2=1, OS1=0, OS0=0, 16 Oversampling, (BW=6KHz)
      Case 5
         GPIOHpins = GPIOHpins + pADCos2 + pADCos0          ' OS2=1, OS1=0, OS0=1, 32 Oversampling, (BW=3KHz)
      Case 6
         GPIOHpins = GPIOHpins + pADCos2 + pADCos1         ' OS2=1, OS1=1, OS0=0, 64 Oversampling, (BW=1.5KHz)
      Case Else                                 ' OS2=0, OS1=0, OS0=0,  No Oversampling, Sin Filtro, (BW=22KHz)
   End Select
   
' Establecimiento byte GPIOH7:0 (Filtro digital ADC)
   FT_Out_Buffer = Chr(MPSSE_CmdSetPortH) & Chr(GPIOHpins) & Chr(GPIOHdir)    ' Cambio estado pines puerto GPIOH
   BytesToWrite = Len(FT_Out_Buffer)                                          ' Num. bytes a escribir en un microframe USB (125µs)
   
   FT_Sta = FT_Write(SPI_Hdl, FT_Out_Buffer, BytesToWrite, BytesWritten)
   If FT_Sta <> FT_OK Then
      SPI_ErrorReport "LHA_SetADCFilter", FT_Sta
   Else
      ADCFilterLevel = DFilterLevel       ' Si todo fue bien guardo nuevo filtro en variable pública
   End If
   
   LHA_SetADCFilter = FT_Sta
End Function

'---------------------------------------------------------------------------------------------------
' LHA_GetADCFilter: Lee el estado actual del filtro digital del ADC
'---------------------------------------------------------------------------------------------------
' Lee el estado de los bits O2:0, actualiza el valor de variable pública ADCFilterLevel
' Devuelve:
' DFilterLevel (0 a 6)    Nivel de filtro digital del ADC (0=sin filtro, 1=Oversamplig 2, 2=OS4, 3=OS8...)
Public Function LHA_GetADCFilter(DFilterLevel As Integer) As Long
   Dim FT_Out_Buffer As String
   Dim FT_In_Buffer As String
   Dim BytesToWrite As Long, BytesWritten As Long
   Dim BytesToReceive As Long, ReceivesBytes As Long
   Dim BytesReturned As Long
   
' Establecimiento byte GPIOH7:0 (Filtro digital ADC)
      
      
   ' JB: Por qué se usa escritura en vez de lectura?? Seguramente fallo. Lo cambio
   
   ' FT_Out_Buffer = Chr(MPSSE_CmdSetPortH) & Chr(MPSSE_CmdSendInmediate)       ' Leo el estado pines puerto GPIOH
    FT_Out_Buffer = Chr(MPSSE_CmdReadPortH) & Chr(MPSSE_CmdSendInmediate)
   
   BytesToWrite = Len(FT_Out_Buffer)                                          ' Num. bytes a escribir en un microframe USB (125µs)
   
   FT_Sta = FT_Write(SPI_Hdl, FT_Out_Buffer, BytesToWrite, BytesWritten)
   If FT_Sta <> FT_OK Then SPI_ErrorReport "LHA_GetADCFilter", FT_Sta

' ESPERA A LA EJECUCIÓN COMANDOS Y RECEPCIÓN RESPUESTA...................................................................
   ' Recuperación de datos leidos, deben estar en el buffer de RxFIFO (2Kbytes)
   ' Espera a que se lean lo datos
   BytesToReceive = 1                                    ' Sólo recibiré el estado de GPIOH, 1 byte
   Do                                                    '(ADC 16 bits, ¿que pasa con 18bits?)
      FT_Sta = Get_USB_Device_QueueStatus(ReceivesBytes) ' Bucle de espera a que llegen todo los bytes o marque error
   Loop Until (ReceivesBytes >= BytesToReceive) Or (FT_Sta <> FT_OK)
  
   If FT_Sta <> FT_OK Then                               ' Fallo algo salgo sin leer y marcando error
      SPI_ErrorReport "Get_USB_Device_QueueStatus", FT_Sta
      Exit Function
   End If
   
' LECTURA DE DATOS RECIBIDOS...............................................................................................
   ' Decodificación y almacenamiento de los datos recibidos
   FT_In_Buffer = Space(ReceivesBytes)                   ' Preparación-dimensionado de buffer de lectura
   ReDim ReadData(numADCChannels - 1)                    ' Dimensiono según el núm. de canales ADC
   FT_Sta = FT_Read(SPI_Hdl, FT_In_Buffer, ReceivesBytes, BytesReturned)
   If FT_Sta = FT_OK Then
      DFilterLevel = CInt(Asc(Mid(FT_In_Buffer, 1, 1))) And &H7 ' Enmascaro los bits que no me interesan sólo OS2:0
      ADCFilterLevel = DFilterLevel                      ' Si todo fue bien guardo nuevo filtro en variable pública
   Else
      SPI_ErrorReport "LHA_GetADCFilter", FT_Sta
   End If

   LHA_GetADCFilter = FT_Sta
   
End Function

' PENDIENTE: Tratar de configurar todo liberría FTCSPI y no usar FTD2XXX
Public Function LHA_Config(SPIHandle As Long, SPIClkFreq As Long) As Long
   Dim Clock_Divisor As Long
   Dim CSDisableStates As FTC_CHIP_SELECT_PINS
   Dim HighIOPinsData As FTH_INPUT_OUTPUT_PINS
   Dim BytesToWrite As Long, BytesWritten As Long
   Dim FT_Out_Buffer As String

   Clock_Divisor = (6000000# / SPIClkFreq) - 1
   SPI_Ret = SPI_InitDevice(SPIHandle, Clock_Divisor)    ' Reset FT2232H y set clock freq.
   SPI_Ret = SPI_SetDeviceLatencyTimer(SPIHandle, 2)     ' Latencia al mínimo de  2 mseg
   
' JB: Los CS todos activos. Los pines todo salidas, a nivel alto.
   
' Defino cuales de los 5 CS (TM/CS + GPIOL0-3) voy a utilizar (False=Activo)
   CSDisableStates.bADBUS3ChipSelectPinState = False         ' En FT4232H, TMS/CS
   CSDisableStates.bADBUS4GPIOL1PinState = False             ' En FT4232H, GPIOL0
   CSDisableStates.bADBUS5GPIOL2PinState = False 'True       ' En FT4232H, GPIOL1
   CSDisableStates.bADBUS6GPIOL3PinState = False 'True       ' En FT4232H, GPIOL2
   CSDisableStates.bADBUS7GPIOL4PinState = False 'True       ' En FT4232H, GPIOL3
   
' En FT423H no existen fisicamente estos pines I/O: GPIOH0-7
' Configuración en modo entrada/salida, False=Entrada, True=Salida
   HighIOPinsData.bPin1InputOutputState = True 'False    ' Pin 1 False=Entrada, True=Salida
   HighIOPinsData.bPin2InputOutputState = True 'False    ' Pin 2 False=Entrada, True=Salida
   HighIOPinsData.bPin3InputOutputState = True 'False    ' Pin 3 False=Entrada, True=Salida
   HighIOPinsData.bPin4InputOutputState = True 'False    ' Pin 4 False=Entrada, True=Salida
   
   HighIOPinsData.bPin5InputOutputState = True           ' Pin 5 False=Entrada, True=Salida
   HighIOPinsData.bPin6InputOutputState = True 'False    ' Pin 6 False=Entrada, True=Salida
   HighIOPinsData.bPin7InputOutputState = True           ' Pin 7 False=Entrada, True=Salida
   HighIOPinsData.bPin8InputOutputState = True           ' Pin 8 False=Entrada, True=Salida
   
' Configuración estado 0 ó de patillas de salida. Si Pin es salida,  False=0, True=1
   HighIOPinsData.bPin1LowHighState = False
   HighIOPinsData.bPin2LowHighState = False
   HighIOPinsData.bPin3LowHighState = False
   HighIOPinsData.bPin4LowHighState = True 'False
   
   HighIOPinsData.bPin5LowHighState = False
   HighIOPinsData.bPin6LowHighState = False
   HighIOPinsData.bPin7LowHighState = False
   HighIOPinsData.bPin8LowHighState = False
   
   SPI_Ret = SPI_SetHiSpeedDeviceGPIOs(SPIHandle, CSDisableStates, HighIOPinsData)
   If SPI_Ret <> FT_OK Then SPI_ErrorReport " USBSPI_GetDeviceInfo", SPI_Ret

' Configuración entradas/salida de las patillas del puerto bajo del SPI del FT2232H
   SPIdir = &HFF - pDI           ' Todo salidas excepto DI=input  (en prototipo &HFB)
   cSPIdir = Chr(SPIdir)         ' Ya lo dejo en cadena para no estar convirtiendo todo el rato
   SPIpins = &HFF                ' Estado inicial bus SPI: Todos los pines de salida a 1

' Configuración entradas/salida de las patillas del puerto alto GPIOH del FT2232H
   GPIOHdir = &HFF               ' Todo salidas
   GPIOHpins = &H8                ' JB: DIO_CS a 1 (Anteriormente: Inicialmente todo el byte alto a 0)

' Configuración dirección y estado de bits canal MPSSE Low (SPI) y High (GPIOH)
   FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSetPortL) & Chr(SPIpins) & cSPIdir           ' Cambio estado pines puerto SPI
   FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSetPortH) & Chr(GPIOHpins) & Chr(GPIOHdir)   ' Cambio estado pines puerto GPIOH
   
   BytesToWrite = Len(FT_Out_Buffer)                                                   ' Num. bytes a escribir en un microframe USB (125µs)
   FT_Sta = FT_Write(SPI_Hdl, FT_Out_Buffer, BytesToWrite, BytesWritten)
   If FT_Sta <> FT_OK Then SPI_ErrorReport "LHA_Config>FT_Write", FT_Sta

   LHA_Config = FT_Sta
End Function

'---------------------------------------------------------------------------------------------------
' LHA_ReadADC: Realiza una conversión A/D en todos los canales
'---------------------------------------------------------------------------------------------------
' Parámetros:
' ReadData()            Matriz unidimensional en la que se devuelve los datos de las conversiones A/D,
'                       ReadData(0) -> Ch1_ADC, ReadData(1) -> Ch2_ADC, ....
'                       Se redimensiona aquí según número de canales ADC (numADCChannels)
Public Function LHA_ReadADC(ReadData() As Integer) As Long
   Dim FT_Out_Buffer As String
   Dim FT_In_Buffer As String
   Dim BytesToWrite As Long, BytesWritten As Long
   Dim BytesToReceive As Long, ReceivesBytes As Long
   Dim BytesReturned As Long
   Dim c As Integer, b As Integer
   'xxxDim SPIpins As LHApins, SPIdir As LHApins, cSPIdir As String * 1
   'xxxDim GPIOHpins As LHA_GPIOHpins, GPIOHdir As LHA_GPIOHpins
   Dim DelayTconv       ' Contador bucle para esperar a fin de conversión ADC, ampliar con oversampling filtro
   
   On Error Resume Next
   
'          Tabla de patillas de salida del puerto L
'--------------------------------------------------------
'        NC   ,pADC2cs,pADCsoc,pADCcs,pDACcs,pDI,pDO,pSK    Definitivo con 2 DAC's
'      pADCos1,pADCos0,pADCsoc,pADCcs,pDACcs,pDI,pDO,pSK
'      GPIOL3, GPIOL2, GPIOL1, GPIOL0, CS,   DI, DO, SK
' &HF7=  1       1       1       1     0     1   1   1
' &HDF=  1       1       0       1     1     1   1   1
' &HFF=  1       1       1       1     1     1   1   1
' &HEF=  1       1       1       0     1     1   1   1
' &H0B=  0E      0E      0E      0E    1S    0E  1S  1S
' &HBB=  1S      0E      1S      1S    1S    0E  1S  1S
' &HFB=  1S      1S      1S      1S    1S    0E  1S  1S

' Configuración entradas/salida de las patillas del puerto bajo del SPI del FT2232H
   SPIdir = &HFF - pDI                       ' Todo salidas excepto DI=input  (en prototipo &HFB)
   cSPIdir = Chr(SPIdir)                     ' Ya lo dejo en cadena para no estar convirtiendo todo el rato
'zzz
SPIpins = &HFF                            ' Estado inicial bus SPI: Todos los pines de salida a 1

' Configuración entradas/salida de las patillas del puerto alto GPIOH del FT2232H
'xxx   GPIOHdir = &HFF                           ' Todo salidas
'xxx   GPIOHpins = &H0                           ' Inicialmente todo el byte alto a 0
 
' Retraso del tiempo de conversión en función del oversampling del filtro digital del ADC.
' OS0=2 ó 3, OS2=10 , OS4=26 , OS8=57, OS16=120, OS32=245, OS64=495
   DelayTconv = 2 * (2 ^ (2 * ADCFilterLevel))   ' Amplio el tiempo de espera fin conversión según oversampling del filtro
   Select Case ADCFilterLevel
      Case 0: DelayTconv = 2
      Case 1: DelayTconv = 10
      Case 2: DelayTconv = 26
      Case 3: DelayTconv = 57
      Case 4: DelayTconv = 120
      Case 5: DelayTconv = 245
      Case 6: DelayTconv = 495
   End Select
   
' Inicio de conversión ADC, pulso de bajada en CONVST A
   SPIpins = SPIpins - pADCsoc                                                      ' Bajo SOC_ADC=0, resto a 1
   FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSetPortL) & Chr(SPIpins) & cSPIdir  ' Cambio estado pines puerto SPI
   SPIpins = SPIpins + pADCsoc                                                      ' Subo SOC_ADC=1, todo a 1
   FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSetPortL) & Chr(SPIpins) & cSPIdir  ' Cambio estado pines puerto SPI
   
' Datos inutiles para esperar a que termine conversión (sin filtro dig. 2-4 µseg)
   For b = 1 To DelayTconv    ' Envío algo que no moleste: El dato anterior, MPSSE_CmdSetPortL+SPIins+cSPIdir
      FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSetPortL) & Chr(SPIpins) & cSPIdir
   Next b
   
' Lectura de datos ADC, bajo CS_ADC
   SPIpins = SPIpins - pADCcs                                                       ' Bajo ADC_CS=0, resto a 1
   FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSetPortL) & Chr(SPIpins) & cSPIdir
   ' Leer 12(11+1) bytes: 6 canales x 2 bytes/canal, -1 por que se lee uno más de lo indicado, en flanco de bajada de reloj
   FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdReadDI) & Chr((2 * numADCChannels) - 1) & Chr(&H0)
   FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSendInmediate)                      ' Ejecutar los comandos en cola.
   SPIpins = SPIpins + pADCcs
   FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSetPortL) & Chr(SPIpins) & cSPIdir  ' Subo ADC_CS=1, todo a 1
      
' ENVÍO EFECTIVO Y SIMULTÁNEO DE TODOS LOS COMANDOS Y DATOS DEL BUFFER........................................................
   BytesToWrite = Len(FT_Out_Buffer)                                                   ' Num. bytes a escribir en un microframe USB (125µs)
   ' Escritura de todo, nuevos valores de DAC, pulso CONVST y clocking de lectura de datos
   FT_Sta = FT_Write(SPI_Hdl, FT_Out_Buffer, BytesToWrite, BytesWritten)
   If FT_Sta <> FT_OK Then SPI_ErrorReport "FT_Write", FT_Sta
      
' ESPERA A LA EJECUCIÓN COMANDOS Y FINALIZACIÓN CONVERSIONES ADC..............................................................
   ' Recuperación de datos leidos, deben estar en el buffer de RxFIFO (2Kbytes)
   ' Espera a que se lean lo datos
   BytesToReceive = 2 * numADCChannels                   ' Por cada canal A/D debo recibir 2 bytes, 6Ch x 2 =12bytes
   Do                                                    '(ADC 16 bits, ¿que pasa con 18bits?)
      FT_Sta = Get_USB_Device_QueueStatus(ReceivesBytes) ' Bucle de espera a que llegen todo los bytes o marque error
   Loop Until (ReceivesBytes >= BytesToReceive) Or (FT_Sta <> FT_OK)
  
   If FT_Sta <> FT_OK Then                               ' Fallo algo salgo sin leer y marcando error
      SPI_ErrorReport "Get_USB_Device_QueueStatus", FT_Sta
      Exit Function
   End If
   
' LECTURA DE DATOS ADC RECIBIDOS...............................................................................................
   ' Decodificación y almacenamiento de los datos ADC recibidos
   FT_In_Buffer = Space(ReceivesBytes)                   ' Preparación-dimensionado de buffer de lectura
   ReDim ReadData(numADCChannels - 1)                    ' Dimensiono según el núm. de canales ADC
   FT_Sta = FT_Read(SPI_Hdl, FT_In_Buffer, ReceivesBytes, BytesReturned)
   If FT_Sta = FT_OK Then
      c = 0                                              ' Comienzo leyendo canal 0 ADC (V1 según datasheet)
      ' Los datos se transmite en modo big-endian (El byte de mayor peso primero, como en el formato Motorola)
      For b = 1 To BytesReturned Step 2
         ReadData(c) = CVIb(Mid(FT_In_Buffer, b, 2))     ' Big-endian H*256+L
         c = c + 1                                       ' Paso al sgte. canal ADC
      Next b
   Else
      SPI_ErrorReport "LHA_ReadADC", FT_Sta
   End If

   LHA_ReadADC = FT_Sta
   
End Function

'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''


'---------------------------------------------------------------------------------------------------
' LHA_WriteDIO: Envía un nuevo valor al convertidor D/A indicado
'---------------------------------------------------------------------------------------------------
' Parámetros:
' DIO_register             Comando del DIO
' WriteData                Dato a enviar al DIO compuesto por dirección y dato

Public Function LHA_WriteDIO(DIO_register As Byte, WriteData As Integer) As Long
   Dim FT_Out_Buffer As String
   Dim BytesToWrite As Long, BytesWritten As Long
   Dim DataH As Byte, DataL As Byte
   
  
       ' Configuración entradas/salida de las patillas del puerto bajo del SPI del FT4232H
  SPIdir = &HFF - pDI        ' Todo salidas excepto DI=input  (en prototipo &HFB)
   cSPIdir = Chr(SPIdir)      ' Ya lo dejo en cadena para no estar convirtiendo todo el rato
    
    'zzzz estaba FE
    
   SPIpins = SPIpins And (&HFE)
    
    'SPIpins = &HFE       ' Estado inicial bus SPI: Todos los pines de salida a 1, excepto reloj que va a cero.
                        ' JB: El resto de bits como estaban, clk se fuerza a cero.
    
  FT_Out_Buffer = Chr(MPSSE_CmdSetPortL) & Chr(SPIpins) & cSPIdir   ' Cambio estado pines puerto SPI
   
   
   GPIOHpins = GPIOHpins - pDIOcs  ' JB:Bajamos el CS_DIO
   GPIOHdir = &HFF   ' Todo salidas
   FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSetPortH) & Chr(GPIOHpins) & Chr(GPIOHdir)    ' Cambio estado pines puerto GPIOH
 
   
   
      
'  FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdWriteDO)          ' Orden: Transmitir datos en flanco de bajada de reloj
' FT_Out_Buffer = FT_Out_Buffer & Chr(&H11)
 FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdWriteDO2)
 
  FT_Out_Buffer = FT_Out_Buffer & Chr(2) & Chr(0)                ' Número de bytes menos 1 a transmitir (Dir y Datos)
      
   ' Primero configuramos la entrada/ salida de los pines
     
   Integer2HL WriteData, DataH, DataL                             ' Los datos a transmitir son el nº de registro DIO y 2 byte datos
   FT_Out_Buffer = FT_Out_Buffer & Chr(DIO_register) & Chr(DataH) & Chr(DataL)     ' Datos a escribir en DIO (Dir y Datos)
   FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSendInmediate)                     ' Ejecutar los comandos en cola.

   GPIOHpins = GPIOHpins + pDIOcs
   FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSetPortH) & Chr(GPIOHpins) & Chr(GPIOHdir)    ' Cambio estado pines puerto GPIOH
   
   
   ' JB: El reloj vuelve a 1
     
     
 '  SPIpins = (SPIpins Or (&H1)) ' Forzamos el bit de reloj a 1
     
   '  SPIpins = &HFF       ' Estado inicial bus SPI: Todos los pines de salida a 1
''''''''''''''''''''''''' FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSetPortL) & Chr(SPIpins) & cSPIdir
   
   
   
' ENVÍO EFECTIVO Y SIMULTÁNEO DE TODOS LOS COMANDOS Y DATOS DEL BUFFER........
   BytesToWrite = Len(FT_Out_Buffer)                                                   ' Num. bytes a escribir en un microframe USB (125µs)
   
   
  ' Debug.Print "Arguments Passed: " & FT_Out_Buffer
   Debug.Print "Arguments Conver: "; HexString(FT_Out_Buffer)
   
   
 '  Debug.Print &HF; FT_Out_Buffer
   
   
  'Text1_Change
  ' Text1.Text = FT_Out_Buffer
  
  'lstDevices.AddItem "paco"
  
 ' Text1_Change
   
   FT_Sta = FT_Write(SPI_Hdl, FT_Out_Buffer, BytesToWrite, BytesWritten)
   
   If FT_Sta <> FT_OK Then
       SPI_ErrorReport "FT_Write", FT_Sta
   End If
   
   LHA_WriteDIO = FT_Sta
   
End Function


    Public Function HexString(EvalString As String) As String
    Dim intStrLen As Integer
    Dim intLoop As Integer
    Dim strHex As String
    EvalString = Trim(EvalString)
    intStrLen = Len(EvalString)
    For intLoop = 1 To intStrLen
    strHex = strHex & " " & Right$("0" & Hex(Asc(Mid(EvalString, intLoop, 1))), 2)
    Next
    HexString = strHex
    End Function
    




'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'---------------------------------------------------------------------------------------------------
' LHA_WriteDAC: Envía un nuevo valor al convertidor D/A indicado
'---------------------------------------------------------------------------------------------------
' Parámetros:
' DACchannel (0 a 3)       Número del canal DAC (0 a 3) donde se escribiran los datos
' WriteData                Dato a enviar al DAC indicado por DACchannel
'                          +10V-1LSB->32767, 0V->0, -10V->-32768
Public Function LHA_WriteDAC(DACchannel As Byte, WriteData As Integer, selDAC As Boolean) As Long
   Dim FT_Out_Buffer As String
   Dim BytesToWrite As Long, BytesWritten As Long
   Dim DataH As Byte, DataL As Byte
   'xxxDim SPIpins As LHApins, SPIdir As LHApins, cSPIdir As String * 1
   
'          Tabla de patillas de salida del puerto L
'--------------------------------------------------------
'        NC   ,pADC2cs,pADCsoc,pADCcs,pDACcs,pDI,pDO,pSK    Definitivo con 2 DAC's
'      pADCos1,pADCos0,pADCsoc,pADCcs,pDACcs,pDI,pDO,pSK
'      GPIOL3, GPIOL2, GPIOL1, GPIOL0, CS,   DI, DO, SK
' &HF7=  1       1       1       1     0     1   1   1
' &HDF=  1       1       0       1     1     1   1   1
' &HFF=  1       1       1       1     1     1   1   1
' &HEF=  1       1       1       0     1     1   1   1
' &H0B=  0E      0E      0E      0E    1S    0E  1S  1S
' &HBB=  1S      0E      1S      1S    1S    0E  1S  1S
' &HFB=  1S      1S      1S      1S    1S    0E  1S  1S
  
' Configuración entradas/salida de las patillas del puerto bajo del SPI del FT4232H
   SPIdir = &HFF - pDI                       ' Todo salidas excepto DI=input  (en prototipo &HFB)
   cSPIdir = Chr(SPIdir)                     ' Ya lo dejo en cadena para no estar convirtiendo todo el rato
   'zzzz
   SPIpins = &HFF                            ' Estado inicial bus SPI: Todos los pines de salida a 1
   
' PREPARACIÓN DE BUFFER DE COMANDOS Y DATOS PARA REALIZAR CONVERSIONES DAC y ADC..............................................
' Escritura de un nuevo valor de DAC
    
   If selDAC Then
        SPIpins = SPIpins - pDACcs                                                       ' Bajo CS_DAC=0, resto a 1
   Else
        SPIpins = SPIpins - pDAC2cs
   End If
'''  SPIpins = SPIpins - pDAC2cs

   FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSetPortL) & Chr(SPIpins) & cSPIdir  ' Cambio estado pines puerto SPI
   FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdWriteDO)                            ' Orden: Transmitir datos en flanco de bajada de reloj
   FT_Out_Buffer = FT_Out_Buffer & Chr(2) & Chr(0)                                  ' Número de bytes menos 1 a transmitir (L y H)
   Integer2HL WriteData, DataH, DataL                                               ' Los datos a transmitir son el nº de registro DAC y 2 byte datos
   FT_Out_Buffer = FT_Out_Buffer & Chr(DACchannel + 4) & Chr(DataH) & Chr(DataL)    ' El registro del DAC0=4, DAC1=5... Datos a escribir en DAC (H y L)
   FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSendInmediate)                      ' Ejecutar los comandos en cola.
''''   SPIpins = SPIpins + pDACcs                                                       ' Subo CS_DAC=1, todo a 1, DO=1 para que al leer D=1->Bit DB23 ShiftReg DAC R/W=1
If selDAC Then
        SPIpins = SPIpins + pDACcs                                                       ' Bajo CS_DAC=0, resto a 1
   Else
        SPIpins = SPIpins + pDAC2cs
   End If
''''  SPIpins = SPIpins + pDAC2cs
 
   FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSetPortL) & Chr(SPIpins) & cSPIdir  ' Cambio estado pines puerto SPI
   
 Debug.Print "Arguments Conver: "; HexString(FT_Out_Buffer)
   
' ENVÍO EFECTIVO Y SIMULTÁNEO DE TODOS LOS COMANDOS Y DATOS DEL BUFFER........................................................
   BytesToWrite = Len(FT_Out_Buffer)                                                   ' Num. bytes a escribir en un microframe USB (125µs)
   ' Escritura de todo, nuevos valores de DAC, pulso CONVST y clocking de lectura de datos
   FT_Sta = FT_Write(SPI_Hdl, FT_Out_Buffer, BytesToWrite, BytesWritten)
   If FT_Sta <> FT_OK Then SPI_ErrorReport "FT_Write", FT_Sta
   
   LHA_WriteDAC = FT_Sta
End Function

' Parámetros:
' DACchannel (0 a 3)       Número del canal DAC (0 a 3) donde se escribiran los datos
' WriteData()              Matriz unidimensional que contiene los datos a enviar al DAC indicado por DACchannel
' ReadData()               Matriz multidimensional donde se devuelven los datos de las conversiones del ADC.
'                          ReadData(0,10) -> Canal 0 ADC (V1 según datasheet), Muestra nº 10 ("0 based")
'                          La matriz es redimensionada internamente según los canales del ADC y el nº de datos escritos en DAC (WriteData)
' ScanDelay (0 a 32767)    Indicador de la pausa entre muestras (0= sin retraso, un dato tras otro),
'                          Por cada unidad se transmitiran 3 bytes "inútiles" para perder tiempo. 100useg->ScanDelay=300 Confirmar???
Public Function LHA_Scan(DACchannel As Byte, WriteData() As Integer, ReadData() As Integer, ScanDelay As Integer) As Long
   Dim FT_Out_Buffer As String
   Dim FT_In_Buffer As String
   Dim BytesToWrite As Long, BytesWritten As Long
   Dim DataH As Byte, DataL As Byte
   Dim i As Long, b As Long, c As Integer
   Dim BytesToReceive As Long, ReceivesBytes As Long
   Dim BytesReturned As Long
   'Dim SPIpins As LHApins, SPIdir As LHApins, cSPIdir As String * 1
   Dim DelayTconv As Integer       ' Contador bucle para esperar a fin de conversión ADC, ampliar con oversampling filtro
   
   
'          Tabla de patillas de salida del puerto L
'--------------------------------------------------------
'        NC   ,pADC2cs,pADCsoc,pADCcs,pDACcs,pDI,pDO,pSK    Definitivo con 2 DAC's
'      pADCos1,pADCos0,pADCsoc,pADCcs,pDACcs,pDI,pDO,pSK
'      GPIOL3, GPIOL2, GPIOL1, GPIOL0, CS,   DI, DO, SK
' &HF7=  1       1       1       1     0     1   1   1
' &HDF=  1       1       0       1     1     1   1   1
' &HFF=  1       1       1       1     1     1   1   1
' &HEF=  1       1       1       0     1     1   1   1
' &H0B=  0E      0E      0E      0E    1S    0E  1S  1S
' &HBB=  1S      0E      1S      1S    1S    0E  1S  1S
' &HFB=  1S      1S      1S      1S    1S    0E  1S  1S
  
' Configuración entradas/salida de las patillas del puerto bajo del SPI del FT4232H
   SPIdir = &HFF - pDI                       ' Todo salidas excepto DI=input  (en prototipo &HFB)
   cSPIdir = Chr(SPIdir)                     ' Ya lo dejo en cadena para no estar convirtiendo todo el rato
   'zzz
   SPIpins = &HFF                            ' Estado inicial bus SPI: Todos los pines de salida a 1
   
' Configuración entradas/salida de las patillas del puerto alto GPIOH del FT2232H
'xxx   GPIOHdir = &HFF                           ' Todo salidas
'xxx   GPIOHpins = &H0                           ' Inicialmente todo el byte alto a 0
 
' Retraso del tiempo de conversión en función del oversampling del filtro digital del ADC.
' OS0=2 ó 3, OS2=10 , OS4=26 , OS8=57, OS16=120, OS32=245, OS64=495
   DelayTconv = 2 * (2 ^ (2 * ADCFilterLevel))   ' Amplio el tiempo de espera fin conversión según oversampling del filtro
   Select Case ADCFilterLevel
      Case 0: DelayTconv = 2
      Case 1: DelayTconv = 10
      Case 2: DelayTconv = 26
      Case 3: DelayTconv = 57
      Case 4: DelayTconv = 120
      Case 5: DelayTconv = 245
      Case 6: DelayTconv = 495
   End Select
   
' PREPARACIÓN DE BUFFER DE COMANDOS Y DATOS PARA REALIZAR CONVERSIONES DAC y ADC..............................................
   For i = 0 To UBound(WriteData)
      ' Escritura de un nuevo valor de DAC
      SPIpins = SPIpins - pDACcs   ' Bajo CS_DAC=0, resto a 1
    ''JB' meter seleccion dac
    
      FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSetPortL) & Chr(SPIpins) & cSPIdir  ' Cambio estado pines puerto SPI
      FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdWriteDO)                            ' Orden: Transmitir datos en flanco de bajada de reloj
      FT_Out_Buffer = FT_Out_Buffer & Chr(2) & Chr(0)                                  ' Número de bytes menos 1 a transmitir (L y H)
      Integer2HL WriteData(i), DataH, DataL                                            ' Los datos a transmitir son el nº de registro DAC y 2 byte datos
      FT_Out_Buffer = FT_Out_Buffer & Chr(DACchannel + 4) & Chr(DataH) & Chr(DataL)    ' El registro del DAC0=4, DAC1=5... Datos a escribir en DAC (H y L)
      FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSendInmediate)                      ' Ejecutar los comandos en cola.
      SPIpins = SPIpins + pDACcs                                                       ' Subo CS_DAC=1, todo a 1, DO=1 para que al leer D=1->Bit DB23 ShiftReg DAC R/W=1
      FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSetPortL) & Chr(SPIpins) & cSPIdir  ' Cambio estado pines puerto SPI
   
      ' Inicio de conversión ADC, pulso de bajada en CONVST A
      SPIpins = SPIpins - pADCsoc                                                      ' Bajo SOC_ADC=0, resto a 1
      FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSetPortL) & Chr(SPIpins) & cSPIdir  ' Cambio estado pines puerto SPI
      SPIpins = SPIpins + pADCsoc                                                      ' Subo SOC_ADC=1, todo a 1
      FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSetPortL) & Chr(SPIpins) & cSPIdir  ' Cambio estado pines puerto SPI
   
      ' Datos inutiles para esperar a que termine conversión (sin filtro dig. 2-4 µseg)
      For b = 1 To DelayTconv    ' Envío algo que no moleste: El dato anterior, MPSSE_CmdSetPortL+SPIins+cSPIdir
         FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSetPortL) & Chr(SPIpins) & cSPIdir
      Next b
   
      ' Lectura de datos ADC, bajo CS_ADC
      SPIpins = SPIpins - pADCcs                                                       ' Bajo ADC_CS=0, resto a 1
      FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSetPortL) & Chr(SPIpins) & cSPIdir
      ' Leer 12(11+1) bytes: 6 canales x 2 bytes/canal, -1 por que se lee uno más de lo indicado, en flanco de bajada de reloj
      FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdReadDI) & Chr((2 * numADCChannels) - 1) & Chr(&H0)
      FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSendInmediate)                      ' Ejecutar los comandos en cola.
      SPIpins = SPIpins + pADCcs
      FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSetPortL) & Chr(SPIpins) & cSPIdir  ' Subo ADC_CS=1, todo a 1
      
      ' Datos inutiles para establecer fijar velocidad de muestreo
      For b = 1 To ScanDelay    ' Envío algo que no moleste: El dato anterior, MPSSE_CmdSetPortL+SPIins+cSPIdir
         FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSetPortL) & Chr(SPIpins) & cSPIdir
      Next b
   Next i
   
   
      Debug.Print "Arguments Conver SCAN: "; HexString(FT_Out_Buffer)
     
' ENVÍO EFECTIVO Y SIMULTÁNEO DE TODOS LOS COMANDOS Y DATOS DEL BUFFER........................................................
   BytesToWrite = Len(FT_Out_Buffer)                                                   ' Num. bytes a escribir en un microframe USB (125µs)
   ' La formula de BytesToWrite = 35*NumPuntosADC/DAC + 35, Para 400 muetras -> 14035 bytes
   ' Escritura de todo, nuevos valores de DAC, pulso CONVST y clocking de lectura de datos

   
   FT_Sta = FT_Write(SPI_Hdl, FT_Out_Buffer, BytesToWrite, BytesWritten)
   If FT_Sta <> FT_OK Then SPI_ErrorReport "FT_Write", FT_Sta
   
   
' ESPERA A LA EJECUCIÓN COMANDOS Y FINALIZACIÓN CONVERSIONES ADC..............................................................
   ' Recuperación de datos leidos, deben estar en el buffer de RxFIFO (2Kbytes)
   ' Espera a que se lean lo datos
   BytesToReceive = (UBound(WriteData) + 1) * 2 * numADCChannels  ' Por cada dato DAC envíado debo recibir 2 bytes, 6Ch x 2b=12bytes
   Do                                                             ' (ADC 16 bits, ¿que pasa con 18bits?)
      FT_Sta = Get_USB_Device_QueueStatus(ReceivesBytes)          ' Bucle de espera a que llegen todo los bytes o marque error
   Loop Until (ReceivesBytes >= BytesToReceive) Or (FT_Sta <> FT_OK)

   If FT_Sta <> FT_OK Then                                        ' Fallo algo salgo sin leer y marcando error
      SPI_ErrorReport "Get_USB_Device_QueueStatus", FT_Sta
      Exit Function
   End If

' LECTURA DE DATOS ADC RECIBIDOS...............................................................................................
   ' Decodificación y almacenamiento de los datos ADC recibidos
   FT_In_Buffer = Space(ReceivesBytes)                            ' Preparación-dimensionado de buffer de lectura
   ReDim ReadData(numADCChannels - 1, UBound(WriteData))          ' Dimensiono matriz datos ADC para todos los canales y muestras.
   FT_Sta = FT_Read(SPI_Hdl, FT_In_Buffer, ReceivesBytes, BytesReturned)
   If FT_Sta = FT_OK Then
      c = 0: i = 0                                                ' Reset contadores de num. canal y muestras respectivamente
      For b = 1 To BytesReturned Step 2                           ' Cada 2 bytes(16bits) un dato ADC
         ReadData(c, i) = CVIb(Mid(FT_In_Buffer, b, 2))           ' Datos en formato Big-endian H*256+L
         c = c + 1                                                ' Paso al sgte. canal ADC
         If c = numADCChannels Then                               ' Una vez leidos todos los canales de un muestreo
            i = i + 1                                             ' Avanzo el indice de la matriz de datos leidos
            c = 0                                                 ' E vuelvo a empezar desde del canal 0 del ADC (V1 según datasheet)
         End If
      Next b
   Else
      SPI_ErrorReport "LHA_Scan", FT_Sta
   End If
   
   LHA_Scan = FT_Sta
End Function





'******************************************************************************************
'******************************************************************************************
'                                 FUNCIONES DE USO GENÉRICO
'******************************************************************************************
'******************************************************************************************

'-------------------------------------------------------------------------------------
'  CVI
'-------------------------------------------------------------------------------------
' La famosa función CVI de basic DOS ahora en Windows
' Extrae un entero de una cadena de dos bytes
' En modo little endian (Intel) Lbyte primero y luego Hbyte
Public Function CVI(sX As String) As Integer
   Dim iTemp As Integer
   
   If Len(sX) <> 2 Then
      Err.Raise 5          ' El argumento o la llamada al procedimiento no son válidos
      Exit Function
   End If
   
   CopyMemory iTemp, ByVal sX, 2
   CVI = iTemp
End Function


' En modo big endian (Motorola) Hbyte primero y luego Lbyte
Public Function CVIb(sX As String) As Integer
   Dim iTemp As Integer
   
   If Len(sX) <> 2 Then
      Err.Raise 5          ' El argumento o la llamada al procedimiento no son válidos
      Exit Function
   End If
   
   CopyMemory iTemp, ByVal sX, 2
   iTemp = ntohs(iTemp)    ' Intercambio de endian de little a big
   CVIb = iTemp
End Function


Public Sub Integer2HL(inData As Integer, outDataH As Byte, outDataL As Byte)
   outDataH = (inData And &HFF00&) / &H100
   outDataL = inData And &HFF
End Sub

Function CVL(sX As String) As Long
   Dim lTemp As Long
   
   If Len(sX) <> 4 Then
      Err.Raise 5          ' El argumento o la llamada al procedimiento no son válidos
      Exit Function
   End If
   CopyMemory lTemp, ByVal sX, 4
   CVL = lTemp
End Function

' Devuelve el nº de dimensiones de una matriz
Private Function ArrayDims(Arr As Variant) As Integer
   Dim i As Integer, bound As Long
   
   On Error Resume Next
   
   For i = 1 To 60
      bound = LBound(Arr, i)
      If Err Then
         ArrayDims = i - 1
         Exit Function
      End If
   Next
End Function



'---------------------------------------------------------------------------------------------------
' LHA_WriteAtt: Envía un nuevo valor al convertidor D/A indicado
'---------------------------------------------------------------------------------------------------
' Parámetros:
' DIO_register             Comando del DIO
' WriteData                Dato a enviar al DIO compuesto por dirección y dato

Public Function LHA_WriteAtt(Att_register As Byte, WriteData As Integer) As Long
   Dim FT_Out_Buffer As String
   Dim BytesToWrite As Long, BytesWritten As Long
   Dim DataH As Byte, DataL As Byte
   
   
   '''''''''''''''
    SPIdir = &HFF - pDI                       ' Todo salidas excepto DI=input  (en prototipo &HFB)
   cSPIdir = Chr(SPIdir)                     ' Ya lo dejo en cadena para no estar convirtiendo todo el rato
   'zzzz   SPIpins = &HFF                            ' Estado inicial bus SPI: Todos los pines de salida a 1
   
   SPIpins = SPIpins - pAttcs
   
   SPIpins = SPIpins And (&HFE)             ' Equivalente a SPIpins = SPIpins - pSK

   FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSetPortL) & Chr(SPIpins) & cSPIdir
        
   '''''''''''
           
'  FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdWriteDO)          ' Orden: Transmitir datos en flanco de bajada de reloj
' FT_Out_Buffer = FT_Out_Buffer & Chr(&H11)
 FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdWriteDO2)
 
  FT_Out_Buffer = FT_Out_Buffer & Chr(2) & Chr(0)                ' Número de bytes menos 1 a transmitir (Dir y Datos)
      
   ' Primero configuramos la entrada/ salida de los pines
     
   Integer2HL WriteData, DataH, DataL                             ' Los datos a transmitir son el nº de registro DIO y 2 byte datos
   FT_Out_Buffer = FT_Out_Buffer & Chr(Att_register) & Chr(DataH) & Chr(DataL)     ' Datos a escribir en DIO (Dir y Datos)
   FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSendInmediate)                     ' Ejecutar los comandos en cola.

   SPIpins = SPIpins + pAttcs '+ pSK
   
   FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSetPortL) & Chr(SPIpins) & cSPIdir
   
   
   ' JB: El reloj vuelve a 1
     
'   SPIpins = (SPIpins Or (&H1)) ' Forzamos el bit de reloj a 1
     
   '  SPIpins = &HFF       ' Estado inicial bus SPI: Todos los pines de salida a 1
' FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSetPortL) & Chr(SPIpins) & cSPIdir
   
   
   
' ENVÍO EFECTIVO Y SIMULTÁNEO DE TODOS LOS COMANDOS Y DATOS DEL BUFFER........
   BytesToWrite = Len(FT_Out_Buffer)                                                   ' Num. bytes a escribir en un microframe USB (125µs)
   
   
  ' Debug.Print "Arguments Passed: " & FT_Out_Buffer
   Debug.Print "Arguments Conver: "; HexString(FT_Out_Buffer)
   
   
 '  Debug.Print &HF; FT_Out_Buffer
   
   
  'Text1_Change
  ' Text1.Text = FT_Out_Buffer
  
  'lstDevices.AddItem "paco"
  
 ' Text1_Change
   
   FT_Sta = FT_Write(SPI_Hdl, FT_Out_Buffer, BytesToWrite, BytesWritten)
   
   If FT_Sta <> FT_OK Then
       SPI_ErrorReport "FT_Write", FT_Sta
   End If
   
   LHA_WriteAtt = FT_Sta
   
End Function


Public Function Reloja0() As Long
   Dim FT_Out_Buffer As String
   Dim BytesToWrite As Long, BytesWritten As Long
  ' Dim DataH As Byte, DataL As Byte

SPIpins = SPIpins - pSK

BytesToWrite = Len(FT_Out_Buffer)

  FT_Out_Buffer = Chr(MPSSE_CmdSetPortL) & Chr(SPIpins) & cSPIdir
    
   FT_Sta = FT_Write(SPI_Hdl, FT_Out_Buffer, BytesToWrite, BytesWritten)
    
    
End Function


Public Function PreparaDatos(DACchannel As Byte, WriteData As Integer, selDAC As Boolean) As String
   Dim FT_Out_Buffer As String
   Dim BytesToWrite As Long, BytesWritten As Long
   Dim DataH As Byte, DataL As Byte

  
' Configuración entradas/salida de las patillas del puerto bajo del SPI del FT4232H
   SPIdir = &HFF - pDI                       ' Todo salidas excepto DI=input  (en prototipo &HFB)
   cSPIdir = Chr(SPIdir)                     ' Ya lo dejo en cadena para no estar convirtiendo todo el rato
   'zzzz
   SPIpins = &HFF                            ' Estado inicial bus SPI: Todos los pines de salida a 1
   
' PREPARACIÓN DE BUFFER DE COMANDOS Y DATOS PARA REALIZAR CONVERSIONES DAC y ADC..............................................
' Escritura de un nuevo valor de DAC
    
   If selDAC Then
        SPIpins = SPIpins - pDACcs                                                       ' Bajo CS_DAC=0, resto a 1
   Else
        SPIpins = SPIpins - pDAC2cs
   End If
'''  SPIpins = SPIpins - pDAC2cs

   FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSetPortL) & Chr(SPIpins) & cSPIdir  ' Cambio estado pines puerto SPI
   FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdWriteDO)                            ' Orden: Transmitir datos en flanco de bajada de reloj
   FT_Out_Buffer = FT_Out_Buffer & Chr(2) & Chr(0)                                  ' Número de bytes menos 1 a transmitir (L y H)
   Integer2HL WriteData, DataH, DataL                                               ' Los datos a transmitir son el nº de registro DAC y 2 byte datos
   FT_Out_Buffer = FT_Out_Buffer & Chr(DACchannel + 4) & Chr(DataH) & Chr(DataL)    ' El registro del DAC0=4, DAC1=5... Datos a escribir en DAC (H y L)
   FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSendInmediate)                      ' Ejecutar los comandos en cola.
''''   SPIpins = SPIpins + pDACcs                                                       ' Subo CS_DAC=1, todo a 1, DO=1 para que al leer D=1->Bit DB23 ShiftReg DAC R/W=1
If selDAC Then
        SPIpins = SPIpins + pDACcs                                                       ' Bajo CS_DAC=0, resto a 1
   Else
        SPIpins = SPIpins + pDAC2cs
   End If
''''  SPIpins = SPIpins + pDAC2cs
 
   FT_Out_Buffer = FT_Out_Buffer & Chr(MPSSE_CmdSetPortL) & Chr(SPIpins) & cSPIdir  ' Cambio estado pines puerto SPI
   
PreparaDatos = FT_Out_Buffer

End Function
