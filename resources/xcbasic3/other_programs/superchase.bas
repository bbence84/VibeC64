'***********************************************************************
'**                       SUPERCHASE                                  **
'**                         REMIX!                                    **
'**                                                                   **
'**    3 different versions of the same game into one program!        **
'**                                                                   **
'** - Original VIC-20 version by Anthony Godshall - October 1982      **
'** - Atari version by someone @ Compute! Gazette                     **
'** - TI-99 4/A version by Cheryl Regena                              **
'**                                                                   **
'** Written in XC-BASIC 3.1.0 by @JJFlash@mastodon.social - Nov 2022  **
'** XC-BASIC created by Csaba Fekete! - https://xc-basic.net/         **
'**                                                                   **
'**                                                                   **
'***********************************************************************


'------------------------INITIAL-SETUP----------------------------------
Dim SHARED scrAddrCache(25) as WORD @loc_scrAddrCache ' 0 -> 24
loc_scrAddrCache:
DATA AS WORD 1024, 1064, 1104, 1144, 1184, 1224, 1264, 1304, 1344, 1384
DATA AS WORD 1424, 1464, 1504, 1544, 1584, 1624, 1664, 1704, 1744, 1784
DATA AS WORD 1824, 1864, 1904, 1944, 1984

poke 53280, 0 : poke 53281, 0

poke $D018, %00011111 'screen $0400, char location: $3800
poke 657, 128 'disable upper-lower case change

VOLUME 15
'-----------------------------------------------------------------------

'-------------------------CONSTANTS-------------------------------------
SHARED Const TRUE = 255
SHARED Const FALSE = 0

SHARED Const SPACE = 81
       Const WALL = 96
       Const EX_WALL = 98
       Const DOOR_CLOSED = 97
       Const DOOR_CLOSED_REVERSED = 99
SHARED Const DOOR_OPEN = 88

SHARED Const MONSTER = 68
       Const MONSTER_ALT = 69
SHARED Const TRAIL = 80
       Const TREASURES = 112
SHARED Const TREASURE_GOLD = 116

SHARED Const MASK_WALKABLE = 16   '0001 0000
SHARED Const MASK_ALL = 48        '0011 0000

SHARED Const GROUP_CREATURES = 0  '0000 0000
SHARED Const GROUP_WALKABLE = 16  '0001 0000
SHARED Const GROUP_TREASURE = 48  '0011 0000

SHARED Const EVENT_NONE = 0
SHARED Const EVENT_PLAYER_CAUGHT = 1
SHARED Const EVENT_PLAYER_EXITED = 2

SHARED Const VIC_COLOR_OFFSET = $D400

SHARED Const VOI1_S = 3
SHARED Const VOI1_R = 3
SHARED Const VOI2_S = 8
SHARED Const VOI2_R = 5
       Const VOI3_S = 7
       Const VOI3_R = 8
'-----------------------------------------------------------------------

'-----------------GAME-STATE-&-GLOBAL-STUFF-----------------------------
Dim SHARED bPeekedTileContent as BYTE

Dim bFrameCounter as BYTE
Dim bAnimFrameCounter as BYTE

Dim SHARED iDirections(4) as INT @loc_iDirections
loc_iDirections:
DATA as INT 1, -40, -1, 40 'east, north, west, south

Dim wDoorAddress as WORD
Dim wDoorColorAddress as WORD
Dim wGoldColorAddress as WORD

Dim SHARED bSkillLevel as BYTE : bSkillLevel = 1
Dim SHARED wScore as WORD
Dim        wLastExitScore as WORD : wLastExitScore = 0
Dim        bTreasures_Quantity as BYTE FAST
Dim SHARED bTreasuresCollected as BYTE
Dim SHARED bTreasuresToActivateMonster as BYTE : bTreasuresToActivateMonster = 1
Dim SHARED bTreasuresToOpenDoor as BYTE

Dim SHARED bMonsterIsOn as BYTE
Dim SHARED bGoldNotCollected as BYTE
Dim SHARED bExitEvent as BYTE

Dim wNoteTable(4) as WORD @loc_wNoteTable
loc_wNoteTable:
DATA as WORD $4495, $5669, $6602, $892B 'C6, E6, G6, C7

Dim bSoundIndex as BYTE
Dim SHARED bSoundTimer_GoldTaken as BYTE
Dim SHARED bSoundTimer_TreasureTaken as BYTE
Dim wEventSound as WORD

Dim N as BYTE FAST
Dim SHARED bJoystick2 as BYTE

declare sub generateMaze () STATIC
declare sub placeDoor() STATIC
declare sub drawInfoBox() STATIC
declare sub shakeScreen() STATIC
declare sub mazeShiftAway() STATIC
declare sub openDoorAnimation() SHARED STATIC
declare sub timedSounds() STATIC
declare sub colouredFrame() STATIC
declare sub titleScreen() STATIC
declare sub playerAppears() STATIC

declare sub placeCharset() STATIC
'-----------------------------------------------------------------------

'------------------HELPER FUNCTIONS-------------------------------------
function myRandom as BYTE (bMax as BYTE, bMask as BYTE) SHARED STATIC
	do
		myRandom = RNDB() AND bMask
	loop while myRandom > bMax
end function

function myByteABS as BYTE (bNumber as BYTE) SHARED STATIC
	if (bNumber AND 128) = 128 then bNumber = (NOT bNumber) + 1
	return bNumber
end function
'-----------------------------------------------------------------------

'------------------------INCLUDES---------------------------------------
include "inc_player.bas"
include "inc_monster.bas"
'-----------------------------------------------------------------------




'------------------TITLE SCREEN-----------------------------------------
sys $E544 FAST ' clear screen
call placeCharset()
call titleScreen()

'-------------------GAME-START------------------------------------------

sys $E544 FAST ' clear screen
textat 32, 0, "super", 1 'white
textat 33, 1, "chase!", 1 'white
textat 32, 7, "skill", 5 'green
textat 33, 8, "level", 5 'green
textat 32, 13, "score", 3 'cyan
textat 32, 18, "speed", 7 'yellow

Randomize TI()
For N = 1 to 10 : bPeekedTileContent = RNDB() : Next N ' bPeekedTileContent used here as a dummy variable!

'------------------LEVEL-START------------------------------------------
restartLevel:
For N as BYTE = 0 to 24
	memset scrAddrCache(N), 31, WALL
	memset VIC_COLOR_OFFSET + scrAddrCache(N), 31, 6 'blue
Next N

call generateMaze()
call placeDoor()

'********LEVEL INIT**********
bFrameCounter = 0

bSoundIndex = 255
bSoundTimer_TreasureTaken = 0
bSoundTimer_GoldTaken = 0
VOICE 3 WAVE TRI  ADSR 0, 0, VOI3_S, VOI3_R  OFF

wScore = wLastExitScore
bTreasuresCollected = 0
bExitEvent = EVENT_NONE

textat 33, 10, bSkillLevel, 1 'white
memset 1657, 5, 32 'erase previous printed score
textat 33, 15, wScore, 10 'light red
textat 33, 20, "1 ", 2 'red

bTreasuresToOpenDoor = shr(bTreasures_Quantity, 1) 
if bSkillLevel < bTreasuresToOpenDoor then
	bTreasuresToOpenDoor = bTreasuresToOpenDoor + bSkillLevel
else
	bTreasuresToOpenDoor = bTreasures_Quantity
end if

call playerAppears()
call initPlayer()
call initMonster()
'-------------------------MAIN LOOP!------------------------------------
do
	on bFrameCounter goto actorMovement, endFrame, mainAnimation, endFrame

actorMovement:
	'-------PLAYER MOVEMENT-----------------
	call playerMovement()
	if bExitEvent then exit do
	
	'-------MONSTER MOVEMENT-----------------
	if bMonsterIsOn then
		call handleMonster()
		if bExitEvent then exit do
	end if

	goto endFrame
	'-------------------------------------------------------------------

mainAnimation:
	if bGoldNotCollected then poke wGoldColorAddress, peek(wGoldColorAddress) XOR 6 'alternates white, yellow, white, yellow, ...

	charat bPlayer_Col, bPlayer_Row, bPlayer_FacingCharacter XOR 1, 13 'light green
	VOICE 1 OFF

	if bMonsterIsOn then
		if bMonster_SpeedUpMode then
			call handleMonster()
			if bExitEvent then exit do
		else
			charat bMonster_Col, bMonster_Row, MONSTER_ALT, 2 'red
			VOICE 2 OFF
		end if
	end if
	'-------------------------------------------------------------------
	
endFrame:
	call timedSounds()
	wait $d011, 128, 128 : wait $d011, 128 : wait $d011, 128, 128 : wait $d011, 128
	bFrameCounter = (bFrameCounter + 1) AND 3
loop

if bExitEvent = EVENT_PLAYER_CAUGHT then
	call shakeScreen()
	call drawInfoBox()
	textat 8, 12, "a tasty morsel", 8 'orange
	textat 12, 13, "indeed!", 8 'orange
	wait $DC00, 16, 16 'wait for fire to be pressed
else
	call drawInfoBox()
	textat 8, 12, "congratulations!", 7 'yellow
	textat 6, 13, "onto the next level!", 7 'yellow
	wLastExitScore = wScore
	if bSkillLevel < 255 then bSkillLevel = bSkillLevel + 1
	call colouredFrame()
	call mazeShiftAway()
end if

goto restartLevel

'------------GAME-SUBROUTINES-------------------------------------------
sub generateMaze () STATIC
	Dim bRow as BYTE FAST
	Dim bCol as BYTE FAST
	Dim bRowEnd as BYTE FAST
	Dim bColEnd as BYTE FAST

	memset 1065, 5, EX_WALL
	poke 1105, EX_WALL
	poke 1145, EX_WALL
	poke 1185, EX_WALL
	poke 1225, EX_WALL

	For N = 1 to 65
		bCol = shl(myRandom(13, 15), 1) + 1
		bRow = shl(myRandom(11, 15), 1) + 1
		bColEnd = bCol + 6 : if bColEnd > 29 then bColEnd = 29
		memset scrAddrCache(bRow) + bCol, bColEnd - bCol + 1, EX_WALL
	Next N

	For N = 1 to 60
		bCol = shl(myRandom(14, 15), 1) + 1
		bRow = shl(myRandom(10, 15), 1) + 1
		bRowEnd = bRow + 4 : if bRowEnd > 23 then bRowEnd = 23
		For K AS BYTE = bRow to bRowEnd
			poke scrAddrCache(K) + bCol, EX_WALL
		Next K
	Next N

	Dim wCalcScreenAddress as WORD FAST
	Dim bStackPointer as BYTE FAST
	Dim wFilledCells as WORD FAST
	Dim wPatchScrAddress as WORD
	Dim wStack(128) as WORD

	bStackPointer = 1 : wFilledCells = 0
	wStack(0) = 1065 'player starting position: Row 1, Column 1
	wPatchScrAddress = 1226 'row 5, column 2
	Const PATCHSCRADDRESS_END = 1253 'row 5, column 29
	
	Dim bTreasures_Color(5) as BYTE @loc_bbTreasures_Color
loc_bbTreasures_Color:
	DATA AS BYTE 12, 9, 10, 8, 7 'gray, brown, light red, orange, yellow

	Dim bTreasures_Sequence(51) as BYTE @loc_bTreasures_Sequence
	'26 treasure 0, 15 treasure 1, 12 treasure 2, 7 treasure 3, 1 treasure 4 (gold!)
loc_bTreasures_Sequence:
	'0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	'1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
	'2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2
	'3, 3, 3, 3, 3, 3, 3
	'                     4
	DATA AS BYTE 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 4
	DATA AS BYTE 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 2, 0, 1, 0, 1, 0, 1, 0
	
	Dim bTreasures_Index as BYTE : bTreasures_Index = 0
	Dim bTileType as BYTE
	Dim bTileColor as BYTE
	bTreasures_Quantity = 0
	bGoldNotCollected = FALSE 'in the event the Gold treasure doesn't show up...

	do
		bStackPointer = bStackPointer - 1
		wCalcScreenAddress = wStack(bStackPointer)
		
		do while peek(wCalcScreenAddress) = EX_WALL
			wCalcScreenAddress = wCalcScreenAddress - cword(1)
		loop
		wCalcScreenAddress = wCalcScreenAddress + cword(1)
		
		do while peek(wCalcScreenAddress) = EX_WALL
			bTileType = SPACE
			if wFilledCells > 5 then
				If myRandom(5, 7) = 5 then
					bTileType = TREASURES + bTreasures_Sequence(bTreasures_Index)
					if bTileType = TREASURE_GOLD then wGoldColorAddress = VIC_COLOR_OFFSET + wCalcScreenAddress : bGoldNotCollected = TRUE
					bTileColor = bTreasures_Color(bTileType AND 7)
					if bTreasures_Index < 50 then bTreasures_Index = bTreasures_Index + 1
					bTreasures_Quantity = bTreasures_Quantity + 1
				end if
			end if
			poke wCalcScreenAddress, bTileType : poke VIC_COLOR_OFFSET + wCalcScreenAddress, bTileColor
			wFilledCells = wFilledCells + 1
			
			wCalcScreenAddress = wCalcScreenAddress - cword(40) 'one row UP
			if peek(wCalcScreenAddress) = EX_WALL then
				wStack(bStackPointer) = wCalcScreenAddress
				bStackPointer = bStackPointer + 1
			end if
			wCalcScreenAddress = wCalcScreenAddress + cword(80) 'back to the original row + one row DOWN
			if peek(wCalcScreenAddress) = EX_WALL then
				wStack(bStackPointer) = wCalcScreenAddress
				bStackPointer = bStackPointer + 1
			end if
			
			wCalcScreenAddress = wCalcScreenAddress - cword(39) 'one row UP + one column RIGHT
		loop
		
		if bStackPointer = 0 then
			if wFilledCells < 280 then
				do until peek(wPatchScrAddress) = WALL
					wPatchScrAddress = wPatchScrAddress + 1
					if wPatchScrAddress > PATCHSCRADDRESS_END then exit sub
				loop
				poke wPatchScrAddress, EX_WALL
				wStack(bStackPointer) = wPatchScrAddress
				bStackPointer = 1
			else
				exit sub
			end if
		end if
	loop
end sub

sub placeDoor() STATIC
	Dim wStartingDoorAddress as WORD FAST
	wStartingDoorAddress = scrAddrCache(myRandom(22, 31) + 1) + 29 'Col 29, Row random
	Dim wMaxDoorAddress as WORD FAST : wMaxDoorAddress = $07DD 'Col 29, Row 24
	Dim wMinDoorAddress as WORD FAST : wMinDoorAddress = $0445 'Col 29, Row 1
	
	wDoorAddress = wStartingDoorAddress
	do
		if (peek(wDoorAddress) AND MASK_WALKABLE) = GROUP_WALKABLE then
			wDoorAddress = wDoorAddress + 1
			poke wDoorAddress, DOOR_CLOSED
			wDoorColorAddress = VIC_COLOR_OFFSET + wDoorAddress
			poke wDoorColorAddress, 14 'light blue
			exit sub
		end if
		wDoorAddress = wDoorAddress + 40
		if wDoorAddress = wMaxDoorAddress then wDoorAddress = wMinDoorAddress
		if wDoorAddress = wStartingDoorAddress then
			wStartingDoorAddress = wStartingDoorAddress - 1
			wDoorAddress = wStartingDoorAddress
			wMaxDoorAddress = wMaxDoorAddress - 1
			wMinDoorAddress = wMinDoorAddress - 1
		end if
	loop
end sub

sub drawInfoBox() STATIC
	poke 1468, 104 'col 4, row 11
	memset 1469, 21, 107 'col 5-25, row 11
	poke 1490, 109 'col 26, row 11
	
	poke 1508, 105 'col 4, row 12
	memset 1509, 21, 32 'col 5-25, row 12
	poke 1530, 110 'col 26, row 12
	
	poke 1548, 105 'col 4, row 13
	memset 1549, 21, 32 'col 5-25, row 13
	poke 1570, 110 'col 26, row 13

	poke 1588, 106 'col 4, row 14
	memset 1589, 21, 108 'col 5-25, row 14
	poke 1610, 111 'col 26, row 14
	
	memset 55740, 23, 6 'blu
	memset 55780, 23, 6 'blu
	memset 55820, 23, 6 'blu
	memset 55860, 23, 6 'blu
	
end sub

sub shakeScreen() STATIC
	Dim bVariance as BYTE
	
	VOICE 1 OFF
	VOICE 2 ON
	VOICE 3 OFF  WAVE SAW
	
	bVariance = 7
	bAnimFrameCounter = 0
	wEventSound = 1382
	
	do
		poke $D011, %10011000 OR ((3 + myRandom(bVariance, 7)) AND 7)
		poke $D016, %00001000 OR myRandom(bVariance, 7)
		VOICE 3 TONE wEventSound  ON
		wait $d011, 128, 128 : wait $d011, 128
		
		bAnimFrameCounter = (bAnimFrameCounter + 1) AND 3
		if bAnimFrameCounter = 0 then bVariance = bVariance - 1
		wEventSound = wEventSound - 40
	loop until bVariance = 255
	
	VOICE 2 OFF
	VOICE 3 OFF
end sub

sub mazeShiftAway() STATIC
	dim wLineAddress as WORD FAST : dim wColorLineAddress as WORD FAST
	Dim nShiftLine as BYTE FAST
	
	for nShiftLine = 0 to 24
		wLineAddress = scrAddrCache(nShiftLine)
		wColorLineAddress = VIC_COLOR_OFFSET + wLineAddress
		memcpy wLineAddress + 1, wLineAddress, 31
		memcpy wColorLineAddress + 1, wColorLineAddress, 31
	next nShiftLine
	
	for N = 0 to 15 '31 columns, 2 cells moved per frame, so 16 times
		for nShiftLine = 0 to 24
			wLineAddress = scrAddrCache(nShiftLine)
			wColorLineAddress = VIC_COLOR_OFFSET + wLineAddress
			memcpy wLineAddress + 2, wLineAddress, 30
			memcpy wColorLineAddress + 2, wColorLineAddress, 30
		next nShiftLine
		wait $d011, 128
	next N
end sub

sub openDoorAnimation() SHARED STATIC
	Dim bDoorColor as BYTE : bDoorColor = 14 'light blue
	Dim bDoorChar as BYTE : bDoorChar = DOOR_CLOSED_REVERSED
	wEventSound = $7F00
	
	VOICE 1 OFF  
	VOICE 2 OFF
	VOICE 3 OFF  WAVE PULSE  ADSR 0, 0, 12, 1
	
	For bAnimFrameCounter = 1 to 20
		bDoorChar = bDoorChar XOR 2 'alternates normal door, reversed door, normal door, ... (or viceversa)
		poke wDoorAddress, bDoorChar
		bDoorColor = bDoorColor XOR 9 'alternates yellow, light blue, yellow, ...
		poke wDoorColorAddress, bDoorColor
		VOICE 3 TONE wEventSound  PULSE 63  ON
		wEventSound = wEventSound + 780
		wait $d011, 128, 128 : wait $d011, 128 : wait $d011, 128, 128 : wait $d011, 128
		if bAnimFrameCounter = 10 then bDoorChar = DOOR_OPEN 'changes from reversed closed door to NORMAL open door
	Next bAnimFrameCounter
	VOICE 3 OFF  TONE 0  WAVE TRI  ADSR 0, 0, VOI3_S, VOI3_R
	bSoundTimer_TreasureTaken = 0
end sub

sub timedSounds() STATIC
	dim bSoundPreviousIndex as BYTE
	
	if bSoundTimer_GoldTaken then
		VOICE 3 TONE shr(wNoteTable(bSoundIndex), 2)  ON
		bSoundIndex = (bSoundIndex + 1) AND 3
		
		bSoundTimer_GoldTaken = bSoundTimer_GoldTaken - 1
		if bSoundTimer_GoldTaken = 0 then VOICE 3 OFF : bSoundTimer_TreasureTaken = 0
		exit sub
	end if
	
	if bSoundTimer_TreasureTaken then
		bSoundPreviousIndex = bSoundIndex
		do
			bSoundIndex = myRandom(3, 3)
		loop while bSoundIndex = bSoundPreviousIndex
		
		VOICE 3 TONE wNoteTable(bSoundIndex)  ON
		
		bSoundTimer_TreasureTaken = bSoundTimer_TreasureTaken - 1
		if bSoundTimer_TreasureTaken = 0 then VOICE 3 OFF
	end if
end sub

sub colouredFrame() STATIC
	Dim iFrameColorAddress as INT FAST
	Dim bStripIndex as BYTE FAST
	Dim bStartingStripIndex as BYTE FAST
	Dim bStripColors(8) as BYTE @loc_bStripColors
loc_bStripColors:
	DATA as BYTE 1, 1, 7, 7, 3, 3, 2, 2 'white, yellow, cyan, red
	
	VOICE 1 OFF  WAVE TRI  TONE shr(wNoteTable(0), 4)  ADSR 0, 11, 1, 10  ON
	VOICE 2 OFF  WAVE TRI  TONE shr(wNoteTable(1), 1)  ADSR 0, 11, 1, 10  ON
	VOICE 3 OFF  WAVE TRI  TONE wNoteTable(2)  ADSR 0, 11, 1, 10  ON
	
	bStartingStripIndex = 0
	
	do
		bStripIndex = bStartingStripIndex
		
		for iFrameColorAddress = $D800 to $D81E
			poke iFrameColorAddress, bStripColors(bStripIndex)
			bStripIndex = (bStripIndex + 1) AND 7
		next iFrameColorAddress
		for iFrameColorAddress = $D846 to $DBDE STEP 40
			poke iFrameColorAddress, bStripColors(bStripIndex)
			bStripIndex = (bStripIndex + 1) AND 7
		next iFrameColorAddress
		poke wDoorColorAddress, 13 'light green (Player is here)
		for iFrameColorAddress = $DBDD to $DBC0 STEP -1
			poke iFrameColorAddress, bStripColors(bStripIndex)
			bStripIndex = (bStripIndex + 1) AND 7
		next iFrameColorAddress
		for iFrameColorAddress = $DB98 to $D828 STEP -40
			poke iFrameColorAddress, bStripColors(bStripIndex)
			bStripIndex = (bStripIndex + 1) AND 7
		next iFrameColorAddress

		for bAnimFrameCounter = 1 to 5
			wait $D011, 128, 128 : wait $D011, 128
			if peek( $DC00) = %01101111 then exit do 'if fire button is pressed, exit
		next bAnimFrameCounter
		
		bStartingStripIndex = (bStartingStripIndex - 2) AND 7
	loop
	
	VOICE 1 TONE shr(wNoteTable(0), 3)  OFF
	VOICE 2 TONE shr(wNoteTable(0), 1)  OFF
	VOICE 3 TONE shl(wNoteTable(0), 1)  OFF
end sub

sub titleScreen() STATIC
	Const PLAYER_LOCATION = 1354
	Const MONSTER_LOCATION = 1434
	
	Dim sCredits(5) as STRING * 40 @loc_sCredits
loc_sCredits:
DATA as STRING * 40 "       written by jjflash@itch.io       "
DATA as STRING * 40 " original vic-20 game: anthony godshall "
DATA as STRING * 40 "    atari graphics: compute! gazette    "
DATA as STRING * 40 "    ti99-4/a version: cheryl regena     "
DATA as STRING * 40 " xc=basic 3: csaba fekete - xc-basic.net"
	Dim bCreditIndex as BYTE
	
	'treasure frame for title
	memset 1036, 16, TREASURE_GOLD
	memset 1236, 16, TREASURE_GOLD
	memset 55308, 216, 7 'yellow
	poke 1076, TREASURE_GOLD
	poke 1116, TREASURE_GOLD
	poke 1156, TREASURE_GOLD
	poke 1196, TREASURE_GOLD
	poke 1091, TREASURE_GOLD
	poke 1131, TREASURE_GOLD
	poke 1171, TREASURE_GOLD
	poke 1211, TREASURE_GOLD
	
	textat 15, 2, "superchase", 1 'white
	textat 17, 3, "remix!", 1 'white
	textat 13, 8, "treasure hunter", 3 'cyan
	textat 13, 10, "monster of dungeons!", 7 'yellow
	
	textat 12, 15, "choose skill level", 5 'green
	textat 13, 19, "then press fire", 5 'green

	charat 18, 17, 60, 10 'left arrow, light red
	charat 22, 17, 62, 10 'right arrow, light red
	
	poke PLAYER_LOCATION, PLAYER : poke 55626, 13 'light green
	poke MONSTER_LOCATION, MONSTER : poke 55706, 2 'red
	
	bCreditIndex = 0
	do
		textat 0, 24, sCredits(bCreditIndex), 15 'light gray
		
		for bFrameCounter = 1 to 36
			charat 20, 17, 48 + bSkillLevel, 1 'white
			
			poke 55994, 10 'color for left arrow, light red
			poke 55998, 10 'color for right arrow, light red
			
			bJoystick2 = peek( $DC00) XOR 127
			
			if (bJoystick2 AND 4) then 'left
				poke 55994, 1 'color for left arrow, white
				if bSkillLevel > 1 then bSkillLevel = bSkillLevel - 1
			else
				if (bJoystick2 AND 8) then 'right
					poke 55998, 1 'color for right arrow, white
					if bSkillLevel < 9 then bSkillLevel = bSkillLevel + 1
				else
					if (bJoystick2 AND 16) then 'fire
						exit sub
					end if
				end if
			end if
			
			poke PLAYER_LOCATION, peek(PLAYER_LOCATION) XOR 1
			poke MONSTER_LOCATION, peek(MONSTER_LOCATION) XOR 1
			
			for bAnimFrameCounter = 1 to 6
				wait $D011, 128, 128 : wait $D011, 128 
			next bAnimFrameCounter

		next bFrameCounter
		bCreditIndex = bCreditIndex + 1 : if bCreditIndex = 5 then bCreditIndex = 0
	loop

end sub

sub playerAppears() STATIC
	charat 1, 1, PLAYER_ALT, 0 'black
	VOICE 1 WAVE PULSE TONE 10000 PULSE 2048 ADSR 0, 0, 2, 9 ON OFF
	For bAnimFrameCounter = 1 to 21
		poke $D829, peek( $D829) XOR 13 'row 1, col 1, light green
		wait $d011, 128, 128 : wait $d011, 128
		wait $d011, 128, 128 : wait $d011, 128
	next bAnimFrameCounter
end sub

'-----------------------------------------------------------------------
sub placeCharset() STATIC
	exit sub
origin $3800
incbin "charset_superchase.chr"
end sub

