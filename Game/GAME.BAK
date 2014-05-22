 {nereikia jokiu sauta ar pa n, o reikia krentanciu rutuliuku pagal sin grafika
 ir kokia 3 vienu metu, tada reiketu juos saudyti}
program pele;
  uses crt, graph, taik;
  const R = 50;
        Rs = 10;
  var gm, gd,
      x, y,       {taikinio piesimas}
      mxx, myy,   {senos peles x, y koord}
      mx, my,     {naujos peles x, y koord}
      m, sm       {peles mygtuko busena}
      : integer;
      lygis,      {keicia cikle x, kuo didesnis - tuo jud. greitis didesnis}
      c : byte;   {char, reikalingas kai skaitau is port [$60]}
      {objektai is 'taik.pas' unito (zemiau)}
      taikiklis : Ttaikiklis;
      taikinys : Ttaikinys;
      status : Tstatus;
  label pb;
{----------------------------------------------------------------------------}
  Procedure Refresh; Assembler;
  asm
     mov dx,3DAh
  @@1:
     in al,dx
     and al,08h
     jnz @@1
  @@2:
     in al,dx
     and al,08h
     jz  @@2
  end;

  procedure InitMouse; assembler;
  asm
    mov ax, 0h
    int 33h
  end;

  procedure ShowPointer; assembler;
  asm
    mov ax, 1h
    int 33h
  end;

  procedure HidePointer; assembler;
  asm
    mov ax, 2h
    int 33h
  end;

  procedure GetXY (var x, y, m : integer);
    var mm, xx, yy : integer;
  begin
    asm
      mov ax, 003h
      int 33h
      mov mm, bx
      mov xx, cx
      mov yy, dx
    end;
    x := xx;
    y := yy;
    m := mm;
  end;

{  procedure ratas (x, y, R : integer);
  begin
    circle (x, y, R + 10);
    circle (x, y, R);
    line (x, y - 10, x, y + 10);
    line (x - 10, y, x + 10, y);
  end;

  procedure taikinys (x, y : integer);
    var ck, R : byte;
  begin
    r := 120;
    setcolor (0);
    for ck := 1 to 6 do
     begin
      setfillstyle (1, ck);
      dec (R,  20);
      fillellipse (x, y, r, r)
     end;
  end;
}
{  procedure skyle (x, y : integer);
  begin
    bar (x - 1, y - 1, x + 1, y + 1);
  end;
 }
  function pataikei : boolean;
  begin
    if (mx < (x + R)) and (mx > (x - R)) and
       (my < (y + R)) and (my > (y - R)) then pataikei := true
                                         else pataikei := false;
  end;
{----------------------------------------------------------------------------}
begin
  initgraph (gd, gm, '');
  initmouse;
  hidepointer;
  taikinys.paruosk;
  lygis := 255;

{intro}
   setcolor (8);
   line (110, 180, 540, 180);
   line (110, 183, 540, 183);
   SetTextStyle (0, HorizDir, 0);
   OUTTEXTxy (200, 100, 'S u p e r   s h o o t e r :');
   outtextXY (250, 470, 'MK & VC inc. 2001');
   setcolor (9);
   SetTextStyle (0, HorizDir, 3);
   outtextxy (110, 150, 'Snoopy: The Hunter');
   setTextStyle (0, HorizDir, 0);

   {palaukia mygtuko paspaudimo}
   c := port [$60];
   repeat until port [$60] <> c;

{zaidimas}
  repeat
    cleardevice;
    status.paruosk;
    status.piesk;
    inc (lygis);

    for X := 1 to 649 do
    begin
      x := x + Lygis;
      {peles statusas}
      getxy (mx, my, m);
      if (mx <> mxx) or (my <> myy) then taikiklis.valyk;
      {piesiamas taikinys}
      if x > 3 then taikinys.valyk;
      y := taikinys.kelias (x);
      taikinys.keiskxy (x, y);
      taikinys.piesk;
      {pele toliau...}
      {ar paspaustas myg 1}
      if ((m and 1) = 1) and (sm <> m) and status.galima then
      begin
        if pataikei then status.pataikei
                    else status.nepataikei;
        status.piesk;
      end;
      sm := m;
      {ar pasikeite peles koord.}
      if (mx <> mxx) or (my <> myy) then
      begin
       taikiklis.keiskxy (mx, my);
       taikiklis.piesk;
       mxx := mx;
       myy := my;
      end;
      refresh;
      delay (50);
      {nutraukimo salygos}
      if Status.laimejai then break;
      if x > 649 then break;
      if port [$60] = 1 then goto pb;
    end;

    if status.laimejai then
    begin
      cleardevice;
      outtextXY (220, 100, 'Tu kieciausias!')
    end
    else begin
      cleardevice;
      setcolor (8);
      outtextxy (220, 100, 'Tu 100% avilys!')
    end;

    {palaukia mygtuko paspaudimo}
    c := port [$60];
    repeat until port [$60] <> c;

  until not status.laimejai;

{pabaiga}
pb:
  cleardevice;
  setcolor (8);
  outtextXY (220, 100, 'Zaidimas baigtas');

  {palaukia mygtuko paspaudimo}
  c := port [$60];
  repeat until port [$60] <> c;

  closegraph;
{  repeat until port [$60] = 1}
end.