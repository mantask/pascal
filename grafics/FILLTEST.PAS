
program floodfill_demo; { FILLTEST.PAS }
{ Mini-drawing program to demonstrate the floodfill-procedure.
  Left button: draw lines
  Right button: fill!
  By Bas van Gaalen }
uses u_vga,u_mouse,u_kb;
const
  drawcolor=white;
  fillcolor=blue;

const
  msptr:array[0..pred(5*5)] of byte=(                        { mouse pointer }
    0,0,7,0,0,
    0,0,15,0,0,
    7,15,0,15,7,
    0,0,15,0,0,
    0,0,7,0,0
  );

var virscr:pointer; x,y:word; first:boolean;
begin
  setvideo($13);
  with sprite[1] do begin
    xpos:=0; ypos:=0;
    xsize:=5; ysize:=5;
    buf:=@msptr;
    seethru:=0;
    transparant:=false;
  end;
  gm_mousewindow(5,5,315,195); { graphics mouse window }
  getmem(virscr,64000);
  cls(virscr,64000);
  x:=0; y:=0; { last line coord }
  first:=true; { first leftpressed }
  repeat
    vretrace;
    destenation:=vidptr;
    movesprabs(1,getmousex-2,getmousey-2);
    putback(virscr,vidptr,1);
    putsprite(1);
    if leftpressed then begin
      destenation:=virscr; { draw everything in virtual screen }
      if first then begin
        x:=getmousex; y:=getmousey;
        putpixel(x,y,drawcolor);
        first:=false;
      end
      else begin
        vga_line(x,y,getmousex,getmousey,drawcolor);
        x:=getmousex; y:=getmousey;
      end;
      flip(virscr,vidptr,64000); { make copy to visual screen }
    end;
  until rightpressed;
  freemem(virscr,64000);
  putback(virscr,vidptr,1); { clear last mousepointer }
  floodfill(getmousex,getmousey,fillcolor); { go and fill! }
  while not leftpressed do;
  setvideo(u_lm);
end.
