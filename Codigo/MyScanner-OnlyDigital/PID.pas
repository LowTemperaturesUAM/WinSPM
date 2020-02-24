unit PID;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, math, ExtCtrls, ThdTimer;

type
  TFormPID = class(TForm)
    CheckBox1: TCheckBox;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SpinEdit3: TSpinEdit;
    Label4: TLabel;
    Label5: TLabel;
    ScrollBar1: TScrollBar;
    Label6: TLabel;
    Label7: TLabel;
    ScrollBar2: TScrollBar;
    Label8: TLabel;
    Label9: TLabel;
    ScrollBar3: TScrollBar;
    Label10: TLabel;
    Label11: TLabel;
    ScrollBar4: TScrollBar;
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
    procedure SpinEdit3Change(Sender: TObject);
    procedure ScrollBar1Change(Sender: TObject);
    procedure ScrollBar2Change(Sender: TObject);
    procedure ScrollBar3Change(Sender: TObject);
    procedure ScrollBar4Change(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure SpinEdit2Change(Sender: TObject);
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
    procedure Gain_IChange(Sender: TObject);
    procedure Gain_DChange(Sender: TObject);
    procedure thrdtmr1Timer(Sender: TObject);
    procedure se1Change(Sender: TObject);
 private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPID: TFormPID;
  InPID_ADC,OutPID_DAC: Integer;
  Gain,Gain_of_I,Gain_of_D: Double;
  P_PID,I_PID,D_PID,MeanReadI: Integer;
  Set_PID, Read_PID, Action_PID,Count_Live, reverse : Integer;
  lastIntegral : Extended; // Valor del error acumulado (para el parámetro I).
  Check_Show,Flag_PIDisworking,PIDReset: Boolean;
  previous_ctrl:  Double;

implementation

uses DataAdcquisition, Scanner1, Config1;

{$R *.DFM}

procedure TFormPID.SpinEdit3Change(Sender: TObject);
begin
  TryStrToFloat(SpinEdit3.Text, Gain);
  Gain:=power(10,Gain);
end;

procedure TFormPID.ScrollBar1Change(Sender: TObject);
begin
P_PID:=ScrollBar1.Position;
Label6.Caption:=InttoStr(ScrollBar1.Position);
end;

procedure TFormPID.ScrollBar2Change(Sender: TObject);
begin
I_PID:=ScrollBar2.Position;
Label8.Caption:=InttoStr(ScrollBar2.Position);
end;

procedure TFormPID.ScrollBar3Change(Sender: TObject);
begin
D_PID:=ScrollBar3.Position;
Label10.Caption:=InttoStr(ScrollBar3.Position);
end;

procedure TFormPID.ScrollBar4Change(Sender: TObject);
begin
Set_PID:=ScrollBar4.Position;
Label12.Caption:=InttoStr(ScrollBar4.Position);
end;

procedure TFormPID.CheckBox1Click(Sender: TObject);
begin
Check_Show:=CheckBox1.checked;
end;

procedure TFormPID.FormShow(Sender: TObject);
begin
Check_Show:=CheckBox1.checked;
Set_PID:=ScrollBar4.Position;
Label12.Caption:=InttoStr(ScrollBar4.Position);
D_PID:=ScrollBar3.Position;
Label10.Caption:=InttoStr(ScrollBar3.Position);
I_PID:=ScrollBar2.Position;
Label8.Caption:=InttoStr(ScrollBar2.Position);
Gain:=Power(10,SpinEdit3.Value);
Gain_of_I:=Power(10,Gain_I.Value);
Gain_of_D:=Power(10,Gain_D.Value);
P_PID:=ScrollBar1.Position;
Label6.Caption:=InttoStr(ScrollBar1.Position);
InPID_ADC:=SpinEdit1.Value;
OutPID_DAC:=SpinEdit2.Value;
if checkbox2.checked then reverse:=1 else reverse:=-1;
//PIDReset:=True; // Mejor que resetee la primera vez, para que inicialice todos los acumuladores
MeanReadI:=SpinEdit5.Value;
//previous_ctrl:=0;
Count_Live:= FormPID.SpinEdit4.Value;

// Activamos el hilo que hará el control cuando se habilite su flag
thrdtmr1.Enabled:=True;
end;

procedure TFormPID.SpinEdit1Change(Sender: TObject);
begin
  TryStrToInt(SpinEdit1.Text, InPID_ADC);
end;

procedure TFormPID.SpinEdit2Change(Sender: TObject);
begin
  TryStrToInt(SpinEdit2.Text, OutPID_DAC);
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
    if (PIDReset) then
    begin
      prevError:=0;
      lastIntegral:=0;
      PIDReset:=False;
    end;

    //Application.ProcessMessages(); //Hermann

    Read_PID := abs(Round(Form10.adc_take(InPID_ADC,InPID_ADC,MeanReadI)*32768));
    thisError := (Set_PID/500*32768)-Read_PID;
    lastIntegral := lastIntegral+thisError; // Siendo formales, habría que multiplicar thisError por dt. Hermann prefiere no hacerlo.
    Action_PID := Action_PID+reverse*Round((Gain*P_PID/100)*thisError + (Gain*Gain_of_I*I_PID/100)*(lastIntegral) + (Gain*Gain_of_D*D_PID/100)*(thisError-prevError));
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

  if (Check_Show and updateUI) then
  begin
    Label4.Caption:=InttoStr(Read_PID);
    Label5.Caption:=InttoStr(Action_PID);
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
end;

end.
