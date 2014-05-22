
program test640x480x16; { 640X480.PAS }
{ Mode 12h unit test, by Bas van Gaalen }
uses u_vga,u_md12h,u_ansi,u_txt,u_kb;
{$i ansi.inc}
var
  scrdata:array[0..80*60*2-1] of byte;
  i:word;
  c:byte;
begin
  setvideo(259); dspat('Text mode...',0,0,15); placecursor(12,0);
  ansi_2txt(imgdata,mem[$b800:0],imgdata_length);
  waitkey(0);
  m12h_setvideo;
  m12h_writetxt(0,0,'Graphics mode...',15);
  fillchar(scrdata,sizeof(scrdata),0);
  ansi_2txt(imgdata,scrdata,imgdata_length);
  m12h_txt2gfx(scrdata,imgdata_depth*imgdata_width);
  for i:=0 to 199 do begin
    c:=i and 15;
    m12h_putpixel(20+i,100+i,c);
    m12h_putpixel(20+i,300-i,c);
    m12h_putpixel(20+i,200,c);
    m12h_putpixel(120,100+i,c);
  end;
  for c:=1 to 7 do for i:=0 to 1 do
    m12h_writetxt(320+10*c-2*i,150+10*c-2*i,'Press a key to continue...',c+8*i);
  randomize;
  repeat
    m12h_writetxt(random(592),320+random(150),'-demo-',random(16));
  until keypressed;
  clearkeybuf;
  setvideo(u_lm);
end.
