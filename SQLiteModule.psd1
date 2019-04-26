@{

  RootModule = 'SQLiteModule.psm1'
  ModuleVersion = '1.0'
  GUID = '0068a5da-63df-4b0c-85f2-b5e8a8cd3dfc'
  Author = 'Christian Imhorst (datenteiler)'
  CompanyName = 'datenteiler.de'
  Copyright = '(c) 2019 Christian Imhorst. All rights reserved.'
  Description = 'Invoke a SQLite query to your SQLite database'
  PowerShellVersion = '5.0'

  # Die Module, die vor dem Importieren dieses Moduls in die globale Umgebung geladen werden müssen
  # RequiredModules = @()

  # Die Assemblys, die vor dem Importieren dieses Moduls geladen werden müssen
  # RequiredAssemblies = @()

  # Die Skriptdateien (PS1-Dateien), die vor dem Importieren dieses Moduls in der Umgebung des Aufrufers ausgeführt werden.
  # ScriptsToProcess = @()

  # Die Module, die als geschachtelte Module des in "RootModule/ModuleToProcess" angegebenen Moduls importiert werden sollen.
  # NestedModules = @()

  # Aus diesem Modul zu exportierende Funktionen. Um optimale Leistung zu erzielen, verwenden Sie keine Platzhalter und löschen den Eintrag nicht. Verwenden Sie ein leeres Array, wenn keine zu exportierenden Funktionen vorhanden sind.
  FunctionsToExport = @()

  # Aus diesem Modul zu exportierende Cmdlets. Um optimale Leistung zu erzielen, verwenden Sie keine Platzhalter und löschen den Eintrag nicht. Verwenden Sie ein leeres Array, wenn keine zu exportierenden Cmdlets vorhanden sind.
  CmdletsToExport = @('Invoke-SQLiteQuery')

  # Die aus diesem Modul zu exportierenden Variablen
  VariablesToExport = '*'

  # Aus diesem Modul zu exportierende Aliase. Um optimale Leistung zu erzielen, verwenden Sie keine Platzhalter und löschen den Eintrag nicht. Verwenden Sie ein leeres Array, wenn keine zu exportierenden Aliase vorhanden sind.
  AliasesToExport = @()
  PrivateData = @{

      PSData = @{

          Tags = @()
          LicenseUri = ''
          ProjectUri = ''
          # IconUri = ''
          # ReleaseNotes = ''

      } 
  } 
  # HelpInfo-URI dieses Moduls
  # HelpInfoURI = ''
}

