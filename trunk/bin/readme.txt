
-----------------------------------------------------------

                Nemp - Noch ein MP3-Player


      von Daniel 'Gausi' Gaußmann, 
      eMail: mail@gausi.de

      Programmiert mit Borland Delphi7 Personal
      Januar 2005 - April 2009

      Version: 3.3.0

(Note: This file is deprecated!)

-----------------------------------------------------------


Einfaches Verwalten und Abspielen einer mp3-Sammlung mit vielen "Standard"-Features 
und einigen besonderen Fähigkeiten, die nicht so häufig anzutreffen sind.


Merkmale
-----------------------------------------------------------

Zusammengefasst:
               
                 Nemp ist einfach nur noch ein mp3 Player.


Aber für ein Ein-Mann-Projekt ein verdammt guter:

   Nemp kann Musikdateien, Playlists und Webstreams abspielen, finden und verwalten. 
   Unter anderem mp3, ogg, wma, wav, m3u, m3u8, pls, asx, wax. Andere Musikformate wie
   flac, ape, aac, m4a können über Plugins hinzugefügt werden.

   Nemp muss nicht installiert werden. Als Tool auf einer externen Platte ist es    
   sofort an jedem Rechner einsatzbereit - inklusive der Medienbibliothek

   Nemp kann Webstreams (nur mp3, optional aac) aufnehmen und automatisch schneiden

   Nemp hat einen integrierten Webserver um die eigene Musiksammlung mit Freunden zu
   teilen - auf der anderen Seite reicht ein einfacher Webbrowser

   Nemp hat ein intuitives GUI mit vielen kleinen nützlichen Dingen wie z.B.
      - optional ins System integrierbares Deskband, wie man es vom WindowsMediaPlayer kennt
      - anpassbares Design durch den integrierten Skineditor
      - Mehrsprachigkeit
      - paralleles Abspielen eines zweiten Liedes über eine zweite Soundkarte
      - automatisches Herunterfahren des Systems nach einer gewissen Zeit
      - Geburtstagsmodus, d.h. abspielen eines bestimmten Liedes zu einer bestimmten Zeit
     

Was Nemp NICHT kann:

   Nemp kann keine CDs rippen
   
   Nemp kann keine CDs brennen
   
   Nemp kann keine Ordnung auf der Festplatte schaffen oder massenhaft Id3-Tags setzen

   Nemp kann kein DRM - und wird das auch NIEMALS können




Lizenzvereinbarungen:
-----------------------------------------------------------
Dieses Produkt wurde vom Autor für ausschließlich kostenlose Verbreitung erstellt 
und veröffentlicht. Es darf unverändert  an jeden weitergegeben werden und auf 
Homepages zum Download zur Verfügung gestellt werden. In diesem Fall ist eine 
Benachrichtigung des Autors erwünscht. Es besteht keinerlei Gewährleistung jeglicher 
Art für das Produkt.

Dieses Produkt umfasst die folgenden Dateien:
   - nemp.exe (Hauptprogramm)
   - NempDeskband.dll
   - faq.htm
   - lgpl.txt
   - bass.dll
   - basswma.dll
   - bass_fx.dll
   - KBHook.dll
   - default.nwl
   - readme.txt (Diese Datei)
Außerdem die Ordner
   - \HTML
   - \locale
   - \Skins
mit weiteren Dateien   


Der Autor dieses Produkts übernimmt KEINERLEI Haftung für Schäden jeglicher Art, die 
durch das Produkt, durch die Nutzung des Produkts, durch die Nichtnutzung des Produkts 
oder durch hier nicht aufgezählte Schadensmöglichkeiten entstehen. In keinem Fall kann 
der Autor dieses Produktes für Schäden jeglicher Art verantwortlich gemacht werden.
Das Produkt wird "so wie es ist" zur Verfügung gestellt. Das Produkt wurde mit 
großer Sorgfalt geschrieben, jedoch könnte jegliche Funktion, die der Beschreibung 
des Produkts nach enthalten ist/sein sollte, durch Fehler versagen. Hierfür 
übernimmt der Autor ebenfalls keine Haftung.
Die Haftungsbeschränkung gilt nicht für den Fall, dass ein Schaden aufgrund grober 
Fahrlässigkeit seitens des Autors entstanden ist.

Eine Gewährleistung für eine fehlerfreie Funktionalität des Produkts wird von 
dem Autor nicht übernommen. Der Autor übernimmt keine Haftung für die Fehlerfreiheit 
des Produkts, insbesondere nicht dafür, dass das Produkt den Anforderungen und 
Zwecken des Erwerbers genügt oder mit anderen von ihm ausgewählten Programmen 
zusammenarbeitet.

Das Programm steht unter dem rechtlichen Schutz der Urheber- und Handelsgesetze 
des Landes, in dem es veröffentlicht, vervielfältigt bzw. genutzt wird. Die 
Dekompilierung, Disassemblierung oder Änderung der Software oder der Dokumentation 
inklusive dieses Dokumentes ist nur für private Zwecke erlaubt. Der Quellcode 
dieses Produkts kann beim Autor per eMail (mail@gausi.de) angefordert werden. 
Die Weitergabe des veränderten Produkts oder Teilen davon bedarf der Zustimmung 
des Autors.



Verwendete Units/Komponenten:
-----------------------------------------------------------
- VirtualTreeView und GraphicEx
  http://www.soft-gems.net/

- TntWare Delphi Unicode Controls
  http://www.tntware.com/delphicontrols/unicode/            

- MP3-Wiedergabe-Engine: bass.dll
  Download unter http://www.un4seen.com/

- Mp3FileUtils 
  http://www.gausi.de/delphi

- Teile der AudioToolsLibrary (ATL)
  http://mac.sourceforge.net/atl/
  http://www.gausi.de/delphi

- SearchTools von Heiko Thiel
  http://www.delphi-forum.de/viewtopic.php?t=48936

- GNU gettext for Delphi
  http://dybdahl.dk/dxgettext/

- Indy 10
  http://www.indyproject.org/

- TACredits
  http://www.delphipraxis.net/topic114228.html

- Windows 7 Support für Delphi
  http://www.delphipraxis.net/topic150591.html

- LastFM API
  http://www.last.fm/api/intro

- MadExcept by Mathias Rauen 
  http://www.madshi.net/
  
- außerdem diverse Funktionen und Codeschnipsel aus dem Internet, u.a. von
  http://www.delphi-forum.de
  http://www.delphipraxis.net
  http://www.dsdt.info
  http://www.swissdelphicenter.ch
  


Version 3.3.0 (Beta2), März 2009
----------------------------------------------------------- 
Neue Funktionen:
----------------
* LastFM-Scrobbeln. Abgespielte Titel werden im LastFM-Userprofil gespeichert.
* Auch im Skin-Modus sind die Player-Buttons (Play, Next, etc) über die Tastatur steuerbar
* Schieberegeler (Lautstärke, Equalizer, ...) sind per Cursortasten steuerbar
* Wird ein neues Laufwerk angeschlossen, auf dem ein "überwachtes Verzeichnis" liegt, dann
  startet ggf. nachträglich das Scannen nach neuen Dateien
* Rudimentärer Windows7-Support (Taskleistenbuttons)

Änderungen:
-----------
* Das Verzeichnis für Webradio-Aufnahmen wird jetzt erst bei Bedarf erstellt,
  nicht direkt beim Start von Nemp
* Anzeige für aktivierten Geburtstags-/Sleepmodus verändert
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
* Equalizer-Einstellungen können unter eigenen Namen gespeichert werden
* Webradio-Aufnahme mit Auto-Cut nach Zeit/Dateigröße

Änderungen:
-----------
* Einstellungsdialog überarbeitet
* Dateitypen-Registrierung erweitert, u.a. Anzeige der aktuell auf Nemp registrierten
  Dateitypen
* About-Dialog überarbeitet
* Scrollgeschwindigkeit in der Taskleiste und im Hauptfenster einstellbar
* Heuristik der Coversuche modifiziert - in einigen Fällen wurde unsinniges
  angezeigt
* Bei Klick auf [N] im Deskband wird das Deskband jetzt ausgeblendet, wenn Nemp 
  abgestürzt ist

Bugfixes:
---------
* Die Volume-Keys bei Multimedia-Tastaturen funktionierten nicht wie gewünscht
* Nach dem Öffnen des Einstellungsdialoges und anschließendem Programmabsturz
  waren (fast) alle Einstellungen auf die Default-Einstellung zurückgesetzt
* Die Lautstärkeregelung bei Jingles war defekt
* Löschen der Playlist führte zu einer Zugriffsverletzung beim anschließenden Versuch, 
  etwas rückwärts abspielen zu wollen
* Die Playlist-Dateien hatten Probleme mit sehr langen Dateinamen
* In den Hotkey-Optionen gab es zweimal "Strg+Alt"
* Die Sprachauswahl im Einstellungsdialog zeigte initial auf deutschen Systemen nichts an 
* Tags in "Lossless WMA"-Dateien wurden nicht ausgelesen



Version 3.2.1, Januar 2009
----------------------------------------------------------- 
Bugfixes:
---------
* Wenn keine Medienbibliothek geladen wurde, funktionierte das Deskband nicht richtig
* Im Dialog zu "Playlist laden" wurden in der deutschen Version unter "Alle unterstützten Formate"
  nicht die *.npl-Dateien angezeigt
* Nach Ausführen der Funktion "Fehlende Dateien löschen" kam es bei der Schnellsuche zu 
  Zugriffsverletzungen
* Das Sortierdreieck in den Spalten der Medienliste wird jetzt ausgeblendet, wenn nach einem Wechsel
  der Vorauswahl die Sortierung verloren geht
* Ein Umschalten zwischen "Suche" und "Browsen" im Modus "Coverflow" konnte unter bestimmten 
  Umständen zu Zugriffsverletzungen führen
* In der deutschen Version wurden im Coverflow einige Alben- oder Interpreten falsch angezeigt
  z.B. "Pos1", wenn das Album "Home" heißt
* Die Schriftart wurde von "MS Sans Serif" auf "Tahoma" geändert, um ClearType zu unterstützen


Version 3.2.0, Dezember 2008
----------------------------------------------------------- 
Neue Funktionen:
----------------
* hidden feature ;-)

Änderungen/Erweiterungen:
-------------------------
* Schriftzug "kein Cover gefunden" durch ein Standardcover ersetzt
* Standardcover für "Alle Dateien", "Kein Cover gefunden" etc. über den Einstellungsdialog
  konfigurierbar
* Im Coverflow ist das "Alle Dateien"-Cover personalisierbar, d.h. es werden 1-8 zufällige 
  Cover aus der Medienbibliothek dafür benutzt
* Unterstützung für *.gif-Dateien 

Bugfixes:
---------
* Fehler in MP3FileUtils behoben, der unter Umständen das letzte Zeichen abschnitt
* Der Geburtstagslied-Auswahl-Dialog zeigte alle Dateien an, nicht nur Audiodateien
* Im Zufalls-Playlist-Erstellen-Dialog war der initiale Fokus unschön gesetzt
* Ein Bearbeiten von gespeicherten Webradio-Sendern wurde nicht automatisch gespeichert
* Die Bedienfolge "Datei abspielen, Pause, Klick auf Next, Play" führte dazu (falls das nächste 
  Stück ein Radiosender ist), dass die AUfnahme nicht möglich war.



Version 3.1.0, November 2008
-----------------------------------------------------------
Neue Funktionen:
----------------
* Deutlich schnellere Suche in der Medienbibliothek. 
  D.h.: Die Suche über die Schnellsuche läuft "in Echtzeit" während des Tippens
        - optional sogar mit Fehlertoleranz, voreingestellt ist eine fehlertolerante
          Suche bei Druck auf die Enter-Taste
* Deutlich verbessertes herunterladen von Lyrics. D.h. schneller, zuverlässiger und einfacher.
  Das Zusatzprogramm "EvilLyrics" wird nicht länger benötigt.
* Integration von Playlisten in die Medienbibliothek
  - Beim Durchsuchen der Festplatten nach Musikdateien werden auch Playlistdateien berücksichtigt.
    Diese können über die Vorauswahl komplett in die aktuelle Playlist eingefügt werden, oder über
    die untere Titelliste nur teilweise.
* Deutlich verbesserte Unterstützung von Webradio
  - Suche in der Shoutcast-Datenbank nach Titeln oder Genre
  - vereinfachte und bessere Favouritenverwaltung
  - Integration der Favouriten in die Medienbibliothek
  - Unterstützung auch von asx/wax-Playlisten bzw. mms:// - Streams
* Integrierter Webserver hinzugefügt. Darüber ist ein Austausch der eigenen Musiksammlung mit 
  Freunden möglich - auf das LAN beschränkt oder weltweit. Optional ist auch die Steuerung des Players
  darüber möglich. Auf der "anderen Seite" genügt ein normaler Webbrowser.
  Das vorige "Remote Nemp", was nur sehr mäßig funktionierte, wurde eingestampft.
* Unterstützung von Bewertungen der einzelnen Titel
* Unterstützung von Coverbildern im PNG-Format (auch im ID3-Tag)
* Anzeige des Covers in der Medienbibliothek
* Anzeige des Covers im Deskband
* Auslesen von Metainformationen aus .flac-Dateien (zum Abspielen wird ein Plugin benötigt)
* Option "minimiert starten" hinzugefügt
* Wiedergabemodus "Kein Repeat" hinzugefügt, d.h. die Wiedergabe fängt nicht wieder von vorne an,
  wenn die Playlist zu Ende ist.
* Binäres Playlistformat hinzugefügt, das weitere Informationen speichern kann und so den Ladevorgang
  beschleunigt, da diese Informationen nicht mehr einzeln aus den mp3-Dateien ermittelt werden müssen.
* Speicherung der letzten Auswahl in der Medienbibliothek

Änderungen/Erweiterungen:
-------------------------
* Verbesserte Behandlung von "falschen Laufwerken". D.h. Nemp merkt, ob das Laufwerk E:\ aus der letzten
  Sitzung mit dem aktuellen E:\ übereinstimmt und leitet ggf. entsprechende Maßnahmen ein.
  Das funktioniert auch mit nachträglich angeschlossenen Laufwerken (d.h. während Nemp läuft) 
* umgestaltetes Detailfenster. Die Bearbeitung der ID3-Tags sollte nun intuitiver sein. Weitere
  Informationen werden angezeigt (z.B. URL und Copyright-Informationen)
* Klick auf den "Next-Button" springt (optional) nur zum nächsten Eintrag im Cue-Sheet
* Mehr Auswahl für das automatische Herunterfahren des Systems, übersichtlichere Gestaltung
* Beim Herunterfahren wird während des abschließenden 30-Sekunden Countdowns die Wiedergabe sanft
  ausgeblendet
* Auswahl der angezeigten Spalten in der Medienbibliothek über das Popup-Menü der Spaltenüberschriften
* Die Buttons für Play/Pause, Stop und Wiedergabemodus haben jetzt ein Popup-Menü
* Wird Nemp nicht korrekt beendet, so wird beim nächsten Start kein Warnhinweis mehr ausgegeben. Die 
  automatisch gesicherte Backup-Playlist wird geladen.
* Sortierung in der Vorauswahl modifiziert. Einträge ohne Information ("N/A") erscheinen am Anfang der 
  Auswahl
* Das Einfügen vieler Dateien von der Medienbibliothek in die Playlist geht jetzt deutlich schneller
  (über die Menüeinträge, Drag&Drop/Copy&Paste ist weiter nur mit max. 500 Dateien möglich)
* Ein Klick auf das [N] im Deskband schaltet jetzt um zwischen minimieren und wiederherstellen.
* Option hinzugefügt: Hints in der Medienliste anzeigen
* Option hinzugefügt: Hints in der Playlist anzeigen

Bugfixes:
---------
* Unter Umständen kam es bei der Aufnahme von Webradio zu einem "Dateiname ist zu lang"-Fehler.
* Wurde bei geöffnetem Detailfenster der Einstellungsdialog geschlossen, dann wurde das 
  Detailfenster nicht mehr automatisch aktualisiert, wenn man im Hauptfenster eine neue Datei auswählte
* Bei Änderungen in der Bibliothek (z.B. löschen) wurden im Anschluss oft unsinnige Knoten in den 
  Browse-listen markiert. Oder es kam zu einer unschönen Fehlermeldung.
* Im Optionsdialog war der Windows-Standard-Skin nicht anwählbar
* Die Option "fertig abgespielte Titel aus der Playlist löschen" konnte zu einem Fehler beim 
  Titelwechsel führen.
* ID3-Tags von mp3-Dateien von jamendo.com wurden oft fehlerhaft ausgelesen
* Bei WMA-Dateien wurden Tracknummern oft nicht ausgelesen
* Wird beim Start ein Webstream abgepielt, und kann dieser nicht gestartet werden, dann bleibt
  der Play/Pause-Button jetzt auf "Abspielen"
* Bei der Verwendung mehrerer Monitore wurden bei einem Ansichtswechsel (Einzelfenster-Kompaktansicht)
  alle Fenster auf den primären Monitor verschoben
* Beim rückwärts abspielen mit erhöhter Geschwindigkeit trat immer der Micky-Maus-Effekt auf, auch wenn
  das in den Einstellungen ausgeschaltet war.
* In der klassischen Ansicht (Windows) wurden beim Verschieben der Fenster nicht immer alle Teile
  des Skins korrekt aktualisiert



Version 3.0.3, Juni 2008
-----------------------------------------------------------
Bugfixes:
---------
* Bei Cue-Listen gab es ein Problem mit dem letzten Eintrag in der Liste
* Bei Cue-Listen kam die Anzeige des aktuellen Eintrags manchmal nicht mit
* Ein Ändern der Optionen bewirkte eine Änderung der Wiedergabe auf die
  Kopfhörerlautstärke
* In 3.0.2 tauchte wieder der Fehler auf, dass die Sprache auf Englisch
  zurückgesetzt wurde, wenn noch keine Sprache explizit gewählt wurde und
  der Einstellungs-Dialog aufgerufen wurde.



Version 3.0.2, Mai 2008
-----------------------------------------------------------
Updates:
--------
* Update der bass.dll von Version 2.3 auf 2.4
  ggf. installierte Addons müssen ebenfalls aktualisiert werden
* neue Deskband-Version, die einen Fehler mit dem kaufmännischem
  Und (&) behebt
* Einstellungen für die Wiedergabe hinzugefügt, die Probleme
  mit einer verzerrten Wiedergabe auf einigen Systemen beheben
  können.

Bugfixes:
---------
* Durch bestimmte Aktionen konnte die Playlist durcheinander geraten
  und Nemp unbedienbar werden.
* Nach einem Drag&Drop vom Explorer in die Playlist waren einige Einträge 
  im Kontextmenü der Medienliste deaktiviert.
* Die Schnellsuche nach dem Leerstring war nicht wirklich schnell.
* Wenn man bei laufender Wiedergabe die Playlist löschte, und nach Ende des 
  aktuellen Stückes den Play-Button klickte, gab es eine Fehlermeldung.
* In der Hilfe waren ab dem Coverflow-Link alle Links verschoben.
* In der Fehlermeldung, wenn EvilLyrics nicht existiert (auf deutsch) fehlte 
  ein P bei rogramm.
* Beim Suchen nach neuen Dateien war "Searching" nicht übersetzt.
* Im Eigenschaftenfenster unter Lyrics: "Erkannate"
* Im Eigenschaftenfenster unter erweiterte id3v2-Frames war unten der 
  Button "Als Datei speichern" zu schmal.
* Über das Tray-Menü ließ sich der erste Eintrag in der Playliste nicht auswählen.
* Die Aktualisierung des Covers in der Medienbibliothek funktionierte teilweise 
  nicht richtig.
* Das ermitteln der Lyrics verursachte eine Fehler-Kaskade.
* Die untere Liste war manchmal "zu groß".


Version 3.0.1, November 2007
-----------------------------------------------------------
Bugfixes:
---------
* Wenn Nemp nicht lief, und man eine mp3-Datei im Explorer doppelklickte, startete zwar
  Nemp, aber die Wiedergabe startete nicht automatisch
* Im Skin-Editor funktionierte der "Skin testen"-Button nicht
* Bei der Auswahl der Skins im Editor gab es immer den Punkt "Kein Skin vorhanden"
* Das Erstellen eines neuen Skins führte zu einer Zugriffsverletzung, 
  wenn der Optionsdialog vorher nicht geöffnet wurde
* Bei Klick auf "Übernehmen" im Optionsdialog kam das Hauptfenster in den Vordergrund
* Wenn noch keine Sprache explizit eingestellt wurde, änderte sich beim ersten Aufruf des
  Optionsdialogs die Sprache auf Englisch, auch wenn beim Start korrekt deutsch erkannt wurde
* Einige Kontrollelemente waren zu klein, was zu einem unvollständigen Text in der deutschen
  Fassung führte
* Ein paar Rechtschreibfehler in der Übersetzungsdatei (deutsch) korrigiert
* Das Deskband hat das kaufmännische Und (&) nicht richtig angezeigt
* alte Versionen der bass.dll und Addons aktualisiert


Version 3.0.0, Oktober 2007
-----------------------------------------------------------
Neue Funktionen:
----------------
* API hinzugefügt. Darüber eine Steuerung von Nemp durch Drittprogramme möglich
    - Steuern des Players
    - Anzeige der Playlist 
    - Suchen in der Medienbib
    - Hinzufügen der Suchtreffer in die Playlist 
* Als Beispiel-Anwendung für die Api: ein Deskband, was sich in die Taskleiste einbettet 
* Remote-Nemp:
    - Verbindung mit anderem Nemp aufnehmen (im Lan oder im Internet)
    - Durchsuchen der fremden Medienbibliothek
    - Download einzelner Titel von Freunden
    - Zusatz-Tools sind möglich, um das andere Nemp zu steuern 
      (Doku dazu folgt später) 
* Zufalls-Playlist erstellen. Als Parameter sind möglich
    - Genres (mit konfigurierbaren Vorauswahlen)
    - Zeitraum
    - Anzahl der Titel
* Unterstützung von Cue-Sheets
    - Zu einem mp3 wird automatisch ein passendes cue-File gefunden, falls vorhanden
    - Anzeige der einzelnen subtracks in einem mp3-File
    - Einfaches Springen zum gewünschten Subtrack per Doppelklick in der Playlist
* Geburtstagsmodus:
    - Zeitpunkt angeben, Lied auswählen, und das Lied wird zu diesem Zeitpunkt automatisch abgespielt
    - Optional kann vorher ein Countdown abgespielt werden
    - Der Countdown wird dabei automatisch passend vorher gestartet! 
* Coverflow zum Browsen in der Medienbib
    - Automatisches Zuordnung Lied <-> Cover
    - Automatische Bestimmung von Titel und Artist für eine Compilation, die durch ein gemeinsames Cover
      definiert wird
    - Sortierung der Cover nach Artist, Album, Jahr oder Genre
    - Drag&Drop eines Covers in die Playlist
* Multilanguage-System eingeführt
    - Quasi beliebig erweiterbar. Übersetzungsdateien können selbst erstellt werden, und einfach
      integriert werden
    - Falls vorhanden, wird automatisch die zum System passende Sprache gewählt - ansonsten englisch
* Aufnahme von Webradio mit automatischem Splitten der Tracks
    - Dateibenennung konfigurierbar
    - Automatisches Hinzufügen von ID3-Tags
* Beim Beenden wird die aktuelle Position im Track gespeichert und beim nächsten Start wieder hergestellt.
* Unterstützung von m3u8-Playlisten für ein korrektes Abspeichern von Unicode-Playlisten

Verbesserte/erweiterte Funktionen:
----------------------------------
* Skinsystem verbessert
    - Beim vergrößern der Fenster jetzt kein Flackern mehr
    - Position und Größe der Steuerbuttons variabel
    - Selbstkonfigurierbare Hover-Effekte für die Buttons 
* Sleepmodus-Alternativen: Nemp beenden, Suspend, Hibernate, Shutdown
* Menügrafiken hinzugefügt
* Tray-Popup enthält Teile der Playlist
* Mehr Komfort in der Medienbib
    - Während der Suche nach neuen Dateien ist die Bib nicht fürs Browsen/Suchen gesperrt 
    - Suchtreffer können per Drag&Drop in die Playlist gezogen werden, auch wenn die Suche noch läuft
    - Ausgewählte Ordner können überwacht werden, d.h. neue Dateien werden beim nächsten Start
      automatisch in die Bib integriert
* Verbesserte Schnellsuche
    - Der eingegebene Suchbegriff wird in einzelne Worte aufgeteilt und diese werden einzeln gesucht
    - Dabei können zusammenhängende Worte durch "" geklammert werden
* Optionsdialog mal wieder umgestaltet. Sollte jetzt sinnvoller unterteilt sein
* Neue Icons
* Konfigurierbare Hotkeys
* Verbesserter Equalizer
* Jingle-Lautstärke konfigurierbar
* Per Drag&Drop werden beliebige Dateien für die Playlist akzeptiert
* Spectrum mit Farbverlauf
* Jede menge weiterer Kleinkram

Änderungen:
-----------
* XP/nichtXP-Version verändert
  - Es kommt nicht mehr auf den Dateinamen an, sonder auf den Ordner, in dem Nemp liegt.
    Nemp im Programmverzeichnis (meist c:\Programme\...): Speicherung der Daten im User-verzeichnis
    Nemp woanders: Speicherung der Daten im Programmverzeichnis selbst

Interna:
--------
* Code des Players fast vollständig neu geschrieben
* Code für die Verwaltung der playlist fast vollständig neu geschrieben
* Code für die Medienbib-Verwaltung fast vollständig neu geschrieben
==> Deswegen: Diesmal keine Auflistung von Bugfixes. 

 


Version 2.5d, November 2006
-----------------------------------------------------------
Bis auf ein paar Kleinigkeiten nur Fehlerkorrekturen:

* Korrektur eines Fehlers bei "Suche nach diesem Artist/Titel/Album", der zu unsinnigen 
  Suchergebnissen oder auch Zugriffsverletzungen führen konnte.
* Dabei auch "diesen Titel" durch den Titel ersetzt.
* Parameterverarbeitung beim Start überarbeitet. Playlisten werden jetzt korrekt behandelt. 
  Ebenso sollte das "Autoplay beim Start" und "Neuen Titel abspielen" jetzt besser funktionieren.
* Skinsystem leicht modifiziert. Bei "Hintergrundbild nicht verwenden für.." wird das Bild 
  jetzt nicht nur für den Baum nicht benutzt, sondern auch nicht für das drumherum. Das 
  erscheint mir sinniger. Den alten Effekt kann man immer noch mit Hilfe der 
  "Halbtransparente Anzeige für..." erreichen.
* Ein bißchen Sprengstoff (TNT ;-)) hinzugefügt, und ein paar weitere Strings 
  "erweitert" (WideStrings). Damit sollte jetzt auch die Suche nach Unicode-Titeln/Namen/... 
  richtig funktionieren.
* Bei Änderung der Anzeige des Trayicons über den Optionendialog wurde der Tray-Hint 
  nicht sofort richtig gesetzt, sondern erst bei einem Liedwechsel



Version 2.5c, Oktober 2006
-----------------------------------------------------------
* Wiedergabemodus (Alles wiederholen, Titel wiederholen, Zufallswiedergabe) wird gespeichert
* Zufallswiedergabe verbessert (wiederholen eines Titels nach kurzer Zeit wird verhindert)
* Gesamtspieldauer der Playlist sollte jetzt korrekt sein
* Schnelles mehrfaches Klicken auf "Rückwärts abspielen" führte zu einer mehrfachen 
  Wiedergabe des Stückes
* Das Fenster kann nun im maximierten Zusatnd nicht mehr verschoben werden
* Option "Jetzt abspielen"
* Draggen von "Alle Alben" führte zu einem Draggen der Gesamten Medienliste, auch dann, wenn ein 
  bestimmter Artist markiert war
* Die Medienliste wird beim Start jetzt im Hintergrund geladen
* "Ordner in Nemp einfügen" vom Kontextmenü des Explorers aus führte u.U. zu einer doppelten 
  "aktuelles Stück"-Markierung in der Playlist
* Doppelklick auf einen leeren Bereich in der Playlist bewirkte ein Abspielen des fokussierten 
  Eintrags


Version 2.5b, September 2006
-----------------------------------------------------------
* Rechtsklick auf die Ecken der Einzelfenster startet nun nicht mehr das Vergrößern/Verkleinern 
  des Fensters
* Die Kommunikation mit EvilLyrics funktioniert wieder


Version 2.5a, September 2006
-----------------------------------------------------------
* Skins werden jetzt im Unterordner \Skins\ gesammelt. Alte Skins müssen dorthin verschoben werden
* initialer Glyph für den Rückwärtbutton korrigiert
* Taskbar-Eintrag wird zurückgesetzt, wenn kein Titel zum abspielen bereit ist
* Schlafmodus: Wahl zwischen "Windows herunterfahren" und "Nemp beenden"
* Skinoption: Hintergrundbild ausrichten am Desktop oder am Mittelteil des Players
* "Als nächstes abspielen" ins Kontextmenü der Playlist eingefügt
* StayOnTop-System modifiziert, sollte jetzt weniger buggy sein


Version 2.5, September 2006
-----------------------------------------------------------
Neue Highlights: Funktionen, die teilweise nichtmal der Windows-Media-Player hat :)
* Unterstützung von Unicode:
  - Abspielen von Dateien mit Unicode-Dateinamen
  - Auslesen von Unicode-Informationen aus den ID3-Tags
  - automatisches Konvertieren von Nicht-Unicode-ID3-Tags in den Zeichensatz, den der 
    Dateiname nahe legt (das kann der WMP10 nicht!)
* Variable Vorauswahl für die Medienliste. Nicht nur Artist-Album, sondern variabel 
  (jeweils Artist, Album, Genre, Jahr, Ordner)
* Variablere Fenstergestaltung: Kompakter Modus oder Einzelfenster

Weitere Updates
* Registrierung der Datentypen, die Nemp kennt
* Einträge in die Kontextmnenüs von Ordnern: "In Nemp abspielen/einfügen"
* Zufällige Wiedergabe der Playlist
* Option hinzugefügt: "Playlist am Ende neu mischen"
* Steuerung der im Kopfhörer abgespielten Dateien
* Auswahl der letzten 10 geladenen/gespeicherten Playlists
* Schlafmodus
* in der Stream-Auswahl gibts jetzt ein PopUp-Menü "URL aufrufen"
* Dateispezifische Hints in Playlist und Medienliste

Änderungen:
* Drag&Drop von der Medienliste in die Playlist ist auch erfolgreich, wenn die gedraggten Dateien 
  nicht vorhanden sind
* Draggen von mehr als 500 Dateien wird unterbunden
* Die vom Skin-Editor automatisch erstellten Buttongrafiken sehen jetzt etwas anders aus
* im Skineditor ist bei neuen Skins das Verzeichnis wählbar (privat/global)
* Skinsystem erweitert: Die Farbe der Equalizer-Nulllinie kann jetzt eingestellt werden
* Skinsystem erweitert: generelles Alpha-Blending in den Listen, für bessere Lesbarkeit auch 
  auf ungünstigeren Hintergrundbildern
* Fenster werden erst bei Bedarf erstellt
* Die Suche nach neuen Dateien verwendet nun SearchTools und ist dadurch etwas schneller
* Unbekannte Genres aus dem ID3v2-Tag werden jetzt in der Medienliste gespeichert

BugFixes:
* Druck auf [DEL] in den Sucheingaben führte zu einem Entfernen eines Eintrags in der Medienliste 
  oder gar zum Absturz des Programms
* Bei sehr breiten Fenster erschien u.U. eine alte, nicht mehr benötigte Komponente
* kleine Unstimmigkeit beim Zeichnen der Visualisierung behoben
* Bei aktivierten Skins konnte es u.U. zu einem unschönen Streifen im Suchfenster kommen
* Bei aktiviertem Fading wurde u.U. ein Klick auf Pause ignoriert
* ein neu erstellter Skin erschien erst nach einem Neustart in den Skin-Auswahl-Menüs
* schwarze Ecken am Rand des Fensters sollten nun seltener auftreten
* Beim Beenden von Windows wurde Nemp nicht korrekt beendet, so dass beim Neustart eine Meldung 
  diesbezüglich kam



Version 2.4, Juni 2006
-----------------------------------------------------------
Updates:
* PlugIn-System zur einfachen Unterstützung weiterer Dateiformate 
  (z.B. CD-DA, Ape, etc.)
  Download der nötigen dll-Dateien unter http://www.un4seen.com
* Unterstützung von Webradio (ShoutCast/Icecast)
  (für AAC+-Streams wird ein entsprechendes Plugin benötigt)
* Schnellsuche hinzugefügt
* Umstieg von bass2.2 auf bass2.3

Bugfixes:
* Durchsuchen des Arbeitsplatzes möglich
* Fehler bei der Darstellung der Buttons behoben

Kleinkram:
* Globale Hotkeys eingeführt
* Konfiguration der Farben für unterschiedliche Bitraten
* Konfiguration der Schriftgröße in den einzelnen Listen
* "StayOnTop" des Players


Version 2.3, Mai 2006
-----------------------------------------------------------
Updates:
* Umfangreiches Skin-System hinzugefügt, inklusive passendem Editor
* 4 verscheidene Anzeigemodi - von komplett bis minimal
* Nemp versteht jetzt Parameter - damit kann man es auch als Standard-Anwendung für 
  mp3-Dateien einrichten
* Nur eine Instanz von Nemp möglich (abschaltbar)
* Bessere Unterstützung von wma-Dateien
* Equalizer-Presets auswählbar
* Effekt-Option: Verändern der Abspielgeschwindigkeit mit oder ohne "Micky-Maus-Effekt"
* Effekt "Rückwärts abspielen" hinzugefügt
* Abspielen von Jingles während der Wiedergabe
* Drag&Drop von Artists und Alben möglich
* Minimieren in den Tray möglich
* Schönerer Splashscreen bei Programmstart mit Statusanzeige
* Option hinzugefügt für ein schnelleres Laden der Playliste
* Abspielen von diversen weiteren Dateitypen ermöglicht. Unter anderem mod, xm, aiff
* Die Zeitanzeige in der Playlist wird jetzt durch das Abspielen ggf. korrigiert
* Funktion "Medienliste als CSV exportieren" hinzugefügt
* optionales automatisches Speichern der Playlist in bestimmten Intervallen hinzugefügt

Veränderungen:
* Lyrics werden in den Dateidetails auch dann angezeigt, wenn die Datei gerade nicht 
  gefunden werden kann
* Standardwert für das Detailfenster ist jetzt "nicht sichtbar"
* Icons in der Playlist zur Anzeige, welche Datei gerade abgespielt wird etc.
* verbesserte Cover-Auswahl

Bugfixes:
* Selten auftretende Gleitkommafehler sollten jetzt gar nicht mehr auftreten
* kleinere Fehler in der GUI behoben
* Verbesserte Unterstützung von m3u-Playlisten


Version 2.2, März 2006
-----------------------------------------------------------
Updates:
* Verbesserte Unterstützung für Multimedia-Tastaturen (hoffentlich) 
  durch Verwendung eines Hooks
* Equalizer hinzugefügt (DirectX 9 benötigt (evtl. reicht auch 8))
* Effekte (Geschwindigkeit, Echo, Hall) hinzugefügt (DirectX 9 benötigt)
* Unterstützung für PLS-Playlisten

Veränderungen:
* minimale Fenstergröße herabgesetzt
* Klick auf ID3v1_Speichern bzw. ID3v2_Speichern bewirkt nun auch eine Speicherung der Änderung 
  im jeweils anderen Tag

Bugfixes:
- Drop in die playlist vom Explorer aus verursachte einen unnötigen Neuaufbau der Medienliste
- Im Headset konnten keine wma-Dateien abgespielt werden
- Nicht 100% dem Standard entsprechende M3U-Listen, wie sie Winamp manchmal erzeugt, 
  wurden unvollständig gelesen
- Beenden im maximierten Zustand bewirkte beim nächsten Laden ein unschönes Verhalten
- Tabulator-Reihenfolge im Detailfenster korrigiert
- Laden der Medienliste funktionierte unter gewissen Umständen nicht richtig


Version 2.1, Februar 2006
-----------------------------------------------------------
Major Updates/Changes:
* Interner Player hinzugefügt
  - Fade-In, Fade-Out
  - Soundkarten-Auswahl
  - Ausgabe einzelner Titel über zweite Soundkarte
  - Unterstützung von mp3, ogg, wav, wma
  - Lautstärkeregelung
  - spulen im Titel
  - Anzeige von Zeit/Restzeit
  - Unterstützung von Multimediatastaturen
* Direktes Suchen in der Medienliste vereinfacht
  - Einteilung in fest vorgegebene Kategorien wie Alben, Sampler, Maxis entfernt
  - dafür ein Artist-Album-Suchsystem implementiert:
    Artist markieren -> Anzeige aller Alben, au denen dieser vertreten ist
    Album markieren -> Anzeige aller Titel auf dem ALbum / aller Titel des 
                           ausgewählten Artists auf dem Album)
* Automatisches Speichern/Laden der Medienliste und der Playliste beim Beenden und Starten
* Änderung des Systems, das eine Laufwerksunabhängige Speicherung ermöglicht. 
  Damit ist auch ein Wechsel der Laufwerksbuchstaben bei mehreren Partitionen 
  (fast) kein Problem mehr
* Suche in eigenen Thread ausgelagert
* Funktion "Lyrics holen mit EvilLyrics" hinzugefügt


Minor Updates/Changes
* Anzeige der Medienliste leicht verändert
* Icons verändert 
* Winamp-Anbindung weiter gelockert. Durch den eigenen Player macht es keinen Sinn 
  mehr, die den Winamp-Status zu überwachen
* Icon geändert
* Umbenennung von "Gausis MP3-Verwaltung" nach "Nemp - Noch ein MP3-Player"
  


Version 2.0, September 2005
-----------------------------------------------------------
Major Updates/Changes:
* Ausführlichere Anzeige von Dateidetails
  - Anzeige von in der Datenbank gespeicherten informationen
  - Anzeige von MPEG-Informationen
  - Anzeige von id3v1/id3v1.1 Informationen
  - Anzeige von id3v2 Informationen
  - Anzeige eines evtl. vorhandenen Covers, das zu der Datei gehört
* vollständige Bearbeitung des id3v1/id3v1.1-Tags hinzugefügt
* Umfangreiche Bearbeitung des id3v2Tags, inklusive Bilder und Lyrics hinzugefügt
* Textsuche hinzugefügt - es kann nach einer Zeile im Text des Liedes gesucht werden
* Suche nach Datum/Genre hinzugefügt
* fehlertolerante Suche hinzugefügt
* Speicherplatzbedarf der .gmp Dateien um fast 50% reduziert 
* Speicherung von Kommentaren in alternativen Datenströmen (ADS) unter 
  NTFS entfernt - dazu sind jetzt die id3v2Tags da
  

Minor Updates/Changes:
* Änderung der Spaltenreihenfolge wieder möglich
* Auslesen der Information "Jahr" und "Genre" aus den ID3-Tags
* Speicherung dieser Informationen in den .gmp-Dateien
* Passwortabfrage zur Editierung der ID3-Tags entfernt - dafür gibt es 
  jetzt eine Option in den Einstellungen.
* "Fernsteuerung" für Winamp entfernt



Version 1.1, Januar 2005
-----------------------------------------------------------
* Austausch der Komponente StringGrid durch VirtualTreeView - dadurch 
  wesentlich schönere Bedienung.
* Hinzufügen einer Such-History
* einfache Beschleunigung der Suchfunktion


Version 1.0, erste Veröffentlichung, Januar 2005
-----------------------------------------------------------


