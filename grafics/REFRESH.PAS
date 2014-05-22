
program refreshtest; { REFRESH.PAS }
{ Test monitors refresh-rate (should be around 70Hz), by Bas van Gaalen }
uses crt,dos,u_vga,u_kb;
var h1,h2,m1,m2,s1,s2,hs1,hs2,i:word;
begin
  i:=0;
  clrscr; writeln('Please wait, calculating refresh-rate...');
  gettime(h1,m1,s1,hs1); repeat gettime(h2,m2,s2,hs2); until s2>s1;
  gettime(h1,m1,s1,hs1);
  repeat
    vretrace;
    gettime(h2,m2,s2,hs2);
    inc(i);
  until s2>s1;
  writeln('Refresh-rate is ',i,'Hz.');
  writeln('Press a key to continue...');
  waitkey(3);
end.
