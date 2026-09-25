        ORG 0000H
        LJMP START

        ORG 000BH
        LJMP Timer0_ISR

CNT4    EQU 30H
PATTERN EQU 31H

START:  MOV PATTERN,#0FEH
        MOV P0,#0FFH
        ACALL Timer_Config
        MOV CNT4,#4

MAIN_LOOP:
        SJMP MAIN_LOOP

Timer_Config:
        MOV TMOD,#01H
        MOV TH0,#0B2H
        MOV TL0,#00H
        MOV IE,#82H
        MOV TCON,#10H
        RET

Timer0_ISR:
        DJNZ CNT4,reset_timer
        MOV CNT4,#4

        MOV A,PATTERN
        RL A
        MOV PATTERN,A
        MOV P0,A

reset_timer:
        MOV TL0,#00H
        MOV TH0,#0B2H
        RETI

        END