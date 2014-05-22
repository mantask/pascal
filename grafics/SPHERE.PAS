{$A+,B-,D+,E+,F-,G+,I+,L+,N-,O-,P-,Q-,R+,S+,T-,V+,X-}
{$M 16384,0,0}

{A Little Rotating Sphere, By Glen Jeh, 8/12/1994, Use Freely}

Program G_Ball;

{Try Messing With The Constants...Code Is Squished A Little}

Uses
  Crt;

Const
  Distance   : Integer  = 100;
  Dir        : Shortint = -3;
  Scale                 = 50;
  Radius                = 80;    {Mystery Constant}
  Delaytime             = 1;     {Delay(Delaytime) To Slow It Down..}
  Slices                = 12;    {Number Of Slices}
  Pps                   = 20;    {Points Per Slice}

Type
  Pointtype = Record
    X,Y,Z   : Integer;
  End;  {(X,Y,Z) Point}

  Slicetype = Array[1..Pps] Of Pointtype;   {Array Of Points For A Slice}
  Balltype = Array[1..Slices] Of Slicetype; {Array Of Slices For A Ball}

Var
  Xangle,
  Yangle,
  Zangle     : Byte;
  I          : Integer;
  Sintable,
  Costable   : Array[0..255] Of Integer;
  Ball,
  Points     : Balltype;  {Ball Is Constant Data, Points Is Rotated Data}

{----------------------------------------------------------------------------}

Procedure Drawpoints (Color : Byte);

  Var
    I,
    I2 : Integer;

  Begin
    For I := 1 To Slices Do
      For I2 := 1 To Pps Do
        With Points[I,I2] Do
          If (Z >= 0) And (X <= 319) And (X>=0) And (Y>=0) And (Y<199) Then
            Mem[$A000:Word(Y) * 320 + X] := Color;
  End;

{----------------------------------------------------------------------------}

Procedure Setupball; {Set Up The Points}

{Sets Up The Ball's Data..}

  Var
    Sliceloop,
    Ppsloop    : Integer;
    Phi,
    Theta      : Real;

  Begin
    For Sliceloop := 1 To Slices Do
      Begin
        Phi := Pi/Slices*Sliceloop;     {0 <= Phi <= Pi}
        For Ppsloop := 1 To Pps Do With Ball[Sliceloop,Ppsloop] Do
          Begin
            Theta := 2*Pi/Pps*Ppsloop;  {0 <= Theta <= 2*Pi}
                {convert Radius,Thetha,Phi To (X,Y,Z) Coordinates}
            Y := Round(Radius * Sin(Phi) * Cos(Theta));
            X := Round(Radius * Sin(Phi) * Sin(Theta));
            Z := Round(Radius * Cos(Phi));
          End;
      End;
  End;

{----------------------------------------------------------------------------}

Procedure Rotate;

{Updates All (X,Y,Z) Coordinates According To Xangle,Yangle,Zangle}

  Var
    I,
    I2,
    TempX,
    TempY,
    TempZ,
    OldTempX : Integer;

  Begin
    For I := 1 To Slices Do
      For I2 := 1 To Pps Do
        With Ball[I,I2] Do
          Begin

            {Rotate On X-axis}

            TempY := (Y*Costable[Xangle] - Z*Sintable[Xangle]) Div 128;
            TempZ := (Y*Sintable[Xangle] + Z*Costable[Xangle]) Div 128;

            {Rotate On Y-axis}

            Tempx := (X*Costable[Yangle] - Tempz*Sintable[Yangle]) Div 128;
            Tempz := (X*Sintable[Yangle] + Tempz*Costable[Yangle]) Div 128;

            {Rotate On Z-axis}

            Oldtempx := Tempx;
            Tempx := (Tempx*Costable[Zangle] - Tempy*Sintable[Zangle]) Div 128;
            Tempy := (Oldtempx*Sintable[Zangle] + Tempy*Costable[Zangle]) Div 128;
            Points[I,I2].X := (Tempx*Scale) Div Distance + 320 Div 2;
            Points[I,I2].Y := (Tempy*Scale) Div Distance + 200 Div 2;
            Points[I,I2].Z := Tempz;
          End;
  End;

{----------------------------------------------------------------------------}

Begin
  For I := 0 To 255 Do
    Begin
      Sintable[I] := Round(Sin(2*Pi/255*I) * 128);
      Costable[I] := Round(Cos(2*Pi/255*I) * 128);
    End;

  Asm
    Mov Ax,$0013;
    Int $10
  End;

  Setupball;
  Xangle := 0;
  Yangle := 0;
  Zangle := 0;

  Repeat
    Rotate;
    Drawpoints(Lightgreen);
    Inc(Xangle,3);
    Inc(Yangle,2);
    Inc(Zangle,1);
    Inc(Distance,Dir);
    If Distance >= 300 Then
      Dir := -3
    Else
      If Distance <= 30 Then
        Dir := 2;
    Delay(Delaytime);    {I Don't Know Why This Is Too Fast...}
    Repeat
    Until Port[$3Da] And 8 <> 0;
    Drawpoints(0);
  Until Keypressed;

  Asm
    Mov Ax,$0003;
    Int $10
  End;
End.
