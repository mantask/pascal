
program mode_13h_3d; { 3D_13H.PAS }
{ mode-13h version of polygoned objects, by Bas van Gaalen,
  might be slow on some (or actualy most) computers }
uses u_vga,u_pal,u_3d,u_kb;

{$define deca} { deca, cube, l4a, loes, bar, tri, bas, check, sven }

const
{$ifdef deca}
  fpoly=1; { first poly to draw from }
  nofpoints=12; { number of points }
  nofplanes=8; { number of planes }
  points:array[1..nofpoints,0..2] of integer=(
    (-20,-20, 30),( 20,-20, 30),( 40,-40,  0),( 20,-20,-30),
    (-20,-20,-30),(-40,-40,  0),(-20, 20, 30),( 20, 20, 30),
    ( 40, 40,  0),( 20, 20,-30),(-20, 20,-30),(-40, 40,  0));
  planes:array[1..nofplanes,0..3] of byte=(
    (2,3,9,8),(10,9,3,4),(11,5,6,12),(7,12,6,1),
    (1,2,3,6),(6,3,4,5),(7,8,9,12),(12,9,10,11));
{$endif}

{$ifdef cube}
  fpoly=4;
  nofpoints=8;
  nofplanes=6;
  points:array[1..nofpoints,0..2] of integer=(
    (-30,-30,-30),(-30,-30,30),(30,-30,30),(30,-30,-30),
    (-30, 30,-30),(-30, 30,30),(30, 30,30),(30, 30,-30));
  planes:array[1..nofplanes,0..3] of byte=(
    (1,5,6,2),(1,4,8,5),(1,2,3,4),(5,6,7,8),(8,7,3,4),(2,3,7,6));
{$endif}

{$ifdef l4a}
  { Guess to who this is dedicated... }
  fpoly=1;
  nofpoints=28;
  nofplanes=9;
  points:array[1..nofpoints,0..2] of integer=(
{l} (-50,-25,  0),(-20,-25,  0),(-20,-15,  0),(-40,-15,  0),
    (-40, 25,  0),(-50, 25,  0),
{4} (-10,-25,  0),(  0,-25,  0),(  0, 25,  0),(-10, 25,  0),
    ( -8,  5,  0),(-20,  5,  0),(-20, 25,  0),(-30, 25,  0),
    (-30, -5,  0),( -8, -5,  0),
{a} ( 10,-25,  0),( 20,-25,  0),( 18, -5,  0),( 32, -5,  0),
    ( 30,-25,  0),( 40,-25,  0),( 40, 25,  0),( 10, 25,  0),
    ( 18,  5,  0),( 32,  5,  0),( 30, 15,  0),( 20, 15,  0));
  planes:array[1..nofplanes,0..3] of byte=(
{l} (1,2,3,4),(1,4,5,6),
{4} (7,8,9,10),(15,16,11,12),(15,12,13,14),
{a} (17,18,28,24),(28,27,23,24),(21,22,23,27),(19,20,26,25));
{$endif}

{$ifdef loes}
  fpoly=1;
  nofpoints=38;
  nofplanes=15;
  points:array[1..nofpoints,0..2] of integer=(
{l} (-70,-25,-15),(-40,-25,-15),(-40,-15,-15),(-60,-15,-15),(-60,25,-15),(-70,25,-15),
{o} (-35,-25,-5),(-5,-25,-5),(-5,25,-5),(-35,25,-5),(-25,-15,-5),(-15,-15,-5),
    (-15,15,-5),(-25,15,-5),
{e} (0,-25,5),(30,-25,5),(30,-15,5),(10,-15,5),(8,-5,5),(20,-5,5),
    (20,5,5),(8,5,5),(10,15,5),(30,15,5),(30,25,5),(0,25,5),
{s} (35,-25,15),(65,-25,15),(65,5,15),(45,5,15),(45,15,15),(65,15,15),(65,25,15),
    (35,25,15),(35,-5,15),(55,-5,15),(55,-15,15),(35,-15,15));
  planes:array[1..nofplanes,0..3] of byte=(
{l} (1,2,3,4),(1,4,5,6),
{o} (7,8,12,11),(8,9,13,12),(14,13,9,10),(7,11,14,10),
{e} (15,16,17,18),(15,18,23,26),(19,20,21,22),(23,24,25,26),
{s} (27,28,37,38),(28,29,36,37),(35,36,29,30),(35,30,31,34),(31,32,33,34));
{$endif}

{$ifdef bar}
  fpoly=3;
  nofpoints=8;
  nofplanes=6;
  points:array[1..nofpoints,0..2] of integer=(
    (-20,-40, 20),( 20,-40, 20),( 20,-40,-20),(-20,-40,-20),
    (-20, 40, 20),( 20, 40, 20),( 20, 40,-20),(-20, 40,-20));
  planes:array[1..nofplanes,0..3] of byte=(
    (1,5,6,2),(1,4,8,5),(1,2,3,4),(5,6,7,8),(8,7,3,4),(2,3,7,6));
{$endif}

{$ifdef tri}
  fpoly=2;
  nofpoints=8;
  nofplanes=6;
  points:array[1..nofpoints,0..2] of integer=(
    (-40,-40,-20),(-10,-10, 20),( 10,-10, 20),( 40,-40,-20),
    (-40, 40,-20),(-10, 10, 20),( 10, 10, 20),( 40, 40,-20));
  planes:array[1..nofplanes,0..3] of byte=(
    (1,5,6,2),(1,4,8,5),(1,2,3,4),(5,6,7,8),(8,7,3,4),(2,3,7,6));
{$endif}

{$ifdef bas}
  fpoly=1;
  nofpoints=40;
  nofplanes=16;
  points:array[1..nofpoints,0..2] of integer=(
{b} (-55,-25,  0),(-30,-25,  0),(-25,-20,  0),(-25, -5,  0),
    (-30,  0,  0),(-25,  5,  0),(-25, 20,  0),(-30, 25,  0),
    (-55, 25,  0),(-45,-15,  0),(-35,-15,  0),(-35, -5,  0),
    (-47, -5,  0),(-47,  5,  0),(-35,  5,  0),(-35, 15,  0),
    (-45, 15,  0),
{a} (-15,-25,  0),( -5,-25,  0),( -5,-15,  0),(  5,-15,  0),
    (  5,-25,  0),( 15,-25,  0),(  5, 25,  0),( -5, 25,  0),
    ( -5, -5,  0),(  5, -5,  0),(  0, 15,  0),
{s} ( 25,-25,  0),( 55,-25,  0),( 55,  5,  0),( 35,  5,  0),
    ( 35, 15,  0),( 55, 15,  0),( 55, 25,  0),( 25, 25,  0),
    ( 25, -5,  0),( 45, -5,  0),( 45,-15,  0),( 25,-15,  0));
  planes:array[1..nofplanes,0..3] of byte=(
{b} (1,2,11,10),(2,3,4,11),(4,5,12,11),(12,6,7,15),(15,7,8,16),
    (16,8,9,17),(1,10,17,9),(13,12,15,14),
{a} (18,19,24,25),(22,23,24,28),(20,21,27,26),
{s} (29,30,39,40),(30,31,38,39),(31,32,37,38),(32,33,36,37),
    (33,34,35,36));
{$endif}

{$ifdef check}
  fpoly=1;
  nofpoints=36;
  nofplanes=13;
  points:array[1..nofpoints,0..2] of integer=(
  (-50,-50,20),(-30,-50,20),(-10,-50,20),(10,-50,20),(30,-50,20),(50,-50,20),
  (-50,-30,20),(-30,-30,20),(-10,-30,20),(10,-30,20),(30,-30,20),(50,-30,20),
  (-50,-10,20),(-30,-10,20),(-10,-10,20),(10,-10,20),(30,-10,20),(50,-10,20),
  (-50,10,20),(-30,10,20),(-10,10,20),(10,10,20),(30,10,20),(50,10,20),
  (-50,30,20),(-30,30,20),(-10,30,20),(10,30,20),(30,30,20),(50,30,20),
  (-50,50,20),(-30,50,20),(-10,50,20),(10,50,20),(30,50,20),(50,50,20));
  planes:array[1..nofplanes,0..3] of byte=(
  (1,2,8,7),(3,4,10,9),(5,6,12,11),(8,9,15,14),(10,11,17,16),
  (13,14,20,19),(15,16,22,21),(17,18,24,23),(20,21,27,26),
  (22,23,29,28),(25,26,32,31),(27,28,34,33),(29,30,36,35));
{$endif}

{$ifdef sven}
  fpoly=1;
  nofpoints=41;
  nofplanes=14;
  points:array[1..nofpoints,0..2] of integer=(
{s} (-75,-25,  0),(-45,-25,  0),(-45,  5,  0),(-65,  5,  0),
    (-65, 15,  0),(-45, 15,  0),(-45, 25,  0),(-75, 25,  0),
    (-75, -5,  0),(-55, -5,  0),(-55,-15,  0),(-75,-15,  0),
{v} (-25,-25,  0),(-15,-25,  0),( -5, 25,  0),(-15, 25,  0),
    (-20,-15,  0),(-25, 25,  0),(-35, 25,  0),
{e} (  5,-25,  0),( 35,-25,  0),( 35,-15,  0),( 15,-15,  0),
    ( 15, -5,  0),( 25, -5,  0),( 25,  5,  0),( 15,  5,  0),
    ( 15, 15,  0),( 35, 15,  0),( 35, 25,  0),(  5, 25,  0),
{n} ( 45,-25,  0),( 55,-25,  0),( 55, 15,  0),( 65,-25,  0),
    ( 75,-25,  0),( 75, 25,  0),( 65, 25,  0),( 65,-15,  0),
    ( 55, 25,  0),( 45, 25,  0));
  planes:array[1..nofplanes,0..3] of byte=(
{s} (1,2,11,12),(2,3,10,11),(3,4,9,10),(4,5,8,9),(5,6,7,8),
{v} (13,14,18,19),(14,15,16,17),
{e} (20,21,22,23),(23,28,31,20),(24,25,26,27),(28,29,30,31),
{n} (32,33,40,41),(34,35,39,40),(35,36,37,38));
{$endif}

var virscr:pointer;

procedure rotate_object;
const xst=2; yst=2; zst=-3;
var
  xp,yp,z:array[1..nofpoints] of integer;
  x,y:integer;
  n,phix,phiy,phiz:byte;
begin
  phix:=0; phiy:=128; phiz:=0;
  fillchar(xp,sizeof(xp),0);
  fillchar(yp,sizeof(yp),0);
  fillchar(z,sizeof(z),0);
  destenation:=virscr;
  repeat
    vretrace;
    setborder(200);
    cls(virscr,320*200); { clear virtual screen }
    for n:=1 to nofpoints do begin
      x:=points[n,0]; y:=points[n,1]; z[n]:=points[n,2]; { get original object }
      rotate(x,y,z[n],phix,phiy,phiz); { rotate it }
      conv3dto2d(xp[n],yp[n],x,y,z[n]); { convert 3d points to 2d }
    end;
    for n:=1 to nofplanes do begin
      polyz[n]:=(z[planes[n,0]]+z[planes[n,1]]+z[planes[n,2]]+z[planes[n,3]]) div 4;
      pind[n]:=n;
    end;
    quicksort(nofplanes); { depth sort }
    for n:=fpoly to nofplanes do { draw seperate planes }
      polygon(xp[planes[pind[n],0]],yp[planes[pind[n],0]],
              xp[planes[pind[n],1]],yp[planes[pind[n],1]],
              xp[planes[pind[n],2]],yp[planes[pind[n],2]],
              xp[planes[pind[n],3]],yp[planes[pind[n],3]],
              160+ctab[phix] div 2,100+stab[phiy] div 4,polyz[n]+130);
    inc(phix,xst); inc(phiy,yst); inc(phiz,zst); { increase angles }
    setborder(0);
    flip(virscr,ptr(u_vidseg,0),320*200); { display screen }
  until keypressed;
end;

var i,j:word;
begin
  setvideo($13);
  {u_border:=true;}
  getmem(virscr,320*200); cls(virscr,320*200);
  for i:=1 to 255 do setrgb(i,i div 16,i div 8,i div 4);
  rotate_object;
  freemem(virscr,320*200);
  setvideo(u_lm);
end.
