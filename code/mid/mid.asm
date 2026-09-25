        LJMP    MAIN 

 

MAIN: 

        MOV     SP, #60H 

        ACALL   INIT_GAME 

 

GAME_LOOP: 

        JB      P3.1, NO_RESET 

        ACALL   INIT_GAME 

        SJMP    WAIT_RESET_RELEASE 

 

WAIT_RESET_RELEASE: 

        JNB     P3.1, WAIT_RESET_RELEASE 

        SJMP    GAME_LOOP 

 

NO_RESET: 

        MOV     A, 47H 

        CJNE    A, #0, GAME_OVER_BLINK 

 

        ACALL   DISPLAY_ALL 

        ACALL   CHECK_KEY 

        ACALL   DELAY_5MS 

 

        INC     4AH 

        MOV     A, 4AH 

        JNZ     CHECK_SPEED 

        INC     4BH 

 

CHECK_SPEED: 

        MOV     A, 4BH 

        CJNE    A, 49H, CHECK_SPEED_L 

        SJMP    CHECK_SPEED_EQUAL_H 

 

CHECK_SPEED_L: 

        JC      GAME_LOOP 

        SJMP    DO_MOVE 

 

CHECK_SPEED_EQUAL_H: 

        MOV     A, 4AH 

        CJNE    A, 48H, CHECK_SPEED_L2 

        SJMP    DO_MOVE 

 

CHECK_SPEED_L2: 

        JC      GAME_LOOP 

 

DO_MOVE: 

        MOV     4AH, #0 

        MOV     4BH, #0 

 

        MOV     A, 45H 

        MOV     43H, A 

        MOV     A, 46H 

        MOV     44H, A 

 

        ACALL   MOVE_SNAKE 

        LJMP    GAME_LOOP 

 

GAME_OVER_BLINK: 

        JNB     P3.1, RESET_FROM_GAME_OVER 

 

        MOV     P0, #00H 

        MOV     P1, #00H 

        ACALL   DELAY_LONG 

        MOV     P0, #0FFH 

        MOV     P1, #0FFH 

        ACALL   DELAY_LONG 

        SJMP    GAME_OVER_BLINK 

 

RESET_FROM_GAME_OVER: 

        ACALL   INIT_GAME 

 

WAIT_RESET_GO: 

        JNB     P3.1, WAIT_RESET_GO 

        LJMP    GAME_LOOP 

 

INIT_GAME: 

        MOV     P0, #0FFH 

        MOV     P1, #0FFH 

        MOV     P3, #0FFH 

 

        MOV     TMOD, #01H 

        MOV     TH0, #0 

        MOV     TL0, #0 

        SETB    TR0 

 

        MOV     50H, #2 

        MOV     70H, #3 

        MOV     51H, #1 

        MOV     71H, #3 

        MOV     52H, #0 

        MOV     72H, #3 

 

        MOV     42H, #3 

        MOV     43H, #1 

        MOV     44H, #0 

        MOV     45H, #1 

        MOV     46H, #0 

        MOV     47H, #0 

        MOV     48H, #200 

        MOV     49H, #0 

        MOV     4AH, #0 

        MOV     4BH, #0 

 

        ACALL   NEW_FOOD 

        RET 

 

DISPLAY_ALL: 

        MOV     4CH, #0 

 

DISPLAY_SNAKE: 

        MOV     A, 4CH 

        CJNE    A, 42H, DISPLAY_SNAKE_DO 

        SJMP    DISPLAY_FOOD_PART 

 

DISPLAY_SNAKE_DO: 

        MOV     A, 4CH 

        ADD     A, #50H 

        MOV     R0, A 

        MOV     A, @R0 

        MOV     R4, A 

 

        MOV     A, 4CH 

        ADD     A, #70H 

        MOV     R0, A 

        MOV     A, @R0 

        MOV     R5, A 

 

        ACALL   DISPLAY_DOT 

 

        INC     4CH 

        SJMP    DISPLAY_SNAKE 

 

DISPLAY_FOOD_PART: 

        MOV     R4, 40H 

        MOV     R5, 41H 

        ACALL   DISPLAY_DOT 

 

        ACALL   DISPLAY_BLOCKS 

        RET 

 

DISPLAY_DOT: 

        MOV     A, #1 

        MOV     R6, R4 

 

DOT_X: 

        CJNE    R6, #0, DOT_X_DO 

        SJMP    DOT_X_END 

 

DOT_X_DO: 

        RL      A 

        DEC     R6 

        SJMP    DOT_X 

 

DOT_X_END: 

        CPL     A 

        MOV     P0, A 

 

        MOV     A, #1 

        MOV     R6, R5 

 

DOT_Y: 

        CJNE    R6, #0, DOT_Y_DO 

        SJMP    DOT_Y_END 

 

DOT_Y_DO: 

        RL      A 

        DEC     R6 

        SJMP    DOT_Y 

 

DOT_Y_END: 

        CPL     A 

        MOV     P1, A 

 

        MOV     R6, #50 

 

DOT_DLY: 

        DJNZ    R6, DOT_DLY 

 

        MOV     P0, #0FFH 

        MOV     P1, #0FFH 

        RET 

 

DISPLAY_BLOCKS: 

        MOV     DPTR, #BLOCK_DATA 

        MOV     4CH, #0 

 

DISP_BLOCK_LOOP: 

        MOV     A, 4CH 

        CJNE    A, #3, DISP_BLOCK_DO 

        RET 

 

DISP_BLOCK_DO: 

        MOV     A, 4CH 

        MOVC    A, @A+DPTR 

        MOV     R4, A 

 

        MOV     A, 4CH 

        ADD     A, #3 

        MOVC    A, @A+DPTR 

        MOV     R5, A 

 

        ACALL   DISPLAY_DOT 

 

        MOV     A, R4 

        CJNE    A, #7, DISP_RIGHT 

        SJMP    DISP_BLOCK_NEXT 

 

DISP_RIGHT: 

        JNC     DISP_BLOCK_NEXT 

        INC     R4 

        ACALL   DISPLAY_DOT 

 

DISP_BLOCK_NEXT: 

        INC     4CH 

        SJMP    DISP_BLOCK_LOOP 

 

CHECK_KEY: 

        JB      P3.4, CHK_DOWN 

        MOV     A, 44H 

        CJNE    A, #0, CHK_DOWN 

        MOV     45H, #0 

        MOV     46H, #0FFH 

 

CHK_DOWN: 

        JB      P3.5, CHK_LEFT 

        MOV     A, 44H 

        CJNE    A, #0, CHK_LEFT 

        MOV     45H, #0 

        MOV     46H, #1 

 

CHK_LEFT: 

        JB      P3.6, CHK_RIGHT 

        MOV     A, 43H 

        CJNE    A, #0, CHK_RIGHT 

        MOV     45H, #0FFH 

        MOV     46H, #0 

 

CHK_RIGHT: 

        JB      P3.7, CHK_SPEEDUP 

        MOV     A, 43H 

        CJNE    A, #0, CHK_SPEEDUP 

        MOV     45H, #1 

        MOV     46H, #0 

 

CHK_SPEEDUP: 

        JB      P3.2, CHK_SPEEDDOWN 

        MOV     A, 49H 

        JNZ     SPEED_OK_DEC 

        MOV     A, 48H 

        CJNE    A, #100, CHK_SPEED_L1 

        SJMP    CHK_SPEEDDOWN 

 

CHK_SPEED_L1: 

        JC      CHK_SPEEDDOWN 

 

SPEED_OK_DEC: 

        MOV     A, 48H 

        CLR     C 

        SUBB    A, #20 

        MOV     48H, A 

        MOV     A, 49H 

        SUBB    A, #0 

        MOV     49H, A 

 

WAIT_SPEEDUP: 

        JNB     P3.2, WAIT_SPEEDUP 

 

CHK_SPEEDDOWN: 

        JB      P3.3, CHK_KEY_END 

        MOV     A, 49H 

        CJNE    A, #1, CHK_SPEED_H 

        SJMP    CHK_KEY_END 

 

CHK_SPEED_H: 

        JC      SPEED_OK_INC 

        MOV     A, 48H 

        CJNE    A, #144, CHK_SPEED_L2 

        SJMP    CHK_KEY_END 

 

CHK_SPEED_L2: 

        JNC     CHK_KEY_END 

 

SPEED_OK_INC: 

        MOV     A, 48H 

        ADD     A, #20 

        MOV     48H, A 

        MOV     A, 49H 

        ADDC    A, #0 

        MOV     49H, A 

 

WAIT_SPEEDDOWN: 

        JNB     P3.3, WAIT_SPEEDDOWN 

 

CHK_KEY_END: 

        RET 

 

MOVE_SNAKE: 

        MOV     A, 50H 

        ADD     A, 43H 

        MOV     4DH, A 

 

        MOV     A, 70H 

        ADD     A, 44H 

        MOV     4EH, A 

 

        MOV     A, 4DH 

        CJNE    A, #8, CHK_WALL_X 

        SJMP    COLLISION 

 

CHK_WALL_X: 

        JNC     COLLISION 

 

        MOV     A, 4EH 

        CJNE    A, #8, CHK_WALL_Y 

        SJMP    COLLISION 

 

CHK_WALL_Y: 

        JNC     COLLISION 

 

        MOV     4CH, #0 

 

CHK_SELF: 

        MOV     A, 4CH 

        CJNE    A, 42H, CHK_SELF_DO 

        SJMP    CHK_BLOCKS 

 

CHK_SELF_DO: 

        MOV     A, 4CH 

        ADD     A, #50H 

        MOV     R0, A 

        MOV     A, @R0 

        MOV     4FH, A 

 

        MOV     A, 4DH 

        CJNE    A, 4FH, CHK_SELF_NEXT 

 

        MOV     A, 4CH 

        ADD     A, #70H 

        MOV     R0, A 

        MOV     A, @R0 

        MOV     4FH, A 

 

        MOV     A, 4EH 

        CJNE    A, 4FH, CHK_SELF_NEXT 

 

        SJMP    COLLISION 

 

CHK_SELF_NEXT: 

        INC     4CH 

        SJMP    CHK_SELF 

 

CHK_BLOCKS: 

        MOV     DPTR, #BLOCK_DATA 

        MOV     4CH, #0 

 

CHK_BLOCK_LOOP: 

        MOV     A, 4CH 

        CJNE    A, #3, CHK_BLOCK_DO 

        SJMP    NO_COLLISION 

 

CHK_BLOCK_DO: 

        MOV     A, 4CH 

        MOVC    A, @A+DPTR 

        MOV     4FH, A 

 

        MOV     A, 4DH 

        CJNE    A, 4FH, CHK_BLOCK_NEXT 

 

        MOV     A, 4CH 

        ADD     A, #3 

        MOVC    A, @A+DPTR 

        MOV     4FH, A 

 

        MOV     A, 4EH 

        CJNE    A, 4FH, CHK_BLOCK_NEXT 

 

        SJMP    COLLISION 

 

CHK_BLOCK_NEXT: 

        INC     4CH 

        SJMP    CHK_BLOCK_LOOP 

 

COLLISION: 

        MOV     47H, #1 

        RET 

 

NO_COLLISION: 

        MOV     A, 4DH 

        CJNE    A, 40H, NO_FOOD 

        MOV     A, 4EH 

        CJNE    A, 41H, NO_FOOD 

 

        INC     42H 

 

        MOV     A, 42H 

        DEC     A 

        MOV     4CH, A 

 

COPY_GROW: 

        MOV     A, 4CH 

        CJNE    A, #0, COPY_GROW_DO 

        SJMP    SET_NEW_HEAD 

 

COPY_GROW_DO: 

        MOV     A, 4CH 

        DEC     A 

        ADD     A, #50H 

        MOV     R0, A 

        MOV     A, @R0 

        MOV     4FH, A 

 

        MOV     A, 4CH 

        ADD     A, #50H 

        MOV     R0, A 

        MOV     A, 4FH 

        MOV     @R0, A 

 

        MOV     A, 4CH 

        DEC     A 

        ADD     A, #70H 

        MOV     R0, A 

        MOV     A, @R0 

        MOV     4FH, A 

 

        MOV     A, 4CH 

        ADD     A, #70H 

        MOV     R0, A 

        MOV     A, 4FH 

        MOV     @R0, A 

 

        DEC     4CH 

        SJMP    COPY_GROW 

 

NO_FOOD: 

        MOV     A, 42H 

        DEC     A 

        MOV     4CH, A 

 

COPY_NORMAL: 

        MOV     A, 4CH 

        CJNE    A, #0, COPY_NORMAL_DO 

        SJMP    SET_NEW_HEAD 

 

COPY_NORMAL_DO: 

        MOV     A, 4CH 

        DEC     A 

        ADD     A, #50H 

        MOV     R0, A 

        MOV     A, @R0 

        MOV     4FH, A 

 

        MOV     A, 4CH 

        ADD     A, #50H 

        MOV     R0, A 

        MOV     A, 4FH 

        MOV     @R0, A 

 

        MOV     A, 4CH 

        DEC     A 

        ADD     A, #70H 

        MOV     R0, A 

        MOV     A, @R0 

        MOV     4FH, A 

 

        MOV     A, 4CH 

        ADD     A, #70H 

        MOV     R0, A 

        MOV     A, 4FH 

        MOV     @R0, A 

 

        DEC     4CH 

        SJMP    COPY_NORMAL 

 

SET_NEW_HEAD: 

        MOV     A, 4DH 

        MOV     50H, A 

 

        MOV     A, 4EH 

        MOV     70H, A 

 

        MOV     A, 4DH 

        CJNE    A, 40H, MOVE_END 

        MOV     A, 4EH 

        CJNE    A, 41H, MOVE_END 

        ACALL   NEW_FOOD 

 

MOVE_END: 

        RET 

 

NEW_FOOD: 

NEW_FOOD_TRY: 

        MOV     A, TH0 

        ADD     A, TL0 

        ANL     A, #07H 

        MOV     40H, A 

 

        MOV     A, TH0 

        ADD     A, TL0 

        RR      A 

        RR      A 

        RR      A 

        ANL     A, #07H 

        MOV     41H, A 

 

        MOV     4CH, #0 

 

CHK_FOOD_SNAKE: 

        MOV     A, 4CH 

        CJNE    A, 42H, CHK_FOOD_SNAKE_DO 

        SJMP    CHK_FOOD_BLOCKS 

 

CHK_FOOD_SNAKE_DO: 

        MOV     A, 4CH 

        ADD     A, #50H 

        MOV     R0, A 

        MOV     A, @R0 

        MOV     4FH, A 

 

        MOV     A, 40H 

        CJNE    A, 4FH, CHK_FOOD_SNAKE_NEXT 

 

        MOV     A, 4CH 

        ADD     A, #70H 

        MOV     R0, A 

        MOV     A, @R0 

        MOV     4FH, A 

 

        MOV     A, 41H 

        CJNE    A, 4FH, CHK_FOOD_SNAKE_NEXT 

 

        SJMP    NEW_FOOD_TRY 

 

CHK_FOOD_SNAKE_NEXT: 

        INC     4CH 

        SJMP    CHK_FOOD_SNAKE 

 

CHK_FOOD_BLOCKS: 

        MOV     DPTR, #BLOCK_DATA 

        MOV     4CH, #0 

 

CHK_FOOD_BLOCK_LOOP: 

        MOV     A, 4CH 

        CJNE    A, #3, CHK_FOOD_BLOCK_DO 

        RET 

 

CHK_FOOD_BLOCK_DO: 

        MOV     A, 4CH 

        MOVC    A, @A+DPTR 

        MOV     4FH, A 

 

        MOV     A, 40H 

        CJNE    A, 4FH, CHK_FOOD_BLOCK_NEXT 

 

        MOV     A, 4CH 

        ADD     A, #3 

        MOVC    A, @A+DPTR 

        MOV     4FH, A 

 

        MOV     A, 41H 

        CJNE    A, 4FH, CHK_FOOD_BLOCK_NEXT 

 

        SJMP    NEW_FOOD_TRY 

 

CHK_FOOD_BLOCK_NEXT: 

        INC     4CH 

        SJMP    CHK_FOOD_BLOCK_LOOP 

 

DELAY_5MS: 

        MOV     R3, #50 

D5_1:   MOV     R4, #100 

D5_2:   DJNZ    R4, D5_2 

        DJNZ    R3, D5_1 

        RET 

 

DELAY_LONG: 

        MOV     R2, #60 

DL:     ACALL   DELAY_5MS 

        DJNZ    R2, DL 

        RET 

 

BLOCK_DATA: 

        DB      2, 5, 6 

        DB      2, 4, 6 

 

        END 