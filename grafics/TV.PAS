{$M 1024,0,64000}  (* 1 K Stack, 64 K Heap (Used for VID Mem) *)

Program TelevisionSimulator;

(*
   This has been written by Kevin Keenliside (Pyromaniax of SKP), and I
   have decided to release this source code to the public. Feel free to
   use this source in your programs. No credit is necessary, but is much
   appreciated.
*)

Type
  Video = ^VideoPTR;
  VideoPtr = Array[0..64000] of Char;   (* Pointer Array, breaks the 64kb
                                           limit so this is conceivable *)

Var
  VideoArray : Video;                   (* Variable = Pointer Array *)
  T,RanColor : byte;

Procedure SetMode(M : word); assembler; (* Set Video Mode *)
Asm
  Mov ax,M
  Int 10h
End;

Procedure PalSet(Color, Rc, Bc, Gc : Byte; TMode : Boolean);
Begin
  If (Tmode) and (Color>7) then Inc(Color,48);
  Port[$3C8] := Color;
  Port[$3C9] := Rc;
  Port[$3C9] := BC;
  Port[$3C9] := GC;
End;

Function KeyHit : Boolean;
Begin
  If Port[$60]<$80 then KeyHit:=True
  else
  KeyHit:=False;
End;

Procedure PutRandomDots(Var Scr : Array of Char);
Var
  I : Longint;

Begin
  For I:=0 to SizeOf(Scr) do Scr[I]:=Chr(Random(15)+17); (* Fill Array with
                                                            color Numbers *)
  Move(Scr,Mem[$A000:$0000],SizeOf(Scr));                (* Move array to
                                                            video memory  *)
End;

{**** Main Program *********************************************************}

Begin
  SetMode($13);                                     (* Put in 320x200 mode *)
  GetMem(VideoArray,SizeOf(VideoArray^));           (* Allocate another 64k*)
  PutRandomDots(VideoArray^);                       (* Fill array with dots*)
  FreeMem(VideoArray,SizeOf(VideoArray^));          (* Free used 64k       *)
  Repeat
    If (T>=15) and (T<=32) then Inc(T) else T:=15;  (* Pick color to change*)
    RanColor:=Random(31);                           (* Set intensity of Clr*)
    PalSet(T,RanColor,RanColor,RanColor,False);     (* Change the Palette  *)
  Until KeyHit;                                     (* Repeat until Keyhit *)
  SetMode($3);                                      (* Put in 80x25 T Mode *)
End.

{**** End of Program *******************************************************}
