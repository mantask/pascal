Program PhireX;
{$G+}    { Enable 286 instructions }
{ coded by Phred  7/23/94     aka Alex Chalfin    }
{               Internet: achalfin@uceng.uc.edu   }
{ A fast computer is HIGHLY recommended.          }
{ Inspired by Jare's fire code                    }

uses dos;

Var
{  Screen : Array[0..63999] of Byte ABSOLUTE $A000:$0000; { the VGA screen }
  { i: not used before, so why should I keep it ??? }
  VScreen : Array[0..16000] of Byte;                { an offscreen buffer }
  {i: now a 4th of the old buffer }
  Lookup : Array[0..199] of Word;    { an Offset lookup table }


procedure mode_x_init;
{ i: routine added by me }
{ i: moreover, the pas-init might have an educational effect }

var regs : registers;
begin
   regs.ax :=$0013;                       { 320*200*256 on }
   intr($10,regs);
   port[$3c4] := 4;                       { memory mode reg }
   port[$3c5] := port[$3c5] and not 8;    { chain 4 off }
   port[$3d4] := $14;                     { underline location reg }
   port[$3d5] := port[$3d5] and not $40;  { dwordmode off }
   port[$3d4] := $17;                     { mode control reg }
   port[$3d5] := port[$3d5] or $40;       { bytemode on }
end;


Procedure SetPalette; Near;
{ Sets the Palette }

Var
  p : Array[0..767] of Byte;
  x : integer;

Begin
  for x := 0 to 255 do            { Generate fade from orange to black }
    Begin
      p[x*3] := (x * 63) Shr 8;
      P[x*3+1] := (x * 22) Shr 8;
      P[x*3+2] := 0;
    End;
  Port[$3C8] := 0;
  For x := 0 to 255 do        { Set the palette }
    Begin
      Port[$3C9] := P[x*3];
      Port[$3C9] := P[x*3+1];
      Port[$3C9] := P[x*3+2];
    End;
End;


Procedure Burnin_Down_The_House;

Var
  c : Integer;

Begin
  Randomize;
  Repeat
    For c := 0 to 79 do    { Setup bottom line "hot spots" }{ i: 319 -> 79 }
      If Random(4) = 1
        Then VScreen[LookUp[199] + c] := Random(3) * 255;

    port[$3c4] := 2;      { i: enable all planes read and write }
    port[$3c5] :=$0f;     { i: }
    port[$3ce] := 2;      { i: }
    port[$3cf] := 1;      { i: }

    Asm
      MOV  CX,7200       { Number of pixels to calculate }{ i: 28800->7200 }
      PUSH CX            { Store count on stack }
      MOV  AX,Offset VScreen
      PUSH AX               { Store value on stack }
      MOV  SI,AX
      MOV  BX,199
      SHL  BX,1
      MOV  AX,Word Ptr [LookUp + BX]
      ADD  SI,AX
      DEC  SI            { DS:SI := VScreen[LookUp[198]+79] } { i: }
     @Looper:
      XOR  AX,AX
      XOR  BX,BX
      MOV  AL,DS:[SI+79]     { i: all those 320something-constants }
      ADD  BX,AX
      MOV  AL,DS:[SI+80]     { i: have to be divided by 4 }
      ADD  BX,AX
      MOV  AL,DS:[SI+81]
      ADD  BX,AX
      MOV  AL,DS:[SI]
      ADD  BX,AX    { Average the three pixels below and the one that its on}
      SHR  BX,2     { Divide by 4 }
      JZ  @Skip
      DEC  BX       { Subtract 1 if value > 0 }
     @Skip:
      MOV  DS:[SI],BL  { Store pixel to screen }
      DEC  SI          { Move to next pixel }
      DEC  CX
      JNZ @Looper
    { Copy the screen Buffer using Double Word copies }
      MOV  BX,110
      SHL  BX,1
      MOV  AX,Word Ptr [LookUp + BX]
      MOV  DX,AX
      POP  SI        { Restore starting offset of VScreen  }
      MOV  AX,$A000
      MOV  ES,AX     { DS:SI = starting location in buffer }
      XOR  DI,DI     { ES:DI = Starting location in screen }
      ADD  SI,DX
      ADD  DI,DX
      POP  CX        { Retrive Count off the stack }
      SHR  CX,2      { divide by 4 to get # of double words.              }
     db 66h          { Since TP won't allow 386 instructions, fake it.    }
      REP  MOVSW     { This translates into REP MOVSD (move double words) }
    End;

{    repeat until (port[$3da] and $08) = 0;
    repeat until (port[$3da] and $08) > 0; }
    { i: wait for vertical retrace, add lines for slowdown }

  Until Port[$60] = 1;   { Until ESC is pressed }
End;

Begin
  mode_x_init;  { i: different graph-mode init }

  For LookUp[0] := 1 to 199 do            { Calculate lookup table }
    LookUp[LookUp[0]] := LookUp[0] * 80;  { i: 320 -> 80 again }
  LookUp[0] := 0;
  SetPalette;
  FillChar(VScreen, 16000, 0);            { i: one fourth }
  Burnin_Down_The_House;
  Asm
    MOV  AX,3
    INT  10h
  End;
End.
