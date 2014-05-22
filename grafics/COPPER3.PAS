
{$define fast}

{ 'fast' for fast computers (386dx/40,
  delete for slow computers (worse) }

program copper; { COPPER3.PAS }
{ Real-time color-mix-copper, by Bas van Gaalen }
uses u_vga,u_kb;

{$ifdef fast}
const size=360; amp=148;
{$else}
const size=250; amp=93;
{$endif}

const step=15; bars=3;
var
  pal:array[0..3*size-1] of byte;
  stab:array[0..255] of word;
  bartab:array[0..bars-1] of word;

procedure createtab; var i:byte; begin
  for i:=0 to 255 do stab[i]:=round(sin(2*pi*i/255)*amp)+amp; end;

procedure movebars;
var n,i:word;
begin
  fillchar(pal,3*size,0);
  for n:=0 to bars-1 do begin
    for i:=0 to 31 do pal[n mod 3+3*stab[bartab[n]]+3*i]:=2*i;
    for i:=0 to 31 do pal[n mod 3+3*stab[bartab[n]]+3*32+3*i]:=63-2*i;
    bartab[n]:=1+bartab[n] mod 255;
  end;
end;

procedure copperbars;
var cc,l:word;
begin
  asm cli end;
  vretrace;
  cc:=0;
  for l:=0 to size-1 do begin
    port[$3c8]:=0;
    port[$3c9]:=pal[cc];
    port[$3c9]:=pal[cc+1];
    while (port[$3da] and 1)<>0 do;
    while (port[$3da] and 1)=0 do;
    port[$3c9]:=pal[cc+2];
    inc(cc,3);
  end;
  asm sti end;
end;

var i:byte;
begin
  fillchar(pal,sizeof(pal),0);
  for i:=0 to bars-1 do bartab[i]:=step*i;
  createtab;
  repeat
    movebars;
    copperbars;
  until keypressed;
end.
