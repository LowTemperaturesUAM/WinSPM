unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, TeeProcs, TeEngine, Chart, Series;

type
  TForm1 = class(TForm)
    Chart1: TChart;
    SinSeries: TFastLineSeries;
    CosSeries: TFastLineSeries;
    SinCosSeries: TFastLineSeries;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
const
  N = 100;
  MIN = -10;
  MAX = 10;
var
  i: Integer;
  x: Double;
begin
  for i:=0 to N - 1 do begin
    x := MIN + (MAX - MIN) * i / (N - 1);
    SinSeries.AddXY(x, sin(x));
    CosSeries.AddXY(x, cos(x));
    SinCosSeries.AddXY(x, sin(x)*cos(x));
  end;
 
end;

end.
