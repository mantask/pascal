
{$g+,n+,e-} { <-- Sorry about that, it's slow anyway }

{ Reals   :       -1     -0.1      0.3   -1.139
  Complex :        0      0.8     -0.5    0.238 }

program julia; { FRACTAL1.PAS }
{ Julia Fractal, uses hardcoded ET4000 SVGA mode! By Bas van Gaalen }
uses u_vga,u_pal,u_kb;
const vseg:word=$a000; speed=2; { ei: 1=slow and accurate; 5=fast and inaccurate }
type real=double;
var cx,cy,xo,yo,x1,y1,xdiv,ydiv:real; mx,my,a,b,i,orb:word;

procedure putpixel(xp,yp:word; col:byte); assembler; asm
  mov es,vseg; mov ax,yp; mov dx,640; mul dx; add ax,xp; adc dx,0; mov di,ax
  mov al,dl; mov dx,03cdh; out dx,al; mov al,col; mov [es:di],al; end;

begin
  write('Real part: '); readln(cx);
  write('Imaginary part: '); readln(cy);
  setvideo($2e);
  for i:=1 to 64 do setrgb(i,15+i div 3,15+i div 3,15+round(i/1.306122449));
  mx:=639; my:=479; xdiv:=mx/4; ydiv:=my/4;
  a:=1;
  while a<mx do begin
    b:=1;
    while b<my do begin
      xo:=-2+a/xdiv; { X complex plane coordinate }
      yo:=2-b/ydiv; { Y complex plane coordinate }
      i:=0;
      repeat
        x1:=xo*xo-yo*yo+cx;
        y1:=2*xo*yo+cy;
        xo:=x1;
        yo:=y1;
        inc(i);
      until (i=64) or (x1*x1+y1*y1>4) or (abs(x1)>2) or (abs(y1)>2);
      if i<64 then orb:=i else orb:=63;
      putpixel(a,b,orb); { Plot orbit }
      inc(b,speed);
    end;
    inc(a,speed);
  end;
  while not keypressed do;
  setvideo(u_lm);
end.
