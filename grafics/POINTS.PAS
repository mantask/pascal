{
  Sample of gfx object( animated particle ) based on TGraphObject.
  Coded by Mike Shirobokov(MSH) aka Mad Max / Queue Members (2:5057/1.5)
  (c)1994 MSH, Samara, Russia
  Warning! This code can be used in educational purposes only.
  For any other use - please contact me on 2:5057/1.5
}

{$A-,B-,D+,E+,F-,G+,I-,L+,N-,O-,P-,Q-,R-,S-,T-,V+,X+}
{$M 16384,0,655360}

unit Points;

interface

uses Objects, GraphObj;

const
  Gravity:   LongInt = Round( 0.08 * ScaleFactor );
  ReflectionRatio: Real = 0.9;

type
  PFlyingPoint = ^TFlyingPoint;
  TFlyingPoint = object( TGraphObject )
    OldPoint,
    OldShadow: array [ 0..1 ] of TPoint2D;
    Speed: TPoint3D;
    Valid: Boolean;
    Number: Integer;
    constructor Init( AOrigin: TPoint3D; ASpeed: TPoint3D );
    procedure Show; virtual;
    procedure Hide; virtual;
    procedure Update; virtual;
    function IsValid: Boolean; virtual;
  end;

  PPoints = ^TPoints;
  TPoints = object( TCollection )
    ToDelete: TCollection;
    constructor Init( InitNumber: Integer );
    procedure Update; virtual;
  end;

implementation

{
If somebody will be not too lazy to rewrite two procedures below in asm -
- pls send them to me :-)
}
procedure DrawPoint( var Point: TPoint2D ); far;
begin
  if (Point.Y > 0) and (Point.X>0) and (Point.X<318) then
  begin
    if Point.Color > 32 then
    begin
      PutPixel( Point.X-1, Point.Y, Point.Color-32 );
      PutPixel( Point.X+2, Point.Y, Point.Color-32 );
      PutPixel( Point.X, Point.Y-1, Point.Color-32 );
      PutPixel( Point.X+1, Point.Y-1, Point.Color-32 );
      PutPixel( Point.X, Point.Y+1, Point.Color-32 );
      PutPixel( Point.X+1, Point.Y+1, Point.Color-32 );
    end;
    PutPixel( Point.X, Point.Y, Point.Color );
    PutPixel( Point.X+1, Point.Y, Point.Color );
  end;
end;

procedure DrawShadow( var Point: TPoint2D ); far;
var
  X, Y:  Word;
  Color: Byte;
begin
  if Point.Y >= 0 then
  begin
    PutPixel( Point.X, Point.Y, Point.Color );
    PutPixel( Point.X+1, Point.Y, Point.Color );
    PutPixel( Point.X, Point.Y+1, Point.Color );
    PutPixel( Point.X+1, Point.Y+1, Point.Color );
  end;
end;

procedure HidePoint( X, Y: Integer );
var
  O: Word;
begin
  O := CurOffset;
  if Y > 0 then
  asm
    push ds
    les di,Screen
    lds si,Screen
    mov ax,Y
    dec ax
    shl ax,6
    mov di,ax
    shl ax,2
    add di,ax
    add di,X
    dec di
    shr di,2
    mov si,di
    add di,word ptr [O]
    add si,32000

    mov ax,$F02
    mov dx,$3C4
    out dx,ax
    mov ax,$008
    mov dx,$3CE
    out dx,ax
    movsb
    movsb
    add di,78
    add si,78
    movsb
    movsb
    add di,78
    add si,78
    movsb
    movsb

    mov ax,$FF08
    mov dx,$3CE
    out dx,ax

    pop ds
  end;
end;

procedure HideShadow( X, Y: Integer );
var
  O: Word;
begin
  O:= CurOffset;
  if Y >= 0 then
  asm
    push ds
    les di,Screen
    lds si,Screen
    mov ax,Y
    shl ax,6
    mov di,ax
    shl ax,2
    add di,ax
    add di,X
    shr di,2
    mov si,di
    add di,word ptr [O]
    add si,32000
    mov ax,$F02
    mov dx,$3C4
    out dx,ax
    mov ax,$008
    mov dx,$3CE
    out dx,ax
    movsb
    movsb
    add di,78
    add si,78
    movsb
    movsb

    mov ax,$FF08
    mov dx,$3CE
    out dx,ax

    pop ds
  end;
end;

constructor TFLyingPoint.Init( AOrigin: TPoint3D; ASpeed: TPoint3D );
begin
  inherited Init(AOrigin);
  Speed := ASpeed;
  Valid := True;
  Show;
end;

procedure TFLyingPoint.Show;
begin
  Draw3D( Origin, White, @DrawPoint, @DrawShadow );
  OldPoint[CurPage] := LastPoint;
  OldShadow[CurPage] := LastShadow;
end;

procedure TFLyingPoint.Hide;
begin
  HidePoint( OldPoint[CurPage].X, OldPoint[CurPage].Y );
  HideShadow( OldShadow[CurPage].X, OldShadow[CurPage].Y );
end;

procedure TFLyingPoint.Update;
var
  Scale: Real;
begin
  Scale := 1;
  if Origin.Y + Speed.Y <= 0 then
  begin
    if Abs(Speed.Y) < Gravity then
    begin
      Valid := False;
      Exit;
    end;
    if Abs(Speed.Y) > 0 then
      Scale := 1 - Abs( (Origin.Y + Speed.Y) / Speed.Y );
    Speed.Y := Integer( Round( (-Speed.Y ) * ReflectionRatio ) );
  end;
  Speed.Y := Speed.Y - Integer(Round( Gravity*Scale) );

  Move( Speed );

  if (Origin.X < Min.X) or (Origin.X >= Max.X) or
     (Origin.Z < Min.Z) or (Origin.Z >= Max.Z) then
  begin
    Valid := False;
    Exit;
  end;
end;

constructor TPoints.Init( InitNumber: Integer );
begin
  inherited Init( initNumber, 10 );
  ToDelete.Init( 10, 1 );
end;

procedure TPoints.Update;

procedure UpdatePoint( P: PFlyingPoint );
begin
  P^.Update;
  if not P^.IsValid then
    ToDelete.Insert(P);
end;

var
  I: Integer;
  P: Pointer;
begin
{  CopyPage( 2, CurPage );}

  for I := Count downto 1 do
    TFlyingPoint(At(I-1)^).Hide;

  for I := Count downto 1 do
    UpdatePoint( At(I-1) );
  for I := Count downto 1 do
    TFlyingPoint(At(I-1)^).Show;
  FlipPage;
  for I := 1 to ToDelete.Count do
  begin
    P := ToDelete.At(I-1);
    Delete(P);
  end;
  ToDelete.FreeAll;
  Inc(Frames);
end;

function TFLyingPoint.IsValid: Boolean;
begin
  IsValid := Valid;
end;

end.
