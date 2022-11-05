; ###################################################################
; ########################## GpgTools.iss ###########################
; ###################################################################
;
;                !! IMPORTANT CODE AND API CHANGES !!
;
; This installer script was especially built for the UNICODE version
; of InnoSetup because the UNICODE version was built with Delphi 2009.
; Because of this we're able to use some new APIs with QWORD (Int64)
; Types !! One of these APIs are for example BASS-Lib API 2.4.
; BUT WE HAD TO CHANGE SOME TYPES IN CODE. SEE DOCUMENTATION HERE:
; http://www.jrsoftware.org/ishelp/index.php?topic=unicode
;
; Beginning with Inno Setup 5.3.0, there are two versions of
; Inno Setup available: Non Unicode Inno Setup and Unicode.
; Key features of Unicode Inno Setup are its ability to display any
; language on any system regardless of the system code page, and its
; ability to work with Unicode filenames. One could consider Unicode
; Inno Setup as the new standard Inno Setup and Non Unicode Inno
; Setup as an old special Inno Setup for those who want the very
; smallest size possible.
;
; If you don't remember which version you installed, click the
; "Inno Setup Compiler" shortcut created in the Start Menu. If
; the version number displayed in its title bar says "(a)" you
; are running Non Unicode Inno Setup. If it says "(u)" you are
; running Unicode Inno Setup.
;
; For the most part the two versions are used identically, and
; any differences between them are noted throughout the help
; file. However, the following overview lists the primary
; differences:
;
; * Unicode Inno Setup uses the existing ANSI .isl language
;   files and you should not and may not convert these to
;   Unicode or anything similar since it does so automatically
;   during compilation using the LanguageCodePage setting of
;   the language. However, you do need to convert existing
;   [Messages] and [CustomMessages] entries in your .iss files
;   to Unicode if the language used a special LanguageCodePage.
;
; * The automatic conversion is also done for any language
;   specific plain text ANSI LicenseFile, InfoBeforeFile, or
;   InfoAfterFile used so you should not convert these either
;   (but you may do so if you wish anyway, unlike ANSI .isl
;   language files).
; * The [Setup] directive ShowUndisplayableLanguages is
;   ignored by Unicode Inno Setup.
; * Unicode Inno Setup is compiled with Delphi 2009 instead
;   of Delphi 2 and 3, leading to slightly larger files. The
;   source code however is still compatible with Delphi 2 and 3,
;   and a non Unicode version will remain available.
; * Existing installations of your programs done by non
;   Unicode installers can be freely updated by Unicode
;   installers, and vice versa.
;
; * Unicode Pascal Scripting notes:
;
;   o The Unicode compiler sees type 'String' as a Unicode
;     string, and 'Char' as a Unicode character. Its 'AnsiString'
;     type hasn't changed and still is an ANSI string. Its 'PChar'
;     type has been renamed to 'PAnsiChar'.
;   o The Unicode compiler is more strict about correct ';'
;     usage: it no longer accepts certain missing ';' characters.
;   o The new RemObjects PascalScript version used by the
;     Unicode compiler supports Unicode, but not for its input
;     source. This means it does use Unicode string types as said,
;     but any literal Unicode characters in the script will be
;     converted to ANSI. This doesn't mean you can't display
;     Unicode strings: you can for example instead use encoded
;     Unicode characters to build Unicode strings
;     (like S := #$0100 + #$0101 + 'Aa';), or load the string
;     from a file using LoadStringsFromFile, or use a {cm:...}
;     constant.
;   o Some support functions had their prototype changed:
;     some parameters of CreateOutputMsgMemoPage,
;     RegQueryBinaryValue, RegWriteBinaryValue, OemToCharBuff,
;     CharToOemBuff, LoadStringFromfile, SaveStringToFile, and
;     GetMD5OfString are of type AnsiString now instead of String.
;   o Added new SaveStringsToUTF8File, and
;     GetMD5OfUnicodeString support functions.
;   o If you want to compile an existing script that
;     imports ANSI Windows API calls with the Unicode compiler,
;     either upgrade to the 'W' Unicode API call or change the
;     parameters from 'String' or 'PChar' to 'AnsiString'. The
;     'AnsiString' approach will make your [Code] compatible
;     with both the Unicode and the non Unicode version.
;   o Added new 'Int64' type, supported by IntToStr. Also
;     added new StrToInt64, StrToInt64Def, and GetSpaceOnDisk64
;     support functions.
;
; * Unicode Inno Setup supports UTF-8 encoded .iss files
;   (but not UTF-16).
; * Unicode Inno Setup supports UTF-8 and UTF-16LE
;   encoded .txt files for LicenseFile, InfoBeforeFile,
;   and InfoAfterFile.
;
;   Note: Unicode Inno Setup can only create Unicode
;   installers and like wise the non Unicode version can
;   only create non Unicode installers. If you want to be
;   able to create both Unicode and non Unicode installers
;   on one computer, you have to install both versions of
;   Inno Setup into different folders.
;
; Pay attention to change calling conventions from...
; old: Char/String to new: PAnsiChar/AnsiString !!!
;
; ###################################################################
;
; Changelog
; 
; 20201116
;
; - Bass-Lib API Upgrade to Version 2.4.15.0 (12/2019).
; - Check for EnforcementMode fixed in EnforcementModeEXEActive()
;   and EnforcementModeScriptActive().
; - Soundfile changed.
;   ("SndHandle" changed for Impulse-Tracker to "BASS_MusicLoad")
; - Skin Error fixed (lost scroll-bar in installer-skin).
;   Reason is an error in the "Codejocks" skinning dll or the skin-file.
;   The unicode version of ISSkin (ISSkinU.dll) has the same eror,
;   when used. The fix is a "redesign" of the coresponding
;   Wizard-Properties (see below in procedure InitializeWizard()).
;   Details:
;   https://stackoverflow.com/questions/35311258/skinned-innosetup-showing-text-instead-of-scrollbar/39821509#39821509
;
; 20210607
;
; - Installer rewritten for Gpg4Win support-installation.
; - Added ISTask.dll external library for process-control of running
;   processes during installation.
; - Added code for checking pre-installed Gpg4Win components.
; - Added GUIDs for local Group-Policy Applocker-Rules.
; - Added [InstallDelete]-Section for complete ROOT-Cert-Upgrade
;
; 20210615
;
; - Added function CheckSRPIsEnabled(): Boolean; like
;   EnforcementModeEXEActive() and EnforcementModeScriptActive() in
;   order to check if Software Restriction-Policy (SRP V1) is
;   enabled. This will be used for writing old "Safer"-Execution
;   Policy-Keys to support older systems.
; - Code cleanup
; - Added reg.exe to Execution-Policy for user-specific environment.
;
; 20210617
;
; - Added function GetGnuPG2Installed(Param: String): String; and
;   GetGpg4WinInstalled(Param: String): String; for dynamic
;   retrieval of the installation-paths of "GnuPG" and "Gpg4Win".
;   So we're also able to support user-defined Installations
;   in other directories.
;
;   GnuPG Install Directory
;
;       HKEY_LOCAL_MACHINE\Software\WOW6432Node\GnuPG
;       Default: Install Directory
;       REG_SZ C:\Program Files (x86)\Gpg4win\..\GnuPG
;
;   Gpg4Win Install-Dir
;
;       HKEY_LOCAL_MACHINE\Software\WOW6432Node\Gpg4win
;       Default: Install Directory
;       REG_SZ C:\Program Files (x86)\Gpg4win
;
;   So we can use these 2 constants:
;
;       {reg:HKLM\Software\WOW6432Node\GnuPG,Install Directory}
;       {reg:HKLM\Software\WOW6432Node\Gpg4win,Install Directory}
;   or 
;       {code:GetGnuPG2Installed}
;       {code:GetGpg4WinInstalled}
;
; - Added firewall-rules by external shellexec for "netsh"
;
; 20210708
;
; - Added Version-Control due to patch-dependency.
;   The installer now checks for "Gpg4Win" version file-string of
;   "kleopatra.exe" in order to support the correct version when
;   doing resouce-fixes and translation-fixes on relevant files.
;   See "#define Gpg4WinVersion" below and "GetGpg4WinVersion"
;   in [Code]-section below ...
;
; - Fixing an error in unattended mode:
;   Now all error-MessageBoxes in Pascal-Code section are disabled,
;   when installer is silently launched with the unattended
;   switches: /SILENT and /VERYSILENT, because of a LOCKING-
;   situation. So /LOG option is HIGHLY RECOMMENDED in
;   unattended operation for debugging !!
;
; 20210813
;
; - Added "MigrateGnuPGKeybase" for Migration of old KeyDB.
;
; 20210919
;
; - Added new Default-Configs of "gpg.conf" and .prf-profiles
;   for "Curve-448" ("Goldilocks") by Mike Hamburg
;   (Rambus Cryptography Research) and curve "secp256k1"
;   (Koblitz Curve of "Bitcoin").
;
; - Implemented automatic certificate-update from Mozilla's cert-store.
;   ===================================================================
; - Added file-downloader:  "VBDownloader.exe"    (Golang with source)
; - Added cert-transcoder:  "VBCertConv.exe"      (Golang with source)
; - Added self-built:       "OpenSSL.exe"         (C-Code binary)
; - Added process-binder:   "BuildTrustList.bat"  (Batch-code)
;
; - Added full ROOT Cert-Store from Mozilla Project into GnuPG-Store.
;
;   All Tools are secured against execution from userspace by using
;   an admin-request in their manifest. The batch-files are also
;   secured against user-execution by triggering "openfiles.exe".
;
; 20211004
;
; - "Run"-Keys re-ordered by addition.
;
; 20211104
;
; - InlinePGP in GpgOL revoked (disabled) by changing
;   "GpgOL_Enable_InlinePGP.exe" to "GpgOL_Config_InlinePGP.exe"
;   because of security considerations against compatibility
;   considerations. In the corresponding ini-file, we're setting
;   the value from "1" to "0" instead creating a new executable
;   for disabling this setting. If the installer is doing an update
;   without an uninstallation before, the registry-values will not
;   be removed and if the new installer will provide a replacement
;   of an existing reg-entry with a new name, we will get an addition
;   (2 entries with contrary functions). So
;   "GpgOL_Config_InlinePGP.exe" is a more neutral name for its
;   functional impact.
;
; - "ExpandGNUPGHOME.exe", "ExpandGNUPGHOME64.exe" updated.
;
; 20211105
;
; - "ExpandGNUPGHOME64.exe" removed from package because the 32-bit
;   version "ExpandGNUPGHOME.exe" does the same job and we dont need
;   redundancy here ... there are no 64-bit dependencies here.
;
; 20211210
;
; - Added MUTEX for installer-instance detection in order to prevent
;   installer from running multiple instances at the same time.
; - Disabling relevant message-boxes, when running in silent mode.
; - Added "Abort;"-procedure to raise an invisible exception, when
;   installer must exit.
; - Removed "ISTask.dll" as helper-object, because it CANNOT DETECT
;   AND KILL TASKS OF OTHER LOGGED-IN USERS IN OTHER X64-SESSIONS
;   ON Windows 10. Used "taskkill.exe" in procedure "TaskKill" by
;   function "Exec()" below.
; - Due to a security concern, which is not fixed yet (as of 20211210),
;   i raised the "s2k-count" value in "gpg-agent.conf" to 65000000 !!
;   For details, look into "gpg-agent.conf".
; - Update to version 1.3.4.0
;
; 20220119
;
; - "StartCon" updated in order to support writing into registry from
;   defined values of the ini-file and to support deletion of values.
;   StartCon also now loggs its actions into the app-eventlog.
;   "Gpg4WinPreConfig.exe" is introduced here and will use the
;   Applocker GUID and Safer-GUID from reg.exe. So ... "reg.exe",
;   "GpgOL_Config_InlinePGP.exe", "GpgOL_Enabe_OLK2016_Resiliency.exe"
;   and "GpgOL_Set_OLK_LoadBehavior.exe" are not needed anymore and
;   were removed from Installer and from execution-policies.
;
; - Certificates updated under ...
;   {commonappdata}\GNU\etc\gnupg\trusted-certs
;
; - Delete old Safer / SrpV2-Keys of removed tools above.
;
; - ToDo:
;   Change type of "ItemData" under {27FF3776-F59C-4329-9A14-25E1C0487E49} from "expandsz" to "string"
;   Change type of "ItemData" under {567CE485-7A23-40c8-AF72-A76E06BBB0A6} from "expandsz" to "string"
;   Change type of "ItemData" under {627CB206-B8AA-43cd-A4EB-2737373FEEAD} from "expandsz" to "string"
;   Change type of "ItemData" under {E6681A4C-458A-43f4-860B-EE848870D02D} from "expandsz" to "string"
;
; - Update to version 1.3.5.0
;
; 20220330
;
; - Update "StartCon" to version 1.0.0.28
; - Update "MigrateGnuPGKeybase" to version 1.0.30.1
; - Implemented unattended installation of sub-package:
;   "gnupg-w32-update.exe" (renamed in order to disable
;   version-dependencies in naming of exe-file).
; - Added NSIS-Installer Package GnuPG 2.2.34.1236 (07.02.2022).
;   Original name: "gnupg-w32-2.2.34_20220207.exe".
;
;   Because this InnoSetup-Installer is updating some files
;   from the above GnuPG-Installer, the GnuPG-Installer must be
;   installed in an early stage of installation.
;   I coded this WITHOUT event-handling under the [Code]-section
;   like:
;
;   procedure CurStepChanged(CurStep: TSetupStep);
;   var
;       ResultCode: Integer;
;   begin
;       // trigger before installing any file.
;       if CurStep = ssInstall then begin
;       ...
;
;   ... by using a dummy-file in the [Files]-section with
;   a "BeforeInstall:"-Flag, triggering a user-defined "GnuPGUpdate"
;   procedure, coded under the [Code]-section.
;
; - Update to version 1.3.6.0
;
; 20220619
;
; - Changed version-scheme in analogy to Gpg4Win, so 1.3.22 <=> 3.1.22.
;
; - Bump version to 1.3.22.0 in order to support Gpg4Win 3.1.22.
;
; - Added VS-NfD Certification Docs for kleopatra, published by the BSI.
;
; - Merged VS-NfD configuration with original configuration of installer
;   package "GnuGP VS Desktop".
;
; 20220708
;
; - Added support for two versions of gpg4win and their file-dependencies.
;   Depending on detected version "Gpg4WinVersion" and "Gpg4WinVersionB"
;   (the latest valid BSI-Version 3.1.16 or the latest Build 3.x.xx),
;   different fixed files may now be installed by evaluation of the two
;   functions: Check: Is3116() / Check: Is31XX().
;
; - Bump version to 1.3.23.0 in order to support Gpg4Win 3.1.23.
;
; 20220906
;
; - Updated NSIS-Installer Package to GnuPG 2.2.39.31776 (02.09.2022).
;   Original name: "gnupg-w32-2.2.39_20220902.exe" (original signed)
;
; - Fixed zlib 1.2.12 with 2 patches for CVE-2022-37434 in my
;   openssl 1.1.1q-build. OpenSSL is used by the x.509-cert update-script:
;   "BuildTrustList.bat" in central master config-directory:
;   "%ProgramData%\GNU\etc\gnupg". For details read "openssl.txt" in
;   the same directory. For security-reasons, my "openssl.exe"-build
;   is using a modified "Manifest", that allows its execution only
;   under admin-rights.
;
; - Bump version to 1.3.23.1 in order to reflect GnuPG version-update.
;
; 20220912
;
; - Bump version to 1.3.24.0 in order to reflect Gpg4Win version-update
;   to 3.1.24.0. Pay attention:
;   "kleopatra.exe" has now a file-version-info string of "3.1.24.0" 
;
; 20221025
;
; - Bump version to 1.3.25.0 in order to reflect Gpg4Win version-update
;   to 3.1.25.0. Pay attention:
;   "kleopatra.exe" has still a file-version-info string of "3.1.24.0"
;
; - Local X.509 ROOT-CERTS disabled.
;   Due to a lot of X.509-cert files under ...
;   "ProgramData\GNU\etc\gnupg\extra-certs" and ...
;   "ProgramData\GNU\etc\gnupg\trusted-certs", with a configurated
;   "trustlist.txt"-file, i recognized an extreme long running task
;   when running "kleopatra" or "gpgol" for the first time of ...
;   gpg, gpg-agent, and scdaemon. The reason are cert-checks for
;   all pub-certs under the directories, mentioned above !!
;
;   THIS MAY RESULT IN A TIMEOUT-ERROR OF GPGOL OR KLEOPATRA !!
;
;   So i disabled this trust-mechanism and moved all certs to
;   "ProgramData\GNU\etc\gnupg\deactivated\". This was only a test
;   for the feasibility of integrating trusted ROOT-CERTS from
;   serveral ROOT-CAs with an automatic update-mechanism.
;
; - Added "gpg-connect-agent.exe" and "gpg-wks-client.exe" to
;   user-based process-termination tool "Gpg4Win_beenden.exe".
;
; - Updated NSIS-Installer Package to GnuPG 2.2.40.11935 (10.10.2022).
;   Original name: "gnupg-w32-2.2.40_20221010.exe" (original signed)
;
; - Fixed removal of file "trustlist_err.txt".
;
; 20221102
;
; - Added "IsGpgVer()" for checking, if GnuPG file-version of
;   "gpg.exe" is like the content of "GpgVersion" in order to support
;   the installation of the correct versions of fixed GnuPG
;   support-files like "pinentry-basic.exe" with fixed german
;   dialog-resources. If we have a version-mismatch, the fixed file
;   will not be installed over the original version. (ToDo:
;   leave the english-version, when english is the installer
;   language).
;
; - In order to customize this installer-code between the versions of
;   supported Gpg4Win/GnuPG-versions (3.x.xx/4.x.xx), change the
;   vars between to token ...:
; ###################################################################
; # Change vars here to support the correct version       - BEGIN - #
; ###################################################################
;   
;   ... and ...
;   
; ###################################################################
; # Change vars here to support the correct version       -  END  - #
; ###################################################################
;
;   ... below ...
;
; - Added english versions of VS-NfD SecOPs-documents, shown in
;   Gpg4Win 3.1.2x and 4.0.x.
;
; - Added additional objects for process-kill at startup.
;
;   Actually the following processes are killed at starup:
;   outlook.exe, kleopatra.exe, gpa.exe, gpgme-w32spawn.exe,
;   gpg-agent.exe, gpg-connect-agent.exe, gpg-wks-client.exe,
;   gpg.exe, dirmngr.exe, gpgsm.exe, scdaemon.exe, pinentry-w32.exe,
;   pinentry.exe, pinentry-basic.exe.
;   
; ###################################################################

#define MyAppName "GpgTools"
#define MyAppID "{DC6550A5-7337-400d-B59C-A7F0E310B300}"
#define MyAppCopyright "Veit Berwig"
#define MyAppPublisher "Veit Berwig"
#define MyAppURL "https://github.com/landsh-de/GpgTools"
#define MyAppDescr "GpgTools, Patches und zentrale Konfiguration für Gpg4Win"
#define MySetupMutex "GpgToolsSetupMutex"

; ###################################################################
; # Change vars here to support the correct version       - BEGIN - #
; ###################################################################
; ===================================================================
; Gpg4Win 3.1.25
#define MyAppVer "1.3.25.1"
#define MyAppVerName "GpgTools 1.3.25.1"
; Gpg4Win 4.0.4
; #define MyAppVer "1.4.04.0"
; #define MyAppVerName "GpgTools 1.4.04.0"
; ###################################################################
; # I'm comparing the string fileversion of the installed 
; # "kleopatra.exe" with var: "Gpg4WinVersion" and "Gpg4WinVersionB"
; # in Code-Section below.
; # 
; # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
; # !!! Be aware, that the file-version string of "kleopatra.exe" !!!
; # !!!  MUST NOT BE THE SAME AS THE PRODUCT-VERSION OF GPG4WIN.  !!!
; # !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
; #
; # Due to Gpg4Win-updates, update this string to the correct
; # file-version of "kleopatra.exe" !!
; ###################################################################
#define Gpg4WinVersion  "3.1.16.0"
#define Gpg4WinVersionB "3.1.24.0"
; ===================================================================
; FileVersion Index-String of other helper-tools of Gpg4Win for finding
; the right version with german resources:
; ===================================================================
; pinentry-w32.exe_{#Gpg4WinVersion},  if kleopatra = Gpg4WinVersion
; gpgex.mo_{#Gpg4WinVersion},          if kleopatra = Gpg4WinVersion
; gpgol.mo_{#Gpg4WinVersion},          if kleopatra = Gpg4WinVersion
; ===================================================================
; pinentry-w32.exe_{#Gpg4WinVersionB}, if kleopatra = Gpg4WinVersionB
; gpgex.mo_{#Gpg4WinVersionB},         if kleopatra = Gpg4WinVersionB
; gpgol.mo_{#Gpg4WinVersionB},         if kleopatra = Gpg4WinVersionB
; ===================================================================

; ===================================================================
; FileVersion Info-String of "gpg.exe" AFTER installation of ...
;                                              "gnupg-w32-update.exe"
; ===================================================================
; GnuPG Release 2.2 / "gnupg-w32-update.exe" is GnuPG 2.2.40
#define GpgVersion   "2.2.40.11935"
; GnuPG Release 2.3 / "gnupg-w32-update.exe" is GnuPG 2.3.8
; #define GpgVersion "2.3.8.28434"
; ===================================================================

; ===================================================================
; FileVersion Index-String of "pinentry-basic.exe" for finding the
; right version with german resources AFTER installation of ...
;                                              "gnupg-w32-update.exe"
; ===================================================================
; GnuPG Release 2.2 / "gnupg-w32-update.exe" is GnuPG 2.2.40
#define GpgVersionIDX "3.1.25.0"
; GnuPG Release 2.3 / "gnupg-w32-update.exe" is GnuPG 2.3.8
; #define GpgVersionIDX "4.0.4"
; ===================================================================

; ###################################################################
; # Change vars here to support the correct version       -  END  - #
; ###################################################################

; ###################################################################

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{#MyAppID}
AppName={#MyAppName}
AppVerName={#MyAppVerName}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={commonpf32}\{#MyAppName}
DefaultGroupName={#MyAppName}
LicenseFile=res\license\gpl-3.0-de.txt
InfoBeforeFile=res\InfoBefore.txt
InfoAfterFile=res\InfoAfter.txt
OutputBaseFilename=gpgtools
SetupIconFile=res\Icon1.ico
Compression=lzma2/max
SolidCompression=no
InternalCompressLevel=max
LZMAAlgorithm=1
;ChangesEnvironment=yes
OutputDir=output
WizardImageFile=res\wizmodernimage.bmp
;WizardImageBackColor=clWhite
WizardSmallImageFile=res\wizmodernsmallimage.bmp
VersionInfoDescription={#MyAppDescr}
VersionInfoCopyright={#MyAppCopyright}
VersionInfoProductName={#MyAppName}
VersionInfoProductVersion={#MyAppVer}
VersionInfoVersion={#MyAppVer}
AppVersion={#MyAppVer}
UninstallDisplayIcon={app}\Icon1.ico
MinVersion=6.1sp1
PrivilegesRequired=admin
; "ArchitecturesInstallIn64BitMode=x64" requests that the install be
; done in "64-bit mode" on x64, meaning it should use the native
; 64-bit Program Files directory and the 64-bit view of the registry.
; On all other architectures it will install in "32-bit mode".
; ArchitecturesInstallIn64BitMode=x64
; Note: We don't set ProcessorsAllowed because we want this
; installation to run on all architectures (including Itanium,
; since it's capable of running 32-bit code too).
DisableWelcomePage=no
; ###################################################################
; ########################### UPDATE HERE ###########################
; For doing an update to an existing installation, we're
; using the three following directives:
UsePreviousAppDir=yes
; Updating uninstall-entry with version-update
CreateUninstallRegKey=yes
; Do not change the title displayed in the uninstaller
UpdateUninstallLogAppName=no
; ###################################################################
; ########################### UPDATE HERE ###########################
; CloseApplications to replace them
; https://jrsoftware.org/ishelp/index.php?topic=setup_closeapplications
; 
; If set to yes or force and Setup is not running silently, Setup
; will pause on the Preparing to Install wizard page if it detects
; applications using files that need to be updated by the ... 
; ... [Files] or ...
; ... [InstallDelete] ...
; section, showing the applications and asking the user if Setup
; should automatically close the applications and restart them after
; the installation has completed.
; 
; If set to yes or force and Setup is running silently, Setup will
; always close and restart such applications, unless told not to via
; the command line.
; 
; If set to force Setup will force close when closing applications,
; unless told not to via the command line. Use with care since this
; may cause the user to lose unsaved work.
; 
; Note: 
; Setup uses Windows Restart Manager ...
; https://docs.microsoft.com/en-us/windows/win32/rstmgr/about-restart-manager
; ... to detect, close, and restart applications.
; CloseApplications=force

; Create MUTEXES to prevent multiple interactive installations of
; same installer (not practical in silent install mode).
; AppMutex=GpgToolsAppMutex,Global\GpgToolsAppMutex
; SetupMutex={#MySetupMutex},Global\{#MySetupMutex}

[Languages]
Name: english; MessagesFile: compiler:Default.isl
Name: german; MessagesFile: compiler:Languages\German.isl

[InstallDelete]
; ###################################################################
; ## Cleanup Cert-Paths before installing new certs with trustlist ##
; ###################################################################
Type: filesandordirs; Name: "{commonappdata}\GNU\etc\gnupg\extra-certs"
Type: filesandordirs; Name: "{commonappdata}\GNU\etc\gnupg\trusted-certs"
Type: filesandordirs; Name: "{commonappdata}\GNU\etc\gnupg\source"
Type: files; Name: "{commonappdata}\GNU\etc\gnupg\trustlist.txt"
Type: files; Name: "{commonappdata}\GNU\etc\gnupg\trustlist_err.txt"
; ###################################################################
; ## Cleanup old tools from install target before new rollout      ##
; ###################################################################
; Type: files; Name: "{app}\StartCon\*.*"
Type: filesandordirs; Name: "{app}\StartCon"

[Files]
; Due to this preinstallation environment we have to take care
; that these files reside in top-of the archive-base when we
; set "SolidCompression" to "true".
; ----------------------------------------------------- PRE-INSTALLATION BEGIN
; Prepare BASS Soundlib for installer sound
;
; ### X86/X64 arch selection ### >>> x86
; ### X86/X64 arch selection ### Place all architecture common files here,
; ### X86/X64 arch selection ### first one should be marked 'solidbreak'
Source: res\bass\bass.dll; DestDir: {tmp}; Flags: dontcopy noencryption nocompression solidbreak
Source: res\bass\sound.it; DestDir: {tmp}; Flags: dontcopy noencryption nocompression
; ISSkin DLL used for skinning Inno Setup installations.
Source: res\skin\ISSkinU.dll; DestDir: {tmp}; Flags: dontcopy noencryption nocompression
; Visual Style resource contains resources used for skinning,
Source: res\skin\Installer.cjstyles; DestDir: {tmp}; Flags: dontcopy noencryption nocompression
; ---------------------------------------------------------------------------
; ###########################################################################
; # Add Update GnuPG-Backend for unattended install             -- BEGIN -- #
; # Run with: {tmp}\gnupg-w32-update.exe /S                                 #
; ###########################################################################
; If we use "Flags: dontcopy" here, we have to use the function ...
;    ExtractTemporaryFile('gnupg-w32-update.exe');
; ... in [Code]-section below. Extraction by PascalScripting in
; [Code]-section below, extracts the file earlier than extraction by the
; normal file copying stage.
Source: data\GpgUpdate\gnupg-w32-update.exe; DestDir: {tmp}; Flags: dontcopy noencryption nocompression
; ###########################################################################
; # Add Update GnuPG-Backend for unattended install             --  END  -- #
; ###########################################################################
; ---------------------------------------------------------------------------
; ###########################################################################
; !! DISABLED HERE, BECAUSE "ISTask.dll" CANNOT DETECT AND KILLE TASKS     !!
; !! OF OTHER LOGGED-IN USERS IN OTHER X64-SESSIONS ON Windows 10          !!
; ###########################################################################
; !! LEFT IN CODE HERE ONLY FOR DOCUMENTATION                              !!
; ###########################################################################
; Process-Control of Apps holding files open during install
; Source: plugins\ISTask.dll; DestDir: {tmp}; Flags: dontcopy noencryption nocompression
; ----------------------------------------------------- PRE-INSTALLATION END
; ### X86/X64 arch selection ### >>> x64
; ### X86/X64 arch selection ### Place all x64 architecture files here,
; ### X86/X64 arch selection ### first one should be marked 'solidbreak'
; Source: data\ProgramData\GNU\*; DestDir: {commonappdata}\GNU; Flags: ignoreversion recursesubdirs createallsubdirs uninsrestartdelete overwritereadonly solidbreak; Check: Is64BitInstallMode; Components: conftool confpatchtool conftoolpol confpatchtoolpol
; Source: data\ProgramData\GNU\*; DestDir: {commonappdata}\GNU; Flags: ignoreversion recursesubdirs createallsubdirs uninsrestartdelete overwritereadonly solidbreak; Check: IsWin64; Components: conftool confpatchtool conftoolpol confpatchtoolpol
; ### X86/X64 arch selection ### >>> x86
; ### X86/X64 arch selection ### Place all architecture common files here,
; ### X86/X64 arch selection ### first one should be marked 'solidbreak'
; NOTE: Don't use "Flags: ignoreversion" on any shared system files
; Local User Environment Expander
;
; ################ Dummy for triggering GnuPGUpdate #################
Source: data\GpgUpdate\dummy; DestDir: {commonappdata}\GNU; BeforeInstall: GnuPGUpdate; Flags: ignoreversion recursesubdirs createallsubdirs uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
;
; ########################## Konfig-Files ###########################
Source: data\ProgramData\GNU\*; DestDir: {commonappdata}\GNU; Flags: ignoreversion recursesubdirs createallsubdirs uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
;
; ###################################################################
; ######################### Program-Patches #########################
; ###################################################################
; 
; Source: data\Program Files (x86)\GnuPG\*; DestDir: {code:GetGnuPG2Installed}; Flags: ignoreversion recursesubdirs createallsubdirs uninsrestartdelete overwritereadonly; Components: confpatchtoolpol confpatchtool
; Source: data\Program Files (x86)\Gpg4win\*; DestDir: {code:GetGpg4WinInstalled}; Flags: ignoreversion recursesubdirs createallsubdirs uninsrestartdelete overwritereadonly; Components: confpatchtoolpol confpatchtool
;
; NEVER delete files on uninstall (were previously installed by another installer)
Source: data\Program Files (x86)\GnuPG\bin\pinentry-basic.exe_{#GpgVersionIDX}; DestName: "pinentry-basic.exe"; DestDir: {code:GetGnuPG2Installed}\bin; Flags: ignoreversion uninsneveruninstall overwritereadonly; Components: confpatchtoolpol confpatchtool; Check: IsGpgVer()
Source: data\Program Files (x86)\GnuPG\share\doc\gnupg\examples\Automatic.prf; DestDir: {code:GetGnuPG2Installed}\share\doc\gnupg\examples; Flags: ignoreversion uninsneveruninstall overwritereadonly; Components: confpatchtoolpol confpatchtool
Source: data\Program Files (x86)\GnuPG\share\doc\gnupg\examples\VS-NfD.prf; DestDir: {code:GetGnuPG2Installed}\share\doc\gnupg\examples; Flags: ignoreversion uninsneveruninstall overwritereadonly; Components: confpatchtoolpol confpatchtool
; Delete files on uninstall (were NOT previously installed by another installer)
Source: data\Program Files (x86)\GnuPG\share\doc\gnupg\examples\Brainpool256.prf; DestDir: {code:GetGnuPG2Installed}\share\doc\gnupg\examples; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Source: data\Program Files (x86)\GnuPG\share\doc\gnupg\examples\Brainpool384.prf; DestDir: {code:GetGnuPG2Installed}\share\doc\gnupg\examples; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Source: data\Program Files (x86)\GnuPG\share\doc\gnupg\examples\Brainpool512.prf; DestDir: {code:GetGnuPG2Installed}\share\doc\gnupg\examples; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Source: data\Program Files (x86)\GnuPG\share\doc\gnupg\examples\Curve-secp256k1.prf; DestDir: {code:GetGnuPG2Installed}\share\doc\gnupg\examples; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Source: data\Program Files (x86)\GnuPG\share\doc\gnupg\examples\Curve448.prf; DestDir: {code:GetGnuPG2Installed}\share\doc\gnupg\examples; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Source: data\Program Files (x86)\GnuPG\share\doc\gnupg\examples\Curve25519.prf; DestDir: {code:GetGnuPG2Installed}\share\doc\gnupg\examples; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Source: data\Program Files (x86)\GnuPG\share\doc\gnupg\examples\RSA-4096.prf; DestDir: {code:GetGnuPG2Installed}\share\doc\gnupg\examples; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
; Only for debugging
; Source: data\Program Files (x86)\GnuPG\share\doc\gnupg\examples\Debug.prf; DestDir: {code:GetGnuPG2Installed}\share\doc\gnupg\examples; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool

; Install only for Gpg4Win Var:"Gpg4WinVersion"
Source: data\Program Files (x86)\Gpg4win\bin\pinentry-w32.exe_{#Gpg4WinVersion}; DestName: "pinentry-w32.exe"; DestDir: {code:GetGpg4WinInstalled}\bin; Flags: ignoreversion uninsneveruninstall overwritereadonly; Components: confpatchtoolpol confpatchtool; Check: Is3116()
; Install only for Gpg4Win Var:"Gpg4WinVersionB"
Source: data\Program Files (x86)\Gpg4win\bin\pinentry-w32.exe_{#Gpg4WinVersionB}; DestName: "pinentry-w32.exe"; DestDir: {code:GetGpg4WinInstalled}\bin; Flags: ignoreversion uninsneveruninstall overwritereadonly; Components: confpatchtoolpol confpatchtool; Check: Is31XX()

; Install only for Gpg4Win Var:"Gpg4WinVersion"
Source: data\Program Files (x86)\Gpg4win\share\locale\de\LC_MESSAGES\gpgex.mo_{#Gpg4WinVersion}; DestName: "gpgex.mo"; DestDir: {code:GetGpg4WinInstalled}\share\locale\de\LC_MESSAGES; Flags: ignoreversion uninsneveruninstall overwritereadonly; Components: confpatchtoolpol confpatchtool; Check: Is3116()
Source: data\Program Files (x86)\Gpg4win\share\locale\de\LC_MESSAGES\gpgol.mo_{#Gpg4WinVersion}; DestName: "gpgol.mo"; DestDir: {code:GetGpg4WinInstalled}\share\locale\de\LC_MESSAGES; Flags: ignoreversion uninsneveruninstall overwritereadonly; Components: confpatchtoolpol confpatchtool; Check: Is3116()
; Install only for Gpg4Win Var:"Gpg4WinVersionB"
Source: data\Program Files (x86)\Gpg4win\share\locale\de\LC_MESSAGES\gpgex.mo_{#Gpg4WinVersionB}; DestName: "gpgex.mo"; DestDir: {code:GetGpg4WinInstalled}\share\locale\de\LC_MESSAGES; Flags: ignoreversion uninsneveruninstall overwritereadonly; Components: confpatchtoolpol confpatchtool; Check: Is31XX()
Source: data\Program Files (x86)\Gpg4win\share\locale\de\LC_MESSAGES\gpgol.mo_{#Gpg4WinVersionB}; DestName: "gpgol.mo"; DestDir: {code:GetGpg4WinInstalled}\share\locale\de\LC_MESSAGES; Flags: ignoreversion uninsneveruninstall overwritereadonly; Components: confpatchtoolpol confpatchtool; Check: Is31XX()

; ###################################################################
; GnuPG-Options: "display-charset utf8" "utf8-strings" were removed
; but in spite of the fixes above, Umlauts are not displayed
; correctly in Basic- and W32-versions of pinentry. We do not provide
; a fixed german Version (no Umlauts were replaced), because the
; QT-version runs correctly.
; ###################################################################
; Source: data\Program Files (x86)\Gpg4win\bin\pinentry.exe; DestDir: {code:GetGpg4WinInstalled}\bin; Flags: ignoreversion uninsneveruninstall overwritereadonly; Components: confpatchtoolpol confpatchtool
; ###################################################################
; Source: data\Program Files (x86)\GnuPG\share\locale\de\LC_MESSAGES\gnupg2.mo; DestDir: {code:GetGnuPG2Installed}\share\locale\de\LC_MESSAGES; Flags: ignoreversion uninsneveruninstall overwritereadonly; Components: confpatchtoolpol confpatchtool
; Source: data\Program Files (x86)\GnuPG\share\locale\de\LC_MESSAGES\libgpg-error.mo; DestDir: {code:GetGnuPG2Installed}\share\locale\de\LC_MESSAGES; Flags: ignoreversion uninsneveruninstall overwritereadonly; Components: confpatchtoolpol confpatchtool
; Source: data\Program Files (x86)\Gpg4win\share\locale\de\LC_MESSAGES\libgpg-error.mo; DestDir: {code:GetGpg4WinInstalled}\share\locale\de\LC_MESSAGES; Flags: ignoreversion uninsneveruninstall overwritereadonly; Components: confpatchtoolpol confpatchtool
; ###################################################################
; 
; ###################################################################
; ############################# Addons ##############################
; ###################################################################
; 
; Delete files on uninstall (were NOT previously installed by another installer)
Source: data\Program Files (x86)\Gpg4win\share\kdeglobals; DestDir: {code:GetGpg4WinInstalled}\share; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Source: data\Program Files (x86)\Gpg4win\share\kleopatrarc; DestDir: {code:GetGpg4WinInstalled}\share; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
; ########################## VS-NfD Certification Docs ##############
Source: data\Program Files (x86)\Gpg4win\share\doc\gnupg-vsd\BSI-VSA-10573_secops-20220207.pdf; DestDir: {code:GetGpg4WinInstalled}\share\doc\gnupg-vsd; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Source: data\Program Files (x86)\Gpg4win\share\doc\gnupg-vsd\BSI-VSA-10584_secops-20220207.pdf; DestDir: {code:GetGpg4WinInstalled}\share\doc\gnupg-vsd; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Source: data\Program Files (x86)\Gpg4win\share\doc\gnupg-vsd\BSI-VSA-10573-ENG_secops-20220207.pdf; DestDir: {code:GetGpg4WinInstalled}\share\doc\gnupg-vsd; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Source: data\Program Files (x86)\Gpg4win\share\doc\gnupg-vsd\BSI-VSA-10584-ENG_secops-20220207.pdf; DestDir: {code:GetGpg4WinInstalled}\share\doc\gnupg-vsd; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
; ########################## Program-Icon ###########################
Source: data\Program Files (x86)\GpgTools\Icon0.ico; DestDir: {app}; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Source: data\Program Files (x86)\GpgTools\Icon1.ico; DestDir: {app}; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Source: data\Program Files (x86)\GpgTools\Icon2.ico; DestDir: {app}; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Source: data\Program Files (x86)\GpgTools\Icon3.ico; DestDir: {app}; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
; ########################## Program-Tools ##########################
; Source: data\Program Files (x86)\GpgTools\*; DestDir: {app}; Flags: ignoreversion recursesubdirs createallsubdirs uninsrestartdelete overwritereadonly; Components: conftool confpatchtool conftoolpol confpatchtoolpol
Source: data\Program Files (x86)\GpgTools\Doc\GnuPG_Yubikey-Support.txt; DestDir: {app}\Doc; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Source: data\Program Files (x86)\GpgTools\Doc\Hinweise.txt; DestDir: {app}\Doc; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
; Already in Gpg4Win-Package "{code:GetGpg4WinInstalled}\share\gpg4win\gpg4win-compendium-de.pdf"
; See below in [Icons] ...
; Source: data\Program Files (x86)\GpgTools\Doc\gpg4win-compendium-de.pdf; DestDir: {app}\Doc; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Source: data\Program Files (x86)\GpgTools\Doc\kleopatra_de.pdf; DestDir: {app}\Doc; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Source: data\Program Files (x86)\GpgTools\Doc\Quickguide_GnuPG.pdf; DestDir: {app}\Doc; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Source: data\Program Files (x86)\GpgTools\Doc\gnupg.pdf; DestDir: {app}\Doc; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Source: data\Program Files (x86)\GpgTools\ExpandGNUPGHOME\ExpandGNUPGHOME.exe; DestDir: {app}\ExpandGNUPGHOME; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Source: data\Program Files (x86)\GpgTools\ExpandGNUPGHOME\ExpandGNUPGHOME.ini; DestDir: {app}\ExpandGNUPGHOME; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Source: data\Program Files (x86)\GpgTools\ExpandGNUPGHOME\ExpandGNUPGHOME.src.zip; DestDir: {app}\ExpandGNUPGHOME; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Source: data\Program Files (x86)\GpgTools\ExpandGNUPGHOME\ExpandGNUPGHOME.txt; DestDir: {app}\ExpandGNUPGHOME; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
; Source: data\Program Files (x86)\GpgTools\ExpandGNUPGHOME\ExpandGNUPGHOME64.exe; DestDir: {app}\ExpandGNUPGHOME; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
; Source: data\Program Files (x86)\GpgTools\ExpandGNUPGHOME\ExpandGNUPGHOME64.ini; DestDir: {app}\ExpandGNUPGHOME; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Source: data\Program Files (x86)\GpgTools\StartCon\Gpg4Win_beenden.exe; DestDir: {app}\StartCon; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Source: data\Program Files (x86)\GpgTools\StartCon\Gpg4Win_beenden.ini; DestDir: {app}\StartCon; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Source: data\Program Files (x86)\GpgTools\StartCon\Gpg4WinPreConfig.exe; DestDir: {app}\StartCon; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Source: data\Program Files (x86)\GpgTools\StartCon\Gpg4WinPreConfig.ini; DestDir: {app}\StartCon; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Source: data\Program Files (x86)\GpgTools\StartCon\doc\StartCon.txt; DestDir: {app}\StartCon\doc; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Source: data\Program Files (x86)\GpgTools\StartCon\license\gpl-3.0-de.txt; DestDir: {app}\StartCon\license; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Source: data\Program Files (x86)\GpgTools\StartCon\license\gpl-3.0.txt; DestDir: {app}\StartCon\license; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Source: data\Program Files (x86)\GpgTools\StartCon\source\StartCon-Source.zip; DestDir: {app}\StartCon\source; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Source: data\Program Files (x86)\GpgTools\MigrateGnuPGKeybase\MigrateGnuPGKeybase.exe; DestDir: {app}\MigrateGnuPGKeybase; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Source: data\Program Files (x86)\GpgTools\MigrateGnuPGKeybase\MigrateGnuPGKeybase.ini; DestDir: {app}\MigrateGnuPGKeybase; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Source: data\Program Files (x86)\GpgTools\MigrateGnuPGKeybase\doc\MigrateGnuPGKeybase.txt; DestDir: {app}\MigrateGnuPGKeybase\doc; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Source: data\Program Files (x86)\GpgTools\MigrateGnuPGKeybase\license\gpl-3.0-de.txt; DestDir: {app}\MigrateGnuPGKeybase\license; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Source: data\Program Files (x86)\GpgTools\MigrateGnuPGKeybase\license\gpl-3.0.txt; DestDir: {app}\MigrateGnuPGKeybase\license; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Source: data\Program Files (x86)\GpgTools\MigrateGnuPGKeybase\source\MigrateGnuPGKeybase.zip; DestDir: {app}\MigrateGnuPGKeybase\source; Flags: ignoreversion uninsrestartdelete overwritereadonly; Components: confpatchtoolpol conftoolpol confpatchtool conftool

[Dirs]

[Types]
; 'Types': What get displayed during the setup
Name: "fullpol"; Description: "Konfig, Tools und Patches inkl. Policy";
Name: "compactpol"; Description: "Konfig und Tools inkl. Policy";
Name: "full"; Description: "Konfig, Tools und Patches";
Name: "compact"; Description: "Konfig und Tools";

[Components]
; Components are used inside the script and
; can be composed of a set of 'Types'
Name: "confpatchtoolpol"; Description: "Konfig, Tools, Patches, Policy"; Types: fullpol compactpol full compact; Flags: fixed
Name: "conftoolpol"; Description: "Konfig, Tools, Policy"; Types: compactpol compact
Name: "confpatchtool"; Description: "Konfig, Tools, Patches"; Types: full compact
Name: "conftool"; Description: "Konfig, Tools"; Types: compact

[Registry]
; Installer-ID zur Installationspruefung
Root: "HKLM"; Subkey: "SOFTWARE\GNU"; ValueType: string; Flags: uninsdeletekeyifempty uninsdeletevalue createvalueifdoesntexist; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Root: "HKLM"; Subkey: "SOFTWARE\GNU\{#MyAppName}"; ValueType: string; Flags: uninsdeletekeyifempty uninsdeletevalue createvalueifdoesntexist; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Root: "HKLM"; Subkey: "SOFTWARE\GNU\{#MyAppName}\AppID"; ValueType: string; Flags: uninsdeletekeyifempty uninsdeletevalue createvalueifdoesntexist; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Root: "HKLM"; Subkey: "SOFTWARE\GNU\{#MyAppName}\AppID\{{#MyAppID}"; ValueType: string; Flags: uninsdeletekeyifempty uninsdeletevalue createvalueifdoesntexist; Components: confpatchtoolpol conftoolpol confpatchtool conftool
; AutoRun Init Sychronisation Gpg4Win-Konfig
;
; ###################################################################
; !!!!!!!!!!!!!!!!!!!!! Be aware of this fact !!!!!!!!!!!!!!!!!!!!!!!
; ###################################################################
; During bootup, the "RUN" registry key will be read sequentially.
;
; The items will be executed in the order that they physically exist
; within the registry database. That physical order is determined by
; the sequence they were entered / added in the registry.
; 
; The order that you see while looking at the RUN key through the
; REGEDIT GUI is only cosmetic (notice that there are sortable
; columns there in the GUI also). If you want to learn the true
; physical order that they are stored (and thus will be executed),
; you will want to export the RUN key and look at in a text editor.
; 
; Source:
; https://msfn.org/board/topic/158037-aplication-execution-order-in-run-registry/?tab=comments#comment-1008325
;
; ###################################################################
; !!!!!!! SO THE ORDER OF ADDING THE KEYS BELOW IS IMPORTANT !!!!!!!!
; ###################################################################
;
; #########################################################################################
; # Delete old AutoRun Init, Safer, SrpV2 keys of GpgOL_Enabe_OLK2016_Resiliency when found
; # Delete old AutoRun Init, Safer, SrpV2 keys of GpgOL_Set_OLK_LoadBehavior     when found
; # Delete old AutoRun Init, Safer, SrpV2 keys of GpgOL_Config_InlinePGP         when found
; #########################################################################################
Root: "HKLM"; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: none; ValueName: "GpgOL_Enabe_OLK2016_Resiliency"; Flags: deletevalue; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Root: "HKLM"; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: none; ValueName: "GpgOL_Set_OLK_LoadBehavior"; Flags: deletevalue; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Root: "HKLM"; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: none; ValueName: "GpgOL_Config_InlinePGP"; Flags: deletevalue; Components: confpatchtoolpol conftoolpol confpatchtool conftool
; Delete old "GpgOL_Enabe_OLK2016_Resiliency ..."
Root: "HKLM"; Subkey: "SOFTWARE\Policies\Microsoft\Windows\safer\codeidentifiers\262144\Paths\{{54CECC54-313E-469c-A257-4FA25A37C16A}"; ValueType: none; Flags: deletekey; Components: confpatchtoolpol conftoolpol confpatchtool conftool
; Delete old "GpgOL_Set_OLK_LoadBehavior ..."
Root: "HKLM"; Subkey: "SOFTWARE\Policies\Microsoft\Windows\safer\codeidentifiers\262144\Paths\{{F26F6CE3-606D-4a1c-8649-83A21ADFFDA2}"; ValueType: none; Flags: deletekey; Components: confpatchtoolpol conftoolpol confpatchtool conftool
; Delete old "GpgOL_Config_InlinePGP ..."
Root: "HKLM"; Subkey: "SOFTWARE\Policies\Microsoft\Windows\safer\codeidentifiers\262144\Paths\{{680D4DAB-C292-4e48-99F6-AE5ADCA8D10B}"; ValueType: none; Flags: deletekey; Components: confpatchtoolpol conftoolpol confpatchtool conftool
; Delete old "GpgTools_GpgOL_Enabe_OLK2016_Resiliency"
Root: "HKLM"; Subkey: "SOFTWARE\Policies\Microsoft\Windows\SrpV2\Exe\50188B46-0B3A-4b57-83A3-23ABB57CB843"; ValueType: none; Flags: deletekey; Components: confpatchtoolpol conftoolpol confpatchtool conftool
; Delete old "GpgTools_GpgOL_Set_OLK_LoadBehavior"
Root: "HKLM"; Subkey: "SOFTWARE\Policies\Microsoft\Windows\SrpV2\Exe\DD93F54D-CB4E-4f37-A76D-0254E8FD0806"; ValueType: none; Flags: deletekey; Components: confpatchtoolpol conftoolpol confpatchtool conftool
; Delete old "GpgTools_GpgOL_Config_InlinePGP"
Root: "HKLM"; Subkey: "SOFTWARE\Policies\Microsoft\Windows\SrpV2\Exe\E35EC1E7-C3A9-4c90-AF86-103AD864F87C"; ValueType: none; Flags: deletekey; Components: confpatchtoolpol conftoolpol confpatchtool conftool
;
; AutoRun Init Syncronize Gpg4Win settings to local user profile
; Root: "HKLM"; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: expandsz; ValueName: "Sync_Gpg4Win_Settings"; ValueData: """{app}\FastCopy.exe"" /cmd=update /auto_close /force_close /estimate /log=FALSE ""{commonappdata}\GNU\*.*"" /to=""%APPDATA%\gnupg"""; Flags: uninsdeletevalue; Components: confpatchtool confpatchtoolpol
; AutoRun Init Cleanup Gpg4Win Processes and Sockets "Gpg4Win beenden"
Root: "HKLM"; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: expandsz; ValueName: "Gpg4Win_Cleanup"; ValueData: """{app}\StartCon\Gpg4WinPreConfig.exe"""; Flags: uninsdeletevalue; Components: confpatchtoolpol conftoolpol confpatchtool conftool
; AutoRun Init Migrate_GnuPG_Keybase (should run first from reg-entries)
Root: "HKLM"; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: expandsz; ValueName: "Migrate_GnuPG_Keybase"; ValueData: """{app}\MigrateGnuPGKeybase\MigrateGnuPGKeybase.exe"""; Flags: uninsdeletevalue; Components: confpatchtoolpol conftoolpol confpatchtool conftool
; AutoRun Init Expand GNUPGHOME Environment to local user environment (x86)
Root: "HKLM"; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: expandsz; ValueName: "Expand_GNUPGHOME"; ValueData: """{app}\ExpandGNUPGHOME\ExpandGNUPGHOME.exe"""; Flags: uninsdeletevalue; Components: confpatchtoolpol conftoolpol confpatchtool conftool
; AutoRun Init Expand GNUPGHOME Environment to local user environment (x64)
; Root: "HKLM"; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: expandsz; ValueName: "Expand_GNUPGHOME_x64"; ValueData: """{app}\ExpandGNUPGHOME\ExpandGNUPGHOME64.exe"""; Flags: uninsdeletevalue; Components: confpatchtoolpol conftoolpol confpatchtool conftool

; ###################################################################
; ####################### Execution Policies ########################
; ###################################################################
; https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-xp/bb457006(v=technet.10)
; Policy Execution Enabler
Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144"; ValueType: string; Flags: uninsdeletekeyifempty uninsdeletevalue createvalueifdoesntexist; Components: confpatchtoolpol conftoolpol
Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths"; ValueType: string; Flags: uninsdeletekeyifempty uninsdeletevalue createvalueifdoesntexist; Components: confpatchtoolpol conftoolpol

; Policy Execution Enabler GpgTools -FASTCOPY-
; Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{{452B70B1-3A90-4258-9D04-F740B204B2FE}"; ValueType: string; ValueName: "Description"; ValueData: "Fast File Copy with Sychronizing Feature. FREEWARE by SHIROUZU Hiroaki"; Flags: uninsdeletekeyifempty uninsdeletevalue; Components: confpatchtoolpol conftoolpol
; Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{{452B70B1-3A90-4258-9D04-F740B204B2FE}"; ValueType: string; ValueName: "ItemData"; ValueData: "{app}\FastCopy\FastCopy.exe"; Flags: uninsdeletekeyifempty uninsdeletevalue; Components: confpatchtoolpol conftoolpol
; Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{{452B70B1-3A90-4258-9D04-F740B204B2FE}"; ValueType: dword; ValueName: "SaferFlags"; ValueData: "00000000"; Flags: uninsdeletekeyifempty uninsdeletevalue; Components: confpatchtoolpol conftoolpol

; Policy Execution Enabler EXE-RULE FOR "GnuPG_All_Files"
Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{{E6681A4C-458A-43f4-860B-EE848870D02D}"; ValueType: string; ValueName: "Description"; ValueData: "GnuPG_All_Files"; Flags: uninsdeletekeyifempty uninsdeletevalue; Components: confpatchtoolpol conftoolpol; Check: CheckSRPIsEnabled()
Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{{E6681A4C-458A-43f4-860B-EE848870D02D}"; ValueType: expandsz; ValueName: "ItemData"; ValueData: "{code:GetGnuPG2Installed}\bin"; Flags: uninsdeletekeyifempty uninsdeletevalue; Components: confpatchtoolpol conftoolpol; Check: CheckSRPIsEnabled()
Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{{E6681A4C-458A-43f4-860B-EE848870D02D}"; ValueType: dword; ValueName: "SaferFlags"; ValueData: "00000000"; Flags: uninsdeletekeyifempty uninsdeletevalue; Components: confpatchtoolpol conftoolpol; Check: CheckSRPIsEnabled()
; Policy Execution Enabler EXE-RULE FOR "Gpg4Win_All_Files"
Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{{627CB206-B8AA-43cd-A4EB-2737373FEEAD}"; ValueType: string; ValueName: "Description"; ValueData: "Gpg4Win_All_Files"; Flags: uninsdeletekeyifempty uninsdeletevalue; Components: confpatchtoolpol conftoolpol; Check: CheckSRPIsEnabled()
Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{{627CB206-B8AA-43cd-A4EB-2737373FEEAD}"; ValueType: expandsz; ValueName: "ItemData"; ValueData: "{code:GetGpg4WinInstalled}\bin"; Flags: uninsdeletekeyifempty uninsdeletevalue; Components: confpatchtoolpol conftoolpol; Check: CheckSRPIsEnabled()
Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{{627CB206-B8AA-43cd-A4EB-2737373FEEAD}"; ValueType: dword; ValueName: "SaferFlags"; ValueData: "00000000"; Flags: uninsdeletekeyifempty uninsdeletevalue; Components: confpatchtoolpol conftoolpol; Check: CheckSRPIsEnabled()
; Policy Execution Enabler EXE-RULE FOR "Gpg4Win_All_Files_x64"
Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{{27FF3776-F59C-4329-9A14-25E1C0487E49}"; ValueType: string; ValueName: "Description"; ValueData: "Gpg4Win_All_Files_x64"; Flags: uninsdeletekeyifempty uninsdeletevalue; Components: confpatchtoolpol conftoolpol; Check: CheckSRPIsEnabled()
Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{{27FF3776-F59C-4329-9A14-25E1C0487E49}"; ValueType: expandsz; ValueName: "ItemData"; ValueData: "{code:GetGpg4WinInstalled}\bin_64"; Flags: uninsdeletekeyifempty uninsdeletevalue; Components: confpatchtoolpol conftoolpol; Check: CheckSRPIsEnabled()
Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{{27FF3776-F59C-4329-9A14-25E1C0487E49}"; ValueType: dword; ValueName: "SaferFlags"; ValueData: "00000000"; Flags: uninsdeletekeyifempty uninsdeletevalue; Components: confpatchtoolpol conftoolpol; Check: CheckSRPIsEnabled()

; Policy Execution Enabler GpgTools -ExpandGNUPGHOME32-
Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{{AD1BA620-A9CE-46f0-9F42-BE0403AE7124}"; ValueType: string; ValueName: "Description"; ValueData: "GNUPGHOME Expander ( ExpandGNUPGHOME.exe ) ..."; Flags: uninsdeletekeyifempty uninsdeletevalue; Components: confpatchtoolpol conftoolpol; Check: CheckSRPIsEnabled()
Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{{AD1BA620-A9CE-46f0-9F42-BE0403AE7124}"; ValueType: string; ValueName: "ItemData"; ValueData: "{app}\ExpandGNUPGHOME\ExpandGNUPGHOME.exe"; Flags: uninsdeletekeyifempty uninsdeletevalue; Components: confpatchtoolpol conftoolpol; Check: CheckSRPIsEnabled()
Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{{AD1BA620-A9CE-46f0-9F42-BE0403AE7124}"; ValueType: dword; ValueName: "SaferFlags"; ValueData: "00000000"; Flags: uninsdeletekeyifempty uninsdeletevalue; Components: confpatchtoolpol conftoolpol; Check: CheckSRPIsEnabled()

; Policy Execution Enabler GpgTools -ExpandGNUPGHOME64-
; Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{{6333CE0C-BCF2-4dee-AAEB-E85CAFACA1AD}"; ValueType: string; ValueName: "Description"; ValueData: "GNUPGHOME Expander ( ExpandGNUPGHOME64.exe ) ..."; Flags: uninsdeletekeyifempty uninsdeletevalue; Components: confpatchtoolpol conftoolpol; Check: CheckSRPIsEnabled()
; Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{{6333CE0C-BCF2-4dee-AAEB-E85CAFACA1AD}"; ValueType: string; ValueName: "ItemData"; ValueData: "{app}\ExpandGNUPGHOME\ExpandGNUPGHOME64.exe"; Flags: uninsdeletekeyifempty uninsdeletevalue; Components: confpatchtoolpol conftoolpol; Check: CheckSRPIsEnabled()
; Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{{6333CE0C-BCF2-4dee-AAEB-E85CAFACA1AD}"; ValueType: dword; ValueName: "SaferFlags"; ValueData: "00000000"; Flags: uninsdeletekeyifempty uninsdeletevalue; Components: confpatchtoolpol conftoolpol; Check: CheckSRPIsEnabled()

; Policy Execution Enabler GpgTools -Gpg4Win_beenden-
Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{{5CA394E7-A792-42f4-8F07-5D2038789B01}"; ValueType: string; ValueName: "Description"; ValueData: "GpgTools Gpg4Win beenden ( Gpg4Win_beenden.exe ) ..."; Flags: uninsdeletekeyifempty uninsdeletevalue; Components: confpatchtoolpol conftoolpol; Check: CheckSRPIsEnabled()
Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{{5CA394E7-A792-42f4-8F07-5D2038789B01}"; ValueType: string; ValueName: "ItemData"; ValueData: "{app}\StartCon\Gpg4Win_beenden.exe"; Flags: uninsdeletekeyifempty uninsdeletevalue; Components: confpatchtoolpol conftoolpol; Check: CheckSRPIsEnabled()
Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{{5CA394E7-A792-42f4-8F07-5D2038789B01}"; ValueType: dword; ValueName: "SaferFlags"; ValueData: "00000000"; Flags: uninsdeletekeyifempty uninsdeletevalue; Components: confpatchtoolpol conftoolpol; Check: CheckSRPIsEnabled()

; Policy Execution Enabler GpgTools -Migrate_GnuPG_Keybase-
Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{{38AFABE5-D73F-4A60-9E25-35C40FC578BE}"; ValueType: string; ValueName: "Description"; ValueData: "Migrate_GnuPG_Keybase ..."; Flags: uninsdeletekeyifempty uninsdeletevalue; Components: confpatchtoolpol conftoolpol; Check: CheckSRPIsEnabled()
Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{{38AFABE5-D73F-4A60-9E25-35C40FC578BE}"; ValueType: string; ValueName: "ItemData"; ValueData: "{app}\MigrateGnuPGKeybase\MigrateGnuPGKeybase.exe"; Flags: uninsdeletekeyifempty uninsdeletevalue; Components: confpatchtoolpol conftoolpol; Check: CheckSRPIsEnabled()
Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{{38AFABE5-D73F-4A60-9E25-35C40FC578BE}"; ValueType: dword; ValueName: "SaferFlags"; ValueData: "00000000"; Flags: uninsdeletekeyifempty uninsdeletevalue; Components: confpatchtoolpol conftoolpol; Check: CheckSRPIsEnabled()

; Policy Execution Enabler GpgTools -Gpg4WinPreConfig-
Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{{567CE485-7A23-40c8-AF72-A76E06BBB0A6}"; ValueType: string; ValueName: "Description"; ValueData: "Gpg4WinPreConfig ..."; Flags: uninsdeletekeyifempty uninsdeletevalue; Components: confpatchtoolpol conftoolpol; Check: CheckSRPIsEnabled()
Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{{567CE485-7A23-40c8-AF72-A76E06BBB0A6}"; ValueType: expandsz; ValueName: "ItemData"; ValueData: "{app}\StartCon\Gpg4WinPreConfig.exe"; Flags: uninsdeletekeyifempty uninsdeletevalue; Components: confpatchtoolpol conftoolpol; Check: CheckSRPIsEnabled()
Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\Safer\CodeIdentifiers\262144\Paths\{{567CE485-7A23-40c8-AF72-A76E06BBB0A6}"; ValueType: dword; ValueName: "SaferFlags"; ValueData: "00000000"; Flags: uninsdeletekeyifempty uninsdeletevalue; Components: confpatchtoolpol conftoolpol; Check: CheckSRPIsEnabled()

; Policy Execution Enabler APPLOCKER RULES
; https://docs.microsoft.com/en-us/windows/security/threat-protection/windows-defender-application-control/applocker/understanding-the-path-rule-condition-in-applocker
; =====================================================================
; AppLocker uses path variables for well-known directories
; in Windows. Path variables are not environment variables.
; The AppLocker engine can only interpret AppLocker path variables.
; The following table details these path variables.
; =====================================================================
; Windows directory/drive   AppLocker variable  Windows variable
; =====================================================================
; Windows                   %WINDIR%            %SystemRoot%
; System32                  %SYSTEM32%          %SystemRoot%\System32 (%SystemDirectory%)
; Windows install-dir       %OSDRIVE%           %SystemDrive%
; Program Files             %PROGRAMFILES%      %ProgramFiles% or
; Program Files             %PROGRAMFILES%      %ProgramFiles(x86)%
; Removable media (CD/DVD)  %REMOVABLE%
; Removable storage         %HOT%
;
; The key ...
; HKLM\SOFTWARE\Policies\Microsoft\Windows\SrpV2
; ... is mirrored to the key:
; HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\SrpV2
;
; The following GUIDs were generated by GuidgenConsole
; Guidgen v2.0.0.4 for .NET 4.6.1:
;
; https://github.com/michaelmcdaniel/GuidgenConsole
;
;
; ------------ APPLOCKER RULES ----------- BEGIN
; INFO: SHITTY APPLOCKER DOES NOT PROVIDE VARS FOR
; USER-PATH AND PROFILE-PATH IDENTIFICATION. SO WE
; HAVE TO DO USE AN ANNOYING APPLOCKER PATH-WILDCARD
; OVER ALL USERPROFILES IN SCRIPT SECTION.
; THIS HAS SOME SECURITY ISSUES ...
; ----------------------------------------
; APPLOCKER ENFORCEMENTMODE FOR EXE-RULE
; We do a "Check: EnforcementModeEXEActive()"
; here. This means, that values are only written, when
; "EnforcementMode" does exist in the Registry with
; DWORD-Value 0x00000001 and check-results on this
; point aren't inverted (check for none-existence ;-))
; ----------------------------------------
; if disabled here, then due to usage of administrative system-defaults
; Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\SrpV2\Exe"; ValueType: dword; ValueName: "EnforcementMode"; ValueData: "$00000000"; Flags: createvalueifdoesntexist uninsdeletekeyifempty uninsdeletevalue; Components: gnupgpol gpgsxpol; Check: EnforcementModeEXEActive()
; ----------------------------------------
; APPLOCKER EXE-RULE FOR "GnuPG_All_Files"
Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\SrpV2\Exe\C3054BEE-5B74-42ac-89A9-F17165332544"; ValueType: string; ValueName: "Value"; ValueData: "<FilePathRule Id=""C3054BEE-5B74-42ac-89A9-F17165332544"" Name=""GnuPG_All_Files"" Description=""(GnuPG) Allows execution of all files in folder &quot;GnuPG&quot; in &quot;Program Files&quot;"" UserOrGroupSid=""S-1-1-0"" Action=""Allow""><Conditions><FilePathCondition Path=""{code:GetGnuPG2Installed}\bin\*""/></Conditions></FilePathRule>"; Flags: uninsdeletekeyifempty uninsdeletevalue; Components: confpatchtoolpol conftoolpol; Check: EnforcementModeEXEActive()
; APPLOCKER EXE-RULE FOR "Gpg4Win_All_Files"
Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\SrpV2\Exe\D7D0251F-C4E4-48d7-AD80-7AF00BE631B3"; ValueType: string; ValueName: "Value"; ValueData: "<FilePathRule Id=""D7D0251F-C4E4-48d7-AD80-7AF00BE631B3"" Name=""Gpg4Win_All_Files"" Description=""(Gpg4Win) Allows execution of all files in folder &quot;Gpg4Win_bin&quot; in &quot;Program Files&quot;"" UserOrGroupSid=""S-1-1-0"" Action=""Allow""><Conditions><FilePathCondition Path=""{code:GetGpg4WinInstalled}\bin\*""/></Conditions></FilePathRule>"; Flags: uninsdeletekeyifempty uninsdeletevalue; Components: confpatchtoolpol conftoolpol; Check: EnforcementModeEXEActive()
; APPLOCKER EXE-RULE FOR "Gpg4Win_All_Files_x64"
Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\SrpV2\Exe\19880016-CBCF-4745-AAAC-919DA96D14AE"; ValueType: string; ValueName: "Value"; ValueData: "<FilePathRule Id=""19880016-CBCF-4745-AAAC-919DA96D14AE"" Name=""Gpg4Win_All_Files_x64"" Description=""(Gpg4Win) Allows execution of all files in folder &quot;Gpg4Win_bin_64&quot; in &quot;Program Files&quot;"" UserOrGroupSid=""S-1-1-0"" Action=""Allow""><Conditions><FilePathCondition Path=""{code:GetGpg4WinInstalled}\bin_64\*""/></Conditions></FilePathRule>"; Flags: uninsdeletekeyifempty uninsdeletevalue; Components: confpatchtoolpol conftoolpol; Check: EnforcementModeEXEActive()
; APPLOCKER EXE-RULE FOR "GpgTools"
Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\SrpV2\Exe\6C643BE4-2CCA-4e60-BC6B-48C43C044224"; ValueType: string; ValueName: "Value"; ValueData: "<FilePathRule Id=""6C643BE4-2CCA-4e60-BC6B-48C43C044224"" Name=""GpgTools_ExpandGNUPGHOME"" Description=""(GpgTools) Allows execution of &quot;ExpandGNUPGHOME&quot;"" UserOrGroupSid=""S-1-1-0"" Action=""Allow""><Conditions><FilePathCondition Path=""{app}\ExpandGNUPGHOME\ExpandGNUPGHOME.exe""/></Conditions></FilePathRule>"; Flags: uninsdeletekeyifempty uninsdeletevalue; Components: confpatchtoolpol conftoolpol; Check: EnforcementModeEXEActive()
; Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\SrpV2\Exe\0EDFEB20-0262-430d-98DF-41C459967D04"; ValueType: string; ValueName: "Value"; ValueData: "<FilePathRule Id=""0EDFEB20-0262-430d-98DF-41C459967D04"" Name=""GpgTools_ExpandGNUPGHOME_x64"" Description=""(GpgTools) Allows execution of &quot;ExpandGNUPGHOME_x64&quot;"" UserOrGroupSid=""S-1-1-0"" Action=""Allow""><Conditions><FilePathCondition Path=""{app}\ExpandGNUPGHOME\ExpandGNUPGHOME64.exe""/></Conditions></FilePathRule>"; Flags: uninsdeletekeyifempty uninsdeletevalue; Components: confpatchtoolpol conftoolpol; Check: EnforcementModeEXEActive()
Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\SrpV2\Exe\DC193BD2-86CC-4b42-BE68-4CA0461679C7"; ValueType: string; ValueName: "Value"; ValueData: "<FilePathRule Id=""DC193BD2-86CC-4b42-BE68-4CA0461679C7"" Name=""GpgTools_Gpg4Win_beenden"" Description=""(GpgTools) Allows execution of &quot;Gpg4Win_beenden&quot;"" UserOrGroupSid=""S-1-1-0"" Action=""Allow""><Conditions><FilePathCondition Path=""{app}\StartCon\Gpg4Win_beenden.exe""/></Conditions></FilePathRule>"; Flags: uninsdeletekeyifempty uninsdeletevalue; Components: confpatchtoolpol conftoolpol; Check: EnforcementModeEXEActive()
Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\SrpV2\Exe\763A3B75-31EF-4145-84A4-56BE08A4CE1F"; ValueType: string; ValueName: "Value"; ValueData: "<FilePathRule Id=""763A3B75-31EF-4145-84A4-56BE08A4CE1F"" Name=""GpgTools_Migrate_GnuPG_Keybase"" Description=""(GpgTools) Allows execution of &quot;MigrateGnuPGKeybase&quot;"" UserOrGroupSid=""S-1-1-0"" Action=""Allow""><Conditions><FilePathCondition Path=""{app}\MigrateGnuPGKeybase\MigrateGnuPGKeybase.exe""/></Conditions></FilePathRule>"; Flags: uninsdeletekeyifempty uninsdeletevalue; Components: confpatchtoolpol conftoolpol; Check: EnforcementModeEXEActive()
Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\SrpV2\Exe\9356E237-DA47-478e-B5AD-86057EC79DD7"; ValueType: string; ValueName: "Value"; ValueData: "<FilePathRule Id=""9356E237-DA47-478e-B5AD-86057EC79DD7"" Name=""GpgTools_Gpg4WinPreConfig"" Description=""(GpgTools) Allows execution of &quot;Gpg4WinPreConfig&quot;"" UserOrGroupSid=""S-1-1-0"" Action=""Allow""><Conditions><FilePathCondition Path=""{app}\StartCon\Gpg4WinPreConfig.exe""/></Conditions></FilePathRule>"; Flags: uninsdeletekeyifempty uninsdeletevalue; Components: confpatchtoolpol conftoolpol; Check: EnforcementModeEXEActive()

; ----------------------------------------
; APPLOCKER ENFORCEMENTMODE FOR SCRIPT-RULE
; We do a "Check: EnforcementModeScriptActive()"
; here. This means, that values are only written, when
; "EnforcementMode" does exist in the Registry with
; DWORD-Value 0x00000001 and check-results on this
; point aren't inverted (check for none-existence ;-))
; ----------------------------------------
; if disabled here, then due to usage of administrative system-defaults
;Root: "HKLM"; Subkey: "Software\Policies\Microsoft\Windows\SrpV2\Script"; ValueType: dword; ValueName: "EnforcementMode"; ValueData: "$00000000"; Flags: createvalueifdoesntexist uninsdeletekeyifempty uninsdeletevalue; Components: confpatchtoolpol conftoolpol; Check: EnforcementModeScriptActive()
; ------------ APPLOCKER RULES ----------- END

; ### X86/X64 arch selection ### >>> x64
; ### X86/X64 arch selection ### Place all x64 architecture registries here
; ################################################################################
; # Imported Registry File: "Install_GnuPG_Explorer_Extension_Dateien.reg"       #
; ################################################################################

; ### X86/X64 arch selection ### >>> x64
; ### X86/X64 arch selection ### Place all x64 architecture registries here
; ################################################################################
; # Imported Registry File: "Install_GnuPG_Explorer_Extension_Verzeichnisse.reg" #
; ################################################################################

[Icons]
; Icons GnuPG
Name: {commonprograms}\{#MyAppName}\Info GnuPG Yubikey-Support; Filename: {app}\Doc\GnuPG_Yubikey-Support.txt; WorkingDir: {app}\Doc; IconFilename: {app}\Icon3.ico; Comment: Info GnuPG Yubikey-Support; IconIndex: 0; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Name: {commonprograms}\{#MyAppName}\Info Änderungshinweise; Filename: {app}\Doc\Hinweise.txt; WorkingDir: {app}\Doc; IconFilename: {app}\Icon3.ico; Comment: Info Änderungshinweise; IconIndex: 0; Components: confpatchtoolpol conftoolpol confpatchtool conftool
; Already in Gpg4Win-Package "{code:GetGpg4WinInstalled}\share\gpg4win\gpg4win-compendium-de.pdf"
; See above in [Files] ...
; Name: {commonprograms}\{#MyAppName}\Handbuch Gpg4Win; Filename: {app}\Doc\gpg4win-compendium-de.pdf; WorkingDir: {app}\Doc; IconFilename: {app}\Icon1.ico; Comment: Handbuch Gpg4Win-Compendium; IconIndex: 0; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Name: {commonprograms}\{#MyAppName}\Handbuch Gpg4Win; Filename: {code:GetGpg4WinInstalled}\share\gpg4win\gpg4win-compendium-de.pdf; WorkingDir: {code:GetGpg4WinInstalled}\share\gpg4win; IconFilename: {app}\Icon1.ico; Comment: Handbuch Gpg4Win-Compendium; IconIndex: 0; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Name: {commonprograms}\{#MyAppName}\Handbuch Kleopatra; Filename: {app}\Doc\kleopatra_de.pdf; WorkingDir: {app}\Doc; IconFilename: {app}\Icon2.ico; Comment: Handbuch Kleopatra; IconIndex: 0; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Name: {commonprograms}\{#MyAppName}\QuickGuide Gpg4Win; Filename: {app}\Doc\Quickguide_GnuPG.pdf; WorkingDir: {app}\Doc; IconFilename: {app}\Icon0.ico; Comment: QuickGuide Gpg4Win; IconIndex: 0; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Name: {commonprograms}\{#MyAppName}\Handbuch GnuPG; Filename: {app}\Doc\gnupg.pdf; WorkingDir: {app}\Doc; IconFilename: {app}\Icon0.ico; Comment: Handbuch GnuPG; IconIndex: 0; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Name: {commonprograms}\{#MyAppName}\Gpg4Win beenden; Filename: {app}\StartCon\Gpg4Win_beenden.exe; WorkingDir: {app}\StartCon; IconFilename: {app}\StartCon\Gpg4Win_beenden.exe; Comment: Alle Programme und Hintergrundprogramme von Gpg4Win beenden; IconIndex: 0; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Name: {commondesktop}\Handbuch Gpg4Win; Filename: {code:GetGpg4WinInstalled}\share\gpg4win\gpg4win-compendium-de.pdf; WorkingDir: {code:GetGpg4WinInstalled}\share\gpg4win; IconFilename: {app}\Icon1.ico; Comment: Handbuch Gpg4Win-Compendium; IconIndex: 0; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Name: {commondesktop}\Handbuch Kleopatra; Filename: {app}\Doc\kleopatra_de.pdf; WorkingDir: {app}\Doc; IconFilename: {app}\Icon2.ico; Comment: Handbuch Kleopatra; IconIndex: 0; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Name: {commondesktop}\QuickGuide Gpg4Win; Filename: {app}\Doc\Quickguide_GnuPG.pdf; WorkingDir: {app}\Doc; IconFilename: {app}\Icon0.ico; Comment: QuickGuide Gpg4Win; IconIndex: 0; Components: confpatchtoolpol conftoolpol confpatchtool conftool
Name: {commondesktop}\Gpg4Win beenden; Filename: {app}\StartCon\Gpg4Win_beenden.exe; WorkingDir: {app}\StartCon; IconFilename: {app}\StartCon\Gpg4Win_beenden.exe; Comment: Alle Programme und Hintergrundprogramme von Gpg4Win beenden; IconIndex: 0; Components: confpatchtoolpol conftoolpol confpatchtool conftool

; #################################################################################
; # Opening Firewall inbound / outbound only used, when this is really necessary. #
; #################################################################################
[Run]
; # Programs are executed in the order they appear in the script.
; # Run unattended GnuPG Update-Installer
; Filename: "{tmp}\gnupg-w32-update.exe"; Parameters: "/S"; Flags: shellexec waituntilterminated runhidden; StatusMsg: {cm:installgnupgupdate}
; # Remove the Windows firewall rules outbound
Filename: "netsh.exe"; Parameters: "advfirewall firewall delete rule name=""GnuPG_gpg_Allow_Out"""; Flags: shellexec waituntilterminated runhidden; StatusMsg: {cm:deletefirewallrules}
Filename: "netsh.exe"; Parameters: "advfirewall firewall delete rule name=""GnuPG_gpgsm_Allow_Out"""; Flags: shellexec waituntilterminated runhidden; StatusMsg: {cm:deletefirewallrules}
Filename: "netsh.exe"; Parameters: "advfirewall firewall delete rule name=""GnuPG_gpg-agent_Allow_Out"""; Flags: shellexec waituntilterminated runhidden; StatusMsg: {cm:deletefirewallrules}
Filename: "netsh.exe"; Parameters: "advfirewall firewall delete rule name=""GnuPG_dirmngr_Allow_Out"""; Flags: shellexec waituntilterminated runhidden; StatusMsg: {cm:deletefirewallrules}
Filename: "netsh.exe"; Parameters: "advfirewall firewall delete rule name=""GnuPG_dirmngr_ldap_Allow_Out"""; Flags: shellexec waituntilterminated runhidden; StatusMsg: {cm:deletefirewallrules}
Filename: "netsh.exe"; Parameters: "advfirewall firewall delete rule name=""GnuPG_kleopatra_Allow_Out"""; Flags: shellexec waituntilterminated runhidden; StatusMsg: {cm:deletefirewallrules}
; # Remove the Windows firewall rules inbound
Filename: "netsh.exe"; Parameters: "advfirewall firewall delete rule name=""GnuPG_dirmngr_Allow_In"""; Flags: shellexec waituntilterminated runhidden; StatusMsg: {cm:deletefirewallrules}
Filename: "netsh.exe"; Parameters: "advfirewall firewall delete rule name=""GnuPG_agent_Allow_In"""; Flags: shellexec waituntilterminated runhidden; StatusMsg: {cm:deletefirewallrules}
Filename: "netsh.exe"; Parameters: "advfirewall firewall delete rule name=""GnuPG_kleopatra_Allow_In"""; Flags: shellexec waituntilterminated runhidden; StatusMsg: {cm:deletefirewallrules}
; # Create the Windows firewall rules outbound
Filename: "netsh.exe"; Parameters: "advfirewall firewall add rule name=""GnuPG_gpg_Allow_Out"" program=""{code:GetGnuPG2Installed}\bin\gpg.exe"" dir=out action=allow enable=yes profile=any"; Flags: shellexec waituntilterminated runhidden; StatusMsg: {cm:createfirewallrules}
Filename: "netsh.exe"; Parameters: "advfirewall firewall add rule name=""GnuPG_gpgsm_Allow_Out"" program=""{code:GetGnuPG2Installed}\bin\gpgsm.exe"" dir=out action=allow enable=yes profile=any"; Flags: shellexec waituntilterminated runhidden; StatusMsg: {cm:createfirewallrules}
Filename: "netsh.exe"; Parameters: "advfirewall firewall add rule name=""GnuPG_gpg-agent_Allow_Out"" program=""{code:GetGnuPG2Installed}\bin\gpg-agent.exe"" dir=out action=allow enable=yes profile=any"; Flags: shellexec waituntilterminated runhidden; StatusMsg: {cm:createfirewallrules}
Filename: "netsh.exe"; Parameters: "advfirewall firewall add rule name=""GnuPG_dirmngr_Allow_Out"" program=""{code:GetGnuPG2Installed}\bin\dirmngr.exe"" dir=out action=allow enable=yes profile=any"; Flags: shellexec waituntilterminated runhidden; StatusMsg: {cm:createfirewallrules}
Filename: "netsh.exe"; Parameters: "advfirewall firewall add rule name=""GnuPG_dirmngr_ldap_Allow_Out"" program=""{code:GetGnuPG2Installed}\bin\dirmngr_ldap.exe"" dir=out action=allow enable=yes profile=any"; Flags: shellexec waituntilterminated runhidden; StatusMsg: {cm:createfirewallrules}
Filename: "netsh.exe"; Parameters: "advfirewall firewall add rule name=""GnuPG_kleopatra_Allow_Out"" program=""{code:GetGpg4WinInstalled}\bin\kleopatra.exe"" dir=out action=allow enable=yes profile=any"; Flags: shellexec waituntilterminated runhidden; StatusMsg: {cm:createfirewallrules}
; # Create the Windows firewall rules inbound
Filename: "netsh.exe"; Parameters: "advfirewall firewall add rule name=""GnuPG_dirmngr_Allow_In"" program=""{code:GetGnuPG2Installed}\bin\dirmngr.exe"" dir=in action=allow enable=yes remoteip=127.0.0.1 profile=any"; Flags: shellexec waituntilterminated runhidden; StatusMsg: {cm:createfirewallrules}
Filename: "netsh.exe"; Parameters: "advfirewall firewall add rule name=""GnuPG_agent_Allow_In"" program=""{code:GetGnuPG2Installed}\bin\gpg-agent.exe"" dir=in action=allow enable=yes remoteip=127.0.0.1 profile=any"; Flags: shellexec waituntilterminated runhidden; StatusMsg: {cm:createfirewallrules}
Filename: "netsh.exe"; Parameters: "advfirewall firewall add rule name=""GnuPG_kleopatra_Allow_In"" program=""{code:GetGpg4WinInstalled}\bin\kleopatra.exe"" dir=in action=allow enable=yes remoteip=127.0.0.1 profile=any"; Flags: shellexec waituntilterminated runhidden; StatusMsg: {cm:createfirewallrules}

[UninstallRun]
; # Remove the Windows firewall rules outbound
Filename: "netsh.exe"; RunOnceId: "GnuPG_gpg_Allow_Out"; Parameters: "advfirewall firewall delete rule name=""GnuPG_gpg_Allow_Out"""; Flags: shellexec waituntilterminated runhidden
Filename: "netsh.exe"; RunOnceId: "GnuPG_gpgsm_Allow_Out"; Parameters: "advfirewall firewall delete rule name=""GnuPG_gpgsm_Allow_Out"""; Flags: shellexec waituntilterminated runhidden
Filename: "netsh.exe"; RunOnceId: "GnuPG_gpg-agent_Allow_Out"; Parameters: "advfirewall firewall delete rule name=""GnuPG_gpg-agent_Allow_Out"""; Flags: shellexec waituntilterminated runhidden
Filename: "netsh.exe"; RunOnceId: "GnuPG_dirmngr_Allow_Out"; Parameters: "advfirewall firewall delete rule name=""GnuPG_dirmngr_Allow_Out"""; Flags: shellexec waituntilterminated runhidden
Filename: "netsh.exe"; RunOnceId: "GnuPG_dirmngr_ldap_Allow_Out"; Parameters: "advfirewall firewall delete rule name=""GnuPG_dirmngr_ldap_Allow_Out"""; Flags: shellexec waituntilterminated runhidden
Filename: "netsh.exe"; RunOnceId: "GnuPG_kleopatra_Allow_Out"; Parameters: "advfirewall firewall delete rule name=""GnuPG_kleopatra_Allow_Out"""; Flags: shellexec waituntilterminated runhidden
; # Remove the Windows firewall rules inbound
Filename: "netsh.exe"; RunOnceId: "GnuPG_dirmngr_Allow_In"; Parameters: "advfirewall firewall delete rule name=""GnuPG_dirmngr_Allow_In"""; Flags: shellexec waituntilterminated runhidden
Filename: "netsh.exe"; RunOnceId: "GnuPG_agent_Allow_In"; Parameters: "advfirewall firewall delete rule name=""GnuPG_agent_Allow_In"""; Flags: shellexec waituntilterminated runhidden
Filename: "netsh.exe"; RunOnceId: "GnuPG_kleopatra_Allow_In"; Parameters: "advfirewall firewall delete rule name=""GnuPG_kleopatra_Allow_In"""; Flags: shellexec waituntilterminated runhidden

[CustomMessages]
english.alreadyinstalled=This Installer-Package is already installed%non this System !%n%nPlease uninstall this package before you invoke%na new installation.
german.alreadyinstalled=Dieses Installer-Paket ist schon auf Ihrem%nSystem installiert !%n%nBitte deinstallieren Sie dieses Paket vor%neiner Neu-Installation.
english.alreadyrunning=This Installer is already running%non this System !%n%nPlease abort this running installation%nbefore you invoke a new installation.
german.alreadyrunning=Dieser Installer läuft schon%nauf diesem System !%n%nBitte beenden Sie die laufende Installation%nvor einer weiteren Installation.
english.compnotinstalled=A necessary component is not installed%non this System !%n%nPlease install this component before you invoke%nthis installation.%n%nFor details look into the installer-protocol.%n(Please create with option: /LOG).
german.compnotinstalled=Eine notwendige Komponente ist nicht installiert%nauf diesem System !%n%nBitte installieren Sie diese Komponente vor%ndieser Installation.%n%nDetails finden Sie im Installationsprotokoll.%n(Bitte anlegen mit Option: /LOG).
english.wronggpg4winversion=Gpg4Win version mismatch - the matching version is not installed%non this System !%n%nPlease install the correct version before you invoke%nthis installation.%n%nFor details look into the installer-protocol.%n(Please create with option: /LOG).
german.wronggpg4winversion=Gpg4Win Versionsfehler - die korrekte Version ist nicht installiert%nauf diesem System !%n%nBitte installieren Sie die korrekte Version vor%ndieser Installation.%n%nDetails finden Sie im Installationsprotokoll.%n(Bitte anlegen mit Option: /LOG).
english.basserror=Error initialising BASS-Soundlib !%n%nPlease check Sound-Subsystem of%nyour Computer ...
german.basserror=Fehler beim initialisiseren der BASS-Soundbibliothek !%n%nBitte prüfen Sie die Soundkartenkonfiguration%nihres Computers ...
english.sendtokeyerror=The "SendTo"-Value under the Registry-Key:%n%nHKCU\Software\Microsoft\Windows\CurrentVersion%n\Explorer\User Shell Folders WAS NOT FOUND !%n%nSo i don't know where to store the Application-Links.%nPlease check this issue and restart the installer ...%n
german.sendtokeyerror=Der "SendTo"-Wert unter dem Registry-Schlüssel:%n%nHKCU\Software\Microsoft\Windows\CurrentVersion%n\Explorer\User Shell Folders%n%nWURDE NICHT GEFUNDEN !%n%nIch weiss nun nicht, wo ich die Verknüpfungen%nablegen soll.%n%nBitte prüfen Sie diesen Sachverhalt und starten Sie%nden Installer neu ...%n
english.createfirewallrules=Creating firewall-rules ...
german.createfirewallrules=Erzeuge Firewall-Regeln ...
english.deletefirewallrules=Deleting old firewall-rules ...
german.deletefirewallrules=Lösche alte Firewall-Regeln ...
english.installgnupgupdate=Installing GnuPG-Update ...
german.installgnupgupdate=Installiere GnuPG-Update ...
english.installgnupgerror=ERROR - GnuPG-Update - CHECK INSTALLER-LOGFILE ...
german.installgnupgerror=FEHLER - GnuPG-Update - INSTALLER-LOGFILE PRÜFEN ...
english.installcont=Continuing installation ...
german.installcont=Installation wird fortgesetzt ...

; Tasks for process-control before installation of files,
; that may be in use during install-process.
; See functions: "RunTask" and "KillTask" below in [Code]-section
Tasks=outlook.exe%nkleopatra.exe%ngpa.exe%ngpgme-w32spawn.exe%ngpg-agent.exe%ngpg-connect-agent.exe%ngpg-wks-client.exe%ngpg.exe%ndirmngr.exe%ngpgsm.exe%nscdaemon.exe%npinentry-w32.exe%npinentry.exe%npinentry-basic.exe

[ThirdParty]
UseRelativePaths=True

[Code]
//
// Script-Pascal resources documented here:
// http://wiki.freepascal.org/Pascal_Script
// Coding of hex-code in special-strings:
// http://www.blooberry.com/indexdot/html/topics/urlencoding.htm
// http://www.remobjects.com/ps.aspx
// https://github.com/remobjects/pascalscript
// http://lawrencebarsanti.wordpress.com/2009/11/28/introduction-to-pascal-script/
// http://lbarsanti.users.sourceforge.net/pascal-script-example.zip
//
// Code modified in order to use new 2.4 api of BASS-API
// (http://www.un4seen.com).
// Portions of code derived from the BASS 2.4 Delphi unit (bass.pas)
// Copyright (c) 1999-2013 Un4seen Developments Ltd.
//

var
  // Is update or not
  MyAppUPDATE : Boolean;

  ApplicationAlreadyInstalled : Boolean;

  // Var for content of #defined var: #MyAppName (ApplicationName)
  // See below in installer-code
  ResultAPPN : String;
  // See below in installer-code
  // Var for content of #defined var: #MyAppID (ApplicationID)
  ResultAPPID : String;

  // Var for content of #defined var: "#define Gpg4WinVersion"
  // For checking the correct version of installed Gpg4Win (kleopatra.exe).
  ResultGpg4WinV : String;
  ResultGpg4WinVB : String;

  // Var for content of result from function: GetGpg4WinVersion()
  // For checking the correct version of installed Gpg4Win (kleopatra.exe).
  ResultGetGpg4WinV : String;


  //////////////////////////////////////////////////////////////////////////////
  // BASS SOUNDLIB
  //
  // Date: 2009
  // ================
  // ACTUALLY Ian Luck CHANGED SOME CALLING CONVENTIONS FROM V2.3 to
  // V2.4. SEE CHANGELOG IN HELPFILE AND LOOK HERE (2.3 DIFFERENCE TO 2.4):
  // http://www.un4seen.com/forum/?topic=9556.0
  // SO WE HAVE TO USE BASS 2.3 HERE, BECAUSE INNOSETUP DOESNOT SUPPORT TYPE
  // INT64 (QWORD) WHICH IS NECESSARY TO CALL BASS 2.4 !!
  //
  // Date: 11/2013
  // ================
  // Now BASS 2.4 works wih new InnoSetup version
  //
  // Date: 11/2016
  // BASS updated to version v2.4.12.1
  //
  // Date: 07/2018
  // BASS updated to version v2.4.13.8
  //
  // Date: 11/2020
  // BASS updated to version v2.4.15.0
  //
  // DOWNLOAD LATEST STUFF FROM HERE:
  // http://www.un4seen.com/

  // For initializing BASSLIB
  BASS_Init_Result : Boolean;
  BASS_Start_Result : Boolean;
  BASS_ChannelPlay_Result : Boolean;
  BASS_Version_Result : DWORD;

  SndHandle: HWND;
  SndName: string;
  //BassName: string;
  //PlayButton : TButton;
  //PauseButton : TButton;
  //StopButton : TButton;
  //Panel1: TPanel;

  // For GnuPG-Updater
  GpgUpdateName: string;

const
  SrpV2ExeKey = 'SOFTWARE\Policies\Microsoft\Windows\SrpV2\Exe';
  SrpV2ScriptKey = 'SOFTWARE\Policies\Microsoft\Windows\SrpV2\Script';
  SrpV1CodeIdentifiersKey = 'SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers';

  //BASS_ACTIVE_STOPPED = 0;
  //BASS_ACTIVE_PLAYING = 1;
  //BASS_ACTIVE_STALLED = 2;
  //BASS_ACTIVE_PAUSED = 3;
  //BASS_SAMPLE_LOOP = 4;

  // Bass version changelog in history
  //BASSVERSION = $02030003;    // (decimal 33751043) API version 2.3
  //BASSVERSION = $02040305;    // (decimal 33817349) API version 2.4      (from 14.07.2009)
  //BASSVERSION = $02040A00;    // (decimal 33819136) API version 2.4.10   (from 16.02.2013)
  //BASSVERSION = $02040C01;    // (decimal 33819649) API version 2.4.12.1 (from 18.04.2016)
  //BASSVERSION = $02040D08;    // (decimal 33819912) API version 2.4.13.8 (from 06.02.2018)
  BASSVERSION = $02040F00;      // (decimal 33820416) API version 2.4.15.0 (from 17.12.2019)


  //BASSVERSIONTEXT = '2.3';    // API version 2.3
  BASSVERSIONTEXT = '2.4';      // API version 2.4

  // Use these to test for error from functions that return a DWORD or QWORD
  //DW_ERROR = LongWord(-1); // -1 (DWORD)
  //QW_ERROR = Int64(-1);    // -1 (QWORD)

  // Error codes returned by BASS_ErrorGetCode()
  BASS_OK                 = 0;    // all is OK
  BASS_ERROR_MEM          = 1;    // memory error
  BASS_ERROR_FILEOPEN     = 2;    // can't open the file
  BASS_ERROR_DRIVER       = 3;    // can't find a free sound driver
  BASS_ERROR_BUFLOST      = 4;    // the sample buffer was lost
  BASS_ERROR_HANDLE       = 5;    // invalid handle
  BASS_ERROR_FORMAT       = 6;    // unsupported sample format
  BASS_ERROR_POSITION     = 7;    // invalid position
  BASS_ERROR_INIT         = 8;    // BASS_Init has not been successfully called
  BASS_ERROR_START        = 9;    // BASS_Start has not been successfully called
  BASS_ERROR_ALREADY      = 14;   // already initialized/paused/whatever
  BASS_ERROR_NOCHAN       = 18;   // can't get a free channel
  BASS_ERROR_ILLTYPE      = 19;   // an illegal type was specified
  BASS_ERROR_ILLPARAM     = 20;   // an illegal parameter was specified
  BASS_ERROR_NO3D         = 21;   // no 3D support
  BASS_ERROR_NOEAX        = 22;   // no EAX support
  BASS_ERROR_DEVICE       = 23;   // illegal device number
  BASS_ERROR_NOPLAY       = 24;   // not playing
  BASS_ERROR_FREQ         = 25;   // illegal sample rate
  BASS_ERROR_NOTFILE      = 27;   // the stream is not a file stream
  BASS_ERROR_NOHW         = 29;   // no hardware voices available
  BASS_ERROR_EMPTY        = 31;   // the MOD music has no sequence data
  BASS_ERROR_NONET        = 32;   // no internet connection could be opened
  BASS_ERROR_CREATE       = 33;   // couldn't create the file
  BASS_ERROR_NOFX         = 34;   // effects are not enabled
  BASS_ERROR_NOTAVAIL     = 37;   // requested data is not available
  BASS_ERROR_DECODE       = 38;   // the channel is a "decoding channel"
  BASS_ERROR_DX           = 39;   // a sufficient DirectX version is not installed
  BASS_ERROR_TIMEOUT      = 40;   // connection timedout
  BASS_ERROR_FILEFORM     = 41;   // unsupported file format
  BASS_ERROR_SPEAKER      = 42;   // unavailable speaker
  BASS_ERROR_VERSION      = 43;   // invalid BASS version (used by add-ons)
  BASS_ERROR_CODEC        = 44;   // codec is not available/supported
  BASS_ERROR_ENDED        = 45;   // the channel/file has ended
  BASS_ERROR_BUSY         = 46;   // the device is busy
  BASS_ERROR_UNSTREAMABLE = 47;   // unstreamable file
  BASS_ERROR_UNKNOWN      = -1;   // some other mystery problem

  // BASS_SetConfig options
  BASS_CONFIG_BUFFER             = 0;
  BASS_CONFIG_UPDATEPERIOD       = 1;
  BASS_CONFIG_GVOL_SAMPLE        = 4;
  BASS_CONFIG_GVOL_STREAM        = 5;
  BASS_CONFIG_GVOL_MUSIC         = 6;
  BASS_CONFIG_CURVE_VOL          = 7;
  BASS_CONFIG_CURVE_PAN          = 8;
  BASS_CONFIG_FLOATDSP           = 9;
  BASS_CONFIG_3DALGORITHM        = 10;
  BASS_CONFIG_NET_TIMEOUT        = 11;
  BASS_CONFIG_NET_BUFFER         = 12;
  BASS_CONFIG_PAUSE_NOPLAY       = 13;
  BASS_CONFIG_NET_PREBUF         = 15;
  BASS_CONFIG_NET_PASSIVE        = 18;
  BASS_CONFIG_REC_BUFFER         = 19;
  BASS_CONFIG_NET_PLAYLIST       = 21;
  BASS_CONFIG_MUSIC_VIRTUAL      = 22;
  BASS_CONFIG_VERIFY             = 23;
  BASS_CONFIG_UPDATETHREADS      = 24;
  BASS_CONFIG_DEV_BUFFER         = 27;
  BASS_CONFIG_VISTA_TRUEPOS      = 30;
  BASS_CONFIG_IOS_MIXAUDIO       = 34;
  BASS_CONFIG_DEV_DEFAULT        = 36;
  BASS_CONFIG_NET_READTIMEOUT    = 37;
  BASS_CONFIG_VISTA_SPEAKERS     = 38;
  BASS_CONFIG_IOS_SPEAKER        = 39;
  BASS_CONFIG_HANDLES            = 41;
  BASS_CONFIG_UNICODE            = 42;
  BASS_CONFIG_SRC                = 43;
  BASS_CONFIG_SRC_SAMPLE         = 44;
  BASS_CONFIG_ASYNCFILE_BUFFER   = 45;
  BASS_CONFIG_OGG_PRESCAN        = 47;
  BASS_CONFIG_MF_VIDEO           = 48;
  BASS_CONFIG_AIRPLAY            = 49;
  BASS_CONFIG_DEV_NONSTOP        = 50;
  BASS_CONFIG_IOS_NOCATEGORY     = 51;
  BASS_CONFIG_VERIFY_NET         = 52;
  BASS_CONFIG_DEV_PERIOD         = 53;
  BASS_CONFIG_FLOAT              = 54;
  //                               55 not existent
  BASS_CONFIG_NET_SEEK           = 56;
  BASS_CONFIG_AM_DISABLE         = 58;
  BASS_CONFIG_NET_PLAYLIST_DEPTH = 59;
  BASS_CONFIG_NET_PREBUF_WAIT    = 60;
  BASS_CONFIG_ANDROID_SESSIONID  = 62;
  BASS_CONFIG_WASAPI_PERSIST     = 65;
  BASS_CONFIG_REC_WASAPI         = 66;
  BASS_CONFIG_ANDROID_AAUDIO     = 67;

  // BASS_SetConfigPtr options
  BASS_CONFIG_NET_AGENT     = 16;
  BASS_CONFIG_NET_PROXY     = 17;
  BASS_CONFIG_LIBSSL        = 64;

  // BASS_CONFIG_IOS_SESSION flags
  BASS_IOS_SESSION_MIX      = 1;
  BASS_IOS_SESSION_DUCK     = 2;
  BASS_IOS_SESSION_AMBIENT  = 4;
  BASS_IOS_SESSION_SPEAKER  = 8;
  BASS_IOS_SESSION_DISABLE  = 16;

  // BASS_Init flags
  BASS_DEVICE_8BITS       = 1;      // 8 bit resolution, else 16 bit
  BASS_DEVICE_MONO        = 2;      // mono, else stereo
  BASS_DEVICE_3D          = 4;      // enable 3D functionality
  BASS_DEVICE_LATENCY     = $100;   // calculate device latency (BASS_INFO struct)
  BASS_DEVICE_CPSPEAKERS  = $400;   // detect speakers via Windows control panel
  BASS_DEVICE_SPEAKERS    = $800;   // force enabling of speaker assignment
  BASS_DEVICE_NOSPEAKER   = $1000;  // ignore speaker arrangement
  BASS_DEVICE_DMIX        = $2000;  // use ALSA "dmix" plugin
  BASS_DEVICE_FREQ        = $4000;  // set device sample rate
  BASS_DEVICE_STEREO      = $8000;  // limit output to stereo
  BASS_DEVICE_AUDIOTRACK  = $20000; // use AudioTrack output
  BASS_DEVICE_DSOUND      = $40000; // use DirectSound output

  // DirectSound interfaces (for use with BASS_GetDSoundObject)
  BASS_OBJECT_DS          = 1;   // IDirectSound
  BASS_OBJECT_DS3DL       = 2;   // IDirectSound3DListener

  // BASS_DEVICEINFO flags
  BASS_DEVICE_ENABLED     = 1;
  BASS_DEVICE_DEFAULT     = 2;
  BASS_DEVICE_INIT        = 4;
  BASS_DEVICE_LOOPBACK    = 8;

  BASS_DEVICE_TYPE_MASK        = $ff000000;
  BASS_DEVICE_TYPE_NETWORK     = $01000000;
  BASS_DEVICE_TYPE_SPEAKERS    = $02000000;
  BASS_DEVICE_TYPE_LINE        = $03000000;
  BASS_DEVICE_TYPE_HEADPHONES  = $04000000;
  BASS_DEVICE_TYPE_MICROPHONE  = $05000000;
  BASS_DEVICE_TYPE_HEADSET     = $06000000;
  BASS_DEVICE_TYPE_HANDSET     = $07000000;
  BASS_DEVICE_TYPE_DIGITAL     = $08000000;
  BASS_DEVICE_TYPE_SPDIF       = $09000000;
  BASS_DEVICE_TYPE_HDMI        = $0a000000;
  BASS_DEVICE_TYPE_DISPLAYPORT = $40000000;

  // BASS_GetDeviceInfo flags
  BASS_DEVICES_AIRPLAY         = $1000000;

  // BASS_INFO flags (from DSOUND.H)
  DSCAPS_CONTINUOUSRATE   = $00000010;     // supports all sample rates between min/maxrate
  DSCAPS_EMULDRIVER       = $00000020;     // device does NOT have hardware DirectSound support
  DSCAPS_CERTIFIED        = $00000040;     // device driver has been certified by Microsoft
  DSCAPS_SECONDARYMONO    = $00000100;     // mono
  DSCAPS_SECONDARYSTEREO  = $00000200;     // stereo
  DSCAPS_SECONDARY8BIT    = $00000400;     // 8 bit
  DSCAPS_SECONDARY16BIT   = $00000800;     // 16 bit

  // BASS_RECORDINFO flags (from DSOUND.H)
  DSCCAPS_EMULDRIVER = DSCAPS_EMULDRIVER;  // device does NOT have hardware DirectSound recording support
  DSCCAPS_CERTIFIED  = DSCAPS_CERTIFIED;   // device driver has been certified by Microsoft

  // defines for formats field of BASS_RECORDINFO (from MMSYSTEM.H)
  WAVE_FORMAT_1M08       = $00000001;      // 11.025 kHz, Mono,   8-bit
  WAVE_FORMAT_1S08       = $00000002;      // 11.025 kHz, Stereo, 8-bit
  WAVE_FORMAT_1M16       = $00000004;      // 11.025 kHz, Mono,   16-bit
  WAVE_FORMAT_1S16       = $00000008;      // 11.025 kHz, Stereo, 16-bit
  WAVE_FORMAT_2M08       = $00000010;      // 22.05  kHz, Mono,   8-bit
  WAVE_FORMAT_2S08       = $00000020;      // 22.05  kHz, Stereo, 8-bit
  WAVE_FORMAT_2M16       = $00000040;      // 22.05  kHz, Mono,   16-bit
  WAVE_FORMAT_2S16       = $00000080;      // 22.05  kHz, Stereo, 16-bit
  WAVE_FORMAT_4M08       = $00000100;      // 44.1   kHz, Mono,   8-bit
  WAVE_FORMAT_4S08       = $00000200;      // 44.1   kHz, Stereo, 8-bit
  WAVE_FORMAT_4M16       = $00000400;      // 44.1   kHz, Mono,   16-bit
  WAVE_FORMAT_4S16       = $00000800;      // 44.1   kHz, Stereo, 16-bit

  BASS_SAMPLE_8BITS       = 1;   // 8 bit
  BASS_SAMPLE_FLOAT       = 256; // 32 bit floating-point
  BASS_SAMPLE_MONO        = 2;   // mono
  BASS_SAMPLE_LOOP        = 4;   // looped
  BASS_SAMPLE_3D          = 8;   // 3D functionality
  BASS_SAMPLE_SOFTWARE    = 16;  // not using hardware mixing
  BASS_SAMPLE_MUTEMAX     = 32;  // mute at max distance (3D only)
  BASS_SAMPLE_VAM         = 64;  // DX7 voice allocation & management
  BASS_SAMPLE_FX          = 128; // old implementation of DX8 effects
  BASS_SAMPLE_OVER_VOL    = $10000; // override lowest volume
  BASS_SAMPLE_OVER_POS    = $20000; // override longest playing
  BASS_SAMPLE_OVER_DIST   = $30000; // override furthest from listener (3D only)

  BASS_STREAM_PRESCAN     = $20000; // enable pin-point seeking/length (MP3/MP2/MP1)
  BASS_STREAM_AUTOFREE	  = $40000; // automatically free the stream when it stop/ends
  BASS_STREAM_RESTRATE	  = $80000; // restrict the download rate of internet file streams
  BASS_STREAM_BLOCK       = $100000;// download/play internet file stream in small blocks
  BASS_STREAM_DECODE      = $200000;// don't play the stream, only decode (BASS_ChannelGetData)
  BASS_STREAM_STATUS      = $800000;// give server status info (HTTP/ICY tags) in DOWNLOADPROC

  BASS_MP3_IGNOREDELAY    = $200; // ignore LAME/Xing/VBRI/iTunes delay & padding info
  BASS_MP3_SETPOS         = BASS_STREAM_PRESCAN;

  BASS_MUSIC_FLOAT        = BASS_SAMPLE_FLOAT;
  BASS_MUSIC_MONO         = BASS_SAMPLE_MONO;
  BASS_MUSIC_LOOP         = BASS_SAMPLE_LOOP;
  BASS_MUSIC_3D           = BASS_SAMPLE_3D;
  BASS_MUSIC_FX           = BASS_SAMPLE_FX;
  BASS_MUSIC_AUTOFREE     = BASS_STREAM_AUTOFREE;
  BASS_MUSIC_DECODE       = BASS_STREAM_DECODE;
  BASS_MUSIC_PRESCAN      = BASS_STREAM_PRESCAN; // calculate playback length
  BASS_MUSIC_CALCLEN      = BASS_MUSIC_PRESCAN;
  BASS_MUSIC_RAMP         = $200;  // normal ramping
  BASS_MUSIC_RAMPS        = $400;  // sensitive ramping
  BASS_MUSIC_SURROUND     = $800;  // surround sound
  BASS_MUSIC_SURROUND2    = $1000; // surround sound (mode 2)
  BASS_MUSIC_FT2PAN       = $2000; // apply FastTracker 2 panning to XM files
  BASS_MUSIC_FT2MOD       = $2000; // play .MOD as FastTracker 2 does
  BASS_MUSIC_PT1MOD       = $4000; // play .MOD as ProTracker 1 does
  BASS_MUSIC_NONINTER     = $10000; // non-interpolated sample mixing
  BASS_MUSIC_SINCINTER    = $800000; // sinc interpolated sample mixing
  BASS_MUSIC_POSRESET     = $8000; // stop all notes when moving position
  BASS_MUSIC_POSRESETEX   = $400000; // stop all notes and reset bmp/etc when moving position
  BASS_MUSIC_STOPBACK     = $80000; // stop the music on a backwards jump effect
  BASS_MUSIC_NOSAMPLE     = $100000; // don't load the samples

  // Speaker assignment flags
  BASS_SPEAKER_FRONT      = $1000000;  // front speakers
  BASS_SPEAKER_REAR       = $2000000;  // rear/side speakers
  BASS_SPEAKER_CENLFE     = $3000000;  // center & LFE speakers (5.1)
  BASS_SPEAKER_REAR2      = $4000000;  // rear center speakers (7.1)
  BASS_SPEAKER_LEFT       = $10000000; // modifier: left
  BASS_SPEAKER_RIGHT      = $20000000; // modifier: right
  BASS_SPEAKER_FRONTLEFT  = BASS_SPEAKER_FRONT or BASS_SPEAKER_LEFT;
  BASS_SPEAKER_FRONTRIGHT = BASS_SPEAKER_FRONT or BASS_SPEAKER_RIGHT;
  BASS_SPEAKER_REARLEFT   = BASS_SPEAKER_REAR or BASS_SPEAKER_LEFT;
  BASS_SPEAKER_REARRIGHT  = BASS_SPEAKER_REAR or BASS_SPEAKER_RIGHT;
  BASS_SPEAKER_CENTER     = BASS_SPEAKER_CENLFE or BASS_SPEAKER_LEFT;
  BASS_SPEAKER_LFE        = BASS_SPEAKER_CENLFE or BASS_SPEAKER_RIGHT;
  BASS_SPEAKER_REAR2LEFT  = BASS_SPEAKER_REAR2 or BASS_SPEAKER_LEFT;
  BASS_SPEAKER_REAR2RIGHT = BASS_SPEAKER_REAR2 or BASS_SPEAKER_RIGHT;

  BASS_ASYNCFILE          = $40000000;
  BASS_UNICODE            = $80000000;

  BASS_RECORD_PAUSE       = $8000; // start recording paused

  // DX7 voice allocation & management flags
  BASS_VAM_HARDWARE       = 1;
  BASS_VAM_SOFTWARE       = 2;
  BASS_VAM_TERM_TIME      = 4;
  BASS_VAM_TERM_DIST      = 8;
  BASS_VAM_TERM_PRIO      = 16;

  // BASS_CHANNELINFO types
  BASS_CTYPE_SAMPLE           = 1;
  BASS_CTYPE_RECORD           = 2;
  BASS_CTYPE_STREAM           = $10000;
  BASS_CTYPE_STREAM_VORBIS    = $10002;
  BASS_CTYPE_STREAM_OGG       = $10002;
  BASS_CTYPE_STREAM_MP1       = $10003;
  BASS_CTYPE_STREAM_MP2       = $10004;
  BASS_CTYPE_STREAM_MP3       = $10005;
  BASS_CTYPE_STREAM_AIFF      = $10006;
  BASS_CTYPE_STREAM_CA        = $10007;
  BASS_CTYPE_STREAM_MF        = $10008;
  BASS_CTYPE_STREAM_AM        = $10009;
  BASS_CTYPE_STREAM_DUMMY     = $18000;
  BASS_CTYPE_STREAM_DEVICE    = $18001;
  BASS_CTYPE_STREAM_WAV       = $40000; // WAVE flag, LOWORD=codec
  BASS_CTYPE_STREAM_WAV_PCM   = $50001;
  BASS_CTYPE_STREAM_WAV_FLOAT = $50003;
  BASS_CTYPE_MUSIC_MOD        = $20000;
  BASS_CTYPE_MUSIC_MTM        = $20001;
  BASS_CTYPE_MUSIC_S3M        = $20002;
  BASS_CTYPE_MUSIC_XM         = $20003;
  BASS_CTYPE_MUSIC_IT         = $20004;
  BASS_CTYPE_MUSIC_MO3        = $00100; // MO3 flag

  // 3D channel modes
  BASS_3DMODE_NORMAL      = 0; // normal 3D processing
  BASS_3DMODE_RELATIVE    = 1; // position is relative to the listener
  BASS_3DMODE_OFF         = 2; // no 3D processing

  // software 3D mixing algorithms (used with BASS_CONFIG_3DALGORITHM)
  BASS_3DALG_DEFAULT      = 0;
  BASS_3DALG_OFF          = 1;
  BASS_3DALG_FULL         = 2;
  BASS_3DALG_LIGHT        = 3;

  // EAX environments, use with BASS_SetEAXParameters
  EAX_ENVIRONMENT_GENERIC           = 0;
  EAX_ENVIRONMENT_PADDEDCELL        = 1;
  EAX_ENVIRONMENT_ROOM              = 2;
  EAX_ENVIRONMENT_BATHROOM          = 3;
  EAX_ENVIRONMENT_LIVINGROOM        = 4;
  EAX_ENVIRONMENT_STONEROOM         = 5;
  EAX_ENVIRONMENT_AUDITORIUM        = 6;
  EAX_ENVIRONMENT_CONCERTHALL       = 7;
  EAX_ENVIRONMENT_CAVE              = 8;
  EAX_ENVIRONMENT_ARENA             = 9;
  EAX_ENVIRONMENT_HANGAR            = 10;
  EAX_ENVIRONMENT_CARPETEDHALLWAY   = 11;
  EAX_ENVIRONMENT_HALLWAY           = 12;
  EAX_ENVIRONMENT_STONECORRIDOR     = 13;
  EAX_ENVIRONMENT_ALLEY             = 14;
  EAX_ENVIRONMENT_FOREST            = 15;
  EAX_ENVIRONMENT_CITY              = 16;
  EAX_ENVIRONMENT_MOUNTAINS         = 17;
  EAX_ENVIRONMENT_QUARRY            = 18;
  EAX_ENVIRONMENT_PLAIN             = 19;
  EAX_ENVIRONMENT_PARKINGLOT        = 20;
  EAX_ENVIRONMENT_SEWERPIPE         = 21;
  EAX_ENVIRONMENT_UNDERWATER        = 22;
  EAX_ENVIRONMENT_DRUGGED           = 23;
  EAX_ENVIRONMENT_DIZZY             = 24;
  EAX_ENVIRONMENT_PSYCHOTIC         = 25;
  // total number of environments
  EAX_ENVIRONMENT_COUNT             = 26;

  BASS_STREAMPROC_END = $80000000; // end of user stream flag

  // BASS_StreamCreateFileUser file systems
  STREAMFILE_NOBUFFER     = 0;
  STREAMFILE_BUFFER       = 1;
  STREAMFILE_BUFFERPUSH   = 2;

  // BASS_StreamPutFileData options
  BASS_FILEDATA_END       = 0; // end & close the file

  // BASS_StreamGetFilePosition modes
  BASS_FILEPOS_CURRENT    = 0;
  BASS_FILEPOS_DECODE     = BASS_FILEPOS_CURRENT;
  BASS_FILEPOS_DOWNLOAD   = 1;
  BASS_FILEPOS_END        = 2;
  BASS_FILEPOS_START      = 3;
  BASS_FILEPOS_CONNECTED  = 4;
  BASS_FILEPOS_BUFFER     = 5;
  BASS_FILEPOS_SOCKET     = 6;
  BASS_FILEPOS_ASYNCBUF   = 7;
  BASS_FILEPOS_SIZE       = 8;
  BASS_FILEPOS_BUFFERING  = 9;

  // BASS_ChannelSetSync types
  BASS_SYNC_POS           = 0;
  BASS_SYNC_END           = 2;
  BASS_SYNC_META          = 4;
  BASS_SYNC_SLIDE         = 5;
  BASS_SYNC_STALL         = 6;
  BASS_SYNC_DOWNLOAD      = 7;
  BASS_SYNC_FREE          = 8;
  BASS_SYNC_SETPOS        = 11;
  BASS_SYNC_MUSICPOS      = 10;
  BASS_SYNC_MUSICINST     = 1;
  BASS_SYNC_MUSICFX       = 3;
  BASS_SYNC_OGG_CHANGE    = 12;
  BASS_SYNC_DEV_FAIL      = 14;
  BASS_SYNC_DEV_FORMAT    = 15;
  BASS_SYNC_THREAD        = $20000000; // flag: call sync in other thread
  BASS_SYNC_MIXTIME       = $40000000; // flag: sync at mixtime, else at playtime
  BASS_SYNC_ONETIME       = $80000000; // flag: sync only once, else continuously

  // BASS_ChannelIsActive return values
  BASS_ACTIVE_STOPPED = 0;
  BASS_ACTIVE_PLAYING = 1;
  BASS_ACTIVE_STALLED = 2;
  BASS_ACTIVE_PAUSED  = 3;
  BASS_ACTIVE_PAUSED_DEVICE = 4;

  // Channel attributes
  BASS_ATTRIB_FREQ                  = 1;
  BASS_ATTRIB_VOL                   = 2;
  BASS_ATTRIB_PAN                   = 3;
  BASS_ATTRIB_EAXMIX                = 4;
  BASS_ATTRIB_NOBUFFER              = 5;
  BASS_ATTRIB_VBR                   = 6;
  BASS_ATTRIB_CPU                   = 7;
  BASS_ATTRIB_SRC                   = 8;
  BASS_ATTRIB_NET_RESUME            = 9;
  BASS_ATTRIB_SCANINFO              = 10;
  BASS_ATTRIB_NORAMP                = 11;
  BASS_ATTRIB_BITRATE               = 12;
  BASS_ATTRIB_BUFFER                = 13;
  BASS_ATTRIB_GRANULE               = 14;
  BASS_ATTRIB_MUSIC_AMPLIFY         = $100;
  BASS_ATTRIB_MUSIC_PANSEP          = $101;
  BASS_ATTRIB_MUSIC_PSCALER         = $102;
  BASS_ATTRIB_MUSIC_BPM             = $103;
  BASS_ATTRIB_MUSIC_SPEED           = $104;
  BASS_ATTRIB_MUSIC_VOL_GLOBAL      = $105;
  BASS_ATTRIB_MUSIC_ACTIVE          = $106;
  BASS_ATTRIB_MUSIC_VOL_CHAN        = $200; // + channel #
  BASS_ATTRIB_MUSIC_VOL_INST        = $300; // + instrument #

  // BASS_ChannelSlideAttribute flags
  BASS_SLIDE_LOG                    = $1000000;

  // BASS_ChannelGetData flags
  BASS_DATA_AVAILABLE = 0;        // query how much data is buffered
  BASS_DATA_FIXED     = $20000000; // flag: return 8.24 fixed-point data
  BASS_DATA_FLOAT     = $40000000; // flag: return floating-point sample data
  BASS_DATA_FFT256    = $80000000; // 256 sample FFT
  BASS_DATA_FFT512    = $80000001; // 512 FFT
  BASS_DATA_FFT1024   = $80000002; // 1024 FFT
  BASS_DATA_FFT2048   = $80000003; // 2048 FFT
  BASS_DATA_FFT4096   = $80000004; // 4096 FFT
  BASS_DATA_FFT8192   = $80000005; // 8192 FFT
  BASS_DATA_FFT16384  = $80000006; // 16384 FFT
  BASS_DATA_FFT32768  = $80000007; // 32768 FFT
  BASS_DATA_FFT_INDIVIDUAL = $10; // FFT flag: FFT for each channel, else all combined
  BASS_DATA_FFT_NOWINDOW = $20;   // FFT flag: no Hanning window
  BASS_DATA_FFT_REMOVEDC = $40;   // FFT flag: pre-remove DC bias
  BASS_DATA_FFT_COMPLEX = $80;    // FFT flag: return complex data
  BASS_DATA_FFT_NYQUIST = $100;   // FFT flag: return extra Nyquist value

  // BASS_ChannelGetLevelEx flags
  BASS_LEVEL_MONO     = 1;
  BASS_LEVEL_STEREO   = 2;
  BASS_LEVEL_RMS      = 4;
  BASS_LEVEL_VOLPAN   = 8;

  // BASS_ChannelGetTags types : what's returned
  BASS_TAG_ID3        = 0; // ID3v1 tags : TAG_ID3 structure
  BASS_TAG_ID3V2      = 1; // ID3v2 tags : variable length block
  BASS_TAG_OGG        = 2; // OGG comments : series of null-terminated UTF-8 strings
  BASS_TAG_HTTP       = 3; // HTTP headers : series of null-terminated ANSI strings
  BASS_TAG_ICY        = 4; // ICY headers : series of null-terminated ANSI strings
  BASS_TAG_META       = 5; // ICY metadata : ANSI string
  BASS_TAG_APE        = 6; // APEv2 tags : series of null-terminated UTF-8 strings
  BASS_TAG_MP4        = 7; // MP4/iTunes metadata : series of null-terminated UTF-8 strings
  BASS_TAG_WMA        = 8; // WMA tags : series of null-terminated UTF-8 strings
  BASS_TAG_VENDOR     = 9; // OGG encoder : UTF-8 string
  BASS_TAG_LYRICS3    = 10; // Lyric3v2 tag : ASCII string
  BASS_TAG_CA_CODEC   = 11;	// CoreAudio codec info : TAG_CA_CODEC structure
  BASS_TAG_MF         = 13;	// Media Foundation tags : series of null-terminated UTF-8 strings
  BASS_TAG_WAVEFORMAT = 14;	// WAVE format : WAVEFORMATEEX structure
  BASS_TAG_AM_MIME    = 15; // Android Media MIME type : ASCII string
  BASS_TAG_AM_NAME    = 16; // Android Media codec name : ASCII string
  BASS_TAG_RIFF_INFO  = $100; // RIFF "INFO" tags : series of null-terminated ANSI strings
  BASS_TAG_RIFF_BEXT  = $101; // RIFF/BWF "bext" tags : TAG_BEXT structure
  BASS_TAG_RIFF_CART  = $102; // RIFF/BWF "cart" tags : TAG_CART structure
  BASS_TAG_RIFF_DISP  = $103; // RIFF "DISP" text tag : ANSI string
  BASS_TAG_RIFF_CUE   = $104; // RIFF "cue " chunk : TAG_CUE structure
  BASS_TAG_RIFF_SMPL  = $105; // RIFF "smpl" chunk : TAG_SMPL structure
  BASS_TAG_APE_BINARY = $1000;  // + index #, binary APEv2 tag : TAG_APE_BINARY structure
  BASS_TAG_MUSIC_NAME = $10000;	// MOD music name : ANSI string
  BASS_TAG_MUSIC_MESSAGE = $10001; // MOD message : ANSI string
  BASS_TAG_MUSIC_ORDERS  = $10002; // MOD order list : BYTE array of pattern numbers
  BASS_TAG_MUSIC_AUTH    = $10003; // MOD author : UTF-8 string
  BASS_TAG_MUSIC_INST    = $10100; // + instrument #, MOD instrument name : ANSI string
  BASS_TAG_MUSIC_SAMPLE  = $10300; // + sample #, MOD sample name : ANSI string

  // BASS_ChannelGetLength/GetPosition/SetPosition modes
  BASS_POS_BYTE           = 0; // byte position
  BASS_POS_MUSIC_ORDER    = 1; // order.row position, MAKELONG(order,row)
  BASS_POS_OGG            = 3; // OGG bitstream number
  BASS_POS_RESET          = $2000000; // flag: reset user file buffers
  BASS_POS_RELATIVE       = $4000000; // flag: seek relative to the current position
  BASS_POS_INEXACT        = $8000000; // flag: allow seeking to inexact position
  BASS_POS_DECODE         = $10000000; // flag: get the decoding (not playing) position
  BASS_POS_DECODETO       = $20000000; // flag: decode to the position instead of seeking
  BASS_POS_SCAN           = $40000000; // flag: scan to the position

  // BASS_ChannelSetDevice/GetDevice option
  BASS_NODEVICE           = $20000;

  // BASS_RecordSetInput flags
  BASS_INPUT_OFF    = $10000;
  BASS_INPUT_ON     = $20000;

  BASS_INPUT_TYPE_MASK    = $FF000000;
  BASS_INPUT_TYPE_UNDEF   = $00000000;
  BASS_INPUT_TYPE_DIGITAL = $01000000;
  BASS_INPUT_TYPE_LINE    = $02000000;
  BASS_INPUT_TYPE_MIC     = $03000000;
  BASS_INPUT_TYPE_SYNTH   = $04000000;
  BASS_INPUT_TYPE_CD      = $05000000;
  BASS_INPUT_TYPE_PHONE   = $06000000;
  BASS_INPUT_TYPE_SPEAKER = $07000000;
  BASS_INPUT_TYPE_WAVE    = $08000000;
  BASS_INPUT_TYPE_AUX     = $09000000;
  BASS_INPUT_TYPE_ANALOG  = $0A000000;

  // BASS_ChannelSetFX effect types
  BASS_FX_DX8_CHORUS	  = 0;
  BASS_FX_DX8_COMPRESSOR  = 1;
  BASS_FX_DX8_DISTORTION  = 2;
  BASS_FX_DX8_ECHO        = 3;
  BASS_FX_DX8_FLANGER     = 4;
  BASS_FX_DX8_GARGLE      = 5;
  BASS_FX_DX8_I3DL2REVERB = 6;
  BASS_FX_DX8_PARAMEQ     = 7;
  BASS_FX_DX8_REVERB      = 8;
  BASS_FX_VOLUME          = 9;

  BASS_DX8_PHASE_NEG_180 = 0;
  BASS_DX8_PHASE_NEG_90  = 1;
  BASS_DX8_PHASE_ZERO    = 2;
  BASS_DX8_PHASE_90      = 3;
  BASS_DX8_PHASE_180     = 4;

type
  // For new BASS 2.4 specification in calling conventions
  // DISABLED HERE BECAUSE OLD INNOSETUP API DOES NOT SUPPORT
  // TYPE INT64 !!
  //
  //DWORD = LongWord;   // I think already defined in Innosetup
  //BOOL = LongBool;    // I think already defined in Innosetup
  //
  // From bass.pas (2.4.15.0)
  //DWORD = Cardinal;
  FLOAT = Single;
  QWORD = Int64;        // New API of InnoSetup now supports this type
                        // 64-bit (replace "int64" with "comp" if using Delphi 3)

  HMUSIC = DWORD;       // MOD music handle
  HSAMPLE = DWORD;      // sample handle
  HCHANNEL = DWORD;     // playing sample's channel handle
  HSTREAM = DWORD;      // sample stream handle
  HRECORD = DWORD;      // recording handle
  HSYNC = DWORD;        // synchronizer handle
  HDSP = DWORD;         // DSP handle
  HFX = DWORD;          // DX8 effect handle
  HPLUGIN = DWORD;      // Plugin handle

  // Device info structure
  BASS_DEVICEINFO = record
    name: PAnsiChar;    // description
    driver: PAnsiChar;  // driver
    flags: DWORD;
  end;

  BASS_INFO = record
    flags: DWORD;       // device capabilities (DSCAPS_xxx flags)
    hwsize: DWORD;      // size of total device hardware memory
    hwfree: DWORD;      // size of free device hardware memory
    freesam: DWORD;     // number of free sample slots in the hardware
    free3d: DWORD;      // number of free 3D sample slots in the hardware
    minrate: DWORD;     // min sample rate supported by the hardware
    maxrate: DWORD;     // max sample rate supported by the hardware
    eax: BOOL;          // device supports EAX? (always FALSE if BASS_DEVICE_3D was not used)
    minbuf: DWORD;      // recommended minimum buffer length in ms (requires BASS_DEVICE_LATENCY)
    dsver: DWORD;       // DirectSound version
    latency: DWORD;     // delay (in ms) before start of playback (requires BASS_DEVICE_LATENCY)
    initflags: DWORD;   // BASS_Init "flags" parameter
    speakers: DWORD;    // number of speakers available
    freq: DWORD;        // current output rate
  end;

  // Recording device info structure
  BASS_RECORDINFO = record
    flags: DWORD;       // device capabilities (DSCCAPS_xxx flags)
    formats: DWORD;     // supported standard formats (WAVE_FORMAT_xxx flags)
    inputs: DWORD;      // number of inputs
    singlein: BOOL;     // only 1 input can be set at a time
    freq: DWORD;        // current input rate
  end;

  // Sample info structure
  BASS_SAMPLE = record
    freq: DWORD;        // default playback rate
    volume: FLOAT;      // default volume (0-100)
    pan: FLOAT;         // default pan (-100=left, 0=middle, 100=right)
    flags: DWORD;       // BASS_SAMPLE_xxx flags
    length: DWORD;      // length (in samples, not bytes)
    max: DWORD;         // maximum simultaneous playbacks
    origres: DWORD;     // original resolution
    chans: DWORD;       // number of channels
    mingap: DWORD;      // minimum gap (ms) between creating channels
    mode3d: DWORD;      // BASS_3DMODE_xxx mode
    mindist: FLOAT;     // minimum distance
    maxdist: FLOAT;     // maximum distance
    iangle: DWORD;      // angle of inside projection cone
    oangle: DWORD;      // angle of outside projection cone
    outvol: FLOAT;      // delta-volume outside the projection cone
    vam: DWORD;         // voice allocation/management flags (BASS_VAM_xxx)
    priority: DWORD;    // priority (0=lowest, $ffffffff=highest)
  end;

  // Channel info structure
  BASS_CHANNELINFO = record
    freq: DWORD;          // default playback rate
    chans: DWORD;         // channels
    flags: DWORD;         // BASS_SAMPLE/STREAM/MUSIC/SPEAKER flags
    ctype: DWORD;         // type of channel
    origres: DWORD;       // original resolution
    plugin: HPLUGIN;      // plugin
    sample: HSAMPLE;      // sample
    filename: PAnsiChar;  // filename
  end;

  BASS_PLUGINFORM = record
    ctype: DWORD;       // channel type
    name: PAnsiChar;    // format description
    exts: PAnsiChar;    // file extension filter (*.ext1;*.ext2;etc...)
  end;

  // 3D vector (for 3D positions/velocities/orientations)
  BASS_3DVECTOR = record
    x: FLOAT;           // +=right, -=left
    y: FLOAT;           // +=up, -=down
    z: FLOAT;           // +=front, -=behind
  end;

  // ID3v1 tag structure
  TAG_ID3 = record
    id: Array[0..2] of AnsiChar;
    title: Array[0..29] of AnsiChar;
    artist: Array[0..29] of AnsiChar;
    album: Array[0..29] of AnsiChar;
    year: Array[0..3] of AnsiChar;
    comment: Array[0..29] of AnsiChar;
    genre: Byte;
  end;

  // Binary APEv2 tag structure
  TAG_APE_BINARY = record
    key: PAnsiChar;
    data: PAnsiChar;
    length: DWORD;
  end;

  // BWF "bext" tag structure
  TAG_BEXT = record
    Description: Array[0..255] of AnsiChar;         // description
    Originator: Array[0..31] of AnsiChar;           // name of the originator
    OriginatorReference: Array[0..31] of AnsiChar;  // reference of the originator
    OriginationDate: Array[0..9] of AnsiChar;       // date of creation (yyyy-mm-dd)
    OriginationTime: Array[0..7] of AnsiChar;       // time of creation (hh-mm-ss)
    TimeReference: QWORD;                           // first sample count since midnight (little-endian)
    Version: Word;                                  // BWF version (little-endian)
    UMID: Array[0..63] of Byte;                     // SMPTE UMID
    Reserved: Array[0..189] of Byte;
    CodingHistory: Array of AnsiChar;               // history
  end;

  BASS_DX8_CHORUS = record
    fWetDryMix: FLOAT;
    fDepth: FLOAT;
    fFeedback: FLOAT;
    fFrequency: FLOAT;
    lWaveform: DWORD;   // 0=triangle, 1=sine
    fDelay: FLOAT;
    lPhase: DWORD;      // BASS_DX8_PHASE_xxx
  end;

  BASS_DX8_COMPRESSOR = record
    fGain: FLOAT;
    fAttack: FLOAT;
    fRelease: FLOAT;
    fThreshold: FLOAT;
    fRatio: FLOAT;
    fPredelay: FLOAT;
  end;

  BASS_DX8_DISTORTION = record
    fGain: FLOAT;
    fEdge: FLOAT;
    fPostEQCenterFrequency: FLOAT;
    fPostEQBandwidth: FLOAT;
    fPreLowpassCutoff: FLOAT;
  end;

  BASS_DX8_ECHO = record
    fWetDryMix: FLOAT;
    fFeedback: FLOAT;
    fLeftDelay: FLOAT;
    fRightDelay: FLOAT;
    lPanDelay: BOOL;
  end;

  BASS_DX8_FLANGER = record
    fWetDryMix: FLOAT;
    fDepth: FLOAT;
    fFeedback: FLOAT;
    fFrequency: FLOAT;
    lWaveform: DWORD;   // 0=triangle, 1=sine
    fDelay: FLOAT;
    lPhase: DWORD;      // BASS_DX8_PHASE_xxx
  end;

  BASS_DX8_GARGLE = record
    dwRateHz: DWORD;               // Rate of modulation in hz
    dwWaveShape: DWORD;            // 0=triangle, 1=square
  end;

  BASS_DX8_I3DL2REVERB = record
    lRoom: LongInt;                // [-10000, 0]      default: -1000 mB
    lRoomHF: LongInt;              // [-10000, 0]      default: 0 mB
    flRoomRolloffFactor: FLOAT;    // [0.0, 10.0]      default: 0.0
    flDecayTime: FLOAT;            // [0.1, 20.0]      default: 1.49s
    flDecayHFRatio: FLOAT;         // [0.1, 2.0]       default: 0.83
    lReflections: LongInt;         // [-10000, 1000]   default: -2602 mB
    flReflectionsDelay: FLOAT;     // [0.0, 0.3]       default: 0.007 s
    lReverb: LongInt;              // [-10000, 2000]   default: 200 mB
    flReverbDelay: FLOAT;          // [0.0, 0.1]       default: 0.011 s
    flDiffusion: FLOAT;            // [0.0, 100.0]     default: 100.0 %
    flDensity: FLOAT;              // [0.0, 100.0]     default: 100.0 %
    flHFReference: FLOAT;          // [20.0, 20000.0]  default: 5000.0 Hz
  end;

  BASS_DX8_PARAMEQ = record
    fCenter: FLOAT;
    fBandwidth: FLOAT;
    fGain: FLOAT;
  end;

  BASS_DX8_REVERB = record
    fInGain: FLOAT;                // [-96.0,0.0]            default: 0.0 dB
    fReverbMix: FLOAT;             // [-96.0,0.0]            default: 0.0 db
    fReverbTime: FLOAT;            // [0.001,3000.0]         default: 1000.0 ms
    fHighFreqRTRatio: FLOAT;       // [0.001,0.999]          default: 0.001
  end;

//////////////////////////////////////////////////////////////////////////////
// calling external bass soundlib using:
// function A(B: Integer): Integer;
// external '<dllfunctionname>@<dllfilename> <callingconvention> <options>';

///////////////////////////////////////////////////////////////////////////////
function BASS_Init(device: Integer; freq, flags: DWORD; win: hwnd; CLSID: Integer): Boolean;
external 'BASS_Init@files:bass.dll stdcall delayload';

// BASS 2.3
//function BASS_StreamCreateFile(mem: BOOL; f: PChar; offset: DWORD; length: DWORD; flags: DWORD): DWORD;
//external 'BASS_StreamCreateFile@files:bass.dll stdcall delayload';
// BASS 2.4
// ATTENTION FOR BASS 2.4 WE HAVE TO USE 64-BIT (QWORD) FOR "offset" AND "length" !!
function BASS_StreamCreateFile(mem: BOOL; f: PAnsiChar; offset: QWORD; length: QWORD; flags: DWORD): DWORD;
external 'BASS_StreamCreateFile@files:bass.dll stdcall delayload';

// For XM, MOD, etc. Tracker Files
// BASS 2.3
//function BASS_MusicLoad(mem: BOOL; f: PChar; offset: DWORD; length: DWORD; flags: DWORD; freq: DWORD): DWORD;
//external 'BASS_MusicLoad@files:bass.dll stdcall delayload';
// BASS 2.4
// ATTENTION FOR BASS 2.4 WE HAVE TO USE 64-BIT (QWORD) FOR "offset" !!
function BASS_MusicLoad(mem: BOOL; f: PAnsiChar; offset: QWORD; length: DWORD; flags: DWORD; freq: DWORD): DWORD;
external 'BASS_MusicLoad@files:bass.dll stdcall delayload';

function BASS_GetVersion(): DWORD;
external 'BASS_GetVersion@files:bass.dll stdcall delayload';

function BASS_Start(): Boolean;
external 'BASS_Start@files:bass.dll stdcall delayload';

function BASS_ChannelPlay(handle: DWORD; restart: BOOL): Boolean;
external 'BASS_ChannelPlay@files:bass.dll stdcall delayload';

function BASS_ChannelIsActive(handle: DWORD): Integer;
external 'BASS_ChannelIsActive@files:bass.dll stdcall delayload';

function BASS_ChannelPause(handle: DWORD): Boolean;
external 'BASS_ChannelPause@files:bass.dll stdcall delayload';

function BASS_Stop(): Boolean;
external 'BASS_Stop@files:bass.dll stdcall delayload';

function BASS_Pause(): Boolean;
external 'BASS_Pause@files:bass.dll stdcall delayload';

function BASS_Free(): Boolean;
external 'BASS_Free@files:bass.dll stdcall delayload';

function BASS_SPEAKER_N(n: DWORD): DWORD;
begin
  Result := n shl 24;
end;

//////////////////////////////////////////////////////////////////////////////
procedure PauseButtonOnClick(Sender: TObject);
begin
  BASS_ChannelPause(SndHandle);
end;

//////////////////////////////////////////////////////////////////////////////
procedure StopButtonOnClick(Sender: TObject);
begin
  BASS_Stop();
  BASS_Free();
end;

//////////////////////////////////////////////////////////////////////////////
// Fix for skinning errors in ISSkinU.dll / ISSkin.dll or skin-files (cjstyles)
// Due to some skin-files, this fix is only for old standard-skins from
// "Codejocks". Recreate dimensions for some properties in the WizardForm Class.
// These properties are currently available in WizardForm:
//
// TWizardForm = class(TSetupForm)
//   property CancelButton: TNewButton; read;
//   property NextButton: TNewButton; read;
//   property BackButton: TNewButton; read;
//   property Notebook1: TNotebook; read;
//   property Notebook2: TNotebook; read;
//   property WelcomePage: TNewNotebookPage; read;
//   property InnerPage: TNewNotebookPage; read;
//   property FinishedPage: TNewNotebookPage; read;
//   property LicensePage: TNewNotebookPage; read;
//   property PasswordPage: TNewNotebookPage; read;
//   property InfoBeforePage: TNewNotebookPage; read;
//   property UserInfoPage: TNewNotebookPage; read;
//   property SelectDirPage: TNewNotebookPage; read;
//   property SelectComponentsPage: TNewNotebookPage; read;
//   property SelectProgramGroupPage: TNewNotebookPage; read;
//   property SelectTasksPage: TNewNotebookPage; read;
//   property ReadyPage: TNewNotebookPage; read;
//   property PreparingPage: TNewNotebookPage; read;
//   property InstallingPage: TNewNotebookPage; read;
//   property InfoAfterPage: TNewNotebookPage; read;
//   property DiskSpaceLabel: TNewStaticText; read;
//   property DirEdit: TEdit; read;
//   property GroupEdit: TNewEdit; read;
//   property NoIconsCheck: TNewCheckBox; read;
//   property PasswordLabel: TNewStaticText; read;
//   property PasswordEdit: TPasswordEdit; read;
//   property PasswordEditLabel: TNewStaticText; read;
//   property ReadyMemo: TNewMemo; read;
//   property TypesCombo: TNewComboBox; read;
//   property Bevel: TBevel; read;
//   property WizardBitmapImage: TBitmapImage; read;
//   property WelcomeLabel1: TNewStaticText; read;
//   property InfoBeforeMemo: TRichEditViewer; read;
//   property InfoBeforeClickLabel: TNewStaticText; read;
//   property MainPanel: TPanel; read;
//   property Bevel1: TBevel; read;
//   property PageNameLabel: TNewStaticText; read;
//   property PageDescriptionLabel: TNewStaticText; read;
//   property WizardSmallBitmapImage: TBitmapImage; read;
//   property ReadyLabel: TNewStaticText; read;
//   property FinishedLabel: TNewStaticText; read;
//   property YesRadio: TNewRadioButton; read;
//   property NoRadio: TNewRadioButton; read;
//   property WizardBitmapImage2: TBitmapImage; read;
//   property WelcomeLabel2: TNewStaticText; read;
//   property LicenseLabel1: TNewStaticText; read;
//   property LicenseMemo: TRichEditViewer; read;
//   property InfoAfterMemo: TRichEditViewer; read;
//   property InfoAfterClickLabel: TNewStaticText; read;
//   property ComponentsList: TNewCheckListBox; read;
//   property ComponentsDiskSpaceLabel: TNewStaticText; read;
//   property BeveledLabel: TNewStaticText; read;
//   property StatusLabel: TNewStaticText; read;
//   property FilenameLabel: TNewStaticText; read;
//   property ProgressGauge: TNewProgressBar; read;
//   property SelectDirLabel: TNewStaticText; read;
//   property SelectStartMenuFolderLabel: TNewStaticText; read;
//   property SelectComponentsLabel: TNewStaticText; read;
//   property SelectTasksLabel: TNewStaticText; read;
//   property LicenseAcceptedRadio: TNewRadioButton; read;
//   property LicenseNotAcceptedRadio: TNewRadioButton; read;
//   property UserInfoNameLabel: TNewStaticText; read;
//   property UserInfoNameEdit: TNewEdit; read;
//   property UserInfoOrgLabel: TNewStaticText; read;
//   property UserInfoOrgEdit: TNewEdit; read;
//   property PreparingErrorBitmapImage: TBitmapImage; read;
//   property PreparingLabel: TNewStaticText; read;
//   property FinishedHeadingLabel: TNewStaticText; read;
//   property UserInfoSerialLabel: TNewStaticText; read;
//   property UserInfoSerialEdit: TNewEdit; read;
//   property TasksList: TNewCheckListBox; read;
//   property RunList: TNewCheckListBox; read;
//   property DirBrowseButton: TNewButton; read;
//   property GroupBrowseButton: TNewButton; read;
//   property SelectDirBitmapImage: TBitmapImage; read;
//   property SelectGroupBitmapImage: TBitmapImage; read;
//   property SelectDirBrowseLabel: TNewStaticText; read;
//   property SelectStartMenuFolderBrowseLabel: TNewStaticText; read;
//   property PreparingYesRadio: TNewRadioButton; read;
//   property PreparingNoRadio: TNewRadioButton; read;
//   property PreparingMemo: TNewMemo; read;
//   property CurPageID: Integer; read;
//   function AdjustLabelHeight(ALabel: TNewStaticText): Integer;
//   procedure IncTopDecHeight(AControl: TControl; Amount: Integer);
//   property PrevAppDir: String; read;
// end;
//

procedure InitializeWizard();
var
  NewLicenseMemo: TMemo;
  NewInfoBeforeMemo: TMemo;
  NewInfoAfterMemo: TMemo;
  NewPreparingMemo: TMemo;

begin
  WizardForm.LicenseMemo.Visible := false;
  WizardForm.InfoBeforeMemo.Visible := false;
  WizardForm.InfoAfterMemo.Visible := false;
  WizardForm.PreparingMemo.Visible := false;

  NewLicenseMemo := TMemo.Create(WizardForm);
  with NewLicenseMemo do
  begin  
    Parent := WizardForm.LicenseMemo.Parent;      
    Left   := WizardForm.LicenseMemo.Left;
    Top    := WizardForm.LicenseMemo.Top;
    Width  := WizardForm.LicenseMemo.Width;
    Height := WizardForm.LicenseMemo.Height;
    Text   := WizardForm.LicenseMemo.Text;
    ReadOnly   := True;
    ScrollBars := ssVertical;
  end;

  NewInfoBeforeMemo := TMemo.Create(WizardForm);
  with NewInfoBeforeMemo do
  begin  
    Parent := WizardForm.InfoBeforeMemo.Parent;      
    Left   := WizardForm.InfoBeforeMemo.Left;
    Top    := WizardForm.InfoBeforeMemo.Top;
    Width  := WizardForm.InfoBeforeMemo.Width;
    Height := WizardForm.InfoBeforeMemo.Height;        
    Text   := WizardForm.InfoBeforeMemo.Text;
    ReadOnly   := True;
    ScrollBars := ssVertical;
  end;

  NewInfoAfterMemo := TMemo.Create(WizardForm);
  with NewInfoAfterMemo do
  begin  
    Parent := WizardForm.InfoAfterMemo.Parent;      
    Left   := WizardForm.InfoAfterMemo.Left;
    Top    := WizardForm.InfoAfterMemo.Top;
    Width  := WizardForm.InfoAfterMemo.Width;
    Height := WizardForm.InfoAfterMemo.Height;        
    Text   := WizardForm.InfoAfterMemo.Text;
    ReadOnly   := True;
    ScrollBars := ssVertical;
  end;

  NewPreparingMemo := TMemo.Create(WizardForm);
  with NewPreparingMemo do
  begin  
    Parent := WizardForm.PreparingMemo.Parent;      
    Left   := WizardForm.PreparingMemo.Left;
    Top    := WizardForm.PreparingMemo.Top;
    Width  := WizardForm.PreparingMemo.Width;
    Height := WizardForm.PreparingMemo.Height;        
    Text   := WizardForm.PreparingMemo.Text;
    ReadOnly   := True;
    ScrollBars := ssVertical;
  end;
end;

//////////////////////////////////////////////////////////////////////////////
// Importing LoadSkin API from ISSkin.dll or ISSkinU.dll 
// Char/String PAnsiChar / AnsiString
// Due to API changes in unicode delphi 2009 we had to change from
// String (ISSkinU.dll) to AnsiString (ISSkin.dll) ...
//
// For ISSkin:
// procedure LoadSkin(lpszPath: AnsiString; lpszIniFileName: AnsiString);
// external 'LoadSkin@files:ISSkin.dll stdcall delayload';
// For ISSkinU:
procedure LoadSkin(lpszPath: String; lpszIniFileName: String);
external 'LoadSkin@files:ISSkinU.dll stdcall delayload';

// Importing UnloadSkin API
procedure UnloadSkin();
// For ISSkinU
external 'UnloadSkin@files:ISSkinU.dll stdcall delayload';
// For ISSkin
// external 'UnloadSkin@files:ISSkin.dll stdcall delayload';

// Importing ShowWindow Windows API from User32.DLL
function ShowWindow(hWnd: Integer; uType: Integer): Integer;
external 'ShowWindow@user32.dll stdcall delayload';

//////////////////////////////////////////////////////////////////////////////
function GetGnuPG2Installed(Param: String): String;
// 
//  HKEY_LOCAL_MACHINE\Software\WOW6432Node\GnuPG
//  Install Directory    REG_SZ    C:\Program Files (x86)\Gpg4win\..\GnuPG
//  
//  HKEY_LOCAL_MACHINE\Software\WOW6432Node\Gpg4win
//  Install Directory    REG_SZ    C:\Program Files (x86)\Gpg4win

var
  Install_Directory_GnuPG2: String;
  aExecFile: String;
  
begin
    if RegQueryStringValue(HKEY_LOCAL_MACHINE, 'Software\WOW6432Node\GnuPG',
        'Install Directory', Install_Directory_GnuPG2) then begin

        // Value was read successfully
        Log('GetGnuPG2Installed(): Install Directory of GnuPG2 exist in Registry: ' + Install_Directory_GnuPG2);
        aExecFile := Install_Directory_GnuPG2 + '\bin\gpg.exe';

        if FileExists(aExecFile) then begin
           Log('GetGnuPG2Installed(): File gpg.exe exist in: ' + aExecFile);
           Result := Install_Directory_GnuPG2;
        end else begin
           Log('GetGnuPG2Installed(): File gpg.exe does not exist in: ' + aExecFile);
        end;
    end else begin
        // Value was NOT read successfully
        Log('GetGnuPG2Installed(): Install Directory of GnuPG2 does not exist in Registry: ' + Install_Directory_GnuPG2);
    end;
end;

//////////////////////////////////////////////////////////////////////////////
function GetGpg4WinInstalled(Param: String): String;
// 
//  HKEY_LOCAL_MACHINE\Software\WOW6432Node\GnuPG
//  Install Directory    REG_SZ    C:\Program Files (x86)\Gpg4win\..\GnuPG
//  
//  HKEY_LOCAL_MACHINE\Software\WOW6432Node\Gpg4win
//  Install Directory    REG_SZ    C:\Program Files (x86)\Gpg4win

var
  Install_Directory_Gpg4win: String;
  aExecFile: String;
  
begin
    if RegQueryStringValue(HKEY_LOCAL_MACHINE, 'Software\WOW6432Node\Gpg4win',
        'Install Directory', Install_Directory_Gpg4win) then begin

        // Value was read successfully
        Log('GetGpg4WinInstalled(): Install Directory of Gpg4win exist in Registry: ' + Install_Directory_Gpg4win);
        aExecFile := Install_Directory_Gpg4win + '\bin\kleopatra.exe';

        if FileExists(aExecFile) then begin
           Log('GetGpg4WinInstalled(): File kleopatra.exe exist in: ' + aExecFile);
           Result := Install_Directory_Gpg4win;
        end else begin
           Log('GetGpg4WinInstalled(): File kleopatra.exe does not exist in: ' + aExecFile);
        end;
    end else begin
        // Value was NOT read successfully
        Log('GetGpg4WinInstalled(): Install Directory of Gpg4win does not exist in Registry: ' + Install_Directory_Gpg4win);
    end;
end;

//////////////////////////////////////////////////////////////////////////////
function IsGnuPG2Installed(): Boolean;
// 
//  HKEY_LOCAL_MACHINE\Software\WOW6432Node\GnuPG
//  Install Directory    REG_SZ    C:\Program Files (x86)\Gpg4win\..\GnuPG
//  
//  HKEY_LOCAL_MACHINE\Software\WOW6432Node\Gpg4win
//  Install Directory    REG_SZ    C:\Program Files (x86)\Gpg4win

var
  Install_Directory_GnuPG2: String;
  aExecFile: String;
  
begin
    if RegQueryStringValue(HKEY_LOCAL_MACHINE, 'Software\WOW6432Node\GnuPG',
        'Install Directory', Install_Directory_GnuPG2) then begin

        // Value was read successfully
        Log('IsGnuPG2Installed(): Install Directory of GnuPG2 exist in Registry: ' + Install_Directory_GnuPG2);
        aExecFile := Install_Directory_GnuPG2 + '\bin\gpg.exe';

        if FileExists(aExecFile) then begin
           Log('IsGnuPG2Installed(): File gpg.exe exist in: ' + aExecFile);
           Result := True;
        end else begin
           Log('IsGnuPG2Installed(): File gpg.exe does not exist in: ' + aExecFile);
           Result := False;
        end;
    end else begin
        // Value was NOT read successfully
        Log('IsGnuPG2Installed(): Install Directory of GnuPG2 does not exist in Registry: ' + Install_Directory_GnuPG2);
        Result := False;
    end;
end;

//////////////////////////////////////////////////////////////////////////////
function IsGpg4WinInstalled(): Boolean;
// 
//  HKEY_LOCAL_MACHINE\Software\WOW6432Node\GnuPG
//  Install Directory    REG_SZ    C:\Program Files (x86)\Gpg4win\..\GnuPG
//  
//  HKEY_LOCAL_MACHINE\Software\WOW6432Node\Gpg4win
//  Install Directory    REG_SZ    C:\Program Files (x86)\Gpg4win

var
  Install_Directory_Gpg4win: String;
  aExecFile: String;
  
begin
    if RegQueryStringValue(HKEY_LOCAL_MACHINE, 'Software\WOW6432Node\Gpg4win',
        'Install Directory', Install_Directory_Gpg4win) then begin

        // Value was read successfully
        Log('IsGpg4WinInstalled(): Install Directory of Gpg4win exist in Registry: ' + Install_Directory_Gpg4win);
        aExecFile := Install_Directory_Gpg4win + '\bin\kleopatra.exe';

        if FileExists(aExecFile) then begin
           Log('IsGpg4WinInstalled(): File kleopatra.exe exist: ' + aExecFile);
           Result := True;
        end else begin
           Log('IsGpg4WinInstalled(): File kleopatra.exe does not exist in: ' + Install_Directory_Gpg4win);
           Result := False;
        end;
    end else begin
        // Value was NOT read successfully
        Log('IsGpg4WinInstalled(): Install Directory of Gpg4win does not exist in Registry: ' + Install_Directory_Gpg4win);
        Result := False;
    end;
end;

//////////////////////////////////////////////////////////////////////////////
function GetGpg4WinVersion(Param: String): String;
// 
//  HKEY_LOCAL_MACHINE\Software\WOW6432Node\GnuPG
//  Install Directory    REG_SZ    C:\Program Files (x86)\Gpg4win\..\GnuPG
//  
//  HKEY_LOCAL_MACHINE\Software\WOW6432Node\Gpg4win
//  Install Directory    REG_SZ    C:\Program Files (x86)\Gpg4win

var
  Gpg4win_Version: String;
  Install_Directory_Gpg4win: String;
  aExecFile: String;

begin
    if RegQueryStringValue(HKEY_LOCAL_MACHINE, 'Software\WOW6432Node\Gpg4win',
        'Install Directory', Install_Directory_Gpg4win) then begin

        // Value was read successfully
        Log('GetGpg4WinVersion(): Install Directory of Gpg4win exist in Registry: ' + Install_Directory_Gpg4win);
        aExecFile := Install_Directory_Gpg4win + '\bin\kleopatra.exe';

        if FileExists(aExecFile) then begin
           Log('GetGpg4WinVersion(): File "kleopatra.exe" exist: ' + aExecFile);
           if GetVersionNumbersString(aExecFile, Gpg4win_Version) then begin
              Log('GetGpg4WinVersion(): File "kleopatra.exe" Version-Number: ' + '"' + Gpg4win_Version + '"');
              Result := Gpg4win_Version;
           end else begin
              Log('GetGpg4WinVersion(): Something went wrong in getting Version-Number of "kleopatra.exe": ' + '"' + Gpg4win_Version + '"');
           end;
        end else begin
           Log('GetGpg4WinVersion(): File "kleopatra.exe" does not exist in: ' + '"' + Install_Directory_Gpg4win + '"');
        end;
    end else begin
        // Value was NOT read successfully
        Log('GetGpg4WinVersion(): Install Directory of Gpg4win does not exist in Registry: ' + Install_Directory_Gpg4win);
    end;
end;

//////////////////////////////////////////////////////////////////////////////
function GetGpgVersion(Param: String): String;
// 
//  HKEY_LOCAL_MACHINE\Software\WOW6432Node\GnuPG
//  Install Directory    REG_SZ    C:\Program Files (x86)\Gpg4win\..\GnuPG
//  
//  HKEY_LOCAL_MACHINE\Software\WOW6432Node\Gpg4win
//  Install Directory    REG_SZ    C:\Program Files (x86)\Gpg4win

var
  Gpg_Version: String;
  Install_Directory_Gpg: String;
  aExecFileG: String;

begin
    if RegQueryStringValue(HKEY_LOCAL_MACHINE, 'Software\WOW6432Node\GnuPG',
        'Install Directory', Install_Directory_Gpg) then begin

        // Value was read successfully
        Log('GetGpgVersion(): Install Directory of GnuPG exist in Registry: ' + Install_Directory_Gpg);
        aExecFileG := Install_Directory_Gpg + '\bin\gpg.exe';

        if FileExists(aExecFileG) then begin
           Log('GetGpgVersion(): File "gpg.exe" exist: ' + aExecFileG);
           if GetVersionNumbersString(aExecFileG, Gpg_Version) then begin
              Log('GetGpgVersion(): File "gpg.exe" Version-Number: ' + '"' + Gpg_Version + '"');
              Result := Gpg_Version;
           end else begin
              Log('GetGpgVersion(): Something went wrong in getting Version-Number of "gpg.exe": ' + '"' + Gpg_Version + '"');
           end;
        end else begin
           Log('GetGpgVersion(): File "gpg.exe" does not exist in: ' + '"' + Install_Directory_Gpg + '"');
        end;
    end else begin
        // Value was NOT read successfully
        Log('GetGpgVersion(): Install Directory of GnuPG does not exist in Registry: ' + Install_Directory_Gpg);
    end;
end;

//////////////////////////////////////////////////////////////////////////////
function Is3116(): Boolean;
// Check for Version 3.1.16
var
  MyResultGpg4WinV: String;
  MyResultGetGpg4WinV: String;

begin
    // Check correct version of Gpg4Win has to be installed.
    MyResultGpg4WinV := ExpandConstant('{#Gpg4WinVersion}');
    MyResultGetGpg4WinV := GetGpg4WinVersion('');

  	if (MyResultGpg4WinV = MyResultGetGpg4WinV) then begin
      Log('Is3116(): Expected "Gpg4Win-Version": ' + MyResultGpg4WinV);
      Log('Is3116(): Received "Gpg4Win-Version": ' + MyResultGetGpg4WinV);
      Log('"Gpg4Win-Version" match ...');
      Result := True;
    end else begin
      Log('Is3116(): Expected "Gpg4Win-Version": ' + MyResultGpg4WinV);
      Log('Is3116(): Received "Gpg4Win-Version": ' + MyResultGetGpg4WinV);
      Log('"Gpg4Win-Version" mismatch ...');
      Result := False;
    end;
end;

//////////////////////////////////////////////////////////////////////////////
function Is31XX(): Boolean;
// Check for Version 3.x.xx (#Gpg4WinVersionB)
var
  MyResultGpg4WinVB: String;
  MyResultGetGpg4WinVB: String;

begin
    // Check correct version of Gpg4Win has to be installed.
    MyResultGpg4WinVB := ExpandConstant('{#Gpg4WinVersionB}');
    MyResultGetGpg4WinVB := GetGpg4WinVersion('');

  	if (MyResultGpg4WinVB = MyResultGetGpg4WinVB) then begin
      Log('Is31XX(): Expected "Gpg4Win-Version": ' + MyResultGpg4WinVB);
      Log('Is31XX(): Received "Gpg4Win-Version": ' + MyResultGetGpg4WinVB);
      Log('"Gpg4Win-Version" match ...');
      Result := True;
    end else begin
      Log('Is31XX(): Expected "Gpg4Win-Version": ' + MyResultGpg4WinVB);
      Log('Is31XX(): Received "Gpg4Win-Version": ' + MyResultGetGpg4WinVB);
      Log('"Gpg4Win-Version" mismatch ...');
      Result := False;
    end;
end;

//////////////////////////////////////////////////////////////////////////////
function IsGpgVer(): Boolean;
// Check for GnuPGVersion (#GpgVersion)
var
  MyResultGpgVersion: String;
  MyResultGetGpgVersion: String;

begin
    // Check correct version of Gpg4Win has to be installed.
    MyResultGpgVersion := ExpandConstant('{#GpgVersion}');
    MyResultGetGpgVersion := GetGpgVersion('');

  	if (MyResultGpgVersion = MyResultGetGpgVersion) then begin
      Log('IsGpgVer(): Expected "Gpg-Version": ' + MyResultGpgVersion);
      Log('IsGpgVer(): Received "Gpg-Version": ' + MyResultGetGpgVersion);
      Log('"Gpg-Version" match ...');
      Result := True;
    end else begin
      Log('IsGpgVer(): Expected "Gpg4Win-Version": ' + MyResultGpgVersion);
      Log('IsGpgVer(): Received "Gpg4Win-Version": ' + MyResultGetGpgVersion);
      Log('"Gpg-Version" mismatch ...');
      Result := False;
    end;
end;

//////////////////////////////////////////////////////////////////////////////
function CheckSRPIsEnabled(): Boolean;
//
// Checking if Software Restriction-Policy (SRP) is enabled
// 
// Used functions:
// function RegQueryDWordValue(const RootKey: Integer; const SubKeyName, \
//                 ValueName: String; var ResultDWord: Cardinal): Boolean;
//
// Checking for:
// [HKLM\SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers]
// "DefaultLevel"=dword:00040000 ; SRP disabled
// "DefaultLevel"=dword:00000000 ; SRP enabled (or when not exist)
//
// #############################################
// # const section for documentation here only #
// #############################################
// const
//  SrpV1CodeIdentifiersKey = 'SOFTWARE\Policies\Microsoft\Windows\Safer\CodeIdentifiers';
//
// Three states are possible:
// - DWORD DefaultLevel is 0x00040000  ---> SRP is disabled
// - DWORD DefaultLevel is 0x00000000  ---> SRP is enabled
// - DWORD DefaultLevel is not defined ---> SRP is enabled

var
  SRPenabled : Cardinal;
  SRPenabledS: String;

begin
  Log('CheckSRPIsEnabled(): Checking if Software Restriction-Policy (SRP) is enabled ...');
  if RegQueryDWordValue(HKEY_LOCAL_MACHINE, SrpV1CodeIdentifiersKey, 'DefaultLevel', SRPenabled) then
  begin // The value exist
    // Format Cardinal to String with "hex 8 digit notation"
    SRPenabledS := Format('%.8x', [SRPenabled]);

    Log('CheckSRPIsEnabled(): Software Restriction-Policy (SRP) is defined:');
    Log(SrpV1CodeIdentifiersKey + '\DefaultLevel = ' + '0x' + SRPenabledS);
    if SRPenabled = $00000000 then
    begin
      // The value is enabled (0x00000000)
      Log('CheckSRPIsEnabled(): Software Restriction-Policy (SRP) is enabled: ' + '0x' + SRPenabledS);
      Result := True;
    end
    else
    if SRPenabled = $00040000 then
    begin
      // The value is disabled (0x00040000)
      Log('CheckSRPIsEnabled(): Software Restriction-Policy (SRP) is disabled: ' + '0x' + SRPenabledS);
      Result := False;
    end
    else
    begin
      // The value is nothing from the above defined ones
      Log('CheckSRPIsEnabled(): Software Restriction-Policy (SRP) has no expected value: ' + '0x' + SRPenabledS);
      Log('CheckSRPIsEnabled(): I assume, that Software Restriction-Policy (SRP) is enabled !!');
      Result := True;
    end;
  end 
  else
  begin
    // The value is not defined
    Log('CheckSRPIsEnabled(): "' + SrpV1CodeIdentifiersKey + '\DefaultLevel' + '"' + ' does not exist.');
    Log('CheckSRPIsEnabled(): Software Restriction-Policy (SRP) is enabled.');
    Result := True;
  end;
end;

//////////////////////////////////////////////////////////////////////////////
function EnforcementModeEXEActive(): Boolean;
//
// Checking if Applocker EnforcementMode for EXE is defined
//
// Used functions:
// function RegQueryDWordValue(const RootKey: Integer; const SubKeyName, \
//                 ValueName: String; var ResultDWord: Cardinal): Boolean;
// function RegGetSubkeyNames(const RootKey: Integer; const SubKeyName: String; \
//                 var Names: TArrayOfString): Boolean;
// function RegQueryStringValue(const RootKey: Integer; const SubKeyName, \
//                 ValueName: String; var ResultStr: String): Boolean;
//
// #############################################
// # const section for documentation here only #
// #############################################
// const
//  SrpV2ExeKey    = 'SOFTWARE\Policies\Microsoft\Windows\SrpV2\Exe';
//  SrpV2ScriptKey = 'SOFTWARE\Policies\Microsoft\Windows\SrpV2\Script';
//
// Three states are possible:
// - DWORD EnforcementMode is 1 -------------> Enforcement is enabled
// - DWORD EnforcementMode is not defined ---> Enforcement is enabled
// - DWORD EnforcementMode is 0 -------------> Enforcement is disabled
//
// In every state I'm checking if subkeys AND their "Value" string-values
// exist. If this is True, then I'm writing the Applocker rules for
// this installer. So actually I only have to do one simple check for
// subkeys and write the Appocker rules if subkeys are existent; but
// anyway ... i will do this with 3 "if ... then" - statements only
// for testing :-)
//

var
  EnforcementModeEXEVar : Cardinal;
  SubKeys: TArrayOfString;
  S: string;
  V: string;
  I: Integer;

begin
  Log('EnforcementModeEXEActive(): Checking if Applocker EnforcementMode for EXE is defined');
  if RegQueryDWordValue(HKEY_LOCAL_MACHINE, SrpV2ExeKey, 'EnforcementMode', EnforcementModeEXEVar) then
  begin // The value exist
    Log(SrpV2ExeKey + '\EnforcementMode = ' + IntToStr(EnforcementModeEXEVar));
    Log('EnforcementModeEXEActive(): Applocker EnforcementMode for EXE is defined.');
    if EnforcementModeEXEVar = $1 then
    begin
      // The value is enabled (0x00000001)
      Log('EnforcementModeEXEActive(): EnforcementMode for EXE is in DWORD enabled: ' + IntToStr(EnforcementModeEXEVar));

      if RegGetSubkeyNames(HKEY_LOCAL_MACHINE, SrpV2ExeKey, SubKeys) then
      begin
        S := '';
        V := '';
        for I := 0 to GetArrayLength(SubKeys)-1 do
          if RegQueryStringValue(HKEY_LOCAL_MACHINE, SrpV2ExeKey + '\' + SubKeys[I], 'Value', V) then
          begin
            S := S + SubKeys[I] + #13#10;
            Log('EnforcementModeEXEActive(): Subkeys found under: ' + SrpV2ExeKey);
            Log('EnforcementModeEXEActive(): List of subkeys:'#13#10 + S);
            Result := True;
          end;
        end else
        begin
          Log('EnforcementModeEXEActive(): No subkeys found under: ' + SrpV2ExeKey);
          Result := False;
      end;

    end
    else
    begin
      // The value is disabled (0x00000000)
      Log('EnforcementModeEXEActive(): EnforcementMode for EXE is in DWORD disabled: ' + IntToStr(EnforcementModeEXEVar));

      if RegGetSubkeyNames(HKEY_LOCAL_MACHINE, SrpV2ExeKey, SubKeys) then
      begin
        S := '';
        V := '';
        for I := 0 to GetArrayLength(SubKeys)-1 do
          if RegQueryStringValue(HKEY_LOCAL_MACHINE, SrpV2ExeKey + '\' + SubKeys[I], 'Value', V) then
          begin
            S := S + SubKeys[I] + #13#10;
            Log('EnforcementModeEXEActive(): Subkeys found under: ' + SrpV2ExeKey);
            Log('EnforcementModeEXEActive(): List of subkeys:'#13#10 + S);
            Result := True;
          end;
        end else
        begin
          Log('EnforcementModeEXEActive(): No subkeys found under: ' + SrpV2ExeKey);
          Result := False;
      end;

    end
  end
  else // The value doesn't exist (so per default EnforcementMode is enabled)
  begin
    Log('EnforcementModeEXEActive(): Could not access ' + SrpV2ExeKey + '\EnforcementMode');
    Log('EnforcementModeEXEActive(): EnforcementMode DWORD Value does not exist under EXE here.');
    Log('EnforcementModeEXEActive(): Applocker EnforcementMode for EXE is not defined (enabled).');

      if RegGetSubkeyNames(HKEY_LOCAL_MACHINE, SrpV2ExeKey, SubKeys) then
      begin
        S := '';
        V := '';
        for I := 0 to GetArrayLength(SubKeys)-1 do
          if RegQueryStringValue(HKEY_LOCAL_MACHINE, SrpV2ExeKey + '\' + SubKeys[I], 'Value', V) then
          begin
            S := S + SubKeys[I] + #13#10;
            Log('EnforcementModeEXEActive(): Subkeys found under: ' + SrpV2ExeKey);
            Log('EnforcementModeEXEActive(): List of subkeys:'#13#10 + S);
            Result := True;
          end;
        end else
        begin
          Log('EnforcementModeEXEActive(): No subkeys found under: ' + SrpV2ExeKey);
          Result := False;
      end;

  end;
end;

//////////////////////////////////////////////////////////////////////////////
function EnforcementModeScriptActive(): Boolean;
//
// Checking if Applocker EnforcementMode for Script is defined
//
// Used functions:
// function RegQueryDWordValue(const RootKey: Integer; const SubKeyName, \
//                 ValueName: String; var ResultDWord: Cardinal): Boolean;
// function RegGetSubkeyNames(const RootKey: Integer; const SubKeyName: String; \
//                 var Names: TArrayOfString): Boolean;
// function RegQueryStringValue(const RootKey: Integer; const SubKeyName, \
//                 ValueName: String; var ResultStr: String): Boolean;
//
// #############################################
// # const section for documentation here only #
// #############################################
// const
//  SrpV2ExeKey    = 'SOFTWARE\Policies\Microsoft\Windows\SrpV2\Exe';
//  SrpV2ScriptKey = 'SOFTWARE\Policies\Microsoft\Windows\SrpV2\Script';
//
// Three states are possible:
// - DWORD EnforcementMode is 1 -------------> Enforcement is enabled
// - DWORD EnforcementMode is not defined ---> Enforcement is enabled
// - DWORD EnforcementMode is 0 -------------> Enforcement is disabled
//
// In every state I'm checking if subkeys AND their "Value" string-values
// exist. If this is True, then I'm writing the Applocker rules for
// this installer. So actually I only have to do one simple check for
// subkeys and write the Appocker rules if subkeys are existent; but
// anyway ... i will do this with 3 "if ... then" - statements only
// for testing :-)
//

var
  EnforcementModeScriptVar : Cardinal;
  SubKeys: TArrayOfString;
  S: string;
  V: string;
  I: Integer;

begin
  Log('EnforcementModeScriptActive(): Checking if Applocker EnforcementMode for Script is defined');
  if RegQueryDWordValue(HKEY_LOCAL_MACHINE, SrpV2ScriptKey, 'EnforcementMode', EnforcementModeScriptVar) then
  begin // The value exist
    Log(SrpV2ScriptKey + '\EnforcementMode = ' + IntToStr(EnforcementModeScriptVar));
    Log('EnforcementModeScriptActive(): Applocker EnforcementMode for Script is defined.');
    if EnforcementModeScriptVar = $1 then
    begin
      // The value is enabled (0x00000001)
      Log('EnforcementModeScriptActive(): EnforcementMode for Script is in DWORD enabled: ' + IntToStr(EnforcementModeScriptVar));

      if RegGetSubkeyNames(HKEY_LOCAL_MACHINE, SrpV2ScriptKey, SubKeys) then
      begin
        S := '';
        V := '';
        for I := 0 to GetArrayLength(SubKeys)-1 do
          if RegQueryStringValue(HKEY_LOCAL_MACHINE, SrpV2ScriptKey + '\' + SubKeys[I], 'Value', V) then
          begin
            S := S + SubKeys[I] + #13#10;
            Log('EnforcementModeScriptActive(): Subkeys found under: ' + SrpV2ScriptKey);
            Log('EnforcementModeScriptActive(): List of subkeys:'#13#10 + S);
            Result := True;
          end;
        end else
        begin
          Log('EnforcementModeScriptActive(): No subkeys found under: ' + SrpV2ScriptKey);
          Result := False;
      end;

    end
    else
    begin
      // The value is disabled (0x00000000)
      Log('EnforcementModeScriptActive(): EnforcementMode for Script is in DWORD disabled: ' + IntToStr(EnforcementModeScriptVar));

      if RegGetSubkeyNames(HKEY_LOCAL_MACHINE, SrpV2ScriptKey, SubKeys) then
      begin
        S := '';
        V := '';
        for I := 0 to GetArrayLength(SubKeys)-1 do
          if RegQueryStringValue(HKEY_LOCAL_MACHINE, SrpV2ScriptKey + '\' + SubKeys[I], 'Value', V) then
          begin
            S := S + SubKeys[I] + #13#10;
            Log('EnforcementModeScriptActive(): Subkeys found under: ' + SrpV2ScriptKey);
            Log('EnforcementModeScriptActive(): List of subkeys:'#13#10 + S);
            Result := True;
          end;
        end else
        begin
          Log('EnforcementModeScriptActive(): No subkeys found under: ' + SrpV2ScriptKey);
          Result := False;
      end;

    end
  end
  else // The value doesn't exist (so per default EnforcementMode is enabled)
  begin
    Log('EnforcementModeScriptActive(): Could not access ' + SrpV2ScriptKey + '\EnforcementMode');
    Log('EnforcementModeScriptActive(): EnforcementMode DWORD Value does not exist under Script here.');
    Log('EnforcementModeScriptActive(): Applocker EnforcementMode for Script is not defined (enabled).');

      if RegGetSubkeyNames(HKEY_LOCAL_MACHINE, SrpV2ScriptKey, SubKeys) then
      begin
        S := '';
        V := '';
        for I := 0 to GetArrayLength(SubKeys)-1 do
          if RegQueryStringValue(HKEY_LOCAL_MACHINE, SrpV2ScriptKey + '\' + SubKeys[I], 'Value', V) then
          begin
            S := S + SubKeys[I] + #13#10;
            Log('EnforcementModeScriptActive(): Subkeys found under: ' + SrpV2ScriptKey);
            Log('EnforcementModeScriptActive(): List of subkeys:'#13#10 + S);
            Result := True;
          end;
        end else
        begin
          Log('EnforcementModeScriptActive(): No subkeys found under: ' + SrpV2ScriptKey);
          Result := False;
      end;

  end;
end;


//////////////////////////////////////////////////////////////////////////////
// Check for existence of SendTo-dir (Windows XP-style):
// %USERPROFILE%\SendTo
// Borrowed som code from:
// https://sourceforge.net/p/qucs/git/ci/master/tree/contrib/windows/innosetup/qucs_and_tools.iss
//
// %USERPROFILE\SendTo is a Junction point to
// %USERPROFILE\AppData\Roaming\Microsoft\Windows\SendTo under Windows 7/8/10.
// So this will also get a TRUE result under Win 7/8/10.
// We have to check for %USERPROFILE\AppData\Roaming\Microsoft\Windows\SendTo under
// WinXP in order to return a TRUE result on no existence because the Check:-function
// above in installer-sections will allways be evaluated on TRUE values. So we have to
// build a TRUE value on no existence here; otherwise we will get a double positive
// evaluation with the SendToDirCheck()-function below.
//
// function SendToDirCheckXP(): Boolean;
// var
//   ProfDirXP : String;
//   SendToDirXP : String;
// begin
//   ProfDirXP := GetEnv('USERPROFILE');
//   SendToDirXP := ProfDirXP + '\AppData\Roaming\Microsoft\Windows\SendTo';
//   // SendToDirXP := ProfDirXP + '\SendTo';
//   if not DirExists(SendToDirXP) then
//   // if DirExists(SendToDirXP) then
//   begin
//     Log('SendToDirCheckXP: - BEGIN -');
//     Log('Win 7/8/10-style SendTo-directory: ' + SendToDirXP + ' does not exist.');
//     Log('Win 7/8/10-style SendTo-directory: assuming Win XP-style SendTo-directory.');
//     Log('SendToDirCheckXP: -- END --');
//     Result := True;
//   end
//   else
//   begin
//     Result := False;
//   end;
// end;


//////////////////////////////////////////////////////////////////////////////
// Disable installation-sound, when "/BASSSOUND-" string was provided
// in commandline-parameters. For more examples in commandline-parsing, look
// here: http://svn.assembla.com/svn/turbocss/bin/Installer/Include/
function SkipSound(): Boolean;
begin
  if Pos('/BASSSOUND-', UpperCase(GetCmdTail)) > 0 then begin
    Log('BASS_Init disabled from commandline ...');
    Result := True;
  end else begin
    Log('BASS_Init not disabled from commandline ...');
    Result := False;
  end;
end;

//////////////////////////////////////////////////////////////////////////////
// ###########################################################################
// !! DISABLED HERE, BECAUSE "ISTask.dll" CANNOT DETECT AND KILLE TASKS     !!
// !! OF OTHER LOGGED-IN USERS IN OTHER X64-SESSIONS ON Windows 10          !!
// ###########################################################################
// !! LEFT IN CODE HERE ONLY FOR DOCUMENTATION                              !!
// ###########################################################################
// CHECK AND KILL PROCESSES WHEN RUNNING                                 BEGIN
// ###########################################################################
// For importing ANSI Windows API calls with the Unicode compiler, we have to
// either upgrade to the 'W' Unicode API call or change the parameters from
// 'String' or 'PChar' to 'AnsiString'. So we're using 'AnsiString' here.
// ###########################################################################
// function RunTask(FileName: AnsiString; bFullpath: Boolean): Boolean;
// external 'RunTask@{tmp}\ISTask.dll stdcall delayload';
// 
// function KillTask(ExeFileName: AnsiString): Integer;
// external 'KillTask@{tmp}\ISTask.dll stdcall delayload';
// 
// function RunTasks(Tasks: AnsiString; bFullpath: Boolean; CheckAll: Boolean): Boolean;
// var
//   sl: TStringList;
//   i: Integer;
// begin
//   Result := False;
//   sl := TStringList.Create;
//   try
//     sl.Text := Tasks;
//     if sl.Count > 0 then
//       for i := 0 to sl.Count -1 do 
//       begin
//         if CheckAll then
//         begin
//           if i = 0 then Result := RunTask(sl[i], bFullpath)
//           else
//             Result := Result and RunTask(sl[i], bFullpath);
//         end
//         else
//         if RunTask(sl[i], bFullpath) then
//         begin
//           Result := True;
//           Break;
//         end;
//       end;
//   finally
//     sl.Free;
//   end;
// end;
// 
// procedure KillTasks(Tasks: AnsiString);
// var
//   sl: TStringList;
//   i: Integer;
// begin
//   sl := TStringList.Create;
//   try
//     sl.Text := Tasks;
//     if sl.Count > 0 then
//       for i := 0 to sl.Count -1 do KillTask(sl[i]);
//   finally
//     sl.Free;
//   end;
// end;
// ###########################################################################
// CHECK AND KILL PROCESSES WHEN RUNNING                                   END
// ###########################################################################

//////////////////////////////////////////////////////////////////////////////
// ###########################################################################
// KILL PROCESSES WHEN RUNNING                                           BEGIN
// ###########################################################################
// Using function Exec():
// function Exec(const Filename, Params, WorkingDir: String; \
//    const ShowCmd: Integer; const Wait: TExecWait; \
//    var ResultCode: Integer): Boolean;
//
procedure TaskKill(Tasks: String);
var
  ResultCode: Integer;
  sl: TStringList;
  i: Integer;
begin
  // Launch "Taskkill.exe" and wait for it to terminate ...
  sl := TStringList.Create;
  try
    sl.Text := Tasks;
    if sl.Count > 0 then
      for i := 0 to sl.Count -1 do begin
        if Exec(ExpandConstant('{sys}\taskkill.exe'), '/f /im ' + '"' + sl[i] + '"', ExpandConstant('{sys}'), SW_HIDE, ewWaitUntilTerminated, ResultCode) then begin
          // handle success if necessary; ResultCode contains the exit code
          if ResultCode > 0 then begin
            Log('TaskKill on:' + ' "' + sl[i] + '" ' + 'failed (not running ?), exit-status: ' + IntToStr(ResultCode));
          end else begin
            Log('TaskKill on:' + ' "' + sl[i] + '" ' + 'successfully, exit-status: ' + IntToStr(ResultCode));
          end;
        end else begin
          // handle failure if necessary; ResultCode contains the error code
          Log('Error running "TaskKill.exe" on:' + ' "' + sl[i] + '" ' + ', exit-status: ' + IntToStr(ResultCode));
        end;
      end;
  finally
    sl.Free;
  end;
end;
// ###########################################################################
// KILL PROCESSES WHEN RUNNING                                             END
// ###########################################################################

// Function for shortening message request
function cm(Message: String): String; Begin Result:= ExpandConstant('{cm:'+ Message +'}') End;

//////////////////////////////////////////////////////////////////////////////
// ###########################################################################
// UPDATE GNUPG PACKAGE BY INSTALLER                                     BEGIN
// ###########################################################################
// Using function Exec():
procedure GnuPGUpdate;
var
  ResultCode: Integer;
begin
    // Running GnuPG-Installer (Update) before installing any file
    ExtractTemporaryFile('gnupg-w32-update.exe')
    GpgUpdateName := ExpandConstant('{tmp}\gnupg-w32-update.exe');
    if (FileExists(GpgUpdateName) = True) then begin
      Log('GnuPG-Installer (Update) EXIST in:');
      Log(GpgUpdateName);
      Log('Executing GnuPG-Installer (Update) silently and wait until termination ...');
      WizardForm.StatusLabel.Caption := cm('installgnupgupdate');
      // Exec(GpgUpdateName, '/S', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
      if Exec(GpgUpdateName, '/S', '', SW_HIDE, ewWaitUntilTerminated, ResultCode) then begin
         // handle success if necessary; ResultCode contains the exit code
        if ResultCode > 0 then begin
          Log('GnuPG-Installer (Update) failed ! Exit-Status: ' + IntToStr(ResultCode));
          WizardForm.StatusLabel.Caption := cm('installgnupgerror');
        end else begin
          Log('GnuPG-Installer (Update) successfully ! Exit-Status: ' + IntToStr(ResultCode));
          WizardForm.StatusLabel.Caption := cm('installcont');
        end;
      end else begin
        // handle failure if necessary; ResultCode contains the error code
        Log('Error running:' + ' "' + GpgUpdateName + '" ' + ', Exit-Status: ' + IntToStr(ResultCode));
        WizardForm.StatusLabel.Caption := cm('installgnupgerror');
      end;
    end else begin
      Log('GnuPG-Installer (Update) DOES NOT EXIST in:');
      Log(GpgUpdateName);
      Log('Skipping GnuPG-Installer (Update) !!');
    end;
end;
// ###########################################################################
// UPDATE GNUPG PACKAGE BY INSTALLER                                       END
// ###########################################################################


// ###########################################################################
// MAIN() INSTALLER SEQUENCE                                             BEGIN
// ###########################################################################


//////////////////////////////////////////////////////////////////////////////
function InitializeSetup(): Boolean;
begin

  // Prevent installer from running multiple
  // installation-instances at the same time.
  Log('Check for existing (running) Setup-MUTEX with name: ' + '"' + ExpandConstant('{#MySetupMutex}') + '"' + ' or ' + '"' + 'Global\' + ExpandConstant('{#MySetupMutex}') + '"' + ' ...');
  if (CheckForMutexes(ExpandConstant('{#MySetupMutex}') + ',' + 'Global\' + ExpandConstant('{#MySetupMutex}')) = True) then begin
    Log('Setup-MUTEX with name: ' + '"' + ExpandConstant('{#MySetupMutex}') + ' or ' + 'Global\' + ExpandConstant('{#MySetupMutex}') + '"' + ' already exist !');
    if (Pos('/SILENT', UpperCase(GetCmdTail)) > 0) OR (Pos('/VERYSILENT', UpperCase(GetCmdTail)) > 0) then begin
      Log('MsgBox: "Error-Message" was disabled, due to /SILENT and /VERYSILENT switches !!');
    end else begin
      MsgBox(ExpandConstant('{cm:alreadyrunning}'), mbInformation, MB_OK);
    end;
    Log('Aborting installation, to prevent running multiple instances !');
    Result := False;
    Abort;
  end else begin
    Log('Setup-MUTEX with name: ' + '"' + ExpandConstant('{#MySetupMutex}') + '"' + ' or ' + '"' + 'Global\' + ExpandConstant('{#MySetupMutex}') + '"' + ' not running, continuing ...');
    Log('Creating Setup-MUTEX with name: ' + '"' + ExpandConstant('{#MySetupMutex}') + '"' + ' and ' + '"' + 'Global\' + ExpandConstant('{#MySetupMutex}') + '"');
    CreateMutex(ExpandConstant('{#MySetupMutex}'));
    CreateMutex('Global\' + ExpandConstant('{#MySetupMutex}'));
  end;

  ExtractTemporaryFile('bass.dll');

  ExtractTemporaryFile('sound.it');
  SndName := ExpandConstant('{tmp}\sound.it');

  // To force this to be an update, set MyAppUPDATE to tue
  // otherwise we will check for GNUPG-REG-Key existence below.
  // If a prior installation was successfull, this stuff
  // of installation will be canceled.

  // This is an update
  MyAppUPDATE := true
  // This is a base installation
  // MyAppUPDATE := false

  try

  // --- BEGIN ---
  // Disable installation-sound, when "/BASSSOUND-" string
  // was provided in commandline-parameters.

  // Check for BASSSOUND-Option
  // if SkipSound() = False then begin
  // Check for BASSSOUND-Option AND Soundfile
  if (SkipSound() = False) AND (FileExists(SndName) = True) then begin
    Log('Installation-Sound not diabled AND Soundfile exist in:');
    Log(SndName);

    BASS_Version_Result := BASS_GetVersion;

  	if (BASS_GetVersion <> BASSVERSION) then begin
      Log('BASS_GetVersion: Version decimal: '+IntToStr(BASS_Version_Result)+' ...');
      Log('BASS_GetVersion: Version expected: '+IntToStr(BASSVERSION)+' / received: '+IntToStr(BASS_Version_Result)+' ...');
      Log('BASS_GetVersion: Version mismatch ...');
      Log('BASS_GetVersion: BASS Soundlib will be disabled ...');

    end else begin

      Log('BASS_GetVersion: Version decimal: '+IntToStr(BASS_Version_Result)+' ...');
      Log('BASS_GetVersion: Version expected: '+IntToStr(BASSVERSION)+' / received: '+IntToStr(BASS_Version_Result)+' ...');
      Log('BASS_GetVersion: Version match ...');
      Log('BASS_GetVersion: BASS Soundlib will be enabled ...');

      Log('Begin BASS_Init ...');
      BASS_Init_Result := BASS_Init(-1, 44100, 0, 0, 0);

      Log('Begin BASS_MusicLoad or BASS_StreamCreateFile ...');
      // #############################################################
      // Be aware to change this code-stuff here in order to take care
      // of the used music-formats
      // #############################################################
      // For WAV, MP3, OGG, etc. sound-files
      // #############################################################
      // SndHandle := BASS_StreamCreateFile(FALSE, PAnsiChar(SndName), 0, 0, BASS_SAMPLE_LOOP);
      // #############################################################
      // For MOD, XM, ,IT, S3M, etc. tracker-files
      // #############################################################
      SndHandle := BASS_MusicLoad(FALSE, PAnsiChar(SndName), 0, 0, BASS_SAMPLE_LOOP, 0);
      // #############################################################

      Log('Begin BASS_Start ...');
      BASS_Start_Result := BASS_Start();

      Log('Begin BASS_ChannelPlay ...');
      BASS_ChannelPlay_Result := BASS_ChannelPlay(SndHandle, False);
    end;

  end;
  // Disable installation-sound, when "/BASSSOUND-" string
  // was provided in commandline-parameters.
  // ---  END  ---

  finally

    if BASS_Init_Result = false then begin
      Log('BASS_Init failed, continuing ...');
      Result := True;
    end else begin
      Log('BASS_Init successful, continuing ...');
      Result := True;
    end;

    if SndHandle = 0 then begin
      Log('BASS_MusicLoad or BASS_StreamCreateFile failed, continuing ...');
      Result := True;
    end else begin
      Log('BASS_MusicLoad or BASS_StreamCreateFile successful, continuing ...');
      Result := True;
    end;

    if BASS_Start_Result = false then begin
      Log('BASS_Start failed, continuing ...');
      Result := True;
    end else begin
      Log('BASS_Start successful, continuing ...');
      Result := True;
    end;

    if BASS_ChannelPlay_Result = false then begin
      Log('BASS_ChannelPlay failed, continuing ...');
      Result := True;
    end else begin
      Log('BASS_ChannelPlay successful, continuing ...');
      Result := True;
    end;

    // Result := True;

    // initialise Setup-Skin
    ExtractTemporaryFile('Installer.cjstyles');

    Log('Loading skin ...');
    // LoadSkin(ExpandConstant('{tmp}\Installer.cjstyles'), 'NormalBlue.ini');
    LoadSkin(ExpandConstant('{tmp}\Installer.cjstyles'), 'NormalBlue.ini');
    Log('Skin loaded !');

    // initialise Setup-Installer-Check
    ResultAPPN := ExpandConstant('{#MyAppName}');
    // In order to mask-out the "{" "}" strings in constants
    // we have to use double "{{"-signs at the beginning !!
    ResultAPPID := ExpandConstant('{{#MyAppID}');

    if MyAppUPDATE = false then begin
      Log('This is not an update. Normal installation ...');
      Log('Testing if Application ID is already installed');
      Log('Testing for existence of: HKLM\Software\GNU\'+ResultAPPN+'\AppID\'+ResultAPPID+' ...');
      Log('under Winx64 HKLM\Software\GNU is mapped to HKLM\SOFTWARE\Wow6432Node\GNU\...');
      // See for details:
      // https://docs.microsoft.com/en-us/windows/win32/winprog64/shared-registry-keys
      // https://docs.microsoft.com/en-us/windows/win32/winprog64/registry-redirector
      // "... Redirected keys are mapped to physical locations under Wow6432Node.
      //      For example, HKLM\Software is redirected to HKLM\Software\Wow6432Node.
      //      However, the physical location of redirected keys should be considered
      //      reserved by the system. Applications should not access a key's physical
      //      location directly, because this location may change. ..."
      ApplicationAlreadyInstalled := RegKeyExists(HKLM,'Software\GNU\'+ResultAPPN+'\AppID\'+ResultAPPID);
      if ApplicationAlreadyInstalled = true then begin
         // MsgBox only, when /SILENT and /VERYSILENT switches were not specified !
         if (Pos('/SILENT', UpperCase(GetCmdTail)) > 0) OR (Pos('/VERYSILENT', UpperCase(GetCmdTail)) > 0) then begin
           Log('MsgBox: "Error-Message" was disabled, due to /SILENT and /VERYSILENT switches !!');
         end else begin
           MsgBox(ExpandConstant('{cm:alreadyinstalled}'), mbInformation, MB_OK);
         end;
        Log('Application ID is already installed, aborting ...');
        Result := False;
        Abort;
      end else begin
        Log('Application ID is not already installed, continuing ...');
        Result := True;
      end;
    end else begin
      Log('This is an update. Update is forced ...');
      Result := True;
    end;

    // Both components have to be installed ...
    if (IsGnuPG2Installed() = True) AND (IsGpg4WinInstalled() = True) then begin
    // Only one component has to be installed ...
    // if (IsGnuPG2Installed() = True) OR (IsGpg4WinInstalled() = True) then begin
      Log('GnuPG2 AND Gpg4Win are installed, continuing ...');
      Result := True;
    end else begin
      Log('GnuPG2 AND Gpg4Win are NOT installed, aborting ...');
      // MsgBox only, when /SILENT and /VERYSILENT switches were not specified !
      if (Pos('/SILENT', UpperCase(GetCmdTail)) > 0) OR (Pos('/VERYSILENT', UpperCase(GetCmdTail)) > 0) then begin
        Log('MsgBox: "Error-Message" was disabled, due to /SILENT and /VERYSILENT switches !!');
      end else begin
        MsgBox(ExpandConstant('{cm:compnotinstalled}'), mbInformation, MB_OK);
      end;
      Result := False;
      Abort;
    end;

    // Check correct version of Gpg4Win has to be installed.
    ResultGpg4WinV := ExpandConstant('{#Gpg4WinVersion}');
    ResultGpg4WinVB := ExpandConstant('{#Gpg4WinVersionB}');

    ResultGetGpg4WinV := GetGpg4WinVersion('');

  	if (ResultGpg4WinV = ResultGetGpg4WinV) OR (ResultGpg4WinVB = ResultGetGpg4WinV) then begin
      Log('Expected "Gpg4Win-Version": ' + ResultGpg4WinV + ' or ' + ResultGpg4WinVB);
      Log('Received "Gpg4Win-Version": ' + ResultGetGpg4WinV);
      Log('"Gpg4Win-Version" match, continuing ...');
      Result := True;
    end else begin
      Log('Expected "Gpg4Win-Version": ' + ResultGpg4WinV + ' or ' + ResultGpg4WinVB);
      Log('Received "Gpg4Win-Version": ' + ResultGetGpg4WinV);
      Log('"Gpg4Win-Version" mismatch, aborting ...');
      // MsgBox only, when /SILENT and /VERYSILENT switches were not specified !
      if (Pos('/SILENT', UpperCase(GetCmdTail)) > 0) OR (Pos('/VERYSILENT', UpperCase(GetCmdTail)) > 0) then begin
        Log('MsgBox: "Error-Message" was disabled, due to /SILENT and /VERYSILENT switches !!');
      end else begin
        MsgBox(ExpandConstant('{cm:wronggpg4winversion}'), mbInformation, MB_OK);
      end;
      Result := False;
      Abort;
    end;

    // ###########################################################################
    // !! DISABLED HERE, BECAUSE "ISTask.dll" CANNOT DETECT AND KILLE TASKS     !!
    // !! OF OTHER LOGGED-IN USERS IN OTHER X64-SESSIONS ON Windows 10          !!
    // ###########################################################################
    // !! LEFT IN CODE HERE ONLY FOR DOCUMENTATION                              !!
    // ###########################################################################
    // Check running tasks
    // ExtractTemporaryFile('ISTask.dll');
    // if FileExists(ExpandConstant('{tmp}') + '\ISTask.dll') then begin
    //   Log('ISTask.dll is available at: ' +  ExpandConstant('{tmp}') + '\ISTask.dll');
    Log('Trying to kill some processes:');
    Log(ExpandConstant('{cm:Tasks}'));
      // RunTasks( StringList [CR-delim]   , Fullpath, CheckAll );
      //# if RunTasks(ExpandConstant('{cm:Tasks}'), False, False) then begin
      //#    Log('Some of these processes are running:');
      //#    Log(ExpandConstant('{cm:Tasks}'));
    Log('Ohhh, what a mess !! ...');
         // KillTasks(ExpandConstant('{cm:Tasks}'));
    TaskKill(ExpandConstant('{cm:Tasks}'));
      //# end else begin
      //#    Log('No relevant processes are running !');
      //#    Log('Continuing without killing anybody ... See ya, Greenhorn !!');
      //# end;
    //# end;
  end;
end;

// ###########################################################################
// MAIN() INSTALLER SEQUENCE                                               END
// ###########################################################################

procedure DeinitializeSetup();
begin
  // Hide Window before unloading skin so user does not get
  // a glimse of an unskinned window before it is closed.
  ShowWindow(StrToInt(ExpandConstant('{wizardhwnd}')), 0);
  UnloadSkin();
  // Close BASS soundlib
  BASS_Stop();
  BASS_Free();
end;
