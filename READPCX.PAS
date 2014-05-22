uses crt;

type palette = array [0 .. 255] of record r, g, b : byte end;
     buffer = array [0 .. 65534] of byte;
procedure readpcx (fn : string; mx, my : integer; p : pointer; var pal : palette);
  var f : file;
      buf : ^buffer;
      fp, s, ck, c : longint;
      cl : byte;
      pp : ^buffer;
begin
  assign (f, fn);  reset (f, 1);
  s := filesize (f);
  if s > 65535 then exit;
  getmem (buf, s);
  blockread (f, buf^, s);
  close (f);
  pp := p;
  fp := 127;
  c := 0;
  for ck := 0 to mx*my do
    begin
      if c = 0 then begin
                      inc (fp);
                      if buf^[fp] > 192 then begin
                                        c := buf^[fp] - 192;
                                        inc (fp);
                                        cl := buf^[fp];
                                      end
                                  else begin
                                         c := 1;
                                         cl := buf^[fp];
                                       end
                    end;
      pp^[ck] := cl;
      dec (c);
    end;

  for c := 0 to 255 do        { nustatom palete }
   begin
     pal[c].r := buf^[fp+1];
     pal[c].g := buf^[fp+2];
     pal[c].b := buf^[fp+3];
     inc (fp, 3);
   end;
  freemem (buf, s);
end;



type masas = array [1 .. 20, 1 ..20] of byte;
  var pm : ^masas;
      pal : palette;
      ck, cx, cy : integer;



begin
  asm
    mov ax, 13h
    int 10h
  end;

  getmem (pm, 400);
  readpcx ('a:\zmon\pcx\zmbazuk1.pcx', 20, 20, pm, pal);

  port[$3c8] := 0;
  for ck := 0 to 255 do
  begin
    port[$3c9] := pal[ck].r div 4;
    port[$3c9] := pal[ck].g div 4;
    port[$3c9] := pal[ck].b div 4;
  end;


  for cy := 1 to 20 do
    for cx := 1 to 20 do
      mem[$a000:cy*320+cx] := pm^[cy,cx];



  freemem (pm, 400);
  readkey;
  asm
    mov ax, 03h
    int 10h
  end;
end.