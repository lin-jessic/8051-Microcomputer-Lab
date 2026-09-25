        ORG 0000H

START:  MOV R0,#20H
        MOV R1,#28H
        MOV R2,#08H
        MOV A,#20H

I0:     MOV @R0,A
        MOV @R1,A
        INC R0
        INC R1
        DJNZ R2,I0

        MOV P0,#0FFH
        MOV R3,#00H
        MOV R4,#00H

        MOV R0,#20H
        MOV R1,#28H
        MOV R2,#08H

L0:     MOV A,@R0
        MOV B,@R1
        MUL AB
        MOV R7,A

        MOV A,B
        JZ NOOV
        INC R4

NOOV:   MOV A,R3
        ADD A,R7
        MOV R3,A
        INC R0
        INC R1
        DJNZ R2,L0

        MOV A,R4
        JZ NOLED

        CJNE A,#01H,CHK2
        MOV P1,#0FEH
        SJMP STAY

CHK2:   CJNE A,#02H,CHK3
        MOV P1,#0FCH
        SJMP STAY

CHK3:   CJNE A,#03H,CHK4
        MOV P1,#0F8H
        SJMP STAY

CHK4:   CJNE A,#04H,CHK5
        MOV P0,#0F0H
        SJMP STAY

CHK5:   CJNE A,#05H,CHK6
        MOV P0,#0E0H
        SJMP STAY

CHK6:   CJNE A,#06H,CHK7
        MOV P0,#0C0H
        SJMP STAY

CHK7:   CJNE A,#07H,CHK8
        MOV P0,#80H
        SJMP STAY

CHK8:   MOV P0,#00H
        SJMP STAY

NOLED:  MOV P0,#0FFH

STAY:   SJMP STAY

        END