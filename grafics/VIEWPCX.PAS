
program viewpcx; { VIEWPCX.PAS }
{ Basic PCX viewer (320x200x256), by Bas van Gaalen }
{ Commandline-parameter: any 64kb PCX file }
uses u_vga,u_ffpcx,u_pal,u_kb;
var pcxpal:pal_type; pcxpic:pointer;
begin
  getmem(pcxpic,320*200);
  if pcx_load(paramstr(1),pcxpic,pcxpal)<>pcx_ok then begin
    writeln('An error ocured: ',pcx_errstr); halt; end;
  setvideo($13);
  setpal(pcxpal);
  displaypic(0,0,pcxpic,320,200);
  freemem(pcxpic,320*200);
  waitkey(0);
  setvideo(u_lm);
end.
