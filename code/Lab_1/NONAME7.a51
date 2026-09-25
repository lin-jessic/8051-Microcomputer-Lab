        ORG 0000H

MAIN:   MOV P0,#0FFH
        MOV PSW,#00H

WAIT_KEY:
        MOV A,P1
        JZ WAIT_KEY

        MOV A,#11111110B

LOOP:   MOV P0,A
        LCALL DELAY
        RL A
        LJMP LOOP

DELAY:  MOV R0,#10

D1:     MOV R1,#40

D2:     MOV R2,#249

D3:     DJNZ R2,D3
        DJNZ R1,D2
        DJNZ R0,D1
        RET

        END