program aibiu_sudarymas_ir_isvedimas;
  uses crt;
  var aibe : set of char;
      simb : char;
      ck : byte;
begin
  clrscr;
  writeln ('Esc - baigia ivedima');
  aibe := [];
  simb := readkey;
  while simb <> #27 do
   begin
     if not (simb in aibe) and (ord (simb) > 31) then
      begin
         write (simb);
         aibe := aibe + [simb]
      end
     else if ord (simb) = 27 then break;
     simb := readkey;
   end;
  writeln;
  for ck := 32 to 255 do if chr (ck) in aibe then write (chr (ck));
  readkey;
end.