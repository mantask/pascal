Program Shading;
 
Uses
  Crt;
 
Var
  Y,
  ColorNum  : Integer;
 
{----------------------------------------------------------------------------}

Procedure SetColors;
 
  Var
    Color : Byte;
    A     : Integer;
 
  Begin   {SetColors}
    For A := 1 to 63 do
      Begin   {For}
        Port[$3c8] := A;
        Port[$3c9] := 1;
        Port[$3c9] := 1;
        Port[$3c9] := A;
      End;    {For}
  End;    {SetColors}

{----------------------------------------------------------------------------}
 
Procedure Horizontal_Line (x1,x2,y : integer; color : Byte);
 
  Var
    Temp,
    Counter : Integer;
 
  Begin   {Horizontal_Line}
    If X1 > X2 Then
      Begin   {If}
        Temp:=X1;
        X1:=X2;
        X2:=Temp;
      End;    {If}

    X1:=(y*320)+X1;
    X2:=(y*320)+X2;

    For Counter := X1 To X2 Do
      Mem[$A000:Counter]:=color;
  End;    {Horizontal_Line}

{----------------------------------------------------------------------------}

Procedure Init13h;    {Sets video to 320X200X256}
 
  Begin   {Init13h}
    Asm
      Mov Ah, 00
      Mov Al, 13h
      Int 10h
    End;   {Asm}
  End;    {Init13h}

{----------------------------------------------------------------------------}

Procedure InitText;   {Sets video to Textmode}
 
  Begin   {InitText}
    Asm
      Mov Ah, 00
      Mov Al, 3
      Int 10h
    End;    {Asm}
  End;    {InitText}

{----------------------------------------------------------------------------}

Begin   {Main}
  ColorNum:=1;
  Init13h;
  SetColors;

  For Y := 1  To 63  Do
    Begin   {For}
      Horizontal_Line(80, 239, Y, Colornum);
      Inc(ColorNum);
    End;    {For}

  For Y := 64 To 126 Do
    Begin   {For}
      Dec(ColorNum);
      Horizontal_Line(80, 239, Y, ColorNum);
    End;

  Readkey;
  InitText;
End.    {Main}
