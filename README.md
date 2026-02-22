# Travel Hub

Reise-Kollaborations-App zur gemeinsamen Planung, Verwaltung und Kommunikation innerhalb von Reisegruppen. Verfuegbar als native iOS-App (Swift/SwiftUI) und als plattformuebergreifende Flutter-App (Web, iOS, Android).

---

## Inhalt

1. [Ueberblick](#ueberblick)
2. [Features](#features)
3. [Tech Stack](#tech-stack)
4. [Projektstruktur](#projektstruktur)
5. [Installation und Start](#installation-und-start)
6. [Tests](#tests)
7. [CI/CD und Deployment](#cicd-und-deployment)
8. [Farbschema](#farbschema)
9. [Kontakt](#kontakt)

---

## Ueberblick

Travel Hub existiert in zwei Varianten:

| | Swift (Original) | Flutter (Port) |
|---|---|---|
| Sprache | Swift | Dart |
| UI Framework | SwiftUI | Flutter (Material 3) |
| Datenhaltung | SwiftData | sqflite + SharedPreferences |
| Architektur | MVVM + @Observable | MVVM + Provider |
| Navigation | TabView / NavigationStack | go_router + BottomNavigationBar |
| Karte | -- | flutter_map + OpenStreetMap |
| Plattformen | iOS 17+ | Web, iOS, Android, macOS |

Das Repository wird auf eine Gitea-Instanz gespiegelt. Bei jedem Push wird automatisch ein Container-Build ausgeloest, der die Flutter-Web-App baut und als Container bereitstellt.

---

## Features

### Dashboard

- Uebersicht bevorstehender und aktiver Reisen
- Budget-Uebersicht mit Gesamtbudget
- Schnelle Navigation zu wichtigen Elementen

### Trip Management

- Neue Trips erstellen (Titel, Destination, Datum, Budget)
- Trips nach Status filtern (Aktiv, Geplant, Abgeschlossen)
- Trip-Details mit Mitgliedern und Beschreibung
- Countdown-Anzeige bis zum Reisebeginn
- Quick-Stats (Mitglieder, Budget, Dauer)

### Freundesystem

- Freunde hinzufuegen mit Name und E-Mail
- Freundschaftsanfragen akzeptieren oder ablehnen
- Freunde entfernen
- Statusanzeige und Avatare mit Initialen

### Chat

- Gruppen-Chat pro Trip
- Nachrichten senden und empfangen
- Chat-Historie mit Zeitstempeln
- Auto-Scroll zu neuen Nachrichten

### Budgetplanung

- Ausgaben pro Trip dokumentieren
- Kategorien: Food, Transport, Accommodation, Activities, General
- Splitting-Funktion (Ausgaben auf mehrere Personen aufteilen)
- Fortschrittsbalken fuer Budget-Tracking
- Ausgaben nach Datum sortiert

### Abstimmungen

- Abstimmungen zu Trip-Entscheidungen erstellen
- Multiple-Choice-Abstimmungen
- Ergebnisse mit Prozentanzeige
- Ablaufdatum und Status (Aktiv/Geschlossen)

### Packliste

- 6 Kategorien: Kleidung, Hygiene, Technik, Dokumente, Strand und Freizeit, Reiseapotheke
- Fortschrittsanzeige mit prozentualem Abschluss
- Suchfunktion und Filter (nur offene Items)
- Geteilte Items mit Claim-Funktion
- Mengen-Badges und Swipe-to-Delete

### Hotelsuche

- 7 Hotels mit Detailinformationen
- Filter nach Region, Preis, Sternen und Ausstattung
- Ausstattungs-Chips (Pool, WLAN, Fruehstueck, Meerblick, etc.)
- Favoriten-System und Buchungsstatus
- Detailseite mit Preisrechner

### Fotos teilen

- 3-Tab-Ansicht: Galerie, Alben, Aktivitaet
- Likes und Kommentare pro Foto
- Upload-Simulation mit Emoji-Auswahl
- Alben erstellen und verwalten
- Aktivitaets-Feed

### Reisetipps

- 12 interaktive Tipps in 6 Kategorien
- Upvote-System und Bookmarks
- Detailansicht mit ausfuehrlicher Beschreibung
- Eigene Tipps hinzufuegen

### Profil und Einstellungen

- Profilbearbeitung (Name, E-Mail, Bio)
- Statistiken: Reisen, Ziele, Freunde, Budget
- Achievements-System mit freischaltbaren Erfolgen
- Feedback-Formular mit Sternebewertung
- Hilfe, FAQ und Datenschutz
- Sprach- und Waehrungseinstellungen

### Interaktive Karte (Entdecken-Tab)

- Interaktive OpenStreetMap-Karte via flutter_map
- 20 europaeische Reiseziele
- Farbige Kategorie-Marker (Strand, Stadt, Berge, Kultur, Abenteuer, Insel)
- Detail-Bottom-Sheet mit Highlights
- Kategorie-Filter und Suchleiste
- Listen- und Kartenansicht umschaltbar

---

## Tech Stack

### Dependencies (Flutter)

| Paket | Version | Zweck |
|-------|---------|-------|
| provider | ^6.1.2 | State Management |
| go_router | ^14.6.2 | Deklarative Navigation |
| sqflite | ^2.4.1 | Lokale SQLite-Datenbank |
| shared_preferences | ^2.3.4 | Key-Value-Speicher |
| flutter_map | ^7.0.2 | Interaktive OpenStreetMap-Karte |
| latlong2 | ^0.9.1 | Geo-Koordinaten |
| url_launcher | ^6.3.1 | Externe Links oeffnen |
| intl | ^0.19.0 | Datums- und Zahlenformatierung |
| uuid | ^4.5.1 | Eindeutige IDs |

---

## Projektstruktur

### Swift (iOS)

```
Travelhub/
  Models/          Datenmodelle (Trip, User, Friend, ChatMessage, ...)
  Views/           SwiftUI Views (Dashboard, Trips, Chat, Budget, ...)
  ViewModels/      MVVM ViewModels
  Components/      Wiederverwendbare UI-Komponenten
```

### Flutter

```
travelhub_flutter/
  lib/
    main.dart          App-Einstiegspunkt
    models/            Datenmodelle (Trip, User, Friend, ...)
    providers/         State Management (Provider)
    screens/           19 Screens (Login, Dashboard, Karte, ...)
    widgets/           Wiederverwendbare Widgets
    services/          Datenbank-Services (sqflite / web)
    theme/             AppTheme und Farben
  test/                Widget-Tests
  web/                 Web-spezifische Dateien
  ios/                 iOS-spezifische Dateien
  android/             Android-spezifische Dateien
  pubspec.yaml         Dependencies
```

---

## Tab Navigation

| Tab | Feature |
|-----|---------|
| Home | Dashboard mit Uebersicht |
| Reisen | Trip Management |
| Entdecken | Interaktive Karte |
| Freunde | Freundeverwaltung |
| Profil | Einstellungen und Statistiken |

---

## Installation und Start

### Swift-Version (Xcode)

1. `Travelhub.xcodeproj` in Xcode oeffnen
2. Simulator-Geraet waehlen (iPhone 15 empfohlen)
3. Mit Cmd + R bauen und starten

### Flutter-Version

Voraussetzungen: Flutter SDK (ab 3.2.0), Chrome (fuer Web-Build)

```bash
# In das Flutter-Projekt wechseln
cd travelhub_flutter

# Dependencies installieren
flutter pub get

# Web-Version starten (Entwicklungsmodus)
flutter run -d chrome

# Produktions-Build erstellen
flutter build web
```

### Lokal testen

```bash
cd travelhub_flutter
flutter build web
cd build/web
python3 -m http.server 8888
```

Die App ist dann unter http://localhost:8888 erreichbar. Stoppen mit Ctrl + C.

---

## Tests

### Swift (Xcode)

| Target | Datei | Beschreibung |
|--------|-------|-------------|
| TravelhubTests | TravelhubTests/TravelhubTests.swift | Unit-Tests |
| TravelhubUITests | TravelhubUITests/TravelhubUITests.swift | UI-Tests |
| TravelhubUITests | TravelhubUITests/TravelhubUITestsLaunchTests.swift | Launch-Performance |

Tests ausfuehren: Product -> Test (Cmd + U) in Xcode

### Flutter

```bash
cd travelhub_flutter

# Alle Tests ausfuehren
flutter test

# Mit Coverage-Report
flutter test --coverage
```

---

## CI/CD und Deployment

Das GitHub-Repository wird auf eine Gitea-Instanz gespiegelt. Bei jedem Push wird eine CI/CD-Pipeline ausgeloest:

```
GitHub (Push) --> Gitea Repository
                      |
                      v
               Gitea Actions / Runner
                      |
              +-------+--------+
              v                v
       flutter build web  Docker Build
              |                |
              +-------+--------+
                      v
               Container Image
               (nginx + Web-App)
                      |
                      v
              Container Registry
                      |
                      v
             Deployment / Hosting
```

Ablauf:

1. Mirror: GitHub wird automatisch nach Gitea synchronisiert
2. CI-Trigger: Jeder Push loest den Gitea-Runner aus
3. Build: flutter build web wird im Container ausgefuehrt
4. Container: Das Build-Ergebnis wird in ein nginx-Docker-Image gepackt
5. Deploy: Der Container wird gestartet und die App ist ueber den Server erreichbar

Beispiel Dockerfile:

```dockerfile
# Build-Stage
FROM ghcr.io/cirruslabs/flutter:stable AS build
WORKDIR /app
COPY travelhub_flutter/ .
RUN flutter pub get && flutter build web

# Production-Stage
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
```

---

## Farbschema

| Farbe | Swift (iOS) | Flutter |
|-------|-------------|---------|
| Primary | #007AFF | #4A90D9 |
| Secondary | #8E8E93 | #67B8DE |
| Background | System | #F5F7FA |
| Text | Label | #2C3E50 |

---

## Kontakt

Bei Fragen oder Problemen: support@travelhub.de

---

Version: 2.1.0
Letztes Update: 20.02.2026
Plattformen: iOS (Swift), Web / iOS / Android (Flutter)
