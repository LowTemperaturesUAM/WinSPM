program MyScanner;

uses
  Forms,
  Scanner1 in 'Scanner1.pas' {ScanForm},
  Scanning in 'Scanning.pas' {TopoForm},
  Trip in 'Trip.pas' {TripForm},
  Liner in 'Liner.pas' {LinerForm},
  Config_Liner in 'Config_Liner.pas' {LinerConfig},
  Config1 in 'Config1.pas' {FormConfig},
  Config_Trip in 'Config_Trip.pas' {TripConfig},
  blqDataSet in 'blqDataSet.pas' {blqDataSetForm},
  var_gbl in 'var_gbl.pas',
  HeaderImg in 'HeaderImg.pas' {Form8},
  FileNames in 'FileNames.pas' {Form9},
  DataAdcquisition in 'DataAdcquisition.pas' {DataForm},
  PID in 'PID.pas' {FormPID},
  Config_IV in 'Config_IV.pas' {Form11},
  Paste in 'Paste.pas' {FormPaste},
  ThdTimer in 'ThdTimer.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'WinSPM';
  Application.CreateForm(TScanForm, ScanForm);
  Application.CreateForm(TTripConfig, TripConfig);
  Application.CreateForm(TTopoForm, TopoForm);
  Application.CreateForm(TLinerForm, LinerForm);
  Application.CreateForm(TLinerConfig, LinerConfig);
  Application.CreateForm(TTripForm, TripForm);
  Application.CreateForm(TblqDataSetForm, blqDataSetForm);
  Application.CreateForm(TForm8, Form8);
  Application.CreateForm(TForm9, Form9);
  Application.CreateForm(TDataForm, DataForm);
  Application.CreateForm(TFormPID, FormPID);
  Application.CreateForm(TForm11, Form11);
  Application.CreateForm(TFormConfig, FormConfig);
  Application.CreateForm(TFormPaste, FormPaste);
  Application.Run;
end.
