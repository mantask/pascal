
program lens; { LENS.PAS }
{ Lens effect (Wierd? Yeah!) By Bas van Gaalen,
  If you have a fast computer, try using a transparent sprite... }
uses u_vga,u_ffpcx,u_pal,u_kb;
const
  radius=30; { sphere radius }
  maxpoints=3000; { maximum number of points }
  xs=60; ys=60; { size is two times sphere-radius }
  ptab:array[0..255] of byte=( { parabole table for bounce }
    123,121,119,117,115,114,112,110,108,106,104,103,101,99,97,96,94,92,91,
    89,87,86,84,82,81,79,78,76,75,73,72,70,69,67,66,64,63,62,60,59,58,56,
    55,54,52,51,50,49,48,46,45,44,43,42,41,39,38,37,36,35,34,33,32,31,30,
    29,28,27,26,26,25,24,23,22,21,21,20,19,18,17,17,16,15,15,14,13,13,12,
    12,11,10,10,9,9,8,8,7,7,6,6,5,5,5,4,4,4,3,3,3,2,2,2,2,1,1,1,1,1,1,0,0,
    0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,5,5,6,6,
    7,7,7,8,8,9,9,10,11,11,12,12,13,14,14,15,16,16,17,18,19,19,20,21,22,
    23,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,
    46,47,48,49,51,52,53,54,56,57,58,60,61,62,64,65,67,68,69,71,72,74,75,
    77,78,80,82,83,85,86,88,90,91,93,95,96,98,100,102,103,105,107,109,111,
    113,114,116,118,120,122,124,126);
type
  parastruc=array[0..xs-1,0..ys-1] of shortint;
var
  para:parastruc;
  pal:pal_type;
  virscr,bckscr:pointer;
const
  paraptr:pointer=@para;

procedure initialize;
const
  step=0.035; { working step-size for a radius of 30 }
var
  alpha,beta:real;
  r,x,y,z:integer;
begin
  writeln('Calculating hemi-sphere data. Can take a few secs...');
  fillchar(para,sizeof(para),0);
  alpha:=pi;
  while alpha>0 do begin
    beta:=pi;
    while beta>0 do begin
      x:=radius+round(radius*cos(alpha)*sin(beta));
      y:=radius+round(0.833*radius*cos(beta));
      z:=round(radius*sin(alpha)*sin(beta));
      para[x,y]:=(radius-z) shr 1;
      beta:=beta-step;
    end;
    alpha:=alpha-step;
  end;
end;

{ Anyone brainy enough could rewrite this to assembler,
  that would speed up things considerably. }
procedure displaypara(x,y:word);
var p:parastruc; i,j:word;
begin
  for i:=x to x+xs-1 do for j:=y to y+ys-1 do
    mem[seg(virscr^):j*320+i]:=mem[seg(virscr^):(j-para[i-x,j-y])*320+i+para[i-x,j-y]];
end;

var di:shortint; i:integer; idx:byte;
begin
  initialize;
  setvideo($13);
  getmem(bckscr,320*200); cls(bckscr,320*200);
  if pcx_load('bots.pcx',bckscr,pal)<>pcx_ok then begin
    setvideo(u_lm); writeln('An error occured: ',pcx_errstr); halt; end;
  setpal(pal);
  displaypic(0,0,bckscr,320,200);
  getmem(virscr,320*200); cls(virscr,320*200);
  i:=30; idx:=128; di:=2;
  repeat
    flip(bckscr,virscr,320*200);
    vretrace;
    displaypara(i,15+ptab[idx]); inc(idx,3);
    inc(i,di); if (i<25) or (i+xs>295) then di:=-di;
    flip(virscr,vidptr,320*200);
  until keypressed;
  freemem(virscr,320*200); freemem(bckscr,320*200);
  clearkeybuf;
  setvideo(u_lm);
end.
