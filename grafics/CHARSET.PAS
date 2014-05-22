
program convert_charset; { CHARSET.PAS }
{ Convert CHARSET.INC to CHARS.INC for SCR_TXT2.PAS,
  Beatify CHARS.INC yourself. By Bas van Gaalen. }
uses dos,u_vga,u_ansi,u_kb;
{$i charset.inc}
const
  txtptr:pointer=ptr($b800,0);
  outfname:pathstr='chars.inc';
var
  txtfile:text;
  chars:array[0..4,0..319] of word;
  v,x:word;
  i,y:byte;
begin
  setvideo(259);
  ansi_2txt(imagedata,txtptr^,imagedata_length);
  assign(txtfile,outfname);
  rewrite(txtfile);

  for i:=0 to 4 do { 5-line hi charset }
    for x:=0 to 79 do begin { 80 small characters on one line }
      for y:=0 to 3 do begin { 4 lines of big characters }
        v:=memw[$b800:y*5*160+i*160+x+x];
        memw[$b800:(i*5+20+y)*160+x+x]:=v;
        chars[i,y*80+x]:=v;
      end;
    end;

  writeln(txtfile,'  chars:array[0..4,0..319] of word=(');
  write(txtfile,'    ');
  for y:=0 to 4 do begin { 5-line hi charset }
    for x:=0 to 319 do begin { 320 bytes in one line }
      write(txtfile,chars[y,x],',');
      if x mod 10=9 then begin writeln(txtfile); write(txtfile,'    '); end;
    end;
    write(txtfile,'),(');
  end;
  writeln(txtfile,')');

  close(txtfile);
  waitkey(0);
end.
