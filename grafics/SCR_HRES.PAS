
program highres_scroll; { SCR_HRES.PAS }
{ High-Resolution (mode 10h) hardware scroll, by Bas van Gaalen }
uses dos,u_vga,u_mdx,u_kb;
const noflines=70; thi=16; scrw=80; maxlines=350;
type str80=string[80];
var txt:array[0..noflines-1] of str80;

procedure readfile(fname:pathstr);
var tfile:text; tstr:str80; i:byte; err:boolean;
begin
  err:=false;
  fillchar(txt,sizeof(txt),0);
  if fname='' then err:=true
  else begin
    assign(tfile,fname);
    {$i-} reset(tfile); {$i+}
    if ioresult<>0 then err:=true
    else begin
      i:=0;
      while (i<noflines) and (not eof(tfile)) do begin
        readln(tfile,tstr); txt[i]:=tstr; inc(i); end;
      close(tfile);
    end;
  end;
  if err then begin
    writeln('Enter filename of textfile on commandline.'); halt; end;
end;

var tbuf:array[0..thi-1,0..79] of byte; cline:integer; x,y,tline,tidx:byte;
begin
  readfile(paramstr(1));
  setvideo($10); { init mode 10h (16d: 640x350x16) }
  getfont(font8x16);
  cline:=1; tline:=0; tidx:=0;
  repeat
    inc(cline);
    mdx_setaddress(cline*scrw);
    vretrace; vretrace;
    move(tbuf[tline,0],mem[u_vidseg:cline*scrw-scrw],80);
    move(tbuf[tline,0],mem[u_vidseg:cline*scrw+maxlines*scrw],80);
    inc(tline);
    if tline=thi then begin
      tline:=0;
      for y:=0 to 15 do for x:=0 to 79 do
        tbuf[y,x]:=mem[seg(font^):ofs(font^)+ord(txt[tidx][x+1])*thi+y];
      tidx:=(tidx+1) mod noflines;
    end;
    if cline>=maxlines then cline:=-1;
  until keypressed;
  setvideo(u_lm);
end.
