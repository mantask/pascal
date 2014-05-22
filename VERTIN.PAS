program asshole;
uses crt;
var vert: array [1..10] of real;
    a,b1,c1: integer;
    bendras,vid,c,b: real;
    maz,didz: boolean;
label 1;
begin
   clrscr;
   b:=-maxint;
   c:=maxint;
   writeln('Iveskite ivertinimus:');
   for a:=1 to 10 do
      begin                                    {nuskaitome ivertinimus}
1:       readln(vert[a]);
         if (vert[a]<0) or (vert[a]>6) then
         {jei ivesta reikme yra mazesne uz nuli ar didesne uz 6, reiksme nuskaitome is naujo}
                                           begin
                                              writeln('blogai ivedei');
                                              goto 1;
                                           end;
      end;
   for a:= 1 to 10 do                          {randame didziausia ir}
      begin                                    {maziausia ivertinimus}
         if vert[a] > b then
                           begin
                              b:=vert[a];
                              b1:=a;
                           end;
         if vert[a] < c then
                          begin
                             c:=vert[a];
                             c1:=a;
                          end;
      end;
   for a:= 1 to 10 do                                              {tikriname ar yra}
      begin                                                        {vienodu didziausiu}
         if (b=vert[a]) and (vert[a]<>vert[b1]) then didz:=true;   {ir maziausiu ivertinimu}
         if (c=vert[a]) and (vert[a]<>vert[c1]) then maz:=true;
      end;
   for a:= 1 to 10 do                          {skaiciuojame visu ivertinimu}
      begin                                    {suma}
         bendras:=bendras+vert[a];
      end;
                                                                      {skaiciuojame vidurki, kai:}
   if (maz) and (didz) then vid:=bendras/10;                          {yra keli didziausi ir keli maziausi ivertinimai}
   if (not maz) and (not didz) then vid:=(bendras-vert[b1]-vert[c1])/8; {kai yra vienas didziausias ir vienas maziausias iv.}
   if (not maz) and (didz) then vid:=(bendras-vert[c1])/9;             {kai keli didziausi ir vienas maziausias}
   if (maz) and (not didz) then vid:=(bendras-vert[b1])/9;             {kai keli maziausi ir vienas didziausias}
   writeln('Vidurkis yra: ');
   write(vid:2:1);    {vidurkiui iskiriame 2 pozicijas ir ji parasome desimtuju tikslumu}
   readkey;
end.