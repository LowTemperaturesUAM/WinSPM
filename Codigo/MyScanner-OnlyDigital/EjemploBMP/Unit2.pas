unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls;

type
  TForm2 = class(TForm)
    P: TPaintBox;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.DFM}

procedure TForm2.Button1Click(Sender: TObject);
var
  he, wi, strip, limit, i,j,c : integer ;
  bmp : TBitmap ;
  ptr : PByteArray ;
begin
  bmp:=TBitmap.Create ;
  Height:=2*256;
  Width:=2*256;
  P.Height:=2*256;
  P.Width:=2*256;
  he := P.Height;
  wi := P.Width;
  bmp.width:=wi ;
  bmp.height:=he ;
  bmp.PixelFormat:=pf24bit ;
  strip:= 2; //he div 256;
  c:=0 ;
  limit:=strip;
  for i:=0 to he-1 do
  begin
    ptr:=bmp.ScanLine[he-i] ;
    for j:=0 to wi-1 do
    begin
      if (i < limit) and (c<255) then begin
        ptr[3*j+0]:=0 ;
        ptr[3*j+1]:=c;
        ptr[3*j+2]:= c;
      end;
      if i = limit then begin
      c:=c+1;
      limit:= limit+ strip;
        ptr[3*j+0]:=0 ;
        ptr[3*j+1]:=c ;
        ptr[3*j+2]:=c ;
      end;
    end ;
  end ;
  p.Canvas.Draw(0,0,bmp) ;
  bmp.Free ;
end;
end.
