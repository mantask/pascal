
program viewsci; { VIEWSCI1.PAS }
{ Display raw picture in mode-x (320x200x256x4), by Bas van Gaalen }
uses dos,u_vga,u_pal,u_mdx,u_kb;
const pal_offset=$000a; pic_offset=$030a;
var p_file:file;

procedure error(err:string); begin writeln(#10#13,err); halt(1); end;

procedure initfile(filename:pathstr); { check and open file }
begin
  if filename='' then error('Enter raw-picture filename on commandline.');
  assign(p_file,filename);
  {$i-} reset(p_file,1); {$i+}
  if ioresult<>0 then error(fexpand(filename)+' not found.');
end;

procedure displayrawpic(xpos,ypos:word);
var pal:pal_type; rawbuf:pointer;
begin
  mdx_setmodex(mdx_320x240,320);
  seek(p_file,pal_offset);
  blockread(p_file,pal,$300);
  setpal(pal);
  getmem(rawbuf,320*200);
  seek(p_file,pic_offset);
  blockread(p_file,rawbuf^,320*200); { assuming a correct picture: 320x200 }
  close(p_file);
  mdx_displaypic(xpos,ypos,rawbuf,320,200);
  freemem(rawbuf,320*200);
  usefont:=font8x8;
  mdx_writetxt(paramstr(1),(320-8*length(paramstr(1))) div 2,210,250);
end;

begin
  if maxavail<(2*320*200) then error('Out of memory.');
  initfile(paramstr(1));
  displayrawpic(0,0);
  waitkey(0);
  setvideo(u_lm);
end.
