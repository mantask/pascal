
program vga_scroll; { SCR_VGA.PAS }
{ Basic VGA scroll, by Bas van Gaalen }
uses u_vga,u_kb;
const
  yo=23*8;
  color=7;
  txt:string='This is just an example of a very basic graphics scroll...   ';

procedure scroll;
var txtidx,curchar,bitpos,pixline,col:byte;
begin
  txtidx:=1;
  repeat
    curchar:=byte(txt[txtidx]); txtidx:=1+txtidx mod length(txt);
    for bitpos:=7 downto 0 do begin
      vretrace;
      for pixline:=0 to 15 do begin
        move(mem[u_vidseg:(yo+pixline)*320+1],mem[u_vidseg:(yo+pixline)*320+0],320);
        col:=byte(((mem[seg(font^):ofs(font^)+curchar shl 4+pixline]) shr bitpos)
          and 1)*(32+txtidx and $1f+pixline+bitpos);
        putpixel(319,yo+pixline,col);
      end;
    end;
  until keypressed;
end;

begin
  setvideo($13);
  getfont(font8x16);
  scroll;
  setvideo(u_lm);
end.
