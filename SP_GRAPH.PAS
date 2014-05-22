{$A+,B-,D-,E+,F-,G+,I-,L-,N+,O-,P-,Q-,R-,S-,T-,V+,X+}
Unit SP_GRAPH;
{$IFDEF I0I}
                           ÉÍ» ÉÍ» ÉÍ» ÉÍ» Ë Ë
                           ºÉ» ÌË¼ ÌÍ¹ ÌÍ¼ ÌÍ¹
                           ÈÍ¼ ÊÈ¼ Ê Ê Ê   Ê Ê
                                                                               asm
                           Biblioteka, Grafika.
                     1999 11 01 (c) Saulius Petrauskas
                          E-mail: Sauliuz@xxx.lt
                               versija 1.2
                                                                               end
{$ENDIF}

                                INTERFACE

Const sig = ' (c) 2000 Saulius Petrauskas';

  Detect         = $000;
  Currentmode    = $000;

  v320x200x256   = $013;
  v320x200x32K   = $10D;
  v320x200x64K   = $10E;

  v640x400x256   = $100;

  v640x480x256   = $101;
  v640x480x32K   = $110;
  v640x480x64K   = $111;

  v800x600x256   = $103;
  v800x600x32K   = $113;
  v800x600x64K   = $114;

  v1024x768x256  = $105;
  v1024x768x32K  = $116;
  v1024x768x64K  = $117;

  v1280x1024x256 = $107;
  v1280x1024x32K = $119;
  v1280x1024x64K = $11A;

  { Line styles for SetLineStyle: }
  SolidLn      = $FFFF;
  DashedLn     = $C3C3;
  DottedLn     = $9999;
  Closedottedln= $AAAA;
  Ropeln       = $FCCF;
  Borderln     = $FAAF;

  SolidFill           =57;
  Currentcolor: Word  =15;

  { BitBlt operators for PutImage: }
  NormalPut     = $88;    { MOV }
  CopyPut       = $88;    { MOV }
  XORPut        = $30;    { XOR }
  OrPut         = $08;    { OR  }
  AndPut        = $20;    { AND }

Type
  VesaModeInfo=
  record
    Modeattributes        : Word;         { Mode Attributes                   }
    WinAAttributes        : Byte;         { Window A attributes               }
    WinBAttributes        : Byte;         { Window B attributes               }
    Granularity           : Word;         { Window granularity in K bytes     }
    WindowSize            : Word;         { Size of window in K bytes         }
    WinASegment           : Word;         { Segment address of window A       }
    WinBSegment           : Word;         { Segment address of window B       }
    WinFuncPtr            : Pointer;      { Windows positioning function      }
    BytesPerScanLine      : Word;         { Number of bytes per scan line     }
    screenwidth           : Word;         { Number of horizontal pixels       }
    ScreenHeight          : Word;         { Number of vertical pixels         }
    CharWidth             : Byte;         { Width of character cell           }
    CharHeight            : Byte;         { Height of character cell          }
    Planes                : Byte;         { Number of memory planes           }
    BitsWordPerPixel      : Byte;         { Number of BitsWord per pixel      }
    NumOfBanks            : Byte;         { Number of banks        (not used) }
    Model                 : Byte;         { Memory model type                 }
    BankSize              : Byte;         { Size of bank           (not used) }
    Pages                 : Byte;         { Number of image pages             }
    Reserved              : Byte;         { The following are for 15,16,24,32 bit colour modes }
    RedMaskSize           : Byte;         { Size of Red mask in BitsWord      }
    Redfieldpos           : Byte;         { Bit position of LSB of Red mask   }
    GreenMaskSize         : Byte;         { Size of Green mask in BitsWord    }
    GreenFieldPosition    : Byte;         { Bit position of LSB of Green mask }
    BlueMaskSize          : Byte;         { Size of Blue mask in BitsWord     }
    BlueFieldPosition     : Byte;         { Bit position of LSB of Blue mask  }
    ReservedMaskSize      : Byte;         { Size of Reserved mask in BitsWord }
    Reservedfieldposition : Byte;         { Bit pos. of LSB of Reserved mask  }
    Directcolormodeinfo   : Byte;
    Filler                : Array[0..215] Of Byte;
  End;

  PointType=record x, y : integer end;

  RGBType=record R,G,B: Byte end;

  PalType=array[0..255] of RGBType;

  ViewPortType=record X1, Y1, X2, Y2 :Integer end;

  FillPatternType=array[0..7] Of Byte;

  FillSettingsType=
  record
    Pattern  : FillPatternType;
    Color    : Word;
    Backcolor: Word
  end;

{  TextSettingsType =
  record
    Font      : longint;{0
    XCharSize : Word;   {4
    YCharSize : Word;   {6
    SubY      : Word;   {8
    Direction : byte;   {10
    Horiz     : Byte;   {11
    Vert      : Byte;   {12
    Size      : byte;   {13
    Separator : shortint;{14
  end;}

  MouseShapeType =
  record
    Hotspot: pointtype;
    Shape: Array[0..1,0..15] Of Word;
  end;

Procedure GetModeInfo(Mode:Word;Var Info:VesaModeInfo); { parao grafinio re‘imo informacij… (apie video kort…) }
Function  GetActiveGraphMode:Word;           { iveda aktyv— grafin re‘im… }
Function  GetGraphMode:Word;                 { iveda grafin re‘im…        }
Function  SetGraphMode(Mode:Word):Boolean;   { nustato grafin re‘im…       }
Function  InitGraph(Mode:Word):Boolean;  { Pagrindinis graf. re‘. jungimas }
Function  SilentInitGraph(Mode:Word):Boolean;{ Naudojama tada jei grafinis
re‘imas jau jungtas ir reikia valdym… perimt i kitos programos,
nesugadinat jos darbo }
Procedure CloseGraph;                             { Ijungia grafin re‘im… }

Procedure WaitRetrace; { Palaukti kol praeis vertikalus ekrano refreshas. Naudojama mirg‚jimui suma‘inti }
Procedure SetPal(Color, RedValue, GreenValue, BlueValue:Word); { nustato palet‚s spalv… }
Procedure GetPal(Color: Word; Var R, G, B: byte);  { gauna palet‚s spalv…   }
Procedure SetAllPal(Var Palette:PalType);          { nustato vis… paletŠ    }
Procedure Getallpal(Var Palette:PalType);          { gauna vis… paletŠ      }
Procedure SetColor(Color:Word);                    { nustato darbinŠ spalv… }
Procedure SetBkColor(Color:Byte);                  { nustato fono spalv…    }
Function  GetColor:Word;                           { gauna spalv…           }
Function  GetBkColor: Byte;                        { gauna fono spalv…      }
Function  GetMaxColor:Word;                        { gauna spalv— kiek     }
Function  RGBcolor(Red,Green,Blue: Word): Word; { naud. kai spalv— >256 (pvz 16 mln) }

Procedure ClearDevice;                          { Ivalo vis… ekran…        }
Procedure ClearViewPort;                        { Ivalo tik darbinŠ dal   }
Procedure SetViewPort(X1, Y1, X2, Y2: Integer); { nustato darbinŠ ekrano dal }
Procedure GetViewSettings(Var Viewport: ViewPortType); { gauna ekrano darbin‚s dalies parametrus }
Procedure SetActivePage(Page: word);  { nustato aktyv— grafikos pl. puslap }
Procedure SetVisualPage(Page: word);  { nustato matom… puslap              }
Procedure Scroll(X,Y:Integer);        { stumdo ekran…                       }
Function  GetX:Integer;               { gauna dabartin x koord.            }
Function  GetY:Integer;               { gauna dabartin y koord.            }

Procedure PutPixel(X,Y:Integer;Color:Word);            { pieia tak…       }
Function  GetPixel(X,Y:Integer):Word;                  { gauna tako spalv… }

Function  Getlinestyle:Word;                      { gauna linij— tip…       }
Procedure SetLineStyle(LineStyle: Word);          { nustato linij— tip…     }
Procedure MoveTo(X, Y : Integer);                 { perkelia kursori—       }
Procedure MoveRel(DX, Dy : Integer);              { pieia linerel          }
Procedure Line(X1,Y1,X2,Y2:Integer);              { linija                  }
Procedure LineTo(X,Y:Integer);                    { linija (tik galo koord) }
Procedure LineRel(X,Y:Integer);                   { tas pats                }
Procedure Rectangle(X1,Y1,X2,Y2 : Integer);       { sta‡iakampis            }

Procedure SetFillPattern(Var Pattern:FillPatternType;Color,Backcolor:Word); { nustato pildym… }
Procedure SetFillStyle(Pattern,Color,Backcolor:Word);     { nustato pildym… }
Procedure GetFillSettings(Var Fillinfo:FillSettingsType); { iveda pildymo nustatymus }
Procedure Bar(X1,Y1,X2,Y2:Integer);          { pieia u‘pildyt… sta‡iakamp }
Procedure Bar3D(X1,Y1,X2,Y2:Integer;Depth:Word;Top:Boolean);  { pieia kub… }
Procedure Fillcircle(X,Y:Integer;Radius:Word);     { u‘pildytas apskritimas }
Procedure FillEllipse(X,Y:Integer;Xradius,Yradius:Word); { u‘pildyta elips‚ }
Procedure DrawPoly(Numpoints:Word;Var Polypoints);           { daugiakampis }

Procedure Circle(X,Y:Integer;Radius:Word);                    { apskritimas }
Procedure Ellipse(X,Y:Integer;Xradius,Yradius : Word);        { elips‚      }

Function  ImageSize(X1, Y1, X2, Y2: Integer): LongInt; { nurodyto ploto dydis }
Procedure SetWriteMode(Mode:Byte);              { nustato klijavimo re‘im… }
Function  GetWriteMode: Byte;                   { gauna klijavimo re‘im…   }
Procedure GetImage(X1,Y1,X2,Y2:Integer;Var Bitmap); { ikerpa paveiksl‚l   }
Procedure PutImage (X,Y:Integer;Var Bitmap);        { klijuoja paveiksl‚l }

{ Procedure SetMouseCursor(X,Y:Word);
Procedure SetMouseStyle(shape:byte);
Procedure SetMousePattern(Shape : MouseShapeType);
Procedure DrawMouse(X,Y:Integer);
Procedure SetMouseWindow(X1,Y1,X2,Y2:word);}

type
 ptype=^ftype;
 ftype=array[1..4096] of byte;

var
  MouseShape  :MouseShapeType;
  getmaxy     :Word;
  getmaxx     :Word;
  BytesPerLine:Word;
  Vp          :ViewPortType;
  Hicolor     :Boolean;


const
  CurShape    :Byte=$FF;

                              IMPLEMENTATION

Var
  Grmode      :Word;
  Addx        :Word;
  Cpx,Cpy     :Word;
  Sdx,Scx     :Word;
  Actstart    :Word;
  Currentfill :FillSettingsType;
  maxcolor    :Byte;
  Backcolor   :Byte;
  Patterns    :Array[0..67] Of FillPatternType;
{ Mouses      :Array[0..15] of MouseShapeType;}

Const
  Linepattern :Word=SolidLn;
  Currentbank :Byte=$FF;

{$L 286} { Naudojamas 16-bit asembleris }
Procedure SetColor(Color:Word);External;
Function GetColor:Word;External;
Function GetMaxColor:Word;External;
Procedure SetAllPal(Var Palette:PalType);External;
Procedure GetAllPal(Var Palette:PalType);External;
Procedure SetPal(Color, RedValue, GreenValue, BlueValue:Word);External;
Function GetX:Integer;External;
Function GetY:Integer;External;
Procedure MoveTo(X,Y:Integer);External;
Procedure MoveRel(DX,Dy:Integer);External;
Procedure SetViewPort(X1, Y1, X2, Y2: Integer);External;

Procedure SetLineStyle(LineStyle:Word);External;
Function Getlinestyle:Word;External;
Procedure LineTo(X,Y:Integer);External;
Procedure LineRel(X,Y:Integer);External;
Function GetPixel(X,Y:Integer):Word;External;

Procedure GetModeInfo(Mode:Word;Var Info:VesaModeInfo);External;
Function GetActiveGraphMode:Word;External;
Function GetGraphMode:Word;External;
Function SetGraphMode(Mode:Word):Boolean;External;

Procedure Plotcolor;Near;external;
Procedure SetWriteMode(Mode:Byte);external;
Function GetWriteMode:Byte;external;
Function GetBkColor:Byte;external;

{$L 386} { Naudojamas 32-bit asembleris }
procedure cleardevice;external;
Procedure Circle(X,Y:Integer;Radius:Word);External;
Procedure GetImage(X1,Y1,X2,Y2:Integer;Var Bitmap);External;
Procedure PutImage(X,Y:Integer;Var Bitmap);External;
Procedure PutPixel(X,Y:Integer;Color:Word);External;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Function InitGraph(Mode:Word):Boolean;Assembler;
Var
  Info:VesaModeInfo;

Asm
  Push Mode
  Call SetGraphMode
  or al,al
  Je @Error
  Cmp Mode,v320x200x256
  Jne @Vesamode
  Mov BytesPerLine,320
  Mov getmaxx,319
  Mov getmaxy,199
  inc addx
  Jmp @Done
  @Vesamode:
  Cmp Mode,0
  Jne @Init
  Call GetActiveGraphMode
  Mov Mode,AX
  @Init:
  Push Mode
  Lea SI,Info
  Push Ss
  Push SI
  Call GetModeInfo
  mov al,info.bitswordperpixel
  mov maxcolor,al
  Mov AX,Info.screenheight
  Mov getmaxy,AX
  Dec getmaxy
  Mov AX,Info.screenwidth
  Mov getmaxx,AX
  Dec getmaxx
  Mov AX,Info.BytesPerScanLine
  Mov BytesPerLine,AX
  Mov AX,Info.WinASegment
  Mov SegA000,AX

  xor cx,cx
  mov bh,ch
  inc cl
  mov bl,info.bitswordperpixel
  sub bl,8
  jz @error
  inc bh
  inc cl
  @Error:
  mov addx,cx
  mov hicolor,bh
  mov ax,true
  @Done:
  Push 15
  Push 0
  Call SetFillStyle

  Push 0
  Push 0
  Push getmaxx
  Push getmaxy
  Call SetViewPort

  push normalput
  call setwritemode
  push 0
  push 7680
  push 0
  push 0
End;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure CloseGraph;Assembler;
Asm
  Mov AX,3H
  Int 10H
End;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Function SilentInitGraph(Mode:Word):Boolean;Assembler;
Var
  Info:VesaModeInfo;

Asm
  or al,al
  Je @Error
  Cmp Mode,v320x200x256
  Jne @Vesamode
  Mov BytesPerLine,320
  Mov getmaxx,319
  Mov getmaxy,199
  inc addx
  Jmp @Done
  @Vesamode:
  Cmp Mode,0
  Jne @Init
  Call GetActiveGraphMode
  Mov Mode,AX
  @Init:
  Push Mode
  Lea SI,Info
  Push Ss
  Push SI
  Call GetModeInfo
  mov al,info.bitswordperpixel
  mov maxcolor,al
  Mov AX,Info.screenheight
  Mov getmaxy,AX
  Dec getmaxy
  Mov AX,Info.screenwidth
  Mov getmaxx,AX
  Dec getmaxx
  Mov AX,Info.BytesPerScanLine
  Mov BytesPerLine,AX
  Mov AX,Info.WinASegment
  Mov SegA000,AX

  xor cx,cx
  mov bh,ch
  inc cl
  mov bl,info.bitswordperpixel
  sub bl,8
  jz @error
  inc bh
  inc cl
  @Error:
  mov addx,cx
  mov hicolor,bh
  mov ax,true
  @Done:
  Push 15
  Push 0
  Call SetFillStyle

  Push 0
  Push 0
  Push getmaxx
  Push getmaxy
  Call SetViewPort

  push normalput
  call setwritemode
  push 0
  push 7680
  push 0
  push 0
End;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure WaitRetrace; Assembler;
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

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure Setbank;Near;Assembler;
Asm
  Cmp DL,Currentbank
  Je @@Nochange
  Mov Currentbank,DL
  Push AX
  Push BX
  Mov AX,4F05H
  XOr BX,BX     {write bank - MOV}
  Int 10H

  Mov AX,4F05H
  Mov BX,0001H  {read bank - AND, OR , XOR}
  Int 10H
  @Noread:
  Pop BX
  Pop AX
  @@Nochange:
End;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure Vsetoffset;Near;assembler;
asm
  Add  AX,Actstart
  Mov CL,Hicolor
  ShL BX,CL
  Mul  BytesPerLine
  Add  AX,BX
  adc dx,0
  Call Setbank
end;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure Rectangle(X1,Y1,X2,Y2 : Integer);Assembler;
Asm
  Push X1
  Push Y1
  Push X2
  Push Y1
  Call Line
  Push X1
  Push Y2
  Push X2
  Push Y2
  Call Line
  Inc Y1
  dec y2
  Push X1
  Push Y1
  Push X1
  Push Y2
  Call Line
  Push X2
  Push Y1
  Push X2
  Push Y2
  Call Line
End;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure Line(X1,Y1,X2,Y2:Integer);Assembler;
Const
  Left  = $07;
  Right = $0B;
  Upper = $0D;
  Lower = $0E;

Var
  I,D,Dtx,Dty,Windowy2,Incx2,Incx,Incy,E:Integer;
  Interchange:Byte;
  Pattern:Word;

Asm
  Mov BX,Vp.X1
  Add X1,BX
  Add X2,BX
  Mov SI,Vp.X2
  Mov DI,Vp.Y1
  Add Y1,DI
  Add Y2,DI
  Mov AX,Vp.Y2
  @Start:
  Mov Windowy2,AX
  {BX|SI|DI|WindowY2 = vp.x1|vp.x2|vp.y1|vp.y2}

  Mov CL,0Fh        {start with %1111  }
  Cmp X2,BX         {x2 < WindowX1 ?}
  Jl @v1point2     {yes, don't change flag for "point is left of window"}
  And CL,Left       {no, reset flag       }
  @v1point2:
  Cmp X2,SI         {x2 > WindowX2 ?}
  Jg @v2point2     {yes, don't change flag for "point is right of window"}
  And CL,Right      {no, reset flag       }
  @v2point2:
  Mov AX,Y2
  Cmp AX,DI         {y2 < WindowY1 ?}
  Jl @v3point2     {yes, don't change flag for "point is above window"}
  And CL,Upper      {no, reset flag       }
  @v3point2:
  Cmp AX,Windowy2   {y2 > WindowY2 ?}
  Jg @point1        {yes, don't change flag for "point is below window"}
  And CL,Lower
  @point1:
  Mov CH,0Fh        {start with %1111  }
  Cmp X1,BX         {x1 < WindowX1 ?}
  Jl @v1point1     {yes, don't change flag for "point is left of window"}
  And CH,Left  {no, reset flag      }
  @v1point1:
  Cmp X1,SI         {x1 > WindowX2 ?}
  Jg @v2point1     {yes, don't change flag for "point is right of window"}
  And CH,Right      {no, reset flag       }
  @v2point1:
  Mov AX,Y1
  Cmp AX,DI         {y1 < WindowY1 ?}
  Jl @v3point1      {yes, don't change flag for "point is above window"}
  And CH,Upper      {no, reset flag       }
  @v3point1:
  Cmp AX,Windowy2   {y1 > WindowY2 ?}
  Jg @v4point1      {yes, don't change flag for "point is below window"}
  And CH,Lower
  @v4point1:        {CH holds the area code for point 1          }
                    {CL holds the area code for point 2, CH the one for point 1}
  Mov AX,CX
  And AL,AH         {Code1 AND Code2 <> 0 ?}
  Jnz @Done         {yes, line is completely outside the window}
  Mov AX,CX
  Or AL,AH          {Code1 OR Code2 = 0 ?}
  Jz @Drawline      {yes, line is completely inside the window}
                    {Now do the clipping itself: }
  Mov AX,CX
  Or AH,AH          {Code1 =0 ?}
  Jnz @Cl3          {no, everything ok lah yauow !}
  Mov AX,X1         {yes, swap points!}
  Xchg AX,X2
  Mov X1,AX
  Mov AX,Y1
  Xchg AX,Y2
  Mov Y1,AX
  Xchg CL,CH
  @Cl3:
  Mov AX,X2
  Sub AX,X1
  Mov Dtx,AX                {dtx := x2 - x1}
  Mov AX,Y2
  Sub AX,Y1
  Mov Dty,AX                {dty := y2 - y1}
  Mov AL,CH                 {AL := Code1}
  Test AL,Not Left          {point1 left of window?   }
  Jz @Cl4                   {no  }
                            {yes, compute new coordinates:}
                            { y1 := y1 + (y2 - y1) / (x2 - x1) * (WindowX1 - X1) }
                            { and x1 := WindowX1}
  Mov AX,BX
  Sub AX,X1                 {AX := WindowX1-x1}
  Imul Dty
  Idiv Dtx
  Add Y1,AX
  Mov X1,BX
  Jmp @point1
  @Cl4:
  Test AL,Not Right         {point1 right of window?   }
  Jz @Cl5                   {no  }
  {yes, compute:}
  { y1 := y1 + (y2 - y1) / (x2 - x1) * (WindowX2 - X1), x1 := WindowX2}
  Mov AX,SI                 {SI = WindowX2}
  Sub AX,X1
  Imul Dty
  Idiv Dtx
  Add Y1,AX
  Mov X1,SI
  Jmp @point1

  @Cl5:
  Test AL,Not Upper         {point1 above window?        }
  Jz @Cl6                   {no  }
                            {yes, compute:}
                            { x1 := x1 + (x2 - x1) / (y2 - y1) * (WindowY1 - y1), y1 := WindowY1 }
  Mov AX,DI                 {DI = WindowY1}
  Sub AX,Y1
  Imul Dtx
  Idiv Dty
  Add X1,AX
  Mov Y1,DI
  Jmp @point1

  @Cl6:
  Test AL,Not Lower         {point below window?         }
  Jz @point1                {no  }
  {yes, compute:}
  { x1 := x1 + (x2 - x1) / (y2 - y1) * (WindowY2 - y1), y1 := WindowY2 }
  Mov AX,Windowy2
  Push AX
  Sub AX,Y1
  Imul Dtx
  Idiv Dty
  Add X1,AX
  Pop AX
  Mov Y1,AX
  Jmp @point1

  @Yincr:
  Cmp Incy,0
  Jl @Negy2
  Add DI,BytesPerLine            {y:=y+incy}
  Jmp @Skip73
  @Negy2:
  Sub DI,BytesPerLine            {y:=y-incy}
  @Skip73:
  Jnc @Nobanky
  Add DX,Incy
  Call Setbank
  @Nobanky:
  Retn

  @Drawline:
  mov ax,linepattern
  mov pattern,ax
  Mov AX,Y1
  Mov BX,X1
  Call Vsetoffset
  Mov DI,AX
  Mov SI,X2                     {SI=_DX}
  Sub SI,X1
  Mov Incx,1
  Mov AX,Addx
  Mov Incx2,AX
  Jns @Bx_To_Dy
  Neg Incx
  Neg Incx2
  Neg SI
  @Bx_To_Dy:
  Mov bX,Y2                     {AX=_DY}
  Sub bX,Y1
  Mov Incy,1
  Jns @Skip2
  Neg Incy
  Neg bX
  @Skip2:
  Mov Interchange,FALSE
  Cmp bX,SI                     {_DY compare _DX [SI] }
  Jl @Dy_Lower_Than_Dx
  Inc Interchange
  Xchg bX,SI
  @Dy_Lower_Than_Dx:
  Mov CX,SI                     {loop i:=_DX;  ;initialization}
  inc cx
  ShL SI,1                      {_DX * 2}
  ShL bX,1                      {_DY * 2}
  Mov E,bX
  Sub E,SI
  Mov ES,SegA000
  Mov AX,Currentcolor
  @Mainloop:                    {main loop}
  ror pattern,1
  Jnc @Noplot
  call plotcolor

  @Noplot:
  Cmp E,0
  Jnge @Skipe                   {while e >= 0}
  Cmp Interchange,FALSE
  Je @Itfalse1
  Add DI,Incx2                   {x:=x+incx}
  Jnz @Nobank1                  {DI=bankend ?}
  Add DX,Incx
  Call Setbank
  Jmp @Nobank1
  @Itfalse1:
  Call @Yincr
  @Nobank1:
  Sub E,SI
  @Skipe:
  Cmp Interchange,FALSE
  Je @Itfalse2
  Call @Yincr
  Jmp @Ittrue2
  @Itfalse2:
  Add DI,Incx2                    {x:=x+incx}
  Jnz @Ittrue2                   {DI=bankend ?}
  Add DX,Incx
  Call Setbank
  @Ittrue2:
  Add E,bX
  Loop @Mainloop
  @Done:
End;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure GetPal(Color: Word;Var R, G, B: Byte);Assembler;
Asm
  Mov DX, 3C7H
  Mov Ax, Color
  Out DX,al
  Add DX, 2
  In  AL, DX
  Les DI, R
  StosB
  In  AL, DX
  Les DI, G
  StosB
  In  AL, DX
  Les DI, B
  StosB
End;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure Hline(X1,X2,Y:Word);Assembler;
Asm
  Mov AX,Vp.x1
  Mov BX,Vp.y1
  Mov CX,Vp.x2
  Mov DX,Vp.y2
  Add X1,AX
  Add X2,AX
  Add Y,BX
  Cmp X1,AX
  Jg @@2
  Cmp X2,AX
  Jl @done
  Mov X1,AX
  @@2:
  Cmp Y,BX
  Jl @Done
  Cmp X2,CX
  Jl @@4
  Cmp X1,CX
  Jg @Done
  Mov X2,CX
  @@4:
  Cmp Y,DX
  Jg @Done

  Mov AX,Y
  Mov BX,X1
  Call Vsetoffset
  Mov DI,AX
  Mov BX,Y
  Mov SI,BX
  ShR SI,3
  ShL SI,3
  Sub BX,SI
  XOr AH,AH
  Mov bl,Byte Ptr Currentfill+BX
  Mov CX,X1
  Mov aX,CX
  ShR CX,3
  ShL CX,3
  Sub aX,CX
  Mov CX,aX
  ROl bl,CL

  Mov ES,SegA000
  Mov CX,X2
  Sub CX,X1
  inc cx
  mov dx,addx
  @Plotloop:
  ROl bl,1
  JNC @Noplot
  Mov AX,Currentfill.Color
  Jmp @Plotit
  @Noplot:
  Mov AX,Currentfill.Backcolor
  @Plotit:
  call plotcolor
  Add DI,dx
  Jnc @Noneedbank
  mov dl,currentbank
  Inc DL
  Call Setbank
  mov dx,addx
  @Noneedbank:
  Loop @Plotloop
  @Done:
End;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure Bar(X1,Y1,X2,Y2:Integer);assembler;
Var
  I,Iy:Word;
  Height,Width:Word;
  ssi:word;

asm
  Mov AX,X1
  Cmp AX,X2
  Jl @Xok
  Xchg AX,X2
  Mov X1,AX
  @xok:

  Mov AX,y1
  Cmp AX,y2
  Jl @yok
  Xchg AX,y2
  Mov y1,AX
  @yok:

  Mov AX,Vp.X1
  Mov BX,Vp.Y1
  Mov CX,Vp.X2
  Mov DX,Vp.Y2

  Add X1,AX
  Add X2,AX
  Add Y1,BX
  Add Y2,BX

  Cmp X1,AX
  Jg @@2
  Cmp X2,AX
  Jl @@Done
  Mov X1,AX
  @@2:
  Cmp Y1,BX
  Jg @@3
  cmp y2,bx
  jl @@done
  mov y1,bx

 @@3:
  Cmp X2,CX
  Jl @@4
  Cmp X1,CX
  Jg @@Done
  Mov X2,CX

  @@4:
  Cmp Y2,DX
  jl @ok
  cmp y1,dx
  jg @@done
  mov y2,dx
  @ok:

  Mov CX,X2
  Sub CX,X1
  Inc CX
  Mov Width,CX

  Mov AX,Y2
  Sub AX,Y1
  Inc AX
  Mov Height,AX

  call getwritemode
  mov byte ptr @pm,al
  Mov AX,Y1
  Mov BX,X1

  Call Vsetoffset
  mov dx,addx
  Mov DI,AX
  add byte ptr @pm,cl
  Mov AX,Width
  ShL AX,CL
  Sub BytesPerLine,AX
  Mov ES,SegA000

  Mov BX,X1
  Mov SI,BX
  ShR BX,3
  ShL BX,3
  Sub SI,BX
  mov ssi,si

  Mov AX,Y1
  Mov si,AX
  ShR AX,3
  ShL AX,3
  Sub si,AX

  @Loopy:
  Mov bl,Byte Ptr Currentfill+si
  mov cl,byte ptr ssi
  rol bl,cl
  Mov CX,Width
  @Plotloop:
  rol bl,1
  Jc @Noplot
  Mov AX,Currentfill.backColor
  Jmp @Plotit
  @Noplot:
  Mov AX,Currentfill.color
  @Plotit:
  db $26
  @pm:db 00
  db $05
  Add DI,dx
  Jnc @Noneedbank
  mov dl,currentbank
  Inc DL
  Call Setbank
  mov dx,addx
  @Noneedbank:
  Loop @Plotloop
  Add DI,BytesPerLine
  Jnc @Nobanky
  mov dl,currentbank
  Inc DL
  Call Setbank
  mov dx,addx
  @Nobanky:
  Inc sI
  Cmp si,8
  Jl @Skip
  Mov si,0
  @Skip:
  Dec Height
  Jnz @Loopy
  Mov AX,Width
  Mov CL,Hicolor
  ShL AX,CL
  Add BytesPerLine,AX
  @@done:
End;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure Bar3D(X1, Y1, X2, Y2:Integer;Depth: Word; Top: Boolean);
Var
  B:Byte;

Begin
  B:=getWriteMode;
  SetWriteMode(CopyPut);
  Bar(X1+1,Y1+1,X2-1,Y2-1);
  Rectangle(X1,Y1,X2,Y2);
  If Top Then
  Begin
    Line(X1,Y1,X1+Depth,Y1-Depth);
    Line(X2,Y1,X2+Depth,Y1-Depth);
    Line(X1+Depth,Y1-Depth,X2+Depth+1,Y1-Depth);
  End;
  Line(X2,Y2,X2+Depth,Y2-Depth);
  Inc(X2,Depth);
  Line(X2,Y2-Depth,X2,Y1-Depth);
  SetWriteMode(B);
End;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Function ImageSize(X1, Y1, X2, Y2: Integer):LongInt;Assembler;
{4+(x2-x1)*(y2-y1) untuk mode 256 warna
 4+2*(x2-x1)*(y2-y1) untuk mode 64k warna
^^->_DeltaX dan _DeltaY}
Asm
  Cwd
  Mov CL,Hicolor
  Mov BX,X2
  Sub BX,X1
  Inc BX
  ShL BX,CL
  Mov AX,Y2
  Sub AX,Y1
  Inc AX
  Mul BX
  Add AX,4
End;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure SetFillPattern(Var Pattern:FillPatternType;Color,Backcolor:Word);
Begin
  Currentfill.Pattern:=Pattern;
  Currentfill.Color:=Color;
  Currentfill.Backcolor:=Backcolor;
End;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure SetFillStyle(Pattern,Color,Backcolor:Word);Assembler;
Asm
  dec pattern
  Lea SI,Patterns
  Mov BX,Pattern
  ShL BX,3
  Add SI,BX
  Push DS
  Push SI
  Push Color
  Push Backcolor
  Call SetFillPattern
End;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure GetFillSettings(Var Fillinfo:FillSettingsType);Assembler;
Asm
  cld
  Lea SI,Currentfill
  LES DI,Fillinfo
  Mov CX,(Type FillSettingsType)/2
  Rep Movsw
End;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure GetViewSettings(Var Viewport: ViewPortType);Assembler;
Asm
  cld
  Lea SI,Vp
  LES DI,Viewport
  Mov CX,(Type ViewPortType)/2
  Rep Movsw
End;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure SetActivePage(Page:word);Assembler;
Asm
  Mov AX,getmaxy
  Inc AX
  Mul Page
  Mov Actstart,AX
End;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure SetVisualPage(Page:word);Assembler;
Asm
  Mov AX,getmaxy
  Inc AX
  Mul Page
  push 0
  push ax
  call scroll
End;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure Scroll(X,Y:Integer);Assembler;
Asm
  Mov CX,Scx
  Mov DX,Sdx
  Add DX,Y
  Add CX,X
  Mov Scx,CX
  Mov Sdx,DX
  Mov AX,04F07H
  XOr BX,BX
  Int 10H
End;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure SetBkColor(Color:Byte);
Var
  R,G,B:byte;

Begin
  Backcolor:=Color;
  GetPal(Color,R,G,B);
  SetPal(0,R,G,B);
End;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure ClearViewPort;
Var
  Fill:FillSettingsType;
  B:Byte;

Begin
  B:=GetWritemode+byte(hicolor);
  SetWritemode(Normalput);
  GetFillSettings(Fill);
  SetFillStyle(57,0,0);
  With Vp Do
    Bar(0,0,X2-X1,Y2-Y1);
  SetFillPattern(Fill.Pattern,Fill.Color,Fill.Backcolor);
  setwritemode(B-(byte(hicolor)));
End;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure Ellipse(X,Y:Integer;Xradius,Yradius:Word);
Var
  I,Ex,Ey: Integer;
  Yradsqr,Yradsqr2,Xradsqr,Xradsqr2,D,DX,Dy: LongInt;

Procedure Plotpoints;
Begin
  PutPixel(X+Ex,Y+Ey,Currentcolor);
  PutPixel(X-Ex,Y+Ey,Currentcolor);
  PutPixel(X+Ex,Y-Ey,Currentcolor);
  PutPixel(X-Ex,Y-Ey,Currentcolor);
End;

Begin
  Ex:=0;
  Ey:=Yradius;
  Yradsqr:=LongInt(Xradius)*Xradius;
  Yradsqr2:=Yradsqr ShL 1;
  Xradsqr:=LongInt(Yradius)*Yradius;
  Xradsqr2:=Xradsqr ShL 1;
  D:=Xradsqr-Yradsqr*Yradius+Yradsqr ShR 2;
  DX:=0;
  Dy:=Yradsqr2*Yradius;
  PutPixel(X,Y-Ey,Currentcolor);
  PutPixel(X,Y+Ey,Currentcolor);
  PutPixel(X-Xradius,Y,Currentcolor);
  PutPixel(X+Xradius,Y,Currentcolor);
  While (DX<Dy) Do
  Begin
    If (D>0) Then
    Begin
      Dec(Ey);
      Dec(Dy,Yradsqr2);
      Dec(D,Dy);
    End;
    Inc(Ex);
    Inc(DX,Xradsqr2);
    Inc(D,Xradsqr+DX);
    Plotpoints;
  End;
  Inc(D,(3*(Yradsqr-Xradsqr) Div 2 - (DX+Dy)) Div 2);
  For I:=Ey DownTo 1 Do
  Begin
    If(D < 0) Then
    Begin
      Inc(Ex);
      Inc(DX,Xradsqr2);
      Inc(D,Xradsqr+DX);
    End;
    Dec(Ey);
    Dec(Dy,Yradsqr2);
    Inc(D,Yradsqr-Dy);
    Plotpoints;
  End;
End;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure FillEllipse(X,Y:Integer;Xradius,Yradius:Word);
Var
  I,Ex,Ey: Integer;
  Yradsqr,Yradsqr2,Xradsqr,Xradsqr2,D,DX,Dy: LongInt;

Procedure Plotpoints;
Var
  Minx,Plusx:Integer;

Begin
  Minx:=X-Ex;
  Plusx:=X+Ex;
  Hline(Minx,Plusx,Y-Ey);
  Hline(Minx,Plusx,Y+Ey);
End;

Begin
  Ex:=0;
  Ey:=Yradius;
  Yradsqr:=LongInt(Xradius)*Xradius;
  Yradsqr2:=Yradsqr ShL 1;
  Xradsqr:=LongInt(Yradius)*Yradius;
  Xradsqr2:=Xradsqr ShL 1;
  D:=Xradsqr-Yradsqr*Yradius+Yradsqr ShR 2;
  DX:=0;
  Dy:=Yradsqr2*Yradius;
  While (DX<Dy) Do
  Begin
    If (D>0) Then
    Begin
      Dec(Ey);
      Dec(Dy,Yradsqr2);
      Dec(D,Dy);
    End;
    Inc(Ex);
    Inc(DX,Xradsqr2);
    Inc(D,Xradsqr+DX);
    Plotpoints;
  End;
  Inc(D,(3*(Yradsqr-Xradsqr) Div 2 - (DX+Dy)) Div 2);
  For I:=Ey DownTo 1 Do
  Begin
    If(D < 0) Then
    Begin
      Inc(Ex);
      Inc(DX,Xradsqr2);
      Inc(D,Xradsqr+DX);
    End;
    Dec(Ey);
    Dec(Dy,Yradsqr2);
    Inc(D,Yradsqr-Dy);
    Plotpoints;
  End;
  Ellipse(X,Y,Xradius,Yradius);
End;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure Fillcircle(X,Y:Integer;Radius:Word);assembler;
asm
 push x
 push y
 push radius
 push radius
 call fillellipse
End;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
Procedure DrawPoly(Numpoints: Word; Var Polypoints);
Var
  Points:Array[0..16000] Of PointType Absolute Polypoints;
  I:Word;

Begin
  For I:=0 To Numpoints-2 Do with points[I] do
  Line(X,Y,Points[I+1].X,Points[I+1].Y);
End;

Procedure Scanedge(X1,Y1,X2,Y2,Setxstart:Integer;Var Edgepointptr); Assembler;
Var
  Advanceamt,Height:Word;
  Skipfirst:Integer;

Asm
  Mov Skipfirst,0
  Les DI,Edgepointptr
  Les DI,ES:[DI]
  Cmp Setxstart,1
  Jz @@Hlineptrset
  Add DI,2
  @@Hlineptrset:
  Mov BX,Y2
  Sub BX,Y1
  Jle @@Toscanedgeexit
  Mov Height,BX
  Sub CX,CX
  Mov DX,1
  Mov AX,X2
  Sub AX,X1
  Jz  @@Isvertical
  Jns @@Setadvanceamt
  Mov CX,1
  Sub CX,BX
  Neg DX
  Neg AX
  @@Setadvanceamt:
  Mov Advanceamt,DX
  Cmp AX,BX
  Jz @@Isdiagonal
  Jb @@Ymajor
  Sub DX,DX
  Div BX
  Mov SI,AX
  Test Advanceamt,8000H
  Jz @@Xmajoradvanceamtset
  Neg SI
  @@Xmajoradvanceamtset:
  Mov AX,X1
  Cmp Skipfirst,1
  Jz @@Xmajorskipentry
  @@Xmajorloop:
  Mov ES:[DI],AX
  Add DI,4
  @@Xmajorskipentry:
  Add AX,SI
  Add CX,DX
  Jle @@Xmajornoadvance
  Add AX,Advanceamt
  Sub CX,Height
  @@Xmajornoadvance:
  Dec BX
  Jnz @@Xmajorloop
  Jmp @@Scanedgedone
  @@Toscanedgeexit:
  Jmp @@Scanedgeexit
  @@Isvertical:
  Mov AX,X1
  Sub BX,Skipfirst
  Jz @@Scanedgeexit
  @@Verticalloop:
  Mov ES:[DI],AX
  Add DI,4
  Dec BX
  Jnz @@Verticalloop
  Jmp @@Scanedgedone
  @@Isdiagonal:
  Mov AX,X1
  Cmp Skipfirst,1
  Jz @@Diagonalskipentry
  @@Diagonalloop:
  stosw
  add di,2
  @@Diagonalskipentry:
  Add AX,DX
  Dec BX
  Jnz @@Diagonalloop
  Jmp @@Scanedgedone
  @@Ymajor:
  Push BP
  Mov SI,X1
  Cmp Skipfirst,1
  Mov BP,BX
  Jz @@Ymajorskipentry
  @@Ymajorloop:
  Mov ES:[DI],SI
  Add DI,4
  @@Ymajorskipentry:
  Add CX,AX
  Jle @@Ymajornoadvance
  Add SI,DX
  Sub CX,BP
  @@Ymajornoadvance:
  Dec BX
  Jnz @@Ymajorloop
  Pop BP
  @@Scanedgedone:
  Cmp Setxstart,1
  Jz @@Updatehlineptr
  Sub DI,2
  @@Updatehlineptr:
  Mov BX,Word Ptr Edgepointptr
  Mov Ss:[BX],DI
  @@Scanedgeexit:
End;

{ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ}
function rgbcolor(red,green,blue:word):word;assembler;
const
 shift=3;
 shiftmask=255;

asm
 mov bx,green
 and bx,0ffh
 shl bx,5
 mov ax,blue
 and ax,0ffh
 add ax,bx
 mov dx,red
 and dx,0ffh
 shl dx,shift
 add dl,bh
 and dx,shiftmask
 mov ah,dl
end;

{
Procedure Drawmouse(X,Y:Integer);Assembler;
Var
  Width,Height:Word;
  AndPattern,Xorpattern:Word;
  Nhorshift:Word;
  savebank:byte;

Asm
    cld
    Mov Nhorshift,0
    Mov Height,16
    Mov Width,16
    mov bx,x
    mov dx,y
    Lea SI,MouseShape
    Lodsw
    sub bx,ax   {x-hotspot.x}
{    cmp bx,0
    jge @xg
    neg bx
    mov nhorshift,bx
    neg bx
    add bx,16
    mov width,bx
    xor bx,bx
    jmp @xdone
    @xg:
    mov ax,bx
    add ax,16
    cmp ax,getmaxx
    jle @xdone
    mov cx,getmaxx
    inc cx
    sub cx,bx
    mov width,cx
    @Xdone:
    Lodsw
    Sub dx,ax
    Cmp dx,0
    Jge @Yg
    mov ax,dx
    neg ax
    shl ax,1
    add si,ax
    add dx,16
    mov height,dx
    xor dx,dx
    jmp @ydone
    @Yg:
    Mov AX,dx
    Add AX,16
    Cmp AX,getmaxy
    Jle @Ydone
    Mov AX,getmaxy
    Sub AX,dx
    Inc AX
    Mov Height,AX
    @Ydone:
    mov al,20h
    add al,hicolor
    mov byte ptr @p1,al
    mov al,30h
    add al,hicolor
    mov byte ptr @p2,al
    Mov AX,dx
    call vsetoffset
    Mov DI,AX
    Push bytesperline
    Mov AX,Width
    shl ax,cl
    Sub bytesperline,AX
    Mov BL,15
    Mov ES,SegA000
    Mov Bx,15
    cmp cl,false
    je @puty
    mov bx,0ffffh

    @Puty:
    LODSW              {AND}
{    mov andpattern,ax
    Mov ax,DS:[SI+30]  {XOR}
{    mov xorpattern,ax
    Mov CX,nhorshift
    Rol andpattern,CL
    Rol xorpattern,CL
    Mov CX,Width
    @Putx:
    XOr aX,aX
    Rol andpattern,1
    Jc @Noandput
    db $26
@p1:db $20
    db $05
    @Noandput:
    Rol Xorpattern,1
    Jnc @Noxorput
    db $26
@p2:db $30
    db $1d   {ada warnaan}
{    @Noxorput:
    add DI,addx
    jnz @nobank
    inc dl
    call setbank
    @nobank:
    Loop @Putx
    Add DI,bytesperline
    jnc @nobank2
    inc dl
    call setbank
    @nobank2:
    Dec Height
    Jnz @Puty
    @@Done:
    Pop bytesperline
End;
 }
Procedure SetMouseCursor(X,Y:Word);Assembler;
Asm
  Mov AX,4
  Mov CX,X
  Mov DX,Y
  Int 33H
End;

{
Procedure SetMouseStyle(shape:byte);
begin
 if curshape <> shape then
 begin
  curshape:=shape;
  setmousepattern(mouses[shape]);
 end;
end;

Procedure SetMousePattern(Shape:MouseShapeType);assembler;
asm
 cld
 mov dx,ds
 lds si,shape
 lea di,mouseshape
 mov ax,ds
 mov es,ax
 mov cx,type(mouseshapetype)/4
 Db 0F3H, 066H, 0A5H
 mov ds,dx
End;
}

PROCEDURE SetMouseWindow(X1,Y1,X2,Y2:Word);assembler;
asm
  mov ax,07h
  mov cx,x1
  mov dx,x2
  int 33h
  mov ax,08h
  mov cx,y1
  mov dx,y2
  int 33h
End;

END.
