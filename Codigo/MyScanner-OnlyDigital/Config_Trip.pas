unit Config_Trip;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ExtCtrls;

type
  TForm6 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    lblCurrentLimit: TLabel;
    spinCurrentLimit: TSpinEdit;
    procedure SpinEdit1Change(Sender: TObject);
    procedure SpinEdit2Change(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form6: TForm6;

implementation

uses Trip;

{$R *.DFM}

procedure TForm6.SpinEdit1Change(Sender: TObject);
begin
  TryStrToInt(SpinEdit1.Text, Form5.ZPDac);
end;

procedure TForm6.SpinEdit2Change(Sender: TObject);
begin
  TryStrToInt(SpinEdit2.Text, Form5.IADC);
end;

procedure TForm6.CheckBox1Click(Sender: TObject);
begin
if (Checkbox1.checked) then Form5.Mult:=1 else Form5.Mult:=-1;
end;

procedure TForm6.CheckBox2Click(Sender: TObject);
begin
if (Checkbox2.checked) then Form5.MultI:=1 else Form5.MultI:=-1;
end;

end.
