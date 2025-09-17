        ORG 0000h
        JP START

; ===============================
; Interrupt vector (IM1)
; ===============================
        ORG $0038
        JP INT_HANDLER

; ===============================
; START
; ===============================
START:
        LD SP,$6000
        DI
        CALL CLEAR_SCREEN
        CALL FILL_ATTRS

        ; Copyright
        LD HL,0          ; rij 0
        LD DE,STR_COPYRIGHT
        CALL PRINT_TEXT

        ; Interrupt test
        CALL RAM_TEST
        JR Z,INT_OK
        LD HL,2
        LD DE,STR_INT_FAIL
        CALL PRINT_TEXT
        JR CONTINUE
INT_OK:
        LD HL,2
        LD DE,STR_INT_OK
        CALL PRINT_TEXT
CONTINUE:

        ; Keyboard label
        LD HL,4
        LD DE,STR_KEYTEST
        CALL PRINT_TEXT

        ; Naam onderaan
        LD HL,6
        LD DE,STR_NAME
        CALL PRINT_TEXT

        IM 1
        EI

MAIN_LOOP:
        ; toetsenbord uitlezen
        LD BC,$FEFE     ; ENTER
        IN A,(C)
        BIT 0,A
        JR NZ,CHECK_J
        LD HL,4
        LD DE,STR_KEY_ENTER
        CALL PRINT_TEXT
        JR MAIN_LOOP

CHECK_J:
        LD BC,$F7FE     ; J
        IN A,(C)
        BIT 4,A
        JR NZ,MAIN_LOOP
        LD HL,4
        LD DE,STR_KEY_J
        CALL PRINT_TEXT
        JR MAIN_LOOP

; ===============================
; CLEAR_SCREEN
; ===============================
CLEAR_SCREEN:
        LD HL,$4000
        LD DE,$57FF
        LD A,0
CLS_LOOP:
        LD (HL),A
        INC HL
        LD A,H
        CP D
        JR NZ,CLS_LOOP
        LD A,L
        CP E
        JR NZ,CLS_LOOP
        RET

; ===============================
; FILL_ATTRS (wit op blauw)
; ===============================
FILL_ATTRS:
        LD HL,$5800
        LD DE,$5AFF
        LD A,%00000111 | %01000000 ; wit op blauw
ATTR_LOOP:
        LD (HL),A
        INC HL
        LD A,H
        CP D
        JR NZ,ATTR_LOOP
        LD A,L
        CP E
        JR NZ,ATTR_LOOP
        RET

; ===============================
; RAM TEST
; ===============================
RAM_TEST:
        LD HL,$4000
        LD A,%10101010
        LD (HL),A
        LD A,(HL)
        CP %10101010
        RET

; ===============================
; PRINT_TEXT HL=row, DE=string
; ===============================
PRINT_TEXT:
        PUSH BC
        PUSH DE
        PUSH HL
        LD B,H
        LD C,L
PT_LOOP:
        LD A,(DE)
        CP 0
        JR Z,PT_DONE
        CALL DRAW_CHAR
        INC DE
        INC L
        JR PT_LOOP
PT_DONE:
        POP HL
        POP DE
        POP BC
        RET

; ===============================
; DRAW_CHAR – Spectrum bitmap addressing
; ===============================
DRAW_CHAR:
        PUSH AF
        PUSH BC
        LD B,A          ; karakter in B
        LD HL,FONT
FONT_SEARCH:
        LD A,(HL)
        CP B
        JR NZ,FONT_NEXT
        INC HL
        LD DE,HL
        LD HL,$4000
        CALL DRAW_8x8
        POP BC
        POP AF
        RET
FONT_NEXT:
        INC HL
        JR FONT_SEARCH

; ===============================
; DRAW_8x8 – teken 8x8 bitmap op HL
; ===============================
DRAW_8x8:
        PUSH BC
        PUSH DE
        LD C,0          ; kolom offset
DRAW8_LOOP:
        LD A,(DE)
        ; Hier Spectrum memory mapping nodig:
        ; VRAM: $4000 + (Ymod64 << 8) + (Ydiv64 << 5) + Xdiv8
        ; Voor demo: schrijf lineair
        LD (HL),A
        INC HL
        INC DE
        CP 8
        JR NZ,DRAW8_LOOP
        POP DE
        POP BC
        RET

; ===============================
; Interrupt handler
; ===============================
INT_HANDLER:
        PUSH AF
        PUSH HL
        ; voorbeeld pixel
        LD HL,$4000
        LD A,%11111111
        LD (HL),A
        POP HL
        POP AF
        EI
        RETI

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
