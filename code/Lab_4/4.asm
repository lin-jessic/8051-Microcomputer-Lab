        ORG 0000H
        LJMP MAIN

        ORG 000BH
        LJMP TIMER0_ISR

        ORG 0030H

MAIN:   MOV SP,#60H
        MOV P0,#0FEH
        CLR 20H.0

        MOV TMOD,#01H
        MOV TH0,#0DCH
        MOV TL0,#00H
        SETB ET0
        SETB EA
        SETB TR0
        MOV 30H,#40

MAIN_LOOP:
        JB P1.0,MAIN_LOOP
        ACALL DELAY_20MS
        JB P1.0,MAIN_LOOP
        CPL 20H.0

WAIT_RELEASE:
        JNB P1.0,WAIT_RELEASE
        ACALL DELAY_20MS
        SJMP MAIN_LOOP

TIMER0_ISR:
        PUSH ACC
        PUSH PSW

        MOV TH0,#0DCH
        MOV TL0,#00H

        DJNZ 30H,TIMER0_EXIT
        MOV 30H,#40

        JB 20H.0,ISR_LEFT_SHIFT
        ACALL SHIFT_RIGHT
        SJMP TIMER0_EXIT

ISR_LEFT_SHIFT:
        ACALL SHIFT_LEFT

TIMER0_EXIT:
        POP PSW
        POP ACC
        RETI

SHIFT_RIGHT:
        MOV A,P0
        JB ACC.7,SR_WRAP
        RL A
        MOV P0,A
        RET

SR_WRAP:
        MOV P0,#0FEH
        RET

SHIFT_LEFT:
        MOV A,P0
        JB ACC.0,SL_WRAP
        RR A
        MOV P0,A
        RET

SL_WRAP:
        MOV P0,#7FH
        RET

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