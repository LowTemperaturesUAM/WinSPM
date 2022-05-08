unit PID;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, math, ExtCtrls, ThdTimer;

type
  TFormPID = class(TForm)
    chkShowValues: TCheckBox;
    spinPID_In: TSpinEdit;
    spinPID_Out: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Gain_P: TSpinEdit;
    lblInValue: TLabel;
    lblOutValue: TLabel;
    scrlbrP: TScrollBar;
    lblPValue: TLabel;
    Label7: TLabel;
    scrlbrI: TScrollBar;
    lblIValue: TLabel;
    Label9: TLabel;
    scrlbrD: TScrollBar;
    lblDValue: TLabel;
    Label11: TLabel;
    scrlbrSetPoint: TScrollBar;
    Label12: TLabel;
    Label13: TLabel;
    CheckBox2: TCheckBox;
    Label14: TLabel;
    SpinEdit4: TSpinEdit;
    Button3: TButton;
    Label15: TLabel;
    Label16: TLabel;
    SpinEdit5: TSpinEdit;
    Label17: TLabel;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Label19: TLabel;
    Button8: TButton;
    Button9: TButton;
    Gain_I: TSpinEdit;
    Gain_D: TSpinEdit;
    thrdtmr1: TThreadedTimer;
    se1: TSpinEdit;
    lbl1: TLabel;
    Button1: TButton;
    SpinEdit6: TSpinEdit;
    lblCurrentLabel: TLabel;
    lblCurrentSetPoint: TLabel;
    procedure chkShowValuesClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure spinPID_InChange(Sender: TObject);
    procedure spinPID_OutChange(Sender: TObject);
    procedure SpinEdit4Change(Sender: TObject);
    procedure CheckBox2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure SpinEdit5Change(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    function Controla(NumberC: Integer; prevError: Double; updateUI: Boolean) : Double;
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure scrlbrPChange(Sender: TObject);
    procedure scrlbrIChange(Sender: TObject);
    procedure scrlbrDChange(Sender: TObject);
    procedure scrlbrSetPointChange(Sender: TObject);
    procedure Gain_PChange(Sender: TObject);
    procedure Gain_IChange(Sender: TObject);
    procedure Gain_DChange(Sender: TObject);
    procedure thrdtmr1Timer(Sender: TObject);
    procedure se1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
 private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPID: TFormPID;
  InPID_ADC,OutPID_DAC: Integer;
  showValues, showInterval: Integer;
  Gain,Gain_of_I,Gain_of_D: Double;
  P_PID,I_PID,D_PID,MeanReadI: Integer;
  Set_PID, Read_PID, Action_PID,Count_Live, reverse : Integer;
  lastIntegral : Extended; // Valor del error acumulado (para el parámetro I).
  Check_Show,Flag_PIDisworking,PIDReset: Boolean;
  previous_ctrl:  Double;

implementation

uses DataAdcquisition, Scanner1, Config1;

{$R *.DFM}

procedure TFormPID.chkShowValuesClick(Sender: TObject);
begin
Check_Show:=chkShowValues.checked;
end;

procedure TFormPID.FormShow(Sender: TObject);
begin
FormPID.DoubleBuffered := True; //Evitamos parpadeos con In y Out
Check_Show:=chkShowValues.checked;
Set_PID:=scrlbrSetPoint.Position;
Label12.Caption:=InttoStr(scrlbrSetPoint.Position);
D_PID:=scrlbrD.Position;
lblDValue.Caption:=InttoStr(scrlbrD.Position);
I_PID:=scrlbrI.Position;
lblIValue.Caption:=InttoStr(scrlbrI.Position);
Gain:=Power(10,Gain_P.Value);
Gain_of_I:=Power(10,Gain_I.Value);
Gain_of_D:=Power(10,Gain_D.Value);
P_PID:=scrlbrP.Position;
lblPValue.Caption:=InttoStr(scrlbrP.Position);
InPID_ADC:=spinPID_In.Value;
OutPID_DAC:=spinPID_out.Value;
if checkbox2.checked then reverse:=1 else reverse:=-1;
//PIDReset:=True; // Mejor que resetee la primera vez, para que inicialice todos los acumuladores
MeanReadI:=SpinEdit5.Value;
//previous_ctrl:=0;
Count_Live:= FormPID.SpinEdit4.Value;

if (InPID_ADC = ScanForm.ADCI) then
  begin
  lblCurrentLabel.Visible := True;
  lblCurrentSetPoint.Visible := True;
  lblCurrentSetPoint.Caption :=Format('%2.2f',[scrlbrSetPoint.Position/scrlbrSetPoint.Max * 2 *1e9* ScanForm.AmpI] );
  end
else
  begin
  lblCurrentLabel.Visible := False;
  lblCurrentSetPoint.Visible := False;
  end;


// Activamos el hilo que hará el control cuando se habilite su flag
thrdtmr1.Enabled:=True;
//Limitamos el numero de veces que actualizamos los valores de In y Out
showValues:=0;
showInterval:=51;
end;

procedure TFormPID.spinPID_InChange(Sender: TObject);
begin
  TryStrToInt(spinPID_In.Text, InPID_ADC);
  if (InPID_ADC = ScanForm.ADCI) then
  begin
  lblCurrentLabel.Visible := True;
  lblCurrentSetPoint.Visible := True;
  lblCurrentSetPoint.Caption :=Format('%2.2f',[scrlbrSetPoint.Position/scrlbrSetPoint.Max * 2 *1e9* ScanForm.AmpI]);
  end
  else
  begin
  lblCurrentLabel.Visible := False;
  lblCurrentSetPoint.Visible := False;
  end;

end;

procedure TFormPID.spinPID_OutChange(Sender: TObject);
begin
  TryStrToInt(spinPID_out.Text, OutPID_DAC);
end;

procedure TFormPID.SpinEdit4Change(Sender: TObject);
begin
  TryStrToInt(SpinEdit4.Text, Count_Live);
end;

procedure TFormPID.CheckBox2Click(Sender: TObject);
begin
if checkbox2.checked then reverse:=1 else reverse:=-1;
end;

procedure TFormPID.Button3Click(Sender: TObject);
begin
PIDReset:=True;
end;

procedure TFormPID.SpinEdit5Change(Sender: TObject);
begin
  TryStrToInt(SpinEdit5.Text, MeanReadI);
end;

procedure TFormPID.Button4Click(Sender: TObject);
begin
SpinEdit5.Value:=SpinEdit5.Value*10;
MeanReadI:=SpinEdit5.Value;
end;

procedure TFormPID.Button5Click(Sender: TObject);
begin
if (Round(SpinEdit5.Value/10)>0) then SpinEdit5.Value:=Round(SpinEdit5.Value/10)
else SpinEdit5.Value:=1;
MeanReadI:=SpinEdit5.Value;
end;

procedure TFormPID.Button6Click(Sender: TObject);
begin
SpinEdit4.Value:=SpinEdit4.Value*10;
Count_Live:=SpinEdit4.Value;
end;

procedure TFormPID.Button7Click(Sender: TObject);
begin
if (Round(SpinEdit4.Value/10)>0) then SpinEdit4.Value:=Round(SpinEdit4.Value/10)
else SpinEdit4.Value:=1;
Count_Live:=SpinEdit4.Value;
end;

function TFormPID.Controla(NumberC: Integer; prevError: Double; updateUI: Boolean) : Double;
var
i: LongInt;
thisError: Double;

begin

  if (Flag_PIDisworking = False) then
  begin
    Result := 0;
    Exit;
  end;

  //if Timer1.Enabled = False then // No debería pasar, pero por si acaso
//    if thrdtmr1.Enabled = False then // No debería pasar, pero por si acaso
//    Exit;


  i:=0;
  while (i<NumberC) do
  begin
    if (PIDReset) then //no podemos hacer esto antes del bucle y ya esta?
    begin
      prevError:=0;
      lastIntegral:=0;
      PIDReset:=False;
      Action_PID:=0; //Asi podemos poner a cero otra vez el control
    end;

    //Application.ProcessMessages(); //Hermann

    Read_PID := abs(Round(Form10.adc_take(InPID_ADC,InPID_ADC,MeanReadI)*32768));
    thisError := (Set_PID/1000*32768)-Read_PID;
    lastIntegral := lastIntegral+thisError/1000; // Siendo formales, habría que multiplicar thisError por dt. Hermann prefiere no hacerlo.
    // Es que podríamos ponerlo, pero dt va a ser casi siempre 0.001 s, por lo que es un factor multiplicativo un tanto arbitrario, pongo 1000, también en la derivada
    Action_PID := Action_PID+reverse*Round((Gain*P_PID/100)*thisError + (Gain_of_I*I_PID/100)*(lastIntegral) + (Gain_of_D*D_PID/100)*(thisError-prevError)*1000);
    if (Action_PID>32768) then
    begin
      Action_PID:=32768;
    end;
    if (Action_PID<-32768) then
    begin
      Action_PID:=-32768;
    end;

    Form10.dac_set(OutPID_DAC,Action_PID, nil);
    prevError:=thisError;
    i:=i+1;
  end;

  //Representamos los valores con menor periodicidad que el timer
  showValues:=showValues +1;
  if ((Check_Show and updateUI) and (showValues = showInterval))  then
  begin
    lblInValue.Caption:=InttoStr(Read_PID);
    lblOutValue.Caption:=InttoStr(Action_PID);
    showValues := 0;
  end;

  Result:=prevError;
end;



procedure TFormPID.Button8Click(Sender: TObject);
begin
//Timer1.Enabled:=True;
//thrdtmr1.Enabled:=True;
Flag_PIDisworking := True;
end;

procedure TFormPID.Button9Click(Sender: TObject);
begin
//Timer1.Enabled:=False;
//thrdtmr1.Enabled:=False;
Flag_PIDisworking := False;
end;

procedure TFormPID.Timer1Timer(Sender: TObject);
begin
  previous_ctrl:=FormPID.Controla(Count_Live,previous_ctrl, True);
end;

procedure TFormPID.scrlbrPChange(Sender: TObject);
begin
P_PID:=scrlbrP.Position;
lblPValue.Caption:=InttoStr(scrlbrP.Position);
end;

procedure TFormPID.scrlbrIChange(Sender: TObject);
begin
I_PID:=scrlbrI.Position;
lblIValue.Caption:=InttoStr(scrlbrI.Position);
end;

procedure TFormPID.scrlbrDChange(Sender: TObject);
begin
D_PID:=scrlbrD.Position;
lblDValue.Caption:=InttoStr(scrlbrD.Position);
end;

procedure TFormPID.scrlbrSetPointChange(Sender: TObject);
begin
Set_PID:=scrlbrSetPoint.Position;
Label12.Caption:=InttoStr(scrlbrSetPoint.Position);
if (InPID_ADC = ScanForm.ADCI) then
  begin
  lblCurrentLabel.Visible := True;
  lblCurrentSetPoint.Visible := True;
  //Conversion a corriente en nA:
  //El valor del ADC va entre +-1 y la amplificacion nos cambia este valor a Amperios.
  //El SetPoint corresponde con una fraccion de los valores del ADC (SetPoint/Max)
  lblCurrentSetPoint.Caption :=Format('%2.2f',[scrlbrSetPoint.Position/scrlbrSetPoint.Max * 2 *1e9* ScanForm.AmpI] );
  end
else
  begin
  lblCurrentLabel.Visible := False;
  lblCurrentSetPoint.Visible := False;
  end
end;
procedure TFormPID.Gain_PChange(Sender: TObject);
begin
  TryStrToFloat(Gain_P.Text, Gain);
  Gain:=power(10,Gain);
end;

procedure TFormPID.Gain_IChange(Sender: TObject);
begin
  TryStrToFloat(Gain_I.Text, Gain_of_I);
  Gain_of_I:=power(10,Gain_of_I);
end;

procedure TFormPID.Gain_DChange(Sender: TObject);
begin
  TryStrToFloat(Gain_D.Text, Gain_of_D);
  Gain_of_D:=power(10,Gain_of_D);
end;

procedure TFormPID.thrdtmr1Timer(Sender: TObject);
begin
  previous_ctrl:=FormPID.Controla(Count_Live,previous_ctrl, True);
end;

procedure TFormPID.se1Change(Sender: TObject);
  var temp64 : Int64; // Temporalmente 64 bits para no perder precisión
begin
  TryStrToInt64(se1.Text, temp64);
  thrdtmr1.Interval := temp64;
  Application.ProcessMessages;
  //Vamos a limitarlo a 5Hz (200ms) para representarlo.
  //Ponemos un numero de intervalos que no acabe en cero, para que todas las cifras cambien y no parezca raro
  if temp64=0 then showInterval:=403
  else showInterval:=Round(51/temp64);
  showValues:=0;

end;

procedure TFormPID.Button1Click(Sender: TObject);
var
 Past,TickTime: longint;

 begin
 TickTime:=SpinEdit6.Value;
 Past := GetTickCount;
 repeat
 application.ProcessMessages;
 Until (GetTickCount - Past) >= TickTime;
end;



end.
