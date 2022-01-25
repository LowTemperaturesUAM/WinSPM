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
  StdCtrls, ExtCtrls, xyyGraph, Menus, Spin, blqdataset, {blqloader,} var_gbl,
  Buttons, TeeProcs, TeEngine, Chart, Series;

type
  TDataCurve = Array [0..1,0..2048] of single;

  TForm4 = class(TForm)
//    xyyGraph1: TxyyGraph;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    SpinEdit1: TSpinEdit;
    Button5: TButton;
    Panel1: TPanel;
    SpinEdit2: TSpinEdit;
    Button6: TButton;
    Label1: TLabel;
    RadioGroup1: TRadioGroup;
    Button7: TButton;
    CheckBox2: TCheckBox;
    Mean: TLabel;
    Jump: TLabel;
    Label4: TLabel;
    RadioGroup2: TRadioGroup;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    SpinEdit5: TSpinEdit;
    Button8: TButton;
    SaveDialog1: TSaveDialog;
    Button9: TButton;
    OpenDialog1: TOpenDialog;
    Label12: TLabel;
    Label13: TLabel;
    Edit5: TEdit;
    Label14: TLabel;
    Label15: TLabel;
    Edit6: TEdit;
    Label16: TLabel;
    scrollSizeBias: TScrollBar;
    lblColorPID: TLabel;
    Label11: TLabel;
    Label5: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    ChartLine: TChart;
    ChartLineSerie0: TFastLineSeries;
    ChartLineSerie1: TFastLineSeries;
    chkAcquireBlock: TCheckBox;
    lblAccumulate: TLabel;
    SpinEdit6: TSpinEdit;
    Label2: TLabel;
    chkPainYesNo: TCheckBox;
    procedure Button5Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    PROCEDURE DerivaRectas (vin:vcurva; out vout:vcurva);
    procedure SpinEdit3Change(Sender: TObject);
    procedure SpinEdit4Change(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Edit5Enter(Sender: TObject);
    procedure Edit6Enter(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure scrollSizeBiasChange(Sender: TObject);
    procedure SpinEdit5Change(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure SaveIV(fileName: string; dataSet: Integer; comments: String);
    procedure Button6Click(Sender: TObject);
    procedure ClearChart();
    procedure chkAcquireBlockClick(Sender: TObject);
    procedure chkPainYesNoClick(Sender: TObject);

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
  end;

var
  Form4: TForm4;

  //b : TblqLoader ;
  blqname : string ;
  b_offset: Integer;
  CurvaADerivar: vcurva;
  CurvaDerivada: vcurva;


implementation

uses Config_Liner, Scanner1, DataAdcquisition, PID, Config1, FileNames;

{$R *.DFM}

//Open Config
procedure TForm4.Button5Click(Sender: TObject);
begin
Form7.Show;
end;

//Open Liner
procedure TForm4.FormShow(Sender: TObject);
var
i: Integer;
begin
//xyyGraph1[1].PlotPoints:=False;
Abort_Measure:=False;
if Form7.RadioGroup1.ItemIndex=0 then ReadXfromADC:=True else
ReadXfromADC:=False;
x_axisDac:=Form7.SpinEdit1.Value;
x_axisAdc:=Form7.seADCxaxis.Value;
x_axisMult:=StrtoFloat(Form7.Edit1.Text);
NumCol:=1;
if Form7.Checkbox1.checked then NumCol:=NumCol+1;
if Form7.Checkbox2.checked then NumCol:=NumCol+1;
if Form7.Checkbox3.checked then NumCol:=NumCol+1;
ReadZ:=Form7.Checkbox1.checked;
ReadCurrent:=Form7.Checkbox2.checked;
ReadOther:=Form7.Checkbox3.checked;

PointNumber:=StrtoInt(ComboBox1.Text);  // Número de puntos de cada IV
Form1.RedimCits(Form1.IV_Scan_Lines, PointNumber);

LinerMean:=SpinEdit3.Value;
Jump_xAxis:=SpinEdit4.Value;
Size_xAxis:=scrollSizeBias.Position/100;

Temperature:=StrtoFloat(Edit5.Text);
MagField:=StrtoFloat(Edit6.Text);
ChartLine.LeftAxis.AxisValuesFormat := '0.####E+0';
StopIt:=True;
PaintYesNo:=chkPainYesNo.checked;
end;

//Do
procedure TForm4.Button1Click(Sender: TObject);
{Salvo y lo meto en:
  ida                 vuelta
  DataX[0,i]          DataX[1,i]
  DataZ[0,i]          DataZ[1,i]
  DataCurrent[0,i]    DataCurrent[1,i]
  DataOther[0,i]      DataOther[1,i]}

var
j,h,k,Princ,Fin: Integer;
DataCurrentOld: Array [0..1,0..2048] of single;
adcRead: TVectorDouble;
pidTimer: Boolean;
  here_previous_ctrl:  Double;
NumberControl: Integer;

begin
// Le decimos a la aplicación que procese los mensajes por si aún queda algún evento del temporizador, que no interfiera con la adquisición de la rampa
Application.ProcessMessages();
NumberControl:=SpinEdit6.Value;

if CheckBox2.Checked then
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
  for j:=0 to SpinEdit2.Value -1 do
  begin

    // Be careful with the following things, because the voltage will be suddenly modified
    if Form7.CheckBox4.Checked then   // This is when we want to reverse the bias
    begin
      if Form7.chkReduceRamp.Checked then    //This is when we want to make an IV curve with a reduced ramp
        Princ:=Round(-32768/Form7.seReduceRampFactor.Value*Size_xAxis)
      else
    Princ:=Round(-32768*Size_xAxis);
    end
    else
    begin
      if Form7.chkReduceRamp.Checked then    //This is when we want to make an IV curve with a reduced ramp
        Princ:=Round(32768/Form7.seReduceRampFactor.Value*Size_xAxis)
      else
    Princ:=Round(32768*Size_xAxis);
    end;

    Fin:=-Princ;
    // Indicamos por qué iteracion vamos
    lblAccumulate.Caption := format ('%d of', [j+1]);

    // Forth (Rampa de ida)
    // Lectura de UNA rampa de ida
    Form10.ramp_take(x_axisDac, Princ, Fin, 0, PointNumber, Jump_xaxis, 0, chkAcquireBlock.Checked);

    // Back (rampa de vuelta)
    //Lectura de UNA rampa de vuelta
    Form10.ramp_take(x_axisDac, Fin, Princ, 1, PointNumber, Jump_xaxis, 0, chkAcquireBlock.Checked);

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

    if (PaintYesNo) then RadioGroup2Click(nil); //Pintamos

    // Esto es peligroso, pero lo hacemos, a ver si no da problemas ...
    // volvemos a poner Princ al valor máximo antes de hacer funcionar el control otra vez
    if Form7.chkReduceRamp.Checked then
      if Form7.CheckBox4.Checked then Princ:=Round(-32768*Size_xAxis)
      else Princ:=Round(32768*Size_xAxis);

    Form10.dac_set(x_axisDAC,Princ, nil);

    // Vamos a dejar funcionar el control durante 2 s
    if (j>=0) then
    begin
    FormPID.thrdtmr1.Enabled:=False;
    FormPID.Button8Click(nil);  // activa el feedback
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
  if checkBox1.checked then Button4Click(nil); //Guardar automáticamente si está chequeado
  Abort_Measure:=True;
  end;

 if (Abort_Measure=True) then Abort_Measure:=False;

 if CheckBox2.Checked then
   begin
    FormPID.Button8Click(nil);
    //FormPID.thrdtmr1.Enabled:=True; //encendemos el timer
   end;

 //Application.ProcessMessages();

end;

//Abort
procedure TForm4.Button3Click(Sender: TObject);
begin
if Abort_Measure=False then Abort_Measure:=True;
if (Button2.Caption='STOP') then
 Button2.Caption:='DODO';
 Application.ProcessMessages;
end;

//Número de puntos
procedure TForm4.ComboBox1Change(Sender: TObject);
begin
PointNumber:=StrtoInt(Combobox1.Text);
Form1.RedimCits(Form1.IV_Scan_Lines, Form4.PointNumber);
end;

//Función para derivar
procedure TForm4.DerivaRectas (vin:vcurva;out vout:vcurva);
//Los parámetros de la función son vin (input) y vout (output).
//Son variables tipo "vcurva". "vcurva" es una estructura donde .x son los datos de la ida, .y los datos de la vuelta, y .n otra cosa no importante para esto.
//Para derivar, los datos "Y" están guardados en la vcurva, y los datos "X" están guardados en DataX
var       i,o,np,m,tot0,pderi                 : integer;
          sx,sy,sx2,sxy,b,bb,cc,nps,sx_2,sy_2,sx2_2,sxy_2,b_2,bb_2,cc_2           : double;{single;}
begin
 m:=StrToInt(ComboBox1.text); //Número de puntos

    //Valores iniciales
    FOR i:=0 TO  m-1 do begin
        vout.x[i] :=0;
        vout.y[i]:= 0;
    end;
    vout.n := m;

pderi:=Form4.SpinEdit5.Value;//Puntos de derivada
pderi:= pderi - 1;

if pderi=0 then begin //Si un punto de derivada
     FOR I:=0 TO m-1 do begin

        DataX[0,i]:=0.5*(DataX[0,i]+DataX[0,i+1]);
        DataX[1,i]:=0.5*(DataX[1,i]+DataX[1,i+1]);

        if (DataX[0,i]-DataX[0,i+1])<>0 then vout.x[i]:=(vin.x[i]-vin.x[i+1])/(DataX[0,i]-DataX[0,i+1]);


        if (DataX[1,i]-DataX[1,i+1])<>0 then vout.y[i]:=(vin.y[i]-vin.y[i+1])/(DataX[1,i]-DataX[1,i+1]);


        DataX[0,m]:=DataX[0,m-1];
        DataX[1,m]:=DataX[1,m-1];
        vout.y[m]:=vout.y[m-1];
        vout.x[m]:=vout.x[m-1];
          end;

    end


 else begin   //Si más de un punto de derivada
     FOR I:=0 TO m-1 do begin
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
procedure TForm4.SpinEdit3Change(Sender: TObject);
begin
  TryStrToInt(SpinEdit3.Text, LinerMean);
end;

//Cambio en Jump
procedure TForm4.SpinEdit4Change(Sender: TObject);
begin
  TryStrToInt(SpinEdit4.Text, Jump_xAxis);
end;

//Pintar las curvas
procedure TForm4.RadioGroup2Click(Sender: TObject);
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
if RadioGroup1.ItemIndex=0 then      //if "Direct" (sin derivar)
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

  if RadioGroup2.ItemIndex=0 then
  begin
  for i:=0 to PointNumber-1 do
    begin
    DatatoPlot_Y[0,i]:=DataPlot[0,i];
    DatatoPlot_Y[1,i]:=DataPlot[1,i];
    end;
  end
  else
  if RadioGroup2.ItemIndex=1 then
  begin
  for i:=0 to PointNumber-1 do
    begin
    DatatoPlot_Y[0,i]:=DataZ[0,i];
    DatatoPlot_Y[1,i]:=DataZ[1,i];
    end;
  end
  else
  if RadioGroup2.ItemIndex=2 then
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
procedure TForm4.Button2Click(Sender: TObject);
begin
Application.ProcessMessages;
if (Button2.Caption='STOP') then
 begin
 Button2.Caption:='DODO';
 exit;
 end
 else
 begin
 while (Abort_Measure=False) do
  begin
  Button2.Caption:='STOP';
  Button1Click(nil);
  if (Button2.Caption='DODO') then exit;
  end;
 Abort_Measure:=False;
 end;
end;

//Delete Graph
procedure TForm4.Button8Click(Sender: TObject);
begin
  ClearChart();
//xyyGraph1.Clear;
//xyyGraph1.Update;
end;

//Guardar
procedure TForm4.Button4Click(Sender: TObject);
var
i,j,k,cols,BlockOffset: Integer;
Fi_Name,BlockFileName,BlockFile,TakeComment:string;
number: Double;

begin
BlockFileName:=SaveDialog1.Filename+InttoStr(SpinEdit1.Value)+'.blq';
TakeComment:=DateTimeToStr(Now)+#13+#10+
    'T(K)='+FloattoStr(Temperature)+#13+#10+
    'B(T)='+FloattoStr(MagField)+#13+#10+
    'X(nm)='+FloattoStrF(Form1.XOffset*10*Form1.AmpX*Form1.CalX, ffGeneral, 5, 4)+#13+#10+
    'Y(nm)='+FloattoStrF(Form1.YOffset*10*Form1.AmpY*Form1.CalY, ffGeneral, 5, 4)+#13+#10;
  for k:=0 to 1 do
  begin
  BlockOffset:=k;
  number:=SpinEdit1.Value+Presentblknumber/10000+BlockOffset/10000;
  BlockFile:=Edit1.Text+FloattoStrF(number,ffFixed,5,4);
  DS:=TblqDataSet.Create(NumCol,PointNumber) ;
  DS._Name:=BlockFile; // Aquí se pone el fichero con .xxxx al final
  DS._BlockFile:=BlockFileName ; // Es el fichero de verdad, como en dd
  DS._BlockOffset:=Presentblknumber+BlockOffset ;
  DS._Moment:=Now;
  DS._Time:=Now ;

 for i:=0 to NumCol-1 do
  begin
  BlockFile:=SaveDialog1.Filename+InttoStr(SpinEdit1.Value);
  if (k=0) then DS._Comment:=TakeComment+'Forth';
  if (k=1) then DS._Comment:=TakeComment+'Back';
  // COL HEADER
  DS[i]._DataFormat:=4 ;      // This is single
  DS[i]._AxisType:=300 ;       // Units Current
  DS[i]._Prom:=1 ;
  DS[i]._Offset:=0 ;
  DS[i]._Factor:=1.0 ;  // No prefactor
  DS[i]._Start:=0 ;
  DS[i]._Size:=1 ;
  DS[i]._CTime:=0 ;
  for j:=0 to 3 do DS[j]._ParamA[j]:=0 ;
    for j:=0 to 7 do DS[j]._ParamB[j]:=0 ;
 end;

 for i:=0 to PointNumber-1 do DS[0].Value[i]:=DataX[k,i];

 cols:=0;
 if ReadZ then
     begin
     cols:=cols+1;
    for i:=0 to PointNumber-1 do DS[cols].Value[i]:=DataZ[k,i];
     end;
 if ReadCurrent then
     begin
     cols:=cols+1;
     for i:=0 to PointNumber-1 do DS[cols].Value[i]:=DataCurrent[k,i];
     end;
 if ReadOther then
     begin
     cols:=cols+1;
     for i:=0 to PointNumber-1 do DS[cols].Value[i]:=DataOther[k,i];
     end;

WriteDataSetInBlock(BlockFileName,DS,False);
DS.Free;
end;
Presentblknumber:=Presentblknumber+2;
Label12.Caption:=InttoStr(Presentblknumber);

if ReadZ then
  SaveIV(SaveDialog1.Filename+InttoStr(SpinEdit1.Value)+'.zv.cur', 0, TakeComment);

if ReadCurrent then
  SaveIV(SaveDialog1.Filename+InttoStr(SpinEdit1.Value)+'.iv.cur', 1, TakeComment);

if ReadOther then
  SaveIV(SaveDialog1.Filename+InttoStr(SpinEdit1.Value)+'.other.cur', 2, TakeComment);

end;

// Guarda las curvas IV en el formato de WSxM
// Nacho Horcas, diciembre de 2017
procedure TForm4.SaveIV(fileName: string; dataSet: Integer; comments: String);
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
  WriteLn(myFile, '    Saved with version: MyScanner 1.302');
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
procedure TForm4.Button9Click(Sender: TObject);
begin
SaveDialog1.FileName:=Edit1.Text;

if SaveDialog1.Execute then
  begin
  SaveDialog1.FileName:=SaveDialog1.FileName;
  Presentblknumber:=0;
  Label12.Caption:=InttoStr(Presentblknumber);
  Form9.Label6.Caption:=ExtractFileDir(SaveDialog1.FileName);
  end;

Edit1.Text:=ExtractFileName(SaveDialog1.FileName);
end;

//En principio no hace nada, button10 no existe
procedure TForm4.Button10Click(Sender: TObject);
var
BlockFile:string;
b_offset: Integer;

begin
BlockFile:=SaveDialog1.Filename+InttoStr(SpinEdit1.Value)+'.blq';

LoadDataSetFromBlock(BlockFile,0,DS);

Label11.Caption:=InttoStr(DS.NRows);

Application.ProcessMessages;
end;

//Temperatura
procedure TForm4.Edit5Enter(Sender: TObject);
begin
if (Edit5.text='')then exit;
Temperature:=StrtoFloat(Edit5.Text);
MagField:=StrtoFloat(Edit6.Text);
end;
//Campo magnético
procedure TForm4.Edit6Enter(Sender: TObject);
begin
if (Edit6.text='')then exit;
Temperature:=StrtoFloat(Edit5.Text);
MagField:=StrtoFloat(Edit6.Text);
end;

//blq Number para guardar
procedure TForm4.SpinEdit1Change(Sender: TObject);
begin
  Presentblknumber:=0;
  Label12.Caption:=InttoStr(Presentblknumber);
end;

//Pintar cada vez que pulsamos "Direct" o "Derivative"
procedure TForm4.RadioGroup1Click(Sender: TObject);
begin
RadioGroup2Click(nil);
end;

//Cambiar bias
procedure TForm4.scrollSizeBiasChange(Sender: TObject);
begin
Size_xAxis:=scrollSizeBias.Position/100;
if Form7.CheckBox4.Checked then
Form10.dac_set(Form7.SpinEdit1.Value, Round(-32767*Size_xAxis), nil)
else
Form10.dac_set(Form7.SpinEdit1.Value, Round(32767*Size_xAxis), nil);

Label18.Caption:=IntToStr(scrollSizeBias.Position);
end;

//Pintar cuando cambias los puntos de derivada
procedure TForm4.SpinEdit5Change(Sender: TObject);
begin
if RadioGroup1.ItemIndex=0 then
  begin
  RadioGroup1.ItemIndex:=1;
  RadioGroup2Click(nil);
  end
  else
  RadioGroup2Click(nil);
end;

//Hold PID
procedure TForm4.Button7Click(Sender: TObject);
begin
  if StopIt then
    begin
    StopIt:=False;
    //Button7.Font.Color :=  clGreen;
    FormPID.Button9Click(nil);
    lblColorPID.Color := clGreen;
    end
  else
    begin
    StopIt:=True;
    //Button7.Font.Color :=  clRed;
    lblColorPID.Color := clRed;
    FormPID.Button8Click(nil);
    end;
end;

//Hold cuando toma las IV
procedure TForm4.Button6Click(Sender: TObject);
begin
if Abort_Measure=False then Abort_Measure:=True;
if (Button2.Caption='STOP') then
 Button2.Caption:='DODO';
 Application.ProcessMessages;
end;

procedure TForm4.ClearChart();
begin
  ChartLineSerie0.Clear();
  ChartLineSerie1.Clear();
end;

procedure TForm4.chkAcquireBlockClick(Sender: TObject);
begin
  if chkAcquireBlock.Checked then
    begin
      SpinEdit3.MaxValue := 42;
      if SpinEdit3.Value > SpinEdit3.MaxValue then
        SpinEdit3.Value := SpinEdit3.MaxValue;
    end
  else
    SpinEdit3.MaxValue := 999999
end;

procedure TForm4.chkPainYesNoClick(Sender: TObject);
begin
PaintYesNo:=chkPainYesNo.Checked;
end;

end.




