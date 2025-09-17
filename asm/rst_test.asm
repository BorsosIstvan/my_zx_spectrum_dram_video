        ORG 0000h
		
		LD SP,$6000        ; stack in RAM (laatste adres)

START:  
        LD HL,$4000        ; VRAM beginadres

        ; ---- Eerste patroon: 16 keer F0/0F ----
        LD B,16
PATT1:  LD A,$F0
        LD (HL),A
        CALL DELAY

        LD A,$0F
        LD (HL),A
        CALL DELAY

        DJNZ PATT1

        ; ---- Tweede patroon: 16 keer AA/55 ----
        LD B,16
PATT2:  LD A,$AA
        LD (HL),A
        CALL DELAY

        LD A,$55
        LD (HL),A
        CALL DELAY

        DJNZ PATT2

        ; Ga terug naar begin
        JP START

; -----------------------
; Delay routine
; Geeft genoeg tijd om LED's te zien knipperen
DELAY:  LD DE,50000       ; groot getal voor vertraging
WAIT:   DEC DE
        LD A,D
        OR E
        JR NZ,WAIT
        RET
