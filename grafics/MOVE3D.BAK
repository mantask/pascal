Program TextureMapping;
Uses Dos, Crt;
Const k=127;   { Multiplier }
      et1=170; { Perspective effect value }
      et2=50;
      zoommax=100; { Maximum Zoom = 100 (2x zoom) }
      MaxLL=100;   { Maximum length of one line in a face }
 hlp:array[0..9] of string =(
  ('. . ... ...   ... . . ...   ... ... . . ... ...   ...   ... ... ... ... ......   ... . . ...   ... ...   . ... ... ...'),
  ('. . .   .      .  . . .     ... . . . . .   .       .   . . . .  .  . .  ..      .  . . .     . . . .   . .   .    . '),
  ('. . ... ...    .  ... ...   . . . . . . ... ...   ...   ..  . .  .  ...  . ...    .  ... ...   . . ..    . ... .    . '),
  ('. .   . .      .  . . .     . . . . . .   . .     .     . . . .  .  . .  . .      .  . . .     . . . . . . .   .    . '),
  ('... ... ...    .  . . ...   . . ... ... ... ...   ...   . . ...  .  . .  . ...    .  . . ...   ... ... ... ... ...  . '),
  (' ... ... . .   . . ... . .   ... . . . ... ... '),
  (' . . . . . .   . . .   . .   .   . . .  .  .   '),
  (' ... . . ...   ..  ... ...   ...  .  .  .  ... '),
  (' . . . .  .    . . .    .    .   . . .  .    . '),
  (' . . . .  .    . . ...  .    ... . . .  .  ... '));
  { Help texts ... nice, eh? ;-}
 Var p_x,p_y,p_z:array[0..3] of integer;
     r_x,r_y:array[0..3] of integer;
     i,j:integer;r:real;              
     sins,coss:array[1..360] of integer; 
     x,y:integer;reg:registers;
     zoom:array[1..zoommax,1..zoommax] of integer; 
     lx,ly:array[0..1,0..MaxLL] of word;  
     lgtl:array[0..1] of word; 
     P,PP:pointer;sg,os,sp,op:word;   
     mouse_x,mouse_y,napit:integer;  

procedure pallette;
var
  ck : byte;
begin
  { setpal }
  for ck := 0 to 63 do
  begin
    port [$3C8] := ck;
    port [$3C9] := 0;
    port [$3C9] := 0;
    port [$3C9] := ck;
  end;
  for ck := 64 to 127 do
  begin
    port [$3C8] := ck;
    port [$3C9] := 0;
    port [$3C9] := 0;
    port [$3C9] := 127 - ck
  end;
  for ck := 128 to 191 do
  begin
    port [$3C8] := ck;
    port [$3C9] := 0;
    port [$3C9] := 0;
    port [$3C9] := ck - 128
  end;
  for ck := 192 to 255 do
  begin
    port [$3C8] := ck;
    port [$3C9] := 0;
    port [$3C9] := 0;
    port [$3C9] := 255 - ck
  end;
end;

Function checkmouse :boolean;
Begin
     reg.ax:=0; intr($33,reg);
     if reg.ax<>0 then checkmouse:=false else checkmouse:=true;
End;
Procedure showmouse;
Begin
reg.ax := 1; intr ($33,reg);
End;
Procedure hidemouse;
Begin
reg.ax :=2; intr($33,reg);
End;
Procedure readmouse;
Begin
reg.ax := 3; intr($33,reg);
mouse_y := reg.dx; mouse_x:= reg.cx;
napit := reg.bx;
End;
Procedure mouse_area(x1,x2,y1,y2 :integer);
Begin
reg.ax := 8; reg.cx := y1; reg.dx :=y2;
intr ($33,reg);
reg.ax := 7; reg.cx := x1 ; reg.dx :=x2;
intr ($33,reg);
End;
Procedure FakeLine(x1,y1,x2,y2:integer;num:byte);
Var   dx,dy,ax,rx,ry,i,count:integer;
      k:shortint;
label Xmajor1,Ymajor1,Ymajor2;
Begin
  k:=1;lgtl[num]:=1;count:=0;
  dx:=abs(x1-x2)+1;dy:=abs(y1-y2)+1;rx:=x1;ry:=y1;
      if (dx<dy) then goto Ymajor1;
 ax:=dx;if (y1-y2>0) then k:=-1;    (* X-major line *)
 if x1>x2 then goto Xmajor1;
For rx:=x1 to x2 do Begin
           lx[num,count]:=rx;ly[num,count]:=ry;inc(lgtl[num]);inc(count);
           ax:=ax-dy;if (ax<=0) then Begin inc(ax,dx);inc(ry,k);End;
End;exit;
xmajor1:  (* X-major line Right-to-left *)
For rx:=x1 downto x2 do Begin
           lx[num,count]:=rx;ly[num,count]:=ry;inc(lgtl[num]);inc(count);
           ax:=ax-dy;if (ax<=0) then Begin inc(ax,dx);inc(ry,k);End;
End;exit;
ymajor1:                            (* Y-major line *)
 ax:=dy;if (x1-x2>0) then k:=-1;
 if y1>y2 then goto Ymajor2;
For ry:=y1 to y2 do Begin
           lx[num,count]:=rx;ly[num,count]:=ry;inc(lgtl[num]);inc(count);
           ax:=ax-dx;if (ax<=0) then Begin inc(ax,dy);inc(rx,k);End;
End;exit;
ymajor2:
 For ry:=y1 downto y2 do Begin
           lx[num,count]:=rx;ly[num,count]:=ry;inc(lgtl[num]);inc(count);
            ax:=ax-dx;if (ax<=0) then Begin inc(ax,dy);inc(rx,k);End;
End;End;
Procedure Viiva(x1,y1,x2,y2:integer;color:byte);
Var   dx,dy,ax,rx,ry,i,count:integer;
      k:shortint;
label Ymajor1,Ymajor2;
Begin
  k:=1;count:=0;
  if (x1>x2) then Begin i:=x1;x1:=x2;x2:=i;
                        i:=y1;y1:=y2;y2:=i;End;
  dx:=abs(x1-x2)+1;dy:=abs(y1-y2)+1;rx:=x1;ry:=y1;
      if (dx<dy) then goto Ymajor1;
 ax:=dx;if (y1-y2>0) then k:=-1;    (* X-major line *)
For rx:=x1 to x2 do Begin
           i:=mem[sp:op+(color*50)+zoom[dx,count]];
           mem[sg:os+rx+ry*100]:=i;
           mem[sg:os+rx+ry*100+100]:=i;inc(count);
           ax:=ax-dy;if (ax<=0) then Begin inc(ax,dx);inc(ry,k);
           End;
End;exit;
ymajor1:                            (* Y-major line *)
 ax:=dy;if (x1-x2>0) then k:=-1;
 if y1>y2 then goto Ymajor2;
For ry:=y1 to y2 do Begin
           i:=mem[sp:op+(color*50)+zoom[dy,count]];
           mem[sg:os+rx+ry*100]:=i;
           mem[sg:os+rx+ry*100+100]:=i;inc(count);
           ax:=ax-dx;if (ax<=0) then Begin inc(ax,dy);inc(rx,k);End;
End;exit;
ymajor2:
 For ry:=y1 downto y2 do Begin
           i:=mem[sp:op+(color*50)+zoom[dy,count]];
           mem[sg:os+rx+ry*100]:=i;
           mem[sg:os+rx+ry*100+100]:=i;inc(count);
            ax:=ax-dx;if (ax<=0) then Begin inc(ax,dy);inc(rx,k);End;
End;End;
Procedure Kierto(x_kierto,y_kierto,z_kierto:integer;num:byte);
Var p,x1,y1,z1,x2,y2,z2:integer;
Begin
 x1:= (p_x[num]);
 y1:= (p_y[num]*coss[x_kierto] div k)+(p_z[num]*sins[x_kierto] div k);
 z1:=-(p_y[num]*sins[x_kierto] div k)+(p_z[num]*coss[x_kierto] div k);
 x2:= (x1*coss[y_kierto] div k)-(z1*sins[y_kierto] div k);
 z2:= (x1*sins[y_kierto] div k)+(z1*coss[y_kierto] div k);
 x1:= (x2*coss[z_kierto] div k)+(y1*sins[z_kierto] div k);
 y2:=-(x2*sins[z_kierto] div k)+(y1*coss[z_kierto] div k);
 p:=(k*et1) div ((z2)+et1+et2);
 x:=(x1*p) div k;
 y:=(y2*p) div k;
 x:=x+50;
 y:=-y+50;
End;
Procedure PreCalculate;
Begin TextColor(3);
 write(' 3D Textured vector routine, 100% Pascal ');
 delay(1000);

For i:=0 to 360 do Begin
  r:=i;sins[i]:=round(sin(r/180*pi)*k);
       coss[i]:=round(cos(r/180*pi)*k);
  End;
 For i:=1 to zoommax do For j:=1 to i do Begin
  r:=50/i;zoom[i,j]:=round(j*r);End;
End;
Procedure SetObject;
Begin
 p_x[0]:= 40;p_y[0]:=-40;p_z[0]:=0;
 p_x[1]:= 40;p_y[1]:= 40;p_z[1]:=0;
 p_x[2]:=-40;p_y[2]:= 40;p_z[2]:=0;
 p_x[3]:=-40;p_y[3]:=-40;p_z[3]:=0;
End;
Procedure ShowFace;
Var pt:array[0..ZoomMax] of integer;kk:integer;a0,a1:byte;
Begin
  fakeline(r_x[1],r_y[1],r_x[0],r_y[0],0);
  fakeline(r_x[2],r_y[2],r_x[3],r_y[3],1);
  dec(lgtl[0],2);dec(lgtl[1],2);
a0:=0;a1:=1;if lgtl[0]<lgtl[1] then Begin a0:=1;a1:=0;End;
 r:=lgtl[a1]/lgtl[a0];
 kk:=round(r*k);
For i:=1 to lgtl[a0] do Pt[i]:=(i*kk) div k;
For i:=1 to lgtl[a0] do
viiva(lx[a0,i],ly[a0,i],lx[a1,pt[i]],ly[a1,pt[i]],zoom[lgtl[a0],i]);
End;
Procedure ShowWorkspace;
Begin
For i:=0 to 99 do
 move(mem[sg:os+(i*100)],mem[$a000:16100+(i*320)],100);
End;
Procedure ClearWorkspace;
Begin
 fillchar(mem[sg:os],10000,0);
End;
Procedure ShowHelp;
Begin
 For j:=0 to 4 do For i:=1 to length(hlp[j]) do if (ord(hlp[j,i])<>32) then
mem[$a000:1610+i+(j*320)]:=15;
 For j:=5 to 9 do For i:=1 to length(hlp[j]) do if (ord(hlp[j,i])<>32) then
mem[$a000:57225+i+(j*320)]:=15;
End;
(* Main Program *)
Begin clrscr;
   if checkmouse then Begin TextColor(12);Writeln(' Warning! No mouse found!');writeln('');End;
   getmem(p,10000);sg:=seg(p^);os:=ofs(p^);
   getmem(PP,2550);sp:=seg(pp^);op:=ofs(pp^);
 PreCalculate;
    SetObject;
  Begin  For i:=0 to 49 do For j:=0 to 50 do mem[sp:op+i+(j*50)]:=i+j;
 reg.ax:=$13;intr($10,reg);End;ShowHelp; { MCGA mode }
   Mouse_area(0,716,0,716);
 readmouse;
 pallette;
repeat
  ClearWorkspace;
 For i:=0 to 3 do Begin
     Kierto((mouse_y div 2)+1,(mouse_x div 2)+1,1,i);r_x[i]:=x;r_y[i]:=y;End;
 ShowFace;
repeat until port[$3da] and 8=8;
 ShowWorkSpace;
 ReadMouse;
until keypressed;
  reg.ax:=$03;intr($10,reg); { Normal text-mode }
writeln(' - The reason why this routine is so "slow"');
writeln('   is that  it is  coded  100% in  pascal. ');
End.
