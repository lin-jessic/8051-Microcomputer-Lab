# 8051 微算機實驗

本 Repository 整理長庚大學資訊工程學系「微算機實驗」課程中的程式實作與實驗報告。

課程前半段以 **8051 Assembly** 為主，從組合語言與微控制器基礎操作開始進行實作；後半段則轉為 **Embedded C**，進一步以 C 語言完成微控制器相關實驗。期中實作延續組合語言階段的內容，期末實作則以 C 語言完成。

- **課程：** 微算機實驗
- **授課教師：** 張哲維教授
- **學校：** 長庚大學 資訊工程學系
- **程式語言：** 8051 Assembly、Embedded C

---

## Repository Structure

```text
8051-Microcomputer-Lab/
│
├── code/                   # 各次實驗與專題原始程式
│   ├── Lab_01/
│   ├── Lab_02/
│   ├── Lab_03/
│   ├── Lab_04/
│   ├── Midterm/
│   ├── Lab_05/
│   ├── Lab_06/
│   ├── ...
│   └── Final/
│
├── reports/                # 各次實驗與專題報告
│   ├── Lab_01.pdf
│   ├── Lab_02.pdf
│   ├── ...
│   └── Final.pdf
│
└── README.md
```

`code/` 保存課程期間各次實驗與專題的程式碼；`reports/` 則整理相對應的實驗報告與結果紀錄。

---

## Course Progression

### Assembly Language

課程前半段以 8051 組合語言進行實作，直接操作微控制器暫存器、記憶體與 I/O，從較底層的方式理解程式執行與硬體控制之間的關係。

包含：

- Lab 01
- Lab 02
- Lab 03
- Lab 04
- Midterm Project

**Language:** 8051 Assembly

### Embedded C

課程後半段改以 C 語言進行 8051 程式開發，在前半學期建立的微控制器基礎上，以較高階的程式結構完成後續實驗與系統功能。

包含：

- Lab 05
- Lab 06
- Final Project

**Language:** Embedded C

---

## Lab Overview

| 實驗 / 專題 | 語言 | 說明 |
| --- | --- | --- |
| Lab 01 | Assembly | 8051 組合語言實作 |
| Lab 02 | Assembly | 8051 組合語言實作 |
| Lab 03 | Assembly | 8051 組合語言實作 |
| Lab 04 | Assembly | 8051 組合語言實作 |
| Midterm | Assembly | 期中整合實作 |
| Lab 05 | Embedded C | 8051 C 語言實作 |
| Lab 06 | Embedded C | 8051 C 語言實作 |
| 後續實驗 | Embedded C | 8051 C 語言與周邊控制實作 |
| Final | Embedded C | 期末整合實作 |

> 各次實驗的完整內容、實作方法與結果可參考 [`reports/`](./reports/)；原始程式則整理於 [`code/`](./code/)。

---

## Learning Outcomes

透過本課程的實作，我從組合語言開始接觸微控制器程式設計，再逐步轉向 Embedded C，建立對微控制器軟硬體互動方式的基本理解。

課程實作主要累積以下經驗：

- 8051 Assembly 基礎程式設計
- Embedded C 微控制器程式開發
- 暫存器與記憶體操作
- 微控制器 I/O 控制
- 程式流程與硬體行為之對應
- 8051 周邊功能實作
- 實驗結果測試與問題排查
- 從 Assembly 過渡至 C 語言的嵌入式程式設計

這些實作也成為後續接觸軟硬體協同設計、感測器整合與嵌入式系統專題時的基礎。

---

## Development Environment

- **IDE / Toolchain:** Keil μVision
- **Platform:** 8051 Microcontroller
- **Assembly:** 8051 Assembly
- **C:** Embedded C / C51

本 Repository 主要保留課程期間撰寫的原始程式與個人實驗報告，用於整理大學期間的課程實作與學習歷程。

---

## Notes

本 Repository 為課程學習成果整理，內容依修課期間實際完成的程式與報告保存。

部分程式可能保留當時課程實驗的原始寫法，以呈現實際學習與實作過程；未特別為展示目的重新改寫實驗結果。
