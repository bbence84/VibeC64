DIM scrval AS BYTE FAST
DIM speed AS BYTE FAST
DIM digit AS BYTE FAST
DIM SHARED j AS BYTE
DIM ji AS int FAST
DECLARE SUB drawnewcol () STATIC
SYSTEM INTERRUPT OFF
scrval = 7
speed = 1
digit = 0
poke 53272,24
poke 53270,24
poke 53281,0
poke 53282,11
poke 53283,9
ji=$2000
'--------------------------- screen --------------------------
dim wStartAddress as word FAST
DIM wSourceAddress AS word FAST
DIM wDestAddress AS word FAST
dim bNumber_Row as BYTE
dim bNumber_Col as BYTE
bNumber_Row = 0
for wStartAddress = $4800 to $4580 step 80
bNumber_Col = bNumber_Row
for wDestAddress = wStartAddress to wStartAddress + 80
poke wDestAddress, bNumber_Col + $30
bNumber_Col = bNumber_Col + 1 : if bNumber_Col = 10 then bNumber_Col = 0
next wDestAddress
bNumber_Row = bNumber_Row + 1 : if bNumber_Row = 10 then bNumber_Row = 0
next wStartAddress
wStartAddress = $2500
wSourceAddress = wStartAddress
for wDestAddress = $0400 to $07C0 step 40
memcpy wSourceAddress, wDestAddress, 40
wSourceAddress = wSourceAddress + 80
next wDestAddress
'--------------------------------------------------------------------------------------
main:
call drawnewcol()
goto main
SUB drawnewcol () STATIC
DO : LOOP UNTIL scan() = 21
scrval = scrval - speed
IF scrval > 142 THEN
scrval = scrval AND 7
wStartAddress = wStartAddress + 1
wSourceAddress = wStartAddress
for wDestAddress = $0400 to $07C0 step 40
memcpy wSourceAddress, wDestAddress, 40
wSourceAddress = wSourceAddress + 80
next wDestAddress
END IF
HSCROLL scrval
END SUB