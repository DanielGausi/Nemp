
-----------------------------------------------------------

                Nemp - Noch ein MP3-Player


      von Daniel 'Gausi' Gau�mann, 
      eMail: mail@gausi.de

      Programmiert mit CodeGear Delphi 2009
      Januar 2005 - Dezember 2011

      Version: 4.3.0


-----------------------------------------------------------


Einfaches Verwalten und Abspielen einer mp3-Sammlung mit vielen "Standard"-Features 
und einigen besonderen F�higkeiten, die nicht so h�ufig anzutreffen sind.


Merkmale
-----------------------------------------------------------

Zusammengefasst:
               
                 Nemp ist einfach nur [n]och [e]in [m]p3 [P]layer.


Aber f�r ein Ein-Mann-Projekt ein verdammt guter:

   Nemp kann Musikdateien, Playlists und Webstreams abspielen, finden und verwalten. 
   Unter anderem mp3, ogg, wma, wav, flac, ape, aac, m4a, m3u, m3u8, pls, asx, wax. 

   Nemp muss nicht installiert werden. Als Tool auf einer externen Platte ist es    
   sofort an jedem Rechner einsatzbereit - inklusive der Medienbibliothek

   Nemp kann Webstreams (nur mp3 und aac) aufnehmen und automatisch schneiden

   Nemp hat einen integrierten Webserver um die eigene Musiksammlung mit Freunden zu
   teilen - auf der anderen Seite reicht ein einfacher Webbrowser

   Nemp hat ein intuitives GUI mit vielen kleinen n�tzlichen Dingen wie z.B.

      - optional ins System integrierbares Deskband, wie man es vom WindowsMediaPlayer kennt
      - anpassbares Design
      - Mehrsprachigkeit
      - paralleles Abspielen eines zweiten Liedes �ber eine zweite Soundkarte
      - automatisches Herunterfahren des Systems nach einer gewissen Zeit
      - integrierter LastFM-Scrobbler
      - Geburtstagsmodus, d.h. abspielen eines bestimmten Liedes zu einer bestimmten Zeit
      - Partymodus mit gr��eren Buttons, reduziertem Men� und eingeschr�nkter Funktionalit�t
     

Was Nemp NICHT kann:

   Nemp kann keine CDs rippen
   
   Nemp kann keine CDs brennen
   
   Nemp kann keine Ordnung auf der Festplatte schaffen oder massenhaft Id3-Tags setzen

   Nemp kann kein DRM - und wird das auch NIEMALS k�nnen




Lizenzvereinbarungen:
-----------------------------------------------------------
GPL 2.0 oder sp�ter
(Details in der licence.txt und der gpl.txt)



Verwendete Units/Komponenten:
-----------------------------------------------------------
- VirtualTreeView
  http://www.soft-gems.net/       

- MP3-Wiedergabe-Engine: bass.dll
  Download unter http://www.un4seen.com/

- Mp3FileUtils 
  http://www.gausi.de/delphi

- Teile der AudioToolsLibrary (ATL)
  http://mac.sourceforge.net/atl/
  http://www.gausi.de

- SearchTools von Heiko Thiel
  http://www.delphi-forum.de/viewtopic.php?t=48936

- GNU gettext for Delphi
  http://dybdahl.dk/dxgettext/

- TACredits
  http://www.delphipraxis.net/topic114228.html

- Eine Drag&Drop-Komponente von Angus Johnson (leicht ver�ndert)
  http://angusj.com/delphi/

- FSPro Windows 7 Taskbar Components
  http://delphi.fsprolabs.com/

- Flying Cow
  http://sourceforge.net/projects/flyingcow/

- LastFM API
  http://www.last.fm/api/intro

- SHOUTcast API
  http://www.shoutcast.com

- MadExcept by Mathias Rauen 
  http://www.madshi.net/
  
- au�erdem diverse Funktionen und Codeschnipsel aus dem Internet, u.a. von
  http://www.delphi-forum.de
  http://www.delphipraxis.net
  http://www.dsdt.info
  http://www.swissdelphicenter.ch



Version 4.3.0, November 2011
----------------------------------------------------------- 
Neue Funktionen:
----------------
* bessere Unterst�tzung f�r CD-Audio 
* Optionen: Neues einlesen der Soundkarten
* Verzeichnis-Dialoge: Letzter Wert wird gespeichert

�nderungen:
-----------
* "Medienbib aufr�umen" und "Dateien neu einlesen" besser gestaltet
* Scrobbeln auf die neue API umgestellt
* Beim Ziehen des Positions-Reglers wird die Zielzeit angezeigt
* "Nachrichten" werden weniger h�ufig generiert, z.B. wenn "rating"
  fehlschl�gt
* Symbole in der Playlist ge�ndert, vor allem auch im Nemp3-Skin
* Neue bass_fx.dll: L�uft auch auf Windows8 64Bit
* "Default"-Einstellung f�r Soundkarten hinzugef�gt
* Gui-�nderung: "keine zus�tzlichen Tags" jetzt nicht mehr bei wma etc.

Bugfixes:
---------
* �bergabe von Dateien an laufende Instanz klappte manchmal nicht
* "Neues Bild"-Dialog in ID3v2-Tag-Editor funktionierte nicht richtig
* Im Detailfenster war das URL-Feld ohne Funktion - ersetzt durch "Composer"
* Parameter "Beim Start mit Wiedergabe beginnen" wurde bei Webstreams 
  ignoriert
* "In Ruhezustand versetzen" wird nur noch einmal ausgef�hrt 
  (beim Aufwachen ist das wieder deaktiviert)
* "Laufwerke" wurden nicht korrekt gespeichert
  (hatte aber keinen Einfluss auf die Funktion)
* "Automatische Bewertung" bei bisher unbewertet Dateien f�hrte zu einer
  sehr geringen Bewertung


Version 4.2.0, Juni 2011
----------------------------------------------------------- 
* Wizard erstellt, der einige wichtige Einstellung beim ersten Start abfragt
* Multimediatasten nicht l�nger per Hook, sondern durch Hotkey
* Option "Schnellen Zugriff auf Metadaten erlauben" hinzugef�gt. 
  Damit k�nnen ggf. unbeabsichtigte �nderungen an den ID3Tags 
  (z.B. beim Bewerten) verhindert werden
* Optionen beim Automatischen bewerten entr�mpelt


Version 4.1.0, April 2011
----------------------------------------------------------- 
Neue Funktionen:
----------------
* Unterst�tzung von Flac- und Ogg-Tags (lesen und schreiben)
* Unterst�tzung f�r das Display der Logitech G15 (durch Zusatztool)
* Copy&Paste: Bei Strg+Shift+C wird eine passende m3u-Liste mit kopiert
* Funktion "Playlist auf USB-Stick kopieren". Dabei auch optional passende 
  Umbenennung der Dateien
* Eqalizer-Steuerung: Leichteres Umschalten zwischen Voreinstellungen
* Webserver: Option f�r die PORT-Einstellung
* Push-To-Talk-taste (F8)
* Datei-Details: Bearbeiten von zus�tzlichen Tags (die f�r die Tagwolke)
* Webradio-Aufnahme: Option "Stream als Ordner"
* Coverflow: - bei der Schnellsuche auch anpassen
             - Sortierung: Fehlende Cover zuerst/am Ende
             - Option f�r das Leeren des Cover-Caches
* ID3-Tag-Editor: readonly-Flag der Dateien ber�cksichtigen
* Funktion "nicht getaggte Dateien auflisten" (unter "erweitert")

�nderungen:
-----------
* Datei in "Letzte Playlists" nicht gefunden: "Eintrag l�schen" anbieten
* Webradio einf�gen: Bei der Playlist nur einfache Input-Box zeigen, 
  wie auch beim Play-Button
* Nicht mp3/ogg/flac-Files k�nnen nicht mehr editiert werden (auch keine 
  Lyrics und weitere Tags) 
  Einzige Ausnahme: Rating
* Bei nicht getaggten Dateien Auswahl was wie angezeigt werden soll,
  z.B. "Pfad in der Spalte Album"
* Nemp kann jetzt auch geschlossen werden, wenn die Medienbibliothek gerade 
  ein Update durchf�hrt.
* GUI: - Drag&Drop auf Kopfh�rer, von Kopfh�rer in Playlist,
       - Drag&Drop vom Detail-Cover in die Playlist und Kopfh�rer

Bugfixes:
---------
* Funktion "Player reinitialisieren" f�hrte beim Aufruf der Einstellungen zu
  einem Fehler
* Wenn keine Track-Nr-Info vorliegt, wird jetzt nicht mehr "0" daf�r im 
  ID3v2Tag gespeichert, sondern nichts
* falsches Label bei Jingles: Lautst�rke reduzieren AUF, nicht UM!

Deaktivierte Funktionen:
------------------------
* Browsen in der Shoutcast-Datenbank. Die API wurde ge�ndert, und die
  Nutzungsbedingungen schlie�t OpenSource aus.

  

Version 4.0.1, August 2010
----------------------------------------------------------- 
Bugfix:
-------
* Bewertungen wurden nicht in den ID3-Tag �bernommen, wenn der 
  Abspielz�hler auf 0 stand


Version 4.0.0 (Serengeti), Mai-Juli 2010
----------------------------------------------------------- 
* �nderung der Lizenz von "Freeware" auf OpenSource
  - Nemp steht ab jetzt unter der GPL
* Wechsel der Programmierumgebung von Delphi7 auf Delphi2009

Neue Funktionen:
----------------
* Neuer Coverflow
  - zeitgem��eres Look&Feel
  - "Alben ohne Cover" werden jetzt einzeln nach Ordner gruppiert angezeigt,
    nicht mehr als ein gro�er Block
  - Automatisches Nachladen von Covern aus dem Internet
* Browse-Modus "Tagwolke" hinzugef�gt
  - Automatische Beschaffung von weiteren Tags (z.B. "Singer-Songwriter")
    von LastFM
  - Anzeige der h�ufigsten Tags in unterschiedlichen Schriftgr��en
  - Doppelklick auf einen tag erzeugt neue Tagwolke, eingeschr�nkt auf alle
    Dateien, die diesen Tag enthalten
* Lyricsuche im Netz funktioniert wieder
* Sortierung nach Dateialter hinzugef�gt
  - zum Browsen werden die Dateien nach Monaten gruppiert
* Spalte Dateityp (mp3, ogg, ...) hinzugef�gt
* Spalte "Playcounter" hinzugef�gt
* Coveranzeige neben der Medienbibliothek erweitert
  - Anzeige von weiteren Informationen, um einige Spalten ausblenden zu k�nnen
  - dort auch Bearbeitung der Daten m�glich
  - dort jetzt auch Anzeige zu Dateien in der Playlist
* Bearbeiten von Datei-Informationen direkt im Hauptfenster
  - Start der Bearbeitung durch zweimal Klicken oder F2
  - �nderung der Bewertung durch einen einzigen Klick m�glich
* Automatische Anpassung der Bewertung bei oft abgespielten Dateien 
  - Die �nderung der Bewertung ist abh�ngig vom Playcounter
    (bei oft geh�rten Titeln �ndert sich die Bewertung weniger stark)
* Windows7-Support erweitert 
  - Angepasstes Vorschaufenster f�r die Taskleiste
  - Buttons f�r die Lautst�rke in der Taskleiste
  - Fortschrittsbalken bei l�ngeren Aktionen in der Taskleiste
* Beim Speichern der Playlist mit einem Album drin wird ein passender 
  Name vorgeschlagen ("Interpret - Album")
* Direktes Abspielen aus der Medienbibliothek ohne �nderung an der Playlist m�glich
* "Vormerkliste" in der Playlist 
  - Abspielreihenfolge kann �ber die Zifferntasten ge�ndert werden
  - �ber das Kontextmen� k�nnen auch mehrere Dateien in die Vormerkliste
    aufgenommen werden 
  - Damit funktioniert "als n�chstes Abspielen" auch im Random-Modus
* Playlist-History
  - Klick auf "Voriger Titel" spielt auch im Zufallsmodus die zuletzt 
    gespielten St�cke ab
  - Klick auf Vor/Zur�ck navigiert dann in der History
  - Erst bei Start eines "neuen" Liedes wird dieses dann in die History-List
    aufgenommen
* Party-Modus 
  - einstellbarer Zoom (1.5x, 2x, 2.5x) f�r leichteres Treffen der Buttons
  - reduziertes Men�
  - eingeschr�nkte Funktionalit�t (Dateien in die Medienbibliothek einf�gen, l�schen, 
    Bearbeiten der ID3-Tags, ...)
* Webradio-Verwaltung verbessert
  - Sortierm�glichkeit f�r die Webradio-Stationen in der Medienbibliothek
  - Export der Webradio-Stationen als pls-Datei
* Random-Playlist erweitert 
  - Dauer der Dateien als Auswahl-Kriterium
  - Tags der Dateien als Auswahlkriterium 
    (daf�r "Genre" entfernt)
* GUI
  - Bei Klick in den Playerteil: Lautst�rke-Regelung per Mausrad
  - Gr��enver�nderung der Einzelfenster auch an den R�ndern m�glich, nicht nur unten rechts
  - intelligentere Gr��enver�nderung der Komponenten bei Resize des Hauptfensters
* Kopfh�rer-Steuerung in das Hauptfenster integriert
  - leichtes Einf�gen des aktuellen Kopfh�rer-Titels in die Playlist
* Erkennung von VBRI-Headern in mp3-Dateien
* Erkennung von weiteren Genre-IDs
* Bessere Hilfe-Datei erstellt

�nderungen:
-----------
* GUI
  - Anzeige im Playerteil umgestaltet
  - im Einzelfenstermodus gibt es nun f�r Equalizer/Effekte/... ein eigenes Fenster
  - Umschalt-Buttons f�r Equalizer/Effekte/... jetzt neben diesen Dingen, nicht mehr �ber
    dem Player 
  - Ausf�hrliche Suche in eigenes Fenster ausgelagert 
  - die Umschalt-Buttons �ber der "Browse-Liste" schalten jetzt um zwischen 
    Classic, Coverflow und Tagwolke
  - Klick auf "Voriger Titel" springt nach den ersten 5 Sekunden nur zum Anfang des 
    aktuellen St�ckes  
* Deskand-Installierung wird unter Windows Vista und 7 verweigert - da funktioniert das 
  eh nicht richtig.
  - ebenso generell unter 64-Bit-Systemen
* Auswahl "Jetzt abspielen, sp�ter abspielen, ..." anders
* "Kopfh�rer-Ausgabe" auch auf derselben Soundkarte wie die Hauptwiedergabe m�glich
* Skineditor aus dem Hauptprogramm entfernt - der wird als eigenes Programm 
  nachgeliefert
* Optionen, Bitraten-Farben: Entfernt. Farben k�nnen nur �ber den Skin eingestellt 
  werden, in den Optionen kann das dann auf Wunsch abgeschaltet werden
* Beim Bearbeiten von Dateieigenschaften im Detailfenster kommt beim Wechsel eine
  "Wollen Sie speichern"-Abfrage
* Effekt "Geschwindigkeit" von 33% - 300% erweitert
* Option: Beim Start Webserver aktivieren hinzugef�gt
* System "Schnellsuche" �berarbeitet. Es wird immer alles durchsucht, nicht nur 
  die "aktuelle Liste". 
  - Treffer aus dieser Liste werden aber zuerst angezeigt
  - statt der Checkbox jetzt ein Button zum L�schen der Eingabe

Bugfixes:
---------
* Beim Sliden in einem Lied bis fast ans Ende wurde u.U. kein Faden ausgef�hrt
* Wenn die Medienbibliothek leer war, wurden die "�berwachten Verzeichnisse" nicht
  nach neuen Dateien gescannt.
* Die Suche �ber den Webserver lieferte nicht immer die erwarteten Ergebnisse




Version 3.3.4, November 2009
----------------------------------------------------------- 
Bugfixes:
---------
* Die Playlist spielte unter bestimmten Umst�nden nur ein Lied ab und stoppte dann



Version 3.3.3, August 2009
----------------------------------------------------------- 
Entfernte Funktionen (ja, ENTFERNT!)
-----------------------------------
* Automatische Lyrics-Suche - LyricWiki musste auf Druck der Plattenfirmen 
  die API abschalten

Bugfixes:
---------
* Der Button "�nderungen �bernehmen" im Einstellungsdialog ist jetzt gro� genug
* Bei Klick auf Stop springt die Titelanzeige jetzt zur�ck
* Ein Starten des Webservers gibt es jetzt ne nettere Fehlermeldung, wenn z.B. XAMPP
  bereits l�uft
* Fading und "Ignorieren bei Stop" funktionierte nicht wie gew�nscht
* Fehlende Dateien in der Playlist wurden nicht �bersprungen, bzw. die Wiedergabe 
  hielt danach automatisch an
* Problem mit der Track-Nr bei WMA-Dateien behoben (hoffentlich)



Version 3.3.2, Juli 2009
----------------------------------------------------------- 
Bugfixes:
---------
* Diverse Fehler beim Starten von CD/DVD oder anderen schreibgesch�tzten Medien behoben
* Die Funktion "Vollst�ndig abgespielte Titel aus der Playlist l�schen" funktionierte nicht
* Das Abschalten der automatischen Update-Suche funktionierte nicht



Version 3.3.1, April 2009
----------------------------------------------------------- 
Bugfixes:
---------
* Bearbeiten von ID3-Tags f�hrte zu Inkonsistenzen in der Medienbibliothek
  ("doppelte Dateien") oder zu einem Totalabsturz des Players



Version 3.3.0 (Beta2), M�rz 2009
----------------------------------------------------------- 
Neue Funktionen:
----------------
* LastFM-Scrobbeln. Abgespielte Titel werden im LastFM-Userprofil gespeichert.
* Auch im Skin-Modus sind die Player-Buttons (Play, Next, etc) �ber die Tastatur steuerbar
* Schieberegeler (Lautst�rke, Equalizer, ...) sind per Cursortasten steuerbar
* Wird ein neues Laufwerk angeschlossen, auf dem ein "�berwachtes Verzeichnis" liegt, dann
  startet ggf. nachtr�glich das Scannen nach neuen Dateien
* Rudiment�rer Windows7-Support (Taskleistenbuttons)

�nderungen:
-----------
* Das Verzeichnis f�r Webradio-Aufnahmen wird jetzt erst bei Bedarf erstellt,
  nicht direkt beim Start von Nemp
* Anzeige f�r aktivierten Geburtstags-/Sleepmodus ver�ndert
* Ein aktivierter Webserver wird jetzt auch im Hauptfenster angezeigt

Bugfixes:
---------
* Bei einer Schnellsuche verschwindet das "Sortierdreieck" in der Anzeige



Version 3.3.0 (Beta1), Februar 2009
----------------------------------------------------------- 
Neue Funktionen:
----------------
* Updater-Funktion, d.h. automatische Benachrichtigung bei neuen Versionen
* Beenden/Shutdown bei Ende der Playlist
* Equalizer-Einstellungen k�nnen unter eigenen Namen gespeichert werden
* Webradio-Aufnahme mit Auto-Cut nach Zeit/Dateigr��e

�nderungen:
-----------
* Einstellungsdialog �berarbeitet
* Dateitypen-Registrierung erweitert, u.a. Anzeige der aktuell auf Nemp registrierten
  Dateitypen
* About-Dialog �berarbeitet
* Scrollgeschwindigkeit in der Taskleiste und im Hauptfenster einstellbar
* Heuristik der Coversuche modifiziert - in einigen F�llen wurde unsinniges
  angezeigt
* Bei Klick auf [N] im Deskband wird das Deskband jetzt ausgeblendet, wenn Nemp 
  abgest�rzt ist

Bugfixes:
---------
* Die Volume-Keys bei Multimedia-Tastaturen funktionierten nicht wie gew�nscht
* Nach dem �ffnen des Einstellungsdialoges und anschlie�endem Programmabsturz
  waren (fast) alle Einstellungen auf die Default-Einstellung zur�ckgesetzt
* Die Lautst�rkeregelung bei Jingles war defekt
* L�schen der Playlist f�hrte zu einer Zugriffsverletzung beim anschlie�enden Versuch, 
  etwas r�ckw�rts abspielen zu wollen
* Die Playlist-Dateien hatten Probleme mit sehr langen Dateinamen
* In den Hotkey-Optionen gab es zweimal "Strg+Alt"
* Die Sprachauswahl im Einstellungsdialog zeigte initial auf deutschen Systemen nichts an 
* Tags in "Lossless WMA"-Dateien wurden nicht ausgelesen



Version 3.2.1, Januar 2009
----------------------------------------------------------- 
Bugfixes:
---------
* Wenn keine Medienbibliothek geladen wurde, funktionierte das Deskband nicht richtig
* Im Dialog zu "Playlist laden" wurden in der deutschen Version unter "Alle unterst�tzten Formate"
  nicht die *.npl-Dateien angezeigt
* Nach Ausf�hren der Funktion "Fehlende Dateien l�schen" kam es bei der Schnellsuche zu 
  Zugriffsverletzungen
* Das Sortierdreieck in den Spalten der Medienliste wird jetzt ausgeblendet, wenn nach einem Wechsel
  der Vorauswahl die Sortierung verloren geht
* Ein Umschalten zwischen "Suche" und "Browsen" im Modus "Coverflow" konnte unter bestimmten 
  Umst�nden zu Zugriffsverletzungen f�hren
* In der deutschen Version wurden im Coverflow einige Alben- oder Interpreten falsch angezeigt
  z.B. "Pos1", wenn das Album "Home" hei�t
* Die Schriftart wurde von "MS Sans Serif" auf "Tahoma" ge�ndert, um ClearType zu unterst�tzen


Version 3.2.0, Dezember 2008
----------------------------------------------------------- 
Neue Funktionen:
----------------
* hidden feature ;-)

�nderungen/Erweiterungen:
-------------------------
* Schriftzug "kein Cover gefunden" durch ein Standardcover ersetzt
* Standardcover f�r "Alle Dateien", "Kein Cover gefunden" etc. �ber den Einstellungsdialog
  konfigurierbar
* Im Coverflow ist das "Alle Dateien"-Cover personalisierbar, d.h. es werden 1-8 zuf�llige 
  Cover aus der Medienbibliothek daf�r benutzt
* Unterst�tzung f�r *.gif-Dateien 

Bugfixes:
---------
* Fehler in MP3FileUtils behoben, der unter Umst�nden das letzte Zeichen abschnitt
* Der Geburtstagslied-Auswahl-Dialog zeigte alle Dateien an, nicht nur Audiodateien
* Im Zufalls-Playlist-Erstellen-Dialog war der initiale Fokus unsch�n gesetzt
* Ein Bearbeiten von gespeicherten Webradio-Sendern wurde nicht automatisch gespeichert
* Die Bedienfolge "Datei abspielen, Pause, Klick auf Next, Play" f�hrte dazu (falls das n�chste 
  St�ck ein Radiosender ist), dass die AUfnahme nicht m�glich war.



Version 3.1.0, November 2008
-----------------------------------------------------------
Neue Funktionen:
----------------
* Deutlich schnellere Suche in der Medienbibliothek. 
  D.h.: Die Suche �ber die Schnellsuche l�uft "in Echtzeit" w�hrend des Tippens
        - optional sogar mit Fehlertoleranz, voreingestellt ist eine fehlertolerante
          Suche bei Druck auf die Enter-Taste
* Deutlich verbessertes herunterladen von Lyrics. D.h. schneller, zuverl�ssiger und einfacher.
  Das Zusatzprogramm "EvilLyrics" wird nicht l�nger ben�tigt.
* Integration von Playlisten in die Medienbibliothek
  - Beim Durchsuchen der Festplatten nach Musikdateien werden auch Playlistdateien ber�cksichtigt.
    Diese k�nnen �ber die Vorauswahl komplett in die aktuelle Playlist eingef�gt werden, oder �ber
    die untere Titelliste nur teilweise.
* Deutlich verbesserte Unterst�tzung von Webradio
  - Suche in der Shoutcast-Datenbank nach Titeln oder Genre
  - vereinfachte und bessere Favouritenverwaltung
  - Integration der Favouriten in die Medienbibliothek
  - Unterst�tzung auch von asx/wax-Playlisten bzw. mms:// - Streams
* Integrierter Webserver hinzugef�gt. Dar�ber ist ein Austausch der eigenen Musiksammlung mit 
  Freunden m�glich - auf das LAN beschr�nkt oder weltweit. Optional ist auch die Steuerung des Players
  dar�ber m�glich. Auf der "anderen Seite" gen�gt ein normaler Webbrowser.
  Das vorige "Remote Nemp", was nur sehr m��ig funktionierte, wurde eingestampft.
* Unterst�tzung von Bewertungen der einzelnen Titel
* Unterst�tzung von Coverbildern im PNG-Format (auch im ID3-Tag)
* Anzeige des Covers in der Medienbibliothek
* Anzeige des Covers im Deskband
* Auslesen von Metainformationen aus .flac-Dateien (zum Abspielen wird ein Plugin ben�tigt)
* Option "minimiert starten" hinzugef�gt
* Wiedergabemodus "Kein Repeat" hinzugef�gt, d.h. die Wiedergabe f�ngt nicht wieder von vorne an,
  wenn die Playlist zu Ende ist.
* Bin�res Playlistformat hinzugef�gt, das weitere Informationen speichern kann und so den Ladevorgang
  beschleunigt, da diese Informationen nicht mehr einzeln aus den mp3-Dateien ermittelt werden m�ssen.
* Speicherung der letzten Auswahl in der Medienbibliothek

�nderungen/Erweiterungen:
-------------------------
* Verbesserte Behandlung von "falschen Laufwerken". D.h. Nemp merkt, ob das Laufwerk E:\ aus der letzten
  Sitzung mit dem aktuellen E:\ �bereinstimmt und leitet ggf. entsprechende Ma�nahmen ein.
  Das funktioniert auch mit nachtr�glich angeschlossenen Laufwerken (d.h. w�hrend Nemp l�uft) 
* umgestaltetes Detailfenster. Die Bearbeitung der ID3-Tags sollte nun intuitiver sein. Weitere
  Informationen werden angezeigt (z.B. URL und Copyright-Informationen)
* Klick auf den "Next-Button" springt (optional) nur zum n�chsten Eintrag im Cue-Sheet
* Mehr Auswahl f�r das automatische Herunterfahren des Systems, �bersichtlichere Gestaltung
* Beim Herunterfahren wird w�hrend des abschlie�enden 30-Sekunden Countdowns die Wiedergabe sanft
  ausgeblendet
* Auswahl der angezeigten Spalten in der Medienbibliothek �ber das Popup-Men� der Spalten�berschriften
* Die Buttons f�r Play/Pause, Stop und Wiedergabemodus haben jetzt ein Popup-Men�
* Wird Nemp nicht korrekt beendet, so wird beim n�chsten Start kein Warnhinweis mehr ausgegeben. Die 
  automatisch gesicherte Backup-Playlist wird geladen.
* Sortierung in der Vorauswahl modifiziert. Eintr�ge ohne Information ("N/A") erscheinen am Anfang der 
  Auswahl
* Das Einf�gen vieler Dateien von der Medienbibliothek in die Playlist geht jetzt deutlich schneller
  (�ber die Men�eintr�ge, Drag&Drop/Copy&Paste ist weiter nur mit max. 500 Dateien m�glich)
* Ein Klick auf das [N] im Deskband schaltet jetzt um zwischen minimieren und wiederherstellen.
* Option hinzugef�gt: Hints in der Medienliste anzeigen
* Option hinzugef�gt: Hints in der Playlist anzeigen

Bugfixes:
---------
* Unter Umst�nden kam es bei der Aufnahme von Webradio zu einem "Dateiname ist zu lang"-Fehler.
* Wurde bei ge�ffnetem Detailfenster der Einstellungsdialog geschlossen, dann wurde das 
  Detailfenster nicht mehr automatisch aktualisiert, wenn man im Hauptfenster eine neue Datei ausw�hlte
* Bei �nderungen in der Bibliothek (z.B. l�schen) wurden im Anschluss oft unsinnige Knoten in den 
  Browse-listen markiert. Oder es kam zu einer unsch�nen Fehlermeldung.
* Im Optionsdialog war der Windows-Standard-Skin nicht anw�hlbar
* Die Option "fertig abgespielte Titel aus der Playlist l�schen" konnte zu einem Fehler beim 
  Titelwechsel f�hren.
* ID3-Tags von mp3-Dateien von jamendo.com wurden oft fehlerhaft ausgelesen
* Bei WMA-Dateien wurden Tracknummern oft nicht ausgelesen
* Wird beim Start ein Webstream abgepielt, und kann dieser nicht gestartet werden, dann bleibt
  der Play/Pause-Button jetzt auf "Abspielen"
* Bei der Verwendung mehrerer Monitore wurden bei einem Ansichtswechsel (Einzelfenster-Kompaktansicht)
  alle Fenster auf den prim�ren Monitor verschoben
* Beim r�ckw�rts abspielen mit erh�hter Geschwindigkeit trat immer der Micky-Maus-Effekt auf, auch wenn
  das in den Einstellungen ausgeschaltet war.
* In der klassischen Ansicht (Windows) wurden beim Verschieben der Fenster nicht immer alle Teile
  des Skins korrekt aktualisiert



Version 3.0.3, Juni 2008
-----------------------------------------------------------
Bugfixes:
---------
* Bei Cue-Listen gab es ein Problem mit dem letzten Eintrag in der Liste
* Bei Cue-Listen kam die Anzeige des aktuellen Eintrags manchmal nicht mit
* Ein �ndern der Optionen bewirkte eine �nderung der Wiedergabe auf die
  Kopfh�rerlautst�rke
* In 3.0.2 tauchte wieder der Fehler auf, dass die Sprache auf Englisch
  zur�ckgesetzt wurde, wenn noch keine Sprache explizit gew�hlt wurde und
  der Einstellungs-Dialog aufgerufen wurde.



Version 3.0.2, Mai 2008
-----------------------------------------------------------
Updates:
--------
* Update der bass.dll von Version 2.3 auf 2.4
  ggf. installierte Addons m�ssen ebenfalls aktualisiert werden
* neue Deskband-Version, die einen Fehler mit dem kaufm�nnischem
  Und (&) behebt
* Einstellungen f�r die Wiedergabe hinzugef�gt, die Probleme
  mit einer verzerrten Wiedergabe auf einigen Systemen beheben
  k�nnen.

Bugfixes:
---------
* Durch bestimmte Aktionen konnte die Playlist durcheinander geraten
  und Nemp unbedienbar werden.
* Nach einem Drag&Drop vom Explorer in die Playlist waren einige Eintr�ge 
  im Kontextmen� der Medienliste deaktiviert.
* Die Schnellsuche nach dem Leerstring war nicht wirklich schnell.
* Wenn man bei laufender Wiedergabe die Playlist l�schte, und nach Ende des 
  aktuellen St�ckes den Play-Button klickte, gab es eine Fehlermeldung.
* In der Hilfe waren ab dem Coverflow-Link alle Links verschoben.
* In der Fehlermeldung, wenn EvilLyrics nicht existiert (auf deutsch) fehlte 
  ein P bei rogramm.
* Beim Suchen nach neuen Dateien war "Searching" nicht �bersetzt.
* Im Eigenschaftenfenster unter Lyrics: "Erkannate"
* Im Eigenschaftenfenster unter erweiterte id3v2-Frames war unten der 
  Button "Als Datei speichern" zu schmal.
* �ber das Tray-Men� lie� sich der erste Eintrag in der Playliste nicht ausw�hlen.
* Die Aktualisierung des Covers in der Medienbibliothek funktionierte teilweise 
  nicht richtig.
* Das ermitteln der Lyrics verursachte eine Fehler-Kaskade.
* Die untere Liste war manchmal "zu gro�".


Version 3.0.1, November 2007
-----------------------------------------------------------
Bugfixes:
---------
* Wenn Nemp nicht lief, und man eine mp3-Datei im Explorer doppelklickte, startete zwar
  Nemp, aber die Wiedergabe startete nicht automatisch
* Im Skin-Editor funktionierte der "Skin testen"-Button nicht
* Bei der Auswahl der Skins im Editor gab es immer den Punkt "Kein Skin vorhanden"
* Das Erstellen eines neuen Skins f�hrte zu einer Zugriffsverletzung, 
  wenn der Optionsdialog vorher nicht ge�ffnet wurde
* Bei Klick auf "�bernehmen" im Optionsdialog kam das Hauptfenster in den Vordergrund
* Wenn noch keine Sprache explizit eingestellt wurde, �nderte sich beim ersten Aufruf des
  Optionsdialogs die Sprache auf Englisch, auch wenn beim Start korrekt deutsch erkannt wurde
* Einige Kontrollelemente waren zu klein, was zu einem unvollst�ndigen Text in der deutschen
  Fassung f�hrte
* Ein paar Rechtschreibfehler in der �bersetzungsdatei (deutsch) korrigiert
* Das Deskband hat das kaufm�nnische Und (&) nicht richtig angezeigt
* alte Versionen der bass.dll und Addons aktualisiert


Version 3.0.0, Oktober 2007
-----------------------------------------------------------
Neue Funktionen:
----------------
* API hinzugef�gt. Dar�ber eine Steuerung von Nemp durch Drittprogramme m�glich
    - Steuern des Players
    - Anzeige der Playlist 
    - Suchen in der Medienbib
    - Hinzuf�gen der Suchtreffer in die Playlist 
* Als Beispiel-Anwendung f�r die Api: ein Deskband, was sich in die Taskleiste einbettet 
* Remote-Nemp:
    - Verbindung mit anderem Nemp aufnehmen (im Lan oder im Internet)
    - Durchsuchen der fremden Medienbibliothek
    - Download einzelner Titel von Freunden
    - Zusatz-Tools sind m�glich, um das andere Nemp zu steuern 
      (Doku dazu folgt sp�ter) 
* Zufalls-Playlist erstellen. Als Parameter sind m�glich
    - Genres (mit konfigurierbaren Vorauswahlen)
    - Zeitraum
    - Anzahl der Titel
* Unterst�tzung von Cue-Sheets
    - Zu einem mp3 wird automatisch ein passendes cue-File gefunden, falls vorhanden
    - Anzeige der einzelnen subtracks in einem mp3-File
    - Einfaches Springen zum gew�nschten Subtrack per Doppelklick in der Playlist
* Geburtstagsmodus:
    - Zeitpunkt angeben, Lied ausw�hlen, und das Lied wird zu diesem Zeitpunkt automatisch abgespielt
    - Optional kann vorher ein Countdown abgespielt werden
    - Der Countdown wird dabei automatisch passend vorher gestartet! 
* Coverflow zum Browsen in der Medienbib
    - Automatisches Zuordnung Lied <-> Cover
    - Automatische Bestimmung von Titel und Artist f�r eine Compilation, die durch ein gemeinsames Cover
      definiert wird
    - Sortierung der Cover nach Artist, Album, Jahr oder Genre
    - Drag&Drop eines Covers in die Playlist
* Multilanguage-System eingef�hrt
    - Quasi beliebig erweiterbar. �bersetzungsdateien k�nnen selbst erstellt werden, und einfach
      integriert werden
    - Falls vorhanden, wird automatisch die zum System passende Sprache gew�hlt - ansonsten englisch
* Aufnahme von Webradio mit automatischem Splitten der Tracks
    - Dateibenennung konfigurierbar
    - Automatisches Hinzuf�gen von ID3-Tags
* Beim Beenden wird die aktuelle Position im Track gespeichert und beim n�chsten Start wieder hergestellt.
* Unterst�tzung von m3u8-Playlisten f�r ein korrektes Abspeichern von Unicode-Playlisten

Verbesserte/erweiterte Funktionen:
----------------------------------
* Skinsystem verbessert
    - Beim vergr��ern der Fenster jetzt kein Flackern mehr
    - Position und Gr��e der Steuerbuttons variabel
    - Selbstkonfigurierbare Hover-Effekte f�r die Buttons 
* Sleepmodus-Alternativen: Nemp beenden, Suspend, Hibernate, Shutdown
* Men�grafiken hinzugef�gt
* Tray-Popup enth�lt Teile der Playlist
* Mehr Komfort in der Medienbib
    - W�hrend der Suche nach neuen Dateien ist die Bib nicht f�rs Browsen/Suchen gesperrt 
    - Suchtreffer k�nnen per Drag&Drop in die Playlist gezogen werden, auch wenn die Suche noch l�uft
    - Ausgew�hlte Ordner k�nnen �berwacht werden, d.h. neue Dateien werden beim n�chsten Start
      automatisch in die Bib integriert
* Verbesserte Schnellsuche
    - Der eingegebene Suchbegriff wird in einzelne Worte aufgeteilt und diese werden einzeln gesucht
    - Dabei k�nnen zusammenh�ngende Worte durch "" geklammert werden
* Optionsdialog mal wieder umgestaltet. Sollte jetzt sinnvoller unterteilt sein
* Neue Icons
* Konfigurierbare Hotkeys
* Verbesserter Equalizer
* Jingle-Lautst�rke konfigurierbar
* Per Drag&Drop werden beliebige Dateien f�r die Playlist akzeptiert
* Spectrum mit Farbverlauf
* Jede menge weiterer Kleinkram

�nderungen:
-----------
* XP/nichtXP-Version ver�ndert
  - Es kommt nicht mehr auf den Dateinamen an, sonder auf den Ordner, in dem Nemp liegt.
    Nemp im Programmverzeichnis (meist c:\Programme\...): Speicherung der Daten im User-verzeichnis
    Nemp woanders: Speicherung der Daten im Programmverzeichnis selbst

Interna:
--------
* Code des Players fast vollst�ndig neu geschrieben
* Code f�r die Verwaltung der playlist fast vollst�ndig neu geschrieben
* Code f�r die Medienbib-Verwaltung fast vollst�ndig neu geschrieben
==> Deswegen: Diesmal keine Auflistung von Bugfixes. 

 


Version 2.5d, November 2006
-----------------------------------------------------------
Bis auf ein paar Kleinigkeiten nur Fehlerkorrekturen:

* Korrektur eines Fehlers bei "Suche nach diesem Artist/Titel/Album", der zu unsinnigen 
  Suchergebnissen oder auch Zugriffsverletzungen f�hren konnte.
* Dabei auch "diesen Titel" durch den Titel ersetzt.
* Parameterverarbeitung beim Start �berarbeitet. Playlisten werden jetzt korrekt behandelt. 
  Ebenso sollte das "Autoplay beim Start" und "Neuen Titel abspielen" jetzt besser funktionieren.
* Skinsystem leicht modifiziert. Bei "Hintergrundbild nicht verwenden f�r.." wird das Bild 
  jetzt nicht nur f�r den Baum nicht benutzt, sondern auch nicht f�r das drumherum. Das 
  erscheint mir sinniger. Den alten Effekt kann man immer noch mit Hilfe der 
  "Halbtransparente Anzeige f�r..." erreichen.
* Ein bi�chen Sprengstoff (TNT ;-)) hinzugef�gt, und ein paar weitere Strings 
  "erweitert" (WideStrings). Damit sollte jetzt auch die Suche nach Unicode-Titeln/Namen/... 
  richtig funktionieren.
* Bei �nderung der Anzeige des Trayicons �ber den Optionendialog wurde der Tray-Hint 
  nicht sofort richtig gesetzt, sondern erst bei einem Liedwechsel



Version 2.5c, Oktober 2006
-----------------------------------------------------------
* Wiedergabemodus (Alles wiederholen, Titel wiederholen, Zufallswiedergabe) wird gespeichert
* Zufallswiedergabe verbessert (wiederholen eines Titels nach kurzer Zeit wird verhindert)
* Gesamtspieldauer der Playlist sollte jetzt korrekt sein
* Schnelles mehrfaches Klicken auf "R�ckw�rts abspielen" f�hrte zu einer mehrfachen 
  Wiedergabe des St�ckes
* Das Fenster kann nun im maximierten Zusatnd nicht mehr verschoben werden
* Option "Jetzt abspielen"
* Draggen von "Alle Alben" f�hrte zu einem Draggen der Gesamten Medienliste, auch dann, wenn ein 
  bestimmter Artist markiert war
* Die Medienliste wird beim Start jetzt im Hintergrund geladen
* "Ordner in Nemp einf�gen" vom Kontextmen� des Explorers aus f�hrte u.U. zu einer doppelten 
  "aktuelles St�ck"-Markierung in der Playlist
* Doppelklick auf einen leeren Bereich in der Playlist bewirkte ein Abspielen des fokussierten 
  Eintrags


Version 2.5b, September 2006
-----------------------------------------------------------
* Rechtsklick auf die Ecken der Einzelfenster startet nun nicht mehr das Vergr��ern/Verkleinern 
  des Fensters
* Die Kommunikation mit EvilLyrics funktioniert wieder


Version 2.5a, September 2006
-----------------------------------------------------------
* Skins werden jetzt im Unterordner \Skins\ gesammelt. Alte Skins m�ssen dorthin verschoben werden
* initialer Glyph f�r den R�ckw�rtbutton korrigiert
* Taskbar-Eintrag wird zur�ckgesetzt, wenn kein Titel zum abspielen bereit ist
* Schlafmodus: Wahl zwischen "Windows herunterfahren" und "Nemp beenden"
* Skinoption: Hintergrundbild ausrichten am Desktop oder am Mittelteil des Players
* "Als n�chstes abspielen" ins Kontextmen� der Playlist eingef�gt
* StayOnTop-System modifiziert, sollte jetzt weniger buggy sein


Version 2.5, September 2006
-----------------------------------------------------------
Neue Highlights: Funktionen, die teilweise nichtmal der Windows-Media-Player hat :)
* Unterst�tzung von Unicode:
  - Abspielen von Dateien mit Unicode-Dateinamen
  - Auslesen von Unicode-Informationen aus den ID3-Tags
  - automatisches Konvertieren von Nicht-Unicode-ID3-Tags in den Zeichensatz, den der 
    Dateiname nahe legt (das kann der WMP10 nicht!)
* Variable Vorauswahl f�r die Medienliste. Nicht nur Artist-Album, sondern variabel 
  (jeweils Artist, Album, Genre, Jahr, Ordner)
* Variablere Fenstergestaltung: Kompakter Modus oder Einzelfenster

Weitere Updates
* Registrierung der Datentypen, die Nemp kennt
* Eintr�ge in die Kontextmnen�s von Ordnern: "In Nemp abspielen/einf�gen"
* Zuf�llige Wiedergabe der Playlist
* Option hinzugef�gt: "Playlist am Ende neu mischen"
* Steuerung der im Kopfh�rer abgespielten Dateien
* Auswahl der letzten 10 geladenen/gespeicherten Playlists
* Schlafmodus
* in der Stream-Auswahl gibts jetzt ein PopUp-Men� "URL aufrufen"
* Dateispezifische Hints in Playlist und Medienliste

�nderungen:
* Drag&Drop von der Medienliste in die Playlist ist auch erfolgreich, wenn die gedraggten Dateien 
  nicht vorhanden sind
* Draggen von mehr als 500 Dateien wird unterbunden
* Die vom Skin-Editor automatisch erstellten Buttongrafiken sehen jetzt etwas anders aus
* im Skineditor ist bei neuen Skins das Verzeichnis w�hlbar (privat/global)
* Skinsystem erweitert: Die Farbe der Equalizer-Nulllinie kann jetzt eingestellt werden
* Skinsystem erweitert: generelles Alpha-Blending in den Listen, f�r bessere Lesbarkeit auch 
  auf ung�nstigeren Hintergrundbildern
* Fenster werden erst bei Bedarf erstellt
* Die Suche nach neuen Dateien verwendet nun SearchTools und ist dadurch etwas schneller
* Unbekannte Genres aus dem ID3v2-Tag werden jetzt in der Medienliste gespeichert

BugFixes:
* Druck auf [DEL] in den Sucheingaben f�hrte zu einem Entfernen eines Eintrags in der Medienliste 
  oder gar zum Absturz des Programms
* Bei sehr breiten Fenster erschien u.U. eine alte, nicht mehr ben�tigte Komponente
* kleine Unstimmigkeit beim Zeichnen der Visualisierung behoben
* Bei aktivierten Skins konnte es u.U. zu einem unsch�nen Streifen im Suchfenster kommen
* Bei aktiviertem Fading wurde u.U. ein Klick auf Pause ignoriert
* ein neu erstellter Skin erschien erst nach einem Neustart in den Skin-Auswahl-Men�s
* schwarze Ecken am Rand des Fensters sollten nun seltener auftreten
* Beim Beenden von Windows wurde Nemp nicht korrekt beendet, so dass beim Neustart eine Meldung 
  diesbez�glich kam



Version 2.4, Juni 2006
-----------------------------------------------------------
Updates:
* PlugIn-System zur einfachen Unterst�tzung weiterer Dateiformate 
  (z.B. CD-DA, Ape, etc.)
  Download der n�tigen dll-Dateien unter http://www.un4seen.com
* Unterst�tzung von Webradio (ShoutCast/Icecast)
  (f�r AAC+-Streams wird ein entsprechendes Plugin ben�tigt)
* Schnellsuche hinzugef�gt
* Umstieg von bass2.2 auf bass2.3

Bugfixes:
* Durchsuchen des Arbeitsplatzes m�glich
* Fehler bei der Darstellung der Buttons behoben

Kleinkram:
* Globale Hotkeys eingef�hrt
* Konfiguration der Farben f�r unterschiedliche Bitraten
* Konfiguration der Schriftgr��e in den einzelnen Listen
* "StayOnTop" des Players


Version 2.3, Mai 2006
-----------------------------------------------------------
Updates:
* Umfangreiches Skin-System hinzugef�gt, inklusive passendem Editor
* 4 verscheidene Anzeigemodi - von komplett bis minimal
* Nemp versteht jetzt Parameter - damit kann man es auch als Standard-Anwendung f�r 
  mp3-Dateien einrichten
* Nur eine Instanz von Nemp m�glich (abschaltbar)
* Bessere Unterst�tzung von wma-Dateien
* Equalizer-Presets ausw�hlbar
* Effekt-Option: Ver�ndern der Abspielgeschwindigkeit mit oder ohne "Micky-Maus-Effekt"
* Effekt "R�ckw�rts abspielen" hinzugef�gt
* Abspielen von Jingles w�hrend der Wiedergabe
* Drag&Drop von Artists und Alben m�glich
* Minimieren in den Tray m�glich
* Sch�nerer Splashscreen bei Programmstart mit Statusanzeige
* Option hinzugef�gt f�r ein schnelleres Laden der Playliste
* Abspielen von diversen weiteren Dateitypen erm�glicht. Unter anderem mod, xm, aiff
* Die Zeitanzeige in der Playlist wird jetzt durch das Abspielen ggf. korrigiert
* Funktion "Medienliste als CSV exportieren" hinzugef�gt
* optionales automatisches Speichern der Playlist in bestimmten Intervallen hinzugef�gt

Ver�nderungen:
* Lyrics werden in den Dateidetails auch dann angezeigt, wenn die Datei gerade nicht 
  gefunden werden kann
* Standardwert f�r das Detailfenster ist jetzt "nicht sichtbar"
* Icons in der Playlist zur Anzeige, welche Datei gerade abgespielt wird etc.
* verbesserte Cover-Auswahl

Bugfixes:
* Selten auftretende Gleitkommafehler sollten jetzt gar nicht mehr auftreten
* kleinere Fehler in der GUI behoben
* Verbesserte Unterst�tzung von m3u-Playlisten


Version 2.2, M�rz 2006
-----------------------------------------------------------
Updates:
* Verbesserte Unterst�tzung f�r Multimedia-Tastaturen (hoffentlich) 
  durch Verwendung eines Hooks
* Equalizer hinzugef�gt (DirectX 9 ben�tigt (evtl. reicht auch 8))
* Effekte (Geschwindigkeit, Echo, Hall) hinzugef�gt (DirectX 9 ben�tigt)
* Unterst�tzung f�r PLS-Playlisten

Ver�nderungen:
* minimale Fenstergr��e herabgesetzt
* Klick auf ID3v1_Speichern bzw. ID3v2_Speichern bewirkt nun auch eine Speicherung der �nderung 
  im jeweils anderen Tag

Bugfixes:
- Drop in die playlist vom Explorer aus verursachte einen unn�tigen Neuaufbau der Medienliste
- Im Headset konnten keine wma-Dateien abgespielt werden
- Nicht 100% dem Standard entsprechende M3U-Listen, wie sie Winamp manchmal erzeugt, 
  wurden unvollst�ndig gelesen
- Beenden im maximierten Zustand bewirkte beim n�chsten Laden ein unsch�nes Verhalten
- Tabulator-Reihenfolge im Detailfenster korrigiert
- Laden der Medienliste funktionierte unter gewissen Umst�nden nicht richtig


Version 2.1, Februar 2006
-----------------------------------------------------------
Major Updates/Changes:
* Interner Player hinzugef�gt
  - Fade-In, Fade-Out
  - Soundkarten-Auswahl
  - Ausgabe einzelner Titel �ber zweite Soundkarte
  - Unterst�tzung von mp3, ogg, wav, wma
  - Lautst�rkeregelung
  - spulen im Titel
  - Anzeige von Zeit/Restzeit
  - Unterst�tzung von Multimediatastaturen
* Direktes Suchen in der Medienliste vereinfacht
  - Einteilung in fest vorgegebene Kategorien wie Alben, Sampler, Maxis entfernt
  - daf�r ein Artist-Album-Suchsystem implementiert:
    Artist markieren -> Anzeige aller Alben, au denen dieser vertreten ist
    Album markieren -> Anzeige aller Titel auf dem ALbum / aller Titel des 
                           ausgew�hlten Artists auf dem Album)
* Automatisches Speichern/Laden der Medienliste und der Playliste beim Beenden und Starten
* �nderung des Systems, das eine Laufwerksunabh�ngige Speicherung erm�glicht. 
  Damit ist auch ein Wechsel der Laufwerksbuchstaben bei mehreren Partitionen 
  (fast) kein Problem mehr
* Suche in eigenen Thread ausgelagert
* Funktion "Lyrics holen mit EvilLyrics" hinzugef�gt


Minor Updates/Changes
* Anzeige der Medienliste leicht ver�ndert
* Icons ver�ndert 
* Winamp-Anbindung weiter gelockert. Durch den eigenen Player macht es keinen Sinn 
  mehr, die den Winamp-Status zu �berwachen
* Icon ge�ndert
* Umbenennung von "Gausis MP3-Verwaltung" nach "Nemp - Noch ein MP3-Player"
  


Version 2.0, September 2005
-----------------------------------------------------------
Major Updates/Changes:
* Ausf�hrlichere Anzeige von Dateidetails
  - Anzeige von in der Datenbank gespeicherten informationen
  - Anzeige von MPEG-Informationen
  - Anzeige von id3v1/id3v1.1 Informationen
  - Anzeige von id3v2 Informationen
  - Anzeige eines evtl. vorhandenen Covers, das zu der Datei geh�rt
* vollst�ndige Bearbeitung des id3v1/id3v1.1-Tags hinzugef�gt
* Umfangreiche Bearbeitung des id3v2Tags, inklusive Bilder und Lyrics hinzugef�gt
* Textsuche hinzugef�gt - es kann nach einer Zeile im Text des Liedes gesucht werden
* Suche nach Datum/Genre hinzugef�gt
* fehlertolerante Suche hinzugef�gt
* Speicherplatzbedarf der .gmp Dateien um fast 50% reduziert 
* Speicherung von Kommentaren in alternativen Datenstr�men (ADS) unter 
  NTFS entfernt - dazu sind jetzt die id3v2Tags da
  

Minor Updates/Changes:
* �nderung der Spaltenreihenfolge wieder m�glich
* Auslesen der Information "Jahr" und "Genre" aus den ID3-Tags
* Speicherung dieser Informationen in den .gmp-Dateien
* Passwortabfrage zur Editierung der ID3-Tags entfernt - daf�r gibt es 
  jetzt eine Option in den Einstellungen.
* "Fernsteuerung" f�r Winamp entfernt



Version 1.1, Januar 2005
-----------------------------------------------------------
* Austausch der Komponente StringGrid durch VirtualTreeView - dadurch 
  wesentlich sch�nere Bedienung.
* Hinzuf�gen einer Such-History
* einfache Beschleunigung der Suchfunktion


Version 1.0, erste Ver�ffentlichung, Januar 2005
-----------------------------------------------------------


