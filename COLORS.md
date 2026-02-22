# 🎨 Travelhub – Farbübersicht

> Vollständige Aufstellung aller im Projekt verwendeten Farben (Stand: Februar 2026)

---

## 1) Offizielles Farbschema (Theme-Dateien)

### Swift – `ColorExtension.swift`

| Rolle         | Hex         | Vorschau |
| ------------- | ----------- | -------- |
| appPrimary    | `#4A90D9`   | 🔵       |
| appSecondary  | `#67B8DE`   | 🔵       |
| appBackground | `#F5F7FA`   | ⬜       |
| appText       | `#2C3E50`   | 🔷       |

### Flutter – `app_theme.dart`

| Rolle      | Hex         | Vorschau |
| ---------- | ----------- | -------- |
| primary    | `#4A90D9`   | 🔵       |
| secondary  | `#67B8DE`   | 🔵       |
| background | `#F5F7FA`   | ⬜       |
| text       | `#2C3E50`   | 🔷       |
| Input Fill | `#F0F0F0`   | ⬜       |

> ⚠️ **Hinweis:** Das README nennt für Swift iOS `#007AFF` (Primary) und `#8E8E93` (Secondary).
> Im tatsächlichen Code (`ColorExtension.swift`) stehen jedoch **dieselben Werte wie bei Flutter** (`#4A90D9` / `#67B8DE`).

---

## 2) Kategoriefarben – SearchHub (Flutter)

Gradienten pro Reise-Kategorie aus `search_hub_screen.dart`:

| Kategorie              | Farbe 1     | Farbe 2     |
| ---------------------- | ----------- | ----------- |
| 🏖️ Strand (`beach`)    | `#F6D365`   | `#FDA085`   |
| 🏙️ Stadt (`city`)      | `#A18CD1`   | `#FBC2EB`   |
| 🏝️ Insel (`island`)    | `#89F7FE`   | `#66A6FF`   |
| 🏛️ Kultur (`culture`)  | `#F093FB`   | `#F5576C`   |
| 🧗 Abenteuer (`adventure`) | `#4FACFE` | `#00F2FE` |
| ⛰️ Berge (`mountain`)  | `#43E97B`   | `#38F9D7`   |

---

## 3) Packlisten-Kategoriefarben (Flutter)

Aus `packliste_screen.dart`:

| Kategorie   | Hex         | Vorschau |
| ----------- | ----------- | -------- |
| Kleidung    | `#42A5F5`   | 🔵       |
| Hygiene     | `#26A69A`   | 🟢       |
| Elektronik  | `#AB47BC`   | 🟣       |
| Dokumente   | `#EF5350`   | 🔴       |
| Sonstiges   | `#FFA726`   | 🟠       |
| Medizin     | `#EC407A`   | 🩷       |

Header-Gradient: `#42A5F5` → `#64B5F6`

---

## 4) Screen-spezifische Akzentfarben (Flutter)

Header-Gradienten einzelner Screens:

| Screen                     | Farbe 1     | Farbe 2     | Stil    |
| -------------------------- | ----------- | ----------- | ------- |
| `create_trip_screen.dart`  | `#4A90D9`   | `#67B8DE`   | Primary |
| `group_management_screen.dart` | `#5C6BC0` | `#7986CB` | Indigo  |
| `voting_screen.dart`       | `#FF7043`   | `#FF8A65`   | Orange  |

---

## 5) Utility- / Hintergrundfarben (Flutter)

| Hex                    | Verwendung                          |
| ---------------------- | ----------------------------------- |
| `#F0F4F8`              | SearchHub-Hintergrund, Fade-Gradient |
| `#5A6A7A`              | Sekundärer Text (SearchHub)         |
| `#000000` (10% Alpha)  | Leichte Schatten (`0x0A000000`)     |

---

## 6) SwiftUI-Systemfarben (kein eigener Hex-Code)

Diese Farben stammen aus dem iOS-System und passen sich automatisch an Light/Dark Mode an:

| Farbe                | Verwendung                                |
| -------------------- | ----------------------------------------- |
| `.gray`              | Platzhalter, sekundärer Text              |
| `.systemGray4`       | Leere Sterne (Bewertungen)               |
| `.systemGray6`       | Input-Hintergründe, Cards                |
| `.systemBackground`  | Adaptiver Screen-Hintergrund             |
| `.white`             | Text auf dunklem Hintergrund, Buttons    |
| `.red`               | Fehler, Löschen, Budget überschritten    |
| `.green`             | Erfolg, Online-Status, positive Bilanz   |
| `.orange`            | Warnungen, Pending-Status                |
| `.yellow`            | Sterne / Bewertungen                     |
| `.blue`              | Links, Freunde hinzufügen                |
| `.primary`           | System-Primärfarbe (dynamisch)           |
| `.accentColor`       | System-Akzentfarbe                       |

---

## Zusammenfassung

| Bereich                  | Anzahl Farben |
| ------------------------ | ------------- |
| Theme (Primary, Sec …)  | 4 + 1         |
| Kategorie-Gradienten     | 12 (6×2)      |
| Packlisten-Kategorien    | 6 + 1         |
| Screen-Gradienten        | 6 (3×2)       |
| Utility-Farben           | 3             |
| Systemfarben (SwiftUI)   | ~12           |
| **Gesamt**               | **~45**       |
