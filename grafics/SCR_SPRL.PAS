
{$r-} { Test with R+ and note the difference! }

program spiral_scroll; { SCR_SPRL.PAS }
{ Spiral scroll - an oldy a-la Amiga - kinda shocky, by Bas van Gaalen }
uses u_vga,u_kb;
const txt:string=' Howdy folks, this is a scroll like in the Amiga days...   ';
var
  stab:array[0..255] of byte; { sine table }
  ctab:array[0..255] of byte; { color table }

procedure spiral;
var
  bitmap:array[0..319] of byte;
  x:word;
  i,j,ch,txtidx,chrlin:byte;
begin
  fillchar(bitmap,sizeof(bitmap),0);
  txtidx:=0; j:=0;
  repeat
    ch:=byte(txt[txtidx]); txtidx:=1+txtidx mod length(txt);
    for chrlin:=0 to 7 do begin
      move(bitmap[1],bitmap[0],sizeof(bitmap)-1); { scroll bitmap 'up' }
      bitmap[319]:=mem[seg(font^):ofs(font^)+ch shl 3+chrlin]; { add bitpattern }
      vretrace;
      for x:=0 to 319-8 do { loop to clear all char-lines }
        for i:=0 to 7 do mem[u_vidseg:stab[(x+j) mod 255]*320+x+i]:=0;
      dec(j,1);
      for x:=0 to 319-8 do { loop to write all char-lines }
        for i:=0 to 7 do begin { loop to extend bits to pixels }
          if ((bitmap[x] shl i) and 128)=128 then
            mem[u_vidseg:stab[(x+j) mod 255]*320+x+i]:=ctab[(x+j) mod 255]
          else mem[u_vidseg:stab[(x+j) mod 255]*320+x+i]:=0;
        end;
    end;
  until keypressed;
end;

var i:byte;
begin
  setvideo($13);
  getfont(font8x8);
  for i:=0 to 255 do begin
    stab[i]:=round(sin(i*4*pi/255)*20)+50;
    if cos(i*4*pi/255)>0 then ctab[i]:=11 else ctab[i]:=3;
  end;
  spiral;
  setvideo(u_lm);
end.
