{$M $800,0,0 }
uses Crt, Dos;
const spal = 256;
var
  KbdIntVec : Procedure;
  ck, r, b, g : byte;

procedure setpal(num, r, g, b: byte);
begin
  port [$3C8] := num;
  port [$3C9] := R;
  port [$3C9] := G;
  port [$3C9] := B
end;

procedure getpal(var num, r, g, b: byte);
begin
  num := port [$3C8];
  R   := port [$3C9];
  G   := port [$3C9];
  B   := port [$3C9]
end;

{$F+}
procedure Keyclick; interrupt;
begin
  if Port[$60] < $80 then
  begin
     Sound(5000);
     Delay(1);
     Nosound;
     for ck := 0 to spal - 1 do
     begin
        getpal (ck, r, g, b);
        r := (r + 4) mod 256;
        g := (g + 4) mod 256;
        b := (b + 4) mod 256;
        setpal (ck, r, g, b);
     end
  end;
  inline ($9C); { PUSHF -- Push flags }
  KbdIntVec;
end;
{$F-}
begin
  GetIntVec($9,@KbdIntVec);
  SetIntVec($9,Addr(Keyclick));
  Keep(0); { Terminate, stay resident }
end.

