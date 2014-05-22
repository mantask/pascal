{ ne mano, bet irgi geras }
                {**********\ Состваитель А.Ю.Романов /**********}
   Program Zvezda_3D;
   Uses Graph,CRT;
   Type koord2D= array [1..2] of word;
   Const
      { Коэфицент  и скорость поворота фигуры }
      plavnost=0.7;
      skorost=0;
      { Количество точек,для которых задаются координаты }
      koltchk=12;
      { Cписок 3D координат по OX}
      dannyeX: array [1..koltchk] of shortint =
               (   0,   0, -94, -20,   0,  20,  94,  32,  52,   0, -52, -32);
      { Cписок 3D координат по OY}
      dannyeY: array [1..koltchk] of shortint =
               ( -15,  15,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0);
      { Cписок 3D координат по OZ}
      dannyeZ: array [1..koltchk] of shortint =
               (   0,   0,  30,  30,  94,  30,  30, -10, -70, -32, -70, -10);
      { Количество отрезков в фигуре }
      kolotr=30;
      { Cписок номеров соединяющихся точек }
      lines:   array [1..kolotr,1..2] of byte =
               ( ( 1, 3), ( 1, 4), ( 1, 5), ( 1, 6), ( 1, 7),
                 ( 1, 8), ( 1, 9), ( 1,10), ( 1,11), ( 1,12),
                 ( 2, 3), ( 2, 4), ( 2, 5), ( 2, 6), ( 2, 7),
                 ( 2, 8), ( 2, 9), ( 2,10), ( 2,11), ( 2,12),
                 ( 3, 4), ( 4, 5), ( 5, 6), ( 6, 7), ( 7, 8),
                 ( 8, 9), ( 9,10), (10,11), (11,12), (12, 3));
   Var

      { 3D система,в которой поворачивается фигура }
      ox3D,oy3D,oz3D:array [1..koltchk] of integer;
      { Старый и новый списки 2D координат }
      polst, polnov: array [1..koltchk] of koord2D;
      { Угол поворота }
      ugpov: real;
      { Sin,Cos угла поворта }
      sinpov,cospov: real;
      { Будут смещать 2D тчк(0,0) в центр экрана }
      xx,zz:word;
{--------------------------------------------------------------------------}
  Procedure GraphInit;
    { Инициализация графического режима }
    Var GrDr,DrMo:integer;
    Begin
       GrDr:=Detect;
       InitGraph(GrDr,DrMo,'');
       xx:=Trunc(GetMaxX/2);
       zz:=Trunc(GetMaxY/2);
    End;
{--------------------------------------------------------------------------}
   Procedure Povorot;
   { Заполняет ox3D,oy3D новыми координатами }
      Var a:byte;
      Begin
         sinpov:=Sin(ugpov);
         cospov:=Cos(ugpov);
         For a:=1 to koltchk do
            Begin
               ox3D[a]:=Trunc( dannyeX[a]*cospov + dannyeY[a]*sinpov );
               oy3D[a]:=Trunc(-dannyeX[a]*sinpov + dannyeY[a]*cospov );
               oz3D[a]:=dannyeZ[a];
            End;
      End;
{--------------------------------------------------------------------------}
   Procedure Perevod;
   { Переводит повернутые 3D координаты на плоскость экрана }
   { т.е.  ox3D,oy3D,oz3D  в polnov }
      Var a:byte;
      Begin
         For a:=1 to koltchk do
            Begin
               polnov[a,1]:= ox3D[a]*2 + xx;
               polnov[a,2]:=Trunc(-oz3D[a] - oy3D[a]/3)*2 + zz;
            End;
      End;
{--------------------------------------------------------------------------}
   Procedure Izobrazi;
      { Стирает старую фигуру и по заданным точкам строит новую }
      Var a:byte;
      Begin
         For a:=1 to kolotr do
            Begin
               SetColor(black);
               Line (polst[ lines[a,1], 1 ],
                     polst[ lines[a,1], 2 ],
                     polst[ lines[a,2], 1 ],
                     polst[ lines[a,2], 2 ]);
               SetColor(yellow);
               Line (polnov[ lines[a,1], 1 ],
                     polnov[ lines[a,1], 2 ],
                     polnov[ lines[a,2], 1 ],
                     polnov[ lines[a,2], 2 ]);
            End;
      End;
{--------------------------------------------------------------------------}
   Procedure Zamena;
   { Приравнивает polst к polnov }
      Var a: byte;
      Begin
         For a:=1 to koltchk do
            Begin
               polst[a,1]:=polnov[a,1];
               polst[a,2]:=polnov[a,2];
            End;
      end;
{--------------------------------------------------------------------------}
   Begin
      GraphInit;
      Repeat
         ugpov:=ugpov+pi*plavnost/180;
         If ugpov>2*pi then ugpov:=0;
         Povorot;
         Perevod;
         Izobrazi;
         Zamena;
         Delay(skorost);
      Until KeyPressed;
      ReadKey;
      CloseGraph;
   End.