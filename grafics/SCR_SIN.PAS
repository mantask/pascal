
program sinusscroll; { SCR_SIN.PAS }
{ Enhanced sinus-scroll, by Bas van Gaalen }
uses u_vga,u_kb;

const
  sofs=140;
  samp=40;
  slen=255;
  size=2;
  curve=3;
  xmax=279 div size;
  ymax=7;
  scrspd=-1;
  scrtxt:string=
    ' Hai world... This looks a bit like the scroll of the second part'+
    ' of Future Crew''s Unreal demo (part one)...     It''s not filled'+
    ' but it sure looks nicer (imho)...                               ';

var
  stab:array[0..slen] of word;

procedure scroll;
type
  scrarray=array[0..xmax,0..ymax] of byte;
  posarray=array[0..xmax,0..ymax] of word;
var
  postab:posarray;
  bitmap:scrarray;
  x,i,sinidx:word;
  y,scridx,curchar:byte;
begin
  fillchar(bitmap,sizeof(bitmap),0);
  fillchar(postab,sizeof(postab),0);
  scridx:=1; sinidx:=0;
  repeat
    curchar:=ord(scrtxt[scridx]);
    scridx:=1+scridx mod length(scrtxt);
    for i:=0 to 7 do begin
      move(bitmap[1,0],bitmap[0,0],(ymax+1)*xmax);
      for y:=0 to ymax do
        if ((mem[seg(font^):ofs(font^)+8*curchar+y] shl i) and 128)<>0 then
          bitmap[xmax,y]:=((scridx+y-i) mod 60)+32 else bitmap[xmax,y]:=0;
      vretrace;
      for x:=0 to xmax do
        for y:=0 to ymax do begin
          mem[u_vidseg:postab[x,y]]:=0;
          postab[x,y]:=(size*y+stab[(sinidx+x+curve*y) mod slen])*320+
            size*x+stab[(x+y) mod slen]-sofs;
          mem[u_vidseg:postab[x,y]]:=bitmap[x,y];
        end;
      sinidx:=(sinidx+scrspd) mod slen;
    end;
  until keypressed;
end;

var i:word;
begin
  getfont(font8x8);
  for i:=0 to slen do stab[i]:=round(sin(i*4*pi/slen)*samp)+sofs;
  setvideo($13);
  scroll;
  setvideo(u_lm);
end.
