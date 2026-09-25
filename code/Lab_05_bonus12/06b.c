#include <REG51.H>

/* LCD 北竲 */
sbit RS = P1^0;
sbit RW = P1^1;
sbit EN = P1^2;

/* Keypad Column */
sbit KC0 = P2^0;
sbit KC1 = P2^1;
sbit KC2 = P2^2;
sbit KC3 = P2^3;

/* Keypad Row */
sbit KR0 = P2^4;
sbit KR1 = P2^5;
sbit KR2 = P2^6;
sbit KR3 = P2^7;

/* LCD ず甧 */
unsigned char line1[20];
unsigned char line2[20];
unsigned char cursor_pos = 0;


/*------------------ ┑筐 ------------------*/

void Delay1ms(void)
{
    unsigned int i;
    for(i=0;i<120;i++);
}

void Delay2ms(void)
{
    Delay1ms();
    Delay1ms();
}

void Delay5ms(void)
{
    Delay1ms();
    Delay1ms();
    Delay1ms();
    Delay1ms();
    Delay1ms();
}

void Delay40us(void)
{
    unsigned char i;
    for(i=0;i<20;i++);
}


/*------------------ LCD ------------------*/

void LCD_Command(unsigned char cmd)
{
    P0 = cmd;
    RS = 0;
    RW = 0;
    EN = 1;
    Delay40us();
    EN = 0;
}

void LCD_Data(unsigned char dat)
{
    P0 = dat;
    RS = 1;
    RW = 0;
    EN = 1;
    Delay40us();
    EN = 0;
}

/* 礶 LCD */
void LCD_Redraw(void)
{
    unsigned char i;

    LCD_Command(0x80);
    for(i=0;i<20;i++)
        LCD_Data(line1[i]);

    LCD_Command(0xC0);
    for(i=0;i<20;i++)
        LCD_Data(line2[i]);
}


/*------------------ Keypad ------------------*/

bit Keypad_AnyPressed(void)
{
    if(KR0==0 || KR1==0 || KR2==0 || KR3==0)
        return 1;
    else
        return 0;
}

void Keypad_WaitRelease(void)
{
    while(Keypad_AnyPressed());
    Delay5ms();
}

/* Keypad 苯磞 */
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


/*------------------  ------------------*/

/* Scroll */
void Scroll(void)
{
    unsigned char i;

    for(i=0;i<20;i++)
        line1[i] = line2[i];

    for(i=0;i<20;i++)
        line2[i] = ' ';

    cursor_pos = 20;

    LCD_Redraw();
    LCD_Command(0xC0);
}


/* Backspace */
void Handle_Backspace(void)
{
    if(cursor_pos==0) return;

    cursor_pos--;

    if(cursor_pos<20)
        line1[cursor_pos] = ' ';
    else
        line2[cursor_pos-20] = ' ';

    LCD_Redraw();

    if(cursor_pos<20)
        LCD_Command(0x80 + cursor_pos);
    else
        LCD_Command(0xC0 + (cursor_pos-20));
}


/* 睲埃场 */
void Handle_ClearAll(void)
{
    unsigned char i;

    for(i=0;i<20;i++)
    {
        line1[i] = ' ';
        line2[i] = ' ';
    }

    cursor_pos = 0;

    LCD_Command(0x01);
    Delay2ms();
    LCD_Command(0x80);
}


/* 村夹北 */
void Move_Cursor_Left(void)
{
    if(cursor_pos>0) cursor_pos--;

    if(cursor_pos<20)
        LCD_Command(0x80 + cursor_pos);
    else
        LCD_Command(0xC0 + (cursor_pos-20));
}

void Move_Cursor_Right(void)
{
    if(cursor_pos<39) cursor_pos++;

    if(cursor_pos<20)
        LCD_Command(0x80 + cursor_pos);
    else
        LCD_Command(0xC0 + (cursor_pos-20));
}

void Move_Cursor_Up(void)
{
    if(cursor_pos>=20)
        cursor_pos -= 20;

    LCD_Command(0x80 + cursor_pos);
}

void Move_Cursor_Down(void)
{
    if(cursor_pos<20)
        cursor_pos += 20;

    LCD_Command(0xC0 + (cursor_pos-20));
}


/*------------------ 祘Α ------------------*/

void main(void)
{
    unsigned char key;
    unsigned char i;

    /* ﹍てゅ */
    for(i=0;i<20;i++)
    {
        line1[i] = ' ';
        line2[i] = ' ';
    }

    cursor_pos = 0;

    Delay5ms();

    /* LCD ﹍て */
    LCD_Command(0x38);
    LCD_Command(0x0E);
    LCD_Command(0x06);
    LCD_Command(0x01);

    Delay2ms();

    LCD_Command(0x80);

    while(1)
    {
        key = Keypad_Scan();

        if(key != 0)
        {
            if(key=='*'){ Handle_Backspace(); continue; }
            if(key=='0'){ Handle_ClearAll(); continue; }
            if(key=='#'){ Scroll(); continue; }

            if(key=='A'){ Move_Cursor_Left(); continue; }
            if(key=='B'){ Move_Cursor_Right(); continue; }
            if(key=='C'){ Move_Cursor_Up(); continue; }
            if(key=='D'){ Move_Cursor_Down(); continue; }

            if(cursor_pos==20)
                LCD_Command(0xC0);
            else if(cursor_pos==40)
                Scroll();

            if(cursor_pos<20)
            {
                line1[cursor_pos] = key;
                LCD_Data(key);
                cursor_pos++;
            }
            else
            {
                line2[cursor_pos-20] = key;
                LCD_Data(key);
                cursor_pos++;
            }
        }
    }
}