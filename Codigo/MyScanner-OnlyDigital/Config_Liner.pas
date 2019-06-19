unit Config_Liner;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Spin;

type
  TForm7 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    SpinEdit1: TSpinEdit;
    RadioGroup1: TRadioGroup;
    Label3: TLabel;
    Label4: TLabel;
    SpinEdit2: TSpinEdit;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Label5: TLabel;
    Panel2: TPanel;
    CheckBox4: TCheckBox;
    Pane3: TPanel;
    RadioGroup2: TRadioGroup;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpinEdit1Change(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure SpinEdit2Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form7: TForm7;

implementation

uses Liner;

{$R *.DFM}

procedure TForm7.FormClose(Sender: TObject; var Action: TCloseAction);
begin
if RadioGroup1.ItemIndex=0 then Form4.ReadXfromADC:=True else
Form4.ReadXfromADC:=False;

Form4.x_axisDac:=SpinEdit1.Value;
Form4.x_axisADC:=SpinEdit2.Value;
Form4.x_axisMult:=StrtoFloat(Edit1.Text);
Form4.NumCol:=1;
if Checkbox1.checked then Form4.NumCol:=Form4.NumCol+1;
if Checkbox2.checked then Form4.NumCol:=Form4.NumCol+1;
if Checkbox3.checked then Form4.NumCol:=Form4.NumCol+1;
Form4.ReadZ:=Checkbox1.checked;
Form4.ReadCurrent:=Checkbox2.checked;
Form4.ReadOther:=Checkbox3.checked;

end;

procedure TForm7.SpinEdit1Change(Sender: TObject);
begin
Form4.x_axisDac:=SpinEdit1.Value;
end;

procedure TForm7.RadioGroup1Click(Sender: TObject);
begin
if RadioGroup1.ItemIndex=0 then Form4.ReadXfromADC:=True else
Form4.ReadXfromADC:=False;
end;

procedure TForm7.SpinEdit2Change(Sender: TObject);
begin
Form4.x_axisADC:=SpinEdit2.Value;
end;

procedure TForm7.Edit1Change(Sender: TObject);
begin
Form4.x_axisMult:=StrtoFloat(Edit1.Text);
end;

procedure TForm7.CheckBox1Click(Sender: TObject);
begin
Form4.NumCol:=1;
if Checkbox1.checked then Form4.NumCol:=Form4.NumCol+1;
if Checkbox2.checked then Form4.NumCol:=Form4.NumCol+1;
if Checkbox3.checked then Form4.NumCol:=Form4.NumCol+1;
Form4.ReadZ:=Checkbox1.checked;
Form4.ReadCurrent:=Checkbox2.checked;
Form4.ReadOther:=Checkbox3.checked;
end;

procedure TForm7.CheckBox2Click(Sender: TObject);
begin
Form4.NumCol:=1;
if Checkbox1.checked then Form4.NumCol:=Form4.NumCol+1;
if Checkbox2.checked then Form4.NumCol:=Form4.NumCol+1;
if Checkbox3.checked then Form4.NumCol:=Form4.NumCol+1;
Form4.ReadZ:=Checkbox1.checked;
Form4.ReadCurrent:=Checkbox2.checked;
Form4.ReadOther:=Checkbox3.checked;
end;

procedure TForm7.CheckBox3Click(Sender: TObject);
begin
Form4.NumCol:=1;
if Checkbox1.checked then Form4.NumCol:=Form4.NumCol+1;
if Checkbox2.checked then Form4.NumCol:=Form4.NumCol+1;
if Checkbox3.checked then Form4.NumCol:=Form4.NumCol+1;
Form4.ReadZ:=Checkbox1.checked;
Form4.ReadCurrent:=Checkbox2.checked;
Form4.ReadOther:=Checkbox3.checked;
end;

procedure TForm7.CheckBox4Click(Sender: TObject);
begin
Form4.scrollSizeBiasChange(nil);
end;

procedure TForm7.RadioGroup2Click(Sender: TObject);
begin
if RadioGroup2.ItemIndex = 0 then Edit1.Text:='10';
if RadioGroup2.ItemIndex = 1 then Edit1.Text:='1';
if RadioGroup2.ItemIndex = 2 then Edit1.Text:='0.1';
if RadioGroup2.ItemIndex = 3 then Edit1.Text:='0.01';
if RadioGroup2.ItemIndex = 4 then Edit1.Text:='0.001';
end;

end.
