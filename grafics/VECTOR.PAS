{  Vectorspaceship by Captain Headcrash
   be careful this program is verry
   dirty and not optimized but gives you
   an image of the power of TP

   Some of the code is ripped from various sources
   if you want to contact me, then write to:
   Dirk Hoeschen
   Fido:   2:245/114.1 or 2:2445/110.1
   Gernet: 21:100/2202 Gamenet: 144:4915/35}

{$N+,G+}
Program VectorShip;

Uses
  Crt,
  Dos;

Type
  LineY   = Array[0..199] Of Word;
  TabType = array[0..255] Of shortint;

Const
  Xc  = 0;
  Yc  = 0;
  Zc  = 300;
  NofPoints = 16;
  Nofpolys  =  7;
  Speed     : Integer = -3;
  PhiX      : Byte    = 0;
  Phiy      : Byte    = 0;
  Phiz      : Byte    = 0;
  WOff      : Word    = 0;
  ScrOff    : Word    = 0;
  Size      : Integer = 100;
  Point     : Array[0..NofPoints,0..2] Of Integer =
              (( 50 ,   0 , 0),  {front}
               (-50 ,  40 , 0),  {upper corner}
               (-50 , -40 , 0),  {lower Corner}
               (-60 ,   0 ,20),  {tail top}
               (-60 ,   0 ,-20), {tail down}
               ( 20 ,  41 , 0),
               (-60 ,  41 , 10),
               (-60 ,  41 ,-10),
               ( 20 , -41 , 0),
               (-60 , -41 , 10),
               (-60 , -41 ,-10),
               ( 30 ,  2 , 2),
               (-30 ,  2 ,14),
               (-20 , 20 , 2),
               ( 30 , -2,  3),
               (-30 , -2, 14),
               (-20 ,-20,  3));

  Polyst    : Array[0..Nofpolys+2,0..2] Of Byte = (
              (0,1,3),(0,2,3),  (0,1,4), (0,2,4),
              (1,3,4), (2,3,4), (5,6,7), (8,9,10),
              (11,12,13),(14,15,16));
  Polcols   : Array[0..Nofpolys+2] Of Byte =
              (16,17,18,19,20,21,22,23,24,25);
  Colors    : Array[0..Nofpolys+2,0..2] Of Byte =(
              ( 55 ,  15 , 40), {upper tail r}
              ( 50 ,  10 , 35), {upper tail l}
              ( 15 ,  45 , 35), {lower tail r}
              ( 10 ,  40 , 30), {lower tail l}
              ( 55 ,  10 ,  0), {motor r}
              ( 55 ,  10 ,  0), {motor l}
              ( 40 ,  50 , 50), {wing r}
              ( 40 ,  50 , 50), {wing l}
              ( 15 ,  35 , 55), {window r}
              ( 10 ,  30 , 50));{window l}
  BgndCols  : Array[0..9,0..2] Of Byte = (
              (40,50,63),(30,40,55),
              (20,30,45),(10,20,35),
              (10,15,30),(35,20, 0),
              (45,25,10),(55,35,15),
              (63,45,15),(63,55,20));
  Mcol      : Byte = 0;
  Mcol1     : Byte = 10;
  Puls      : Byte = 5;
  Puls1     : Byte = 5;

Var
  PInd      : Array[0..Nofpolys] Of Integer;
  Polyz     : Array[0..Nofpolys] Of Integer;
  Wx,
  lArray,
  SArray    : Word;
  I         : Integer;
  Ch        : Char;
  La        : ^LineY;
  SinTab    : TabType;

{---------------Init demo-----------------------------}

Procedure SetColor(Color, r, g, b: Byte); Assembler;

  Asm {set DAC Color}
    Mov  dx, 3C8h   {Color port}
    Mov  al, Color  {number Of Color to change}
    Out  dx, al
    Inc  dx         {Inc dx to write}
    Mov  al, r      {red value}
    Out  dx, al
    Mov  al, g      {green}
    Out  dx, al
    Mov  al, b      {blue}
    Out  dx, al

  End; {Write index now points to next Color}

{-----------------------------------------------------}

Procedure Calcsinus(var SinTab : TabType);

  Var I : Byte;

  Begin
    For I := 0 To 255 Do
      SinTab[I] := round(sin(2*I*pi/255)*127);
  End;

{---------------graphic stuff-------------------------}

Var
  Color      : Byte;
  CrtcPort   : Word;       {Crt controller}
  OldMode    : Byte;
  Input1Port : Word;       {Crtc Input Status Reg #1=CrtcPort+6}

Const
  seqPort  = $3C4;         {Sequencer}
  gcPort   = $3CE;         {Graphics Controller}
  attrPort = $3C0;         {attribute Controller}
  xRes     = 320;
  yRes     = 200;          {displayed screen Size}
  vxRes    = 640;          {Vitual xres For scrolling etc}
  vSeg     = $A000;        {video segment}
  vxBytes  = vxRes div 4;  {Bytes per virtual scan line}


{-----------------------------------------------------}

Procedure GraphBegin; {Switch To 4frame mode}

  Var
    I, J,
    K, L  : Byte;

  Begin
    CrtcPort   := MemW[$40 : $63];
    Input1Port := CrtcPort + 6;
    Asm
      Mov   Ah, $000f
      Int   $10
      Mov   OldMode,al     {get old mode}
      Mov   AX,0013h       {Use Bios To switch mode 13h }
      Int   10h            {(=320x200x256)}
      Mov   DX,SeqPort     {get sequencerport and}
      Mov   AL,04h         {select memorymode-register}
      Out   DX,AL          {and Do it}
      Inc   DX             {Inc To readport}
      In    AL,DX          {read memorymode}
      And   AL,011110111b  {Bit 3:=0:4 planes Do not chaIn}
      Or    AL,000000100b  {Bit 2:=1:no odd/even-mechan.}
      Out   DX,AL          {write value}
      Dec   DX             {back To sequenzer-register }
      Mov   AX,0F02h       {(=Map-Mask) 11}
      Out   DX,AX          {select..}
                           {;...allow access To al 4 bitmaps}
      Mov   AX,Vseg        {Segment $A000 allows direct acces}
      Mov   ES,AX          {write To ES}
      Xor   DI,DI          {DI=0 BegInIng Of the plane}
      Xor   AX,AX          {AX=0 To clear screen}
      Mov   CX,08000h      {8000h Words To clear vga-mem}
      Cld                  {clear direction flag}
      RepNZ SToSW          {write AX To ES:DI / Inc DI / Dec CX
                            And repeat until CX=0}
      Mov   DX,3D4h        {CRT-Controller}
      Mov   AL,14h         {UnderlIne-location-Register}
      Out   DX,AL          {activate}
      Inc   DX             {Inc To DatapOrt}
      In    AL,DX          {read DatapOrt}
      And   AL,010111111b  {Bit 6:=0: no dubbleWord-}
      Out   DX,AL          {adressIng}
      Dec   DX
      Mov   AL,017h        {Mode-control-register}
      Out   DX,AL
      Inc   DX
      In    AL,DX
      Or    AL,01000000b   {Bit 6:=1: To access the whole}
      Out   DX,AL          {memOry lInear}
      Mov   DX,3D4h        {CRT-Controller}
      Mov   ax, vxBytes    {virtual xSize In Bytes}
      Shr   ax, 1          {Words per scan lIne}
      Mov   ah, al         {copy To hiByte}
      Mov   al, $13        {13h ScreenSizeOffset reg}
      Out   dx, ax         {set CrtC Offset reg}
    End;
  End;

{-----------------------------------------------------}

Procedure GraphEnd; Assembler;

  Asm
    Mov al, OldMode
    Mov ah, 0
    Int $10
  End;

{-----------------------------------------------------}

Procedure SetWindow(X, Y : Integer); Assembler;

  Asm
    Mov  ax, vxBytes
    Mul  y
    Mov  bx, x
    Mov  cl, bl
    Shr  bx, 2
    Add  bx, ax    {bx=Ofs Of upper left cOrner}
    Mov  dx, Input1POrt
   @L:
    In   al, dx
    Test al, 8
    Jnz  @L        {wait For no v retrace}
    Sub  dx, 6     {CrtC pOrt}
    Mov  al, $D
    Mov  ah, bl
    Cli            {these values are sampled at start Of retrace}
    Out  dx, ax    {lo Byte Of display start Addr}
    Dec  al
    Mov  ah, bh
    Out  dx, ax    {hi Byte}
    Sti
    Add  dx, 6
   @L2:
    In   al, dx
    Test al, 8
    Jz   @L2       {wait For v retrace}
                   {this also resets Attrib flip/flop}
    Mov  dx, attrPOrt
    Mov  al, $33
    Out  dx, al    {Select Pixel Pan Register}
    And  cl, 3
    Mov  al, cl
    Shl  al, 1
    Out  dx, al    {Shift is For 256 ColOr Mode}
End;

{-----------------------------------------------------}

Procedure WaitRetrace; Assembler;

  Asm
    Mov  dx, CrtcPOrt
    Add  dx, 6 {fInd Crt status reg (Input pOrt #1)}
   @L1:
    In   al, dx
    Test al, 8
    Jnz  @L1;  {wait For no v retrace}
   @L2:
    In   al, dx
    Test al, 8
    Jz   @L2 {wait For v retrace}
  End;

{-----------------------------------------------------}

Procedure ClearScreen(ScrOff: Word);

  Const
    Diffs     : Array[0..9] Of Word =
                ( 45,35,20,15,10,5,10,15,20,25);

  Var
    DiffPoint : PoInter;

  Begin
    DiffPoint := Addr(diffs);
    Asm
      Mov     DX,SeqPOrt
      Mov     AX,00F02h     {activate all 4 frames}
      Out     DX,AX
      Mov     AX,Vseg       {a000h= Begin Of videopage}
      Mov     ES,AX
      Mov     DI,ScrOff     {Add Ofset To di}
      Lds     si,DiffPoint  {poInts To an list with the Sizes
                             Of the ColOrbars}
      Mov     Ax,01E1Eh     {first BGNDColOr=30}
      Mov     CX,10         {ten ColOrs at all}

     @NextColOr:

      Push    CX            {save cx}
      Mov     CX,DS:[si]    {number Of lInes}
      Add     SI,2          {Inc si}

     @NextLIne:

      Push    CX
      Mov     CX,40         {Words per lIne / 4 }
      Cld
      Rep     Stosw         {fill lIne with ax}
      Add     DI,VxBytes-80 {Add 80 bcause Of vxSize=640}
      Pop     CX
      Loop   @NextLIne
      Inc     Al            {next ColOr}
      Inc     Ah
      Cld
      Pop     CX
      Loop   @NextColOr
    End;
  End;

{-----------------------------------------------------}

Procedure HLin(x, x2, y : Integer); Assembler;

  Asm
    Mov   ax, vSeg     {A000 nach AX}
    Mov   es, ax       {Adresssegment nach ES}
    Cld                {Richtungsflag lîschen}
    Mov   ax, vxBytes  {Anzahl der Bytes In x-richtung}
    Mul   y            {Multipliziert mit y}
    Mov   di, ax       {base Of scan lIne}
    Mov   bx, x        {X nach BX}
    Mov   dx, x2       {X2 nach DX}
    Sub   dx, bx       {Breite In Bytes x2-x}
    Jns  @bigger       {ist x2 > X}
    Mov   bx, x2       {X2 nach BX}
    Mov   dx, x        {X  nach DX}
    Jmp  @lower

   @bigger:

    Mov   dx, x2       {X2 nach DX}

   @lower:

    Mov   cl, bl       {veschieben nach lowByte CX}
    Shr   bx, 2        {durch 4 teilen 1Punkt 4 Planes}
    Mov   ch, dl       {verschieben nach hiByte cx}
    Shr   dx, 2        {durch 4 teilen}
    Sub   dx, bx       {Breite In Bytes x2-x}
    And   cx, $0303    {Jeweils die ersten 2 Bit HI und low Ausmaskieren}
    Add   di, bx       {ZeileNoffset auf DI}
    Mov   ax, $FF02    {HiByte fÅllen lowByte bit 1 setzen}
    Shl   ah, cl       {hiByte um anfangsOffset shiften}
    And   ah, $0F      {lInken RAnd ausmaskieren}
    Mov   cl, ch       {rechter Offset nach cl}
    Mov   bh, $F1      {11110001 nach Bh}
    Rol   bh, cl       {Rollen im HiByte um ch}
    And   bh, $0F      {rechten rAnd ausmaskieren}
    Mov   cx, dx       {breite In Bytes nach cx}
    Or    cx, cx       {was soll das denn?}
    Jnz  @LEFT         {achso Testen auf null}
    And   ah, bh       {KombIniere lInke & rechte bitmaske}

   @Left:

    Mov   dx, seqPOrt  {AuswahlpOrt fuer die planes}
    Out   dx, ax       {planes auswaehlen}
    Inc   dx           {nach schreibpOrt erhoehen 3d5}
    Mov   al, ColOr    {farbe nach al}
    Stosb              {und lInken rAnd schreiben}
    Jcxz @Exit         {wenn cx null ist dann abbrechen}
    Dec   cx           {ansonsten Decrementieren}
    Jcxz @RIGHT        {wenn null, dann rechte seite schreiben}
    Mov   al, $0F      {00001111 alle planes auswaehlen}
    Out   dx, al       {skipped if cx=0,1}
    Mov   al, ColOr    {Farbe nach al}
    Repz  Stosb        {mittlere Bytes schreiben jeweils 4 Punkte}

   @Right:

    Mov   al, bh       {rechte maske nach al}
    Out   dx, al       {skipped if cx=0}
    Mov   al, ColOr    {Farbe nach al}
    Stosb              {rechte maske schreiben}

   @Exit:
  End;

{------------------------------------------------------------}

Procedure DoFill;

  Const
    Xstep   = -3;
    Ystep   = 1;
    Zstep   = -2;

  Var
    s,pc, d        : Integer;
    polyx,polyy    : Array[0..2] Of Word;
    px,py,pz       : Array[0..NofPoInts] Of Word;
    X,Y,Z,X1,Y1,Z1 : Integer;

{--------------------- FillRoutines -------------------------}

Procedure Fillpoly;

  {-----------------------------------------------------}

  Procedure Fline(x,y,x2,y2:Word);

    Var d,dx,dy,ai,bi,xi,yi:Integer;

    Begin
      If(x<x2) Then
        Begin
          xi := 1;
          dx := x2-x;
        End
      Else
        Begin
          xi := -1;
          dx := x-x2;
        End;
      yi     := 1;
      dy     := y2-y;
      la^[y] :=x;      {whenever y changes write xvalue To la[y]}
      If dx > dy Then
        Begin
          ai := (dy-dx) * 2;
          bi := dy Shl 1;
          d  := bi-dx;
          Repeat
            If (d >= 0) Then
              Begin
                Inc(y,yi);
                Inc(d,ai);
                la^[y] := x;
              End
            Else
              Inc(d,bi);
            Inc(x,xi);
          Until (x = x2);
        End
          Else
            Begin
              ai := (dx-dy) * 2;
              bi := dx Shl 1;
              d  := bi-dy;
              Repeat
                If (d >= 0) Then
                  Begin
                    Inc(x,xi);
                    Inc(d,ai);
                  End
                Else
                  Inc(d,bi);
                Inc(y,yi);
                la^[y] := x;  {diTo}
              Until(y=y2);
            End;
    End;

  {-----------------------------------------------------}

  Procedure lInefill(x,y,x2,y2:Word);

    Var
      d,dx,dy,ai,bi,xi,yi : Integer;

    Begin
      If (x < x2) Then
        Begin
          xi := 1;
          dx := x2-x;
        End
      Else
        Begin
          xi := -1;
          dx := x-x2;
        End;
      yi := 1;
      dy := y2-y;
      If dx > dy Then
        Begin
          ai := (dy - dx) * 2;
          bi := dy Shl 1;
          d  := bi-dx;
          While x <> x2 Do
            Begin
              Repeat
                If (d >= 0) Then
                  Begin
                    Inc(y,yi);
                    Inc(d,ai);
                    HLin(x,la^[y],y); {Whenever y changes draw hlIne on from
                                           x To la^[y]}
                  End
                Else
                  Inc(d,bi);
                Inc(x,xi);
              Until x = x2;
            End;
        End
      Else
        Begin
          ai := (dx - dy) * 2;
          bi := dx Shl 1;
          d  := bi - dy;
          While y <> Y2 Do
            Begin
              Repeat
                If (d >= 0) Then
                  Begin
                    Inc(x,xi);
                    Inc(d,ai);
                  End
                Else
                  Inc(d,bi);
                Inc(y,yi);
                HLin(x,la^[y],y); {diTo}
              Until y = y2;
            End;
        End;
    End;

  {-----------------------------------------------------}

  Begin
    Color     := PolCols[pc];
    PolyY[0]  := py[polyst[pc,0]];
    PolyX[0]  := px[polyst[pc,0]];
    PolyY[1]  := py[polyst[pc,1]];
    PolyX[1]  := px[polyst[pc,1]];
    PolyY[2]  := py[polyst[pc,2]];
    PolyX[2]  := px[polyst[pc,2]];

   {Sort PolyY. PolyY[0] must be the highest Point}
   {Ployy[2] the lowest}

    If PolyY[0]>PolyY[1] Then
      Begin
        s        := PolyY[1];
        PolyY[1] := PolyY[0];
        PolyY[0] := s;
        s        := PolyX[1];
        PolyX[1] := PolyX[0];
        PolyX[0] := s;
      End;
    If PolyY[2] < PolyY[0] Then
      Begin
        s        := PolyY[2];
        PolyY[2] := PolyY[1];
        PolyY[1] := PolyY[0];
        PolyY[0] := s;
        s        := PolyX[2];
        PolyX[2] := PolyX[1];
        PolyX[1] := PolyX[0];
        PolyX[0] := s;
      End
    Else
      If PolyY[2] < PolyY[1] Then
        Begin
          s        := PolyY[1];
          PolyY[1] := PolyY[2];
          PolyY[2] := s;
          s        := PolyX[1];
          PolyX[1] := PolyX[2];
          PolyX[2] := s;
        End;

    {Calculate a lIne from the highest To the lowest Point}
    
    FLine(PolyX[0], PolyY[0], PolyX[2], PolyY[2]);

    {the xvalues Of the first lIne are now In la[y]}

    {calculate the second lIne And fill}

    LineFill(PolyX[0], PolyY[0], PolyX[1], PolyY[1]);

    {we only use triangles}

    LineFill(PolyX[1], PolyY[1], PolyX[2], PolyY[2]);
  End;

{-----------------------------------------------------}

Procedure Motor;

  Begin
    Mcol  := Mcol + Puls;
    If (Mcol = 65) Or (Mcol = 0) Then
      Puls  := -Puls;
    Mcol1   := Mcol1 + Puls1;
    If (Mcol1 = 65) Or (Mcol1 = 0) Then
      Puls1 := -Puls1;
    SetColor(20, Mcol, 10, 10);
    SetColor(21, Mcol1, 10, 10);
  End;

{-----------------------------------------------------}

Function Sinus(Idx : Byte) : Integer;

  Begin
    Sinus := SinTab[Idx];
  End;

{-----------------------------------------------------}

Function CoSinus(Idx : Byte) : Integer;

  Begin
    CoSinus := SinTab[(Idx+192) Mod 255];
  End;

{-----------------------------------------------------}

{Yeah this is the normal quickSort example from TP.
 there is no faster way To Sort an Array}

Procedure QuickSort(Lo, Hi: Integer);

  {-----------------------------------------------------}

  Procedure Sort(l, r: Integer);

    Var
      i, j, x, y: Integer;

    Begin
      i := l;
      j := r;
      x := PolyZ[(l+r) Div 2];
      Repeat
        While PolyZ[i] < x Do
          i := i + 1;
        While x < PolyZ[j] Do
          j := j - 1;
        If i <= j Then
          Begin
            y        := PolyZ[i];
            PolyZ[i] := PolyZ[j];
            PolyZ[j] := y;
            y        := Pind[i];
            Pind[i]  := Pind[j];
            Pind[j]  := y;
            i        := i + 1;
            j        := j - 1;
          End;
      Until i > j;
      If l < j Then
        Sort(l, j);
      If i < r Then
        Sort(i, r);
    End;

  {-----------------------------------------------------}
  
  Begin {QuickSort};
    Sort(Lo,Hi);
  End;

{--------------------MainLoop------------------------------}

Begin
  Repeat
    Color  := 0;

    SetWindow(0,WOff);           {always draw To a virtual screen}
    WOff   := 200 - WOff;        {flip window}
    ScrOff := $7d00 - ScrOff;    {flip screeNofset}

    ClearScreen(ScrOff);         {clear screen And mke lAndscape}

    {SetColor(0,40,40,40);}

    For I := 0 To NofPoints Do
      Begin
         X1    := (CoSinus(PhiY)*Point[I,0]-Sinus(PhiY)*Point[I,2]) div 128;
         Y1    := (CoSinus(PhiZ)*Point[I,1]-Sinus(PhiZ)*X1) div 128;
         Z1    := (CoSinus(PhiY)*Point[I,2]+Sinus(PhiY)*Point[I,0]) div 128;
         X     := (CoSinus(PhiZ)*X1+Sinus(PhiZ)*Point[I,1]) div 128;
         Y     := (CoSinus(PhiX)*Y1+Sinus(PhiX)*Z1) div 128;
         Z     := (CoSinus(Phix)*Z1-Sinus(Phix)*Y1) div 128;
         PX[I] := 160+(Xc*Z-X*Size) div (Z-Zc) ; {sTOre py}
         PY[I] := 100+wOff+(Yc*Z-Y*Size) div (Z-Zc);{sTOre px}
         PZ[I] := Z;{sTOre pz}
      End;

    For I:=0 To Nofpolys Do
      Begin
        PolyZ[I]  := pz[polyst[i,0]];          {Add the zvalues Of}
        PolyZ[I]  := PolyZ[i]+pz[polyst[i,1]]; {the the Points Of }
        PolyZ[I]  := PolyZ[i]+pz[polyst[i,2]]; {the triangle}
        Pind[I]   := I;                        {Index To Point To Polygons}
      End;

    QuickSort(0, Nofpolys);        {Sort the z-values Of the polygones
                                     the farest triangle must be drawn first}

    Motor;                         {change the Color Of the backtail}

    Inc(Phix,xstep);               {Rotate the axis}
    Inc(Phiy,ystep);
    Inc(PhiZ,Zstep);
    d  := 2;                  {you Dont need To draw the farest two polygons}
    WaitRetrace;              {wait For retrace To sync 35fps
                               else it's flickerIng reMove if
                               you have a slow VGA card}
    pc := Pind[0];
    If (pc = 6) Or (pc = 7) Then
      FillPoly;                      {the wings are allways visible}

    pc := Pind[1];
    If (pc = 6) Or (pc = 7) Then
      Begin
        FillPoly;
        Inc(d);           {if Pind[1] is a wIng you can flip another polygon}
      End;

    For i := d To Nofpolys Do
      Begin
        pc  := Pind[i];
        FillPoly;
        If pc < 2 Then
          Begin                        {0 And 1 are the Toptail}
            pc  := NofPolys + 1 + pc;  {draw the wInDows}
            FillPoly;
          End;
      End;
    Inc(Size,Speed);
    if (Size > 400) Or (Size<50) Then
      Speed := -Speed;

    {SetColor(0,0,0,0);}

  Until POrt[$60]=1;
End;
      
{--------------------Main--------------------------------}

Begin
  GraphBegin;
  CalcSinus(SinTab);
  For I := 0 To NofPolys + 2 Do
    SetColor(PolCols[i], Colors[i,0], Colors[i,1], Colors[i,2]);
  For I := 0 To 9 Do
    SetColor(i+30, BgndCols[i,0], BgndCols[i,1], BgndCols[i,2]);
  New(La); {La is an Array[0..199] YSize 200LInes}
  DoFill;
  Dispose(La);
  GraphEnd;
End.
