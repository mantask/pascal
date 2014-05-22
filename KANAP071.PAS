program Kanap071;
uses
  graph;
var
  gm, gd : integer;

{procedure sinusoide}
procedure sinusoide (xx, yy,    {veduokles pradzia}
                     xp, xg,    {sinusoides pradzia ir galas}
                     ya,        {sinusoides asis}
                     sptm, spl, {sinusoides ir liniju spalvos}
                     n : byte); {taskai dedami kas n laipsniu}
var
  x, y, h : integer;
  t, th : real;
begin
  setcolor (spl);
  setlinestyle (1, 0, 1);
  h := round (540 / (xg - xp + 1)); {laipsniai}
  h := n div h;                     {tasko koordinates x kitimo zingsnis}
  x := xp;
  t := 0;
  while t <= 540 do
  begin
    y := trunc (sin (t * pi / 40) * 20);
{   line (xx, yy, x, y + ya);      {linija nuo veduokles pradzios}
    putpixel (x, y + ya, spl);      {sinusoides taskas}
    t := t + n;
    x := x + h
  end
end;
{procedure sinusoide}

begin
  initgraph (gm, gd, '');
  sinusoide (100, 10, 0, 255, 239, 1, 2, 5);
  repeat until port [$60] = 1;
  closegraph
end.