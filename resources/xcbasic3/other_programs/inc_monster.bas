Const MASK_SUBGROUP = 8       '0000 1000
Const MASK_WALK_LOWHALF = 24  '0001 1000

Dim SHARED bMonster_Col as BYTE
Dim SHARED bMonster_Row as BYTE
Dim        bMonster_Direction as BYTE
Dim        bMonster_Lag as BYTE
Dim        bMonster_PreviousTile as BYTE
Dim SHARED bMonster_SpeedUpMode as BYTE
Dim        bMonster_MarkingMode as BYTE
Dim        bMonster_DelayFrame as BYTE
Dim        bMonster_Distance_TurnONSpeedUp as BYTE
Dim        bMonster_Distance_TurnOFFSpeedUp as BYTE

Dim bManhattanDistance as BYTE

declare sub monsterMovement() STATIC

sub initMonster() SHARED STATIC
	bMonsterIsOn = FALSE
	if bSkillLevel < 8 then
		bTreasuresToActivateMonster = 8 - bSkillLevel
	end if

	bMonster_Col = 1
	bMonster_Row = 1
	bMonster_Direction = EAST
	bMonster_Lag = 10
	bMonster_PreviousTile = SPACE
	bMonster_SpeedUpMode = FALSE
	bMonster_MarkingMode = FALSE

	if bSkillLevel < 16 then
		bMonster_Distance_TurnONSpeedUp = 21 - bSkillLevel 'minimum: 6
		bMonster_Distance_TurnOFFSpeedUp = 12 - shr(bSkillLevel, 1) 'minimum: 5
	end if
	
	bMonster_DelayFrame = 9 '= Lag - 1
	
	VOICE 2 OFF TONE 256  WAVE NOISE  ADSR 0, 0, VOI2_S, VOI2_R 'monster sound
	
end sub

sub handleMonster() SHARED STATIC
	Dim bMoveFrame as BYTE
	
	bManhattanDistance = myByteABS(bPlayer_Row - bMonster_Row) + myByteABS(bPlayer_Col - bMonster_Col)
	if bManhattanDistance > bMonster_Distance_TurnONSpeedUp then
		bMonster_SpeedUpMode = TRUE
	else
		if bManhattanDistance < bMonster_Distance_TurnOFFSpeedUp then
			if bMonster_SpeedUpMode then
				if bMonster_Lag > 1 then
					bMonster_Lag = bMonster_Lag - 1
					textat 33, 20, 11 - bMonster_Lag, 2 'red
				end if
				bMonster_SpeedUpMode = FALSE
				VOICE 2 TONE 256 ADSR 0, 0, VOI2_S, VOI2_R
			end if
		end if
	end if
	if bMonster_SpeedUpMode then
		VOICE 2 TONE shl(cword(bManhattanDistance), 8) ADSR 0, 0, 2, VOI2_R
		call monsterMovement()
		exit sub
	end if
	
	if bMonster_DelayFrame then
		bMonster_DelayFrame = bMonster_DelayFrame - 1
		if bMonster_DelayFrame = 0 then bMoveFrame = bSkillLevel
	else
		call monsterMovement()
		if bMoveFrame then bMoveFrame = bMoveFrame - 1
		if bMoveFrame = 0 then bMonster_DelayFrame = bMonster_Lag - 1
	end if
	
end sub

sub monsterMovement() STATIC
	Const MINUS_ONE = 255
	Dim wPeekingLocation as WORD
	Dim bMonster_PreviousColour as BYTE

	Dim bTravelingDirection as BYTE

	Dim bThisTileDistance as BYTE
	Dim bClosestDistance as BYTE
	Dim bThisTileRow as BYTE
	Dim bThisTileCol as BYTE
	Dim bClosestTileDirection as BYTE
	Dim bPeekedDirection as BYTE FAST

	Dim bWalkableDirections(4) as BYTE '0...3
	Dim bWalkableDirections_Count as BYTE FAST
	Dim bTrailDirections(4) as BYTE '0...3
	Dim bTrailDirections_Count as BYTE FAST
	'------------------------------------------------
	wPeekingLocation = scrAddrCache(bMonster_Row) + bMonster_Col
	
	bTravelingDirection = bMonster_Direction

	bWalkableDirections_Count = MINUS_ONE
	bTrailDirections_Count = MINUS_ONE

	bClosestDistance = 255
	
	bMonster_Direction = (bMonster_Direction - 1) AND 3 'starting from the Monster's right (going clockwise)
	For bPeekedDirection = 1 to 4
		bPeekedTileContent = peek(wPeekingLocation + iDirections(bMonster_Direction))
		
		if (bPeekedTileContent AND MASK_ALL) = GROUP_CREATURES then bExitEvent = EVENT_PLAYER_CAUGHT : exit for 'Gotcha, Player!!
		
		if (bPeekedTileContent AND MASK_WALK_LOWHALF) = GROUP_WALKABLE then
			if bPeekedTileContent = TRAIL then
				bWalkableDirections_Count = bWalkableDirections_Count + 1
				bTrailDirections_Count = bTrailDirections_Count + 1
				bTrailDirections(bTrailDirections_Count) = bMonster_Direction
			else
				if bPeekedDirection < 4 then 'ignoring the opposite travelled direction!
					bWalkableDirections_Count = bWalkableDirections_Count + 1
					bWalkableDirections(bWalkableDirections_Count) = bMonster_Direction
					'ALSO, find the closest tile to the player...
					bThisTileRow = bMonster_Row : bThisTileCol = bMonster_Col
					if (bMonster_Direction AND 1) then 'odd number, vertical direction
						bThisTileRow = bMonster_Row + cbyte(SGN(iDirections(bMonster_Direction)))
					else 'even number, horizontal direction
						bThisTileCol = bMonster_Col + cbyte(iDirections(bMonster_Direction))
					end if
					bThisTileDistance = myByteABS(bPlayer_Row - bThisTileRow) + myByteABS(bPlayer_Col - bThisTileCol)
					if bThisTileDistance < bClosestDistance then
						bClosestDistance = bThisTileDistance
						bClosestTileDirection = bMonster_Direction
					end if
				end if
			end if
		end if
		
		bMonster_Direction = (bMonster_Direction + 1) AND 3 'now going counter-clockwise
	next bPeekedDirection
	
	if bExitEvent = EVENT_NONE then
		if bTrailDirections_Count <> MINUS_ONE then
			bMonster_Direction = bTrailDirections(myRandom(bTrailDirections_Count, 3))
		else
			if bWalkableDirections_Count = MINUS_ONE then
				bMonster_Direction = (bTravelingDirection + 2) AND 3 'go to the opposite direction and start marking tiles
				bMonster_MarkingMode = TRUE
			else
				if bWalkableDirections_Count = 2 then 'if there are *three* walkable tiles...
					bWalkableDirections_Count = bWalkableDirections_Count + 1
					bWalkableDirections(bWalkableDirections_Count) = bClosestTileDirection
				end if
				bMonster_Direction = bWalkableDirections(myRandom(bWalkableDirections_Count, 3))
			end if
		end if
		if bWalkableDirections_Count AND (bWalkableDirections_Count <> MINUS_ONE) then bMonster_MarkingMode = FALSE 'if there are at least *two* walkable tiles...
	end if

'------------------------DRAW-------------------------------------------
	if (bMonster_PreviousTile AND MASK_ALL) <> GROUP_TREASURE then
		bMonster_PreviousTile = SPACE
	end if
	if bMonster_MarkingMode then
		bMonster_PreviousTile = bMonster_PreviousTile OR MASK_SUBGROUP
	end if

	charat bMonster_Col, bMonster_Row, bMonster_PreviousTile, bMonster_PreviousColour
	
	bMonster_PreviousTile = peek(wPeekingLocation + iDirections(bMonster_Direction))
	bMonster_PreviousColour = peek(VIC_COLOR_OFFSET + wPeekingLocation + iDirections(bMonster_Direction))

	if (bMonster_Direction AND 1) then 'odd number, vertical direction
		bMonster_Row = bMonster_Row + cbyte(SGN(iDirections(bMonster_Direction)))
	else 'even number, horizontal direction
		bMonster_Col = bMonster_Col + cbyte(iDirections(bMonster_Direction))
	end if
	charat bMonster_Col, bMonster_Row, MONSTER, 2 'red
	VOICE 2 ON

end sub

