uses crt;
var a: char;
begin clrscr;a:=readkey;
if a = #0 then a := readkey; writeln(ord(a)) end.