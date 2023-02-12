program MyScanner;

uses
  Forms,
  Scanner1 in 'Scanner1.pas' {ScanForm},
  Scanning in 'Scanning.pas' {Form3},
  Trip in 'Trip.pas' {Form5},
  Liner in 'Liner.pas' {Form4},
  Config_Liner in 'Config_Liner.pas' {Form7},
  Config1 in 'Config1.pas' {FormConfig},
  Config_Trip in 'Config_Trip.pas' {Form6},
  blqDataSet in 'blqDataSet.pas' {blqDataSetForm},
  var_gbl in 'var_gbl.pas',
  HeaderImg in 'HeaderImg.pas' {Form8},
  FileNames in 'FileNames.pas' {Form9},
  DataAdcquisition in 'DataAdcquisition.pas' {Form10},
  PID in 'PID.pas' {FormPID},
  Config_IV in 'Config_IV.pas' {Form11},
  Paste in 'Paste.pas' {FormPaste},
  ThdTimer in 'ThdTimer.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'WinSPM';
  Application.CreateForm(TScanForm, ScanForm);
  Application.CreateForm(TForm6, Form6);
  Application.CreateForm(TForm3, Form3);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TForm7, Form7);
  Application.CreateForm(TForm5, Form5);
  Application.CreateForm(TblqDataSetForm, blqDataSetForm);
  Application.CreateForm(TForm8, Form8);
  Application.CreateForm(TForm9, Form9);
  Application.CreateForm(TForm10, Form10);
  Application.CreateForm(TFormPID, FormPID);
  Application.CreateForm(TForm11, Form11);
  Application.CreateForm(TFormConfig, FormConfig);
  Application.CreateForm(TFormPaste, FormPaste);
  Application.Run;
end.
