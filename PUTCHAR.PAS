type Tekranas = array [1 .. 2000] of word;
     ByteRec = record
       hi, lo : byte
     end;
var ekranas : Tekranas absolute $B800:$0000;


procedure putChar (x, y : byte; c : char; sp : byte);
 var ko : word;
begin
  ko := (y - 1) * 80 + x;
  byterec (ekranas [ko]).lo := sp;
  byterec (ekranas [ko]).hi := ord (c);
end;

procedure putString (x, y : byte; str : string; spTxt, spFon : byte);
  var ck : word;
      sp : byte;
begin
  if length (str) < 1 then exit;
  sp := spTxt + spFon * 16;
  for ck := 0 to length (str) - 1 do
  putChar (x + ck, y, str [ck + 1], sp);
end;
