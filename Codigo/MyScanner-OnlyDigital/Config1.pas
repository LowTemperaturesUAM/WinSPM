unit Config1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Spin, Math, IniFiles, Buttons;

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
    ComboBox2: TComboBox;
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
    Edit2: TEdit;
    SaveCfg: TSpeedButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure SaveCfgClick(Sender: TObject);
  private
    { Private declarations }
    IniFile: TMemIniFile;
    iniTitle: AnsiString;
    iniLiner: AnsiString;
    iniTrip: AnsiString;
    iniPID: AnsiString;
    ConfigDir: String;
//    const string iniTitle := 'Channels';
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses Scanner1, DataAdcquisition, Config_Liner, Config_Trip, PID;

{$R *.DFM}

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin
ScanForm.XDAC:=SpinEdit1.Value;
ScanForm.YDAC:=SpinEdit2.Value;
ScanForm.XDAC_Pos:=SpinEdit6.Value;
ScanForm.YDAC_Pos:=SpinEdit7.Value;
ScanForm.AmpX:=StrtoFloat(Combobox1.Text);
ScanForm.AmpY:=StrtoFloat(Combobox2.Text);
ScanForm.CalX:=StrtoFloat(Edit1.Text);
ScanForm.CalY:=StrtoFloat(Edit2.Text);
ScanForm.ADCTopo:=SpinEdit3.Value;
ScanForm.ADCI:=SpinEdit4.Value;
ScanForm.AmpTopo:=StrtoFloat(Combobox3.Text);
//Aqui hemos puesto un -1 al guardar la amplificacion
ScanForm.AmpI:=power(10,-1*(StrtoFloat(Form2.Combobox4.Text)-1)); //Le resto 1 a mano porque hay un factor 10 colgando por cómo se interpreta la lectura del adc
ScanForm.CalTopo:=StrtoFloat(Edit3.Text);
ScanForm.MultI:=StrtoInt(Edit4.Text);
ScanForm.ReadTopo:=Checkbox1.checked;
ScanForm.ReadCurrent:=Checkbox2.checked;

//añadido para poder leer other
ScanForm.ReadOther:=Checkbox3.checked;
ScanForm.ADCOther:=SpinEdit5.Value;
ScanForm.AmpOther:=StrtoFloat(ComboBox5.Text);
ScanForm.MultOther:=StrtoInt(Edit5.Text);

// Si está activo el atenuador, el efecto será el mismo que bajar las ganancias de los amplificadores un factor 10
if (chkAttenuator.Checked) then
begin
  if ScanForm.Versiondivider=False then Form10.set_attenuator(0,0.1)// ponemos 0, pero no lo usamos
  else
    begin
       Form10.set_attenuator(1,0.1);
       Form10.set_attenuator(2,0.1);
    end;
//  ScanForm.AmpX:= ScanForm.AmpX*0.1;
//  ScanForm.AmpY:= ScanForm.AmpY*0.1;
end
else
  begin
  if ScanForm.Versiondivider=False then Form10.set_attenuator(0,1)
  else
  begin
       Form10.set_attenuator(1,1);
       Form10.set_attenuator(2,1);
  end;
  end;
ScanForm.TrackBar3Change(self);


end;

procedure TForm2.FormCreate(Sender: TObject);
begin
// Leemos los datos del fichero de configuración
iniTitle := 'Channels';
iniLiner := 'Liner';
iniTrip := 'Trip';
iniPID := 'PID';
ConfigDir := GetCurrentDir;
IniFile := TMemIniFile.Create(ConfigDir+'\Config.ini');
try
  //Parametros de barrido
  SpinEdit1.Value := IniFile.ReadInteger(String(iniTitle), 'XScanDac', 0);
  SpinEdit2.Value := IniFile.ReadInteger(String(iniTitle), 'YScanDac', 2);
  Combobox1.Text := IniFile.ReadString(String(iniTitle), 'XYAmplifier', '13');
  Combobox2.Text := Combobox1.Text;
  SpinEdit6.Value := IniFile.ReadInteger(String(iniTitle), 'XPosDac', 1);
  SpinEdit7.Value := IniFile.ReadInteger(String(iniTitle), 'YPosDac', 3);
  Combobox6.Text := IniFile.ReadString(String(iniTitle), 'XYPosAmp', '13');
  Combobox7.Text := Combobox6.Text;
  Edit1.Text := IniFile.ReadString(String(iniTitle), 'XYCalibration', '5');
  Edit2.Text := Edit1.Text;
  //Parametros de topo y corriente
  SpinEdit3.Value := IniFile.ReadInteger(String(iniTitle), 'TopoAdc', 2);
  Combobox3.Text := IniFile.ReadString(String(iniTitle), 'TopoAmp', '13');
  Edit3.Text := IniFile.ReadString(String(iniTitle), 'TopoCalibration', '1');
  SpinEdit4.Value := IniFile.ReadInteger(String(iniTitle), 'CurrentAdc', 0);
  Combobox4.Text := IniFile.ReadString(String(iniTitle), 'CurrentAmp', '8');
  Edit4.Text := IniFile.ReadString(String(iniTitle), 'CurrentMult', '-1');
  //Incluyo los parametros para una tercera entrada pero hay que activarla manualmente
  SpinEdit5.Value := IniFile.ReadInteger(String(iniTitle), 'OtherAdc', 1);
  Combobox5.Text := IniFile.ReadString(String(iniTitle), 'OtherAmp', '9');
  Edit5.Text := IniFile.ReadString(String(iniTitle), 'OtherMult', '1');
  //Parametros de Liner
  Form7.SpinEdit1.Value := IniFile.ReadInteger(String(iniLiner), 'IVRampDac', 5);
  Form7.CheckBox4.Checked := IniFile.ReadBool(String(iniLiner), 'IVReverseDac', False);
  Form7.seADCxaxis.Value := IniFile.ReadInteger(String(iniLiner), 'IVReadAdc', 0);
  Form7.Edit1.Text := IniFile.ReadString(String(iniLiner), 'IVMult', '10');
  //En principio es mejor no cambiar este valor por defecto y solo cambiarlo manualmente
  //Podriamos leer un valor por defecto para las curvas reducidas pero que haya que marcar la casilla manualmente
  //Form7.seReduceRampFactor.Value := IniFile.ReadInteger(String(iniLiner)), 'ReduceRamp', 1);

  //Parametros de Trip
  Form6.SpinEdit1.Value := IniFile.ReadInteger(String(iniTrip), 'CoarseDac', 4);
  Form6.SpinEdit2.Value := SpinEdit4.Value;
  Form6.spinCurrentLimit.Value := IniFile.ReadInteger(String(iniTrip), 'CurrentLim', 50);
  Form6.CheckBox1.Checked := IniFile.ReadBool(String(iniTrip), 'ZPInverse', False);
  Form6.CheckBox2.Checked := IniFile.ReadBool(String(iniTrip), 'CurrentInverse', False);
  //Parametros PID
  FormPID.SpinEdit1.Value := SpinEdit4.Value;
  FormPID.SpinEdit2.Value := IniFile.ReadInteger(String(iniPID), 'OutputDac', 6);
  FormPID.CheckBox2.Checked := IniFile.ReadBool(String(iniPID), 'PIDReverseOut', True);
finally
  IniFile.Free;
end;


ScanForm.XDAC:=SpinEdit1.Value;
ScanForm.YDAC:=SpinEdit2.Value;
ScanForm.AmpX:=StrtoFloat(Combobox1.Text);
ScanForm.AmpY:=StrtoFloat(Combobox2.Text);
ScanForm.CalX:=StrtoFloat(Edit1.Text);
ScanForm.CalY:=StrtoFloat(Edit2.Text);
ScanForm.ADCTopo:=SpinEdit3.Value;
ScanForm.ADCI:=SpinEdit4.Value;
ScanForm.AmpTopo:=StrtoFloat(Form2.Combobox3.Text);
//Aqui no hemos puesto un -1 al guardar la amplificacion. Uno de los dos esta haciendolo de forma incorrecta
ScanForm.AmpI:=power(10,-1*StrtoFloat(Form2.Combobox4.Text));
ScanForm.CalTopo:=StrtoFloat(Form2.Edit3.Text);
ScanForm.MultI:=StrtoInt(Form2.Edit4.Text);
ScanForm.ReadTopo:=Checkbox1.checked;
ScanForm.ReadCurrent:=Checkbox2.checked;
end;

procedure TForm2.SaveCfgClick(Sender: TObject);
begin
// Guardamos los datos en el fichero de configuración
// Leemos los datos del fichero de configuración
// En esta version en necesario guardar el directorio de ejecucion
// porque si no el archivo de configuracion se guarda en el directorio de las topos
// y entonces los cambios que hagamos no se aplican para la proxima vez
IniFile := TMemIniFile.Create(ConfigDir+'\Config.ini');
try
  //Parametros de barrido
  IniFile.WriteInteger(String(iniTitle), 'XScanDac', SpinEdit1.Value);
  IniFile.WriteInteger(String(iniTitle), 'YScanDac', SpinEdit2.Value);
  IniFile.WriteString(String(iniTitle), 'XYAmplifier', Combobox1.Text);
  IniFile.WriteInteger(String(iniTitle), 'XPosDac', SpinEdit6.Value);
  IniFile.WriteInteger(String(iniTitle), 'YPosDac', SpinEdit7.Value);
  IniFile.WriteString(String(iniTitle), 'XYPosAmp', Combobox6.Text);
  IniFile.WriteString(String(iniTitle), 'XYCalibration', Edit1.Text);
  //Parametros de topo y corriente
  IniFile.WriteInteger(String(iniTitle), 'TopoAdc', SpinEdit3.Value);
  IniFile.WriteString(String(iniTitle), 'TopoAmp', Combobox3.Text);
  IniFile.WriteString(String(iniTitle), 'TopoCalibration', Edit3.Text);
  IniFile.WriteInteger(String(iniTitle), 'CurrentAdc', SpinEdit4.Value);
  IniFile.WriteString(String(iniTitle), 'CurrentAmp', Combobox4.Text);
  IniFile.WriteString(String(iniTitle), 'CurrentMult', Edit4.Text);
  IniFile.WriteInteger(String(iniTitle), 'OtherAdc', SpinEdit5.Value);
  IniFile.WriteString(String(iniTitle), 'OtherAmp', Combobox5.Text);
  IniFile.WriteString(String(iniTitle), 'OtherMult', Edit5.Text);
  //Parametros de Liner
  IniFile.WriteInteger(String(iniLiner), 'IVRampDac', Form7.SpinEdit1.Value);
  IniFile.WriteBool(String(iniLiner), 'IVReverseDac', Form7.CheckBox4.Checked);
  IniFile.WriteInteger(String(iniLiner), 'IVReadAdc', Form7.seADCxaxis.Value);
  IniFile.WriteString(String(iniLiner), 'IVMult', Form7.Edit1.Text);
  //Parametros de Trip
  IniFile.WriteInteger(String(iniTrip), 'CoarseDac', Form6.SpinEdit1.Value);
  IniFile.WriteInteger(String(iniTrip), 'CurrentLim', Form6.spinCurrentLimit.Value);
  IniFile.WriteBool(String(iniTrip), 'ZPInverse', Form6.CheckBox1.Checked);
  IniFile.WriteBool(String(iniTrip), 'CurrentInverse', Form6.CheckBox2.Checked);
  //Parametros PID
  IniFile.WriteInteger(String(iniPID), 'OutputDac', FormPID.SpinEdit2.Value);
  IniFile.WriteBool(String(iniPID), 'PIDReverseOut', FormPID.CheckBox2.Checked);
finally
  IniFile.UpdateFile;
  IniFile.Free;
end;
end;

procedure TForm2.CheckBox4Click(Sender: TObject);
begin
if Checkbox4.Checked then
  begin
//    Checkbox4.Checked:=False;
    ScanForm.CheckBox2.Checked:=True;
  end
else
  begin
//  Checkbox4.Checked:=True;
  ScanForm.CheckBox2.Checked:=False;
  end;
end;

end.
