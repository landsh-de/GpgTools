<p align=center>"<a href="https://github.com/landsh-de/GpgTools/releases">GpgTools</a>" - VS-NfD (de_vs) conformity for "Gpg4Win" (aka "GnuPG VS-Desktop®")</p>

<br>
<p align="center">
  <img src="https://github.com/landsh-de/GpgTools/assets/83558069/060b562e-745e-4401-b4f9-537926928660" />
</p>

##### <p align=right>By vitusb in 20240709</p>
##### <p align=right>GnuPG VS-Desktop® ist eine eingetragene Marke der [g10 Code GmbH](https://g10code.com "g10 Code GmbH").<br>GnuPG VS-Desktop® is a registered trademark of [g10 Code GmbH](https://g10code.com "g10 Code GmbH").</p>
##### <p align=right>[Sicherheits-Bedenken zu Brainpool-Kurven des BSI](https://github.com/landsh-de/mkcert#some-informations-to-the-brainpool-curves-designed-and-authorized-by-the-bsi-and-that-are-still-conformant-to-the-vs-nfd-de-vs-mode "Sicherheits-Bedenken zu den Brainpool-Kurven des BSI")<br>[(Security concerns about the BSI's Brainpool curves)](https://github.com/landsh-de/mkcert#some-informations-to-the-brainpool-curves-designed-and-authorized-by-the-bsi-and-that-are-still-conformant-to-the-vs-nfd-de-vs-mode "Security concerns about the BSI's Brainpool curves")</p>

### <p id="German_Description">Deutsch / [English](#English_Description "English Description")</p>

"GpgTools" ist ein Addon zur Herstellung der "VS-NfD"-Konformität ("de-vs" Modus) für das Open-Source Projekt "Gpg4Win".

"GpgTools" kann nach der Installation der entsprechenden Gpg4Win-Version manuell oder unbeaufsichtigt installiert werden. Es installiert neben zusätzlichen unterstützenden Werkzeugen eine zentrale, gehärtete Konfiguration. Diese Konfiguration aktiviert gehärtete "VS-NfD"-konforme Algorithmen und Konfigurationsparameter, die einen "VS-NfD"-konformen Betrieb von "Gpg4Win" ermöglichen.

"GpgTools" benötigt (abgesehen von der Verteilung des Paketes) KEINE WEITEREN ADMINISTRATIVEN Prozesse; die Benutzerumgebung wird zur Laufzeit (Anmeldung) konfiguriert.

"Gpg4Win" muss VOR der Installation von "GpgTools" auf dem System installiert sein. Der Installer von "GpgTools" prüft VOR der Installation, ob die korrekte Version von "Gpg4Win" bereits installiert ist.

#### Welche Version von "Gpg4Win" soll ich verwenden ?
Streng genommen ist nur Version 3.1.16 inkl. Signatur der folgenden 3-er Versionen vom BSI für VS-Stufen bis "VS-NfD" "zugelassen". Das bereitgestellte "Private-Build" in der jeweils aktuellen Version, entspricht im Quellcode dem Original aus dem Versions-Tag des GnuPG-Git für "GnuPG VS Desktop" bzw. "Gpg4Win". Diese Version ist allerdings nicht digital signiert; das verwendete GnuPG-Backend ist inklusive der digitalen Signatur identisch. Die aktuelle 3er-Version ("[gpg4win-3.x.x.exe](https://github.com/landsh-de/Gpg4Win/releases)") wird auf einem aktuellen Debian Live-System entsprechend der Dokumentation erstellt.

#### Arbeitsschritte zur Installation:
1. Laden Sie den Installer von "Gpg4Win" von der Seite des Herstellers herunter.
   **Auf der Seite des Herstellers kann von "Release 3" nur die Version 3.1.16 als Installationspaket heruntergeladen werden (Stand 07/2022). Eine aktuelle 3-er Version, die im Quellcode mit der Version von "GnuPG VS Desktop" identisch ist, steht [hier zur Verfügung](https://github.com/landsh-de/Gpg4Win/releases).**
2. Aktuell wird der Installer für die Versionen "[gpg4win-3.1.16.exe (VS-NfD)](http://files.gpg4win.de/gpg4win-3.1.16.exe)", "[gpg4win-4.3.1.exe](https://files.gpg4win.de/gpg4win-4.3.1.exe)" und "[gpg4win-3.x.x.exe](https://github.com/landsh-de/Gpg4Win/releases)" unterstützt. **Der VS-NfD-Modus wird von GpgTools für ALLE Versionen aktiviert ABER NUR DIE VERSION 3.1.16 IST OFFIZIELL VOM BSI ZUGELASSEN (SIEHE SecOPs SHA256-HASHES für Gpg4Win-3.1.16).**
4. Installieren Sie "[die aktuelle 3.x.xx-Version von Gpg4Win](https://github.com/landsh-de/Gpg4Win/releases)", bzw. die etwas ältere zugelassene 3-er Version "[gpg4win-3.1.16.exe (VS-NfD)](http://files.gpg4win.de/gpg4win-3.1.16.exe)" (im unattended Modus: ```start /wait "" "[ABSPATH]\gpg4win-x.x.xx.exe" /S```)
5. Installieren Sie "GpgTools" (Details: s.u.).
6. Starten Sie den Computer neu.
7. Nach dem Neustart werden bei der Anmeldung mehrere kleine Werkzeuge verborgen gestartet, die zur Vorkonfiguration im Nutzer-Kontext, sowie zur Schlüssel-Migration dienen (siehe auch unten: [Details der Installation](#Details_der_Installation "Details der Installation")). Die Ausführung wird durch kleine Icons unten in der Symbol-Leiste angezeigt.

### Hinweise und Anmerkungen zu der gegenwärtigen Implementierung der Gpg4Win-Suite und der mit dieser Nachinstallation ("GpgTools") durchgeführten Änderungen ...

### Installation:

> Die aktuelle Installation installiert eine globale zentrale gehärtete Konfiguration für [Gpg4Win](https://www.gpg4win.de "Gpg4Win / GnuPG VS-Desktop"). Es wird ein [Update](https://dev.gnupg.org/T6849 "Update") des GnuPG-Backend auf Version 2.2.47 durchgeführt. Des Weiteren werden Werkzeuge installiert, die die Nutzer-Konfiguration im Benutzerkontext bei Anmeldung vordefinieren. Für gehärtete Windows-Umgebungen wird die Ausführungs-Policy für entsprechende Programme von [Gpg4Win](https://www.gpg4win.de "Gpg4Win / GnuPG VS-Desktop") in den lokalen Applocker-Richtlinien bei Installation automatisch umgesetzt.

Dateien wie "openssl.exe", die unter dem globalen Verzeichnis von GnuPG (ProgramData\GNU\etc\gnupg) installiert werden, besitzen ein angepasstes "Manifest" in ihrem PE-Loader, damit diese Werkzeuge nur mit einem "Administrativen Konto" ausgeführt werden können. Diese Werkzeuge werden zur Implementierung eines noch nicht aktivierten Update-Mechanismus für ROOT-Zertifikate unter GnuPG/Gpg4Win verwendet, der als Quelle nur die "TRUST"-Varianten aus dem Mozilla-ROOT-Cert-Store verwendet. Als Basis dient das Programm "[VBCertConv](https://github.com/landsh-de/VBCertConv)", welches auf einem [Programm von "Adam Langley" (Security Engineer - Google) basiert](https://github.com/agl/extract-nss-root-certs). In einem administativen Umfeld kann über die "Aufgabenplanung" von Windows ein zyklisches Update der "trustlist.txt" über das Script: "BuildTrustList.bat" konfiguriert werden.

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
* Löschung vorheriger installierter X.509-Zertifikate (im Update-Modus / X.509-Zertifikate werden nur unter GnuPG ausgerollt und nicht systemweit !!).
* Unbeaufsichtigte Installation (unattended) des Paketes "gnupg-w32-update.exe" <b>(!! Prüfsumme und Digitale-Signatur ist identisch mit Originalversion des aktuellen GnuPG Installer-Paketes der jeweiligen aktuellen GnuPG-Version !!)</b>.
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

Der Innosetup-Installer der "GpgTools" ist nicht verschlüsselt. Falls Sie den Inhalt des Paketes zur Sicherheit überprüfen möchten, können Sie die EXE-Datei mit dem Werkzeug "Innounp" (Kommandozeilen-Werkzeug zur Extraktion von Innosetup Installer-Paketen) extrahieren. Innounp kann hier heruntergeladen werden:
[Innounp (Homepage Sourceforge)](https://innounp.sourceforge.net/)

Um unter Windows die Ausführung heruntergeladener, ausführbarer Dateien zu ermöglichen, muss der "Alternate Data-Stream" "Zone.Identifier" aus der Datei entfernt werden sonst wird die Ausführung dieser Datei gesperrt. Starten Sie hierzu eine Kommando-Shell (cmd.exe) und führen Sie hierzu folgendes Kommando über die Powershell aus:
```
powershell.exe -ep Bypass -noprofile -command "Remove-Item \"HERUNTERGELADENE_AUSFÜHRBARE_DATEI\" -Stream Zone.Identifier"
```

#### <p id="English_Description">English / [Deutsch](#German_Description "Deutsche Beschreibung")</p>

“GpgTools” is an “add-on”, implemented as an installer-package, for establishing the "VS-NfD"-conformity (“de-vs” mode) for the open-source project [Gpg4Win (updated version)](https://github.com/landsh-de/Gpg4Win/releases) and [Gpg4Win (original version -outdated-)](https://www.gpg4win.de "Gpg4Win / GnuPG VS-Desktop").

“GpgTools” can be installed manually or unattended after the installation of the corresponding "Gpg4Win" version. It installs a central, hardened configuration. This configuration activates hardened “VS-NfD”-compliant algorithms and configuration parameters in order to activate the “VS-NfD”-compliant operation of "Gpg4Win".

“GpgTools” requires (apart from the distribution of the package) NO ADDITIONAL ADMINISTRATIVE processes; the user environment is parameterized at runtime (login).

"Gpg4Win" must be installed on the system BEFORE installing "GpgTools". The "GpgTools" installer checks BEFORE the installation whether the correct version of "Gpg4Win" is already installed.

... For installer commandline-options, see description in german above ...

In order to execute downloaded, non-signed executables under Windows, the "Alternate Data-Stream" "Zone.Identifier" must be removed from file, otherwise the execution will be blocked. Please invoke a commandline-shell (cmd.exe) and run the following command from a Powershell:
```
powershell.exe -ep Bypass -noprofile -command "Remove-Item \"DOWNLOADED_EXECUTABLE_FILE\" -Stream Zone.Identifier"
```

