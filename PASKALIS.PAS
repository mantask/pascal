program paskalis;

const
  n = 34;

type
  Telem = array [1 .. 100] of 0 .. 9;
  Teil = array [1 .. n] of ^Telem;

var
  eil1, eil2 : Teil;
  ck, ckn, ckf : longint;
  f : text;

procedure rasyk (var eil : Teil; var f : text);
var
  ckn : 1 .. 100;
  ck : byte;
  t : boolean;
begin
  for ckn := 1 to n do
  begin
    for ck := 99 to 1 do
    if (eil [ckn]^[ck] <> 0) and not t then
    begin
      t := true;
      write (f, eil [ckn]^[ck]);
    end;
    write (f, ' ');
  end;
  writeln (f)
end;


function teig (elem : Telem) : boolean;
var
  ck : byte;
  t : boolean;
begin
  t := true;
  for ck := 1 to 100 do
  if elem [ck] = 0 then t := false;
  teig := t
end;

procedure sukurk (var eil1, eil2 : Teil);
var
  ck : word;
  ckn : byte;
begin
  for ck := 1 to n do
  begin
    new (eil1 [ck]);
    new (eil2 [ck]);
    for ckn := 1 to 100 do
    begin
      eil1 [ck]^ [ckn] := 0;
      eil2 [ck]^ [ckn] := 0;
    end;
  end;
  eil1 [1]^ [1] := 1;
end;

procedure valyk (var eil1, eil2 : Teil);
var
  ck : byte;
begin
  for ck := 1 to n do
  begin
    dispose (eil1 [ck]);
    dispose (eil2 [ck]);
  end
end;

procedure sum (var eil1, eil2 : Teil; n : integer);
var
  ckn : byte;
  ck : byte;
  s : 0 .. 18;
begin
  for ckn := 1 to n do
  begin
    for ck := 99 downto 1 do
    begin
      s := eil1 [ckn]^[ck] + eil1 [ckn - 1]^[ck];
      eil1 [ckn]^ := eil2 [ck]^;
      eil2 [ckn]^ := s mod 10;
      eil2 [ck + 1]^ := eil2 [ck + 1] + s div 10;
    end;
  end;
end;

begin
  assign (f, 'Paskalis.txt');
  rewrite (f);
  sukurk (eil1, eil2);
  for ckn := 1 to n do
  begin
    { sumuoju }
    for ck := 1 to ckn do
    sum (eil1 [ck]^, eil2 [ck]^, ckn);
    { skiaciuoju }
    for ckf := 100 to 1 do
    if teig (eil2 [ck]^) then rasyk (eil2, f);
  end;
  close (f);
  valyk (eil1, eil2);
end.