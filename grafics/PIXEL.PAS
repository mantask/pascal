(******************************************************************
 tGraphix : Copyright (C) 1994, Simple Minded Software
 purpose  : simple pixel graphics routines in *TEXTMODE*.
 Author   : Eric Coolman, Simple Minded Software.
 Compiler : Turbo Pascal 6.

 Permission is granted for modification, use, and distribution
 of this source code for NON-COMMERCIAL (including shareware)
 use, provided proper credit is given where due.  USE AT OWN RISK!

 [NOTES:]
 - I haven't implemented many error checks in here yet -- too much
   work just doing this conversion, so I will leave the rest for
   you guys to do :-).
 - Error checking needed is EGA/VGA, (only set up for VGA right
   now), char maps selected (only allow 0-3 on an EGA, and 0-7 on
   VGA, not available on monochrome/mda).  Check the colours used
   for the gWindow - allow only hi-intense colours (8-15) since
   it will be the second character map, and the gfx won't display
   with the lo-intense (which will be our text map).  There are
   more, but my brain refuses to remember them.
 - active map (gfxMap) and work map (wMap) are started, but not
   completely implemented yet... hint, hint <G>
 - unless you load a font into one of the 8 character tables, do
   not use anything but 0 for your text map for now.
 - routines not completely written by me (circle/line) have been
   properly credited in the function/procedure comments below.
 - please don't laugh at my code... I'm a C/C++/ASM programmer by
   choice (but I'm flexible... so no flaming either <G>)
 - I can be reached here (Fidonet Pascal, C, C++, ASM conferences)
   or at eric.coolman@onlinesys.com.  Comments appreciated.  I
   am curious to see what you guys can come up with, and may post
   more effects if I get some good feedback :-).
******************************************************************)
program tGraphix;

const
     vidBase = $B800;
     fontBase= $A000;  { address of bitplane 2, where character }
                                               { maps are store }
var
     lasterr : byte;
     bpAccess,            { current access status to bitplane 2 }
     hadAccess : boolean; { previous access "" study to see why }
     textMap, gfxMap,         { character map currently set for }
                                           { text, and graphics }
     wMap     : byte;    { work map... use this and gfxMap just }
    { like active page and visable page in bgi graphics mode... }
    { you see gfxMap on screen, but work on wMap.  If wMap and  }
    { gfxMap are the same, you will work on and see both.       }
     xMax, yMax,                       { max pixel co-ordinates }
     fontOfs     : word;        { offset to work map from $a000 }

(*********************************************************************
 Get or release access to bitplane 2, where the character maps are
 stored ($A000:0000 - $A000:FFFF).
 Input : True for access to bitplane 2, where char maps are stored
 Notes : -Most of the procedures are set up to call this automatically
         but only when it needs to.  This is the routines that causes
         the flicker when switching between text and gfx mode, so
         try an limit how often you use it.
         -make sure you call this with FALSE before you do any text
         writing, and ESPECIALLY when you exit to DOS or you'll crash
*********************************************************************)
procedure FontAccess( Accessible : boolean );
begin
  asm
    push ax
    push dx
    cli

    { -- EgaVga sequencer -- }
    mov dx, 3c4h

    mov ax, 0100h
  @1:
    out dx, ax
    mov ax, 0302h
    cmp Accessible, True
    jnz @2
    inc ah          { 0402h if accessible }
  @2:
    out dx, ax
    mov ax, 0304h
    cmp Accessible, True
    jnz @3
    add ah, 04h     { 0704h if accessible }
  @3:
    out dx, ax
    mov ax, 0300h
    out dx, ax
    { -- Graphics Controller -- }
    mov dx, 3ceh

    mov ax, 0004h
    cmp Accessible, True
    jnz @4
    add ah, 02h     { 0204h if accessible }
  @4:
    out dx, ax
    mov ax, 0005h
    cmp Accessible, True
    jz @5
    add ah, 10h    { 1005h if *NOT* accessible }
  @5:
    out dx, ax
    mov ax, 0006h
    cmp Accessible, True
    jz @6
    add ah, 0eh    { 0e06h if *NOT* accessible }
  @6:
    out dx, ax

    sti
    pop  dx
    pop  ax
  end;
  bpAccess := Accessible;
end;

(*********************************************************************
 Clears a whole character map (sets all bits to zero).
 Input : character map to clear (0 - 7).
 NOTES  -This routine is set up for VGA 16 scanline text only
        -do NOT (unless intended) clear your text map (normally 0)
         or you won't be able to see any of your normal text.
*********************************************************************)
procedure ClearMap( map : byte);
var
  chLine, ascCode : byte;
begin
  hadAccess := bpAccess;
  { $2000 = 8192d = 32 lines * 256 chars = 1 table -- see note about }
                                  { table layout in previous message }
  fontOfs   := map * ($2000 * 2);
  if ( map >= 4 ) then
    inc( fontOfs, $2000 );          { See note about table layout... }
  if not hadAccess then            { Q.. do we have bitplane access? }
     FontAccess(True);                        { A.. no, then get it! }
  for ascCode := 0 to 255 do               { each char of entire set }
    for chLine := 0 to 15 do            { from top to bottom of char }
      mem[fontBase:fontOfs+(ascCode*32)+chLine] := 0;     { clear it }
  if not hadAccess then           { Q.. did we have bitplane access? }
     FontAccess(False);                  { A.. no, so release access }
end;

(*********************************************************************
 This routine will get rid of that nasty ugly 9th bit used on the
 VGA video card.  This allows us to connect our graphic characters.
 I was meaning to send this routine to Darrell Stewart because I saw
 his question in Swag packets asking how to do this... so here ya go
 Darrell :-)
 Input : either True or False - no VGA detection, so don't call with
         False on an EGA, etc.
**********************************************************************)
procedure deleteBit9( clearit : boolean ); assembler;
asm
    push bx
    push ax
    push cx
    push dx

    mov dx, 03cch             { 3cch = Miscellaneous output register }
    in  al, dx
    and al, 0f3h                        { mask all bits except 2 & 3 }
    cmp clearit, True
    jz  @width8
    or  al, 04h    { set bit 2 (720 horizontal pixels -> 28.322 MHz) }
                   { (for 8 wide -- 640 horiz. pixels -> 25.175 MHz) }
    mov bx, 0800h        { BH = 08h = pixel to pan to, to set normal }
                                                            { offset }
                           { BL = 00h = gen 8 pixels per clock cycle }
    jmp @setRes        { why wouldn't "short" asm keyword work here? }
 @width8:
    mov bx, 0001h  { BH = 00h = pixel to pan to, to move screen left }
                           { BL = 01h = gen 9 pixels per clock cycle }
 @setRes:
    mov dx, 3c2h           { Toggle horiz. res. -- 720 or 640 pixels }
                                                       { (see above) }
    out dx, al

    cli

    mov dx, 3c4h                    { Sequence controller index port }
    mov ax, 0100h             { AL = 00h = Sequence controller reset }
                                        { AH = 01h = (Bit 0) reset 1 }
    out dx, ax

    mov al, 01h                             { Clocking mode register }
    mov ah, bl
    out dx, ax

    mov ax, 0300h     { 00h = SeqCtrl reset, 03h = reset 1/2 without }
                                           { reseting character maps }
    out dx, ax

    sti

    mov ax, 1000h                { Change horizontal screen position }
    mov bl, 13h
    int 10h

    pop dx
    pop cx
    pop ax
    pop bx
end;

(*********************************************************************
  Sets your primary (text) and secondary (graphics) character map.
  Input : pMap - character map to use for text (0 - 7).
          sMap - "                  " graphics (0 - 7).
  NOTES - if pMap is an even number, sMap must be odd, and vice versa.
        - You can use this for displaying 2 fonts at the same time
          also.  Just load a font into pMap and sMap, and call this
          routine.
*********************************************************************)
procedure SetMaps(pMap, sMap : byte);
begin
  textMap := pMap;
  { gfxMap  := wMap := sMap;         { <- this doesn't work huh? <G> }
  gfxMap := sMap;
  wMap   := sMap;

  asm
      push ax
      push bx
      push cx

      mov al, pMap                              { set up BL register }
      and al, 03h
      mov ah, pMap
      and ah, 04h
      mov cl, 02h
      shl ah, cl
      or  al, ah
      mov ah, sMap
      and ah, 03h
      shl ah, cl
      or al, ah
      mov ah, sMap
      and ah, 04h
      inc cl
      shl ah, cl
      or al, ah
      xchg al, bl

      mov ax, 1103h
      int 10h

      pop cx
      pop bx
      pop ax
  end
end;

(*********************************************************************
 This uses direct screen writes, and will allow me to print out
 control characters, including nul.  It also takes into account
 the current video page I am on (mem[$40:$4E] is vid offset)
 Input : col - column to write char at   (1-80)
         row - row to write character at (1-25)
         fClr- foreground colour of character
         bClr- background colour of character
         ch  - character to write.
*********************************************************************)
procedure putChAt(col, row, fClr, bClr, ch : byte);
var
    rowWid   : byte;
    vidOfs   : word;
begin
   hadAccess := bpAccess;
   if hadAccess then
       FontAccess(False);
   rowWid  := mem[$40:$4A]*2;                         { normally 160 }
   vidOfs  := mem[$40:$4E]+((row-1)*rowWid)+((col-1)*2);

   mem[vidBase:vidOfs] := ch;         { Write character to video RAM }
   mem[vidBase:vidOfs+1] := fclr+(bclr shl 4);
                                      { Write attribute to video RAM }
   if hadAccess then
       FontAccess(True);
end;

(*********************************************************************
 This initializes an area on screen for you to draw your graphics in.
 It sets up the co-ordinates for the other routines as well, so it
 must be called before any other graphics routines (unless you use
 the InitGfx() function below).
 Input : x1, y1 - top left most corner of the window
         xLen   - width of the window
         yLen   - height of the window
         fClr   - colour of set pixels   (foreground colour)
         bClr   - colour of unset pixels (background colour)

 NOTE : Co-ordinates must be passed in CHARACTERS (not pixels).
*********************************************************************)
Function gWindow(x1, y1, xLen, yLen, fClr, bClr : byte) : byte;
var
    curCh, curX, curY : byte;
    maxChars          : word;
begin
    curCh     := 0;                                { cur ascii code }
    hadAccess := bpAccess;
    maxChars  := (xLen * yLen);
    if ( maxChars > 256 ) then
        gWindow := 1        { window too big -- req's too many chars }
    else
      begin
        deleteBit9( True );
        xMax := xLen * 8;                           { 8 = font width }
        yMax := yLen * 16;                        { 16 = font Height }
        if not hadAccess then
            FontAccess(True);

        ClearMap(gfxMap);
        if(wMap <> gfxMap) then
            ClearMap(wMap);

        { SetMaps(textMap, gfxMap); }
        FontAccess(False);

        for curY := y1 to y1+yLen-1 do          { show the character }
          for curX := x1 to x1+xLen-1 do         { set on the screen }
            begin
              putChAt( curX, curY, fClr, bClr, curCh);
              inc(curCh);
            end;
        gWindow := 0;                                    { no errors }
    end
end;

(*********************************************************************
  Just as in graphics, this sets a pixel on or off, but does not do
  colour (textmode limitation <G>).  If you want to set a pixel to a
  colour, you will need to write a char in that colour to the location
  of the pixel, but it will also colour the pixels to the left and/or
  right and above below it (8 x 16 pixels), and you are also limited
  to colours 0-7 if an even graphics map, or 8-15 for an odd gfx map.
  Input : xPos in pixels from left of window.
          yPos in pixels from top of window.
          True to turn the pixel on, False to turn it off.
*********************************************************************)
function setPixel(xPos, yPos : integer; TurnOn : boolean ) : byte;
var
    chrCode,                      { ASCII code we will be re-defining }
    lineMask,         { current bit settings of line to be re-defined }
    newLine,                          { changed line (with pixel set) }
    chrLine  : byte;  { line offset from 0 of current char "      "   }
    lineOfs  : word; { ofs of font line where pixel occurs from $a000 }
begin
    hadAccess := bpAccess;

    if ( ( xPos >= xMax ) or ( yPos >= yMax) ) then  { out of bounds? }
        setPixel := 1
    else
      begin                                { 8&16=VGA font dimensions }
        chrCode := ( (xPos div 8) + yPos div 16 * (xMax div 8) );
        chrLine := (yPos mod 16);
                                { 32 = max allowable height of a char }
        lineOfs := fontOfs + chrCode * 32 + chrLine;
        if not hadAccess then        { Q.. have access to bitplane 2? }
            FontAccess(True);                  { A.. No?  Then get it }
        lineMask:= mem[fontBase:lineOfs];

        if TurnOn then
             newLine := lineMask OR ( 128 shr (xPos mod 8) )
        else
             newLine := lineMask AND not ( 128 shr (xPos mod 8) );
        mem[fontBase:lineOfs] := newLine;

        if not hadAccess then
            FontAccess(False);

        setPixel := 0;                                    { no errors }
      end;
end;

(**********************************************************************
 Bresenham circle and lines...this code was originally written by Brian
 Dessent and posted in the Fidonet C echo. It was then modified for
 portability by Bob Stout and distributed with "C Snippets".  It was
 then modified by me (Eric Coolman) for use with my C++ tgfx library,
 and then I converted it to Pascal for this little demo <whew!>.
 Input : xCtr   - center horizontal value for circle
         yCtr   - center vertical value for circle
         rad    - radius (center to edge) of circle
         turnon - True to draw and False to delete circle
**********************************************************************)
procedure Circle( xCtr, yCtr, rad : word; TurnOn : boolean );
var
    x, y, d   : integer;
begin
  x := 0;
  y := rad;
  d := 2 * (1 - rad);
  hadAccess := bpAccess;

  if not hadAccess then
      FontAccess(True);

  while (y >= 0) do
    begin
      lasterr := setPixel(xCtr + x, yCtr + y, TurnOn);
      lasterr := setPixel(xCtr + x, yCtr - y, TurnOn);
      lasterr := setPixel(xCtr - x, yCtr + y, TurnOn);
      lasterr := setPixel(xCtr - x, yCtr - y, TurnOn);
      if (d + y > 0) then
        begin
          y := y - 1;
          d := d - (2 * y * xMax div yMax) - 1;
        end;
      if (x > d) then
        begin
          x := x + 1;
          d := d + (2 * x) + 1;
        end
    end;

 if not hadAccess then
     FontAccess(False);
end;

(**********************************************************************
 Bresenham line drawing routine.  See above for credits and add Sean
 Palmer's name to list since I used his line routine for reference
 (Pascal's ABS() doesn't quite work like C's... had me stumped <G>)
 Input : x, y   - top left pixel co-ordinates for line
         x2, y2 - bottom left co-ordinates for line
         turnon - True to draw line, False to erase it.
**********************************************************************)
procedure line(x, y, x2, y2 : word; TurnOn : boolean);
var
     i, sx, sy, dx, dy, e : integer;
     steep                : boolean;

begin
     steep     := False;
     hadAccess := bpAccess;
     if x2 > x then
       begin
         sx := 1;
         dx := x2 - x;
       end
     else
       begin
         sx := -1;
         dx := x-x2;
       end;
     if y2 > y then
       begin
         sy := 1;
         dy := y2 - y;
       end
     else
       begin
         sy := -1;
         dy := y - y2;
       end;

     if dy > dx then
       begin
         steep := True;
         x  := x XOR y;  { swap x and y }
         y  := y XOR x;
         x  := x XOR y;
         dx := dx XOR dy; { swap dx and dy }
         dy := dy XOR dx;
         dx := dx XOR dy;
         sx := sx XOR sy; { swap sx and sy }
         sy := sy XOR sx;
         sx := sx XOR sy;
      end;

      e := 2 * dy - dx;
      if not hadAccess then
          FontAccess(True);
      for i := 0 to (dx-1) do
        begin
          if steep then
              lasterr := setPixel(y, x, TurnOn)
          else
              lasterr := setPixel(x, y, TurnOn);

          while e >= 0 do
            begin
              y := y + sy;
              e := e - 2 * dx;
            end;

          x := x + sx;
          e := e + 2 * dy;
        end;
    lasterr := setPixel(x2, y2, TurnOn);
    if not hadAccess then
        FontAccess(False);
end;

(*********************************************************************
 This basically does the same thing as ClearMap, but will get bitplane
 access if you don't already have it, release it if needed when done,
 and is only for use with the visable graphics map.
*********************************************************************)
procedure clearWindow;
begin
    hadAccess := bpAccess;
    if not bpAccess then
        FontAccess(True);
    clearMap(gfxMap);
    if not bpAccess then
        FontAccess(False);
end;

{ grabs and dumps keypress...returns 1 if a key was hit, else 0 }
function KbGrab : boolean;
var
    WasHit : boolean;
begin
    WasHit := False;

    asm
        mov ax, 0100h
        int 16h
        lahf
        test ah, 40h
        jnz @done
        inc WasHit
        mov ax, 0000h       { grab the key they hit .... }
        int 16h
      @done:
    end;
    KbGrab := WasHit;
end;

(*********************************************************************
  This is a cheezy version of my horizontal starfield.  I like my C++
  one much better... will probably work on this a bit more later.
*********************************************************************)
procedure StarField;
type
    pixTable = array[0..201] of word;
var
    numStars,                                    { for current level }
    multiplier, curStar : word;
    level, x            : byte;
    totalStars  : word;
    starTable   : pixTable;
begin
  hadAccess  := bpAccess;
  if not hadAccess then
      fontAccess(True);
  totalStars := 100;

  { set up our star lookup table... }
  for x := 0 to totalStars do
    begin
      starTable[x * 2] := random(xMax - 1);
      starTable[x * 2 + 1] := random(yMax - 1);
    end;

  multiplier := (totalStars div 10);
  repeat
  curStar := 0;   { of total }

  for level := 4 downto 0 do
    begin
      numStars := curStar + (level * multiplier);
      for curStar := curStar to (numStars - 1) do
        begin
          { erase old star position before changing it }
          lasterr :=
          setPixel(starTable[curStar*2],starTable[curStar*2+1],False);
          { add velocity & direction to our star }
          starTable[curStar*2] := (starTable[curStar*2] + (level))
                                  mod (xMax - 1);
          lasterr := setPixel(starTable[curStar*2],
                              starTable[curStar*2+1], True);
        end;
      end;
  while ( (port[$3da] and $08) <> $08) do;   { wait for vert retrace }
  until KbGrab;
  if not hadAccess then
      fontAccess(False);
end;

(*********************************************************************
 This is just a "replacement" for some the error checking that I
 didn't do :-).  If you send it bad parameters, it will correct them
 as best it can.  When you (hint, hint) finish the error checking in
 the other procedures, you can get rid of this (unless you like it)
*********************************************************************)
procedure initGfx(x1, y1, xLen, yLen         : word;
                  fClr, bClr, txtMap, gfxMap : byte);
begin
    if ( (xLen * yLen) > 256) then                { outta range? }
      begin
        xLen := (x1 + 25);         { set to something reasonable }
        yLen := (y1 + 10);
      end;

    { text and graphic map can not *both* be odd or even... must }
    { be one of each }
    if ( (txtMap mod 2 = 0) and (gfxMap mod 2 = 0) ) or
       ( (txtMap mod 2 <> 0) and (gfxMap mod 2 <> 0) ) then
        gfxMap := (gfxMap + 1) mod 8;

    deleteBit9(True);
    SetMaps(txtMap, gfxMap);
    if ( ( gfxMap mod 2 <> 0 ) and ( fClr < 8 ) ) then
        fClr := fClr + 8
    else
      if ( ( gfxMap mod 2 = 0 ) and ( fClr > 8 ) ) then
          fClr := fClr - 8;

    if not bpAccess then
        FontAccess(True);
    lasterr := gWindow(x1, y1, xLen, yLen, fClr, bClr);
end;

{ Simple clean up routine... call this when you are done }
procedure exitGfx;
begin
  if bpAccess then
      FontAccess(False);
  deleteBit9(False);
  SetMaps(0,0);
  for wMap := 1 to 80 do                       { using globals for X }
    for lasterr := 1 to 25 do            { ... and Y to clear screen }
       putChAt(wMap, lasterr, 7, 0, 32);
end;

{ Main procedure }
const
  str                : string = 'Textmode';
var
  ctr, chX, chY      : byte;
  ch                 : char;
  x2, y2,
  xCtr, yCtr, cirCtr : word;
begin
  for chX := 1 to 80 do
    for chY := 1 to 25 do
      begin
        ch := str[chX mod 9 + 1];
        putChAt(chX, chY, chY mod 8, 0, Ord(ch));
      end;
  initGfx(27, 7, 25, 10, 15, 1, 0, 3);

  randomize;
  for ctr := 0 to 25 do
    begin
      xCtr   := random(xMax);
      yCtr   := random(yMax);
      cirCtr := random(25);
      Circle(xCtr, yCtr, cirCtr, True);
    end;

  while not KbGrab do;
  clearWindow;

  for ctr := 0 to 25 do
    begin
      xCtr   := random(xMax);
      x2     := random(xMax);
      yCtr   := random(yMax);
      y2     := random(yMax);
      Line( xCtr, yCtr, x2, y2, True);
    end;

  while not KbGrab do;
  clearWindow;
  StarField;

  exitGfx;
end.
