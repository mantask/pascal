{***Special for Mantas & others ... who thinks that I'm the worst at TP***
****************  256(8bit) spalvu bitmap'o nuskaitymas  *****************
 Jei plotis>byte arba aukstis>byte (255), tai galima atsidaryti kaip word
   faila (file of word) ir nuskaityti matmenis, poto skaityti kaip byte}

Program Eksperimentai_su_BMP;

uses
  Crt,Graph;

var
  f: file of byte;
  W: file of word;
  f2: text;
  x, y, aukstis, plotis, k:word;
  kodas, spalva: byte;
  pal: array [0 .. 255] of record r, g, b: byte end;
  gd, gm: integer;
  adresas: string;

Procedure CheckKey;
begin
{  case readkey of
    #27:halt(0);
  end;}
end;

Procedure Preview;
begin
  InitGraph(gd, gm, '');
  Assign(w,adresas);
  Reset(w);
  for k:=1 to 10 do
    Read(w,x);
  plotis:=x;
  for k:=11 to 12 do
    Read(w,x);
  aukstis:=x;
{Yra visokie ten INFOHEADER'iai kuriu as nesuvirskinau ir todel skaitau
matmenis savo budu.}
  Close(w);
  Assign(f2,'bitmap.dat');
  Rewrite(f2);
  WriteLn(f2,plotis,'*',aukstis,'*',256);
  Assign(f,adresas);
  Reset(f);
  for x:=1 to 1078 do read(f,kodas);
  for y:=0 to aukstis-1 do begin
    for x:=0 to plotis-1 do begin
      Read((f),kodas);
      PutPixel(x,aukstis-y,kodas);
      Write(f2,chr(kodas));
    end;
    WriteLn(f2);
  end;
  Close(f);
  Close(f2);
  Readkey;
  CloseGraph;
end;

begin
  adresas:='eg.bmp';
  TextColor(LightGray);
  TextBackGround(0);
  ClrScr;
  Assign(f,adresas);
  Reset(f);
  for x:=1 to 18 do begin
    Read(f,kodas);
    WriteLn(x:10,kodas:4);
    CheckKey;
  end;
  Read(f,kodas);
  WriteLn(19:10,kodas:4,'  - paveikslelio plotis pixeliais');
  WriteLn('plotis:=',kodas,';');
  Plotis:=kodas;
  CheckKey;
  for x:=20 to 22 do begin
    Read(f,kodas);
    WriteLn(x:10,kodas:4);
    CheckKey;
  end;
  Read(f,kodas);
  WriteLn(23:10,kodas:4,'  - paveikslelio aukstis pixeliais');
  WriteLn('aukstis:=',kodas,';');
  aukstis:=kodas;
  CheckKey;
  for x:=24 to 54 do begin
    read(f,kodas);
    WriteLn(x:10,kodas:4);
    CheckKey;
  end;
  WriteLn;
  WriteLn('Nuo cia prasideda spalvu palete');
  WriteLn;
  y:=3;
  for x:=55 to 1078 do begin
    Read(f,kodas);
    y:=y+1;
    if y=4 then y:=0;
    case y of
      0:spalva:=red;
      1:spalva:=green;
      2:spalva:=blue;
      3:spalva:=LightGray;
    end;
    TextColor(spalva);
    if spalva=LightGray then
      WriteLn(x:30,kodas:4)
        else if spalva=red then begin
          Inc(k);
          TextColor(LightGray);
          Write(k:3);
          Textcolor(red);
          WriteLn(x:7,kodas:4);
        end
          else WriteLn(x:10,kodas:4);
    case spalva of
      red:begin
            pal[k-1].r:=kodas;
          end;
      green:begin
              pal[k-1].g:=kodas;
            end;
      blue:begin
             pal[k-1].b:=kodas;
           end;
    end;
    CheckKey;
  end;
  for y:=1 to aukstis do begin
    for x:=1 to plotis do begin
      Read(f,kodas);
{     WriteLn(y:10,x:10,kodas:20);}
      CheckKey;
    end;
  end;
  Close(f);
  Preview;
end.
{P.S. Jei norite atvaizduoti 320*200*256 ekrane, tai reikia perjungti
i si rezima ir per portus ijungti palete (irasu masyvas pal[0..255] of rgb)}