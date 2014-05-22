{ MK 2001 }
Unit graphics;

INTERFACE

procedure initgraph;
Procedure closegraph;
Procedure PutPixel (X, Y : Integer; C : Byte);
Procedure Line (X1, Y1, X2, Y2 : Word; Color : Byte);
procedure Vline (x, y1, y2 : integer; col : byte);
Procedure HLine (x1, x2, y : integer; col : byte);
Procedure setRGBpal (col, R, G, B : byte);
Procedure getRGBpal (col : byte; var R, G, B : byte);
Procedure Delay (ms : Word);

IMPLEMENTATION

Procedure initgraph; Assembler;
Asm
  mov  ax, 13h
  int 10h
end;

Procedure closegraph; Assembler;
asm
  Mov  ax, 03h
  int  10h
end;

Procedure PutPixel(X, Y : Integer; C : Byte); Assembler;
Asm
   mov   ax, $A000
   mov   es, ax
   mov   bx, [X]
   mov   dx, [Y]
   xchg  dh, dl
   mov   al, [C]
   mov   di, dx
   shr   di, 2
   add   di, dx
   add   di, bx
   stosb
End;

Procedure Line(X1, Y1, X2, Y2 : Word; Color : Byte);   Assembler;

Var
   DeX          : Integer;
   DeY          : Integer;
   IncF         : Integer;

Asm     { Line }
   mov   ax, [X2]      { Move X2 into AX                                    }
   sub   ax, [X1]      { Get the horiz length of the line -  X2 - X1        }
   jnc   @Dont1        { Did X2 - X1 yield a negative result?               }
   neg   ax            { Yes, so make the horiz length positive             }

@Dont1:
   mov   [DeX], ax     { Now, move the horiz length of line into DeX        }
   mov   ax, [Y2]      { Move Y2 into AX                                    }
   sub   ax, [Y1]      { Subtract Y1 from Y2, giving the vert length        }
   jnc   @Dont2        { Was it negative?                                   }
   neg   ax            { Yes, so make it positive                           }

@Dont2:
   mov   [DeY], ax     { Move the vert length into DeY                      }
   cmp   ax, [DeX]     { Compare the vert length to horiz length            }
   jbe   @OtherLine    { If vert was <= horiz length then jump              }

   mov   ax, [Y1]      { Move Y1 into AX                                    }
   cmp   ax, [Y2]      { Compare Y1 to Y2                                   }
   jbe   @DontSwap1    { If Y1 <= Y2 then jump, else...                     }
   mov   bx, [Y2]      { Put Y2 in BX                                       }
   mov   [Y1], bx      { Put Y2 in Y1                                       }
   mov   [Y2], ax      { Move Y1 into Y2                                    }
                       { So after all that.....                             }
                       { Y1 = Y2 and Y2 = Y1                                }

   mov   ax, [X1]      { Put X1 into AX                                     }
   mov   bx, [X2]      { Put X2 into BX                                     }
   mov   [X1], bx      { Put X2 into X1                                     }
   mov   [X2], ax      { Put X1 into X2                                     }

@DontSwap1:
   mov   [IncF], 1     { Put 1 in IncF, ie, plot another pixel              }
   mov   ax, [X1]      { Put X1 into AX                                     }
   cmp   ax, [X2]      { Compare X1 with X2                                 }
   jbe   @SkipNegate1  { If X1 <= X2 then jump, else...                     }
   neg   [IncF]        { Negate IncF                                        }

@SkipNegate1:
   mov   ax, [Y1]      { Move Y1 into AX                                    }
   mov   bx, 320       { Move 320 into BX                                   }
   mul   bx            { Multiply 320 by Y1                                 }
   mov   di, ax        { Put the result into DI                             }
   add   di, [X1]      { Add X1 to DI, and tada - offset in DI              }
   mov   bx, [DeY]     { Put DeY in BX                                      }
   mov   cx, bx        { Put DeY in CX                                      }
   mov   ax, 0A000h    { Put the segment to plot in, in AX                  }
   mov   es, ax        { ES points to the VGA                               }
   mov   dl, [Color]   { Put the color to use in DL                         }
   mov   si, [DeX]     { Point SI to DeX                                    }

@DrawLoop1:
   mov   es:[di], dl   { Put the color to plot with, DL, at ES:DI           }
   add   di, 320       { Add 320 to DI, ie, next line down                  }
   sub   bx, si        { Subtract DeX from BX, DeY                          }
   jnc   @GoOn1        { Did it yield a negative result?                    }
   add   bx, [DeY]     { Yes, so add DeY to BX                              }
   add   di, [IncF]    { Add the amount to increment by to DI               }

@GoOn1:
   loop  @DrawLoop1    { No negative result, so plot another pixel          }
   jmp   @ExitLine     { We're all done, so outta here!                     }

@OtherLine:
   mov   ax, [X1]      { Move X1 into AX                                    }
   cmp   ax, [X2]      { Compare X1 to X2                                   }
   jbe   @DontSwap2    { Was X1 <= X2 ?                                     }
   mov   bx, [X2]      { No, so move X2 into BX                             }
   mov   [X1], bx      { Move X2 into X1                                    }
   mov   [X2], ax      { Move X1 into X2                                    }
   mov   ax, [Y1]      { Move Y1 into AX                                    }
   mov   bx, [Y2]      { Move Y2 into BX                                    }
   mov   [Y1], bx      { Move Y2 into Y1                                    }
   mov   [Y2], ax      { Move Y1 into Y2                                    }

@DontSwap2:
   mov   [IncF], 320   { Move 320 into IncF, ie, next pixel is on next row  }
   mov   ax, [Y1]      { Move Y1 into AX                                    }
   cmp   ax, [Y2]      { Compare Y1 to Y2                                   }
   jbe   @SkipNegate2  { Was Y1 <= Y2 ?                                     }
   neg   [IncF]        { No, so negate IncF                                 }

@SkipNegate2:
   mov   ax, [Y1]      { Move Y1 into AX                                    }
   mov   bx, 320       { Move 320 into BX                                   }
   mul   bx            { Multiply AX by 320                                 }
   mov   di, ax        { Move the result into DI                            }
   add   di, [X1]      { Add X1 to DI, giving us the offset                 }
   mov   bx, [DeX]     { Move DeX into BX                                   }
   mov   cx, bx        { Move BX into CX                                    }
   mov   ax, 0A000h    { Move the address of the VGA into AX                }
   mov   es, ax        { Point ES to the VGA                                }
   mov   dl, [Color]   { Move the color to plot with in DL                  }
   mov   si, [DeY]     { Move DeY into SI                                   }

@DrawLoop2:
   mov   es:[di], dl   { Put the byte in DL at ES:DI                        }
   inc   di            { Increment DI by one, the next pixel                }
   sub   bx, si        { Subtract SI from BX                                }
   jnc   @GoOn2        { Did it yield a negative result?                    }
   add   bx, [DeX]     { Yes, so add DeX to BX                              }
   add   di, [IncF]    { Add IncF to DI                                     }

@GoOn2:
   loop  @DrawLoop2    { Keep on plottin'                                   }

@ExitLine:
                       { All done!                                          }
End;

procedure Vline (x, y1, y2 : integer; col : byte); Assembler;
Asm
   mov   ax, 0A000h
   mov   es, ax
   mov   ax, Y1
   shl   ax, 6
   mov   di, ax
   shl   ax, 2
   add   di, ax
   add   di, X
   mov   cx, Y2
   mov   al, Col
   sub   cx, Y1
@Plot:
   mov   es:[di], al
   add   di, 320
   dec   cx
   jnz   @Plot
end;

Procedure HLine (x1, x2, y : integer; col : byte); Assembler;
Asm
  mov   ax, $A000
  mov   es, ax
  mov   ax, x1
  mov   bx, y
  mov   cx, x2
  sub   cx, ax
  mov   di, ax
  mov   dx, bx
  shl   bx, 8
  shl   dx, 6
  add   dx, bx
  add   di, dx
  mov   al, col
  rep   stosb
end;

Procedure setRGBpal (col, R, G, B : byte); Assembler;
asm
   mov   dx, 03C8h
   mov   al, [Col]
   out   dx, al
   inc   dx
   mov   al, [R]
   out   dx, al
   mov   al, [G]
   out   dx, al
   mov   al, [B]
   out   dx, al
end;

Procedure getRGBpal (col : byte; var R, G, B : byte); Assembler;
Asm
   mov   dx, 03C7h
   mov   al, [Col]
   out   dx, al
   add   dx, 2
   in    al, dx
   les   di, [R]
   stosb
   in    al, dx
   les   di, [G]
   stosb
   in    al, dx
   les   di, [B]
   stosb
end;

Procedure Delay (ms : Word); Assembler;
Asm
   mov   ax, 1000
   mul   ms
   mov   cx, dx
   mov   dx, ax
   mov   ah, 86h
   int   15h
End;

begin
end.