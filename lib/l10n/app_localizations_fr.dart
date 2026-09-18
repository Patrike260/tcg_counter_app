// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'TCG Tracker';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get delete => 'Supprimer';

  @override
  String get add => 'Ajouter';

  @override
  String get close => 'Fermer';

  @override
  String get continueAction => 'Continuer';

  @override
  String get apply => 'Appliquer';

  @override
  String get create => 'Créer';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get all => 'Tous';

  @override
  String get edit => 'Modifier';

  @override
  String get archive => 'Archiver';

  @override
  String get or => 'OU';

  @override
  String get from => 'sur';

  @override
  String get version => 'Version';

  @override
  String get versionSubtitle => 'Web / PWA';

  @override
  String errorWithDetails(Object error) {
    return 'Erreur : $error';
  }

  @override
  String loadErrorWithDetails(Object error) {
    return 'Impossible de charger : $error';
  }

  @override
  String gamesLoadError(Object error) {
    return 'Impossible de charger les jeux : $error';
  }

  @override
  String decksLoadError(Object error) {
    return 'Impossible de charger les decks : $error';
  }

  @override
  String get noUserLoggedIn => 'Aucun utilisateur connecté';

  @override
  String userIdShort(String id) {
    return 'ID : $id...';
  }

  @override
  String get navDashboard => 'Tableau de bord';

  @override
  String get navDecks => 'Decks';

  @override
  String get navTools => 'Outils';

  @override
  String get navSettings => 'Réglages';

  @override
  String get titleMyDecks => 'Mes decks';

  @override
  String get tooltipDashboardFilter => 'Filtres du tableau de bord';

  @override
  String get tooltipDiceCoin => 'Pièce et dés';

  @override
  String get noTcg => 'Aucun TCG';

  @override
  String get turnFree => 'Tour libre';

  @override
  String get turnFirstShort => '1st';

  @override
  String get turnSecondShort => '2nd';

  @override
  String get turnFirstFull => '1st (premier)';

  @override
  String get turnSecondFull => '2nd (second)';

  @override
  String get formatBo1 => 'Best of 1';

  @override
  String get formatBo3 => 'Best of 3';

  @override
  String get bo1 => 'BO1';

  @override
  String get bo3 => 'BO3';

  @override
  String get allFormats => 'Tous les formats';

  @override
  String get languageTitle => 'Langue';

  @override
  String get languageSubtitle => 'Choisir la langue de l’app';

  @override
  String get languageSystem => 'Langue du système';

  @override
  String get languageSystemSubtitle => 'Suivre la langue de l’appareil';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageFrench => 'Français';

  @override
  String get languageItalian => 'Italiano';

  @override
  String get loginTitle => 'Connexion TCG Tracker';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get signIn => 'Se connecter';

  @override
  String get register => 'S’inscrire';

  @override
  String get alreadyHaveAccount => 'Déjà un compte ? Se connecter';

  @override
  String get noAccountYet => 'Pas encore de compte ? S’inscrire';

  @override
  String get continueWithGoogle => 'Continuer avec Google';

  @override
  String get enterEmailPassword => 'Veuillez saisir e-mail et mot de passe.';

  @override
  String get registrationSuccess => 'Inscription réussie !';

  @override
  String googleLoginFailed(Object error) {
    return 'Connexion Google échouée : $error';
  }

  @override
  String get legalAcceptHint =>
      'En vous inscrivant, vous acceptez nos conditions d’utilisation et notre politique de confidentialité.';

  @override
  String get sectionAppearance => 'APPARENCE';

  @override
  String get sectionSettings => 'RÉGLAGES';

  @override
  String get sectionContent => 'GESTION ET CONTENU';

  @override
  String get sectionBackup => 'DONNÉES ET SAUVEGARDE';

  @override
  String get sectionAccount => 'COMPTE ET INFOS';

  @override
  String get themePresetsTitle => 'Thèmes et couleurs';

  @override
  String get dashboardTabsTitle => 'Configurer onglets et tuiles';

  @override
  String get dashboardTabsSubtitle => 'Ordre, onglets et widgets affichés';

  @override
  String get matchDefaultsTitle => 'Matchs et valeurs par défaut';

  @override
  String get visibleTcgsTitle => 'TCG visibles';

  @override
  String get visibleTcgsSubtitle => 'Masquer des jeux dans les listes';

  @override
  String get manageTcgsTitle => 'Gérer les jeux (TCG)';

  @override
  String get manageTcgsSubtitle => 'Ajouter ou renommer des jeux';

  @override
  String get toolPresetsTitle => 'Gérer les préréglages d’outils';

  @override
  String get toolPresetsSubtitle => 'Life counter, joueurs et minuteur';

  @override
  String get tournamentsTitle => 'Tournois et événements';

  @override
  String get tournamentsSubtitle => 'Noter classements et decks joués';

  @override
  String get archetypesTitle => 'Gérer les archétypes adverses';

  @override
  String get archetypesSubtitle => 'Renommer ou nettoyer les suggestions';

  @override
  String get eventTagsTitle => 'Gérer les tags d’événements';

  @override
  String get eventTagsSubtitle => 'Créer des tags pour tournois ou cups';

  @override
  String get exportCsvTitle => 'Exporter les matchs en CSV';

  @override
  String get exportCsvSubtitle => 'Idéal pour Excel ou un tableur';

  @override
  String get exportJsonTitle => 'Sauvegarde complète (JSON)';

  @override
  String get exportJsonSubtitle => 'Enregistre tous les decks et matchs';

  @override
  String get restoreBackupTitle => 'Restaurer une sauvegarde';

  @override
  String get restoreBackupSubtitle => 'Importer un fichier JSON';

  @override
  String get legalSettingsTitle => 'Conditions et confidentialité';

  @override
  String get legalSettingsSubtitle => 'CGU, mentions et disclaimer';

  @override
  String get signOutTitle => 'Se déconnecter';

  @override
  String get signOutSubtitle => 'Terminer la session';

  @override
  String get deleteAccountTitle => 'Supprimer le compte définitivement';

  @override
  String get deleteAccountSubtitle => 'Supprimer compte, decks et matchs';

  @override
  String get csvExported => 'Matchs exportés en CSV !';

  @override
  String csvExportFailed(Object error) {
    return 'Échec de l’export CSV : $error';
  }

  @override
  String get jsonBackupCreated => 'Sauvegarde JSON créée !';

  @override
  String jsonBackupFailed(Object error) {
    return 'Échec de l’export : $error';
  }

  @override
  String get fileReadFailed => 'Le fichier n’a pas pu être lu.';

  @override
  String get restoreBackupQuestion => 'Restaurer la sauvegarde ?';

  @override
  String get restoreBackupBody =>
      'Les decks et matchs existants seront fusionnés ou mis à jour.';

  @override
  String get restore => 'Restaurer';

  @override
  String matchesRestored(int count) {
    return '$count matchs restaurés !';
  }

  @override
  String restoreFailed(Object error) {
    return 'Restauration échouée : $error';
  }

  @override
  String get deleteAccountQuestion => 'Supprimer le compte ?';

  @override
  String get deleteAccountBody =>
      'Voulez-vous vraiment supprimer définitivement votre compte ainsi que tous les decks et matchs enregistrés ?';

  @override
  String get lastConfirmation => 'Dernière confirmation';

  @override
  String get deleteAccountFinalBody =>
      'Cette action est irréversible. Le compte et toutes les données du tracker seront supprimés.';

  @override
  String get deletePermanently => 'Supprimer définitivement';

  @override
  String deleteAccountFailed(Object error) {
    return 'Impossible de supprimer le compte : $error';
  }

  @override
  String get legalScreenTitle => 'Mentions légales et confidentialité';

  @override
  String get legalIntro =>
      'Veuillez lire les informations suivantes avant d’utiliser l’app ou de créer un compte.';

  @override
  String get legalTermsTitle => 'Conditions d’utilisation';

  @override
  String get legalTermsBody =>
      'TCG Tracker est un projet fan privé et non officiel. L’app sert à noter vos decks, matchs et classements de tournoi à la table. Ce n’est pas une offre commerciale ni un produit officiel des éditeurs de jeux de cartes.\n\nL’utilisation se fait à vos risques. Aucune garantie n’est donnée sur la disponibilité, l’absence d’erreurs ou la conservation des données. Une perte de données (panne, suppression de compte, évolution du service) n’est pas exclue. Faites vos propres sauvegardes si besoin.\n\nL’app est réservée à un usage privé. L’abus, l’extraction automatisée de comptes tiers ou le contournement de la sécurité sont interdits.';

  @override
  String get legalPrivacyTitle => 'Confidentialité (RGPD)';

  @override
  String get legalPrivacyBody =>
      'Le responsable du traitement au sens du RGPD est l’exploitant de cette app (voir mentions légales).\n\nNous stockons notamment : votre e-mail (compte), les données d’authentification et le contenu que vous saisissez (decks, résultats, notes, tags, tournois). Le stockage se fait dans le cloud Supabase (PostgreSQL avec RLS).\n\nLa finalité est la fourniture du tracker (exécution du contrat, art. 6, par. 1, b RGPD). Aucune transmission à des tiers à des fins publicitaires. Les prestataires techniques (hébergement/auth) ne traitent les données que pour le fonctionnement.\n\nVous disposez d’un droit d’accès, de rectification, de limitation, d’opposition et d’effacement. Utilisez « Supprimer le compte définitivement » dans les réglages.';

  @override
  String get legalDisclaimerTitle => 'Marques et copyright';

  @override
  String get legalDisclaimerBody =>
      'Pokémon, One Piece, Yu-Gi-Oh!, Magic: The Gathering, Dragon Ball Super et tous les autres jeux, personnages, logos et noms cités sont des marques ou des œuvres protégées de leurs titulaires, notamment Nintendo, The Pokémon Company, Bandai, Toei Animation, Konami, Wizards of the Coast / Hasbro et d’autres concédants.\n\nCette app n’est pas affiliée à ces entreprises. Il s’agit d’un projet fan indépendant. Les noms de jeux servent uniquement à suivre vos propres parties. Aucune image de carte officielle n’est vendue ou concédée comme partie du produit.';

  @override
  String get legalImprintTitle => 'Mentions légales et contact';

  @override
  String get legalImprintBody =>
      'Informations légales :\n\nExploitant / développeur :\n[Prénom et nom]\n[Rue et numéro]\n[CP Ville]\nAllemagne\n\nContact :\nE-mail : kontakt@example.com\n\nRemplacez les espaces réservés par les informations réelles avant une mise en ligne publique.';

  @override
  String get themeScreenTitle => 'Thème et design';

  @override
  String get themeLight => 'CLAIR';

  @override
  String get themeDark => 'SOMBRE';

  @override
  String get matchSettingsTitle => 'Réglages de match';

  @override
  String get defaultGame => 'Jeu de cartes par défaut';

  @override
  String get defaultFormat => 'Format de match par défaut';

  @override
  String get defaultTurnOrder => 'Ordre de tour par défaut';

  @override
  String get turnFreeLabel => 'Libre';

  @override
  String get rememberLastTags => 'Mémoriser les derniers tags';

  @override
  String get statsTimeRange => 'Période des statistiques';

  @override
  String get statsTimeRangeSubtitle =>
      'S’applique au winrate, némésis et performance TCG';

  @override
  String get dashboardGameFocus => 'Jeu ciblé du tableau de bord';

  @override
  String get dashboardGamePickerTitle => 'Jeu du tableau de bord';

  @override
  String get rangeWeek => 'Semaine';

  @override
  String get rangeMonth => 'Mois';

  @override
  String get rangeSeason => 'Saison';

  @override
  String get rangeYear => 'Année';

  @override
  String get rangeAllTime => 'Tout';

  @override
  String get visibleTcgsScreenTitle => 'TCG visibles';

  @override
  String get noGamesAvailable => 'Aucun jeu de cartes.';

  @override
  String get atLeastOneTcgVisible => 'Au moins un TCG doit rester visible.';

  @override
  String get addTcgTitle => 'Ajouter un TCG';

  @override
  String get renameTcgTitle => 'Renommer le TCG';

  @override
  String get gameNameLabel => 'Nom du jeu';

  @override
  String get newName => 'Nouveau nom';

  @override
  String get manageTcgsScreenTitle => 'Gérer les jeux (TCG)';

  @override
  String get toolPresetsScreenTitle => 'Préréglages d’outils';

  @override
  String get factoryResetQuestion => 'Réinitialiser ?';

  @override
  String get noPresets => 'Aucun préréglage.';

  @override
  String get keepOnePreset => 'Au moins un préréglage doit rester.';

  @override
  String get enterNameAndLp => 'Indiquez un nom et des LP de départ valides.';

  @override
  String get playerCount => 'Nombre de joueurs';

  @override
  String get roundTimer => 'Minuteur de round';

  @override
  String get minutes => 'Minutes';

  @override
  String minutesValue(int minutes) {
    return '$minutes min';
  }

  @override
  String get presetName => 'Nom';

  @override
  String get startingLp => 'LP de départ';

  @override
  String get createTagTitle => 'Créer un tag';

  @override
  String get tagNameHint => 'Nom du tag (ex. Store Cup, League)';

  @override
  String get manageTagsScreenTitle => 'Gérer les tags d’événements';

  @override
  String get standardTagsHeader => 'TAGS STANDARD (FIXES)';

  @override
  String get systemTagSubtitle => 'Tag système (non supprimable)';

  @override
  String get customTagsHeader => 'TAGS PERSONNALISÉS';

  @override
  String get createTag => 'Créer un tag';

  @override
  String get noCustomTags => 'Aucun tag personnalisé pour le moment.';

  @override
  String get deleteArchetypeQuestion => 'Supprimer l’archétype ?';

  @override
  String deleteArchetypeBody(String name) {
    return 'Retirer « $name » des suggestions automatiques ?';
  }

  @override
  String itemDeleted(String name) {
    return '« $name » supprimé.';
  }

  @override
  String deleteFailed(Object error) {
    return 'Suppression échouée : $error';
  }

  @override
  String get renameArchetypeTitle => 'Renommer l’archétype';

  @override
  String renamedTo(String name) {
    return 'Renommé en « $name ».';
  }

  @override
  String renameFailed(Object error) {
    return 'Renommage échoué : $error';
  }

  @override
  String get archetypesScreenTitle => 'Gérer les archétypes adverses';

  @override
  String get chooseCardGame => 'Choisir un jeu';

  @override
  String get noArchetypesForGame => 'Aucun archétype pour ce TCG.';

  @override
  String get dashboardConfigTitle => 'Configurer le tableau de bord';

  @override
  String get resetToDefault => 'Réinitialiser';

  @override
  String get resetDashboardQuestion => 'Réinitialiser ?';

  @override
  String get atLeastOneTab => 'Au moins un onglet doit rester actif.';

  @override
  String get allEvents => 'Tous les événements';

  @override
  String get focusEventTag => 'Tag d’événement ciblé';

  @override
  String get focusEventTagOptional => 'Tag d’événement (optionnel)';

  @override
  String get customDashboard => 'Tableau de bord perso';

  @override
  String get tabTitle => 'Titre';

  @override
  String get icon => 'Icône';

  @override
  String get startTiles => 'Tuiles de départ';

  @override
  String get widgetWinrate => 'Winrate global';

  @override
  String get widgetNemesis => 'Némésis et meilleur matchup';

  @override
  String get widgetPerformance => 'Performance par jeu';

  @override
  String get widgetRecent => 'Derniers matchs';

  @override
  String get widgetTournaments => 'Tournois et classements';

  @override
  String get widgetTurnOrder => 'Stats 1st / 2nd';

  @override
  String get tabAllround => 'Polyvalent';

  @override
  String get tabTournament => 'Tournoi';

  @override
  String get tabMinimal => 'Minimal';

  @override
  String get noDashboardTab => 'Aucun onglet de tableau de bord actif.';

  @override
  String eventFilter(String tag) {
    return 'Événement : $tag';
  }

  @override
  String get winrate => 'Winrate';

  @override
  String get matches => 'Matchs';

  @override
  String get wins => 'Victoires';

  @override
  String get recorded => 'Enregistrés';

  @override
  String winsOfTotal(int total) {
    return 'sur $total';
  }

  @override
  String get noMatchesInRange => 'Aucun match sur la période choisie';

  @override
  String noRepeatMatchups(String range) {
    return 'Aucun match contre des archétypes répétés sur la période ($range).\nIl faut au moins 2 matchs contre le même deck.';
  }

  @override
  String get bestMatchup => 'Meilleur matchup';

  @override
  String get nemesisDeck => 'Némésis / deck problème';

  @override
  String get performanceByGame => 'Performance par jeu';

  @override
  String get noMatchesVisibleTcgs =>
      'Pas encore de matchs pour les TCG visibles.';

  @override
  String winsOfMatches(int wins, int total) {
    return '$wins victoires sur $total matchs';
  }

  @override
  String get recentMatches => 'Derniers matchs';

  @override
  String get turnOrder => 'Ordre de tour';

  @override
  String get first => 'First';

  @override
  String get second => 'Second';

  @override
  String winsFraction(int wins, int total) {
    return '$wins/$total victoires';
  }

  @override
  String get recentTournaments => 'Derniers tournois';

  @override
  String get noTournamentsYet => 'Aucun tournoi enregistré.';

  @override
  String tournamentsLoadFailed(Object error) {
    return 'Impossible de charger les tournois.\n$error';
  }

  @override
  String get lossRate => 'Taux de défaites';

  @override
  String winsLossesSummary(int wins, int losses, int total) {
    return '$wins–$losses  ($wins victoires / $total matchs)';
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
      'Aucun deck pour le moment.\nAppuyez sur + en bas à droite pour créer le premier !';

  @override
  String get deleteDeckQuestion => 'Supprimer ce deck ?';

  @override
  String deleteDeckBody(String name) {
    return 'Le deck « $name » et TOUS les matchs associés seront définitivement supprimés !';
  }

  @override
  String deckDeleted(String name) {
    return 'Deck « $name » supprimé.';
  }

  @override
  String deckArchived(String name) {
    return 'Deck « $name » archivé.';
  }

  @override
  String get linkOpenFailed => 'Le lien n’a pas pu être ouvert.';

  @override
  String get matchSingular => 'match';

  @override
  String get matchPlural => 'matchs';

  @override
  String get fillRequiredFields =>
      'Veuillez remplir tous les champs obligatoires.';

  @override
  String get invalidDecklistUrl =>
      'Veuillez indiquer une URL de decklist valide.';

  @override
  String get cardGame => 'Jeu de cartes';

  @override
  String get deckName => 'Nom du deck';

  @override
  String get decklistLinkOptional => 'Lien decklist (optionnel)';

  @override
  String get notesOptional => 'Notes (optionnel)';

  @override
  String get addDeck => 'Ajouter un deck';

  @override
  String get editDeck => 'Modifier le deck';

  @override
  String get viewDecklist => 'Voir la decklist';

  @override
  String get noMatchesForDeck =>
      'Aucun match pour ce deck.\nAppuyez sur + pour en ajouter un !';

  @override
  String get noMatchesForFilter => 'Aucun match pour ce filtre.';

  @override
  String get deleteMatchQuestion => 'Supprimer le match ?';

  @override
  String deleteMatchBody(String name) {
    return 'Voulez-vous vraiment supprimer la partie contre $name ?';
  }

  @override
  String get matchDeleted => 'Match supprimé.';

  @override
  String statsTitle(String name) {
    return '$name - Stats';
  }

  @override
  String get noStatsYet => 'Aucun match pour calculer des statistiques.';

  @override
  String get matchupsVsArchetypes => 'Matchups contre les archétypes';

  @override
  String winsOfGames(int wins, int total) {
    return '$wins victoires sur $total parties';
  }

  @override
  String get needDeckForMatch =>
      'Créez d’abord un deck pour enregistrer des matchs.';

  @override
  String get noToolPresets => 'Aucun préréglage d’outil.';

  @override
  String get recordMatch => 'Enregistrer un match';

  @override
  String get chooseOwnDeck => 'Choisir votre deck';

  @override
  String get editMatch => 'Modifier le match';

  @override
  String get logMatch => 'Saisir un match';

  @override
  String get needOpponentDeck => 'Veuillez indiquer le deck adverse.';

  @override
  String get win => 'Victoire';

  @override
  String get loss => 'Défaite';

  @override
  String get draw => 'Égalité';

  @override
  String get opponentDeckArchetype => 'Deck / archétype adverse';

  @override
  String get opponentDeck => 'Deck adverse';

  @override
  String get format => 'Format';

  @override
  String get order => 'Ordre';

  @override
  String get eventTags => 'Tags d’événement';

  @override
  String get scoreOptional => 'Score (optionnel, ex. 2-1)';

  @override
  String get rollTitle => 'Tirage';

  @override
  String get d20 => 'D20';

  @override
  String get d6 => 'D6';

  @override
  String get coin => 'Pièce';

  @override
  String get multi => 'Multi';

  @override
  String rollDie(int sides) {
    return 'Lancer D$sides';
  }

  @override
  String get flipCoin => 'Lancer la pièce';

  @override
  String rollMulti(int count, int sides) {
    return 'Lancer $count×D$sides';
  }

  @override
  String get deleteTournamentQuestion => 'Supprimer le tournoi ?';

  @override
  String deleteTournamentBody(String name) {
    return '« $name » sera définitivement supprimé.';
  }

  @override
  String tournamentDeleted(String name) {
    return '« $name » supprimé.';
  }

  @override
  String get noTournamentsHint =>
      'Aucun tournoi.\nNotez store championships, regionals et opens.';

  @override
  String get needNameTcgDeck => 'Veuillez renseigner nom, TCG et deck.';

  @override
  String get placementMustBeNumber => 'Le classement doit être un nombre.';

  @override
  String get participantsMustBeNumber =>
      'Le nombre de participants doit être un nombre.';

  @override
  String get placementMinOne => 'Le classement doit être au moins 1.';

  @override
  String get placementVsField =>
      'Le classement ne peut pas dépasser le nombre de participants.';

  @override
  String get tournamentName => 'Nom du tournoi';

  @override
  String get chooseTcg => 'Choisir un TCG';

  @override
  String get chooseGameFirst => 'Choisissez d’abord un jeu';

  @override
  String get noDecksForTcg => 'Aucun deck pour ce TCG';

  @override
  String get chooseDeck => 'Choisir un deck';

  @override
  String get playedDeck => 'Deck joué';

  @override
  String get place => 'Place';

  @override
  String get participants => 'Participants';

  @override
  String get date => 'Date';

  @override
  String get addTournament => 'Ajouter un tournoi';

  @override
  String get editTournament => 'Modifier le tournoi';

  @override
  String get noMatchingMatches => 'Aucun match correspondant.';

  @override
  String relatedMatchesCount(int count) {
    return '$count matchs associés';
  }

  @override
  String matchesLoadFailed(Object error) {
    return 'Impossible de charger les matchs : $error';
  }

  @override
  String relatedMatchesTagsAndDeck(String deck) {
    return 'Matchs avec les mêmes tags et le deck « $deck ».';
  }

  @override
  String get relatedMatchesTags => 'Matchs avec les mêmes tags.';

  @override
  String get noPlacement => 'Pas de classement';

  @override
  String placementOf(int place, int total) {
    return '#$place / $total';
  }

  @override
  String get firstPlace => '1re place';

  @override
  String topPlacement(int place) {
    return 'Top $place';
  }

  @override
  String placeNumber(int place) {
    return 'Place $place';
  }

  @override
  String get promoBadge => 'CARDMARKET PARTNER';

  @override
  String get promoHeadline => 'Trouve singles et displays';

  @override
  String get promoSubtitle =>
      'Soutiens l’app avec ton prochain upgrade de deck.';

  @override
  String get promoView => 'Shopper';

  @override
  String get promoDismiss => 'Masquer la bannière';

  @override
  String get promoOpenFailed => 'Le lien partenaire n’a pas pu être ouvert.';

  @override
  String get promoSettingsTitle => 'Recommandations partenaires et bannières';

  @override
  String get promoSettingsSubtitle =>
      'Soutiens le projet avec des liens communautaires discrets';

  @override
  String get toolsTabChakra => 'Chakra (Naruto)';

  @override
  String get toolsTabLife => 'Life Counter';

  @override
  String get toolsTabTimer => 'Minuteur';

  @override
  String get chakraReadyLabel => 'Chakra disponible (Ready)';

  @override
  String chakraReadyRatio(int available, int total) {
    return '$available / $total Ready';
  }

  @override
  String chakraTappedHint(int tapped) {
    return '$tapped tapés';
  }

  @override
  String get chakraPay1 => 'Payer 1 chakra';

  @override
  String get chakraPay2 => 'Payer 2 chakra';

  @override
  String get chakraEndTurn => 'Fin de round / Nouveau tour';

  @override
  String get chakraRefreshOnly => 'Refresh only';

  @override
  String get chakraDeckTitle => 'Deck chakra';

  @override
  String chakraDeckRemaining(int remaining) {
    return '$remaining / 12 restants';
  }

  @override
  String get chakraZoneMax => 'Zone chakra max';

  @override
  String get chakraResetTurn1 => 'Reset tour 1';

  @override
  String get lifeYou => 'Toi';

  @override
  String get lifeOpponent => 'Adversaire';

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
  String get timerPreset30 => '30 min';

  @override
  String get timerPreset45 => '45 min';

  @override
  String get timerPreset50 => '50 min';

  @override
  String get toolsTabDice => 'Dés et pièce';

  @override
  String get toolsTabRiftbound => 'Score Riftbound';

  @override
  String get coinHeads => 'Face';

  @override
  String get coinTails => 'Pile';

  @override
  String get randomStarter => 'Premier joueur aléatoire';

  @override
  String starterResult(String name) {
    return '$name commence';
  }

  @override
  String get playerOne => 'Joueur 1';

  @override
  String get playerTwo => 'Joueur 2';

  @override
  String get riftboundGoal => 'Points pour gagner';

  @override
  String get riftboundGoal8 => '8 pts';

  @override
  String get riftboundGoal10 => '10 pts';

  @override
  String get riftboundWinBadge => 'Victoire !';

  @override
  String get riftboundPlusBattlefield => '+1 champ de bataille';

  @override
  String get saveMatch => 'Enregistrer le match';
}
