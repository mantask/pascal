{ MK 2001 }
program dangus1;

uses
  crt, graph;

Type
  Tdangus = Object                  { fonas, t.y., dangus }
    zvaigzdes : array [0 .. 99] of record
                                     x : 0 .. 639;
                                     y : 0 .. 479;
                                   end;
    constructor paruosk;
    procedure pastumk (vnt : byte);
    procedure trink;
    procedure piesk (sp : byte);
  end;

var
  dangus : Tdangus;
  gd, gm : integer;
  kiek : byte;

constructor Tdangus.paruosk;
var
  ck : byte;
begin
  randomize;
  for ck := 0 to 99 do
  begin
    zvaigzdes [ck].x := random (640);
    zvaigzdes [ck].y := random (480);
  end
end;

procedure Tdangus.pastumk;
var
  ck : byte;
begin
  for ck := 0 to 99 do
  zvaigzdes [ck].x := (zvaigzdes [ck].x + (640 - vnt)) mod 640;
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
  putpixel (zvaigzdes [ck].x, zvaigzdes [ck].y, sp)
end;

{ palaukia vertikalaus ekrano perpie’mo, animacija maÿiau mirga }
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

begin
  initgraph (gd, gm, '');
  dangus.paruosk;
  repeat
    dangus.trink;
    dangus.pastumk (2);
    dangus.piesk (7);
    delay (100);
  until port [$60] = 1;
  closegraph
end.