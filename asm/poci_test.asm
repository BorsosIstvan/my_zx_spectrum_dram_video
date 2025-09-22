        ORG 0000h
		LD SP,$5FFF        ; stack in RAM
		JP START
        ; vul tot adres $0038 met NOPs
        defs $0038 - $, 0x00    

        JP INT_HANDLER
START:		

		
		CALL BLUE_SCREEN
		CALL CLEAR_SCREEN
		CALL PRINT_A
		
		; RAM TEST
		; RAM1 = 0x6000 - 0x7FFF
		LD HL,0x6000
		LD DE,0x7FFF
		CALL TEST_RAM1_BLOCK

		; RAM2 = 0x8000 - 0x9FFF
		LD HL,0x8000
		LD DE,0x9FFF
		LD IX,PRINT_TEST_RAM2_OK
		LD IY,PRINT_TEST_RAM2_FAIL
		CALL TEST_RAM2_BLOCK

		; RAM3 = 0xA000 - 0xBFFF
		LD HL,0xA000
		LD DE,0xFFFF
		LD IX,PRINT_TEST_RAM3_OK
		LD IY,PRINT_TEST_RAM3_FAIL
		CALL TEST_RAM3_BLOCK

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
		
PRINT_TEST_RAM1_OK:
		PUSH HL
		LD HL,$4010
		LD A,%00111000
		LD (HL),A
		LD HL,$4110
		LD A,%01000100
		LD (HL),A
		LD HL,$4210
		LD A,%01000100
		LD (HL),A
		LD HL,$4310
		LD A,%01111100
		LD (HL),A
		LD HL,$4410
		LD A,%01000100
		LD (HL),A
		LD HL,$4510
		LD A,%01000100
		LD (HL),A
		LD HL,$4610
		LD A,%01000100
		LD (HL),A
		LD HL,$4710
		LD A,%00000000
		LD (HL),A
;		LD HL,$5810
;		LD A,%00000111
;		LD (HL),A
		POP HL
		RET

PRINT_TEST_RAM1_FAIL:
		PUSH HL
		LD HL,$4010
		LD A,%01111000
		LD (HL),A
		LD HL,$4110
		LD A,%01000100
		LD (HL),A
		LD HL,$4210
		LD A,%01000100
		LD (HL),A
		LD HL,$4310
		LD A,%01111000
		LD (HL),A
		LD HL,$4410
		LD A,%01000100
		LD (HL),A
		LD HL,$4510
		LD A,%01000100
		LD (HL),A
		LD HL,$4610
		LD A,%01111000
		LD (HL),A
		LD HL,$4710
		LD A,%00000000
		LD (HL),A
		LD HL,$5810
		LD A,%00001111
		LD (HL),A
		POP HL
		RET
		
PRINT_TEST_RAM2_OK:
		LD HL,$4030
		LD A,%00111000
		LD (HL),A
		LD HL,$4130
		LD A,%01000100
		LD (HL),A
		LD HL,$4230
		LD A,%01000100
		LD (HL),A
		LD HL,$4330
		LD A,%01111100
		LD (HL),A
		LD HL,$4430
		LD A,%01000100
		LD (HL),A
		LD HL,$4530
		LD A,%01000100
		LD (HL),A
		LD HL,$4630
		LD A,%01000100
		LD (HL),A
		LD HL,$4730
		LD A,%00000000
		LD (HL),A
		LD HL,$5830
		LD A,%00001111
		LD (HL),A
		RET

PRINT_TEST_RAM2_FAIL:
		LD HL,$4030
		LD A,%01111000
		LD (HL),A
		LD HL,$4130
		LD A,%01000100
		LD (HL),A
		LD HL,$4230
		LD A,%01000100
		LD (HL),A
		LD HL,$4330
		LD A,%01111000
		LD (HL),A
		LD HL,$4430
		LD A,%01000100
		LD (HL),A
		LD HL,$4530
		LD A,%01000100
		LD (HL),A
		LD HL,$4630
		LD A,%01111000
		LD (HL),A
		LD HL,$4730
		LD A,%00000000
		LD (HL),A
		LD HL,$5830
		LD A,%00001111
		LD (HL),A
		RET
		
PRINT_TEST_RAM3_OK:
		LD HL,$4050
		LD A,%00111000
		LD (HL),A
		LD HL,$4150
		LD A,%01000100
		LD (HL),A
		LD HL,$4250
		LD A,%01000100
		LD (HL),A
		LD HL,$4350
		LD A,%01111100
		LD (HL),A
		LD HL,$4450
		LD A,%01000100
		LD (HL),A
		LD HL,$4550
		LD A,%01000100
		LD (HL),A
		LD HL,$4650
		LD A,%01000100
		LD (HL),A
		LD HL,$4750
		LD A,%00000000
		LD (HL),A
		LD HL,$5850
		LD A,%00001111
		LD (HL),A
		RET

PRINT_TEST_RAM3_FAIL:
		LD HL,$4050
		LD A,%01111000
		LD (HL),A
		LD HL,$4150
		LD A,%01000100
		LD (HL),A
		LD HL,$4250
		LD A,%01000100
		LD (HL),A
		LD HL,$4350
		LD A,%01111000
		LD (HL),A
		LD HL,$4450
		LD A,%01000100
		LD (HL),A
		LD HL,$4550
		LD A,%01000100
		LD (HL),A
		LD HL,$4650
		LD A,%01111000
		LD (HL),A
		LD HL,$4750
		LD A,%00000000
		LD (HL),A
		LD HL,$5850
		LD A,%00001111
		LD (HL),A
		RET

		
	;-----------------------------------------
	; Test RAM van adres HL tot adres DE
	; In: HL = startadres
	;     DE = eindadres
	;     IX = pointer naar PRINT_OK routine
	;     IY = pointer naar PRINT_FAIL routine
	;-----------------------------------------
TEST_RAM1_BLOCK:
        PUSH AF
        PUSH BC
		PUSH DE
		PUSH HL

TEST_LOOP:
        LD (HL),0x55
        LD A,(HL)
        CP 0x55
        JR NZ,TEST_FAIL

        LD (HL),0xAA
        LD A,(HL)
        CP 0xAA
        JR NZ,TEST_FAIL

        INC HL
        LD A,H
        CP D
        JR NZ,TEST_LOOP
        LD A,L
        CP E
        JR NZ,TEST_LOOP

        ; ------------------------------
        ; Als RAM OK → print
        ; ------------------------------
        CALL PRINT_TEST_RAM1_OK
		POP HL
		POP DE
        POP BC
        POP AF
        RET

TEST_FAIL:
        CALL PRINT_TEST_RAM1_FAIL
        POP HL
		POP DE
        POP BC
        POP AF
        RET

TEST_RAM2_BLOCK:
        PUSH AF
        PUSH BC
		PUSH DE
		PUSH HL

TEST_LOOP2:
        LD (HL),0x55
        LD A,(HL)
        CP 0x55
        JR NZ,TEST_FAIL2

        LD (HL),0xAA
        LD A,(HL)
        CP 0xAA
        JR NZ,TEST_FAIL2

        INC HL
        LD A,H
        CP D
        JR NZ,TEST_LOOP2
        LD A,L
        CP E
        JR NZ,TEST_LOOP2

        ; ------------------------------
        ; Als RAM OK → print
        ; ------------------------------
        CALL PRINT_TEST_RAM2_OK
		POP HL
		POP DE
        POP BC
        POP AF
        RET

TEST_FAIL2:
        CALL PRINT_TEST_RAM2_FAIL
        POP HL
		POP DE
        POP BC
        POP AF
        RET
		
TEST_RAM3_BLOCK:
        PUSH AF
        PUSH BC
		PUSH DE
		PUSH HL

TEST_LOOP3:
        LD (HL),0x55
        LD A,(HL)
        CP 0x55
        JR NZ,TEST_FAIL3

        LD (HL),0xAA
        LD A,(HL)
        CP 0xAA
        JR NZ,TEST_FAIL3

        INC HL
        LD A,H
        CP D
        JR NZ,TEST_LOOP3
        LD A,L
        CP E
        JR NZ,TEST_LOOP3

        ; ------------------------------
        ; Als RAM OK → print
        ; ------------------------------
        CALL PRINT_TEST_RAM3_OK
		POP HL
		POP DE
        POP BC
        POP AF
        RET

TEST_FAIL3:
        CALL PRINT_TEST_RAM3_FAIL
        POP HL
		POP DE
        POP BC
        POP AF
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
