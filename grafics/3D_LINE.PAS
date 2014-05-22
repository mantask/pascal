
program hidden; { 3D_LINE.PAS }
{ Hidden line routine - kinda buggy and schocky on most systems,
  by Bas van Gaalen }
uses u_vga,u_pal,u_3d,u_kb;

{$define cube} { deca, cube }

const
{$ifdef deca}
  fpoly=1; { first poly to draw from }
  nofpoints=12; { number of points }
  nofplanes=10; { number of planes }
  points:array[1..nofpoints,0..2] of integer=(
    (-20,-30, 20),( 20,-30, 20),( 40,  0, 40),(-40,  0, 40),
    ( 20, 30, 20),(-20, 30, 20),(-20,-30,-20),( 20,-30,-20),
    ( 40,  0,-40),(-40,  0,-40),( 20, 30,-20),(-20, 30,-20));
  planes:array[1..nofplanes,0..3] of byte=(
    (1,2,3,4),(4,3,5,6),(2,8,9,3),(3,9,11,5),(8,7,10,9),
    (9,10,12,11),(7,1,4,10),(10,4,6,12),(7,8,2,1),(6,5,11,12));
{$endif}

{$ifdef cube}
  fpoly=4;
  nofpoints=8;
  nofplanes=6;
  points:array[1..nofpoints,0..2] of integer=(
    (-30,-30, 30),( 30,-30, 30),( 30, 30, 30),(-30, 30, 30),
    (-30,-30,-30),( 30,-30,-30),( 30, 30,-30),(-30, 30,-30));
  planes:array[1..nofplanes,0..3] of byte=(
    (1,2,3,4),(2,6,7,3),(6,5,8,7),(5,1,4,8),(5,6,2,1),(4,3,7,8));
{$endif}

var virscr:pointer;

procedure wireframe(x1,y1,x2,y2,x3,y3,x4,y4:word; c:byte);
begin
  vga_line(x1,y1,x2,y2,c);
  vga_line(x2,y2,x3,y3,c);
  vga_line(x3,y3,x4,y4,c);
  vga_line(x4,y4,x1,y1,c);
end;

procedure rotate_object;
const xst=1; yst=1; zst=-2;
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
    setborder(200);
    for n:=1 to nofpoints do begin
      x:=points[n,0]; y:=points[n,1]; z[n]:=points[n,2];
      rotate(x,y,z[n],phix,phiy,phiz);
      conv3dto2d(xp[n],yp[n],x,y,z[n]);
      inc(xp[n],160); inc(yp[n],100); { transfer object to middle of screen }
    end;
    for n:=1 to nofplanes do begin
      polyz[n]:=(z[planes[n,0]]+z[planes[n,1]]+z[planes[n,2]]+z[planes[n,3]]) div 4;
      pind[n]:=n;
    end;
    quicksort(nofplanes);
    vretrace;
    cls(destenation,320*200);
    for n:=1 to nofplanes do
      if not checkfront(xp[planes[pind[n],0]],yp[planes[pind[n],0]],
                    xp[planes[pind[n],1]],yp[planes[pind[n],1]],
                    xp[planes[pind[n],2]],yp[planes[pind[n],2]]) then
        wireframe(xp[planes[pind[n],0]],yp[planes[pind[n],0]],
                  xp[planes[pind[n],1]],yp[planes[pind[n],1]],
                  xp[planes[pind[n],2]],yp[planes[pind[n],2]],
                  xp[planes[pind[n],3]],yp[planes[pind[n],3]],200);
    inc(phix,xst); inc(phiy,yst); inc(phiz,zst);
    setborder(0);
    flip(virscr,vidptr,320*200);
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
