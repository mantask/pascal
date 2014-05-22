
program save_pcx; { SAVEPCX.PAS }
{ Save complete screen to file in PCX-format (<64Kb!), by Bas van Gaalen }
uses u_vga,u_ffpcx,u_pal,u_kb;
var pal:pal_type; picbuf:pointer; i,j:word; r,g,b:byte;
begin
  setvideo($13);
  getmem(picbuf,320*200);
  for i:=0 to 319 do
    for j:=0 to 199 do
      mem[u_vidseg:j*320+i]:=j+i div 6;
  move(mem[u_vidseg:0],mem[seg(picbuf^):0],320*200);
  for i:=0 to 255 do begin
    r:=0; g:=0; b:=i div 4;
    setrgb(i,r,g,b);
    pal[i].r:=r;
    pal[i].g:=g;
    pal[i].b:=b;
  end;
  waitkey(0);
  if pcx_save('test.pcx',picbuf,pal)<>pcx_ok then begin
    writeln('An error ocured: ',pcx_errstr); halt; end;
  freemem(picbuf,320*200);
  setvideo(u_lm);
  writeln('Written: TEST.PCX, a 320x200x256 (default) pcx file.');
  waitkey(0);
end.
