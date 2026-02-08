rem ****************************************************
rem * XC=BASIC 3.0
rem * Sprite multiplexing example
rem * Shows how to display 14 sprites using only 7
rem * hardware sprites via raster interrupts
rem * (Converted from v2.0)
rem ****************************************************

OPTION FASTINTERRUPT

CONST SHAPES_START = $2000
CONST ANIM_SPEED   = 30
CONST SPR_MCOLOR1  = $d025
CONST SPR_MCOLOR2  = $d026

rem Fast variables for interrupt routines
DIM i AS BYTE FAST
DIM f AS BYTE FAST
DIM c AS BYTE FAST

rem Declare sprite data arrays
DIM ghost1(63) AS BYTE @ghost1_data
DIM ghost2(63) AS BYTE @ghost2_data

rem Clear the screen and set border and background colors
MEMSET 1024, 1000, 32
POKE 53280, 11
POKE 53281, 0
f = 0
c = ANIM_SPEED

rem Load sprites into memory
FOR i = 0 TO 63
  POKE SHAPES_START + i, ghost1(i)
  POKE SHAPES_START + 64 + i, ghost2(i)
NEXT i

rem Set global multicolors
POKE SPR_MCOLOR1, 1
POKE SPR_MCOLOR2, 0

rem Initialize all 7 sprites
FOR i = 0 TO 6
  SPRITE i ON MULTI SHAPE 128 AT CWORD(i) * 40 + 50, 100 COLOR i + 2
NEXT i

rem Setup raster interrupts for sprite multiplexing
rem First set up the handlers, then enable
ON RASTER 1 GOSUB sg1
ON RASTER 130 GOSUB sg2
ON RASTER 250 GOSUB animate

SYSTEM INTERRUPT OFF
RASTER INTERRUPT ON

rem Wait for a keypress to exit
DIM k AS BYTE
DO
  GET k
LOOP UNTIL k <> 0

rem Cleanup: disable interrupts and sprites
RASTER INTERRUPT OFF
SYSTEM INTERRUPT ON

FOR i = 0 TO 6
  SPRITE i OFF
NEXT i

POKE 53280, 14
POKE 53281, 6
PRINT "{CLR}"
END

rem ****************************************************
rem * Interrupt Service Routines
rem * Note: ISRs cannot call SUBs/FUNCTIONs in XC=BASIC 3
rem ****************************************************

rem First sprite group - top of screen (Y=100)
sg1:
  SPRITE 0 COLOR 2  AT  50, 100
  SPRITE 1 COLOR 3  AT  90, 100
  SPRITE 2 COLOR 4  AT 130, 100
  SPRITE 3 COLOR 5  AT 170, 100
  SPRITE 4 COLOR 6  AT 210, 100
  SPRITE 5 COLOR 7  AT 250, 100
  SPRITE 6 COLOR 8  AT 290, 100
  ON RASTER 130 GOSUB sg2
  RETURN

rem Second sprite group - bottom of screen (Y=180)
sg2:
  SPRITE 0 COLOR 9  AT  50, 180
  SPRITE 1 COLOR 10 AT  90, 180
  SPRITE 2 COLOR 11 AT 130, 180
  SPRITE 3 COLOR 12 AT 170, 180
  SPRITE 4 COLOR 13 AT 210, 180
  SPRITE 5 COLOR 14 AT 250, 180
  SPRITE 6 COLOR 15 AT 290, 180
  ON RASTER 1 GOSUB sg1
  RETURN

rem Animation routine - cycles between ghost frames
animate:
  c = c - 1
  IF c = 0 THEN
    SPRITE 0 SHAPE 128 + f
    SPRITE 1 SHAPE 128 + f
    SPRITE 2 SHAPE 128 + f
    SPRITE 3 SHAPE 128 + f
    SPRITE 4 SHAPE 128 + f
    SPRITE 5 SHAPE 128 + f
    SPRITE 6 SHAPE 128 + f
    rem XOR with 1 toggles between 0 and 1
    f = f XOR 1
    c = ANIM_SPEED
  END IF
  ON RASTER 250 GOSUB animate
  RETURN

rem ****************************************************
rem * Sprite Data
rem ****************************************************

rem Ghost animation frame 1
ghost1_data:
DATA AS BYTE _
  $00,$00,$00,$00,$aa,$00,$02,$aa, _
  $80,$02,$aa,$80,$0a,$aa,$a0,$0a, _
  $aa,$a0,$29,$69,$68,$29,$69,$68, _
  $2b,$6b,$68,$2b,$6b,$68,$2a,$aa, _
  $a8,$2a,$aa,$a8,$2a,$aa,$a8,$2a, _
  $aa,$a8,$2a,$aa,$a8,$2a,$aa,$a8, _
  $2a,$aa,$a8,$2a,$aa,$a8,$28,$a2, _
  $88,$28,$a2,$88,$28,$a2,$88,$00

rem Ghost animation frame 2
ghost2_data:
DATA AS BYTE _
  $00,$00,$00,$00,$aa,$00,$02,$aa, _
  $80,$02,$aa,$80,$0a,$aa,$a0,$0a, _
  $aa,$a0,$29,$69,$68,$29,$69,$68, _
  $29,$e9,$e8,$29,$e9,$e8,$2a,$aa, _
  $a8,$2a,$aa,$a8,$2a,$aa,$a8,$2a, _
  $aa,$a8,$2a,$aa,$a8,$2a,$aa,$a8, _
  $2a,$aa,$a8,$2a,$aa,$a8,$22,$8a, _
  $28,$22,$8a,$28,$22,$8a,$28,$00
