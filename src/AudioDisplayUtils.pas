{

    Unit AudioDisplayUtils

    Formatted output of several properties of AudioFiles

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2005-2022, Daniel Gaussmann
    http://www.gausi.de
    mail@gausi.de
    ---------------------------------------------------------------
    This program is free software; you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by the
    Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful, but
    WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
    for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin St, Fifth Floor, Boston, MA 02110, USA

    See license.txt for more information

    ---------------------------------------------------------------
}
unit AudioDisplayUtils;

interface

uses windows, classes, SysUtils, StrUtils, IniFiles, NempAudioFiles;

resourcestring
  rsFormatNonEmptyTitleCDDA       = 'CD-Audio, Track &d';
  rsFormatDefaultPlaylistTitle    = '%s - %s';
  rsFormatPlaylistStream          = 'Webradio: %s';
  rsFormatPlaylistStreamWithTitle = '%s: %s';
  rsFormatPlaylistTitle_AddPrebookIndex = '(%d)  %s';
  rsFormatPlaylistTitle_AddVoteCounter  = '(%d)  %s';

  rsFormatTreeBitrate     = '%d kbit/s';
  rsFormatTreeBitrateVBR  = '%d kbit/s (vbr)';
  rsFormatTreeCuePosition = '»%d:%.2d ';
  rsFormatTreeCueIndex    = '»%d';
  rsFormatTreeDuration    = '%d:%.2d ';
  rsFormatTreeFileSize    = '%.2f MB';
  rsFormatTreeSamplerate  = '%s kHz';

  rsFormatHintLineArtist        = 'Artist: %s';
  rsFormatHintLineTitle         = 'Title: %s';
  rsFormatHintLineAlbum         = 'Album: %s';
  rsFormatHintLineAlbumWithTrack = 'Album: %s (Track %d)';
  rsFormatHintLineDuration      = 'Duration: %d:%.2d min';
  rsFormatHintLineCueDuration   = 'Duration: %d:%.2d min(start at: %d:%.2d)';
  rsFormatHintLineBitrate       = 'Bitrate: %d kbit/s';
  rsFormatHintLineBitrateVBR    = 'Bitrate: %d kbit/s (vbr)';
  rsFormatHintLineFileSize      = 'FileSize: %.2f MB';
  rsFormatHintLineDirectory     = 'Directory: %s';
  rsFormatHintLineFilename      = 'Filename: %s';
  rsFormatHintLineCDAudioTrack  = 'Track: %d';

  rsFormatHintLineRating                = 'Rating: %.1f of 5 stars';
  rsFormatHintLineRatingWithPlayCounter = 'Rating: %.1f of 5 stars, played %d times';
  rsFormatHintLineReplayGainTrack       = 'ReplayGain: %.2f dB';
  rsFormatHintLineReplayGainTrackAlbum  = 'ReplayGain: %.2f dB (Album %.2f dB)';
  rsConstHintLineReplayGainNA           = 'ReplayGain: not available';

  rsFormatHintLineWebradioStaion = 'Webradio: %s';
  rsFormatHintLineWebradioURL = 'URL: %s';

  rsFormatSummaryTrackAlbum = '%s, Track %d';
  rsFormatSummaryBitrate    = '%d kbit/s';
  rsFormatSummaryQuality    = '%d kbit/s, %s kHz, %s';
  rsFormatSummaryQualityVBR = '%d kbit/s (vbr), %s kHz, %s';
  rsFormatSummaryDuration     = '%d:%.2d min';
  rsFormatSummarySize         = '%.2f MB';
  rsFormatSummaryDurationSize = '%d:%.2d min, %.2f MB';
  rsFormatSummaryDurationSizeCue = '%d:%.2d min (total %d:%.2d, %.2f MB)';
  rsFormatSummaryPlayCounter = 'Played %d times';
  rsFormatSummaryReplayGainTrack       = 'ReplayGain: %.2f dB';
  rsFormatSummaryReplayGainTrackAlbum  = 'ReplayGain: %.2f dB (Album %.2f dB)';

  rsConstSummaryWebradio     = 'Webradio';
  rsConstSummaryArtistNA     = 'Artist: -?-';
  rsConstSummaryTitleNA      = 'Title: -?-';
  rsConstSummaryAlbumNA      = 'Album: -?-';
  rsConstSummaryYearNA       = 'Year: -?-';
  rsConstSummaryGenreNA      = 'Genre: -?-';
  rsConstSummaryDurationNA   = 'Duration: -?-';
  rsConstSummaryQualityNA    = 'Audio information: -?-';
  rsConstSummaryReplayGainNA = 'ReplayGain: not available';

  rsFormatDetailsSummarySamplerateQuality = '%s kHz, %s';

  rsTreeUnknownBitrate = '-?-';
  rsTreeWebStreamDummy = '(Webstream)';
  rsTreeUnkownDuration = '-?-'; // only used if Type is "at_Undef", should never happen
  rsTreeUnlimitedDuration = '∞ ';

  //rsFormatReplayGainTrack_Short = '%6.2f dB';
  //rsFormatReplayGainAlbum_Short = '%6.2f dB (Album %6.2f dB)';
  rsFormatReplayGainTrack_WithPeak = 'Title: %.2f dB, Peak: %.6f';
  rsFormatReplayGainAlbum_WithPeak = 'Album: %.2f dB, Peak: %.6f';

const
  cCSVHeader = 'Artist;Title;Album;Genre;Year;Track;CD;Directory;Filename;Type;Filesize;Duration;Bitrate;vbr;Channelmode;Samplerate;Rating;Playcounter;Lyrics;TrackGain;AlbumGain;TrackPeak;AlbumPeak';
  cCSVFormat = '%s;%s;%s;%s;%s;%d;%s;%s;%s;%s;%d;%d;%d;%s;%s;%s;%d;%d;%s;%s;%s;%s;%s;';
  phArtist   =   '<artist>';
  phAlbum    =    '<album>';
  phTitle    =    '<title>';
  phTrack    =    '<track>';
  phYear     =     '<year>';
  phGenre    =    '<genre>';
  phStation  =   '<station>';
  phFileName = '<filename>';
  phFileNameExt = '<filenameExt>';
  phExtension=      '<ext>';
  phSubDir   =   '<subdir>';
  phDir      =      '<dir>';
  phFullPath = '<fullpath>';
  cFormatArtistTitle = '<artist> - <title>';
  cFormatArtistAlbum = '<artist> - <album>';
  cFormatWebradio = '<station>: <title>';

  Mp3db_Samplerates: Array[0..9] of String
      = (' 8.0','11.0','12.0','16.0','22.0','24.0','32.0','44.1','48.0','N/A ');

  Mp3db_Modes:  Array[0..5] of String
      = ('S ','JS','DC','M ','--', 'X');

  Mp3DB_ChannelModes : Array[0..5] of String
      = ('Stereo', 'Joint-Stereo', 'Dual-Channel', 'Mono', '', 'Multi');

{ ToDo:
  Für den Webserver wird eine zweite Version hiervon gebraucht, damit das ganze Threadsafe bleibt
  (damit Änderungen an den optionen bei laufendem Webserver möglich werden)
}


type
  (*
  0: result := ''; // Empty String
  1: result := AUDIOFILE_UNKOWN;
  2: result := ChangeFileExt(Dateiname, '');
  3: result := ExtractFileName(ExcludeTrailingPathDelimiter(Ordner));
  4: result := Ordner;
  5: result := Pfad;
  *)

  TESubstituteValue = (svEmpty, svNA, svFileName, svSubDirectory, svDirectory, svFullPath, svFileNameWithExtension);

  // ??? Das nutzen? TAudioFileStringIndex = (siArtist, siAlbum, siOrdner, siGenre, siJahr, siFileAge, siDateiname);

  TEAudioProperty = (cpArtist, cpTitle, cpAlbum, cpTrack, cpYear, cpGenre,
      cpFileName, cpFileNameExt, cpExtension, cpSubDir, cpDir, cpFullPath, cpStation );

  TSetOfAudioProperties = set of TEAudioProperty;

const
  PlaceHolders: Array[TEAudioProperty] of String = (
        phArtist, phTitle, phAlbum, phTrack, phYear, phGenre,
        phFileName, phFileNameExt, phExtension, phSubDir, phDir, phFullPath, phStation);

type

  TAudioFormatString = class
    private
      fParseString: String;
      fContainedProperties: TSetOfAudioProperties;
      procedure fSetparseString(aValue: String);
      procedure fSetNeededProperties(aValue: String);
    public
      property parseString: String read fParseString write fSetparseString;
      constructor Create(aValue: String);

      // CheckFile: Check whether FileProperties and needed properties match
      function CheckFile(aAudioFile: TAudioFile): Boolean;
      // ParsedTitle: returns the parsed Title for the AudioFile
      function ParsedTitle(aAudioFile: TAudioFile): String;
  end;

  TAudioDisplay = class
    private

      // Substitute Vales for artist/Title/Album in Treeview
      fArtistSubstitute: TESubstituteValue;
      fAlbumSubstitute : TESubstituteValue;
      fTitleSubstitute : TESubstituteValue;

      // for displaying a proper Title in the Playlist
      // including Fallback, if some wanted information is missing
      fPlaylistTitleFormat,
      fPlaylistTitleFormatFB,
      fPlaylistCueAlbumFormat,
      fPlaylistCueTitleFormat,
      fPlaylistWebradioFormat: TAudioFormatString;

      // Setter/Getter for the PlaylistTitle-FormatString ...
      procedure fSetPlaylistTitleFormat   (aValue: String);
      procedure fSetPlaylistTitleFormatFB(aValue: String);
      function fGetPlaylistTitleFormat   : String;
      function fGetPlaylistTitleFormatFB: String;
      // ... same for CueSheets, but without Fallback here ...
      procedure fSetPlaylistCueAlbumFormat(aValue: String);
      procedure fSetPlaylistCueTitleFormat(aValue: String);
      function fGetPlaylistCueAlbumFormat: String;
      function fGetPlaylistCueTitleFormat: String;
      // ... and for Webradio
      procedure fSetPlaylistWebradioFormat(aValue: String);
      function fGetPlaylistWebradioFormat   : String;

      function HintLineArtist(af: TAudioFile): String;
      function HintLineTitle(af: TAudioFile): String;
      function HintLineAlbum(af: TAudioFile): String;
      function HintLineCDAudioTrack(af: TAudioFile): String;
      function HintLineDuration(af: TAudioFile): String;
      function HintLineCueDuration(af: TAudioFile): String;
      function HintLineBitrate(af: TAudioFile): String;
      function HintLineFilename(af: TAudioFile): String;
      function HintLineDirectory(af: TAudioFile): String;
      function HintLineFileSize(af: TAudioFile): String;
      function HintLineRating(af: TAudioFile): String;
      function HintLineReplayGain(af: TAudioFile): String;
      function HintLineWebradioStation(af: TAudioFile): String;
      function HintLineWebRadioURL(af: TAudioFile): String;

      // default Playlist-Title (as in previous Nemp versions)
      function GetDefaultPlaylistTitle(af: TAudioFile): String;

      function getSubstitute(af: TAudioFile; substitute: TESubstituteValue): String;

    public
      // substitute values for the MediaLibrary VST
      property ArtistSubstitute: TESubstituteValue read fArtistSubstitute write fArtistSubstitute;
      property AlbumSubstitute : TESubstituteValue read fAlbumSubstitute  write fAlbumSubstitute ;
      property TitleSubstitute : TESubstituteValue read fTitleSubstitute  write fTitleSubstitute ;
      // templates for parsing the "combined title information"
      property PlaylistTitleFormat  : String read fGetPlaylistTitleFormat   write fSetPlaylistTitleFormat  ;
      property PlaylistTitleFormatFB: String read fGetPlaylistTitleFormatFB write fSetPlaylistTitleFormatFB;
      property PlaylistCueAlbumFormat: String read fGetPlaylistCueAlbumFormat write fSetPlaylistCueAlbumFormat;
      property PlaylistCueTitleFormat: String read fGetPlaylistCueTitleFormat write fSetPlaylistCueTitleFormat;
      property PlaylistWebradioFormat: String read fGetPlaylistWebradioFormat write fSetPlaylistWebradioFormat;

      constructor Create;
      destructor Destroy; Override;
      procedure Assign(aSourceDisplay: TAudioDisplay);

      procedure LoadSettings;
      procedure SaveSettings;

      // main methods
      // Some columns may be filled with substitute values, if they're not set
      function TreeArtist(af: TAudioFile): String;
      function TreeAlbum(af: TAudioFile): String;
      function TreeTitle(af: TAudioFile): String;
      function TreeDuration(af: TAudioFile): String;
      function TreeAudioFileIndex(af: TAudioFile; aIndex: Integer): String;
      function TreeBitrate(af: TAudioFile): String;
      function TreeFileSize(af: tAudioFile): String;
      function TreeSamplerate(af: TAudioFile): String;
      function TreeChannelmode(af: TAudioFile): String;
      function HintText(af: TAudioFile): String;

      function SummaryArtist(af: TAudioFile): String;
      function SummaryTitle(af: TAudioFile): String;
      function SummaryAlbum(af: TAudioFile): String;
      function SummaryYear(af: TAudioFile): String;
      function SummaryGenre(af: TAudioFile): String;

      function SummaryHintArtist(af: TAudioFile): String;
      function SummaryHintTitle(af: TAudioFile): String;
      function SummaryHintAlbum(af: TAudioFile): String;
      function SummaryHintYear(af: TAudioFile): String;
      function SummaryHintGenre(af: TAudioFile): String;
      function SummaryHintDirectory(af: TAudioFile): String;


      function SummaryQuality(af: TAudioFile): String;
      function SummaryBitrate(af: TAudioFile): String;
      function SummaryDuration(af: TAudioFile): String;
      function SummaryDurationSize(af: TAudioFile): String;
      function SummaryDurationSizeCue(af, mainAF: TAudioFile): String;
      function SummaryPlayCounter(af: TAudioFile): String;
      function SummaryReplayGain(af: TAudioFile): String;
      //function SummaryDuration(af: TAudioFile): String;

      function DetailSummarySamplerate(af: TAudioFile): String;

      function CSVLine(af: tAudioFile): String;

      function GetNonEmptyTitle(af: TAudioFile): String;

      // build a proper title for the playlist (a combination of different porperties)
      function PlaylistTitle(af: TAudioFile; ShowCounter: Boolean = False): String; //
      function PlaylistCueAlbum(af: TAudioFile): String;
      function PlaylistCueTitle(af: TAudioFile): String;
      function PlaylistWebradioTitle(af: TAudioFile): String;

      // Player-Display
      function PlayerLine1(MainFile, CueFile: TAudioFile): String;
      function PlayerLine2(MainFile, CueFile: TAudioFile): String;


  end;

function NempDisplay: TAudioDisplay;


implementation

uses
  Nemp_RessourceStrings, Nemp_ConstantsAndTypes, HilfsFunktionen, Math;

var
  flocalNempDisplay: TAudioDisplay;


function NempDisplay: TAudioDisplay;
begin
  if not assigned(flocalNempDisplay) then
    flocalNempDisplay := TAudioDisplay.Create;

  result := flocalNempDisplay;
end;


{ TAudioFormatString }

constructor TAudioFormatString.Create(aValue: String);
begin
  inherited create;;
  // init private fields
  ParseString := aValue;
end;

procedure TAudioFormatString.fSetparseString(aValue: String);
begin
  fParseString := aValue;
  fSetNeededProperties(aValue);
end;

procedure TAudioFormatString.fSetNeededProperties(aValue: String);
var i: TEAudioProperty;
begin
  fContainedProperties := [];
  // fill the set of needed properties
  for i := Low(TEAudioProperty) to High(TEAudioProperty) do
    if AnsiContainsText(aValue, PlaceHolders[i]) then
      fContainedProperties := fContainedProperties + [i];
end;

// CheckFile: Check whether FileProperties and needed properties match
function TAudioFormatString.CheckFile(aAudioFile: TAudioFile): Boolean;
begin
    result := NOT (
                 ((cpArtist in fContainedProperties) and (aAudioFile.Artist = ''))
              or ((cpTitle in fContainedProperties) and (aAudioFile.Titel = ''))
              or ((cpAlbum in fContainedProperties) and (aAudioFile.Album = '')) );
end;

// ParsedTitle: returns the parsed Title for the AudioFile
function TAudioFormatString.ParsedTitle(aAudioFile: TAudioFile): String;
var tmp: String;
  i: TEAudioProperty;

  function GetAudioProperty(aProp: TEAudioProperty): string;
  begin
    case aProp of
      cpArtist  : result := aAudioFile.Artist;
      cpTitle   : result := aAudioFile.Titel;
      cpAlbum   : result := aAudioFile.Album;
      cpTrack   : result := IntToStr(aAudioFile.Track);
      cpYear    : result := aAudioFile.Year;
      cpGenre   : result := aAudioFile.Genre;
      cpFileName: result := ChangeFileExt(aAudioFile.Dateiname, '');
      cpFileNameExt: result := aAudioFile.Dateiname;
      cpExtension: result := aAudioFile.Extension;
      cpSubDir  : result := ExtractFileName(ExcludeTrailingPathDelimiter(aAudioFile.Ordner));
      cpDir     : result := aAudioFile.Ordner;
      cpFullPath: result := aAudioFile.Pfad;
      cpStation : if aAudioFile.Description = '' then
                  result := aAudioFile.Ordner
                else
                  result := aAudioFile.Description;
    end;
    // note: Trim is needed, especially for property "year" in PlaylistToUSB
    // otherwise there may be some "#0" in the string, which will lead to invalid filenames and
    // erroneous behaviour
    result := trim(result);
  end;

begin
  tmp := fParseString;

  for i in fContainedProperties do
    tmp := StringReplace(tmp, PlaceHolders[i], GetAudioProperty(i), [rfIgnoreCase,rfReplaceAll]);
  result := tmp;
end;



{ TAudioDisplay }

constructor TAudioDisplay.Create;
begin
  inherited;

  fPlaylistTitleFormat    := TAudioFormatString.Create('');
  fPlaylistTitleFormatFB  := TAudioFormatString.Create('');
  fPlaylistCueAlbumFormat := TAudioFormatString.Create('');
  fPlaylistCueTitleFormat := TAudioFormatString.Create('');
  fPlaylistWebradioFormat := TAudioFormatString.Create('');

  // default values (will be overwritten by IniSettings anyway)
  fArtistSubstitute := svSubDirectory;
  fAlbumSubstitute  := svDirectory;
  fTitleSubstitute  := svFileName;

  PlaylistTitleFormat  := cFormatArtistTitle;
  PlaylistTitleFormatFB := cFormatArtistTitle;

  PlaylistCueAlbumFormat := cFormatArtistTitle;
  PlaylistCueTitleFormat := cFormatArtistTitle;
end;


destructor TAudioDisplay.Destroy;
begin
  fPlaylistTitleFormat   .Free;
  fPlaylistTitleFormatFB .Free;
  fPlaylistCueAlbumFormat.Free;
  fPlaylistCueTitleFormat.Free;
  fPlaylistWebradioFormat.Free;

  inherited;
end;

procedure TAudioDisplay.Assign(aSourceDisplay: TAudioDisplay);
begin
  fArtistSubstitute := aSourceDisplay.fArtistSubstitute;
  fAlbumSubstitute  := aSourceDisplay.fAlbumSubstitute ;
  fTitleSubstitute  := aSourceDisplay.fTitleSubstitute ;
  PlaylistTitleFormat   := aSourceDisplay.PlaylistTitleFormat ;
  PlaylistTitleFormatFB := aSourceDisplay.PlaylistTitleFormatFB ;
  PlaylistCueAlbumFormat := aSourceDisplay.PlaylistCueAlbumFormat;
  PlaylistCueTitleFormat := aSourceDisplay.PlaylistCueTitleFormat;
  //
  // todo: weitere Felder ergänzen
  //
end;

procedure TAudioDisplay.LoadSettings;

  function ReadSV(aSection, aKey: String; aDefault: TESubstituteValue): TESubstituteValue;
  var
    tmpInt: Integer;
  begin
    tmpInt := NempSettingsManager.ReadInteger(aSection, aKey , Integer(aDefault));
    if (tmpInt >= Integer(low(TESubstituteValue))) and
       (tmpInt <= Integer(high(TESubstituteValue)))
    then
      result := TESubstituteValue(tmpInt)
    else
      result := aDefault;
  end;

begin
  fPlaylistTitleFormat   .parseString := NempSettingsManager.ReadString('AudioDisplay', 'PlaylistTitleFormat', cFormatArtistTitle);
  fPlaylistTitleFormatFB .parseString := NempSettingsManager.ReadString('AudioDisplay', 'PlaylistTitleFormatFB', phTitle);
  fPlaylistCueAlbumFormat.parseString := NempSettingsManager.ReadString('AudioDisplay', 'PlaylistCueAlbumFormat', cFormatArtistAlbum);
  fPlaylistCueTitleFormat.parseString := NempSettingsManager.ReadString('AudioDisplay', 'PlaylistCueTitleFormat', cFormatArtistTitle);
  fPlaylistWebradioFormat.parseString := NempSettingsManager.ReadString('AudioDisplay', 'PlaylistWebradioFormat', cFormatWebradio);

  fArtistSubstitute := ReadSV('AudioDisplay', 'ArtistSubstitute', svFileName    );
  fTitleSubstitute  := ReadSV('AudioDisplay', 'TitleSubstitute' , svFileName    );
  fAlbumSubstitute  := ReadSV('AudioDisplay', 'AlbumSubstitute' , svSubDirectory);
end;

procedure TAudioDisplay.SaveSettings;
begin
  NempSettingsManager.WriteString('AudioDisplay', 'PlaylistTitleFormat'  , fPlaylistTitleFormat.parseString  );
  NempSettingsManager.WriteString('AudioDisplay', 'PlaylistTitleFormatFB', fPlaylistTitleFormatFB.parseString);
  NempSettingsManager.WriteString('AudioDisplay', 'PlaylistCueAlbumFormat', fPlaylistCueAlbumFormat.parseString);
  NempSettingsManager.WriteString('AudioDisplay', 'PlaylistCueTitleFormat', fPlaylistCueTitleFormat.parseString);
  NempSettingsManager.WriteString('AudioDisplay', 'PlaylistWebradioFormat', fPlaylistWebradioFormat.parseString);

  NempSettingsManager.WriteInteger('AudioDisplay', 'ArtistSubstitute', Integer(fArtistSubstitute));
  NempSettingsManager.WriteInteger('AudioDisplay', 'TitleSubstitute' , Integer(fTitleSubstitute) );
  NempSettingsManager.WriteInteger('AudioDisplay', 'AlbumSubstitute' , Integer(fAlbumSubstitute) );
end;


procedure TAudioDisplay.fSetPlaylistTitleFormat(aValue: String);
begin
  fPlaylistTitleFormat.parseString := aValue;
end;
procedure TAudioDisplay.fSetPlaylistTitleFormatFB(aValue: String);
begin
  fPlaylistTitleFormatFB.parseString := aValue;
end;
function TAudioDisplay.fGetPlaylistTitleFormat: String;
begin
  result := fPlaylistTitleFormat.parseString;
end;
function TAudioDisplay.fGetPlaylistTitleFormatFB: String;
begin
  result := fPlaylistTitleFormatFB.parseString;
end;

procedure TAudioDisplay.fSetPlaylistCueAlbumFormat(aValue: String);
begin
  fPlaylistCueAlbumFormat.parseString := aValue;
end;
procedure TAudioDisplay.fSetPlaylistCueTitleFormat(aValue: String);
begin
  fPlaylistCueTitleFormat.parseString := aValue;
end;
function TAudioDisplay.fGetPlaylistCueAlbumFormat: String;
begin
    result := fPlaylistCueAlbumFormat.parseString;
end;
function TAudioDisplay.fGetPlaylistCueTitleFormat: String;
begin
    result := fPlaylistCueTitleFormat.parseString;
end;
procedure TAudioDisplay.fSetPlaylistWebradioFormat(aValue: String);
begin
  fPlaylistWebradioFormat.parseString := aValue;
end;
function TAudioDisplay.fGetPlaylistWebradioFormat: String;
begin
  result := self.fPlaylistWebradioFormat.parseString;
end;


///  Support method for final Fallback, NempDefault
function TAudioDisplay.GetNonEmptyTitle(af: TAudioFile): String;
begin
    if UnKownInformation(af.Titel) then
        result := ChangeFileExt(af.Dateiname, '')
    else
        result := af.Titel;

    if result = '' then // possible at CDDA?
    begin
        case af.AudioType of
            at_Undef,
            at_File,
            at_Stream,
            at_CUE : result := af.Pfad;
            at_CDDA: Result := Format(rsFormatNonEmptyTitleCDDA, [af.Track]);
        end;
    end;
end;

///  Default Playlist-Titel. Final fallback, if everything else goes wrong
function TAudioDisplay.GetDefaultPlaylistTitle(af: TAudioFile): String;
begin
  case af.AudioType of
        at_Undef  : result := '';

        at_File, at_CDDA, at_CUE: begin
            if UnKownInformation(af.Artist) then
                result := GetNonEmptyTitle(af)
            else
                result := Format(rsFormatDefaultPlaylistTitle, [af.Artist, GetNonEmptyTitle(af)]);
        end;

        at_Stream : begin
            if (af.Artist <> '') and (af.Titel <> '') then  // could be the case on remote ogg-files (through "DoOggMeta")
                result := Format(rsFormatDefaultPlaylistTitle, [af.Artist, GetNonEmptyTitle(af)])
            else
            begin
                if (af.Titel <> '') and (af.Titel <> af.Pfad) then
                    result := Format(rsFormatPlaylistStreamWithTitle, [af.Description, af.Titel])
                else
                    if af.Description <> '' then
                        result := Format(rsFormatPlaylistStream, [af.Description])
                    else
                        result := Format(rsFormatPlaylistStream, [af.Ordner]);
            end;
        end;
    end;

    if result = '' then
        result := af.Pfad;
end;


function TAudioDisplay.PlaylistTitle(af: TAudioFile; ShowCounter: Boolean = False): String;
begin
{
### Hier ggf. auch noch nach Typ des AudioFiles unterscheiden?
### File, Stream, CD, Cue?
### at_File, at_Stream, at_CDDA, at_CUE, <NEU> AT_FileMitCueList
}
  case af.AudioType of
    at_File,
    at_CDDA: begin
      if assigned(af.CueList) then
        result := PlaylistCueAlbum(af)
      else begin
        if fPlaylistTitleFormat.CheckFile(af) then
          result := fPlaylistTitleFormat.ParsedTitle(af)
        else
          if fPlaylistTitleFormatFB.CheckFile(af) then
            result := fPlaylistTitleFormatFB.ParsedTitle(af)
          else
            result := GetDefaultPlaylistTitle(af);
      end;
    end;
    at_Stream: begin
        result := PlaylistWebradioTitle(af);
    end;
    at_CUE: begin
      result := PlaylistCueTitle(af);
    end
  else
    result := '';
  end;

  if ShowCounter then
  begin
    if af.PrebookIndex > 0 then
      result := Format(rsFormatPlaylistTitle_AddPrebookIndex, [af.PrebookIndex, result])
    else
      if af.VoteCounter > 0 then
        result := Format(rsFormatPlaylistTitle_AddVoteCounter, [af.VoteCounter, result]);
  end;
end;

function TAudioDisplay.PlaylistCueAlbum(af: TAudioFile): String;
begin
  if fPlaylistCueAlbumFormat.CheckFile(af) then
    result := fPlaylistCueAlbumFormat.ParsedTitle(af)
  else
    result := GetDefaultPlaylistTitle(af);
end;

function TAudioDisplay.PlaylistCueTitle(af: TAudioFile): String;
begin
  if fPlaylistCueTitleFormat.CheckFile(af) then
    result := fPlaylistCueTitleFormat.ParsedTitle(af)
  else
    result := GetDefaultPlaylistTitle(af);
end;


function TAudioDisplay.PlaylistWebradioTitle(af: TAudioFile): String;
begin
  if fPlaylistWebradioFormat.CheckFile(af) then
    result := fPlaylistWebradioFormat.ParsedTitle(af)
  else
    result := GetDefaultPlaylistTitle(af);
end;

function TAudioDisplay.getSubstitute(af: TAudioFile; substitute: TESubstituteValue): String;
begin
  case substitute of
    svEmpty: result := '';
    svNA: result := AUDIOFILE_UNKOWN;
    svFileName: result := ChangeFileExt(af.Dateiname, '');
    svSubDirectory: result := ExtractFileName(ExcludeTrailingPathDelimiter(af.Ordner));
    svDirectory: result := af.Ordner;
    svFullPath: result := af.Pfad;
    svFileNameWithExtension: result := af.Dateiname;
  else
    result := '';
  end;
end;

function TAudioDisplay.TreeAlbum(af: TAudioFile): String;
begin
  case af.AudioType of
    // special case Webstream: no information available for TreeView
    at_Stream: result := rsTreeWebStreamDummy;
  else
    begin
      if trim(af.Album) = '' then
        result := getSubstitute(af, fAlbumSubstitute)
      else
        result := af.Album;
    end;
  end;
end;

function TAudioDisplay.TreeArtist(af: TAudioFile): String;
begin
  case af.AudioType of
    // special case Webstream: no information available for TreeView
    at_Stream: result := rsTreeWebStreamDummy;
  else
    begin
      if trim(af.Artist) = '' then
        result := getSubstitute(af, fArtistSubstitute)
      else
        result := af.Artist;
    end;
  end;
end;

function TAudioDisplay.TreeTitle(af: TAudioFile): String;
begin
  case af.AudioType of
    // special case Webstream: no information available for TreeView
    at_Stream: result := rsTreeWebStreamDummy;
  else
    begin
      if trim(af.Titel) = '' then
        result := getSubstitute(af, fTitleSubstitute)
      else
        result := af.Titel;
    end;
  end;
end;

function TAudioDisplay.TreeBitrate(af: TAudioFile): String;
begin
  if af.Bitrate > 0 then
  begin
    if af.vbr then
      result := Format(rsFormatTreeBitrateVBR, [af.Bitrate])
    else
      result := Format(rsFormatTreeBitrate, [af.Bitrate])
  end
  else
    result := rsTreeUnknownBitrate;
end;

function TAudioDisplay.TreeDuration(af: TAudioFile): String;
begin
  case af.AudioType of
    at_Undef  : result := rsTreeUnkownDuration;
    at_File,
    at_CDDA   : begin
        if af.Bitrate = 0 then
          result := rsTreeUnkownDuration
        else
          result := Format(rsFormatTreeDuration, [af.Duration Div 60, af.Duration mod 60]);
    end;
    at_Stream : result := rsTreeUnlimitedDuration;
    at_Cue    : result := Format(rsFormatTreeCuePosition, [Round(af.Index01) Div 60, Round(af.Index01) mod 60] );
  end;
end;

function TAudioDisplay.TreeAudioFileIndex(af: TAudioFile; aIndex: Integer): String;
begin
  if af.AudioType = at_CUE then
    result := Format(rsFormatTreeCueIndex, [aIndex])
  else
    result := IntToStr(aIndex);
end;

function TAudioDisplay.TreeFileSize(af: tAudioFile): String;
begin
  result := Format(rsFormatTreeFileSize, [af.Size / 1024 / 1024]);
end;

function TAudioDisplay.TreeSamplerate(af: TAudioFile): String;
begin
  result := Format(rsFormatTreeSamplerate, [Mp3db_Samplerates[af.SamplerateIDX]]);
end;

function TAudioDisplay.TreeChannelmode(af: TAudioFile): String;
begin
  result := Mp3DB_ChannelModes[af.ChannelModeIdx];
end;





function TAudioDisplay.HintLineArtist(af: TAudioFile): String;
begin
  result := Format(rsFormatHintLineArtist, [af.Artist]);
end;

function TAudioDisplay.HintLineTitle(af: TAudioFile): String;
begin
  result := Format(rsFormatHintLineTitle, [af.Titel]);
end;

function TAudioDisplay.HintLineAlbum(af: TAudioFile): String;
begin
  if af.Track <> 0 then
    result := Format(rsFormatHintLineAlbumWithTrack, [af.Album, af.Track])
  else
    result := Format(rsFormatHintLineAlbum, [af.Album])
end;

function TAudioDisplay.HintLineCDAudioTrack(af: TAudioFile): String;
begin
  result := Format(rsFormatHintLineCDAudioTrack, [af.Track]);
end;

function TAudioDisplay.HintLineBitrate(af: TAudioFile): String;
begin
  if af.vbr then
    result := Format(rsFormatHintLineBitrateVBR, [af.Bitrate])
  else
    result := Format(rsFormatHintLineBitrate, [af.Bitrate])
end;

function TAudioDisplay.HintLineDuration(af: TAudioFile): String;
begin
  result := Format(rsFormatHintLineDuration, [af.Duration Div 60, af.Duration mod 60]);
end;

function TAudioDisplay.HintLineCueDuration(af: TAudioFile): String;
begin
  result := Format(rsFormatHintLineCueDuration, [af.Duration Div 60, af.Duration mod 60, Round(af.Index01) Div 60, Round(af.Index01) mod 60]);
end;

function TAudioDisplay.HintLineFilename(af: TAudioFile): String;
begin
  result := Format(rsFormatHintLineFilename, [af.Dateiname]);
end;

function TAudioDisplay.HintLineDirectory(af: TAudioFile): String;
begin
  result := Format(rsFormatHintLineDirectory, [af.Ordner]);
end;

function TAudioDisplay.HintLineFileSize(af: TAudioFile): String;
begin
  result := Format(rsFormatHintLineFileSize, [af.Size / 1024 / 1024]);
end;
function TAudioDisplay.HintLineRating(af: TAudioFile): String;
begin
  if (af.PlayCounter > 0) then
    result := Format(rsFormatHintLineRatingWithPlayCounter, [af.RoundedRating, af.PlayCounter])
  else
    result := Format(rsFormatHintLineRating, [af.RoundedRating]);
end;

function TAudioDisplay.HintLineReplayGain(af: TAudioFile): String;
begin
  if (Not IsZero(af.TrackGain)) and (Not isZero(af.AlbumGain)) then
    result := Format(rsFormatHintLineReplayGainTrackAlbum, [af.TrackGain, af.AlbumGain])
  else
    if (Not IsZero(af.TrackGain)) then
      result := Format(rsFormatHintLineReplayGainTrack, [af.TrackGain])
    else
      result := rsConstHintLineReplayGainNA;
end;

function TAudioDisplay.HintLineWebradioStation(af: TAudioFile): String;
begin
  result := Format(rsFormatHintLineWebradioStaion, [af.Description]);
end;

function TAudioDisplay.HintLineWebRadioURL(af: TAudioFile): String;
begin
  result := Format(rsFormatHintLineWebradioURL, [af.Pfad]);
end;


function TAudioDisplay.HintText(af: TAudioFile): String;
begin
    case af.AudioType of
        at_Undef: result := '';

        at_File: begin
           result :=
              HintLineArtist(af)    + #13#10 +
              HintLineTitle(af)     + #13#10 +
              HintLineAlbum(af)     + #13#10 +
              HintLineDuration(af)  + #13#10 +
              HintLineBitrate(af)   + #13#10 +
              HintLineFileSize(af)  + #13#10 +
              HintLineFilename(af)  + #13#10 +
              HintLineDirectory(af) + #13#10 +
              HintLineRating(af)    + #13#10 +
              HintLineReplayGain(af);
        end;

        at_Stream: begin
            result :=
              HintLineWebradioStation(af) + #13#10 +
              HintLineWebRadioURL(af);
        end;

        at_cue: begin
            result :=
              HintLineArtist(af)   + #13#10 +
              HintLineTitle(af)    + #13#10 +
              HintLineCueDuration(af) + #13#10 +
              HintLineFilename(af) + #13#10 +
              HintLineDirectory(af);
        end;

        at_CDDA: begin
            if trim(af.Artist) = '' then
                result :=
                  HintLineCDAudioTrack(af) + #13#10 +
                  HintLineAlbum(af)
            else
                result :=
                  HintLineArtist(af) + #13#10 +
                  HintLineTitle(af)  + #13#10 +
                  HintLineAlbum(af)  + #13#10 +
                  HintLineDuration(af);
        end;
    end;
end;


    {
rsConstSummaryArtistNA
rsConstSummaryTitleNA
rsConstSummaryAlbumNA
rsConstSummaryYearNA
rsConstSummaryGenreNA    }

function TAudioDisplay.SummaryArtist(af: TAudioFile): String;
begin
  if Trim(af.Artist) = '' then
    result := rsConstSummaryArtistNA
  else
    result := af.Artist;
end;

function TAudioDisplay.SummaryTitle(af: TAudioFile): String;
begin
  if Trim(af.Titel) = '' then
    result := rsConstSummaryTitleNA
  else
    result := af.Titel;
end;

function TAudioDisplay.SummaryAlbum(af: TAudioFile): String;
begin
  if Trim(af.Album) = '' then
    result := rsConstSummaryAlbumNA
  else
  begin
    if af.Track <> 0 then
      result := Format(rsFormatSummaryTrackAlbum, [af.Album, af.Track])
    else
      result := af.Album;
  end;
end;

function TAudioDisplay.SummaryYear(af: TAudioFile): String;
begin
  if (Trim(af.Year) = '') or (af.Year = '0') then
    result := rsConstSummaryYearNA
  else
    result := af.Year;
end;

function TAudioDisplay.SummaryGenre(af: TAudioFile): String;
begin
  if af.AudioType = at_Stream then
    result := rsConstSummaryWebradio
  else
  begin
    if Trim(af.Genre) = '' then
      result := rsConstSummaryGenreNA
    else
      result := af.Genre;
  end;
end;

function TAudioDisplay.SummaryHintArtist(af: TAudioFile): String;
begin
  if af.IsValidArtist then
    result := Format(MainForm_DoublClickToSearchArtist, [af.Artist])
  else
    result := '';
end;

function TAudioDisplay.SummaryHintTitle(af: TAudioFile): String;
begin
  if af.IsValidTitle then
    result := Format(MainForm_DoublClickToSearchTitle, [af.Titel])
  else
    result := '';
end;

function TAudioDisplay.SummaryHintAlbum(af: TAudioFile): String;
begin
  if af.IsValidAlbum then
    result := Format(MainForm_DoublClickToSearchAlbum, [af.Album])
  else
    result := '';
end;

function TAudioDisplay.SummaryHintYear(af: TAudioFile): String;
begin
  if af.IsValidYear then
    result := Format(MainForm_DoublClickToSearchYear, [af.Year])
  else
    result := '';
end;

function TAudioDisplay.SummaryHintGenre(af: TAudioFile): String;
begin
  if af.IsValidGenre then
    result := Format(MainForm_DoublClickToSearchGenre, [af.Genre])
  else
    result := '';
end;

function TAudioDisplay.SummaryHintDirectory(af: TAudioFile): String;
begin
  result := MainForm_DoublClickToSearchDirectory;
end;


///  Note: Indicator for "valid" audio information is "bitrate <> 0"
///        If an AudioFile has bitrate=0, Nemp couldn't recognize the audio format.
///        It's probably some exotic format the bass.dll can process, but not widely used for actual music
function TAudioDisplay.SummaryQuality(af: TAudioFile): String;
begin
  if af.Bitrate = 0 then
    result := rsConstSummaryQualityNA
  else
  begin
    if af.vbr then
      result :=
        Format(rsFormatSummaryQualityVBR, [af.Bitrate, Mp3db_Samplerates[af.SamplerateIDX], Mp3DB_ChannelModes[af.ChannelModeIdx] ])
    else
      result :=
        Format(rsFormatSummaryQuality   , [af.Bitrate, Mp3db_Samplerates[af.SamplerateIDX], Mp3DB_ChannelModes[af.ChannelModeIdx] ])
  end;
end;

function TAudioDisplay.SummaryBitrate(af: TAudioFile): String;
begin
  result := Format(rsFormatSummaryBitrate, [af.Bitrate])
end;

function TAudioDisplay.SummaryDuration(af: TAudioFile): String;
begin
  if af.Bitrate = 0 then
    result := rsConstSummaryDurationNA
  else
    result := Format(rsFormatSummaryDuration, [af.Duration Div 60, af.Duration mod 60])
end;

function TAudioDisplay.SummaryDurationSize(af: TAudioFile): String;
begin
  if af.Bitrate = 0 then
    result := Format(rsFormatSummarySize, [af.Size / 1024 / 1024])
  else
    result := Format(rsFormatSummaryDurationSize, [af.Duration Div 60, af.Duration mod 60, af.Size / 1024 / 1024])
end;

function TAudioDisplay.SummaryDurationSizeCue(af, mainAF: TAudioFile): String;
begin
  result := Format(rsFormatSummaryDurationSizeCue,
                     [af.Duration Div 60, af.Duration mod 60,
                      mainAF.Duration Div 60, mainAF.Duration mod 60,
                      mainAF.Size / 1024 / 1024]);
end;

function TAudioDisplay.SummaryPlayCounter(af: TAudioFile): String;
begin
  Format(rsFormatSummaryPlayCounter, [af.PlayCounter]);
end;

function TAudioDisplay.SummaryReplayGain(af: TAudioFile): String;
begin
  if (Not IsZero(af.TrackGain)) and (Not isZero(af.AlbumGain)) then
    result := Format(rsFormatSummaryReplayGainTrackAlbum, [af.TrackGain, af.AlbumGain])
  else
    if (Not IsZero(af.TrackGain)) then
      result := Format(rsFormatSummaryReplayGainTrack, [af.TrackGain])
    else
      result := rsConstSummaryReplayGainNA;
end;

function TAudioDisplay.DetailSummarySamplerate(af: TAudioFile): String;
begin
  result := Format(rsFormatDetailsSummarySamplerateQuality,
              [Mp3db_Samplerates[af.SamplerateIDX],
               Mp3DB_ChannelModes[af.ChannelModeIdx]]);
end;



function TAudioDisplay.CSVLine(af: tAudioFile): String;
var vbrstr, Lyricsstr : UnicodeString;

    function EscapeStr(aStr: String): String;
    begin
      result := StringReplace(aStr, ';', ',', [rfReplaceAll])
    end;

begin
  if af.vbr then
    vbrstr := 'vbr'
  else
    vbrstr := 'cbr';

  if af.LyricsExisting then
    Lyricsstr := 'ok'
  else
    Lyricsstr := 'N/A';

  result :=  Format(cCSVFormat,
        [ EscapeStr(af.Artist),
          EscapeStr(af.Titel),
          EscapeStr(af.Album),
          EscapeStr(af.Genre),
          EscapeStr(af.Year),
          af.Track,
          af.CD,
          EscapeStr(af.Ordner),
          EscapeStr(af.Dateiname),
          EscapeStr(af.Extension),
          af.Size,
          af.Duration,
          af.Bitrate,
          vbrStr,
          Mp3DB_ChannelModes[af.ChannelModeIdx],
          Mp3db_Samplerates[af.SamplerateIDX],
          af.Rating,
          af.PlayCounter,
          LyricsStr,
          GainValueToString(af.TrackGain),
          GainValueToString(af.AlbumGain),
          PeakValueToString(af.TrackPeak),
          PeakValueToString(af.AlbumPeak)
        ]);
end;

function TAudioDisplay.PlayerLine1(MainFile, CueFile: TAudioFile): String;
begin
    if not assigned(MainFile) then
        result := ''
    else
    begin
        // get a proper display string for the player
        // 1st line (in most cases: "Artist")
        case MainFile.AudioType of
            at_Undef: result := '';
            at_File,
            at_CDDA: begin
                    if assigned(CueFile) then
                        result := PlaylistTitle(MainFile)   // yes, Mainfile, not cuefile here!
                    else
                    begin
                        // usual case: just the "Artist"
                        if MainFile.Artist <> '' then
                            result := MainFile.Artist
                        else
                            result := Player_UnkownArtist;
                    end;
            end;

            at_Stream: begin
                    if (MainFile.artist <> '') and (MainFile.titel <> '') then  // could be the case on remote ogg-files (through "DoOggMeta")
                        result := MainFile.Artist
                    else
                        result := MainFile.Description;
            end;
        else
            // at_CUE should not happen here
            result := '';
        end;
    end;
end;
function TAudioDisplay.PlayerLine2(MainFile, CueFile: TAudioFile): String;
begin
    if not assigned(MainFile) then
        result := ''
    else
    begin
        // get a proper display string for the player
        // 2nd line (in most cases: "Title")
        case MainFile.AudioType of
            at_Undef  : result := '';
            at_File,
            at_CDDA   : begin
                    if assigned(CueFile) then
                        result := PlaylistTitle(CueFile)
                    else
                        // usual case: just the "Title"
                        result := GetNonEmptyTitle(MainFile); // MainFile.NonEmptyTitle;
            end;
            at_Stream : begin
                        result := MainFile.Titel
            end
        else
            //at_CUE should not happen here
            result := '';
        end;
    end;
end;



initialization

  flocalNempDisplay := Nil;

finalization

  if assigned(flocalNempDisplay) then
    flocalNempDisplay.Free;

end.
