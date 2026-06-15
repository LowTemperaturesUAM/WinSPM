unit Config_IV;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormCITS = class(TForm)
    DoForth_CITS: TCheckBox;
    DoBack_CITS: TCheckBox;
    NrOfLines_CITS: TComboBox;
    NrOfPointsLbl: TLabel;
    chkSaveAsWSxM: TCheckBox;
    procedure NrOfLines_CITSChange(Sender: TObject);
    procedure NrOfLines_CITSExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCITS: TFormCITS;

implementation

uses Scanner1, Liner;

{$R *.dfm}

procedure TFormCITS.NrOfLines_CITSChange(Sender: TObject);
var
  isValid: Boolean;
  NewLines: Integer;
begin
//Check for valid input
isValid := TryStrToInt(NrOfLines_CITS.Text,NewLines);
//If it is, we proceed with the asignment
if isValid then
begin
  if (NewLines>=8) and (NewLines<=512) then
  begin
    ScanForm.IV_Scan_Lines := NewLines;
    ScanForm.RedimCits(ScanForm.IV_Scan_Lines, LinerForm.PointNumber);
  end;
end;
end;



procedure TFormCITS.NrOfLines_CITSExit(Sender: TObject);
var
  isValid: Boolean;
  NewLines: Integer;
begin
//Check for valid input for number of lines
isValid := TryStrToInt(NrOfLines_CITS.Text,NewLines);
if isValid then
begin
  //If we already have the proper value, we exit
  if NewLines = ScanForm.IV_Scan_Lines then exit
  //Otherwise, we revert to the last know good value
  else NrOfLines_CITS.Text := IntToStr(ScanForm.IV_Scan_Lines);
end
//If the input is now valid, we also revert to the last know good value;
else NrOfLines_CITS.Text := IntToStr(ScanForm.IV_Scan_Lines);
end;

end.
