{
  ieskom maziausio:
   X = s2 * s1 + s1 - s2 = s3 * s4 + s3 - s4
}

program kasubai;

const
  iki = 50;

var
  X, s1, s2, s3, s4 : longint;
  ok : boolean;

begin
  ok := true;
  x := maxint;
  for s1 := 1 to iki do
  if ok then
  for s2 := 2 to iki do
  if ok and (s1 + 1 <> s2 - 1) then
  for s3 := 1 to iki do
  if ok and (s1 <> s3) and (s2 - 1 <> s3 + 1) then
  for s4 := 2 to iki do
  if ok and (s1 + 1 <> s4 - 1) and (s2 <> s4) and (s3 + 1 <> s4 - 1) and
     (s1 * s2 = s3 * s4) then
  begin
    ok := false;
    writeln ('X = ', (s1 + 1) * (S2 - 1) + s1 + 1 - s2 + 1);
    writeln (s1+1,'*',s2-1,'+',s1+1,'-',s2-1,'=',s3+1,'*',s4-1,'+',s3+1,'-',s4-1);
    writeln (s1, ' ', s2, ' ', s3, ' ', s4)
  end;
end.