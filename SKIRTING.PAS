{programa sugeneruoja visus skaicius tenkinancius salygas:
  sk1 * sk2 = sk3, kur siu skaiciu skaitmenys skirtingi ir nelygus 0}
program skaiciai;
   uses crt;
   var f : text;
       sk1, sk2, sk3 : integer;

   procedure p (str : string);
   begin
      if length (str) = 4 then Writeln (f, str)
      else
      begin
         p (str + '1');
         p (str + '2');
         p (str + '3');
         p (str + '4');
         p (str + '5');
         p (str + '6');
         p (str + '7');
         p (str + '8');
         p (str + '9');
      end
   end;

   function ar (sk1, sk2, sk3 : integer) : boolean;
      var pg, ck : integer;
          arT : boolean;
          sk : array [1 .. 9] of boolean;
   begin {ar}
      for ck := 1 to 9 do sk [ck] := false;
      art := true;
      for ck := 1 to 9 do
      begin {for}
         case ck of
             1: pg := sk3 div 1000;
             2: pg := sk3 mod 1000 div 100;
             3: pg := sk3 div 10 mod 10;
             4: pg := sk3 mod 10;
             5: pg := sk1 mod 10;
             6: if (sk1 div 10) = 0 then pg :=  sk2 div 1000 else pg := sk1 div 10;
             7: pg := sk2 mod 10;
             8: pg := sk2 mod 100 div 10;
             9: pg := sk2 mod 1000 div 100;
         end; {case}
         if not sk [pg] then sk [pg] := true
         else
            begin
               art := false;
               break
            end;
      end; {for}
      ar := art;
   end;{ar}

begin
   clrscr;
   assign (f, 'skaitm.txt');
   rewrite (f);
   p ('');
   close (f);
   reset (f);
   while not eof (f) do
   begin{while}
      readln (f, sk3);
      sk1 := 1;
      repeat
        inc (sk1);
        if sk3 mod sk1 = 0 then
        begin {if}
           sk2 := sk3 div sk1;
           if ((sk1 div 10 = 0) and (sk2 div 1000 > 0)) or ((sk1 div 10 > 0) and (sk2 div 100 < 10) and (sk2 div 100 > 0))
           then if ar (sk1, sk2, sk3) then writeln (sk1 :5,' *', sk2 :5, ' =', sk3 :5);
        end; {if}
      until sk1 = 98;
   end;  {while}
   close (f);
   erase (f);
end.