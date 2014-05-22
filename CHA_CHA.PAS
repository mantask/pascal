Program raso_teksta;
uses
  Dos, Crt;
type
  Tekranas = array [1 .. 2000] of word;
  ByteRec = record
    hi, lo : byte
  end;
var
  Int1CSave : Pointer;
  ekranas : Tekranas absolute $B800:$0000;
  SenasINT01Ch : procedure;

procedure putChar (y, x : byte; c : char; sptxt, spfon : byte);
  var ko : word;
      sp : word;
begin
  ko := x * 80 + y;
  sp := spTxt + spFon * 16;
  byterec (ekranas [ko]).lo := sp;
  byterec (ekranas [ko]).hi := ord (c);
end;

{$F+}
procedure Taimeris; interrupt;
  begin
    putChar ( 9,  9, ' ', 15, 2);
    putChar (10,  9, ' ', 15, 2);
    putChar (11,  9, ' ', 15, 2);
    putChar (12,  9, ' ', 15, 2);
    putChar (13,  9, ' ', 15, 2);
    putChar (14,  9, ' ', 15, 2);
    putChar (15,  9, ' ', 15, 2);

    putchar ( 9, 10, ' ', 15, 2);
    putChar (10, 10, 'C', 15, 2);
    putChar (11, 10, 'h', 15, 2);
    putChar (12, 10, 'a', 15, 2);
    putChar (13, 10, 'n', 15, 2);
    putChar (14, 10, 'a', 15, 2);
    putChar (15, 10, ' ', 15, 2);

    putChar ( 9, 11, ' ', 15, 2);
    putChar (10, 11, ' ', 15, 2);
    putChar (11, 11, ' ', 15, 2);
    putChar (12, 11, ' ', 15, 2);
    putChar (13, 11, ' ', 15, 2);
    putChar (14, 11, ' ', 15, 2);
    putChar (15, 11, ' ', 15, 2);

    INLINE ($9C); { PUSHF -- Push flags }
    SenasINT01Ch;
{    if port [$60] = 1 then SetIntVec ($1C, @SenasINT01Ch);
 } end;
{$F-}
begin
  GetIntVec ($1C, @SenasINT01Ch);
  SetIntVec ($1C, @Taimeris);
end.
