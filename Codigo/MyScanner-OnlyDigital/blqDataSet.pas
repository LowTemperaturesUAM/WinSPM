unit blqDataSet;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Tipos;

type
  TblqDataSetForm = class(TForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TDataSetCol = class
    private
      FData : TPArrayOfSingles ;
      Fn :integer ;
      FDataFormat : Integer ; // 0:generate 2:SmallInt 4:single 8:double
      //FTipo : Integer ; // Ver GetAxisTitle
      FProm : Integer ; // promedios
      FOffset : double ;
      FFactor : double ;
      FStart, FSize : Double ;
      FCTime : double ;
      FParamA : array[0..3] of double ;
      FParamB : array[0..7] of single ;

      FAxistype : Integer ;
      FAxisUnits : Integer ;
      FAxisUnitsFactor : double ;

      function GetParamA(n:integer) : double ;
      procedure SetParamA(n:integer;d:double) ;
      function GetParamB(n:integer) : single ;
      procedure SetParamB(n:integer;d:single) ;

      function GetValue(n:integer) : double ;
      procedure SetValue(n:integer;f:double) ;

      function GetAxisTitle:AnsiString ;
      procedure SetAxisUnits(n:Integer) ;

      constructor Create(n:integer) ;
      destructor Destroy ; override ;

      function GetMinIndex : integer ;
      function GetMaxIndex : integer ;

    public
      property Data : TPArrayOfSingles read Fdata ;
      property DataFormat : integer read FDataFormat ;
      property Prom:integer read FProm ;
      property Offset:double read FOffset ;
      property Factor:double read FFactor ;
      property Start : double read FStart ;
      property Size : double read FSize ;
      property CTime : double read FCTime ;

      property Value[n:integer] : double read GetValue write SetValue ; default ;
      property AxisType:Integer read FAxisType ;
      property AxisTitle:AnsiString read GetAxisTitle ;
      property AxisUnits:Integer write SetAxisUnits ;

      property MinIndex : integer read GetMinIndex ;
      property MaxIndex : integer read GetMaxIndex ;

      // SECRET
      property _DataFormat : integer write FDataFormat ;
      //property _Tipo:Integer write FTipo;
      property _Prom:Integer write FProm ;
      property _Offset:double write FOffset ;
      property _Factor:double write FFactor ;
      property _Start : double write FStart ;
      property _Size : double write FSize ;
      property _CTime : double write FCTime ;
      property _ParamA[n:integer]:double read GetParamA write SetParamA ;
      property _ParamB[n:integer]:single read GetParamB write SetParamB ;
      property _AxisType:Integer write FAxisType;
  end ;


  TblqDataSet = class
    private
      FNcols : Integer ;
      FNrows : Integer ;
      FCol : TList ;
      FName : AnsiString ;
      FMoment : double ;
      FTime : double ;
      FComment : AnsiString ;

      FBlockFile : AnsiString ;
      FBlockOffset : Integer ;
      FXCol,FY1Col,FY2Col : Integer ;

      function GetCol(n:Integer):TDataSetCol ;

    public
      constructor Create(ncols,nrows:Integer) ;
      destructor Destroy ; override ;

      property xcol : integer read Fxcol write Fxcol ;
      property y1col : integer read Fy1col write Fy1col ;
      property y2col : integer read Fy2col write Fy2col ;
      property Col[n:Integer] : TDataSetCol read GetCol ; default ;
      property Name:AnsiString read FName ;
      property BlockFile:AnsiString read FBlockFile ;
      property BlockOffset:integer read FBlockOffset ;
      property Nrows:integer read FNrows ;
      property Ncols:integer read FNcols ;
      property Moment : double read FMoment ;
      property Time : double read FTime ;
      property Comment : AnsiString read FComment write FComment;

      // SECRETAS
      property _Name:AnsiString write FName ;
      property _Moment : double write FMoment;
      property _Time : double write FTime ;
      property _Comment : AnsiString write FComment ;
      property _BlockFile:AnsiString write FBlockFile;
      property _BlockOffset:Integer write FBlockOffset ;

  end ;

  T_BLQ_Head = record
    v0 : word ; // $4444
    v1,v2,v3 : word ;
    Name : array [0..31] of Char ;
    NCols : Integer ;
    NRows : Integer ;
    Moment : double ;
    Time : double ;
    Comment : array [0..127] of Char ;

    User : Integer ;
    UserReserved : array [0..99] of byte ;

    Unid : Integer ;
    UnidReserved : array [0..99] of byte ;
    //PiezoVoltage : array [0..7] of single ;
    //PiezoCalibration : array [0..7] of single ;
    //UnidReserved : array [0..35] of byte ;

  end ;

  T_COL_Head = record
    v0 : word ; // $3333
    DataFormat : SmallInt ; // 0,1,2,4,8
    Tipo : Integer ;
    Prom : Integer ;
    Offset,Factor : double ;
    Start,Size : double ;
    CTime : single ;
    ParamA : array[0..3] of double ;
    ParamB : array[0..7] of single ;
    Reserved : array [0..15] of byte ;
  end ;

  function LoadDataSetFromBlock(BlockFile:AnsiString;BlockOffset:Integer;var DS:TblqDataSet) : Boolean ;
  function WriteDataSetInBlock(BlockFile:AnsiString;DS:TblqDataSet;TwoTerminal:Boolean) : Boolean ;

const
  units_unknown=0 ; units_displacement=100 ; units_voltage=200 ;
  units_current=300 ; units_time=400 ; units_force=500 ; units_conductance=600 ;

  units_factor_SI=0 ; units_factor_mili=-3 ; units_factor_micro=-6 ; units_factor_nano=-9 ;
  units_factor_pico=-12 ; units_factor_kilo=3 ; units_factor_mega=6 ; units_factor_giga=9 ;
  units_factor_tera=12 ;

  //units_factor_a=100 ; units_factor_G0=101 ;

var
  blqDataSetForm: TblqDataSetForm;

implementation

{$R *.DFM}


var
  i : Integer ;
  f : Double ;

constructor TDataSetCol.Create(n:integer) ;
begin
  inherited Create ;
  GetMem(FData,4*n) ;
  Fn:=n ;
  FDataFormat:=0 ;
  FAxisType:=units_unknown ;
  FProm:=1 ;
  FOffset:=0.0 ;
  FFactor:=1.0 ;
  FStart:=0.0 ;
  FSize:=1.0 ;
  FCTime:=0.0 ;
  for i:=0 to 3 do FParamA[i]:=0.0 ;
  for i:=0 to 7 do FParamB[i]:=0.0 ;

  // propias del dataset
  FAxisUnits:=units_factor_SI ;
  FAxisUnitsFactor:=1.0 ;


  for i:=0 to 3 do FParamA[i]:=0.0 ;
  for i:=0 to 7 do FParamB[i]:=0.0 ;
end ;

destructor TDataSetCol.Destroy ;
begin
  FreeMem(FData) ;
  inherited Destroy ;
end ;


constructor TblqDataSet.Create(ncols,nrows:Integer) ;
begin
  inherited Create ;
  Fncols:=ncols ;
  Fnrows:=nrows ;
  FMoment:=0.0 ;
  FTime:=1.0 ;
  FName:='No name' ;
  FBlockFile:='' ;
  FBlockOffset:=0 ;
  FXCol:=0 ;
  FY1Col:=1 ;
  FY2Col:=2 ;
  // CREA LAS COLUMNAS
  FCol:=Tlist.Create ;
  for i:=0 to ncols-1 do begin
    FCol.Add(TDataSetCol.Create(nrows)) ;
  end ;
end ;

destructor TblqDataSet.Destroy ;
begin
  for i:=0 to Ncols-1 do TDataSetCol(FCol[i]).Free ;
  FCol.Clear ;
  FCol.Free ;
  inherited Destroy ;
end ;

function TDataSetCol.GetValue(n:Integer) : double ;
begin
  if (n<0) or (n>=Fn) then begin Result:=0.0 ; Exit ; end ;
  Result:=FAxisUnitsFactor*FFactor*(FData[n]+FOffset) ;
end ;
procedure TDataSetCol.SetValue(n:Integer;f:double) ;
begin
  if (n<0) or (n>=Fn) then Exit ;
  FData[n]:=(f/(FAxisUnitsFactor*FFactor))-FOffset ;
end ;


function TblqDataSet.GetCol(n:Integer) : TDataSetCol ;
var c : TDataSetCol ;
begin
  if n>=Fncols then c:=FCol[0]
  else c:=FCol[n] ;
  Result:=c ;
end;

function TDataSetCol.GetParamA(n:integer) : double ;
begin
  Result:=FParamA[n] ;
end ;
procedure TDataSetCOl.SetParamA(n:integer;d:double) ;
begin
  FParamA[n]:=d ;
end ;
function TDataSetCol.GetParamB(n:integer) : single ;
begin
  Result:=FParamB[n] ;
end ;
procedure TDataSetCol.SetParamB(n:integer;d:single) ;
begin
  FParamB[n]:=d ;
end ;

function TDataSetCol.GetAxistitle : AnsiString ;
var s,u,n : AnsiString ;
begin
  case FAxisType of
    units_unknown : begin n:='unknown' ; u:='' ; end ;
    units_displacement : begin n:='displacement' ; u:='m' ; end ;
    units_voltage : begin n:='voltage'; u:='V' ; end ;
    units_time : begin n:='time' ; u:='s' ; end ;
    units_force : begin n:='force' ; u:='N' ; end ;
    units_current : begin n:='current' ; u:='A' ; end ;
    units_conductance : begin n:='conductance' ; u:='ohm-1' ; end ;
    else begin n:='unknown' ; u:='' ; end ;
  end ;
  case FAxisUnits of
    units_factor_SI :    begin s:=n+' ('+u+')' ;  end ;
    units_factor_mili :  begin s:=n+' (m'+u+')' ; end ;
    units_factor_micro : begin s:=n+' (µ'+u+')' ; end ;
    units_factor_nano :  begin s:=n+' (n'+u+')' ; end ;
    units_factor_pico :  begin s:=n+' (p'+u+')' ; end ;
    units_factor_kilo :  begin s:=n+' (K'+u+')' ; end ;
    units_factor_mega :  begin s:=n+' (M'+u+')' ; end ;
    units_factor_giga :  begin s:=n+' (G'+u+')' ; end ;
    // TIPOS NO ESTANDAR
    //units_factor_a :     begin s:=n+' (Å)' ; end ;
    //units_factor_G0:     begin s:=n+' (2e2/h)' ; end ;
    else  begin s:=n+' (?)' ; end ;
  end ;
  Result:=s ;

end ;

procedure TDataSetCol.SetAxisUnits(n:Integer) ;
begin
  case n of
    units_factor_SI :    begin FAxisUnits:=n ; FAxisUnitsFactor:=1.0 ; end ;
    units_factor_mili :  begin FAxisUnits:=n ; FAxisUnitsFactor:=1e3 ; end ;
    units_factor_micro : begin FAxisUnits:=n ; FAxisUnitsFactor:=1e6 ; end ;
    units_factor_nano :  begin FAxisUnits:=n ; FAxisUnitsFactor:=1e9 ; end ;
    units_factor_pico :  begin FAxisUnits:=n ; FAxisUnitsFactor:=1e12; end ;
    units_factor_kilo :  begin FAxisUnits:=n ; FAxisUnitsFactor:=1e-3 ; end ;
    units_factor_mega :  begin FAxisUnits:=n ; FAxisUnitsFactor:=1e-6 ; end ;
    units_factor_giga :  begin FAxisUnits:=n ; FAxisUnitsFactor:=1e-9 ; end ;
    // TIPOS NO ESTANDAR
    //axu_a :     begin FAxisUnits:=n ; FAxisUnitsFactor:=1e10 ; end ;
    //axu_G0:     begin FAxisUnits:=n ; FAxisUnitsFactor:=12909.0 ; end ;
  end ;
end ;


function LoadDataSetFromBlock(BlockFile:AnsiString;BlockOffset:Integer;var DS:TblqDataSet) : Boolean ;
type
  Tsingle_array = array [0..65535] of single ;
  Tdouble_array = array [0..65535] of double ;
  TSmallInt_array = array [0..65535] of SmallInt ;
  TShortInt_array = array [0..65535] of ShortInt ;
var
  j : integer ;
  data_single : ^Tsingle_array ;
  data_double : ^TDouble_array ;
  data_smallint : ^TSmallint_array ;
  data_shortInt : ^TShortInt_array ;
  FF : TFileStream ;
  BLQ_Head : T_BLQ_Head ;
  COL_Head : T_COL_Head ;
begin
  Result:=False ;
  if '.BLQ'<>UpperCase(ExtractFileExt(BlockFile)) then Exit ;
  // ABRIR FICHERO
  FF:=TFileStream.Create(BlockFile,fmOpenRead) ;
  FF.Seek(BlockOffset,soFromBeginning) ;

  // LEER DATASET HEADER
  FF.Read(BLQ_Head,SizeOf(T_BLQ_Head)) ;
  // COMPROBACIONES

  // CREAR EL DATASET
  //DS.Free ;
  DS:=TblqDataSet.Create(BLQ_Head.NCols,BLQ_Head.Nrows) ;
  DS._Name:=BLQ_Head.Name ;
  DS._BlockFile:=BlockFile ;
  DS._BlockOffset:=BlockOffset ;
  DS._Moment:=BLQ_Head.Moment ;
  DS._Time:=BLQ_Head.Time ;
  DS.Comment:=BLQ_Head.Comment ;

  // LEER LAS COLUMNAS
  for i:=0 to DS.NCols-1 do begin
    FF.Read(COL_Head,SizeOf(COL_Head)) ;
    // COMPROBACIONES

    // COL HEADER
    DS[i]._DataFormat:=COL_Head.DataFormat ;
    DS[i]._AxisType:=COL_Head.Tipo ;
    DS[i]._Prom:=COL_Head.Prom ;
    DS[i]._Offset:=COL_Head.Offset ;
    DS[i]._Factor:=COL_Head.Factor ;
    DS[i]._Start:=COL_Head.Start ;
    DS[i]._Size:=COL_Head.Size ;
    DS[i]._CTime:=COL_Head.CTime ;
    for j:=0 to 3 do DS[j]._ParamA[j]:=Col_Head.ParamA[j] ;
    for j:=0 to 7 do DS[j]._ParamB[j]:=Col_Head.ParamB[j] ;

    // LEER DATOS
    case COL_Head.DataFormat of
    0 : for j:=0 to DS.NRows-1 do begin
          DS[i].FData[j]:=DS[0].Start+j*(DS[0].Size/DS.NRows) ;
          //DS[i]._Val[j]:=DS[i].Factor*(DS[i]._Val[j]+DS[i].Offset) ;
        end ;
    1 : begin
        GetMem(data_ShortInt,DS.Nrows) ;
        FF.Read(data_ShortInt^,DS.Nrows) ;
        for j:=0 to DS.NRows-1 do DS[i].FData[j]:=data_ShortInt^[j] ;
        FreeMem(data_ShortInt) ;
        end ;
    2 : begin
        GetMem(data_SmallInt,2*DS.Nrows) ;
        FF.Read(data_SmallInt^,2*DS.Nrows) ;
        for j:=0 to DS.NRows-1 do DS[i].FData[j]:=data_SmallInt^[j] ;
        FreeMem(data_SmallInt) ;
        end ;
    4 : begin
        GetMem(data_single,4*DS.Nrows) ;
        FF.Read(data_single^,4*DS.Nrows) ;
        for j:=0 to DS.NRows-1 do DS[i].FData[j]:=data_single^[j] ;
        FreeMem(data_single) ;
        end ;
    8 : begin
        GetMem(data_double,8*DS.Nrows) ;
        FF.Read(data_double^,8*DS.Nrows) ;
        for j:=0 to DS.NRows-1 do DS[i].FData[j]:=data_double^[j] ;
        FreeMem(data_double) ;
        end ;
    end ;
  end ;

  // CERRAR FICHERO
  FF.Destroy ;
  Result:=True ;
end ;


function WriteDataSetInBlock(BlockFile:AnsiString;DS:TblqDataSet;TwoTerminal:Boolean) : Boolean ;
label
  fin_error, fin_write_error ;
type
  Tbufs = array[0..65535] of single ;
  Tbufd = array[0..65535] of double ;
var
  FF : TFileStream ;
  h : T_BLQ_Head ;
  c : T_Col_Head ;
  k : integer ;
  bufs : array[0..16384] of single ;
  bufd : array[0..16384] of double ;
  f1,f2 : double ;


begin
  Result:=False ;
  if DS.NCols<0 then goto fin_error ;
  if DS.NRows<0 then goto fin_error ;

  for k:=0 to DS.NRows-1 do begin
    if (DS.Col[k].DataFormat<>0) and (DS.Col[k].DataFormat<>1)
       and (DS.Col[k].DataFormat<>2) and (DS.Col[k].DataFormat<>4)
       and (DS.Col[k].DataFormat<>8) then goto fin_error ;
  end ;

  if FileExists(BlockFile) then FF:=TFileStream.Create(BlockFile,fmOpenWrite)
  else FF:=TFileStream.Create(BlockFile,fmCreate) ;
  FF.Seek(0,soFromEnd) ;

  // CABECERA GENERAL
  h.V0:=$4444 ; h.V1:=1 ; h.V2:=0 ; h.V3:=0 ;
  for i:=0 to 31 do h.Name[i]:=#0 ;
  strcopy(h.Name,PChar(DS.Name)) ;
  h.NCols:=DS.NCols ;
  h.NRows:=DS.NRows ;
  h.Moment:=DS.Moment ;
  h.Time:=DS.Time ;
  for i:=0 to 127 do h.Comment[i]:=#0 ;
  strcopy(h.Comment,PChar(DS.Comment)) ;
  h.User:=1 ;
  for i:=0 to 99 do h.UserReserved[i]:=0 ;
  h.Unid:=1 ;
  for i:=0 to 99 do h.UnidReserved[i]:=0 ;
  FF.Write(h,SizeOf(h)) ;

  // COLUMNAS ----------------------------------
  for k:=0 to DS.NCols-1 do begin
    c.V0:=$3333 ;
    c.DataFormat:=DS.Col[k].DataFormat ;
    if (k=0) and TwoTerminal then c.DataFormat:=0 ;
    c.Tipo:=DS.Col[k].FAxisType ;
    c.Prom:=DS.Col[k].Prom ;
    c.Offset:=DS.Col[k].Offset ;
    c.Factor:=DS.Col[k].Factor ;
    c.Start:=0.0 ;
    c.Size:=0.0 ;
    if c.DataFormat=0 then begin
      f1:=DS.Col[k].FData[0] ;
      f2:=DS.Col[k].FData[DS.NRows-1] ;
      f2:=(f2-f1)/(DS.NRows-1) ;
      c.Start:=f1 ;
      c.Size:=f2*DS.NRows ;
    end ;
    c.cTime:=0.0 ;
    for i:=0 to 3 do c.ParamA[i]:=0.0 ;
    for i:=0 to 7 do c.ParamB[i]:=0.0 ;

    for i:=0 to 15 do c.Reserved[i]:=0 ;

    FF.Write(c,SizeOf(c)) ;


    // DATOS -------------------------------
    if c.DataFormat<>0 then begin
      if c.DataFormat=8 then begin
        for i:=0 to DS.NRows-1 do bufd[i]:=DS.Col[k].FData[i] ;
        if (8*DS.NRows)<>FF.Write(bufd,8*DS.NRows) then goto fin_write_error ;
      end ;
      if c.DataFormat=4 then begin
        for i:=0 to DS.NRows-1 do bufs[i]:=DS.Col[k].FData[i] ;
        if (4*DS.NRows)<>FF.Write(bufs,4*DS.NRows) then goto fin_write_error ;
      end ;
      if c.DataFormat=2 then begin
        for i:=0 to DS.NRows-1 do bufs[i]:=DS.Col[k].FData[i] ;
        if (4*DS.NRows)<>FF.Write(bufs,4*DS.NRows) then goto fin_write_error ;
      end ;
      if c.DataFormat=1 then begin
        for i:=0 to DS.NRows-1 do bufs[i]:=DS.Col[k].FData[i] ;
        if (4*DS.NRows)<>FF.Write(bufs,4*DS.NRows) then goto fin_write_error ;
      end ;

    end ; // END WRITE DATA
  end ; // END NCOLS LOOP

  FF.Destroy ;
  Result:=True ;
  Exit ;

  fin_error:
  ShowMessage('ERROR inside DataSet') ;
  Exit ;

  fin_write_error:
  ShowMessage('ERROR writting file') ;
  FF.Destroy ;
  Exit ;

end ;


function TDataSetCol.GetMinIndex : integer ;
var i,min_n : integer ; min_val : double ;
begin
  min_n:=0 ; min_val:=FData[0] ;
  for i:=0 to Fn-1 do begin
    if FData[i]<min_val then begin min_n:=i ; min_val:=FData[i] ; end ;
    end ;
  Result:=min_n ;
end ;

function TDataSetCol.GetMaxIndex : integer ;
var i,max_n : integer ; max_val : double ;
begin
  max_n:=0 ; max_val:=FData[0] ;
  for i:=0 to Fn-1 do begin
    if FData[i]>max_val then begin max_n:=i ; max_val:=FData[i] ; end ;
    end ;
  Result:=max_n ;
end ;

end.
