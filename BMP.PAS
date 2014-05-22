program bmp;

const
  vardas = 'pict.bmp';  { paveiksliuko failas }

var
  f : file; { BMP failas }
  ckx, cky : word;
  sp : byte;
  c : char;
  wordas : record
             hi, lo : byte
           end;
  dWordas : record
              hi, lo : word
            end;
  pict : record
           Tipas : string [2];
           dydis : Dwordas
         end;

begin
  assign (f, vardas);
  reset (f);
  blockRead (f, wordas, sizeof (wordas));
  pict.tipas := chr (wordas.hi) + chr (wordas.Lo);
  close (f);
end.