
program copper; { COPPER4.PAS }
{ Multiple copper, by Bas van Gaalen }
uses crt,u_vga,u_kb;
const size=350; step=25;
var
  pal1,pal2:array[0..3*size-1] of byte;
  stab:array[0..255] of word;
  bartab:array[0..2] of word;

procedure createtab; var i:byte; begin
  for i:=0 to 255 do stab[i]:=round(sin(2*pi*i/255)*100)+100; end;

procedure makecopperlist;
var cc,i:word;
begin
  cc:=0;
  fillchar(pal2,sizeof(pal2),0);
  for i:=0 to size-1 do begin
    pal2[cc+0]:=32+trunc(31*sin(i*pi/(size/2)));
    pal2[cc+1]:=32+trunc(31*sin(i*pi*2/(size/2)));
    pal2[cc+2]:=32+trunc(31*sin(i*pi*3/(size/2)));
    inc(cc,3);
  end;
end;

procedure writetext;
var f:text; s:string; i:byte;
begin
  textcolor(1); i:=0;
  assign(f,'copper4.pas');
  {$i-} reset(f); {$i+}
  if ioresult=0 then begin
    while (not eof(f)) and (i<49) do begin
      readln(f,s);
      writeln(s);
      inc(i);
    end;
  end
  else for i:=1 to 49 do writeln('test line ',i);
end;

procedure movebars;
var n,i:word;
begin
  fillchar(pal1,sizeof(pal1),0);
  for n:=0 to 2 do begin
    for i:=0 to 63 do pal1[n mod 3+3*stab[bartab[n]]+3*i]:=i;
    for i:=0 to 63 do pal1[n mod 3+3*stab[bartab[n]]+3*64+3*i]:=63-i;
    bartab[n]:=1+bartab[n] mod 255;
  end;
end;

procedure copperbars;
var cc,l,j:word;
begin
  asm cli end;
  vretrace;
  cc:=0;
  for l:=0 to size-1 do begin
    while (port[$3da] and 1)<>0 do;
    while (port[$3da] and 1)=0 do;
    port[$3c8]:=0;
    port[$3c9]:=pal1[cc]; port[$3c9]:=pal1[cc+1];
    port[$3c9]:=pal1[cc+2];
    port[$3c8]:=1;
    port[$3c9]:=pal2[cc]; port[$3c9]:=pal2[cc+1]; port[$3c9]:=pal2[cc+2];
    inc(cc,3);
  end;
  asm sti end;
end;

var i:byte;
begin
  setvideo(259);
  makecopperlist;
  createtab;
  for i:=0 to 2 do bartab[i]:=step*i;
  writetext;
  repeat
    movebars;
    copperbars;
  until keypressed;
  setvideo(u_lm);
end.
