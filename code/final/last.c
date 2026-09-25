#include <REG51.H> 

#include <string.h> 

 

#define uchar unsigned char 

#define uint unsigned int 

 

sbit RS = P1^0; 

sbit RW = P1^1; 

sbit EN = P1^2; 

 

sbit BZ = P1^3; 

sbit S1 = P1^4; 

 

#define MODE_XMAS 0 

#define MODE_NEWYR 1 

#define MODE_STAR 2 

 

uchar currentMode = MODE_XMAS; 

 

#define C4 0xF22A 

#define D4 0xF3C2 

#define E4 0xF536 

#define F4 0xF5FD 

#define G4 0xF729 

#define A4 0xF7D0 

#define B4 0xF8E4 

#define C5 0xF914 

#define D5 0xF9E0 

#define E5 0xFA9A 

#define F5 0xFAFE 

 

uchar code christmasTree[8] = { 

0x18,0x3C,0x7E,0x18,0x3C,0x7E,0xFF,0x18 

}; 

 

uchar code smileyFace[8] = { 

0xFF,0x81,0xA5,0x81,0xA5,0xBD,0x81,0xFF 

}; 

 

uchar code neutralFace[8] = { 

0xFF,0x81,0xA5,0x81,0x81,0xFF,0x81,0xFF 

}; 

 

uchar code star[8] = { 

0x02,0x07,0x22,0x70,0x24,0x4E,0xE4,0x40 

}; 

 

unsigned int code Song[] = { 

 

G4,C5,C5,D5,C5,B4,A4,A4,A4, 

D5,D5,E5,D5,C5,B4,G4,G4, 

E5,E5,F5,E5,D5,C5,A4, 

G4,G4,A4,D5,B4,C5, 

0,0,0,0,0, 

 

E4,E4,F4,G4,G4,F4,E4,D4, 

C4,C4,D4,E4,E4,D4,D4, 

E4,E4,F4,G4,G4,F4,E4,D4, 

C4,C4,D4,E4,D4,C4,C4, 

0,0,0,0,0, 

 

C4,C4,G4,G4,A4,A4,G4, 

F4,F4,E4,E4,D4,D4,C4, 

G4,G4,F4,F4,E4,E4,D4, 

G4,G4,F4,F4,E4,E4,D4, 

C4,C4,G4,G4,A4,A4,G4, 

F4,F4,E4,E4,D4,D4,C4 

}; 

 

uchar code Dur[] = { 

 

2,2,2,2,2,2,2,2,2, 

2,2,2,2,2,2,2,2, 

2,2,2,2,2,2,2, 

2,2,2,2,2,2, 

2,2,2,2,2, 

 

2,2,2,2,2,2,2,2, 

2,2,2,2,2,2, 

2,2,2,2,2,2,2,2, 

2,2,2,2,2, 

2,2,2,2,2, 

 

2,2,2,2,2,3, 

2,2,2,2,2,3, 

2,2,2,2,2,3, 

2,2,2,2,2,3, 

2,2,2,2,2,3, 

2,2,2,2,2,4 

}; 

 

uchar idx = 0; 

uchar tick = 0; 

bit shortRest = 0; 

 

char lcdText[24] = " Merry Christmas "; 

uchar lcdPos = 0; 

uchar lcdTick = 0; 

 

bit blinkState = 1; 

uchar blinkTick = 0; 

 

bit smileToggle = 0; 

uchar smileTick = 0; 

 

void Delay1ms(){ 

uint i; 

for(i=0;i<120;i++); 

} 

 

void delay40us(){ 

uchar i; 

for(i=0;i<20;i++); 

} 

 

void Command(uchar cmd){ 

P0 = cmd; 

RS = 0; 

RW = 0; 

EN = 1; 

delay40us(); 

EN = 0; 

} 

 

void Data(uchar dat){ 

P0 = dat; 

RS = 1; 

RW = 0; 

EN = 1; 

delay40us(); 

EN = 0; 

} 

 

void LCD_Init(){ 

Command(0x38); 

Command(0x0F); 

Command(0x06); 

Command(0x01); 

} 

 

void LCD_Scroll(){ 

uchar i; 

Command(0x80); 

for(i=0;i<16;i++){ 

Data(lcdText[(lcdPos+i)%strlen(lcdText)]); 

} 

lcdPos = (lcdPos + 1) % strlen(lcdText); 

} 

 

void switchMode(){ 

currentMode = (currentMode + 1) % 3; 

lcdPos = 0; 

 

tick = 0; 

shortRest = 0; 

smileTick = 0; 

smileToggle = 0; 

 

if(currentMode == MODE_XMAS){ 

idx = 0; 

strcpy(lcdText," Merry Christmas "); 

} 

else if(currentMode == MODE_NEWYR){ 

idx = 36; 

strcpy(lcdText," Happy New Year "); 

} 

else{ 

idx = 71; 

strcpy(lcdText," Twinkle Star "); 

} 

 

TH0 = Song[idx] >> 8; 

TL0 = Song[idx]; 

} 

 

void checkButton(){ 

static bit last = 1; 

 

if(S1 == 0 && last == 1){ 

Delay1ms(); 

Delay1ms(); 

 

if(S1 == 0){ 

switchMode(); 

} 

} 

 

last = S1; 

} 

 

void Timer0_ISR(void) interrupt 1{ 

 

if(Song[idx] == 0 || shortRest){ 

BZ = 0; 

} 

else{ 

BZ = ~BZ; 

} 

 

TH0 = Song[idx] >> 8; 

TL0 = Song[idx]; 

} 

 

void Timer1_ISR(void) interrupt 3{ 

 

tick++; 

lcdTick++; 

blinkTick++; 

 

if(blinkTick >= 6){ 

blinkTick = 0; 

blinkState = !blinkState; 

} 

 

if(currentMode == MODE_NEWYR){ 

smileTick++; 

if(smileTick >= 12){ 

smileTick = 0; 

smileToggle = !smileToggle; 

} 

} 

 

if(lcdTick >= 10){ 

lcdTick = 0; 

LCD_Scroll(); 

} 

 

if(!shortRest && tick >= Dur[idx]*2){ 

shortRest = 1; 

tick = 0; 

return; 

} 

 

if(shortRest && tick >= 1){ 

shortRest = 0; 

tick = 0; 

idx++; 

 

if(currentMode == MODE_XMAS && idx > 35) idx = 0; 

if(currentMode == MODE_NEWYR && idx > 70) idx = 36; 

if(currentMode == MODE_STAR && idx > 112) idx = 71; 

 

TH0 = Song[idx] >> 8; 

TL0 = Song[idx]; 

} 

} 

 

void displayPattern(){ 

uchar r,p; 

 

for(r=0;r<8;r++){ 

 

P3 = ~(1<<r); 

 

if(blinkState == 0 && currentMode != MODE_NEWYR){ 

p = 0xFF; 

} 

else{ 

if(currentMode == MODE_XMAS) 

p = christmasTree[r]; 

else if(currentMode == MODE_NEWYR) 

p = smileToggle ? smileyFace[r] : neutralFace[r]; 

else 

p = star[r]; 

} 

 

P2 = ~p; 

 

Delay1ms(); 

 

P3 = 0xFF; 

} 

} 

 

void main(){ 

 

P0 = P1 = P2 = P3 = 0xFF; 

 

LCD_Init(); 

 

TMOD = 0x11; 

 

TH0 = Song[0] >> 8; 

TL0 = Song[0]; 

 

TH1 = 0x3C; 

TL1 = 0xB0; 

 

ET0 = 1; 

ET1 = 1; 

EA = 1; 

 

TR0 = 1; 

TR1 = 1; 

 

while(1){ 

displayPattern(); 

checkButton(); 

} 

} 

 