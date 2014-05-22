
program xfade; { XFADE.PAS }
{ Cross-fade routine, by Bas van Gaalen }
uses u_vga,u_pal,u_kb;
const
  lines=13;
  creds:array[0..lines-1] of string[20]=(
    {.........|.........|}
    'This cross-fade',
    'routine was made by',
    'Bas van Gaalen',
    'Code and idea',
    'inspired by',
    'David Proper',
    'This routine was',
    'enhanced a bit',
    'in comparison with',
    'David''s one...',
    'cu later',
    'alligator!',
    '');

procedure cleartxt(col,new:byte);
var x,y,vofs:word;
begin
  for x:=0 to 319 do for y:=100 to 107 do begin
    vofs:=y*320+x;
    if mem[u_vidseg:vofs]=col then mem[u_vidseg:vofs]:=0
    else if mem[u_vidseg:vofs]<>0 then mem[u_vidseg:vofs]:=new;
  end;
end;

procedure writetxt(col,cur:byte; txt:string); { special textroutine }
var x,y,vofs:word; i,j,k:byte;
begin
  x:=(320-8*length(txt)) div 2; y:=100;
  for i:=1 to length(txt) do for j:=0 to 7 do for k:=0 to 7 do
    if ((mem[seg(font^):ofs(font^)+ord(txt[i])*8+j] shl k) and 128) <> 0 then begin
      vofs:=(y+j)*320+(i*8)+x+k;
      if mem[u_vidseg:vofs]=cur then mem[u_vidseg:vofs]:=col+cur else mem[u_vidseg:vofs]:=col;
    end;
end;

var txtidx,curcol,i:byte;
begin
  setvideo($13);
  getfont(font8x8);
  setrgb(1,0,0,0); setrgb(2,0,0,0); setrgb(3,63 div 2,63,63 div 2);
  curcol:=1; txtidx:=0;
  repeat
    cleartxt(curcol,3-curcol);
    writetxt(curcol,3-curcol,creds[txtidx]);
    for i:=0 to 63 do begin
      vretrace;
      setrgb(curcol,i div 2,i,i div 2);
      setrgb(3-curcol,(63-i) div 2,63-i,(63-i) div 2);
    end;
    waitkey(1);
    curcol:=succ(curcol mod 2);
    txtidx:=succ(txtidx) mod lines;
  until port[$60]=1; { <ESC> to quit }
  setvideo(u_lm);
end.
