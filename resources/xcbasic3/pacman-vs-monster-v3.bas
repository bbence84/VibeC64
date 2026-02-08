rem *********************
rem * XC=BASIC 3.0
rem *
rem * A very stupid
rem * example program for
rem * sprite demonstration
rem * (Converted from v2.0)
rem *********************

CONST SHAPES_START = $2000
CONST RASTER_LINE  = $d012
CONST SPR_MCOLOR1  = $d025
CONST SPR_MCOLOR2  = $d026

rem Declare sprite data arrays
DIM pacman1(63) AS BYTE @pacman1_data
DIM pacman2(63) AS BYTE @pacman2_data
DIM pacman3(63) AS BYTE @pacman3_data
DIM pacman4(63) AS BYTE @pacman4_data
DIM monster1(63) AS BYTE @monster1_data
DIM monster2(63) AS BYTE @monster2_data
DIM monster3(63) AS BYTE @monster3_data
DIM monster4(63) AS BYTE @monster4_data

rem Copy sprite data to shape locations
DIM i AS BYTE
FOR i = 0 TO 63
  POKE SHAPES_START + i, pacman1(i)
  POKE SHAPES_START + 64 + i, pacman2(i)
  POKE SHAPES_START + 128 + i, pacman3(i)
  POKE SHAPES_START + 192 + i, pacman4(i)
  POKE SHAPES_START + 256 + i, monster1(i)
  POKE SHAPES_START + 320 + i, monster2(i)
  POKE SHAPES_START + 384 + i, monster3(i)
  POKE SHAPES_START + 448 + i, monster4(i)
NEXT i

rem Set multicolor registers (global sprite multicolors)
POKE SPR_MCOLOR1, 10
POKE SPR_MCOLOR2, 0

rem Init variables
DIM pacman_x AS WORD  : pacman_x = 40
DIM pacman_y AS BYTE  : pacman_y = 140
DIM monster_x AS WORD : monster_x = 280
DIM monster_y AS BYTE : monster_y = 144
DIM animphase AS INT  : animphase = 0
DIM animdir AS INT    : animdir = 1
DIM pos AS WORD       : pos = 40
DIM collide AS BYTE
DIM j AS BYTE

rem Set up sprites using new SPRITE command
rem XYSIZE 1,1 = double width and double height
SPRITE 0 XYSIZE 1, 1 MULTI COLOR 7 SHAPE 128 AT pacman_x, pacman_y ON
SPRITE 1 XYSIZE 1, 1 MULTI COLOR 1 SHAPE 132 AT monster_x, monster_y ON

rem -- read current collision state to reset register
collide = PEEK($d01e) AND 1

DO
  rem Wait for 2 frames (like the original)
  FOR j = 1 TO 2
    DO : LOOP UNTIL SCAN() >= 250
    DO : LOOP UNTIL SCAN() < 250
  NEXT j
  
  SPRITE 0 AT pos, pacman_y
  SPRITE 1 AT 320 - pos, monster_y
  
  pos = pos + 2
  animphase = animphase + animdir
  
  IF animphase = 3 THEN animdir = -1
  IF animphase = 0 THEN animdir = 1
  
  SPRITE 0 SHAPE 128 + animphase
  SPRITE 1 SHAPE 132 + animphase
  
  collide = PEEK($d01e) AND 1
LOOP UNTIL collide = 1

END

rem Sprite #1 - Pacman frame 1
rem Multicolor mode, BG color: 6, Sprite color: 7, multicolor1: 10, multicolor2: 0
pacman1_data:
DATA AS BYTE _
  $01, $00, $00, _
  $01, $00, $00, _
  $05, $00, $00, _
  $05, $00, $00, _
  $14, $14, $00, _
  $14, $54, $00, _
  $51, $5A, $00, _
  $51, $6A, $80, _
  $01, $6A, $A0, _
  $05, $A8, $A0, _
  $05, $A8, $A8, _
  $16, $AA, $A8, _
  $1A, $AA, $A8, _
  $0A, $A8, $00, _
  $0A, $AA, $A8, _
  $0A, $AA, $A8, _
  $0A, $AA, $A8, _
  $02, $AA, $A0, _
  $02, $AA, $A0, _
  $00, $AA, $80, _
  $00, $2A, $00

rem Sprite #2 - Pacman frame 2
rem Multicolor mode, BG color: 6, Sprite color: 7, multicolor1: 10, multicolor2: 6
pacman2_data:
DATA AS BYTE _
  $01, $00, $00, _
  $01, $00, $00, _
  $05, $00, $00, _
  $05, $00, $00, _
  $14, $14, $00, _
  $14, $54, $00, _
  $51, $5A, $00, _
  $51, $6A, $80, _
  $01, $6A, $A0, _
  $05, $A8, $A0, _
  $05, $A8, $A8, _
  $16, $AA, $A0, _
  $1A, $AA, $00, _
  $0A, $A8, $00, _
  $0A, $AA, $00, _
  $0A, $AA, $A0, _
  $0A, $AA, $A8, _
  $02, $AA, $A0, _
  $02, $AA, $A0, _
  $00, $AA, $80, _
  $00, $2A, $00

rem Sprite #3 - Pacman frame 3
rem Multicolor mode, BG color: 6, Sprite color: 7, multicolor1: 10, multicolor2: 6
pacman3_data:
DATA AS BYTE _
  $01, $00, $00, _
  $01, $00, $00, _
  $05, $00, $00, _
  $05, $00, $00, _
  $14, $14, $00, _
  $14, $54, $00, _
  $51, $5A, $00, _
  $51, $6A, $80, _
  $01, $6A, $A0, _
  $05, $A2, $A8, _
  $05, $A2, $A0, _
  $16, $AA, $80, _
  $1A, $AA, $00, _
  $0A, $A8, $00, _
  $0A, $AA, $00, _
  $0A, $AA, $80, _
  $0A, $AA, $A0, _
  $02, $AA, $A8, _
  $02, $AA, $A0, _
  $00, $AA, $80, _
  $00, $2A, $00

rem Sprite #4 - Pacman frame 4
rem Multicolor mode, BG color: 6, Sprite color: 7, multicolor1: 10, multicolor2: 6
pacman4_data:
DATA AS BYTE _
  $01, $00, $00, _
  $01, $00, $00, _
  $05, $00, $00, _
  $05, $00, $00, _
  $14, $14, $00, _
  $14, $54, $00, _
  $51, $5A, $00, _
  $51, $6A, $A0, _
  $01, $6A, $A0, _
  $05, $A2, $80, _
  $05, $A2, $80, _
  $16, $AA, $00, _
  $1A, $A8, $00, _
  $0A, $A0, $00, _
  $0A, $A8, $00, _
  $0A, $AA, $00, _
  $0A, $AA, $80, _
  $02, $AA, $80, _
  $02, $AA, $A0, _
  $00, $AA, $A0, _
  $00, $2A, $00

rem Sprite #5 - Monster frame 1
rem Multicolor mode, BG color: 6, Sprite color: 1, multicolor1: 10, multicolor2: 0
monster1_data:
DATA AS BYTE _
  $05, $55, $40, _
  $15, $55, $50, _
  $15, $55, $50, _
  $55, $55, $54, _
  $55, $A9, $A8, _
  $55, $BD, $BC, _
  $55, $BD, $BC, _
  $55, $BD, $BC, _
  $55, $A9, $A8, _
  $55, $55, $54, _
  $55, $55, $54, _
  $55, $55, $54, _
  $55, $55, $54, _
  $55, $55, $54, _
  $55, $55, $54, _
  $55, $55, $54, _
  $55, $55, $54, _
  $55, $55, $54, _
  $55, $55, $54, _
  $44, $44, $44, _
  $44, $44, $44

rem Sprite #6 - Monster frame 2
rem Multicolor mode, BG color: 6, Sprite color: 1, multicolor1: 10, multicolor2: 0
monster2_data:
DATA AS BYTE _
  $05, $55, $40, _
  $15, $55, $50, _
  $15, $55, $50, _
  $55, $55, $54, _
  $56, $A6, $A4, _
  $56, $F6, $F4, _
  $56, $F6, $F4, _
  $56, $F6, $F4, _
  $56, $A6, $A4, _
  $55, $55, $54, _
  $55, $55, $54, _
  $55, $55, $54, _
  $55, $55, $54, _
  $55, $55, $54, _
  $55, $55, $54, _
  $55, $55, $54, _
  $55, $55, $54, _
  $55, $55, $54, _
  $55, $55, $54, _
  $11, $11, $10, _
  $11, $11, $10

rem Sprite #7 - Monster frame 3
rem Multicolor mode, BG color: 6, Sprite color: 1, multicolor1: 10, multicolor2: 0
monster3_data:
DATA AS BYTE _
  $05, $55, $40, _
  $15, $55, $50, _
  $15, $55, $50, _
  $55, $55, $54, _
  $6A, $6A, $54, _
  $7E, $7E, $54, _
  $7E, $7E, $54, _
  $7E, $7E, $54, _
  $6A, $6A, $54, _
  $55, $55, $54, _
  $55, $55, $54, _
  $55, $55, $54, _
  $55, $55, $54, _
  $55, $55, $54, _
  $55, $55, $54, _
  $55, $55, $54, _
  $55, $55, $54, _
  $55, $55, $54, _
  $55, $55, $54, _
  $44, $44, $44, _
  $44, $44, $44

rem Sprite #8 - Monster frame 4
rem Multicolor mode, BG color: 6, Sprite color: 1, multicolor1: 10, multicolor2: 0
monster4_data:
DATA AS BYTE _
  $05, $55, $40, _
  $15, $55, $50, _
  $15, $55, $50, _
  $55, $55, $54, _
  $A9, $A9, $54, _
  $F9, $F9, $54, _
  $F9, $F9, $54, _
  $F9, $F9, $54, _
  $A9, $A9, $54, _
  $55, $55, $54, _
  $55, $55, $54, _
  $55, $55, $54, _
  $55, $55, $54, _
  $55, $55, $54, _
  $55, $55, $54, _
  $55, $55, $54, _
  $55, $55, $54, _
  $55, $55, $54, _
  $55, $55, $54, _
  $11, $11, $10, _
  $11, $11, $10
