unit DataAdcquisition;

interface

uses
  Windows, Messages, SysUtils, DateUtils, StdCtrls, Spin, Controls, Classes, Graphics, Forms, Dialogs, Scanner1,
  Liner, FT2232CSPIUnit, SPIDLLFuncUnit,D2XXUnit, StrUtils, WINSOCK, PID,
  ExtCtrls ;

  Const
  FT_DLL_Name = 'ftd2xx.dll';
  TRAZAS = false;       // Para definir si se lanzan mensajes o no
  MPSSE_BadCommand = $FA;         // If detects a bad command send back 2 bytes to the PC: 0xFA + the bad command byte.
  MPSSE_CmdWriteDO = $10;         // Clock Data Bytes Out on +ve Clock Edge MSB First (no Read)
  MPSSE_CmdWriteDO2 = $11;        // Clock Data Bytes Out on -ve Clock Edge MSB First (no Read)
  MPSSE_CmdSendInmediate = $87;   // This will make the chip flush its buffer back to the PC.
  MPSSE_CmdSetPortL = $80;        // Set Data Bits Low Byte
  MPSSE_CmdSetPortH = $82;        // Set Data Bits High Byte
  MPSSE_CmdReadPortH = $83;       // Read Data Bits High Byte
  MPSSE_CmdReadDI = $20;          // Clock Data Bytes In on +ve Clock Edge MSB First (no Write) Lengh=0->1byte
  NUM_ADCs = 6;                   // Número de ADCs que podemos leer de la electrónica

type

  TLHApins = (
   pSK = $01,        // Serial clock
   pDO = $02,        // SPI MOSI (Master Output, Slave(ADC/DAC) Input)
   pDI = $04,        // SPI MISO (Master Input, Slave(ADC/DAC) Output)
   pDACcs = $08,     // CS_DAC   (Chip Select DAC0-3), Salida
   pADCcs = $10,     // CS_ADC   (Chip Select ADC), Salida
   pDAC2cs = $20,    // CS_DAC2  (Chip Select DAC4-7), Salida
   pAttcs = $40,     // CS_ATT   (Chip select atenuadores)
   pADCsoc = $80);   // CONVSTA  (Start of Convertion ADC), Salida

  TLHA_GPIOHpins = (
   pADCos0 = $01,    // OS0 Filtro digital ADC, Salida - Nacho: Creo que en este programa no se usa
   pADCos1 = $02,    // OS1 Filtro digital ADC, Salida - Nacho: Creo que en este programa no se usa
   pADCos2 = $04,    // OS2 Filtro digital ADC, Salida - Nacho: Creo que en este programa no se usa
   pDIOcs = $08);    // Nacho: Creo que en este programa no se usa

  AdcTakeAction = (
   AdcNone = $0,         // No hace nada, no tiene mucho sentido usarla
   AdcWriteCommand = $1, // Escribe el comando que pide los datos
   AdcReadData = $2,     // Lee los datos que hayan llegado
   AdcWriteRead = $3);   // Ambas acciones

  TMatrixInt = array of array of Integer;
  TVectorDouble = array of Double;

  TForm10 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Button2: TButton;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    Label3: TLabel;
    ScrollBar1: TScrollBar;
    Label4: TLabel;
    SpinEdit3: TSpinEdit;
    Button3: TButton;
    Label5: TLabel;
    Label6: TLabel;
    Button4: TButton;
    Button5: TButton;
    Label7: TLabel;
    Edit1: TEdit;
    Label8: TLabel;
    tmr55: TTimer;
    procedure Button1Click(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    function InitDataAcq : boolean ;
    function dac_set(ndac,valor:integer; BufferOut: PAnsiChar) : integer;
    function adc_take(chn,mux,n:integer) : double;
    function adc_take_all(n:Integer; action: AdcTakeAction; BufferOut: PAnsiChar) : TVectorDouble ;
    function ramp_take(ndac, value1, value2, dataSet, npoints, jump, delay: Integer; blockAcq: Boolean): boolean;
    function send_buffer(bufferToSend: PAnsiChar; bytesToSend: Integer): FTC_STATUS;
    procedure set_dio_port(value: Word);
    // para las electrónicas con atenuador. Si Form1.VersionDivider=False, entonces es todo como
    // cuando no hay atenuador. Si no, es que hay atenuador.
    procedure set_attenuator(DACAttNr: Integer; value: double);
    //procedure set_attenuator(value: Double);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    attenuator: Double;
    StopAction: Boolean;
  end;

var
  Form10: TForm10;
  SupraSPI_Hdl:Dword;
  simulating: Boolean;
  simulatedDac: array[0..7] of Integer;
  Buffer:String[50]; //En ppio. hay espacio de sobra con esta cantidad


implementation

uses Config_Liner;
  Function SPI_GetHiSpeedDeviceNameLocIDChannel(dwDeviceNameIndex: DWORD; lpDeviceNameBuffer: LPSTR; dwDeviceNameBufferSize: DWORD; lpdwLocationID: LPDWORD; lpChannelBuffer: LPSTR; dwChannelBufferSize: DWORD; lpdwHiSpeedDeviceType: LPDWORD):FTC_STATUS; stdcall ; External FT2232CSPI_DLL_Name name 'SPI_GetHiSpeedDeviceNameLocIDChannel';
  Function SPI_OpenHiSpeedDevice( DeviceName:String;  LocationID:Integer;Channel: String; ftHandle:pointer):FTC_STATUS;     stdcall ; External FT2232CSPI_DLL_Name name 'SPI_OpenHiSpeedDevice';
  Function SPI_InitDevice  (ftHandle:dword; ClockDivisor:Dword ) : FTC_STATUS;    stdcall ; External FT2232CSPI_DLL_Name name 'SPI_InitDevice' ;
  Function SPI_SetDeviceLatencyTimer (ftHandle:dword; Timervalue:Dword)   : FTC_STATUS;    stdcall ; External FT2232CSPI_DLL_Name name 'SPI_SetDeviceLatencyTimer' ;
  Function SPI_SetHiSpeedDeviceGPIOs(fthandle: Dword; ChipSelectsDisableStates: PFtcChipSelectPins; HighInputOutputPins: PFtcInputOutputPins): FTC_STATUS; stdcall ; External FT2232CSPI_DLL_Name name 'SPI_SetHiSpeedDeviceGPIOs';
  Function SPI_Close (fthandle: Dword): FTC_STATUS; stdcall ; External FT2232CSPI_DLL_Name name 'SPI_Close';

  Function FT_Read ( lngHandle:dword; lpszBuffer: Pointer;  lngBufferSize:dword;lngBytesReturned:Pointer):FTC_STATUS ; stdcall ; External otra_DLL_Name name 'FT_Read';
  Function FT_GetQueueStatus (lngHandle:dword; lngRxBytes:pointer ):   FTC_STATUS ; stdcall ; External otra_DLL_Name name 'FT_GetQueueStatus';
  Function FT_Write(ftHandle:Dword; FTOutBuf : Pointer; BufferSize : LongInt; ResultPtr : Pointer ) : FTC_STATUS ; stdcall ; External otra_DLL_Name name 'FT_Write';
  Function FT_Purge(ftHandle:Dword; dwMask:Dword):  FTC_STATUS ; stdcall ; External otra_DLL_Name name 'FT_Purge';
  Function FT_SetChars(ftHandle:Dword; uEventCh, uEventChEn, uErrorCh, uErrorChEn: Char):  FTC_STATUS ; stdcall ; External otra_DLL_Name name 'FT_SetChars';
  Function FT_ResetDevice(ftHandle:Dword):  FTC_STATUS ; stdcall ; External otra_DLL_Name name 'FT_ResetDevice';
  Function FT_SetFlowControl(ftHandle:Dword; usFlowControl: Word; uXon, uXoff: Char):  FTC_STATUS ; stdcall ; External otra_DLL_Name name 'FT_SetFlowControl';

{$R *.DFM}

// Funciones auxiliares


// HexToString
// Convierte pares de valores de números hexadecimales codificados en ASCII a su equivalente sin codificar.
// Ejemplo:
// HexToString('4142') -> 'AB' o lo que es lo mismo $4142 (si el endianness es el adecuado).
function HexToString(H: String): String;
var I: Integer;
begin
  Result:= '';
  for I := 1 to length (H) div 2 do
    Result:= Result+Char(StrToInt('$'+Copy(H,(I-1)*2+1,2)));
end;


Function Get_USB_Device_QueueStatus(ReceivesBytes: Dword): Dword;
//' return the number of bytes waiting to be read
begin
   Result:= FT_GetQueueStatus(SupraSPI_Hdl, @ReceivesBytes);
End;

Function TForm10.InitDataAcq : boolean  ;

 var LocationID:Integer;
 var SPI_Ret:Integer;    SPI_Hdl:Dword;
 var sTexto: String;
 var DeviceType: DWORD;
 var nameBuffer: array[1..50] of AnsiChar;
 var channelBuffer:  array[1..50] of AnsiChar;

 var BytesToWrite: Integer;
 var BytesWritten:Integer;

 var miestructura2:FtcChipSelectPins;
 var entradassalidas:FtcInputOutputPins;


begin
  simulating := false;
  SPI_Ret :=0;
 Result:=False;

 SPI_GetHiSpeedDeviceNameLocIDChannel(0, @nameBuffer, 50, @LocationID, @channelBuffer, 50, @DeviceType);
 SPI_Ret := SPI_OpenHiSpeedDevice(nameBuffer, LocationID, channelBuffer, @SPI_Hdl) ;
 Str( SPI_Ret, sTexto );

 SupraSPI_Hdl:=  SPI_Hdl;

 If SPI_Ret <> 0  then
 begin
 if not simulating then MessageDlg('No se puede abrir: ' +Stexto, mtError, [mbOk], 0);
 exit;
 end ;
 // else  MessageDlg('Abierto correctamente', mtError, [mbOk], 0);

 SPI_Ret :=  SPI_InitDevice(SPI_Hdl, 2); // Con los retardos que hay ahora en los ADCs podría funcionar con 0 e ir más rápido
 Str( SPI_Ret, sTexto );

 If SPI_Ret <> 0  then
 begin
 MessageDlg('No se puede iniciar: ' +Stexto, mtError, [mbOk], 0) ;
 exit;
 end;
// else  MessageDlg('Inicializado correctamente', mtError, [mbOk], 0);

 FT_ResetDevice(SPI_Hdl);

 SPI_Ret := FT_SetChars(SPI_Hdl, Char(0), Char(0), Char(0), Char(0));
 Str( SPI_Ret, sTexto );

 SPI_Ret := SPI_SetDeviceLatencyTimer  (SPI_Hdl,2);
 Str( SPI_Ret, sTexto );

 If SPI_Ret <> 0 then
 begin
  if not simulating then MessageDlg('No se puede configurar la latencia: ' + Stexto, mtError, [mbOk], 0) ;
  exit;
 end;
  // else  MessageDlg('Latencia correcta', mtError, [mbOk], 0);

   FT_SetFlowControl (SPI_Hdl, FT_FLOW_RTS_CTS, Char(0), Char(0));
   // Configurar entradas y salidas y estado inicial

   entradassalidas.bPin1InputOutputState:=true;
   entradassalidas.bPin2InputOutputState:=true;
   entradassalidas.bPin3InputOutputState:=true;
   entradassalidas.bPin4InputOutputState:=true;
   entradassalidas.bPin5InputOutputState:=true;
   entradassalidas.bPin6InputOutputState:=true;
   entradassalidas.bPin7InputOutputState:=true;
   entradassalidas.bPin8InputOutputState:=true;

   entradassalidas.bPin1LowHighState:=false;
   entradassalidas.bPin2LowHighState:=false;
   entradassalidas.bPin3LowHighState:=false;
   entradassalidas.bPin4LowHighState:=true;
   entradassalidas.bPin5LowHighState:=false;
   entradassalidas.bPin6LowHighState:=false;
   entradassalidas.bPin8LowHighState:=false;


 SPI_Ret :=  SPI_SetHiSpeedDeviceGPIOs (  SPI_Hdl, @miestructura2,  @entradassalidas);
 Str( SPI_Ret, sTexto );

 If SPI_Ret <> 0 then
 begin
  if not simulating then MessageDlg('No se pueden configurar las E/S: '+Stexto, mtError, [mbOk], 0);
  exit;
 end;
 //  else  MessageDlg('Puertos correctos', mtError, [mbOk], 0);         // Da error, ignoro el motivo


  Buffer:=' ';

  //  No necesaria esta parte de la configuración.
  //  Buffer:=HexToString('80FFFB8208FF');
  //  BytesToWrite:= Length (Buffer);
  /////////////////////////////////////////////////////////////////////////
  //SPI_Ret :=  FT_Write(SPI_Hdl, @Buffer, BytesToWrite, @BytesWritten) ;

  //  If SPI_Ret <> 0
  //  then MessageDlg('error en el write config', mtError, [mbOk], 0);


  // Escritura de valor máximo en el atenuador por posibles problemas tras reset (va a la mitad del FS)
  // El valor máximo significa que no atenua.
  // Se tiene en cuenta la versión de la electrónica
  if Form1.Versiondivider=False then set_attenuator(0,1)
  else
    begin
     set_attenuator(1,1);
     set_attenuator(2,1);
     set_attenuator(3,1);
     set_attenuator(4,1);
    end;
  // Configuración de la salidas digitales

 Buffer:=HexToString('80FEFB8200FF110200400000878208FF80FFFB');
 BytesToWrite:= Length (Buffer);

 SPI_Ret :=  FT_Write(SPI_Hdl, @(Buffer[1]), BytesToWrite, @BytesWritten) ;
 If (SPI_Ret <> 0) or (BytesToWrite <> BytesWritten) then
 begin
  if not simulating then MessageDlg  ('error al configurar las DIO: ', mtError, [mbOk], 0);
  exit;
 end;

// Realizar lecturas ADC para estabilizar datos

   adc_take(0,1,5);    // 5 es experimental

// Purgar lectura y escritura en el buffer

   FT_Purge(   SupraSPI_Hdl,1);
   SPI_Ret:=FT_Purge(   SupraSPI_Hdl,2);
   If SPI_Ret <> 0  then
   begin
    if not simulating then MessageDlg  ('error al purgar el buffer: ', mtError, [mbOk], 0);
    exit;
   end;

if (TRAZAS) then MessageDlg('take_initialize', mtError, [mbOk], 0);

Result:=True ;
end  ;

 //////////////// FUNCIÓN DAC_SET
 // Devuelve el número de caracteres que ocupa la cadena que envía por USB o
 // -1 en caso de error (donde se controle)
function TForm10.dac_set(ndac, valor:integer; BufferOut: PAnsiChar) : Integer ;
Var sTexto:String;
Var sTexto2:String;
var CadenaCS:integer;
var sele_dac:integer;
var BytesToWrite: Integer;
var BytesWritten:Integer;
var SPI_Ret:Integer;
var total:integer;
var i: Integer;
var BufferDest: PAnsiChar;


begin

  if (ndac<0) or (ndac>7) then Exit ;


  // Si vamos a invertir el valor, lo hacemos antes de saturar para evitar desbordamientos con -(-32768)
  //if (ndac> 4) then valor:=-valor;    // No están invertidos, así que se puede hacer por SW para coherencia con las otras salidas del DAC
  if (ndac < 5) then valor:=-valor;    // Es mejor que un nº positivo ofrezca una salida positiva, de modo que se hace de este modo en vez de como estaba inicialmente previsto en la línea anterior

// Se saturan los valores según indicaciones de Isabel
  if valor>32767 then valor:=32767 ;
  if valor<-32768 then valor:=-32768 ;

  if (ndac  > 3) then
  begin
    CadenaCS:=$FF-Integer(pDAC2cs);  //DF
    sele_dac:=ndac;
  end
  else
  begin
    CadenaCS:=$FF-Integer(pDACcs);  //F7
    sele_dac:=ndac+4;
  end;

   // Si nos han pasado un buffer para guardar la cadena que hay que enviar, lo usamos.
   // Si no, lo guardamos en el buffer general.
   if (BufferOut = nil) then
   begin
     BufferDest := Addr(Buffer[1]);
   end
   else
   begin
     BufferDest := BufferOut;
   end;

   // Construyo la cadena que se enviará
   i := 0; // El primer caracter está reservado para la longitud, se use o no.
   (BufferDest+i)^ := Char(MPSSE_CmdSetPortL); Inc(i);
   (BufferDest+i)^ := Char(CadenaCS); Inc(i);
   (BufferDest+i)^ := Char($FB); Inc(i);
   (BufferDest+i)^ := Char(MPSSE_CmdWriteDO); Inc(i);
   (BufferDest+i)^ := Char($02); Inc(i);
   (BufferDest+i)^ := Char($00); Inc(i);
   (BufferDest+i)^ := Char(sele_dac); Inc(i);
   (BufferDest+i)^ := Char(valor shr 8); Inc(i); // Byte más significativo del valor
   (BufferDest+i)^ := Char(valor and $FF); Inc(i); // Byte menos significativo del valor
   (BufferDest+i)^ := Char(MPSSE_CmdSendInmediate); Inc(i);
   (BufferDest+i)^ := Char(MPSSE_CmdSetPortL); Inc(i);
   (BufferDest+i)^ := Char($FF); Inc(i);
   (BufferDest+i)^ := Char($FB); Inc(i);
//   (BufferDest+i)^ := Char(MPSSE_CmdSendInmediate); Inc(i); // ¿Se puede añadir? No le veo mucho sentido, pero parece que afecta a la lectura de datos.

   // Nacho Horcas, agosto de 2017
   // Si sólo se tiene que guardar la instrucción en el buffer, se guarda y no se envía nada
   if (BufferOut = nil) then
   begin
       BytesToWrite:= i;
       SPI_Ret :=  FT_Write(SupraSPI_Hdl, @(Buffer[1]), BytesToWrite, @BytesWritten);
       //Application.ProcessMessages(); // Por si tiene que hacer feedback o lo que toque //Hermann
       If (SPI_Ret <> 0) or (BytesToWrite <> BytesWritten) then
           if not simulating then MessageDlg('error al escribir un valor en el DAC', mtError, [mbOk], 0);
   end;

   // El valor ya viene en formato -32768..0..32767, de modo que la conversión es al valor hex del ascii
   if simulating then simulatedDac[ndac] := valor;


//////////////////////Fin normal//////////////


 Str( ndac, sTexto );
 Str( valor, sTexto2 );
if TRAZAS then MessageDlg('DAC Set numero de dac:'+Stexto+ 'valor:'+sTexto2, mtError, [mbOk], 0);

  Result:=i;

end  ;

////////////  FUNCIÓN ADC_take    ///////////
function TForm10.adc_take(chn,mux,n:integer) : double ;


Var sTexto:String;
Var sTexto2:String;
Var sTexto3:String;

var SPI_Ret:Integer;
var BytesToWrite: Integer;
var BytesWritten:Integer;
var BytesToReceive:Integer;
var numADCChannels:Integer;
var ReceivesBytes:Integer;
var FT_In_Buffer: array [0..14] of Byte; //En ppio. tamaño suficiente para esta versión
var BytesReturned:Integer;
var numres:longint;
var resultadoooo:extended;
var i:integer;
var datosum: double ;
var   f : double ;

begin

// En el original, había estas limitaciones:
// if (n<1) or (chn<0) or (chn>7) or (mux<0) or (mux>31) then Exit ; ;
// Las cuales se adaptan a:


if (n<1) or (chn<0) or (chn>5)  then Exit ;

         //MessageDlg(IntToStr(chn), mtError, [mbOk], 0);
  datosum:=0 ;    // Se pone a 0 al principio del bucle


  for i:=1 to n do begin

  // Nacho, abril de 2018. Por algún motivo que desconozco a veces el valor de i excede el de n, que no debería pasar.
  // Si es el caso, salgo del bucle
  if (i > n) then
    break;

  Buffer:=' ';
  ReceivesBytes:=0; // Para pruebas

//  Buffer:=HexToString('807FFB80FFFB80FFFB80FFFB80EFFB200b008780FFFB');
  // Nacho, agosto de 2017. Cambio la cadena para añadir más tiempos de espera.
  // En algunas electrónicas que deben llevar un ADC distinto no daba tiempo a que terminara la conversión.
  Buffer:=HexToString('807FFB80FFFB80FFFB80FFFB80FFFB80FFFB80EFFB200b008780FFFB');

  BytesToWrite:= Length (Buffer);
  SPI_Ret :=  FT_Write(SupraSPI_Hdl, @(Buffer[1]), BytesToWrite, @BytesWritten) ;
  If (SPI_Ret <> 0) or (BytesToWrite <> BytesWritten) then
   if not simulating then MessageDlg('Error al preparar los datos para escribir ', mtError, [mbOk], 0);


  numADCChannels:=6;
  ReceivesBytes:=0;
  BytesToReceive := 2 * numADCChannels ;   //   Por cada canal A/D debo recibir 2 bytes, 6Ch x 2 =12bytes


  Repeat
        SPI_Ret:=  FT_GetQueueStatus(SupraSPI_Hdl, @ReceivesBytes);
  Until (ReceivesBytes >= BytesToReceive) Or (SPI_Ret <> FT_OK)  ;

  If SPI_Ret <> 0 then
    if not simulating then MessageDlg(Format('TForm10.adc_take. Error al leer (%d)', [SPI_Ret]), mtError, [mbOk], 0);

  BytesReturned:=0;

    if (ReceivesBytes <> BytesToReceive) then
    begin
      Str( ReceivesBytes, sTexto );
      OutputDebugString(PChar('ADC_take Recibidos: ' + sTexto));
    end;

  // LECTURA DE DATOS ADC RECIBIDOS

   SPI_Ret := FT_Read(SupraSPI_Hdl, @FT_In_Buffer, ReceivesBytes, @BytesReturned);

   If SPI_Ret <> 0 then
      if not simulating then MessageDlg(Format('error al leer los datos ADC (%d)', [SPI_Ret]), mtError, [mbOk], 0);


   numres:=ord(FT_In_Buffer[(chn*2)])*256 +  ( ord(FT_In_Buffer[(chn*2+1)]));
   if  numres > $7FFF             then    numres:=numres - $10000;      //Conversión (condicional) a nºs negativos
   resultadoooo:=numres/$10000;

  Str( resultadoooo, sTexto2 );
  Str( n, sTexto3 );

 if TRAZAS then   MessageDlg('El valor es :'+Stexto2+ 'y n es:'+sTexto3, mtError, [mbOk], 0);

   datosum:=datosum + resultadoooo ;

 end;   // Del for

  f:=datosum/n ;
  Str( f, sTexto2 );
  if TRAZAS then   MessageDlg('El valor medio es :'+Stexto2, mtError, [mbOk], 0);
  Result:=f;


//////////////////////////// fin normal
 Str( chn, sTexto );
 Str( mux, sTexto2 );
 Str( n, sTexto3 );

if TRAZAS then  MessageDlg('ADC TAKE chn:'+Stexto+ 'mux:'+sTexto2+'n:' +sTexto3, mtError, [mbOk], 0);

end;

////////////  FUNCIÓN ADC_take_all    ///////////
// Nacho, agosto de 2017. Una vez comprobado que funciona, sería recomendable usarla dentro de adc_take, por aquello de la mantenibilidad
// Si se le pide que lea datos, devuelve una matriz con esos datos.
// Si sólo se le pide que construya la cadena que pide los datos, pero no que los
// lea, devuelve el número de caracteres de la cadena en el primer valor del vector
// devuelto.
function TForm10.adc_take_all(n:Integer; action: AdcTakeAction; BufferOut: PAnsiChar) : TVectorDouble ;


Var sTexto:String;
Var sTexto2:String;
Var sTexto3:String;

var SPI_Ret:Integer;
var BytesToWrite: Integer;
var BytesWritten:Integer;
var BytesToReceive:Integer;
var numADCChannels:Integer;
var ReceivesBytes:Integer;
var FT_In_Buffer: array [0..14] of Byte; //En ppio. tamaño suficiente para esta versión
var BytesReturned:Integer;
var numres:longint;
var resultadoooo:extended;
var i:integer;
var j:integer;
var datosum: TVectorDouble ;
var   f : double ;

var intentos: Integer; // Para pruebas de cuando faltan datos

begin

  if (n<1) then Exit ;

  if ((action = AdcWriteCommand) or (action = AdcWriteRead)) then
  begin

   // Construyo la cadena que se enviará. Será la misma en todas las iteraciones
   // Si es sólo ponerla en el buffer, hay que copiarla para cada iteración.
   i := 1; // El primer caracter está reservado para la longitud, se use o no.
   // Activamos la señal de conversión del ADC
   Buffer[i] := Char(MPSSE_CmdSetPortL); Inc(i);
   Buffer[i] := Char($7F); Inc(i);
   Buffer[i] := Char($FB); Inc(i);
   // Esperamos un poco hasta que termine la conversión
   Buffer[i] := Char(MPSSE_CmdSetPortL); Inc(i);
   Buffer[i] := Char($FF); Inc(i);
   Buffer[i] := Char($FB); Inc(i);
   Buffer[i] := Char(MPSSE_CmdSetPortL); Inc(i);
   Buffer[i] := Char($FF); Inc(i);
   Buffer[i] := Char($FB); Inc(i);
   Buffer[i] := Char(MPSSE_CmdSetPortL); Inc(i);
   Buffer[i] := Char($FF); Inc(i);
   Buffer[i] := Char($FB); Inc(i);
   Buffer[i] := Char(MPSSE_CmdSetPortL); Inc(i);
   Buffer[i] := Char($FF); Inc(i);
   Buffer[i] := Char($FB); Inc(i);
   Buffer[i] := Char(MPSSE_CmdSetPortL); Inc(i);
   Buffer[i] := Char($FF); Inc(i);
   Buffer[i] := Char($FB); Inc(i);
   // Leemos los datos del ADC
   Buffer[i] := Char(MPSSE_CmdSetPortL); Inc(i);
   Buffer[i] := Char($EF); Inc(i);
   Buffer[i] := Char($FB); Inc(i);
   Buffer[i] := Char(MPSSE_CmdReadDI); Inc(i);
   Buffer[i] := Char($0B); Inc(i);
   Buffer[i] := Char($00); Inc(i);
   Buffer[i] := Char(MPSSE_CmdSendInmediate); Inc(i);
   Buffer[i] := Char(MPSSE_CmdSetPortL); Inc(i);
   Buffer[i] := Char($FF); Inc(i);
   Buffer[i] := Char($FB); Inc(i);
   Buffer[i] := Char(MPSSE_CmdSendInmediate); Inc(i);
   Buffer[0] := Char(i-1); // Longitud de la cadena
  end;

  setLength(datosum, NUM_ADCs);
  for j := 0 to NUM_ADCs-1 do
    datosum[j]:=0 ;    // Se pone a 0 al principio del bucle

  BytesToWrite:= Length (Buffer);
  i:=0;
  while (i < n) do // Si se usa un for el optimizador se pasa de listo
  begin
    ReceivesBytes:=0;

    // Si tenemos que pedir los datos, los pedimos
    if ((action = AdcWriteCommand) or (action = AdcWriteRead)) then
    begin
       // Nacho Horcas, agosto de 2017
       // Si sólo se tiene que guardar la instrucción en el buffer, se guarda y no se envía nada
       if (BufferOut = nil) then
       begin
         SPI_Ret :=  FT_Write(SupraSPI_Hdl, @(Buffer[1]), BytesToWrite, @BytesWritten);
         If (SPI_Ret <> 0) or (BytesToWrite <> BytesWritten) then
             if not simulating then MessageDlg('error al pedir los datos de los ADCs', mtError, [mbOk], 0);
       end
       else
         CopyMemory(BufferOut+i*BytesToWrite, Addr(Buffer[1]), BytesToWrite);
    end;

    // Si tenemos que leer los datos, los leemos
    if ((action = AdcReadData) or (action = AdcWriteRead)) then
    begin
      ReceivesBytes:=0;
      BytesToReceive := 2 * NUM_ADCs ;   //   Por cada canal A/D debo recibir 2 bytes, 6Ch x 2 =12bytes

      intentos := 0;
      Repeat
        SPI_Ret:= FT_GetQueueStatus(SupraSPI_Hdl, @ReceivesBytes);
        intentos := intentos+1;
      Until (ReceivesBytes >= BytesToReceive) Or (SPI_Ret <> FT_OK) or (intentos > 10000);

      If SPI_Ret <> FT_OK then
        if not simulating then MessageDlg(Format('TForm10.adc_take_all. Error al leer (%d)', [SPI_Ret]), mtError, [mbOk], 0);

      if (ReceivesBytes < BytesToReceive) then // No nos han llegado los datos en un tiempo prudencial. Intentamos salvar los muebles
      begin
        for j := 0 to BytesToReceive-1 do
          FT_In_Buffer[j] := 0;
        BytesToReceive := ReceivesBytes;
      end;


      BytesReturned:=0;

      // LECTURA DE DATOS ADC RECIBIDOS

      // Nacho, agosto de 2017. Antes se leía todo el buffer, en lugar de sólo lo que interesaba.
      // Mantengo ese caso por compatibilidad, para que no llegen los datos desfasados
      // Si se mantiene la condición, a veces se roban datos. (Comprobar si sigue pasando tras cambiar los índices de los buffers)
      if (action = AdcWriteRead) then
      begin
        if (ReceivesBytes <> BytesToReceive) then
        begin
          Str( ReceivesBytes, sTexto );
          OutputDebugString(PChar('Recibidos: ' + sTexto));
        end;
        SPI_Ret := FT_Read(SupraSPI_Hdl, @FT_In_Buffer, ReceivesBytes, @BytesReturned);
      end
      else
        SPI_Ret := FT_Read(SupraSPI_Hdl, @FT_In_Buffer, BytesToReceive, @BytesReturned);

      If SPI_Ret <> 0 then
        if not simulating then MessageDlg('error al leer los datos ADC ', mtError, [mbOk], 0);

      for j := 0 to NUM_ADCs-1 do
      begin
        numres := ord(FT_In_Buffer[(j*2)])*256 +  ( ord(FT_In_Buffer[(j*2+1)]));
        if  numres > 32767             then    numres:=numres - 65536;      //Conversión (condicional) a nºs negativos
        resultadoooo:=numres/32768;
        if simulating then resultadoooo := simulatedDac[Form1.XDAC]/$8000+Random/100;
        datosum[j] := datosum[j] + resultadoooo ;
      end;
    end;

    Inc(i);
  end;   // Del while

  SetLength(Result, NUM_ADCs);

  // Si tenemos que leer los datos, escribimos en la variable de retorno los
  // valores leídos promediados.
  if ((action = AdcReadData) or (action = AdcWriteRead)) then
  begin
    for j := 0 to NUM_ADCs-1 do
    begin
      f:=datosum[j]/n ;
      Str( j, sTexto );
      Str( f, sTexto2 );
      if TRAZAS then MessageDlg('El valor medio del canal '+Stexto+' es :'+Stexto2, mtError, [mbOk], 0);
      Result[j]:=f;
    end;
  end
  else
  begin
    // Devolvemos en la primera posición el número de bytes que hemos escrito en el buffer
    Result[0] := BytesToWrite*n;
  end;
  
end;

////////////  FUNCIÓN ramp_take    ///////////
// Adquiere un bloque de datos mientras genera una rampa por un DAC
// Parámetros de entrada:
//  ndac:     Índice del DAC a utilizar. -1 si no se quiere modificar ninguna salida.
//  value1:   Valor inicial de la rampa.
//  value2:   Valor final de la rampa.
//  dataSet:  Arrays del módulo "Liner" donde guardar los datos (0: ida, 1: vuelta).
//  npoints:  Número de puntos de la rampa.
//  jump:     Número de pasos intermedios en el DAC al variar cada valor de salida.
//  delay:    Tiempo de espera (en unidades arbitrarias) desde que se da la salida del DAC hasta que se leen los ADCs. (Sin implementar)
//  blockAcq: Indica si se dede adquirir toda la rampa como un bloque (tarda menos) o punto a punto (usa menos buffer de comunicación).

function TForm10.ramp_take(ndac, value1, value2, dataSet, npoints, jump, delay: Integer; blockAcq: Boolean): boolean;
var
i,j,Loc_ADCTopo,Loc_ADCI, Loc_ADCOther: Integer;
Loc_CalTopo,Loc_AmpTopo,Loc_AmpI,Loc_MultI,Loc_AmpOther,Loc_MultOther,Step,DacVal: Double;
ReceivesBytes, BytesToReceive: Integer;
adcRead: TVectorDouble;
BufferMem: Array[0..FT_Out_Buffer_Size] of Byte;
safeBufferSize: Integer; // Cuando el buffer se llene hasta esta cantidad de datos, los enviaremos. Debe ser sensiblemente menor que el tamaño del buffer para evitar que se desborde
BufferPtr: PAnsiChar;
SPI_Ret: FTC_STATUS;

begin

  safeBufferSize := Round(Length(BufferMem)*0.8);
  if (not blockAcq) then
    safeBufferSize := 0; // Si la adquisición es punto a punto no usamos el buffer y enviamos siempre los datos
  DacVal:=value1;
  Step:=(value2-value1)/(npoints*jump-1);

  //Cogemos variables de la config del scanner
  Loc_CalTopo:=Form1.CalTopo;
  Loc_AmpTopo:=Form1.AmpTopo;
  Loc_ADCTopo:=Form1.ADCTopo;

  Loc_AmpI:=Form1.AmpI;
  Loc_MultI:=Form1.MultI;
  Loc_ADCI:=Form1.ADCI;

  Loc_AmpOther:=Form1.AmpOther;
  Loc_MultOther:=Form1.MultOther;
  Loc_ADCOther:=Form1.ADCOther;

  // Lectura de UNA rampa de ida o vuelta
  BufferPtr := Addr(BufferMem[0]);
  i:=0;
  while (Form4.Abort_Measure=False) and (i<npoints) do
  begin
    j := 0;
    if not Form4.ReadXFromADC then
      Form4.DataX[dataSet,i]:=DacVal*Strtofloat(Form7.Edit1.Text)/32768;

    while (j < jump) do
    begin
      BufferPtr := BufferPtr + Form10.dac_set(Form4.x_axisDAC, Round(DacVal), BufferPtr);
      DacVal := DacVal+Step;
      Inc(j);
      if blockAcq then
        //Application.ProcessMessages; // Para que pueda hacer el feedback digital //Hermann
    end;

    if (blockAcq) then // Si la adquisición es por bloques, metemos también la lectura del ADC. Si es punto a punto mejor esperar a que dé la salida.
    begin
      adcRead := Form10.adc_take_all(Form4.LinerMean, AdcWriteCommand, BufferPtr);
      BufferPtr := BufferPtr + Round(adcRead[0]);
    end;

    // Si se llena el buffer, lo enviamos y empezamos de nuevo desde el principio
    if ((BufferPtr-Addr(BufferMem[0])) > safeBufferSize) then
    begin
      Form10.send_buffer(Addr(BufferMem[0]), BufferPtr-Addr(BufferMem[0]));
      BufferPtr := Addr(BufferMem[0]);
    end;

    // Si estamos adquiriendo punto a punto, adquirimos el punto que toque ahora
    // que hemos enviado el anterior. No lo meto en el mismo envío para no
    // tener problemas de latencias. Si se usa la adquisición punto a punto es de
    // suponer que no hay prisa, podemos tardar un poco más en cada punto.
    if (not blockAcq) then
    begin
      adcRead:=Form10.adc_take_all(Form4.LinerMean, AdcWriteRead, nil);
      if Form4.ReadXFromADC then
        Form4.DataX[dataSet,i]:=adcRead[Form4.x_axisADC]*Form4.x_axisMult;

      if Form4.ReadZ then
      begin
        //if (Form1.DigitalPID) then
        //  Form4.DataZ[dataSet,i]:=Loc_CalTopo*Loc_AmpTopo*Action_PID/32768
        //else
          Form4.DataZ[dataSet,i]:=Loc_CalTopo*Loc_AmpTopo*adcRead[Loc_ADCTopo];
      end;

      //Hemos cambiado Loc_ADCI por x_axisADC en el primer parámetro de adc_take para que el canal de ADC sea el de config liner
      //Se vuelve a poner Loc_ADCI
      if Form4.ReadCurrent then
        Form4.DataCurrent[dataSet,i]:=Loc_AmpI*Loc_MultI*adcRead[Loc_ADCI];

      //Hermann, 19/11/2021. se añade una lectura de un ADC adicional
        if Form4.ReadOther then
        Form4.DataOther[dataSet,i]:=Loc_AmpOther*Loc_MultOther*adcRead[Loc_ADCOther];

    end;

    Inc(i);
  end;

  // Si la adquisición es punto a punto, ya habremos terminado. Salimos
  if (not blockAcq) then
  begin
      Result := True;
      Exit;
  end;

  // Tenemos un ciclo de latencia, por lo que envío un dato más, para luego
  // despreciar el primero.
  adcRead := Form10.adc_take_all(1, AdcWriteCommand, BufferPtr);
  BufferPtr := BufferPtr + Round(adcRead[0]);

  // Envía todos los datos del buffer
  Form10.send_buffer(Addr(BufferMem[0]), BufferPtr-Addr(BufferMem[0]));

  // Recibe los datos de los ADCs
  // La variable i tendrá el número de puntos que realmente ha pedido. Si se ha
  // parado la adquisición a medias, será menor que PointNumber. Leemos los datos
  // que realmente hemos pedido. Aquí no comprobamos si nos han pedido que paremos,
  // sacamos de los buffers todo lo que hemos pedido.

  // Sacamos el dato extra que hemos metido para compensar la latencia.
  Form10.adc_take_all(1, AdcReadData, nil);

  j := i;
  i:=0;
  while (i < j) do
  begin
    adcRead:=Form10.adc_take_all(Form4.LinerMean, AdcReadData, nil);
    if Form4.ReadXFromADC then
      Form4.DataX[dataSet,i]:=adcRead[Form4.x_axisADC]*Form4.x_axisMult;

    if Form4.ReadZ then
    begin
      //if (Form1.DigitalPID) then
      //  Form4.DataZ[dataSet,i]:=Loc_CalTopo*Loc_AmpTopo*Action_PID/32768
      //else
        Form4.DataZ[dataSet,i]:=Loc_CalTopo*Loc_AmpTopo*adcRead[Loc_ADCTopo];
    end;

    //Hemos cambiado Loc_ADCI por x_axisADC en el primer parámetro de adc_take para que el canal de ADC sea el de config liner
    // Volver a poner Loc_ADCI
    if Form4.ReadCurrent then
      Form4.DataCurrent[dataSet,i]:=Loc_AmpI*Loc_MultI*adcRead[Loc_ADCI];

    //Hemos cambiado Loc_ADCI por x_axisADC en el primer parámetro de adc_take para que el canal de ADC sea el de config liner
    // Volver a poner Loc_ADCI
    if Form4.ReadOther then
      Form4.DataOther[dataSet,i]:=Loc_AmpOther*Loc_MultOther*adcRead[Loc_ADCOther];

    i:=i+1;
  end;

  Result := True;
end;

function TForm10.send_buffer(bufferToSend: PAnsiChar; bytesToSend: Integer):FTC_STATUS;
var
BytesWritten: Integer;
SPI_Ret: Integer;
begin
  BytesWritten := 0;
  SPI_Ret :=  FT_Write(SupraSPI_Hdl, bufferToSend, bytesToSend, @BytesWritten);
  while bytesToSend <> BytesWritten do       // Si no ha podido enviar todo el buffer, lo volvemos a intentar. En el futuro se puede quitar el envío anterior y hacerlo siempre aquí
  begin
    if (BytesWritten < bytesToSend) then
    begin
      bufferToSend := bufferToSend+BytesWritten;
      bytesToSend := bytesToSend-BytesWritten;
    end;
    if not simulating then MessageDlg(Format('No se ha podido enviar todo el buffer de la rampa. Enviados %d de %d', [BytesWritten, bytesToSend]), mtError, [mbOk], 0);
    SPI_Ret :=  FT_Write(SupraSPI_Hdl, bufferToSend, bytesToSend, @BytesWritten);
    //Application.ProcessMessages(); //Hermann
  end;

  If SPI_Ret <> 0 then
      if not simulating then MessageDlg('error al enviar el buffer de la rampa', mtError, [mbOk], 0);

   Result := SPI_Ret;
end;

procedure TForm10.set_dio_port(value: Word);
var
  BufferDest: PAnsiChar;
  i: Integer;
  SPI_Ret, BytesWritten: Integer;
  BufferOut: array [0..20] of Byte;
begin
  BufferDest := Addr(BufferOut[0]);

  // Construyo la cadena que se enviará
  i := 0;
  (BufferDest+i)^ := Char(MPSSE_CmdSetPortL); Inc(i);
  (BufferDest+i)^ := Char($FE); Inc(i);
  (BufferDest+i)^ := Char($FF-Integer(pDI)); Inc(i);
  (BufferDest+i)^ := Char(MPSSE_CmdSetPortH); Inc(i);
  (BufferDest+i)^ := Char(0); Inc(i);
  (BufferDest+i)^ := Char($FF); Inc(i);
  (BufferDest+i)^ := Char(MPSSE_CmdWriteDO2); Inc(i);
  (BufferDest+i)^ := Char(2); Inc(i); // Número de bytes a transmitir menos 1
  (BufferDest+i)^ := Char(0); Inc(i);
  (BufferDest+i)^ := Char($40); Inc(i); // Direccion del chip y bits de control
  (BufferDest+i)^ := Char(9); Inc(i); // Registro de datos
  (BufferDest+i)^ := Char(value); Inc(i); // Valores de cada bit
  (BufferDest+i)^ := Char(MPSSE_CmdSendInmediate); Inc(i);
  (BufferDest+i)^ := Char(MPSSE_CmdSetPortH); Inc(i);
  (BufferDest+i)^ := Char(Integer(pDIOcs)); Inc(i);
  (BufferDest+i)^ := Char($FF); Inc(i);
  (BufferDest+i)^ := Char(MPSSE_CmdSendInmediate); Inc(i);

  SPI_Ret :=  FT_Write(SupraSPI_Hdl, BufferDest, i, @BytesWritten);
  If (SPI_Ret <> 0) or (i <> BytesWritten) then
     if not simulating then MessageDlg('error al escribir el puerto digital', mtError, [mbOk], 0);
end;

procedure TForm10.set_attenuator(DACAttNr: Integer; value: double);
var
  BufferDest: PAnsiChar;
  i: Integer;
  SPI_Ret, BytesWritten: Integer;
  BufferOut: array [0..20] of Byte;
  valueDAC: Integer;
begin
  BufferDest := Addr(BufferOut[0]);

  // El atenuador se implementa mediante un DAC de 16 bits sin signo que usa la señal a atenuar como referencia.
  // Para el valor máximo del DAC la salida será igual a la referencia.
  valueDAC := Round(value*$FFFF);

  // Construyo la cadena que se enviará
  // esto habrá que cambiarlo todo para pasar a unicode
  i := 0;
  (BufferDest+i)^ := Char(MPSSE_CmdSetPortL); Inc(i);
  (BufferDest+i)^ := Char($FE-Integer(pAttcs)); Inc(i);
  (BufferDest+i)^ := Char($FF-Integer(pDI)); Inc(i);
  (BufferDest+i)^ := Char(MPSSE_CmdWriteDO2); Inc(i);
  (BufferDest+i)^ := Char(2); Inc(i); // Número de bytes a transmitir menos 1
  (BufferDest+i)^ := Char(0); Inc(i);
  if Form1.VersionDivider=False then
  begin
    (BufferDest+i)^ := Char(03);
    Inc(i); // Registro: Ambos DACs
  end
  else
    begin
      if (DACAttNr=1) then (BufferDest+i)^ := Char(03); Inc(i); // registro DAC A Canal 0
      if (DACAttNr=2) then (BufferDest+i)^ := Char(03); Inc(i); // registro DAC A Canal 2
      if (DACAttNr=3) then (BufferDest+i)^ := Char(03); Inc(i); // registro DAC A Canal 5
      if (DACAttNr=4) then (BufferDest+i)^ := Char(03); Inc(i); // registro DAC A Canal 6
    end;
  (BufferDest+i)^ := Char(valueDAC shr 8); Inc(i);  // Parte alta del valor del DAC
  (BufferDest+i)^ := Char(valueDAC and $FF); Inc(i); // Parte baja del valor del DAC
  (BufferDest+i)^ := Char(MPSSE_CmdSendInmediate); Inc(i);
  (BufferDest+i)^ := Char(MPSSE_CmdSetPortL); Inc(i);
  (BufferDest+i)^ := Char($FE); Inc(i);
  (BufferDest+i)^ := Char($FF-Integer(pDI)); Inc(i);
  (BufferDest+i)^ := Char(MPSSE_CmdSendInmediate); Inc(i);

  SPI_Ret :=  FT_Write(SupraSPI_Hdl, BufferDest, i, @BytesWritten);
  If (SPI_Ret <> 0) or (i <> BytesWritten) then
     if not simulating then MessageDlg('error al escribir el atenuador', mtError, [mbOk], 0);

  attenuator := value;
end;


//Esta se quedA
procedure TForm10.Button1Click(Sender: TObject);
begin
InitDataAcq;
end;
//Esta se quedA
procedure TForm10.ScrollBar1Change(Sender: TObject);
var
numdac:SmallInt;
Value:SmallInt;
begin
numdac:=SpinEdit2.Value;
Value:=Scrollbar1.Position;

dac_set(numdac,Value, nil);
Label5.Caption:= FloatToStrF(10*Value/32768,ffGeneral,4,4);
end;
//Esta se quedA
procedure TForm10.FormCreate(Sender: TObject);
begin
InitDataAcq;
end;


//Esta se quedA
procedure TForm10.Button2Click(Sender: TObject);
var
mux,n: SmallInt;

begin
mux:=SpinEdit1.Value;
n:=SpinEdit3.Value;
Label3.Caption:=FloattoStr(adc_take(mux,mux,n));
end;

procedure TForm10.Button3Click(Sender: TObject);
begin
ScrollBar1.Position:=0;
ScrollBar1Change(nil);
end;

procedure TForm10.Button4Click(Sender: TObject);
var
mux,n: SmallInt;
  myFile : TextFile;
  //text   : string;
  //startTime : TDateTime;
  //currentTime : TDateTime;
  frequency,startTime,endTime : Int64 ;
  elapsedSeconds : Single;



begin
  Label7.Font.Color :=clGreen;
  Label7.Caption :='Saving';
  // Try to open the Test.txt file for writing to
  AssignFile(myFile, Concat(Edit1.Text,'_',Label8.Caption,'.txt'));
  ReWrite(myFile);

  //mux:=SpinEdit1.Value;
  //n:=SpinEdit3.Value;
  //Label3.Caption:=FloattoStr(adc_take(0,mux,n));
  StopAction:=False;
  //startTime:=Now;
  //startTime:=MilliSecondOfTheYear(startTime);
  frequency:=100000;
  QueryPerformanceFrequency(frequency);
  QueryPerformanceCounter(startTime);
  //FunctionToTime();


  while  StopAction=False do
  begin
  //Sleep(1);
  //currentTime:=Now;
  QueryPerformanceCounter(endTime);
  elapsedSeconds := (endTime - startTime) / frequency;
  //currentTime:=MilliSecondOfTheYear(currentTime);
  //Writeln(myFile,DateUtils.MilliSecondsBetween(startTime, currentTime),' ',adc_take(0,0,1):2:6,' ',adc_take(0,1,1):2:6);
  //Writeln(myFile,currentTime-startTime,' ',adc_take(0,0,1):2:6,' ',adc_take(0,1,1):2:6);
  Writeln(myFile,elapsedSeconds,' ',10*adc_take(0,0,16),' ',10*adc_take(2,2,16));
  //Application.ProcessMessages; //Hermann
  end  ;

  // Write a couple of well known words to this file
  //writeln(myFile, 'Hello World');

  // Write a blank line
  //writeln(myFile);

  // Write a string and a number to the file
  //writeln(myFile, '22/7 = ' , 22/7);

  // Repeat the above, but with number formatting
  //writeln(myFile, '22/7 = ' , 22/7:12:6);

  // Close the file
  CloseFile(myFile);
  Label8.Caption:=IntToStr(StrToInt(Label8.Caption)+1);
end;

procedure TForm10.Button5Click(Sender: TObject);
begin
StopAction:=True;
Label7.Font.Color :=clRed;
Label7.Caption :='Not saving';
end;

procedure TForm10.Edit1Change(Sender: TObject);
begin
Label8.Caption:='1';
end;

end.

