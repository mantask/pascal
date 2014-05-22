{ Turbo Pascal Version 7.0 Directive Settings }
{$A+,B-,D+,E+,F-,G+,I+,L+,N-,O-,P-,Q-,R-,S+,T-,V+,X+}

Program Wormhole;

Uses
  Crt;

Const
  Vidseg:Word = $A000;
  Divd        = 128;
  Astep       = 6;
  Xst         = 4;
  Yst         = 5;

Var
  Sintab      : Array[0..449] Of Integer;
  Stab,
  Ctab        : Array[0..255] Of Integer;
  Virscr      : Pointer;
  Virseg      : Word;
  Lstep       : Byte;

{$Define Cpu386}

{----------------------------------------------------------------------------}

Procedure Setpal( Col,R,G,B : Byte ); Assembler;

Asm
  Mov Dx,03C8H
  Mov Al,Col
  Out Dx,Al
  Inc Dx
  Mov Al,R
  Out Dx,Al
  Mov Al,G
  Out Dx,Al
  Mov Al,B
  Out Dx,Al
End;

{----------------------------------------------------------------------------}

Procedure Drawpolar( Xo,Yo,R,A : Word; C : Byte; Lvseg : Word ); Assembler;

Asm
  Mov Es,Lvseg
  Mov Bx,A
  Add Bx,A
  Mov Cx,Word Ptr Sintab[Bx]
  Add Bx,2*90
  Mov Ax,Word Ptr Sintab[Bx]
  Mul R
  Mov Bx,Divd
  Xor Dx,Dx
  Cwd
  Idiv Bx
  Add Ax,Xo
  Add Ax,160
  Cmp Ax,320
  Ja @Out
  Mov Si,Ax

  Mov Ax,Cx
  Mul R
  Mov Bx,Divd
  Xor Dx,Dx
  Cwd
  Idiv Bx
  Add Ax,Yo
  Add Ax,100
  Cmp Ax,200
  Ja @Out

  Shl Ax,6
  Mov Di,Ax
  Shl Ax,2
  Add Di,Ax
  Add Di,Si
  Mov Al,C
  Mov [Es:Di],Al
  @Out:
End;

{----------------------------------------------------------------------------}

Procedure Cls(Lvseg:Word); Assembler;

Asm
  Mov Es,[Lvseg]
  Xor Di,Di
  Xor Ax,Ax

{$IFDEF Cpu386}

  Mov Cx,320*200/4
  Rep
  Db $66; Stosw

{$ELSE}

  Mov Cx,320*200/2
  Rep Stosw

{$ENDIF}

End;

{----------------------------------------------------------------------------}

Procedure Flip(Src,Dst:Word); Assembler;

Asm
  Push Ds
  Mov Ax,[Dst]
  Mov Es,Ax
  Mov Ax,[Src]
  Mov Ds,Ax
  Xor Si,Si
  Xor Di,Di

{$IFDEF Cpu386}

  Mov Cx,320*200/4
  Rep
  Db $66; Movsw

{$ELSE}

  Mov Cx,320*200/2
  Rep Movsw

{$ENDIF}

  Pop Ds
End;

{----------------------------------------------------------------------------}

Procedure Retrace; Assembler;

Asm
  Mov Dx,03Dah
 @Vert1:
  In Al,Dx
  Test Al,8
  Jnz @Vert1
 @Vert2:
  In Al,Dx
  Test Al,8
  Jz @Vert2
End;

{----------------------------------------------------------------------------}

Var
  C       : Byte;
  X,Y,I,J : Word;

Begin
  Asm
    Mov Ax,13H;
    Int 10H;
  End;

  For I := 0 To 255 Do
    Begin
      Ctab[I] := Round(Cos(Pi*I/128)*60);
      Stab[I] := Round(Sin(Pi*I/128)*45);
    End;

  For I := 0 To 449 Do
    Sintab[I] := Round(Sin(2*Pi*I/360)*Divd);

  Getmem(Virscr,64000);
  Virseg := Seg(Virscr^);
  Cls(Virseg);
  X := 30;
  Y := 90;

  Repeat
    {Retrace;}
    C     := 22;
    Lstep := 2;
    J     := 10;
    While J < 220 Do
      Begin
        I := 0;
        While I < 360 Do
          Begin
            Drawpolar(Ctab[(X+(200-j)) Mod 255],Stab[(Y+(200-j)) Mod
                255],J,I,C,Virseg);
            Inc(I,Astep);
          End;
        Inc(J,Lstep);
        If (J Mod 5) = 0 Then
          Begin
            Inc(Lstep);
            Inc(C);
            If C > 31 Then
              C := 22;
          End;
      End;
    X := Xst + X Mod 255;
    Y := Yst + Y Mod 255;
    Flip(Virseg,Vidseg);
    Cls(Virseg);
  Until Keypressed;

  While Keypressed Do
    Readkey;
  Freemem(Virscr,64000);
  Textmode(Lastmode);
End.
