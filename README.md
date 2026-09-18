# 🃏 TCG Counter App

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Supabase](https://img.shields.io/badge/Backend-Supabase-3ECF8E?logo=supabase)](https://supabase.com)
[![PWA Ready](https://img.shields.io/badge/PWA-Ready-FF6F00?logo=pwa)](https://patrike260.github.io/tcg_counter_app/)
[![GitHub Pages](https://img.shields.io/badge/Deployment-GitHub_Pages-222222?logo=github)](https://patrike260.github.io/tcg_counter_app/)

Eine universelle, moderne Progressive Web App (PWA) und mobile Begleit-App für Trading-Card-Game-Spieler. Entwickelt zum schnellen Erfassen von Match-Ergebnissen direkt am Turniertisch, zur Deck-Verwaltung und mit interaktiven In-Game-Spieltisch-Werkzeugen.

👉 **Live-Web-App:** [https://patrike260.github.io/tcg_counter_app/](https://patrike260.github.io/tcg_counter_app/)

---

## ✨ Features

### 📊 Deck- & Match-Tracking
* **Multi-TCG-Support:** Vorkonfiguriert für *Magic: The Gathering*, *Pokémon*, *One Piece*, *Yu-Gi-Oh!*, *Lorcana*, *Star Wars Unlimited*, *Naruto Mythos*, *Riftbound*, *Weiß Schwarz* u.v.m. Eigene TCGs können flexibel hinzugefügt werden.
* **Schnelleingabe am Spieltisch:** Erfassung von Sieg, Niederlage, Unentschieden oder Timeout in Sekundenschnelle.
* **Turn-Order & Formate:** Optionale Erfassung von Play/Draw (1st/2nd), BO1/BO3 mit Game-Score und Notizen.
* **Gegner-Archetypen mit Auto-Suggest:** Automatisches Merken und Vorschlagen zuvor gespielter gegnerischer Archetypen.
* **Event-Tagging:** Zuordnung zu Events (Local, Regional, Casual, Testing) inklusive Filterung.

### 🎲 In-Game Spieltisch-Tools
* **Life Counter (2 Spieler):** Vertikal geteilte Tischansicht (oberer Spieler um 180° gedreht) mit Presets (20, 50, 8000 LP).
* **Naruto Mythos Chakra-Tracker:** Speziell nach den offiziellen Regeln: Verwaltung von Ready/Rested Chakra, Rundenzug-Refresh und Chakra-Deck-Counter.
* **Riftbound Score-Tracker:** Battlefield-Punktezähler bis zur Zielpunktzahl.
* **Turnier-Timer:** Countdown mit Preset-Zeiten (30, 45, 50 Min.) und optischem Warnsignal für die letzten 5 Minuten.
* **Zufallstools:** Münzwurf (Kopf/Zahl), Würfel (D6, D20) und Startspieler-Picker.

### 🎨 Design & Barrierefreiheit
* **Theme-Presets:** Wählbar zwischen *Cyberpunk Neon*, *Paper Manga (High Contrast)*, *One Piece Crimson* und *Cell Green*.
* **Light & Dark Mode:** Volle Unterstützung für grelles Hallenlicht und abgedunkelte Spielabende.

### 🔒 Sicherheit, Daten & PWA
* **Cloud-Sync:** Echtzeit-Synchronisation via Supabase mit Row-Level Security (RLS).
* **Offline-Caching:** Decks bleiben auch ohne Netzverbindung über lokalen Speicher verfügbar.
* **Export & Backup:** Match-Historie als CSV exportieren oder vollständige JSON-Backups sichern und wiederherstellen.
* **Installierbar (PWA):** Direkt aus Chrome, Edge oder Safari ohne App-Store auf dem Smartphone installierbar.

---

## 🛠️ Tech Stack

* **Frontend:** [Flutter](https://flutter.dev) (Web & Android)
* **State Management:** [Flutter Riverpod](https://riverpod.dev)
* **Backend:** [Supabase](https://supabase.com) (PostgreSQL, Auth, Row-Level Security)
* **Hosting:** GitHub Pages

---

## 🚀 Lokales Setup

### 1. Repository klonen
```bash
git clone [https://github.com/Patrike260/tcg_counter_app.git](https://github.com/Patrike260/tcg_counter_app.git)
cd tcg_counter_app
