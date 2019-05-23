unit Config1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Spin, Math;

type
  TForm2 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    Label6: TLabel;
    Edit1: TEdit;
    Label7: TLabel;
    ComboBox1: TComboBox;
    Label8: TLabel;
    ComboBox2: TComboBox;
    Label9: TLabel;
    Edit2: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    Panel2: TPanel;
    Label12: TLabel;
    Label14: TLabel;
    SpinEdit3: TSpinEdit;
    Label15: TLabel;
    ComboBox3: TComboBox;
    CheckBox1: TCheckBox;
    Label13: TLabel;
    Edit3: TEdit;
    CheckBox2: TCheckBox;
    Label16: TLabel;
    SpinEdit4: TSpinEdit;
    Label17: TLabel;
    ComboBox4: TComboBox;
    Label18: TLabel;
    Edit4: TEdit;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    CheckBox3: TCheckBox;
    SpinEdit5: TSpinEdit;
    ComboBox5: TComboBox;
    Edit5: TEdit;
    CheckBox4: TCheckBox;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    SpinEdit6: TSpinEdit;
    SpinEdit7: TSpinEdit;
    chkAttenuator: TCheckBox;
    Label25: TLabel;
    ComboBox6: TComboBox;
    Label26: TLabel;
    ComboBox7: TComboBox;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses Scanner1, DataAdcquisition;

{$R *.DFM}

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
Form1.XDAC:=SpinEdit1.Value;
Form1.YDAC:=SpinEdit2.Value;
Form1.XDAC_Pos:=SpinEdit6.Value;
Form1.YDAC_Pos:=SpinEdit7.Value;
Form1.AmpX:=StrtoFloat(Combobox1.Text);
Form1.AmpY:=StrtoFloat(Combobox2.Text);
Form1.CalX:=StrtoFloat(Edit1.Text);
Form1.CalY:=StrtoFloat(Edit2.Text);
Form1.ADCTopo:=SpinEdit3.Value;
Form1.ADCI:=SpinEdit4.Value;
Form1.AmpTopo:=StrtoFloat(Combobox3.Text);
Form1.AmpI:=power(10,-1*(StrtoFloat(Form2.Combobox4.Text)-1)); //Le resto 1 a mano porque hay un factor 10 colgando por cómo se interpreta la lectura del adc
Form1.CalTopo:=StrtoInt(Edit3.Text);
Form1.MultI:=StrtoInt(Edit4.Text);
Form1.ReadTopo:=Checkbox1.checked;
Form1.ReadCurrent:=Checkbox2.checked;

// Si está activo el atenuador, el efecto será el mismo que bajar las ganancias de los amplificadores un factor 10
if (chkAttenuator.Checked) then
begin
  Form10.set_attenuator(0.1);
//  Form1.AmpX:= Form1.AmpX*0.1;
//  Form1.AmpY:= Form1.AmpY*0.1;
end
else
  Form10.set_attenuator(1);

Form1.TrackBar3Change(self);

end;

procedure TForm2.FormCreate(Sender: TObject);
begin
Form1.XDAC:=SpinEdit1.Value;
Form1.YDAC:=SpinEdit2.Value;
Form1.AmpX:=StrtoFloat(Combobox1.Text);
Form1.AmpY:=StrtoFloat(Combobox2.Text);
Form1.CalX:=StrtoFloat(Edit1.Text);
Form1.CalY:=StrtoFloat(Edit2.Text);
Form1.ADCTopo:=SpinEdit3.Value;
Form1.ADCI:=SpinEdit4.Value;
Form1.AmpTopo:=StrtoFloat(Form2.Combobox3.Text);
Form1.AmpI:=power(10,-1*StrtoFloat(Form2.Combobox4.Text));
Form1.CalTopo:=StrtoInt(Form2.Edit3.Text);
Form1.MultI:=StrtoInt(Form2.Edit4.Text);
Form1.ReadTopo:=Checkbox1.checked;
Form1.ReadCurrent:=Checkbox2.checked;
end;

procedure TForm2.CheckBox4Click(Sender: TObject);
begin
if Checkbox4.Checked then
  begin
//    Checkbox4.Checked:=False;
    Form1.CheckBox2.Checked:=True;
  end
else
  begin
//  Checkbox4.Checked:=True;
  Form1.CheckBox2.Checked:=False;
  end;
end;

end.
