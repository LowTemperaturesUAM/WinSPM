unit AuxGraph;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ColorGrd, StdCtrls, Spin, ComCtrls, Tabnotbk, ExtCtrls, xyyGraph,Clipbrd,
  blqLoader,blqDataSet,var_gbl, dspIIRFilters, dspFFT;

type
  TAuxGraph1 = class(TForm)
    TabbedNotebook1: TTabbedNotebook;
    Label1: TLabel;
    ActiveCurveNr: TSpinEdit;
    Label2: TLabel;
    xAxisTitle: TEdit;
    yAxisTitle: TEdit;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    DeleteCurve: TButton;
    PaintCurve: TButton;
    ColorDialog1: TColorDialog;
    ChColor: TButton;
    LoadData: TButton;
    Savedata: TButton;
    CopyClip: TButton;
    CopyfClip: TButton;
    DeleteAll: TButton;
    Button1: TButton;
    OpenDialog2: TOpenDialog;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Button2: TButton;
    Button3: TButton;
    SpinEdit1: TSpinEdit;
    CheckDeriva: TCheckBox;
    Label7: TLabel;
    Button4: TButton;
    GotoPlotNr: TEdit;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Edit2: TEdit;
    CheckBox4: TCheckBox;
    Button5: TButton;
    RadioGroup1: TRadioGroup;
    ScrollBar1: TScrollBar;
    ScrollBar2: TScrollBar;
    Label9: TLabel;
    Label10: TLabel;
    Button11: TButton;
    RadioGroup2: TRadioGroup;
    SpinEdit2: TSpinEdit;
    Button12: TButton;
    Button7: TButton;
    RadioGroup3: TRadioGroup;
    Button8: TButton;
    Panel1: TPanel;
    FilterGraph: TxyyGraph;
    GenGraph: TxyyGraph;
    Splitter1: TSplitter;
    Label11: TLabel;
    procedure ColorGrid1Change(Sender: TObject);
    procedure DeleteCurveClick(Sender: TObject);
    procedure PaintCurveClick(Sender: TObject);
    procedure ChColorClick(Sender: TObject);
    procedure ActiveCurveNrChange(Sender: TObject);
    procedure CopyClipClick(Sender: TObject);
    procedure SavedataClick(Sender: TObject);
    procedure LoadDataClick(Sender: TObject);
    procedure CopyfClipClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DeleteAllClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure ScrollBar2Change(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
    procedure SpinEdit2Change(Sender: TObject);
    procedure Button12Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure LowPassFilter(Sender: TObject; k: Integer);
    procedure BandStopFilter(Sender: TObject);
  end;

var
  AuxGraph1: TAuxGraph1;
   b : TblqLoader ;
   DS : TblqDataSet ;
  blqname : string ;
  b_offset: Integer;
  MaxGraph : Integer;
  Datos1,Datos2,CurvaADerivar: vcurva;
  CurvaDerivada: vcurva;
  Ida,FilterFixed: Boolean;

implementation

uses Info, MiLee;



{$R *.DFM}

procedure TAuxGraph1.ColorGrid1Change(Sender: TObject);
begin
//GenGraph[ActiveCurveNr.Value].Color:=ColorGrid1.Selection;
end;

procedure TAuxGraph1.DeleteCurveClick(Sender: TObject);
begin
GenGraph[ActiveCurveNr.Value].Clear;
if MaxGraph  >	1 then  MaxGraph:=MaxGraph-1;
GenGraph.Update;
end;

procedure TAuxGraph1.PaintCurveClick(Sender: TObject);
var
i: Integer;

begin
for i:=1 to 100
do
begin
GenGraph[ActiveCurveNr.Value].AddPoint(i,i);
end;

end;

procedure TAuxGraph1.ChColorClick(Sender: TObject);
begin
if ColorDialog1.Execute then
GenGraph[ActiveCurveNr.Value].Color:=ColorDialog1.Color;
ActiveCurveNr.Color:=GenGraph[ActiveCurveNr.Value].Color;
end;

procedure TAuxGraph1.ActiveCurveNrChange(Sender: TObject);
begin
ActiveCurveNr.Color:=GenGraph[ActiveCurveNr.Value].Color;
if ActiveCurveNr.Value>MaxGraph
 then
  begin
//  GenGraph[ActiveCurveNr.Value].Color :=
//  GenGraph[ActiveCurveNr.Value-1].Color+256;
  MaxGraph:=MaxGraph+1;
  Label7.Caption:=InttoStr(MaxGraph);
  end;
end;

procedure TAuxGraph1.CopyClipClick(Sender: TObject);
var
AllCurve: String;
j,i: Integer;

begin
AllCurve:='';
for i:=0 to (GenGraph[ActiveCurveNr.Value].Size-1) do
begin
AllCurve:=AllCurve+
FloattoStr(GenGraph[ActiveCurveNr.Value].x[i])+#9+
FloattoStr(GenGraph[ActiveCurveNr.Value].y[i])+#9;
AllCurve:=AllCurve+#13+#10;
end;
Application.ProcessMessages;
Clipboard.AsText:=AllCurve;
end;

procedure TAuxGraph1.SavedataClick(Sender: TObject);
var

F: TextFile;
s: string;
i: Integer;
begin

if SaveDialog1.Execute then
begin
 AssignFile(F, SaveDialog1.FileName);
 Rewrite(F);
 for i:=0 to (GenGraph[ActiveCurveNr.Value].Size-1) do
 begin
   s:=FloattoStr(GenGraph[ActiveCurveNr.Value].x[i])+#9+
   FloattoStr(GenGraph[ActiveCurveNr.Value].y[i]);
   Writeln(F,s);
 end;
 CloseFile(F);
end;
end;

procedure TAuxGraph1.LoadDataClick(Sender: TObject);
var
F: TextFile;
s,s1,s2: string;
i: Integer;
x,y: Extended;

begin
if OpenDialog1.Execute then
begin
 AssignFile(F, OpenDialog1.FileName);
 Reset(F);
 while not SeekEof(F) do
 begin
   s1:='';
   s2:='';
   Readln(F,s);
   if RadioGroup3.ItemIndex=0 then
   begin
   if (Pos(#9,s)>0) then
   begin
   for i:=1 to (Pos(#9,s)-1) do s1:=s1+s[i];
   for i:=Pos(#9,s)+1 to Length(s) do s2:=s2+s[i];
   x:=StrtoFloat(s1);
   y:=StrtoFloat(s2);
   GenGraph[ActiveCurveNr.Value].Addpoint(x,y);
   end;
   end
   else
   begin
   if (Pos(' ',s)>0) then
   begin
   for i:=1 to (Pos(' ',s)-1) do s1:=s1+s[i];
   for i:=Pos(' ',s)+1 to Length(s) do s2:=s2+s[i];
   x:=StrtoFloat(s1);
   y:=StrtoFloat(s2);
   GenGraph[ActiveCurveNr.Value].Addpoint(x,y);
   end;
   end;
 end;
 CloseFile(F);
GenGraph.Update;
end;

end;

procedure TAuxGraph1.CopyfClipClick(Sender: TObject);
var
s,s1,s2,s3: string;
i,iline,iend: Integer;
x,y: Extended;

begin
s:=Clipboard.AsText;
iend:=1;
iline:=1;
while iend<Length(s) do
 begin
   s1:='';
   s2:='';
   s3:='';
   if (iline>1) then
        for i:=iend to iend+iline do s3:=s3+s[i]
   else
        begin
        for i:=1 to Pos(#13,s) do iline:=iline+1;
        for i:=iend to iend+iline do s3:=s3+s[i];
        end;
   if (Pos(#9,s3)>0) then
   begin
   for i:=1 to (Pos(#9,s3)-1) do s1:=s1+s3[i];
   for i:=Pos(#9,s3)+1 to (Pos(#13,s3)-1) do s2:=s2+s3[i];
   end;
   iend:=iend+i+1;
   if(s1<>'') and (s2<>'') then
   begin
   x:=StrtoFloat(s1);
   y:=StrtoFloat(s2);
   GenGraph[ActiveCurveNr.Value].Addpoint(x,y);
   end;
 end;
GenGraph.Update;
end;

procedure TAuxGraph1.FormShow(Sender: TObject);
var
i: Integer;

begin
for i:=1 to 100 do GenGraph[i].Color:=10000*i;
MaxGraph:=1;
ida:=True;
FilterFixed:=False;
//FilterGraph.Hide;
end;

procedure TAuxGraph1.DeleteAllClick(Sender: TObject);
var
i: Integer;

begin
for i:=1 to MaxGraph
do GenGraph[i].Clear;
GenGraph.Clear;
FilterGraph.Clear;
MaxGraph:=1;
Label7.Caption:= InttoStr(MaxGraph);
ActiveCurveNr.Value:=1;
ActiveCurveNrChange(nil);
GenGraph.Update;
end;

procedure TAuxGraph1.Button1Click(Sender: TObject);
var
   F: TFileStream;
   Ext,MiFile : string;

begin

if OpenDialog2.Execute then
begin

  // ABRIR FICHERO
  F:=TFileStream.Create(OpenDialog2.Filename,fmOpenRead) ;
  Ext:=UpperCase(ExtractFileExt(OpenDialog2.Filename)) ;
  F.Seek(0,soFromBeginning) ;
  Label4.Caption:=ExtractFileName(OpenDialog2.Filename);

if Ext = '.BLQ' then
begin
  F.Destroy;
  blqname:=OpenDialog2.Filename;

  InfoForm.Mensaje.Caption:='Loading BLQ...' ;
  InfoForm.Show ;
  InfoForm.Refresh ;
  b.SelectBlockFile(blqname) ;
  InfoForm.Close ;

end;

end;

end;

procedure TAuxGraph1.Button2Click(Sender: TObject);
var
j,i: Integer;

begin
AuxGraph1.DeleteAllClick(nil);
if ((StrtoInt(Label6.Caption)+SpinEdit1.Value)<b.Count) then
begin
for j:=1 to SpinEdit1.Value do
 begin
  Label6.Caption:=InttoStr(StrtoInt(Label6.Caption)+1);
  b_offset:=b.GetEntryOffset(StrtoInt(Label6.Caption)+1) ;
  LoadDataSetFromBlock(blqname,b_offset,DS) ;
  ActiveCurveNr.Value:=ActiveCurveNr.Value+1;
  ActiveCurveNrChange(nil);
  if CheckDeriva.checked then
  begin
  CurvaADerivar.n:=DS.Nrows;
  for i:=0 to DS.nrows-1 do
  begin
  CurvaADerivar.x[i]:=DS[0].Value[i];
  CurvaADerivar.y[i]:=DS[1].Value[i];
  end;
  ValProm.DerivaRectas(CurvaAderivar,CurvaDerivada);
  for i:=0 to DS.nrows-1 do
    begin
    GenGraph[ActiveCurveNr.Value].AddPoint(CurvaDerivada.x[i],
    CurvaDerivada.y[i]);
    end;
  end
  else
  begin
  for i:=0 to DS.nrows-1 do
    begin
    GenGraph[ActiveCurveNr.Value].AddPoint(DS[0].Value[i],
    DS[1].Value[i]);
    end;
  end;
 end;
GenGraph.Update;
end;
end;

procedure TAuxGraph1.FormCreate(Sender: TObject);
begin
  b:=TblqLoader.Create(Self) ;
end;

procedure TAuxGraph1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  b.Free;
end;

procedure TAuxGraph1.Button3Click(Sender: TObject);
var
j,i: Integer;

begin
AuxGraph1.DeleteAllClick(nil);
if (StrtoInt(Label6.Caption)>SpinEdit1.Value) then
begin
for j:=1 to SpinEdit1.Value do
 begin
  Label6.Caption:=InttoStr(StrtoInt(Label6.Caption)-1);
  b_offset:=b.GetEntryOffset(StrtoInt(Label6.Caption)-1) ;
  LoadDataSetFromBlock(blqname,b_offset,DS) ;
  ActiveCurveNr.Value:=ActiveCurveNr.Value+1;
  ActiveCurveNrChange(nil);
  if CheckDeriva.checked then
  begin
  CurvaADerivar.n:=DS.Nrows;
  for i:=1 to DS.nrows do
  begin
  CurvaADerivar.x[i]:=DS[0].Value[i];
  CurvaADerivar.y[i]:=DS[1].Value[i];
  end;
  ValProm.DerivaRectas(CurvaAderivar,CurvaDerivada);
  for i:=1 to DS.nrows-1 do
    begin
    GenGraph[ActiveCurveNr.Value].AddPoint(CurvaDerivada.x[i],
    CurvaDerivada.y[i]);
    end;
  end
  else
  begin
  for i:=0 to DS.nrows-1 do
    begin
    GenGraph[ActiveCurveNr.Value].AddPoint(DS[0].Value[i],
    DS[1].Value[i]);
    end;
  end;
 end;
GenGraph.Update;
end;
end;

procedure TAuxGraph1.Button4Click(Sender: TObject);
var
j,i,cont: Integer;
PromBeginval,PromEndval,offsetval,DiffIyV: Double;
Prom: Double;


begin

if (StrtoInt(GotoPlotNr.Text)<b.Count) then
begin
  b_offset:=b.GetEntryOffset(StrtoInt(GotoPlotNr.Text)) ;
  LoadDataSetFromBlock(blqname,b_offset,DS) ;
  Label6.Caption:=InttoStr(StrtoInt(GotoPlotNr.Text));
  ActiveCurveNr.Value:=ActiveCurveNr.Value+1;
  ActiveCurveNrChange(nil);
    // Corrigo offset
  {*offsetval:=Abs(Trunc(StrtoFloat(ValProm.Offset.Text)/
   abs(DS[0].Value[1]-DS[0].Value[Ds.NRows-1])/1e3*Ds.Nrows));
  Datos1.n:=DS.Nrows-offsetval;
  Datos2.n:=DS.Nrows-offsetval;
  *}
  offsetval:=StrtoFloat(ValProm.Offset.Text);
  DiffIyV:=StrtoFloat(ValProm.Edit2.Text);
  Datos1.n:=DS.Nrows;
  Datos2.n:=DS.Nrows;

  for i:=1 to Datos1.n do
  begin
  Datos1.x[i]:=DS[0].Value[i]*1e3-offsetval-DiffIyV;
  Datos1.y[i]:=DS[1].Value[i];
  end;
  if CheckBox3.Checked then
  begin
  b_offset:=b.GetEntryOffset(StrtoInt(GotoPlotNr.Text)+1) ;
  LoadDataSetFromBlock(blqname,b_offset,DS) ;
  for i:=1 to Datos2.n do
  begin
  Datos2.x[i]:=(DS[0].Value[Datos2.n-i]*1e3-offsetval+Datos1.x[i])/2;
  Datos2.y[i]:=(DS[1].Value[Datos2.n-i]+Datos1.y[i])/2;
  end;
  end
  else
  begin
  for i:=1 to Datos2.n do
  begin
  Datos2.x[i]:=Datos1.x[i];
  Datos2.y[i]:=Datos1.y[i];
  end;
  end;

  if CheckDeriva.checked then
  begin
  CurvaADerivar.n:=Datos2.n;
  for i:=1 to DS.nrows-1 do
  begin
  CurvaADerivar.x[i]:=Datos2.x[i];
  CurvaADerivar.y[i]:=Datos2.y[i];
  end;
  ValProm.DerivaRectas(CurvaAderivar,CurvaDerivada);
  // Normalizo al promedio alrededor de la esquina
  // PROMEDIO ALREDEDOR DE LA ESQUINA
  cont:=0;    // contador de promedios
  Prom:=0;
  PromBeginval:= StrtoFloat(ValProm.PromBegin.Text);
  PromEndval:= StrtoFloat(ValProm.PromEnd.Text);
  for i:=1 to Datos2.n do
  begin
   if (Abs(CurvaDerivada.x[i])>PromBeginval)
    and (Abs(CurvaDerivada.x[i])<PromEndval) then
   begin
    Prom:=Prom+CurvaDerivada.y[i];
    cont:=cont+1;
    end;
  end;  // for i
  if cont>0 then for i:=1 to Datos2.n do
                              CurvaDerivada.y[i]:=CurvaDerivada.y[i]/Prom*cont;
  for i:=1 to Datos2.n-1 do
   begin
   if Checkbox4.checked then
   GenGraph[ActiveCurveNr.Value].AddPoint(CurvaDerivada.x[i],(CurvaDerivada.y[i]
   +StrtoFloat(Edit2.Text)*ActiveCurveNr.Value))
   else
   GenGraph[ActiveCurveNr.Value].AddPoint(CurvaDerivada.x[i],CurvaDerivada.y[i]);
  end;
  end
  else
  begin
  for i:=0 to Datos2.n do
   GenGraph[ActiveCurveNr.Value].AddPoint(DS[0].Value[i],DS[1].Value[i]);
  end;
end;
if Checkbox2.Checked then
begin
if ida then
begin
ida:=False;
GotoPlotNr.Text:=InttoStr(StrtoInt(GotoPlotNr.Text)+1);
Button4Click(nil);
end
else ida:=True;
end;
GenGraph.Update;
end;

procedure TAuxGraph1.Button5Click(Sender: TObject);
var
F: TextFile;
s: string;
i,j: Integer;
begin

if SaveDialog1.Execute then
begin
 AssignFile(F, SaveDialog1.FileName);
 Rewrite(F);
 for i:=0 to (GenGraph[ActiveCurveNr.Value].Size-1) do
 begin
   s:='';
   for j:=1 to ActiveCurveNr.Value do
   s:=s+FloattoStr(GenGraph[j].x[i])+#9+
   FloattoStr(GenGraph[j].y[i])+#9;
   Writeln(F,s);
 end;
 CloseFile(F);
end;
end;

procedure TAuxGraph1.ScrollBar1Change(Sender: TObject);
var
i: Integer;

begin
dspIIRFilter1.Frequency1:=ScrollBar1.Position;
Label9.Caption:=InttoStr(ScrollBar1.Position);
end;

procedure TAuxGraph1.Button6Click(Sender: TObject);
begin
if GenGraph.Showing then begin GenGraph.Hide;FilterGraph.Show; end
else
begin FilterGraph.Hide;GenGraph.Show; end;
end;

procedure TAuxGraph1.Button7Click(Sender: TObject);
var
i,j,k:Integer;
MyBuffx,MyBuffy : Array[0..10000] of Extended;
begin
for k:=2 to ActiveCurveNr.Value do
begin
FilterGraph.Clear;
if GenGraph[ActiveCurveNr.Value].Size>10 then
begin
if FilterFixed=True then LowPassFilter(nil,k);
for i:=0 to GenGraph[k].Size do
begin
MyBuffx[i]:=GenGraph[k].x[i];
if FilterFixed=False then MyBuffy[i]:=dspIIRFilter1.Filter(GenGraph[k].y[i])
else MyBuffy[i]:=FilterGraph[1].y[i];
end;
GenGraph[k].Clear;
for j:=0 to i-2 do
begin
if Checkbox4.checked then
GenGraph[k].AddPoint(MyBuffx[j],MyBuffy[j]+StrtoFloat(Edit2.Text)*k)
else
GenGraph[k].AddPoint(MyBuffx[j],MyBuffy[j]);
end;
if Checkbox4.checked then
GenGraph[k].AddPoint(MyBuffx[i-2],MyBuffy[i-2]+StrtoFloat(Edit2.Text)*k)
else
GenGraph[k].AddPoint(MyBuffx[i-2],MyBuffy[i-2])
end;
end;
FilterGraph.Update;
GenGraph.Update;
end;

procedure TAuxGraph1.Button8Click(Sender: TObject);
var
i,j,Size:Integer;
MiX,MiY: Array[0..10000] of double;

begin
for j:=1 to ActiveCurveNr.Value do
begin
  Size:=GenGraph[j].Size;
  Label11.Caption:=InttoStr(Size);
  for i:=0 to Size do
   begin
   MiX[i]:=GenGraph[j].x[i];
   MiY[i]:=GenGraph[j].y[i]+StrtoFloat(Edit2.Text)*j;
   end;
  GenGraph[j].Clear;
  for i:=0 to Size-1 do
   begin
   GenGraph[j].AddPoint(MiX[i],MiY[i]);
   end;
end;
GenGraph.Update;
end;

procedure TAuxGraph1.Button9Click(Sender: TObject);
var
i:Integer;

begin
FilterGraph[1].Clear;
dspIIRFilter1.Response:=ftBandStop;
for i:=1 to GenGraph[ActiveCurveNr.Value].Size-1 do
FilterGraph[1].AddPoint(i,
dspIIRFilter1.Filter(GenGraph[ActiveCurveNr.Value].y[i]));
FilterGraph.Update;
end;


procedure TAuxGraph1.Button10Click(Sender: TObject);
var
i:Integer;

begin
FilterGraph[1].Clear;
dspIIRFilter1.Response:=ftBandPass;
for i:=1 to GenGraph[ActiveCurveNr.Value].Size-1 do
FilterGraph[1].AddPoint(i,
dspIIRFilter1.Filter(GenGraph[ActiveCurveNr.Value].y[i]));
FilterGraph.Update;
end;

procedure TAuxGraph1.ScrollBar2Change(Sender: TObject);
var
i: Integer;

begin
dspIIRFilter1.Frequency2:=ScrollBar2.Position;
Label10.Caption:=InttoStr(ScrollBar2.Position);
end;

procedure TAuxGraph1.Button11Click(Sender: TObject);
var
i:Integer;

begin
FilterGraph[1].Clear;
dspFFT1.Clear;
Label11.Caption:=InttoStr(GenGraph[ActiveCurveNr.Value].Size);
dspFFT1.BufferSize:=(GenGraph[ActiveCurveNr.Value].Size+1)*2;
for i:=1 to GenGraph[ActiveCurveNr.Value].Size-1 do
begin
dspFFT1.RealIn[i]:=GenGraph[ActiveCurveNr.Value].y[i];
dspFFT1.ImagIn[i]:=0;
end;
dspFFT1.FFT;
for i:=1 to dspFFT1.BufferSize do
FilterGraph[1].AddPoint(i,dspFFT1.RealOut[i]);
FilterGraph.Update;
end;

procedure TAuxGraph1.RadioGroup1Click(Sender: TObject);
begin
if RadioGroup1.ItemIndex=0 then dspIIRFilter1.Response:=ftLowPass;
if RadioGroup1.ItemIndex=1 then dspIIRFilter1.Response:=ftHighPass;
if RadioGroup1.ItemIndex=2 then dspIIRFilter1.Response:=ftBandStop;
if RadioGroup1.ItemIndex=3 then dspIIRFilter1.Response:=ftBandPass;
end;

procedure TAuxGraph1.RadioGroup2Click(Sender: TObject);
begin
if RadioGroup2.ItemIndex=0 then dspIIRFilter1.Kind:=fkBessel
else if RadioGroup2.ItemIndex=1 then dspIIRFilter1.Kind:=fkButterworth
else if RadioGroup2.ItemIndex=2 then dspIIRFilter1.Kind:=fkChebyshev;
FilterFixed:=False;
if RadioGroup2.ItemIndex=3 then FilterFixed:=True;
end;

procedure TAuxGraph1.SpinEdit2Change(Sender: TObject);
begin
dspIIRFilter1.Order:=SpinEdit2.Value;
end;

procedure TAuxGraph1.Button12Click(Sender: TObject);
var
i:Integer;

begin
Radiogroup2Click(nil);
if FilterFixed=False then
for i:=0 to GenGraph[ActiveCurveNr.Value].Size do
FilterGraph[1].AddPoint(i,
dspIIRFilter1.Filter(GenGraph[ActiveCurveNr.Value].y[i]))
else LowPassFilter(nil,ActiveCurveNr.Value);
FilterGraph.Update;
end;

procedure TAuxGraph1.LowPassFilter(Sender: TObject; k: Integer);
var
i: Integer;
FourierSize: Integer;

begin
FilterGraph.Clear;
dspFFT1.Clear;
Label11.Caption:=InttoStr(GenGraph[k].Size);
Application.ProcessMessages;
FourierSize:=GenGraph[k].Size;
if FourierSize<100 then exit;
dspFFT1.BufferSize:=(GenGraph[k].Size+1)*2;
 for i:=0 to FourierSize do
 begin
 dspFFT1.RealIn[i]:=GenGraph[k].y[i];
 dspFFT1.ImagIn[i]:=0;
 end;
 dspFFT1.FFT;
 for i:=0 to ScrollBar1.Position-1 do
  FilterGraph[1].AddPoint(i,dspFFT1.RealOut[i]);
 for i:=ScrollBar1.Position to dspFFT1.BufferSize-ScrollBar1.Position-1 do
  FilterGraph[1].AddPoint(i,0);
 for i:=dspFFT1.BufferSize-ScrollBar1.Position to dspFFT1.BufferSize do
  FilterGraph[1].AddPoint(i,dspFFT1.RealOut[i]);

 dspFFT1.Clear;
 for i:=0 to FilterGraph[1].Size do
 begin
 dspFFT1.RealIn[i]:=FilterGraph[1].y[i];
 dspFFT1.ImagIn[i]:=0;
 end;
 dspFFT1.FFT;
 FilterGraph[1].Clear;
 for i:=0 to Trunc(dspFFT1.BufferSize/2)-1 do
  FilterGraph[1].AddPoint(i,dspFFT1.RealOut[i]/2000);
end;

procedure TAuxGraph1.BandStopFilter(Sender: TObject);
var
i: Integer;

begin
 for i:=0 to GenGraph[ActiveCurveNr.Value].Size do
 begin
 dspFFT1.RealIn[i]:=GenGraph[ActiveCurveNr.Value].y[i];
 dspFFT1.ImagIn[i]:=0;
 end;
 dspFFT1.FFT;
 for i:=0 to ScrollBar2.Position-1 do
  FilterGraph[1].AddPoint(i,dspFFT1.RealOut[i]);
 for i:=ScrollBar2.Position to ScrollBar1.Position-1 do
  FilterGraph[1].AddPoint(i,0);
 for i:=ScrollBar1.Position to dspFFT1.BufferSize-ScrollBar1.Position-1 do
  FilterGraph[1].AddPoint(i,dspFFT1.RealOut[i]);
 for i:=dspFFT1.BufferSize-ScrollBar1.Position to
   dspFFT1.BufferSize-ScrollBar2.Position-1 do
  FilterGraph[1].AddPoint(i,0);
 for i:=dspFFT1.BufferSize-ScrollBar2.Position to dspFFT1.BufferSize do
  FilterGraph[1].AddPoint(i,dspFFT1.RealOut[i]);

 dspFFT1.Clear;
 for i:=0 to FilterGraph[1].Size do
 begin
 dspFFT1.RealIn[i]:=FilterGraph[1].y[i];
 dspFFT1.ImagIn[i]:=0;
 end;
 dspFFT1.FFT;
 FilterGraph[1].Clear;
 for i:=1 to Trunc(dspFFT1.BufferSize/2)-2 do
  FilterGraph[1].AddPoint(i,dspFFT1.RealOut[i]/2000);
end;

end.
