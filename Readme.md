## <p align=center>"GpgTools"<br>Activate VS-NfD Configuration for "Gpg4Win"<br>(aka "GnuPG VS-Desktop®")</p>

##### <p align=right>By vitusb in 20211228</p>
##### <p align=right>GnuPG VS-Desktop® ist eine eingetragene Marke der [g10 Code GmbH](https://g10code.com "g10 Code GmbH").<br>GnuPG VS-Desktop® is a registered trademark of [g10 Code GmbH](https://g10code.com "g10 Code GmbH").</p>

## <p id="German_Description">Deutsch / [English](#English_Description "English Description")</p>

### "GpgTools" ist ein "Addon", umgesetzt als Installer-Paket, zur Herstellung der "VS-NfD"-Konformität ("de-vs" Modus) für das Open-Source Projekt [Gpg4Win](https://www.gpg4win.de "Gpg4Win / GnuPG VS-Desktop").

### "GpgTools" kann nach der Installation der entsprechenden [Gpg4Win](https://www.gpg4win.de "Gpg4Win / GnuPG VS-Desktop")-Version manuell oder unbeaufsichtigt (unattended) installiert werden und rollt neben zusätzlichen unterstützenden Werkzeugen (Zero-Config Tools) eine zentrale, gehärtete Konfiguration aus. Diese Konfiguration aktiviert gehärtete "VS-NfD"-konforme Algorithmen und Konfigurationsparameter, die einen "VS-NfD"-konformen Betrieb von [Gpg4Win](https://www.gpg4win.de "Gpg4Win / GnuPG VS-Desktop") ermöglichen.

### "GpgTools" benötigt (abgesehen von der Verteilung des Paketes) KEINE WEITEREN ADMINISTRATIVEN Prozesse; die Benutzerumgebung wird zur Laufzeit (Anmeldung) parametrisiert.

### Jede Unter-Version von "GpgTools" ist einer "Mainline-Version" von [Gpg4Win](https://www.gpg4win.de "Gpg4Win / GnuPG VS-Desktop") zugeordnet:

> ### * GptTools 1.3.x.x <=> [Gpg4Win 3.x.x](https://files.gpg4win.org/?C=M;O=D "Files of Gpg4Win 3.x.x")

> ### * GptTools 1.4.x.x <=> [Gpg4Win 4.x.x](https://files.gpg4win.org/?C=M;O=D "Files of Gpg4Win 4.x.x")

### [Gpg4Win](https://www.gpg4win.de "Gpg4Win / GnuPG VS-Desktop") muss VOR der Installation von "GpgTools" auf dem System installiert sein. Der Installer von "GpgTools" prüft VOR der Installation, ob die korrekte Version von [Gpg4Win](https://www.gpg4win.de "Gpg4Win / GnuPG VS-Desktop") bereits installiert ist.

### Hinweise und Anmerkungen zu der gegenwärtigen Implementierung der Gpg4Win-Suite und der mit dieser Nachinstallation ("GpgTools") durchgeführten Änderungen ...

### Installation:

> #### Diese Installation installiert eine globale zentrale gehärtete Konfiguration für [Gpg4Win](https://www.gpg4win.de "Gpg4Win / GnuPG VS-Desktop"), sowie Fehlerbehebungen in den Dialogen von "Pinentry" und den Übersetzungstabellen von GnuPG, GpgEX und GpgOL. Des Weiteren werden Werkzeuge installiert, die die Nutzer-Konfiguration im Nutzerkontext bei Anmeldung vordefinieren. Für gehärtete Windows-Umgebungen wird die Ausführungs-Policy für entsprechende Programme von [Gpg4Win](https://www.gpg4win.de "Gpg4Win / GnuPG VS-Desktop") in den lokalen Applocker-Richtlinien bei Installation automatisch umgesetzt.

### Details der Installation:

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
* Dekomprimierung und Installation der Dateien.
* Anlegen der Firewall-Regeln (es werden für den Zugriff auf Keyserver und das Loopback-Interface nur ausgehende Firewall-Regeln für "GnuPG", "GpgSM", "Gpg-Agent", "DirMngr" und "Kleopatra" eingerichtet; für "GnuPG", "Gpg-Agent" und "DirMngr" werden nur 3 eingehende Firewall-Regeln vom Loopback-Interface eingerichtet. Details entnehmen Sie bitte dem Installer-Quellcode aus der Datei: "GpgTools.iss".
* Prüfung: Software Restriction-Policy (SRP) aktiviert ?
* Prüfung: Applocker EnforcementMode für EXE-Files aktiviert ?
* Anlegen lokaler Applocker- und SAFER- Execution-Policies, wenn o. g. Prüfungen positiv sind.
* Nach-Installation einzelner Konfigurations-Dateien in die [Gpg4Win](https://www.gpg4win.de "Gpg4Win / GnuPG VS-Desktop")-Installation (z.B. gehärtete Konfiguration für "Kleopatra" zur Deaktivierung selbst-initiierter Updates, gehärtete Konfiguration des "VS-NfD" Modus, Vor-Konfiguration des "Yubikey-5 NFC" Hardware-Tokens, etc.
* Installation einzelner AutoRun-Schlüssel in der REGISTRY "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Run" zur Ausführung einzelner Werkzeuge während der Anmeldung durch den (die) Nutzer(in) :
1. * Expand_GNUPGHOME: setzen "GNUPGHOME" Umgebungsvariable ...
2. * Gpg4Win_Cleanup: GnuPG-Prozesse bei Anmeldung beenden (Workaround für Gpg-Agent Socket-Problem)
3. * GpgOL_Config_InlinePGP: "Inline PGP" aktivieren ...
4. * GpgOL_Enabe_OLK2016_Resiliency: Outlook 2016 Resiliency aktivieren. ...
5. * GpgOL_Set_OLK_LoadBehavior: Outlook 2016 "LoadBehavior" definieren.
6. * Migrate_GnuPG_Keybase: Programm zur Prüfung und automatischen Migration einer alten GnuPG v1 Schlüssel-Datenbank starten.


### Installations-Optionen:

#### Unbeaufsichtigte Installation (SILENT)

> Benutzen Sie die Option "/VERYSILENT /BASSSOUND-" anstatt "/SILENT" für eine vollständig verborgene Installation !!

#### Installation inkl. Policy-Einträge (DEFAULT):
```
[Installer.exe] /LANG=German /TYPE=fullpol /SILENT /NORESTART
[Installer.exe] /LANG=German /TYPE=fullpol /SILENT /NORESTART /LOG
```
#### Installation kompakt inkl. Policy Einträge:

```
[Installer.exe] /LANG=German /TYPE=compactpol /SILENT /NORESTART
[Installer.exe] /LANG=German /TYPE=compactpol /SILENT /NORESTART /LOG
```
#### Installation ohne Policy Einträge:

```
[Installer.exe] /LANG=German /TYPE=full /SILENT /NORESTART
[Installer.exe] /LANG=German /TYPE=full /SILENT /NORESTART /LOG
```
#### Installation kompakt ohne Policy Einträge:

```
[Installer.exe] /LANG=German /TYPE=compact /SILENT /NORESTART
[Installer.exe] /LANG=German /TYPE=compact /SILENT /NORESTART /LOG
```

<br>

---

## <p id="English_Description">English / [Deutsch](#German_Description "Deutsche Beschreibung")</p>


### “GpgTools” is an “add-on”, implemented as an installer-package, for establishing the "VS-NfD"-conformity (“de-vs” mode) for the open-source project [Gpg4Win](https://www.gpg4win.de "Gpg4Win / GnuPG VS-Desktop").

### “GpgTools” can be installed manually or unattended after the installation of the corresponding [Gpg4Win](https://www.gpg4win.de "Gpg4Win / GnuPG VS-Desktop") version and, in addition to additional supporting tools (zero-config tools), rolls out a central, hardened configuration. This configuration activates hardened “VS-NfD”-compliant algorithms and configuration parameters that enable “VS-NfD”-compliant operation of [Gpg4Win](https://www.gpg4win.de "Gpg4Win / GnuPG VS-Desktop").

### “GpgTools” requires (apart from the distribution of the package) NO ADDITIONAL ADMINISTRATIVE processes; the user environment is parameterized at runtime (login).

### Each sub-version of “GpgTools” is assigned to a “mainline version” of [Gpg4Win](https://www.gpg4win.de "Gpg4Win / GnuPG VS-Desktop"):

> ### * GptTools 1.3.x.x <=> [Gpg4Win 3.x.x](https://files.gpg4win.org/?C=M;O=D "Files of Gpg4Win 3.x.x")

> ### * GptTools 1.4.x.x <=> [Gpg4Win 4.x.x](https://files.gpg4win.org/?C=M;O=D "Files of Gpg4Win 4.x.x")


### [Gpg4Win](https://www.gpg4win.de "Gpg4Win / GnuPG VS-Desktop") must be installed on the system BEFORE installing “GpgTools”. The “GpgTools” installer checks BEFORE the installation whether the correct version of [Gpg4Win](https://www.gpg4win.de "Gpg4Win / GnuPG VS-Desktop") is already installed.
