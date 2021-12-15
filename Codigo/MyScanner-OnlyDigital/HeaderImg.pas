unit HeaderImg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls, var_gbl;

type
  TForm8 = class(TForm)
    Button1: TButton;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    RichEdit1: TRichEdit;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  ZAmplitude: Single;
  PosFin:Integer;
  WSxMHeader: AnsiString;
  end;

var
  Form8: TForm8;

implementation

uses Scanner1, PID;

{$R *.DFM}

procedure TForm8.FormCreate(Sender: TObject);
begin
  Button1Click(nil);
end;

procedure TForm8.Button1Click(Sender: TObject);
var
MyComments, strLine, strUnit: AnsiString;

begin
  //DecimalSeparator := '.';

  if RadioGroup1.ItemIndex=0 then MyComments:='Forth'
  else MyComments:='Back';

  if RadioGroup2.ItemIndex=0 then
  begin
    strUnit := 'nm';
    MyComments:=MyComments+'Z'
  end
  else if RadioGroup2.ItemIndex=1 then
  begin
    strUnit := 'nA';
    MyComments:=MyComments+'I'
  end
  else
  begin
    strUnit := 'V';
    MyComments:=MyComments+'Other';
  end;

  WSxMHeader:='WSxM file copyright UAM'+#13#10+
         'SxM Image file'+#13#10+
         'Image header size: 0'+#13#10+ // No se usa el tamaño de la cabecera, pero mejor que aparezca la línea
         '[Control]'+#13#10+
         #13#10;

  if (FormPID = nil) then
    strLine :='    Set Point: ?? %'
  else
    strLine := Format('    Set Point: %d %%', [FormPID.ScrollBar4.Position]);

  WSxMHeader := WSxMHeader+strLine+#13#10;

  strLine := Format('    X Amplitude: %f nm', [abs(Form1.h.xend-Form1.h.xstart)*1e9*Form1.CalX]);
  WSxMHeader := WSxMHeader+strLine+#13#10;

  strLine := Format('    X Offset: %f nm', [Form1.XOffset*10*Form1.AmpX*Form1.CalX]);
  WSxMHeader := WSxMHeader+strLine+#13#10;

  strLine := Format('    Y Amplitude: %f nm', [abs(Form1.h.yend-Form1.h.ystart)*1e9*Form1.CalY]);
  WSxMHeader := WSxMHeader+strLine+#13#10;

  strLine := Format('    Y Offset: %f nm', [Form1.YOffset*10*Form1.AmpY*Form1.CalY]);
  WSxMHeader := WSxMHeader+strLine+#13#10;

  WSxMHeader := WSxMHeader+#13#10+
        '[General Info]'#13#10+
        #13#10+
        '    Image Data Type: double'#13#10;

  strLine := Format('    Number of columns: %d', [Form1.P_Scan_Lines]);
  WSxMHeader := WSxMHeader+strLine+#13#10;

  strLine := Format('    Number of rows: %d', [Form1.P_Scan_Lines]);
  WSxMHeader := WSxMHeader+strLine+#13#10;

  strLine := Format('    Z Amplitude: 1 %s', [strUnit]); // Si se guardan como flotantes el número se ignora el valor. Se usa la unidad con el valor que venga en la matriz
  WSxMHeader := WSxMHeader+strLine+#13#10;

  WSxMHeader := WSxMHeader+
        #13#10+
        '[Miscellaneous]'#13#10+
        #13#10+
        '    Comments: '+Edit1.Text+MyComments+#13#10+
        '    Saved with version: MyScanner 1.302'#13#10+
        '    Version: 1.0 (August 2005)'#13#10+
        '    Z Scale Factor: 1'#13#10+
        '    Z Scale Offset: 0'#13#10+
        #13#10 +
        '[Header end]'+
        #13#10;

  PosFin := Length(WSxMHeader);
  RichEdit1.Text:= WSxMHeader;
  Label2.Caption:=InttoStr(PosFin);
end;

end.
