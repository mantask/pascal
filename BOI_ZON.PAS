Program BOILaiko_juostos;
  var f : text;  {rezultatai ir prad duomenys}
      n,  {laiko juostu skaicius}
      t, j, {t - laikas, j - juosta, cia galim masyvui}
      ck : byte; {ciklo kintamasis}
      galim : array [0 .. 59, 0 .. 59] of boolean; {pg lentele}
      laik : array [0 ..59] of word; {laikai zinuciu pagal gavimio tvarka}
      ats : array [0 .. 59] of byte; {atsakymas}
      pg, tt : word; {pagalbinis nuskaitant laika}
begin
  {nuskaitymas}
  assign (f, 'zon.in');
  reset (f);
  readln (f, n);
  for ck := 0 to n - 1 do
  readln (f, laik [ck]);
  close (f);

  {skaiciavimas}
  for t := 0 to n - 1 do
  for j := 0 to n - 1 do
  if (laik [t] + j * 100) < n * 100 then galim [t, j] := true
                          else galim [t, j] := false;

  for j := n - 1  downto 0 do
  begin
    pg := 0;
    tt := 0;
    for t := 0 to n - 1 do
    if (galim [t, j]) and ((laik [t] + j * 100) > tt) then
    begin
      pg := t;
      tt := laik [t]
    end;
    ats [pg] := j;
    for ck := 0 to n - 1 do
    galim [pg, ck] := false;
  end;

  {surasymas}
  assign (f, 'zon.out');
  rewrite (f);
  for ck := 0 to n - 1 do
  write (f, ats [ck], ' ');
  close (f)
end.