unit DataAdcquisition;

interface

uses
  Windows, Messages, SysUtils, DateUtils, StdCtrls, Spin, Controls, Classes, Graphics, Forms, Dialogs, Scanner1,
  Liner, FT2232CSPIUnit, SPIDLLFuncUnit,D2XXUnit, StrUtils,IniFiles, WINSOCK, PID, 
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
  NUM_ADCs = 6;                   // N�mero de ADCs que podemos leer de la electr�nica
  NUM_DACs = 8;

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

  Int9 = -256..255;

  TDACCal = record
    Offset: Int9;
    Gain: ShortInt;
  end;

  TDataForm = class(TForm)
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
    OffsetBtn: TButton;
    GainBtn: TButton;
    SetDACCorrection: TSpinEdit;
    OffsetValue: TSpinEdit;
    GainValue: TSpinEdit;
    SetDACCorrLbl: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    function InitDataAcq : boolean ;
    function dac_set(ndac,valor:integer; BufferOut: PAnsiChar) : integer;
    function adc_take(chn,mux,n:integer) : double;
    function adc_take_all(n:Integer; action: AdcTakeAction; BufferOut: PAnsiChar) : TVectorDouble ;
    function ramp_take(ndac, value1, value2, dataSet, npoints, jump, delay: Integer; blockAcq: Boolean): boolean;
    function ramp_take_reduce(ndac, value1, value2, dataSet, npoints, jump, delay: Integer; blockAcq: Boolean): boolean;
    function send_buffer(bufferToSend: PAnsiChar; bytesToSend: Integer): FTC_STATUS;
    procedure set_dio_port(value: Word);
    procedure set_attenuator(DACAttNr: Integer; value: double);
    procedure set_attenuator_14b(DACAttNr: Integer; value: double);
    procedure dac_gain(ndac, offset: ShortInt; BufferOut: PAnsiChar);
    procedure dac_zero_offset(ndac: ShortInt; offset: Int9; BufferOut: PAnsiChar);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure OffsetBtnClick(Sender: TObject);
    procedure GainBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    { Private declarations }
  public
    { Public declarations }
    scan_attenuator: Double;
    z_attenuator: Double;
    bias_attenuator: Double;
    StopAction: Boolean;
    DACCal: array [0..7] of TDACCal;
  end;

var
  DataForm: TDataForm;
  SupraSPI_Hdl:Dword;
  simulating: Boolean;
  simulatedDac: array[0..7] of Integer;
  Buffer:String[50]; //En ppio. hay espacio de sobra con esta cantidad
  CalFile: TMemIniFile;

implementation

uses Config_Liner,Config1;
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
// Convierte pares de valores de n�meros hexadecimales codificados en ASCII a su equivalente sin codificar.
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

Function TDataForm.InitDataAcq : boolean  ;

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

 SPI_Ret :=  SPI_InitDevice(SPI_Hdl, 2); // Con los retardos que hay ahora en los ADCs podr�a funcionar con 0 e ir m�s r�pido
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

  //  No necesaria esta parte de la configuraci�n.
  //  Buffer:=HexToString('80FFFB8208FF');
  //  BytesToWrite:= Length (Buffer);
  /////////////////////////////////////////////////////////////////////////
  //SPI_Ret :=  FT_Write(SPI_Hdl, @Buffer, BytesToWrite, @BytesWritten) ;

  //  If SPI_Ret <> 0
  //  then MessageDlg('error en el write config', mtError, [mbOk], 0);


  // Escritura de valor m�ximo en el atenuador por posibles problemas tras reset (va a la mitad del FS)
  // El valor m�ximo significa que no atenua.
  // Se tiene en cuenta la versi�n de la electr�nica
  //if ScanForm.Versiondivider=False then set_attenuator(0,1)
  //else
  //  begin
  //   set_attenuator(1,1);
  //   set_attenuator(2,1);
  //   set_attenuator(3,1);
  //   set_attenuator(4,1);
  //  end;

case ScanForm.LHARev of
  revB..revC: begin //LHA rev B y C. Atenuadores solo en los Canales 0 y 2
    set_attenuator(0,1);
    z_attenuator := 1;
    bias_attenuator := 1;
    //DataForm.scan_attenuator:=1;
    //DataForm.bias_attenuator:=1;
  end;
  revD: begin //LHA rev D. A�ade tambien atenuadores a los canales 5 y 6
    set_attenuator(1,1);
    set_attenuator(2,1);
    set_attenuator(3,1);
    set_attenuator(4,1);
    //DataForm.scan_attenuator:=1;
    //DataForm.bias_attenuator:=1;
  end;
  revE: begin //LHA version 14bits. Mismos atenuadores que rev D pero con 14bits
    set_attenuator_14b(1,1);
    set_attenuator_14b(2,1);
    set_attenuator_14b(3,1);
    set_attenuator_14b(4,1);
    //DataForm.scan_attenuator:=1;
    //DataForm.bias_attenuator:=1;
  end;
end;
  // Configuraci�n de la salidas digitales

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

 //////////////// FUNCI�N DAC_SET
 // Devuelve el n�mero de caracteres que ocupa la cadena que env�a por USB o
 // -1 en caso de error (donde se controle)
 // No encuentro la situacion en la que devolvemos -1
function TDataForm.dac_set(ndac, valor:integer; BufferOut: PAnsiChar) : Integer ;
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
  //if (ndac> 4) then valor:=-valor;    // No est�n invertidos, as� que se puede hacer por SW para coherencia con las otras salidas del DAC
  if (ndac < 5) then valor:=-valor;    // Es mejor que un n� positivo ofrezca una salida positiva, de modo que se hace de este modo en vez de como estaba inicialmente previsto en la l�nea anterior
  // No estoy seguro de si esto corresponde con la configuracion actual, y no nos sirve para las nuevas versiones con 4 atenuadores
// Se saturan los valores seg�n indicaciones de Isabel
  if valor>32767 then valor:=32767 ;
  if valor<-32768 then valor:=-32768 ;

  // El los registros para enviar la se�al a los Canales 0 a 3 de cada DAC son respectivamente 4 a 7
  // Para los primeros 4 canales de la electronica, tenemos que sumar 4 al valor que usamos,
  // y para los siguientes 4 podemos dejarlo tal cual
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

   // Construyo la cadena que se enviar�
   i := 0; // El primer caracter est� reservado para la longitud, se use o no.
   (BufferDest+i)^ := Char(MPSSE_CmdSetPortL); Inc(i);
   (BufferDest+i)^ := Char(CadenaCS); Inc(i);
   (BufferDest+i)^ := Char($FB); Inc(i);
   (BufferDest+i)^ := Char(MPSSE_CmdWriteDO); Inc(i);
   (BufferDest+i)^ := Char($02); Inc(i); // Numero de bytes a transmitir menos 1?
   (BufferDest+i)^ := Char($00); Inc(i);
   (BufferDest+i)^ := Char(sele_dac); Inc(i); //Registro?
   (BufferDest+i)^ := Char(valor shr 8); Inc(i); // Byte m�s significativo del valor
   (BufferDest+i)^ := Char(valor and $FF); Inc(i); // Byte menos significativo del valor
   (BufferDest+i)^ := Char(MPSSE_CmdSendInmediate); Inc(i);
   (BufferDest+i)^ := Char(MPSSE_CmdSetPortL); Inc(i);
   (BufferDest+i)^ := Char($FF); Inc(i);
   (BufferDest+i)^ := Char($FB); Inc(i);
//   (BufferDest+i)^ := Char(MPSSE_CmdSendInmediate); Inc(i); // �Se puede a�adir? No le veo mucho sentido, pero parece que afecta a la lectura de datos.

   // Nacho Horcas, agosto de 2017
   // Si s�lo se tiene que guardar la instrucci�n en el buffer, se guarda y no se env�a nada
   if (BufferOut = nil) then
   begin
       BytesToWrite:= i;
       SPI_Ret :=  FT_Write(SupraSPI_Hdl, @(Buffer[1]), BytesToWrite, @BytesWritten);
       //Application.ProcessMessages(); // Por si tiene que hacer feedback o lo que toque //Hermann
       If (SPI_Ret <> 0) or (BytesToWrite <> BytesWritten) then
           if not simulating then MessageDlg('error al escribir un valor en el DAC', mtError, [mbOk], 0);
   end;

   // El valor ya viene en formato -32768..0..32767, de modo que la conversi�n es al valor hex del ascii
   if simulating then simulatedDac[ndac] := valor;


//////////////////////Fin normal//////////////


 Str( ndac, sTexto );
 Str( valor, sTexto2 );
if TRAZAS then MessageDlg('DAC Set numero de dac:'+Stexto+ 'valor:'+sTexto2, mtError, [mbOk], 0);

  Result:=i;

end;

////////////  FUNCI�N ADC_take    ///////////
function TDataForm.adc_take(chn,mux,n:integer) : double ;


Var sTexto:String;
Var sTexto2:String;
Var sTexto3:String;

var SPI_Ret:Integer;
var BytesToWrite: Integer;
var BytesWritten:Integer;
var BytesToReceive:Integer;
//var numADCChannels:Integer;
var ReceivesBytes:Integer;
var FT_In_Buffer: array [0..14] of Byte; //En ppio. tama�o suficiente para esta versi�n
var BytesReturned:Integer;
var numres:longint;
var resultadoooo:extended;
var i:integer;
var datosum: double ;
var   f : double ;

begin

// En el original, hab�a estas limitaciones:
// if (n<1) or (chn<0) or (chn>7) or (mux<0) or (mux>31) then Exit ; ;
// Las cuales se adaptan a:

// Solo los canales 0 a 5 tienen salida en la electronica
if (n<1) or (chn<0) or (chn>5)  then Exit ;

         //MessageDlg(IntToStr(chn), mtError, [mbOk], 0);
  datosum:=0 ;    // Se pone a 0 al principio del bucle


  for i:=1 to n do begin

  // Nacho, abril de 2018. Por alg�n motivo que desconozco a veces el valor de i excede el de n, que no deber�a pasar.
  // Si es el caso, salgo del bucle
  if (i > n) then
    break;

  Buffer:=' ';
  ReceivesBytes:=0; // Para pruebas

//  Buffer:=HexToString('807FFB80FFFB80FFFB80FFFB80EFFB200b008780FFFB');
  // Nacho, agosto de 2017. Cambio la cadena para a�adir m�s tiempos de espera.
  // En algunas electr�nicas que deben llevar un ADC distinto no daba tiempo a que terminara la conversi�n.
  Buffer:=HexToString('807FFB80FFFB80FFFB80FFFB80FFFB80FFFB80EFFB200b008780FFFB');

  BytesToWrite:= Length (Buffer);
  SPI_Ret :=  FT_Write(SupraSPI_Hdl, @(Buffer[1]), BytesToWrite, @BytesWritten) ;
  If (SPI_Ret <> 0) or (BytesToWrite <> BytesWritten) then
   if not simulating then MessageDlg('Error al preparar los datos para escribir ', mtError, [mbOk], 0);


  //numADCChannels:=6;
  ReceivesBytes:=0;
  BytesToReceive := 2 * NUM_ADCs ;   //   Por cada canal A/D debo recibir 2 bytes, 6Ch x 2 =12bytes


  Repeat
        SPI_Ret:=  FT_GetQueueStatus(SupraSPI_Hdl, @ReceivesBytes);
  Until (ReceivesBytes >= BytesToReceive) Or (SPI_Ret <> FT_OK)  ;

  If SPI_Ret <> 0 then
    if not simulating then MessageDlg(Format('TDataForm.adc_take. Error al leer (%d)', [SPI_Ret]), mtError, [mbOk], 0);

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
   if  numres > $7FFF             then    numres:=numres - $10000;      //Conversi�n (condicional) a n�s negativos
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

////////////  FUNCI�N ADC_take_all    ///////////
// Nacho, agosto de 2017. Una vez comprobado que funciona, ser�a recomendable usarla dentro de adc_take, por aquello de la mantenibilidad
// Si se le pide que lea datos, devuelve una matriz con esos datos.
// Si s�lo se le pide que construya la cadena que pide los datos, pero no que los
// lea, devuelve el n�mero de caracteres de la cadena en el primer valor del vector
// devuelto.
function TDataForm.adc_take_all(n:Integer; action: AdcTakeAction; BufferOut: PAnsiChar) : TVectorDouble ;


Var sTexto:String;
Var sTexto2:String;
Var sTexto3:String;

var SPI_Ret:Integer;
var BytesToWrite: Integer;
var BytesWritten:Integer;
var BytesToReceive:Integer;
//var numADCChannels:Integer;
var ReceivesBytes:Integer;
var FT_In_Buffer: array [0..14] of Byte; //En ppio. tama�o suficiente para esta versi�n
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

   // Construyo la cadena que se enviar�. Ser� la misma en todas las iteraciones
   // Si es s�lo ponerla en el buffer, hay que copiarla para cada iteraci�n.
   i := 1; // El primer caracter est� reservado para la longitud, se use o no.
   // Activamos la se�al de conversi�n del ADC
   Buffer[i] := Char(MPSSE_CmdSetPortL); Inc(i);
   Buffer[i] := Char($7F); Inc(i);
   Buffer[i] := Char($FB); Inc(i);
   // Esperamos un poco hasta que termine la conversi�n
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
       // Si s�lo se tiene que guardar la instrucci�n en el buffer, se guarda y no se env�a nada
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
        if not simulating then MessageDlg(Format('TDataForm.adc_take_all. Error al leer (%d)', [SPI_Ret]), mtError, [mbOk], 0);

      if (ReceivesBytes < BytesToReceive) then // No nos han llegado los datos en un tiempo prudencial. Intentamos salvar los muebles
      begin
        for j := 0 to BytesToReceive-1 do
          FT_In_Buffer[j] := 0;
        BytesToReceive := ReceivesBytes;
      end;


      BytesReturned:=0;

      // LECTURA DE DATOS ADC RECIBIDOS

      // Nacho, agosto de 2017. Antes se le�a todo el buffer, en lugar de s�lo lo que interesaba.
      // Mantengo ese caso por compatibilidad, para que no llegen los datos desfasados
      // Si se mantiene la condici�n, a veces se roban datos. (Comprobar si sigue pasando tras cambiar los �ndices de los buffers)
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
        if  numres > 32767             then    numres:=numres - 65536;      //Conversi�n (condicional) a n�s negativos
        resultadoooo:=numres/32768;
        if simulating then resultadoooo := simulatedDac[ScanForm.XDAC]/$8000+Random/100;
        datosum[j] := datosum[j] + resultadoooo ;
      end;
    end;

    Inc(i);
  end;   // Del while

  SetLength(Result, NUM_ADCs);

  // Si tenemos que leer los datos, escribimos en la variable de retorno los
  // valores le�dos promediados.
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
    // Devolvemos en la primera posici�n el n�mero de bytes que hemos escrito en el buffer
    Result[0] := BytesToWrite*n;
  end;
  
end;

////////////  FUNCI�N ramp_take    ///////////
// Adquiere un bloque de datos mientras genera una rampa por un DAC
// Par�metros de entrada:
//  ndac:     �ndice del DAC a utilizar. -1 si no se quiere modificar ninguna salida.
//  value1:   Valor inicial de la rampa.
//  value2:   Valor final de la rampa.
//  dataSet:  Arrays del m�dulo "Liner" donde guardar los datos (0: ida, 1: vuelta).
//  npoints:  N�mero de puntos de la rampa.
//  jump:     N�mero de pasos intermedios en el DAC al variar cada valor de salida.
//  delay:    Tiempo de espera (en unidades arbitrarias) desde que se da la salida del DAC hasta que se leen los ADCs. (Sin implementar)
//  blockAcq: Indica si se dede adquirir toda la rampa como un bloque (tarda menos) o punto a punto (usa menos buffer de comunicaci�n).

function TDataForm.ramp_take(ndac, value1, value2, dataSet, npoints, jump, delay: Integer; blockAcq: Boolean): boolean;
var
i,j,Loc_ADCTopo,Loc_ADCI, Loc_ADCOther: Integer;
Loc_CalTopo,Loc_AmpTopo,Loc_AmpI,Loc_MultI,Loc_AmpOther,Loc_MultOther,Step,DacVal: Double;
ReceivesBytes, BytesToReceive: Integer;
adcRead: TVectorDouble;
BufferMem: Array[0..FT_Out_Buffer_Size] of Byte;
safeBufferSize: Integer; // Cuando el buffer se llene hasta esta cantidad de datos, los enviaremos. Debe ser sensiblemente menor que el tama�o del buffer para evitar que se desborde
BufferPtr: PAnsiChar;
SPI_Ret: FTC_STATUS;

begin

  safeBufferSize := Round(Length(BufferMem)*0.8);
  if (not blockAcq) then
    safeBufferSize := 0; // Si la adquisici�n es punto a punto no usamos el buffer y enviamos siempre los datos
  DacVal:=value1;
  Step:=(value2-value1)/(npoints*jump-1);

  //Cogemos variables de la config del scanner
  Loc_CalTopo:=ScanForm.CalTopo;
  Loc_AmpTopo:=ScanForm.AmpTopo;
  Loc_ADCTopo:=ScanForm.ADCTopo;

  Loc_AmpI:=ScanForm.AmpI;
  Loc_MultI:=ScanForm.MultI;
  Loc_ADCI:=ScanForm.ADCI;

  Loc_AmpOther:=ScanForm.AmpOther;
  Loc_MultOther:=ScanForm.MultOther;
  Loc_ADCOther:=ScanForm.ADCOther;

  // Lectura de UNA rampa de ida o vuelta
  BufferPtr := Addr(BufferMem[0]);
  i:=0;
  while (LinerForm.Abort_Measure=False) and (i<npoints) do
  begin
    j := 0;
    if not LinerForm.ReadXFromADC then
      LinerForm.DataX[dataSet,i]:=DacVal*LinerForm.x_axisMult/32768;

    while (j < jump) do
    begin
      BufferPtr := BufferPtr + dac_set(LinerForm.x_axisDAC, Round(DacVal), BufferPtr);
      DacVal := DacVal+Step;
      Inc(j);
      //if blockAcq then
        //Application.ProcessMessages; // Para que pueda hacer el feedback digital //Hermann
    end;

    if (blockAcq) then // Si la adquisici�n es por bloques, metemos tambi�n la lectura del ADC. Si es punto a punto mejor esperar a que d� la salida.
    begin
      adcRead := adc_take_all(LinerForm.LinerMean, AdcWriteCommand, BufferPtr);
      BufferPtr := BufferPtr + Round(adcRead[0]);
    end;

    // Si se llena el buffer, lo enviamos y empezamos de nuevo desde el principio
    if ((BufferPtr-Addr(BufferMem[0])) > safeBufferSize) then
    begin
      send_buffer(Addr(BufferMem[0]), BufferPtr-Addr(BufferMem[0]));
      BufferPtr := Addr(BufferMem[0]);
    end;

    // Si estamos adquiriendo punto a punto, adquirimos el punto que toque ahora
    // que hemos enviado el anterior. No lo meto en el mismo env�o para no
    // tener problemas de latencias. Si se usa la adquisici�n punto a punto es de
    // suponer que no hay prisa, podemos tardar un poco m�s en cada punto.
    if (not blockAcq) then
    begin
      adcRead:=adc_take_all(LinerForm.LinerMean, AdcWriteRead, nil);
      if LinerForm.ReadXFromADC then
        LinerForm.DataX[dataSet,i]:=adcRead[LinerForm.x_axisADC]*LinerForm.x_axisMult;

      if LinerForm.ReadZ then
      begin
        //if (Form1.DigitalPID) then
        //  LinerForm.DataZ[dataSet,i]:=Loc_CalTopo*Loc_AmpTopo*Action_PID/32768
        //else
          LinerForm.DataZ[dataSet,i]:=Loc_CalTopo*Loc_AmpTopo*adcRead[Loc_ADCTopo];
      end;

      //Hemos cambiado Loc_ADCI por x_axisADC en el primer par�metro de adc_take para que el canal de ADC sea el de config liner
      //Se vuelve a poner Loc_ADCI
      if LinerForm.ReadCurrent then
        LinerForm.DataCurrent[dataSet,i]:=Loc_AmpI*Loc_MultI*adcRead[Loc_ADCI];

      //Hermann, 19/11/2021. se a�ade una lectura de un ADC adicional
        if LinerForm.ReadOther then
        LinerForm.DataOther[dataSet,i]:=Loc_AmpOther*Loc_MultOther*adcRead[Loc_ADCOther];

    end;

    Inc(i);
  end;

  // Si la adquisici�n es punto a punto, ya habremos terminado. Salimos
  if (not blockAcq) then
  begin
      Result := True;
      Exit;
  end;

  // Tenemos un ciclo de latencia, por lo que env�o un dato m�s, para luego
  // despreciar el primero.
  adcRead := adc_take_all(1, AdcWriteCommand, BufferPtr);
  BufferPtr := BufferPtr + Round(adcRead[0]);

  // Env�a todos los datos del buffer
  send_buffer(Addr(BufferMem[0]), BufferPtr-Addr(BufferMem[0]));

  // Recibe los datos de los ADCs
  // La variable i tendr� el n�mero de puntos que realmente ha pedido. Si se ha
  // parado la adquisici�n a medias, ser� menor que PointNumber. Leemos los datos
  // que realmente hemos pedido. Aqu� no comprobamos si nos han pedido que paremos,
  // sacamos de los buffers todo lo que hemos pedido.

  // Sacamos el dato extra que hemos metido para compensar la latencia.
  adc_take_all(1, AdcReadData, nil);

  j := i;
  i:=0;
  while (i < j) do
  begin
    adcRead:=adc_take_all(LinerForm.LinerMean, AdcReadData, nil);
    if LinerForm.ReadXFromADC then
      LinerForm.DataX[dataSet,i]:=adcRead[LinerForm.x_axisADC]*LinerForm.x_axisMult;

    if LinerForm.ReadZ then
    begin
      //if (Form1.DigitalPID) then
      //  LinerForm.DataZ[dataSet,i]:=Loc_CalTopo*Loc_AmpTopo*Action_PID/32768
      //else
        LinerForm.DataZ[dataSet,i]:=Loc_CalTopo*Loc_AmpTopo*adcRead[Loc_ADCTopo];
    end;

    //Hemos cambiado Loc_ADCI por x_axisADC en el primer par�metro de adc_take para que el canal de ADC sea el de config liner
    // Volver a poner Loc_ADCI
    if LinerForm.ReadCurrent then
      LinerForm.DataCurrent[dataSet,i]:=Loc_AmpI*Loc_MultI*adcRead[Loc_ADCI];

    //Hemos cambiado Loc_ADCI por x_axisADC en el primer par�metro de adc_take para que el canal de ADC sea el de config liner
    // Volver a poner Loc_ADCI
    if LinerForm.ReadOther then
      LinerForm.DataOther[dataSet,i]:=Loc_AmpOther*Loc_MultOther*adcRead[Loc_ADCOther];

    i:=i+1;
  end;

  Result := True;
end;

//Implement a ramp procedure that allows to smoothly change between
//a larger set point voltage (Vset) and a reduced ramp voltage (Vstart)
//We want to go from Vset to Vstart without reading the ADCs and maybe a reduced number of steps,
// and then do a normal ramp_take prodcedure from Vstart to Vend
function TDataForm.ramp_take_reduce(ndac, value1, value2, dataSet, npoints, jump, delay: Integer; blockAcq: Boolean): boolean;
var
i,j,Loc_ADCTopo,Loc_ADCI, Loc_ADCOther: Integer;
Loc_CalTopo,Loc_AmpTopo,Loc_AmpI,Loc_MultI,Loc_AmpOther,Loc_MultOther,Step,DacVal: Double;
ReceivesBytes, BytesToReceive: Integer;
adcRead: TVectorDouble;
BufferMem: Array[0..FT_Out_Buffer_Size] of Byte;
safeBufferSize: Integer; // Cuando el buffer se llene hasta esta cantidad de datos, los enviaremos. Debe ser sensiblemente menor que el tama�o del buffer para evitar que se desborde
BufferPtr: PAnsiChar;
SPI_Ret: FTC_STATUS;

begin

  safeBufferSize := Round(Length(BufferMem)*0.8);
  if (not blockAcq) then
    safeBufferSize := 0; // Si la adquisici�n es punto a punto no usamos el buffer y enviamos siempre los datos
  DacVal:=value1;
  Step:=(value2-value1)/(npoints*jump-1);

  //Cogemos variables de la config del scanner
  Loc_CalTopo:=ScanForm.CalTopo;
  Loc_AmpTopo:=ScanForm.AmpTopo;
  Loc_ADCTopo:=ScanForm.ADCTopo;

  Loc_AmpI:=ScanForm.AmpI;
  Loc_MultI:=ScanForm.MultI;
  Loc_ADCI:=ScanForm.ADCI;

  Loc_AmpOther:=ScanForm.AmpOther;
  Loc_MultOther:=ScanForm.MultOther;
  Loc_ADCOther:=ScanForm.ADCOther;

  // Lectura de UNA rampa de ida o vuelta
  BufferPtr := Addr(BufferMem[0]);
  i:=0;
  while (LinerForm.Abort_Measure=False) and (i<npoints) do
  begin
    j := 0;
    if not LinerForm.ReadXFromADC then
      LinerForm.DataX[dataSet,i]:=DacVal*LinerForm.x_axisMult/32768;

    while (j < jump) do
    begin
      BufferPtr := BufferPtr + dac_set(LinerForm.x_axisDAC, Round(DacVal), BufferPtr);
      DacVal := DacVal+Step;
      Inc(j);
      //if blockAcq then
        //Application.ProcessMessages; // Para que pueda hacer el feedback digital //Hermann
    end;

    if (blockAcq) then // Si la adquisici�n es por bloques, metemos tambi�n la lectura del ADC. Si es punto a punto mejor esperar a que d� la salida.
    begin
      adcRead := adc_take_all(LinerForm.LinerMean, AdcWriteCommand, BufferPtr);
      BufferPtr := BufferPtr + Round(adcRead[0]);
    end;

    // Si se llena el buffer, lo enviamos y empezamos de nuevo desde el principio
    if ((BufferPtr-Addr(BufferMem[0])) > safeBufferSize) then
    begin
      send_buffer(Addr(BufferMem[0]), BufferPtr-Addr(BufferMem[0]));
      BufferPtr := Addr(BufferMem[0]);
    end;

    // Si estamos adquiriendo punto a punto, adquirimos el punto que toque ahora
    // que hemos enviado el anterior. No lo meto en el mismo env�o para no
    // tener problemas de latencias. Si se usa la adquisici�n punto a punto es de
    // suponer que no hay prisa, podemos tardar un poco m�s en cada punto.
    if (not blockAcq) then
    begin
      adcRead:=adc_take_all(LinerForm.LinerMean, AdcWriteRead, nil);
      if LinerForm.ReadXFromADC then
        LinerForm.DataX[dataSet,i]:=adcRead[LinerForm.x_axisADC]*LinerForm.x_axisMult;

      if LinerForm.ReadZ then
      begin
        //if (Form1.DigitalPID) then
        //  LinerForm.DataZ[dataSet,i]:=Loc_CalTopo*Loc_AmpTopo*Action_PID/32768
        //else
          LinerForm.DataZ[dataSet,i]:=Loc_CalTopo*Loc_AmpTopo*adcRead[Loc_ADCTopo];
      end;

      //Hemos cambiado Loc_ADCI por x_axisADC en el primer par�metro de adc_take para que el canal de ADC sea el de config liner
      //Se vuelve a poner Loc_ADCI
      if LinerForm.ReadCurrent then
        LinerForm.DataCurrent[dataSet,i]:=Loc_AmpI*Loc_MultI*adcRead[Loc_ADCI];

      //Hermann, 19/11/2021. se a�ade una lectura de un ADC adicional
        if LinerForm.ReadOther then
        LinerForm.DataOther[dataSet,i]:=Loc_AmpOther*Loc_MultOther*adcRead[Loc_ADCOther];

    end;

    Inc(i);
  end;

  // Si la adquisici�n es punto a punto, ya habremos terminado. Salimos
  if (not blockAcq) then
  begin
      Result := True;
      Exit;
  end;

  // Tenemos un ciclo de latencia, por lo que env�o un dato m�s, para luego
  // despreciar el primero.
  adcRead := adc_take_all(1, AdcWriteCommand, BufferPtr);
  BufferPtr := BufferPtr + Round(adcRead[0]);

  // Env�a todos los datos del buffer
  send_buffer(Addr(BufferMem[0]), BufferPtr-Addr(BufferMem[0]));

  // Recibe los datos de los ADCs
  // La variable i tendr� el n�mero de puntos que realmente ha pedido. Si se ha
  // parado la adquisici�n a medias, ser� menor que PointNumber. Leemos los datos
  // que realmente hemos pedido. Aqu� no comprobamos si nos han pedido que paremos,
  // sacamos de los buffers todo lo que hemos pedido.

  // Sacamos el dato extra que hemos metido para compensar la latencia.
  adc_take_all(1, AdcReadData, nil);

  j := i;
  i:=0;
  while (i < j) do
  begin
    adcRead:=adc_take_all(LinerForm.LinerMean, AdcReadData, nil);
    if LinerForm.ReadXFromADC then
      LinerForm.DataX[dataSet,i]:=adcRead[LinerForm.x_axisADC]*LinerForm.x_axisMult;

    if LinerForm.ReadZ then
    begin
      //if (Form1.DigitalPID) then
      //  LinerForm.DataZ[dataSet,i]:=Loc_CalTopo*Loc_AmpTopo*Action_PID/32768
      //else
        LinerForm.DataZ[dataSet,i]:=Loc_CalTopo*Loc_AmpTopo*adcRead[Loc_ADCTopo];
    end;

    //Hemos cambiado Loc_ADCI por x_axisADC en el primer par�metro de adc_take para que el canal de ADC sea el de config liner
    // Volver a poner Loc_ADCI
    if LinerForm.ReadCurrent then
      LinerForm.DataCurrent[dataSet,i]:=Loc_AmpI*Loc_MultI*adcRead[Loc_ADCI];

    //Hemos cambiado Loc_ADCI por x_axisADC en el primer par�metro de adc_take para que el canal de ADC sea el de config liner
    // Volver a poner Loc_ADCI
    if LinerForm.ReadOther then
      LinerForm.DataOther[dataSet,i]:=Loc_AmpOther*Loc_MultOther*adcRead[Loc_ADCOther];

    i:=i+1;
  end;

  Result := True;
end;

function TDataForm.send_buffer(bufferToSend: PAnsiChar; bytesToSend: Integer):FTC_STATUS;
var
BytesWritten: Integer;
SPI_Ret: Integer;
begin
  BytesWritten := 0;
  SPI_Ret :=  FT_Write(SupraSPI_Hdl, bufferToSend, bytesToSend, @BytesWritten);
  while bytesToSend <> BytesWritten do       // Si no ha podido enviar todo el buffer, lo volvemos a intentar. En el futuro se puede quitar el env�o anterior y hacerlo siempre aqu�
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

procedure TDataForm.set_dio_port(value: Word);
var
  BufferDest: PAnsiChar;
  i: Integer;
  SPI_Ret, BytesWritten: Integer;
  BufferOut: array [0..20] of Byte;
begin
  BufferDest := Addr(BufferOut[0]);

  // Construyo la cadena que se enviar�
  i := 0;
  (BufferDest+i)^ := Char(MPSSE_CmdSetPortL); Inc(i);
  (BufferDest+i)^ := Char($FE); Inc(i);
  (BufferDest+i)^ := Char($FF-Integer(pDI)); Inc(i);
  (BufferDest+i)^ := Char(MPSSE_CmdSetPortH); Inc(i);
  (BufferDest+i)^ := Char(0); Inc(i);
  (BufferDest+i)^ := Char($FF); Inc(i);
  (BufferDest+i)^ := Char(MPSSE_CmdWriteDO2); Inc(i);
  (BufferDest+i)^ := Char(2); Inc(i); // N�mero de bytes a transmitir menos 1
  (BufferDest+i)^ := Char(0); Inc(i);
  (BufferDest+i)^ := Char($40); Inc(i); // Direccion del chip y bits de control
  (BufferDest+i)^ := Char(9); Inc(i); // Registro de datos
  (BufferDest+i)^ := Char(value); Inc(i); // Valores de cada bit
  (BufferDest+i)^ := Char(MPSSE_CmdSendInmediate); Inc(i);
  (BufferDest+i)^ := Char(MPSSE_CmdSetPortH); Inc(i);
  (BufferDest+i)^ := Char(Integer(pDIOcs)); Inc(i); //No estoy seguro de que esto sea correcto
  (BufferDest+i)^ := Char($FF); Inc(i);
  (BufferDest+i)^ := Char(MPSSE_CmdSendInmediate); Inc(i);

  SPI_Ret :=  FT_Write(SupraSPI_Hdl, BufferDest, i, @BytesWritten);
  If (SPI_Ret <> 0) or (i <> BytesWritten) then
     if not simulating then MessageDlg('error al escribir el puerto digital', mtError, [mbOk], 0);
end;

procedure TDataForm.set_attenuator(DACAttNr: Integer; value: double);
var
  BufferDest: PAnsiChar;
  i: Integer;
  SPI_Ret, BytesWritten: Integer;
  BufferOut: array [0..20] of Byte;
  valueDAC: Word;
begin
  BufferDest := Addr(BufferOut[0]);

  // El atenuador se implementa mediante un DAC de 16 bits sin signo que usa la se�al a atenuar como referencia.
  // Para establecer el factor de atenuacion, mandamos una secuencia de 18 bits (2+18)
  // Los dos bit superiores indican el canal de destino, y el resto el valor de atenuacion
  // en la escala de salida del DAC comprendida entre 0 y 2^16 (65536 o $FFFF)

  // Para el valor m�ximo del DAC la salida ser� igual a la referencia.
  valueDAC := Round(value*$FFFF);

  // Construyo la cadena que se enviar�
  // esto habr� que cambiarlo todo para pasar a unicode
  i := 0;
  (BufferDest+i)^ := Char(MPSSE_CmdSetPortL); Inc(i);
  (BufferDest+i)^ := Char($FE-Integer(pAttcs)); Inc(i);
  (BufferDest+i)^ := Char($FF-Integer(pDI)); Inc(i);
  (BufferDest+i)^ := Char(MPSSE_CmdWriteDO2); Inc(i);
  (BufferDest+i)^ := Char(2); Inc(i); // N�mero de bytes a transmitir menos 1
  (BufferDest+i)^ := Char(0); Inc(i);
  //if ScanForm.VersionDivider=False then
  //if ScanForm.LHARev = 1 then
  //  begin
  //    (BufferDest+i)^ := Char(03); // Registro: Ambos DACs (Canales 0 y 2)
  //    Inc(i); //No usamos DACAttNr, porque siempre cambiamos los dos canales
  //    scan_attenuator := value;
  //  end
  //else
  //  begin
      case DACAttNr of
        // Version con solo 2 atenuadores:
        0: begin (BufferDest+i)^ := Char(03); scan_attenuator:=value; end; // Registro: Ambos DACs (Canales 0 y 2)
        // Version con 4 atenuadores:
        // La variable que guarda el factor de atenuacion de escaneo solo se cambia
        // una vez al llamar la funcion para el DAC A, pero afecta tambien al DAC B
        // Hay que tener cuidado de cambiar la atenuacion de ambos siempre a la vez
        1: begin (BufferDest+i)^ := Char(00); scan_attenuator:=value; end; // Registro: DAC A (Canal 0)
        2: (BufferDest+i)^ := Char(01); // Registro: DAC B (Canal 2)
        3: begin (BufferDest+i)^ := Char(02); z_attenuator:=value; end;// Registro: DAC C (Canal 5)
        4: begin (BufferDest+i)^ := Char(03); bias_attenuator:=value; end// Registro: DAC D (Canal 6)
      end;
      Inc(i);
  //  end;
  (BufferDest+i)^ := Char(Hi(valueDAC)); Inc(i);  // Parte alta del valor del DAC
  (BufferDest+i)^ := Char(Lo(valueDAC)); Inc(i); // Parte baja del valor del DAC
  (BufferDest+i)^ := Char(MPSSE_CmdSendInmediate); Inc(i);
  (BufferDest+i)^ := Char(MPSSE_CmdSetPortL); Inc(i);
  (BufferDest+i)^ := Char($FE); Inc(i);
  (BufferDest+i)^ := Char($FF-Integer(pDI)); Inc(i);
  (BufferDest+i)^ := Char(MPSSE_CmdSendInmediate); Inc(i);

  SPI_Ret :=  FT_Write(SupraSPI_Hdl, BufferDest, i, @BytesWritten);
  If (SPI_Ret <> 0) or (i <> BytesWritten) then
     if not simulating then MessageDlg('error al escribir el atenuador', mtError, [mbOk], 0);
end;

procedure TDataForm.set_attenuator_14b(DACAttNr: Integer; value: double);
var
  BufferDest: PAnsiChar;
  i: Integer;
  SPI_Ret, BytesWritten: Integer;
  BufferOut: array [0..20] of Byte;
  valueDAC: Word;
  shortValueDAC: Word;
begin
  BufferDest := Addr(BufferOut[0]);

  // El atenuador se implementa mediante un DAC de 14 bits sin signo que usa la se�al a atenuar como referencia.
  // Para establecer el factor de atenuacion, mandamos una secuencia de 16 bits (2+14)
  // Los dos bit superiores indican el canal de destino, y el resto el valor de atenuacion
  // en la escala de salida del DAC comprendida entre 0 y 2^14 (16384 o $3FFF)
  
  // Para el valor m�ximo del DAC la salida ser� igual a la referencia.
  valueDAC := Round(value*$3FFF);
  shortValueDAC := valueDAC and $3FFF; //Limpiamos los bits 14 y 15
  //Ahora introducimos el valor del DAC de destino en estos dos ultimos bits
  shortValueDAC := shortValueDAC or (Word(DACAttNr-1) shl 14);
  //Aqui introducirmos el resto de la logica que dependa del canal
  case DACAttNr of
    // La variable que guarda el factor de atenuacion de escaneo solo se cambia
    // una vez al llamar la funcion para el DAC A, pero afecta tambien al DAC B
    // Hay que tener cuidado de cambiar la atenuacion de ambos siempre a la vez
    1: scan_attenuator:=value; // Registro: DAC A (Canal 0)
    //2: // Registro: DAC B (Canal 2)
    3: z_attenuator:=value; // Registro: DAC C (Canal 5)
    4: bias_attenuator:=value; // Registro: DAC D (Canal 6)
  end;
  // Construyo la cadena que se enviar�
  // esto habr� que cambiarlo todo para pasar a unicode
  i := 0;
  (BufferDest+i)^ := Char(MPSSE_CmdSetPortL); Inc(i);
  (BufferDest+i)^ := Char($FE-Integer(pAttcs)); Inc(i);
  (BufferDest+i)^ := Char($FF-Integer(pDI)); Inc(i);
  (BufferDest+i)^ := Char(MPSSE_CmdWriteDO2); Inc(i);
  (BufferDest+i)^ := Char(1); Inc(i); // N�mero de bytes a transmitir menos 1
  (BufferDest+i)^ := Char(0); Inc(i);
  (BufferDest+i)^ := Char(Hi(shortValueDAC)); Inc(i);  // Parte alta del valor del DAC
  (BufferDest+i)^ := Char(Lo(shortValueDAC)); Inc(i); // Parte baja del valor del DAC
  (BufferDest+i)^ := Char(MPSSE_CmdSendInmediate); Inc(i);
  (BufferDest+i)^ := Char(MPSSE_CmdSetPortL); Inc(i);
  (BufferDest+i)^ := Char($FE); Inc(i);
  (BufferDest+i)^ := Char($FF-Integer(pDI)); Inc(i);
  (BufferDest+i)^ := Char(MPSSE_CmdSendInmediate); Inc(i);

  SPI_Ret :=  FT_Write(SupraSPI_Hdl, BufferDest, i, @BytesWritten);
  If (SPI_Ret <> 0) or (i <> BytesWritten) then
     if not simulating then MessageDlg('error al escribir el atenuador', mtError, [mbOk], 0);
end;


//Esta se queda
procedure TDataForm.Button1Click(Sender: TObject);
begin
InitDataAcq;
end;
//Esta se queda
procedure TDataForm.ScrollBar1Change(Sender: TObject);
var
numdac:SmallInt;
Value:SmallInt;
begin
numdac:=SpinEdit2.Value;
Value:=Scrollbar1.Position;

dac_set(numdac,Value, nil);
Label5.Caption:= FloatToStrF(10*Value/32768,ffGeneral,4,4);
end;
//Esta se queda
procedure TDataForm.FormCreate(Sender: TObject);
var
i: Integer;
begin
//Configuramos los las calibraciones a cero inicialmente
for i:=0 to NUM_DACs-1 do
with DACCal[i] do
begin
  Offset:=0;
  Gain:=0;
end;
InitDataAcq;
end;


//Esta se queda
procedure TDataForm.Button2Click(Sender: TObject);
var
mux,n: SmallInt;

begin
mux:=SpinEdit1.Value;
n:=SpinEdit3.Value;
Label3.Caption:=FloattoStr(adc_take(mux,mux,n));
end;

procedure TDataForm.Button3Click(Sender: TObject);
begin
ScrollBar1.Position:=0;
ScrollBar1Change(nil);
end;

procedure TDataForm.Button4Click(Sender: TObject);
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

procedure TDataForm.Button5Click(Sender: TObject);
begin
StopAction:=True;
Label7.Font.Color :=clRed;
Label7.Caption :='Not saving';
end;

procedure TDataForm.Edit1Change(Sender: TObject);
begin
Label8.Caption:='1';
end;

//Gain: set the registers 12 to 15 for DAC 0 to 3 respectively
//	The registers are 16bit long, but only the lower 8bits are relevant
//	The input value is a 8bit two's compliment value (from -128 to 127)
//	That means we can simply work with a ShortInt(Int8), and fill the Hi byte with zeros
//	Each step corresponds with 1 LSB step ajusment to the output gain

procedure TDataForm.dac_gain(ndac, offset: ShortInt; BufferOut: PAnsiChar);
var
  sele_dac: ShortInt;
  CadenaCS: Integer;
  BytesToWrite: Integer;
  BytesWritten:Integer;
  SPI_Ret: Integer;
  i: Integer;
  BufferDest: PAnsiChar;

begin


  // Para los primeros 4 canales de la electronica, tenemos que sumar 4 al valor que usamos,

  if (ndac  > 3) then
  begin
    CadenaCS:=$FF-Integer(pDAC2cs);  //DF
    sele_dac:=ndac+8;
  end
  else
  begin
    CadenaCS:=$FF-Integer(pDACcs);  //F7
    sele_dac:=ndac+12;
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

	// Construyo la cadena que se enviar�
	i := 0; // El primer caracter est� reservado para la longitud, se use o no.
	(BufferDest+i)^ := Char(MPSSE_CmdSetPortL); Inc(i);
	(BufferDest+i)^ := Char(CadenaCS); Inc(i);
	(BufferDest+i)^ := Char($FB); Inc(i);
	(BufferDest+i)^ := Char(MPSSE_CmdWriteDO); Inc(i);
	(BufferDest+i)^ := Char($02); Inc(i); // Numero de bytes a transmitir menos 1?
	(BufferDest+i)^ := Char($00); Inc(i);
	(BufferDest+i)^ := Char(sele_dac); Inc(i); //Registro?
	(BufferDest+i)^ := Char($00); Inc(i); // Byte superior del registro. Este valor va a ser ignorado
	(BufferDest+i)^ := Char(offset); Inc(i); // Byte inferior. Aqui introducimos el valor de la ganancia
	(BufferDest+i)^ := Char(MPSSE_CmdSendInmediate); Inc(i);
	(BufferDest+i)^ := Char(MPSSE_CmdSetPortL); Inc(i);
	(BufferDest+i)^ := Char($FF); Inc(i);
	(BufferDest+i)^ := Char($FB); Inc(i);
	
   if (BufferOut = nil) then
   begin
       BytesToWrite:= i;
       SPI_Ret :=  FT_Write(SupraSPI_Hdl, @(Buffer[1]), BytesToWrite, @BytesWritten);
       If (SPI_Ret <> 0) or (BytesToWrite <> BytesWritten) then
           if not simulating then MessageDlg('error al escribir un valor en el DAC', mtError, [mbOk], 0);
   end;

end;


//Zero Offset: set the registers 8 to 11 for DAC 0 to 3 respectively
//	The registers are 16bit long, but only the lower 9bits are relevant
//	The input value is a 9bit two's compliment value (from -256 to 255)
//	Each step corresponds with a 0.125 LSB (Least significant bit) adjustment to the output

procedure TDataForm.dac_zero_offset(ndac: ShortInt; offset: Int9; BufferOut: PAnsiChar);
var
  sele_dac: ShortInt;
  CadenaCS: Integer;
  SPI_Ret: Integer;
  BytesToWrite: Integer;
  BytesWritten:Integer;
  i: Integer;
  BufferDest: PAnsiChar;

begin


  // Para los primeros 4 canales de la electronica, tenemos que sumar 4 al valor que usamos,

  if (ndac  > 3) then
  begin
    CadenaCS:=$FF-Integer(pDAC2cs);  //DF
    sele_dac:=ndac+4;
  end
  else
  begin
    CadenaCS:=$FF-Integer(pDACcs);  //F7
    sele_dac:=ndac+8;
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

	// Construyo la cadena que se enviar�
	i := 0; // El primer caracter est� reservado para la longitud, se use o no.
	(BufferDest+i)^ := Char(MPSSE_CmdSetPortL); Inc(i);
	(BufferDest+i)^ := Char(CadenaCS); Inc(i);
	(BufferDest+i)^ := Char($FB); Inc(i);
	(BufferDest+i)^ := Char(MPSSE_CmdWriteDO); Inc(i);
	(BufferDest+i)^ := Char($02); Inc(i); // Numero de bytes a transmitir menos 1?
	(BufferDest+i)^ := Char($00); Inc(i);
	(BufferDest+i)^ := Char(sele_dac); Inc(i); //Registro?
  //if offset>=0 then (BufferDest+i)^ := Char($00)
  //else (BufferDest+i)^ := Char($01);Inc(i); //Byte superior del registro. Solo necesitamos el signo
  (BufferDest+i)^ := Char(Hi(offset) shr 7); Inc(i);//Byte superior del registro. Solo necesitamos el signo que es el bit superior
	(BufferDest+i)^ := Char(Lo(offset)); Inc(i); // Byte inferior del valor
	(BufferDest+i)^ := Char(MPSSE_CmdSendInmediate); Inc(i);
	(BufferDest+i)^ := Char(MPSSE_CmdSetPortL); Inc(i);
	(BufferDest+i)^ := Char($FF); Inc(i);
	(BufferDest+i)^ := Char($FB); Inc(i);
	
   if (BufferOut = nil) then
   begin
       BytesToWrite:= i;
       SPI_Ret :=  FT_Write(SupraSPI_Hdl, @(Buffer[1]), BytesToWrite, @BytesWritten);
       If (SPI_Ret <> 0) or (BytesToWrite <> BytesWritten) then
           if not simulating then MessageDlg('error al escribir un valor en el DAC', mtError, [mbOk], 0);
   end;

end;

procedure TDataForm.OffsetBtnClick(Sender: TObject);
begin
// probablemente deberiamos de comprobar que los valores introducidos en el spinedit son validos antes de pasarlos
DACCal[SetDACCorrection.Value].Offset:=OffsetValue.Value;
dac_zero_offset(SetDACCorrection.Value,OffsetValue.Value,nil);
// Podemos mostrar el offset aplicado en mV
end;

procedure TDataForm.GainBtnClick(Sender: TObject);
begin
// probablemente deberiamos de comprobar que los valores introducidos en el spinedit son validos antes de pasarlos
DACCal[SetDACCorrection.Value].Gain:=GainValue.Value;
dac_gain(SetDACCorrection.Value,GainValue.Value,nil);
end;

procedure TDataForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: Integer;
begin
CalFile := TMemIniFile.Create(FormConfig.ConfigDir+'\Calibrations.ini');
try
  for i:=0 to NUM_DACs-1 do
  with DACCal[i] do
  begin
    CalFile.WriteInteger(Format('DAC %d',[i]), 'Offset', Offset);
    CalFile.WriteInteger(Format('DAC %d',[i]), 'Gain', Gain);
  end;
finally
  CalFile.UpdateFile;
  CalFile.Free;
end;
end;
end.

