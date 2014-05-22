{ MK 2001 }
program GraphicsTest;

{ Grafics unito demonstracija }

uses
  graphics;

var
  ck : word;
  pg : boolean;

begin
  initgraph;

  for ck := 0 to 255 do
  begin
    setRGBpal (ck, ck div 32, 64 - ck div 4 , ck div 4);
    vline (ck, 0, 200, ck);
  end;

  repeat until port [$60] = 1;
  closegraph
end.