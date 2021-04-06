unit Scanning;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, xyyGraph, var_gbl, Spin, ComCtrls, Chart, Series,
  TeeProcs, TeEngine;

type
  TForm3 = class(TForm)
    ScrollBox1: TScrollBox;
    ScrollBox2: TScrollBox;
    Button1: TButton;
    RadioGroup1: TRadioGroup;
    PaintBox1: TPaintBox;
    PaintBox2: TPaintBox;
//    xyyGraph1: TxyyGraph;
    ChartLine: TChart;
    SpinEdit1: TSpinEdit;
    Label1: TLabel;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    TrackBar1: TTrackBar;
    Label3: TLabel;
    Label4: TLabel;
    TrackBar2: TTrackBar;
    Label2: TLabel;
    Label5: TLabel;
    CheckBox1: TCheckBox;
    Label6: TLabel;
    CheckBox2: TCheckBox;
    chkFlatten: TCheckBox;
    CheckBox3: TCheckBox;
    trckbrZoom: TTrackBar;
    lblZoom: TLabel;
    lblOffset: TLabel;
    trckbrOffset: TTrackBar;
    btnResetZoomOffset: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure FillImg(Sender: TObject; Data: HImg; Size: Integer; Sens: Integer);
    procedure UpdateBitmaps(Sender: TObject);
    procedure FreeScans(Sender:TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure ClearChart();
    procedure btnResetZoomOffsetClick(Sender: TObject);
    procedure trckbrZoomChange(Sender: TObject);
    procedure trckbrOffsetChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses Scanner1, PID;

{$R *.DFM}

procedure TForm3.Button1Click(Sender: TObject);
begin
CheckBox1.Checked:=False;
Form1.StopAction:=True;
//FormPID.se1.Text:='1'; //Comentado por Fran
end;

procedure TForm3.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//xyyGraph1.Clear;
ClearChart();
Form1.StopAction:=True;
//FormPID.se1.Text:='1'; //Comentado por Fran
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
if (Form1.PauseAction) then
begin Button2.Caption:='PAUSE'; Form1.PauseAction:=False; end
else
begin Button2.Caption:='CONTINUE'; Form1.PauseAction:=True; end;
end;

procedure TForm3.UpdateBitmaps(Sender: TObject);
var
  flatten: Integer;
  MakeX: Boolean;
  Data:HImg;

begin
    flatten := 0;
    if chkFlatten.Checked then
      flatten := 1;

    MakeX := (Form1.RadioGroup1.ItemIndex=0);

    if Form3.RadioGroup1.ItemIndex=0 then
    begin
      Data := Form1.FilterImage(Form1.Dat_Image_Forth[1], MakeX, Form1.P_Scan_Lines, flatten);
      FillImg(Sender,Data,Form1.P_Scan_Lines,1);
      Data := Form1.FilterImage(Form1.Dat_Image_Back[1], MakeX, Form1.P_Scan_Lines, flatten);
      FillImg(Sender,Data,Form1.P_Scan_Lines,2);
    end
    else
    begin
      Data := Form1.FilterImage(Form1.Dat_Image_Forth[2], MakeX, Form1.P_Scan_Lines, flatten);
      FillImg(Sender,Data,Form1.P_Scan_Lines,1);
      Data := Form1.FilterImage(Form1.Dat_Image_Back[2], MakeX, Form1.P_Scan_Lines, flatten);
      FillImg(Sender,Data,Form1.P_Scan_Lines,2);
    end;
end;

procedure TForm3.FillImg(Sender: TObject; Data: HImg; Size: Integer; Sens: Integer);
var
i,j,SizeofPixel,SepPixel: Integer;
DatatoPaint: Array[0..512,0..512] of Integer;
DataMax, DataMin, DataTo0_255, DataTo0_255Offset, BrightnessOffset: Double;
RectBitmap: TRect;
Bitmap: TBitmap;

begin

DataMax:=-1000000;
DataMin:=1000000;

//Busca máximo y mínimo
for i:=0 to Size-1 do
begin
for j:=0 to Size-1 do
 begin
 if Data[i,j]>DataMax then DataMax:=Data[i,j];
 if Data[i,j]<DataMin then DataMin:=Data[i,j];
 end;
end;
if ((DataMax-DataMin)=0) then begin DataMax:=1;DataMin:=0;end;

// Lo pone dentro de la escala [0,255] donde max=255 y min=0
// Es más eficiente multiplicar que divir, y es más eficiente hacer la resta y demás una sola vez que todas las del bucle
DataTo0_255 := 255*trckbrZoom.Position/(DataMax-DataMin);
//DataTo0_255Offset := -(DataMax+DataMin)/2;
DataTo0_255Offset := -(DataMax+DataMin)/2;
BrightnessOffset := 255*(trckbrZoom.Position+1)*trckbrOffset.Position/(200);

for i:=0 to Size-1 do
begin
for j:=0 to Size-1 do
 begin
 DatatoPaint[i,j]:=Round(((Data[i,j]+DataTo0_255Offset)*DataTo0_255)+255/2+BrightnessOffset);
 // Comprobamos que el dato cae dentro de los limites. Como ahora hay un offset, es posible que caiga fueraç

 if(DatatoPaint[i,j]>255) then
   DatatoPaint[i,j]:=255;
 if(DatatoPaint[i,j]<0) then
   DatatoPaint[i,j]:=0;
 end;
end;

// Creamos un bitmap con el tamaño original de la imagen y vamos coloreándolo punto a punto. Luego lo redimensionaremos.
Bitmap:= TBitmap.Create;
try
  Bitmap.PixelFormat := pf24bit;
  Bitmap.Width := Size;
  Bitmap.Height := Size;

  for i:=0 to Size-1 do
  begin
    for j:=0 to Size-1 do
    begin
      Bitmap.Canvas.Pixels[i, j] := DatatoPaint[j, i]*$010101;
    end;
    Application.ProcessMessages;
  end;

  RectBitmap.Top := 0;
  RectBitmap.Bottom := 256;
  RectBitmap.Left := 0;
  RectBitmap.Right := 256;

  if (Sens=1) then
    PaintBox1.Canvas.StretchDraw(RectBitmap, Bitmap)
  else
    PaintBox2.Canvas.StretchDraw(RectBitmap, Bitmap);

finally
  Bitmap.Free;
end;

{ // Código antiguo de pintado (cambiado en octubre de 2018). Se mantiene por si hay que hacer alguna prueba.
SizeofPixel:=Round(256/Size); //Tamaño del pixel
if Size=512 then SizeofPixel:=1;

for i:=0 to Size-1 do
begin
for j:=0 to Size-1 do
 begin
 if (Sens=1) then
  begin
   PaintBox1.Canvas.Brush.Color:=DatatoPaint[i,j]*65793; // $101010
   PaintBox1.Canvas.FillRect (Rect(j*SizeofPixel,i*SizeofPixel,(j+3)*SizeofPixel,(i+3)*SizeofPixel));
  end
  else
  begin
   PaintBox2.Canvas.Brush.Color:=DatatoPaint[i,j]*65793;
   PaintBox2.Canvas.FillRect(Rect(j*SizeofPixel,i*SizeofPixel,(j+3)*SizeofPixel,(i+3)*SizeofPixel));
  end;
 end;
end; }

end;

procedure TForm3.FreeScans(Sender:TObject);
var
i,j: integer ;
bmp : TBitmap ;
ptr : PByteArray ;
rect : TRect ;

begin
  bmp:=TBitmap.Create ;
  bmp.width:=512 ;
  bmp.height:=512 ;
  bmp.PixelFormat:=pf24bit ;
  for i:=0 to bmp.width-1 do
  begin
    ptr:=bmp.ScanLine[bmp.width-1-i] ;
    for j:=0 to bmp.width-1 do
    begin
      ptr[3*j+0]:=150 ;
      ptr[3*j+1]:=150 ;
      ptr[3*j+2]:=150 ;
    end ;
  end ;
  rect.Left:=0 ; Rect.Right:= 512;
  rect.Top :=0 ; rect.Bottom := 512 ;
  Paintbox1.Canvas.StretchDraw(rect,bmp) ;
  Paintbox2.Canvas.StretchDraw(rect,bmp) ;
  bmp.Free ;
end;

procedure TForm3.Button3Click(Sender: TObject);
begin
  ChartLine.LeftAxis.SetMinMax(ChartLine.LeftAxis.Minimum/2,ChartLine.LeftAxis.Maximum/2);
end;

procedure TForm3.Button4Click(Sender: TObject);
begin
  ChartLine.LeftAxis.SetMinMax(ChartLine.LeftAxis.Minimum*2, ChartLine.LeftAxis.Maximum*2);
end;

procedure TForm3.Button5Click(Sender: TObject);
begin
  ChartLine.LeftAxis.SetMinMax(ChartLine.LeftAxis.Minimum-0.05, ChartLine.LeftAxis.Maximum-0.05);
end;

procedure TForm3.Button6Click(Sender: TObject);
begin
  ChartLine.LeftAxis.SetMinMax(ChartLine.LeftAxis.Minimum+0.05, ChartLine.LeftAxis.Maximum+0.05);
end;

procedure TForm3.FormShow(Sender: TObject);
begin
  ChartLine.LeftAxis.AxisValuesFormat := '0.##E+###';
  Button7Click(nil);
end;

procedure TForm3.Button7Click(Sender: TObject);
begin
//  ChartLine.LeftAxis.SetMinMax(-0.2,0.2);
  ChartLine.LeftAxis.Automatic := True;
end;

procedure TForm3.TrackBar1Change(Sender: TObject);
begin
Label4.Caption:=InttoStr(Trackbar1.Position);
Form1.TrackBar1.Position:=TrackBar1.Position;
Form1.TiempoMedio:=0;
Form1.PuntosPonderados:=0;
Form1.TiempoInicial:=0;
end;

procedure TForm3.TrackBar2Change(Sender: TObject);
begin
Label5.Caption:=InttoStr(Trackbar2.Position);
//P_Scan_Jump:= Trackbar2.Position;
Form1.TrackBar2.Position:=TrackBar2.Position;
Form1.TiempoMedio:=0;
Form1.PuntosPonderados:=0;
Form1.TiempoInicial:=0;
end;

procedure TForm3.ClearChart();
begin
  ChartLine.RemoveAllSeries();
end;

procedure TForm3.btnResetZoomOffsetClick(Sender: TObject);
begin
  trckbrZoom.Position := 1;
  trckbrOffset.Position := 0;
  UpdateBitmaps(nil);
end;

procedure TForm3.trckbrZoomChange(Sender: TObject);
begin
  UpdateBitmaps(nil);
end;

procedure TForm3.trckbrOffsetChange(Sender: TObject);
begin
  UpdateBitmaps(nil);
end;

end.
