        ORG 0000h
		LD SP,$8000        ; stack in RAM
		JP START
        ; vul tot adres $0038 met NOPs
        defs $0038 - $, 0x00    

        JP INT_HANDLER
row_counter:   DB 0 
START:		

		
		CALL BLUE_SCREEN
		CALL CLEAR_SCREEN
		CALL PRINT_A
		IM 1
		EI

HALT_LOOP:
        JP HALT_LOOP

INT_HANDLER
        PUSH AF
        PUSH BC
        PUSH DE
        PUSH HL
		CALL PRINT_B
		CALL PRINT_IO
		CALL PRINT_COPYRIGHT
        POP HL
        POP DE
        POP BC
        POP AF
        EI
        RETI		
INT_HANDLER_2:
        PUSH AF
        PUSH BC
        PUSH DE
        PUSH HL
		CALL PRINT_B
        ; row_counter ophalen
        LD HL,row_counter
        LD A,(HL)

        ; Bereken poortadres = (row<<8)|$FE
        CPL                 ; ZX rij-actief = 0, dus invert bits
        LD B,A
        LD C,$FE
        IN A,(C)            ; lees toetsenrij

        ; Schrijf A naar VRAM
        ; basisadres = $4085
        LD H,$40
        LD L,$85
        LD D,(row_counter)
        LD E,0
        ADD HL,DE           ; HL = 4085 + row_counter*256
        LD (HL),A           ; sla databuswaarde op scherm

        ; row_counter++
        LD A,(row_counter)
        INC A
        CP 8
        JR NZ,no_wrap
        XOR A               ; terug naar 0
no_wrap:
        LD (row_counter),A

        POP HL
        POP DE
        POP BC
        POP AF
        EI
        RETI
		
;============================================
;		SUBRUTINES
;============================================		
CLEAR_SCREEN:
        LD HL,$4000        ; begin van bitmap
        LD DE,$4000+6144   ; eindadres bitmap
FILL_BITMAP:
		LD A,%00000000
        LD (HL),A
        INC HL
        LD A,H
        CP D
        JR NZ,FILL_BITMAP
        LD A,L
        CP E
        JR NZ,FILL_BITMAP
		
BLUE_SCREEN:
		LD HL,$5800
        LD DE,$5800+768
ATTR_LOOP:
        LD A,%00001111 ; FBPPPIII FBrgbrgb
		OR %01000000
        LD (HL),A
        INC HL
        LD A,H
        CP D
        JR NZ,ATTR_LOOP
        LD A,L
        CP E
        JR NZ,ATTR_LOOP
        RET
		
PRINT_A:
		LD HL,$4001
		LD A,%00111000
		LD (HL),A
		LD HL,$4101
		LD A,%01000100
		LD (HL),A
		LD HL,$4201
		LD A,%01000100
		LD (HL),A
		LD HL,$4301
		LD A,%01111100
		LD (HL),A
		LD HL,$4401
		LD A,%01000100
		LD (HL),A
		LD HL,$4501
		LD A,%01000100
		LD (HL),A
		LD HL,$4601
		LD A,%01000100
		LD (HL),A
		LD HL,$4701
		LD A,%00000000
		LD (HL),A
;		LD HL,$5801
;		LD A,%00000111
;		LD (HL),A
		RET
		
PRINT_B:
		LD HL,$4021
		LD A,%01111000
		LD (HL),A
		LD HL,$4121
		LD A,%01000100
		LD (HL),A
		LD HL,$4221
		LD A,%01000100
		LD (HL),A
		LD HL,$4321
		LD A,%01111000
		LD (HL),A
		LD HL,$4421
		LD A,%01000100
		LD (HL),A
		LD HL,$4521
		LD A,%01000100
		LD (HL),A
		LD HL,$4621
		LD A,%01111000
		LD (HL),A
		LD HL,$4721
		LD A,%00000000
		LD (HL),A
		LD HL,$5821
		LD A,%00001111
		LD (HL),A
		RET
		
PRINT_IO:
		LD HL,$4000
		LD BC,$AAFE
		IN A,(C)
		LD (HL), A
		RET
		
PRINT_COPYRIGHT:
        ; Copyright
        LD HL,$4000          ; rij 0
        LD DE,STR_KEY_ENTER
        CALL PRINT_TEXT
		RET
		
; ===============================
; Strings
; ===============================
STR_COPYRIGHT:  DB "(c) 1982 Sinclair Research Ltd",0
STR_INT_OK:     DB "INTERRUPT TEST: OK",0
STR_INT_FAIL:   DB "INTERRUPT TEST: FAIL",0
STR_KEYTEST:    DB "KEYBOARD TEST:",0
STR_KEY_ENTER:  DB "ENTER",0
STR_KEY_J:      DB "J",0
STR_NAME:       DB "Istvan SPECCY",0

; ===============================
; FONT table (8x8 per char)
; ===============================
FONT:
        ; spatie = 0x20
        DB 0,0,0,0,0,0,0,0
        ; A = 0x41
        DB %00111000,%01000100,%01000100,%01111100,%01000100,%01000100,%01000100,0
        ; B = 0x42
        DB %01111000,%01000100,%01000100,%01111000,%01000100,%01000100,%01111000,0
        ; C = 0x43
        DB %00111100,%01000010,%01000000,%01000000,%01000000,%01000010,%00111100,0
        ; D = 0x44
        DB %01111000,%01000100,%01000100,%01000100,%01000100,%01000100,%01111000,0
        ; E = 0x45
        DB %01111100,%01000000,%01000000,%01111000,%01000000,%01000000,%01111100,0
        ; F = 0x46
        DB %01111100,%01000000,%01000000,%01111000,%01000000,%01000000,%01000000,0
        ; G = 0x47
        DB %00111100,%01000010,%01000000,%01001110,%01000010,%01000010,%00111100,0
        ; H = 0x48
        DB %01000100,%01000100,%01000100,%01111100,%01000100,%01000100,%01000100,0
        ; I = 0x49
        DB %00111000,%00010000,%00010000,%00010000,%00010000,%00010000,%00111000,0
        ; J = 0x4A
        DB %00011100,%00001000,%00001000,%00001000,%01001000,%01001000,%00110000,0
        ; K = 0x4B
        DB %01000100,%01001000,%01010000,%01100000,%01010000,%01001000,%01000100,0
        ; L = 0x4C
        DB %01000000,%01000000,%01000000,%01000000,%01000000,%01000000,%01111100,0
        ; M = 0x4D
        DB %10001001,%11010101,%10101001,%10001001,%10001001,%10001001,%10001001,0
        ; N = 0x4E
        DB %01000100,%01100100,%01010100,%01001100,%01000100,%01000100,%0
        ; O = 0x4F
        DB %00111000,%01000100,%01000100,%01000100,%01000100,%01000100,%00111000,0
        ; P = 0x50
        DB %01111000,%01000100,%01000100,%01111000,%01000000,%01000000,%01000000,0
        ; Q = 0x51
        DB %00111000,%01000100,%01000100,%01000100,%01010100,%01001000,%00110100,0
        ; R = 0x52
        DB %01111000,%01000100,%01000100,%01111000,%01010000,%01001000,%01000100,0
        ; S = 0x53
        DB %00111100,%01000010,%01000000,%00111000,%00000010,%01000010,%00111100,0
        ; T = 0x54
        DB %01111100,%00010000,%00010000,%00010000,%00010000,%00010000,%00010000,0
        ; U = 0x55
        DB %01000100,%01000100,%01000100,%01000100,%01000100,%01000100,%00111000,0
        ; V = 0x56
        DB %01000100,%01000100,%01000100,%01000100,%01000100,%00101000,%00010000,0
        ; W = 0x57
        DB %10001001,%10001001,%10001001,%10101001,%10101001,%11010101,%10001001,0
        ; X = 0x58
        DB %01000100,%01000100,%00101000,%00010000,%00101000,%01000100,%01000100,0
        ; Y = 0x59
        DB %01000100,%01000100,%00101000,%00010000,%00010000,%00010000,%00010000,0
        ; Z = 0x5A
        DB %01111100,%00000100,%00001000,%00010000,%00100000,%01000000,%01111100,0
        ; cijfers 0-9 kunnen toegevoegd worden op dezelfde manier

; ===============================
; PRINT_TEXT HL=row, DE=string
; ===============================
; ====================================
; IN: HL = schermstart (row,col berekend)
;     DE = pointer naar string
; String eindigt met 0
; ====================================
PRINT_TEXT:
PT_LOOP:
        LD A,(DE)
        OR A
        RET Z              ; klaar bij 0
        CALL DRAW_CHAR
        INC DE             ; volgende karakter
        INC L              ; kolom +1
        JR PT_LOOP


; ===============================
; DRAW_CHAR – Spectrum bitmap addressing
; ===============================
; ====================================
; IN: HL = schermpositie
;     A  = karaktercode (ASCII)
; ====================================
DRAW_CHAR:
        PUSH DE
		PUSH HL
        PUSH AF

        ; Bereken offset = A*8
        LD L,A
        LD H,0
        ADD HL,HL   ; *2
        ADD HL,HL   ; *4
        ADD HL,HL   ; *8

        LD DE,FONT
        ADD HL,DE   ; HL = FONT + A*8
        EX DE,HL    ; DE = fontadres

        POP AF      ; A terughalen (niet meer nodig, maar netjes)
		POP HL
        CALL DRAW_8x8

        POP DE
        RET


; ===============================
; DRAW_8x8 – teken 8x8 bitmap op HL
; ===============================
; ====================================
; IN: HL = startadres schermpositie
;     DE = pointer naar 8-byte bitmap
; ====================================
DRAW_8x8:
        PUSH BC
		PUSH DE
		PUSH HL
        LD B,8              ; 8 rijen
DRAW8_LOOP:
        LD A,(DE)
        LD (HL),A           ; zet 1 rasterlijn
        INC DE
        INC H               ; volgende 256 bytes → volgende rasterlijn
        DJNZ DRAW8_LOOP
		POP HL
		POP DE
        POP BC
        RET
