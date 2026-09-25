        ORG 0000H
        LJMP START

        ORG 000BH
        LJMP Timer0_ISR

TH0_INIT    EQU 4CH
TL0_INIT    EQU 1DH
CNT_TARGET  EQU 28

CNT         EQU 30H
WALK        EQU 31H

START:  MOV WALK,#01H
        MOV P0,#0FFH
        ACALL Timer_Config
        MOV CNT,#CNT_TARGET

MAIN_LOOP:
        SJMP MAIN_LOOP

Timer_Config:
        MOV TMOD,#01H
        MOV TH0,#TH0_INIT
        MOV TL0,#TL0_INIT
        MOV IE,#82H
        MOV TCON,#10H
        RET

Timer0_ISR:
        MOV TH0,#TH0_INIT
        MOV TL0,#TL0_INIT
        DJNZ CNT,ISR_Exit
        MOV CNT,#CNT_TARGET
        MOV A,WALK
        RL A
        JNZ NoWrap
        MOV A,#01H

NoWrap: MOV WALK,A
        CPL A
        MOV P0,A

ISR_Exit:
        RETI

        END