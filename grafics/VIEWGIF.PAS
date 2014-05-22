
program viewgif; { VIEWGIF.PAS }
{ GIF viewer, by Bas van Gaalen }
uses dos,u_vga,u_ffgif,u_kb;
var info:gif_inforec; bgipath,fname:pathstr; dummy:byte;
begin
  bgipath:='i:\gfxfx2';
  fname:=paramstr(1);
  if gif_info(fname,info)<>gif_ok then begin
    writeln('An error ocured: ',gif_errstr); halt; end;
  with info do
    writeln('Info on ',fname,': ',xres,'x',yres,'x',1 shl pixs,', ',version);
  waitkey(0);
  dummy:=gif_display(fname,bgipath,-1);
  clearkeybuf; waitkey(0);
  setvideo(u_lm);
end.
