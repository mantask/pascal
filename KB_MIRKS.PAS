{MK 2001}
program keyboard_LED;
  uses crt;
  const viso = 25;      {kiek kartu mirges}
        laikas = 10000; {delay trukme}
        mirksi : array [1 .. viso, 1 .. 3] of 0 .. 1 = {mirksejimo tvarka}
          ((1,0,1),(0,1,0),(1,0,1),(0,1,0),(1,0,1),
           (0,0,0),(1,0,0),(0,1,0),(0,0,1),(0,1,0),
           (1,0,0),(0,1,0),(0,0,1),(0,1,0),(1,0,0),
           (0,1,0),(0,0,1),(0,1,0),(1,0,0),(1,1,1),
           (0,0,0),(1,1,1),(0,0,0),(1,1,1),(0,0,0));
  var num_lock, Caps_lock, Scroll_lock : boolean;
      pg, ck : byte;
      kb_flag : byte absolute $40:$97;  { LOCKu vieta atmintyje }
  label del, del1;
begin
{
          Keyboard Flags Bytes 2 and 3

          ³7³6³5³4³3³2³1³0³  40:97  LED Indicator Flags
           ³ ³ ³ ³ ³ ³ ³ ÀÄÄÄÄ scroll lock indicator
           ³ ³ ³ ³ ³ ³ ÀÄÄÄÄÄ num-lock indicator
           ³ ³ ³ ³ ³ ÀÄÄÄÄÄÄ caps-lock indicator
           ³ ³ ³ ³ ÀÄÄÄÄÄÄÄ circus system indicator
           ³ ³ ³ ÀÄÄÄÄÄÄÄÄ ACK received
           ³ ³ ÀÄÄÄÄÄÄÄÄÄ re-send received flag
           ³ ÀÄÄÄÄÄÄÄÄÄÄ mode indicator update
           ÀÄÄÄÄÄÄÄÄÄÄÄ keyboard transmit error flag
}
  clrscr;
  textcolor (7);
  writeln ('Dabar atsipalaiduok ir stebek savo klaviaturos lemputes');
  writeln ('SPAUSK MYGTUKA ir ziurek!');
  readkey;
  pg := kb_flag;
  if (pg and 1) = 1 then scroll_lock := true else scroll_lock := false;
  if (pg and 2) = 2 then num_lock := true else num_lock := false;
  if (pg and 4) = 4 then caps_lock := true else caps_lock := false;

  for ck := 1 to viso do
  begin
    pg := 0;
    if mirksi [ck, 1] = 1 then pg := pg + 2;
    if mirksi [ck, 2] = 1 then pg := pg + 4;
    if mirksi [ck, 3] = 1 then pg := pg + 1;
{   kb_flag := pg;}{nera reikalo jungineti LOCKus realiai, uztenka tik LEDus}
    asm
       mov   al,0edH
       out   60H,al
       mov   cx,2000H
  del: loop  del
       mov   al,pg
       out   60H,al
    end;
    delay (laikas);
  end;

  pg := 0;
  if scroll_lock then pg := pg + 1;
  if num_lock then pg := pg + 2;
  if caps_lock then pg := pg + 4;
  kb_flag := pg; {grazinam senus lockus, bet ne LED}
  { dabar laikas ir LEDam }
  asm
     mov   al, 0edH {0edH - kaitaliosim LED}
     out   60H, al   {60H - PC/XT, 64H - AT}
     mov   cx, 2000H
del1:loop  del1
     mov   al, pg    {pirmi 3 bitai: 01H - scroll, 02H - num, 04H - scroll}
     out   60H, al
  end;
end.