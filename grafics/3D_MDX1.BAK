
program mode_x_3d; { 3D_MDX1.PAS }
{ Mode-x version of polygoned object, by Bas van Gaalen & Sven van Heel }
uses u_vga,u_mdx,u_pal,u_3d,u_kb;

{$define deca} { deca, cube, bar, tri }

const
{$ifdef deca}
  fpoly=6; { first poly to draw from }
  nofpoints=12; { number of points }
  nofplanes=10; { number of planes }
  points:array[1..nofpoints,0..2] of integer=(
    (-15,-15, 30),( 15,-15, 30),( 40,-40,  0),( 15,-15,-30),
    (-15,-15,-30),(-40,-40,  0),(-15, 15, 30),( 15, 15, 30),
    ( 40, 40,  0),( 15, 15,-30),(-15, 15,-30),(-40, 40,  0));
  planes:array[1..nofplanes,0..3] of byte=(
    (1,2,8,7),(2,3,9,8),(10,9,3,4),(11,10,4,5),(11,5,6,12),
    (7,12,6,1),(1,2,3,6),(6,3,4,5),(7,8,9,12),(12,9,10,11));
{$endif}

{$ifdef cube}
  s=45;
  fpoly=4;
  nofpoints=8;
  nofplanes=6;
  points:array[1..nofpoints,0..2] of integer=(
    (-s,-s,-s),(-s,-s, s),( s,-s, s),( s,-s,-s),
    (-s, s,-s),(-s, s, s),( s, s, s),( s, s,-s));
  planes:array[1..nofplanes,0..3] of byte=(
    (1,5,6,2),(1,4,8,5),(1,2,3,4),(5,6,7,8),(8,7,3,4),(2,3,7,6));
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
    (-50,-50,-20),(-10,-10, 20),( 10,-10, 20),( 50,-50,-20),
    (-50, 50,-20),(-10, 10, 20),( 10, 10, 20),( 50, 50,-20));
  planes:array[1..nofplanes,0..3] of byte=(
    (1,5,6,2),(1,4,8,5),(1,2,3,4),(5,6,7,8),(8,7,3,4),(2,3,7,6));
{$endif}

{ -------------------------------------------------------------------------- }

procedure rotate_object;
const xst=-1; yst=1; zst=-1;
var
  xp,yp,z:array[1..nofpoints] of integer;
  x,y:integer;
  n,phix,phiy,phiz:byte;
begin
  phix:=0; phiy:=0; phiz:=0;
  fillchar(xp,sizeof(xp),0);
  fillchar(yp,sizeof(yp),0);
  fillchar(z,sizeof(z),0);
  repeat
    vretrace;
    setborder(100);
    for n:=1 to nofpoints do begin
      x:=points[n,0]; y:=points[n,1]; z[n]:=points[n,2];
      rotate(x,y,z[n],phix,phiy,phiz);
      conv3dto2d(xp[n],yp[n],x,y,z[n]);
    end;
    for n:=1 to nofplanes do begin
      polyz[n]:=z[planes[n,0]]+z[planes[n,1]]+z[planes[n,2]]+z[planes[n,3]];
      pind[n]:=n;
    end;
    quicksort(nofplanes);
    mdx_ofs:=16000-mdx_ofs;
    mdx_setaddress(mdx_ofs);
    mdx_cls;
    for n:=fpoly to nofplanes do
      mdx_polygon(xp[planes[pind[n],0]],yp[planes[pind[n],0]],
                  xp[planes[pind[n],1]],yp[planes[pind[n],1]],
                  xp[planes[pind[n],2]],yp[planes[pind[n],2]],
                  xp[planes[pind[n],3]],yp[planes[pind[n],3]],
                  160+ctab[phix],100-stab[phiy] div 2,polyz[n]+70);
    inc(phix,xst); inc(phiy,yst); inc(phiz,zst);
    setborder(0);
  until keypressed;
end;

{ -------------------------------------------------------------------------- }

var i:byte;
begin
  mdx_setmodex(mdx_320x200,320);
  {u_border:=true;}
  for i:=1 to 255 do setrgb(i,i div 16,i div 8,i div 4);
  rotate_object;
  setvideo(u_lm);
end.
