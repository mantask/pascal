program knyga;
uses crt;
var viso, persk_psl,skirtumas,sk:integer;greitis:real;
begin
 clrscr;
 writeln('PUSLAPIU APSKAICIAVIMO PROGRAMA');
 writeln('iveskite knygos puslapiu skaiciu');
 read(viso);
 writeln('Kiek jau perskaitete?');
 read(persk_psl);
 skirtumas:=viso-persk_psl;
 writeln('Dar liko: ',skirtumas);
 writeln('Kiek puslapiu perskaitote per diena?');
 read(sk);
 greitis:=skirtumas/sk;
 writeln('skaitysite dar: ', greitis :1 :1, ' dienu.');
 readkey;
end.
