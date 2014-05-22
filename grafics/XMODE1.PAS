{ Illustration on how VGA Write Mode 1 works }
{ by Andrew Golovin (2:5080/10@Fidonet)      }
{ Can be used at your own risk freely w/o    }
{ any charge                                 }
{============================================}
{ PREFACE:                                   }
{ In VGA Write Mode 1 (VWM1) data stored in  }
{ Video Memory from Latch Register that can  }
{ be readed from VMem too. VWM1 can be used  }
{ in such application as Scrolling or        }
{ handling sprites placed in VMem            }
{ (on Unvisible Page).                       }
{ Some tricks with MaskBits can give you     }
{ many effects. I think that this code       }
{ can be used as basis for creating          }
{ 2ndReality alike plasma. ;)                }

var
  OldMode: Byte;
  X: Word;

procedure SetWriteMode(Wmode: Byte); assembler;
asm
  Mov     DX,3ceh
  Mov     AL,5
  Out     DX,AL
  Inc     DX
  In      AL,DX
  And     AL,11111100b
  Or      AL,WMode
  Out     DX,AL
end;

Procedure MaskPlanes(PlaneToMask: Byte); assembler;
asm
  Mov     DX,3c4h
  Mov     AL,2
  Out     DX,AL
  Inc     DX
  Mov     AL,PlaneToMask
  Out     DX,AL
End;

procedure Init320x200_X; assembler;
asm
  Mov AH,0fh; Int 10h; Mov [OldMode],al; Mov AX,13h; Int 10h;
  Mov DX,3c4h; Mov AL,04h; Out DX,AL; Inc DX; In AL,DX; And AL,011110111b;
  Or AL,000000100b; Out DX,AL; Dec DX; Mov AX,0f02h; Out DX,AX;
  Mov AX,0a000h; Mov ES,AX; XOr DI,DI; XOr AX,AX; Mov CX,8000h;
  ClD; RepNZ StoSW; Mov DX,3d4h; Mov AL,14h; Out DX,AL; Inc DX;
  In AL,DX; And AL,010111111b; Out DX,AL; Dec DX; Mov AL,017h;
  Out DX,AL; Inc DX; In AL,DX; Or AL,01000000b; Out DX,AL; Mov DX,3d4h;
  Mov AX,80; ShR AX,1; Mov AH,AL; Mov AL,13h; Out DX,AX; Ret
end;

procedure ScrollLineByLine; assembler;
  asm
    Push    DS
    Mov     CX,200       { 200 lines on screen              }
  @1:
    Push    CX

    Mov     AX,0a000h    { all works is in Video Segment    }
    Mov     DS,AX
    Mov     ES,AX

    Mov     SI,80        { Source for scrolling is 2nd line }
    XOr     DI,DI        { Destination - 1st line           }
    Mov     CX,16000     { Copy all screen                  }
    Rep     MovSB        { byte by byte                     }

    { You can try to implement another method of scrolling
      For example - word by word

     Mov    CX,8000
     Rep    MovSW

      Or by DWords (if you have 386 CPU)

     Mov    CX,4000
     db     66h
     Rep    MovSW

      This methods is much faster.
      But i can't explain some video effects appearing on screen
      May be you can explain it. I think this is my bug somewhere }

    Pop     CX
    Loop    @1

    Pop     DS
  end;

begin
 { Only init 320x200x256 X-signed mode. Don't pay much attention }
 Init320x200_x;
 { Following lines uses VGA Write Mode 0 (as default) }
 { Don't pay much attention on this code. It's only draws }
 { some kind of picture on screen }
 for X:=0 to 15999 do
   Mem[$A000:X]:=(X mod 16)+32+(X div 320);
 { Set VWM1 }
 SetWriteMode(1);
 { You can play a bit with parameters for MaskPalnes }
 { Mask planes as 1010b. Only 4 lo-bits makes sence }
 { This mask enable only even pixels scrolling }
 MaskPlanes(10);
 { Scroll even pixels }
 ScrollLineByLine;
 { Mask planes as 0101b. Only 4 lo-bits makes sence }
 { This mask enable only odd pixels scrolling }
 MaskPlanes(5);
 { Scroll odd pixels }
 ScrollLineByLine;
 { Restore old CRTC mode }
 asm Mov al,OldMode; XOr ah,ah; Int 10h end;
end.

Andrew

-!- GaldED 2.42-
 ! Origin:  The BEST! BBS Ekaterinburg\Russia +7-343-257-9848  (2:5080/10)


