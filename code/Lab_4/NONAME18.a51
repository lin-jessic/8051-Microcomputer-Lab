        ORG 0000H
        LJMP START

        ORG 000BH
        LJMP Timer0_ISR

TH0_INIT    EQU 0DCH
TL0_INIT    EQU 00H
CNT_TARGET  EQU 28H
CNT         EQU 30H
WALK        EQU 31H
DIR_FLAG    EQU 20H.0

        ORG 0030H

START:  MOV SP,#60H
        MOV WALK,#01H
        MOV P0,#0FEH
        CLR DIR_FLAG
        ACALL Timer_Config
        MOV CNT,#CNT_TARGET

MAIN_LOOP:
        JB P1.0,MAIN_LOOP
        ACALL DELAY_20MS
        JB P1.0,MAIN_LOOP
        CPL DIR_FLAG

WAIT_RELEASE:
        JNB P1.0,WAIT_RELEASE
        ACALL DELAY_20MS
        SJMP MAIN_LOOP

Timer_Config:
        MOV TMOD,#01H
        MOV TCON,#10H
        MOV IE,#82H
        MOV TH0,#TH0_INIT
        MOV TL0,#TL0_INIT
        RET

Timer0_ISR:
        PUSH ACC
        PUSH PSW
        MOV TH0,#TH0_INIT
        MOV TL0,#TL0_INIT
        DJNZ CNT,ISR_Exit
        MOV CNT,#CNT_TARGET

        JB DIR_FLAG,ISR_LEFT

ISR_RIGHT:
        MOV A,WALK
        RL A
        JNZ NoWrap_R
        MOV A,#01H

NoWrap_R:
        MOV WALK,A
        CPL A
        MOV P0,A
        SJMP ISR_Exit

ISR_LEFT:
        MOV A,WALK
        RR A
        JNZ NoWrap_L
        MOV A,#80H

NoWrap_L:
        MOV WALK,A
        CPL A
        MOV P0,A

ISR_Exit:
        POP PSW
        POP ACC
        RETI

DELAY_20MS:
        PUSH 00H
        PUSH 01H
        MOV R0,#100

D20_L1: MOV R1,#200

D20_L2: DJNZ R1,D20_L2
        DJNZ R0,D20_L1
        POP 01H
        POP 00H
        RET

        END