unit smgrafx;

{    Remco de Korte
     Soft Machine
     remcodek@xs4all.nl
     http://www.xs4all.nl/~remcodek/

     thanks: Denthor of Asphyxia}

interface

type
  virtual = array[1..64000] of byte;
  virtptr = ^virtual;

var
  virscr,virscr2,virscr3:virtPtr;
  vga2,vga3,vga4:word;
  sl:array[0..199] of word;
  loop:byte;
  fadepal:array[0..255,1..3] of byte;



procedure initgraf;
procedure inittext;
procedure screen(col:byte;w:word);
procedure putpixel (x,y:integer;col:byte;w:word);
function getpixel (x,y:integer;w:word):byte;
procedure waitretrace;
procedure getpal(cn:byte;Var r,g,b:Byte);
procedure setpal(cn:byte;r,g,b:byte);
procedure setupvirtual;
procedure setupvirtual2;
procedure setupvirtual3;
procedure shutdown;
procedure flip(source,dest:word);
procedure hline (x1,x2,y:word;col:byte;w:word);
procedure line(a,b,c,d:integer;col:byte;w:word);
procedure drawpoly(x1,y1,x2,y2,x3,y3,x4,y4:integer;color:byte;w:word);
procedure rectangle(x1,y1,x2,y2:integer;col:byte;w:word);
procedure fadeout;
procedure fadein;
procedure quickfadeout(z:integer);
procedure quickfadein(z:integer);

const vga=$a000;

implementation

uses
  crt,dos;

type
  toggles=(rshift,lshift,ctrl,alt,scrolllock,numlock,capslock,insert);
  status=set of toggles;

var
  keystatus:status absolute $40:$17;

function sgn(a:real):integer;

begin
  if a>0 then sgn:=+1;
  if a<0 then sgn:=-1;
  if a=0 then sgn:=0;
end;

function rad (theta : real) : real;

begin
  rad := theta * pi / 180
end;

procedure initgraf; assembler;

asm
  mov        ax,0013h
  int        10h
end;


procedure inittext; assembler;

asm
  mov        ax,0003h
  int        10h
end;

procedure screen; assembler;

asm
   push    es
   mov     cx, 32000;
   mov     es,[w]
   xor     di,di
   mov     al,[col]
   mov     ah,al
   rep     stosw
   pop     es
end;

procedure putpixel; assembler;

asm
   mov  ax,w
   mov  es,ax
   mov  bx,[y]
   shl  bx,1
   mov  di,word ptr [sl + bx]
   add  di,[x]
   mov  al,[col]
   mov  es:[di],al
end;

function getpixel; assembler;

asm
   mov  ax,w
   mov  es,ax
   mov  bx,[y]
   shl  bx,1
   mov  di,word ptr [sl + bx]
   add  di,[x]
   mov  al,es:[di]
end;

procedure waitretrace;assembler;

label
  l1, l2;
asm
    mov dx,3DAh
l1:
    in al,dx
    and al,08h
    jnz l1
l2:
    in al,dx
    and al,08h
    jz  l2
end;

procedure getpal(cn:byte;Var r,g,b:Byte);

var
  rr,gg,bb:byte;

begin
   asm
      mov    dx,3c7h
      mov    al,cn
      out    dx,al

      add    dx,2

      in     al,dx
      mov    [rr],al
      in     al,dx
      mov    [gg],al
      in     al,dx
      mov    [bb],al
   end;
   r := rr;
   g := gg;
   b := bb;
end;

procedure setpal(cn:byte;r,g,b:byte);

begin
 asm
   mov    dx,3c8h
   mov    al,[cn]
   out    dx,al
   inc    dx
   mov    al,[r]
   out    dx,al
   mov    al,[g]
   out    dx,al
   mov    al,[b]
   out    dx,al
 end;
end;

procedure setupvirtual;

begin
  getmem (virscr,64000);
  vga2 := seg (virscr^);
end;

procedure setupvirtual2;

begin
  getmem (virscr2,64000);
  vga3 := seg (virscr2^);
end;

procedure setupvirtual3;

begin
  getmem (virscr3,64000);
  vga4 := seg (virscr3^);
end;

procedure shutdown;

begin
  freemem (virscr,64000);
end;

procedure flip; assembler;

asm
  push    ds
  mov     ax, [Dest]
  mov     es, ax
  mov     ax, [Source]
  mov     ds, ax
  xor     si, si
  xor     di, di
  mov     cx, 32000
  rep     movsw
  pop     ds
end;

procedure hline; assembler;

asm
  mov   ax,w
  mov   es,ax
  mov   ax,y
  mov   di,ax
  shl   ax,8
  shl   di,6
  add   di,ax
  add   di,x1

  mov   al,col
  mov   ah,al
  mov   cx,x2
  sub   cx,x1
  shr   cx,1
  jnc   @start
  stosb
@Start :
  rep   stosw
end;

procedure line;

var i,s,d1x,d1y,d2x,d2y,u,v,m,n:integer;

begin
  u:= c - a;
  v:= d - b;
     d1x:= SGN(u);
     d1y:= SGN(v);
     d2x:= SGN(u);
     d2y:= 0;
     m:= ABS(u);
     n := ABS(v);
     IF NOT (M>N) then
     BEGIN
          d2x := 0 ;
          d2y := SGN(v);
          m := ABS(v);
          n := ABS(u);
     END;
     s := m shr 1;
     FOR i := 0 TO m DO
     BEGIN
          putpixel(a,b,col,w);
          s := s + n;
          IF not (s<m) THEN
          BEGIN
               s := s - m;
               a:= a + d1x;
               b := b + d1y;
          END
          ELSE
          BEGIN
               a := a + d2x;
               b := b + d2y;
          END;
     end;
END;


procedure drawpoly;

var
  x:integer;
  mny,mxy:integer;
  mnx,mxx,yc:integer;
  mul1,div1,
  mul2,div2,
  mul3,div3,
  mul4,div4:integer;

begin
  mny:=y1; mxy:=y1;
  if y2<mny then mny:=y2;
  if y2>mxy then mxy:=y2;
  if y3<mny then mny:=y3;
  if y3>mxy then mxy:=y3;    { Choose the min y mny and max y mxy }
  if y4<mny then mny:=y4;
  if y4>mxy then mxy:=y4;

  if mny<0 then mny:=0;
  if mxy>199 then mxy:=199;
  if mny>199 then exit;
  if mxy<0 then exit;        { Verticle range checking }

  mul1:=x1-x4; div1:=y1-y4;
  mul2:=x2-x1; div2:=y2-y1;
  mul3:=x3-x2; div3:=y3-y2;
  mul4:=x4-x3; div4:=y4-y3;  { Constansts needed for intersection calc }

  for yc:=mny to mxy do
    begin
      mnx:=320;
      mxx:=-1;
      if (y4>=yc) or (y1>=yc) then
        if (y4<=yc) or (y1<=yc) then   { Check that yc is between y1 and y4 }
          if not(y4=y1) then
            begin
              x:=(yc-y4)*mul1 div div1+x4; { Point of intersection on x axis }
              if x<mnx then
                mnx:=x;
              if x>mxx then
                mxx:=x;       { Set point as start or end of horiz line }
            end;
      if (y1>=yc) or (y2>=yc) then
        if (y1<=yc) or (y2<=yc) then   { Check that yc is between y1 and y2 }
          if not(y1=y2) then
            begin
              x:=(yc-y1)*mul2 div div2+x1; { Point of intersection on x axis }
              if x<mnx then
                mnx:=x;
              if x>mxx then
                mxx:=x;       { Set point as start or end of horiz line }
            end;
      if (y2>=yc) or (y3>=yc) then
        if (y2<=yc) or (y3<=yc) then   { Check that yc is between y2 and y3 }
          if not(y2=y3) then
            begin
              x:=(yc-y2)*mul3 div div3+x2; { Point of intersection on x axis }
              if x<mnx then
                mnx:=x;
              if x>mxx then
                mxx:=x;       { Set point as start or end of horiz line }
            end;
      if (y3>=yc) or (y4>=yc) then
        if (y3<=yc) or (y4<=yc) then   { Check that yc is between y3 and y4 }
          if not(y3=y4) then
            begin
              x:=(yc-y3)*mul4 div div4+x3; { Point of intersection on x axis }
              if x<mnx then
                mnx:=x;
              if x>mxx then
                mxx:=x;       { Set point as start or end of horiz line }
            end;
      if mnx<0 then
        mnx:=0;
      if mxx>319 then
        mxx:=319;          { Range checking on horizontal line }
      if mnx<=mxx then
        hline (mnx,mxx,yc,color,w);   { Draw the horizontal line }
    end;
  end;

procedure rectangle;

begin
  line(x1,y1,x1,y2,col,w);
  line(x2,y1,x2,y2,col,w);
  line(x1,y1,x2,y1,col,w);
  line(x1,y2,x2,y2,col,w);
end;

procedure fadeout;

var
	i,j:integer;

begin
	for i:=0 to 255 do getpal(i,fadepal[i,1],fadepal[i,2],fadepal[i,3]);
	for j:=63 downto 0 do
	begin
		for i:=0 to 255 do setpal(i,fadepal[i,1]*j div 63,fadepal[i,2]*j div 63,fadepal[i,3]*j div 63);
		delay(10);
	end;
end;

procedure fadein;

var
	i,j:integer;

begin
	for j:=0 to 63 do
	begin
		for i:=0 to 255 do setpal(i,fadepal[i,1]*j div 63,fadepal[i,2]*j div 63,fadepal[i,3]*j div 63);
		delay(10);
	end;
end;

procedure quickfadeout;

var
	i,j:integer;

begin
	for i:=0 to 255 do getpal(i,fadepal[i,1],fadepal[i,2],fadepal[i,3]);
	for j:=z downto 0 do
	begin
		for i:=0 to 255 do setpal(i,fadepal[i,1]*j div z,fadepal[i,2]*j div z,fadepal[i,3]*j div z);
		delay(10);
	end;
end;

procedure quickfadein;

var
	i,j:integer;

begin
	for j:=0 to z do
	begin
		for i:=0 to 255 do setpal(i,fadepal[i,1]*j div z,fadepal[i,2]*j div z,fadepal[i,3]*j div z);
		delay(10);
	end;
end;

function shiftstate:byte;

var
  regs:registers;

begin
  regs.ah:=2;
  intr($16,regs);
  shiftstate:=regs.al;
end;

function readnumlock: boolean;

begin
  readnumlock:=(shiftstate and 32)<>0;
end;



begin
  for loop:=0 to 199 do sl[loop]:=loop*320;
  if readnumlock=true then keystatus:=keystatus-[numlock];
end.
