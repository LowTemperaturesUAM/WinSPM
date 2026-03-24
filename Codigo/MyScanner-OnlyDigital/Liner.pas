{LINER
 08/08/2017

 -Accumulate sólo funciona para Current, no para Z ni other
 -Sólo deriva Current, no Z ni other
 -Falta programar el hold cuando toma las iv
 -Cuando derivas desde el botón "cambiar puntos de derivada" lo hace mal. 11/4/2018. Revisar si ya está corregido
}

 unit Liner;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus, Spin, blqdataset, var_gbl,
  Buttons, TeeProcs, TeEngine, Chart, Series, HeaderImg ;

type
  TDataCurve = Array [0..1,0..2048] of single;

  TLinerForm = class(TForm)
    DoBtn: TButton;
    DoRepeatBtn: TButton;
    AbortButton: TButton;
    SaveCurveBtn: TButton;
    chkSaveAllCurves: TCheckBox;
    ptnNumberSelect: TComboBox;
    curveNameEdit: TEdit;
    FileNumberSpin: TSpinEdit;
    ConfigBtn: TButton;
    Panel1: TPanel;
    AccumEdit: TSpinEdit;
    FinishIVBtn: TButton;
    AccumLbl: TLabel;
    DerivRadioG: TRadioGroup;
    HoldBtn: TButton;
    ReEnablePIDchk: TCheckBox;
    MeanLbl: TLabel;
    JumpLbl: TLabel;
    DerivPtsLbl: TLabel;
    CurveTypeRadioG: TRadioGroup;
    MeanEdit: TSpinEdit;
    JumpEdit: TSpinEdit;
    DerivPtsSpin: TSpinEdit;
    DeleteBtn: TButton;
    SaveDialog1: TSaveDialog;
    setNameBtn: TButton;
    OpenDialog1: TOpenDialog;
    lblCurveCount: TLabel;
    TempLbl: TLabel;
    TemperatureEdit: TEdit;
    KelvinLbl: TLabel;
    MagFieldLbl: TLabel;
    MagFieldEdit: TEdit;
    TeslaLbl: TLabel;
    scrollSizeBias: TScrollBar;
    lblColorPID: TLabel;
    ptsNumberLbl: TLabel;
    SizeLbl: TLabel;
    xAxisRange: TLabel;
    ChartLine: TChart;
    ChartLineSerie0: TFastLineSeries;
    ChartLineSerie1: TFastLineSeries;
    chkAcquireBlock: TCheckBox;
    progressIVLbl: TLabel;
    CtrlTimeEdit: TSpinEdit;
    CtrlTimeLbl: TLabel;
    chkPainYesNo: TCheckBox;
    BottomPanel: TPanel;
    RightPanel: TPanel;
    TopPanel: TPanel;
    GraphPanel: TPanel;
    ZAttText: TLabel;
    BiasAttText: TLabel;
    ZAttDispValue: TLabel;
    BiasAttDispValue: TLabel;
    DoOSbtn: TButton;
    OSRatioEdit: TSpinEdit;
    OSRatioLbl: TLabel;
    procedure OpenConfig(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure doIV(Sender: TObject);
    procedure doIV_reduce(Sender: TObject);
    procedure AbortRepeat(Sender: TObject);
    procedure ptnNumberSelectChange(Sender: TObject);
    procedure DerivaRectas (vin:vcurva; out vout:vcurva);
    procedure MeanEditChange(Sender: TObject);
    procedure JumpEditChange(Sender: TObject);
    procedure ChangePlotType(Sender: TObject);
    procedure doOnRepeat(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
    procedure saveBLQ(Sender: TObject);
    procedure setFileName(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure TemperatureEditEnter(Sender: TObject);
    procedure MagFieldEditEnter(Sender: TObject);
    procedure FileNumberSpinChange(Sender: TObject);
    procedure DerivRadioGClick(Sender: TObject);
    procedure scrollSizeBiasChange(Sender: TObject);
    procedure DerivPtsSpinChange(Sender: TObject);
    procedure HoldFeedback(Sender: TObject);
    procedure SaveIV(fileName: string; dataSet: Integer; comments: String);
    procedure FinishIVBtnClick(Sender: TObject);
    procedure ClearChart();
    procedure chkAcquireBlockClick(Sender: TObject);
    procedure chkPainYesNoClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure DoIV_oversample(Sender: TObject);
    procedure OSRatioEditChange(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  x_axisDac, x_axisADC: Integer;
  x_axisMult: Single;
  ReadZ, ReadCurrent, ReadOther: Boolean;
  NumCol:Integer;
  Multiplier : Single;
  ReadXfromADC : Boolean;
  Abort_Measure: Boolean;
  PointNumber: Integer;
  DataX: Array [0..1,0..2048] of single;
  DataZ: Array [0..1,0..2048] of single;
  DataCurrent: Array [0..1,0..2048] of single;
  DataOther: Array [0..1,0..2048] of single;
  enviax,recibey: single;
  LinerMean,Jump_xAxis: Integer;
  Size_xAxis: Single;
  Presentblknumber: Integer;
  Temperature,MagField: Single;
  StopIt: Boolean;
  
  //b : TblqLoader ;     //bqlLoader solo aparece aqui, creo que podemos eliminarlo
  DS : TblqDataSet ;
  blqname : string ;
  b_offset: Integer;
  Datos1,Datos2,CurvaADerivar: vcurva;
  CurvaDerivada: vcurva;
  PaintYesNo: Boolean; // Es para si se quiere o no pintar las IVs
  OversamplingRatio: Byte;
  Prejump: Integer;
  end;

var
  LinerForm: TLinerForm;

  //b : TblqLoader ;
  blqname : string ;
  b_offset: Integer;
  CurvaADerivar: vcurva; //estamos definiendo esta variable dos veces?
  CurvaDerivada: vcurva;
const
  OSRatio = 4;

implementation

uses Config_Liner, Scanner1, DataAdcquisition, PID, Config1, FileNames, Math;

{$R *.DFM}

//Open Config
procedure TLinerForm.OpenConfig(Sender: TObject);
begin
LinerConfig.Show;
end;

//Open Liner
procedure TLinerForm.FormShow(Sender: TObject);
begin
//xyyGraph1[1].PlotPoints:=False;
Abort_Measure:=False;
if LinerConfig.RadioGroup1.ItemIndex=0 then ReadXfromADC:=True else
ReadXfromADC:=False;
x_axisDac:=LinerConfig.SpinEdit1.Value;
x_axisAdc:=LinerConfig.seADCxaxis.Value;
//Asumimos que la atenuacion inicial de todos los canales es siempre 1
x_axisMult:=StrtoFloat(LinerConfig.xDACMultiplier.Text);
NumCol:=1;
if LinerConfig.Checkbox1.checked then NumCol:=NumCol+1;
if LinerConfig.Checkbox2.checked then NumCol:=NumCol+1;
if LinerConfig.Checkbox3.checked then NumCol:=NumCol+1;
ReadZ:=LinerConfig.Checkbox1.checked;
ReadCurrent:=LinerConfig.Checkbox2.checked;
ReadOther:=LinerConfig.Checkbox3.checked;

PointNumber:=StrtoInt(ptnNumberSelect.Text);  // Número de puntos de cada IV
ScanForm.RedimCits(ScanForm.IV_Scan_Lines, PointNumber);

LinerMean:=MeanEdit.Value;
Jump_xAxis:=JumpEdit.Value;
Size_xAxis:=scrollSizeBias.Position/100;

Temperature:=StrtoFloat(TemperatureEdit.Text);
MagField:=StrtoFloat(MagFieldEdit.Text);
ChartLine.LeftAxis.AxisValuesFormat := '0.####E+0';
StopIt:=True;
PaintYesNo:=chkPainYesNo.checked;
OversamplingRatio:=0;
end;

//Do
procedure TLinerForm.doIV(Sender: TObject);
{Salvo y lo meto en:
  ida                 vuelta
  DataX[0,i]          DataX[1,i]
  DataZ[0,i]          DataZ[1,i]
  DataCurrent[0,i]    DataCurrent[1,i]
  DataOther[0,i]      DataOther[1,i]}

var
j,h,k,Princ,Fin: Integer;
//j: 1..1000; //Los valores que podemos coger en la interfaz estan limitados a este rango
DataCurrentOld: Array [0..1,0..2048] of single;
here_previous_ctrl:  Double;
NumberControl: Integer;


begin
// Le decimos a la aplicación que procese los mensajes por si aún queda algún evento del temporizador, que no interfiera con la adquisición de la rampa
Application.ProcessMessages();
NumberControl:=CtrlTimeEdit.Value;

if ReEnablePIDchk.Checked then
   begin
    FormPID.Button9Click(nil);  // desactiva el feedback
    //FormPID.thrdtmr1.Enabled:=False; //apagamos el timer
   end;

here_previous_ctrl:=0;

  // Creamos los vectores DataCurrentOld que usaremos para el accumulate
  for h:=0 to PointNumber -1 do
    begin
      DataCurrentOld[0,h]:=  0.0;
      DataCurrentOld[1,h]:=  0.0;
    end;
  //Bucle del accumulate. Tomamos tantas curvas como ponga en el SpinEdit de accumulate
  //y vamos haciendo la media con las anteriores y actualizando el gráfico
  while (Abort_Measure=False) do
  begin
  for j:=0 to AccumEdit.Value -1 do
  begin

    // Be careful with the following things, because the voltage will be suddenly modified
    if LinerConfig.ReverseCheck.Checked then   // This is when we want to reverse the bias
    begin
      if LinerConfig.chkReduceRamp.Checked then    //This is when we want to make an IV curve with a reduced ramp
        Princ:=Round(-32768/LinerConfig.seReduceRampFactor.Value*Size_xAxis)
      else
    Princ:=Round(-32768*Size_xAxis);
    end
    else
    begin
      if LinerConfig.chkReduceRamp.Checked then    //This is when we want to make an IV curve with a reduced ramp
        Princ:=Round(32768/LinerConfig.seReduceRampFactor.Value*Size_xAxis)
      else
    Princ:=Round(32768*Size_xAxis);
    end;
    // It might be more desisable to go thorough zero instead of making the IV symmetric
    // We should consider changing it by default or allow the user to change it
    Fin:=-Princ;
    // Also: for maximum range, we are going above the DAC limit by 1 LSB
    // as it goes from -32768 to 32767
    // Indicamos por qué iteracion vamos
    progressIVLbl.Caption := format ('%d of', [j+1]);

    // Forth (Rampa de ida)
    // Lectura de UNA rampa de ida
    //DataForm.ramp_take(x_axisDac, Princ, Fin, 0, PointNumber, Jump_xaxis, 0, chkAcquireBlock.Checked);
    DataForm.ramp_take_os(x_axisDac, Princ, Fin, 0, PointNumber, Jump_xaxis, 0, chkAcquireBlock.Checked,OSRatio);

    // Back (rampa de vuelta)
    //Lectura de UNA rampa de vuelta
    //DataForm.ramp_take(x_axisDac, Fin, Princ, 1, PointNumber, Jump_xaxis, 0, chkAcquireBlock.Checked);
    DataForm.ramp_take_os(x_axisDac, Fin, Princ, 1, PointNumber, Jump_xaxis, 0, chkAcquireBlock.Checked,OSRatio);

    {FormPID.Button8Click(nil);
    sleep(20);
    FormPID.Button9Click(nil);
    }

    for h:=0 To PointNumber - 1 do
      begin
      //Calculamos la media de la curva actual (DataCurrent) con las curvas acumuladas hasta ahora (DataCurrentOld)
      DataCurrent[0,h]:=  DataCurrentOld[0,h]*(j/(j +1)) + DataCurrent[0,h]*(1/(j+1));
      DataCurrent[1,h]:=  DataCurrentOld[1,h]*(j/(j+1)) + DataCurrent[1,h]*(1/(j+1));

      DataCurrentOld[0,h]:=  DataCurrent[0,h];
      DataCurrentOld[1,h]:=  DataCurrent[1,h];
      end;

    if (PaintYesNo) then ChangePlotType(nil); //Pintamos

    // Esto es peligroso, pero lo hacemos, a ver si no da problemas ...
    // volvemos a poner Princ al valor máximo antes de hacer funcionar el control otra vez
    if LinerConfig.chkReduceRamp.Checked then
      if LinerConfig.ReverseCheck.Checked then Princ:=Round(-32768*Size_xAxis)
      else Princ:=Round(32768*Size_xAxis);

    DataForm.dac_set(x_axisDAC,Princ, nil);

    // Vamos a dejar funcionar el control durante 2 s
    //j es siempre 0 o positivo. Para que lo comprobamos?
    //De hecho, deberiamos usar un Cardinal
    if (j>=0) then
    begin
    FormPID.thrdtmr1.Enabled:=False;
    FormPID.Button8Click(nil);  // activa el feedback
    // deberiamos activar el feedback solamente si NumberControl>0
        k:=0;
    while (k<NumberControl)  do
      begin
       k:=k+1;
         here_previous_ctrl:=FormPID.Controla(1,here_previous_ctrl, True);   // controla SIN threadtimer
         Sleep(1);
      end;
    FormPID.Button9Click(nil);  // desactiva el feedback
    FormPID.thrdtmr1.Enabled:=True;
    //Application.ProcessMessages;
    end;

    Application.ProcessMessages();
  end;
  if chkSaveAllCurves.checked then saveBLQ(nil); //Guardar automáticamente si está chequeado
  Abort_Measure:=True;
  end;

 if (Abort_Measure=True) then Abort_Measure:=False;

 if ReEnablePIDchk.Checked then
   begin
    FormPID.Button8Click(nil);
    //FormPID.thrdtmr1.Enabled:=True; //encendemos el timer
   end;

 //Application.ProcessMessages();

end;

//Do
procedure TLinerForm.doIV_reduce(Sender: TObject);
{Salvo y lo meto en:
  ida                 vuelta
  DataX[0,i]          DataX[1,i]
  DataZ[0,i]          DataZ[1,i]
  DataCurrent[0,i]    DataCurrent[1,i]
  DataOther[0,i]      DataOther[1,i]}

var
j,h,k,Princ,Fin,value1,value2: Integer;
//j: 1..1000; //Los valores que podemos coger en la interfaz estan limitados a este rango
DataCurrentOld: Array [0..1,0..2048] of single;
here_previous_ctrl:  Double;
NumberControl: Integer;


begin
// Le decimos a la aplicación que procese los mensajes por si aún queda algún evento del temporizador, que no interfiera con la adquisición de la rampa
Application.ProcessMessages();
NumberControl:=CtrlTimeEdit.Value;

if ReEnablePIDchk.Checked then
   begin
    FormPID.Button9Click(nil);  // desactiva el feedback
    //FormPID.thrdtmr1.Enabled:=False; //apagamos el timer
   end;

here_previous_ctrl:=0;

  // Creamos los vectores DataCurrentOld que usaremos para el accumulate
  for h:=0 to PointNumber -1 do
    begin
      DataCurrentOld[0,h]:=  0.0;
      DataCurrentOld[1,h]:=  0.0;
    end;
  //Bucle del accumulate. Tomamos tantas curvas como ponga en el SpinEdit de accumulate
  //y vamos haciendo la media con las anteriores y actualizando el gráfico
  while (Abort_Measure=False) do
  begin
  for j:=0 to AccumEdit.Value -1 do
  begin

    // Be careful with the following things, because the voltage will be suddenly modified
    if LinerConfig.ReverseCheck.Checked then   // This is when we want to reverse the bias
    begin
      if LinerConfig.chkReduceRamp.Checked then    //This is when we want to make an IV curve with a reduced ramp
      begin
        value1:=Round(-32768/LinerConfig.seReduceRampFactor.Value*Size_xAxis);
        Princ:=Round(-32768*Size_xAxis);
      end
      else
      begin
        value1:=Round(-32768*Size_xAxis);
        Princ:=value1;
      end
    end
    else
    begin
      if LinerConfig.chkReduceRamp.Checked then    //This is when we want to make an IV curve with a reduced ramp
      begin
        value1:=Round(32768/LinerConfig.seReduceRampFactor.Value*Size_xAxis);
        Princ:=Round(32768*Size_xAxis);
      end
      else
      begin
        value1:=Round(32768*Size_xAxis);
        Princ:=value1;
      end;
    end;
    // It might be more desisable to go thorough zero instead of making the IV symmetric
    // We should consider changing it by default or allow the user to change it
    //Fin:=-Princ;
    Fin := -value1;
    value2 := -value1;
    // Also: for maximum range, we are going above the DAC limit by 1 LSB
    // as it goes from -32768 to 32767
    // Indicamos por qué iteracion vamos
    progressIVLbl.Caption := format ('%d of', [j+1]);

    // Forth (Rampa de ida)
    // Lectura de UNA rampa de ida
    //DataForm.ramp_take(x_axisDac, Princ, Fin, 0, PointNumber, Jump_xaxis, 0, chkAcquireBlock.Checked);
    //DataForm.ramp_take_os(x_axisDac, Princ, Fin, 0, PointNumber, Jump_xaxis, 0, chkAcquireBlock.Checked,OSRatio);
    DataForm.ramp_take_reduce2(x_axisDac, value1,value2,Princ, Fin, 0, PointNumber, Jump_xaxis,Prejump, chkAcquireBlock.Checked,OSRatio);
    //DataForm.ramp_take_simple(x_axisDac, value1,value2,Princ, Fin, 0, PointNumber, Jump_xaxis,Prejump, chkAcquireBlock.Checked,OSRatio);
    //DataForm.ramp_take_reducesimple(x_axisDac, value1,value2,Princ, Fin, 0, PointNumber, Jump_xaxis,Prejump, chkAcquireBlock.Checked,OSRatio);

    //ramp_take_reduce2(ndac, value1, value2,startval, finalval, dataSet, npoints, jump,prejump: Integer; blockAcq: Boolean;OSRatio: Byte): boolean;
    // Back (rampa de vuelta)
    //Lectura de UNA rampa de vuelta
    //DataForm.ramp_take(x_axisDac, Fin, Princ, 1, PointNumber, Jump_xaxis, 0, chkAcquireBlock.Checked);
    //DataForm.ramp_take_os(x_axisDac, Fin, Princ, 1, PointNumber, Jump_xaxis, 0, chkAcquireBlock.Checked,OSRatio);
    DataForm.ramp_take_reduce2(x_axisDac, value2,value1,Fin, Princ, 1, PointNumber, Jump_xaxis,Prejump, chkAcquireBlock.Checked,OSRatio);
    //DataForm.ramp_take_simple(x_axisDac, value2,value1,Fin, Princ, 1, PointNumber, Jump_xaxis,Prejump, chkAcquireBlock.Checked,OSRatio);
    //DataForm.ramp_take_reducesimple(x_axisDac, value2,value1,Fin, Princ, 1, PointNumber, Jump_xaxis,Prejump, chkAcquireBlock.Checked,OSRatio);

    for h:=0 To PointNumber - 1 do
      begin
      //Calculamos la media de la curva actual (DataCurrent) con las curvas acumuladas hasta ahora (DataCurrentOld)
      DataCurrent[0,h]:=  DataCurrentOld[0,h]*(j/(j +1)) + DataCurrent[0,h]*(1/(j+1));
      DataCurrent[1,h]:=  DataCurrentOld[1,h]*(j/(j+1)) + DataCurrent[1,h]*(1/(j+1));

      DataCurrentOld[0,h]:=  DataCurrent[0,h];
      DataCurrentOld[1,h]:=  DataCurrent[1,h];
      end;

    if (PaintYesNo) then ChangePlotType(nil); //Pintamos

    // Esto es peligroso, pero lo hacemos, a ver si no da problemas ...
    // volvemos a poner Princ al valor máximo antes de hacer funcionar el control otra vez
    if LinerConfig.chkReduceRamp.Checked then
      if LinerConfig.ReverseCheck.Checked then Princ:=Round(-32768*Size_xAxis)
      else Princ:=Round(32768*Size_xAxis);

    //DataForm.dac_set(x_axisDAC,Princ, nil);

    // Vamos a dejar funcionar el control durante 2 s
    //j es siempre 0 o positivo. Para que lo comprobamos?
    //De hecho, deberiamos usar un Cardinal
    if (j>=0) then
    begin
    FormPID.thrdtmr1.Enabled:=False;
    FormPID.Button8Click(nil);  // activa el feedback
    // deberiamos activar el feedback solamente si NumberControl>0
        k:=0;
    while (k<NumberControl)  do
      begin
       k:=k+1;
         here_previous_ctrl:=FormPID.Controla(1,here_previous_ctrl, True);   // controla SIN threadtimer
         Sleep(1);
      end;
    FormPID.Button9Click(nil);  // desactiva el feedback
    FormPID.thrdtmr1.Enabled:=True;
    //Application.ProcessMessages;
    end;

    Application.ProcessMessages();
  end;
  if chkSaveAllCurves.checked then saveBLQ(nil); //Guardar automáticamente si está chequeado
  Abort_Measure:=True;
  end;

 if (Abort_Measure=True) then Abort_Measure:=False;

 if ReEnablePIDchk.Checked then
   begin
    FormPID.Button8Click(nil);
    //FormPID.thrdtmr1.Enabled:=True; //encendemos el timer
   end;

 //Application.ProcessMessages();

end;

//Abort
procedure TLinerForm.AbortRepeat(Sender: TObject);
begin
if Abort_Measure=False then Abort_Measure:=True;
if (DoRepeatBtn.Caption='STOP') then
 DoRepeatBtn.Caption:='DODO';
 Application.ProcessMessages;
end;

//Número de puntos
procedure TLinerForm.ptnNumberSelectChange(Sender: TObject);
var
  isvalid: Boolean;
  input: Integer;
begin
// should check if it is a number and smaller or equal to 2048
isvalid := TryStrtoInt(ptnNumberSelect.Text,input);
if isvalid then
begin
  if (input <= 2048) then
  begin
  PointNumber:=StrtoInt(ptnNumberSelect.Text);
  ScanForm.RedimCits(ScanForm.IV_Scan_Lines, PointNumber);
  end
  else
  begin
  ptnNumberSelect.Text := InttoStr(PointNumber);
  end;

end;
end;

//Función para derivar
procedure TLinerForm.DerivaRectas (vin:vcurva;out vout:vcurva);
//Los parámetros de la función son vin (input) y vout (output).
//Son variables tipo "vcurva". "vcurva" es una estructura donde .x son los datos de la ida, .y los datos de la vuelta, y .n otra cosa no importante para esto.
//Para derivar, los datos "Y" están guardados en la vcurva, y los datos "X" están guardados en DataX
var       i,o,np,m,tot0,pderi                 : integer;
          sx,sy,sx2,sxy,b,bb,cc,nps,sx_2,sy_2,sx2_2,sxy_2,b_2,bb_2,cc_2           : double;{single;}
          tempForth, tempBack: Single;
begin
 m:=StrToInt(ptnNumberSelect.text); //Número de puntos

    //Valores iniciales
    FOR i:=0 TO  m-1 do begin
        vout.x[i] :=0;
        vout.y[i]:= 0;
    end;
    vout.n := m;

pderi:=DerivPtsSpin.Value-1;//Puntos de derivada
//pderi:= pderi - 1;

if pderi=0 then begin //Si un punto de derivada
    // El ultimo punto de cada curva se desvía. Hay algo que no esta del todo bien aqui
     for i:=0 to m-1 do
     begin
        //DataX[0,i]:=0.5*(DataX[0,i]+DataX[0,i+1]);// estamos shifteando los datos!!!
        //DataX[1,i]:=0.5*(DataX[1,i]+DataX[1,i+1]);
        tempForth:=0.5*(DataX[0,i]+DataX[0,i+1]);
        tempBack:=0.5*(DataX[1,i]+DataX[1,i+1]);

        if (tempForth-DataX[0,i+1])<>0 then vout.x[i]:=(vin.x[i]-vin.x[i+1])/(tempForth-DataX[0,i+1]);


        if (tempBack-DataX[1,i+1])<>0 then vout.y[i]:=(vin.y[i]-vin.y[i+1])/(tempBack-DataX[1,i+1]);



     end;
     //DataX[0,m]:=DataX[0,m-1];
     //DataX[1,m]:=DataX[1,m-1];
     vout.y[m]:=vout.y[m-1];
     vout.x[m]:=vout.x[m-1];
    end


 else begin   //Si más de un punto de derivada
     for i:=0 to m-1 do begin
          (* minimos cuadrados*)
          SX:=0;SY:=0;SXY:=0;SX2:=0;np:=0;
          SX_2:=0;SY_2:=0;SXY_2:=0;SX2_2:=0;
          FOR O:=(i-pderi) TO (i+pderi) do begin
            if ( (o>=0) and (o<m)) then begin
               inc(np);
               SX:=SX+(DataX[0,o]-DataX[0,i]);
               SX_2:=SX_2+(DataX[1,o]-DataX[1,i]);
               SY:=SY+(vin.x[o]-vin.x[i]);
               SY_2:=SY_2+(vin.y[o]-vin.y[i]);
               SXY:=SXY+(DataX[0,o]-DataX[0,i])*(vin.x[o]-vin.x[i]);
               SXY_2:=SXY_2+(DataX[1,o]-DataX[1,i])*(vin.y[o]-vin.y[i]);
               SX2:=SX2+sqr(DataX[0,o]-DataX[0,i]);
               SX2_2:=SX2_2+sqr(DataX[1,o]-DataX[1,i]);
               end;
          end;
          nps:=1.0*np;
          bb:=((nps*SXY)-(SX*SY));
          bb_2:=((nps*SXY_2)-(SX_2*SY_2));
          cc:=((nps*SX2)-(SX*SX));
          cc_2:=((nps*SX2_2)-(SX_2*SX_2));

          if abs(cc)<1e-10  then b:=1e10 else b:=bb/cc;
          vout.x[i]:=bb;

          if abs(cc_2)<1e-10  then b_2:=1e10 else b_2:=bb_2/cc_2;
          vout.y[i]:=bb_2;

          tot0:=m;
          vout.n:=tot0;
     end;


end;
end;

//Cambio en Mean
procedure TLinerForm.MeanEditChange(Sender: TObject);
begin
  TryStrToInt(MeanEdit.Text, LinerMean);
end;

//Cambio en Jump
procedure TLinerForm.JumpEditChange(Sender: TObject);
begin
  TryStrToInt(JumpEdit.Text, Jump_xAxis);
end;

//Pintar las curvas
procedure TLinerForm.ChangePlotType(Sender: TObject);
var
i: Integer;
DatatoPlot_X: Array[0..1,0..2048] of single;
DatatoPlot_Y: Array[0..1,0..2048] of single;
DataConductanceVcurva: vcurva;//Creamos vcurvas para meterlas en la función derivaRectas
DataCurrentVcurva: vcurva;
DataPlot: Array[0..1,0..2048] of single;

begin
  for i:=0 to PointNumber-1 do
    begin
    DataCurrentVcurva.x[i]:=DataCurrent[0,i];  //Pasamos el Vcurva a array
    DataCurrentVcurva.y[i]:=DataCurrent[1,i];
    DataCurrentVcurva.n:=PointNumber;
    end;
if DerivRadioG.ItemIndex=0 then      //if "Direct" (sin derivar)
begin
 for i:=0 to PointNumber-1 do
    begin
    DataPlot[0,i]:=DataCurrent[0,i];   //Lo pasamos para plotear
    DataPlot[1,i]:=DataCurrent[1,i];
    end;
end
else    //if "Derivative" (derivada)
begin
DerivaRectas(DataCurrentVcurva,DataConductanceVcurva);
 for i:=0 to PointNumber-1 do
    begin
    DataCurrentVcurva.n:=PointNumber;
    DataPlot[0,i]:=DataConductanceVcurva.x[i];
    DataPlot[1,i]:=DataConductanceVcurva.y[i];
    end;
end;
  //LLenamos DatatoPlot con lo que toque para pintar
  for i:=0 to PointNumber-1 do
  begin
  DatatoPlot_X[0,i]:=DataX[0,i];
  DatatoPlot_X[1,i]:=DataX[1,i];
  end;

  if CurveTypeRadioG.ItemIndex=0 then
  begin
  for i:=0 to PointNumber-1 do
    begin
    DatatoPlot_Y[0,i]:=DataPlot[0,i];
    DatatoPlot_Y[1,i]:=DataPlot[1,i];
    end;
  end
  else
  if CurveTypeRadioG.ItemIndex=1 then
  begin
  for i:=0 to PointNumber-1 do
    begin
    DatatoPlot_Y[0,i]:=DataZ[0,i];
    DatatoPlot_Y[1,i]:=DataZ[1,i];
    end;
  end
  else
  if CurveTypeRadioG.ItemIndex=2 then
  begin
  for i:=0 to PointNumber-1 do
    begin
    DatatoPlot_Y[0,i]:=DataOther[0,i];
    DatatoPlot_Y[1,i]:=DataOther[1,i];
    end;
  end;

  ClearChart();


  for i:=0 to PointNumber-1 do
    begin
      ChartLineSerie0.AddXY(DatatoPlot_X[0,i],DatatoPlot_Y[0,i]);
      ChartLineSerie1.AddXY(DatatoPlot_X[1,i],DatatoPlot_Y[1,i]);
    end;
end;

//DoDo
procedure TLinerForm.doOnRepeat(Sender: TObject);
begin
Application.ProcessMessages;
if (DoRepeatBtn.Caption='STOP') then
 begin
 DoRepeatBtn.Caption:='DODO';
 exit;
 end
 else
 begin
 while (Abort_Measure=False) do
  begin
  DoRepeatBtn.Caption:='STOP';
  doIV(nil);
  if (DoRepeatBtn.Caption='DODO') then exit;
  end;
 Abort_Measure:=False;
 end;
end;

//Delete Graph
procedure TLinerForm.DeleteBtnClick(Sender: TObject);
begin
  ClearChart();
//xyyGraph1.Clear;
//xyyGraph1.Update;
end;

//Guardar
procedure TLinerForm.saveBLQ(Sender: TObject);
var
i,j,k,cols,BlockOffset: Integer;
fileNr: Integer;
curInd: UInt64;
curveName,BlockFileName,BlockFile,TakeComment:string;

begin
fileNr := FileNumberSpin.Value;
curveName := curveNameEdit.Text;
//The name for each curve in the blq is only 32 characters long
// We can skip the check, as we made sure that name999.XXXX has shorter input
BlockFileName:=SaveDialog1.Filename+InttoStr(fileNr)+'.blq';
TakeComment:=DateTimeToStr(Now)+#13+#10+
    'T(K)='+FloattoStrF(Temperature,ffGeneral,5,2)+#13+#10+
    'B(T)='+FloattoStrF(MagField,ffGeneral,5,2)+#13+#10+
    'X(nm)='+FloattoStrF(ScanForm.XOffset*10*ScanForm.AmpX*ScanForm.CalX, ffGeneral, 5, 4)+#13+#10+
    'Y(nm)='+FloattoStrF(ScanForm.YOffset*10*ScanForm.AmpY*ScanForm.CalY, ffGeneral, 5, 4)+#13+#10;
for k:=0 to 1 do
begin
  BlockOffset:=k;
  //BlockFile:=curveNameEdit.Text+FloattoStrF(number,ffFixed,5,4);
  curInd := Presentblknumber+BlockOffset;
  curInd := curInd mod 10000; // if we go beyond 4 digits, we simply wrap around
  BlockFile:=curveName+IntToStr(fileNr)+'.'+Format('%4.4d',[curInd]);
  DS:=TblqDataSet.Create(NumCol,PointNumber) ;
  DS._Name:=BlockFile; // Aquí se pone el fichero con .xxxx al final
  DS._BlockFile:=BlockFileName ; // Es el fichero de verdad, como en dd
  DS._BlockOffset:=Presentblknumber+BlockOffset ;
  DS._Moment:=Now;  //this value doesn't mean anything
  DS._Time:=Now ;
  //BlockFile:=SaveDialog1.Filename+InttoStr(fileNr); // we don't even use this value at all
  if (k=0) then DS._Comment:=TakeComment+'Forth';
  if (k=1) then DS._Comment:=TakeComment+'Back';


  // COL HEADER
  DS[0]._DataFormat:=4 ;                    // This is single
  DS[0]._AxisType:=blqdataset.units_voltage;// Units Current
  DS[0]._Prom:=1 ;
  DS[0]._Offset:=0 ;
  DS[0]._Factor:=1.0 ;                      // No prefactor
  DS[0]._Start:=0 ;
  DS[0]._Size:=1 ;
  DS[0]._CTime:=0 ;
  for j:=0 to 3 do DS[0]._ParamA[j]:=0;
  for j:=0 to 7 do DS[0]._ParamB[j]:=0;

  for i:=1 to NumCol-1 do
  begin
    //BlockFile:=SaveDialog1.Filename+InttoStr(fileNr); // we don't even use this value at all
    //if (k=0) then DS._Comment:=TakeComment+'Forth';
    //if (k=1) then DS._Comment:=TakeComment+'Back';
    // COL HEADER
    DS[i]._DataFormat:=4 ;                    // This is single
    //DS[i]._AxisType:=blqdataset.units_current;// Units Current
    DS[i]._Prom:=1 ;
    DS[i]._Offset:=0 ;
    DS[i]._Factor:=1.0 ;                      // No prefactor
    DS[i]._Start:=0 ;
    DS[i]._Size:=1 ;
    DS[i]._CTime:=0 ;
    for j:=0 to 3 do DS[i]._ParamA[j]:=0 ;
    for j:=0 to 7 do DS[i]._ParamB[j]:=0 ;
  end;

 for i:=0 to PointNumber-1 do DS[0].Value[i]:=DataX[k,i];

 cols:=0;
 if ReadZ then
     begin
     cols:=cols+1;
     DS[cols]._AxisType:=blqdataset.units_displacement;// Units of displacement
     for i:=0 to PointNumber-1 do DS[cols].Value[i]:=DataZ[k,i];
     end;
 if ReadCurrent then
     begin
     cols:=cols+1;
     DS[cols]._AxisType:=blqdataset.units_current;// Units Current
     for i:=0 to PointNumber-1 do DS[cols].Value[i]:=DataCurrent[k,i];
     end;
 if ReadOther then
     begin
     cols:=cols+1;
     DS[cols]._AxisType:=blqdataset.units_voltage;// Units Voltage
     for i:=0 to PointNumber-1 do DS[cols].Value[i]:=DataOther[k,i];
     end;

WriteDataSetInBlock(BlockFileName,DS,False);
DS.Free;
end;
Presentblknumber:=Presentblknumber+2;
lblCurveCount.Caption:=InttoStr(Presentblknumber);

//Solo guardamos la curva para la primera que tomamos en un mismo blq,
// para evitar sobreescribir el archivo de curvas todo el tiempo
// si marcamos Save All no guarda ninguna
// no deberia de afectar a si guardamos una espectro en formato WSxM
if (Presentblknumber < 3) and (not chkSaveAllCurves.Checked) then    //
begin
  if ReadZ then
    SaveIV(SaveDialog1.Filename+InttoStr(fileNumberSpin.Value)+'.zv.cur', 0, TakeComment);

  if ReadCurrent then
    SaveIV(SaveDialog1.Filename+InttoStr(fileNumberSpin.Value)+'.iv.cur', 1, TakeComment);

  if ReadOther then
    SaveIV(SaveDialog1.Filename+InttoStr(fileNumberSpin.Value)+'.other.cur', 2, TakeComment);
end;


end;

// Guarda las curvas IV en el formato de WSxM
// Nacho Horcas, diciembre de 2017
procedure TLinerForm.SaveIV(fileName: string; dataSet: Integer; comments: String);
var
  myFile : TextFile;
  commentsWSxM, strLine: string;
//  strGeneralInfoDir :string;
  factorX, factorY: double;
  i: Integer;
  DataCurve: ^TDataCurve;

begin

  DecimalSeparator := '.';
  factorX := 1;
  commentsWSxM := StringReplace(comments, #13#10, '\n', [rfReplaceAll, rfIgnoreCase]);

  AssignFile(myFile, fileName);
  ReWrite(myFile);

  WriteLn(myFile, 'WSxM file copyright UAM');

  case dataSet of
    0: begin
      WriteLn(myFile, 'ZV curve file');
      factorY := 1e9; // m a nm
      DataCurve := @DataZ;
    end;
    1:  begin
      WriteLn(myFile, 'IV curve file');
      factorY := 1e9; // A a nA
      DataCurve := @DataCurrent;
    end;
    else begin
      WriteLn(myFile, 'Generic curve file');
      factorY := 1;
      DataCurve := @DataOther;
    end;
  end;

  WriteLn(myFile, 'Image header size: 0');
  WriteLn(myFile, '');
  WriteLn(myFile, '[General Info]');
  WriteLn(myFile, '');
  WriteLn(myFile, '    Number of lines: 2'); // Ida y vuelta

  strLine := Format('    Number of points: %d', [PointNumber]);
  WriteLn(myFile, strLine);

  WriteLn(myFile, '    X axis text: V[#x]');
  WriteLn(myFile, '    X axis unit: V');

  case dataSet of
    0: begin
      WriteLn(myFile, '    Y axis text: Z[#y]');
      WriteLn(myFile, '    Y axis unit: nm');
    end;
    1:  begin
      WriteLn(myFile, '    Y axis text: I[#y]');
      WriteLn(myFile, '    Y axis unit: nA');
    end;
    else begin
      WriteLn(myFile, '    Y axis text: V[#y]');
      WriteLn(myFile, '    Y axis unit: V');
    end;
  end;

  WriteLn(myFile, '');
  WriteLn(myFile, '[Miscellaneous]');
  WriteLn(myFile, '');
  Write(myFile, '    Comments: ');
  WriteLn(myFile, commentsWSxM);
  WriteLn(myFile, '    First Forward: Yes');
  WriteLn(myFile, '    Saved with version: MyScanner '+Form8.Version);
  WriteLn(myFile, '    Version: 3.0 (July 2004)');
  WriteLn(myFile, '');
  WriteLn(myFile, '[Header end]');

  for i:=0 to PointNumber-1 do
  begin
    strLine := Format('%g %g %g %g', [DataX[0,i]*factorX, DataCurve^[0,i]*factorY,
      DataX[1,i]*factorX, DataCurve^[1,i]*factorY]);
    WriteLn(myFile, strLine);
  end;

  CloseFile(myFile);
end;


//Set File Name
procedure TLinerForm.setFileName(Sender: TObject);
var
  tempName: string;
begin
SaveDialog1.FileName:=curveNameEdit.Text;

if SaveDialog1.Execute then
  begin
  Presentblknumber:=0; //Reset the curve index and the corresponding text
  lblCurveCount.Caption:=InttoStr(Presentblknumber);
  //Place the new directory in the corresponding window
  Form9.Label6.Caption:=ExtractFileDir(SaveDialog1.FileName);
  //Get back the filename without extension, and check that it's not too long
  tempName := ExtractFileName(SaveDialog1.FileName);
  tempName := ChangeFileExt(tempName,'');
  //Make sure the name for the curve fits the 32 byte long field in the blq file
  if Length(tempName) > 25 then
  begin
   tempName := Format('%24.24s',[tempName]);
  end;
  curveNameEdit.Text:=tempName;
  end;
end;

//En principio no hace nada, button10 no existe
procedure TLinerForm.Button10Click(Sender: TObject);
var
BlockFile:string;
b_offset: Integer;

begin
BlockFile:=SaveDialog1.Filename+InttoStr(fileNumberSpin.Value)+'.blq';

LoadDataSetFromBlock(BlockFile,0,DS);

//Label11.Caption:=InttoStr(DS.NRows);

Application.ProcessMessages;
end;

//Temperatura
procedure TLinerForm.TemperatureEditEnter(Sender: TObject);
var
  YesField,YesTemp: Boolean;
begin
if (TemperatureEdit.text='')then exit;
YesTemp := TryStrToFloat(TemperatureEdit.Text,Temperature);
YesField :=TryStrToFloat(MagFieldEdit.Text, MagField);
if YesTemp and YesField then
  Form8.Edit1.Text:='T='+FloatToStrF(Temperature,ffGeneral,5,2)+'K,H='+FloatToStrF(MagField,ffGeneral,5,2)+'T,'
else exit;
end;
//Campo magnético
procedure TLinerForm.MagFieldEditEnter(Sender: TObject);
var
  YesField,YesTemp: Boolean;
begin
if (MagFieldEdit.text='')then exit;
YesTemp := TryStrToFloat(TemperatureEdit.Text,Temperature);
YesField :=TryStrToFloat(MagFieldEdit.Text, MagField);
if YesTemp and YesField then
  Form8.Edit1.Text:='T='+FloatToStrF(Temperature,ffGeneral,5,2)+'K,H='+FloatToStrF(MagField,ffGeneral,5,2)+'T,'
else exit;
end;

//blq Number para guardar
procedure TLinerForm.FileNumberSpinChange(Sender: TObject);
begin
  Presentblknumber:=0;
  lblCurveCount.Caption:=InttoStr(Presentblknumber);
end;

//Pintar cada vez que pulsamos "Direct" o "Derivative"
procedure TLinerForm.DerivRadioGClick(Sender: TObject);
begin
ChangePlotType(nil);
end;

//Cambiar bias
procedure TLinerForm.scrollSizeBiasChange(Sender: TObject);
begin
Size_xAxis:=scrollSizeBias.Position/100;
if LinerConfig.ReverseCheck.Checked then
DataForm.dac_set(LinerConfig.SpinEdit1.Value, Round(-32767*Size_xAxis), nil)
else
DataForm.dac_set(LinerConfig.SpinEdit1.Value, Round(32767*Size_xAxis), nil);

//xAxisRange.Caption:=IntToStr(scrollSizeBias.Position);
if x_axisDac = 6 then //assume this is the Bias DAC by default
begin
  if abs(x_axisMult)<1 then //mV
  begin
    if LinerConfig.ReverseCheck.Checked then
    xAxisRange.Caption:=Format('%.3g mV', [Size_xAxis*x_axisMult*-1e3])
    else xAxisRange.Caption:=Format('%.3g mV', [Size_xAxis*x_axisMult*1e3]);
  end
  else xAxisRange.Caption:=Format('%.3g V', [Size_xAxis*x_axisMult]);
end
else xAxisRange.Caption:=IntToStr(scrollSizeBias.Position);
end;

//Pintar cuando cambias los puntos de derivada
procedure TLinerForm.DerivPtsSpinChange(Sender: TObject);
begin
if DerivRadioG.ItemIndex=0 then
  begin
  DerivRadioG.ItemIndex:=1;
  ChangePlotType(nil);
  end
else
  ChangePlotType(nil);
end;

//Hold PID
procedure TLinerForm.HoldFeedback(Sender: TObject);
begin
  if FormPID.Flag_PIDisworking then
    begin
    StopIt:=False;
    FormPID.Button9Click(nil);
    lblColorPID.Color := clGreen;
    end
  else
    begin
    StopIt:=True;
    lblColorPID.Color := clRed;
    FormPID.Button8Click(nil);
    end;
end;

//Hold cuando toma las IV
procedure TLinerForm.FinishIVBtnClick(Sender: TObject);
begin
if Abort_Measure=False then Abort_Measure:=True;
if (DoRepeatBtn.Caption='STOP') then
 DoRepeatBtn.Caption:='DODO';
 Application.ProcessMessages;
end;

procedure TLinerForm.ClearChart();
begin
  ChartLineSerie0.Clear();
  ChartLineSerie1.Clear();
end;

procedure TLinerForm.chkAcquireBlockClick(Sender: TObject);
begin
  if chkAcquireBlock.Checked then
    begin
      MeanEdit.MaxValue := 42; // any value higher breaks for 2048pts curves
      if MeanEdit.Value > MeanEdit.MaxValue then
        MeanEdit.Value := MeanEdit.MaxValue;
    end
  else
    MeanEdit.MaxValue := 999999
end;

procedure TLinerForm.chkPainYesNoClick(Sender: TObject);
begin
PaintYesNo:=chkPainYesNo.Checked;
end;

procedure TLinerForm.FormResize(Sender: TObject);
var
  oldWidth :Integer;
begin
  //Change the size of the graph panel as the form is rescaled
  //Preserving the same padding with the nearby panels
  GraphPanel.Height := BottomPanel.Top - GraphPanel.Top -3;
  GraphPanel.Width := RightPanel.Left - GraphPanel.Left -2;
  oldWidth := BottomPanel.Width;
  BottomPanel.Width := GraphPanel.Width;
  scrollSizeBias.Width := scrollSizeBias.Width  + BottomPanel.Width - oldWidth;
end;

// Then problem remains with the new ramp_take_os implementation.
//Every time we change the ADC oversampling on the fly, we get wrong values
// on the first reads
procedure TLinerForm.DoIV_oversample(Sender: TObject);

{Salvo y lo meto en:
  ida                 vuelta
  DataX[0,i]          DataX[1,i]
  DataZ[0,i]          DataZ[1,i]
  DataCurrent[0,i]    DataCurrent[1,i]
  DataOther[0,i]      DataOther[1,i]}

var
j,h,k,Princ,Fin: Integer;
//j: 1..1000; //Los valores que podemos coger en la interfaz estan limitados a este rango
DataCurrentOld: Array [0..1,0..2048] of single;
here_previous_ctrl:  Double;
NumberControl: Integer;
OSRatio: Byte;

begin
// Le decimos a la aplicación que procese los mensajes por si aún queda algún evento del temporizador, que no interfiera con la adquisición de la rampa
Application.ProcessMessages();
NumberControl:=CtrlTimeEdit.Value;

if ReEnablePIDchk.Checked then
   begin
    FormPID.Button9Click(nil);  // desactiva el feedback
    //FormPID.thrdtmr1.Enabled:=False; //apagamos el timer
   end;

here_previous_ctrl:=0;

  // Creamos los vectores DataCurrentOld que usaremos para el accumulate
  for h:=0 to PointNumber -1 do
    begin
      DataCurrentOld[0,h]:=  0.0;
      DataCurrentOld[1,h]:=  0.0;
    end;
  //Bucle del accumulate. Tomamos tantas curvas como ponga en el SpinEdit de accumulate
  //y vamos haciendo la media con las anteriores y actualizando el gráfico
  while (Abort_Measure=False) do
  begin
  for j:=0 to AccumEdit.Value -1 do
  begin

    // Be careful with the following things, because the voltage will be suddenly modified
    if LinerConfig.ReverseCheck.Checked then   // This is when we want to reverse the bias
    begin
      if LinerConfig.chkReduceRamp.Checked then    //This is when we want to make an IV curve with a reduced ramp
        Princ:=Round(-32768/LinerConfig.seReduceRampFactor.Value*Size_xAxis)
      else
    Princ:=Round(-32768*Size_xAxis);
    end
    else
    begin
      if LinerConfig.chkReduceRamp.Checked then    //This is when we want to make an IV curve with a reduced ramp
        Princ:=Round(32768/LinerConfig.seReduceRampFactor.Value*Size_xAxis)
      else
    Princ:=Round(32768*Size_xAxis);
    end;

    Fin:=-Princ;
    // Indicamos por qué iteracion vamos
    progressIVLbl.Caption := format ('%d of', [j+1]);

    OSRatio := OversamplingRatio;
    // Forth (Rampa de ida)
    // Lectura de UNA rampa de ida
    DataForm.ramp_take_os(x_axisDac, Princ, Fin, 0, PointNumber, Jump_xaxis, 0, chkAcquireBlock.Checked,OSRatio);

    // Back (rampa de vuelta)
    //Lectura de UNA rampa de vuelta
    DataForm.ramp_take_os(x_axisDac, Fin, Princ, 1, PointNumber, Jump_xaxis, 0, chkAcquireBlock.Checked,OSRatio);

    {FormPID.Button8Click(nil);
    sleep(20);
    FormPID.Button9Click(nil);
    }

    for h:=0 To PointNumber - 1 do
      begin
      //Calculamos la media de la curva actual (DataCurrent) con las curvas acumuladas hasta ahora (DataCurrentOld)
      DataCurrent[0,h]:=  DataCurrentOld[0,h]*(j/(j +1)) + DataCurrent[0,h]*(1/(j+1));
      DataCurrent[1,h]:=  DataCurrentOld[1,h]*(j/(j+1)) + DataCurrent[1,h]*(1/(j+1));

      DataCurrentOld[0,h]:=  DataCurrent[0,h];
      DataCurrentOld[1,h]:=  DataCurrent[1,h];
      end;

    if (PaintYesNo) then ChangePlotType(nil); //Pintamos

    // Esto es peligroso, pero lo hacemos, a ver si no da problemas ...
    // volvemos a poner Princ al valor máximo antes de hacer funcionar el control otra vez
    if LinerConfig.chkReduceRamp.Checked then
      if LinerConfig.ReverseCheck.Checked then Princ:=Round(-32768*Size_xAxis)
      else Princ:=Round(32768*Size_xAxis);

    DataForm.dac_set(x_axisDAC,Princ, nil);

    // Vamos a dejar funcionar el control durante 2 s
    //j es siempre 0 o positivo. Para que lo comprobamos?
    //De hecho, deberiamos usar un Cardinal
    if (j>=0) then
    begin
    FormPID.thrdtmr1.Enabled:=False;
    FormPID.Button8Click(nil);  // activa el feedback
    // deberiamos activar el feedback solamente si NumberControl>0
        k:=0;
    while (k<NumberControl)  do
      begin
       k:=k+1;
         here_previous_ctrl:=FormPID.Controla(1,here_previous_ctrl, True);   // controla SIN threadtimer
         Sleep(1);
      end;
    FormPID.Button9Click(nil);  // desactiva el feedback
    FormPID.thrdtmr1.Enabled:=True;
    //Application.ProcessMessages;
    end;

    Application.ProcessMessages();
  end;
  if chkSaveAllCurves.checked then saveBLQ(nil); //Guardar automáticamente si está chequeado
  Abort_Measure:=True;
  end;

 if (Abort_Measure=True) then Abort_Measure:=False;

 if ReEnablePIDchk.Checked then
   begin
    FormPID.Button8Click(nil);
    //FormPID.thrdtmr1.Enabled:=True; //encendemos el timer
   end;

 //Application.ProcessMessages();

end;

procedure TLinerForm.OSRatioEditChange(Sender: TObject);
begin

if (OSRatioEdit.Value > OversamplingRatio) and (OversamplingRatio >0) then
begin
OversamplingRatio := OversamplingRatio *2;
end
else if (OSRatioEdit.Value < OversamplingRatio) then
begin
  OversamplingRatio :=  OversamplingRatio div 2;
end
else if (OSRatioEdit.Value > OversamplingRatio) and (OversamplingRatio =0)then
begin
  OversamplingRatio :=  2;
end;

OSRatioEdit.Value := OversamplingRatio;
end;


end.




