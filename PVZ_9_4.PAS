program Pavyzdys_9_4;
uses crt;
const Tm= 200;
type
    rbyte=record l,h: byte; end;
    ekranas=array[1..25, 1..80] of rbyte;
    sar=^ke;
    ke=record
           s:rbyte;
           kitas:sar;
    end;
var p: sar;
    Ek: ekranas absolute $B800:$0000;
    k:integer;
    laisva:boolean;
    c:char;
    x,y:byte;
    d:rbyte;
procedure Prijunk(var P:sar; x:rbyte);
var t:sar;
begin
   new(t);
   T^.s:=x;
   P:=T;
end;
procedure paimkE(var p:sar




