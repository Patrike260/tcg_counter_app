// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'TCG Tracker';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get add => 'Add';

  @override
  String get close => 'Close';

  @override
  String get continueAction => 'Continue';

  @override
  String get apply => 'Apply';

  @override
  String get create => 'Create';

  @override
  String get reset => 'Reset';

  @override
  String get all => 'All';

  @override
  String get edit => 'Edit';

  @override
  String get archive => 'Archive';

  @override
  String get or => 'OR';

  @override
  String get from => 'of';

  @override
  String get version => 'Version';

  @override
  String get versionSubtitle => 'Web / PWA';

  @override
  String errorWithDetails(Object error) {
    return 'Error: $error';
  }

  @override
  String loadErrorWithDetails(Object error) {
    return 'Could not load: $error';
  }

  @override
  String gamesLoadError(Object error) {
    return 'Could not load games: $error';
  }

  @override
  String decksLoadError(Object error) {
    return 'Could not load decks: $error';
  }

  @override
  String get noUserLoggedIn => 'No user signed in';

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
  String get navSettings => 'Settings';

  @override
  String get titleMyDecks => 'My decks';

  @override
  String get tooltipDashboardFilter => 'Dashboard filters';

  @override
  String get tooltipDiceCoin => 'Coin & dice';

  @override
  String get noTcg => 'No TCG';

  @override
  String get turnFree => 'Turn free';

  @override
  String get turnFirstShort => '1st';

  @override
  String get turnSecondShort => '2nd';

  @override
  String get turnFirstFull => '1st (going first)';

  @override
  String get turnSecondFull => '2nd (going second)';

  @override
  String get formatBo1 => 'Best of 1';

  @override
  String get formatBo3 => 'Best of 3';

  @override
  String get bo1 => 'BO1';

  @override
  String get bo3 => 'BO3';

  @override
  String get allFormats => 'All formats';

  @override
  String get languageTitle => 'Language';

  @override
  String get languageSubtitle => 'Choose app language';

  @override
  String get languageSystem => 'System language';

  @override
  String get languageSystemSubtitle => 'Follow the device language';

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
  String get createAccount => 'Create account';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get signIn => 'Sign in';

  @override
  String get register => 'Register';

  @override
  String get alreadyHaveAccount => 'Already have an account? Sign in';

  @override
  String get noAccountYet => 'No account yet? Register now';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get enterEmailPassword => 'Please enter email and password.';

  @override
  String get registrationSuccess => 'Registration successful!';

  @override
  String googleLoginFailed(Object error) {
    return 'Google sign-in failed: $error';
  }

  @override
  String get legalAcceptHint =>
      'By registering you accept our Terms of Use & Privacy Policy.';

  @override
  String get sectionAppearance => 'APPEARANCE';

  @override
  String get sectionSettings => 'SETTINGS';

  @override
  String get sectionContent => 'MANAGEMENT & CONTENT';

  @override
  String get sectionBackup => 'DATA & BACKUP';

  @override
  String get sectionAccount => 'ACCOUNT & INFO';

  @override
  String get themePresetsTitle => 'Color scheme & design presets';

  @override
  String get dashboardTabsTitle => 'Configure dashboard tabs & tiles';

  @override
  String get dashboardTabsSubtitle =>
      'Reorder tabs and choose which widgets to show';

  @override
  String get matchDefaultsTitle => 'Match & default settings';

  @override
  String get visibleTcgsTitle => 'Visible TCGs';

  @override
  String get visibleTcgsSubtitle => 'Hide unwanted card games from dropdowns';

  @override
  String get manageTcgsTitle => 'Manage card games (TCGs)';

  @override
  String get manageTcgsSubtitle => 'Add or rename games';

  @override
  String get toolPresetsTitle => 'Manage tool presets';

  @override
  String get toolPresetsSubtitle => 'Life counter, player count and timer';

  @override
  String get tournamentsTitle => 'Tournaments & events';

  @override
  String get tournamentsSubtitle => 'Track placements and decks you played';

  @override
  String get archetypesTitle => 'Manage opponent archetypes';

  @override
  String get archetypesSubtitle => 'Rename or clean saved suggestions';

  @override
  String get eventTagsTitle => 'Manage event tags';

  @override
  String get eventTagsSubtitle =>
      'Create your own tags for tournaments or cups';

  @override
  String get exportCsvTitle => 'Export matches as CSV';

  @override
  String get exportCsvSubtitle => 'Ideal for Excel or spreadsheets';

  @override
  String get exportJsonTitle => 'Full backup (JSON)';

  @override
  String get exportJsonSubtitle => 'Saves all decks and match history';

  @override
  String get restoreBackupTitle => 'Restore backup';

  @override
  String get restoreBackupSubtitle => 'Import a JSON backup file';

  @override
  String get legalSettingsTitle => 'Terms of use & privacy';

  @override
  String get legalSettingsSubtitle => 'View terms, disclaimer and imprint';

  @override
  String get signOutTitle => 'Sign out';

  @override
  String get signOutSubtitle => 'End this session';

  @override
  String get deleteAccountTitle => 'Permanently delete account';

  @override
  String get deleteAccountSubtitle =>
      'Remove account, decks and matches for good';

  @override
  String get csvExported => 'Matches exported as CSV!';

  @override
  String csvExportFailed(Object error) {
    return 'CSV export failed: $error';
  }

  @override
  String get jsonBackupCreated => 'JSON backup created!';

  @override
  String jsonBackupFailed(Object error) {
    return 'Backup export failed: $error';
  }

  @override
  String get fileReadFailed => 'The file could not be read.';

  @override
  String get restoreBackupQuestion => 'Restore backup?';

  @override
  String get restoreBackupBody =>
      'Existing decks and matches will be merged or updated.';

  @override
  String get restore => 'Restore';

  @override
  String matchesRestored(int count) {
    return '$count matches restored!';
  }

  @override
  String restoreFailed(Object error) {
    return 'Restore failed: $error';
  }

  @override
  String get deleteAccountQuestion => 'Delete account?';

  @override
  String get deleteAccountBody =>
      'Do you really want to permanently delete your account and all saved decks and matches?';

  @override
  String get lastConfirmation => 'Final confirmation';

  @override
  String get deleteAccountFinalBody =>
      'This cannot be undone. The account and all tracker data will be deleted permanently.';

  @override
  String get deletePermanently => 'Delete permanently';

  @override
  String deleteAccountFailed(Object error) {
    return 'Account could not be deleted: $error';
  }

  @override
  String get legalScreenTitle => 'Legal & privacy';

  @override
  String get legalIntro =>
      'Please read the following notes before using the app or creating an account.';

  @override
  String get legalTermsTitle => 'Terms of use';

  @override
  String get legalTermsBody =>
      'TCG Tracker is a private, unofficial fan project. The app is meant for tracking your own decks, matches and tournament placements at the table. It is not a commercial product of the respective card game publishers.\n\nUse is at your own risk. There is no warranty for uninterrupted availability, error-free operation or that your data will be kept. Data loss (for example through outages, account deletion or service changes) cannot be ruled out. Keep your own backups if needed.\n\nYou may use the app for private purposes only. Abuse, automated scraping of other accounts or bypassing security mechanisms is not allowed.';

  @override
  String get legalPrivacyTitle => 'Privacy (GDPR)';

  @override
  String get legalPrivacyBody =>
      'The controller for personal data under the GDPR is the operator of this app (see imprint).\n\nWe store in particular: your email address (account), authentication data and content you enter (decks, match results, notes, tags, tournaments). Data is stored in the Supabase cloud (PostgreSQL with row-level security).\n\nThe purpose is providing the tracker (performance of a contract, Art. 6(1)(b) GDPR). Your data is not shared with third parties for advertising. Technical processors (hosting/auth) only process data as needed to run the service.\n\nYou have the right to access, rectification, restriction, objection and erasure. Use “Permanently delete account” in Settings to have your account and tracker data removed.';

  @override
  String get legalDisclaimerTitle => 'Trademark & copyright notice';

  @override
  String get legalDisclaimerBody =>
      'Pokémon, One Piece, Yu-Gi-Oh!, Magic: The Gathering, Dragon Ball Super and all other named card games, characters, logos and names are registered trademarks or copyrighted works of their respective owners, including Nintendo, The Pokémon Company, Bandai, Toei Animation, Konami, Wizards of the Coast / Hasbro and other licensors.\n\nThis app is not affiliated with those companies. It is an independent fan project. Game names are used only so you can track your own games. Official card images or protected artwork are not sold or licensed as part of this product.';

  @override
  String get legalImprintTitle => 'Imprint & contact';

  @override
  String get legalImprintBody =>
      'Information according to applicable imprint law:\n\nOperator / developer:\n[First and last name]\n[Street and number]\n[ZIP City]\nGermany\n\nContact:\nEmail: kontakt@example.com\n\nPlease replace the placeholders with real details before operating the app publicly.';

  @override
  String get themeScreenTitle => 'Color scheme & design';

  @override
  String get themeLight => 'LIGHT';

  @override
  String get themeDark => 'DARK';

  @override
  String get matchSettingsTitle => 'Match settings';

  @override
  String get defaultGame => 'Default card game';

  @override
  String get defaultFormat => 'Default match format';

  @override
  String get defaultTurnOrder => 'Default turn order';

  @override
  String get turnFreeLabel => 'Free';

  @override
  String get rememberLastTags => 'Remember last selected tags';

  @override
  String get statsTimeRange => 'Time range for statistics';

  @override
  String get statsTimeRangeSubtitle =>
      'Applies to win rate, nemesis and TCG performance';

  @override
  String get dashboardGameFocus => 'Game focus for dashboard';

  @override
  String get dashboardGamePickerTitle => 'Dashboard game';

  @override
  String get rangeWeek => 'Week';

  @override
  String get rangeMonth => 'Month';

  @override
  String get rangeSeason => 'Season';

  @override
  String get rangeYear => 'Year';

  @override
  String get rangeAllTime => 'All time';

  @override
  String get visibleTcgsScreenTitle => 'Visible TCGs';

  @override
  String get noGamesAvailable => 'No card games available.';

  @override
  String get atLeastOneTcgVisible => 'At least one TCG must stay visible.';

  @override
  String get addTcgTitle => 'Add a new TCG';

  @override
  String get renameTcgTitle => 'Rename TCG';

  @override
  String get gameNameLabel => 'Card game name';

  @override
  String get newName => 'New name';

  @override
  String get manageTcgsScreenTitle => 'Manage card games (TCGs)';

  @override
  String get toolPresetsScreenTitle => 'Tool presets';

  @override
  String get factoryResetQuestion => 'Reset to defaults?';

  @override
  String get noPresets => 'No presets available.';

  @override
  String get keepOnePreset => 'At least one preset must remain.';

  @override
  String get enterNameAndLp => 'Please enter a name and valid starting LP.';

  @override
  String get playerCount => 'Player count';

  @override
  String get roundTimer => 'Round timer';

  @override
  String get minutes => 'Minutes';

  @override
  String minutesValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get presetName => 'Name';

  @override
  String get startingLp => 'Starting LP';

  @override
  String get createTagTitle => 'Create a new tag';

  @override
  String get tagNameHint => 'Tag name (e.g. Store Cup, League)';

  @override
  String get manageTagsScreenTitle => 'Manage event tags';

  @override
  String get standardTagsHeader => 'STANDARD TAGS (FIXED)';

  @override
  String get systemTagSubtitle => 'System tag (cannot be deleted)';

  @override
  String get customTagsHeader => 'CUSTOM TAGS';

  @override
  String get createTag => 'Create tag';

  @override
  String get noCustomTags => 'No custom tags yet.';

  @override
  String get deleteArchetypeQuestion => 'Delete archetype?';

  @override
  String deleteArchetypeBody(String name) {
    return 'Remove \"$name\" from automatic suggestions?';
  }

  @override
  String itemDeleted(String name) {
    return '\"$name\" deleted.';
  }

  @override
  String deleteFailed(Object error) {
    return 'Delete failed: $error';
  }

  @override
  String get renameArchetypeTitle => 'Rename archetype';

  @override
  String renamedTo(String name) {
    return 'Renamed to \"$name\".';
  }

  @override
  String renameFailed(Object error) {
    return 'Rename failed: $error';
  }

  @override
  String get archetypesScreenTitle => 'Manage opponent archetypes';

  @override
  String get chooseCardGame => 'Choose card game';

  @override
  String get noArchetypesForGame => 'No archetypes for this TCG.';

  @override
  String get dashboardConfigTitle => 'Configure dashboard';

  @override
  String get resetToDefault => 'Reset to default';

  @override
  String get resetDashboardQuestion => 'Reset to default?';

  @override
  String get atLeastOneTab => 'At least one tab must stay enabled.';

  @override
  String get allEvents => 'All events';

  @override
  String get focusEventTag => 'Focus event tag';

  @override
  String get focusEventTagOptional => 'Focus event tag (optional)';

  @override
  String get customDashboard => 'Custom dashboard';

  @override
  String get tabTitle => 'Title';

  @override
  String get icon => 'Icon';

  @override
  String get startTiles => 'Starting tiles';

  @override
  String get widgetWinrate => 'Overall win rate';

  @override
  String get widgetNemesis => 'Nemesis & best matchup';

  @override
  String get widgetPerformance => 'Performance by card game';

  @override
  String get widgetRecent => 'Recent matches';

  @override
  String get widgetTournaments => 'Tournaments & placements';

  @override
  String get widgetTurnOrder => '1st / 2nd turn-order stats';

  @override
  String get tabAllround => 'Allround';

  @override
  String get tabTournament => 'Tournament';

  @override
  String get tabMinimal => 'Minimal';

  @override
  String get noDashboardTab => 'No dashboard tab is active.';

  @override
  String eventFilter(String tag) {
    return 'Event: $tag';
  }

  @override
  String get winrate => 'Winrate';

  @override
  String get matches => 'Matches';

  @override
  String get wins => 'Wins';

  @override
  String get recorded => 'Recorded';

  @override
  String winsOfTotal(int total) {
    return 'of $total';
  }

  @override
  String get noMatchesInRange => 'No matches in the selected period';

  @override
  String noRepeatMatchups(String range) {
    return 'No matches against repeating archetypes in the selected period ($range).\nAt least 2 matches against the same deck are required.';
  }

  @override
  String get bestMatchup => 'Strongest matchup';

  @override
  String get nemesisDeck => 'Nemesis / problem deck';

  @override
  String get performanceByGame => 'Performance by card game';

  @override
  String get noMatchesVisibleTcgs => 'No matches yet for visible TCGs.';

  @override
  String winsOfMatches(int wins, int total) {
    return '$wins wins of $total matches';
  }

  @override
  String get recentMatches => 'Recent matches';

  @override
  String get turnOrder => 'Turn order';

  @override
  String get first => 'First';

  @override
  String get second => 'Second';

  @override
  String winsFraction(int wins, int total) {
    return '$wins/$total wins';
  }

  @override
  String get recentTournaments => 'Recent tournaments';

  @override
  String get noTournamentsYet => 'No tournaments recorded yet.';

  @override
  String tournamentsLoadFailed(Object error) {
    return 'Tournaments could not be loaded.\n$error';
  }

  @override
  String get lossRate => 'Loss rate';

  @override
  String winsLossesSummary(int wins, int losses, int total) {
    return '$wins–$losses  ($wins wins / $total matches)';
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
      'No decks yet.\nTap + at the bottom right to create your first deck!';

  @override
  String get deleteDeckQuestion => 'Delete this deck?';

  @override
  String deleteDeckBody(String name) {
    return 'Deck \"$name\" and ALL related matches will be deleted permanently!';
  }

  @override
  String deckDeleted(String name) {
    return 'Deck \"$name\" deleted.';
  }

  @override
  String deckArchived(String name) {
    return 'Deck \"$name\" archived.';
  }

  @override
  String get linkOpenFailed => 'The link could not be opened.';

  @override
  String get matchSingular => 'match';

  @override
  String get matchPlural => 'matches';

  @override
  String get fillRequiredFields => 'Please fill in all required fields.';

  @override
  String get invalidDecklistUrl => 'Please enter a valid decklist URL.';

  @override
  String get cardGame => 'Card game';

  @override
  String get deckName => 'Deck name';

  @override
  String get decklistLinkOptional => 'Decklist link (optional)';

  @override
  String get notesOptional => 'Notes (optional)';

  @override
  String get addDeck => 'Add deck';

  @override
  String get editDeck => 'Edit deck';

  @override
  String get viewDecklist => 'View decklist';

  @override
  String get noMatchesForDeck =>
      'No matches recorded for this deck yet.\nTap + below to add a match!';

  @override
  String get noMatchesForFilter => 'No matches found for this filter.';

  @override
  String get deleteMatchQuestion => 'Delete match?';

  @override
  String deleteMatchBody(String name) {
    return 'Do you really want to delete the game against $name?';
  }

  @override
  String get matchDeleted => 'Match deleted.';

  @override
  String statsTitle(String name) {
    return '$name - Stats';
  }

  @override
  String get noStatsYet => 'No matches yet to calculate statistics.';

  @override
  String get matchupsVsArchetypes => 'Matchups against archetypes';

  @override
  String winsOfGames(int wins, int total) {
    return '$wins wins of $total games';
  }

  @override
  String get needDeckForMatch => 'Create a deck first to record matches.';

  @override
  String get noToolPresets => 'No tool presets available.';

  @override
  String get recordMatch => 'Record match';

  @override
  String get chooseOwnDeck => 'Choose your deck';

  @override
  String get editMatch => 'Edit match';

  @override
  String get logMatch => 'Log match';

  @override
  String get needOpponentDeck => 'Please enter the opponent’s deck.';

  @override
  String get win => 'Win';

  @override
  String get loss => 'Loss';

  @override
  String get draw => 'Draw';

  @override
  String get opponentDeckArchetype => 'Opponent deck / archetype';

  @override
  String get opponentDeck => 'Opponent deck';

  @override
  String get format => 'Format';

  @override
  String get order => 'Order';

  @override
  String get eventTags => 'Event tags';

  @override
  String get scoreOptional => 'Score (optional, e.g. 2-1)';

  @override
  String get rollTitle => 'Randomize';

  @override
  String get d20 => 'D20';

  @override
  String get d6 => 'D6';

  @override
  String get coin => 'Coin';

  @override
  String get multi => 'Multi';

  @override
  String rollDie(int sides) {
    return 'Roll D$sides';
  }

  @override
  String get flipCoin => 'Flip coin';

  @override
  String rollMulti(int count, int sides) {
    return 'Roll $count×D$sides';
  }

  @override
  String get deleteTournamentQuestion => 'Delete tournament?';

  @override
  String deleteTournamentBody(String name) {
    return '“$name” will be deleted permanently.';
  }

  @override
  String tournamentDeleted(String name) {
    return '“$name” deleted.';
  }

  @override
  String get noTournamentsHint =>
      'No tournaments yet.\nRecord store championships, regionals and opens.';

  @override
  String get needNameTcgDeck => 'Please fill in name, TCG and deck.';

  @override
  String get placementMustBeNumber => 'Placement must be a number.';

  @override
  String get participantsMustBeNumber => 'Participant count must be a number.';

  @override
  String get placementMinOne => 'Placement must be at least 1.';

  @override
  String get placementVsField =>
      'Placement cannot be greater than the field size.';

  @override
  String get tournamentName => 'Tournament name';

  @override
  String get chooseTcg => 'Choose TCG';

  @override
  String get chooseGameFirst => 'Choose a card game first';

  @override
  String get noDecksForTcg => 'No decks for this TCG';

  @override
  String get chooseDeck => 'Choose deck';

  @override
  String get playedDeck => 'Deck played';

  @override
  String get place => 'Place';

  @override
  String get participants => 'Participants';

  @override
  String get date => 'Date';

  @override
  String get addTournament => 'Add tournament';

  @override
  String get editTournament => 'Edit tournament';

  @override
  String get noMatchingMatches => 'No matching matches found.';

  @override
  String relatedMatchesCount(int count) {
    return '$count matches linked';
  }

  @override
  String matchesLoadFailed(Object error) {
    return 'Matches could not be loaded: $error';
  }

  @override
  String relatedMatchesTagsAndDeck(String deck) {
    return 'Matches with the same tags and deck “$deck”.';
  }

  @override
  String get relatedMatchesTags => 'Matches with the same tags.';

  @override
  String get noPlacement => 'No placement';

  @override
  String placementOf(int place, int total) {
    return '#$place / $total';
  }

  @override
  String get firstPlace => '1st place';

  @override
  String topPlacement(int place) {
    return 'Top $place';
  }

  @override
  String placeNumber(int place) {
    return 'Place $place';
  }
}
