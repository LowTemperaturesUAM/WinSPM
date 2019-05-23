unit U_fCurva;

interface

uses var_gbl, sysutils;


procedure Crea_cabBLK( var cabe: TBLK_cab; num : integer;
                           tipoc : byte; hlk : integer);

procedure AbrefichBLK(hlk: integer); // var fc: file);
procedure Escribe_Cab( j,i : integer);
procedure Escribe_dat( j,i : integer);
procedure CierrafichBLK;

implementation


procedure Crea_cabBLK( var cabe: TBLK_cab; num : integer;
                           tipoc : byte; hlk : integer);
var i,signo : integer;
    ape : string;
    pcnom : Pchar;
    ss : string;
begin
signo:=2*(num mod 2)-1;
case hlk of
     1: ape:='d.';
     2: ape:='l.';
     end;


//para prueba
  //vbias1:=35.0; vbias2:=150.0;

with cabe do begin

                    ss :=  curname+ inttostr(curserienum)+ape+
                            inttostr(curmednum+num);
                    strpcopy(name,ss);
                    w1   := $00;
                    w2   := $00;
                    w3   := $DF01;
                    ctipo:= tipoc;
                    samp := puntos;

                    RX   := vXDAC;
                    RY   := vYDAC;
                    RXp  := vXXtot;
                    RYp  := vYYtot;
                    RZ   := vZtot;
                    RZp  := vZZtot;

                    vtun := vbias1;
                 case tipoc of
                      $00,$10 : begin
                                   case signo of
                                        -1: begin vini:=vb_ini;vppr:=vb_fin-vb_ini;end;
                                         1: begin vini:=vb_fin;vppr:=vb_ini-vb_fin;end;
                                         end;
                                  //vini := signo*abs(vbias1);
                                  //vppr := -2.0*abs(vbias1)*signo;
                                  end;
                      $01,$11 : begin
                                  //vini := abs(vbias2)*signo;
                                  //vppr := -2.0*abs(vbias2)*signo;
                                  case signo of
                                        -1: begin vini:=vb_ini;vppr:=vb_fin-vb_ini;end;
                                         1: begin vini:=vb_fin;vppr:=vb_ini-vb_fin;end;
                                         end;
                                  end;
                      end;

                    rang := rangoIV;
                    Srate:= lk_sens;
                    Wrate:= lk_filtro;
                    fcon := -1;
                    AutoV:=0; //smallint;
                    DTram:=0; // smallint;
                    DThol:= 0; // smallint;
                    DTclk:=0; // byte;
                    expo := 8;//round(log10(rang)); // byte;
                    ZpDAC:= vZDAC; //single;
               for i:=1 to 44 do blank[i]:=$00; // array [1..44] of byte;
end;
end;

procedure AbrefichBLK(hlk: integer);  //; var fc: file);
var fn: string;
begin
case hlk of
     1: fn:=fullcurname+inttostr(curserienum)+'d.'+
                            inttostr(curmednum+1);
     2: fn:=fullcurname+inttostr(curserienum)+'l.'+
                            inttostr(curmednum+1);
     end;
AssignFile(fcurva,fn);
Rewrite(fcurva,1);
end;

procedure Escribe_Cab(j,i : integer);
begin
Blockwrite(fcurva, cabcurva[j][i], sizeof(TBLK_cab) );
end;

procedure Escribe_dat(j,i : integer);
begin
Blockwrite(fcurva, datcurva[j][i], 2*puntos);
end;

procedure CierrafichBLK;
begin
CloseFile(fcurva);
end;

end.
