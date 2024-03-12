unit Config_Liner;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Spin;

type
  TLinerConfig = class(TForm)
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
    SetDAC5AttBtn: TButton;
    SetDAC6AttBtn: TButton;
    DAC5AttEdit: TEdit;
    DAC6AttEdit: TEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
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
    procedure DAC5AttEditCheck(Sender: TObject);
    procedure DAC6AttEditCheck(Sender: TObject);
    procedure SetDAC5AttBtnClick(Sender: TObject);
    procedure SetDAC6AttBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LinerConfig: TLinerConfig;

implementation

uses Liner, DataAdcquisition, Scanner1;

{$R *.DFM}

procedure TLinerConfig.FormClose(Sender: TObject; var Action: TCloseAction);
var
  NewMultiplier: Double;
begin
if RadioGroup1.ItemIndex=0 then LinerForm.ReadXfromADC:=True else
LinerForm.ReadXfromADC:=False;

LinerForm.x_axisDac:=SpinEdit1.Value;
LinerForm.x_axisADC:=seADCxaxis.Value;
//LinerForm.x_axisMult:=StrtoFloat(xDACMultiplier.Text);
NewMultiplier := StrtoFloat(xDACMultiplier.Text);
case LinerForm.x_axisDac of
  0: LinerForm.x_axisMult := NewMultiplier*DataForm.scan_attenuator;
  2: LinerForm.x_axisMult := NewMultiplier*DataForm.scan_attenuator;
  5: LinerForm.x_axisMult := NewMultiplier*DataForm.z_attenuator;
  6: LinerForm.x_axisMult := NewMultiplier*DataForm.bias_attenuator;
else LinerForm.x_axisMult := NewMultiplier;
end;
LinerForm.NumCol:=1;
if Checkbox1.checked then LinerForm.NumCol:=LinerForm.NumCol+1;
if Checkbox2.checked then LinerForm.NumCol:=LinerForm.NumCol+1;
if Checkbox3.checked then LinerForm.NumCol:=LinerForm.NumCol+1;
LinerForm.ReadZ:=Checkbox1.checked;
LinerForm.ReadCurrent:=Checkbox2.checked;
LinerForm.ReadOther:=Checkbox3.checked;

end;

procedure TLinerConfig.SpinEdit1Change(Sender: TObject);
begin
  TryStrToInt(SpinEdit1.Text, LinerForm.x_axisDac);
end;

procedure TLinerConfig.RadioGroup1Click(Sender: TObject);
begin
if RadioGroup1.ItemIndex=0 then LinerForm.ReadXfromADC:=True else
LinerForm.ReadXfromADC:=False;
end;

procedure TLinerConfig.xDACMultiplierChange(Sender: TObject);
var
  NewMultiplier: Double;
  IsValid: Boolean;
begin
IsValid := TryStrtoFloat(xDACMultiplier.Text,NewMultiplier);
if IsValid and (NewMultiplier <> 0) then
//Ojo!! si hemos cambiado el DAC de salida y no hemos cerrado la ventana,
// la escala se actualizara acorde al dac que tuvieramos antes
case LinerForm.x_axisDac of
  0: LinerForm.x_axisMult := NewMultiplier*DataForm.scan_attenuator;
  2: LinerForm.x_axisMult := NewMultiplier*DataForm.scan_attenuator;
  5: LinerForm.x_axisMult := NewMultiplier*DataForm.z_attenuator;
  6: LinerForm.x_axisMult := NewMultiplier*DataForm.bias_attenuator;
else LinerForm.x_axisMult := NewMultiplier;
end
else exit;
end;

procedure TLinerConfig.xDACMultiplierCheck(Sender: TObject);
var
  NewMultiplier: Double;
  IsValid: Boolean;
begin
IsValid := TryStrtoFloat(xDACMultiplier.Text,NewMultiplier);
if (not IsValid) or (NewMultiplier <> LinerForm.x_axisMult) then
begin
xDACMultiplier.Text := FloatToStrF(LinerForm.x_axisMult,ffGeneral,4,4);
end;
end;

procedure TLinerConfig.CheckBox1Click(Sender: TObject);
begin
LinerForm.NumCol:=1;
if Checkbox1.checked then LinerForm.NumCol:=LinerForm.NumCol+1;
if Checkbox2.checked then LinerForm.NumCol:=LinerForm.NumCol+1;
if Checkbox3.checked then LinerForm.NumCol:=LinerForm.NumCol+1;
LinerForm.ReadZ:=Checkbox1.checked;
LinerForm.ReadCurrent:=Checkbox2.checked;
LinerForm.ReadOther:=Checkbox3.checked;
end;

procedure TLinerConfig.CheckBox2Click(Sender: TObject);
begin
LinerForm.NumCol:=1;
if Checkbox1.checked then LinerForm.NumCol:=LinerForm.NumCol+1;
if Checkbox2.checked then LinerForm.NumCol:=LinerForm.NumCol+1;
if Checkbox3.checked then LinerForm.NumCol:=LinerForm.NumCol+1;
LinerForm.ReadZ:=Checkbox1.checked;
LinerForm.ReadCurrent:=Checkbox2.checked;
LinerForm.ReadOther:=Checkbox3.checked;
end;

procedure TLinerConfig.CheckBox3Click(Sender: TObject);
begin
LinerForm.NumCol:=1;
if Checkbox1.checked then LinerForm.NumCol:=LinerForm.NumCol+1;
if Checkbox2.checked then LinerForm.NumCol:=LinerForm.NumCol+1;
if Checkbox3.checked then LinerForm.NumCol:=LinerForm.NumCol+1;
LinerForm.ReadZ:=Checkbox1.checked;
LinerForm.ReadCurrent:=Checkbox2.checked;
LinerForm.ReadOther:=Checkbox3.checked;
end;

procedure TLinerConfig.ReverseCheckClick(Sender: TObject);
begin
LinerForm.scrollSizeBiasChange(nil);
end;

procedure TLinerConfig.RadioGroup2Click(Sender: TObject);
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

procedure TLinerConfig.seADCxaxisChange(Sender: TObject);
begin
  TryStrToInt(seADCxaxis.Text, LinerForm.x_axisAdc);
end;


procedure TLinerConfig.DAC5AttEditCheck(Sender: TObject);
var
  NewMultiplier: Double;
  IsValid: Boolean;
begin
IsValid := TryStrtoFloat(DAC5AttEdit.Text,NewMultiplier);
if (not IsValid) then
begin
DAC5AttEdit.Text := FloatToStrF(DataForm.z_attenuator,ffGeneral,4,4);
end;
end;


procedure TLinerConfig.DAC6AttEditCheck(Sender: TObject);
var
  NewMultiplier: Double;
  IsValid: Boolean;
begin
IsValid := TryStrtoFloat(DAC6AttEdit.Text,NewMultiplier);
if (not IsValid) then
begin
DAC6AttEdit.Text := FloatToStrF(DataForm.bias_attenuator,ffGeneral,4,4);
end;
end;

procedure TLinerConfig.FormShow(Sender: TObject);
begin
case ScanForm.LHARev of
    revB..revC: begin
      //Dejamos los botones de los atenuadores 5 y 6 invisibles
      DAC5AttEdit.Visible := False;
      DAC6AttEdit.Visible := False;
      SetDAC5AttBtn.Visible := False;
      SetDAC6AttBtn.Visible := False;
      LinerForm.ZAttText.Visible := False;
      LinerForm.ZAttDispValue.Visible := False;
      LinerForm.BiasAttText.Visible := False;
      LinerForm.BiasAttDispValue.Visible := False;
    end;
    revD..revE: begin
      //En las versiones nuevas mostramos esta opcion
      DAC5AttEdit.Visible := True;
      DAC6AttEdit.Visible := True;
      SetDAC5AttBtn.Visible := True;
      SetDAC6AttBtn.Visible := True;
      LinerForm.ZAttText.Visible := True;
      LinerForm.ZAttDispValue.Visible := True;
      LinerForm.BiasAttText.Visible := True;
      LinerForm.BiasAttDispValue.Visible := True;
    end;
end;
end;

procedure TLinerConfig.SetDAC5AttBtnClick(Sender: TObject);
begin
case ScanForm.LHARev of
    revD: begin
      //Dejamos los botones de los atenuadores 5 y 6 invisibles
      DataForm.set_attenuator(3,StrToFloat(DAC5AttEdit.Text));
    end;
    revE: begin
      //En las versiones nuevas mostramos esta opcion
      DataForm.set_attenuator_14b(3,StrToFloat(DAC5AttEdit.Text));
    end;
end;
LinerForm.ZAttDispValue.Caption := DAC5AttEdit.Text;
//Refresh de multiplier
xDACMultiplierChange(xDACMultiplier);
end;

procedure TLinerConfig.SetDAC6AttBtnClick(Sender: TObject);
begin
case ScanForm.LHARev of
    revD: begin
      //Dejamos los botones de los atenuadores 5 y 6 invisibles
      DataForm.set_attenuator(4,StrToFloat(DAC6AttEdit.Text));
    end;
    revE: begin
      //En las versiones nuevas mostramos esta opcion
      DataForm.set_attenuator_14b(4,StrToFloat(DAC6AttEdit.Text));
    end;
end;
LinerForm.BiasAttDispValue.Caption := DAC6AttEdit.Text;
//Refresh de multiplier
xDACMultiplierChange(xDACMultiplier);
end;

procedure TLinerConfig.FormCreate(Sender: TObject);
var
  NewMultiplier: Double;
begin
NewMultiplier := StrtoFloat(xDACMultiplier.Text);
if NewMultiplier<>0 then LinerForm.x_axisMult := NewMultiplier
else LinerForm.x_axisMult := 10;
end;

end.
