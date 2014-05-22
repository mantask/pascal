{MK 2001}
{8 respublikines informatiko olimmpiados uzdavinys}
{ideja:
 reikia visa brangenybiu sarasa persirasyti i masyva ir is jo isemus viena brangenybe
 ja isimti ir is masyvo, o veliau rekursiskai kviesti tiek proceduru kiek liko
 brangenybiu
}
program karalius;
type
  Tmas = array [1 .. 200] of byte;
  Timtas = array [1 .. 200] of boolean;
var
  ck, {pagalbinis ciklo kintamasis}
  skaic,           {brangenybiu skaicius}
  maxsv : byte; {maksimalus svoris}
  brangenybes : array [1 .. 200, 1 .. 2] of integer; {brangenybiu svoris, verte}
  f : text;
  imta, maximta : Tmas;
  imtas : Timtas;
  maxkart : Byte;
  maxvert : longint;

procedure imk (kartai : byte; imta : Tmas; svoris, verte : longint; imtas : Timtas;
           var maxkart : byte; var maximta : Tmas; var maxverte : longint);
  var ck : byte;
begin
  if svoris > maxsv then
  begin
    svoris := svoris - brangenybes [kartai, 1];
    verte := verte - brangenybes [kartai, 2];
    if verte > maxverte then
    begin
      imta [kartai] := 0;
      dec (kartai);
      maxkart := kartai;
      maximta := imta;
      maxverte := verte;
    end
  end
  else begin
    for ck := kartai + 1 to skaic do
    if not imtas [ck] then
    begin
      imtas [ck] := true;
      imta [kartai + 1] := ck;
      imk (kartai + 1, imta, svoris + brangenybes [ck, 1], verte + brangenybes [ck, 2],
           imtas, maxkart, maximta, maxverte);
      imta [kartai + 1] := 0;
      imtas [ck] := false;
    end;
  end
end;

begin
  {nuskaitymas}
  assign (f, 'kar.dat');
  reset (f);
  readln (f, skaic, maxsv);
  for ck := 1 to skaic do
  readln (f, brangenybes [ck, 1], brangenybes [ck, 2]);
  close (f);

  {skaiciavimas}
  imk (0, imta, 0, 0, imtas, maxkart, maximta, maxvert);

  {rezultatas}
  assign (f, 'kar.rez');
  rewrite (f);
  writeln (f, maxvert);
  for ck := 1 to maxkart do
  writeln (f, maximta [ck]);
  close (F);
end.