#include <REG51.H>

/* LCD 控制腳位 */
sbit RS = P1^0;
sbit RW = P1^1;
sbit EN = P1^2;

/* Keypad 欄 (Column) */
sbit KC0 = P2^0;
sbit KC1 = P2^1;
sbit KC2 = P2^2;
sbit KC3 = P2^3;

/* Keypad 列 (Row) */
sbit KR0 = P2^4;
sbit KR1 = P2^5;
sbit KR2 = P2^6;
sbit KR3 = P2^7;


/* 1ms 延遲 */
void Delay1ms(void)
{
    unsigned int i;
    for(i=0;i<120;i++);
}

/* 2ms 延遲 */
void Delay2ms(void)
{
    Delay1ms();
    Delay1ms();
}

/* 5ms 延遲 */
void Delay5ms(void)
{
    Delay1ms();
    Delay1ms();
    Delay1ms();
    Delay1ms();
    Delay1ms();
}

/* 約 40us 延遲 */
void Delay40us(void)
{
    unsigned char i;
    for(i=0;i<20;i++);
}


/* LCD 指令 */
void LCD_Command(unsigned char cmd)
{
    P0 = cmd;
    RS = 0;
    RW = 0;
    EN = 1;
    Delay40us();
    EN = 0;
}

/* LCD 資料 */
void LCD_Data(unsigned char dat)
{
    P0 = dat;
    RS = 1;
    RW = 0;
    EN = 1;
    Delay40us();
    EN = 0;
}


/* 判斷是否有按鍵被按 */
bit Keypad_AnyPressed(void)
{
    if(KR0==0 || KR1==0 || KR2==0 || KR3==0)
        return 1;
    else
        return 0;
}


/* 等待按鍵放開 */
void Keypad_WaitRelease(void)
{
    while(Keypad_AnyPressed());
    Delay5ms();
}


/* 掃描 Keypad */
unsigned char Keypad_Scan(void)
{
    static unsigned char keymap[4][4] =
    {
        {'1','2','3','A'},
        {'4','5','6','B'},
        {'7','8','9','C'},
        {'*','0','#','D'}
    };

    unsigned char row,col;

    KR0 = KR1 = KR2 = KR3 = 1;

    for(col=0; col<4; col++)
    {
        KC0 = KC1 = KC2 = KC3 = 1;

        switch(col)
        {
            case 0: KC0 = 0; break;
            case 1: KC1 = 0; break;
            case 2: KC2 = 0; break;
            case 3: KC3 = 0; break;
        }

        if(KR0==0){ row=0; goto pressed; }
        if(KR1==0){ row=1; goto pressed; }
        if(KR2==0){ row=2; goto pressed; }
        if(KR3==0){ row=3; goto pressed; }
    }

    return 0;

pressed:
    Delay5ms();
    Keypad_WaitRelease();
    return keymap[row][col];
}


/* 主程式 */
void main(void)
{
    unsigned char key;
    unsigned char count = 0;

    Delay5ms();

    /* LCD 初始化 */
    LCD_Command(0x3F);
    LCD_Command(0x0E);
    LCD_Command(0x01);
    Delay2ms();
    LCD_Command(0x80);

    while(1)
    {
        key = Keypad_Scan();

        if(key != 0)
        {
            if(count < 40)
            {
                LCD_Data(key);
                count++;

                /* 換到第二行 */
                if(count == 20)
                {
                    LCD_Command(0xC0);
                }
            }
        }
    }
}