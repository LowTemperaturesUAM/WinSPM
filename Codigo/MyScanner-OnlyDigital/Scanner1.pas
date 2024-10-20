{

}

unit Scanner1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, var_gbl, Spin, Math, ClipBrd, jpeg, Paste, Series,
  Buttons;

type
  TCitsIV = array of single;        // Cada rampa de una IV
  TCitsLine = array of TCitsIV;     // Todas las rampas IV de una línea
  TCitsImage = array of TCitsLine;  // Todas las rampas IV de una imagen
  TImageSingle = Array [0..512,0..512] of Single;
  //definimos las revisiones de la electronica como una enumeracion de los posibles valores
  type TLHARev = (none,revB,revC=1,revD,revE);
  //asignamos la revision C con el mismo valor que B porque son iiguales en terminos de software

  TScanForm = class(TForm)
    ScanButton: TButton;
    TestButton: TButton;
    ConfigBtn: TButton;
    SaveAllImg: TCheckBox;
    Panel1: TPanel;
    ZoomInLbl: TLabel;
    ComboBox1: TComboBox;
    Panel2: TPanel;
    ComboBox2: TComboBox;
    Label2: TLabel;
    TrackBar1: TTrackBar;
    Label3: TLabel;
    Label4: TLabel;
    TrackBar2: TTrackBar;
    Label5: TLabel;
    Label6: TLabel;
    TrackBar3: TTrackBar;
    Label7: TLabel;
    Label8: TLabel;
    ClearBtn: TButton;
    MakeIVChk: TCheckBox;
    SaveImgButton: TButton;
    ScrollBox1: TScrollBox;
    PaintBox1: TPaintBox;
    StopBtn: TButton;
    RadioGroup1: TRadioGroup;
    OpenTripBtn: TButton;
    OpenLinerBtn: TButton;
    FileNameEdit: TEdit;
    Button3: TButton;
    ImgNumberSpin: TSpinEdit;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    HeaderImgBtn: TButton;
    SaveDialog1: TSaveDialog;
    CheckBox3: TCheckBox;
    ShowDirBtn: TButton;
    InitDACBtn: TButton;
    SpinEdit2: TSpinEdit;
    ScrollBar1: TScrollBar;
    OpenDataAcqBtn: TButton;
    CheckBox6: TCheckBox;
    OpenPIDBtn: TButton;
    btnMarkNow: TButton;
    PasteImgBtn: TButton;
    STSConfigBtn: TButton;
    ScrollBar2: TScrollBar;
    ScrollBar3: TScrollBar;
    btnCenterAtTip: TButton;
    MarkRedBtn: TButton;
    Button9: TSpeedButton;
    Panel3: TPanel;
    SpinLinesBefore: TSpinEdit;
    LblLinesBefore: TLabel;
    procedure ConfigBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure PaintBox1DblClick(Sender: TObject);
    procedure TrackBar3Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure ResetTipPosition();
    procedure Button9Click(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure TestButtonClick(Sender: TObject);
    procedure MakeLine(Sender:TObject; Saveit: Boolean; LineNr: Integer);
    procedure MakeEmptyLine(Sender:TObject; Saveit: Boolean);
    function  FilterImage(Image: TImageSingle; scanX: Boolean; numPoints, filterOrder: Integer) : HImg;
    function  FitToLine(dataX, dataY: vector; numPoints: Integer; out slope, ord: Single) : Boolean;
    //function  TakeOnePoint(Sender:TObject) : Single;
    procedure CreateCitsTempFiles();
    procedure DestroyCitsTempFiles();
    procedure CitsSeekToIV(row, column, point: Integer);
    procedure RedimCits(PointsXY, PointsIV: Integer);
    procedure OpenLinerBtnClick(Sender: TObject);
    procedure OpenTripBtnClick(Sender: TObject);
    procedure ScanButtonClick(Sender: TObject);
    procedure MoveDac(Sender: TObject; DacNr, init, fin, jump : integer; BufferOut: PAnsiChar);
    procedure SaveSTP(Sender: TObject; OneImg : HImg; Suffix: String; factorZ: double);
    procedure SaveCits(dataSet: Integer);
    procedure SetLengthofStr(Sender: TObject; MyLength: Integer; var MyString: String);
    procedure HeaderImgBtnClick(Sender: TObject);
    procedure SaveImgButtonClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SaveAllImgClick(Sender: TObject);
    procedure ShowDirBtnClick(Sender: TObject);
    procedure InitDACBtnClick(Sender: TObject);
    procedure OpenPIDBtnClick(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure OpenDataAcqBtnClick(Sender: TObject);
    procedure ResizeBitmap(Bitmap: TBitmap; Width, Height: Integer; Background: TColor);
    procedure ClearBtnClick(Sender: TObject);
    procedure MakeIVChkClick(Sender: TObject);
    procedure UpdateCanvas(Sender:TObject);
    procedure SetCanvasZoomFactor(Canvas: TCanvas; AZoomFactor: Integer);
    procedure PasteImgBtnClick(Sender: TObject);
    procedure STSConfigBtnClick(Sender: TObject);
    procedure SetCanvasZoomAndRotation(ACanvas: TCanvas; Zoom: Double; Angle: Double; CenterpointX, CenterpointY: Double);
    procedure ScrollBar2Change(Sender: TObject);
    procedure ScrollBar3Change(Sender: TObject);
    function PointGlobalToCanvas(pntGlobal: TPointFloat; canvasSize: Integer):TPoint;
    function PointCanvasToGlobal(pntCanvas: TPoint; canvasSize: Integer):TPointFloat;
    function StringToLengthNm(strValue: String):Single;
    procedure btnMarkNowClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SetNewOffset(pntClickedFloat: TPointFloat);
    procedure btnCenterAtTipClick(Sender: TObject);
    procedure MarkRedBtnClick(Sender: TObject);
    //procedure SpinEdit3Change(Sender: TObject);


  private
    { Private declarations }
  public
    { Public declarations }
//añadidas nuevas variables para leer other, noviembre de 2021.
  XDAC,YDAC,XDAC_Pos,YDAC_Pos, ADCTopo, ADCI, ADCOther, MultI, MultOther: Integer;
  AmpTopo, AmpI, AmpOther, AmpX,Ampy,AmpX_Pos,AmpY_Pos,CalTopo,CalX,CalY: Single;

  SleepDo: Integer;
  BiasDAC: Integer;
  MultBias: Single;
  ReadTopo, ReadCurrent, ReadOther: Boolean;
  PosXSTM,PosYSTM,DacValX,DacvalY: Integer;
  StopAction,PauseAction: Boolean;
  P_Scan_Mean, P_Scan_Jump, P_Scan_Lines, IV_Scan_Lines: Integer;
  P_Scan_Size : Single;
  //Images up to 512 pts, with x in 0 and y's in 1..2
  Dat_Image_Forth: Array [0..10] of TImageSingle;
  Dat_Image_Back: Array [0..10] of TImageSingle;
  Line_Image_Forth: Array [0..10,0..512] of Single;  // One line forth
  Line_Image_Back: Array [0..10,0..512] of Single;   // One line back
  One_Line: Array[0..10,0..512] of Single;
//  DataCurrentCits: Array[0..3] of TCitsImage; // cualquier combinación de ida y vuelta de la imagen y la IV
  CitsTempFile: Array[0..3] of TFileStream;
  CitsTempFileName: Array[0..3] of String;
  EraseLines: Integer;
  SizeOfWindow: Integer;
  h: TIMGHeader;
  DatatoPaint: Array[0..512,0..512] of Integer;
  DataMax, DataMin, DataCenter: Double;
  Limpiar: Boolean;
  P_Scan_Size_Old:Single;
  bitmapPasteList: array of TScanBitmap;
  bitmapPasteList2: array of TScanBitmap;
  contadorIV:Integer;
  PuntosTotales: Integer;
  PuntosMedidos: Integer;
  PuntosPonderados: Integer;
  TiempoMedio: Single;
  TiempoInicial: Int64;
  XOffset, YOffset: Double; // Posición central del área de barrido entre -1 y 1
  //VersionDivider: Boolean; // si la versión del LHA contiene divisores o no
  //LHARev: Byte; //Version de la electronica para tratar los atenuadores

  LHARev: TLHARev;
  end;

var
  ScanForm: TScanForm;

implementation

uses Config1, Scanning, Liner, Trip, HeaderImg, FileNames, DataAdcquisition,
  PID, Config_IV;


var
  F: TFileStream;

{$R *.DFM}

procedure TScanForm.ConfigBtnClick(Sender: TObject);
begin
FormConfig.Show;
end;

procedure TScanForm.FormShow(Sender: TObject);
begin
  //control sobre si la versión del LHA contiene divisores o no
//if Application.MessageBox('LHA Version with extra attenuators?','LHA version', MB_YESNO)=IDYES
//  then VersionDivider:=True
//  else VersionDivider:=False;
DecimalSeparator := '.'; //Fijamos el formato de los decimales
ThousandSeparator := #0;
FormConfig.Show;
XDAC:=FormConfig.SpinEdit1.Value;
YDAC:=FormConfig.SpinEdit2.Value;
XDAC_Pos:=FormConfig.SpinEdit6.Value;
YDAC_Pos:=FormConfig.SpinEdit7.Value;
AmpX:=StrtoFloat(FormConfig.Combobox1.Text);
AmpY:=StrtoFloat(FormConfig.Combobox2.Text);
AmpX_Pos:=StrtoFloat(FormConfig.Combobox6.Text);
AmpY_Pos:=StrtoFloat(FormConfig.Combobox7.Text);
CalX:=StrtoFloat(FormConfig.Edit1.Text);
CalY:=StrtoFloat(FormConfig.Edit2.Text);
ADCTopo:=FormConfig.TopoChanEdit.Value;
ADCI:=FormConfig.CurrentChanEdit.Value;
AmpTopo:=StrtoFloat(FormConfig.TopoAmpBox.Text);
AmpI:=power(10,-1*(StrtoFloat(FormConfig.CurrentAmpBox.Text)-1)); //El valor que leemos del ADC va entre +-1, no entre +-10 como el voltaje, asi que restamos 1
CalTopo:=StrtoFloat(FormConfig.TopoCalEdit.Text);
MultI:=StrtoInt(FormConfig.CurrentMultEdit.Text);
ReadTopo:=FormConfig.TopoCheck.checked;
ReadCurrent:=FormConfig.CurrentCheck.checked;


//FormConfig.Hide;
XOffset := 0;
YOffset := 0;
PosXSTM:=0;
PosYSTM:=0;
DacvalX:=0;
DacvalY:=0;
StopAction:=False;
PauseAction:=False;
P_Scan_Lines:=StrtoInt(ComboBox2.Text);
IV_Scan_Lines:=StrToInt(Form11.ComboBox1.Text);
P_Scan_Mean:=Trackbar1.Position;
P_Scan_Jump:= Trackbar2.Position;
P_Scan_Size:=Trackbar3.Position/1000;

// Preparamos el fichero o los ficheros temporales para manejar los CITs en formato WSxM
CreateCitsTempFiles();
RedimCits(IV_Scan_Lines, LinerForm.PointNumber);

//Limpiar:=True;
contadorIV:=1;

PuntosTotales:=P_Scan_Lines*P_Scan_Lines*2;

Label30.Caption:=FloattoStrF(65535*P_Scan_Size/32768*AmpX*DataForm.scan_attenuator*10,ffFixed,2,1);
Label32.Caption:=FloattoStrF(65535*P_Scan_Size/32768*AmpX*DataForm.scan_attenuator*10*CalX,ffFixed,2,1);
TrackBar3Change(nil); // Simulo que se ha cambiado el tamaño para que acutalice la interfaz
SizeOfWindow:=400;
StopAction:=True;
LinerForm.Show; //Estamos mostrando la ventana antes de que se cree, esto no parece buena idea
TripForm.Show;
FormPID.Show;
//Count_Live:= FormPID.SpinEdit4.Value;
//take_initialize;

// Hacemos un tip reset para asegurarnos de que la posición inicial es la central
ResetTipPosition();
UpdateCanvas(nil);
end;

procedure TScanForm.PaintBox1DblClick(Sender: TObject);
var
pntClicked: TPoint;
pntClickedFloat: TPointFloat;

begin
  // Calculo la posición donde se ha pulsado, referida al tamaño máximo de barrido (entre +/-1)
  pntClicked := PaintBox1.ScreenToClient(Mouse.CursorPos);
  pntClickedFloat := PointCanvasToGlobal(pntClicked, SizeOfWindow);
  SetNewOffset(pntClickedFloat);
end;

procedure TScanForm.SetNewOffset(pntClickedFloat: TPointFloat);
var
Princ,Fin: Integer;

begin
  XOffset := pntClickedFloat.x;
  YOffset := pntClickedFloat.y;

  // Por si acaso saturo, para no salirnos del área de barrido.
  if ((Abs(XOffset) > 1)) then
    XOffset := XOffset/Abs(XOffset);

  if ((Abs(YOffset) > 1)) then
    YOffset := YOffset/Abs(YOffset);

  Princ:=DacvalX;
  Fin:=Round(XOffset*32767);

  MoveDac(nil, XDAC_Pos, Princ, Fin, P_Scan_Jump, nil);

  DacValX:=Fin;
  Princ:=DacvalY;
  Fin:=Round(YOffset*32767);

  MoveDac(nil, YDAC_Pos, Princ, Fin, P_Scan_Jump, nil);

  DacvalY:=Fin;
  UpdateCanvas(nil);
end;

procedure TScanForm.TrackBar3Change(Sender: TObject);

begin
P_Scan_Size_Old:=P_Scan_Size;
Label8.Caption:=InttoStr(Trackbar3.Position);
P_Scan_Size:=Trackbar3.Position/1000;
Label30.Caption:=FloattoStrF(65535*P_Scan_Size/32768*AmpX*DataForm.scan_attenuator*10,ffFixed,3,1);
Label32.Caption:=FloattoStrF(65535*P_Scan_Size/32768*AmpX*DataForm.scan_attenuator*10*CalX,ffFixed,3,1);
UpdateCanvas(nil);
end;

procedure TScanForm.TrackBar2Change(Sender: TObject);
begin
Label6.Caption:=InttoStr(Trackbar2.Position);
P_Scan_Jump:= Trackbar2.Position;
TopoForm.TrackBar2.Position:=TrackBar2.Position;
TiempoMedio:=0;
PuntosPonderados:=0;
TiempoInicial:=0; // Inidicamos que no es un tiempo válido
end;

procedure TScanForm.TrackBar1Change(Sender: TObject);
begin
Label4.Caption:=InttoStr(Trackbar1.Position);
P_Scan_Mean:=Trackbar1.Position;
TopoForm.TrackBar1.Position:=TrackBar1.Position;
TiempoMedio:=0;
PuntosPonderados:=0;
TiempoInicial:=0; // Inidicamos que no es un tiempo válido
end;

procedure TScanForm.ResetTipPosition();
var
pointCenter: TPointFloat;
begin
  ScrollBar2.Position:=Round(ScrollBar2.max/2);
  ScrollBar3.Position:=Round(ScrollBar3.max/2);
  pointCenter.x := 0;
  pointCenter.y := 0;
  ScanForm.SetNewOffset(pointCenter);
end;

procedure TScanForm.Button9Click(Sender: TObject);
begin
if Application.MessageBox('Are you sure you want to reset the position?','Confirm Tip Reset', MB_YESNO)=IDYES
  then ResetTipPosition();
end;

procedure TScanForm.StopBtnClick(Sender: TObject);
begin
TopoForm.ScanLoop.Checked:=False;
StopAction:=True;
end;

procedure TScanForm.SetCanvasZoomFactor(Canvas: TCanvas; AZoomFactor: Integer);

begin
  if AZoomFactor = 100 then
    SetMapMode(Canvas.Handle, MM_TEXT)
  else
  begin
    SetMapMode(Canvas.Handle, MM_ISOTROPIC);
    SetWindowExtEx(Canvas.Handle, 100, 100, nil);
    SetViewportExtEx(Canvas.Handle, AZoomFactor, AZoomFactor, nil);
  end;
end;

Procedure TScanForm.SetCanvasZoomAndRotation(ACanvas: TCanvas; Zoom: Double;
  Angle: Double; CenterpointX, CenterpointY: Double);
var
  form: tagXFORM;
  rAngle: Double;
begin
  rAngle := DegToRad(Angle);
  SetGraphicsMode(ACanvas.Handle, GM_ADVANCED);
  SetMapMode(ACanvas.Handle, MM_ANISOTROPIC);
  form.eM11 := Zoom * Cos(rAngle);
  form.eM12 := Zoom * Sin(rAngle);
  form.eM21 := Zoom * (-Sin(rAngle));
  form.eM22 := Zoom * Cos(rAngle);
  form.eDx := CenterpointX;
  form.eDy := CenterpointY;
  SetWorldTransform(ACanvas.Handle, form);
end;

procedure TScanForm.PaintBox1Paint(Sender: TObject);
begin
UpdateCanvas(nil);
end;

procedure TScanForm.ComboBox1Change(Sender: TObject);
var
  halfScrollSize, oldPosX, oldPosY: Single;
const
  zoomFactor: Integer = 1;
begin
  // Para que los pasos sean más suaves ajusto el número de pasos permitidos en
  // las barras de desplazamiento.

  // Intento mantener sin moverse el punto central del cuadro que se pinta
  halfScrollSize := ScrollBar2.Max/2;
  oldPosX := (ScrollBar3.Position-halfScrollSize)/halfScrollSize;
  oldPosY := (ScrollBar2.Position-halfScrollSize)/halfScrollSize;

  // Corrijo el efecto de que el zoom se ajusta para que no se salga del área de barrido
  oldPosX := oldPosX*(zoomFactor-1)/zoomFactor;
  oldPosY := oldPosY*(zoomFactor-1)/zoomFactor;

  zoomFactor := StrToInt(ComboBox1.Text);
  halfScrollSize := 50*zoomFactor;
  ScrollBar2.Max := Round(2*halfScrollSize);
  ScrollBar3.Max := ScrollBar2.Max; // Muy importante que sea el mismo valor

  // Restauro las posiciones relativas
  if zoomFactor = 1 then
  begin
    ScrollBar3.Position := Round(halfScrollSize);
    ScrollBar2.Position := Round(halfScrollSize);
  end
  else
  begin
    ScrollBar3.Position := Round((oldPosX*zoomFactor/(zoomFactor-1)+1)*halfScrollSize);
    ScrollBar2.Position := Round((oldPosY*zoomFactor/(zoomFactor-1)+1)*halfScrollSize)
  end;

  UpdateCanvas(nil);
end;

procedure TScanForm.ComboBox2Change(Sender: TObject);
begin
P_Scan_Lines:=StrtoInt(ComboBox2.Text);  // Número de filas y columnas
Form11.ComboBox1.ItemIndex := ComboBox2.ItemIndex;
Form11.ComboBox1Change(nil)
end;

procedure TScanForm.TestButtonClick(Sender: TObject);
var
k, Prin,OldEraseLines: Integer;
A:Boolean;
begin
TryStrToInt(TopoForm.SpinEdit1.Text, OldEraseLines);;
//Si no mostramos ninguna linea en el scan, lo cambiamos a 2 para test
if OldEraseLines = 0 then
  begin
  EraseLines := 2;
  TopoForm.SpinEdit1.Text := FloattoStr(EraseLines);
  end;

//FormPID.se1.Text:='0';    //Comentado por Fran

A:=False;
if MakeIVChk.Checked=True then A:=True;
MakeIVChk.Checked:=False;
StopAction:=False;
StopBtn.Enabled:=True;
TopoForm.Show;

//Llevar el DAC a la posición inicial
Prin:=Round(int(32767*P_Scan_Size));
if (RadioGroup1.ItemIndex=0) then MoveDac(nil, XDAC, 0, -Prin, P_Scan_Jump, nil) // Scan en X Hay que llevar el DAC a cero
else MoveDac(nil, YDAC, 0, -Prin, P_Scan_Jump, nil); // Scan en Y Hay que llevar el DAC a cero

 k:=0;
while (StopAction<>True) do
 begin
   k:=k+1;
   TryStrToInt(TopoForm.SpinEdit1.Text, EraseLines);
 MakeLine(nil, False, 0);
 Application.ProcessMessages;
 if (k>=EraseLines) then
 begin
   TopoForm.ClearChart();
   k:=0;
 end;
 end;

// Para devolver la punta a su sitio, hace falta el último valor en el que está el DAC. Se lleva a makeline
//Fin:=Round(int(32767*P_Scan_Size)); //Vale tanto para el test en X como en Y
//if (RadioGroup1.ItemIndex=0) then MoveDac(nil, XDAC, Fin, 0, P_Scan_Jump, nil) // Scan en X Hay que llevar el DAC a cero
//else MoveDac(nil, YDAC, Fin, 0, P_Scan_Jump, nil); // Scan en Y Hay que llevar el DAC a cero

StopBtn.Enabled:=False;
//CrossPosX:=Round(DacValX/32768*200+200);
//CrossPosY:=Round(-DacValY/32768*200+200);
//ScanForm.PaintBox1DblClick(nil);  No descomentar estas línea tal cual. En lugar de eso usar la función SetNewOffset calculando previamente el punto. (0, 0) si es ir al centro.

//Volvemos a la configuracion del scan previa
EraseLines := OldEraseLines;
TopoForm.SpinEdit1.Text := FloattoStr(EraseLines);

TopoForm.Close;
if A=True then MakeIVChk.Checked:=True;
end;

procedure TScanForm.Makeline(Sender: TObject; Saveit: Boolean; LineNr: Integer);
var
i,j,k,total,OldX,OldY,LastX,LastY, channelToPlot, flatten: Integer;
Princ,Princ2,Fin,Step: Integer;
hour,mnts,scnd,remtm: Integer;
xvolt,yvolt,yFactor: single;
MakeX: Boolean;
interv, zeroSingle: Single;
Data:HImg;
C2,F:Int64;
adcRead: TVectorDouble;
ChartLineSerie0, ChartLineSerie1: TFastLineSeries;

begin
zeroSingle := 0; // Para completar con ceros el fichero

// Creamos las series (líneas que se dibujarán) en el gráfico
ChartLineSerie0 := TFastLineSeries.Create(self);
ChartLineSerie1 := TFastLineSeries.Create(self);
ChartLineSerie0.ParentChart := TopoForm.ChartLine;
ChartLineSerie1.ParentChart := TopoForm.ChartLine;
ChartLineSerie0.LinePen.Color := clred;
ChartLineSerie1.LinePen.Color := clblack;
TopoForm.ChartLine.AddSeries(ChartLineSerie0);
TopoForm.ChartLine.AddSeries(ChartLineSerie1);

if RadioGroup1.ItemIndex=0 then MakeX:=True
else MakeX:=False;

OldX:=0; // dado que son dacs diferentes, el dac del barrido está en 0
OldY:=0;

LastX:=0;
LastY:=0;

{if (RadioGroup1.ItemIndex=0) then
  MakeX:=True
else
  MakeY:=True;}

  //modify rounding, Hermann 22/09/2020
if MakeX then
  begin
   Princ:=OldX-Round(32768*P_Scan_Size);
  end
else
  begin
  Princ:=OldY-Round(32768*P_Scan_Size);
  end;
if (P_Scan_Size=0) then
  P_Scan_Size:=1;

if MakeX then
  Fin:=OldX+Round(32768*P_Scan_Size)
else
  Fin:=OldY+Round(32768*P_Scan_Size);

if (abs(Fin)>32768) or (Princ<-32768) then
begin
  StopAction:=True;
  exit;
end;

total:=Round(abs(Princ-Fin));

if Fin>Princ then Step:=Round(total/P_Scan_Lines);
if (Step=0) then Step:=100;

//esta comprobación deberiamos hacerla al hacer un DO o un Test, no en cada linea
if (IV_Scan_Lines>P_Scan_Lines) and (MakeIVChk.Checked) then
begin
  MessageDlg('Spectro: too many points',mtError,[mbOK],0);
  IV_Scan_Lines:=P_Scan_Lines;
  RedimCits(IV_Scan_Lines, LinerForm.PointNumber);
end;
//Increase the X axis of the chart by 5% because the points seem to be outside sometimes
TopoForm.ChartLine.BottomAxis.SetMinMax(Min(Princ, Fin)/32768*AmpX*DataForm.scan_attenuator*10*CalX*1.05, Max(Princ, Fin)/32768*AmpX*DataForm.scan_attenuator*10*CalX*1.05);

if (TopoForm.RadioGroup1.ItemIndex = 0) then // Topo
begin
  channelToPlot := 1;
  yFactor := StrtoFloat(FormConfig.TopoCalEdit.Text)*StrtoFloat(FormConfig.TopoAmpBox.Text);//ScanForm.CalTopo*ScanForm.AmpTopo;
end
else // Current
begin
  channelToPlot := 2;
  yFactor := ScanForm.MultI*ScanForm.AmpI;
end;

//Forth
i:=0;

QueryPerformanceFrequency(F);
while (i<P_Scan_Lines) do
begin
  while (PauseAction=True) do
  begin
    PuntosPonderados:=0;
    TiempoInicial:=0;
    Application.ProcessMessages;
  end;
  //Deberiamos resetear el tiempo inicial y los puntos ponderados a 0 si ha habido una pausa
  // para evitar errores grandes en la estimacion del tiempo
  PuntosMedidos:=PuntosMedidos+1;
  PuntosPonderados:=PuntosPonderados+1;

  // Si el cronómetro estaba parado, lo arrancamos
  if TiempoInicial = 0 then
    QueryPerformanceCounter(TiempoInicial);

  if MakeX then OldX:=Princ+Step*i else OldY:=Princ+Step*i;
  if MakeX then  // Scan in X
  begin
    if (not StopAction) then
      begin
      if (i<>0)then MoveDac(nil, XDAC, Princ+Step*(i-1), OldX, P_Scan_Jump, nil);     // El primer paso debe de quedarse quieto !
      LastX:=OldX; // hay que acordarse de donde se sale para volver a aparcar la punta. Esto está un poco mal
      // lo del temporizador lo deja todo muy oscuro, no comprendo bien el resto del código. Hermann 22/09/20
      end;

    if (ContadorIV=P_Scan_Lines/IV_Scan_Lines) then
    begin
      if (MakeIVChk.Checked)  and (Form11.CheckBox1.Checked) then
      begin
        CitsSeekToIV(Floor(LineNr/ContadorIV), Floor(i/ContadorIV), 0);  // el i cambiado por Hermann

        if StopAction then // Si nos han pedido que paremos ponemos a cero los valores que faltan por adquirir.
        for k := 0 to LinerForm.PointNumber-1 do
          begin
            CitsTempFile[0].Write(zeroSingle, SizeOf(zeroSingle));
            CitsTempFile[1].Write(zeroSingle, SizeOf(zeroSingle));
          end
        else // Hay que continuar con la adquisición
        begin
          LinerForm.Button1Click(nil); //Make IV con espectro
          // Los datos adquiridos están en LinerForm.DataCurrent. Los guardamos donde toque
          // en el orden que toque
          for k := 0 to LinerForm.PointNumber-1 do
          begin
            CitsTempFile[0].Write(LinerForm.DataCurrent[0][k], SizeOf(LinerForm.DataCurrent[0][k]));
            CitsTempFile[1].Write(LinerForm.DataCurrent[1][LinerForm.PointNumber-1-k], SizeOf(LinerForm.DataCurrent[1][LinerForm.PointNumber-1-k]));
          end;
        end;
        ContadorIV:=1;
      end;
    end
    else
    begin
      ContadorIV:=ContadorIV+1;
    end;

    xVolt:=OldX/32768*AmpX*10;
    Dat_Image_Forth[0,P_Scan_Lines-1-LineNr,i]:=xVolt*CalX;
    if StopAction then
    begin
      Dat_Image_Forth[1,P_Scan_Lines-1-LineNr,i]:=0;
      Dat_Image_Forth[2,P_Scan_Lines-1-LineNr,i]:=0;
    end
    else
    begin
      adcRead:=DataForm.adc_take_all(P_Scan_Mean, AdcWriteRead, nil);

      if ReadTopo=True then
      begin
        //if (DigitalPID) then
        //  Dat_Image_Forth[1,LineNr,i]:=Action_PID/32768
        //else
          Dat_Image_Forth[1,P_Scan_Lines-1-LineNr,i]:=adcRead[ADCTopo];
      end;

      if ReadCurrent=True then
        Dat_Image_Forth[2,P_Scan_Lines-1-LineNr,i]:=adcRead[ADCI];
    end;

    //añadido por Hermann 22/09/2020. Solo pinta si eraselines es mayor que cero
    //no estamos teniendo en cuenta si los atenuadores están activados
    if (EraseLines>0) then ChartLineSerie0.AddXY(Dat_Image_Forth[0,P_Scan_Lines-1-LineNr,i]*DataForm.scan_attenuator,10*yFactor*Dat_Image_Forth[channelToPlot,P_Scan_Lines-1-LineNr,i]);
  end
  else   // Scan in Y
  begin
    if (not StopAction) then
      begin
        if (i<>0) then MoveDac(nil, YDAC, Princ+Step*(i-1), OldY, P_Scan_Jump, nil);  // solo debe de moverse cuando i<>0
        LastY:=OldY; // Lo mismo que arriba.
      end;

    if (ContadorIV=P_Scan_Lines/IV_Scan_Lines) then
    begin
      if (MakeIVChk.Checked)  and (Form11.CheckBox1.Checked) then
      begin
        CitsSeekToIV(Floor(i/ContadorIV), Floor(LineNr/ContadorIV), 0);

        if StopAction then  // Si nos han pedido que paremos ponemos a cero los valores que faltan por adquirir.
        begin
            CitsTempFile[0].Write(zeroSingle, SizeOf(zeroSingle));
            CitsTempFile[1].Write(zeroSingle, SizeOf(zeroSingle));
        end
        else
        begin
          LinerForm.Button1Click(nil); //Make IV con espectro
          // Los datos adquiridos están en LinerForm.DataCurrent. Los guardamos donde toque
          // en el orden que toque
          for k := 0 to LinerForm.PointNumber-1 do
          begin
            CitsTempFile[0].Write(LinerForm.DataCurrent[0][k], SizeOf(LinerForm.DataCurrent[0][k]));
            CitsTempFile[1].Write(LinerForm.DataCurrent[1][LinerForm.PointNumber-1-k], SizeOf(LinerForm.DataCurrent[1][LinerForm.PointNumber-1-k]));
          end;
        end;
        ContadorIV:=1;
      end;
    end
    else
    begin
      ContadorIV:=ContadorIV+1;
    end;

    yVolt:=OldY/32768*AmpY*10;
    Dat_Image_Forth[0,P_Scan_Lines-1-i,LineNr]:=yVolt*CalY;

    if StopAction then
    begin
      Dat_Image_Forth[1,P_Scan_Lines-1-i,LineNr]:=0;
      Dat_Image_Forth[2,P_Scan_Lines-1-i,LineNr]:=0;
    end
    else
    begin
        adcRead:=DataForm.adc_take_all(P_Scan_Mean, AdcWriteRead, nil);
      if ReadTopo=True then
      begin
        //if (DigitalPID) then
        //  Dat_Image_Forth[1,i,LineNr]:=Action_PID/32768
        //else
          Dat_Image_Forth[1,P_Scan_Lines-1-i,LineNr]:=adcRead[ADCTopo];
      end;
      if ReadCurrent=True then Dat_Image_Forth[2,P_Scan_Lines-1-i,LineNr]:=adcRead[ADCI];
    end;

    //añadido por Hermann 22/09/2020. Solo pinta si eraselines es mayor que cero
    if (EraseLines>0) then ChartLineSerie0.AddXY(Dat_Image_Forth[0,P_Scan_Lines-1-i,LineNr]*DataForm.scan_attenuator,10*yFactor*Dat_Image_Forth[channelToPlot,P_Scan_Lines-1-i,LineNr]);
  end;

  QueryPerformanceCounter(C2); // Lectura del cronómetro
  TiempoMedio:=(C2-TiempoInicial)/(F*PuntosPonderados+1); // El +1 es para evitar dividir entre 0. No supondrá mucho error
  if TopoForm.CheckBox3.Checked then
    begin
    remtm := Trunc((PuntosTotales-PuntosMedidos)*TiempoMedio);
    hour:= remtm div 3600;
    remtm:= remtm mod 3600;
    mnts := remtm div 60;
    scnd := remtm mod 60;
    TopoForm.Label6.Caption :=  FloatToStr(hour) +':'+Format('%.2d',[mnts])+':'+Format('%.2d',[scnd]);
    end;

  Application.ProcessMessages;
  i:=i+1;
end;
contadorIV:=1;

//Back

i:=0;
if MakeX then Princ2:=OldX else Princ2:=OldY;
while (i<P_Scan_Lines)  do
begin
  while (PauseAction=True) do
  begin
    PuntosPonderados:=0;
    TiempoInicial:=0;
    Application.ProcessMessages;
  end;

  PuntosMedidos:=PuntosMedidos+1;
  PuntosPonderados:=PuntosPonderados+1;

  // Si el cronómetro estaba parado, lo arrancamos
  if TiempoInicial = 0 then
    QueryPerformanceCounter(TiempoInicial);

  if MakeX then OldX:=Princ2-Step*i else OldY:=Princ2-Step*i;
  if MakeX then
  begin
    if (not StopAction) then
      begin
        if (i<>0) then MoveDac(nil, XDAC, Princ2-Step*(i-1), OldX, P_Scan_Jump, nil);  //solo debe de moverse cuando ya ha empezado
        LastX:=OldX;
      end;
    if (ContadorIV=P_Scan_Lines/IV_Scan_Lines) then
    begin
      CitsSeekToIV(Floor(LineNr/ContadorIV), Floor(i/ContadorIV), 0);

      if (MakeIVChk.Checked)  and (Form11.CheckBox2.Checked) then
      begin
        if StopAction then // Si nos han pedido que paremos ponemos a cero los valores que faltan por adquirir.
        begin
          for k := 0 to LinerForm.PointNumber-1 do
          begin
            CitsTempFile[2].Write(zeroSingle, SizeOf(zeroSingle));
            CitsTempFile[3].Write(zeroSingle, SizeOf(zeroSingle));
          end;
        end
        else
        begin
          LinerForm.Button1Click(nil); //Make IV con espectro
          // Los datos adquiridos están en LinerForm.DataCurrent. Los guardamos donde toque
          // en el orden que toque
          for k := 0 to LinerForm.PointNumber-1 do
          begin
            CitsTempFile[2].Write(LinerForm.DataCurrent[0][k], SizeOf(LinerForm.DataCurrent[0][k]));
            CitsTempFile[3].Write(LinerForm.DataCurrent[1][LinerForm.PointNumber-1-k], SizeOf(LinerForm.DataCurrent[1][LinerForm.PointNumber-1-k]));
          end;
        end;
        ContadorIV:=1;
      end;
    end
    else
    begin
      ContadorIV:=ContadorIV+1;
    end;

    xVolt:=OldX/32768*AmpX*10;

    // Nacho Horcas, diciembre de 2017. Cambio el orden en el que se guardan los
    // datos para que la izquierda sea la misma posición X tanto en la ida como
    // en la vuelta, en lugar de que sea el punto que se adquirió primero
    Dat_Image_Back[0,P_Scan_Lines-1-LineNr,P_Scan_Lines-i-1]:=xVolt*CalX;

    if StopAction then
    begin
      Dat_Image_Back[1,P_Scan_Lines-1-LineNr,P_Scan_Lines-i-1]:=0;
      Dat_Image_Back[2,P_Scan_Lines-1-LineNr,P_Scan_Lines-i-1]:=0;
    end
    else
    begin
      adcRead:=DataForm.adc_take_all(P_Scan_Mean, AdcWriteRead, nil);
      if ReadTopo=True then
      begin
        //if (DigitalPID) then
        //  Dat_Image_Back[1,LineNr,P_Scan_Lines-i-1]:=Action_PID/32768
        //else
          Dat_Image_Back[1,P_Scan_Lines-1-LineNr,P_Scan_Lines-i-1]:=adcRead[ADCTopo];
      end;

      if ReadCurrent=True then Dat_Image_Back[2,P_Scan_Lines-1-LineNr,P_Scan_Lines-i-1]:=adcRead[ADCI];
    end;

    //añadido por Hermann 22/09/2020. Solo pinta si eraselines es mayor que cero
    if (EraseLines>0) then ChartLineSerie1.AddXY(Dat_Image_Back[0,P_Scan_Lines-1-LineNr,P_Scan_Lines-i-1]*DataForm.scan_attenuator,10*yFactor*Dat_Image_Back[channelToPlot,P_Scan_Lines-1-LineNr,P_Scan_Lines-i-1]);
  end
  else
  begin
    if (not StopAction) then
      begin
        if (i<>0) then MoveDac(nil, YDAC, Princ2-Step*(i-1), OldY, P_Scan_Jump, nil);  // solo moverse cuando empezado
        LastY:=OldY;
      end;

    if (ContadorIV=P_Scan_Lines/IV_Scan_Lines) then
    begin
      if (MakeIVChk.Checked)  and (Form11.CheckBox2.Checked) then
      begin
        CitsSeekToIV(Floor(P_Scan_Lines-i-1/ContadorIV), Floor(LineNr/ContadorIV), 0);

        if StopAction then // Si nos han pedido que paremos ponemos a cero los valores que faltan por adquirir.
        begin
          for k := 0 to LinerForm.PointNumber-1 do
          begin
            CitsTempFile[2].Write(zeroSingle, SizeOf(zeroSingle));
            CitsTempFile[3].Write(zeroSingle, SizeOf(zeroSingle));
          end;
        end
        else
        begin
          LinerForm.Button1Click(nil); //Make IV con espectro
          // Los datos adquiridos están en LinerForm.DataCurrent. Los guardamos donde toque
          // en el orden que toque
          for k := 0 to LinerForm.PointNumber-1 do
          begin
            CitsTempFile[2].Write(LinerForm.DataCurrent[0][k], SizeOf(LinerForm.DataCurrent[0][k]));
            CitsTempFile[3].Write(LinerForm.DataCurrent[1][LinerForm.PointNumber-1-k], SizeOf(LinerForm.DataCurrent[1][LinerForm.PointNumber-1-k]));
          end;
        end;
        ContadorIV:=1;
      end;
    end
    else
    begin
      ContadorIV:=ContadorIV+1;
    end;

    yVolt:=OldY/32768*AmpY*10;
    Dat_Image_Back[0,P_Scan_Lines-i-1,LineNr]:=yVolt*CalY;

    if StopAction then
    begin
      Dat_Image_Back[1,P_Scan_Lines-i-1,LineNr]:=0;
      Dat_Image_Back[2,P_Scan_Lines-i-1,LineNr]:=0;
    end
    else
    begin
      adcRead:=DataForm.adc_take_all(P_Scan_Mean, AdcWriteRead, nil);
      if ReadTopo=True then
      begin
        //if (DigitalPID) then
        //  Dat_Image_Back[1,P_Scan_Lines-i-1,LineNr]:=Action_PID/32768
        //else
          Dat_Image_Back[1,i,LineNr]:=adcRead[ADCTopo];
      end;
      if ReadCurrent=True then Dat_Image_Back[2,i,LineNr]:=adcRead[ADCI];
    end;

    //añadido por Hermann 22/09/2020. Solo pinta si eraselines es mayor que cero
    if (EraseLines>0) then ChartLineSerie1.AddXY(Dat_Image_Back[0,P_Scan_Lines-i-1,LineNr]*DataForm.scan_attenuator,10*yFactor*Dat_Image_Back[channelToPlot,i,LineNr]);
  end;

    QueryPerformanceCounter(C2); // Lectura del cronómetro
    TiempoMedio:=(C2-TiempoInicial)/(F*PuntosPonderados+1); // El +1 es para evitar dividir entre 0. No supondrá mucho error
    if TopoForm.CheckBox3.Checked then
    begin
    remtm := Trunc((PuntosTotales-PuntosMedidos)*TiempoMedio);
    hour:= remtm div 3600;
    remtm:= remtm mod 3600;
    mnts := remtm div 60;
    scnd := remtm mod 60;
    TopoForm.Label6.Caption := FloatToStr(hour) +':'+Format('%.2d',[mnts])+':'+Format('%.2d',[scnd]);
    end;
    
    Application.ProcessMessages;
    i:=i+1;
end;

if StopAction then
begin
  // Si salimos, hay que llevar la punta a su sitio
  if MakeX then MoveDac(nil, XDAC, LastX, 0, P_Scan_Jump, nil)
  else MoveDac(nil, YDAC, LastY, 0, P_Scan_Jump, nil);
end;

// Se podría actualizar la gráfica de la curva sólo aquí, por eficiencia
// TopoForm.xyyGraph1.Update;

contadorIV:=1;

if Saveit then
begin
  TopoForm.UpdateBitmaps(nil);
end;
end;

procedure TScanForm.MakeEmptyLine(Sender: TObject; Saveit: Boolean);
var
i,total,OldX,OldY,LastX,LastY, channelToPlot: Integer;
Princ,Princ2,Fin,Step: Integer;
//hour,mnts,scnd,remtm: Integer;
xvolt,yvolt,yFactor: single;
MakeX: Boolean;
//zeroSingle: Single;
//Data:HImg;
//C2,F:Int64;
adcRead: TVectorDouble;
ChartLineSerie0, ChartLineSerie1: TFastLineSeries;
xVal, yVal: Array [0..10] of single;

begin
//zeroSingle := 0; // Para completar con ceros el fichero

// Creamos las series (líneas que se dibujarán) en el gráfico
ChartLineSerie0 := TFastLineSeries.Create(self);
ChartLineSerie1 := TFastLineSeries.Create(self);
ChartLineSerie0.ParentChart := TopoForm.ChartLine;
ChartLineSerie1.ParentChart := TopoForm.ChartLine;
ChartLineSerie0.LinePen.Color := clred;
ChartLineSerie1.LinePen.Color := clblack;
TopoForm.ChartLine.AddSeries(ChartLineSerie0);
TopoForm.ChartLine.AddSeries(ChartLineSerie1);

if RadioGroup1.ItemIndex=0 then MakeX:=True
else MakeX:=False;

OldX:=0; // dado que son dacs diferentes, el dac del barrido está en 0
OldY:=0;

LastX:=0;
LastY:=0;

{if (RadioGroup1.ItemIndex=0) then
  MakeX:=True
else
  MakeY:=True;}

  //modify rounding, Hermann 22/09/2020
if MakeX then
begin
 Princ:=OldX-Round(32768*P_Scan_Size);
end
else
begin
  Princ:=OldY-Round(32768*P_Scan_Size);
end;
if (P_Scan_Size=0) then P_Scan_Size:=1;

if MakeX then Fin:=OldX+Round(32768*P_Scan_Size)
else Fin:=OldY+Round(32768*P_Scan_Size);

if (abs(Fin)>32768) or (Princ<-32768) then
begin
  StopAction:=True;
  exit;
end;

total:=Round(abs(Princ-Fin));

if Fin>Princ then Step:=Round(total/P_Scan_Lines);
if (Step=0) then Step:=100;

if (IV_Scan_Lines>P_Scan_Lines) and (MakeIVChk.Checked) then
begin
  MessageDlg('Spectro: too many points',mtError,[mbOK],0);
  IV_Scan_Lines:=P_Scan_Lines;
  RedimCits(IV_Scan_Lines, LinerForm.PointNumber);
end;

TopoForm.ChartLine.BottomAxis.SetMinMax(Min(Princ, Fin)/32768*AmpX*DataForm.scan_attenuator*10*CalX, Max(Princ, Fin)/32768*AmpX*DataForm.scan_attenuator*10*CalX);

if (TopoForm.RadioGroup1.ItemIndex = 0) then // Topo
begin
  channelToPlot := 1;
  yFactor := StrtoFloat(FormConfig.TopoCalEdit.Text)*StrtoFloat(FormConfig.TopoAmpBox.Text);//ScanForm.CalTopo*ScanForm.AmpTopo;
end
else // Current
begin
  channelToPlot := 2;
  yFactor := ScanForm.MultI*ScanForm.AmpI;
end;

//Forth
i:=0;

//QueryPerformanceFrequency(F);
while (i<P_Scan_Lines) do
begin
  while (PauseAction=True) do Application.ProcessMessages;
  if MakeX then OldX:=Princ+Step*i else OldY:=Princ+Step*i;
  if MakeX then  // Scan in X
  begin
    if (not StopAction) then
    begin
      if (i<>0) then MoveDac(nil, XDAC, Princ+Step*(i-1), OldX, P_Scan_Jump, nil);  // solo debe de moverse cuando i<>0
      LastX:=OldX; // Lo mismo que arriba.
    end;
    xVolt:=OldX/32768*AmpX*10;
    if (StopAction) then
    begin
      xVal[1]:=0;
      xVal[2]:=0;
    end
    else
    begin
      adcRead:=DataForm.adc_take_all(P_Scan_Mean, AdcWriteRead, nil);
      if ReadTopo=True then xVal[1]:= adcRead[ADCTopo];
      if ReadCurrent=True then xVal[2]:=adcRead[ADCI];
    end;
    if (EraseLines>0) then ChartLineSerie0.AddXY(xVolt*CalX*DataForm.scan_attenuator,10*yFactor*xVal[channelToPlot]);
  end
  else   // Scan in Y
  begin
    if (not StopAction) then
    begin
      if (i<>0) then MoveDac(nil, YDAC, Princ+Step*(i-1), OldY, P_Scan_Jump, nil);  // solo debe de moverse cuando i<>0
      LastY:=OldY; // Lo mismo que arriba.
    end;
    yVolt:=OldY/32768*AmpY*10;
    if StopAction then
    begin
      yVal[1]:=0;
      yVal[2]:=0;
    end
    else
    begin
      adcRead:=DataForm.adc_take_all(P_Scan_Mean, AdcWriteRead, nil);
      if ReadTopo=True then yVal[1]:= adcRead[ADCTopo];
      if ReadCurrent=True then yVal[2]:=adcRead[ADCI];
    end;
    if (EraseLines>0) then ChartLineSerie0.AddXY(yVolt*CalY*DataForm.scan_attenuator,10*yFactor*yVal[channelToPlot]);
  end;

  Application.ProcessMessages;
  i:=i+1;
end;


//Back

i:=0;
if MakeX then Princ2:=OldX else Princ2:=OldY;
while (i<P_Scan_Lines)  do
begin
  while (PauseAction=True) do Application.ProcessMessages;
  if MakeX then OldX:=Princ2-Step*i else OldY:=Princ2-Step*i;
  if MakeX then
  begin
    if (not StopAction) then
    begin
      if (i<>0) then MoveDac(nil, XDAC, Princ2-Step*(i-1), OldX, P_Scan_Jump, nil);  //solo debe de moverse cuando ya ha empezado
      LastX:=OldX;
    end;
    xVolt:=OldX/32768*AmpX*10;
    if (StopAction) then
    begin
      xVal[1]:=0;
      xVal[2]:=0;
    end
    else
    begin
      adcRead:=DataForm.adc_take_all(P_Scan_Mean, AdcWriteRead, nil);
      if ReadTopo=True then xVal[1]:= adcRead[ADCTopo];
      if ReadCurrent=True then xVal[2]:=adcRead[ADCI];
    end;
    if (EraseLines>0) then ChartLineSerie1.AddXY(xVolt*CalX*DataForm.scan_attenuator,10*yFactor*xVal[channelToPlot]);
  end
  else
  begin
	  if (not StopAction) then
    begin
      if (i<>0) then MoveDac(nil, YDAC, Princ2-Step*(i-1), OldY, P_Scan_Jump, nil);  // solo debe de moverse cuando i<>0
      LastY:=OldY; // Lo mismo que arriba.
    end;
    yVolt:=OldY/32768*AmpY*10;
    if StopAction then
    begin
      yVal[1]:=0;
      yVal[2]:=0;
    end
    else
    begin
      adcRead:=DataForm.adc_take_all(P_Scan_Mean, AdcWriteRead, nil);
      if ReadTopo=True then yVal[1]:= adcRead[ADCTopo];
      if ReadCurrent=True then yVal[2]:=adcRead[ADCI];
    end;
    if (EraseLines>0) then ChartLineSerie1.AddXY(yVolt*CalY*DataForm.scan_attenuator,10*yFactor*yVal[channelToPlot]);
	end;
  Application.ProcessMessages;
  i:=i+1;
end;

if StopAction then
begin
  // Si salimos, hay que llevar la punta a su sitio
  if MakeX then MoveDac(nil, XDAC, LastX, 0, P_Scan_Jump, nil)
  else MoveDac(nil, YDAC, LastY, 0, P_Scan_Jump, nil);
end;


end;

// filterOrder: 0 = No filter; 1 = Fit to line
function TScanForm.FilterImage(Image: TImageSingle; scanX: Boolean; numPoints, filterOrder: Integer) : HImg;
var
  i, j: Integer;
  ord, slope: Single;
  dataX, dataY: vector;
begin

  // Si nos pasan un filtro no permitido, devolvemos los datos sin filtrar
  if filterOrder = 1 then // Ajuste a línea
  begin
    for i := 0 to numPoints-1 do
      dataX[i] := i;

    for i := 0 to numPoints-1 do
    begin
      // Copiamos los datos al array según sean filas o columnas
      if scanX then
        for j := 0 to numPoints-1 do
          dataY[j] := Image[i, j]
      else
        for j := 0 to numPoints-1 do
          dataY[j] := Image[j, i];

      // Realizamos el ajuste por filas o columnas según la dirección de barrido
      FitToLine(dataX, dataY, numPoints, slope, ord);

      // Copiamos los datos restando la recta ajustada
      if scanX then
        for j := 0 to numPoints-1 do
          Result[i, j] := Image[i, j]-(j*slope+ord)
      else
        for j := 0 to numPoints-1 do
          Result[j, i] := Image[j, i]-(j*slope+ord);
    end;
  end
  else
  begin
    for i := 0 to numPoints-1 do
      for j := 0 to numPoints-1 do
        Result[i, j] := Image[i, j];
  end;
end;

function TScanForm.FitToLine(dataX, dataY: vector; numPoints: Integer; out slope, ord: Single) : Boolean;
var
  i: Integer;
  sx, sy, sxy, sx2, aux: Single;
begin
  // Ponemos por defecto unos valores inofensivos
  slope := 0;
  ord := 0;
  Result := False;

  // Inicializamos los acumuladores
  sx := 0;
  sy := 0;
  sxy := 0;
  sx2 := 0;

  for i := 0 to numPoints-1 do
  begin
    sx := sx + dataX[i];
    sy := sy + dataY[i];
    sxy := sxy + dataX[i]*dataY[i];
    sx2 := sx2 + dataX[i]*dataX[i];
  end;

  aux := numPoints*sx2-sx*sx;
  if aux = 0 then
    Exit;

  slope := (numPoints*sxy-sx*sy)/aux;
  ord := (sx2*sy-sx*sxy)/aux;
  Result := true;
end;

{function TScanForm.TakeOnePoint(Sender:TObject) : Single;
var
Lectura: Single;
i: Integer;
begin
for i:=0 to P_Scan_Mean do
 begin

 end;
end;}

procedure TScanForm.CreateCitsTempFiles();
var
  i: Integer;
  path: array [0..MAX_PATH] of Char;
  fileName: array [0..MAX_PATH] of Char;

begin
  GetTempPath(MAX_PATH, path);
  for i:=0 to 3 do
  begin
    GetTempFileName(path, 'CITS', 0, fileName);
    CitsTempFileName[i] := fileName;
    CitsTempFile[i]:=TFileStream.Create(fileName,fmCreate);
  end;
end;

procedure TScanForm.DestroyCitsTempFiles();
var
  i: Integer;
begin
  for i:=0 to 3 do
  begin
    CitsTempFile[i].Free();
    DeleteFile(CitsTempFileName[i]);
  end
end;

procedure TScanForm.CitsSeekToIV(row, column, point: Integer);
var
  i, pointsIV: Integer;
  position: Int64;
begin
  if ((row < 0) or (column < 0)) then
    exit;

  pointsIV := LinerForm.PointNumber;
  position := ((row*IV_Scan_Lines+column)*pointsIV+point)*sizeof(Single);

  for i := 0 to 3 do
  begin
    CitsTempFile[i].Seek(position, 0);
  end
end;

procedure TScanForm.RedimCits(PointsXY, PointsIV: Integer);
var
  i: Integer;
begin
  if ((PointsXY <= 0) or (PointsIV <= 0)) then
    exit;

  // Defino los nuevos tamaños de los ficheros según lo que se necesite
  for i := 0 to 3 do
  begin
    CitsTempFile[i].Size := PointsXY*PointsXY*PointsIV*sizeof(single);
  end
end;

procedure TScanForm.OpenLinerBtnClick(Sender: TObject);
begin
LinerForm.Show;
end;

procedure TScanForm.OpenTripBtnClick(Sender: TObject);
begin
TripForm.Show;
end;

procedure TScanForm.ScanButtonClick(Sender: TObject);
var
i,p: Integer;
j,k,total: Integer;
PrincX,PrincY,FinX, FinY,Step: Integer;
PaintLines: Boolean;
Source: TRect;
Dest: TRect;
DacValX_Local,DacValY_Local: Integer; // estábamos usando una variable global para Escanear, eso ha dado problemas
          // usamos pues YDAC_Pos -> DacValY
          // y YDAC -> DacValY_Local
LinesBefore: Integer;
begin

repeat
  PuntosTotales:=P_Scan_Lines*P_Scan_Lines*2;
  PuntosMedidos:=0;
  PuntosPonderados:=0;
  TiempoMedio:=0;
  TiempoInicial:=0;

  h.xstart:=DacValX/32768*DataForm.scan_attenuator*AmpX*10*1e-9;
  h.xend:=Round(DacValX+int(65535*P_Scan_Size))/32768*AmpX*DataForm.scan_attenuator*10*1e-9;
  h.ystart:=DacValY/32768*DataForm.scan_attenuator*AmpX*10*1e-9;
  h.yend:=Round(DacValY+int(65535*P_Scan_Size))/32768*AmpY*DataForm.scan_attenuator*10*1e-9;
  h.xn:=P_Scan_Lines;
  h.yn:=P_Scan_Lines;


  LinesBefore:= SpinLinesBefore.Value;
  StopAction:=False;
  StopBtn.Enabled:=True;
  if MakeIVChk.Checked then LinerForm.show;
  TopoForm.Show;
  TopoForm.FreeScans(nil);
  TryStrToInt(TopoForm.SpinEdit1.Text, EraseLines);

  PaintLines:=Checkbox6.checked;

  // Borramos las imágenes antes de adquirir líneas nuevas
  for i := 1 to 2 do
    for j := 0 to P_Scan_Lines-1 do
      for k := 0 to P_Scan_Lines-1 do
      begin
        Dat_Image_Forth[i][j][k] := 0;
        Dat_Image_Back[i][j][k] := 0;
      end;


   PrincY:=Round(-int(32767*P_Scan_Size)); //Punto inicial en Y
   PrincX:=Round(-int(32767*P_Scan_Size)); //Punto inicial en X
   MoveDac(nil, XDAC, 0, PrincX, P_Scan_Jump, nil);
   MoveDac(nil, YDAC, 0, PrincY, P_Scan_Jump, nil);
   //sleep(500*StrToInt(SpinEdit3.Text));
   //FormPID.se1.Text:='0';
   //sleep(500*StrToInt(SpinEdit3.Text)); //Comentado por Fran
   FormPID.SleepCtrlBtnClick(nil);

  i:=0;
  p:=0;
  if (RadioGroup1.ItemIndex=0) then // Scan in X
      begin

        //PrincY:=Round(-int(32767*P_Scan_Size)); //Punto inicial en Y
        if (P_Scan_Size=0) then P_Scan_Size:=1;
        FinY:=Round(int(32767*P_Scan_Size));   //Punto final en Y
        total:=Round(abs(PrincY-FinY));
        if FinY>PrincY then Step:=Round(total/P_Scan_Lines);
        if (Step=0) then Step:=100;
        // Hago varias lineas antes de iniciar la imagen
        //p:=0;
        //i:=0;
        //Indicamos la posicion en Y
        DacValY_Local:=PrincY;
        while (LinesBefore > i) and (not StopAction) do
        begin
          p:=p+1;
          TryStrToInt(TopoForm.SpinEdit1.Text, EraseLines);
          MakeEmptyLine(nil,PaintLines);
          if (p>=EraseLines) then
            begin
              TopoForm.ClearChart();
              p:=0;
            end;
          i:=i+1;
        end;
        i:=0;
        while ((i<P_Scan_Lines) and (not StopAction)) do  //Bucle lento en Y
        begin
          p:=p+1;
          TryStrToInt(TopoForm.SpinEdit1.Text, EraseLines);
          DacValY_Local:=PrincY+Step*i;
          if (i<>0) then MoveDac(nil, YDAC, PrincY+Step*(i-1), DacValY_Local, P_Scan_Jump, nil);
          MakeLine(nil,PaintLines,i); //Save the line and send line number
          if (p>=EraseLines) then
            begin
  //            TopoForm.xyyGraph1.Clear;
              TopoForm.ClearChart();
              p:=0;
            end;
          i:=i+1;
        end;
        // Devuelvo la punta a la posición central. Supongo imágenes cuadradas y sin invertir en ningún canal, por lo que el punto final en X e Y será el mismo
        if (not StopAction) then MoveDac(nil, XDAC, PrincX, 0, P_Scan_Jump, nil);   //porque en la X se vuelve con makeline si se para, y si no hay que devolverlo a su sitio
        MoveDac(nil, YDAC, DacvalY_Local, 0, P_Scan_Jump, nil); //porque en la X se vuelve con makeline
      end
  else //Now scan in Y
      begin
        //PrincX:=Round(-int(32767*P_Scan_Size)); //Punto inicial en X
        if (P_Scan_Size=0) then P_Scan_Size:=1;
        FinX:=Round(int(32767*P_Scan_Size));   //Punto final en X
        total:=Round(abs(PrincX-FinX));
        if FinX>PrincX then Step:=Round(total/P_Scan_Lines);
        if (Step=0) then Step:=100;
        // Hago varias lineas antes de iniciar la imagen
        //p:=0;
        //i:=0;
        //Indicamos la posicion en X
        DacvalX_Local:=PrincX;
        while (LinesBefore > i) and ( not StopAction) do
        begin
          p:=p+1;
          TryStrToInt(TopoForm.SpinEdit1.Text, EraseLines);
          MakeEmptyLine(nil,PaintLines);
          if (p>=EraseLines) then
            begin
              TopoForm.ClearChart();
              p:=0;
            end;
          i:=i+1;
        end;
        i:=0;
        while ((i<P_Scan_Lines) and (not StopAction)) do  //Bucle lento en X
        begin
          p:=p+1;
          TryStrToInt(TopoForm.SpinEdit1.Text, EraseLines);
          DacvalX_Local:=PrincX+Step*i;
          if (i<>0) then MoveDac(nil, XDAC, PrincX+Step*(i-1), DacValX_Local, P_Scan_Jump, nil);
          MakeLine(nil,PaintLines,i); //Save the line and send line number
          if (p>=EraseLines) then
            begin
  //            TopoForm.xyyGraph1.Clear;
              TopoForm.ClearChart();
              p:=0;
            end;
          i:=i+1;
        end;
        // Devuelvo la punta a la posición central. Supongo imágenes cuadradas y sin invertir en ningún canal, por lo que el punto final en X e Y será el mismo
        MoveDac(nil, XDAC, DacValX_Local, 0, P_Scan_Jump, nil);
        if (not StopAction) then MoveDac(nil, YDAC, PrincY, 0, P_Scan_Jump, nil);
      end;

      StopBtn.Enabled:=False;

     if checkbox3.checked then // Hay que dejar dibujada la última imagen adquirida en esa posición
     begin
       i := Length(bitmapPasteList);
       SetLength(bitmapPasteList, i+1);

       bitmapPasteList[i].x := XOffset;
       bitmapPasteList[i].y := YOffset;
       bitmapPasteList[i].sizeX := 2*P_Scan_Size*DataForm.scan_attenuator;
       bitmapPasteList[i].sizeY := 2*P_Scan_Size*DataForm.scan_attenuator;
       bitmapPasteList[i].bitmap := TBitmap.Create;
       try
         with bitmapPasteList[i].bitmap do
         begin
           Width := TopoForm.PaintBox1.Width;
           Height := TopoForm.PaintBox1.Height;
           Dest := Rect(0, 0, Width, Height);
         end;
         with TopoForm.PaintBox1 do
           Source := Rect(0, 0, Width, Height);
           bitmapPasteList[i].bitmap.Canvas.CopyRect(Dest, TopoForm.PaintBox1.Canvas, Source);
        finally
       end;
       UpdateCanvas(self);
     end;


  TopoForm.Close;

  if (SaveAllImg.Checked) then
  begin
    SaveImgButtonClick(nil);
    if (MakeIVChk.Checked) then LinerForm.SpinEdit1.Value:=LinerForm.SpinEdit1.Value + 1;
  end;
until not TopoForm.ScanLoop.Checked;
//if (TopoForm.ScanLoop.Checked) then Button1Click(nil); // Ojo!!. Llamada recursiva sin condición de parada!! (bucle infinito). Cambiado por repeat ... until

if (TopoForm.CheckBox2.Checked)then
begin
  TripForm.Separate100BtnClick(nil);
  TopoForm.CheckBox2.Checked:=False;
end;
end;

// Nacho, agosto de 2017. Si se pasa un buffer válido, en lugar de enviar el dato lo añade al buffer
procedure TScanForm.MoveDac(Sender: TObject; DacNr, init, fin, jump : integer; BufferOut: PAnsiChar);
var
j,StepNumr,StepSign: Integer;
Go_jump: Integer;

begin
  {j:=0;

  interv:=(fin-init)/jump;

  while (j<jump+1) do
  begin
  Go_jump:=Round(init+j*interv);
  DataForm.dac_set(DacNr,Go_jump, BufferOut);
  j:=j+1;
  Application.ProcessMessages;
  end;
  }

  j:=0;

  StepNumr:=abs(Round((fin-init)/jump));
  if (abs(fin-init)>0) then StepSign:=Round((fin-init)/abs(fin-init))
  else StepSign:=1;

  while (j<StepNumr+1) do
  begin
  Go_jump:=Round(init+StepSign*j*jump);
  DataForm.dac_set(DacNr,Go_jump, BufferOut);
  j:=j+1;
  Application.ProcessMessages;
  end;
  
  DataForm.dac_set(DacNr,fin, BufferOut);
  Application.ProcessMessages;
end;

procedure TScanForm.SaveSTP(Sender: TObject; OneImg : HImg; Suffix: String; factorZ: double);
var
MiFile,FileNumber : string;
k,l: Integer;
DataWsxmtoPlotinFile: Array [0..512,0..512] of Double;
DataLine: Array [0..512] of Double;

begin
  ScanForm.SaveImgButton.Enabled:=False; // se desactiva para que no se pueda grabar sobre el fichero abierto.
  Form8.Button1.Click; // Rellena la cabecera de la imagen

  // Asume que las imágenes son cuadradas (mismo número de filas y columnas)
  // Reordeno los datos para salgan bien colocados en WSxM.
  for l:=0 to h.yn-1 do
  begin
    for k:=0 to h.yn-1 do
    begin
      DataWsxmtoPlotinFile[k,l]:=OneImg[h.yn-l-1,h.yn-k-1]*factorZ;
    end;
  end;

  if Form9.Label5.Caption='.\data' then Button3Click(nil); // default value for the path
  MiFile:=Form9.Label5.Caption; //Here is directory

  FileNumber := Format('%.3d', [ImgNumberSpin.Value]);
  MiFile:=MiFile+'\'+FileNameEdit.Text+'_'+FileNumber+Suffix+'.stp';

  F:=TFileStream.Create(MiFile,fmCreate) ;
  F.WriteBuffer(Form8.WSxMHeader[1], Length(Form8.WSxMHeader));

  for l:=0 to h.yn-1 do
  begin
    for k:=0 to h.yn-1 do
    begin
      DataLine[k] := DataWsxmtoPlotinFile[k,l]
    end;
    F.WriteBuffer(DataLine,SizeOf(Double)*h.yn);
    Application.ProcessMessages;  // para que funcione el control mientras que graba. No comprendo bien por qué tarda tanto.
  end;
  F.Destroy;
  ScanForm.SaveImgButton.Enabled:=True; // se activa para que no se pueda grabar sobre el fichero abierto.
end;

// Guarda las curvas IV en el formato General Spectroscopy Imaging de WSxM
// Nacho Horcas, diciembre de 2017
procedure TScanForm.SaveCits(dataSet: Integer);
var
  MiFile, FileNumber, strLine, strDirections : string;
  strGeneralInfoDir :string;
  minV, maxV, value : double;
  valueSingle : Single;
  i, j, k, size_double: Integer;
  ImageTopo: ^TImageSingle;

begin
  DecimalSeparator := '.';
  if Form9.Label5.Caption='.\data' then Button3Click(nil); // default value for the path
  MiFile:=Form9.Label5.Caption; //Here is directory

  case dataSet of
    0:
    begin
      ImageTopo := @(Dat_Image_Forth[1]);
      strDirections := '.ff';
      strGeneralInfoDir := '    Spectroscopy direction: Forward'
    end;
    1:
    begin
      ImageTopo := @(Dat_Image_Forth[1]);
      strDirections := '.fb';
      strGeneralInfoDir := '    Spectroscopy direction: Backward'
    end;
    2:
    begin
      ImageTopo := @(Dat_Image_Back[1]);
      strDirections := '.bf';
      strGeneralInfoDir := '    Spectroscopy direction: Forward'
    end;
    3:
    begin
      ImageTopo := @(Dat_Image_Back[1]);
      strDirections := '.bb';
      strGeneralInfoDir := '    Spectroscopy direction: Backward'
    end;
  else
      Exit;
  end;

  FileNumber := Format('%.3d', [ImgNumberSpin.Value]);
  MiFile:=MiFile+'\'+FileNameEdit.Text+FileNumber+strDirections+'.gsi';

  F:=TFileStream.Create(MiFile,fmCreate) ;

  // Guardamos la cabecera del fichero
  F.Write('WSxM file copyright UAM'+#13#10, 2+Length('WSxM file copyright UAM'));
  F.Write('Spectroscopy Imaging Image file'#13#10, 2+Length('Spectroscopy Imaging Image file'));
  F.Write('Image header size: 0'#13#10, 2+Length('Image header size: 0')); // No se usa el tamaño de la cabecera, pero mejor que aparezca la línea
  F.Write(''#13#10, 2+Length(''));

  F.Write('[Control]'#13#10, 2+Length('[Control]'));
  F.Write(''#13#10, 2+Length(''));

  if (FormPID.spinPID_In.Value  = ScanForm.ADCI) then
  strLine := Format('    Set Point: %s nA', [FormPID.lblCurrentSetPoint.Caption])
  else strLine := Format('    Set Point: %d %%', [FormPID.scrlbrSetPoint.Position]);
  F.Write(PChar(strLine+#13#10)^, 2+Length(strLine));

  strLine := Format('    X Amplitude: %f nm', [abs(ScanForm.h.xend-ScanForm.h.xstart)*1e9*CalX]);
  F.Write(PChar(strLine+#13#10)^, 2+Length(strLine));

  strLine := Format('    X Offset: %f nm', [XOffset*10*AmpX*CalX]);
  F.Write(PChar(strLine+#13#10)^, 2+Length(strLine));

  strLine := Format('    Y Amplitude: %f nm', [abs(ScanForm.h.yend-ScanForm.h.ystart)*1e9*CalY]);
  F.Write(PChar(strLine+#13#10)^, 2+Length(strLine));

  strLine := Format('    Y Offset: %f nm', [YOffset*10*AmpY*CalY]);
  F.Write(PChar(strLine+#13#10)^, 2+Length(strLine));

  F.Write(''#13#10, 2+Length(''));

  F.Write('[General Info]'#13#10, 2+Length('[General Info]'));
  F.Write(''#13#10, 2+Length(''));
  F.Write('    Image Data Type: double'#13#10, 2+Length('    Image Data Type: double'));

  strLine := Format('    Number of columns: %d', [ScanForm.IV_Scan_Lines]);
  F.Write(PChar(strLine+#13#10)^, 2+Length(strLine));

  strLine := Format('    Number of points per ramp: %d', [LinerForm.PointNumber]);
  F.Write(PChar(strLine+#13#10)^, 2+Length(strLine));

  strLine := Format('    Number of rows: %d', [ScanForm.IV_Scan_Lines]);
  F.Write(PChar(strLine+#13#10)^, 2+Length(strLine));

  F.Write('    Spectroscopy Amplitude: 1 nA'#13#10, 2+Length('    Spectroscopy Amplitude: 1 nA')); // Lo importante es la unidad, no el valor
  F.Write(PChar(strGeneralInfoDir+#13#10)^, 2+Length(strGeneralInfoDir));
  F.Write('    Z Amplitude: 1 nm'#13#10, 2+Length('    Z Amplitude: 1 nm')); // Lo importante es la unidad, no el valor
  F.Write(''#13#10, 2+Length(''));

  F.Write('[Miscellaneous]'#13#10, 2+Length('[Miscellaneous]'));
  F.Write(''#13#10, 2+Length(''));
  strLine:= Format('    Saved with version: MyScanner %s',[Form8.Version]);
  F.Write(PChar(strLine+#13#10)^, 2+Length(strLine));
  F.Write('    Version: 1.0 (August 2005)'#13#10, 2+Length('    Version: 1.0 (August 2005)'));
  F.Write('    Z Scale Factor: 1'#13#10, 2+Length('    Z Scale Factor: 1'));
  F.Write('    Z Scale Offset: 0'#13#10, 2+Length('    Z Scale Offset: 0'));
  F.Write(''#13#10, 2+Length(''));

  F.Write('[Spectroscopy images ramp value list]'#13#10, 2+Length('[Spectroscopy images ramp value list]'));
  F.Write(''#13#10, 2+Length(''));

  // Guarda las tensiones de cada punto del IV
  maxV := 10*LinerForm.Size_xAxis;
  minV := -maxV;

  for i := 0 to LinerForm.PointNumber-1 do
  begin
    strLine := Format('    Image %.3d: %.4f V', [i, minV+i*(maxV-minV)/(LinerForm.PointNumber-1)]);
    F.Write(PChar(strLine+#13#10)^, 2+Length(strLine));
  end;

  F.Write(''#13#10, 2+Length(''));
  F.Write('[Header end]'#13#10, 2+Length('[Header end]'));

  // Nacho, diciembre de 2017. No me gusta nada esta manera de escribir los datos
  // en fichero, pero no encuentro una mejor para escribir directametne en binario
  size_double := SizeOf(value);

  // Fin de escribir la cabecera. Guardamos los datos, primero la topografía y luego las curvas IV
  // Para pruebas, guardo datos inventados
  for i := ScanForm.IV_Scan_Lines-1 downto 0 do
  begin
    for j := ScanForm.IV_Scan_Lines-1 downto 0 do
    begin
      value := ImageTopo^[i,j];
      F.Write(value, size_double);
    end;
  end;

  // El orden de guardar, extraído de WSxM, es
	//for (int iRamp = 0; iRamp < iNumRampPoints; iRamp++)
	//	for (int iRow = 0; iRow < iNumRows; iRow++)
	//		for (int iCol = 0; iCol < iNumColumns; iCol++)

  for i := 0 to LinerForm.PointNumber-1 do
  begin
    for j := ScanForm.IV_Scan_Lines-1 downto 0 do
    begin
      for k := ScanForm.IV_Scan_Lines-1 downto 0 do
      begin
        CitsSeekToIV(j, k, i);
//        value := DataCurrentCits[dataSet][j][k][i]*1e9; // Guardamos en nA
        CitsTempFile[dataSet].Read(valueSingle, SizeOf(valueSingle));
        value := valueSingle*1e9; // Guardamos en nA
        F.Write(value, size_double);
      end;
    end;
  end;

  F.Destroy;
end;

procedure TScanForm.SetLengthofStr(Sender: TObject; MyLength: Integer; var MyString: String);
var
MyStrLength,LengthDiff,i: Integer;
Buf: String;

begin
Buf:='';
MyStrLength:=Length(MyString);
if (MyStrLength<MyLength) then
 begin
  LengthDiff:=MyLength-MyStrLength;
  if (LengthDiff<10) then SetLength(Buf,LengthDiff)
  else LengthDiff:=0;
  for i:=1 to LengthDiff do Buf[i]:='0';
  //SetLength(MyString,MyLength);
  MyString:=Buf+MyString;
  end;
end;


procedure TScanForm.HeaderImgBtnClick(Sender: TObject);
begin
Form8.Show;
end;

procedure TScanForm.SaveImgButtonClick(Sender: TObject);
var
OneImg: HImg;
i,j:Integer;
factorZ: double; // Factor para convertir los datos de la matriz a sus unidades de fichero (nm, nA o V).

begin
if ReadTopo=True then
begin
  factorZ := 10.0*ScanForm.AmpTopo*ScanForm.CalTopo;
  for i:=0 to h.yn-1 do
  begin
   for j:=0 to h.yn-1 do
   begin
     OneImg[i,j]:=Dat_Image_Forth[1,i,j];
   end;
  end;
  Form8.RadioGroup1.ItemIndex:=0;
  Form8.RadioGroup2.ItemIndex:=0;
  SaveSTP(nil,OneImg,'_ih', factorZ);

  for i:=0 to h.yn-1 do
  begin
   for j:=0 to h.yn-1 do
   begin
     OneImg[i,j]:=Dat_Image_Back[1,i,j];
   end;
  end;
  Form8.RadioGroup1.ItemIndex:=1;
  Form8.RadioGroup2.ItemIndex:=0;
  SaveSTP(nil,OneImg,'_vh', factorZ);
end;

if ReadCurrent=True then
begin
  factorZ := ScanForm.AmpI*1e9*ScanForm.MultI;
  for i:=0 to h.yn-1 do
  begin
    for j:=0 to h.yn-1 do
    begin
      OneImg[i,j]:=Dat_Image_Forth[2,i,j];
    end;
  end;
  Form8.RadioGroup1.ItemIndex:=0;
  Form8.RadioGroup2.ItemIndex:=1;
  SaveSTP(nil,OneImg,'_ic', factorZ);

  for i:=0 to h.yn-1 do
  begin
    for j:=0 to h.yn-1 do
    begin
      OneImg[i,j]:=Dat_Image_Back[2,i,j];
    end;
  end;
  Form8.RadioGroup1.ItemIndex:=1;
  Form8.RadioGroup2.ItemIndex:=1;
  SaveSTP(nil,OneImg,'_vc', factorZ);

// Se usa la misma condición que controla si se hacen IVs y aparte, que se quieran guardar los datos en este formato
if (MakeIVChk.Checked) and (Form11.CheckBox1.Checked) and (Form11.chkSaveAsWSxM.Checked) then
  for i := 0 to 3 do
    SaveCits(i);
end;

ImgNumberSpin.Value:=ImgNumberSpin.Value+1;
end;

procedure TScanForm.Button3Click(Sender: TObject);
var
i,Long :Integer;
S: String;
begin
if SaveDialog1.Execute then
begin
S:=ExtractFileName(SaveDialog1.FileName);
for i:=1 to Length(S) do if S[i]='.' then Long:=i;

SetLength(S,Long-1);
FileNameEdit.Text:=S;

Form9.Label5.Caption:=ExtractFileDir(SaveDialog1.FileName);

//Cambiamos el directorio y normbre de las IV solo si es una espectro
  if MakeIVChk.Checked then
  begin
    LinerForm.Edit1.Text:=FileNameEdit.Text;
    LinerForm.SaveDialog1.FileName := ChangeFileExt(SaveDialog1.FileName, '');
    //CreateDir(Form9.Label5.Caption+'\IV');
    Form9.Label6.Caption:=Form9.Label5.Caption;
  end;
end;

end;

procedure TScanForm.SaveAllImgClick(Sender: TObject);
begin
  if SaveAllImg.Checked  = True then Button3Click(nil);
end;

procedure TScanForm.ShowDirBtnClick(Sender: TObject);
begin
Form9.Show;
end;

procedure TScanForm.InitDACBtnClick(Sender: TObject);
begin
//take_initialize;
DataForm.InitDataAcq;
end;

procedure TScanForm.OpenPIDBtnClick(Sender: TObject);
begin
FormPID.Show;
end;

procedure TScanForm.ScrollBar1Change(Sender: TObject);
var
dac_num, enviaDac:SmallInt;

begin
dac_num:=SpinEdit2.Value;
enviaDac:=ScrollBar1.Position;
DataForm.dac_set(dac_num,enviaDac, nil);
end;

procedure TScanForm.OpenDataAcqBtnClick(Sender: TObject);
begin
DataForm.Show;
end;

procedure TScanForm.ResizeBitmap(Bitmap: TBitmap; Width, Height: Integer; Background: TColor);
var
  R: TRect;
  B: TBitmap;
  X, Y: Integer;
begin
  if assigned(Bitmap) then begin   
    B:= TBitmap.Create;
    try
//      if Bitmap.Width > Bitmap.Height then begin
//        R.Right:= Width;
//        R.Bottom:= ((Width * Bitmap.Height) div Bitmap.Width);    
//        X:= 0;
//        Y:= (Height div 2) - (R.Bottom div 2);
//      end else begin
        R.Right:= ((Height * Bitmap.Width) div Bitmap.Height);
        R.Bottom:= Height;
        X:= (Width div 2) - (R.Right div 2);
        Y:= 0;
//      end;
      R.Left:= 0;
      R.Top:= 0;
      B.PixelFormat:= Bitmap.PixelFormat;
      B.Width:= Width;
      B.Height:= Height;
      B.Canvas.Brush.Color:= Background;
      B.Canvas.FillRect(B.Canvas.ClipRect);
      B.Canvas.StretchDraw(R, Bitmap);
      Bitmap.Width:= Width;
      Bitmap.Height:= Height;
      Bitmap.Canvas.Brush.Color:= Background;
      Bitmap.Canvas.FillRect(Bitmap.Canvas.ClipRect);
      Bitmap.Canvas.Draw(X, Y, B);
    finally
      B.Free;
    end;
  end;
end;

procedure TScanForm.ClearBtnClick(Sender: TObject);
var
  i:Integer;
  Mensaje:Integer;
begin
  Mensaje:=MessageDlg('All .bmp files will be eliminated',mtConfirmation,[mbOK,mbCancel],0);
  if Mensaje=mrOk then
  begin
    // No sé si es necesario destruir los bitmaps, lo hago por si acaso
    for i := 0 to Length(bitmapPasteList)-1 do
      bitmapPasteList[i].bitmap.Free;

    SetLength(bitmapPasteList, 0);

    for i := 0 to Length(bitmapPasteList2)-1 do
      bitmapPasteList2[i].bitmap.Free;

    SetLength(bitmapPasteList2, 0);

    PaintBox1.Invalidate;
  end;
end;



procedure TScanForm.MakeIVChkClick(Sender: TObject);
begin
  FormConfig.MakeIVCheck.Checked:=MakeIVChk.Checked;
end;

function TScanForm.PointGlobalToCanvas(pntGlobal: TPointFloat; canvasSize: Integer):TPoint;
var
  zoomFactor, scrollX, scrollY, tempX, tempY, halfScollRange: Double;
begin
  halfScollRange := ScrollBar2.Max/2; // Asumo que empieza en cero
  zoomFactor := StrToFloat(ComboBox1.Text);
  scrollX := -(ScrollBar3.Position-halfScollRange)/halfScollRange; // Lo normalizo a [-1, +1]
  scrollY := (ScrollBar2.Position-halfScollRange)/halfScollRange; // Lo normalizo a [-1, +1]

  // Asigno los valores iniciales a las variables temporales que usaré
  tempX := pntGlobal.x;
  tempY := pntGlobal.y;

  // Para un zoom de 2, sólo cabe en la ventada un área entre +/-0.5, por ejemplo
  tempX := tempX*zoomFactor;
  tempY := tempY*zoomFactor;

  // Scroll
  tempX := tempX + scrollX*(zoomFactor-1); // El -1 es para que no se salga del recuadro
  tempY := tempY + scrollY*(zoomFactor-1);

  // Transformación sin tener en cuenta zoom ni scroll. Invierto la Y, ya que en
  // pantalla este eje es positivo hacia abajo
  tempX := (1+tempX)*canvasSize/2;
  tempY := (1-tempY)*canvasSize/2;

  Result.X := Round(tempX);
  Result.Y := Round(tempY);
end;

function TScanForm.StringToLengthNm(strValue: String):Single;
var
  strNumber, strUnit: String;
  value: Single;
  i: integer;
begin
  try
    strValue := Trim(strValue);
    i := LastDelimiter(' ', strValue);
    if (i > 0) then
    begin
      strNumber := Copy(strValue, 1, i-1);
      strUnit := Copy(strValue, i+1, Length(strValue)-i);
    end;

    value := StrToFloat(strNumber); // Leemos el número

    // Convertimos las unidades, si hiciera falta
    if strUnit = 'Å' then
      value := value/10
    else if strUnit = 'µm' then
      value := value*1000
    else if strUnit = 'mm' then
      value := value*1e6
    else if strUnit = 'm' then
      value := value*1e9
  except
    value := NaN; // Ha habido algún problema durante la conversión
  end;

  Result := value;

end;

function TScanForm.PointCanvasToGlobal(pntCanvas: TPoint; canvasSize: Integer):TPointFloat;
var
  zoomFactor, scrollX, scrollY, tempX, tempY, halfScollRange: Double;
begin
  halfScollRange := ScrollBar2.Max/2; // Asumo que empieza en cero
  zoomFactor := StrToFloat(ComboBox1.Text);
  scrollX := -(ScrollBar3.Position-halfScollRange)/halfScollRange; // Lo normalizo a [-1, +1]
  scrollY := (ScrollBar2.Position-halfScollRange)/halfScollRange; // Lo normalizo a [-1, +1]

  // Asigno los valores iniciales a las variables temporales que usaré
  tempX := pntCanvas.x;
  tempY := pntCanvas.y;

  // Transformación sin tener en cuenta zoom ni scroll.
  tempX := tempX*2/canvasSize-1;
  tempY := -(tempY*2/canvasSize-1);

  // Scroll
  tempX := tempX - scrollX*(zoomFactor-1); // El -1 es para que no se salga del recuadro
  tempY := tempY - scrollY*(zoomFactor-1);

  // Para un zoom de 2, sólo cabe en la ventada un área entre +/-0.5, por ejemplo
  tempX := tempX/zoomFactor;
  tempY := tempY/zoomFactor;

  Result.X := tempX;
  Result.Y := tempY;
end;

procedure TScanForm.UpdateCanvas(Sender:TObject);
var
  i:Integer;
  bottomLeft, topRight: TPoint;
  bottomLeftFloat, topRightFloat: TPointFloat;
begin

//  Pinta el fondo
  with ScanForm.PaintBox1.Canvas do
  begin
    Pen.Color   := $808080;
    Brush.Color := Pen.Color;
    Brush.Style := bsSolid;

    // Pinto el fondo de gris. Luego lo taparé con el área de barrido permitida por los piezos
    // Si todo está bien hecho, este fondo gris no se debería ver nunca
    FillRect(Rect(0,0,ScanForm.PaintBox1.Width,ScanForm.PaintBox1.Height));

    Pen.Color:= clred;//clred;
    Brush.Color:=0;

    // Rectánculo de todo el área de barrido que admite el piezo
    bottomLeftFloat.X := -1;
    bottomLeftFloat.Y := -1;
    topRightFloat.X   :=  1;
    topRightFloat.Y   :=  1;
    bottomLeft := PointGlobalToCanvas(bottomLeftFloat, SizeOfWindow);
    topRight := PointGlobalToCanvas(topRightFloat, SizeOfWindow);
    Rectangle(Rect(bottomLeft, topRight));
  end;

  // Nacho, marzo de 2018. Junto el dibujado de "Paste image" y "Mark now"
  // creando una única lista dinámica de bitmaps a pegar. Si hay bitmap, lo
  // pintamos. En caso contrario pintamos un recuadro amarillo.
  PaintBox1.Canvas.Pen.Color:= $00C0C0;
  PaintBox1.Canvas.Brush.Style:=bsClear;

  for i := 0 to length(bitmapPasteList)-1 do
  begin
    // Calculo el rectángulo donde habrá que dibujar el bitmap
    bottomLeftFloat.X := bitmapPasteList[i].x-bitmapPasteList[i].sizeX/2;
    bottomLeftFloat.Y := bitmapPasteList[i].y-bitmapPasteList[i].sizeY/2;
    topRightFloat.X   :=  bitmapPasteList[i].x+bitmapPasteList[i].sizeX/2;;
    topRightFloat.Y   :=  bitmapPasteList[i].y+bitmapPasteList[i].sizeY/2;;
    bottomLeft := PointGlobalToCanvas(bottomLeftFloat, SizeOfWindow);
    topRight := PointGlobalToCanvas(topRightFloat, SizeOfWindow);

    // Pinto el bitmap que toque dentro del rectángulo o el rectángulo solo si no hay bitmap
    if bitmapPasteList[i].bitmap = nil then
      PaintBox1.Canvas.Rectangle(Rect(bottomLeft.X, topRight.Y, topRight.X, bottomLeft.Y))
    else
      PaintBox1.Canvas.StretchDraw(Rect(bottomLeft.X, topRight.Y, topRight.X, bottomLeft.Y), bitmapPasteList[i].bitmap);
  end;


  PaintBox1.Canvas.Pen.Color:= clred;
  PaintBox1.Canvas.Brush.Style:=bsClear;


  for i := 0 to length(bitmapPasteList2)-1 do
  begin
    // Calculo el rectángulo donde habrá que dibujar el bitmap
    bottomLeftFloat.X := bitmapPasteList2[i].x-bitmapPasteList2[i].sizeX/2;
    bottomLeftFloat.Y := bitmapPasteList2[i].y-bitmapPasteList2[i].sizeY/2;
    topRightFloat.X   :=  bitmapPasteList2[i].x+bitmapPasteList2[i].sizeX/2;;
    topRightFloat.Y   :=  bitmapPasteList2[i].y+bitmapPasteList2[i].sizeY/2;;
    bottomLeft := PointGlobalToCanvas(bottomLeftFloat, SizeOfWindow);
    topRight := PointGlobalToCanvas(topRightFloat, SizeOfWindow);

    // Pinto el bitmap que toque dentro del rectángulo o el rectángulo solo si no hay bitmap
    if bitmapPasteList2[i].bitmap = nil then
      PaintBox1.Canvas.Rectangle(Rect(bottomLeft.X, topRight.Y, topRight.X, bottomLeft.Y))
    else
      PaintBox1.Canvas.StretchDraw(Rect(bottomLeft.X, topRight.Y, topRight.X, bottomLeft.Y), bitmapPasteList[i].bitmap);
  end;




  //Cuadrado de posición de la punta
  with ScanForm.PaintBox1.Canvas do
  begin
    Pen.Color:= $FFFF00;
    Brush.Style:=bsClear;

    // Dibujo el recuadro que indica el área de barrido seleccionada
    bottomLeftFloat.X := XOffset-P_Scan_Size*DataForm.scan_attenuator;
    bottomLeftFloat.Y := YOffset-P_Scan_Size*DataForm.scan_attenuator;
    topRightFloat.X   := XOffset+P_Scan_Size*DataForm.scan_attenuator;
    topRightFloat.Y   := YOffset+P_Scan_Size*DataForm.scan_attenuator;
    bottomLeft := PointGlobalToCanvas(bottomLeftFloat, SizeOfWindow);
    topRight := PointGlobalToCanvas(topRightFloat, SizeOfWindow);
    Rectangle(Rect(bottomLeft, topRight));

    // Dibujo la cruz que marca el centro
    bottomLeftFloat.X := XOffset;
    bottomLeftFloat.Y := YOffset;
    bottomLeft := PointGlobalToCanvas(bottomLeftFloat, SizeOfWindow);
    Rectangle(bottomLeft.X-4,bottomLeft.Y-1,bottomLeft.X+4,bottomLeft.Y+1);
    Rectangle(bottomLeft.X-1,bottomLeft.Y-4,bottomLeft.X+1,bottomLeft.Y+4);
  end;
end;

procedure TScanForm.PasteImgBtnClick(Sender: TObject);
var
  bmp: TBitmap;
  uiClipboardID, hData: Cardinal;
  clipboardPointer: ^TWSxMClipboardHeader;
  szPathName: array[0..MAX_PATH-1] of Char;
  szFileName: array[0..MAX_PATH-1] of Char;
  x, y, sizeX, sizeY, value: Single;
  numParamsRead, i: Integer; // Número de datos que hemos podido obtener de la cabecera
  fileTemp: TextFile;
  fileLine, strLabel, strValue: string;

begin
  // Para no borrar por error algo que no toque
  szFileName := '';

  // Valores por defecto para el pegado
  sizeX := 2*10*P_Scan_Size*AmpX*DataForm.scan_attenuator*CalX; // Rango del DAC en V * ganancia del amplificador * Calibracion en nm/V
  sizeY := 2*10*P_Scan_Size*AmpY*DataForm.scan_attenuator*CalY;
  x := XOffset*10*AmpX*CalX;
  y := YOffset*10*AmpY*CalY;
  numParamsRead := 0;

	// 1.Se accede al clipBoard para obtener el identificador de lo guardado anteriormente y se obtiene
	// el manejador de lo almacenado, si es null es que no había nada con "WSxM Format". Suponemos
	// por defecto que no va a ser una película, así que comprobamos que sea otra cosa con
	// formato "WSxM Format"
  uiClipboardID := RegisterClipboardFormat('WSxM Format');
  if (uiClipboardID = 0) then
  begin
    if (not Clipboard.HasFormat(CF_TEXT)) then
    begin
      exit;
    end;
  end;

  try
    OpenClipboard(0);

    // Obtenemos el manejador del portapapeles para el formato WSxM, si lo hubiera
    hData := GetClipboardData(uiClipboardID);

    if (hData <> 0) then
    begin
      // Bloqueamos el acceso a los dato
      clipboardPointer := GlobalLock(hData);

      // Procedemos a la lectura de los datos del portapapeles
      // Vamos a guardar la imagen en un ficheor temporal. Lo primero que hacemos es buscar un nombre único
      GetEnvironmentVariable('TEMP', szPathName, MAX_PATH);
      GetTempFileName(szPathName, 'WSxMClipboard', 0, szFileName);

      // Guardamos los datos en dicho fichero
      if clipboardPointer.bIsInClipBoard then
      begin
        F := TFileStream.Create(szFileName, fmCreate);
        F.WriteBuffer(clipboardPointer.data, clipboardPointer.ulSize);
        F.Destroy();
      end
      else  // El fichero no estaba en memoria, lo copiamos de su ubicación original
        CopyFile(clipboardPointer.szRealFileName, szFileName, False); // Está sin probar
      begin
      end;

      // Ya tenemos una copia de la imagen, desbloqueamos el acceso a los datos
      GlobalUnlock(hData);

      // Abrimos el fichero como lectura y leemos la cabecera (los datos no son necesarios, usaremos el bitmap
      // Miramos si hay información de tamaño y posiciones. Si la hay, la guardamos en memoria
      AssignFile(fileTemp, szFileName);
      Reset(fileTemp);

      // Vamos leyendo línea a línea hasta que aparezca el título que buscamos
      while (not Eof(fileTemp)) and (fileLine <> '[Control]') do
      begin
        ReadLn(fileTemp, fileLine);
      end;

      fileLine := ' ';
      // Buscamos dentro de este título alguno de los datos que queremos leer
      // Si ha llegado un título nuevo (empieza por "[") dejamos de leer
      while (not Eof(fileTemp)) and (fileLine[1] <> '[') do
      begin
        ReadLn(fileTemp, fileLine);
        if fileLine = '' then
        begin
          // Para que no falle al comparar el primer caracter
          fileLine := ' ';
          Continue;
        end;

        fileLine := Trim(fileLine);
        // Si el campo tiene algún valor, lo leemos
        i := LastDelimiter(':', fileLine);
        if (i > 0) then
        begin
          strLabel := Copy(fileLine, 1, i-1);
          strValue := Copy(fileLine, i+1, Length(fileLine)-i);
        end;

        if (strLabel = 'X Amplitude') then
        begin
          value := StringToLengthNm(strValue);
          if not IsNan(value) then // Si es un número válido lo guardamos
          begin
            sizeX := value;
            numParamsRead := numParamsRead+1;
          end;
        end;

        if (strLabel = 'Y Amplitude') then
        begin
          value := StringToLengthNm(strValue);
          if not IsNan(value) then // Si es un número válido lo guardamos
          begin
            sizeY := value;
            numParamsRead := numParamsRead+1;
          end;
        end;

        if (strLabel = 'X Offset') then
        begin
          value := StringToLengthNm(strValue);
          if not IsNan(value) then // Si es un número válido lo guardamos
          begin
            x := value;
            numParamsRead := numParamsRead+1;
          end;
        end;

        if (strLabel = 'Y Offset') then
        begin
          value := StringToLengthNm(strValue);
          if not IsNan(value) then // Si es un número válido lo guardamos
          begin
            y := value;
            numParamsRead := numParamsRead+1;
          end;
        end;

      end;

      // Cerramos y borramos el fichero temporal
      CloseFile(fileTemp);
      DeleteFile(szFileName);
    end;
  except
    // Ha habido problemas con el portapapeles. Continuamos sin más
  end;

  CloseClipboard();

  // Pegado del bitmap
  if Clipboard.HasFormat(CF_PICTURE) then
  begin
    bmp := TBitmap.Create;
    try
      bmp.Assign(Clipboard);

      // Ponemos los valores iniciales que conozcamos
      FormPaste.setSizeX(sizeX);
      FormPaste.setSizeY(sizeY);
      FormPaste.setOffsetX(x);
      FormPaste.setOffsetY(y);

      // Si hemos llegado hasta aquí es que había algún bitmap en memoria. Si nos falta algún dato
      // de tamaño o posición, lo preguntamos
      if numParamsRead < 4 then
      begin
        FormPaste.ShowModal();
      end;

      i := Length(bitmapPasteList);
      SetLength(bitmapPasteList, i+1);

      // Independientemente de que hayamos mostrado el diálogo o no, debería tener los datos buenos
      bitmapPasteList[i].sizeX := FormPaste.getSizeX()/(10*AmpX*CalX);
      bitmapPasteList[i].sizeY := FormPaste.getSizeY()/(10*AmpY*CalY);
      bitmapPasteList[i].x := FormPaste.getOffsetX()/(10*AmpX*CalX);
      bitmapPasteList[i].y := FormPaste.getOffsetY()/(10*AmpY*CalY);

      // Copio el bitmap a memoria
      bitmapPasteList[i].bitmap := TBitmap.Create;
      bitmapPasteList[i].bitmap.Assign(Clipboard);

      UpdateCanvas(Self);

    except
        // Can't convert
    end;

  end
  else
  begin
    ShowMessage('No valid data in clipboard!');
  end;
end;

procedure TScanForm.STSConfigBtnClick(Sender: TObject);
begin
Form11.show;
end;

procedure TScanForm.ScrollBar2Change(Sender: TObject);
begin
  UpdateCanvas(nil)
end;

procedure TScanForm.ScrollBar3Change(Sender: TObject);
begin
  UpdateCanvas(nil)
end;

procedure TScanForm.btnMarkNowClick(Sender: TObject);
var
  i: Integer;
begin
  // Añado un elemento a la lista de bitmaps a dibujar en el área de barrido del piezo
  // Será un color sólido
  i := Length(bitmapPasteList);
  SetLength(bitmapPasteList, i+1);

  bitmapPasteList[i].x := XOffset;
  bitmapPasteList[i].y := YOffset;
  bitmapPasteList[i].sizeX := 2*P_Scan_Size*DataForm.scan_attenuator;
  bitmapPasteList[i].sizeY := 2*P_Scan_Size*DataForm.scan_attenuator;

  // En el caso de mark now no habrá bitmap, sólo un recuadro
  bitmapPasteList[i].bitmap := nil;

  // En el caso de mark now el bitmap será un color sólido. Me vale con un punto del color adecuado
{  bitmapPasteList[i].bitmap := TBitmap.Create;
  bitmapPasteList[i].bitmap.Width := 1;
  bitmapPasteList[i].bitmap.Height := 1;
  bitmapPasteList[i].bitmap.Canvas.Brush.Color := $00C0C0;
  bitmapPasteList[i].bitmap.Canvas.FillRect(Rect(0, 0, 1, 1));}

  UpdateCanvas(self);
end;

procedure TScanForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DestroyCitsTempFiles();
end;

// Cálculos extraidos de TScanForm.PointCanvasToGlobal, igualando el punto del canvas
// a cero (una vez normalizado entre +/-1) y despejando scrollX o scrollY
procedure TScanForm.btnCenterAtTipClick(Sender: TObject);
var
  zoomFactor, scrollX, scrollY, halfScollRange: Double;
begin
  halfScollRange := ScrollBar2.Max/2; // Asumo que empieza en cero
  zoomFactor := StrToFloat(ComboBox1.Text);

  // Scroll entre +/-1
  if (zoomFactor = 1) then
  begin
    scrollX := 0;
    scrollY := 0;
  end
  else
  begin
    scrollX :=  XOffset*zoomFactor/(zoomFactor-1);
    scrollY := -YOffset*zoomFactor/(zoomFactor-1);
  end;

  // Scroll entre 0 y el máximo de las barras
  ScrollBar3.Position := Round((scrollX+1)*halfScollRange);
  ScrollBar2.Position := Round((scrollY+1)*halfScollRange);

  UpdateCanvas(nil);
end;

procedure TScanForm.MarkRedBtnClick(Sender: TObject);

 var
  i: Integer;
begin
  // Añado un elemento a la lista de bitmaps a dibujar en el área de barrido del piezo
  // Será un color sólido
  i := Length(bitmapPasteList2);
  SetLength(bitmapPasteList2, i+1);

  bitmapPasteList2[i].x := XOffset;
  bitmapPasteList2[i].y := YOffset;
  bitmapPasteList2[i].sizeX := 2*P_Scan_Size*DataForm.scan_attenuator;
  bitmapPasteList2[i].sizeY := 2*P_Scan_Size*DataForm.scan_attenuator;

  // En el caso de mark now no habrá bitmap, sólo un recuadro
  bitmapPasteList2[i].bitmap := nil;

  // En el caso de mark now el bitmap será un color sólido. Me vale con un punto del color adecuado
{  bitmapPasteList[i].bitmap := TBitmap.Create;
  bitmapPasteList[i].bitmap.Width := 1;
  bitmapPasteList[i].bitmap.Height := 1;
  bitmapPasteList[i].bitmap.Canvas.Brush.Color := $00C0C0;
  bitmapPasteList[i].bitmap.Canvas.FillRect(Rect(0, 0, 1, 1));}

  UpdateCanvas(self);
end;

//procedure TScanForm.SpinEdit3Change(Sender: TObject);
//begin
//SleepDo := StrtoInt(SpinEdit3.Text);
//end;



end.

