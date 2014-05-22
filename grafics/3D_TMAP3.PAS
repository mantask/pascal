
program texturemapping; { 3D_TMAP3.PAS }
{ Gouraud dhaded texture-mapping, by Jeroen Bouwens }
uses u_vga,u_ffpcx,u_pal,u_3d,u_kb;
const
  picfile='gfxfx2.pcx';
  picsize=270*180;
  nofpoints=8; { cube has 8 corners }
  nofplanes=12; { 2 triangles/face, 6 faces = 12 triangles }
  points:array[1..nofpoints,0..2] of integer=(
    (10,10,10),(-10,10,10),(-10,-10,10),(10,-10,10),
    (10,10,-10),(-10,10,-10),(-10,-10,-10),(10,-10,-10));
  planes:array[1..nofplanes,0..2] of integer=(
    (1,2,6),(1,6,5),(2,3,7),(2,7,6),(3,4,8),(3,8,7),
    (4,1,5),(4,5,8),(3,2,1),(3,1,4),(5,6,7),(5,7,8));

var
  ut,vt:array[1..nofplanes,0..2] of word;
  picture:pointer;

procedure initialize; { load texturemap picture and set uv-coords }
var pal:pal_type; i:word; j,k:byte;
begin
  setvideo($13); { set graphics mode }
  fillchar(pal,sizeof(pal),0); setpal(pal); { set all colors to black }
  i:=pcx_load(picfile,vidptr,pal); { drop pcx file on screen }
  getmem(picture,picsize); { reserve memory for texture map }
  for j:=0 to 179 do for i:=0 to 269 do { copy picture to memory }
    mem[seg(picture^):ofs(picture^)+270*j+i]:=mem[$a000:320*j+i];
  cls(vidptr,320*200); { clear screen }
  setpal(pal); { set picture palette }

  k:=1; { define the uv-coordinates for every point in every surface }
  for i:=0 to 1 do for j:=0 to 2 do begin
    ut[k,0]:=j*89; vt[k,0]:=i*89;
    ut[k,1]:=j*89+88; vt[k,1]:=i*89;
    ut[k,2]:=j*89+88; vt[k,2]:=i*89+88;
    inc(k);
    ut[k,0]:=j*89; vt[k,0]:=i*89;
    ut[k,1]:=j*89+88; vt[k,1]:=i*89+88;
    ut[k,2]:=j*89; vt[k,2]:=i*89+88;
    inc(k);
  end;
end;

procedure rotate_object;
const
  depth=300;
  xst=1; yst=2; zst=2;
var
  xa,ya,za:array[1..nofpoints] of real; { rotated object coords }
  bx,by,bz:array[1..nofpoints] of integer; { 2d coords }
  magntab:array[0..255] of byte; { magnification table }
  virscr:pointer;
  relx1,relx2,relz1,relz2,rely1,rely2:real;
  vx,vy,vz,ux,uy,uz,ul:real;
  ll:real;
  xt,yt,zt:real;
  costheta:real;                { angle between lightsource and plane-normal }
  negmag,posmag,                                            { zoom constants }
  lx,ly,lz:integer;                                     { lightsource coords }
  phix,phiy,phiz,                                 { angles of rotated object }
  surfcol,                                     { surface illumination factor }
  magidx,i,j,k:byte;
begin
  for i:=0 to 255 do magntab[i]:=round(sin(i*4*pi/255)*20)+22;
  lx:=0; ly:=0; lz:=15; { light source coordinates }
  ll:=sqrt(lx*lx+ly*ly+lz*lz);
  phix:=0; phiy:=0; phiz:=0;
  magidx:=0;
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
        gouraudtexture(bx[planes[i,0]],by[planes[i,0]],ut[i,0],vt[i,0],bz[planes[i,0]],
          bx[planes[i,1]],by[planes[i,1]],ut[i,1],vt[i,1],bz[planes[i,1]],
          bx[planes[i,2]],by[planes[i,2]],ut[i,2],vt[i,2],bz[planes[i,2]],
          seg(picture^),ofs(picture^),270);
      end;
    flip(virscr,vidptr,320*200); { display picture }

    k:=1; inc(magidx,5);
    negmag:=45-magntab[magidx];
    posmag:=45+magntab[magidx];
    for i:=0 to 1 do for j:=0 to 2 do begin
      ut[k,0]:=j*89+negmag; vt[k,0]:=i*89+negmag;
      ut[k,1]:=j*89+posmag; vt[k,1]:=i*89+negmag;
      ut[k,2]:=j*89+posmag; vt[k,2]:=i*89+posmag;
      inc(k);
      ut[k,0]:=j*89+negmag; vt[k,0]:=i*89+negmag;
      ut[k,1]:=j*89+posmag; vt[k,1]:=i*89+posmag;
      ut[k,2]:=j*89+negmag; vt[k,2]:=i*89+posmag;
      inc(k);
    end;

    inc(phix,xst); inc(phiy,yst); inc(phiz,zst); { increase angles }
  until keypressed;
  freemem(virscr,320*200);
end;

begin
  initialize;
  rotate_object;
  freemem(picture,picsize);
  setvideo(u_lm);
end.
