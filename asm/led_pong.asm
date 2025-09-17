        ORG 0000h
		
		LD SP,$6000        ; stack in RAM (laatste adres)

        LD HL,$4000

LOOP:   
        LD A,%11111110
        LD (HL),A

		CALL DELAY

        LD A,%11111101
        LD (HL),A

		CALL DELAY

        LD A,%11111011
        LD (HL),A

		CALL DELAY
		LD A,%11110111
        LD (HL),A

		CALL DELAY

        LD A,%11101111
        LD (HL),A

		CALL DELAY

        LD A,%11011111
        LD (HL),A

		CALL DELAY
		LD A,%10111111
        LD (HL),A

		CALL DELAY

        LD A,%01111111
        LD (HL),A

		CALL DELAY
		LD A,%01111111
        LD (HL),A

		CALL DELAY

        LD A,%10111111
        LD (HL),A

		CALL DELAY

        LD A,%11011111
        LD (HL),A

		CALL DELAY
		LD A,%11101111
        LD (HL),A

		CALL DELAY

        LD A,%11110111
        LD (HL),A

		CALL DELAY

        LD A,%11111011
        LD (HL),A

		CALL DELAY
		LD A,%11111101
        LD (HL),A

		CALL DELAY

        LD A,%11111110
        LD (HL),A

		CALL DELAY

        JP LOOP

; -----------------------
; Delay routine
; Geeft genoeg tijd om LED's te zien knipperen
DELAY:  LD DE,$FFFF       ; groot getal voor vertraging
WAIT:   DEC DE
        LD A,D
        OR E
        JR NZ,WAIT
        RET