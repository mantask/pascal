{
  Demo for animated particles engine.
  Coded by Mike Shirobokov(MSH) aka Mad Max / Queue Members (2:5057/1.5)
  (c)1994 MSH, Samara, Russia
  Warning! This code can be used in educational purposes only.
  For any other use - please contact me.
}

{$A-,B-,D+,E+,F-,G+,I-,L+,N-,O-,P-,Q-,R-,S-,T-,V+,X+}
{$M 16384,0,655360}

program Glitch;

{$M $4000,$32000,$32000}

uses Objects, CRT, GraphObj, Points;

const
  PointsNumber  = 300;
  YSpeedMul: LongInt = Round( 3.5 * ScaleFactor );
  YSpeedAdd: LongInt = Round( 0.7 * ScaleFactor );
  XSpeedMul: LongInt = Round( 0.7 * ScaleFactor );
  XSpeedAdd: LongInt = Round( 0 * ScaleFactor );

  ShadeSteps  = 16;
  StarsNumber  = 200;
  PartSteps  = 500;
  AngleStep: Integer = 2;

type
  TInsertType = ( itSpyralFromFloor,
    itRandomFromFloor,
    itSpyralFromCeil,
    itInRing,
    itRandomInCone,
    itRandom );

  PPointsApp = ^TPointsApp;
  TPointsApp = object( TGraphApplication )
    Points: TPoints;
    constructor Init;
    procedure Run; virtual;
    destructor Done; virtual;
    procedure InsertPoint( How: TInsertType );
  end;

procedure TPointsApp.InsertPoint( How: TInsertType );

var
  Speed: TPoint3D;
  Origin: TPoint3D;

procedure InsertSpyralFromFloor;
const
  PointsOrigin : TPoint3D = ( X:0;  Y:0; Z:0 );
  Last:  Real = 2*Pi;
  Step:  Real = Pi / 20;
begin
  Speed.X := Round( XSpeedMul * Cos(Last) );
  Speed.Z := Round( XSpeedMul * Sin(Last) );
  Last := Last - Step;
  if Last < 0 then Last := 2*Pi;
  Speed.Y := YSpeedMul + YSpeedAdd;
  Points.Insert( New( PFlyingPoint, Init( PointsOrigin, Speed ) ) );
end;

procedure InsertRandomFromFloor;
const
  PointsOrigin : TPoint3D = ( X:0;  Y:0; Z:0 );
begin
  repeat
    Speed.X := XSpeedMul-Integer(Random(XSpeedMul*2));
  until Abs(Speed.X) >= XSpeedAdd;
  repeat
    Speed.Z := XSpeedMul-Integer(Random(XSpeedMul*2));
  until Abs(Speed.X) >= XSpeedAdd;
  Speed.Y := YSpeedAdd + Random(YSpeedMul);
  Points.Insert( New( PFlyingPoint, Init( PointsOrigin, Speed ) ) );
end;

procedure InsertSpyralFromCeil;
const
  Last:  Real = 2*Pi;
  Step:  Real = Pi / 20;
begin
  Origin.X := Round( Max.X * Cos(Last) /2 ) + 50*ScaleFactor;
  Origin.Z := Round( Max.Z * Sin(Last) /2 );
  Origin.Y := Max.Y;
  Last := Last - Step;
  if Last < 0 then Last := 2*Pi;
  Speed.X := 0;
  Speed.Z := 0;
  Speed.Y := 0;
{  Speed.Y := Round( YSpeedMul*Sin(Last) );}
{  Speed.Y := YSpeedMul;}
  Points.Insert( New( PFlyingPoint, Init( Origin, Speed ) ) );
end;

procedure InsertInRing;
const
  PointsOrigin : TPoint3D = ( X:0;  Y:0; Z:0 );
  Number = 20;
var
  I: Integer;
begin
  Speed.Y := YSpeedMul+YSpeedAdd;
  for I := 1 to Number do
  begin
    Speed.X := Round( XSpeedMul*Sin(2*Pi*I/Number) );
    Speed.Z := Round( XSpeedMul*Cos(2*Pi*I/Number) );
    Points.Insert( New( PFlyingPoint, Init( PointsOrigin, Speed ) ) );
  end;
end;

procedure InsertRandomInCone;
begin
  Origin.Y := LongInt( Random( (Max.Y - Min.Y) shr 4 ) ) shl 3 + Min.Y;
  Origin.X := LongInt( Random( (Origin.Y) shr 3 ) ) shl 5 - Origin.Y*2;
  Origin.Z := LongInt( Random( (Origin.Y) shr 3 ) ) shl 5 - Origin.Y*2;
  Speed.X := 0;
  Speed.Z := 0;
  Speed.Y := 0;
  Points.Insert( New( PFlyingPoint, Init( Origin, Speed ) ) );
end;

procedure InsertRandom;
begin
  Origin.Y := LongInt( Random( (Max.Y - Min.Y) shr 4 ) ) shl 4 + Min.Y;
  Origin.X := LongInt( Random( (Max.X - Min.X) shr 4 ) ) shl 4 + Min.X;
  Origin.Z := LongInt( Random( (Max.Z - Min.Z) shr 4 ) ) shl 4 + Min.Z;
  Speed.X := 0;
  Speed.Z := Random( XSpeedMul ) + XSpeedAdd;
  Speed.Y := Random( XSpeedMul ) + XSpeedAdd;
  Points.Insert( New( PFlyingPoint, Init( Origin, Speed ) ) );
end;

begin
  case How of
    itSpyralFromFloor : InsertSpyralFromFloor;
    itRandomFromFloor : InsertRandomFromFloor;
    itSpyralFromCeil  : InsertSpyralFromCeil;
    itInRing          : InsertInRing;
    itRandomInCone    : InsertRandomInCone;
    itRandom          : InsertRandom;
  end;
end;

constructor TPointsApp.Init;
var
  I,
  J:  Integer;
  Color: Byte;
begin
  inherited Init;
  Randomize;
  FillChar( Palette, SizeOf(Palette), 0 );
  SetAllPalette( Palette );
  for I := 199 downto 109 do
  begin
    for J := 0 to 319 do
      PutPixel( J, I, 27 + I + Random(20) );
  end;
  for I := 1 to StarsNumber do
    PutPixel( Random(320), Random(109), 128+Random(128) );
  CopyPage( 0, 2 );
  CopyPage( 0, 1 );
  Points.Init( PointsNumber );
  for I := 0 to 127 do
  begin
    Palette[I].R := I div 2;
    Palette[I].G := I div 2;
    Palette[I].B := I div 2;
    Palette[I+128].R := 0;
    Palette[I+128].G := 0;
    Palette[I+128].B := I div 2;
  end;
  SetAllPalette(Palette);
end;

procedure TPointsApp.Run;

function Ended: Boolean;
const
  ToEnd: Integer = 0;
  IsEnded:      Boolean = False;
var
  I:  Integer;
begin
  Ended := False;
  if KeyPressed then
  begin
    ReadKey;
    IsEnded := True;
  end;
  if IsEnded then
  begin
    for I := 0 to 255 do
    begin
      if Palette[I].R > 64 div ShadeSteps then
        Dec( Palette[I].R, 64 div ShadeSteps );
      if Palette[I].G > 64 div ShadeSteps then
        Dec( Palette[I].G, 64 div ShadeSteps );
      if Palette[I].B > 64 div ShadeSteps  then
        Dec( Palette[I].B, 64 div ShadeSteps );
    end;
{

   Uncomment this if you'll see flickering

    Repeat Until (Port[$3DA] And $08) = 0;
    Repeat Until (Port[$3DA] And $08) <> 0;
}
    SetAllPalette( Palette );
    Inc(ToEnd);
    if ToEnd >= ShadeSteps then Ended := True;
  end;
end;

var
  J,
  I:  Integer;
  Angle: LongInt;
begin
  Angle := 0;

  for I := 1 to PartSteps do
  begin
    if Ended then Exit;
    if (Points.Count < PointsNumber ) and (I and 7 = 7) then
      InsertPoint( itInRing );
    Points.Update;
    Inc( Angle, AngleStep );
    if Angle >= RotateSteps shl 1 then Angle := 0;
    ViewAngle := Angle shr 1;
  end;
  for I := 1 to Points.Count do
    Inc( TFlyingPoint( Points.At(I-1)^ ).Speed.X, 7*ScaleFactor );

  XSpeedMul := Round( 2 * ScaleFactor );
  YSpeedAdd := Round( 6 * ScaleFactor );
  YSpeedMul := 3*ScaleFactor;
  Gravity := Round( 0.25 * ScaleFactor );
  for I := 1 to PartSteps do
  begin
    if Ended then Exit;
    if (Points.Count < PointsNumber ) then
      InsertPoint( itRandomFromFloor );
    Points.Update;
{
    Inc( Angle, AngleStep );
    if Angle >= RotateSteps shl 1 then Angle := 0;
    ViewAngle := Angle shr 1;
}
  end;
  for I := 1 to Points.Count do
    Inc( TFlyingPoint( Points.At(I-1)^ ).Speed.X, 4*ScaleFactor );

  ReflectionRatio := 1;
  Gravity := Round( 0.3 * ScaleFactor );
  for I := 1 to PartSteps do
  begin
    if Ended then Exit;
    if (Points.Count < PointsNumber) then
      InsertPoint( itSpyralFromCeil );
    Points.Update;
    Inc( Angle, AngleStep );
    Angle := Angle mod (RotateSteps shl 1);
    ViewAngle := Angle shr 1;
  end;

  for I := 1 to Points.Count do
    Inc( TFlyingPoint( Points.At(I-1)^ ).Speed.Z, 5*ScaleFactor );

  Gravity := Round( 0.08 * ScaleFactor );
  YSpeedAdd := Round( 0.4*ScaleFactor );
  YSpeedMul := Round( 3.5 * ScaleFactor );
  XSpeedMul := Round( 0.5 * ScaleFactor );
  AngleStep := -AngleStep;
  for I := 1 to PartSteps do
  begin
    if Ended then Exit;
    if (Points.Count < PointsNumber) {and (I and 3 = 3)} then
      InsertPoint( itSpyralFromFloor );
    Points.Update;
    Inc( Angle, AngleStep );
    if Angle < 0 then Angle  := (RotateSteps shl 1) + Angle;
    ViewAngle := Angle shr 1;
  end;
  for I := 1 to Points.Count do
    TFlyingPoint( Points.At(I-1)^ ).Speed.Y := 0;

  Gravity := Round( -0.02 * ScaleFactor );
  YSpeedAdd := Round( 6 * ScaleFactor );
  XSpeedMul := Round( 2 * ScaleFactor );
  Angle := Angle shl 4;
  AngleStep := -AngleStep;
  for I := 1 to PartSteps - 100 do
  begin
    if Ended then Exit;
{    if Points.Count < PointsNumber then}
      InsertPoint( itRandom );
    Points.Update;
    Inc( Angle, AngleStep );
    Angle := Angle mod (RotateSteps shl 5);
    Inc( AngleStep );
    if Angle >= RotateSteps shl 5 then Angle := 0;
    ViewAngle := Angle shr 5;
  end;
  for I := 1 to 32 do
  begin
    if Ended then Exit;
    InsertPoint( itRandomInCone );
    Points.Update;
    Inc( Angle, AngleStep );
    Angle := Angle mod (RotateSteps shl 5);
    Inc( AngleStep, 1 );
    if Angle >= RotateSteps shl 5 then Angle := 0;
    ViewAngle := Angle shr 5;
    for J := 0 to 255 do
    begin
      if Palette[J].R < 63 then Inc( Palette[J].R, 2 );
      if Palette[J].R > 63 then Palette[J].R := 63;
      if Palette[J].G < 63 then Inc( Palette[J].G, 2 );
      if Palette[J].G > 63 then Palette[J].G := 63;
      if Palette[J].B < 63 then Inc( Palette[J].B, 2 );
      if Palette[J].B > 63 then Palette[J].B := 63;
    end;
{
    Repeat Until (Port[$3DA] And $08) = 0;
    Repeat Until (Port[$3DA] And $08) <> 0;
}
    SetAllPalette( Palette );
  end;
end;

destructor TPointsApp.Done;
begin
  Points.Done;
  inherited Done;
end;

var
  GA:  TPointsApp;
begin
  GA.Init;
  GA.Run;
  GA.Done;
end.
