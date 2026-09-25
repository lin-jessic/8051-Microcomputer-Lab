# 8051 Microcomputer Lab

長庚大學資訊工程學系「微算機實驗」課程實作紀錄。

本課程以 8051 微控制器為核心，前半學期使用組合語言進行暫存器、I/O Port、Timer 與 Interrupt 等基礎實作；後半學期改以 Embedded C 進行 LCD、Keypad、蜂鳴器等周邊控制，並於期中與期末整合多項功能完成較完整的系統實作。

**Course:** 微算機實驗  
**Institution:** 長庚大學 資訊工程學系  
**Instructor:** 張哲維教授   
**Languages:** 8051 Assembly (A51) / Embedded C (C51)

---

## Repository Structure

```text
8051-Microcomputer-Lab/
│
├── code/
│   ├── Lab_01/
│   ├── Lab_02/
│   ├── Lab_03/
│   ├── Lab_04/
│   ├── Midterm/
│   ├── Lab_05/
│   ├── Lab_06/
│   ├── Mid/
│   └── Final/
│
├── reports/
│   ├── Lab_01.pdf
│   ├── Lab_02.pdf
│   ├── Lab_03.pdf
│   ├── Lab_04.pdf
│   ├── Midterm.pdf
│   ├── Lab_05.pdf
│   ├── Lab_06.pdf
│   ├── Mid.pdf
│   └── Term.pdf
│
└── README.md
```

`code/` 保存各次實驗、期中與期末實作的原始程式；`reports/` 則整理對應的實驗報告。

---

## Lab Overview

| 實作 | 語言 | 主題 | 主要內容 |
| --- | --- | --- | --- |
| **Lab 01** | Assembly | Vector Dot Product | 向量內積、Register Indirect Addressing、`MUL`、`DJNZ` |
| **Lab 02** | Assembly | LED Shift | 按鍵觸發 LED 位移、`RL` / `RR`、Software Delay、Port Polling |
| **Lab 03** | Assembly | Timer0 Interrupt | 使用 Timer0 Interrupt 控制 LED Rotation、Interrupt Vector 與 Timer Reload |
| **Lab 04** | Assembly | Button-Controlled LED | 按鍵控制 LED 雙向移動、Debounce、`CPL` 與 Context Save |
| **Midterm** | Assembly | Snake Game | 於 8×8 LED Matrix 實作貪食蛇遊戲，包含移動、碰撞判斷與速度控制 |
| **Lab 05** | Embedded C | Keypad & LCD | 4×4 Matrix Keypad 掃描與 16×2 LCD 顯示控制 |
| **Lab 05 Bonus** | Embedded C | LCD Calculator | 以 Keypad 與 LCD 實作基本計算機功能 |
| **Lab 06** | Embedded C | Buzzer Music | 使用 Timer0 控制蜂鳴器頻率，以音符與時間陣列完成音樂播放 |
| **Lab 06 Bonus** | Embedded C | Interrupt Music | 將音樂播放改以 Timer0 ISR 控制，降低 Blocking 操作 |
| **Final** | Embedded C | Multi-mode Music Player | 整合多首歌曲、LCD 顯示、自訂字元與模式切換功能 |

---

## Assembly Programming

Lab 01 至 Lab 04 與期中專題主要使用 8051 Assembly 完成。

這一階段從基本的資料運算與記憶體定址開始，逐步加入 I/O Port、Timer 與 Interrupt，直接操作 8051 暫存器與硬體資源。

主要實作內容包含：

- Register 與 Register Indirect Addressing
- Arithmetic / Logic Instructions
- GPIO Port Control
- Software Delay
- Timer0
- Interrupt Service Routine
- PUSH / POP Context Save
- Button Input 與 Debounce
- LED / LED Matrix Control

### Midterm — Snake Game

期中實作將前半學期的 Assembly Programming 與硬體控制整合，在 **8×8 LED Matrix** 上完成貪食蛇遊戲。

除了 LED Matrix 顯示之外，也需要處理遊戲狀態、移動方向、碰撞判斷與速度變化，使原本分散於各次 Lab 的底層控制概念整合成一個完整程式。

---

## Embedded C

Lab 05、Lab 06 與期末專題改以 Embedded C（C51）進行。

相較於前半學期直接使用 Assembly 操作暫存器，這一階段開始以 C 語言整理硬體控制流程，並實作 LCD、Matrix Keypad 與 Buzzer 等周邊功能。

主要實作內容包含：

- 8051 Embedded C
- `sbit` / `sfr` Hardware Mapping
- 4×4 Matrix Keypad Scanning
- 16×2 LCD Control
- Timer-based Tone Generation
- Timer Interrupt
- Button / Mode Control
- Peripheral Integration

### Final — Multi-mode Music Player

期末實作整合 LCD、Buzzer、Timer 與輸入控制，完成具有多種操作模式的音樂播放器。

系統可切換不同歌曲，並利用 LCD 顯示目前狀態與自訂字元，將後半學期各次實驗中的周邊控制功能整合至同一個 Embedded C 專案中。

---

## What I Learned

這門課是我實際接觸微控制器與底層硬體控制的重要實作課程。

從前半學期使用 Assembly 直接操作 8051 暫存器、Port、Timer 與 Interrupt，到後半學期改以 Embedded C 控制 LCD、Keypad 與 Buzzer，我逐步理解程式執行與硬體行為之間的關係。

期中與期末實作也讓我第一次將多個周邊與控制流程整合成較完整的系統，而不只是完成單一功能。這些經驗後續也成為我進行嵌入式系統、感測器整合與軟硬體系統實作時的基礎。

---

## Contents

完整程式與實驗紀錄請參考：

- [`code/`](./code/) — 各次 Lab、Midterm 與 Final 原始程式
- [`reports/`](./reports/) — 各次實驗與專題報告

---

> 本 Repository 為大學課程學習成果整理，內容以當時完成之程式與實驗報告為主。
