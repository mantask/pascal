uses
  dos;
const
  baitas : byte = 7;
var
  KbdIntVec : Procedure;
  senas : ^byte;
  kb_flag : byte absolute $40:$97;
{$F+}
procedure Keyclick; interrupt;
  var pg : byte;
begin
  senas^ := senas^ xor baitas;
  pg := senas^;
  asm
    mov   al, 0edH
    out   60H, al
    mov   cx, 2000H
   @del:
    loop  @del
    mov   al, pg
    out   60H, al
  end;
  inline ($9C);
  KbdIntVec;
end;
{$F-}
begin
  senas^ := kb_flag;
  { Insert ISR into keyboard chain }
  GetIntVec($9,@KbdIntVec);
  SetIntVec($9,Addr(Keyclick));
  Keep(0); { Terminate, stay resident }
end.

