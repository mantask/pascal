unit Man;

interface

uses
  graph;

Type
  Tvirs = array [1 .. 15, 1 .. 3] of integer;

Const
  lin : array [1 .. 16, 1 .. 2] of byte =
       ((1,2),(1,3),(2,3),(3,4),(3,5),(4,6),(6,8),(5,7),(7,9),
        (4,10),(5,11),(10,11),(10,12),(12,14),(11,13),(13,15));
  virs : Tvirs =
       ((15,100,40),(25,100,40),(20,86,40),(5,80,40),(35,80,40),
         (0,53,40),(40,53,40),(0,33,40),(40,33,40),(15,43,40),
         (25,43,40),(15,22,40),(25,22,40),(15,0,40),(25,0,40));
  Depth = 256;
  cx : byte = 20; { zmogaus erdves centras }
  cy : byte = 50; { zmogaus erdves centras }

Type
  TMan = Object
  private
    alfaAsis : integer;
    alfaAukstyn : integer;
    Virsunes : Tvirs;
    procedure versk2D (var x, y : integer; xx, yy, zz : integer);
  public
    constructor Create;
    procedure piesk (x, y : word; sp : byte);
    procedure pasukAsis (alfa : word); { paskuka apie asi }
    procedure pasukAukstyn (alfa : word); { paskuka aukstyn }
  end;

implementation

constructor Tman.Create;
var
  ck : byte;
begin
  alfaasis := 0;
  alfaAukstyn := 0;
  virsunes := virs
end;

procedure Tman.versk2D (var x, y : integer; xx, yy, zz : integer);
var
  pg : real;
begin
  if zz = 0 then pg := depth
            else pg := depth / zz;
  x := round (xx * pg);
  y := round (yy * pg)
end;

procedure TMan.pasukAsis (alfa : word);
var
  xx, zz : integer;
  ck : word;
  beta,
  sinn, coss : real;
begin
  alfaAsis := (alfa + alfaAsis) mod 360;
  beta := AlfaAsis * pi / 180;
  sinn := sin (beta);
  coss := cos (beta);
  for ck := 1 to 15 do
  begin
    xx := virs [ck, 1] - cx;
    zz := virs [ck, 3] - cx;
    xx := trunc (xx * coss + zz * sinn);
    zz := trunc (zz * coss - xx * sinn);
    virsunes [ck, 3] := zz + cx;
    virsunes [ck, 1] := xx + cx
  end
end;

procedure Tman.pasukAukstyn (alfa : word);
var
  xx, yy : integer;
  ck : word;
  beta,
  sinn, coss : real;
begin
  alfaAukstyn := (alfa + AlfaAukstyn) mod 360;
  beta := alfaaukstyn * pi / 180;
  sinn := sin (beta);
  coss := cos (beta);
  for ck := 1 to 15 do
  begin
    xx := virs [ck, 1] - cx;
    yy := virs [ck, 2];
    xx := trunc (xx * coss - yy * sinn);
    yy := trunc (xx * sinn + yy * coss);
    virsunes [ck, 1] := xx + cx;
    virsunes [ck, 2] := yy
  end
end;

{ kol kas naudosim graph unita }
procedure TMan.piesk (x, y : word; sp : byte);
var
  ck : byte;
  xx1, xx2, yy1, yy2 : integer;
begin
  setcolor (sp);
  for ck := 1 to 16 do
  begin
    versk2d (xx1, yy1, virsunes [lin [ck,1],1], virsunes [lin [ck,1],2], virsunes [lin [ck,1],3]);
    versk2d (xx2, yy2, virsunes [lin [ck,2],1], virsunes [lin [ck,2],2], virsunes [lin [ck,2],3]);
    line (x + xx1, y - yy1, x + xx2, y - yy2)
  end
end;

begin
end.