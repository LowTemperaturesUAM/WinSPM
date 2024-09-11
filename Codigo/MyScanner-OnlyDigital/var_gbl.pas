unit var_gbl;

interface
uses Windows, Graphics, SysUtils, AnsiStrings;

const
ldatos = 2048;
MAXCURVAS =100;
MaxCuadros = 100;
MaxCurmeds = 100;
MaxImgDatos = 128;


type
vector = array [0..ldatos] of single;
vector2 = array [0..2*ldatos] of single;
Tiscan = array [0..ldatos] of smallint;
TiscanL = array [0..2*ldatos] of smallint;
HImg = array [0..512,0..512] of single;

TScanBitmap = record
  x: Single;
  y: Single;
  sizeX: Single;
  sizeY: Single;
  bitmap: TBitmap;
end;

TWSxMClipboardHeader = record
  szFileName: array[0..MAX_PATH-1] of Char; //Nombre del fichero Temporal
  szRealFileName: array[0..MAX_PATH-1] of Char; //Nombre de la ruta completa del fichero real (sólo para movies)
  ulSize: ULONGLONG; //Tamaño del fichero a copiar
  bIsMovie: Boolean; //Variable booleana que identifica si es una movie lo que hay en el portapapeles
	bIsInClipBoard: Boolean; //Variable que identifica si el archivo era demasiado grande para estar en el clipboard como temporal,
                           // así que no se borra el temporal y se mantiene en la carpeta.
  pading: array[0..5] of Char;
  data: char; // No forma parte de la cabecera en sí, sino que marca dónde empiezan los datos
end;


vectorcontador = array [0..512] of Integer;
vectorsize = array [0..512] of Single;
vectorbitmap = array [0..512] of TBitmap;

vcurva = record
               x : vector;
               y : vector;
               n : integer;
               end;

TIMGheader = record
    identif : integer ; // $00333333
    version : integer ; // $00010000
    day : word ;      // 1-31
    month : word ;    // 1 = Enero ... 12=Diciembre
    year : word    ;  // e.g. 2003
    moment : double ; // seconds of day
    time : double ;   // seconds (final-start)

    xstart,xend : double ;
    ystart,yend : double ;
    xn,yn : integer ;

    // 62 bytes
    vacio : array [0..449] of byte ;  //512-50=462
    // 512 bytes
    comment : array [0..511] of char ;
  end ;

infocurva = record
               name : AnsiString;
               decolor :integer;
                    w1   : word;
                    w2   : word;
                    w3   : word;
                    ctipo: byte;
                    samp : smallint;

                    RX   : single;
                    RY   : single;
                    RXp  : single;
                    RYp  : single;
                    RZ   : single;
                    RZp  : single;

                    vtun : single;
                    vini : single;
                    vppr : single;

                    rang : single;
                    Srate: single;
                    Wrate: single;
                    fcon : smallint;
                    AutoV: smallint;
                    DTram: smallint;
                    DThol: smallint;
                    DTclk: byte;
                    expo : byte;
                    ZpDAC: single;

                normy : single;
                Gparal : single;
               end;


Newcurva = record
                    name : array [1..13] of char;
                    w1   : word;
                    w2   : word;
                    w3   : word;
                    ctipo: byte;
                    samp : smallint;

                    RX   : single;
                    RY   : single;
                    RXp  : single;
                    RYp  : single;
                    RZ   : single;
                    RZp  : single;

                    vtun : single;
                    vini : single;
                    vppr : single;

                    rang : single;
                    Srate: single;
                    Wrate: single;
                    fcon : smallint;
                    AutoV: smallint;
                    DTram: smallint;
                    DThol: smallint;
                    DTclk: byte;
                    expo : byte;
                    ZpDAC: single;
                    blank: array [1..44] of byte;

                    ptos : array [1..1024] of word;

                end;

TBLK_dat = array [1..1024] of smallint;
//TBLK_dat = array [1..2048] of smallint;
TBLK_cab = record
                    name : array [0..10] of char;        // habia 12
                    w1   : word;
                    w2   : word;
                    w3   : word;
                    ctipo: byte;
                    //samp : smallint;
                    samp : smallint;

                    RX   : single;
                    RY   : single;
                    RXp  : single;
                    RYp  : single;
                    RZ   : single;
                    RZp  : single;

                    vtun : single;
                    vini : single;
                    vppr : single;

                    rang : single;
                    Srate: single;   // lk_sens
                    Wrate: single;   // lk_filtro
                    fcon : smallint;
                    AutoV: smallint;
                    DTram: smallint;
                    DThol: smallint;
                    DTclk: byte;
                    expo : byte;
                    ZpDAC: single;
                 //   blank: array [1..44] of byte;
                    blank: array [1..40] of byte;

                 end;


//------------fich fotos
//Cabecera foto:

TIMG_cab = Record

   identif1,identif2,version : word ;
   fich : array [0..15] of char ;
   cut,micro,person : word ;

   lgain,lzero : single ;
   iuve,itun,bias,intens : single ;

   az,azz,azzz,ax,ay,axx,ayy : single ;
   lz,lzz,lzzz,lx,ly,lxx,lyy,li : single ;
   cz,czz,czzz,cx,cy,cxx,cyy : single ;
   z,zz,zzz,x,y,xx,yy,integ : single ;

   rng1x,rng1y,rng2x,rng2y,corrx,corry : single ;
   plnx,plny : single ;

   speed,tiempo : single ;
   stepsx,stepsy : word ;

   modol,modob : word ;

   fil1,fil2,only,scnf : word ;

   comment : array[0..99] of char ;

   levertyp,zeltyp,zelgain : word ;
   zelcalx,zelcaly,zelcalx0,zelcaly0,zelsum : single ;
   zelx,zely,zelx0,zely0 : single ;
   leverk,leverkt,leverf0,leverf,levera : single ;

   vacio : array [0..60] of word ;

   end;





// Colores
const clNaranja=$004080FF;
      clAzulClaro=$00FF8000;
var
elcolor : array[1..14] of integer =
                       (clBlack, clMaroon,
                       clDkGray, clRed,
                       clNavy, clNaranja,
                       clBlue, clFuchsia,
                       clGreen, clPurple,
                       clAzulClaro, clOlive,
                       clTeal, clLime);


type

datalims = array [1..4] of single;
intlims = array [1..4] of integer;
tcruz = record
          x : single;
          y : single;
          end;
var

Npromedios : integer = 20;
dadac1last : word = $0000;
WORDPIOPRIMA : word = $00;
WORDCONTROL : word = $00;

vXDAC, vYDAC, vZDAC : single; // los DACS en +-10 V
vXpot, vYpot, vZpot : single; // los potenciometros en +-10 V
vXtot, vYtot, vZtot : single; // DACS + Pot en +-10 V
//vXDAC, vYDAC, vZDAC : single;
vpotenX : single =0;
vpotenY : single =0;
vXXtot, vYYtot, vZZtot : single;
vbias1,vfinbias1, vbias2,vfinbias2,
vb_ini, vb_fin                 : single;


// curvas BLK
curva : array [1..2] of array [1..MAXCURVAS] of vcurva; //real, para pintar
//icurva : array [1..MAXCURVAS] of infocurva;
cabcurva : array [1..2] of array [1..MAXCURVAS] of TBLK_cab;
datcurva : array [1..2] of array [1..MAXCURVAS] of TBLK_dat;
fcurva : file;

codtipocurva : byte;

//parametros de medida de curvas
puntos : integer =1024;
pderi : integer = 20;

//generales
NumCuadros: integer = 0;
NumCurMeds: integer =0;

cuadro : array [1..Maxcuadros] of datalims;
curMeds : array [1..Maxcurmeds] of Tcruz;
ocruz, cruz, Ncruz : Tcruz;   //coords de cruz y cuadros en voltios de los DACS
Tapete_lims, MaxBarr_lims, Barr_lims, oBarr_lims,
 oDAClims,DAClims, BarrDAC_lims  : datalims;
ctroBDAC,oriBarrDAC, vrap, vlen : Tcruz;
BarrLado : single;
pixrect : intlims;
pasosDAC : smallint = 100;
delayDAC : integer = 100;

ptosfoto : integer = 128;
orient : smallint;

ApVxy : single = 100;
ApVz : single = 50;
AmplPiezosXY: single = 13.0;
AmplPiezoZ: single = 13.0;
BandasXY : integer = 2;
BandasZ : integer = 1;

RangoIV : single = 1E8;

//factores para unidades correctas al pintar:
factor_PX : single = 1.0;
factor_PY : single = 1.0;
factor_lkT : single = 1.0;

lk_sens : single = 300.0;
lk_filtro : single = 100.0;

scandato : vector2;
foto_running : boolean = false;


C_biasIV, C_biasIZ, C_biasZV,
C_lectIV, C_lectIZ, C_lectZV,
C_lectCorr, C_lectZeta, C_lectLockin : integer;

signo_lect : array [0..2] of integer;

//gains : array [0..7] of shortint = (1, 1, 1, 1, 1, 1, 1, 1);


//Qbmp : array [0..1] of TBitmap;


  iscanL : array[0..2] of TiscanL;
  iscan : array[1..2,0..2] of Tiscan;


  iov, indi : integer;

  fileZ : array[0..1] of file;
  fileCorr : array[0..1] of file;
  fileLockin : array[0..1] of file;

 
  
  b : array [0..3*1024-1] of byte ;
  FPalette : array [0..511,0..2] of byte ;


function MyFormat(const FormatStr: Ansistring; const Args: array of const): AnsiString;


implementation

function MyFormat(const FormatStr: AnsiString; const Args: array of const): AnsiString;
begin
{$IfDef VER150}
  MyFormat:=Format(FormatStr, Args);
{$Else}
  MyFormat:=AnsiStrings.Format(FormatStr, Args, TFormatSettings.Invariant);
{$EndIf}
end;

end.
