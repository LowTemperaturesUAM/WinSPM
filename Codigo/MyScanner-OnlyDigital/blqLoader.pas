unit blqLoader;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  stdCtrls, Buttons, ComCtrls, ExtCtrls, Spin,
  blqDataSet ;



type
  TblqLoaderForm = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    ListBox1: TListBox;
    Cancel: TBitBtn;
    BlockName: TLabel;
    OK: TBitBtn;
    private
    public
  end;

  TBlockEntry = class
    private
      FNombre : AnsiString ;
      FOffset : Integer ;
      FIndex : Integer ;
    public
      constructor Create ;
      destructor Destroy ; override ;
  end ;

  TblqLoader = class(TComponent)
    private
      FFileName : string ; // blq filename with path
      FExt : string ; // blq extension
      nnn : Integer ; // n dataset entries
      sss : Integer ; // n selected dataset entries
      FEntries : TList ;
      FSelectedEntries : TList ;

      function NoGoodFile : Boolean ;
      procedure AddEntry(name:AnsiString;offset,index:integer) ;
      procedure AddSelectedEntry(n:integer) ;


    public
      constructor Create(AOwner:TComponent) ;
      destructor Destroy ; override ;
      property FileName : string read FFileName ;
      property Count : integer read nnn ;
      property SelectedCount : Integer read sss ;
      function SelectBlockFile(FileName : String) : Boolean ;
      function SelectEntriesDialog : Boolean ;
      function SelectNextEntries(inc:Integer) :  Boolean ;
      function GetEntryOffset(n:integer) : Integer ;
      function GetSelectedEntryOffset(n:integer) : Integer ;

      // DISEÑO
      function _SelectEntry(n:integer) : Boolean ;
      procedure _UnSelectEntries ;
      property _BlockFileName:string read FFileName ;
  end ;


  procedure Register ;

var
  blqLoaderForm: TblqLoaderForm;

implementation

type
  T_BCK_Head = record
    nombre : array [0..13] of char ;
    v1,v2,v3 : Word ; // $3C3C  $???? $????
    tipo : byte ; //? I(Z) siempre
    n : Word ; // n datos
    z,x,y,zz,xx,yy,zzz,dac : single ; // voltaje en piezo
    cz,cx,cy,czz,cxx,cyy,czzz,cdac : single ; // calibracion A/V
    bias : single ; // bias en voltios
    start,size : single ; // voltaje en piezo
    factor : single ; // factor IV
    offset : single ; // offset voltios de lectura
    prom : integer ; // promedios
    momento, time : single ; // segundos
    coment : array [0..31] of char ;
    vacio : array [0..104] of char ;
    // n SmallInt (signed 2-byte integers)
  end ;


var
  i : integer ;
  b : boolean ;

{$R *.DFM}

procedure Register ;
begin
  RegisterComponents('My',[TblqLoader]) ;
end ;

constructor TBlockEntry.Create ;
begin
  inherited Create ;
end ;

destructor TBlockEntry.Destroy ;
begin
  inherited Destroy ;
end ;

constructor TblqLoader.Create(AOwner:TComponent) ;
begin
  inherited Create(AOwner) ;
  FEntries:=TList.Create ;
  FSelectedEntries:=TList.Create ;
end ;

destructor TblqLoader.Destroy ;
begin
  FEntries.Free ;
  FSelectedEntries.Free ;
  inherited Destroy ;
end ;

function TblqLoader.NoGoodFile : Boolean ;
begin
  Result:=False ;
end ;

procedure TblqLoader.AddEntry(name:AnsiString;offset,index:integer) ;
var Entry : TBlockEntry ;
begin
  Entry:=TBlockEntry.Create ;
  Entry.FOffset:=Offset ;
  Entry.FIndex:=index ;
  Entry.FNombre:=Name ;
  FEntries.Add(Entry) ;
end ;

procedure TblqLoader.AddSelectedEntry(n:integer) ;
var SelEntry,Entry : TBlockEntry ;
begin
  SelEntry:=TBlockEntry.Create ;
  Entry:=FEntries.Items[n] ;
  SelEntry.Fnombre:=Entry.FNombre ;
  SelEntry.FOffset:=Entry.FOffset ;
  SelEntry.FIndex:=Entry.FIndex ;
  FSelectedEntries.Add(SelEntry) ;
end ;


function TblqLoader.SelectBlockFile(FileName : string) : Boolean ;
var
  Open : TOpenDialog ;
  F : TFileStream ;
  BCK_Head : T_BCK_Head ;
  BLQ_Head : T_BLQ_Head ;
  COL_Head : T_COL_Head ;
  Ext : string ;
  Offset : integer ;
  d : TBlockEntry ;
  j : integer ;
begin
  if FileName='' then begin
    Open:=TOpenDialog.Create(Self) ;
    // OPCIONES
    Open.Filter:='Fichero *.BLQ|*.BLQ|Fichero *.BCK|*.BCK' ;
    //Open.ofPathMustExist:=True ;
    //Open.Options.ofFileMustExist:=True ;
    if Open.Execute=False then Exit ;
    FFileName:=Open.FileName ;
  end ;

  if FFileName=FileName then begin
    FEntries.Free ;
    FSelectedEntries.Free ;
    FEntries:=TList.Create ;
    FSelectedEntries:=TList.Create ;
    FFileName:=FileName ;
  end
  else begin
    FEntries.Free ;
    FSelectedEntries.Free ;
    FEntries:=TList.Create ;
    FSelectedEntries:=TList.Create ;
    FFileName:=FileName ;
  end ;

  nnn:=0 ;

  //if not Assigned(FEntries) then FEntries:=TList.Create ;
  //if not Assigned(FSelectedEntries) then FSelectedEntries:=TList.Create ;

  // ABRIR FICHERO
  F:=TFileStream.Create(FFileName,fmOpenRead) ;
  Ext:=UpperCase(ExtractFileExt(FFileName)) ;

  Offset:=0 ;
  j:=0 ;
  // BCK -----------------------
  if Ext='.BCK' then begin
    while F.Read(BCK_Head,SizeOf(BCK_Head))=SizeOf(BCK_Head) do begin
      if BCK_Head.v1<>$3C3C then begin Result:=NoGoodFile ; F.Destroy ; Exit ; end ;
      AddEntry(BCK_Head.Nombre,Offset,j) ;
      F.Seek(2*BCK_Head.n,soFromCurrent) ;
      Offset:=Offset+SizeOf(BCK_Head)+2*BCK_Head.n ;
      j:=j+1 ;
    end ;
  end ;
  // BLQ
  if Ext='.BLQ' then begin
    while F.Read(BLQ_Head,SizeOf(BLQ_Head))=SizeOf(BLQ_Head) do begin
      if BLQ_Head.V0<>$4444 then begin Result:=NoGoodFile ; F.Destroy ; Exit ; end ;
      AddEntry(BLQ_Head.Name,Offset,j) ;
      Offset:=Offset+SizeOf(BLQ_Head) ;
      for i:=0 to BLQ_Head.NCols-1 do begin
        if F.Read(COL_Head,SizeOf(COL_Head))<>SizeOf(COL_Head) then begin Result:=NoGoodFile ; F.Destroy ; Exit ; end ;
        if COL_Head.v0<>$3333 then begin Result:=NoGoodFile ; F.Destroy ; Exit ; end ;
        Offset:=Offset+SizeOf(COL_Head) ;
        if COL_Head.DataFormat<>0 then begin
          F.Seek(COL_Head.DataFormat*BLQ_Head.NRows,soFromCurrent) ;
          Offset:=Offset+COL_Head.DataFormat*BLQ_Head.NRows ;
        end ;
      end ;
      j:=j+1 ;
    end ;
  end ;


  // CERRAR FICHERO
  F.Destroy ;


  nnn:=FEntries.Count ;
  sss:=0 ;
  FSelectedEntries.Clear ;
  FExt:=Ext ;

  blqLoaderForm.ListBox1.Items.Clear ;
  for i:=0 to nnn-1 do begin
    d:=FEntries[i] ;
    blqLoaderForm.ListBox1.Items.Add(d.FNombre) ;
  end ;

end ;


function TblqLoader.SelectEntriesDialog : Boolean ;
begin
  Result:=False ;
  if nnn=0 then Exit ;

  with blqLoaderForm do begin
    Panel1.Left:=0 ;
    Panel1.Top:=0 ;
    ClientWidth:=Panel1.Width ;
    ClientHeight:=Panel1.Height ;
    Panel1.BevelOuter:=bvNone ;
    Panel1.Visible:=True ;
    Caption:='Select DataSet' ;
    BlockName.Caption:=FFileName ;
    ShowModal ; // MUESTRA VENTANA
    Panel1.Visible:=False ;
  end ;


  if blqLoaderForm.ModalResult=mrOK then begin
    FSelectedEntries.Clear ;
    sss:=blqLoaderForm.ListBox1.SelCount ;
    for i:=0 to nnn-1 do begin
      if blqLoaderForm.ListBox1.Selected[i] then AddSelectedEntry(i) ;
    end ;
    Result:=True ;
  end ;

end ;


function TblqLoader.SelectNextEntries(inc:Integer) :  Boolean ;
var
  Entry : TBlockEntry ;
  indices : array [0..1023] of integer ;
begin
  Result:=False ;
  if nnn=0 then Exit ;
  if sss=0 then Exit ;
  for i:=0 to sss-1 do begin
    Entry:=FSelectedEntries[i] ;
    if (Entry.FIndex+inc) >= nnn then Exit ;
    if (Entry.FIndex+inc) < 0 then Exit ;
    indices[i]:=Entry.FIndex ;
  end ;
  FSelectedEntries.Clear ;
  FSelectedEntries.Pack ;
  for i:=0 to sss-1 do begin
    AddSelectedEntry(indices[i]+inc) ;
    blqLoaderForm.ListBox1.Selected[indices[i]]:=False ;
    blqLoaderForm.ListBox1.Selected[indices[i]+inc]:=True ;
  end ;

  Result:=True ;
end ;

function TblqLoader.GetEntryOffset(n:integer) : Integer ;
begin
  Result:=0 ;
  if (n<0) or (n>=nnn) then Exit ;
  Result:=TBlockEntry(FEntries[n]).FOffset ;
end ;
function TblqLoader.GetSelectedEntryOffset(n:integer) : Integer ;
begin
  Result:=0 ;
  if (n<0) or (n>=sss) then Exit ;
  Result:=TBlockEntry(FSelectedEntries[n]).FOffset ;
end ;


// SOLO PARA DISEÑO
function TblqLoader._SelectEntry(n:integer) : Boolean ;
begin
  Result:=False ;
  if n>=nnn then Exit ;
  AddSelectedEntry(n) ;
  sss:=sss+1 ;
end ;

procedure TblqLoader._UnSelectEntries ;
begin
  FSelectedEntries.Clear ;
  sss:=0 ;
end ;

//####################################################################
//####################################################################

{

function TBlockFile.LoadBCK(BlockFile:string;BlockOffset:Integer;var DS:TDataSet) : Boolean ;
var
  f : TFileStream ;
  h : T_BCK_Head ;
  w : Word ;
  ddd : TDataSetCol ;
begin
  // ABRIR FICHERO
  F:=TFileStream.Create(BlockFile,fmOpenRead) ;
  F.Seek(BlockOffset,soFromBeginning) ;
  F.Read(h,SizeOf(T_BCK_Head)) ;
  // CREAR EL DATASET
  if DS<>nil then DS.Free ;
  DS:=TDataSet.Create(2,h.n) ;
  // LEER Y1
  for i:=0 to h.n-1 do begin
    F.Read(w,2) ;
    DS[1][i]:=h.factor*(w*0.0003051) ;
  end ;
  // CERRAR FICHERO
  F.Destroy ;
  // CREAR X
  for i:=0 to h.n-1 do DS[0][i]:=1e-10*h.cz*(h.start+(h.size/h.n)*i) ;
  // DATOS DATA SET
  DS._BlockFile:=BlockFile ;
  DS._BlockOffset:=BlockOffset ;
  DS._Name:=string(h.nombre) ;
  DS._Moment:=h.Momento ;
  DS._Time:=h.Time ;

  DS[0]._AxisType:=axt_displacement ;
  DS[0]._DataFormat:=4 ;
  DS[0]._Start:=0.0 ;
  DS[0]._Size:=1.0 ;
  DS[0].AxisUnits:=axu_a ;

  DS[1]._AxisType:=axt_current ;
  DS[1]._DataFormat:=4 ;
  DS[1]._Start:=0.0 ;
  DS[1]._Size:=1.0 ;
  DS[1]._ParamA[0]:=h.bias ;
  DS[1]._ParamB[0]:=1.0/h.factor ;

  Result:=True ;

end ;
}

end.





