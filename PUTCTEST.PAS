program testas;

  uses crt;

  type Tekranas = array [1 .. 2000] of word;
       ByteRec = record
         hi, lo : byte
       end;
  var ekranas : Tekranas absolute $B800:$0000;
      x, y : byte;
{--------------}
  procedure putChar (x, y : byte; c : char; sptxt, spfon : byte);
    var ko : word;
        sp : word;
  begin
    ko := (y - 1) * 80 + x;
    sp := spTxt + spFon * 16;
    byterec (ekranas [ko]).lo := sp;
    byterec (ekranas [ko]).hi := ord (c);
  end;
{---------------}
  procedure putString (x, y : byte; str : string; spTxt, spFon : byte);
    var ck : word;
  begin
    if length (str) < 1 then exit;
    for ck := 0 to length (str) - 1 do
    putChar (x + ck, y, str [ck + 1], spTxt, spfon);
  end;
{--------------}
begin

  textbackground (0);
  clrscr;

  putchar ( 1,  1, 'þ', 9, 0);
  putchar ( 1, 25, 'þ', 9, 0);
  putchar (80,  1, 'þ', 9, 0);
  putchar (80, 25, 'þ', 9, 0);
  putstring (32, 12, 'Put char test', 8, 8);
  putstring (35, 13, 'MK 2001', 8, 8);

  repeat
  until port [$60] = 1;
end.