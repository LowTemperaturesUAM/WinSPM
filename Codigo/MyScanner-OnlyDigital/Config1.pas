unit Config1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Spin, Math, IniFiles, Buttons, ComCtrls;

type
  TFormConfig = class(TForm)
    ScanPanel: TPanel;
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
    ReadPanel: TPanel;
    ReadTitle: TLabel;
    TopoChanLbl: TLabel;
    TopoChanEdit: TSpinEdit;
    TopoAmpLbl: TLabel;
    TopoAmpBox: TComboBox;
    TopoCheck: TCheckBox;
    TopoCalLbl: TLabel;
    TopoCalEdit: TEdit;
    CurrentCheck: TCheckBox;
    CurrentChanLbl: TLabel;
    CurrentChanEdit: TSpinEdit;
    CurrentAmpLbl: TLabel;
    CurrentAmpBox: TComboBox;
    CurrentMultLbl: TLabel;
    CurrentMultEdit: TEdit;
    OtherChanLbl: TLabel;
    OtherAmpLbl: TLabel;
    OtherMultLbl: TLabel;
    OtherCheck: TCheckBox;
    OtherChanEdit: TSpinEdit;
    OtherAmpBox: TComboBox;
    OtherMultEdit: TEdit;
    MakeIVCheck: TCheckBox;
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
    UpdateCfg: TSpeedButton;
    LHAVersionSel: TComboBox;
    LHAVerLbl: TLabel;
    PosSpeedBar: TTrackBar;
    SpeedLbl: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure MakeIVCheckClick(Sender: TObject);
    procedure SaveCfgClick(Sender: TObject);
    procedure UpdateCfgClick(Sender: TObject);
    procedure LHAVersionSelChange(Sender: TObject);
    procedure PosSpeedBarChange(Sender: TObject);
  private
    { Private declarations }
    IniFile: TMemIniFile;
    iniTitle: AnsiString;
    iniLiner: AnsiString;
    iniTrip: AnsiString;
    iniPID: AnsiString;
    iniRev: AnsiString;

//    const string iniTitle := 'Channels';
  public
    //LHARev: Byte;
    ConfigDir: String;

  end;

var
  FormConfig: TFormConfig;

implementation

uses Scanner1, DataAdcquisition, Liner,Config_Liner, Config_Trip, PID;

{$R *.DFM}

procedure TFormConfig.FormClose(Sender: TObject; var Action: TCloseAction);
begin
UpdateCfgClick(nil);
end;

procedure TFormConfig.FormCreate(Sender: TObject);
begin
// Leemos los datos del fichero de configuración
iniTitle := 'Channels';
iniLiner := 'Liner';
iniTrip := 'Trip';
iniPID := 'PID';
iniRev := 'Hardware Information';
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
  TopoChanEdit.Value := IniFile.ReadInteger(String(iniTitle), 'TopoAdc', 2);
  TopoAmpBox.Text := IniFile.ReadString(String(iniTitle), 'TopoAmp', '13');
  TopoCalEdit.Text := IniFile.ReadString(String(iniTitle), 'TopoCalibration', '1');
  CurrentChanEdit.Value := IniFile.ReadInteger(String(iniTitle), 'CurrentAdc', 0);
  CurrentAmpBox.Text := IniFile.ReadString(String(iniTitle), 'CurrentAmp', '8');
  CurrentMultEdit.Text := IniFile.ReadString(String(iniTitle), 'CurrentMult', '-1');
  //Incluyo los parametros para una tercera entrada pero hay que activarla manualmente
  OtherChanEdit.Value := IniFile.ReadInteger(String(iniTitle), 'OtherAdc', 1);
  OtherAmpBox.Text := IniFile.ReadString(String(iniTitle), 'OtherAmp', '9');
  OtherMultEdit.Text := IniFile.ReadString(String(iniTitle), 'OtherMult', '1');
  //Parametros de Liner
  LinerConfig.SpinEdit1.Value := IniFile.ReadInteger(String(iniLiner), 'IVRampDac', 5);
  LinerConfig.ReverseCheck.Checked := IniFile.ReadBool(String(iniLiner), 'IVReverseDac', False);
  LinerConfig.seADCxaxis.Value := IniFile.ReadInteger(String(iniLiner), 'IVReadAdc', 0);
  LinerConfig.xDACMultiplier.Text := IniFile.ReadString(String(iniLiner), 'IVMult', '10');
  LinerConfig.xDACMultiplierChange(nil);
  LinerForm.Show; //Refrescamos la ventana del liner
  //xAxisRange.Caption:=IntToStr(scrollSizeBias.Position);
  //Cambiamos las unidades del liner acorde a los parametros obtenidos
  if (LinerForm.x_axisDac = 6) and (LinerForm.x_axisMult<>0) then //assume this is the Bias DAC by default
  begin
    if LinerForm.x_axisMult<1 then //mV
    begin
      if LinerConfig.ReverseCheck.Checked then
      LinerForm.xAxisRange.Caption:=Format('%.3g mV', [LinerForm.x_axisMult*-1e3])
      else LinerForm.xAxisRange.Caption:=Format('%.3g mV', [LinerForm.x_axisMult*1e3]);
    end
    else LinerForm.xAxisRange.Caption:=Format('%.3g V', [LinerForm.x_axisMult]);
  end
  else LinerForm.xAxisRange.Caption:=IntToStr(LinerForm.scrollSizeBias.Position);
  //En principio es mejor no cambiar este valor por defecto y solo cambiarlo manualmente
  //Podriamos leer un valor por defecto para las curvas reducidas pero que haya que marcar la casilla manualmente
  //LinerConfig.seReduceRampFactor.Value := IniFile.ReadInteger(String(iniLiner)), 'ReduceRamp', 1);

  //Parametros de Trip
  TripConfig.OutDacEdit.Value := IniFile.ReadInteger(String(iniTrip), 'CoarseDac', 4);
  TripConfig.InADCEdit.Value := CurrentChanEdit.Value;
  TripConfig.spinCurrentLimit.Value := IniFile.ReadInteger(String(iniTrip), 'CurrentLim', 50);
  TripConfig.InvertZPChk.Checked := IniFile.ReadBool(String(iniTrip), 'ZPInverse', False);
  TripConfig.InvertCurChk.Checked := IniFile.ReadBool(String(iniTrip), 'CurrentInverse', False);
  //Parametros PID
  FormPID.spinPID_In.Value := CurrentChanEdit.Value;
  FormPID.spinPID_Out.Value := IniFile.ReadInteger(String(iniPID), 'OutputDac', 6);
  FormPID.ReversePIDChk.Checked := IniFile.ReadBool(String(iniPID), 'PIDReverseOut', True);
  //Informatcion sobre la version de la electronica LHA, devolvemos 0 si no se indica
  ScanForm.LHARev := TLHARev(IniFile.ReadInteger(String(iniRev), 'Revision', 0));
finally
  IniFile.Free;
end;


ScanForm.XDAC:=SpinEdit1.Value;
ScanForm.YDAC:=SpinEdit2.Value;
ScanForm.AmpX:=StrtoFloat(Combobox1.Text);
ScanForm.AmpY:=StrtoFloat(Combobox2.Text);
ScanForm.CalX:=StrtoFloat(Edit1.Text);
ScanForm.CalY:=StrtoFloat(Edit2.Text);
ScanForm.ADCTopo:=TopoChanEdit.Value;
ScanForm.ADCI:=CurrentChanEdit.Value;
ScanForm.AmpTopo:=StrtoFloat(TopoAmpBox.Text);
ScanForm.AmpI:=power(10,-1*(StrtoFloat(CurrentAmpBox.Text)-1));
ScanForm.CalTopo:=StrtoFloat(TopoCalEdit.Text);
ScanForm.MultI:=StrtoInt(CurrentMultEdit.Text);
ScanForm.ReadTopo:=TopoCheck.checked;
ScanForm.ReadCurrent:=CurrentCheck.checked;

//añadido para poder leer other
//ScanForm.ReadOther:=OtherCheck.checked;
ScanForm.ADCOther:=OtherChanEdit.Value;
ScanForm.AmpOther:=power(10,-1*(StrtoFloat(OtherAmpBox.Text)-1));
ScanForm.MultOther:=StrtoInt(OtherMultEdit.Text);

// Inicializamos los atenuadores al abrir el programa
// Los atenuadores fucionan correctamente cuando cerramos el config, pero no al inicial el programa
//if ScanForm.Versiondivider=False then DataForm.set_attenuator(0,1)
//  else
//  begin
//       DataForm.set_attenuator(1,1);
//       DataForm.set_attenuator(2,1);
//       DataForm.set_attenuator(3,1);
//       DataForm.set_attenuator(4,1);
//  end;

// Comprobamos si la revision indicada es valida o no
// Si no, preguntamos al usuario
if (ScanForm.LHARev <revB) or (ScanForm.LHARev > revE) then
  begin
    if Application.MessageBox('LHA Version with 4 attenuators?','LHA version', MB_YESNO)=IDYES
    then
      begin
         //ScanForm.VersionDivider:=True;
         if Application.MessageBox('LHA Version uses 16bit attenuators?','Attenuator bits', MB_YESNO)=IDYES
         then ScanForm.LHARev := revD
         else ScanForm.LHARev := revE;
      end
    else
      begin
           //ScanForm.VersionDivider:=False;
           ScanForm.LHARev := revB;
      end;
end;

case ScanForm.LHARev of
  revB..revC: begin //LHA rev B y C. Atenuadores solo en los Canales 0 y 2
    DataForm.set_attenuator(0,1);
    DataForm.z_attenuator := 1;
    DataForm.bias_attenuator := 1;
    LHAVersionSel.ItemIndex := 0;
    //DataForm.scan_attenuator:=1;
    //DataForm.bias_attenuator:=1;
  end;
  revD: begin //LHA rev D. Añade tambien atenuadores a los canales 5 y 6
    DataForm.set_attenuator(1,1);
    DataForm.set_attenuator(2,1);
    DataForm.set_attenuator(3,1);
    DataForm.set_attenuator(4,1);
    LHAVersionSel.ItemIndex := 1;
    //DataForm.scan_attenuator:=1;
    //DataForm.bias_attenuator:=1;
  end;
  revE: begin //LHA version 14bits. Mismos atenuadores que rev D pero con 14bits
    DataForm.set_attenuator_14b(1,1);
    DataForm.set_attenuator_14b(2,1);
    DataForm.set_attenuator_14b(3,1);
    DataForm.set_attenuator_14b(4,1);
    LHAVersionSel.ItemIndex := 2;
    //DataForm.scan_attenuator:=1;
    //DataForm.bias_attenuator:=1;
  end;
end;
LinerConfig.Show;
LinerForm.Show; //Refrescamos la ventana del liner para que aparezca lo de los atenuadores

end;

procedure TFormConfig.SaveCfgClick(Sender: TObject);
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
  IniFile.WriteInteger(String(iniTitle), 'TopoAdc', TopoChanEdit.Value);
  IniFile.WriteString(String(iniTitle), 'TopoAmp', TopoAmpBox.Text);
  IniFile.WriteString(String(iniTitle), 'TopoCalibration', TopoCalEdit.Text);
  IniFile.WriteInteger(String(iniTitle), 'CurrentAdc', CurrentChanEdit.Value);
  IniFile.WriteString(String(iniTitle), 'CurrentAmp', CurrentAmpBox.Text);
  IniFile.WriteString(String(iniTitle), 'CurrentMult', CurrentMultEdit.Text);
  IniFile.WriteInteger(String(iniTitle), 'OtherAdc', OtherChanEdit.Value);
  IniFile.WriteString(String(iniTitle), 'OtherAmp', OtherAmpBox.Text);
  IniFile.WriteString(String(iniTitle), 'OtherMult', OtherMultEdit.Text);
  //Parametros de Liner
  IniFile.WriteInteger(String(iniLiner), 'IVRampDac', LinerConfig.SpinEdit1.Value);
  IniFile.WriteBool(String(iniLiner), 'IVReverseDac', LinerConfig.ReverseCheck.Checked);
  IniFile.WriteInteger(String(iniLiner), 'IVReadAdc', LinerConfig.seADCxaxis.Value);
  IniFile.WriteString(String(iniLiner), 'IVMult', LinerConfig.xDACMultiplier.Text);
  //Parametros de Trip
  IniFile.WriteInteger(String(iniTrip), 'CoarseDac', TripConfig.OutDacEdit.Value);
  IniFile.WriteInteger(String(iniTrip), 'CurrentLim', TripConfig.spinCurrentLimit.Value);
  IniFile.WriteBool(String(iniTrip), 'ZPInverse', TripConfig.InvertZPChk.Checked);
  IniFile.WriteBool(String(iniTrip), 'CurrentInverse', TripConfig.InvertCurChk.Checked);
  //Parametros PID
  IniFile.WriteInteger(String(iniPID), 'OutputDac', FormPID.spinPID_Out.Value);
  IniFile.WriteBool(String(iniPID), 'PIDReverseOut', FormPID.ReversePIDChk.Checked);
  //Si la revision contiene un valor valido, la escribimos
  if (ScanForm.LHARev >= revB ) and (ScanForm.LHARev <= revE) then
  IniFile.WriteInteger(String(iniRev), 'Revision', Ord(ScanForm.LHARev));
finally
  IniFile.UpdateFile;
  IniFile.Free;
end;
end;

procedure TFormConfig.MakeIVCheckClick(Sender: TObject);
begin
  ScanForm.MakeIVChk.Checked:=MakeIVCheck.Checked;
end;

procedure TFormConfig.UpdateCfgClick(Sender: TObject);
begin
ScanForm.XDAC:=SpinEdit1.Value;
ScanForm.YDAC:=SpinEdit2.Value;
ScanForm.XDAC_Pos:=SpinEdit6.Value;
ScanForm.YDAC_Pos:=SpinEdit7.Value;
ScanForm.AmpX:=StrtoFloat(Combobox1.Text);
ScanForm.AmpY:=StrtoFloat(Combobox2.Text);
ScanForm.CalX:=StrtoFloat(Edit1.Text);
ScanForm.CalY:=StrtoFloat(Edit2.Text);
ScanForm.ADCTopo:=TopoChanEdit.Value;
ScanForm.ADCI:=CurrentChanEdit.Value;
ScanForm.AmpTopo:=StrtoFloat(TopoAmpBox.Text);
//La amplificacion introducida es en V que va entre +-10, pero el valor que leemos de los ADC es entre +-1, asi que restamos 1
ScanForm.AmpI:=power(10,-1*(StrtoFloat(CurrentAmpBox.Text)-1));
ScanForm.CalTopo:=StrtoFloat(TopoCalEdit.Text);
ScanForm.MultI:=StrtoInt(CurrentMultEdit.Text);
ScanForm.ReadTopo:=TopoCheck.checked;
ScanForm.ReadCurrent:=CurrentCheck.checked;

//añadido para poder leer other
ScanForm.ReadOther:=OtherCheck.checked;
ScanForm.ADCOther:=OtherChanEdit.Value;
ScanForm.AmpOther:=power(10,-1*(StrtoFloat(OtherAmpBox.Text)-1));
ScanForm.MultOther:=StrtoInt(OtherMultEdit.Text);

// Si está activo el atenuador, el efecto será el mismo que bajar las ganancias de los amplificadores un factor 10
if (chkAttenuator.Checked) then
  begin
    case ScanForm.LHARev of
    revB..revC: begin //LHA rev B y C. Atenuadores solo en los Canales 0 y 2
      DataForm.set_attenuator(0,0.1);
      //DataForm.scan_attenuator:=0.1;
    end;
    revD: begin //LHA rev D. Añade tambien atenuadores a los canales 5 y 6
      DataForm.set_attenuator(1,0.1);
      DataForm.set_attenuator(2,0.1);
      //DataForm.scan_attenuator:=0.1;
    end;
    revE: begin //LHA version 14bits. Mismos atenuadores que rev D pero con 14bits
      DataForm.set_attenuator_14b(1,0.1);
      DataForm.set_attenuator_14b(2,0.1);
      //DataForm.scan_attenuator:=0.1;
    end;
    end;
  end
else
  begin
    case ScanForm.LHARev of
    revB..revC: begin //LHA rev B y C. Atenuadores solo en los Canales 0 y 2
      DataForm.set_attenuator(0,1);
      //DataForm.scan_attenuator:=1;
    end;
    revD: begin //LHA rev D. Añade tambien atenuadores a los canales 5 y 6
      DataForm.set_attenuator(1,1);
      DataForm.set_attenuator(2,1);
      //DataForm.scan_attenuator:=1;
    end;
    revE: begin //LHA version 14bits. Mismos atenuadores que rev D pero con 14bits
      DataForm.set_attenuator_14b(1,1);
      DataForm.set_attenuator_14b(2,1);
      //DataForm.scan_attenuator:=1;
    end;
    end;
end;

ScanForm.TrackBar3Change(self);

if (FormPID.spinPID_In.Value  = ScanForm.ADCI) then
  begin
  FormPID.lblCurrentLabel.Visible := True;
  FormPID.lblCurrentSetPoint.Visible := True;
  //Conversion a corriente en nA:
  //El valor del ADC va entre +-1 y la amplificacion nos cambia este valor a Amperios.
  //El SetPoint corresponde con una fraccion de los valores del ADC (SetPoint/Max)
  FormPID.lblCurrentSetPoint.Caption :=Format('%2.2f',[FormPID.scrlbrSetPoint.Position/FormPID.scrlbrSetPoint.Max * 2 *1e9* ScanForm.AmpI] );
  end
else
  begin
  FormPID.lblCurrentLabel.Visible := False;
  FormPID.lblCurrentSetPoint.Visible := False;
  end;

end;



procedure TFormConfig.LHAVersionSelChange(Sender: TObject);
begin
  // Actualmente las revisiones disponibles son las siguientes, en este mismo orden:
  // rev B (LHARev :=1)
  // rev D (LHARev :=2)
  // rev D 14bit (LHARev :=3)
  // Podemos por tanto establecer el valor a partir del indice correspondiente
  ScanForm.LHARev := TLHArev(LHAVersionSel.ItemIndex+1);
  DataForm.InitDataAcq; //Inicializamos para que los atenuadores queden debidamente configurados
end;

procedure TFormConfig.PosSpeedBarChange(Sender: TObject);
begin
  ScanForm.P_Pos_Jump := PosSpeedBar.Position;
end;



end.
