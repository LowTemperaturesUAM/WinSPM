unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Mask;

type
  TForm1 = class(TForm)
    G: TPaintBox;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    MaskEdit1: TMaskEdit;
    Button4: TButton;
    Button5: TButton;
    p2: TPaintBox;
    Button6: TButton;
    PaintBox1: TPaintBox;
    Button7: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
  private
    { Private declarations }
  public
    Function Normal(var x : extended ; var sigma , med : single): extended;
  end;

var
  Form1: TForm1;

implementation

uses Unit2;

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var
  i,j,c : integer ;
  bmp, bmp2 : TBitmap ;
  ptr : PByteArray ;
  rect : TRect ;


begin
  bmp:=TBitmap.Create ;
  bmp.width:=256 ;
  bmp.height:=256 ;
  bmp.PixelFormat:=pf24bit ;
  for i:=0 to 255 do
  begin
    ptr:=bmp.ScanLine[255-i] ;
    for j:=0 to 255 do
    begin
      c:=i ;
      ptr[3*j+0]:=0 ;
      ptr[3*j+1]:=0 ;
      ptr[3*j+2]:=c ;
    end ;
  end ;
  rect.Left:= 0 ; Rect.Right:= 128;
  rect.Top :=0 ; rect.Bottom := 128 ;
  bmp2:= Tbitmap.Create;
  bmp.Canvas.StretchDraw(rect, bmp);
  bmp.Width:= Rect.Right;
  bmp.Height:= Rect.Bottom;
  G.Canvas.Draw(0,0,bmp) ;
  bmp2.free;
  bmp.Free ;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  CAnvas.Ellipse(0,0,Width, Height);
end;

procedure TForm1.Button3Click(Sender: TObject);
const
  step = 32;
var
  Rect: TRect ;
  i: integer ;
begin
  Rect.Left := 0 ;
  Rect.Right := ClientWidth ;
  for I := 0 to Step-1 do
  begin
        Rect.Top:= i * ClientHeight div Step ;
        Rect.Bottom := (i + 1) * ClientHeight div Step ;
        Canvas.Brush.Color := RGB( 0 , 0 , (I+1) * 128 div Step + 127);
        Canvas.FillRect(Rect);
  end;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  Form2.ShowModal;
end;

procedure TForm1.Button5Click(Sender: TObject);

var
  i,j,c : integer ;
  bmp : TBitmap ;
  ptr : PByteArray ;
begin
  Beep;
{  bmp:=TBitmap.Create ;
  bmp.width:=256 ;
  bmp.height:=256 ;
  bmp.PixelFormat:=pf16bit ;

  for i:=0 to 255 do
  begin
    ptr:=bmp.ScanLine[255-i] ;
    for j:=0 to 255 do
    begin
      c:=i ;
      ptr[3*j+0]:=0 ;
      ptr[3*j+1]:=0 ;
      ptr[3*j+2]:=c ;
    end ;
  end ;
  p2.Canvas.Draw(0,0,bmp) ;
  bmp.Free ;
}
end;
procedure TForm1.Button6Click(Sender: TObject);
var
  bmp, b2 : TBitMap ;
  i, j, c, sz, h, w : integer ;
  p : PByteArray ;

 BitMap1,BitMap2 : TBitMap;
 MyFormat : Word;
begin
   BitMap2 := TBitMap.Create;
   BitMap1 := TBitMap.Create;
 try
   BitMap2.Assign(BitMap1);     // Copy BitMap1 into BitMap2
   BitMap2.Dormant;             // Free up GDI resources
   BitMap2.FreeImage;           // Free up Memory.
   Canvas.Draw(20,20,BitMap2);  // Note that previous calls don't lose the image

   BitMap2.Monochrome := true;
   Canvas.Draw(80,80,BitMap2);
   BitMap2.ReleaseHandle;       // This will actually lose the bitmap;
 finally
   BitMap1.Free;
   BitMap2.Free;
  bmp  := TBitMap.Create ;
  w:= 100 ; h := 100 ;
  paintbox1.Height := h ;
  Paintbox1.Width := w ;
  b2 := TbitMap.Create ;
  b2.Width := w ;
  b2.Height := h ;
  sz := 5 ;
  bmp.Height := sz ;
  bmp.Width := sz ;
  bmp.PixelFormat := pf24bit ;
  for I:= 0 to sz-1 do begin
    P := Bmp.ScanLine[sz-1- i ] ;
    for j:= 0 to sz-1 do begin
     c:= 125 ;
      p[0+3*j]:= c ;
      p[1+3*j]:= 0 ;
      p[2+3*j]:= c ;
    end ;
  end;

  bmp.Canvas.StretchDraw(Rect(0,0,w,h),bmp) ;
  //b2:= bmp ;
  //PaintBox1.Canvas.StretchDraw(Rect(0,0,w,h),b2) ;
  //Paintbox1.Canvas.Draw(0,0,bmp) ;
  bmp.Canvas.StretchDraw(rect(0,0,w,h), bmp);
  bmp.Width:= w;
  bmp.Height:= h;
  PaintBox1.Canvas.Draw(0,0,bmp) ;
  b2.Free ;
  bmp.Free ;
 end;
end;
procedure TForm1.Button7Click(Sender: TObject);
var
  b1, b2 : TBitMap ;
  i, j, c, sz, h , w : integer ;
  p : PByteArray ;
  x, x0 : extended ;
  y, z : single ;

begin
  b1 := TBitMap.Create ;
  b2 := TBitMap.Create ;
  try
  H:= 125 ;
  w:= H ;
  sz:= Round(10*h) ;
  b1.Width := sz ;
  b1.Height := sz ;
  b1.PixelFormat := pf24bit ;
  for i:= 0 to sz-1 do begin
    p := b1.ScanLine[sz-1-i] ;
    c:=i*125 div sz + 124 ;
    x:= c ; Y:= 7.2 ; z:= 124 ;
    x:= normal(x,y,z);
    for j:= 0 to sz-1 do begin
    p[0+3*j]:= rOUND(256*x) ;
    p[1+3*j]:= 0 ;//255-C ;
    p[2+3*j]:= 0 ; //c ;
    end;
  end ;
  b2.Assign(b1) ;
  B1.FreeImage ;
  B1.Width:= W;
  B1.Height:= h ;
  b1.Canvas.StretchDraw(Rect(0,0,w, h ), b2);
  Paintbox1.Height:=h ;
  PaintBox1.Width := w ;
  PaintBox1.Canvas.Draw(0,0,b1);
  PaintBox1.Canvas.Draw(0,0,b1);
  finally
  b1.Free ;
  b2.Free ;
  end;

end;
function TForm1.Normal(var x : extended ; var sigma, med: single ): extended;
var y, z : real ;
begin
   y := -(x-med)/sigma*(x-med)/sigma ;
   z:= Exp(y);
   Result:= z ;
end;


end.
