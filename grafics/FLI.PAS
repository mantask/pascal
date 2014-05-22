{$G+}

PROGRAM FliPlayer;

{  v1.1 made by Thaco   }
{ (c) EPOS, August 1992 }


CONST
  CLOCK_HZ              =4608;                   { Frequency of clock }
  MONITOR_HZ            =70;                     { Frequency of monitor }
  CLOCK_SCALE           =CLOCK_HZ DIV MONITOR_HZ;

  BUFFERSIZE            =$FFFE;                  { Size of the framebuffer, must be an even number }
  CDATA                 =$040;                   { Port number of timer 0 }
  CMODE                 =$043;                   { Port number of timers control word }
  CO80                  =$3;                     { Number for standard text mode }
  KEYBOARD              =28;                     { Numbers returned by PORT[$64] indicating what hardware caused INT 09/the - }
  MOUSE                 =60;                     { - number on PORT[$60] }
  MCGA                  =$13;                    { Number for MCGA mode }
  MCGACheck:BOOLEAN     =TRUE;                   { Variable for MCGA checking }
  UseXMS:BOOLEAN        =TRUE;                   { Variable for XMS usage }
  XMSError:BYTE         =0;                      { Variable indicating the errornumber returned from the last XMS operation }

TYPE
  EMMStructure          =RECORD
                           BytesToMoveLo,              { Low word of bytes to move. NB: Must be even! }
                           BytesToMoveHi,              { High word of bytes to move }
                           SourceHandle,               { Handle number of source (SH=0 => conventional memory) }
                           SourceOffsetLo,             { Low word of source offset, or OFS if SH=0 }
                           SourceOffsetHi,             { High word of source offset, or SEG if SH=0 }
                           DestinationHandle,          { Handle number of destination (DH=0 => conventional memory) }
                           DestinationOffsetLo,        { Low word of destination offset, or OFS if DH=0 }
                           DestinationOffsetHi  :WORD; { High word of destination offset, or SEG if DH=0 }
                         END;
  HeaderType            =ARRAY[0..128] OF BYTE;  { A buffertype used to read all kinds of headers }


VAR
  Key,                                           { Variable used to check if a key has been pressed }
  OldKey                :BYTE;                   { Variable used to check if a key has been pressed }
  XMSRecord             :EMMStructure;           { Variable for passing values to the XMS routine }
  InputFile             :FILE;                   { Variable for the incomming .FLI file }
  Header                :HeaderType;             { Buffer used to read all kinds of headers }
  Counter,                                       { General purpose counter }
  Speed                 :INTEGER;                { Timedifference in video tics from one frame to the next }
  FileCounter,                                   { Variable telling the point to read from in the file stored in XMS }
  FileSize,                                      { Size of the .FLI-file }
  FrameSize,                                     { Variable indicating the datasize of current frame }
  NextTime,                                      { Variable saying when it is time to move on to the next frame }
  TimeCounter,                                   { Holding the current time in video tics }
  SecondPos             :LONGINT;                { Number of bytes to skip from the start of the .FLI file when starting - }
                                                 { - from the beginning again }
  Buffer,                                        { Pointer to the Framebuffer }
  XMSEntryPoint         :POINTER;                { Entry point of the XMS routine in memory }
  SpeedString           :STRING[2];              { String used to parse the -sNN command }
  FileName              :STRING;                 { String holding the name of the .FLI-file }
  BufferHandle,                                  { Handle number returned from the XMS routine }
  BytesRead,                                     { Variable telling the numbers of bytes read from the .FLI file }
  FrameNumber,                                   { Number of the current frame }
  Frames,                                        { Total number of frames }
  Chunks                :WORD;                   { Total number of chunks in a frame }


FUNCTION UpCaseString(Streng:String):String;
{ takes a string and convert all letters to uppercase }
VAR
  DummyString           :String;
  Counter               :Integer;
BEGIN
  DummyString:='';
  FOR Counter:=1 TO Length(Streng) DO
    DummyString:=DummyString+UpCase(Streng[Counter]);
  UpCaseString:=DummyString;
END;


PROCEDURE InitMode(Mode:WORD); ASSEMBLER;
{ uses BIOS interrupts to set a videomode }
ASM
  mov  ax,Mode
  int  10h
END;


FUNCTION ModeSupport(Mode:WORD):BOOLEAN; ASSEMBLER;
{ uses BIOS interrupts to check if a videomode is supported }
LABEL Exit, Last_Modes, No_Support, Supported;
VAR
  DisplayInfo           :ARRAY[1..64] OF BYTE;   { Array for storing functionality/state information }
ASM
  push es

  mov  ah,1Bh                                    { the functionality/state information request at int 10h }
  mov  bx,0                                      { 0 = return functionality/state information }
  push ds                                        { push DS on the stack and pop it into ES so ES:DI could be used to - }
  pop  es                                        { - address DisplayInfo, as demanded of the interrupt function }
  mov  di,offset DisplayInfo
  int  10h

  les  di,[dword ptr es:di]                      { The first dword in the buffer for state information is the address - }
                                                 { - of static funtionality table }
  mov  cx,Mode                                   { Can only check for the 0h-13h modes }
  cmp  cx,13h
  ja   No_Support                                { Return 'no support' for modes > 13h }

  mov  ax,1                                      { Shift the right byte the right - }
                                                 { - times and test for the right - }
  cmp  cx,10h                                    { - bit for knowing if the - }
  jae  Last_Modes                                { - videomode is supported - }
                                                 { - }
  shl  ax,cl                                     { - }
  test ax,[word ptr es:di+0]                     { - }
  jz   No_Support                                { - }
  jmp  Supported                                 { - }
                                                 { - }
Last_Modes:                                      { - }
  sub  cx,10h                                    { - }
  shl  ax,cl                                     { - }
  test al,[byte ptr es:di+2]                     { - }
  jz   No_Support                                { - }

Supported:
  mov  al,1                                      { AL=1 makes the function return TRUE }
  jmp  Exit

No_Support:
  mov  al,0                                      { AL=0 makes the function return TRUE }

Exit:
  pop  es
END;


FUNCTION NoXMS:BOOLEAN; ASSEMBLER;
{ checks out if there is a XMS driver installed, and in case it initialize the
  XMSEntryPoint Variable }
LABEL JumpOver;
ASM
  push es

  mov  ax,4300h                                  { AX = 4300h => INSTALLATION CHECK }
  int  2Fh                                       { use int 2Fh EXTENDED MEMORY SPECIFICATION (XMS) }
  mov  bl,1                                      { use BL as a flag to indicate success }
  cmp  al,80h                                    { is a XMS driver installed? }
  jne  JumpOver
  mov  ax,4310h                                  { AX = 4310h => GET DRIVER ADDRESS }
  int  2Fh
  mov  [word ptr XMSEntryPoint+0],BX             { initialize low word of XMSEntryPoint }
  mov  [word ptr XMSEntryPoint+2],ES             { initialize high word of XMSEntryPoint }
  mov  bl,0                                      { indicate success }
JumpOver:
  mov  al,bl                                     { make the function return TRUE (AH=1) or FALSE (AH=0) }

  pop  es
END;


FUNCTION XMSMaxAvail:WORD; ASSEMBLER;
{ returns size of largest contiguous block of XMS in kilo (1024) bytes }
LABEL JumpOver;
ASM
  mov  ah,08h                                    { 'Query free extended memory' function }
  mov  XMSError,0                                { clear error variable }
  call [dword ptr XMSEntryPoint]
  or   ax,ax                                     { check for error }
  jnz  JumpOver
  mov  XMSError,bl                               { errornumber stored in BL }
JumpOver:                                        { AX=largest contiguous block of XMS }
END;


FUNCTION XMSGetMem(SizeInKB:WORD):WORD; ASSEMBLER;
{ allocates specified numbers of kilo (1024) bytes of XMS and return a handle
  to this XMS block }
LABEL JumpOver;
ASM
  mov  ah,09h                                    { 'Allocate extended memory block' function }
  mov  dx,SizeInKB                               { number of KB requested }
  mov  XMSError,0                                { clear error variable }
  call [dword ptr XMSEntryPoint]
  or   ax,ax                                     { check for error }
  jnz  JumpOver
  mov  XMSError,bl                               { errornumber stored in BL }
JumpOver:
  mov  ax,dx                                     { return handle number to XMS block }
END;


PROCEDURE XMSFreeMem(Handle:WORD); ASSEMBLER;
LABEL JumpOver;
ASM
  mov  ah,0Ah                                    { 'Free extended memory block' function }
  mov  dx,Handle                                 { XMS's handle number to free }
  mov  XMSError,0                                { clear error variable }
  call [dword ptr XMSEntryPoint]
  or   ax,ax                                     { check for error }
  jnz  JumpOver
  mov  XMSError,bl                               { errornumber stored in BL }
JumpOver:
END;


PROCEDURE XMSMove(VAR EMMParamBlock:EMMStructure); ASSEMBLER;
LABEL JumpOver;
ASM
  push ds
  push es
  push ds
  pop  es
  mov  ah,0Bh                                    { 'Move extended memory block' function }
  mov  XMSError,0                                { clear error variable }
  lds  si,EMMParamBlock                          { DS:SI -> data to pass to the XMS routine }
  call [dword ptr es:XMSEntryPoint]
  or   ax,ax                                     { check for error }
  jnz  JumpOver
  mov  XMSError,bl                               { errornumber stored in BL }
JumpOver:
  pop  es
  pop  ds
END;


PROCEDURE ExitDueToXMSError;
BEGIN
  InitMode(CO80);
  WriteLn('ERROR! XMS routine has reported error ',XMSError);
  XMSFreeMem(BufferHandle);
  Halt(0);
END;

PROCEDURE GetBlock(VAR Buffer; Size:WORD);
{ reads a specified numbers of data from a diskfile or XMS into a buffer }
VAR
  XMSRecord             :EMMStructure;
  NumberOfBytes         :WORD;
BEGIN
  IF UseXMS THEN
  BEGIN
    NumberOfBytes:=Size;
    IF Size MOD 2=1 THEN
      Inc(NumberOfBytes);  { one must allways ask for a EQUAL number of bytes }
    WITH XMSRecord DO
    BEGIN
      BytesToMoveLo      :=NumberOfBytes;
      BytesToMoveHi      :=0;
      SourceHandle       :=BufferHandle;
      SourceOffsetLo     :=FileCounter MOD 65536;
      SourceOffsetHi     :=FileCounter DIV 65536;
      DestinationHandle  :=0;
      DestinationOffsetLo:=Ofs(Buffer);
      DestinationOffsetHi:=Seg(Buffer);
    END;
    XMSMove(XMSRecord);
    IF XMSError<>0 THEN
      ExitDueToXMSError;
    Inc(FileCounter,Size);
  END
  ELSE
    BlockRead(InputFile,Buffer,Size);
END;


PROCEDURE InitClock; ASSEMBLER; {Taken from the FLILIB source}
ASM
  mov  al,00110100b                          { put it into linear count instead
of divide by 2 }
  out  CMODE,al
  xor  al,al
  out  CDATA,al
  out  CDATA,al
END;


FUNCTION GetClock:LONGINT; ASSEMBLER; {Taken from the FLILIB source}
{ this routine returns a clock with occassional spikes where time
  will look like its running backwards 1/18th of a second.  The resolution
  of the clock is 1/(18*256) = 1/4608 second.  66 ticks of this clock
  are supposed to be equal to a monitor 1/70 second tick.}
ASM
  mov  ah,0                                  { get tick count from dos and use for hi 3 bytes }
  int  01ah                                  { lo order count in DX, hi order in CX }
  mov  ah,dl
  mov  dl,dh
  mov  dh,cl

  mov  al,0                           { read lo byte straight from timer chip }
  out  CMODE,al                                  { latch count }
  mov  al,1
  out  CMODE,al                                  { set up to read count }
  in   al,CDATA                                  { read in lo byte (and discard) }
  in   al,CDATA                                  { hi byte into al }
  neg  al                                  { make it so counting up instead of down }
END;


PROCEDURE TreatFrame(Buffer:POINTER;Chunks:WORD); ASSEMBLER;
{ this is the 'workhorse' routine that takes a frame and put it on the screen }
{ chunk by chunk }
LABEL
  Color_Loop, Copy_Bytes, Copy_Bytes2, Exit, Fli_Black, Fli_Brun, Fli_Color,
  Fli_Copy, Fli_Lc, Fli_Loop, Jump_Over, Line_Loop, Line_Loop2, Next_Line,
  Next_Line2, Pack_Loop, Pack_Loop2;
ASM
  cli                                            { disable interrupts }
  push ds
  push es
  lds  si,Buffer                                 { let DS:SI point at the frame to be drawn }

Fli_Loop:                                        { main loop that goes through all the chunks in a frame }
  cmp  Chunks,0                                  { are there any more chunks to draw? }
  je   Exit
  dec  Chunks                                    { decrement Chunks for the chunk to process now }

  mov  ax,[word ptr ds:si+4]                     { let AX have the ChunkType }
  add  si,6                                      { skip the ChunkHeader }

  cmp  ax,0Bh                                    { is it a FLI_COLOR chunk? }
  je   Fli_Color
  cmp  ax,0Ch                                    { is it a FLI_LC chunk? }
  je   Fli_Lc
  cmp  ax,0Dh                                    { is it a FLI_BLACK chunk? }
  je   Fli_Black
  cmp  ax,0Fh                                    { is it a FLI_BRUN chunk? }
  je   Fli_Brun
  cmp  ax,10h                                    { is it a FLI_COPY chunk? }
  je   Fli_Copy
  jmp  Fli_Loop                                  { This command should not be
necessary since the program should make one - }
                                                 { - of the other jumps }

Fli_Color:
  mov  bx,[word ptr ds:si]                       { number of packets in this
chunk (allways 1?) }
  add  si,2                                      { skip the NumberOfPackets }
  mov  al,0                                      { start at color 0 }
  xor  cx,cx                                     { reset CX }

Color_Loop:
  or   bx,bx                                     { set flags }
  jz   Fli_Loop                                  { exit if no more packages }
  dec  bx                                        { decrement NumberOfPackages for the package to process now }

  mov  cl,[byte ptr ds:si+0]                     { first byte in packet tells how many colors to skip }
  add  al,cl                                     { add the skiped colors to the start to get the new start }
  mov  dx,$3C8                                   { PEL Address Write Mode Register }
  out  dx,al                                     { tell the VGA card what color we start changing }

  inc  dx                                        { at the port abow the PEL_A_W_M_R is the PEL Data Register }
  mov  cl,[byte ptr ds:si+1]                     { next byte in packet tells how many colors to change }
  or   cl,cl                                     { set the flags }
  jnz  Jump_Over                                 { if NumbersToChange=0 then NumbersToChange=256 }
  inc  ch                                        { CH=1 and CL=0 => CX=256 }
Jump_Over:
  add  al,cl                                     { update the color to start at }
  mov  di,cx                                     { since each color is made of 3 bytes (Red, Green & Blue) we have to - }
  shl  cx,1                                      { - multiply CX (the data counter) with 3 }
  add  cx,di                                     { - CX = old_CX shl 1 + old_CX (the fastest way to multiply with 3) }
  add  si,2                                      { skip the NumbersToSkip and NumbersToChange bytes }
  rep  outsb                                     { put the color data to the VGA card FAST! }

  jmp  Color_Loop                                { finish with this packet - jump back }


Fli_Lc:
  mov  ax,0A000h
  mov  es,ax                                     { let ES point at the screen segment }
  mov  di,[word ptr ds:si+0]                     { put LinesToSkip into DI - }
  mov  ax,di                                     { - to get the offset address to this line we have to multiply with 320 - }
  shl  ax,8                                      { - DI = old_DI shl 8 + old_DI shl 6 - }
  shl  di,6                                      { - it is the same as DI = old_DI*256 + old_DI*64 = old_DI*320 - }
  add  di,ax                                     { - but this way is faster than a plain mul }
  mov  bx,[word ptr ds:si+2]                     { put LinesToChange into BX }
  add  si,4                                      { skip the LinesToSkip and LinesToChange words }
  xor  cx,cx                                     { reset cx }

Line_Loop:
  or   bx,bx                                     { set flags }
  jz  Fli_Loop                                   { exit if no more lines to change }
  dec  bx

  mov  dl,[byte ptr ds:si]                       { put PacketsInLine into DL }
  inc  si                                        { skip the PacketsInLine byte
}
  push di                                        { save the offset address of this line }

Pack_Loop:
  or   dl,dl                                     { set flags }
  jz   Next_Line                                 { exit if no more packets in this line }
  dec  dl
  mov  cl,[byte ptr ds:si+0]                     { put BytesToSkip into CL }
  add  di,cx                                     { update the offset address }
  mov  cl,[byte ptr ds:si+1]                     { put BytesOfDataToCome into CL }
  or   cl,cl                                     { set flags }
  jns  Copy_Bytes                                { no SIGN means that CL number of data is to come - }
                                                 { - else the next data should be put -CL number of times }
  mov  al,[byte ptr ds:si+2]                     { put the byte to be repeated into AL }
  add  si,3                                      { skip the packet }
  neg  cl                                        { repeat -CL times }
  rep  stosb
  jmp  Pack_Loop                                 { finish with this packet }

Copy_Bytes:
  add  si,2                                      { skip the two count bytes at the start of the packet }
  rep  movsb
  jmp  Pack_Loop                                 { finish with this packet }

Next_Line:
  pop  di                                        { restore the old offset address of the current line }
  add  di,320                                    { offset address to the next line }
  jmp  Line_Loop


Fli_Black:
  mov  ax,0A000h
  mov  es,ax                                     { let ES:DI point to the start of the screen }
  xor  di,di
  mov  cx,32000                                  { number of words in a screen }
  xor  ax,ax                                     { color 0 is to be put on the screen }
  rep  stosw
  jmp  Fli_Loop                                  { jump back to main loop }


Fli_Brun:
  mov  ax,0A000h
  mov  es,ax                                     { let ES:DI point at the start of the screen }
  xor  di,di
  mov  bx,200                                    { numbers of lines in a screen }
  xor  cx,cx

Line_Loop2:
  mov  dl,[byte ptr ds:si]                       { put PacketsInLine into DL }
  inc  si                                        { skip the PacketsInLine byte }
  push di                                        { save the offset address of this line }

Pack_Loop2:
  or   dl,dl                                     { set flags }
  jz   Next_Line2                                { exit if no more packets in this line }
  dec  dl
  mov  cl,[byte ptr ds:si]                       { put BytesOfDataToCome into CL }
  or   cl,cl                                     { set flags }
  js   Copy_Bytes2                               { SIGN meens that CL number of data is to come - }
                                                 { - else the next data should be put -CL number of times }
  mov  al,[byte ptr ds:si+1]                     { put the byte to be repeated into AL }
  add  si,2                                      { skip the packet }
  rep  stosb
  jmp  Pack_Loop2                                { finish with this packet }

Copy_Bytes2:
  inc  si                                        { skip the count byte at the start of the packet }
  neg  cl                                        { repeat -CL times }
  rep  movsb
  jmp  Pack_Loop2                                { finish with this packet }

Next_Line2:
  pop  di                                        { restore the old offset address of the current line }
  add  di,320                                    { offset address to the next line }
  dec  bx                                        { any more lines to draw? }
  jnz  Line_Loop2
  jmp  Fli_Loop                                  { jump back to main loop }

Fli_Copy:
  mov  ax,0A000h
  mov  es,ax                                     { let ES:DI point to the start of the screen }
  xor  di,di
  mov  cx,32000                                  { number of words in a screen }
  rep  movsw
  jmp  Fli_Loop                                  { jump back to main loop }


Exit:
  sti                                            { enable interrupts }
  pop  es
  pop  ds
END;



BEGIN
  WriteLn;
  WriteLn('.FLI-Player v1.1 by Thaco');
  WriteLn('  (c) EPOS, August 1992');
  WriteLn;
  IF ParamCount=0 THEN                           { if no input parameters then write the 'usage text' }
  BEGIN
    WriteLn('USAGE: FLIPLAY <options> <filename>');
    WriteLn('                   '+#24+'         '+#24);
    WriteLn('                   ³         ÀÄÄ  Filename of .FLI file');
    WriteLn('                   ÀÄÄÄÄÄÄÄÄÄÄÄÄ  -d   = Do not use XMS');
    WriteLn('                                  -i   = Information about the program');
    WriteLn('                                  -n   = No checking of MCGA mode support');
    WriteLn('                                  -sNN = Set playspeed to NN video ticks (0-99)');
    WriteLn('                                         ( NN=70 ÷ frame delay of 1 second )');
    Halt(0);
  END;

  FOR Counter:=1 TO ParamCount DO                { search through the input parameters for a -Info option }
    IF Pos('-I',UpCaseString(ParamStr(Counter)))<>0 THEN
    BEGIN
      WriteLn('Program information:');
      WriteLn('This program plays animations (sequences of pictures) made by programs like',#10#13,
              'Autodesk Animator (so called .FLI-files). The program decodes the .FLI file,',#10#13,
              'frame by frame, and uses the systemclock for mesuring the time-delay between',#10#13,
              'each frame.');
      WriteLn('Basis for the program was the FliLib package made by Jim Kent, but since the',#10#13,
              'original source was written in C, and I am not a good C-writer, I decided',#10#13,
              'to write my own .FLI-player in Turbo Pascal v6.0.');
      WriteLn('This program was made by Eirik Milch Pedersen (thaco@solan.unit.no).');
      WriteLn('Copyright Eirik Pedersens Own Softwarecompany (EPOS), August 1992');
      WriteLn;
      WriteLn('Autodesk Animator is (c) Autodesk Inc');
      WriteLn('FliLib is (c) Dancing Flame');
      WriteLn('Turbo Pascal is (c) Borland International Inc');
      Halt(0);
    END;

  Speed:=-1;
  Counter:=1;
  WHILE (Copy(ParamStr(Counter),1,1)='-') AND (ParamCount>=Counter) DO { search
through the input parameters to assemble them }
  BEGIN
   IF Pos('-D',UpCaseString(ParamStr(Counter)))<>0 THEN  { do not use XMS for
storing the file into memory }
     UseXMS:=FALSE
   ELSE
     IF Pos('-N',UpCaseString(ParamStr(Counter)))<>0 THEN  { do not check for a
vga card present }
       MCGACheck:=FALSE
     ELSE
       IF Pos('-S',UpCaseString(ParamStr(Counter)))<>0 THEN { speed override
has been specified }
       BEGIN
         SpeedString:=Copy(ParamStr(Counter),3,2);  { cut out the NN parameter
}
         IF NOT(SpeedString[1] IN ['0'..'9']) OR    { check if the NN parameter
is legal }
            (NOT(SpeedString[2] IN ['0'..'9',' ']) AND (Length(SpeedString)=2))
THEN
         BEGIN
           WriteLn('ERROR! Can not parse speed ''',SpeedString,'''.');
           Halt(0);
         END;
         Speed:=Byte(SpeedString[1])-48;  { take the first number, in ASCII,
and convert it to a standard number }
         IF Length(SpeedString)=2 THEN    { if there is two numbers then
multiply the first with 10 and add the next }
           Speed:=Speed*10+Byte(SpeedString[2])-48;
         Speed:=Speed*CLOCK_SCALE;        { convert the speed to number of
clock tics }
       END;
   Inc(Counter);
  END;

  IF ParamCount<Counter THEN
  BEGIN
    WriteLn('ERROR! No filename specified.');
    Halt(0);
  END;

  FileName:=UpCaseString(ParamStr(Counter));
  IF Pos('.',FileName)=0 THEN  { find out if there exist a . in the filename }
    FileName:=FileName+'.FLI'; { if not then add the .FLI extension on the
filename }

  IF MaxAvail<BUFFERSIZE THEN   { check if there is enough memory to the frame buffer }
  BEGIN
    WriteLn('ERROR! Can not allocate enough memory to a frame buffer.');
    Halt(0);
  END;

  GetMem(Buffer,BUFFERSIZE);
  Assign(InputFile,FileName);
  Reset(InputFile,1);
  IF IOResult<>0 THEN  { has an error occured during opening the file? }
  BEGIN
    WriteLn('ERROR! Can not open file ''',FileName,'''.');
    Halt(0);
  END;

  IF NOT(MCGACheck) OR ModeSupport(MCGA) THEN
    InitMode(MCGA)
  ELSE
  BEGIN
    WriteLn('ERROR! Video mode 013h - 320x200x256 colors - is not supported.');
    Halt(0);
  END;

  BlockRead(InputFile,Header,128);  { read the .FLI main header }

  IF NOT((Header[4]=$11) AND (Header[5]=$AF)) THEN  { check if the file has got the magic number }
  BEGIN
    InitMode(CO80);
    WriteLn('ERROR! File ''',FileName,''' is of a wrong file type.');
    Halt(0);
  END;

  IF NoXMS THEN  { if no XMS driver present then do not use XMS }
    UseXMS:=FALSE;

  IF UseXMS THEN
  BEGIN
FileSize:=Header[0]+256*(LongInt(Header[1])+256*(LongInt(Header[2])+256*LongInt
(Header[3])));
    IF XMSMaxAvail<=(FileSize+1023) SHR 10 THEN  { is there enough XMS (rounded up to nearest KB) availible? }
    BEGIN
      WriteLn('ERROR! Not enough XMS for the file');
      Halt(0);
    END
    ELSE
    BEGIN
      Seek(InputFile,0);  { skip back to start of .FLI-file to put it all into XMS }
      BufferHandle:=XMSGetMem((FileSize+1023) SHR 10);  { allocate XMS for the whole .FLI file }
      FileCounter:=0;
      REPEAT
        BlockRead(InputFile,Buffer^,BUFFERSIZE,BytesRead);  { read a part from the .FLI file }
        IF BytesRead MOD 2=1 THEN  { since BUFFERSIZE shoud be an even number, the only time this triggers is the last part }
          Inc(BytesRead);          { must be done because the XMS routine demands an even number of bytes to be moved }
        IF BytesRead<>0 THEN
        BEGIN
          WITH XMSRecord DO  { put data into the XMSRecord }
          BEGIN
            BytesToMoveLo      :=BytesRead;
            BytesToMoveHi      :=0;
            SourceHandle       :=0;
            SourceOffsetLo     :=Ofs(Buffer^);
            SourceOffsetHi     :=Seg(Buffer^);
            DestinationHandle  :=BufferHandle;
            DestinationOffsetLo:=FileCounter MOD 65536;
            DestinationOffsetHi:=FileCounter DIV 65536;
          END;
          XMSMove(XMSRecord);   { move bytes to XMS }
          IF XMSError<>0 THEN   { have any XMS errors occured? }
            ExitDueToXMSError;
          Inc(FileCounter,BytesRead);  { update the offset into XMS where to put the next bytes }
        END;
      UNTIL BytesRead<>BUFFERSIZE;  { repeat until bytes read <> bytes tried to read => end of file }
    END;
    FileCounter:=128;  { we continue (after reading the .FLI file into XMS)
right after the .FLI main header }
  END;

  Frames:=Header[6]+Header[7]*256;  { get the number of frames from the .FLI-header }
  IF Speed=-1 THEN                  { if speed is not set by a speed override then get it from the .FLI-header }
    Speed:=(Header[16]+Integer(Header[17])*256)*CLOCK_SCALE;
  InitClock;  { initialize the System Clock }
  OldKey:=PORT[$60];  { get the current value from the keyboard }
  Key:=OldKey;        { and set the 'current key' Variable to the same value }

  GetBlock(Header,16);  { read the first frame-header }
FrameSize:=Header[0]+256*(LongInt(Header[1])+256*(LongInt(Header[2])+256*LongInt(Header[3])))-16;  { calculate framesize }
  SecondPos:=128+16+FrameSize;  { calculate what position to skip to when the
.FLI is finished and is going to start again - }
                                { the position = .FLI-header +
first_frame-header + first_framesize }
  Chunks:=Header[6]+Header[7]*256;  { calculate number of chunks in frame }
  GetBlock(Buffer^,FrameSize);  { read the frame into the framebuffer }
  TreatFrame(Buffer,Chunks);  { treat the first frame }

  TimeCounter:=GetClock;  { get the current time }

  {
    The first frame must be handeled separatly from the rest. This is because
the rest of the frames are updates/changes of the
    first frame.
    At the end of the .FLI-file there is one extra frame who handles the
changes from the last frame to the first frame.
  }

  REPEAT
    FrameNumber:=1;  { we start at the first frame (after the initial frame) }
    REPEAT
      GetBlock(Header,16);  { read frame-header }
FrameSize:=Header[0]+256*(LongInt(Header[1])+256*(LongInt(Header[2])+256*LongInt(Header[3])))-16;  { size of frame }
      IF FrameSize<>0 THEN  { sometimes there are no changes from one frame to
the next (used for extra delays). In such - }
                            { - cases the size of the frame is 0 and we don't
have to process them }
      BEGIN
        Chunks:=Header[6]+Header[7]*256;  { calculate number of chunks in the
frame }
        GetBlock(Buffer^,FrameSize);  { read the frame into the framebuffer }
        TreatFrame(Buffer,Chunks);  { treat the frame }
      END;

      NextTime:=TimeCounter+Speed;   { calculate the delay to the next frame }
      WHILE TimeCounter<NextTime DO  { wait for this long }
        TimeCounter:=GetClock;

      IF PORT[$64]=KEYBOARD THEN   { check if the value at the keyboard port is
caused by a key pressed }
        Key:=PORT[$60];            { get the current value from the keyboard }
      Inc(FrameNumber);  { one frame finished, over to the next one }
    UNTIL (FrameNumber>Frames) OR (Key<>OldKey);  { repeated until we come to
the last frame or a key is pressed }

    IF UseXMS THEN
      FileCounter:=SecondPos
    ELSE
      Seek(InputFile,SecondPos);  { set current position in the file to the
second frame }

  UNTIL Key<>OldKey;  { exit the loop if a key has been pressed }

  InitMode(CO80);  { get back to text mode }

  Close(InputFile);            { be a kind boy and close the file before we end
the program }
  FreeMem(Buffer,BUFFERSIZE);  { and free the framebuffer }

  IF UseXMS THEN
    XMSFreeMem(BufferHandle);
END.
