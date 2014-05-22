
program textscroll; { SCR_TXT2.PAS }
{ Textscroll, use CHARSET.PAS to create CHARS.INC. By Bas van Gaalen }
uses u_vga,u_txt,u_kb;
const
{$i chars.inc}
  tseg:word=$b800; hi=1;
  txt:string=
    'howdy world...     this is a multicolored-bigchar-'+
    'proportional-''smooth''-textscroll...          of '+
    'course made by bas van gaalen!     it contains an '+
    'extensive number of characters: 0 1 2 3 4 5 6 7 8 '+
    '9 :-) ( / ? ! , . etc...       ';
  cpos:array[0..46] of word=(
    0,5,12,19,26,33,40,47,54,61,65,72,80,87,97,104,111,118,125,132,139,146,
    153,160,170,177,184,191,195,200,205,211,215,222,227,232,240,247,252,259,
    266,273,280,287,294,301,308);
  clen:array[0..46] of byte=(
    3,7,7,7,7,7,7,7,7,4,7,7,7,10,7,7,7,7,7,7,7,7,7,10,7,7,7,4,5,5,6,4,7,5,
    5,4,7,5,7,7,7,7,7,7,7,7,6);

var
  i,cur,idx,line:byte;

begin
  setvideo(259);
  cursoroff;
  dspat('As you can see, not the complete screen is scrolling...',-1,6,lightgray);
  idx:=1;
  repeat
    cur:=ord(txt[idx]);
    idx:=1+idx mod length(txt);
    { conv ascii to table }
    case cur of
      32:cur:=0;
      33:cur:=31;
      39:cur:=29;
      40,41:dec(cur,7);
      44:cur:=28;
      45:cur:=30;
      46:cur:=27;
      47:cur:=46;
      48..57:dec(cur,12);
      58:cur:=35;
      63:cur:=32;
      65..90:dec(cur,64);
      97..122:dec(cur,96);
    end;
    for i:=0 to pred(clen[cur]) do begin
      vretrace;
      for line:=0 to 4 do begin
        move(mem[tseg:(hi+line)*160+2],mem[tseg:(hi+line)*160],158);
        memw[tseg:158+(hi+line)*160]:=chars[line,cpos[cur]+i];
      end;
    end;
  until keypressed;
  cursoron;
end.
