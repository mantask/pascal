
{$v-}

program _list; { LIST.PAS }
{ Simple (unfinished) list-program, by Bas van Gaalen }
uses dos,u_txt,u_misc,u_kb;

type
  lineptr=^linerec;
  linerec=record
    line:string;
    next:lineptr;
  end;

var
  txtfile:text;
  firstline,curline,lastline:lineptr;
  search:string[50];
  noflines:word;
  ascii,clear:boolean;

{----------------------------------------------------------------------------}

procedure initialize;
var fname:pathstr; hexcnt,total:longint; i:byte;
begin
  if paramstr(1)='' then begin
    writeln('Enter filename on commandline'); halt; end;
  fname:=paramstr(1);

  assign(txtfile,fname);
  {$i-} reset(txtfile); {$i+}
  if ioresult<>0 then begin
    writeln('File not found...'); halt; end;

  hexcnt:=0;
  total:=0;
  noflines:=0;
  new(firstline);
  firstline^.next:=nil;
  curline:=firstline;
  repeat
    readln(txtfile,curline^.line);
    for i:=1 to length(curline^.line) do
      if not (ord(curline^.line[i]) in [9..13,32..254]) then inc(hexcnt);
    inc(total,length(curline^.line));
    new(curline^.next);
    curline:=curline^.next;
    inc(noflines);
  until eof(txtfile);
  curline^.next:=nil;
  lastline:=curline^.next;
  ascii:=(hexcnt/total)<0.10;

  fillchar(search,sizeof(search),0);

  cursoroff;
end;

{----------------------------------------------------------------------------}

procedure list;
var scrpos:longint; key:word; stpos:integer; i:byte; escape:boolean;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure dumpscreen(linenum:longint; start:integer);
var tmp:string[80]; i:word; len:byte;
begin
  i:=0;
  curline:=firstline;
  while (i<>linenum) and (curline<>lastline) do begin
    curline:=curline^.next; inc(i); end;
  i:=1;
  while (i<=rows) and (curline^.next<>lastline) do begin
    fillchar(tmp,sizeof(tmp),#0);
    if length(curline^.line)<start then len:=0
    else if integer(length(curline^.line))-start>80 then len:=80
    else len:=length(curline^.line)-start;
    move(curline^.line[start+1],tmp[1],len);
    tmp[0]:=#80;
    dspat(tmp,0,i,lightgray);
    curline:=curline^.next;
    inc(i);
  end;
  if i<rows then filltext(' ',0,i,79,pred(rows),lightgray);
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

procedure find(var linenum:longint; var start:integer; searchstart:word);
var i:word; found:boolean;
begin
  if searchstart=0 then begin
    filltext(' ',0,0,79,0,_lightgray);
    dspat('Search: ',1,0,_lightgray);
    i:=input(9,0,search,[#31..#126],30,_lightgray+blue,_lightgray,nocap,pos_le);
  end;
  curline:=firstline; i:=0;
  while (i<>searchstart) and (curline<>lastline) do begin
    curline:=curline^.next; inc(i); end;
  found:=false;
  while (not found) and (curline<>lastline) do begin
    found:=pos(strup(search),strup(curline^.line))<>0;
    if not found then begin
      curline:=curline^.next; inc(i); end;
  end;
  if found then begin
    linenum:=I; start:=0; end
  else begin
    filltext(' ',0,0,79,0,_lightgray);
    dspat('* Not Found *',1,0,_lightgray+blue);
    clear:=false;
  end;
end;

{- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - }

begin
  clrscr;
  scrpos:=0; stpos:=0; escape:=false; clear:=true;
  repeat
    dumpscreen(scrpos,stpos);
    if clear then begin
      filltext(' ',0,0,79,0,_lightgray);
      if ascii then dspat('ASCII',59,0,_lightgray)
      else dspat('HEX  ',59,0,_lightgray);
      dspat(lz(succ(scrpos),3)+'/'+lz(succ(noflines),3),66,0,_lightgray);
      dspat(lz(stpos,3),74,0,_lightgray);
    end;
    clear:=true;
    key:=getekey;
    case key of
      crsrup:if scrpos>0 then dec(scrpos);
      crsrdown:if scrpos<noflines then inc(scrpos);
      crsrpgup:if scrpos-rows>=0 then dec(scrpos,rows) else scrpos:=0;
      crsrpgdn:if scrpos<=noflines-rows then inc(scrpos,rows);
      crsrhome:scrpos:=0;
      crsrend:scrpos:=noflines-rows+1;
      crsrright:if stpos+10<=210 then inc(stpos,10);
      crsrleft:if stpos-10>=0 then dec(stpos,10);
      crsrcend:stpos:=210;
      crsrhome:stpos:=0;
      crsresc:escape:=true;
      ord('F'),ord('f'):find(scrpos,stpos,0);
      ord('N'),ord('n'):find(scrpos,stpos,succ(scrpos));
    end;
  until escape;
  clrscr;
  cursoron;
end;

{----------------------------------------------------------------------------}

begin
  initialize;
  list;
end.
