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
    Label4: TLabel;
    xDACMultiplier: TEdit;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Label5: TLabel;
    Panel2: TPanel;
    ReverseCheck: TCheckBox;
    Pane3: TPanel;
    RadioGroup2: TRadioGroup;
    Label3: TLabel;
    seADCxaxis: TSpinEdit;
    pnl1: TPanel;
    seReduceRampFactor: TSpinEdit;
    chkReduceRamp: TCheckBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpinEdit1Change(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure xDACMultiplierChange(Sender: TObject);
    procedure xDACMultiplierCheck(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure ReverseCheckClick(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
    procedure seADCxaxisChange(Sender: TObject);
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
if RadioGroup1.ItemIndex=0 then LinerForm.ReadXfromADC:=True else
LinerForm.ReadXfromADC:=False;

LinerForm.x_axisDac:=SpinEdit1.Value;
LinerForm.x_axisADC:=seADCxaxis.Value;
LinerForm.x_axisMult:=StrtoFloat(xDACMultiplier.Text);
LinerForm.NumCol:=1;
if Checkbox1.checked then LinerForm.NumCol:=LinerForm.NumCol+1;
if Checkbox2.checked then LinerForm.NumCol:=LinerForm.NumCol+1;
if Checkbox3.checked then LinerForm.NumCol:=LinerForm.NumCol+1;
LinerForm.ReadZ:=Checkbox1.checked;
LinerForm.ReadCurrent:=Checkbox2.checked;
LinerForm.ReadOther:=Checkbox3.checked;

end;

procedure TForm7.SpinEdit1Change(Sender: TObject);
begin
  TryStrToInt(SpinEdit1.Text, LinerForm.x_axisDac);
end;

procedure TForm7.RadioGroup1Click(Sender: TObject);
begin
if RadioGroup1.ItemIndex=0 then LinerForm.ReadXfromADC:=True else
LinerForm.ReadXfromADC:=False;
end;

procedure TForm7.xDACMultiplierChange(Sender: TObject);
var
  NewMultiplier: Single;
  IsValid: Boolean;
begin
IsValid := TryStrtoFloat(xDACMultiplier.Text,NewMultiplier);
if IsValid and (NewMultiplier <> 0) then LinerForm.x_axisMult := NewMultiplier
else exit;
end;

procedure TForm7.xDACMultiplierCheck(Sender: TObject);
var
  NewMultiplier: Single;
  IsValid: Boolean;
begin
IsValid := TryStrtoFloat(xDACMultiplier.Text,NewMultiplier);
if (not IsValid) or (NewMultiplier <> LinerForm.x_axisMult) then
begin
xDACMultiplier.Text := FloatToStrF(LinerForm.x_axisMult,ffGeneral,4,4);
end;
end;

procedure TForm7.CheckBox1Click(Sender: TObject);
begin
LinerForm.NumCol:=1;
if Checkbox1.checked then LinerForm.NumCol:=LinerForm.NumCol+1;
if Checkbox2.checked then LinerForm.NumCol:=LinerForm.NumCol+1;
if Checkbox3.checked then LinerForm.NumCol:=LinerForm.NumCol+1;
LinerForm.ReadZ:=Checkbox1.checked;
LinerForm.ReadCurrent:=Checkbox2.checked;
LinerForm.ReadOther:=Checkbox3.checked;
end;

procedure TForm7.CheckBox2Click(Sender: TObject);
begin
LinerForm.NumCol:=1;
if Checkbox1.checked then LinerForm.NumCol:=LinerForm.NumCol+1;
if Checkbox2.checked then LinerForm.NumCol:=LinerForm.NumCol+1;
if Checkbox3.checked then LinerForm.NumCol:=LinerForm.NumCol+1;
LinerForm.ReadZ:=Checkbox1.checked;
LinerForm.ReadCurrent:=Checkbox2.checked;
LinerForm.ReadOther:=Checkbox3.checked;
end;

procedure TForm7.CheckBox3Click(Sender: TObject);
begin
LinerForm.NumCol:=1;
if Checkbox1.checked then LinerForm.NumCol:=LinerForm.NumCol+1;
if Checkbox2.checked then LinerForm.NumCol:=LinerForm.NumCol+1;
if Checkbox3.checked then LinerForm.NumCol:=LinerForm.NumCol+1;
LinerForm.ReadZ:=Checkbox1.checked;
LinerForm.ReadCurrent:=Checkbox2.checked;
LinerForm.ReadOther:=Checkbox3.checked;
end;

procedure TForm7.ReverseCheckClick(Sender: TObject);
begin
LinerForm.scrollSizeBiasChange(nil);
end;

procedure TForm7.RadioGroup2Click(Sender: TObject);
begin
  // Preservamos el signo actual, y solo cambiamos la magnitud,
  // para evitar causar errores porque se nos olvide añadir de nuevo el signo
  if LinerForm.x_axisMult > 0 then
  begin
  if RadioGroup2.ItemIndex = 0 then xDACMultiplier.Text:='10';
  if RadioGroup2.ItemIndex = 1 then xDACMultiplier.Text:='1';
  if RadioGroup2.ItemIndex = 2 then xDACMultiplier.Text:='0.1';
  if RadioGroup2.ItemIndex = 3 then xDACMultiplier.Text:='0.01';
  if RadioGroup2.ItemIndex = 4 then xDACMultiplier.Text:='0.001';
  end
  else
  begin
    if RadioGroup2.ItemIndex = 0 then xDACMultiplier.Text:='-10';
    if RadioGroup2.ItemIndex = 1 then xDACMultiplier.Text:='-1';
    if RadioGroup2.ItemIndex = 2 then xDACMultiplier.Text:='-0.1';
    if RadioGroup2.ItemIndex = 3 then xDACMultiplier.Text:='-0.01';
    if RadioGroup2.ItemIndex = 4 then xDACMultiplier.Text:='-0.001';
  end;

end;

procedure TForm7.seADCxaxisChange(Sender: TObject);
begin
  TryStrToInt(seADCxaxis.Text, LinerForm.x_axisAdc);
end;

end.
