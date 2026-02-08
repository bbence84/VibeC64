PRINT CHR$($0E)
POKE 53280, 0 : POKE 53281, 0

DIM current_room AS BYTE
DIM has_dosszie AS BYTE
DIM has_irodakulcs AS BYTE
DIM has_belepo AS BYTE
DIM has_ora AS BYTE
DIM desk_open AS BYTE
DIM portrait_moved AS BYTE
DIM boss_met AS BYTE
DIM bizniszmen_met AS BYTE
DIM game_over AS BYTE

DIM cmd$ AS STRING * 32
DIM verb$ AS STRING * 16
DIM noun$ AS STRING * 16

current_room = 1
game_over = 0
has_dosszie = 0
has_irodakulcs = 0
has_belepo = 0
has_ora = 0
desk_open = 0
portrait_moved = 0
boss_met = 0
bizniszmen_met = 0

SUB parse_input() STATIC
    DIM i AS BYTE
    DIM space_pos AS BYTE
    verb$ = ""
    noun$ = ""
    space_pos = 0
    FOR i = 1 TO LEN(cmd$)
        IF MID$(cmd$, i, 1) = " " THEN
            space_pos = i
            EXIT FOR
        END IF
    NEXT i
    IF space_pos = 0 THEN
        verb$ = cmd$
    ELSE
        verb$ = LEFT$(cmd$, space_pos - 1)
        noun$ = RIGHT$(cmd$, LEN(cmd$) - space_pos)
    END IF
END SUB

SUB desc() STATIC
    PRINT "{CLR}{WHITE}"
    SELECT CASE current_room
        CASE 1
            PRINT "AZ IRODABAN VAGY. POR ES OLCSO KAVE"
            PRINT "SZAGA VAN. AZ ASZTALON IRATOK,"
            PRINT "A FALON EGY PORTRE LOG."
            IF boss_met = 0 THEN PRINT "A FONOKOD AZ ASZTAL ANAL UL."
        CASE 2
            PRINT "AZ UTCA ZAJOS ES KOSZOS."
            PRINT "ESZAKRA AZ IRODA, KELETRE A KASZINO,"
            PRINT "NYUGATRA A STADION TALALHATO."
        CASE 3
            PRINT "A KASZINO CSILLOG. PENZ ES FUST"
            PRINT "SZALL A LEVEGOBEN."
            IF bizniszmen_met = 0 THEN PRINT "EGY BIZNISZMEN UL A BARNAL."
        CASE 4
            PRINT "A STADION HATALMAS. A TOMEG MORAJLIK."
            PRINT "ESZAKRA A VIP PAHOLY BEJARATA VAN."
        CASE 5
            PRINT "MEGERKEZTEL A VIP PAHOLYBA!"
            PRINT "A RENDSZER KEGYELTJE LETTEL."
            PRINT "{YELLOW}GRATULALOK, NYERTEL!"
            game_over = 1
    END SELECT
    PRINT ""
END SUB

SUB move(dir$ AS STRING * 8) STATIC
    SELECT CASE current_room
        CASE 1
            IF dir$ = "DEL" THEN
                IF has_belepo = 1 THEN
                    current_room = 2
                ELSE
                    PRINT "A FONOK NEM ENGED KI BELEPO NELKUL!"
                END IF
            ELSE
                PRINT "ERRA NEM MEHETSZ."
            END IF
        CASE 2
            IF dir$ = "ESZAK" THEN : current_room = 1 : 
            ELSEIF dir$ = "KELET" THEN : current_room = 3 : 
            ELSEIF dir$ = "NYUGAT" THEN : current_room = 4 : 
            ELSE : PRINT "ERRA NEM MEHETSZ." : END IF
        CASE 3
            IF dir$ = "NYUGAT" THEN : current_room = 2 : 
            ELSE : PRINT "ERRA NEM MEHETSZ." : END IF
        CASE 4
            IF dir$ = "KELET" THEN : current_room = 2 : 
            ELSEIF dir$ = "ESZAK" THEN
                IF has_ora = 1 THEN
                    current_room = 5
                ELSE
                    PRINT "A VIP OR NEKED TUL CSORESZ. KELL EGY ORA!"
                END IF
            ELSE : PRINT "ERRA NEM MEHETSZ." : END IF
    END SELECT
END SUB

SUB handle_use() STATIC
    IF noun$ = "KULCS" AND has_irodakulcs = 1 AND current_room = 1 THEN
        PRINT "KINYITOTTAD AZ ASZTALFIOKOT. VAN BENNE EGY DOSSZIE."
        desk_open = 1
    ELSEIF noun$ = "PORTRE" AND current_room = 1 THEN
        PRINT "A PORTRE MOGOTT TALALTAL EGY KULCSOT!"
        portrait_moved = 1
    ELSE
        PRINT "EZT ITT NEM TUDOD HASZNALNI."
    END IF
END SUB

SUB handle_take() STATIC
    IF noun$ = "KULCS" AND portrait_moved = 1 AND current_room = 1 AND has_irodakulcs = 0 THEN
        PRINT "FELVETTED A KULCSOT."
        has_irodakulcs = 1
    ELSEIF noun$ = "DOSSZIE" AND desk_open = 1 AND current_room = 1 AND has_dosszie = 0 THEN
        PRINT "FELVETTED A DOSSZIET."
        has_dosszie = 1
    ELSE
        PRINT "NINCS ITT ILYESMI."
    END IF
END SUB

SUB handle_give() STATIC
    IF noun$ = "DOSSZIE" AND current_room = 1 AND boss_met = 0 AND has_dosszie = 1 THEN
        PRINT "A FONOK ELVETTE A DOSSZIET ES ADOTT EGY BELEPOT."
        has_belepo = 1
        has_dosszie = 0
        boss_met = 1
    ELSEIF noun$ = "DOSSZIE" AND current_room = 3 AND bizniszmen_met = 0 AND has_dosszie = 1 THEN
        PRINT "A BIZNISZMEN MEGKOZONTE AZ IRATOT ES ADOTT EGY ARANY ORAT."
        has_ora = 1
        has_dosszie = 0
        bizniszmen_met = 1
    ELSE
        PRINT "NEM TUDOD ODAADNI."
    END IF
END SUB

CALL desc()
WHILE game_over = 0
    PRINT "{CYAN}PARANCS: ";
    INPUT cmd$
    CALL parse_input()
    
    SELECT CASE verb$
        CASE "ESZAK", "DEL", "KELET", "NYUGAT"
            CALL move(verb$)
            CALL desc()
        CASE "NEZ"
            CALL desc()
        CASE "LELTAR"
            PRINT "NALAD VAN: ";
            IF has_irodakulcs = 1 THEN PRINT "KULCS ";
            IF has_dosszie = 1 THEN PRINT "DOSSZIE ";
            IF has_belepo = 1 THEN PRINT "BELEPO ";
            IF has_ora = 1 THEN PRINT "ORA ";
            IF has_irodakulcs=0 AND has_dosszie=0 AND has_belepo=0 AND has_ora=0 THEN PRINT "SEMMI";
            PRINT ""
        CASE "FELVESZ"
            CALL handle_take()
        CASE "HASZNAL"
            CALL handle_use()
        CASE "AD"
            CALL handle_give()
        CASE ELSE
            PRINT "NEM ERTEM..."
    END SELECT
LOOP

PRINT "A JATEKNAK VEGE."
END

REM ==============================
REM CREATED USING VIBEC64 IN XC=BASIC
REM GITHUB.COM/BBENCE84/VIBEC64
