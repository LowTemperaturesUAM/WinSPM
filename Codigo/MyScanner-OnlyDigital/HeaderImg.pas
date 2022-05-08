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
    procedure SPMVersion(FileName:string; var Major,Minor, Release, Build: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
    ZAmplitude: Single;
    PosFin:Integer;
    WSxMHeader: String;
    Version: String;
    MajorVer,MinorVer,ReleaseVer,BuildVer:Integer;
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
MyComments, strLine, strUnit: string;

begin
  DecimalSeparator := '.';

  //Obtenemos la version del programa para incluirlo en los header
  SPMVersion(ExtractFileName(ParamStr(0)),MajorVer,MinorVer,ReleaseVer,BuildVer);
  Version := FloatToStr(MajorVer) + '.' +FloatToStr(MinorVer) + '.'+FloatToStr(ReleaseVer);

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
  else if (FormPID.spinPID_In.Value  = ScanForm.ADCI) then
  strLine := Format('    Set Point: %s nA', [FormPID.lblCurrentSetPoint.Caption])
  else strLine := Format('    Set Point: %d %%', [FormPID.scrlbrSetPoint.Position]);

  WSxMHeader := WSxMHeader+strLine+#13#10;

  strLine := Format('    X Amplitude: %f nm', [abs(ScanForm.h.xend-ScanForm.h.xstart)*1e9*ScanForm.CalX]);
  WSxMHeader := WSxMHeader+strLine+#13#10;

  strLine := Format('    X Offset: %f nm', [ScanForm.XOffset*10*ScanForm.AmpX*ScanForm.CalX]);
  WSxMHeader := WSxMHeader+strLine+#13#10;

  strLine := Format('    Y Amplitude: %f nm', [abs(ScanForm.h.yend-ScanForm.h.ystart)*1e9*ScanForm.CalY]);
  WSxMHeader := WSxMHeader+strLine+#13#10;

  strLine := Format('    Y Offset: %f nm', [ScanForm.YOffset*10*ScanForm.AmpY*ScanForm.CalY]);
  WSxMHeader := WSxMHeader+strLine+#13#10;

  WSxMHeader := WSxMHeader+#13#10+
        '[General Info]'#13#10+
        #13#10+
        '    Image Data Type: double'#13#10;

  strLine := Format('    Number of columns: %d', [ScanForm.P_Scan_Lines]);
  WSxMHeader := WSxMHeader+strLine+#13#10;

  strLine := Format('    Number of rows: %d', [ScanForm.P_Scan_Lines]);
  WSxMHeader := WSxMHeader+strLine+#13#10;

  strLine := Format('    Z Amplitude: 1 %s', [strUnit]); // Si se guardan como flotantes el número se ignora el valor. Se usa la unidad con el valor que venga en la matriz
  WSxMHeader := WSxMHeader+strLine+#13#10;

  WSxMHeader := WSxMHeader+
        #13#10+
        '[Miscellaneous]'#13#10+
        #13#10+
        '    Comments: '+Edit1.Text+MyComments+#13#10+
        '    Saved with version: MyScanner '+Version+#13#10+
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

procedure TForm8.SPMVersion(FileName: string; var Major,Minor, Release, Build: Integer);
var
  Info:Pointer;
  InfoSize:Dword;
  FileInfo: PVSFixedFileInfo;
  FileSize: DWORD;
  Temp: DWORD;
begin
  //Funcion para obtener la version del programa usando la API de windows
  InfoSize := GetFileVersionInfoSize(PAnsiChar(FileName), Temp);
  if not(InfoSize =0) then
  begin
  GetMem(Info,InfoSize);
    try
      GetFileVersionInfo(PAnsiChar(FileName), 0, InfoSize, Info);
      VerQueryValue(Info, PathDelim, Pointer(FileInfo), FileSize);
      Major := FileInfo.dwFileVersionMS div $FFFF;
      Minor := FileInfo.dwFileVersionMS and $FFFF;
      Release := FileInfo.dwFileVersionLS div $FFFF;
      Build := FileInfo.dwFileVersionLS and $FFFF;
    finally
      FreeMem(Info, FileSize);
    end;
  end
  else
  begin //Si no lo consigue lo introducimos a mano
    Major :=1 ;
    Minor :=4 ;
    Release :=1 ;
    Build :=0 ;
  end;
end;

end.
