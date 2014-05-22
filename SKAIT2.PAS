{programa}
{----------------------------}
{ TiS¨ Mantas Kanaporis 2000 }
{----------------------------}

{-=pradzia=-}
program skait;
var tekstas: string;
    num, kabl_poz, atmn, pradz_num: integer;
    yra_kabl, yra_min, klaida: boolean;
    TXTiSK,skaitmuo: real;
    skaitymas: real;

function laipsnis_10 (rodiklis: integer):real;
   var kartas: integer;
       laipsnis: real;
   BEGIN
   laipsnis:=1;
   for kartas:=1 to rodiklis do begin
         laipsnis:=laipsnis*10;
       end;
   laipsnis_10:=laipsnis;
   END;

BEGIN
   repeat
     TXTiSK:=0;
     klaida:=false;
     yra_kabl:=false;
     yra_min:=false;
     readln(tekstas);
     if (length(tekstas)=1) and ((tekstas[1]='.')or(tekstas[1]='-')) then klaida:=true;
     if length(tekstas)=0 then klaida:=true;
     for num:=1 to length(tekstas) do begin
          if tekstas[num] in ['0'..'9','.','-'] then else klaida:=true;
          if tekstas[num]='-' then begin if num<>1 then klaida:=true; yra_min:=true end;
          if tekstas[num]='.' then
             if yra_kabl then klaida:=true else
                begin yra_kabl:=true; kabl_poz:=num; end;
     end;
     if yra_min then pradz_num:=2 else pradz_num:=1;
     for num:=pradz_num to length(tekstas) do begin
         case tekstas[num] of
              '.':skaitmuo:=0;
              '-':skaitmuo:=0;
              '0':skaitmuo:=0;
              '1':skaitmuo:=1;
              '2':skaitmuo:=2;
              '3':skaitmuo:=3;
              '4':skaitmuo:=4;
              '5':skaitmuo:=5;
              '6':skaitmuo:=6;
              '7':skaitmuo:=7;
              '8':skaitmuo:=8;
              '9':skaitmuo:=9;
         end;
         if num>kabl_poz then atmn:=1 else atmn:=0;
         if yra_kabl then TXTiSK:=TXTiSK+skaitmuo*laipsnis_10(length(tekstas)+atmn-num)
              else TXTiSK:=TXTiSK+skaitmuo*laipsnis_10(length(tekstas)-num);
     end;
     if yra_kabl then TXTiSK:=TXTiSK/laipsnis_10(length(tekstas)+1-kabl_poz);
     if yra_min then skaitymas:=-TXTiSK else skaitymas:=TXTiSK;

   until not klaida;
   writeln;
   writeln(skaitymas);
END.
{-=pabaiga=-}
{ TiS¨ }

{funkcija}
{----------------------------}
{ TiS¨ Mantas Kanaporis 2000 }
{----------------------------}

{-=pradzia=-}
FUNCTION skaitymas:real;
var tekstas: string;
    num, kabl_poz, atmn, pradz_num: integer;
    yra_kabl, yra_min, klaida: boolean;
    TXTiSK,skaitmuo: real;

function laipsnis_10 (rodiklis: integer):real;
   var kartas: integer;
       laipsnis: real;
   BEGIN
   laipsnis:=1;
   for kartas:=1 to rodiklis do begin
         laipsnis:=laipsnis*10;
       end;
   laipsnis_10:=laipsnis;
   END;

BEGIN
   repeat
     TXTiSK:=0;
     klaida:=false;
     yra_kabl:=false;
     yra_min:=false;
     readln(tekstas);
     if (length(tekstas)=1) and ((tekstas[1]='.')or(tekstas[1]='-')) then klaida:=true;
     if length(tekstas)=0 then klaida:=true;
     for num:=1 to length(tekstas) do begin
          if tekstas[num] in ['0'..'9','.'] then else if tekstas[1]='-' then yra_min:=true else klaida:=true;
          if tekstas[num]='.' then
             if yra_kabl then klaida:=true else
                begin yra_kabl:=true; kabl_poz:=num; end;
     end;
     if yra_min then pradz_num:=2 else pradz_num:=1;
     for num:=pradz_num to length(tekstas) do begin
         case tekstas[num] of
              '.':skaitmuo:=0;
              '-':skaitmuo:=0;
              '0':skaitmuo:=0;
              '1':skaitmuo:=1;
              '2':skaitmuo:=2;
              '3':skaitmuo:=3;
              '4':skaitmuo:=4;
              '5':skaitmuo:=5;
              '6':skaitmuo:=6;
              '7':skaitmuo:=7;
              '8':skaitmuo:=8;
              '9':skaitmuo:=9;
         end;
         if num>kabl_poz then atmn:=1 else atmn:=0;
         if yra_kabl then TXTiSK:=TXTiSK+skaitmuo*laipsnis_10(length(tekstas)+atmn-num)
              else TXTiSK:=TXTiSK+skaitmuo*laipsnis_10(length(tekstas)-num);
     end;
     if yra_kabl then TXTiSK:=TXTiSK/laipsnis_10(length(tekstas)+1-kabl_poz);
     if yra_min then skaitymas:=-TXTiSK else skaitymas:=TXTiSK;
   until not klaida;
END;
{-=pabaiga=-}
{ TiS¨ }

