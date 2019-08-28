unit xyyGraph;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, Math, ComCtrls ;

procedure Register ;

type

  TxyyGraphForm = class(TForm)
  private
  public
  end;

  // FORWARD DECLARATIONS
  TxyyGraph = class ;
  TxyyGraphAxis = class ;
  TxyyGraphSeries = class ;

  // AXIS
  TxyyGraphAxis = class (TPersistent)
    private
      FGraph : TxyyGraph ;
      Fkind : integer ;
      Fmin,Fmax : double ;
      FTitle : string ;
      FTitleFont : TFont ;
      FTicksNumber : integer ;
      FTicksFont : TFont ;
      FTicksLength : integer ;
      FTicksSpace : integer ;
      FGridPen : TPen ;
      FTicksPen : TPen ;
      FAxisPen : TPen ;

      constructor Create(AGraph:TxyyGraph;kind:integer) ;
      destructor Destroy ;
      procedure SetMin(v:double) ;
      procedure SetMax(v:double) ;
      procedure SetTicksSpace(i:integer) ;
      function GetDivisionStart : double ;
      function GetDivisionSize : double ;
      function GetDivisionDigits : integer ;

    published
      property Min : double read FMin write SetMin ;
      property Max : double read FMax write SetMax ;
      property Title : string read FTitle write FTitle ;
      property TitleFont : TFont read FTitleFont ;
      property TicksFont : TFont read FTicksFont ;
      property TicksSpace : integer read FTicksSpace write SetTicksSpace default 4 ;
      property GridPen : TPen read FGridPen ;
      property AxisPen : TPen read FAxisPen  ;
      property TicksPen : TPen read FTicksPen ;
  end ;

  TxyyGraphSeries = class
    private
      Fn : integer ;
      Fdata : array of double ;
      FColor : TColor ;
      FPoints,FLines : Boolean ;
      FVisible : Boolean ;
      FSecondAxis : Boolean ;
      constructor Create ;
      destructor Destroy ;
      function GetX(i:integer):double ;
      function GetY(i:integer):double ;

    public
      property Size : integer read Fn ;
      property Color : TColor read FColor write FColor ;
      property PlotPoints : Boolean read FPoints write FPoints ;
      property PlotLines : Boolean read FPoints write FLines ;
      property Visible : Boolean read FVisible write FVisible ;
      property x[i:integer] : double read GetX ;
      property y[i:integer] : double read GetY ;
      property SecondAxis : Boolean read FSecondAxis write FSecondAxis ;

      function AddPoint(x,y:double) : Boolean ;
      function Clear : Boolean ;
  end ;
  TPxyyGraphSeries = ^TxyyGraphSeries ;


  TXyyGraph = class (TCustomPanel)
    private
      FBox : TPaintBox ;
      FBackGroundColor : TColor ;
      FXAxis,FYAxis : TxyyGraphAxis ;
      FSeries : array of TxyyGraphSeries ;
      FTitle : string ;
      FTitleFont : TFont ;
      FClipping : Boolean ;
      FZooming : Boolean ;
      Fmousex1,Fmousex2,Fmousey1,Fmousey2 : integer ;
      Fxx1,Fxx2,Fyy1,Fyy2 : integer ;
      FAntiFlicker : Boolean ;

      FAutoScaling,FZoomed : Boolean ;

      FMyCanvas : TCanvas ;
      FToPrinter : Boolean ;

      // ASIGNADOS POR EL USUARIO
      FMouseMove : TMouseMoveEvent ;
      FMouseDown : TMouseEvent ;
      FMouseUp : TMouseEvent ;
      FClick : TNotifyEvent ;

      procedure Pintar ;
      procedure Paint ; override ;
      procedure RescaleAll ;
      function GetSeries(i:integer):TxyyGraphSeries;
      function GetCanvas : TCanvas ;
      procedure Resize ; override ;

      procedure PClick(Sender:TObject) ;
      procedure PMouseDown(Sender:TObject;Button:TMouseButton;Shift:TShiftState;X,Y:Integer);
      procedure PMouseMove(Sender:TObject;Shift:TShiftState;X,Y:Integer);
      procedure PMouseUp(Sender:TObject;Button:TMouseButton;Shift:TShiftState;X,Y:Integer);

    public
      property Canvas : TCanvas read GetCanvas ;
      property  Series[i:integer]: TxyyGraphSeries read GetSeries ; default ;
      constructor Create(AOwner:Tcomponent) ; override ;
      destructor Destroy ; override ;
      procedure Update ;
      procedure UpdateMyCanvas(MyCanvas:TCanvas) ;
      function Clear : Boolean ;
      function GetX(xi:integer) : double ;
      function GetY(yi:integer) : double ;
      function GetXpixel(x:double) : integer ;
      function GetYpixel(y:double) : integer ;

    published
      property BackgroundColor : TColor read FBackgroundColor write FbackgroundColor ;
      property XAxis : TxyyGraphAxis read FXAxis ;
      property YAxis : TxyyGraphAxis read FYAxis ;
      property Title : string read FTitle write FTitle ;
      property TitleFont : TFont read FTitleFont ;
      property AutoScaling : Boolean read FAutoScaling write FAutoScaling ;
      property Align ;
      property AntiFlicker : Boolean read FAntiFlicker write FAntiFlicker ;

      property OnClick : TNotifyEvent read FClick write Fclick ;
      property OnMouseDown : TMouseEvent read FMouseDown write FMouseDown ;
      property OnMouseUp : TMouseEvent read FMouseUp write FMouseUp ;
      property OnMouseMove : TMouseMoveEvent read FMouseMove write FMouseMove ;

  end ;

var
  xyyGraphForm: TxyyGraphForm ;

implementation

{$R *.DFM}

const
  MAXDATA = 32768 ;
  MAXSERIES = 1000 ;

procedure Register ;
begin
  RegisterComponents('My',[TxyyGraph]) ;
end ;


constructor TxyyGraph.Create(AOwner:Tcomponent) ;
var
  i : integer ;
begin
  inherited Create(AOwner) ;

  // GET SERIES MEMORY
  GetMem(FSeries,MAXSERIES*Sizeof(TPxyyGraphSeries)) ;
  for i:=0 to MAXSERIES-1 do FSeries[i]:=TxyyGraphSeries.Create ;

  // DEFAULT PRESENTATION
  width:=250 ; height:=200 ;
  //width:=400 ; height:=300 ;
  FBackGroundColor:=clWhite ;
  Color:=FBackgroundColor ;
  Cursor:=crCross ;
  BevelInner:=bvNone ;
  BevelOuter:=bvNone ;

  FAutoScaling:=True ;
  FZoomed:=False ;
  FToPrinter:=False ;

  FTitleFont:=TFont.Create ;
  FTitleFont.Name:='arial' ;
  FTitleFont.Size:=8 ;
  FTitleFont.Color:=clBlack ;
  FTitleFont.Style:=[fsBold,fsItalic] ;
  FTitle:='xyyGraph' ;
  FClipping:=True ;
  FAntiFlicker:=False ;

  // CREATE AXIS
  FXAxis:=TxyyGraphAxis.Create(Self,0) ;
  FYAxis:=TxyyGraphAxis.Create(Self,1) ;

  FBox:=TPaintBox.Create(Self) ;
  FBox.Parent:=Self ;
  FBox.Align:=alClient ;
  FBox.Color:=FbackgroundColor ;

  Fxx1:=0 ;
  Fxx2:=FBox.width ;
  Fyy1:=0 ;
  Fyy2:=FBox.height ;

  FZooming:=False ;
  FBox.OnClick:=PClick ;
  FBox.OnMouseDown:=PMouseDown ;
  FBox.OnMouseUp:=PMouseUp ;
  FBox.OnMouseMove:=PMouseMove ;

end ;

destructor TxyyGraph.Destroy ;
begin

  //for i:=0 to MAXSERIES-1 do Fseries[i].Free ; //???
  FBox.Free ;
  FreeMem(FSeries) ;
  FTitleFont.Free ;
  FXAxis.Free ;
  FYAxis.Free ;
  inherited Destroy ;
end ;

function TxyyGraph.GetX(xi:integer) : double ;
begin
  Result:=FXAxis.FMin+(FXAxis.Fmax-FXAxis.Fmin)*(xi-Fxx1)/(Fxx2-Fxx1) ;
end ;

function TxyyGraph.GetY(yi:integer) : double ;
begin
  yi:=Fbox.height-yi ;
  Result:=FYAxis.FMin+(FYAxis.Fmax-FYAxis.Fmin)*(yi-Fyy1)/(Fyy2-Fyy1) ;
end ;

function TxyyGraph.GetXpixel(x:double) : integer ;
begin
  Result:=Round(Fxx1+(Fxx2-Fxx1)*(x-FXAxis.Fmin)/(FXAxis.FMax-FXAxis.Fmin)) ;
end ;

function TxyyGraph.GetYpixel(y:double) : integer ;
begin
  Result:=Round(Fyy1+(Fyy2-Fyy1)*(y-FYAxis.Fmin)/(FYAxis.FMax-FYAxis.Fmin)) ;
  Result:=FBox.height-Result ;
end ;


function TxyyGraph.GetCanvas : TCanvas ;
begin
  Result:=FBox.Canvas ;
end ;

procedure TxyyGraph.RescaleAll ;
var
  i,k : integer ;
  found : integer ;
  xmin,xmax,ymin,ymax : double ;
begin
  found:=0 ;

  for k:=0 to MAXSERIES-1 do begin
    if FSeries[k]=nil then continue ;
    if FSeries[k].size=0 then continue ;
    for i:=0 to FSeries[k].size-1 do begin
      if found=0 then begin
        xmin:=FSeries[k].Fdata[2*i] ;
        xmax:=FSeries[k].Fdata[2*i] ;
        ymin:=FSeries[k].Fdata[2*i+1] ;
        ymax:=FSeries[k].Fdata[2*i+1] ;
        found:=1 ;
        continue ;
      end ;
      if FSeries[k].Fdata[2*i]<xmin then xmin:=FSeries[k].Fdata[2*i] ;
      if FSeries[k].Fdata[2*i]>xmax then xmax:=FSeries[k].Fdata[2*i] ;
      if FSeries[k].Fdata[2*i+1]<ymin then ymin:=FSeries[k].Fdata[2*i+1] ;
      if FSeries[k].Fdata[2*i+1]>ymax then ymax:=FSeries[k].Fdata[2*i+1] ;
    end ;
  end ;

  if found=0 then begin
    FXAxis.Fmin:=0.0 ;
    FXAxis.Fmax:=1.0 ;
    FYAxis.Fmin:=0.0 ;
    FYAxis.Fmax:=1.0 ;
    Exit ;
  end ;

  if xmin>=xmax then begin
    xmax:=xmin+0.5 ;
    xmin:=xmin-0.5 ;
  end ;
  if ymin>=ymax then begin
    ymax:=ymin+0.5 ;
    ymin:=ymin-0.5 ;
  end ;

  FXAxis.Fmin:=xmin ;
  FXAxis.Fmax:=xmax;
  FYAxis.Fmin:=ymin ;
  FYAxis.Fmax:=ymax ;

  FZoomed:=False ;
end ;

procedure TxyyGraph.Resize ;
begin
  //inherited Resize ;
end ;

procedure TxyyGraph.Paint ;
begin
  //inherited Paint ;
  Pintar ;
end ;

procedure TxyyGraph.Pintar ;
label vale ;
var
  Canv : TCanvas ;
  ww,hh : integer ;
  i,j,k,xx,yy : integer ;

  f : double ;
  fx1,fxw,fy1,fyw : double ;
  fxd,fyd : integer ;
  s : string ;
  xf,yf,xfo,yfo : double ;

  bmp : TBitmap ;
  rgn : HRGN ;

  OldPos : TPoint ;
  OldPen : TPen ;
  OldBrush : TBrush ;

  Poly : array [0..MAXDATA-1] of TPoint ;
  PolyN : integer ;

begin
  OldPos:=Canvas.PenPos ;
  OldPen:=Canvas.Pen ;
  OldBrush:=Canvas.Brush ;

  if FToPrinter=False then begin
    ww:=Self.width ;
    hh:=Self.height ;
    Canv:=FBox.Canvas ;

    if FAntiFlicker then begin
      bmp:=TBitmap.Create ;
      bmp.width:=ww ;
      bmp.height:=ww ;
      Canv:=bmp.Canvas ;
    end ;
    end
  else begin
    Canv:=FMyCanvas ;
    ww:=Self.width ;
    hh:=Self.height ;
  end ;

  with Canv do begin
    Brush.Color:=FbackGroundColor ;
    Brush.Style:=bsSolid ;
    Pen.Color:=FbackGroundColor ;
    Pen.Width:=1 ;
    Pen.Style:=psSolid ;
    Rectangle(0,0,ww,hh) ;
  end ;

  Fxx1:=Round(1.2*FYAxis.FTicksSpace*Abs(FYAxis.FTicksFont.Size)) ;
  Fxx2:=ww-Fxx1 div 2 ; // ???
  Fyy1:=Round(1.4*Abs(FXAxis.FTitleFont.Height+FXAxis.FTicksFont.Height)) ;
  Fyy2:=Round(hh-2.0*Abs(FTitleFont.Height)) ;

  // GRAPH TITLE
  with Canv do begin
    Font:=FTitleFont ;
    xx:=Round(ww/2-TextWidth(FTitle)/2) ;
    yy:=Round(hh-Textheight(FTitle)/2+3) ;
    TextOut(xx,hh-yy,FTitle) ;
  end ;

  // EJE X
  with Canv do begin
    Pen:=FXAxis.FAxisPen ;
    MoveTo(GetXpixel(FXAxis.FMin),GetYPixel(FYAxis.FMin)) ;
    LineTo(GetXpixel(FXAxis.FMax),GetYPixel(FYAxis.FMin)) ;
    MoveTo(GetXpixel(FXAxis.FMin),GetYPixel(FYAxis.FMax)) ;
    LineTo(GetXpixel(FXAxis.FMax),GetYPixel(FYAxis.FMax)) ;

    // X TITLE
    Font:=FXaxis.FTitleFont ;
    xx:=Round((Fxx1+Fxx2)/2-TextWidth(FXAxis.FTitle)/2) ;
    yy:=Round(0.5*Fyy1);
    TextOut(xx,hh-yy,FXAxis.FTitle) ;

    // X DIVISIONES
    fx1:=FXAxis.GetDivisionStart ;
    fxw:=FXAxis.GetDivisionSize ;
    fxd:=FXAxis.GetDivisionDigits ;

    // X GRID
    if True then begin
      Pen:=FXAxis.FGridPen ;
      f:=fx1 ;
      while f<=FXaxis.FMax+fxw*0.001 do begin
        MoveTo(GetXpixel(f),GetYPixel(FYAxis.FMin)) ;
        LineTo(GetXpixel(f),GetYPixel(FYAxis.FMax)) ;
        f:=f+fxw ;
      end ;
    end ;

    // X TICKS
    Pen:=FXAxis.FTicksPen ;
    Font:=FXAxis.FTicksFont ;
    f:=fx1 ;
    while f<=FXaxis.FMax+fxw*0.001 do begin
      MoveTo(GetXpixel(f),GetYPixel(FYAxis.FMin)) ;
      LineTo(GetXpixel(f),GetYPixel(FYAxis.FMin)-FXAxis.FTicksLength) ;
      MoveTo(GetXpixel(f),GetYPixel(FYAxis.FMax)) ;
      //LineTo(GetXpixel(f),GetYPixel(FYAxis.FMax)+FXAxis.FTicksLength) ;
      s:=FloatToStrF(f,ffGeneral,FXAxis.GetDivisionDigits,2) ;
      TextOut(GetXpixel(f)-Round(TextWidth(s)/2),hh-Fyy1,s) ;
      f:=f+fxw ;
    end ;

  end ;


  // EJE Y
  with Canv do begin
    Pen.Color:=clBlack ;
    Pen.Width:=1 ;
    Pen.Style:=psSolid ;
    MoveTo(GetXpixel(FXAxis.FMin),GetYPixel(FYAxis.FMin)) ;
    LineTo(GetXpixel(FXAxis.FMin),GetYPixel(FYAxis.FMax)) ;
    MoveTo(GetXpixel(FXAxis.FMax),GetYPixel(FYAxis.FMin)) ;
    LineTo(GetXpixel(FXAxis.FMax),GetYPixel(FYAxis.FMax)) ;

    // Y TITLE ???
    Font:=FYaxis.FTitleFont ;
    TextOut(10,hh-Round(0.5*Fyy1),FYAxis.FTitle) ;

    // Y DIVISIONES
    fy1:=FYAxis.GetDivisionStart ;
    fyw:=FYAxis.GetDivisionSize ;
    fyd:=FYAxis.GetDivisionDigits ;

    // Y GRID
    if True then begin
      Pen:=FYAxis.FGridPen ;
      f:=fy1 ;
      while f<=FYaxis.FMax+fyw*0.001 do begin
        MoveTo(GetXpixel(FXAxis.FMin),GetYpixel(f)) ;
        LineTo(GetXpixel(FXAxis.FMax),GetYpixel(f)) ;
        f:=f+fyw ;
      end ;
    end ;

    // Y TICKS
    Pen:=FYAxis.FTicksPen ;
    Font:=FXAxis.FTicksFont ;
    f:=fy1 ;
    while f<=FYaxis.FMax+fyw*0.001 do begin
      MoveTo(GetXpixel(FXAxis.Fmin),GetYPixel(f)) ;
      LineTo(GetXpixel(FXAxis.Fmin)+FYAxis.FTicksLength,GetYPixel(f)) ;
      MoveTo(GetXpixel(FXAxis.Fmax),GetYPixel(f)) ;
      //LineTo(GetXpixel(FXAxis.Fmax)-FYAxis.FTicksLength,GetYPixel(f)) ;
      s:=FloatToStrF(f,ffGeneral,FYAxis.GetDivisionDigits,2) ;
      TextOut(Fxx1-TextWidth(s)-10,GetYPixel(f)-TextHeight('s')div 2,s) ;
      f:=f+fyw ;
    end ;

  end ;

  // RECUADRO
  with Canv do begin
    Pen:=FXAxis.FAxisPen ;
    MoveTo(GetXpixel(FXAxis.FMin),GetYPixel(FYAxis.FMin)) ;
    LineTo(GetXpixel(FXAxis.FMax),GetYPixel(FYAxis.FMin)) ;
    MoveTo(GetXpixel(FXAxis.FMin),GetYPixel(FYAxis.FMax)) ;
    LineTo(GetXpixel(FXAxis.FMax),GetYPixel(FYAxis.FMax)) ;
    Pen:=FYAxis.FAxisPen ;
    MoveTo(GetXpixel(FXAxis.FMin),GetYPixel(FYAxis.FMin)) ;
    LineTo(GetXpixel(FXAxis.FMin),GetYPixel(FYAxis.FMax)) ;
    MoveTo(GetXpixel(FXAxis.FMax),GetYPixel(FYAxis.FMin)) ;
    LineTo(GetXpixel(FXAxis.FMax),GetYPixel(FYAxis.FMax)) ;
  end ;



  // DATOS
  for k:=0 to MAXSERIES-1 do begin
    if FSeries[k]=nil then continue ;
    if FSeries[k].Visible=False then continue ;
    with Canv do begin
      Brush.Color:=FSeries[k].Color ;
      Brush.Style:=bsSolid ;
      Pen.Color:=FSeries[k].Color ;
      Pen.Width:=1 ;
      Pen.Style:=psSolid ;
    end ;

    // CLIPPING
    if FCLipping then begin
      rgn:=CreateRectRgn(Fxx1+1,hh-Fyy1,Fxx2,hh-Fyy2+1) ;
      SelectClipRgn(Canv.Handle,rgn) ;
    end ;

    // DRAW LINES
    if (FSeries[k].FLines) and (FSeries[k].Size>=2) then begin
      PolyN:=0 ;
      for i:=0 to FSeries[k].Size-2 do begin
        xfo:=FSeries[k].FData[2*i] ;
        yfo:=FSeries[k].FData[2*i+1] ;
        xf:=FSeries[k].FData[2*i+2] ;
        yf:=FSeries[k].FData[2*i+3] ;

        if FClipping then begin
          // SI ESTA DENTRO
          if (xfo>=FXAxis.FMin) and (xfo<=FXAxis.FMax) and
             (xf>=FXAxis.FMin) and (xf<=FXAxis.FMax) and
             (yfo>=FYAxis.FMin) and (yfo<=FYAxis.FMax) and
             (yf>=FYAxis.FMin) and (yf<=FYAxis.FMax) then goto vale ;

          // SI ESTAN FUERA LOS DOS FUERA
          if (xfo<FXAxis.FMin) and (xf<FXAxis.FMin) then continue ;
          if (xfo>FXAxis.FMax) and (xf>FXAxis.FMax) then continue ;
          if (yfo<FYAxis.Fmin) and (yf<FYAxis.Fmin) then continue ;
          if (yfo>FYAxis.Fmax) and (yf>FYAxis.Fmax) then continue ;

        end ;

        vale:
        if True then begin
          Poly[PolyN].x:=GetxPixel(xfo) ;
          Poly[PolyN].y:=GetyPixel(yfo) ;
          PolyN:=PolyN+1 ;
          end
        else begin
          Canv.MoveTo(Getxpixel(xfo),Getypixel(yfo)) ;
          Canv.LineTo(Getxpixel(xf),Getypixel(yf)) ;
        end ;

      end ;

      if PolyN>1 then Canv.PolyLine(Slice(Poly,PolyN)) ;

    end ;

    // DRAW POINTS
    if (FSeries[k].FPoints) and (FSeries[k].Size>0) then begin
      for i:=0 to FSeries[k].Size-1 do begin
        xf:=FSeries[k].Fdata[2*i] ;
        yf:=FSeries[k].Fdata[2*i+1] ;
        if FClipping then begin
          if (xf<FXAxis.Fmin) or (xf>FXAxis.FMax) then continue ;
          if (yf<FYAxis.Fmin) or (yf>FYAxis.FMax) then continue ;
        end ;
        xx:=GetXPixel(xf) ;
        yy:=GetYPixel(yf) ;
        Canv.Rectangle(xx-2,yy-2,xx+2,yy+2) ;
      end ;
    end ;

    // DELETE CLIPPING
    if FCLipping then DeleteObject(rgn) ;

  end ;

  Canv.PenPos:=OldPos ;
  Canv.Pen:=OldPen ;
  Canv.Brush:=OldBrush ;

  if FAntiFlicker and (FToPrinter=False) then begin
    FBox.Canvas.Draw(0,0,bmp) ;
    bmp.Free ;
  end ;

end ;

procedure TxyyGraph.Update ;
begin
  if FAutoScaling and (not FZoomed) then RescaleAll ;
  Pintar ;
end ;

function TxyyGraph.GetSeries(i:integer):TxyyGraphSeries;
begin
  if (i<0) or (i>=MAXSERIES) then begin  // FATAL ERROR ???
    MessageDlg('xyyGraph FATAL ERROR accesing nonexisting series',mtInformation,
      [mbOk], 0);
    Application.Terminate ;
  end ;
  if Fseries[i]=nil then begin
    Fseries[i]:=TxyyGraphSeries.Create ;
  end ;
  Result:=FSeries[i] ;
end ;

function TxyyGraph.Clear : Boolean ;
var i : integer ;
begin //
  for i:=0 to MAXSERIES-1 do begin
    if FSeries[i]<>nil then FSeries[i].Clear ;
  end ;
  Result:=True ;
end ;

procedure TxyyGraph.PClick(Sender:TObject) ;
begin
  if csDesigning in ComponentState then Pintar ;
  if Assigned(FClick) then FClick(Self) ;
end ;

procedure TxyyGraph.PMouseDown(Sender:TObject;Button:TMouseButton;Shift:TShiftState;X,Y:Integer);
begin
  if (not FZooming) and (Button=mbRight) and (True) then begin
    Fmousex1:=x ;
    Fmousey1:=y ;
    Fmousex2:=x ;
    Fmousey2:=y ;
    FZooming:=True ;
    Canvas.Pen.Color:=FBackgroundColor ;
    Canvas.Pen.Style:=psDot ;
    Canvas.Pen.Width:=2 ;
    Canvas.Pen.Mode:=pmXor ;
    Canvas.Brush.Style:=bsClear ;
    Canvas.Rectangle(Fmousex1,Fmousey1,Fmousex2,Fmousey2) ;
    Canvas.Pen.Style:=psSolid ;
    Canvas.Pen.Width:=1 ;
    Canvas.Pen.Mode:=pmCopy ;
  end ;
  if Assigned(FMouseDown) then FMouseDown(Self,Button,Shift,x,y) ;
end ;

procedure TxyyGraph.PMouseUp(Sender:TObject;Button:TMouseButton;Shift:TShiftState;X,Y:Integer);
var
  k : integer ;
  x1,x2,y1,y2 : double ;
begin
  if (FZooming) and (Button=mbRight) then begin
    Canvas.Pen.Color:=FBackgroundColor ;
    Canvas.Pen.Style:=psDot ;
    Canvas.Pen.Width:=2 ;
    Canvas.Pen.Mode:=pmXor ;
    Canvas.Brush.Style:=bsClear ;
    Canvas.Rectangle(Fmousex1,Fmousey1,Fmousex2,Fmousey2) ;
    FZooming:=False ;
    Canvas.Pen.Style:=psSolid ;
    Canvas.Pen.Width:=1 ;
    Canvas.Pen.Mode:=pmCopy ;

    if (Abs(Fmousex1-Fmousex2)<8) and (Abs(Fmousey1-Fmousey2)<8) then begin
      FZoomed:=False ;
      RescaleAll ;
      Pintar ;
      Exit ;
    end ;

    // MAKE ZOOM
    if (Fmousex1<>Fmousex2) and (Fmousey1<>Fmousey2) then begin
      if FMousex1>FMousex2 then begin k:=FMousex1 ; Fmousex1:=fmousex2 ; Fmousex2:=k ; end ;
      if FMousey1<FMousey2 then begin k:=FMousey1 ; Fmousey1:=fmousey2 ; Fmousey2:=k ; end ;

      x1:=GetX(Fmousex1) ;
      x2:=GetX(Fmousex2) ;
      y1:=GetY(Fmousey1) ;
      y2:=GetY(Fmousey2) ;

      FXAxis.FMin:=x1 ;
      FXAxis.FMax:=x2 ;
      FYAxis.FMin:=y1 ;
      FYAxis.FMax:=y2 ;

      FZoomed:=True ;
      Pintar ;
    end ;

  end ;
  if Assigned(FMouseUp) then FMouseUp(Self,Button,Shift,x,y) ;
end ;

procedure TxyyGraph.PMouseMove(Sender:TObject;Shift:TShiftState;X,Y:Integer);
begin
  if FZooming then begin
    Canvas.Pen.Color:=FBackgroundColor ;
    Canvas.Pen.Mode:=pmXor ;
    Canvas.Pen.Style:=psDot ;
    Canvas.Brush.Style:=bsClear ;
    Canvas.Pen.Width:=2 ;
    Canvas.Rectangle(Fmousex1,Fmousey1,Fmousex2,Fmousey2) ;
    Fmousex2:=x ;
    Fmousey2:=y ;
    Canvas.Rectangle(Fmousex1,Fmousey1,Fmousex2,Fmousey2) ;
    Canvas.Pen.Style:=psSolid ;
    Canvas.Pen.Width:=1 ;
    Canvas.Pen.Mode:=pmCopy ;
  end ;
  if Assigned(FMouseMove) then FMouseMove(Self,Shift,x,y) ;
end ;

/////////////////////////////////////////////////////////////////////////////
////////////////////////   TxyyGraphAxis ////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////


constructor TxyyGraphAxis.Create(AGraph:TxyyGraph;kind:integer) ;
begin
  FGraph:=AGraph ;

  FTitleFont:=TFont.Create ;
  FTitleFont.Name:='Arial' ;
  FTitleFont.Size:=8 ;
  FTitleFont.Color:=clBlack ;
  FTitleFont.Style:=[fsBold] ;

  FAxisPen:=TPen.Create ;
  FTicksPen:=TPen.Create ;
  FGridPen:=TPen.Create ;
  FGridPen.Color:=clSilver ;
  FGridPen.Style:=psDot ;

  FGraph:=AGraph ;
  FKind:=kind ;
  FMin:=0.0 ;
  FMax:=1.0 ;
  case kind of
    0 : FTitle:='X axis' ;
    1 : FTitle:='Y axis' ;
    else FTitle:='' ;
  end ;

  FTicksFont:=TFont.Create ;
  FTicksFont.Name:='Arial' ;
  FTicksFont.Size:=8 ;
  FTicksFont.Color:=clBlack ;

  FTicksNumber:=0 ;
  FTicksLength:=6 ;
  FTicksSpace:=4 ;

end ;

destructor TxyyGraphAxis.Destroy ;
begin
  FTitleFont.Free ;
  FTicksFont.Free ;
  FAxisPen.Free ;
  FTicksPen.Free ;
  FGridPen.Free ;
end ;

procedure TxyyGraphAxis.SetMin(v:double) ;
begin
  FGraph.FZoomed:=True ;
  if v>=FMax then begin
    FMin:=v ;
    FMax:=v+1e-6 ;
    Exit ;
  end ;
  FMin:=v ;
end ;

procedure TxyyGraphAxis.SetMax(v:double) ;
begin
  FGraph.FZoomed:=True ;
  if v<=FMin then begin
    FMax:=v ;
    FMin:=v-1e-6 ;
    Exit ;
  end ;
  FMax:=v ;
end ;

procedure TxyyGraphAxis.SetTicksSpace(i:integer) ;
begin
  if i<0 then i:=1 ;
  if i>20 then i:=20 ;
  FTicksSpace:=i ;
end ;

function TxyyGraphAxis.GetDivisionStart : double ;
var
  fw,f1 : double ;
begin
  fw:=GetDivisionSize ;
  if FMin>=0.0 then begin
    f1:=fw*Floor(FMin/fw) ;
    if f1<Fmin then f1:=f1+fw ;
    end
  else begin
    f1:=fw*Floor(Fmin/fw) ;
    if f1<Fmin then f1:=f1+fw ;
  end ;

  Result:=f1 ;
end ;

function TxyyGraphAxis.GetDivisionSize : double ;
var
  ndiv : integer ;
  ff : double ;
  fw : double ;
  signif : integer ;
begin
  ndiv:=FTicksNumber ;
  if ndiv=0 then ndiv:=3 ;

  // ANCHO TICKs
  ff:=(Fmax-fmin)/(ndiv+1) ;
  signif:=Round(Log10(ff)) ;

  fw:=ff/Power(10,signif) ;
  if fw>=1.5 then fw:=2.0 ;
  if (fw>=0.8) and (fw<1.5) then fw:=1.0 ;
  if (fw>=0.4) and (fw<0.8) then fw:=0.5 ;
  if fw<0.4 then fw:=0.2 ;

  fw:=fw*Power(10,signif) ;
  Result:=fw ;
end ;

function TxyyGraphAxis.GetDivisionDigits : integer ;
var
  fw : double ;
  signif : integer ;
begin
  fw:=GetDivisionSize ;

  signif:=Floor(Log10(fw)) ;

  if signif>0 then signif:=Signif+1 ;
  if signif<0 then signif:=-Signif+1 ;
  if signif=0 then signif:=1 ;

  Result:=signif ;
end ;


/////////////////////////////////////////////////////////////////////////////
////////////////////////   TxyyGraphSeries //////////////////////////////////
/////////////////////////////////////////////////////////////////////////////

constructor TxyyGraphSeries.Create ;
begin
  Fn:=0 ;
  Fdata:=nil ;
  FColor:=clBlack ;
  FPoints:=True ;
  FLines:=True ;
  FVisible:=True ;
  FSecondAxis:=False ;
end ;

destructor TxyyGraphSeries.Destroy ;
begin
  if Fn<>0 then FreeMem(Fdata) ;
end ;

function TxyyGraphSeries.AddPoint(x,y:double):Boolean ;
begin
  if Fn=0 then GetMem(Fdata,2*8*MAXDATA) ;
  if Fn>=MAXDATA then begin Result:=False ; Exit ; end ;
  Fdata[2*Fn]:=x ;
  Fdata[2*Fn+1]:=y ;
  Fn:=Fn+1 ;
  Result:=True ;
end ;

function TxyyGraphSeries.GetX(i:integer):double ;
begin
  if (i<0) or (i>=Fn) then begin Result:=0.0 ; Exit ; end ;
  Result:=Fdata[2*i] ;
end ;

function TxyyGraphSeries.GetY(i:integer):double ;
begin
  if (i<0) or (i>=Fn) then begin Result:=0.0 ; Exit ; end ;
  Result:=Fdata[2*i+1] ;
end ;

function TxyyGraphSeries.Clear : Boolean ;
begin
  if Fn<>0 then FreeMem(Fdata) ;
  Fn:=0 ;
  Result:=True ;
end ;


procedure TxyyGraph.UpdateMyCanvas(MyCanvas:TCanvas) ;
begin //
  FMyCanvas:=MyCanvas ;
  FToPrinter:=True ;
  Pintar ;
  FToPrinter:=False ;
end ;


end.
