Program Ert;

Uses
  Crt;

Type
  RGBcolors= array[0..47] of byte;

Var
  RGBoriginal,
  RGBnuller    : RGBcolors;
  N            : Integer;

{----------------------------------------------------------------------------}

Procedure GetDAC(Var RGBvalues); Assembler;

  Asm
    Mov Bl,0
    Les Di,RGBvalues

   @Loop:

    Push Bx
    Mov  Ax, 1007h
    Int  10h
    Mov  Bl, Bh
    Mov  Bh, 0
    Mov  Ax, 1015h
    Int  10h
    Mov  Es:[Di], Dh
    Mov  Es:[Di+1], Ch
    Mov  Es:[Di+2], Cl
    Add  Di, 3
    Pop  Bx
    Inc  Bl
    Cmp  Bl, 10h
    Jnz  @Loop
  End;    {GetDAC}

{----------------------------------------------------------------------------}

Procedure Fade(RGBvaluEs : RGBcolors; Speed : ShortInt);

  Var
    PaletteRegs   : Array[0..16] Of Byte;
    Original,
    TotalChange,
    NextValuEs    : RGBcolors;

  Begin   {Fade}
    Asm
      Mov  Bl, 0
      Mov  Di, 0
      Mov  Si, 0

     @LoopInit:

      Push Bx
      Mov  Ax, 1007h
      Int  10h
      Mov  Byte Ptr PaletteRegs[Si], Bh
      Inc  Si
      Mov  Bl, Bh
      Mov  Bh, 0
      Mov  Ax, 1015h
      Int  10h
      Mov  Byte Ptr Original[Di], Dh
      Mov  Al, Byte Ptr RGBvAluEs[Di]
      Sub  Al, Dh
      Mov  Byte Ptr TotalChange[Di], Al
      Mov  Byte Ptr Original[Di+1], Ch
      Mov  Al, Byte Ptr RGBvAluEs[Di+1]
      Sub  Al, Ch
      Mov  Byte Ptr TotalChange[Di+1], Al
      Mov  Byte Ptr Original[Di+2],Cl
      Mov  Al, Byte Ptr RGBvAluEs[Di+2]
      Sub  Al, Cl
      Mov  Byte Ptr TotalChange[Di+2], Al
      Add  Di, 3
      Pop  Bx
      Inc  Bl
      Cmp  Bl, 10h
      Jnz  @LoopInit
      Mov  Bl, Speed
      Mov  Bh, 0

     @LoopSpeed:

      Inc  Bh
      Mov  Di, 0
      Mov  Cx, 48

     @LoopUdregn:

      Mov  Al, Bh
      Imul Byte Ptr TotalChange[Di]
      Idiv Bl
      Add  Al, Byte Ptr Original[Di]
      Mov  Byte Ptr NextVAluEs[Di], Al
      Inc  Di
      loop @LoopUdregn
      Mov  Dx, 3dah

     @LoopWait1:

      In   Al, Dx
      Test Al,8
      Jnz  @LoopWait1

     @LoopWait2:

      In   Al, Dx
      Test Al, 8
      Jz   @LoopWait2
      Mov  Cx, 16
      Mov  Di, 0
      Mov  Si, 0

     @LoopOutput:

      Mov  Al, Byte Ptr PAletteRegs[Di]
      Inc  Di
      Mov  Dx, 3c8h
      Out  Dx, Al
      Inc  Dx
      Mov  Al, Byte Ptr NextVAluEs[Si]
      Out  Dx, Al
      Mov  Al, Byte Ptr NextVAluEs[Si+1]
      Out  Dx, Al
      Mov  Al, Byte Ptr NextVAluEs[Si+2]
      Out  Dx, Al
      Add  Si, 3
      Loop @LoopOutput
      Cmp  Bh, Bl
      Jnz  @LoopSpeed
    End;    {Asm}
  End;    {Fade}

{----------------------------------------------------------------------------}

Begin   {Main}
  GetDAC(RGBOriginal);
  For N := 0 To 47 Do
    RGBnuller[N] := 0;
    Repeat
      Fade( RGBnuller, 127 );
      For N := 0 To 1999 Do
        Begin   {For}
          Mem[$b800:N+N]   := Random(256);
          Mem[$b800:N+N+1] := Random(16);
        End;    {For}
      Fade( RGBOriginal , 127 );
    Until KeyPressed;
    ClrScr;
End.
