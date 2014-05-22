Program PaletteTricks;

  Uses Crt;


  Const CGA_CharSet_Seg = $0F000;
        CGA_CharSet_Ofs = $0FA6E;
        CharLength      = 8;
        NumChars        = 256;
        VGA_Segment     = $0A000;
        NumCycles       = 200;
        Radius          = 80;

        DispStr         : String =
'...LOADER BY FRED NIETZCHE     CALL CENTERPOINT! (301) 309-0144, 9600+ ONLY  NUP: TERMINEX'+
'           WHATEVER ELSE YOU WANT HERE...                         ';

        Colors : Array[1..15*3] Of Byte =
                 (  7,  7, 63,
                   15, 15, 63,
                   23, 23, 63,
                   31, 31, 63,
                   39, 39, 63,
                   47, 47, 63,
                   55, 55, 63,
                   63, 63, 63,
                   55, 55, 63,
                   47, 47, 63,
                   39, 39, 63,
                   31, 31, 63,
                   23, 23, 63,
                   15, 15, 63,
                    7,  7, 63  );


Type  OneChar =Array[1..CharLength] Of Byte;


Var   CharSet : Array[1..NumChars] Of OneChar;
      Locs    : Array[1..NumCycles] Of Integer;
      BarLocs : Array[1..4] Of Integer;


  Procedure GetChars;

    Var NumCounter,
        ByteCounter,
        MemCounter   :Integer;
  
    Begin { GetChars }
      MemCounter:=0;
      For NumCounter:=1 To NumChars Do
        For ByteCounter:=1 To CharLength Do
          Begin
            CharSet[NumCounter][ByteCounter]:=Mem[CGA_CharSet_Seg:CGA_CharSet_Ofs+MemCounter];
            Inc(MemCounter);
          End;
    End;  { GetChars }


  Procedure VideoMode ( Mode : Byte );

    Begin { VideoMode }
      Asm
        Mov  AH,00
        Mov  AL,Mode
        Int  10h
      End;
    End;  { VideoMode }


  Procedure SetColor ( Color, Red, Green, Blue : Byte );

    Begin { SetColor }
      Port[$3C8] := Color;
      Port[$3C9] := Red;
      Port[$3C9] := Green;
      Port[$3C9] := Blue;
    End;  { SetColor }


  Procedure DispVert ( Var CurrLine : Integer );

    Var Letter : OneChar;
        VertLine,
        Count  : Integer;

    Begin { DispVert }
      Letter := CharSet[Ord(DispStr[(CurrLine Div 8)+1])+1];
      VertLine := (CurrLine-1) Mod 8;
      For Count := 1 To 8 Do
        If Letter[Count] And ($80 Shr VertLine) = 0
          Then Mem[VGA_Segment:185*320+(Count-1)*320+319] := 0
          Else Mem[VGa_Segment:185*320+(Count-1)*320+319] := 181;
    End;  { DispVert }


  Procedure CalcLocs;

    Var Count : Integer;

    Begin { CalcLocs }
      For Count := 1 To NumCycles Do
        Locs[Count] := Round(Radius*Sin((2*Pi/NumCycles)*Count))+Radius+1;
    End;  { CalcLocs }


    Procedure DoCycle;

      Label Wait,Retr,BarLoop,PrevIsLast,Continue1,Continue2,Rep1,Rep2;

      Begin { DoCycle }
        Asm

          MOV   DX,3DAh
Wait:     IN    AL,DX
          TEST  AL,08h
          JZ    Wait
Retr:     IN    AL,DX
          TEST  AL,08h
          JNZ   Retr

{ Do Bars... }

           MOV   BX,0
BarLoop:
           PUSH  BX
           MOV   AX,Word Ptr BarLocs[BX]
           MOV   BX,AX
           DEC   BX
           SHL   BX,1
           MOV   AX,Word Ptr Locs[BX]
           PUSH  AX
           CMP   BX,0
           JE    PrevIsLast
           DEC   BX
           DEC   BX
           MOV   AX,Word Ptr Locs[BX]
           JMP   Continue1

PrevIsLast:
           MOV   AX,Word Ptr Locs[(NumCycles-1)*2]

Continue1:
           MOV   DX,03C8h
           OUT   DX,AL
           INC   DX
           MOV   CX,15*3
           MOV   AL,0
Rep1:
           OUT   DX,AL
           LOOP  Rep1

           DEC   DX
           POP   AX
           OUT   DX,AL
           INC   DX
           MOV   CX,15*3
           XOR   BX,BX
Rep2:
           MOV   AL,Byte Ptr Colors[BX]
           OUT   DX,AL
           INC   BX
           LOOP  Rep2

           POP   BX
           INC   Word Ptr BarLocs[BX]
           CMP   Word Ptr BarLocs[BX],NumCycles
           JNG   Continue2

           Mov   Word Ptr BarLocs[BX],1
Continue2:
           INC   BX
           INC   BX
           CMP   BX,8
           JNE   BarLoop

        End;
      End;  { DoCycle }


  Var CurrVert,
      Count     : Integer;
      Key       : Char;
      MemPos    : Word;

  Begin { PaletteTricks }

    VideoMode($13);
    Port[$3C8] := 1;
    For Count := 1 To 180 Do
      SetColor(Count,0,0,0);
    MemPos := 0;
    For Count := 1 To 180 Do
      Begin
        FillChar(Mem[VGA_Segment:MemPos],320,Chr(Count));
        MemPos := MemPos + 320;
      End;
    SetColor(181,63,63,0);
    CalcLocs;
    For Count := 1 To 4 Do
      BarLocs[Count] := Count*10;

    GetChars;
    CurrVert := 1;
    Repeat
      DoCycle;
      For Count := 1 To 8 Do
        Move(Mem[VGA_Segment:185*320+(Count-1)*320+1],
             Mem[VGA_Segment:185*320+(Count-1)*320],319);
      DispVert(CurrVert);
      Inc(CurrVert);
      If CurrVert > Length(DispStr) * 8
        Then CurrVert := 1;

    Until Keypressed;
    Key := ReadKey;
    VideoMode(3);
  End.  { PaletteTricks }
