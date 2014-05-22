
program mode_13h_3d; { 3D_HOLE.PAS }
{ mode-13h version of polygoned object - inc. backgroud, by Bas van Gaalen }
uses u_vga,u_ffpcx,u_pal,u_3d,u_kb;
const
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
var page,virscr:pointer;

procedure rotate_object;
const xst=2; yst=2; zst=-1;
var
  xp,yp,z:array[1..nofpoints] of integer;
  x,y:integer;
  n,phix,phiy,phiz:byte;
begin
  {u_border:=true;}
  phix:=0; phiy:=0; phiz:=0;
  fillchar(xp,sizeof(xp),0);
  fillchar(yp,sizeof(yp),0);
  fillchar(z,sizeof(z),0);
  destenation:=virscr;
  repeat
    vretrace;
    setborder(200);
    flip(page,virscr,320*200);
    for n:=1 to nofpoints do begin
      x:=points[n,0]; y:=points[n,1]; z[n]:=points[n,2];
      rotate(x,y,z[n],phix,phiy,phiz);
      conv3dto2d(xp[n],yp[n],x,y,z[n]);
      inc(xp[n],160); inc(yp[n],100);
    end;
    for n:=1 to nofplanes do begin
      polyz[n]:=(z[planes[n,0]]+z[planes[n,1]]+z[planes[n,2]]+z[planes[n,3]]) div 4;
      pind[n]:=n;
    end;
    quicksort(nofplanes);
    for n:=fpoly to nofplanes do
      polygon(xp[planes[pind[n],0]],yp[planes[pind[n],0]],
              xp[planes[pind[n],1]],yp[planes[pind[n],1]],
              xp[planes[pind[n],2]],yp[planes[pind[n],2]],
              xp[planes[pind[n],3]],yp[planes[pind[n],3]],
              ctab[phix] div 2,0,pind[n]);
    inc(phix,xst); inc(phiy,yst); inc(phiz,zst);
    setborder(0);
    flip(virscr,vidptr,320*200);
  until keypressed;
end;

var pcxpal:pal_type; pcxpic:pointer; i:byte;
begin
  getmem(page,320*200); getmem(virscr,320*200);
  if pcx_load('bots.pcx',page,pcxpal)<>pcx_ok then begin
    writeln('An error ocured: ',pcx_errstr); halt; end;
  setvideo($13);
  setpal(pcxpal);
  for i:=1 to nofplanes do setrgb(i,10+i,10+i,15+i*2);
  rotate_object;
  freemem(page,320*200); freemem(virscr,320*200);
  setvideo(u_lm);
end.
