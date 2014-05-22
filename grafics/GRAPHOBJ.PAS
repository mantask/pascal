{
  Small part of my gfx unit for representation of 3D vector objects.
  Coded by Mike Shirobokov(MSH) aka Mad Max / Queue Members (2:5057/1.5)
  (c)1994 MSH, Samara, Russia
  You can do anything with this stuff but pls refer to me
  if you want to use it. You can change anything except
  this comment.
}

unit GraphObj;

interface

uses Objects, Memory;

type
  PPoint2D = ^TPoint2D;
  TPoint2D = object
    X, Y: Integer;
    Color: Byte;
  end;

  PPoint3D = ^TPoint3D;
  TPoint3D = object
    X, Y, Z: LongInt;
  end;

  PDrawFunc = ^TDrawFunc;
  TDrawFunc = procedure( Point: TPoint2D );

const
  ScaleFactor = 256;
  Min : TPoint3D = ( X:-156 * ScaleFactor; Y:2 * ScaleFactor;
       Z:-156 * ScaleFactor );
  Max : TPoint3D = ( X: 156 * ScaleFactor; Y:135 * ScaleFactor;
       Z: 156 * ScaleFactor );
  MaxColor = 256;
  ScreenSize = 64000;
  RotateSteps = 100;
  ViewAngle: 0..RotateSteps-1 = 0;
  SurfAngle: 0..RotateSteps-1 = 0;

var
  Palette: array [ 0..255 ] of record R,G,B: Byte; end;
  LastPoint,
  LastShadow: TPoint2D;
  SinTable: array [ 0..RotateSteps-1 ] of LongInt;
  CosTable: array [ 0..RotateSteps-1 ] of LongInt;
  Time:  LongInt absolute 0:$46C;
  StartTime,
  Frames:  LongInt;
  CurPage,
  CurOffset: Word;

type
  TScreenBuffer = array[ 0..199, 0..319 ] of Byte;
  PScreenBuffer = ^TScreenBuffer;

const
  Screen: PScreenBuffer = Ptr( $A000, 0 );

type
  TColor = ( White, Blue, Black );
  procedure Draw3D( Point: TPoint3D; Color: TColor;
      DrawObject, DrawShadow: PDrawFunc );
  function GetRealColor( Point: TPoint3D; Color: TColor ): Byte;
  procedure SetAllPalette( var Palette );
  procedure PutPixel( X, Y: Integer; Color: Byte );
  procedure CopyPage( FromPage, ToPage: Word );
  procedure FlipPage;

type
  PGraphApplication = ^TGraphApplication;
  TGraphApplication = object( TObject )
    constructor Init;
    procedure Run; virtual;
    destructor Done; virtual;
  end;

  PGraphObject = ^TGraphObject;
  TGraphObject = object( TObject )
    Origin: TPoint3D;
    constructor Init( AOrigin: TPoint3D );
    procedure Hide; virtual;
    procedure Show; virtual;
    procedure Move( Delta: TPoint3D ); virtual;
    procedure Update; virtual;
    destructor Done; virtual;
  end;

implementation

constructor TGraphApplication.Init;
var
  I: Integer;
begin
  inherited Init;
  asm
    mov ax,$13
    int $10
    mov al,$05
    mov dx,$3ce
    out dx,al
    mov dx,$3cf
    in al,dx
    and al,239
    out dx,al
    dec dx
    mov al,$06
    out dx,al
    inc dx
    in al,dx
    and al,253
    out dx,al
    mov dx,$3c4
    mov al,$04
    out dx,al
    inc dx
    in al,dx
    and al,247
    or al,4
    out dx,al
    mov ax,$a000
    mov es,ax
    mov di,0
    mov ax,0
    mov cx,$8000
    rep stosw
    mov dx,$3d4
    mov al,$14
    out dx,al
    inc dx
    in al,dx
    and al,191
    out dx,al
    dec dx
    mov al,$17
    out dx,al
    inc dx
    in al,dx
    or al,64
    out dx,al
  end;
  for I := 0 to RotateSteps-1 do
  begin
    SinTable[i] := Round( Sin( 2*Pi / RotateSteps * I ) * 1024 );
    CosTable[i] := Round( Cos( 2*Pi / RotateSteps * I ) * 1024 );
  end;
  CurPage := 0;
  CurOffset := 0;
  Frames := 0;
  StartTime := Time;
end;

procedure TGraphApplication.Run;
begin
  Abstract;
end;

destructor TGraphApplication.Done;
begin
  asm
    mov ax,3
    int 10h
  end;
  WriteLn( 'Frames per second : ', Frames/(Time-StartTime)/0.055:5:2 );
end;

constructor TGraphObject.Init( AOrigin: TPoint3D );
begin
  Origin := AOrigin;
end;

procedure TGraphObject.Hide;
begin
  Abstract;
end;

procedure TGraphObject.Show;
begin
  Abstract;
end;

procedure TGraphObject.Move( Delta: TPoint3D );
begin
  Origin.X := Origin.X + Delta.X;
  Origin.Y := Origin.Y + Delta.Y;
  Origin.Z := Origin.Z + Delta.Z;
end;

procedure TGraphObject.Update;
begin
  Abstract;
end;

destructor TGraphObject.Done;
begin
  Hide;
end;

function GetRealColor( Point: TPoint3D; Color: TColor ): Byte;
begin
  if Color = Black then
    GetRealColor := 0
  else
    GetRealColor := Byte( ( (Point.Z - Min.Z) shl 7 ) div (Max.Z - Min.Z) +
      Ord(Color) shl 7);
end;

procedure Draw3D( Point: TPoint3D; Color: TColor;
    DrawObject, DrawShadow: PDrawFunc );
var
  RealPoint: TPoint2D;
  T1,
  T2,
  T3,
  T4: LongInt;
begin

  if (Point.X < Min.X) or (Point.X >= Max.X) or
     (Point.Y < Min.Y) or (Point.Y >= Max.Y) or
     (Point.Z < Min.Z) or (Point.Z >= Max.Z) then
    Exit;

  T1 := Point.X * CosTable[ ViewAngle ];
  T2 := Point.Z * SinTable[ ViewAngle ];
  T3 := Point.X * SinTable[ ViewAngle ];
  T4 := Point.Z * CosTable[ ViewAngle ];
  Point.X := ( T1 - T2 ) div 1024;
  Point.Z := ( T3 + T4 ) div 1024;
{
  T1 := Point.Y * CosTable[ SurfAngle ];
  T2 := Point.Z * SinTable[ SurfAngle ];
  T3 := Point.Y * SinTable[ SurfAngle ];
  T4 := Point.Z * CosTable[ SurfAngle ];
  Point.Y := ( T1 - T2 ) div 1024;
  Point.Z := ( T3 + T4 ) div 1024;
}
  if (Point.X < Min.X) or (Point.X >= Max.X) or
     (Point.Y < Min.Y) or (Point.Y >= Max.Y) or
     (Point.Z < Min.Z) or (Point.Z >= Max.Z) then
    Exit;

  RealPoint.X := (Point.X-Min.X) shr 8;
  RealPoint.Y := ( Max.Y + Point.Z shr 2 ) shr 8;
  RealPoint.Color := 0;
{  DrawShadow^( RealPoint ); Borland sucks! It doesn't work! }
  asm
    push ss
    lea ax,RealPoint
    push ax
    call dword ptr [DrawShadow]
  end;
  LastShadow.X := RealPoint.X;
  LastShadow.Y := RealPoint.Y;

  RealPoint.Y := ( (Max.Y-Point.Y) + Point.Z shr 2 ) shr 8;
  RealPoint.Color := GetRealColor(Point,Color);
{  DrawObject^( RealPoint ); Borland sucks! It doesn't work! }
  asm
    push ss
    lea ax,RealPoint
    push ax
    call dword ptr [DrawObject]
  end;
  LastPoint.X := RealPoint.X;
  LastPoint.Y := RealPoint.Y;
end;

procedure SetAllPalette( var Palette );
begin
  asm
    push ds
    lds si,Palette
    xor al,al
    mov dx,$3C8
    out dx,al
    inc dx
    mov cx,768
    rep outsb
    pop ds
  end;
end;

procedure CopyPage( FromPage, ToPage: Word ); assembler;
asm
  push ds
  les di, Screen
  mov di, 16000
  mov ax, ToPage
  mul di
  mov di,ax
  lds si, Screen
  mov si, 16000
  mov ax, FromPage
  mul si
  mov si,ax
  mov dx,$3C4
  mov ax,$F02
  out dx,ax
  mov dx,$3CE
  mov ax,$008
  out dx,ax

  mov cx,16000
  cld
  rep movsb

  mov dx,$3CE
  mov ax,$FF08
  out dx,ax

  pop ds
end;

procedure PutPixel( X, Y: Integer; Color: Byte ); assembler;
asm
  les di,Screen
  add di,CurOffset
  mov ax,Y
  shl ax,4
  add di,ax
  shl ax,2
  add di,ax
  mov ax,X
  mov cl,al
  and cl,3
  shr ax,2
  add di,ax
  mov ah,1
  shl ah,cl
  mov dx,$3C4
  mov al,2
  out dx,ax
  mov al,Color
  mov es:[di],al
end;

procedure FlipPage;
begin
  asm
    mov dx,3d4h
    mov al,0ch
    mov ah,CurOffset.Byte[1]
    out dx,ax
    mov dx,3d4h
    mov al,0dh
    mov ah,byte ptr CurOffset
    out dx,ax

    mov dx,3dah
 @@1: in al,dx
    test al,00001000b
    jz @@1
 @@2: in   al,dx
    test al,00001000b
    jnz  @@2

  end;
  CurPage := 1-CurPage;
  CurOffset := 16000*CurPage;
end;

end.
