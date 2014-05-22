
program viewsci; { VIEWSCI2.PAS }
{ Display raw picture in standard mode 13h (320x200x256), by Bas van Gaalen }
uses dos,u_vga,u_pal,u_kb;
const pal_offset=$000a; pic_offset=$030a;
var p_file:file;

procedure error(err:string); begin writeln(#10#13,err); halt(1); end;

procedure initfile(filename:pathstr);
begin
  if filename='' then error('Enter raw-picture filename on commandline.');
  assign(p_file,filename);
  {$i-} reset(p_file,1); {$i+}
  if ioresult<>0 then error(fexpand(filename)+' not found.');
end;

procedure initrawpal;
var pal:pal_type;
begin
  seek(p_file,pal_offset);
  blockread(p_file,pal,$300);
  setvideo($13);
  setpal(pal);
end;

procedure displayrawpic;
begin
  seek(p_file,pic_offset);
  blockread(p_file,mem[u_vidseg:0],320*200); { assuming 320x200 }
  close(p_file);
end;

begin
  initfile(paramstr(1));
  initrawpal;
  displayrawpic;
  repeat until keypressed;
  setvideo(u_lm);
end.
