        ORG 0000h

        LD SP,$6000        ; stack in RAM

; =======================
; Vul BITMAP (0x4000-0x57FF) met patroon 00111100
; =======================
        LD HL,$4000        ; begin van bitmap
        LD DE,$4000+6144   ; eindadres bitmap
        LD A,%00111100     ; patroon (smalle horizontale balk)

FILL_BITMAP:
		LD A,%11111111
        LD (HL),A
        INC HL
        LD A,H
        CP D
        JR NZ,FILL_BITMAP
        LD A,L
        CP E
        JR NZ,FILL_BITMAP

; =======================
; Vul ATTR (0x5800-0x5AFF) met kleuren
; (ink: wit, paper: zwart, daarna andere kleuren)
; =======================
        LD HL,$5800        ; begin attributen
        LD DE,$5800+768    ; einde attributen

        LD B,0             ; kleur index

NEXT_ATTR:
        LD A,B
        AND %00000111      ; alleen INK bits gebruiken
        OR %01000000       ; PAPER=0, BRIGHT=1
        LD (HL),A
        INC HL
        INC B
        LD A,H
        CP D
        JR NZ,NEXT_ATTR
        LD A,L
        CP E
        JR NZ,NEXT_ATTR

; =======================
; Schrijven iets op scherm
; =======================

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
		LD HL,$5801
		LD A,%00000111
		LD (HL),A
		
; ============================
; Testwaarde schrijven
; ============================
        LD HL,$4000        ; testadres in VRAM
        LD A,%10101010     ; testwaarde
        LD (HL),A          ; schrijf waarde

; ============================
; Teruglezen
; ============================
        LD A,(HL)          ; lees waarde terug
        CP %10101010       ; vergelijk
        JR Z,TEST_OK       ; als gelijk → OK

; ============================
; Test FAIL → teken 'B'
; ============================
TEST_FAIL:
        LD HL,$4003        ; pixeldata adres voor 'O'
        LD A,%00111000
        LD (HL),A
        LD HL,$4103
        LD A,%01000100
        LD (HL),A
        LD HL,$4203
        LD A,%01000100
        LD (HL),A
        LD HL,$4303
        LD A,%01000100
        LD (HL),A
        LD HL,$4403
        LD A,%01000100
        LD (HL),A
        LD HL,$4503
        LD A,%01000100
        LD (HL),A
		LD HL,$4603
        LD A,%00111000
        LD (HL),A
		LD HL,$4703
        LD A,%00000000
        LD (HL),A
        LD HL,$5803        ; attribute
        LD A,%00000111     ; white on black
        LD (HL),A
        JP HALT_LOOP

; ============================
; Test OK → teken 'A'
; ============================
TEST_OK:
        LD HL,$4003        ; pixeldata adres voor 'A'
        LD A,%00111000
        LD (HL),A
        LD HL,$4103
        LD A,%01000100
        LD (HL),A
        LD HL,$4203
        LD A,%01111100
        LD (HL),A
        LD HL,$4303
        LD A,%01000100
        LD (HL),A
        LD HL,$4403
        LD A,%01000100
        LD (HL),A
        LD HL,$4503
        LD A,%01000100
        LD (HL),A
        LD HL,$5803        ; attribute
        LD A,%00000111     ; white on black
        LD (HL),A

; ============================
; Klaar
; ============================
; =======================
; Einde – blijf hier hangen
; =======================
HALT_LOOP:
        JP HALT_LOOP
