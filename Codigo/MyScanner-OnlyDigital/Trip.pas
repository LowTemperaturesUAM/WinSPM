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
    StepLabel: TLabel;
    StepsCount: TLabel;
    ResetCountBtn: TButton;
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
    procedure MakeStepsBuf(numSteps, direction: Integer);
    procedure ResetCountBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  Speed, Size, times, ZPDac, IADC, Mult, MultI: Integer;
  StopTrip: Boolean;
  TripMean: Integer;
  // Cuidado con StopTrip, se está asignando varias veces en la aproximación automática.
  // Es poco probable pero podría darse el caso que una de estas asignaciones coincidiera con la pulsación del usuario para parar, lo machacase y no parara.
  end;

var
  TripForm: TTripForm;
  TripBuffer: array [1..6554*12] of AnsiChar; //Maximum size for Speed =10 and 12 bytes per dac value
  TripSteps: Integer;
  //TripMean: Integer;
const
  OSRatio = 4;

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
TripForm.DoubleBuffered := True;
TripConfig.Show;
Size:=SizeBar.Position;
Speed:=SpeedBar.Position;
times:=StepsEdit.Value;
TripConfig.Show;
ZPDAC:=TripConfig.OutDacEdit.Value;
IADC:=TripConfig.InADCEdit.Value;
if (TripConfig.InvertZPChk.checked) then Mult:=1 else Mult:=-1;
if (TripConfig.InvertCurChk.checked) then MultI:=1 else MultI:=-1;
TripMean:=TripConfig.MeanSpin.Value;
TripConfig.Hide;
end;

procedure TTripForm.ApproachBtnClick(Sender: TObject);
begin
  SetMoving(true);
  MakeStepsBuf(times, 1);
  //MakeSteps(times, 1);
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
  MakeStepsBuf(times, -1);
  //MakeSteps(times, -1);
  SetMoving(false);
end;

procedure TTripForm.Separate100BtnClick(Sender: TObject);
begin
  SetMoving(true);
  MakeStepsBuf(100, -1);
  //MakeSteps(100, -1);
  SetMoving(false);
end;

procedure TTripForm.AutoApproachBtnClick(Sender: TObject);
var
punto_salida: boolean;
adcRead : TVectorDouble;

begin
  SetMoving(true);
  StopTrip:=False;
  punto_salida:=false;
  while (not punto_salida) do
  begin
    //Strom_jetzt:=  DataForm.adc_take(TripConfig.InADCEdit.Value,TripConfig.InADCEdit.Value,TripMean);
    adcRead:=DataForm.adc_take_all_os(TripMean, AdcWriteRead, nil,OSRatio);
    while (abs(adcRead[TripConfig.InADCEdit.Value]/2)<(TripConfig.spinCurrentLimit.Value/100)) and (not StopTrip) do
    begin
      MakeStepsBuf(times, 1);
      //MakeSteps(times, 1);
      //Strom_jetzt:=  DataForm.adc_take(TripConfig.InADCEdit.Value,TripConfig.InADCEdit.Value,TripMean);
      adcRead :=DataForm.adc_take_all_os(TripMean, AdcWriteRead, nil,OSRatio);
    end;
    punto_salida:=True;
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

//we could implement a version of this using a buffer
//we can match the speed, but the slope would be more consistent
// and we can just go through more DAC values in between
//at max speed it takes about 65us per point
procedure TTripForm.MakeSteps(numSteps, direction: Integer);
var
i,j: SmallInt;
enviaZ: Integer;

begin
  StopTrip:=False;
  i:=0;
  while (i<numSteps) and (StopTrip=False) do
  begin
    //we could start at one as it always ends in zero the iteration befora
    //maybe add a zero befora the loop to make sure we start from the correct value
    for j:= 0 downto -32767 do
    begin
      //its around 65 pints at max speed
      if Frac(j/Speed)=0 then
      begin
        enviaZ:=direction*Mult*Round(j*Size/10);
        DataForm.dac_set(ZPDac,enviaZ, nil);
      end;
    end;
    for j:= 32767 downto 0 do
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
  TripSteps:= TripSteps -(i*direction*Mult*Size); //Add the number of steps done
  StepsCount.Caption := IntToStr(TripSteps);
  // I think this one is redundant now, as the generated ramp always ends in 0
  // and due to the process message in betwee, it waits for a long time (over 1ms)
  //DataForm.dac_set(ZPDac,0, nil);
end;

procedure TTripForm.MakeStepsBuf(numSteps, direction: Integer);
var
i,j: SmallInt;
//n : Integer;
calcZ: Integer;
enviaZ: Integer;
//TripBuffer2: array of AnsiChar;
BufferMem: Array[0..$8000] of Byte; //Using the value of FT_Out_Buffer_Size (Manually)
BufferPtr: PAnsiChar;
m : Integer;
totalBytes: Integer;
begin
  StopTrip:=False;
  i:=0;
  //SetLength(TripBuffer2,6554*12); //Maximum size for Speed =10
  // we can be more clever when creating the size of the buffer,
  // as it would typically be much smaller
  BufferPtr := Addr(Buffermem[0]);
  totalBytes :=0;
  while (i<numSteps) and (StopTrip=False) do
  begin
    //n:=1;
    //we could start at one as it always ends in zero the iteration befora
    //maybe add a zero before the loop to make sure we start from the correct value
    for j:= 0 downto -32767 do
    begin
      //its around 65 points at max speed
      if Frac(j/Speed)=0 then
      begin
        calcZ:=direction*Mult*Round(j*Size/10);
        //if (ZPDac < 5) then calcZ:=-calcZ; //Mantenemos este paso, aunque no tiene mucho sentido
        //if enviaZ >32767 then enviaZ:=32767;
        //if enviaZ<-32768 then enviaZ:=-32768;
        enviaZ := DataForm.clampToDAC16(calcZ);
        m := DataForm.dac_set_buff(ZPDac,enviaZ,BufferPtr);
        totalBytes := totalBytes + m;
        BufferPtr := BufferPtr + m;
        //n := n + DataForm.dac_set_buff2(ZPDac,enviaZ, Slice(@TripBuffer[n],12));
      end;
    end;
    for j:= 32767 downto 0 do
    begin
      if Frac(j/Speed)=0 then
      begin
        calcZ:=direction*Mult*Round(j*Size/10);
        //if (ZPDac < 5) then calcZ:=-calcZ; //Mantenemos este paso, aunque no tiene mucho sentido
        //if enviaZ >32767 then enviaZ:=32767;
        //if enviaZ<-32768 then enviaZ:=-32768;
        enviaZ := DataForm.clampToDAC16(calcZ);
        m := DataForm.dac_set_buff(ZPDac,enviaZ,BufferPtr);
        totalBytes := totalBytes + m;
        BufferPtr := BufferPtr + m;
        //n := n + DataForm.dac_set_buff2(ZPDac,enviaZ, Slice(@TripBuffer[n],12));
      end;
    end;
    if totalBytes > ($8000-2*m) then MessageDlg('Hemos superado el buffer', mtError, [mbOk], 0);
    //add the send_inmediate command at the end;
    m := DataForm.send_inmediate(BufferPtr);;
    totalBytes := totalBytes + m;
    BufferPtr := BufferPtr + m;
    //Send the ramp for one step
    DataForm.send_buffer(Addr(Buffermem[0]), totalBytes);
    BufferPtr := Addr(BufferMem[0]);
    totalBytes := 0;
    Application.ProcessMessages;
    i:=i+1;
  end;

  TripSteps:= TripSteps -(i*direction*Mult*Size); //Add the number of steps done
  StepsCount.Caption := IntToStr(TripSteps);
  //n := DataForm.dac_set(ZPDac,0, Addr(TripBuffer[n]));
  // I think this one is redundant now, as the generated ramp always ends in 0
  // and due to the process message in betwee, it waits for a long time (over 1ms)
  //DataForm.send_buffer(@TripBuffer[1], n);
end;


procedure TTripForm.ResetCountBtnClick(Sender: TObject);
begin
  TripSteps:= 0; //Reset the number of steps done
  StepsCount.Caption := IntToStr(TripSteps);
end;

end.
