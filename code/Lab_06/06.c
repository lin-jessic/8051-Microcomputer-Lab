#include <REG51.H>

sbit BZ = P0^0;   // 蜂鳴器接在 P0.0

#define DO 0xF22A
#define RE 0xF3C2
#define MI 0xF536
#define FA 0xF5FD
#define SO 0xF729
#define LA 0xF7D0

/* 音階 */
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
    2,2,2,3,
    3,2,2,2,
    2,2,2,3,
    2,2,3,

    2,2,2,3,
    3,2,2,2,
    2,2,2,3,
    2,3,4
};

/* 延遲 */
void Delay_ms(unsigned int t)
{
    unsigned int i,j;
    for(i=0;i<t;i++)
        for(j=0;j<120;j++);
}

/* 播放音符 */
void Play(unsigned int p)
{
    unsigned int i;

    for(i=0;i<200;i++)
    {
        TH0 = (p >> 8);
        TL0 = (p & 0xFF);

        TF0 = 0;
        TR0 = 1;

        while(TF0 == 0);

        TR0 = 0;
        BZ = ~BZ;
    }
}

void main(void)
{
    unsigned char i;

    TMOD = 0x01;   // Timer0 Mode1 (16bit)

    while(1)
    {
        for(i=0;i<sizeof(Song)/sizeof(Song[0]);i++)
        {
            Play(Song[i]);
            BZ = 0;
            Delay_ms(50 * Dur[i]);
        }

        Delay_ms(400);
    }
}