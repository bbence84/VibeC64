PRINT CHR$($0e)
BORDER 0 : BACKGROUND 0 : POKE 646, 1

DIM SHARED current_loc AS BYTE
DIM SHARED has_box AS BYTE
DIM SHARED has_palinka AS BYTE
DIM SHARED has_suit AS BYTE
DIM SHARED has_toll AS BYTE
DIM SHARED has_plane AS BYTE
DIM SHARED game_won AS BYTE
DIM SHARED gave_palinka AS BYTE

current_loc = 1
has_box = 0
has_palinka = 0
has_suit = 0
has_toll = 0
has_plane = 0
game_won = 0
gave_palinka = 0

DIM cmd AS STRING * 32
DIM verb AS STRING * 10
DIM noun AS STRING * 20

DECLARE SUB intro() STATIC
DECLARE SUB show_loc() STATIC
DECLARE SUB parse_input() STATIC
DECLARE SUB handle_move() STATIC
DECLARE SUB handle_talk() STATIC
DECLARE SUB handle_get() STATIC
DECLARE SUB handle_give() STATIC
DECLARE SUB handle_use() STATIC
DECLARE SUB split_cmd() STATIC

CALL intro()

DO WHILE game_won = 0
    CALL show_loc()
    PRINT "mit teszel? ";
    INPUT cmd
    IF cmd <> "" THEN
        CALL split_cmd()
        CALL parse_input()
    END IF
LOOP

PRINT "{CLR}{DOWN}gyoztel! a tender a tied!"
PRINT "az arany alairortollal minden kapu kinyilt."
END

SUB intro() STATIC
    PRINT "{CLR}{WHT}*** NER-LOVAG KALAND ***"
    PRINT "{DOWN}szerezd meg az arany alairortollat"
    PRINT "es nyerj meg egy tendert!{DOWN}"
    PRINT "parancsok: VERB NOUN (pl. menj eszak)"
    PRINT "helyszinek: kisbolt, bazar, jacht, hatosag"
    PRINT "karakterek: lolo, polgarmester"
    PRINT "targyak: doboz, palinka, oltozony, toll"
    PRINT "----------------------------------------"
END SUB

SUB show_loc() STATIC
    PRINT "{DOWN}{YEL}helyszin: ";
    SELECT CASE current_loc
        CASE 1
            PRINT "kisbolt (start)"
            PRINT "{GRN}a polgarmester itt iszik a pultnal."
            IF has_box = 0 THEN PRINT "latsz egy nokia dobozt."
            IF has_palinka = 0 THEN PRINT "van itt egy uveg palinka."
        CASE 2
            PRINT "varkert bazar"
            PRINT "{GRN}elegans hely. latszolag ures."
            IF has_suit = 0 THEN PRINT "egy oltozony van a fogason."
        CASE 3
            PRINT "adria jacht"
            PRINT "{GRN}lolo itt pihen a fedelzeten."
            IF has_toll = 0 THEN PRINT "lolo kezeben egy arany toll van."
        CASE 4
            PRINT "hatosag"
            PRINT "{GRN}itt dolnek el a tenderek."
    END SELECT
    PRINT "{WHT}";
END SUB

SUB split_cmd() STATIC
    DIM i AS BYTE
    DIM sp AS BYTE
    DIM char_at AS STRING * 1
    sp = 0
    verb = ""
    noun = ""
    FOR i = 1 TO LEN(cmd)
        char_at = MID$(cmd, i, 1)
        IF char_at = " " THEN
            sp = i
            i = LEN(cmd)
        END IF
    NEXT i
    IF sp > 0 THEN
        verb = LEFT$(cmd, sp - 1)
        noun = RIGHT$(cmd, LEN(cmd) - sp)
    ELSE
        verb = cmd
    END IF
END SUB

SUB parse_input() STATIC
    SELECT CASE verb
        CASE "menj"
            CALL handle_move()
        CASE "beszel"
            CALL handle_talk()
        CASE "vedd", "ker"
            CALL handle_get()
        CASE "ad"
            CALL handle_give()
        CASE "hasznal"
            CALL handle_use()
        CASE ELSE
            PRINT "nem ertem ezt a parancsot."
    END SELECT
END SUB

SUB handle_move() STATIC
    SELECT CASE noun
        CASE "kisbolt"
            current_loc = 1
        CASE "bazar"
            IF has_suit = 1 THEN
                current_loc = 2
            ELSE
                PRINT "ebben a rongyban nem mehetsz a bazarba!"
            END IF
        CASE "jacht"
            IF has_plane = 1 THEN
                current_loc = 3
            ELSE
                PRINT "nincs magangeped, hogy adriara menj!"
            END IF
        CASE "hatosag"
            current_loc = 4
        CASE ELSE
            PRINT "ismeretlen irany."
    END SELECT
END SUB

SUB handle_talk() STATIC
    IF noun = "polgarmester" AND current_loc = 1 THEN
        IF gave_palinka = 0 THEN
            PRINT "szomjas vagyok fiam, hozz egy kis utitarsat."
        ELSE
            IF has_box = 1 THEN
                PRINT "latom megvan a kenopenz. vigyed a bazarba!"
            ELSE
                PRINT "kellene az a nokia doboz a mutyihoz."
            END IF
        END IF
    ELSE
        IF noun = "lolo" AND current_loc = 3 THEN
            PRINT "szia uram! tollat akarsz? kellene egy magangep elobb."
        ELSE
            PRINT "nem felel senki."
        END IF
    END IF
END SUB

SUB handle_get() STATIC
    IF noun = "doboz" AND current_loc = 1 THEN
        has_box = 1 : PRINT "eltetted a nokia dobozt."
    ELSE
        IF noun = "palinka" AND current_loc = 1 THEN
            has_palinka = 1 : PRINT "eltetted a palinkat."
        ELSE
            IF noun = "oltozony" AND current_loc = 2 THEN
                has_suit = 1 : PRINT "felvetted a ner-lovag jelmezt."
            ELSE
                IF noun = "toll" AND current_loc = 3 THEN
                    IF has_plane = 1 THEN
                        has_toll = 1 : PRINT "lolo neked adta az arany tollat."
                    ELSE
                        PRINT "lolo: te nem vagy kozulunk valo!"
                    END IF
                ELSE
                    PRINT "ez itt nincs meg."
                END IF
            END IF
        END IF
    END IF
END SUB

SUB handle_give() STATIC
    IF noun = "palinka" AND current_loc = 1 AND has_palinka = 1 THEN
        gave_palinka = 1 : has_palinka = 0
        PRINT "a polgarmester kitta es elmeselte a repulo titkat."
        PRINT "most mar beszerezhetsz egy magangepet."
        has_plane = 1
    ELSE
        PRINT "ezt nem tudod odaadni."
    END IF
END SUB

SUB handle_use() STATIC
    IF noun = "toll" AND current_loc = 4 AND has_toll = 1 THEN
        game_won = 1
    ELSE
        PRINT "ezt most nem tudod hasznalni."
    END IF
END SUB
