
program test_txt_unit; { TESTTXT.PAS }
{ General demonstration of the procs and function of the txt-unit.
  Press a key to continue between the screens.
  By Bas van Gaalen }
uses u_txt,u_misc,u_kb;
var
  backuppal:array[1..15] of record r,g,b:byte; end;
  x,y:byte;
begin
  clrscr;
  cursoroff;

  { hi-intensity demo }
  for y:=0 to 15 do
    for x:=0 to 15 do
      dspat(' x ',3*x,y,y*16+x);
  waitkey(0);
  setblink(off); { blink off, hi-intensity on }
  waitkey(0);
  setblink(on); { blink on, hi-intensity off }

  { special setrgb procedure for textmode - set gray-scale palette }

  for x:=1 to 15 do begin
    txt_getrgb(x,backuppal[x].r,backuppal[x].g,backuppal[x].b); { backup }
    txt_setrgb(x,x*63 div 16,x*63 div 16,x*63 div 16); { set new }
  end;
  dspat('txt_setrgb demo...',0,16,15);
  waitkey(0);
  setblink(off); { blink off, hi-intensity on }
  waitkey(0);
  setblink(on); { blink on, hi-intensity off }
  for x:=1 to 15 do
    txt_setrgb(x,backuppal[x].r,backuppal[x].g,backuppal[x].b); { restore }

  { txt_lines demo - also check SWITCH.PAS }
  dspat('Current screen resolution: '+lz(cols,0)+'x'+lz(rows,0),0,17,lightgray);
  waitkey(0);
  txt_lines(28);
  dspat('Current screen resolution: '+lz(cols,0)+'x'+lz(rows,0),0,18,lightgray);
  waitkey(0);
  txt_lines(50);

  { display-routines demo }
  dspat('dpat: display at - displays string of given color at given place',0,20,lightblue);
  for x:=1 to 15 do fillattr(x*3,21,x*3+2,21,x);
  dsptxt('dpstxt: display text at - display text string only, no color, at given place',0,21);
  dspmul(#0#7+'dspmul: display '+#0#9+'multi'+#0#11+'color'+#0#7+' text at given position',0,22);

  { cursor }
  linecursor;
  dspat('Normal cursor:',0,24,lightgray); placecursor(15,24); readln;
  halfcursor;
  dspat('  Half cursor:',0,25,lightgray); placecursor(15,25); readln;
  blockcursor;
  dspat('Insert cursor:',0,26,lightgray); placecursor(15,26); readln;
  cursoroff;

  dspat('For more of an implicit demonstration check PV.PAS',0,28,lightcyan);
  waitkey(0);
end.
