SHARED Const PLAYER = 64
SHARED Const PLAYER_ALT = 65
       Const PLAYER_LEFT = 66

Const MASK_TREASURE_GOLD = 247 '1111 0111
Const MASK_TILE = 7            '0000 0111

SHARED Const EAST = 0
       Const NORTH = 1
       Const WEST = 2
       Const SOUTH = 3

Dim SHARED bPlayer_Col as BYTE
Dim SHARED bPlayer_Row as BYTE
Dim SHARED bPlayer_FacingCharacter as BYTE

Dim bPlayerDirection as BYTE

declare function playerMoved as BYTE () STATIC

sub initPlayer() SHARED STATIC
	bPlayer_Col = 1
	bPlayer_Row = 1
	bPlayer_FacingCharacter = PLAYER
	
	VOICE 1 TONE 256  PULSE 1536  WAVE PULSE  ADSR 0, 0, VOI1_S, VOI1_R  OFF 'player sound
end sub

sub playerMovement() SHARED STATIC	
	bJoystick2 = peek( $DC00) XOR 127

	if (bJoystick2 AND 1) then
		bPlayerDirection = NORTH
		if playerMoved() then exit sub
	else
		if (bJoystick2 AND 2) then
			bPlayerDirection = SOUTH
			if playerMoved() then exit sub
		end if
	end if
	
	if (bJoystick2 AND 4) then
		bPlayerDirection = WEST
		bPlayer_FacingCharacter = PLAYER_LEFT
		if playerMoved() then exit sub
	else
		if (bJoystick2 AND 8) then
			bPlayerDirection = EAST
			bPlayer_FacingCharacter = PLAYER
			if playerMoved() then exit sub
		end if
	end if
end sub

function playerMoved as BYTE () STATIC
	Dim wScoreTable(5) as WORD @loc_wScoreTable
loc_wScoreTable:
	DATA AS WORD 10, 20, 30, 50, 500

	bPeekedTileContent = peek(scrAddrCache(bPlayer_Row) + bPlayer_Col + iDirections(bPlayerDirection))
	
	if (bPeekedTileContent AND MASK_ALL) = GROUP_CREATURES then 'Player bumped into Monster!
		charat bPlayer_Col, bPlayer_Row, SPACE
		bExitEvent = EVENT_PLAYER_CAUGHT
		return TRUE
	end if
	
	if (bPeekedTileContent AND MASK_WALKABLE) = GROUP_WALKABLE then
		charat bPlayer_Col, bPlayer_Row, TRAIL, 11 'dark grey
		VOICE 1 ON
		
		if (bPlayerDirection AND 1) then 'odd number, vertical direction
			bPlayer_Row = bPlayer_Row + cbyte(SGN(iDirections(bPlayerDirection)))
		else 'even number, horizontal direction
			bPlayer_Col = bPlayer_Col + cbyte(iDirections(bPlayerDirection))
		end if
		charat bPlayer_Col, bPlayer_Row, bPlayer_FacingCharacter, 13 'light green
		
		if (bPeekedTileContent AND MASK_ALL) = GROUP_TREASURE Then
			bTreasuresCollected = bTreasuresCollected + 1
			if bTreasuresCollected = bTreasuresToActivateMonster then bMonsterIsOn = TRUE
			if (bPeekedTileContent AND MASK_TREASURE_GOLD) = TREASURE_GOLD then 'both non-marked and marked gold!
				bGoldNotCollected = FALSE : bSoundTimer_GoldTaken = 28
			else
				bSoundTimer_TreasureTaken = 7
			end if
			wScore = wScore + wScoreTable( (bPeekedTileContent AND MASK_TILE) )
			textat 33, 15, wScore, 10 'light red
			if bTreasuresCollected = bTreasuresToOpenDoor then call openDoorAnimation()
		else
			if bPeekedTileContent = DOOR_OPEN then bExitEvent = EVENT_PLAYER_EXITED
		end if

		return TRUE
	end if
	return FALSE
end function
