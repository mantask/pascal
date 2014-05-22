
program texturemapping; { 3D_TMAP1.PAS }
{ Gouraud Shading, by Jeroen Bouwens }
uses u_vga,u_pal,u_3d,u_kb;
const
  nofpoints=8; { cube has 8 corners }
  nofplanes=12; { 2 triangles/face, 6 faces = 12 triangles }
  points:array[1..nofpoints,0..2] of integer=(
    (10,10,10),(-10,10,10),(-10,-10,10),(10,-10,10),
    (10,10,-10),(-10,10,-10),(-10,-10,-10),(10,-10,-10));
  planes:array[1..nofplanes,0..2] of integer=(
    (1,2,6),(1,6,5),(2,3,7),(2,7,6),(3,4,8),(3,8,7),
    (4,1,5),(4,5,8),(3,2,1),(3,1,4),(5,6,7),(5,7,8));

procedure rotate_object;
const
  depth=400;
  xst=1; yst=2; zst=-3;
var
  xa,ya,za:array[1..nofpoints] of real; { rotated object coords }
  bx,by,bz:array[1..nofpoints] of integer; { 2d coords }
  virscr:pointer;
  xt,yt,zt:real;
  phix,phiy,phiz,                                 { angles of rotated object }
  i,j:byte;
begin
  phix:=0; phiy:=0; phiz:=0;
  getmem(virscr,320*200); { reserve memory for virtual screen }
  destenation:=virscr; destseg:=seg(destenation^); { set new destenation }
  repeat
    for i:=1 to nofpoints do begin
      xt:=points[i,0]; yt:=points[i,1]; zt:=points[i,2]; { get original }
      rrotate(xt,yt,zt,phix,phiy,phiz); { rotate it }
      bz[i]:=15+round(zt/1.2);
      zt:=zt+60;
      xa[i]:=xt; ya[i]:=yt; za[i]:=zt-20;
      bx[i]:=160+round((xt*depth)/zt); { convert to 2d }
      by[i]:=100+round((yt*depth*0.8333)/zt);
    end;
    cls(virscr,320*200);
    for i:=1 to nofplanes do
      if not checkfront(bx[planes[i,0]],by[planes[i,0]],
          bx[planes[i,1]],by[planes[i,1]],
          bx[planes[i,2]],by[planes[i,2]]) then begin
        gouraud(bx[planes[i,0]],by[planes[i,0]],bz[planes[i,0]],
          bx[planes[i,1]],by[planes[i,1]],bz[planes[i,1]],
          bx[planes[i,2]],by[planes[i,2]],bz[planes[i,2]]);
      end;
    flip(virscr,vidptr,320*200); { display picture }
    inc(phix,xst); inc(phiy,yst); inc(phiz,zst); { increase angles }
  until keypressed;
  freemem(virscr,320*200);
end;

var i:byte;
begin
  setvideo($13);
  for i:=1 to 31 do setrgb(i,8-i shr 2,16-i shr 1,32-i);
  rotate_object;
  setvideo(u_lm);
end.
