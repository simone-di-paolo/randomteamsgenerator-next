import 'dart:ui' as ui;

/// Global strings for the application in different languages.
class AppStrings {
  final String appTitle;
  final String homeHeadline;
  final String homeTagline;
  final String managePlayers;
  final String generateTeams;
  final String history;
  final String settings;
  final String back;
  final String teamsTitle;
  final String noTeamsGenerated;
  final String saveTeams;
  final String teamsSavedSuccess;
  final String shareSubject;
  final String clearData;
  final String clearDataSubtitle;
  final String clearDataAction;
  final String clearDataSuccess;
  final String appearance;
  final String darkMode;
  final String darkModeSubtitle;
  final String info;
  final String version;
  final String sourceCode;
  final String emptyHistory;
  final String savedTeamsWillAppearHere;
  final String delete;
  final String teamsGeneratedCount;
  final String reopenPlayerManagement;
  final String shareTeams;
  final String shareHistorySubject;
  final String playerManagementTitle;
  final String addPlayerPlaceholder;
  final String playersCount;
  final String startGeneration;
  final String selectNumTeams;
  final String clickToGenerate;
  final String playerExistsError;
  final String addPlayers;
  final String enterNamesToStart;
  final String numTeamsQuestion;
  final String clickToGenerateDesc;
  final String generateButton;
  final String playersPerTeamTemplate;

  AppStrings({
    required this.appTitle,
    required this.homeHeadline,
    required this.homeTagline,
    required this.managePlayers,
    required this.generateTeams,
    required this.history,
    required this.settings,
    required this.back,
    required this.teamsTitle,
    required this.noTeamsGenerated,
    required this.saveTeams,
    required this.teamsSavedSuccess,
    required this.shareSubject,
    required this.clearData,
    required this.clearDataSubtitle,
    required this.clearDataAction,
    required this.clearDataSuccess,
    required this.appearance,
    required this.darkMode,
    required this.darkModeSubtitle,
    required this.info,
    required this.version,
    required this.sourceCode,
    required this.emptyHistory,
    required this.savedTeamsWillAppearHere,
    required this.delete,
    required this.teamsGeneratedCount,
    required this.reopenPlayerManagement,
    required this.shareTeams,
    required this.shareHistorySubject,
    required this.addPlayers,
    required this.enterNamesToStart,
    required this.numTeamsQuestion,
    required this.clickToGenerateDesc,
    required this.generateButton,
    required this.playersPerTeamTemplate,
    required this.playerManagementTitle,
    required this.addPlayerPlaceholder,
    required this.playersCount,
    required this.startGeneration,
    required this.selectNumTeams,
    required this.clickToGenerate,
    required this.playerExistsError,
  });

  factory AppStrings.it() => AppStrings(
    appTitle: 'Random Teams Generator',
    homeHeadline: 'Generatore di Squadre Casuali',
    homeTagline: 'Equo, veloce e divertente.',
    managePlayers: 'Gestisci Giocatori',
    generateTeams: 'Genera Squadre',
    history: 'Cronologia',
    settings: 'Impostazioni',
    back: 'Torna indietro',
    teamsTitle: 'Le Squadre',
    noTeamsGenerated: 'Nessuna squadra generata.',
    saveTeams: 'Salva Squadre',
    teamsSavedSuccess: 'Squadre salvate con successo nella cronologia!',
    shareSubject: 'Le nostre Squadre!',
    clearData: 'Svuota tutto',
    clearDataSubtitle: 'Rimuove tutti i giocatori',
    clearDataAction: 'Svuota',
    clearDataSuccess: 'Tutti i giocatori sono stati rimossi',
    appearance: 'Aspetto',
    darkMode: 'Tema Scuro',
    darkModeSubtitle: 'Attiva o disattiva il dark mode',
    info: 'Info',
    version: 'Versione 0.1',
    sourceCode: 'Codice Sorgente',
    emptyHistory: 'Cronologia Vuota',
    savedTeamsWillAppearHere: 'Le squadre salvate appariranno qui.',
    delete: 'Elimina',
    teamsGeneratedCount: 'squadre generate',
    reopenPlayerManagement: 'Riapri Gestione Giocatori',
    shareTeams: 'Condividi Squadre',
    shareHistorySubject: 'Squadre generate il',
    playerManagementTitle: 'Gestisci Giocatori',
    addPlayerPlaceholder: 'Nome giocatore...',
    playersCount: 'Giocatori',
    startGeneration: 'Inizia Generazione',
    selectNumTeams: 'Quante squadre vuoi creare?',
    clickToGenerate: 'Clicca per generare',
    playerExistsError: 'Il giocatore esiste già',
    addPlayers: 'Aggiungi Giocatori',
    enterNamesToStart: 'Inserisci i nomi per iniziare a creare le squadre.',
    numTeamsQuestion: 'Quante squadre vuoi creare?',
    clickToGenerateDesc: 'Dividi i tuoi giocatori in squadre bilanciate.',
    generateButton: 'Genera!',
    playersPerTeamTemplate: 'Da {min} a {max} giocatori per squadra',
  );

  factory AppStrings.en() => AppStrings(
    appTitle: 'Random Teams Generator',
    homeHeadline: 'Random Teams Generator',
    homeTagline: 'Fair, fast and fun.',
    managePlayers: 'Manage Players',
    generateTeams: 'Generate Teams',
    history: 'History',
    settings: 'Settings',
    back: 'Go back',
    teamsTitle: 'The Teams',
    noTeamsGenerated: 'No teams generated.',
    saveTeams: 'Save Teams',
    teamsSavedSuccess: 'Teams saved successfully into history!',
    shareSubject: 'Our Teams!',
    clearData: 'Clear All',
    clearDataSubtitle: 'Removes all players',
    clearDataAction: 'Clear',
    clearDataSuccess: 'All players have been removed',
    appearance: 'Appearance',
    darkMode: 'Dark Mode',
    darkModeSubtitle: 'Toggle dark or light theme',
    info: 'Info',
    version: 'Version 0.1',
    sourceCode: 'Source Code',
    emptyHistory: 'History is Empty',
    savedTeamsWillAppearHere: 'Your saved teams will appear here.',
    delete: 'Delete',
    teamsGeneratedCount: 'teams generated',
    reopenPlayerManagement: 'Reopen Player Management',
    shareTeams: 'Share Teams',
    shareHistorySubject: 'Teams generated on',
    playerManagementTitle: 'Manage Players',
    addPlayerPlaceholder: 'Player name...',
    playersCount: 'Players',
    startGeneration: 'Start Generation',
    selectNumTeams: 'How many teams do you want?',
    clickToGenerate: 'Click to generate',
    playerExistsError: 'Player already exists',
    addPlayers: 'Add Players',
    enterNamesToStart: 'Enter names to start creating teams.',
    numTeamsQuestion: 'How many teams for today?',
    clickToGenerateDesc: 'Split your players into balanced teams.',
    generateButton: 'Generate!',
    playersPerTeamTemplate: 'From {min} to {max} players per team',
  );

  String playersPerTeam(int min, int max) {
    return playersPerTeamTemplate.replaceFirst('{min}', min.toString()).replaceFirst('{max}', max.toString());
  }

  static AppStrings of() {
    final languageCode = ui.PlatformDispatcher.instance.locale.languageCode;
    return languageCode == 'it' ? AppStrings.it() : AppStrings.en();
  }
}
