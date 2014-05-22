uses
  crt, dos;

type
  ekranas = array [0..319, 0..199] of byte;

var
  k, a, b: word;
  kx, ky: integer;
  z: byte;
  adr: string;

Procedure Putpixel(x,y,spalva:word);
  begin
    if (x<320) and (x>-1) and (y<200) and (y>-1) then
      mem[$a000:y*320+x] := spalva;
  end;

Procedure Palete_is_failo(adresas:string);
  var
    f: file;
    pal: array [0 .. 255] of record b, g, r, z: byte; end;
    masas: array [1..54] of byte;
    S: word;
  begin
    Assign(f, adresas); Reset(f, 1);
    S := FileSize (f);
    if s > 65535 then exit;
    BlockRead (f, masas, 54);
    BlockRead (f, pal, 256*4);
    Close(f);
    port[$3c8] := 0;
    for s := 0 to 255 do  begin
      port[$3c9] := pal[s].r div 4;
      port[$3c9] := pal[s].g div 4;
      port[$3c9] := pal[s].b div 4;
    end;
  end;

Procedure Failas_i_ekrana(Adresas:string; kx, ky: integer; zm: byte);
  var
    wf: file of word;
    bf: file;
    kint, w, plotis, aukstis, pb, y2, S, x, y: word;
    mas: array [0..1078] of byte;
  begin
    Assign(wf, adresas);
    Reset(wf);
    for kint := 1 to 10 do
      read(wf, w);
    plotis := w;
    for kint := 11 to 12 do
      read(wf, w);
    aukstis := w;
    Close(wf);
    Assign(bf, adresas);
    Reset(bf, 1);
    S:= FileSize(bf);
    BlockRead(bf, mas, 1078);
    pb := plotis-(plotis div 4)*4;
    pb := 4-pb;
    if pb=4 then pb:=0;
    for y:=0 to aukstis-1 do begin
      BlockRead(bf, mas, plotis + pb);
      for x:=0 to plotis-1 do begin
        b := mas[x];
        y2 := (aukstis-y-1);
        PutPixel((x div zm) + kx, (y2 div zm) + ky, b);
      end;
    end;
    Close(bf);
  end;

begin
  asm
    mov ax, 13h
    int 10h
  end;
  adr:='e:\programs\tp\prog\geras.bmp';
  Palete_Is_Failo(adr);
  kx := -400;
  ky := -50;
  z := 1;
  Repeat
    for b := 0 to 199 do
      for a := 0 to 319 do
        mem[$a000:b*320+a] := 0;
    Failas_i_ekrana(adr, kx, ky, z);
    case ReadKey of
      #0:case ReadKey of
           #75: Inc(kx, 100);
           #77: Dec(kx, 100);
           #72: Inc(ky, 100);
           #80: Dec(ky, 100);
           #71: Inc(ky, 10);
           #79: Dec(ky, 10);
           #83: Inc(kx, 10);
           #81: Dec(kx, 10);
         end;
      #45:Inc(z);
      #43:if z>1 then Dec(z);
      #114:begin kx:=0; ky:=0; z:=3 end;
      #82:begin kx:=0; ky:=0; z:=3 end;
      #27:begin
            asm
              mov ax, 03h
              int 10h
            end;
            Halt(0);
          end;
    end;
  until false;
end.
