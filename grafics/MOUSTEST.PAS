
program moustest; { MOUSTEST.PAS }
{ Demonstration of the mouse unit - also check MiniGame, by Bas van Gaalen }
uses u_mouse,u_txt,u_misc,u_kb;
var tmp:string; c,x,y:byte; escape:boolean;
begin
  if not mouseinstalled then begin
    writeln('No mouse installed'); halt; end;
  getmouseversion;
  setscr; nwindow(2,2,21,10,' mouse parms ',pos_hi+pos_mi,
    _lightgray+lightcyan,_lightgray+darkgray,darkgray);
  nwindow(40,2,79,v_lines-2,'',0,0,lightgray,0);
  tm_mousewindow(41,3,78,v_lines-3); { mouse window }
  setmousepos(60 shl 3,v_lines shl 2);
  randomize; { generate garbage text in window }
  for y:=3 to v_lines-3 do begin
    for x:=41 to 78 do begin
      c:=random(60);
      if c>52 then dspchar(' ',x,y,lightgray) { generate space }
      else dspchar(chr(ord('a')+c shr 1),x,y,lightgray); { random char }
    end;
  end;
  tm_showmouse;
  nwindow(70,v_lines-6,77,v_lines-4,'',0,0,_blue+lightcyan,darkgray);
  dspat('EXIT',72,v_lines-5,_blue+lightcyan);
  dspmul(#0#112+'version : '+#0#113+hexbyte(verhi)+'.'+hexbyte(verlo),3,3);
  dspmul(#0#112+'type    : '+#0#113+mtypes[mousetype],3,4);
  dspmul(#0#112+'buttons : '+#0#113+lz(buttons,0),3,5);
  escape:=false;
  repeat
    dspmul(#0#112+'x       : '+#0#113+lz(getmousex shr 3,2),3,6);
    dspmul(#0#112+'y       : '+#0#113+lz(getmousey shr 3,2),3,7);
    fillchar(tmp,sizeof(tmp),0);
    if leftpressed then tmp:='left ';
    if middlepressed then tmp:=tmp+'middle ';
    if rightpressed then tmp:=tmp+'right';
    tmp[0]:=#18;
    dspat(tmp,3,8,_lightgray+blue);
    if leftpressed then begin
      fillchar(tmp,sizeof(tmp),0);
      tmp:=copy(tm_getstratcursor(18),1,18);
      tmp[0]:=#18;
      dspat(tmp,3,9,_lightgray+blue);
      tmp:=copy(tmp,1,4);
      escape:=strdn(tmp)='exit';
    end;
  until escape;
  tm_hidemouse;
  getscr;
end.
