{ JPM1_5_12 }
var dpirk, dpard : integer;
kursas :  array [1..10] of real;
    c: integer;

procedure pp (kursas: array of real; pdiena: real; { prad. duom. }
              var dpirk, dpard: integer);                { rez. }
   var diena: integer;
begin
   dpirk := 1; dpard := 1; { geriausia pirkti ir parduoti 1 metu diena }
   kursas [1] := pdiena;
   for diena := 2 to 10 {365} do { tikrinami visi metai }
     begin
        kursas [diena] := kursas [diena - 1] + kursas [diena];
        { ar akcija sia diena pigesne uz anksciau buvusia pigiausia }
        if kursas [diena] < kursas [dpirk]
             then dpirk := diena;
        { ar akcija sia diena brangesne uz anksciau buvusia brangiausia }
        if kursas [diena] > kursas [dpard]
             then dpard := diena;
     end
end;

begin

for c := 1 to 10 do
readln (kursas[c]);
pp (kursas, 10, dpirk, dpard);
writeln (dpirk, dpard:5);
end.

