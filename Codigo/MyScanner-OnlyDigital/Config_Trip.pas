unit Config_Trip;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ExtCtrls;

type
  TTripConfig = class(TForm)
    Panel1: TPanel;
    OutLabel: TLabel;
    InLabel: TLabel;
    OutDacEdit: TSpinEdit;
    InADCEdit: TSpinEdit;
    InvertZPChk: TCheckBox;
    InvertCurChk: TCheckBox;
    lblCurrentLimit: TLabel;
    spinCurrentLimit: TSpinEdit;
    procedure OutDacEditChange(Sender: TObject);
    procedure InADCEditChange(Sender: TObject);
    procedure InvertZPChkClick(Sender: TObject);
    procedure InvertCurChkClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TripConfig: TTripConfig;

implementation

uses Trip;

{$R *.DFM}

procedure TTripConfig.OutDacEditChange(Sender: TObject);
begin
  //TryStrToInt(OutDacEdit.Text, TripForm.ZPDac);
  TripForm.ZPDAC:=OutDacEdit.Value;
end;

procedure TTripConfig.InADCEditChange(Sender: TObject);
begin
  //TryStrToInt(SpinEdit2.Text, TripForm.IADC);
  TripForm.IADC:=InADCEdit.Value;
end;

procedure TTripConfig.InvertZPChkClick(Sender: TObject);
begin
if (InvertZPChk.Checked) then TripForm.Mult:=1 else TripForm.Mult:=-1;
end;

procedure TTripConfig.InvertCurChkClick(Sender: TObject);
begin
if (InvertCurChk.Checked) then TripForm.MultI:=1 else TripForm.MultI:=-1;
end;

end.
