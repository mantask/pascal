
program switch; { SWITCH.PAS }
{ Switching number of lines: 12,14,21,25,28,43,50, by Bas van Gaalen }
uses u_misc,u_txt,u_kb;
var key:word;
begin
  setscr; nwindow(2,2,15,10,' set lines ',pos_hi+pos_mi,
    _lightgray+lightcyan,_lightgray+darkgray,darkgray);
  dspat('1. 12 lines',3,3,_lightgray);
  dspat('2. 14 lines',3,4,_lightgray);
  dspat('3. 21 lines',3,5,_lightgray);
  dspat('4. 25 lines',3,6,_lightgray);
  dspat('5. 28 lines',3,7,_lightgray);
  dspat('6. 43 lines',3,8,_lightgray);
  dspat('7. 50 lines',3,9,_lightgray);
  repeat
    key:=getekey;
    case key of
      crsr1:txt_lines(12);
      crsr2:txt_lines(14);
      crsr3:txt_lines(21);
      crsr4:txt_lines(25);
      crsr5:txt_lines(28);
      crsr6:txt_lines(43);
      crsr7:txt_lines(50);
    end;
  until key=crsresc;
  getscr;
end.
