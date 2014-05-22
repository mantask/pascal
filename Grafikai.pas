program Grafikai;
uses graph, crt;

const
  sp1 = 7;
  sp2 = 8;
  sp3 = 9;
  sp4 = 12;

var FunkTipas: integer;

    a, b, c, k: real; { parametrai }
    key : byte;
    n: integer;
    AInt, BInt, CInt, KInt: integer;
    IsAInteger, IsBInteger, IsCInteger, IsKInteger: boolean;
    ATrupm, BTrupm, CTrupm, KTrupm, NTrupm: byte;

procedure Inicializacija;
var
  grDriver: Integer;
  grMode: Integer;
  ErrCode: Integer;
begin
  grDriver := Detect;
  InitGraph(grDriver, grMode,'');
  ErrCode := GraphResult;
  if ErrCode <> grOk then
    Writeln('Graphics error:', GraphErrorMsg(ErrCode));
end; { Inicializacija }

procedure Meniu;
  var i: integer;
      y: integer;
      Skaicius: string;
begin
  setfillstyle (0, sp2);
  bar (0, 0, 639, 479);
  SetBkColor(sp2);
  SetColor(sp1);

  SetTextStyle(0, 1, 0);
  outtextxy (637, 240, 'Jurgis Graÿys (c) 2003');
  SetTextStyle(0, 0, 0);

  { Keturkampiu braizymas }
  SetTextStyle(0,0,2);
  SetLineStyle(0,0,1);
  y:= 120;
  for i:= 1 to 9 do
    begin
      Rectangle(60, y, 90, y + 30);
      Str(i, Skaicius);
      OutTextXY(69, y + 9, Skaicius);
      y:= y + 35;
    end;
  setcolor (sp4);
  Rectangle(100, 120, 580, 150);
  setcolor (sp1);

  { Uzrasai }
  SetTextStyle(0,0,3);
  OutTextXY(100,30, 'Funkcij÷ grafikai');
  SetTextStyle(0,0,2);
  OutTextXY(50,80, 'Pasirinkite norim– funkcijos tip–: ');
  SetLineStyle(0,0,3);
  Rectangle(80, 15, 520, 65);
  Line(30,440,610,440);
  SetTextStyle(0,0,1);
  OutTextXY(70,455,'Rodykli÷ klavi’ais pasirinkite funkcij– ir paspauskite <ENTER>');
  OutTextXY(110, 132, 'Tiesin” funkcija  y = kx + b');
  OutTextXY(110, 167, 'Kvadratin” funkcija  y = ax˝ + bx + c');
  OutTextXY(110, 202, 'Atvirk’tinis proporcingumas y = ');
  SetLineStyle(0,0,1);
  Line(365, 205, 380, 205);
  OutTextXY(370, 195, 'k');
  OutTextXY(370, 207, 'x');
  OutTextXY(110, 237, 'Laipsnin” funkcija  y = x');
  OutTextXY(312, 232, 'n');
  OutTextXY(110, 272, 'Modulio funkcija  y = |ax|');
  OutTextXY(110, 307, 'Logaritmin” funkcija  y = log x');
  OutTextXY(110, 342, 'Sinuso funkcija  y = sin ax');
  OutTextXY(110, 377, 'Kosinuso funkcija  y = cos ax');
  OutTextXY(110, 412, 'I’eiti i’ programos');
end; { Meniu }

procedure Pasirinkimas(var Tipas: integer);
  var Jau: boolean;
      k: char;
      nr: integer;
      y: integer;
begin
  nr:= 1;
  Jau:= False;
  y:= 120;
  while not Jau do
    begin
      k:= readkey;
      if k = #13 then Jau:= True;
      if k = #0 then
        begin
          k:= readkey;
          if k = #72
            then
              begin  { i virsu }
                if nr = 1
                 then
                  begin
                    SetColor(sp2);
                    Rectangle(100, 120, 580, 150);
                    SetColor(sp4);
                    Rectangle(100, 400, 580, 430);
                    nr:= 9;
                    y:= 400;
                  end
                 else
                  begin
                    SetColor(sp2);
                    Rectangle(100, y, 580, y + 30);
                    SetColor(sp4);
                    y:= y - 35;
                    Rectangle(100, y, 580, y + 30);
                    nr:= nr - 1;
                  end;
              end;
          if k = #80
            then
              begin { i apacia }
                if nr = 9
                 then
                  begin
                    SetColor(sp2);
                    Rectangle(100, 400, 580, 430);
                    SetColor(sp4);
                    Rectangle(100, 120, 580, 150);
                    nr:= 1;
                    y:= 120;
                  end
                 else
                  begin
                    SetColor(sp2);
                    Rectangle(100, y, 580, y + 30);
                    SetColor(sp4);
                    y:= y + 35;
                    Rectangle(100, y, 580, y + 30);
                    nr:= nr + 1;
                  end;
              end;
        end;
    end;
  Tipas:= nr;
end; { Pasirinkimas }

procedure Formule(Tipas: integer);
var SveikSk: integer;
    TrupmSk: real;

  procedure Ivedimas(raide: char; var skint: integer; var rsk: real; var TSk: byte);
    var x: integer;
        k: char;
        Jau: boolean;
        ilgis: integer;
        skaicius: string;
        temp: string;

    function Galima(k: char): boolean;

      function Nera: boolean;
        var i: integer;
            N: boolean;
      begin
        N:= True;
        for i:= 1 to Length(skaicius) do
          N:= N and (not (skaicius[i] in [',', '.']));
        Nera:= N;
      end; { Nera }

    begin
      case k of
        '-': Galima:= ilgis = 0;
        '.' , ',': Galima:= (ilgis < 7) and (ilgis > 0) and Nera;
      end;
    end; { Galima }

    procedure Koeficientas(sk: string; var int: integer; var realsk: real; var TrupmSk: byte);
      var i, j, laipsn: integer;
          vardiklis: longint;
          Trupmena, minus: boolean;
          ssk: string;
          rezint: integer;
          rezreal: real;
          skaitmuo, code: integer;
    begin
      rezint:= 0;
      trupmena := false;
      rezreal:= 0;
      ssk:= sk;
      if ssk[1] = '-'
        then
          begin
            minus:= true;
            ssk:= Copy(ssk, 2, Length(ssk) - 1);
          end
        else
          minus:= false;
      i:= 1;
      while (not (ssk[i] in [',', '.'])) and (i <= length(ssk)) do
        begin
          val(ssk[i], skaitmuo, code);
          rezint:= rezint * 10 + skaitmuo;
          i:= i + 1;
        end;
      if i < length(ssk)
        then
          begin
            trupmena := true;
            if ssk[i] in [',', '.']
              then
                begin
                  rezreal:= rezint;
                  laipsn:= 1;
                  i:= i + 1;
                  while i <= length(ssk) do
                    begin
                      vardiklis:= 1;
                      for j:= 1 to laipsn do
                        vardiklis:= vardiklis * 10;
                      val(ssk[i], skaitmuo, code);
                      rezreal:= rezreal + skaitmuo / vardiklis;
                      i:= i + 1;
                      laipsn:= laipsn + 1;
                    end;
                end;
          end;
      if minus
        then
          begin
            int:= 0 - rezint;
            realsk:= 0 - rezreal;
          end
        else
          begin
            int:= rezint;
            realsk:= rezreal;
          end;
      if trupmena then TrupmSk:= laipsn - 1
                  else trupmsk := 0;
    end; { Koeficientas }

  begin { Ivedimas }
    SetColor(sp1);
    SetFillStyle(0, sp3);
    bar(90, 158, 500, 310);
    Rectangle(90, 158, 500, 250);
    SetColor(sp1);

    OutTextXY(100, 170, 'Ωveskite koeficient–  :');
    OutTextXY(440, 170, raide);
    Rectangle(200, 200, 350, 240);
    x:= 210;
    Line(x, 235, x+17, 235);
    Jau:= False;
    ilgis:= 0;
    skaicius:= '';
    while not Jau do
      begin
        k:= readkey;
        if k = #13 then Jau:= True;
        if ((k in ['0'..'9']) and (ilgis < 7))
           or ((k in ['-', '.', ',']) and galima(k))
          then
            begin
              SetColor(sp1);
              inc(ilgis);
              OutTextXY(x, 215, k);
              SetColor(sp2);
              Line(x, 235, x+17, 235);
              x:= x + 17;
              SetColor(sp1);
              Line(x, 235, x+17, 235);
              skaicius:= skaicius + k;
            end;
        if (k = #8) and (ilgis > 0)
          then
            begin
              SetColor(sp2);
              Line(x, 235, x+17, 235);
              x:= x - 17;
              SetColor(sp1);
              Line(x, 235, x+17, 235);

              SetColor(sp2);
              SetFillStyle(0, sp1);
              bar(x, 210, x+17, 232);
              dec(ilgis);
              skaicius:= Copy(skaicius, 1, Length(skaicius) - 1);
            end;
      end;
    Koeficientas(skaicius, skint, rsk, TSk);
  end; { Ivedimas }

  procedure Tipas1(var KInt, BInt: integer; var Tk, Tb: real);
    var TTk, TTb: real;
  begin
    Ivedimas('k', KInt, TTk, KTrupm);
    Ivedimas('b', BInt, TTb, BTrupm);
    Tk:= TTk;
    Tb:= TTb;
  end; { Tipas1 }

  procedure Tipas2(var AInt, BInt, CInt: integer; var Ta, Tb, Tc: real);
    var TTa, TTb, TTc: real;
  begin
    Ivedimas('a', AInt, TTa, ATrupm);
    Ivedimas('b', BInt, TTb, BTrupm);
    Ivedimas('c', CInt, TTc, CTrupm);
    Ta:= TTa;
    Tb:= TTb;
    Tc:= TTc;
  end; { Tipas2 }

  procedure Tipas3(var KInt: integer; k: real);
  begin
    Ivedimas('k', KInt, k, KTrupm);
  end; { Tipas3 }

  procedure Tipas4(var n: integer);
    var nreal: real;
  begin
    Ivedimas('n', n, nreal, NTrupm);
  end; { Tipas4 }

  procedure Tipas5(var AInt: integer; var Ta: real);
    var TTa: real;
  begin
    Ivedimas('a', AInt, TTa, ATrupm);
    Ta:= TTa;
  end; { Tipas5 }

  procedure Tipas6(var AInt: integer; var Ta: real);
    var TTa: real;
  begin
    Ivedimas('a', AInt, TTa, ATrupm);
    Ta:= TTa;
  end; { Tipas6 }

  procedure Tipas7(var AInt: integer; var Ta: real);
    var TTa: real;
  begin
    Ivedimas('a', AInt, TTa, ATrupm);
    Ta:= TTa;
  end; { Tipas7 }

  procedure Tipas8(var AInt: integer; var Ta: real);
    var TTa: real;
  begin
    Ivedimas('a', AInt, TTa, ATrupm);
    Ta:= TTa;
  end; { Tipas8 }

begin { Formule }
  setcolor (sp1);
  setfillstyle (1, sp2);
  bar (0, 0, 639, 479);
  SetTextStyle(0,0,3);
  OutTextXY(90, 30, 'Funkcijos ‘vedimas');
  SetLineStyle(0,0,3);
  Rectangle(70, 15, 540, 65);
  SetTextStyle(0,0,2);
  OutTextXY(40, 80, 'J◊s÷ pasirinktos funkcijos tipas: ');

  { funkcijos tipo pavadinimas}
  case Tipas of
    1: OutTextXY(200, 105, 'y = kx + b');
    2: OutTextXY(160, 105, 'y = ax˝ + bx + c');
    3: begin
         OutTextXY(250, 115, 'y = ');
         Line(305, 123, 345, 123);
         OutTextXY(320, 102, 'k');
         OutTextXY(320, 127, 'x');
       end;
    4: begin
         OutTextXY(250, 110, 'y = x');
         OutTextXY(330, 100, 'n');
       end;
    5: begin
         OutTextXY(250, 110, 'y = |ax|');
       end;
    6: begin
         OutTextXY(220, 110, 'y = log x');
         OutTextXY(332, 121, 'a');
       end;
    7: begin
         OutTextXY(220, 110, 'y = sin');
         OutTextXY(343, 110, 'ax');
       end;
    8: begin
         OutTextXY(220, 110, 'y = cos');
         OutTextXY(343, 110, 'ax');
       end;
  end; { case }

  case Tipas of
    1: begin
         Tipas1(Kint, BInt, k, b);
         if k = 0.0
           then IsKInteger:= true
           else IsKInteger:= false;
         if b = 0.0
           then IsBInteger:= true
           else IsBInteger:= false;
       end;
    2: begin
         Tipas2(AInt, BInt, CInt, a, b, c);
         if a = 0.0
           then IsAInteger:= true
           else IsAInteger:= false;
         if b = 0.0
           then IsBInteger:= true
           else IsBInteger:= false;
         if c = 0.0
           then IsCInteger:= true
           else IsCInteger:= false;
       end;
    3: begin
         Tipas3(KInt, k);
         if k = 0.0
           then IsKInteger:= true
           else IsKInteger:= false;
       end;
    4: Tipas4(n);
    5: begin
         Tipas5(AInt, a);
         if a = 0.0
           then IsAInteger:= true
           else IsAInteger:= false;
       end;
    6: begin
         Tipas6(AInt, a);
         if a = 0.0
           then IsAInteger:= true
           else IsAInteger:= false;
       end;
    7: begin
         Tipas7(AInt, a);
         if a = 0.0
           then IsAInteger:= true
           else IsAInteger:= false;
       end;
    8: begin
         Tipas8(AInt, a);
         if a = 0.0
           then IsAInteger:= true
           else IsAInteger:= false;
       end;
  end; { case }

end; { Formule }

procedure Grafikas(Tipas: integer);
  var Temp: string;
      x: integer;

  procedure FunkcijosUzrasas;
  begin
    setfillstyle (1, 0);
    bar (0, 0, 639, 479);
    setcolor (sp1);
    SetTextStyle(0,0,3);
    OutTextXY(50,30,'Funkcija:');
    Rectangle(30, 15, 610, 65);
    SetTextStyle(0,0,2);
    x:= 315;
    OutTextXY(270,35, 'y');
    OutTextXY(295,35, '=');
    case Tipas of
      1: begin
           if KInt <> 1
           then
             begin
             if IsKInteger
               then
                 begin
                   Str(Kint, Temp);
                   OutTextXY(315, 35, Temp);
                 end
               else
                 begin
                   Str(k: 0: KTrupm, Temp);
                   OutTextXY(315, 35, Temp);
                 end;
             x:= x + Length(Temp) * 16;
             end;
           OutTextXY(x, 35, 'x');
           x:= x + 20;
           if IsBInteger
             then
               begin
                 Str(Bint, Temp);
                 if BInt >= 0
                   then
                     begin
                       OutTextXY(x, 35, '+');
                       OutTextXY(x + 20, 35, Temp);
                     end
                   else OutTextXY(x, 35, Temp);
               end
             else
               begin
                 Str(b: 0: BTrupm, Temp);
                 if b >= 0
                   then
                     begin
                       OutTextXY(x, 35, '+');
                       OutTextXY(x + 20, 35, Temp);
                     end
                   else OutTextXY(x, 35, Temp);
               end;
         end;
      2: begin
           if AInt <> 1 then
           begin
           if IsAInteger
             then
               begin
                 Str(Aint, Temp);
                 OutTextXY(315, 35, Temp);
               end
             else
               begin
                 Str(a: 0: ATrupm, Temp);
                 OutTextXY(315, 35, Temp);
               end;
           x:= x + Length(Temp) * 16;
           end;
           OutTextXY(x, 35, 'x˝');
           x:= x + 40;
           if BInt <> 1
           then
             begin
             if IsBInteger
               then
                 begin
                   Str(BInt, Temp);
                   if BInt >= 0
                     then
                       begin
                         OutTextXY(x, 35, '+');
                         OutTextXY(x + 20, 35, Temp);
                       end
                     else OutTextXY(x, 35, Temp);
                 end
               else
                 begin
                   Str(b: 0: BTrupm, Temp);
                   if b >= 0
                     then
                       begin
                         OutTextXY(x, 35, '+');
                         OutTextXY(x + 20, 35, Temp);
                       end
                     else OutTextXY(x, 35, Temp);
                 end;
             if BInt >= 0
               then x:= x + (Length(Temp) + 1) * 18
               else x:= x + Length(Temp) * 18;
             end
           else
             begin
               OutTextXY(x, 35, '+');
               x:= x + 20;
             end;
           OutTextXY(x, 35, 'x');
           x:= x + 20;
           if IsCInteger
             then
               begin
                 Str(Cint, Temp);
                 if CInt >= 0
                   then
                     begin
                       OutTextXY(x, 35, '+');
                       OutTextXY(x + 20, 35, Temp);
                     end
                   else OutTextXY(x, 35, Temp);
               end
             else
               begin
                 Str(c: 0: CTrupm, Temp);
                 if c >= 0
                   then
                     begin
                       OutTextXY(x, 35, '+');
                       OutTextXY(x + 20, 35, Temp);
                     end
                   else OutTextXY(x, 35, Temp);
               end;
         end;
      3: begin
           Str(KInt, Temp);
           OutTextXY(325, 22, Temp);
           Line(315,42,315 + (Length(Temp) + 1) * 16 ,42);
           OutTextXY(315 + Length(Temp) * 8, 46, 'x');
         end;
      4: begin
           OutTextXY(320, 35, 'x');
           Str(n, Temp);
           OutTextXY(338, 25, Temp);
         end;
      5: begin
           OutTextXY(x,35,'|');
           x:= x + 20;
             if Aint <> 1
             then
               begin
                 if IsAInteger
                   then
                     begin
                       Str(Aint, Temp);
                       OutTextXY(x, 35, Temp);
                     end
                   else
                     begin
                       Str(a: 0: ATrupm, Temp);
                       OutTextXY(x, 35, Temp);
                     end;
                 x:= x + Length(Temp) * 16;
               end;
               OutTextXY(x, 35, 'x|');
         end;
      6: begin
           OutTextXY(x, 35, 'log x');
         end;
      7: begin
           OutTextXY(x, 35, 'sin');
           x:= x + 55;
           if AInt <> 1 then
           begin
           if (AInt < 0) or (a < 0) then
             begin
               OutTextXY(x, 35, '(');
               x:= x + 20;
             end;
           if IsAInteger
             then
               begin
                 Str(Aint, Temp);
                 OutTextXY(x, 35, Temp);
               end
             else
               begin
                 Str(a: 0: ATrupm, Temp);
                 OutTextXY(x, 35, Temp);
               end;
           x:= x + Length(Temp) * 16;
           end;
           OutTextXY(x, 35, 'x');
           if (AInt < 0) or (a < 0) then
             begin
               x:= x + 20;
               OutTextXY(x, 35, ')');
             end;
         end;
      8: begin
           OutTextXY(x, 35, 'cos');
           x:= x + 55;
           if AInt <> 1 then
           begin
           if (AInt < 0) or (a < 0) then
             begin
               OutTextXY(x, 35, '(');
               x:= x + 20;
             end;
           if IsAInteger
             then
               begin
                 Str(Aint, Temp);
                 OutTextXY(x, 35, Temp);
               end
             else
               begin
                 Str(a: 0: ATrupm, Temp);
                 OutTextXY(x, 35, Temp);
               end;
           x:= x + Length(Temp) * 16;
           end;
           OutTextXY(x, 35, 'x');
           if (AInt < 0) or (a < 0) then
             begin
               x:= x + 20;
               OutTextXY(x, 35, ')');
             end;
         end;
    end;
  end; { FunkcijosUzrasas }

  procedure KoordinaciuAshys;
    var x, y: integer;
        i: integer;
        stri: string;
  begin
    SetLineStyle(0,0,1);
    setcolor (sp1);
    Line(20,270,630,270);
    Line(630,270,615,273);
    Line(630,270,615,267);
    Line(320,70,320,470);
    Line(320,70,317,85);
    Line(320,70,323,85);
    SetTextStyle(0,0,1);
    OutTextXY(625, 275, 'x');
    OutTextXY(325, 68, 'y');
    x:= 40;
    while x <= 600 do
      begin
        line(x, 269, x, 271);
        x:= x + 20;
      end;
    y:= 90;
    while y <= 450 do
      begin
        line(319, y, 321, y);
        y:= y + 20;
      end;
    SetTextStyle(0,0,1);
    x:= 40;
    for i:= -28 to 28 do
      begin
        if abs(i) mod 6 = 0
        then
          begin
            str(i, stri);
            if abs(i) < 10
              then
                if i > 0
                  then OutTextXY(x-2, 273, stri)
                  else
                    if i = 0
                      then OutTextXY(x+3, 273, stri)
                      else OutTextXY(x-5, 273, stri)
              else
                if i < 0
                  then OutTextXY(x-8, 273, stri)
                  else OutTextXY(x-4, 273, stri)
          end;
        x:= x + 10;
      end;
    y:= 470;
    for i:= -20 to 20 do
      begin
        if (abs(i) mod 6 = 0) and (i <> 0)
        then
          begin
            str(i, stri);
            OutTextXY(324, y - 3, stri);
          end;
        y:= y - 10;
      end;
  end; { KoordinaciuAshys }

  procedure Braizymas;
    var x, y: real;
        koordx, koordy: integer;
        pirmas: boolean;
        i: integer;

    procedure Koordinates(skx, sky: real; var kx, ky: integer);
    var
      xx, yy : real;
    begin
      xx := 320 + skx * 10;
      yy := 270 - sky * 10;
      if (xx >= 0) and (xx <= 639) then kx := round (xx)
                                   else kx := 640;
      if (yy >= 0) and (yy <= 479) then ky := round (yy)
                                   else ky := 480;
    end; { Koordinates }

  begin
    setcolor (sp4);
    SetLineStyle(0,0,3);
    pirmas:= true;
    x:= - 30;
    while x < 30 do
      begin
        case Tipas of
          1: begin
               if IsKInteger
                 then
                   if IsBInteger
                     then y:= KInt * x + BInt
                     else y:= KInt * x + b
                 else
                   y:= k * x + b;
             end;
          2: begin
               if IsAInteger
                 then
                   if IsBInteger
                     then
                       if IsCInteger
                         then y:= AInt * x * x + BInt * x + CInt
                         else y:= AInt * x * x + BInt * x + c
                     else
                       if IsCInteger
                         then y:= AInt * x * x + b * x + CInt
                         else y:= AInt * x * x + b * x + c
                 else
                   if IsBInteger
                     then
                       if IsCInteger
                         then y:= a * x * x + BInt * x + CInt
                         else y:= a * x * x + BInt * x + c
                     else
                       if IsCInteger
                         then y:= a * x * x + b * x + CInt
                         else y:= a * x * x + b * x + c;
             end;
          3: begin
               if (x < 0.01) and (x > -0.01)
                 then begin
                        pirmas:= true;
                        y:= maxint / 25;
                      end
                 else
                   if IsKInteger
                     then y:= KInt / x
                     else y:= k / x;
             end;
          4: begin
               y:= 1;
               if n > 0
                 then for i:= 1 to n do y:= y * x
                 else
                   if (x < 0.01) and (x > -0.01)
                     then begin
                            pirmas:= true;
                            y:= maxint / 25;
                          end
                     else for i:= 1 to abs(n) do y:= y / x;
             end;
          5: begin
               if IsAInteger
                 then y:= abs(AInt * x)
                 else y:= abs(a * x);
             end;
          6: begin
               if x > 0 then y:= ln(x)
                        else y:= maxint / 25;
             end;
          7: begin
               if IsAInteger
                 then y:= sin(AInt * x)
                 else y:= sin(a * x);
             end;
          8: begin
               if IsAInteger
                 then y:= cos(AInt * x)
                 else y:= cos(a * x);
             end;
        end; { case }
        Koordinates(x, y, koordx, koordy);
        if (koordx > 0) and (koordx < 640)
          and (koordy > 67) and (koordy < 480)
            then
              if pirmas
                then
                  begin
                    MoveTo(koordx, koordy);
                    pirmas:= false;
                  end
                else LineTo(koordx, koordy)
            else
              begin
                pirmas:= true;
                y:= maxint / 25;
              end;
        x:= x + 0.01;
      end;
    setcolor (sp1);
    OutTextXY(440, 457, 'Paspauskite ENTER');
    rectangle(430,450,585,470);
  end; { Braizymas }

begin { Grafikas }
  FunkcijosUzrasas;
  KoordinaciuAshys;
  Braizymas;
end;

var iseiti: boolean;

begin
  Inicializacija;
  iseiti:= false;
  repeat
    Meniu;
    Pasirinkimas(FunkTipas);
    if FunkTipas = 9
      then iseiti:= true
      else
        begin
          Formule(FunkTipas);
          Grafikas(FunkTipas);
          repeat
            key := ord (readkey)
          until key = 13
        end;
  until iseiti;
  CloseGraph;
end.

