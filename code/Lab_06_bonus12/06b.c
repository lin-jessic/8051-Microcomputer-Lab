#include <REG51.H>

sbit BZ = P0^0;     // 蜂鳴器接 P0.0

/* 音階 */
#define DO 0xF22A
#define RE 0xF3C2
#define MI 0xF536
#define FA 0xF5FD
#define SO 0xF729
#define LA 0xF7D0

/* 歌曲 */
unsigned int code Song[] = {
    MI,MI,FA,SO,
    SO,FA,MI,RE,
    DO,DO,RE,MI,
    MI,RE,RE,

    MI,MI,FA,SO,
    SO,FA,MI,RE,
    DO,DO,RE,MI,
    RE,DO,DO
};

/* 節拍 */
unsigned char code Dur[] = {
    2,2,2,2,
    2,2,2,2,
    2,2,2,2,
    2,2,4,

    2,2,2,2,
    2,2,2,2,
    2,2,2,2,
    2,3,4
};

/* 全域變數 */
unsigned char idx = 0;
unsigned char tick = 0;
bit shortRest = 0;
bit longRest  = 0;


/* Timer0 中斷：產生音波 */
void Timer0_ISR(void) interrupt 1
{
    if(!shortRest && !longRest)
        BZ = ~BZ;

    TH0 = Song[idx] >> 8;
    TL0 = Song[idx] & 0xFF;
}


/* Timer1 中斷：控制節拍 */
void Timer1_ISR(void) interrupt 3
{
    tick++;

    /* 音符結束 → 短休止 */
    if(!shortRest && !longRest && tick >= Dur[idx] * 2)
    {
        shortRest = 1;
        tick = 0;
        BZ = 0;
        return;
    }

    /* 短休止結束 */
    if(shortRest && tick >= 1)
    {
        shortRest = 0;
        tick = 0;
        idx++;

        /* 小節長休止 */
        if(idx==4 || idx==8 || idx==12 || idx==15 ||
           idx==19 || idx==23 || idx==27 || idx==30)
        {
            longRest = 1;
            BZ = 0;
            return;
        }

        /* 歌曲結束 */
        if(idx >= sizeof(Song)/sizeof(Song[0]))
        {
            TR0 = 0;
            TR1 = 0;
            ET0 = 0;
            ET1 = 0;
            BZ = 0;
            return;
        }

        TH0 = Song[idx] >> 8;
        TL0 = Song[idx] & 0xFF;
        return;
    }

    /* 長休止結束 */
    if(longRest && tick >= 6)
    {
        longRest = 0;
        tick = 0;

        if(idx >= sizeof(Song)/sizeof(Song[0]))
        {
            TR0 = 0;
            TR1 = 0;
            ET0 = 0;
            ET1 = 0;
            BZ = 0;
            return;
        }

        TH0 = Song[idx] >> 8;
        TL0 = Song[idx] & 0xFF;
    }
}


/* 主程式 */
void main(void)
{
    TMOD = 0x11;      // Timer0、Timer1 都為 Mode1 (16bit)

    /* Timer0 初始值 */
    TH0 = Song[0] >> 8;
    TL0 = Song[0] & 0xFF;

    /* Timer1 約 50ms */
    TH1 = 0x3C;
    TL1 = 0xB0;

    /* 開中斷 */
    ET0 = 1;
    ET1 = 1;
    EA  = 1;

    /* 啟動 Timer */
    TR0 = 1;
    TR1 = 1;

    while(1);
}