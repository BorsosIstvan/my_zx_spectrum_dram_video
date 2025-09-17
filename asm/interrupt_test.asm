        ORG 0000h
        JP START

; ------------------------------
; Interrupt vector (IM1)
; ------------------------------
        ORG $0038
        JP INT_HANDLER

; ------------------------------
; START
; ------------------------------
START:
        LD SP,$6000
        DI
        CALL CLEAR_SCREEN
        CALL FILL_ATTRS

        ; Copyright bovenaan
        LD HL,0          ; row 0
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
        ; ENTER toets
        LD BC,$FEFE
        IN A,(C)
        BIT 0,A
        JR NZ,CHECK_J
        LD HL,8
        LD DE,STR_KEY_ENTER
        CALL PRINT_TEXT
        JR MAIN_LOOP

CHECK_J:
        LD BC,$F7FE
        IN A,(C)
        BIT 4,A
        JR NZ,MAIN_LOOP
        LD HL,8
        LD DE,STR_KEY_J
        CALL PRINT_TEXT
        JR MAIN_LOOP

; ------------------------------
; CLEAR_SCREEN – bitmap leegmaken
; ------------------------------
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

; ------------------------------
; FILL_ATTRS – wit op blauw
; ------------------------------
FILL_ATTRS:
        LD HL,$5800
        LD DE,$5AFF
        LD A,%00000111 | %01000000
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

; ------------------------------
; RAM TEST
; ------------------------------
RAM_TEST:
        LD HL,$4000
        LD A,%10101010
        LD (HL),A
        LD A,(HL)
        CP %10101010
        RET

; ------------------------------
; PRINT_TEXT – HL=row, DE=string
; ------------------------------
PRINT_TEXT:
        PUSH BC
        PUSH DE
        PUSH HL
        LD B,H          ; row
PT_LOOP:
        LD A,(DE)
        CP 0
        JR Z,PT_DONE
        CALL DRAW_CHAR
        INC DE
        JR PT_LOOP
PT_DONE:
        POP HL
        POP DE
        POP BC
        RET

; ------------------------------
; DRAW_CHAR – teken 8x8 char op row/col
; ------------------------------
; HL = row*8, B = char code
DRAW_CHAR:
        PUSH AF
        PUSH BC
        PUSH DE
        LD C,0          ; column start (kan later dynamisch)
        LD E,B          ; char code
        LD D,0
        LD HL,SCREEN_ADDR
        LD DE,FONT+8    ; char bitmap offset
DRAW_LOOP:
        LD A,(DE)
        CALL DRAW_BYTE
        INC DE
        INC HL
        INC D
        CP 8
        JR NZ,DRAW_LOOP
        POP DE
        POP BC
        POP AF
        RET

; ------------------------------
; DRAW_BYTE – teken één byte op bitmap
; ------------------------------
; A = byte, HL = startadres
DRAW_BYTE:
        LD (HL),A
        RET

; ------------------------------
; SCREEN_ADDR – bereken Spectrum-adres van row/col
; ------------------------------
SCREEN_ADDR: EQU $4000

; ------------------------------
; Interrupt handler
; ------------------------------
INT_HANDLER:
        PUSH AF
        PUSH HL
        ; Teken een eenvoudige I
        LD HL,$4063
        LD A,%00111000
        LD (HL),A
        POP HL
        POP AF
        EI
        RETI

; ------------------------------
; Strings
; ------------------------------
STR_COPYRIGHT:  DB "(c) 1982 Sinclair Research Ltd",0
STR_INT_OK:     DB "INTERRUPT TEST: OK",0
STR_INT_FAIL:   DB "INTERRUPT TEST: FAIL",0
STR_KEYTEST:    DB "KEYBOARD TEST:",0
STR_KEY_ENTER:  DB "ENTER",0
STR_KEY_J:      DB "J",0
STR_NAME:       DB "Istvan SPECCY",0

; ------------------------------
; Font table (8x8) – enkel voorbeeld
; ------------------------------
FONT:
; hier komen de 8×8 bitmaps van de letters (A-Z, 0-9, etc)
        DB 0,0,124,18,18,124,0,0  ; A
        DB 0,0,126,74,74,126,0,0  ; B
        DB 0,0,60,66,66,60,0,0    ; C
        ; enzovoort...
