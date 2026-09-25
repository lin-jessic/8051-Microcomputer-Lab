        ORG 0000H

MAIN:   MOV P0,#0FFH
        MOV PSW,#00H

WAIT_KEY:
        MOV A,P1
        JZ WAIT_KEY

RIGHT_RIDER:
        MOV A,#11111000B
        MOV R4,#5

SCAN_RIGHT:
        MOV P0,A
        LCALL DELAY_100MS
        RR A
        DJNZ R4,SCAN_RIGHT

        MOV R4,#5

SCAN_LEFT:
        MOV P0,A
        LCALL DELAY_100MS
        RL A
        DJNZ R4,SCAN_LEFT
        SJMP RIGHT_RIDER

DELAY_100MS:
        MOV R0,#1

D1:     MOV R1,#40

D2:     MOV R2,#63

D3:     DJNZ R2,D3
        DJNZ R1,D2
        DJNZ R0,D1
        RET

        END