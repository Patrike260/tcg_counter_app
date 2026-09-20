// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'TCG Tracker';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get delete => 'Löschen';

  @override
  String get add => 'Hinzufügen';

  @override
  String get close => 'Schließen';

  @override
  String get continueAction => 'Weiter';

  @override
  String get apply => 'Übernehmen';

  @override
  String get create => 'Anlegen';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get all => 'Alle';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get archive => 'Archivieren';

  @override
  String get or => 'ODER';

  @override
  String get from => 'von';

  @override
  String get version => 'Version';

  @override
  String get versionSubtitle => 'Web / PWA';

  @override
  String errorWithDetails(Object error) {
    return 'Fehler: $error';
  }

  @override
  String loadErrorWithDetails(Object error) {
    return 'Fehler beim Laden: $error';
  }

  @override
  String gamesLoadError(Object error) {
    return 'Spiele konnten nicht geladen werden: $error';
  }

  @override
  String decksLoadError(Object error) {
    return 'Decks konnten nicht geladen werden: $error';
  }

  @override
  String get noUserLoggedIn => 'Kein Nutzer eingeloggt';

  @override
  String userIdShort(String id) {
    return 'ID: $id...';
  }

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navDecks => 'Decks';

  @override
  String get navTools => 'Tools';

  @override
  String get navSettings => 'Einstellungen';

  @override
  String get titleMyDecks => 'Meine Decks';

  @override
  String get tooltipDashboardFilter => 'Dashboard-Filter';

  @override
  String get tooltipDiceCoin => 'Münze & Würfel';

  @override
  String get noTcg => 'Kein TCG';

  @override
  String get turnFree => 'Zug frei';

  @override
  String get turnFirstShort => '1st';

  @override
  String get turnSecondShort => '2nd';

  @override
  String get turnFirstFull => '1st (Beginn)';

  @override
  String get turnSecondFull => '2nd (Zweiter)';

  @override
  String get formatBo1 => 'Best of 1';

  @override
  String get formatBo3 => 'Best of 3';

  @override
  String get bo1 => 'BO1';

  @override
  String get bo3 => 'BO3';

  @override
  String get allFormats => 'Alle Formate';

  @override
  String get languageTitle => 'Sprache';

  @override
  String get languageSubtitle => 'App-Sprache wählen';

  @override
  String get languageSystem => 'Systemsprache';

  @override
  String get languageSystemSubtitle => 'Der Gerätesprache folgen';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageItalian => 'Italiano';

  @override
  String get loginTitle => 'TCG Tracker Login';

  @override
  String get createAccount => 'Konto erstellen';

  @override
  String get email => 'E-Mail';

  @override
  String get password => 'Passwort';

  @override
  String get signIn => 'Anmelden';

  @override
  String get register => 'Registrieren';

  @override
  String get alreadyHaveAccount => 'Bereits ein Konto? Anmelden';

  @override
  String get noAccountYet => 'Noch kein Konto? Jetzt registrieren';

  @override
  String get continueWithGoogle => 'Mit Google fortfahren';

  @override
  String get enterEmailPassword => 'Bitte E-Mail und Passwort eingeben.';

  @override
  String get registrationSuccess => 'Registrierung erfolgreich!';

  @override
  String googleLoginFailed(Object error) {
    return 'Google Login fehlgeschlagen: $error';
  }

  @override
  String get legalAcceptHint =>
      'Mit der Registrierung akzeptierst du unsere Nutzungsbedingungen & Datenschutzrichtlinien.';

  @override
  String get sectionAppearance => 'ERSCHEINUNGSBILD / DESIGN';

  @override
  String get sectionSettings => 'EINSTELLUNGEN';

  @override
  String get sectionContent => 'VERWALTUNG & INHALTE';

  @override
  String get sectionBackup => 'DATEN & BACKUP';

  @override
  String get sectionAccount => 'KONTO & INFO';

  @override
  String get themePresetsTitle => 'Farbschema & Design-Presets';

  @override
  String get dashboardTabsTitle => 'Dashboard-Tabs & Kacheln konfigurieren';

  @override
  String get dashboardTabsSubtitle =>
      'Reihenfolge, Tabs und angezeigte Widgets anpassen';

  @override
  String get matchDefaultsTitle => 'Match- & Standardeinstellungen';

  @override
  String get visibleTcgsTitle => 'Sichtbare TCGs anpassen';

  @override
  String get visibleTcgsSubtitle =>
      'Unerwünschte Kartenspiele in Dropdowns ausblenden';

  @override
  String get manageTcgsTitle => 'Kartenspiele (TCGs) verwalten';

  @override
  String get manageTcgsSubtitle => 'Spiele hinzufügen oder umbenennen';

  @override
  String get toolPresetsTitle => 'Tool-Presets verwalten';

  @override
  String get toolPresetsSubtitle =>
      'Life Counter, Spieleranzahl und Timer anpassen';

  @override
  String get tournamentsTitle => 'Turniere & Events';

  @override
  String get tournamentsSubtitle =>
      'Platzierungen und gespielte Decks festhalten';

  @override
  String get archetypesTitle => 'Gegner-Archetypen verwalten';

  @override
  String get archetypesSubtitle =>
      'Gespeicherte Vorschläge umbenennen oder bereinigen';

  @override
  String get eventTagsTitle => 'Event-Tags verwalten';

  @override
  String get eventTagsSubtitle =>
      'Eigene Tags für Turniere oder Cups erstellen';

  @override
  String get exportCsvTitle => 'Matches als CSV exportieren';

  @override
  String get exportCsvSubtitle => 'Ideal für Excel oder Tabellenkalkulation';

  @override
  String get exportJsonTitle => 'Vollständiges Backup sichern (JSON)';

  @override
  String get exportJsonSubtitle => 'Sichert alle Decks & Match-Historien';

  @override
  String get restoreBackupTitle => 'Backup wiederherstellen';

  @override
  String get restoreBackupSubtitle => 'JSON-Sicherungsdatei einlesen';

  @override
  String get legalSettingsTitle => 'Nutzungsbedingungen & Datenschutz';

  @override
  String get legalSettingsSubtitle => 'Impressum, Disclaimer und DSGVO';

  @override
  String get signOutTitle => 'Abmelden';

  @override
  String get signOutSubtitle => 'Sitzung beenden';

  @override
  String get deleteAccountTitle => 'Konto unwiderruflich löschen';

  @override
  String get deleteAccountSubtitle =>
      'Account, Decks und Matches endgültig entfernen';

  @override
  String get csvExported => 'Matches als CSV exportiert!';

  @override
  String csvExportFailed(Object error) {
    return 'Fehler beim CSV-Export: $error';
  }

  @override
  String get jsonBackupCreated => 'JSON-Backup erfolgreich generiert!';

  @override
  String jsonBackupFailed(Object error) {
    return 'Fehler beim Backup-Export: $error';
  }

  @override
  String get fileReadFailed => 'Datei konnte nicht gelesen werden.';

  @override
  String get restoreBackupQuestion => 'Backup einspielen?';

  @override
  String get restoreBackupBody =>
      'Vorhandene Decks und Matches werden zusammengeführt bzw. aktualisiert.';

  @override
  String get restore => 'Wiederherstellen';

  @override
  String matchesRestored(int count) {
    return '$count Matches erfolgreich wiederhergestellt!';
  }

  @override
  String restoreFailed(Object error) {
    return 'Wiederherstellung fehlgeschlagen: $error';
  }

  @override
  String get deleteAccountQuestion => 'Konto löschen?';

  @override
  String get deleteAccountBody =>
      'Möchtest du deinen Account und alle gespeicherten Decks und Matches wirklich endgültig löschen?';

  @override
  String get lastConfirmation => 'Letzte Bestätigung';

  @override
  String get deleteAccountFinalBody =>
      'Diese Aktion kann nicht rückgängig gemacht werden. Das Konto und alle Tracker-Daten werden unwiderruflich gelöscht.';

  @override
  String get deletePermanently => 'Endgültig löschen';

  @override
  String deleteAccountFailed(Object error) {
    return 'Konto konnte nicht gelöscht werden: $error';
  }

  @override
  String get legalScreenTitle => 'Rechtliches & Datenschutz';

  @override
  String get legalIntro =>
      'Bitte lies die folgenden Hinweise, bevor du die App nutzt oder ein Konto anlegst.';

  @override
  String get legalTermsTitle => 'Nutzungsbedingungen (AGB)';

  @override
  String get legalTermsBody =>
      'TCG Tracker ist ein privates, inoffizielles Fan-Projekt. Die App dient dazu, eigene Decks, Matches und Turnierplatzierungen am Spieltisch festzuhalten. Es handelt sich nicht um ein kommerzielles Angebot und nicht um ein offizielles Produkt der jeweiligen Kartenspiel-Hersteller.\n\nDie Nutzung erfolgt auf eigene Verantwortung. Es besteht keine Gewährleistung für ununterbrochene Verfügbarkeit, fehlerfreie Funktion oder den Erhalt deiner Daten. Datenverlust (z. B. durch technische Störungen, Account-Löschung oder Änderungen am Dienst) kann nicht ausgeschlossen werden. Lege bei Bedarf eigene Backups an.\n\nDu darfst die App nur für private Zwecke verwenden. Missbrauch, automatisiertes Auslesen fremder Konten oder das Umgehen von Sicherheitsmechanismen ist untersagt.';

  @override
  String get legalPrivacyTitle => 'Datenschutz (DSGVO)';

  @override
  String get legalPrivacyBody =>
      'Verantwortlich für die Verarbeitung personenbezogener Daten im Sinne der DSGVO ist der Betreiber dieser App (siehe Impressum).\n\nWir speichern insbesondere: deine E-Mail-Adresse (Konto), Authentifizierungsdaten sowie von dir eingegebene Spielinhalte (Decks, Match-Ergebnisse, Notizen, Tags, Turniere). Die Speicherung erfolgt in der Supabase-Cloud (PostgreSQL mit Row-Level Security).\n\nZweck der Verarbeitung ist die Bereitstellung des Trackers (Vertragserfüllung bzw. vorvertragliche Maßnahmen, Art. 6 Abs. 1 lit. b DSGVO). Es erfolgt keine Weitergabe deiner Daten an Dritte zu Werbezwecken. Technische Dienstleister (Hosting/Auth) verarbeiten Daten nur, soweit das für den Betrieb erforderlich ist.\n\nDu hast das Recht auf Auskunft, Berichtigung, Einschränkung, Widerspruch und Löschung. Über „Konto unwiderruflich löschen“ in den Einstellungen kannst du dein Konto und die zugehörigen Tracker-Daten endgültig entfernen lassen.';

  @override
  String get legalDisclaimerTitle => 'Marken- & Copyright-Hinweis (Disclaimer)';

  @override
  String get legalDisclaimerBody =>
      'Pokémon, One Piece, Yu-Gi-Oh!, Magic: The Gathering, Dragon Ball Super und alle weiteren genannten Kartenspiele, Figuren, Logos und Bezeichnungen sind eingetragene Marken bzw. urheberrechtlich geschützte Werke ihrer jeweiligen Rechteinhaber, unter anderem Nintendo, The Pokémon Company, Bandai, Toei Animation, Konami, Wizards of the Coast / Hasbro sowie weiterer Lizenzgeber.\n\nDiese App steht in keiner offiziellen Verbindung zu den genannten Unternehmen. Es handelt sich um ein unabhängiges Fan-Projekt. Spielnamen und Motive dienen ausschließlich der Orientierung beim privaten Tracken eigener Partien. Es werden keine offiziellen Kartenbilder oder geschützten Artwork-Dateien als Produktbestandteil verkauft oder lizenziert.';

  @override
  String get legalImprintTitle => 'Impressum & Kontakt';

  @override
  String get legalImprintBody =>
      'Angaben gemäß § 5 DDG (Digitales-Dienste-Gesetz):\n\nBetreiber / Entwickler:\n[Vor- und Nachname]\n[Straße Hausnummer]\n[PLZ Ort]\nDeutschland\n\nKontakt:\nE-Mail: kontakt@example.com\n\nBitte ersetze die Platzhalter durch die tatsächlichen Angaben, bevor die App öffentlich betrieben wird.';

  @override
  String get themeScreenTitle => 'Farbschema & Design';

  @override
  String get themeLight => 'HELL';

  @override
  String get themeDark => 'DUNKEL';

  @override
  String get matchSettingsTitle => 'Match-Einstellungen';

  @override
  String get defaultGame => 'Standard-Kartenspiel';

  @override
  String get defaultFormat => 'Standard Match-Format';

  @override
  String get defaultTurnOrder => 'Standard Zugreihenfolge';

  @override
  String get turnFreeLabel => 'Frei';

  @override
  String get rememberLastTags => 'Zuletzt gewählte Tags merken';

  @override
  String get statsTimeRange => 'Zeitraum für Statistiken';

  @override
  String get statsTimeRangeSubtitle =>
      'Wirkt auf Winrate, Nemesis und TCG-Performance';

  @override
  String get dashboardGameFocus => 'Spiel-Fokus für Dashboard';

  @override
  String get dashboardGamePickerTitle => 'Dashboard-Spiel';

  @override
  String get rangeWeek => 'Woche';

  @override
  String get rangeMonth => 'Monat';

  @override
  String get rangeSeason => 'Saison';

  @override
  String get rangeYear => 'Jahr';

  @override
  String get rangeAllTime => 'Gesamt';

  @override
  String get visibleTcgsScreenTitle => 'Sichtbare TCGs';

  @override
  String get noGamesAvailable => 'Keine Kartenspiele vorhanden.';

  @override
  String get atLeastOneTcgVisible =>
      'Mindestens ein TCG muss sichtbar bleiben.';

  @override
  String get addTcgTitle => 'Neues TCG hinzufügen';

  @override
  String get renameTcgTitle => 'TCG umbenennen';

  @override
  String get gameNameLabel => 'Name des Kartenspiels';

  @override
  String get newName => 'Neuer Name';

  @override
  String get manageTcgsScreenTitle => 'Kartenspiele (TCGs) verwalten';

  @override
  String get toolPresetsScreenTitle => 'Tool-Presets';

  @override
  String get factoryResetQuestion => 'Werkseinstellungen?';

  @override
  String get noPresets => 'Keine Presets vorhanden.';

  @override
  String get keepOnePreset => 'Mindestens ein Preset muss erhalten bleiben.';

  @override
  String get enterNameAndLp => 'Bitte Name und gültige Start-LP angeben.';

  @override
  String get playerCount => 'Spieleranzahl';

  @override
  String get roundTimer => 'Rundentimer';

  @override
  String get minutes => 'Minuten';

  @override
  String minutesValue(int minutes) {
    return '$minutes Min';
  }

  @override
  String get presetName => 'Name';

  @override
  String get startingLp => 'Start-LP';

  @override
  String get createTagTitle => 'Neuen Tag erstellen';

  @override
  String get tagNameHint => 'Tag-Name (z. B. Store Cup, League)';

  @override
  String get manageTagsScreenTitle => 'Event-Tags verwalten';

  @override
  String get standardTagsHeader => 'STANDARD-TAGS (FEST VORGEGEBEN)';

  @override
  String get systemTagSubtitle => 'System-Tag (kann nicht gelöscht werden)';

  @override
  String get customTagsHeader => 'BENUTZERDEFINIERTE TAGS';

  @override
  String get createTag => 'Tag erstellen';

  @override
  String get noCustomTags => 'Noch keine eigenen Tags angelegt.';

  @override
  String get deleteArchetypeQuestion => 'Archetyp löschen?';

  @override
  String deleteArchetypeBody(String name) {
    return 'Soll \"$name\" aus den automatischen Vorschlägen entfernt werden?';
  }

  @override
  String itemDeleted(String name) {
    return '\"$name\" gelöscht.';
  }

  @override
  String deleteFailed(Object error) {
    return 'Fehler beim Löschen: $error';
  }

  @override
  String get renameArchetypeTitle => 'Archetyp umbenennen';

  @override
  String renamedTo(String name) {
    return 'Umbenannt in \"$name\".';
  }

  @override
  String renameFailed(Object error) {
    return 'Fehler beim Umbenennen: $error';
  }

  @override
  String get archetypesScreenTitle => 'Gegner-Archetypen verwalten';

  @override
  String get chooseCardGame => 'Kartenspiel wählen';

  @override
  String get noArchetypesForGame =>
      'Keine Archetypen für dieses TCG vorhanden.';

  @override
  String get dashboardConfigTitle => 'Dashboard konfigurieren';

  @override
  String get resetToDefault => 'Auf Standard zurücksetzen';

  @override
  String get resetDashboardQuestion => 'Auf Standard zurücksetzen?';

  @override
  String get atLeastOneTab => 'Mindestens ein Tab muss aktiv bleiben.';

  @override
  String get allEvents => 'Alle Events';

  @override
  String get focusEventTag => 'Fokus-Event-Tag';

  @override
  String get focusEventTagOptional => 'Fokus-Event-Tag (optional)';

  @override
  String get customDashboard => 'Eigenes Dashboard';

  @override
  String get tabTitle => 'Titel';

  @override
  String get icon => 'Icon';

  @override
  String get startTiles => 'Start-Kacheln';

  @override
  String get widgetWinrate => 'Gesamte Winrate & Siegquote';

  @override
  String get widgetNemesis => 'Nemesis & Best Matchup';

  @override
  String get widgetPerformance => 'Performance nach Kartenspiel';

  @override
  String get widgetRecent => 'Letzte Matches';

  @override
  String get widgetTournaments => 'Turniere & Platzierungen';

  @override
  String get widgetTurnOrder => '1st / 2nd Zugreihenfolge-Stats';

  @override
  String get tabAllround => 'Allround';

  @override
  String get tabTournament => 'Turnier';

  @override
  String get tabMinimal => 'Minimal';

  @override
  String get noDashboardTab => 'Kein Dashboard-Tab aktiv.';

  @override
  String eventFilter(String tag) {
    return 'Event: $tag';
  }

  @override
  String get winrate => 'Winrate';

  @override
  String get matches => 'Matches';

  @override
  String get wins => 'Siege';

  @override
  String get recorded => 'Erfasst';

  @override
  String winsOfTotal(int total) {
    return 'von $total';
  }

  @override
  String get noMatchesInRange => 'Keine Matches im gewählten Zeitraum';

  @override
  String noRepeatMatchups(String range) {
    return 'Keine Matches gegen mehrfache Archetypen im gewählten Zeitraum ($range).\nMindestens 2 Matches gegen dasselbe Deck nötig.';
  }

  @override
  String get bestMatchup => 'Stärkstes Matchup';

  @override
  String get nemesisDeck => 'Nemesis / Problem-Deck';

  @override
  String get performanceByGame => 'Performance nach Kartenspiel';

  @override
  String get noMatchesVisibleTcgs => 'Noch keine Matches für sichtbare TCGs.';

  @override
  String winsOfMatches(int wins, int total) {
    return '$wins Siege von $total Matches';
  }

  @override
  String get recentMatches => 'Letzte Matches';

  @override
  String get turnOrder => 'Zugreihenfolge';

  @override
  String get first => 'First';

  @override
  String get second => 'Second';

  @override
  String winsFraction(int wins, int total) {
    return '$wins/$total Siege';
  }

  @override
  String get recentTournaments => 'Letzte Turniere';

  @override
  String get noTournamentsYet => 'Noch keine Turniere erfasst.';

  @override
  String tournamentsLoadFailed(Object error) {
    return 'Turniere konnten nicht geladen werden.\n$error';
  }

  @override
  String get lossRate => 'Loss-Rate';

  @override
  String winsLossesSummary(int wins, int losses, int total) {
    return '$wins–$losses  ($wins Siege / $total Matches)';
  }

  @override
  String vsNameRange(String name, String rate, String range) {
    return 'vs. $name • $rate% ($range)';
  }

  @override
  String vsOpponent(String name) {
    return 'vs. $name';
  }

  @override
  String get noDecksYet =>
      'Noch keine Decks angelegt.\nTippe unten rechts auf +, um dein erstes Deck zu erstellen!';

  @override
  String get deleteDeckQuestion => 'Deck wirklich löschen?';

  @override
  String deleteDeckBody(String name) {
    return 'Das Deck \"$name\" und ALLE dazugehörigen Matches werden unwiderruflich gelöscht!';
  }

  @override
  String deckDeleted(String name) {
    return 'Deck \"$name\" gelöscht.';
  }

  @override
  String deckArchived(String name) {
    return 'Deck \"$name\" archiviert.';
  }

  @override
  String get linkOpenFailed => 'Link konnte nicht geöffnet werden.';

  @override
  String get matchSingular => 'Match';

  @override
  String get matchPlural => 'Matches';

  @override
  String get fillRequiredFields => 'Bitte alle Pflichtfelder ausfüllen.';

  @override
  String get invalidDecklistUrl => 'Bitte eine gültige Decklisten-URL angeben.';

  @override
  String get cardGame => 'Kartenspiel';

  @override
  String get deckName => 'Deck-Name';

  @override
  String get decklistLinkOptional => 'Decklisten-Link (optional)';

  @override
  String get notesOptional => 'Notizen (optional)';

  @override
  String get addDeck => 'Deck hinzufügen';

  @override
  String get editDeck => 'Deck bearbeiten';

  @override
  String get viewDecklist => 'Deckliste ansehen';

  @override
  String get noMatchesForDeck =>
      'Noch keine Matches für dieses Deck erfasst.\nKlicke unten auf +, um ein Match hinzuzufügen!';

  @override
  String get noMatchesForFilter => 'Keine Matches für diesen Filter gefunden.';

  @override
  String get deleteMatchQuestion => 'Match löschen?';

  @override
  String deleteMatchBody(String name) {
    return 'Möchtest du das Spiel gegen $name wirklich löschen?';
  }

  @override
  String get matchDeleted => 'Match gelöscht.';

  @override
  String statsTitle(String name) {
    return '$name - Stats';
  }

  @override
  String get noStatsYet =>
      'Noch keine Matches vorhanden, um Statistiken zu berechnen.';

  @override
  String get matchupsVsArchetypes => 'Matchups gegen Archetypen';

  @override
  String winsOfGames(int wins, int total) {
    return '$wins Siege von $total Spielen';
  }

  @override
  String get needDeckForMatch =>
      'Lege zuerst ein Deck an, um Matches zu erfassen.';

  @override
  String get noToolPresets => 'Keine Tool-Presets vorhanden.';

  @override
  String get recordMatch => 'Match erfassen';

  @override
  String get chooseOwnDeck => 'Eigenes Deck wählen';

  @override
  String get editMatch => 'Match bearbeiten';

  @override
  String get logMatch => 'Match eintragen';

  @override
  String get needOpponentDeck => 'Bitte das gegnerische Deck angeben.';

  @override
  String get win => 'Sieg';

  @override
  String get loss => 'Niederlage';

  @override
  String get draw => 'Unentschieden';

  @override
  String get opponentDeckArchetype => 'Gegnerisches Deck / Archetyp';

  @override
  String get opponentDeck => 'Gegnerisches Deck';

  @override
  String get format => 'Format';

  @override
  String get order => 'Reihenfolge';

  @override
  String get eventTags => 'Event-Tags';

  @override
  String get scoreOptional => 'Score (optional, z. B. 2-1)';

  @override
  String get rollTitle => 'Auslosen';

  @override
  String get d20 => 'D20';

  @override
  String get d6 => 'D6';

  @override
  String get coin => 'Münze';

  @override
  String get multi => 'Multi';

  @override
  String rollDie(int sides) {
    return 'D$sides würfeln';
  }

  @override
  String get flipCoin => 'Münze werfen';

  @override
  String rollMulti(int count, int sides) {
    return '$count×D$sides würfeln';
  }

  @override
  String get deleteTournamentQuestion => 'Turnier löschen?';

  @override
  String deleteTournamentBody(String name) {
    return '„$name“ wird unwiderruflich gelöscht.';
  }

  @override
  String tournamentDeleted(String name) {
    return '„$name“ gelöscht.';
  }

  @override
  String get noTournamentsHint =>
      'Noch keine Turniere erfasst.\nHalte Store Championships, Regionals und Opens fest.';

  @override
  String get needNameTcgDeck => 'Bitte Name, TCG und Deck ausfüllen.';

  @override
  String get placementMustBeNumber => 'Platzierung muss eine Zahl sein.';

  @override
  String get participantsMustBeNumber => 'Teilnehmerzahl muss eine Zahl sein.';

  @override
  String get placementMinOne => 'Platzierung muss mindestens 1 sein.';

  @override
  String get placementVsField =>
      'Platzierung darf nicht größer als die Teilnehmerzahl sein.';

  @override
  String get tournamentName => 'Turnier-Name';

  @override
  String get chooseTcg => 'TCG wählen';

  @override
  String get chooseGameFirst => 'Zuerst ein Kartenspiel wählen';

  @override
  String get noDecksForTcg => 'Keine Decks für dieses TCG';

  @override
  String get chooseDeck => 'Deck wählen';

  @override
  String get playedDeck => 'Gespieltes Deck';

  @override
  String get place => 'Platz';

  @override
  String get participants => 'Teilnehmern';

  @override
  String get date => 'Datum';

  @override
  String get addTournament => 'Turnier hinzufügen';

  @override
  String get editTournament => 'Turnier bearbeiten';

  @override
  String get noMatchingMatches => 'Keine passenden Matches gefunden.';

  @override
  String relatedMatchesCount(int count) {
    return '$count Matches zugeordnet';
  }

  @override
  String matchesLoadFailed(Object error) {
    return 'Matches konnten nicht geladen werden: $error';
  }

  @override
  String relatedMatchesTagsAndDeck(String deck) {
    return 'Matches mit denselben Tags und Deck „$deck“.';
  }

  @override
  String get relatedMatchesTags => 'Matches mit denselben Tags.';

  @override
  String get noPlacement => 'Keine Platzierung';

  @override
  String placementOf(int place, int total) {
    return '#$place / $total';
  }

  @override
  String get firstPlace => '1. Platz';

  @override
  String topPlacement(int place) {
    return 'Top $place';
  }

  @override
  String placeNumber(int place) {
    return 'Platz $place';
  }

  @override
  String get promoBadge => 'CARDMARKET PARTNER';

  @override
  String get promoHeadline => 'Finde Singles & Displays';

  @override
  String get promoSubtitle =>
      'Unterstütze die App mit deinem nächsten Deck-Upgrade.';

  @override
  String get promoView => 'Shoppen';

  @override
  String get promoDismiss => 'Banner ausblenden';

  @override
  String get promoOpenFailed =>
      'Der Partner-Link konnte nicht geöffnet werden.';

  @override
  String get promoSettingsTitle => 'Partner-Empfehlungen & Banner';

  @override
  String get promoSettingsSubtitle =>
      'Unterstütze das Projekt durch dezente Community-Links';

  @override
  String get toolsTabChakra => 'Chakra (Naruto)';

  @override
  String get toolsTabLife => 'Life Counter';

  @override
  String get toolsTabTimer => 'Runden-Timer';

  @override
  String get chakraReadyLabel => 'Verfügbares Chakra (Ready)';

  @override
  String chakraReadyRatio(int available, int total) {
    return '$available / $total Ready';
  }

  @override
  String chakraTappedHint(int tapped) {
    return '$tapped getappt';
  }

  @override
  String get chakraPay1 => '-1 Chakra zahlen';

  @override
  String get chakraPay2 => '-2 Chakra zahlen';

  @override
  String get chakraEndTurn => 'Runde beenden / Neuer Zug';

  @override
  String get chakraRefreshOnly => 'Refresh Only';

  @override
  String get chakraDeckTitle => 'Chakra-Deck';

  @override
  String chakraDeckRemaining(int remaining) {
    return '$remaining / 12 übrig';
  }

  @override
  String get chakraZoneMax => 'Chakra-Zone Max';

  @override
  String get chakraResetTurn1 => 'Reset auf Zug 1';

  @override
  String get lifeYou => 'Du';

  @override
  String get lifeOpponent => 'Gegner';

  @override
  String get lifePresetMtg => '20 MTG';

  @override
  String get lifePresetOp => '50 OP';

  @override
  String get lifePresetYgo => '8000 YGO';

  @override
  String get timerStart => 'Start';

  @override
  String get timerPause => 'Pause';

  @override
  String get timerPreset30 => '30 Min';

  @override
  String get timerPreset45 => '45 Min';

  @override
  String get timerPreset50 => '50 Min';

  @override
  String get toolsTabDice => 'Würfel & Münze';

  @override
  String get coinHeads => 'Kopf';

  @override
  String get coinTails => 'Zahl';

  @override
  String get randomStarter => 'Zufälliger Startspieler';

  @override
  String starterResult(String name) {
    return '$name fängt an';
  }

  @override
  String get playerOne => 'Spieler 1';

  @override
  String get playerTwo => 'Spieler 2';

  @override
  String get saveMatch => 'Match speichern';

  @override
  String get displayNameLabel => 'Anzeigename';

  @override
  String get editDisplayNameTitle => 'Anzeigename ändern';

  @override
  String get displayNameHint => 'Spielername';

  @override
  String get displayNameSaved => 'Anzeigename gespeichert.';

  @override
  String displayNameFailed(Object error) {
    return 'Anzeigename konnte nicht geändert werden: $error';
  }

  @override
  String get changePasswordTitle => 'Passwort ändern';

  @override
  String get changePasswordSubtitle => 'Neues Passwort für dieses Konto setzen';

  @override
  String get newPassword => 'Neues Passwort';

  @override
  String get confirmPassword => 'Passwort bestätigen';

  @override
  String get passwordTooShort =>
      'Das Passwort muss mindestens 6 Zeichen haben.';

  @override
  String get passwordsMismatch => 'Die Passwörter stimmen nicht überein.';

  @override
  String get passwordUpdated => 'Passwort aktualisiert.';

  @override
  String passwordUpdateFailed(Object error) {
    return 'Passwort konnte nicht geändert werden: $error';
  }

  @override
  String get legalTrademarksTitle => 'Marken- & Urheberrechts-Disclaimer';

  @override
  String get legalTrademarksBody =>
      'Alle erwähnten Markennamen, Spielbezeichnungen, Logos und Trademarks (u. a. Pokémon, Magic: The Gathering, Yu-Gi-Oh!, One Piece, Naruto Mythos, Riftbound) sind eingetragene Warenzeichen ihrer jeweiligen Eigentümer. Diese App ist ein inoffizielles Fan-Projekt und steht in keiner geschäftlichen oder offiziellen Verbindung zu den Rechteinhabern.';

  @override
  String get legalPrivacyStructuredTitle => 'Datenschutzerklärung (DSGVO)';

  @override
  String get legalPrivacyStructuredBody =>
      'Zur Bereitstellung der App-Funktionen verarbeiten wir Kontodaten (E-Mail-Adresse, Spielstände, Decks und Matches) über Supabase. Du hast das Recht auf Auskunft, Datenexport (JSON/CSV-Backup in den Einstellungen) und die vollständige Löschung deines Accounts direkt in den Einstellungen. Es erfolgt keine Weitergabe an Dritte zu Werbezwecken.';

  @override
  String get legalAffiliateTitle => 'Affiliate- & Partner-Hinweis';

  @override
  String get legalAffiliateBody =>
      'Diese App enthält Empfehlungs- und Partnerlinks (z. B. zu Cardmarket). Bei Käufen über diese Links erhalten wir gegebenenfalls eine Provision oder Werbegutschrift, ohne dass für den Nutzer zusätzliche Kosten entstehen.';

  @override
  String get legalContactStructuredTitle => 'Kontakt & Impressum';

  @override
  String get legalContactStructuredBody =>
      'Für Support und rechtliche Anfragen nutze das Projekt-Repository:\nhttps://github.com/Patrike260/tcg_counter_app';

  @override
  String get legalGithub => 'GitHub-Repository';

  @override
  String get themeModeLabel => 'Modus';

  @override
  String get themeModeSystem => 'System';

  @override
  String get themeModeLight => 'Hell';

  @override
  String get themeModeDark => 'Dunkel';

  @override
  String get presetCyberpunk => 'Cyberpunk';

  @override
  String get presetPaper => 'Paper Manga';

  @override
  String get presetCrimson => 'Crimson';

  @override
  String get presetCell => 'Cell Green';

  @override
  String get deckWinRateNew => 'Neu';

  @override
  String deckWinRateBadge(int percent, int count) {
    return '$percent% • ${count}G';
  }

  @override
  String get chakraPoolLabel => 'Chakra gezahlt / Pool';

  @override
  String get chakraPointsLabel => 'Punkte';

  @override
  String get chakraResetBoard => 'Board zurücksetzen';

  @override
  String get toolsTabDigimon => 'Digimon Memory';

  @override
  String get digimonTurnP1 => 'Zug: Spieler 1';

  @override
  String get digimonTurnP2 => 'Zug: Spieler 2';

  @override
  String get digimonTurnPass => 'Turn Pass';

  @override
  String get digimonSpend => 'Memory ausgeben';

  @override
  String get digimonCorrect => 'Korrektur';

  @override
  String get digimonResetZero => 'Reset auf 0';

  @override
  String get chakraCounterLabel => 'Chakra';

  @override
  String get lifePresetMtg60 => 'Magic 60-Card';

  @override
  String get lifePresetCommander => 'Commander';

  @override
  String get lifePresetYgoName => 'Yu-Gi-Oh!';

  @override
  String get lifePresetAdd => 'Preset anlegen';

  @override
  String get lifePresetName => 'Name';

  @override
  String get lifePresetStartLp => 'Start-LP';

  @override
  String get lifePresetStepSmall => 'Tipp (±)';

  @override
  String get lifePresetStepLarge => 'Long-Press (±)';

  @override
  String get lifePresetInvalid =>
      'Bitte Name und gültige Zahlen größer 0 eingeben.';

  @override
  String get deckSortNewest => 'Neueste';

  @override
  String get deckSortGrouped => 'Nach TCG';

  @override
  String get deckSortCustom => 'Sortieren';

  @override
  String deckGroupHeader(String game, int count) {
    return '$game ($count Decks)';
  }
}
