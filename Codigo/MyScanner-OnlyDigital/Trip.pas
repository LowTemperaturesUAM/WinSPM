unit Trip;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, math;

type
  TTripForm = class(TForm)
    ApproachBtn: TButton;
    SeparateBtn: TButton;
    Separate100Btn: TButton;
    AutoApproachBtn: TButton;
    StepsEdit: TSpinEdit;
    SpeedBar: TScrollBar;
    SizeBar: TScrollBar;
    SpeedName: TLabel;
    SizeName: TLabel;
    ConfigBtn: TButton;
    SpeedLbl: TLabel;
    SizeLbl: TLabel;
    StopBtn: TButton;
    StepsLbl: TLabel;
    StepsDiv10Btn: TButton;
    StepsMul10Btn: TButton;
    procedure ConfigBtnClick(Sender: TObject);
    procedure SizeBarChange(Sender: TObject);
    procedure SpeedBarChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ApproachBtnClick(Sender: TObject);
    procedure StepsEditChange(Sender: TObject);
    procedure SeparateBtnClick(Sender: TObject);
    procedure Separate100BtnClick(Sender: TObject);
    procedure AutoApproachBtnClick(Sender: TObject);
    procedure StopBtnClick(Sender: TObject);
    procedure StepsDiv10BtnClick(Sender: TObject);
    procedure StepsMul10BtnClick(Sender: TObject);
    procedure SetMoving(moving: Boolean);
    procedure MakeSteps(numSteps, direction: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  Speed, Size, times, ZPDac, IADC, Mult, MultI: Integer;
  StopTrip: Boolean;
  // Cuidado con StopTrip, se está asignando varias veces en la aproximación automática.
  // Es poco probable pero podría darse el caso que una de estas asignaciones coincidiera con la pulsación del usuario para parar, lo machacase y no parara.
  end;

var
  TripForm: TTripForm;

implementation

uses Config_Trip, Liner, DataAdcquisition, Scanner1;


{$R *.DFM}

procedure TTripForm.ConfigBtnClick(Sender: TObject);
begin
TripConfig.Show;
end;

procedure TTripForm.SizeBarChange(Sender: TObject);
begin
Size:=SizeBar.Position;
SizeLbl.Caption:=InttoStr(Size);
end;

procedure TTripForm.SpeedBarChange(Sender: TObject);
begin
Speed:=SpeedBar.Position;
SpeedLbl.Caption:=InttoStr(Speed);
end;

procedure TTripForm.FormShow(Sender: TObject);
begin
TripConfig.Show;
Size:=SizeBar.Position;
Speed:=SpeedBar.Position;
times:=StepsEdit.Value;
TripConfig.Show;
ZPDAC:=TripConfig.OutDacEdit.Value;
IADC:=TripConfig.InADCEdit.Value;
if (TripConfig.InvertZPChk.checked) then Mult:=1 else Mult:=-1;
if (TripConfig.InvertCurChk.checked) then MultI:=1 else MultI:=-1;
TripConfig.Hide;
end;

procedure TTripForm.ApproachBtnClick(Sender: TObject);
begin
  SetMoving(true);
  MakeSteps(times, 1);
  SetMoving(false);
end;

procedure TTripForm.StepsEditChange(Sender: TObject);
begin
  //TryStrToInt(StepsEdit.Text, times);
  times := StepsEdit.Value;
end;

procedure TTripForm.SeparateBtnClick(Sender: TObject);
begin
  SetMoving(true);
  MakeSteps(times, -1);
  SetMoving(false);
end;

procedure TTripForm.Separate100BtnClick(Sender: TObject);
begin
  SetMoving(true);
  MakeSteps(100, -1);
  SetMoving(false);
end;

procedure TTripForm.AutoApproachBtnClick(Sender: TObject);
var
Strom_jetzt: Single;
punto_salida: boolean;

begin
//Esta para probar hay que asignarle un valor minimo de corriente a aprtir de la cual pare de moverse
//Strom_jetzt:=9;//adc_take(0,ADCI,ScanForm.P_Scan_Mean))
//StopTrip:=False;
  SetMoving(true);
  StopTrip:=False;
  punto_salida:=false;
  while (punto_salida=false) do
  begin
    Strom_jetzt:=  DataForm.adc_take(TripConfig.InADCEdit.Value,TripConfig.InADCEdit.Value,ScanForm.P_Scan_Mean);
    //Label7.caption:=Floattostr(Strom_jetzt);
    //times:=1000;
    while (abs(Strom_jetzt)<(TripConfig.spinCurrentLimit.Value/100)) and (StopTrip=False) do
    begin
      MakeSteps(times, 1);
      Strom_jetzt:=  DataForm.adc_take(TripConfig.InADCEdit.Value,TripConfig.InADCEdit.Value,ScanForm.P_Scan_Mean);
    end;
    punto_salida:=True;
    //times:=StepsEdit.Value;
  end;
  SetMoving(false);
end;

procedure TTripForm.StopBtnClick(Sender: TObject);
begin
  StopTrip:=True;
end;

procedure TTripForm.StepsDiv10BtnClick(Sender: TObject);
begin
  if (Round(StepsEdit.Value/10)>0) then
    StepsEdit.Value:=Round(StepsEdit.Value/10)
  else
    StepsEdit.Value:=1;
end;

procedure TTripForm.StepsMul10BtnClick(Sender: TObject);
begin
  StepsEdit.Value:=StepsEdit.Value*10;
end;

procedure TTripForm.SetMoving(moving: Boolean);
begin
  // Habilitamos o deshabilitamos los botones de movimiento que correspondan
  ApproachBtn.Enabled := not moving;
  SeparateBtn.Enabled := not moving;
  Separate100Btn.Enabled := not moving;
  AutoApproachBtn.Enabled := not moving;
  StopBtn.Enabled := moving; // Stop
end;


procedure TTripForm.MakeSteps(numSteps, direction: Integer);
var
i,j: SmallInt;
enviaZ: Integer;

begin
  StopTrip:=False;
  i:=0;
  while (i<numSteps) and (StopTrip=False) do
  begin
    for j:= 0 to 32767 do
    begin
      if Frac(j/Speed)=0 then
      begin
        enviaZ:=direction*Mult*Round(j*Size/10);
        DataForm.dac_set(ZPDac,enviaZ, nil);
      end;
    end;
    for j:= -32768 to 0 do
    begin
      if Frac(j/Speed)=0 then
      begin
        enviaZ:=direction*Mult*Round(j*Size/10);
        DataForm.dac_set(ZPDac,enviaZ, nil);
      end;
    end;
    Application.ProcessMessages;
    i:=i+1;
  end;
  DataForm.dac_set(ZPDac,0, nil);
end;

end.
