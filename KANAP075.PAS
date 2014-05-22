{ MK 2001                    }
{ Mantas Kanaporis           }
{ Vilniaus Ïemynos gimnazija }
{ -------------------------- }
{ VII skyrius                }
{ 4 uØdavinys                }

{ Animacija nutraukiama Esc mygtuku }

program kanap075;

uses
  graph;

const
  { trys valÑiÖ kadrai }
  valtis1 : array [0 .. 14, 0 .. 19] of 0 .. 1 =
  ((0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0),
   (0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0),
   (0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0),
   (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
   (0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0),
   (0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0),
   (0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0),
   (0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0),
   (0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0),
   (0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0),
   (1,1,1,1,0,0,0,1,1,0,0,1,1,0,0,0,1,1,1,1),
   (0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0),
   (0,0,1,1,0,1,0,1,0,1,1,0,1,0,1,0,1,1,0,0),
   (0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0),
   (0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0));
  valtis2 : array [0 .. 14, 0 .. 19] of 0 .. 1 =
  ((0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0),
   (0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0),
   (0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0),
   (0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0),
   (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
   (0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0),
   (0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0),
   (0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0),
   (0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0),
   (0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0),
   (1,1,1,1,0,0,0,1,1,0,0,1,1,0,0,0,1,1,1,1),
   (0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0),
   (0,0,1,1,0,1,0,1,0,1,1,0,1,0,1,0,1,1,0,0),
   (0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0),
   (0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0));
  valtis3 : array [0 .. 14, 0 .. 19] of 0 .. 1 =
  ((0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
   (0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0),
   (0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0),
   (0,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0),
   (0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0),
   (0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0),
   (0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0),
   (0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0),
   (0,0,0,0,0,0,0,0,1,0,0,1,0,0,0,0,0,0,0,0),
   (0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0),
   (1,1,1,1,0,0,0,1,1,0,0,1,1,0,0,0,1,1,1,1),
   (0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0),
   (0,0,1,1,0,1,0,1,0,1,1,0,1,0,1,0,1,1,0,0),
   (0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0),
   (0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0));
  pozx = 359;                       { valties pozicija x aÕies atØvilgiu }
  mastelis = 2;                     { valties pieÕimo mastelis }

Type
  Tdangus = Object                  { fonas, t.y., dangus }
    zvaigzdes : array [0 .. 99] of record
                                     x : 0 .. 639;
                                     y : 0 .. 399;
                                   end;
    constructor paruosk;
    procedure pastumk;
    procedure trink;
    procedure piesk;
  end;

var
  beta, kadras,
  gm, gd,
  poz, alfa : integer;
  dangus : Tdangus;

constructor Tdangus.paruosk;
var
  ck : byte;
begin
  for ck := 0 to 99 do
  begin
    zvaigzdes [ck].x := random (640);
    zvaigzdes [ck].y := random (400);
  end
end;

procedure Tdangus.pastumk;
var
  ck : byte;
begin
  for ck := 0 to 99 do
  zvaigzdes [ck].x := (zvaigzdes [ck].x + 639) mod 640;
end;

procedure Tdangus.trink;
var
  ck : integer;
begin
  for ck := 0 to 99 do
  putpixel (zvaigzdes [ck].x mod 640, zvaigzdes [ck].y, 0)
end;

procedure Tdangus.piesk;
var
  ck : integer;
begin
  for ck := 0 to 99 do
  putpixel (zvaigzdes [ck].x, zvaigzdes [ck].y, 8)
end;

{ palaukia vertikalaus ekrano perpieÕmo, animacija maØiau mirga }
Procedure waitRetrace; Assembler;
asm
   mov dx,3DAh
@@1:
   in al,dx
   and al,08h
   jnz @@1
@@2:
   in al,dx
   and al,08h
   jz  @@2
end;

{ pieÕiama valtis }
procedure putValtis (nr : byte; x, Y : integer; alfa : real; sp : byte);
var
  pgx, pgy, ckx, cky : integer;
  R, beta : real;
begin
  alfa := alfa * pi / 180;        { paverciam i radianus }
  for ckx := 0 to 19 do
  for cky := 0 to 14 do
  begin
    R := sqrt (ckx * ckx + cky * cky);
    if ckx = 0 then beta := alfa  { valtis pasukama alfa kampu }
               else beta := alfa + arctan (cky / ckx);
    pgx := trunc (R * cos (beta));
    pgy := trunc (R * sin (beta));
    case nr of                    { kadras }
      0 : if valtis1 [cky, ckx] = 1 then putpixel (x + pgx * mastelis, y + pgy * mastelis, sp);
      1 : if valtis2 [cky, ckx] = 1 then putpixel (x + pgx * mastelis, y + pgy * mastelis, sp);
      2 : if valtis3 [cky, ckx] = 1 then putpixel (x + pgx * mastelis, y + pgy * mastelis, sp);
    end;
  end;
end;

{ pieÕiamas vanduo - trys sinusoidÓs }
procedure putvanduo (laipsnis, spalva : integer; Var yy : integer);
var
  ckx, y : integer;
begin
  yy := 400 + trunc (sin ((pozx + laipsnis) * pi / 180) * 20);
  for ckx := 0 to 639 do
  begin
    y := trunc (sin ((ckx + laipsnis) * pi / 180) * 20);
    putpixel (ckx, y + 400, spalva);
    putpixel (ckx, y + 425, spalva);
    putpixel (ckx, y + 450, spalva);
  end;
end;

begin
  initgraph (gd, gm, '');
  dangus.paruosk;
  setcolor (8);
  outtextxy (280, 470, 'MK 2001');
  repeat                          { animacija }
    putvaltis (kadras, pozx, poz - 15 * mastelis, alfa, 0);
    putvanduo (beta, 0, poz);
    dangus.trink;
    beta := (beta + 1) mod 360;   { sinusoidÓs kampo keitimas }
    if (beta > 60) and (beta < 100) or (beta > 230) and (beta < 280)
    then alfa := 0
    else if (beta < 90) or (beta > 270)
         then alfa := 15
         else alfa := -15;
    kadras := beta mod 9;         { keiÑiamas kadras }
    if kadras < 3 then kadras := 0
    else if kadras < 6 then kadras := 1
                       else kadras := 2;
    dangus.pastumk;
    dangus.piesk;
    putvanduo (beta, 1, poz);
    putvaltis (kadras, pozx, poz - 15 * mastelis, alfa, 15);
    waitretrace;
  until port [$60] = 1;           { laukiama Esc paspaudimo }
  closegraph;
end.