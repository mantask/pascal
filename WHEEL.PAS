program wheel;

{ Made by Jos Dickmann for public domain }
{ e-mail : j.w.j.dickmann@universal.nl }
{ The SVGA driver "Svga256.bgi" is on my Pascal Page }
{ http://www.universal.nl/users/dickmann/pascal.htm }


uses crt,dos,graph;

const                                    { random score }
  score :array[128..217] of byte =
    (1,2,3,4,5,11,12,13,14,15,21,22,23,24,25,31,32,33,34,35,41,42,43,44,45,
     51,52,53,54,55,61,62,63,64,65,71,72,73,74,75,81,82,83,84,85,
     6,7,8,9,10,16,17,18,19,20,26,27,28,29,30,36,37,38,39,40,
     46,47,48,49,50,56,57,58,59,60,66,67,68,69,70,76,77,78,79,80,
     86,87,88,89,90);

var
  x,y,p,pp,q : integer;
  ch         : char;
  start      : integer;
  run_out    : byte;
  s          : string;

procedure STARS(x,y,xx,yy,number :integer;point :byte);

begin
 { randomize;}
  for pp :=0 to point do begin
    for p :=1 to number do begin
      putpixel(random(xx-(x-1))+x,random(yy-(y-1))+y,7);
      putpixel(random(xx-(x-1))+x,random(yy-(y-1))+y,8);
      putpixel(random(xx-(x-1))+x,random(yy-(y-1))+y,15);
    end;
    inc(x,40);inc(y,40);dec(xx,40);dec(yy,40);
  end;
end;


Procedure WAIT(ms : Word); Assembler;{**************************************}
Asm
  mov ax, 1000;
  mul ms;
  mov cx, dx;
  mov dx, ax;
  mov ah, $86;
  int $15;
end;

Procedure RGB(Color,wr,wg,wb : Byte);{**************************************}

begin
  Port[$3C8]:=Color;
  Port[$3C9]:=wr;
  Port[$3C9]:=wg;
  Port[$3C9]:=wb;
end;

procedure screen(scherm :byte);{********************************************}

var  AutoDetect : pointer;  GrMd,GrDr  : integer;

{$F+}
function DetectVGA0 : Integer;
begin detectvga0 :=0;end;
function DetectVGA1 : Integer;
begin detectvga1 :=1;end;
function DetectVGA2 : Integer;
begin detectvga2 :=2;end;
function DetectVGA3 : Integer;
begin detectvga3 :=3;end;
function DetectVGA4 : Integer;
begin detectvga4 :=4;end;
{$F-}

begin
  AutoDetect := @DetectVGA2;
  case scherm of
    0:AutoDetect := @DetectVGA0;    { 320x200x256 }
    1:AutoDetect := @DetectVGA1;    { 640x400x256 }
    2:AutoDetect := @DetectVGA2;    { 640x480x256 }
    3:AutoDetect := @DetectVGA3;    { 800x600x256 }
    4:AutoDetect := @DetectVGA4;    { 1024x768x256 }
  end;
  GrDr := InstallUserDriver('SVGA256',AutoDetect);
  GrDr := Detect;
  InitGraph(GrDr,GrMd,'');
end;

procedure klik;{***********************************************************}

begin
  sound(2000);wait(1);nosound;
end;

procedure run_loop;{*******************************************************}

begin
  repeat
    rgb(start,50,0,0);
    klik;
    wait(10);
    rgb(start,15,0,0);
    inc(start);
    if start =218 then start :=128;
  until keypressed;

  pp :=10;
  run_out :=random(30)+40;    { number between 40 and 70 }
  repeat
    rgb(start,50,0,0);
    klik;
    wait(pp);
    rgb(start,15,0,0);
    inc(start);
    if start =219 then start :=128;
    inc(pp);
  until pp =run_out;

  rgb(start,50,0,0);

  bar(20,20,50,40);

  str(score[start],s);
  settextstyle(0,0,2);
  setcolor(13);outtextxy(20,20,s);
  setcolor(5);outtextxy(21,21,s);
  settextstyle(0,0,0);
end;

procedure design_screen;{***************************************************}

begin
  cleardevice;
  stars(0,0,639,479,200,5);
  setcolor(8);
  setfillstyle(1,0);
  fillellipse(320,240,204,204);
  x :=0;
  for pp :=1 to 90 do begin
    for p :=1 to 200 do begin
      setcolor(127+pp);
      if p <70 then setcolor(1);
      ellipse(320,240,0+x,4+x,p,p);
    end;
    inc(x,4);
  end;

  settextstyle(0,0,2);
  setcolor(13);outtextxy(214,200,'SPACE IS START');
  setcolor(5);outtextxy(215,201,'SPACE IS START');

  setcolor(15);outtextxy(221,230,'ENTER IS STOP');
  setcolor(7);outtextxy(222,231,'ENTER IS STOP');

  setcolor(10);outtextxy(214,260,'ESCAPE IS EXIT');
  setcolor(2);outtextxy(215,261,'ESCAPE IS EXIT');
  settextstyle(0,0,0);


  settextstyle(0,0,3);
  setcolor(11);outtextxy(130,410,'WHEEL OF FORTUNE');
  setcolor(3);outtextxy(131,411,'WHEEL OF FORTUNE');
  settextstyle(0,0,0);
end;

begin
  screen(2);                                           { screen 640x480x256 }
  for p :=128 to 217 do setrgbpalette(p,15,0,0);       { red color }

  design_screen;

  start :=128;
  repeat
    run_loop;
    repeat
      ch :=readkey;
    until ch in[#32,#27];
  until ch in[#27];

  closegraph;
  halt;
end.
