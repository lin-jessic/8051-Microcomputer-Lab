        ORG 0000H

        MOV R0,#20H
        MOV R1,#28H
        MOV R2,#08H
        MOV A,#01H

I0:     MOV @R0,A
        MOV @R1,A
        INC R0
        INC R1
        DJNZ R2,I0

        MOV R0,#20H
        MOV R1,#28H
        MOV R2,#08H
        MOV R3,#00H

L0:     MOV A,@R0
        MOV B,@R1
        MUL AB
        ADD A,R3
        MOV R3,A
        INC R0
        INC R1
        DJNZ R2,L0

WAIT:   SJMP WAIT

        END