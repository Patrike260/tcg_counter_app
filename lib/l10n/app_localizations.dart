import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('fr'),
    Locale('it'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'TCG Tracker'**
  String get appTitle;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @archive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archive;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get from;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @versionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Web / PWA'**
  String get versionSubtitle;

  /// No description provided for @errorWithDetails.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorWithDetails(Object error);

  /// No description provided for @loadErrorWithDetails.
  ///
  /// In en, this message translates to:
  /// **'Could not load: {error}'**
  String loadErrorWithDetails(Object error);

  /// No description provided for @gamesLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load games: {error}'**
  String gamesLoadError(Object error);

  /// No description provided for @decksLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load decks: {error}'**
  String decksLoadError(Object error);

  /// No description provided for @noUserLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'No user signed in'**
  String get noUserLoggedIn;

  /// No description provided for @userIdShort.
  ///
  /// In en, this message translates to:
  /// **'ID: {id}...'**
  String userIdShort(String id);

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navDecks.
  ///
  /// In en, this message translates to:
  /// **'Decks'**
  String get navDecks;

  /// No description provided for @navTools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get navTools;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @titleMyDecks.
  ///
  /// In en, this message translates to:
  /// **'My decks'**
  String get titleMyDecks;

  /// No description provided for @tooltipDashboardFilter.
  ///
  /// In en, this message translates to:
  /// **'Dashboard filters'**
  String get tooltipDashboardFilter;

  /// No description provided for @tooltipDiceCoin.
  ///
  /// In en, this message translates to:
  /// **'Coin & dice'**
  String get tooltipDiceCoin;

  /// No description provided for @noTcg.
  ///
  /// In en, this message translates to:
  /// **'No TCG'**
  String get noTcg;

  /// No description provided for @turnFree.
  ///
  /// In en, this message translates to:
  /// **'Turn free'**
  String get turnFree;

  /// No description provided for @turnFirstShort.
  ///
  /// In en, this message translates to:
  /// **'1st'**
  String get turnFirstShort;

  /// No description provided for @turnSecondShort.
  ///
  /// In en, this message translates to:
  /// **'2nd'**
  String get turnSecondShort;

  /// No description provided for @turnFirstFull.
  ///
  /// In en, this message translates to:
  /// **'1st (going first)'**
  String get turnFirstFull;

  /// No description provided for @turnSecondFull.
  ///
  /// In en, this message translates to:
  /// **'2nd (going second)'**
  String get turnSecondFull;

  /// No description provided for @formatBo1.
  ///
  /// In en, this message translates to:
  /// **'Best of 1'**
  String get formatBo1;

  /// No description provided for @formatBo3.
  ///
  /// In en, this message translates to:
  /// **'Best of 3'**
  String get formatBo3;

  /// No description provided for @bo1.
  ///
  /// In en, this message translates to:
  /// **'BO1'**
  String get bo1;

  /// No description provided for @bo3.
  ///
  /// In en, this message translates to:
  /// **'BO3'**
  String get bo3;

  /// No description provided for @allFormats.
  ///
  /// In en, this message translates to:
  /// **'All formats'**
  String get allFormats;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageTitle;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose app language'**
  String get languageSubtitle;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'System language'**
  String get languageSystem;

  /// No description provided for @languageSystemSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Follow the device language'**
  String get languageSystemSubtitle;

  /// No description provided for @languageGerman.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get languageGerman;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// No description provided for @languageItalian.
  ///
  /// In en, this message translates to:
  /// **'Italiano'**
  String get languageItalian;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'TCG Tracker Login'**
  String get loginTitle;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get alreadyHaveAccount;

  /// No description provided for @noAccountYet.
  ///
  /// In en, this message translates to:
  /// **'No account yet? Register now'**
  String get noAccountYet;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithDiscord.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Discord'**
  String get continueWithDiscord;

  /// No description provided for @continueWithGithub.
  ///
  /// In en, this message translates to:
  /// **'Sign in with GitHub'**
  String get continueWithGithub;

  /// No description provided for @enterEmailPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter email and password.'**
  String get enterEmailPassword;

  /// No description provided for @registrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful!'**
  String get registrationSuccess;

  /// No description provided for @googleLoginFailed.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in failed: {error}'**
  String googleLoginFailed(Object error);

  /// No description provided for @discordLoginFailed.
  ///
  /// In en, this message translates to:
  /// **'Discord sign-in failed: {error}'**
  String discordLoginFailed(Object error);

  /// No description provided for @githubLoginFailed.
  ///
  /// In en, this message translates to:
  /// **'GitHub sign-in failed: {error}'**
  String githubLoginFailed(Object error);

  /// No description provided for @legalAcceptHint.
  ///
  /// In en, this message translates to:
  /// **'By registering you accept our Terms of Use & Privacy Policy.'**
  String get legalAcceptHint;

  /// No description provided for @sectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'APPEARANCE / DESIGN'**
  String get sectionAppearance;

  /// No description provided for @sectionSettings.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get sectionSettings;

  /// No description provided for @sectionToolsTimer.
  ///
  /// In en, this message translates to:
  /// **'TOOLS & TIMER'**
  String get sectionToolsTimer;

  /// No description provided for @sectionContent.
  ///
  /// In en, this message translates to:
  /// **'MANAGEMENT & CONTENT'**
  String get sectionContent;

  /// No description provided for @sectionBackup.
  ///
  /// In en, this message translates to:
  /// **'DATA & BACKUP'**
  String get sectionBackup;

  /// No description provided for @sectionSupport.
  ///
  /// In en, this message translates to:
  /// **'SUPPORT & FEEDBACK'**
  String get sectionSupport;

  /// No description provided for @sectionAccount.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT & INFO'**
  String get sectionAccount;

  /// No description provided for @themePresetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Color scheme & design presets'**
  String get themePresetsTitle;

  /// No description provided for @dashboardTabsTitle.
  ///
  /// In en, this message translates to:
  /// **'Configure dashboard tabs & tiles'**
  String get dashboardTabsTitle;

  /// No description provided for @dashboardTabsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reorder tabs and choose which widgets to show'**
  String get dashboardTabsSubtitle;

  /// No description provided for @matchDefaultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Match & default settings'**
  String get matchDefaultsTitle;

  /// No description provided for @visibleTcgsTitle.
  ///
  /// In en, this message translates to:
  /// **'Visible TCGs'**
  String get visibleTcgsTitle;

  /// No description provided for @visibleTcgsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Hide unwanted card games from dropdowns'**
  String get visibleTcgsSubtitle;

  /// No description provided for @manageTcgsTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage card games (TCGs)'**
  String get manageTcgsTitle;

  /// No description provided for @manageTcgsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add or rename games'**
  String get manageTcgsSubtitle;

  /// No description provided for @toolPresetsTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage tool presets'**
  String get toolPresetsTitle;

  /// No description provided for @toolPresetsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Life counter, player count and timer'**
  String get toolPresetsSubtitle;

  /// No description provided for @timerSoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Sound alert when time expires'**
  String get timerSoundTitle;

  /// No description provided for @timerSoundSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Play a short system beep at 00:00'**
  String get timerSoundSubtitle;

  /// No description provided for @timerVibrationTitle.
  ///
  /// In en, this message translates to:
  /// **'Vibration alert when time expires'**
  String get timerVibrationTitle;

  /// No description provided for @timerVibrationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Haptic feedback on supported devices'**
  String get timerVibrationSubtitle;

  /// No description provided for @tournamentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tournaments & events'**
  String get tournamentsTitle;

  /// No description provided for @tournamentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track placements and decks you played'**
  String get tournamentsSubtitle;

  /// No description provided for @archetypesTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage opponent archetypes'**
  String get archetypesTitle;

  /// No description provided for @archetypesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Rename or clean saved suggestions'**
  String get archetypesSubtitle;

  /// No description provided for @eventTagsTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage event tags'**
  String get eventTagsTitle;

  /// No description provided for @eventTagsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your own tags for tournaments or cups'**
  String get eventTagsSubtitle;

  /// No description provided for @exportCsvTitle.
  ///
  /// In en, this message translates to:
  /// **'Export matches as CSV'**
  String get exportCsvTitle;

  /// No description provided for @exportCsvSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ideal for Excel or spreadsheets'**
  String get exportCsvSubtitle;

  /// No description provided for @exportJsonTitle.
  ///
  /// In en, this message translates to:
  /// **'Full backup (JSON)'**
  String get exportJsonTitle;

  /// No description provided for @exportJsonSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Saves all decks and match history'**
  String get exportJsonSubtitle;

  /// No description provided for @restoreBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Restore backup'**
  String get restoreBackupTitle;

  /// No description provided for @restoreBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Import a JSON backup file'**
  String get restoreBackupSubtitle;

  /// No description provided for @legalSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of use & privacy'**
  String get legalSettingsTitle;

  /// No description provided for @legalSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Imprint, disclaimer and GDPR'**
  String get legalSettingsSubtitle;

  /// No description provided for @signOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOutTitle;

  /// No description provided for @signOutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'End this session'**
  String get signOutSubtitle;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete account'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Remove account, decks and matches for good'**
  String get deleteAccountSubtitle;

  /// No description provided for @csvExported.
  ///
  /// In en, this message translates to:
  /// **'Matches exported as CSV!'**
  String get csvExported;

  /// No description provided for @csvExportFailed.
  ///
  /// In en, this message translates to:
  /// **'CSV export failed: {error}'**
  String csvExportFailed(Object error);

  /// No description provided for @jsonBackupCreated.
  ///
  /// In en, this message translates to:
  /// **'JSON backup created!'**
  String get jsonBackupCreated;

  /// No description provided for @jsonBackupFailed.
  ///
  /// In en, this message translates to:
  /// **'Backup export failed: {error}'**
  String jsonBackupFailed(Object error);

  /// No description provided for @fileReadFailed.
  ///
  /// In en, this message translates to:
  /// **'The file could not be read.'**
  String get fileReadFailed;

  /// No description provided for @restoreBackupQuestion.
  ///
  /// In en, this message translates to:
  /// **'Restore backup?'**
  String get restoreBackupQuestion;

  /// No description provided for @restoreBackupBody.
  ///
  /// In en, this message translates to:
  /// **'Existing decks and matches will be merged or updated.'**
  String get restoreBackupBody;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @matchesRestored.
  ///
  /// In en, this message translates to:
  /// **'{count} matches restored!'**
  String matchesRestored(int count);

  /// No description provided for @restoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Restore failed: {error}'**
  String restoreFailed(Object error);

  /// No description provided for @deleteAccountQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete account?'**
  String get deleteAccountQuestion;

  /// No description provided for @deleteAccountBody.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to permanently delete your account and all saved decks and matches?'**
  String get deleteAccountBody;

  /// No description provided for @lastConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Final confirmation'**
  String get lastConfirmation;

  /// No description provided for @deleteAccountFinalBody.
  ///
  /// In en, this message translates to:
  /// **'This cannot be undone. The account and all tracker data will be deleted permanently.'**
  String get deleteAccountFinalBody;

  /// No description provided for @deletePermanently.
  ///
  /// In en, this message translates to:
  /// **'Delete permanently'**
  String get deletePermanently;

  /// No description provided for @deleteAccountFailed.
  ///
  /// In en, this message translates to:
  /// **'Account could not be deleted: {error}'**
  String deleteAccountFailed(Object error);

  /// No description provided for @legalScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Legal & privacy'**
  String get legalScreenTitle;

  /// No description provided for @legalIntro.
  ///
  /// In en, this message translates to:
  /// **'Please read the following notes before using the app or creating an account.'**
  String get legalIntro;

  /// No description provided for @legalTermsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get legalTermsTitle;

  /// No description provided for @legalTermsBody.
  ///
  /// In en, this message translates to:
  /// **'TCG Tracker is a private, unofficial fan project. The app is meant for tracking your own decks, matches and tournament placements at the table. It is not a commercial product of the respective card game publishers.\n\nUse is at your own risk. There is no warranty for uninterrupted availability, error-free operation or that your data will be kept. Data loss (for example through outages, account deletion or service changes) cannot be ruled out. Keep your own backups if needed.\n\nYou may use the app for private purposes only. Abuse, automated scraping of other accounts or bypassing security mechanisms is not allowed.'**
  String get legalTermsBody;

  /// No description provided for @legalPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy (GDPR)'**
  String get legalPrivacyTitle;

  /// No description provided for @legalPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'The controller for personal data under the GDPR is the operator of this app (see imprint).\n\nWe store in particular: your email address (account), authentication data and content you enter (decks, match results, notes, tags, tournaments). Data is stored in the Supabase cloud (PostgreSQL with row-level security).\n\nThe purpose is providing the tracker (performance of a contract, Art. 6(1)(b) GDPR). Your data is not shared with third parties for advertising. Technical processors (hosting/auth) only process data as needed to run the service.\n\nYou have the right to access, rectification, restriction, objection and erasure. Use “Permanently delete account” in Settings to have your account and tracker data removed.'**
  String get legalPrivacyBody;

  /// No description provided for @legalDisclaimerTitle.
  ///
  /// In en, this message translates to:
  /// **'Trademark & copyright notice'**
  String get legalDisclaimerTitle;

  /// No description provided for @legalDisclaimerBody.
  ///
  /// In en, this message translates to:
  /// **'Pokémon, One Piece, Yu-Gi-Oh!, Magic: The Gathering, Dragon Ball Super and all other named card games, characters, logos and names are registered trademarks or copyrighted works of their respective owners, including Nintendo, The Pokémon Company, Bandai, Toei Animation, Konami, Wizards of the Coast / Hasbro and other licensors.\n\nThis app is not affiliated with those companies. It is an independent fan project. Game names are used only so you can track your own games. Official card images or protected artwork are not sold or licensed as part of this product.'**
  String get legalDisclaimerBody;

  /// No description provided for @legalImprintTitle.
  ///
  /// In en, this message translates to:
  /// **'Imprint & contact'**
  String get legalImprintTitle;

  /// No description provided for @legalImprintBody.
  ///
  /// In en, this message translates to:
  /// **'Information according to applicable imprint law:\n\nOperator / developer:\n[First and last name]\n[Street and number]\n[ZIP City]\nGermany\n\nContact:\nEmail: kontakt@example.com\n\nPlease replace the placeholders with real details before operating the app publicly.'**
  String get legalImprintBody;

  /// No description provided for @themeScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Color scheme & design'**
  String get themeScreenTitle;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'LIGHT'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'DARK'**
  String get themeDark;

  /// No description provided for @matchSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Match settings'**
  String get matchSettingsTitle;

  /// No description provided for @defaultGame.
  ///
  /// In en, this message translates to:
  /// **'Default card game'**
  String get defaultGame;

  /// No description provided for @defaultFormat.
  ///
  /// In en, this message translates to:
  /// **'Default match format'**
  String get defaultFormat;

  /// No description provided for @defaultTurnOrder.
  ///
  /// In en, this message translates to:
  /// **'Default turn order'**
  String get defaultTurnOrder;

  /// No description provided for @turnFreeLabel.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get turnFreeLabel;

  /// No description provided for @rememberLastTags.
  ///
  /// In en, this message translates to:
  /// **'Remember last selected tags'**
  String get rememberLastTags;

  /// No description provided for @statsTimeRange.
  ///
  /// In en, this message translates to:
  /// **'Time range for statistics'**
  String get statsTimeRange;

  /// No description provided for @statsTimeRangeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Applies to win rate, nemesis and TCG performance'**
  String get statsTimeRangeSubtitle;

  /// No description provided for @dashboardGameFocus.
  ///
  /// In en, this message translates to:
  /// **'Game focus for dashboard'**
  String get dashboardGameFocus;

  /// No description provided for @dashboardGamePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard game'**
  String get dashboardGamePickerTitle;

  /// No description provided for @rangeWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get rangeWeek;

  /// No description provided for @rangeMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get rangeMonth;

  /// No description provided for @rangeSeason.
  ///
  /// In en, this message translates to:
  /// **'Season'**
  String get rangeSeason;

  /// No description provided for @rangeYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get rangeYear;

  /// No description provided for @rangeAllTime.
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get rangeAllTime;

  /// No description provided for @visibleTcgsScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Visible TCGs'**
  String get visibleTcgsScreenTitle;

  /// No description provided for @noGamesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No card games available.'**
  String get noGamesAvailable;

  /// No description provided for @atLeastOneTcgVisible.
  ///
  /// In en, this message translates to:
  /// **'At least one TCG must stay visible.'**
  String get atLeastOneTcgVisible;

  /// No description provided for @addTcgTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a new TCG'**
  String get addTcgTitle;

  /// No description provided for @renameTcgTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename TCG'**
  String get renameTcgTitle;

  /// No description provided for @gameNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Card game name'**
  String get gameNameLabel;

  /// No description provided for @newName.
  ///
  /// In en, this message translates to:
  /// **'New name'**
  String get newName;

  /// No description provided for @manageTcgsScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage card games (TCGs)'**
  String get manageTcgsScreenTitle;

  /// No description provided for @toolPresetsScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Tool presets'**
  String get toolPresetsScreenTitle;

  /// No description provided for @factoryResetQuestion.
  ///
  /// In en, this message translates to:
  /// **'Reset to defaults?'**
  String get factoryResetQuestion;

  /// No description provided for @noPresets.
  ///
  /// In en, this message translates to:
  /// **'No presets available.'**
  String get noPresets;

  /// No description provided for @keepOnePreset.
  ///
  /// In en, this message translates to:
  /// **'At least one preset must remain.'**
  String get keepOnePreset;

  /// No description provided for @enterNameAndLp.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name and valid starting LP.'**
  String get enterNameAndLp;

  /// No description provided for @playerCount.
  ///
  /// In en, this message translates to:
  /// **'Player count'**
  String get playerCount;

  /// No description provided for @roundTimer.
  ///
  /// In en, this message translates to:
  /// **'Round timer'**
  String get roundTimer;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @minutesValue.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String minutesValue(int minutes);

  /// No description provided for @presetName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get presetName;

  /// No description provided for @startingLp.
  ///
  /// In en, this message translates to:
  /// **'Starting LP'**
  String get startingLp;

  /// No description provided for @createTagTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a new tag'**
  String get createTagTitle;

  /// No description provided for @tagNameHint.
  ///
  /// In en, this message translates to:
  /// **'Tag name (e.g. Store Cup, League)'**
  String get tagNameHint;

  /// No description provided for @manageTagsScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage event tags'**
  String get manageTagsScreenTitle;

  /// No description provided for @standardTagsHeader.
  ///
  /// In en, this message translates to:
  /// **'STANDARD TAGS (FIXED)'**
  String get standardTagsHeader;

  /// No description provided for @systemTagSubtitle.
  ///
  /// In en, this message translates to:
  /// **'System tag (cannot be deleted)'**
  String get systemTagSubtitle;

  /// No description provided for @customTagsHeader.
  ///
  /// In en, this message translates to:
  /// **'CUSTOM TAGS'**
  String get customTagsHeader;

  /// No description provided for @createTag.
  ///
  /// In en, this message translates to:
  /// **'Create tag'**
  String get createTag;

  /// No description provided for @noCustomTags.
  ///
  /// In en, this message translates to:
  /// **'No custom tags yet.'**
  String get noCustomTags;

  /// No description provided for @deleteArchetypeQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete archetype?'**
  String get deleteArchetypeQuestion;

  /// No description provided for @deleteArchetypeBody.
  ///
  /// In en, this message translates to:
  /// **'Remove \"{name}\" from automatic suggestions?'**
  String deleteArchetypeBody(String name);

  /// No description provided for @itemDeleted.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" deleted.'**
  String itemDeleted(String name);

  /// No description provided for @deleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Delete failed: {error}'**
  String deleteFailed(Object error);

  /// No description provided for @renameArchetypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename archetype'**
  String get renameArchetypeTitle;

  /// No description provided for @renamedTo.
  ///
  /// In en, this message translates to:
  /// **'Renamed to \"{name}\".'**
  String renamedTo(String name);

  /// No description provided for @renameFailed.
  ///
  /// In en, this message translates to:
  /// **'Rename failed: {error}'**
  String renameFailed(Object error);

  /// No description provided for @archetypesScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage opponent archetypes'**
  String get archetypesScreenTitle;

  /// No description provided for @chooseCardGame.
  ///
  /// In en, this message translates to:
  /// **'Choose card game'**
  String get chooseCardGame;

  /// No description provided for @noArchetypesForGame.
  ///
  /// In en, this message translates to:
  /// **'No archetypes for this TCG.'**
  String get noArchetypesForGame;

  /// No description provided for @dashboardConfigTitle.
  ///
  /// In en, this message translates to:
  /// **'Configure dashboard'**
  String get dashboardConfigTitle;

  /// No description provided for @resetToDefault.
  ///
  /// In en, this message translates to:
  /// **'Reset to default'**
  String get resetToDefault;

  /// No description provided for @resetDashboardQuestion.
  ///
  /// In en, this message translates to:
  /// **'Reset to default?'**
  String get resetDashboardQuestion;

  /// No description provided for @atLeastOneTab.
  ///
  /// In en, this message translates to:
  /// **'At least one tab must stay enabled.'**
  String get atLeastOneTab;

  /// No description provided for @allEvents.
  ///
  /// In en, this message translates to:
  /// **'All events'**
  String get allEvents;

  /// No description provided for @focusEventTag.
  ///
  /// In en, this message translates to:
  /// **'Focus event tag'**
  String get focusEventTag;

  /// No description provided for @focusEventTagOptional.
  ///
  /// In en, this message translates to:
  /// **'Focus event tag (optional)'**
  String get focusEventTagOptional;

  /// No description provided for @customDashboard.
  ///
  /// In en, this message translates to:
  /// **'Custom dashboard'**
  String get customDashboard;

  /// No description provided for @tabTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get tabTitle;

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// No description provided for @startTiles.
  ///
  /// In en, this message translates to:
  /// **'Starting tiles'**
  String get startTiles;

  /// No description provided for @widgetWinrate.
  ///
  /// In en, this message translates to:
  /// **'Overall win rate'**
  String get widgetWinrate;

  /// No description provided for @widgetNemesis.
  ///
  /// In en, this message translates to:
  /// **'Nemesis & best matchup'**
  String get widgetNemesis;

  /// No description provided for @widgetPerformance.
  ///
  /// In en, this message translates to:
  /// **'Performance by card game'**
  String get widgetPerformance;

  /// No description provided for @widgetRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent matches'**
  String get widgetRecent;

  /// No description provided for @widgetTournaments.
  ///
  /// In en, this message translates to:
  /// **'Tournaments & placements'**
  String get widgetTournaments;

  /// No description provided for @widgetTurnOrder.
  ///
  /// In en, this message translates to:
  /// **'1st / 2nd turn-order stats'**
  String get widgetTurnOrder;

  /// No description provided for @tabAllround.
  ///
  /// In en, this message translates to:
  /// **'Allround'**
  String get tabAllround;

  /// No description provided for @tabTournament.
  ///
  /// In en, this message translates to:
  /// **'Tournament'**
  String get tabTournament;

  /// No description provided for @tabMinimal.
  ///
  /// In en, this message translates to:
  /// **'Minimal'**
  String get tabMinimal;

  /// No description provided for @noDashboardTab.
  ///
  /// In en, this message translates to:
  /// **'No dashboard tab is active.'**
  String get noDashboardTab;

  /// No description provided for @eventFilter.
  ///
  /// In en, this message translates to:
  /// **'Event: {tag}'**
  String eventFilter(String tag);

  /// No description provided for @winrate.
  ///
  /// In en, this message translates to:
  /// **'Winrate'**
  String get winrate;

  /// No description provided for @matches.
  ///
  /// In en, this message translates to:
  /// **'Matches'**
  String get matches;

  /// No description provided for @wins.
  ///
  /// In en, this message translates to:
  /// **'Wins'**
  String get wins;

  /// No description provided for @recorded.
  ///
  /// In en, this message translates to:
  /// **'Recorded'**
  String get recorded;

  /// No description provided for @winsOfTotal.
  ///
  /// In en, this message translates to:
  /// **'of {total}'**
  String winsOfTotal(int total);

  /// No description provided for @noMatchesInRange.
  ///
  /// In en, this message translates to:
  /// **'No matches in the selected period'**
  String get noMatchesInRange;

  /// No description provided for @noRepeatMatchups.
  ///
  /// In en, this message translates to:
  /// **'No matches against repeating archetypes in the selected period ({range}).\nAt least 2 matches against the same deck are required.'**
  String noRepeatMatchups(String range);

  /// No description provided for @bestMatchup.
  ///
  /// In en, this message translates to:
  /// **'Strongest matchup'**
  String get bestMatchup;

  /// No description provided for @nemesisDeck.
  ///
  /// In en, this message translates to:
  /// **'Nemesis / problem deck'**
  String get nemesisDeck;

  /// No description provided for @performanceByGame.
  ///
  /// In en, this message translates to:
  /// **'Performance by card game'**
  String get performanceByGame;

  /// No description provided for @noMatchesVisibleTcgs.
  ///
  /// In en, this message translates to:
  /// **'No matches yet for visible TCGs.'**
  String get noMatchesVisibleTcgs;

  /// No description provided for @winsOfMatches.
  ///
  /// In en, this message translates to:
  /// **'{wins} wins of {total} matches'**
  String winsOfMatches(int wins, int total);

  /// No description provided for @recentMatches.
  ///
  /// In en, this message translates to:
  /// **'Recent matches'**
  String get recentMatches;

  /// No description provided for @turnOrder.
  ///
  /// In en, this message translates to:
  /// **'Turn order'**
  String get turnOrder;

  /// No description provided for @first.
  ///
  /// In en, this message translates to:
  /// **'First'**
  String get first;

  /// No description provided for @second.
  ///
  /// In en, this message translates to:
  /// **'Second'**
  String get second;

  /// No description provided for @winsFraction.
  ///
  /// In en, this message translates to:
  /// **'{wins}/{total} wins'**
  String winsFraction(int wins, int total);

  /// No description provided for @recentTournaments.
  ///
  /// In en, this message translates to:
  /// **'Recent tournaments'**
  String get recentTournaments;

  /// No description provided for @noTournamentsYet.
  ///
  /// In en, this message translates to:
  /// **'No tournaments recorded yet.'**
  String get noTournamentsYet;

  /// No description provided for @tournamentsLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Tournaments could not be loaded.\n{error}'**
  String tournamentsLoadFailed(Object error);

  /// No description provided for @lossRate.
  ///
  /// In en, this message translates to:
  /// **'Loss rate'**
  String get lossRate;

  /// No description provided for @winsLossesSummary.
  ///
  /// In en, this message translates to:
  /// **'{wins}–{losses}  ({wins} wins / {total} matches)'**
  String winsLossesSummary(int wins, int losses, int total);

  /// No description provided for @vsNameRange.
  ///
  /// In en, this message translates to:
  /// **'vs. {name} • {rate}% ({range})'**
  String vsNameRange(String name, String rate, String range);

  /// No description provided for @vsOpponent.
  ///
  /// In en, this message translates to:
  /// **'vs. {name}'**
  String vsOpponent(String name);

  /// No description provided for @noDecksYet.
  ///
  /// In en, this message translates to:
  /// **'No decks yet.\nTap + at the bottom right to create your first deck!'**
  String get noDecksYet;

  /// No description provided for @deleteDeckQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete this deck?'**
  String get deleteDeckQuestion;

  /// No description provided for @deleteDeckBody.
  ///
  /// In en, this message translates to:
  /// **'Deck \"{name}\" and ALL related matches will be deleted permanently!'**
  String deleteDeckBody(String name);

  /// No description provided for @deckDeleted.
  ///
  /// In en, this message translates to:
  /// **'Deck \"{name}\" deleted.'**
  String deckDeleted(String name);

  /// No description provided for @deckArchived.
  ///
  /// In en, this message translates to:
  /// **'Deck \"{name}\" archived.'**
  String deckArchived(String name);

  /// No description provided for @linkOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'The link could not be opened.'**
  String get linkOpenFailed;

  /// No description provided for @matchSingular.
  ///
  /// In en, this message translates to:
  /// **'match'**
  String get matchSingular;

  /// No description provided for @matchPlural.
  ///
  /// In en, this message translates to:
  /// **'matches'**
  String get matchPlural;

  /// No description provided for @fillRequiredFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all required fields.'**
  String get fillRequiredFields;

  /// No description provided for @invalidDecklistUrl.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid decklist URL.'**
  String get invalidDecklistUrl;

  /// No description provided for @cardGame.
  ///
  /// In en, this message translates to:
  /// **'Card game'**
  String get cardGame;

  /// No description provided for @deckName.
  ///
  /// In en, this message translates to:
  /// **'Deck name'**
  String get deckName;

  /// No description provided for @decklistLinkOptional.
  ///
  /// In en, this message translates to:
  /// **'Decklist link (optional)'**
  String get decklistLinkOptional;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptional;

  /// No description provided for @addDeck.
  ///
  /// In en, this message translates to:
  /// **'Add deck'**
  String get addDeck;

  /// No description provided for @editDeck.
  ///
  /// In en, this message translates to:
  /// **'Edit deck'**
  String get editDeck;

  /// No description provided for @viewDecklist.
  ///
  /// In en, this message translates to:
  /// **'View decklist'**
  String get viewDecklist;

  /// No description provided for @noMatchesForDeck.
  ///
  /// In en, this message translates to:
  /// **'No matches recorded for this deck yet.\nTap + below to add a match!'**
  String get noMatchesForDeck;

  /// No description provided for @noMatchesForFilter.
  ///
  /// In en, this message translates to:
  /// **'No matches found for this filter.'**
  String get noMatchesForFilter;

  /// No description provided for @deleteMatchQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete match?'**
  String get deleteMatchQuestion;

  /// No description provided for @deleteMatchBody.
  ///
  /// In en, this message translates to:
  /// **'Do you really want to delete the game against {name}?'**
  String deleteMatchBody(String name);

  /// No description provided for @matchDeleted.
  ///
  /// In en, this message translates to:
  /// **'Match deleted.'**
  String get matchDeleted;

  /// No description provided for @statsTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} - Stats'**
  String statsTitle(String name);

  /// No description provided for @noStatsYet.
  ///
  /// In en, this message translates to:
  /// **'No matches yet to calculate statistics.'**
  String get noStatsYet;

  /// No description provided for @matchupsVsArchetypes.
  ///
  /// In en, this message translates to:
  /// **'Matchups against archetypes'**
  String get matchupsVsArchetypes;

  /// No description provided for @winsOfGames.
  ///
  /// In en, this message translates to:
  /// **'{wins} wins of {total} games'**
  String winsOfGames(int wins, int total);

  /// No description provided for @needDeckForMatch.
  ///
  /// In en, this message translates to:
  /// **'Create a deck first to record matches.'**
  String get needDeckForMatch;

  /// No description provided for @noToolPresets.
  ///
  /// In en, this message translates to:
  /// **'No tool presets available.'**
  String get noToolPresets;

  /// No description provided for @recordMatch.
  ///
  /// In en, this message translates to:
  /// **'Record match'**
  String get recordMatch;

  /// No description provided for @chooseOwnDeck.
  ///
  /// In en, this message translates to:
  /// **'Choose your deck'**
  String get chooseOwnDeck;

  /// No description provided for @editMatch.
  ///
  /// In en, this message translates to:
  /// **'Edit match'**
  String get editMatch;

  /// No description provided for @logMatch.
  ///
  /// In en, this message translates to:
  /// **'Log match'**
  String get logMatch;

  /// No description provided for @needOpponentDeck.
  ///
  /// In en, this message translates to:
  /// **'Please enter the opponent’s deck.'**
  String get needOpponentDeck;

  /// No description provided for @win.
  ///
  /// In en, this message translates to:
  /// **'Win'**
  String get win;

  /// No description provided for @loss.
  ///
  /// In en, this message translates to:
  /// **'Loss'**
  String get loss;

  /// No description provided for @draw.
  ///
  /// In en, this message translates to:
  /// **'Draw'**
  String get draw;

  /// No description provided for @opponentDeckArchetype.
  ///
  /// In en, this message translates to:
  /// **'Opponent deck / archetype'**
  String get opponentDeckArchetype;

  /// No description provided for @opponentDeck.
  ///
  /// In en, this message translates to:
  /// **'Opponent deck'**
  String get opponentDeck;

  /// No description provided for @format.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get format;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// No description provided for @eventTags.
  ///
  /// In en, this message translates to:
  /// **'Event tags'**
  String get eventTags;

  /// No description provided for @scoreOptional.
  ///
  /// In en, this message translates to:
  /// **'Score (optional, e.g. 2-1)'**
  String get scoreOptional;

  /// No description provided for @rollTitle.
  ///
  /// In en, this message translates to:
  /// **'Randomize'**
  String get rollTitle;

  /// No description provided for @d20.
  ///
  /// In en, this message translates to:
  /// **'D20'**
  String get d20;

  /// No description provided for @d6.
  ///
  /// In en, this message translates to:
  /// **'D6'**
  String get d6;

  /// No description provided for @coin.
  ///
  /// In en, this message translates to:
  /// **'Coin'**
  String get coin;

  /// No description provided for @multi.
  ///
  /// In en, this message translates to:
  /// **'Multi'**
  String get multi;

  /// No description provided for @rollDie.
  ///
  /// In en, this message translates to:
  /// **'Roll D{sides}'**
  String rollDie(int sides);

  /// No description provided for @flipCoin.
  ///
  /// In en, this message translates to:
  /// **'Flip coin'**
  String get flipCoin;

  /// No description provided for @rollMulti.
  ///
  /// In en, this message translates to:
  /// **'Roll {count}×D{sides}'**
  String rollMulti(int count, int sides);

  /// No description provided for @deleteTournamentQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete tournament?'**
  String get deleteTournamentQuestion;

  /// No description provided for @deleteTournamentBody.
  ///
  /// In en, this message translates to:
  /// **'“{name}” will be deleted permanently.'**
  String deleteTournamentBody(String name);

  /// No description provided for @tournamentDeleted.
  ///
  /// In en, this message translates to:
  /// **'“{name}” deleted.'**
  String tournamentDeleted(String name);

  /// No description provided for @noTournamentsHint.
  ///
  /// In en, this message translates to:
  /// **'No tournaments yet.\nRecord store championships, regionals and opens.'**
  String get noTournamentsHint;

  /// No description provided for @needNameTcgDeck.
  ///
  /// In en, this message translates to:
  /// **'Please fill in name, TCG and deck.'**
  String get needNameTcgDeck;

  /// No description provided for @placementMustBeNumber.
  ///
  /// In en, this message translates to:
  /// **'Placement must be a number.'**
  String get placementMustBeNumber;

  /// No description provided for @participantsMustBeNumber.
  ///
  /// In en, this message translates to:
  /// **'Participant count must be a number.'**
  String get participantsMustBeNumber;

  /// No description provided for @placementMinOne.
  ///
  /// In en, this message translates to:
  /// **'Placement must be at least 1.'**
  String get placementMinOne;

  /// No description provided for @placementVsField.
  ///
  /// In en, this message translates to:
  /// **'Placement cannot be greater than the field size.'**
  String get placementVsField;

  /// No description provided for @tournamentName.
  ///
  /// In en, this message translates to:
  /// **'Tournament name'**
  String get tournamentName;

  /// No description provided for @chooseTcg.
  ///
  /// In en, this message translates to:
  /// **'Choose TCG'**
  String get chooseTcg;

  /// No description provided for @chooseGameFirst.
  ///
  /// In en, this message translates to:
  /// **'Choose a card game first'**
  String get chooseGameFirst;

  /// No description provided for @noDecksForTcg.
  ///
  /// In en, this message translates to:
  /// **'No decks for this TCG'**
  String get noDecksForTcg;

  /// No description provided for @chooseDeck.
  ///
  /// In en, this message translates to:
  /// **'Choose deck'**
  String get chooseDeck;

  /// No description provided for @playedDeck.
  ///
  /// In en, this message translates to:
  /// **'Deck played'**
  String get playedDeck;

  /// No description provided for @place.
  ///
  /// In en, this message translates to:
  /// **'Place'**
  String get place;

  /// No description provided for @participants.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get participants;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @addTournament.
  ///
  /// In en, this message translates to:
  /// **'Add tournament'**
  String get addTournament;

  /// No description provided for @editTournament.
  ///
  /// In en, this message translates to:
  /// **'Edit tournament'**
  String get editTournament;

  /// No description provided for @noMatchingMatches.
  ///
  /// In en, this message translates to:
  /// **'No matching matches found.'**
  String get noMatchingMatches;

  /// No description provided for @relatedMatchesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} matches linked'**
  String relatedMatchesCount(int count);

  /// No description provided for @matchesLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Matches could not be loaded: {error}'**
  String matchesLoadFailed(Object error);

  /// No description provided for @relatedMatchesTagsAndDeck.
  ///
  /// In en, this message translates to:
  /// **'Matches with the same tags and deck “{deck}”.'**
  String relatedMatchesTagsAndDeck(String deck);

  /// No description provided for @relatedMatchesTags.
  ///
  /// In en, this message translates to:
  /// **'Matches with the same tags.'**
  String get relatedMatchesTags;

  /// No description provided for @noPlacement.
  ///
  /// In en, this message translates to:
  /// **'No placement'**
  String get noPlacement;

  /// No description provided for @placementOf.
  ///
  /// In en, this message translates to:
  /// **'#{place} / {total}'**
  String placementOf(int place, int total);

  /// No description provided for @firstPlace.
  ///
  /// In en, this message translates to:
  /// **'1st place'**
  String get firstPlace;

  /// No description provided for @topPlacement.
  ///
  /// In en, this message translates to:
  /// **'Top {place}'**
  String topPlacement(int place);

  /// No description provided for @placeNumber.
  ///
  /// In en, this message translates to:
  /// **'Place {place}'**
  String placeNumber(int place);

  /// No description provided for @promoOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'The partner link could not be opened.'**
  String get promoOpenFailed;

  /// No description provided for @supportCardmarketTitle.
  ///
  /// In en, this message translates to:
  /// **'Cards & accessories on Cardmarket'**
  String get supportCardmarketTitle;

  /// No description provided for @supportCardmarketSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Support the app with your next purchase'**
  String get supportCardmarketSubtitle;

  /// No description provided for @supportCoffeeTitle.
  ///
  /// In en, this message translates to:
  /// **'Buy me a coffee'**
  String get supportCoffeeTitle;

  /// No description provided for @supportCoffeeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Support development via Buy Me a Coffee'**
  String get supportCoffeeSubtitle;

  /// No description provided for @supportGithubStarTitle.
  ///
  /// In en, this message translates to:
  /// **'Star the GitHub project'**
  String get supportGithubStarTitle;

  /// No description provided for @supportGithubStarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Give the app a star on GitHub'**
  String get supportGithubStarSubtitle;

  /// No description provided for @supportDiscordTitle.
  ///
  /// In en, this message translates to:
  /// **'Community & feedback on Discord'**
  String get supportDiscordTitle;

  /// No description provided for @supportDiscordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Chat with players or share ideas'**
  String get supportDiscordSubtitle;

  /// No description provided for @supportGithubIssueTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a GitHub issue'**
  String get supportGithubIssueTitle;

  /// No description provided for @supportGithubIssueSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Report a bug or request a feature'**
  String get supportGithubIssueSubtitle;

  /// No description provided for @toolsTabChakra.
  ///
  /// In en, this message translates to:
  /// **'Chakra (Naruto)'**
  String get toolsTabChakra;

  /// No description provided for @toolsTabLife.
  ///
  /// In en, this message translates to:
  /// **'Life Counter'**
  String get toolsTabLife;

  /// No description provided for @toolsTabTimer.
  ///
  /// In en, this message translates to:
  /// **'Round timer'**
  String get toolsTabTimer;

  /// No description provided for @chakraReadyLabel.
  ///
  /// In en, this message translates to:
  /// **'Available chakra (Ready)'**
  String get chakraReadyLabel;

  /// No description provided for @chakraReadyRatio.
  ///
  /// In en, this message translates to:
  /// **'{available} / {total} Ready'**
  String chakraReadyRatio(int available, int total);

  /// No description provided for @chakraTappedHint.
  ///
  /// In en, this message translates to:
  /// **'{tapped} tapped'**
  String chakraTappedHint(int tapped);

  /// No description provided for @chakraPay1.
  ///
  /// In en, this message translates to:
  /// **'Pay 1 chakra'**
  String get chakraPay1;

  /// No description provided for @chakraPay2.
  ///
  /// In en, this message translates to:
  /// **'Pay 2 chakra'**
  String get chakraPay2;

  /// No description provided for @chakraEndTurn.
  ///
  /// In en, this message translates to:
  /// **'End round / New turn'**
  String get chakraEndTurn;

  /// No description provided for @chakraRefreshOnly.
  ///
  /// In en, this message translates to:
  /// **'Refresh only'**
  String get chakraRefreshOnly;

  /// No description provided for @chakraDeckTitle.
  ///
  /// In en, this message translates to:
  /// **'Chakra deck'**
  String get chakraDeckTitle;

  /// No description provided for @chakraDeckRemaining.
  ///
  /// In en, this message translates to:
  /// **'{remaining} / 12 left'**
  String chakraDeckRemaining(int remaining);

  /// No description provided for @chakraZoneMax.
  ///
  /// In en, this message translates to:
  /// **'Chakra zone max'**
  String get chakraZoneMax;

  /// No description provided for @chakraResetTurn1.
  ///
  /// In en, this message translates to:
  /// **'Reset to turn 1'**
  String get chakraResetTurn1;

  /// No description provided for @lifeYou.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get lifeYou;

  /// No description provided for @lifeOpponent.
  ///
  /// In en, this message translates to:
  /// **'Opponent'**
  String get lifeOpponent;

  /// No description provided for @lifePresetMtg.
  ///
  /// In en, this message translates to:
  /// **'20 MTG'**
  String get lifePresetMtg;

  /// No description provided for @lifePresetOp.
  ///
  /// In en, this message translates to:
  /// **'50 OP'**
  String get lifePresetOp;

  /// No description provided for @lifePresetYgo.
  ///
  /// In en, this message translates to:
  /// **'8000 YGO'**
  String get lifePresetYgo;

  /// No description provided for @timerStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get timerStart;

  /// No description provided for @timerPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get timerPause;

  /// No description provided for @timerPreset30.
  ///
  /// In en, this message translates to:
  /// **'30 min'**
  String get timerPreset30;

  /// No description provided for @timerPreset45.
  ///
  /// In en, this message translates to:
  /// **'45 min'**
  String get timerPreset45;

  /// No description provided for @timerPreset50.
  ///
  /// In en, this message translates to:
  /// **'50 min'**
  String get timerPreset50;

  /// No description provided for @timerAddFive.
  ///
  /// In en, this message translates to:
  /// **'+5 min extension'**
  String get timerAddFive;

  /// No description provided for @toolsTabDice.
  ///
  /// In en, this message translates to:
  /// **'Dice & coin'**
  String get toolsTabDice;

  /// No description provided for @coinHeads.
  ///
  /// In en, this message translates to:
  /// **'Heads'**
  String get coinHeads;

  /// No description provided for @coinTails.
  ///
  /// In en, this message translates to:
  /// **'Tails'**
  String get coinTails;

  /// No description provided for @randomStarter.
  ///
  /// In en, this message translates to:
  /// **'Random first player'**
  String get randomStarter;

  /// No description provided for @starterResult.
  ///
  /// In en, this message translates to:
  /// **'{name} goes first'**
  String starterResult(String name);

  /// No description provided for @playerOne.
  ///
  /// In en, this message translates to:
  /// **'Player 1'**
  String get playerOne;

  /// No description provided for @playerTwo.
  ///
  /// In en, this message translates to:
  /// **'Player 2'**
  String get playerTwo;

  /// No description provided for @saveMatch.
  ///
  /// In en, this message translates to:
  /// **'Save match'**
  String get saveMatch;

  /// No description provided for @displayNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get displayNameLabel;

  /// No description provided for @editDisplayNameTitle.
  ///
  /// In en, this message translates to:
  /// **'Change display name'**
  String get editDisplayNameTitle;

  /// No description provided for @displayNameHint.
  ///
  /// In en, this message translates to:
  /// **'Player name'**
  String get displayNameHint;

  /// No description provided for @displayNameSaved.
  ///
  /// In en, this message translates to:
  /// **'Display name updated.'**
  String get displayNameSaved;

  /// No description provided for @displayNameFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update display name: {error}'**
  String displayNameFailed(Object error);

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePasswordTitle;

  /// No description provided for @changePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set a new password for this account'**
  String get changePasswordSubtitle;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters.'**
  String get passwordTooShort;

  /// No description provided for @passwordsMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordsMismatch;

  /// No description provided for @passwordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password updated.'**
  String get passwordUpdated;

  /// No description provided for @passwordUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not update password: {error}'**
  String passwordUpdateFailed(Object error);

  /// No description provided for @legalTrademarksTitle.
  ///
  /// In en, this message translates to:
  /// **'Trademarks & copyright'**
  String get legalTrademarksTitle;

  /// No description provided for @legalTrademarksBody.
  ///
  /// In en, this message translates to:
  /// **'All mentioned brand names, game titles, logos and trademarks (including Pokémon, Magic: The Gathering, Yu-Gi-Oh!, One Piece, Naruto Mythos, Riftbound) are registered trademarks of their respective owners. This app is an unofficial fan project and is not affiliated with, endorsed by, or commercially connected to the rights holders.'**
  String get legalTrademarksBody;

  /// No description provided for @legalPrivacyStructuredTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy (GDPR)'**
  String get legalPrivacyStructuredTitle;

  /// No description provided for @legalPrivacyStructuredBody.
  ///
  /// In en, this message translates to:
  /// **'We process account data (email address, match records, decks and related play statistics) via Supabase solely to provide the app. You have the right to access your data, export it (JSON/CSV backup in Settings) and delete your account completely from Settings. Data is not sold to third parties for advertising.'**
  String get legalPrivacyStructuredBody;

  /// No description provided for @legalAffiliateTitle.
  ///
  /// In en, this message translates to:
  /// **'Affiliate & partner notice'**
  String get legalAffiliateTitle;

  /// No description provided for @legalAffiliateBody.
  ///
  /// In en, this message translates to:
  /// **'This app contains referral and partner links (for example to Cardmarket). Purchases made through these links may earn us a commission or advertising credit, at no extra cost to you.'**
  String get legalAffiliateBody;

  /// No description provided for @legalContactStructuredTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact & imprint'**
  String get legalContactStructuredTitle;

  /// No description provided for @legalContactStructuredBody.
  ///
  /// In en, this message translates to:
  /// **'For support and legal inquiries please use the project repository:\nhttps://github.com/Patrike260/tcg_counter_app'**
  String get legalContactStructuredBody;

  /// No description provided for @legalGithub.
  ///
  /// In en, this message translates to:
  /// **'GitHub repository'**
  String get legalGithub;

  /// No description provided for @themeModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get themeModeLabel;

  /// No description provided for @themeModeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeModeSystem;

  /// No description provided for @themeModeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeModeLight;

  /// No description provided for @themeModeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeModeDark;

  /// No description provided for @presetCyberpunk.
  ///
  /// In en, this message translates to:
  /// **'Cyberpunk'**
  String get presetCyberpunk;

  /// No description provided for @presetPaper.
  ///
  /// In en, this message translates to:
  /// **'Paper Manga'**
  String get presetPaper;

  /// No description provided for @presetCrimson.
  ///
  /// In en, this message translates to:
  /// **'Crimson'**
  String get presetCrimson;

  /// No description provided for @presetCell.
  ///
  /// In en, this message translates to:
  /// **'Cell Green'**
  String get presetCell;

  /// No description provided for @deckWinRateNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get deckWinRateNew;

  /// No description provided for @deckWinRateBadge.
  ///
  /// In en, this message translates to:
  /// **'{percent}% • {count}G'**
  String deckWinRateBadge(int percent, int count);

  /// No description provided for @chakraPoolLabel.
  ///
  /// In en, this message translates to:
  /// **'Chakra paid / pool'**
  String get chakraPoolLabel;

  /// No description provided for @chakraPointsLabel.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get chakraPointsLabel;

  /// No description provided for @chakraResetBoard.
  ///
  /// In en, this message translates to:
  /// **'Reset board'**
  String get chakraResetBoard;

  /// No description provided for @toolsTabDigimon.
  ///
  /// In en, this message translates to:
  /// **'Digimon Memory'**
  String get toolsTabDigimon;

  /// No description provided for @digimonTurnP1.
  ///
  /// In en, this message translates to:
  /// **'Turn: Player 1'**
  String get digimonTurnP1;

  /// No description provided for @digimonTurnP2.
  ///
  /// In en, this message translates to:
  /// **'Turn: Player 2'**
  String get digimonTurnP2;

  /// No description provided for @digimonTurnPass.
  ///
  /// In en, this message translates to:
  /// **'Turn Pass'**
  String get digimonTurnPass;

  /// No description provided for @digimonSpend.
  ///
  /// In en, this message translates to:
  /// **'Spend memory'**
  String get digimonSpend;

  /// No description provided for @digimonCorrect.
  ///
  /// In en, this message translates to:
  /// **'Manual adjust'**
  String get digimonCorrect;

  /// No description provided for @digimonResetZero.
  ///
  /// In en, this message translates to:
  /// **'Reset to 0'**
  String get digimonResetZero;

  /// No description provided for @chakraCounterLabel.
  ///
  /// In en, this message translates to:
  /// **'Chakra'**
  String get chakraCounterLabel;

  /// No description provided for @lifePresetMtg60.
  ///
  /// In en, this message translates to:
  /// **'Magic 60-Card'**
  String get lifePresetMtg60;

  /// No description provided for @lifePresetCommander.
  ///
  /// In en, this message translates to:
  /// **'Commander'**
  String get lifePresetCommander;

  /// No description provided for @lifePresetYgoName.
  ///
  /// In en, this message translates to:
  /// **'Yu-Gi-Oh!'**
  String get lifePresetYgoName;

  /// No description provided for @lifePresetAdd.
  ///
  /// In en, this message translates to:
  /// **'Add preset'**
  String get lifePresetAdd;

  /// No description provided for @lifePresetName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get lifePresetName;

  /// No description provided for @lifePresetStartLp.
  ///
  /// In en, this message translates to:
  /// **'Starting LP'**
  String get lifePresetStartLp;

  /// No description provided for @lifePresetStepSmall.
  ///
  /// In en, this message translates to:
  /// **'Tap step (±)'**
  String get lifePresetStepSmall;

  /// No description provided for @lifePresetStepLarge.
  ///
  /// In en, this message translates to:
  /// **'Long-press (±)'**
  String get lifePresetStepLarge;

  /// No description provided for @lifePresetInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a name and numbers greater than 0.'**
  String get lifePresetInvalid;

  /// No description provided for @deckSortNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get deckSortNewest;

  /// No description provided for @deckSortGrouped.
  ///
  /// In en, this message translates to:
  /// **'By TCG'**
  String get deckSortGrouped;

  /// No description provided for @deckSortCustom.
  ///
  /// In en, this message translates to:
  /// **'Reorder'**
  String get deckSortCustom;

  /// No description provided for @deckGroupHeader.
  ///
  /// In en, this message translates to:
  /// **'{game} ({count} decks)'**
  String deckGroupHeader(String game, int count);

  /// No description provided for @toolsTabCyberpunk.
  ///
  /// In en, this message translates to:
  /// **'Gig Dice'**
  String get toolsTabCyberpunk;

  /// No description provided for @gigPool.
  ///
  /// In en, this message translates to:
  /// **'Unrolled'**
  String get gigPool;

  /// No description provided for @gigCenter.
  ///
  /// In en, this message translates to:
  /// **'Center board'**
  String get gigCenter;

  /// No description provided for @gigStreetCred.
  ///
  /// In en, this message translates to:
  /// **'Street Cred'**
  String get gigStreetCred;

  /// No description provided for @gigNewRound.
  ///
  /// In en, this message translates to:
  /// **'New round'**
  String get gigNewRound;

  /// No description provided for @gigAdjustValue.
  ///
  /// In en, this message translates to:
  /// **'Adjust value'**
  String get gigAdjustValue;

  /// No description provided for @gigSteal.
  ///
  /// In en, this message translates to:
  /// **'Steal'**
  String get gigSteal;

  /// No description provided for @gigRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove / spend'**
  String get gigRemove;

  /// No description provided for @gigStolen.
  ///
  /// In en, this message translates to:
  /// **'STOLEN'**
  String get gigStolen;

  /// No description provided for @gigCredShort.
  ///
  /// In en, this message translates to:
  /// **'CRED'**
  String get gigCredShort;

  /// No description provided for @gigGigs.
  ///
  /// In en, this message translates to:
  /// **'Gigs'**
  String get gigGigs;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'fr', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
