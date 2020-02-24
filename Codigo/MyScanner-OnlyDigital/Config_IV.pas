unit Config_IV;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm11 = class(TForm)
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    ComboBox1: TComboBox;
    Label1: TLabel;
    chkSaveAsWSxM: TCheckBox;
    procedure ComboBox1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form11: TForm11;

implementation

uses Scanner1, Liner;

{$R *.dfm}

procedure TForm11.ComboBox1Change(Sender: TObject);
begin
Form1.IV_Scan_Lines:=StrtoInt(ComboBox1.Text);
Form1.RedimCits(Form1.IV_Scan_Lines, Form4.PointNumber);
end;

end.
