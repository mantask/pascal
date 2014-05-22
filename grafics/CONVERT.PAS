
program convertsystems; { CONVERT.PAS }
{ Convert any system to any other system, by Bas van Gaalen }
uses u_kb;
const bin=2; oct=8; dec=10; hex=16;
var num:string;

function power(src,pwr:byte):word;
var dst:word; i:byte;
begin
  dst:=1;
  for i:=1 to pwr do dst:=dst*src;
  power:=dst;
end;

procedure convert(sysfr,systo:byte; src:string; var dst:string);
const numstr:array[0..35] of char='0123456789abcdefghijklmnopqrstuvwxyz';
var tmpdst:string; result:real; len,i,j,pos:byte;
begin
  len:=length(src); result:=0;
  for i:=1 to len do begin
    pos:=255; j:=0;
    while (j<length(numstr)) and (pos<>(j-1)) do begin
      if upcase(src[i])=upcase(numstr[j]) then pos:=j;
      inc(j);
    end;
    result:=result+pos*power(sysfr,len-i);
  end;
  tmpdst:='';
  while result <> 0 do begin
    result:=result/systo;
    j:=round(frac(result)*systo);
    insert(numstr[j],tmpdst,1);
    result:=result-frac(result);
  end;
  dst:=tmpdst;
end;

begin
  convert(hex,dec,'abcd',num);
  writeln(num);
  waitkey(0);
end.
