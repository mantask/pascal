program JPM1_5_10;
   type pinigai = record
                    sv,     { svarai }
                    sl,     { silingai }
                    p: word { pensai }
                  end;
   var s1, s2,   { pradines sumos }
       s: pinigai; { galutine suma }
begin
   readln (s1.sv, s1.sl, s1.p);
   readln (s2.sv, s2.sl, s2.p);
   s.p := (s1.p + s2.p) mod 12;
   { paskaiciuojame, kiek susumavus dvi sumas, liks pensu }
   s.sl := (s1.sl + s2.sl + (s1.p + s2.p) div 12) mod 20;
   s.sv := (s1.sv + s2.sv + (s1.sl + s2.sl + (s1.p + s2.p) div 12) div 20);
   writeln (s.sv, ' ', s.sl, ' ', s.p);
end.
