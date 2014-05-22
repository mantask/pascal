
program pixelate; { PIXELATE.PAS }
{ Commandline-parameter: any 320x200x256 PCX file,
  reminder: realy slow, just to give some hints,
  by Bas van Gaalen }
uses u_vga,u_ffpcx,u_pal,u_kb;
var pcxpal:pal_type; pcxpic:pointer;

procedure zoom;
var i,j,x,y,z:word; c:byte;
begin
  z:=2;
  repeat
    vretrace;
    for i:=0 to (319 div z) do
      for j:=0 to (199 div z) do begin
        c:=mem[u_vidseg:(j*z)*320+i*z];
        for y:=0 to pred(z) do
          for x:=0 to pred(z) do
            mem[u_vidseg:(j*z+y)*320+i*z+x]:=c;
      end;
    z:=z shl 1;
  until z>100;
end;

begin
  getmem(pcxpic,320*200);
  if pcx_load(paramstr(1),pcxpic,pcxpal)<>pcx_ok then begin
    writeln('An error ocured: ',pcx_errstr); halt; end;
  setvideo($13);
  setpal(pcxpal);
  displaypic(0,0,pcxpic,320,200);
  freemem(pcxpic,320*200);
  zoom;
  waitkey(0);
  setvideo(u_lm);
end.
