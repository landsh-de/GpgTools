## <p align=center>"GpgTools"<br>Activate VS-NfD conformity for "Gpg4Win"<br>(aka "GnuPG VS-Desktop®")</p>

##### <p align=right>By vitusb in 20220330</p>
##### <p align=right>GnuPG VS-Desktop® ist eine eingetragene Marke der [g10 Code GmbH](https://g10code.com "g10 Code GmbH").<br>GnuPG VS-Desktop® is a registered trademark of [g10 Code GmbH](https://g10code.com "g10 Code GmbH").</p>
##### <p align=right>[Sicherheits-Bedenken zu Brainpool-Kurven des BSI](https://github.com/landsh-de/mkcert#some-informations-to-the-brainpool-curves-designed-and-authorized-by-the-bsi-and-that-are-still-conformant-to-the-vs-nfd-de-vs-mode "Sicherheits-Bedenken zu den Brainpool-Kurven des BSI")<br>[(Security concerns about the BSI's Brainpool curves)](https://github.com/landsh-de/mkcert#some-informations-to-the-brainpool-curves-designed-and-authorized-by-the-bsi-and-that-are-still-conformant-to-the-vs-nfd-de-vs-mode "Security concerns about the BSI's Brainpool curves")</p>

## <p id="German_Description">Deutsch / [English](#English_Description "English Description")</p>

### "GpgTools" ist ein "Addon", umgesetzt als Installer-Paket, zur Herstellung der "VS-NfD"-Konformität ("de-vs" Modus) für das Open-Source Projekt [Gpg4Win](https://www.gpg4win.de "Gpg4Win / GnuPG VS-Desktop").

### "GpgTools" kann nach der Installation der entsprechenden [Gpg4Win](https://www.gpg4win.de "Gpg4Win / GnuPG VS-Desktop")-Version manuell oder unbeaufsichtigt (unattended) installiert werden und rollt neben zusätzlichen unterstützenden Werkzeugen (Zero-Config Tools) eine zentrale, gehärtete Konfiguration aus. Diese Konfiguration aktiviert gehärtete "VS-NfD"-konforme Algorithmen und Konfigurationsparameter, die einen "VS-NfD"-konformen Betrieb von [Gpg4Win](https://www.gpg4win.de "Gpg4Win / GnuPG VS-Desktop") ermöglichen.

### "GpgTools" benötigt (abgesehen von der Verteilung des Paketes) KEINE WEITEREN ADMINISTRATIVEN Prozesse; die Benutzerumgebung wird zur Laufzeit (Anmeldung) parametrisiert.

### Jede Unter-Version von "GpgTools" ist einer "Mainline-Version" von [Gpg4Win](https://www.gpg4win.de "Gpg4Win / GnuPG VS-Desktop") zugeordnet:

> ### * GptTools 1.3.x.x <=> [Gpg4Win 3.x.x](https://files.gpg4win.org/?C=M;O=D "Files of Gpg4Win 3.x.x")

> ### * GptTools 1.4.x.x <=> [Gpg4Win 4.x.x](https://files.gpg4win.org/?C=M;O=D "Files of Gpg4Win 4.x.x")

### [Gpg4Win](https://www.gpg4win.de "Gpg4Win / GnuPG VS-Desktop") muss VOR der Installation von "GpgTools" auf dem System installiert sein. Der Installer von "GpgTools" prüft VOR der Installation, ob die korrekte Version von [Gpg4Win](https://www.gpg4win.de "Gpg4Win / GnuPG VS-Desktop") bereits installiert ist.

#### Arbeitsschritte für die Version 1.3.x.x (Gpg4Win 3.x.x):
1. Laden Sie den Installer von "Gpg4Win" von der Seite des Herstellers herunter.
2. - Aktuell wird der Installer in der Version [gpg4win-3.1.16.exe](https://files.gpg4win.org/gpg4win-3.1.16.exe "gpg4win-3.1.16.exe") unterstützt.
2. - Laden Sie die SHA256 Prüfsumme [gpg4win-3.1.16.exe.sha256](https://files.gpg4win.org/gpg4win-3.1.16.exe.sha256 "gpg4win-3.1.16.exe.sha256") herunter und vergleichen Sie diese mit der Prüfsumme der Datei: [gpg4win-3.1.16.exe](https://files.gpg4win.org/gpg4win-3.1.16.exe "gpg4win-3.1.16.exe")
4. Installieren Sie "[gpg4win-3.1.16.exe](https://files.gpg4win.org/gpg4win-3.1.16.exe "gpg4win-3.1.16.exe")" (Unattended Mode: ```start /wait "" "[ABSPATH]\gpg4win-3.1.16.exe" /S```)
5. Installieren Sie "GpgTools" (Details: s.u.).
6. Starten Sie den Computer neu.
7. Nach dem Neustart werden bei der Anmeldung mehrere kleine Werkzeuge verborgen gestartet, die zur Vorkonfiguration im Nutzer-Kontext, sowie zur Schlüssel-Migration dienen (siehe auch unten: [Details der Installation](#Details_der_Installation "Details der Installation")). Die Ausführung wird durch kleine Icons unten in der Symbol-Leiste angezeigt.
8. Fertig !

### Hinweise und Anmerkungen zu der gegenwärtigen Implementierung der Gpg4Win-Suite und der mit dieser Nachinstallation ("GpgTools") durchgeführten Änderungen ...

### Installation:

> #### Diese Installation installiert eine globale zentrale gehärtete Konfiguration für [Gpg4Win](https://www.gpg4win.de "Gpg4Win / GnuPG VS-Desktop"), sowie Fehlerbehebungen in den Dialogen von "Pinentry" und den Übersetzungstabellen von GnuPG, GpgEX und GpgOL. Es wird ein [Update](https://dev.gnupg.org/T5703 "Update") des GnuPG-Backend auf Version [2.2.34](https://dev.gnupg.org/T5703 "2.2.34") vom 07.02.2022 durchgeführt. Des Weiteren werden Werkzeuge installiert, die die Nutzer-Konfiguration im Nutzerkontext bei Anmeldung vordefinieren. Für gehärtete Windows-Umgebungen wird die Ausführungs-Policy für entsprechende Programme von [Gpg4Win](https://www.gpg4win.de "Gpg4Win / GnuPG VS-Desktop") in den lokalen Applocker-Richtlinien bei Installation automatisch umgesetzt.

#### Details zu der Update-Historie von GnuPG seit Rollout über Gpg4Win 3.1.16 (GnuPG 2.2.28)
* [Release GnuPG 2.2.29](https://dev.gnupg.org/T5498 "Release GnuPG 2.2.29")
* [Release GnuPG 2.2.30](https://dev.gnupg.org/T5519 "Release GnuPG 2.2.20")
* [Release GnuPG 2.2.31](https://dev.gnupg.org/T5571 "Release GnuPG 2.2.31")
* [Release GnuPG 2.2.32](https://dev.gnupg.org/T5601 "Release GnuPG 2.2.32")
* [Release GnuPG 2.2.33](https://dev.gnupg.org/T5641 "Release GnuPG 2.2.33")
* [Release GnuPG 2.2.34](https://dev.gnupg.org/T5703 "Release GnuPG 2.2.34")

### <p id="Details_der_Installation">Details der Installation:</p>

* INSTALLER: InnoSetup
* Falls Unattended-Installation aktiviert, Deaktivierung aller interaktiven Dialog-Formen: Messageboxen, etc. ...
* Dekomprimierung Bass-Soundlib
* Dekomprimierung Bass-Soundfile
* Dekomprimierung Installer-Skin
* Prüfung, ob "Gpg4Win" und "GnuPG" in der passenden Version installiert sind.
* Abspielen der Hintergrund-Musik während des Installations-Prozesses.
* Beendigung aller zum Installations-Zeitpunkt im Hintergrund auf dem System im globalen Kontext laufenden Programme: "outlook.exe", "kleopatra.exe" "gpa.exe", "gpgme-w32spawn.exe", "gpg-agent.exe", "gpg.exe", "dirmngr.exe", "gpgsm.exe", "scdaemon.exe", "pinentry-w32.exe", "pinentry.exe", "pinentry-basic.exe".
* Löschung vorheriger angelegter Firewall-Regeln (im Update-Modus).
* Löschung vorheriger installierter X.509-Zertifikate (im Update-Modus / X.509-Zertifikate werden nur unter GnuPG ausgerollt nicht systemweit).
* Unbeaufsichtigte Installation (unattended) des Paketes "gnupg-w32-update.exe" (im Original: "gnupg-w32-2.2.34_20220207.exe" / die Prüfsumme ist identisch).
* Dekomprimierung und Installation der Dateien.
* Anlegen der Firewall-Regeln (es werden für den Zugriff auf Keyserver und das Loopback-Interface nur ausgehende Firewall-Regeln für "GnuPG", "GpgSM", "Gpg-Agent", "DirMngr" und "Kleopatra" eingerichtet; für "GnuPG", "Gpg-Agent" und "DirMngr" werden nur 3 eingehende Firewall-Regeln vom Loopback-Interface eingerichtet. Details entnehmen Sie bitte dem Installer-Quellcode aus der Datei: "GpgTools.iss".
* Prüfung: Software Restriction-Policy (SRP) aktiviert ?
* Prüfung: Applocker EnforcementMode für EXE-Files aktiviert ?
* Anlegen lokaler Applocker- und SAFER- Execution-Policies, wenn o. g. Prüfungen positiv sind.
* Nach-Installation einzelner Konfigurations-Dateien in die [Gpg4Win](https://www.gpg4win.de "Gpg4Win / GnuPG VS-Desktop")-Installation (z.B. gehärtete Konfiguration für "Kleopatra" zur Deaktivierung selbst-initiierter Updates, gehärtete Konfiguration des "VS-NfD" Modus, Vor-Konfiguration des "Yubikey-5 NFC" Hardware-Tokens, etc.
* Installation einzelner AutoRun-Schlüssel in der REGISTRY "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run" zur Ausführung einzelner Werkzeuge während der Anmeldung durch den (die) Nutzer(in) :
1. * Expand_GNUPGHOME: setzen "GNUPGHOME" Umgebungsvariable ...
2. * Gpg4Win_Cleanup (Gpg4WinPreConfig): GnuPG-Prozesse bei Anmeldung beenden (Workaround für Gpg-Agent Socket-Problem)
3. * Gpg4Win_Cleanup (Gpg4WinPreConfig): "Inline PGP" deaktivieren ...
4. * Gpg4Win_Cleanup (Gpg4WinPreConfig): Outlook 2016 Resiliency aktivieren. ...
5. * Gpg4Win_Cleanup (Gpg4WinPreConfig): Outlook 2016 "LoadBehavior" definieren.
6. * [Migrate_GnuPG_Keybase](https://github.com/landsh-de/MigrateGnuPGKeybase "Migrate_GnuPG_Keybase"): Programm zur Prüfung und automatischen Migration einer alten GnuPG v1 Schlüssel-Datenbank starten. Für Details schauen Sie in das Projekt: [MigrateGnuPGKeybase](https://github.com/landsh-de/MigrateGnuPGKeybase "MigrateGnuPGKeybase")

### Installations-Optionen:

#### Unbeaufsichtigte Installation (SILENT)

> Benutzen Sie die Option "/VERYSILENT /BASSSOUND-" anstatt "/SILENT" für eine vollständig verborgene Installation !!

#### Installation inkl. Policy-Einträge (DEFAULT):
```
[Installer.exe] /LANG=German /TYPE=fullpol /SILENT /NORESTART
[Installer.exe] /LANG=German /TYPE=fullpol /SILENT /NORESTART /LOG
[Installer.exe] /LANG=German /TYPE=fullpol /VERYSILENT /BASSSOUND- /NORESTART /LOG
```

#### Installation kompakt inkl. Policy Einträge:

```
[Installer.exe] /LANG=German /TYPE=compactpol /SILENT /NORESTART
[Installer.exe] /LANG=German /TYPE=compactpol /SILENT /NORESTART /LOG
[Installer.exe] /LANG=German /TYPE=compactpol /VERYSILENT /BASSSOUND- /NORESTART /LOG
```

#### Installation ohne Policy Einträge:
```
[Installer.exe] /LANG=German /TYPE=full /SILENT /NORESTART
[Installer.exe] /LANG=German /TYPE=full /SILENT /NORESTART /LOG
[Installer.exe] /LANG=German /TYPE=full /VERYSILENT /BASSSOUND- /NORESTART /LOG
```

#### Installation kompakt ohne Policy Einträge:
```
[Installer.exe] /LANG=German /TYPE=compact /SILENT /NORESTART
[Installer.exe] /LANG=German /TYPE=compact /SILENT /NORESTART /LOG
[Installer.exe] /LANG=German /TYPE=compact /VERYSILENT /BASSSOUND- /NORESTART /LOG
```

#### Aufgrund der relativ hohen Kosten einer Digitalen Code-Signatur, sind entsprechende Binaries (noch) nicht digital signiert; somit kann es vorkommen, dass die Ausführung dieser Dateien nach einem Download unter Windows vom System blockiert wird. Um unter Windows die Ausführung heruntergeladener, ausführbarer Dateien zu ermöglichen, muss der "Alternate Data-Stream" "Zone.Identifier" aus der Datei entfernt werden sonst wird die Ausführung dieser Datei gesperrt. Starten Sie hierzu eine Kommando-Shell (cmd.exe) und führen Sie hierzu folgendes Kommando über die Powershell aus:
```
powershell.exe -ep Bypass -noprofile -command "Remove-Item \"HERUNTERGELADENE_AUSFÜHRBARE_DATEI\" -Stream Zone.Identifier"
```

## <p id="English_Description">English / [Deutsch](#German_Description "Deutsche Beschreibung")</p>

### “GpgTools” is an “add-on”, implemented as an installer-package, for establishing the "VS-NfD"-conformity (“de-vs” mode) for the open-source project [Gpg4Win](https://www.gpg4win.de "Gpg4Win / GnuPG VS-Desktop").

### “GpgTools” can be installed manually or unattended after the installation of the corresponding [Gpg4Win](https://www.gpg4win.de "Gpg4Win / GnuPG VS-Desktop") version and, in addition to additional supporting tools (zero-config tools), rolls out a central, hardened configuration. This configuration activates hardened “VS-NfD”-compliant algorithms and configuration parameters that enable “VS-NfD”-compliant operation of [Gpg4Win](https://www.gpg4win.de "Gpg4Win / GnuPG VS-Desktop").

### “GpgTools” requires (apart from the distribution of the package) NO ADDITIONAL ADMINISTRATIVE processes; the user environment is parameterized at runtime (login).

### Each sub-version of “GpgTools” is assigned to a “mainline version” of [Gpg4Win](https://www.gpg4win.de "Gpg4Win / GnuPG VS-Desktop"):

> ### * GptTools 1.3.x.x <=> [Gpg4Win 3.x.x](https://files.gpg4win.org/?C=M;O=D "Files of Gpg4Win 3.x.x")

> ### * GptTools 1.4.x.x <=> [Gpg4Win 4.x.x](https://files.gpg4win.org/?C=M;O=D "Files of Gpg4Win 4.x.x")


### [Gpg4Win](https://www.gpg4win.de "Gpg4Win / GnuPG VS-Desktop") must be installed on the system BEFORE installing “GpgTools”. The “GpgTools” installer checks BEFORE the installation whether the correct version of [Gpg4Win](https://www.gpg4win.de "Gpg4Win / GnuPG VS-Desktop") is already installed.

... For installer commandline-options, see description in german above ...

#### Due to the relatively high costs of a digital code signature, the corresponding binaries are not (yet) digitally signed; so it can happen that the execution of these files is blocked by the system after a download under Windows. In order to execute downloaded, non-signed executables under Windows, the "Alternate Data-Stream" "Zone.Identifier" must be removed from file, otherwise the execution will be blocked. Please invoke a commandline-shell (cmd.exe) and run the following command from a Powershell:
```
powershell.exe -ep Bypass -noprofile -command "Remove-Item \"DOWNLOADED_EXECUTABLE_FILE\" -Stream Zone.Identifier"
```

