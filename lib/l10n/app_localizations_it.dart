// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'TCG Tracker';

  @override
  String get cancel => 'Annulla';

  @override
  String get save => 'Salva';

  @override
  String get delete => 'Elimina';

  @override
  String get add => 'Aggiungi';

  @override
  String get close => 'Chiudi';

  @override
  String get continueAction => 'Continua';

  @override
  String get apply => 'Applica';

  @override
  String get create => 'Crea';

  @override
  String get reset => 'Reimposta';

  @override
  String get all => 'Tutti';

  @override
  String get edit => 'Modifica';

  @override
  String get archive => 'Archivia';

  @override
  String get or => 'OPPURE';

  @override
  String get from => 'di';

  @override
  String get version => 'Versione';

  @override
  String get versionSubtitle => 'Web / PWA';

  @override
  String errorWithDetails(Object error) {
    return 'Errore: $error';
  }

  @override
  String loadErrorWithDetails(Object error) {
    return 'Impossibile caricare: $error';
  }

  @override
  String gamesLoadError(Object error) {
    return 'Impossibile caricare i giochi: $error';
  }

  @override
  String decksLoadError(Object error) {
    return 'Impossibile caricare i mazzi: $error';
  }

  @override
  String get noUserLoggedIn => 'Nessun utente collegato';

  @override
  String userIdShort(String id) {
    return 'ID: $id...';
  }

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navDecks => 'Mazzi';

  @override
  String get navTools => 'Strumenti';

  @override
  String get navSettings => 'Impostazioni';

  @override
  String get titleMyDecks => 'I miei mazzi';

  @override
  String get tooltipDashboardFilter => 'Filtri dashboard';

  @override
  String get tooltipDiceCoin => 'Moneta e dadi';

  @override
  String get noTcg => 'Nessun TCG';

  @override
  String get turnFree => 'Turno libero';

  @override
  String get turnFirstShort => '1st';

  @override
  String get turnSecondShort => '2nd';

  @override
  String get turnFirstFull => '1st (primo)';

  @override
  String get turnSecondFull => '2nd (secondo)';

  @override
  String get formatBo1 => 'Best of 1';

  @override
  String get formatBo3 => 'Best of 3';

  @override
  String get bo1 => 'BO1';

  @override
  String get bo3 => 'BO3';

  @override
  String get allFormats => 'Tutti i formati';

  @override
  String get languageTitle => 'Lingua';

  @override
  String get languageSubtitle => 'Scegli la lingua dell’app';

  @override
  String get languageSystem => 'Lingua di sistema';

  @override
  String get languageSystemSubtitle => 'Segui la lingua del dispositivo';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageItalian => 'Italiano';

  @override
  String get loginTitle => 'Accesso TCG Tracker';

  @override
  String get createAccount => 'Crea account';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Password';

  @override
  String get signIn => 'Accedi';

  @override
  String get register => 'Registrati';

  @override
  String get alreadyHaveAccount => 'Hai già un account? Accedi';

  @override
  String get noAccountYet => 'Non hai un account? Registrati';

  @override
  String get continueWithGoogle => 'Continua con Google';

  @override
  String get enterEmailPassword => 'Inserisci e-mail e password.';

  @override
  String get registrationSuccess => 'Registrazione riuscita!';

  @override
  String googleLoginFailed(Object error) {
    return 'Accesso Google non riuscito: $error';
  }

  @override
  String get legalAcceptHint =>
      'Registrandoti accetti i Termini di utilizzo e l’informativa sulla privacy.';

  @override
  String get sectionAppearance => 'ASPETTO / DESIGN';

  @override
  String get sectionSettings => 'IMPOSTAZIONI';

  @override
  String get sectionContent => 'GESTIONE E CONTENUTI';

  @override
  String get sectionBackup => 'DATI E BACKUP';

  @override
  String get sectionAccount => 'ACCOUNT E INFO';

  @override
  String get themePresetsTitle => 'Schema colori e temi';

  @override
  String get dashboardTabsTitle => 'Configura schede e riquadri';

  @override
  String get dashboardTabsSubtitle => 'Ordine, schede e widget visibili';

  @override
  String get matchDefaultsTitle => 'Match e impostazioni predefinite';

  @override
  String get visibleTcgsTitle => 'TCG visibili';

  @override
  String get visibleTcgsSubtitle => 'Nascondi giochi dai menu a tendina';

  @override
  String get manageTcgsTitle => 'Gestisci i giochi (TCG)';

  @override
  String get manageTcgsSubtitle => 'Aggiungi o rinomina i giochi';

  @override
  String get toolPresetsTitle => 'Gestisci preset strumenti';

  @override
  String get toolPresetsSubtitle => 'Life counter, giocatori e timer';

  @override
  String get tournamentsTitle => 'Tornei ed eventi';

  @override
  String get tournamentsSubtitle => 'Registra piazzamenti e mazzi giocati';

  @override
  String get archetypesTitle => 'Gestisci archetipi avversari';

  @override
  String get archetypesSubtitle => 'Rinomina o pulisci i suggerimenti';

  @override
  String get eventTagsTitle => 'Gestisci tag evento';

  @override
  String get eventTagsSubtitle => 'Crea tag per tornei o coppe';

  @override
  String get exportCsvTitle => 'Esporta match in CSV';

  @override
  String get exportCsvSubtitle => 'Ideale per Excel o fogli di calcolo';

  @override
  String get exportJsonTitle => 'Backup completo (JSON)';

  @override
  String get exportJsonSubtitle => 'Salva tutti i mazzi e lo storico match';

  @override
  String get restoreBackupTitle => 'Ripristina backup';

  @override
  String get restoreBackupSubtitle => 'Importa un file JSON';

  @override
  String get legalSettingsTitle => 'Termini e privacy';

  @override
  String get legalSettingsSubtitle => 'Impressum, disclaimer e GDPR';

  @override
  String get signOutTitle => 'Esci';

  @override
  String get signOutSubtitle => 'Termina la sessione';

  @override
  String get deleteAccountTitle => 'Elimina account in modo permanente';

  @override
  String get deleteAccountSubtitle => 'Rimuovi account, mazzi e match';

  @override
  String get csvExported => 'Match esportati in CSV!';

  @override
  String csvExportFailed(Object error) {
    return 'Esportazione CSV non riuscita: $error';
  }

  @override
  String get jsonBackupCreated => 'Backup JSON creato!';

  @override
  String jsonBackupFailed(Object error) {
    return 'Esportazione backup non riuscita: $error';
  }

  @override
  String get fileReadFailed => 'Impossibile leggere il file.';

  @override
  String get restoreBackupQuestion => 'Ripristinare il backup?';

  @override
  String get restoreBackupBody =>
      'I mazzi e i match esistenti verranno uniti o aggiornati.';

  @override
  String get restore => 'Ripristina';

  @override
  String matchesRestored(int count) {
    return '$count match ripristinati!';
  }

  @override
  String restoreFailed(Object error) {
    return 'Ripristino non riuscito: $error';
  }

  @override
  String get deleteAccountQuestion => 'Eliminare l’account?';

  @override
  String get deleteAccountBody =>
      'Vuoi davvero eliminare in modo definitivo l’account e tutti i mazzi e i match salvati?';

  @override
  String get lastConfirmation => 'Conferma finale';

  @override
  String get deleteAccountFinalBody =>
      'L’azione non è reversibile. L’account e tutti i dati del tracker verranno eliminati.';

  @override
  String get deletePermanently => 'Elimina definitivamente';

  @override
  String deleteAccountFailed(Object error) {
    return 'Impossibile eliminare l’account: $error';
  }

  @override
  String get legalScreenTitle => 'Note legali e privacy';

  @override
  String get legalIntro =>
      'Leggi le seguenti informazioni prima di usare l’app o creare un account.';

  @override
  String get legalTermsTitle => 'Termini di utilizzo';

  @override
  String get legalTermsBody =>
      'TCG Tracker è un progetto fan privato e non ufficiale. L’app serve a registrare i tuoi mazzi, i match e i piazzamenti nei tornei al tavolo. Non è un’offerta commerciale né un prodotto ufficiale degli editori di carte.\n\nL’uso è a tuo rischio. Non c’è garanzia di disponibilità continua, assenza di errori o conservazione dei dati. La perdita di dati (guasti, cancellazione account, modifiche al servizio) non è esclusa. Fai backup propri se necessario.\n\nL’app è solo per uso privato. Abuso, scraping di altri account o elusione della sicurezza non sono consentiti.';

  @override
  String get legalPrivacyTitle => 'Privacy (GDPR)';

  @override
  String get legalPrivacyBody =>
      'Il titolare del trattamento ai sensi del GDPR è il gestore di questa app (vedi impressum).\n\nMemorizziamo in particolare: e-mail (account), dati di autenticazione e i contenuti che inserisci (mazzi, risultati, note, tag, tornei). L’archiviazione avviene nel cloud Supabase (PostgreSQL con RLS).\n\nLo scopo è fornire il tracker (esecuzione del contratto, art. 6 par. 1 lett. b GDPR). Nessuna cessione a terzi per pubblicità. I fornitori tecnici (hosting/auth) trattano i dati solo per il funzionamento.\n\nHai diritto di accesso, rettifica, limitazione, opposizione e cancellazione. Usa «Elimina account in modo permanente» nelle impostazioni.';

  @override
  String get legalDisclaimerTitle => 'Marchi e copyright';

  @override
  String get legalDisclaimerBody =>
      'Pokémon, One Piece, Yu-Gi-Oh!, Magic: The Gathering, Dragon Ball Super e tutti gli altri giochi, personaggi, loghi e nomi citati sono marchi o opere protette dei rispettivi titolari, tra cui Nintendo, The Pokémon Company, Bandai, Toei Animation, Konami, Wizards of the Coast / Hasbro e altri licenzianti.\n\nL’app non è affiliata a queste aziende. È un progetto fan indipendente. I nomi dei giochi servono solo a tracciare le tue partite. Non vengono vendute o concesse immagini ufficiali delle carte.';

  @override
  String get legalImprintTitle => 'Impressum e contatti';

  @override
  String get legalImprintBody =>
      'Informazioni legali:\n\nGestore / sviluppatore:\n[Nome e cognome]\n[Via e numero]\n[CAP Città]\nGermania\n\nContatto:\nE-mail: kontakt@example.com\n\nSostituisci i segnaposto con i dati reali prima di un uso pubblico.';

  @override
  String get themeScreenTitle => 'Schema colori e design';

  @override
  String get themeLight => 'CHIARO';

  @override
  String get themeDark => 'SCURO';

  @override
  String get matchSettingsTitle => 'Impostazioni match';

  @override
  String get defaultGame => 'Gioco di carte predefinito';

  @override
  String get defaultFormat => 'Formato match predefinito';

  @override
  String get defaultTurnOrder => 'Ordine di turno predefinito';

  @override
  String get turnFreeLabel => 'Libero';

  @override
  String get rememberLastTags => 'Ricorda gli ultimi tag';

  @override
  String get statsTimeRange => 'Periodo delle statistiche';

  @override
  String get statsTimeRangeSubtitle =>
      'Si applica a winrate, nemesi e performance TCG';

  @override
  String get dashboardGameFocus => 'Gioco in evidenza nella dashboard';

  @override
  String get dashboardGamePickerTitle => 'Gioco dashboard';

  @override
  String get rangeWeek => 'Settimana';

  @override
  String get rangeMonth => 'Mese';

  @override
  String get rangeSeason => 'Stagione';

  @override
  String get rangeYear => 'Anno';

  @override
  String get rangeAllTime => 'Tutto';

  @override
  String get visibleTcgsScreenTitle => 'TCG visibili';

  @override
  String get noGamesAvailable => 'Nessun gioco di carte.';

  @override
  String get atLeastOneTcgVisible => 'Almeno un TCG deve restare visibile.';

  @override
  String get addTcgTitle => 'Aggiungi un TCG';

  @override
  String get renameTcgTitle => 'Rinomina TCG';

  @override
  String get gameNameLabel => 'Nome del gioco';

  @override
  String get newName => 'Nuovo nome';

  @override
  String get manageTcgsScreenTitle => 'Gestisci i giochi (TCG)';

  @override
  String get toolPresetsScreenTitle => 'Preset strumenti';

  @override
  String get factoryResetQuestion => 'Ripristinare i valori predefiniti?';

  @override
  String get noPresets => 'Nessun preset.';

  @override
  String get keepOnePreset => 'Deve restare almeno un preset.';

  @override
  String get enterNameAndLp => 'Inserisci nome e LP iniziali validi.';

  @override
  String get playerCount => 'Numero di giocatori';

  @override
  String get roundTimer => 'Timer del round';

  @override
  String get minutes => 'Minuti';

  @override
  String minutesValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get presetName => 'Nome';

  @override
  String get startingLp => 'LP iniziali';

  @override
  String get createTagTitle => 'Crea un nuovo tag';

  @override
  String get tagNameHint => 'Nome tag (es. Store Cup, League)';

  @override
  String get manageTagsScreenTitle => 'Gestisci tag evento';

  @override
  String get standardTagsHeader => 'TAG STANDARD (FISSI)';

  @override
  String get systemTagSubtitle => 'Tag di sistema (non eliminabile)';

  @override
  String get customTagsHeader => 'TAG PERSONALIZZATI';

  @override
  String get createTag => 'Crea tag';

  @override
  String get noCustomTags => 'Nessun tag personalizzato.';

  @override
  String get deleteArchetypeQuestion => 'Eliminare l’archetipo?';

  @override
  String deleteArchetypeBody(String name) {
    return 'Rimuovere \"$name\" dai suggerimenti automatici?';
  }

  @override
  String itemDeleted(String name) {
    return '\"$name\" eliminato.';
  }

  @override
  String deleteFailed(Object error) {
    return 'Eliminazione non riuscita: $error';
  }

  @override
  String get renameArchetypeTitle => 'Rinomina archetipo';

  @override
  String renamedTo(String name) {
    return 'Rinominato in \"$name\".';
  }

  @override
  String renameFailed(Object error) {
    return 'Rinomina non riuscita: $error';
  }

  @override
  String get archetypesScreenTitle => 'Gestisci archetipi avversari';

  @override
  String get chooseCardGame => 'Scegli il gioco';

  @override
  String get noArchetypesForGame => 'Nessun archetipo per questo TCG.';

  @override
  String get dashboardConfigTitle => 'Configura dashboard';

  @override
  String get resetToDefault => 'Ripristina predefinito';

  @override
  String get resetDashboardQuestion => 'Ripristinare i valori predefiniti?';

  @override
  String get atLeastOneTab => 'Almeno una scheda deve restare attiva.';

  @override
  String get allEvents => 'Tutti gli eventi';

  @override
  String get focusEventTag => 'Tag evento in evidenza';

  @override
  String get focusEventTagOptional => 'Tag evento (opzionale)';

  @override
  String get customDashboard => 'Dashboard personalizzata';

  @override
  String get tabTitle => 'Titolo';

  @override
  String get icon => 'Icona';

  @override
  String get startTiles => 'Riquadri iniziali';

  @override
  String get widgetWinrate => 'Winrate complessivo';

  @override
  String get widgetNemesis => 'Nemesi e miglior matchup';

  @override
  String get widgetPerformance => 'Performance per gioco';

  @override
  String get widgetRecent => 'Match recenti';

  @override
  String get widgetTournaments => 'Tornei e piazzamenti';

  @override
  String get widgetTurnOrder => 'Statistiche 1st / 2nd';

  @override
  String get tabAllround => 'Allround';

  @override
  String get tabTournament => 'Torneo';

  @override
  String get tabMinimal => 'Minimale';

  @override
  String get noDashboardTab => 'Nessuna scheda dashboard attiva.';

  @override
  String eventFilter(String tag) {
    return 'Evento: $tag';
  }

  @override
  String get winrate => 'Winrate';

  @override
  String get matches => 'Match';

  @override
  String get wins => 'Vittorie';

  @override
  String get recorded => 'Registrati';

  @override
  String winsOfTotal(int total) {
    return 'su $total';
  }

  @override
  String get noMatchesInRange => 'Nessun match nel periodo selezionato';

  @override
  String noRepeatMatchups(String range) {
    return 'Nessun match contro archetipi ripetuti nel periodo ($range).\nServono almeno 2 match contro lo stesso mazzo.';
  }

  @override
  String get bestMatchup => 'Matchup più forte';

  @override
  String get nemesisDeck => 'Nemesi / mazzo problema';

  @override
  String get performanceByGame => 'Performance per gioco';

  @override
  String get noMatchesVisibleTcgs => 'Ancora nessun match per i TCG visibili.';

  @override
  String winsOfMatches(int wins, int total) {
    return '$wins vittorie su $total match';
  }

  @override
  String get recentMatches => 'Match recenti';

  @override
  String get turnOrder => 'Ordine di turno';

  @override
  String get first => 'First';

  @override
  String get second => 'Second';

  @override
  String winsFraction(int wins, int total) {
    return '$wins/$total vittorie';
  }

  @override
  String get recentTournaments => 'Tornei recenti';

  @override
  String get noTournamentsYet => 'Nessun torneo registrato.';

  @override
  String tournamentsLoadFailed(Object error) {
    return 'Impossibile caricare i tornei.\n$error';
  }

  @override
  String get lossRate => 'Tasso di sconfitte';

  @override
  String winsLossesSummary(int wins, int losses, int total) {
    return '$wins–$losses  ($wins vittorie / $total match)';
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
      'Nessun mazzo ancora.\nTocca + in basso a destra per crearne uno!';

  @override
  String get deleteDeckQuestion => 'Eliminare questo mazzo?';

  @override
  String deleteDeckBody(String name) {
    return 'Il mazzo \"$name\" e TUTTI i match correlati verranno eliminati definitivamente!';
  }

  @override
  String deckDeleted(String name) {
    return 'Mazzo \"$name\" eliminato.';
  }

  @override
  String deckArchived(String name) {
    return 'Mazzo \"$name\" archiviato.';
  }

  @override
  String get linkOpenFailed => 'Impossibile aprire il link.';

  @override
  String get matchSingular => 'match';

  @override
  String get matchPlural => 'match';

  @override
  String get fillRequiredFields => 'Compila tutti i campi obbligatori.';

  @override
  String get invalidDecklistUrl => 'Inserisci un URL decklist valido.';

  @override
  String get cardGame => 'Gioco di carte';

  @override
  String get deckName => 'Nome del mazzo';

  @override
  String get decklistLinkOptional => 'Link decklist (opzionale)';

  @override
  String get notesOptional => 'Note (opzionale)';

  @override
  String get addDeck => 'Aggiungi mazzo';

  @override
  String get editDeck => 'Modifica mazzo';

  @override
  String get viewDecklist => 'Vedi decklist';

  @override
  String get noMatchesForDeck =>
      'Nessun match per questo mazzo.\nTocca + in basso per aggiungerne uno!';

  @override
  String get noMatchesForFilter => 'Nessun match per questo filtro.';

  @override
  String get deleteMatchQuestion => 'Eliminare il match?';

  @override
  String deleteMatchBody(String name) {
    return 'Vuoi davvero eliminare la partita contro $name?';
  }

  @override
  String get matchDeleted => 'Match eliminato.';

  @override
  String statsTitle(String name) {
    return '$name - Stats';
  }

  @override
  String get noStatsYet => 'Nessun match per calcolare le statistiche.';

  @override
  String get matchupsVsArchetypes => 'Matchup contro archetipi';

  @override
  String winsOfGames(int wins, int total) {
    return '$wins vittorie su $total partite';
  }

  @override
  String get needDeckForMatch => 'Crea prima un mazzo per registrare i match.';

  @override
  String get noToolPresets => 'Nessun preset strumento.';

  @override
  String get recordMatch => 'Registra match';

  @override
  String get chooseOwnDeck => 'Scegli il tuo mazzo';

  @override
  String get editMatch => 'Modifica match';

  @override
  String get logMatch => 'Inserisci match';

  @override
  String get needOpponentDeck => 'Inserisci il mazzo avversario.';

  @override
  String get win => 'Vittoria';

  @override
  String get loss => 'Sconfitta';

  @override
  String get draw => 'Pareggio';

  @override
  String get opponentDeckArchetype => 'Mazzo / archetipo avversario';

  @override
  String get opponentDeck => 'Mazzo avversario';

  @override
  String get format => 'Formato';

  @override
  String get order => 'Ordine';

  @override
  String get eventTags => 'Tag evento';

  @override
  String get scoreOptional => 'Punteggio (opzionale, es. 2-1)';

  @override
  String get rollTitle => 'Sorteggio';

  @override
  String get d20 => 'D20';

  @override
  String get d6 => 'D6';

  @override
  String get coin => 'Moneta';

  @override
  String get multi => 'Multi';

  @override
  String rollDie(int sides) {
    return 'Tira D$sides';
  }

  @override
  String get flipCoin => 'Lancia la moneta';

  @override
  String rollMulti(int count, int sides) {
    return 'Tira $count×D$sides';
  }

  @override
  String get deleteTournamentQuestion => 'Eliminare il torneo?';

  @override
  String deleteTournamentBody(String name) {
    return '“$name” verrà eliminato definitivamente.';
  }

  @override
  String tournamentDeleted(String name) {
    return '“$name” eliminato.';
  }

  @override
  String get noTournamentsHint =>
      'Nessun torneo ancora.\nRegistra store championship, regional e open.';

  @override
  String get needNameTcgDeck => 'Compila nome, TCG e mazzo.';

  @override
  String get placementMustBeNumber => 'Il piazzamento deve essere un numero.';

  @override
  String get participantsMustBeNumber =>
      'Il numero di partecipanti deve essere un numero.';

  @override
  String get placementMinOne => 'Il piazzamento deve essere almeno 1.';

  @override
  String get placementVsField =>
      'Il piazzamento non può superare il numero di partecipanti.';

  @override
  String get tournamentName => 'Nome del torneo';

  @override
  String get chooseTcg => 'Scegli TCG';

  @override
  String get chooseGameFirst => 'Scegli prima un gioco';

  @override
  String get noDecksForTcg => 'Nessun mazzo per questo TCG';

  @override
  String get chooseDeck => 'Scegli mazzo';

  @override
  String get playedDeck => 'Mazzo giocato';

  @override
  String get place => 'Posto';

  @override
  String get participants => 'Partecipanti';

  @override
  String get date => 'Data';

  @override
  String get addTournament => 'Aggiungi torneo';

  @override
  String get editTournament => 'Modifica torneo';

  @override
  String get noMatchingMatches => 'Nessun match corrispondente.';

  @override
  String relatedMatchesCount(int count) {
    return '$count match associati';
  }

  @override
  String matchesLoadFailed(Object error) {
    return 'Impossibile caricare i match: $error';
  }

  @override
  String relatedMatchesTagsAndDeck(String deck) {
    return 'Match con gli stessi tag e il mazzo “$deck”.';
  }

  @override
  String get relatedMatchesTags => 'Match con gli stessi tag.';

  @override
  String get noPlacement => 'Nessun piazzamento';

  @override
  String placementOf(int place, int total) {
    return '#$place / $total';
  }

  @override
  String get firstPlace => '1° posto';

  @override
  String topPlacement(int place) {
    return 'Top $place';
  }

  @override
  String placeNumber(int place) {
    return 'Posto $place';
  }

  @override
  String get promoBadge => 'CARDMARKET PARTNER';

  @override
  String get promoHeadline => 'Trova singles e display';

  @override
  String get promoSubtitle =>
      'Sostieni l’app con il tuo prossimo upgrade del mazzo.';

  @override
  String get promoView => 'Acquista';

  @override
  String get promoDismiss => 'Nascondi banner';

  @override
  String get promoOpenFailed => 'Impossibile aprire il link partner.';

  @override
  String get promoSettingsTitle => 'Consigli partner e banner';

  @override
  String get promoSettingsSubtitle =>
      'Sostieni il progetto con link community discreti';

  @override
  String get toolsTabChakra => 'Chakra (Naruto)';

  @override
  String get toolsTabLife => 'Life Counter';

  @override
  String get toolsTabTimer => 'Timer round';

  @override
  String get chakraReadyLabel => 'Chakra disponibile (Ready)';

  @override
  String chakraReadyRatio(int available, int total) {
    return '$available / $total Ready';
  }

  @override
  String chakraTappedHint(int tapped) {
    return '$tapped tappati';
  }

  @override
  String get chakraPay1 => 'Paga 1 chakra';

  @override
  String get chakraPay2 => 'Paga 2 chakra';

  @override
  String get chakraEndTurn => 'Fine round / Nuovo turno';

  @override
  String get chakraRefreshOnly => 'Refresh only';

  @override
  String get chakraDeckTitle => 'Chakra-deck';

  @override
  String chakraDeckRemaining(int remaining) {
    return '$remaining / 12 rimasti';
  }

  @override
  String get chakraZoneMax => 'Zona chakra max';

  @override
  String get chakraResetTurn1 => 'Reset al turno 1';

  @override
  String get lifeYou => 'Tu';

  @override
  String get lifeOpponent => 'Avversario';

  @override
  String get lifePresetMtg => '20 MTG';

  @override
  String get lifePresetOp => '50 OP';

  @override
  String get lifePresetYgo => '8000 YGO';

  @override
  String get timerStart => 'Start';

  @override
  String get timerPause => 'Pausa';

  @override
  String get timerPreset30 => '30 min';

  @override
  String get timerPreset45 => '45 min';

  @override
  String get timerPreset50 => '50 min';

  @override
  String get toolsTabDice => 'Dadi e moneta';

  @override
  String get toolsTabRiftbound => 'Punteggio Riftbound';

  @override
  String get coinHeads => 'Testa';

  @override
  String get coinTails => 'Croce';

  @override
  String get randomStarter => 'Primo giocatore casuale';

  @override
  String starterResult(String name) {
    return 'Inizia $name';
  }

  @override
  String get playerOne => 'Giocatore 1';

  @override
  String get playerTwo => 'Giocatore 2';

  @override
  String get riftboundGoal => 'Punti per vincere';

  @override
  String get riftboundGoal8 => '8 pt';

  @override
  String get riftboundGoal10 => '10 pt';

  @override
  String get riftboundWinBadge => 'Vittoria!';

  @override
  String get riftboundPlusBattlefield => '+1 campo di battaglia';

  @override
  String get saveMatch => 'Salva match';

  @override
  String get displayNameLabel => 'Nome visualizzato';

  @override
  String get editDisplayNameTitle => 'Cambia nome visualizzato';

  @override
  String get displayNameHint => 'Nome giocatore';

  @override
  String get displayNameSaved => 'Nome visualizzato aggiornato.';

  @override
  String displayNameFailed(Object error) {
    return 'Impossibile aggiornare il nome: $error';
  }

  @override
  String get changePasswordTitle => 'Cambia password';

  @override
  String get changePasswordSubtitle =>
      'Imposta una nuova password per l’account';

  @override
  String get newPassword => 'Nuova password';

  @override
  String get confirmPassword => 'Conferma password';

  @override
  String get passwordTooShort => 'La password deve avere almeno 6 caratteri.';

  @override
  String get passwordsMismatch => 'Le password non coincidono.';

  @override
  String get passwordUpdated => 'Password aggiornata.';

  @override
  String passwordUpdateFailed(Object error) {
    return 'Impossibile aggiornare la password: $error';
  }

  @override
  String get legalTrademarksTitle => 'Marchi e diritto d’autore';

  @override
  String get legalTrademarksBody =>
      'Tutti i marchi, nomi di giochi, loghi e trademark citati (tra cui Pokémon, Magic: The Gathering, Yu-Gi-Oh!, One Piece, Naruto Mythos, Riftbound) sono marchi registrati dei rispettivi titolari. Questa app è un progetto fan non ufficiale e non ha alcun rapporto commerciale o ufficiale con i titolari dei diritti.';

  @override
  String get legalPrivacyStructuredTitle => 'Informativa sulla privacy (GDPR)';

  @override
  String get legalPrivacyStructuredBody =>
      'Trattiamo i dati dell’account (e-mail, statistiche di gioco, mazzi e match) tramite Supabase solo per fornire l’app. Hai diritto di accesso, esportazione (backup JSON/CSV nelle impostazioni) e cancellazione completa dell’account dalle impostazioni. Nessuna cessione a terzi per pubblicità.';

  @override
  String get legalAffiliateTitle => 'Affiliazione e partner';

  @override
  String get legalAffiliateBody =>
      'L’app contiene link di raccomandazione e affiliazione (ad es. Cardmarket). Gli acquisti tramite questi link possono generarci una commissione o un credito pubblicitario, senza costi extra per te.';

  @override
  String get legalContactStructuredTitle => 'Contatti e impressum';

  @override
  String get legalContactStructuredBody =>
      'Per supporto e richieste legali usa il repository del progetto:\nhttps://github.com/Patrike260/tcg_counter_app';

  @override
  String get legalGithub => 'Repository GitHub';

  @override
  String get themeModeLabel => 'Modalità';

  @override
  String get themeModeSystem => 'Sistema';

  @override
  String get themeModeLight => 'Chiaro';

  @override
  String get themeModeDark => 'Scuro';

  @override
  String get presetCyberpunk => 'Cyberpunk';

  @override
  String get presetPaper => 'Paper Manga';

  @override
  String get presetCrimson => 'Crimson';

  @override
  String get presetCell => 'Cell Green';

  @override
  String get deckWinRateNew => 'Nuovo';

  @override
  String deckWinRateBadge(int percent, int count) {
    return '$percent% • ${count}G';
  }
}
