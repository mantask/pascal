
(*
** Picture Viewer supports the following formats:
**
**   GIF - Compuserve <tm> Graphics Interchange Format,
**   PCX - Zsoft, (including fast-load and save procedures)
**   CEL - Autodesk Annimator brush,
**   RIX - ColorRIX/EGA Paint (SC?),
**
** and limited
**   BMP - Windows <tm> and OS/2 <tm> Device-Independant Bitmap,
**   IFF/ILBM - Electronic Arts <tm> Deluxe Paint InterLeaved BitMap
**
** Press M to force another graphics-mode
**
** This picture-viewer makes use of a general BGI-driver of Borland <tm>
**
** Made by Bas van Gaalen
*)

{$v-}

program pictureview; { PV.PAS }
{ Picture viewer }
uses
  dos,u_vga,u_txt,u_misc,u_kb,
  u_ffgif,u_ffpcx,u_ffcel,u_ffrix,u_ffbmp,u_fflbm;

{--------------------------------------------- file select consts/types/vars }

const
  itemsize=58;
  mode:shortint=-1;
  shadow:byte=darkgray;
  w_title:byte=_lightgray+lightblue;
  w_attr:byte=_lightgray+darkgray;
  w_select:byte=_blue+lightgray;
  w_scrbar:byte=_lightgray+lightblue;
  w_norm:byte=_lightgray+blue;

type
  str3=string[3];
  str20=string[20];
  str25=string[25];
  str80=string[80];
  item=string[itemsize];
  selectptr=^selectrec;
  selectrec=array[0..65000 div sizeof(item)] of item;

var
  list:selectptr;
  prevpath,globalpath:pathstr;
  curnum,files,listsize:word;
  scrsize,drives:byte;

{----------------------------------------------------------------------------}

procedure setmode;
const
  modes:array[0..7] of string[10]=(
    '320x200','640x350','640x400','640x480',
    '800x600','1024x768','1280x1024','autodetect');
var key:word; i:byte;
begin
  setscr; nwindow(60,5,74,14,' select mode ',pos_hi+pos_mi,w_title,w_attr,shadow);
  for i:=0 to 7 do dspat(chr(ord('0')+i)+'. '+modes[i],61,6+i,w_norm);
  key:=getekey;
  case key of
    crsr0:mode:=0;
    crsr1:mode:=5;
    crsr2:mode:=1;
    crsr3:mode:=2;
    crsr4:mode:=3;
    crsr5:mode:=4;
    crsr6:mode:=6;
    crsr7:mode:=-1;
  end;
  getscr;
end;

{--------------------------------------------------- file select procs/funcs }

function select(x,y,xe,ye:byte; path,title:str80; cur,max:word; listptr:selectptr):word;
var startpos,basepos:longint; prescr,scrpos,winsize:byte; esc:boolean;

procedure putline(abswinpos:byte; absbasepos:word); begin
  dsptxt(copy(listptr^[absbasepos],1,xe-x-1),x+1,y+abswinpos); end;

procedure dumpscreen(start:word);
var i,last:byte;
begin
  if max<winsize then last:=max else last:=winsize;
  for i:=1 to last do putline(i,start+i-1);
end;

begin
  if listptr=nil then exit;
  setscr; nwindow(x,y-2,xe,ye,title,pos_hi+pos_mi,w_title,w_attr,shadow);
  fillattr(x+1,y+1,xe-1,ye-1,w_norm);
  filltext(#196,x+1,y,xe-1,y,w_attr);
  dspat(copy(path,1,xe-x-1),x+1,y-1,w_norm);
  winsize:=ye-y-1; basepos:=cur;
  if cur<(winsize div 2) then startpos:=0
  else if cur>=max-(winsize div 2) then startpos:=max-winsize
  else startpos:=basepos-(winsize div 2);
  dumpscreen(startpos);
  scrpos:=cur-startpos; prescr:=succ(scrpos);
  esc:=false;
  repeat
    if prescr<>scrpos then begin
      fillattr(x+1,y+prescr,xe-1,y+prescr,w_norm);
      fillattr(x+1,y+scrpos,xe-1,y+scrpos,w_select);
      prescr:=scrpos;
    end;
    scrollbar(xe,y-1,basepos,winsize+2,max,w_scrbar);
    case getekey of
      crsrleft,
      crsrup:if basepos>1 then begin
        prescr:=scrpos;
        dec(basepos);
        if scrpos>1 then dec(scrpos)
        else begin
          scrolltexty('d',x+1,y+1,xe-1,y+winsize);
          putline(scrpos,basepos-1);
        end;
      end;
      crsrright,
      crsrdown:if basepos<max then begin
        prescr:=scrpos;
        inc(basepos);
        if scrpos<winsize then inc(scrpos)
        else begin
          scrolltexty('u',x+1,y+1,xe-1,y+winsize);
          putline(scrpos,basepos-1);
        end;
      end;
      crsrhome:if basepos<>1 then begin
        prescr:=scrpos;
        scrpos:=1;
        basepos:=1;
        dumpscreen(0);
      end;
      crsrend:if basepos<>max then begin
        prescr:=scrpos;
        if max<winsize then scrpos:=max else scrpos:=winsize;
        basepos:=max;
        dumpscreen(max-scrpos);
      end;
      crsrpgup:if scrpos>1 then begin
        prescr:=scrpos;
        if basepos-scrpos>0 then dec(basepos,scrpos-1) else basepos:=1;
        scrpos:=1;
      end
      else if basepos>1 then begin
        prescr:=scrpos;
        if basepos>winsize then dec(basepos,winsize) else basepos:=1;
        dumpscreen(basepos-scrpos);
      end;
      crsrpgdn:if scrpos<winsize then begin
        if basepos<>max then begin
          prescr:=scrpos;
          if max<winsize then begin scrpos:=max; basepos:=max; end
          else begin inc(basepos,winsize-scrpos); scrpos:=winsize; end;
        end;
      end
      else if basepos<max then begin
        if basepos<(max-winsize) then inc(basepos,winsize) else basepos:=max;
        dumpscreen(basepos-winsize);
      end;
      ord('m'),ord('M'):setmode;
      crsrcr:begin esc:=true; select:=basepos; end;
      crsresc:begin esc:=true; select:=0; end;
    end;
  until esc;
  getscr;
end;

procedure sort(l,r:integer);
var i,j:integer; x,y:pathstr;
begin
  i:=l; j:=r; x:=copy(list^[(l+r) div 2],10,3)+copy(list^[(l+r) div 2],1,8);
  repeat
    while (copy(list^[i],10,3)+copy(list^[i],1,8))<x do inc(i);
    while x<(copy(list^[j],10,3)+copy(list^[j],1,8)) do dec(j);
    if i<=j then begin
      y:=list^[i]; list^[i]:=list^[j]; list^[j]:=y;
      inc(i); dec(j);
    end;
  until i>j;
  if l<j then sort(l,j);
  if i<r then sort(i,r);
end;

function fileexist(s:pathstr):boolean; var di:searchrec; begin
  findfirst(s,anyfile,di); fileexist:=(doserror=0); end;

procedure setdrive(drive:byte); assembler; asm { 0=A: }
  mov dl,drive; mov ah,0eh; int 21h; end;

function getdrive:byte; assembler; asm { 0=A: }
  mov ah,19h; int 21h; end;

function flopdrives:byte; assembler; { 0=none, 1=A:, 2=A: & B: }
asm
  int 11h
  test al,1
  jz @nodrives
  ror al,2
  and al,3
  inc ax
  jmp @out
 @nodrives:
  xor al,al
 @out:
end;

function selectfile(path:pathstr):pathstr;
const
  cdirstr:pathstr='<DIR>';
  months:array[1..12] of str3=('jan','feb','mar','apr','may','jun',
                               'jul','aug','sep','oct','nov','dec');
var
  gifinfo:gif_inforec;
  pcxinfo:pcx_inforec;
  celinfo:cel_inforec;
  rixinfo:rix_inforec;
  bmpinfo:bmp_inforec;
  lbminfo:lbm_inforec;
  di:searchrec;
  fname:namestr; fext:extstr; fdir:dirstr;
  dt:datetime;
  tmp:str20;
  i:word;
  dummy,last,j,dr:byte;
  c:char;
begin
  setscr;
  if globalpath<>prevpath then begin
    prevpath:=globalpath;
    if list<>nil then freemem(list,listsize);
    files:=0;
    findfirst('*.*',anyfile,di);
    while doserror=0 do begin inc(files); findnext(di); end;   { count files }
    inc(files,drives);       { add number of drives to number of total files }
    listsize:=files*sizeof(item);
    getmem(list,listsize);
    i:=0;                                   { read files in select-structure }
    dr:=flopdrives;                                          { floppy-drives }
    last:=getdrive;                                     { save current drive }
    if dr>0 then
      for j:=1 to flopdrives do begin
        fillchar(list^[i],sizeof(item),0);
        list^[i][0]:=chr(itemsize);
        tmp:=#17'['+chr(ord('A')+pred(j))+':]';
        move(tmp[1],list^[i][1],length(tmp));
        inc(i);
      end;
    for dr:=2 to 25 do begin                                  { other drives }
      setdrive(dr);
      if getdrive=dr then begin
        fillchar(list^[i],sizeof(item),0);
        list^[i][0]:=chr(itemsize);
        tmp:=#17'['+chr(ord('A')+dr)+':]';
        move(tmp[1],list^[i][1],length(tmp));
        inc(i);
      end;
    end;
    setdrive(last);                                     { restore last drive }
    findfirst('*.*',anyfile,di);
    while doserror=0 do begin
      with di do begin
        fillchar(list^[i],sizeof(item),0);
        list^[i][0]:=chr(itemsize);
        if bitson(attr,directory) then begin                   { directories }
          if name<>'.' then begin
            if name<>'..' then name:=#25+name else name:=#24+name;
            move(name[1],list^[i][1],length(name));
            move(cdirstr[1],list^[i][15],7);
            unpacktime(time,dt);
            with dt do tmp:=lz(day,2)+'-'+months[month]+'-'+lz(year-1900,2);
            move(tmp[1],list^[i][24],length(tmp));
            with dt do tmp:=lz(hour,2)+':'+lz(min,2)+':'+lz(sec,2);
            move(tmp[1],list^[i][35],length(tmp));
            inc(i);
          end;
        end
        else {if bitson(attr,archive) then} begin                    { files }
          fsplit(name,fdir,fname,fext);
          tmp:=copy(fext,2,length(fext)-1);
          tmp:=strdn(tmp);
          if (tmp='gif') or (tmp='pcx') or (tmp='lbm') or
             (tmp='bmp') or (copy(tmp,1,2)='sc') or (tmp='cel') then begin
            if tmp='gif' then begin
              dummy:=gif_info(fname+fext,gifinfo);
              with gifinfo do tmp:=lz(xres,0)+'x'+lz(yres,0)+'x'+lz(1 shl pixs,0);
            end
            else if tmp='pcx' then begin
              dummy:=pcx_info(fname+fext,pcxinfo);
              with pcxinfo do tmp:=lz(xres,0)+'x'+lz(yres,0)+'x'+lz(1 shl pixs,0);
            end
            else if tmp='lbm' then begin
              dummy:=lbm_info(fname+fext,lbminfo);
              with lbminfo do tmp:=lz(xres,0)+'x'+lz(yres,0)+'x'+lz(1 shl pixs,0);
            end
            else if tmp='bmp' then begin
              dummy:=bmp_info(fname+fext,bmpinfo);
              with bmpinfo do begin
                if (xres=0) or (yres=0) or (pixs=0) then tmp:='invalid'
                else tmp:=lz(xres,0)+'x'+lz(yres,0)+'x'+lz(1 shl pixs,0);
              end;
            end
            else if copy(tmp,1,2)='sc' then begin
              dummy:=rix_info(fname+fext,rixinfo);
              with rixinfo do tmp:=lz(xres,0)+'x'+lz(yres,0)+'x'+lz(1 shl pixs,0);
            end
            else if tmp='cel' then begin
              dummy:=cel_info(fname+fext,celinfo);
              with celinfo do tmp:=lz(xres,0)+'x'+lz(yres,0)+'x'+lz(1 shl pixs,0);
            end;
            move(tmp[1],list^[i][45],length(tmp));
            if length(fname)>0 then move(fname[1],list^[i][1],length(fname));
            if length(fext)>0 then move(fext[2],list^[i][10],length(fext)-1);
            str(size:7,tmp); move(tmp[1],list^[i][15],7);
            unpacktime(time,dt);
            with dt do tmp:=lz(day,2)+'-'+months[month]+'-'+lz(year-(year div 100)*100,2);
            move(tmp[1],list^[i][24],length(tmp));
            with dt do tmp:=lz(hour,2)+':'+lz(min,2)+':'+lz(sec,2);
            move(tmp[1],list^[i][35],length(tmp));
            inc(i);
          end;
        end;
      end;
      findnext(di);
    end;
    scrsize:=v_lines-6;
    if i<scrsize then scrsize:=i;
    sort(0,i-1);                                       { sort directory list }
    files:=i;
  end;
  cursoroff;                                         { select file from list }
  curnum:=select(3,3,4+itemsize,4+scrsize,path,' Select a File ',curnum,files,list);
  i:=curnum;
  if i<>0 then begin
    if list^[i-1][10]<>#0 then selectfile:=copy(list^[i-1],1,pos(#0,list^[i-1])-1)+'.'+copy(list^[i-1],10,3)
    else selectfile:=copy(list^[i-1],1,pos(#0,list^[i-1])-1);
  end else selectfile:='';
  getscr; cursoron;
end;

function getfname:pathstr;
var
  curdir,fname,drive:pathstr;
  is_drive,is_dir,is_file:boolean;
begin
  getdir(0,curdir);
  repeat
    fname:=selectfile(curdir);         { select dir, drive or file from list }
    is_drive:=false; is_dir:=false; is_file:=false;
    if fname<>'' then begin                                  { find out type }
      if (fname[1] in [#24,#25]) then is_dir:=true
      else if fname[1]=#17 then is_drive:=true
      else is_file:=true;
    end else is_file:=true;
    if is_drive then begin                { select drive and curdir on drive }
      drive:=copy(fname,3,2);
      chdir(drive);
      getdir(0,curdir);
      globalpath:=noslash(curdir);
      curnum:=1;
    end
    else if is_dir then begin                            { select new curdir }
      if fname[1]=#25 then begin
        if length(curdir)>3 then curdir:=curdir+'\'+copy(fname,2,length(fname)-1)
        else curdir:=curdir+copy(fname,2,length(fname)-1);
      end
      else begin
        curdir:=copy(curdir,1,rpos(['\'],curdir)-1);
        if length(curdir)=2 then curdir:=curdir+'\';
      end;
      chdir(curdir);
      globalpath:=noslash(curdir);
      curnum:=1;
    end;
  until is_file;
  if fname<>'' then getfname:=fexpand(fname) else getfname:='';
end;

{----------------------------------------------------------------------------}

var
  bgipath,pathname,olddir:pathstr;
  fname:namestr;
  fext:extstr;
  fdir:dirstr;
  tmp:string;
  dummy,x,y:byte;
begin
  bgipath:='i:\gfxfx2';                                 { path to bgi-driver }
  curnum:=1;
  list:=nil;
  drives:=0;                                     { retrieve number of drives }
  y:=getdrive; { save drive }
  for x:=2 to 25 do begin
    setdrive(x);
    if getdrive=x then inc(drives);
  end;
  setdrive(y); { restore drive }
  inc(drives,flopdrives);
  getdir(0,olddir);                                            { save curdir }
  globalpath:=olddir; prevpath:='';
  x:=getx; y:=gety;
  repeat
    pathname:=getfname;
    if pathname<>'' then begin
      setscr;
      fsplit(pathname,fdir,fname,fext);
      tmp:=copy(fext,2,length(fext)-1);
      fext:=strdn(tmp);
      if fext='gif' then dummy:=gif_display(pathname,bgipath,mode)
      else if fext='pcx' then dummy:=pcx_display(pathname,bgipath,mode)
      else if fext='lbm' then dummy:=lbm_display(pathname,bgipath,mode)
      else if fext='bmp' then dummy:=bmp_display(pathname,bgipath,mode)
      else if fext='cel' then dummy:=cel_display(pathname,bgipath,mode)
      else if copy(fext,1,2)='sc' then dummy:=rix_display(pathname,bgipath,mode);
      clearkeybuf;
      waitkey(0);
      setvideo(u_lm);
      getscr;
    end;
  until pathname='';
  chdir(olddir);                                        { restore old curdir }
  placecursor(x,y);
end.
