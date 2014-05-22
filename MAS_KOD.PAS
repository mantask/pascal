{randa integer tipo skaiciaus dvejetaini koda}
program vidinis_kodas;
   var a : integer;
       ck, pg : integer;
       ats : array [1 .. 16] of 0 .. 1;
begin
   readln (a);
   for ck := 0 to 15 do
   begin
      pg := a shl ck;
      pg := (pg and $8000) shr 15;
      ats [ck + 1] := pg
   end;
   for ck := 1 to  8 do write (ats [ck]);
   write (':');
   for ck := 9 to 16 do write (ats [ck]);
   readln
end.