{

    Unit Details
    Form TFDetails

    - Show Details from AudioFiles
    - Edit ID3Tags, including basic-stuff like title, artist,
                    Lyrics (with search function for LyricWiki.org)
                    Pictures

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2005-2010, Daniel Gaussmann
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
unit Details;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Contnrs,
  Dialogs, NempAudioFiles, StdCtrls, ExtCtrls, StrUtils, JPEG, PNGImage, GifImg,
  ShellApi, ComCtrls, U_CharCode, myDialogs,

  AudioFileBasics, Mp3FileUtils, ID3v2Frames, ID3GenreList, Mp3Files, FlacFiles, OggVorbisFiles,
  VorbisComments, AudioFiles, Apev2Tags, ApeTagItem, MusePackFiles, cddaUtils,
  M4AFiles, M4AAtoms,

  CoverHelper, Buttons, ExtDlgs, ImgList,  Hilfsfunktionen, Systemhelper, HtmlHelper,
  Nemp_ConstantsAndTypes, gnuGettext, Lyrics,
  Nemp_RessourceStrings,  IdBaseComponent, IdComponent, TagClouds,
  IdTCPConnection, IdTCPClient, IdHTTP, Menus, RatingCtrls, Spin;

type
  TFDetails = class(TForm)
    Btn_Close: TButton;
    MainPageControl: TPageControl;
    Tab_General: TTabSheet;
    GrpBox_File: TGroupBox;
    Btn_Explore: TButton;
    GrpBox_Title: TGroupBox;
    Btn_Actualize: TButton;
    GrpBox_Quality: TGroupBox;
    GrpBox_Cover: TGroupBox;
    CoverIMAGE: TImage;
    Btn_OpenImage: TButton;
    Tab_MpegInformation: TTabSheet;
    GrpBox_ID3v1: TGroupBox;
    GrpBox_ID3v2: TGroupBox;
    Btn_Properties: TButton;
    Timer1: TTimer;
    Tab_Lyrics: TTabSheet;
    GrpBox_Lyrics: TGroupBox;
    PnlWarnung: TPanel;
    Image1: TImage;
    Btn_DeleteLyricFrame: TButton;
    Tab_ExtendedID3v2: TTabSheet;
    BtnLyricWiki: TButton;
    GrpBox_Pictures: TGroupBox;
    Btn_NewPicture: TButton;
    Btn_DeletePicture: TButton;
    Btn_SavePictureToFile: TButton;
    GrpBox_Mpeg: TGroupBox;
    GrpBox_TextFrames: TGroupBox;
    ID3Image: TImage;
    Bevel1: TBevel;
    BtnApply: TButton;
    BtnUndo: TButton;
    CBID3v1: TCheckBox;
    CBID3v2: TCheckBox;
    BtnCopyFromV2: TButton;
    BtnCopyFromV1: TButton;
    Lblv2Copyright: TLabeledEdit;
    Lblv2Composer: TLabeledEdit;
    LvFrames: TListView;
    GrpBox_ID3v2Info: TGroupBox;
    LblConst_Id3v2Version: TLabel;
    LblConst_Id3v2Size: TLabel;
    Lblv2_Size: TLabel;
    Lblv2_Version: TLabel;
    RatingImageBib: TImage;
    IdHTTP1: TIdHTTP;
    BtnLyricWikiManual: TButton;
    PM_URLCopy: TPopupMenu;
    PM_CopyURLToClipboard: TMenuItem;
    LBLName: TLabel;
    LBLSize: TLabel;
    LlblConst_FileSize: TLabel;
    LlblConst_Filename: TLabel;
    LlblConst_Path: TLabel;
    LBLPfad: TLabel;
    Lbl_Warnings: TLabel;
    LBLArtist: TLabel;
    LBLTitel: TLabel;
    LBLAlbum: TLabel;
    LBLYear: TLabel;
    LBLGenre: TLabel;
    LlblConst_Artist: TLabel;
    LlblConst_Title: TLabel;
    LlblConst_Album: TLabel;
    LlblConst_Year: TLabel;
    LlblConst_Genre: TLabel;
    LBLDauer: TLabel;
    LlblConst_Duration: TLabel;
    LlblConst_Comment: TLabel;
    LBLKommentar: TLabel;
    LlblConst_Track: TLabel;
    LBLTrack: TLabel;
    LBLBitrate: TLabel;
    LBLSamplerate: TLabel;
    LlblConst_Samplerate: TLabel;
    LlblConst_Bitrate: TLabel;
    LblConst_Rating: TLabel;
    LblRating: TLabel;
    Lbl_FoundCovers: TLabel;
    LblConst_ID3v1Artist: TLabel;
    LblConst_ID3v1Title: TLabel;
    LblConst_ID3v1Album: TLabel;
    LblConst_ID3v1Year: TLabel;
    LblConst_ID3v1Genre: TLabel;
    LblConst_ID3v1Comment: TLabel;
    LblConst_ID3v1Track: TLabel;
    LblConst_ID3v2Artist: TLabel;
    LblConst_ID3v2Title: TLabel;
    LblConst_ID3v2Album: TLabel;
    LblConst_ID3v2Year: TLabel;
    LblConst_ID3v2Genre: TLabel;
    LblConst_ID3v2Comment: TLabel;
    LblConst_ID3v2Track: TLabel;
    LblConst_MpegBitrate: TLabel;
    LblConst_MpegSamplerate: TLabel;
    LblConst_MpegOriginal: TLabel;
    LblConst_MpegEmphasis: TLabel;
    LblConst_MpegVersion: TLabel;
    LblConst_MpegCopyright: TLabel;
    LblConst_MpegProtection: TLabel;
    LblConst_MpegHeader: TLabel;
    LblConst_MpegExtension: TLabel;
    LblConst_MpegDuration: TLabel;
    LblDETBitrate: TLabel;
    LblDETSamplerate: TLabel;
    LblDETDauer: TLabel;
    LblDETVersion: TLabel;
    LblDETHeaderAt: TLabel;
    LblDETProtection: TLabel;
    LblDETExtension: TLabel;
    LblDETCopyright: TLabel;
    LblDETOriginal: TLabel;
    LblDETEmphasis: TLabel;
    SaveDialog1: TSaveDialog;
    Lblv1Album: TEdit;
    Lblv1Artist: TEdit;
    Lblv1Titel: TEdit;
    Lblv1Year: TEdit;
    Lblv1Comment: TEdit;
    Lblv1Track: TEdit;
    Lblv2Artist: TEdit;
    Lblv2Titel: TEdit;
    Lblv2Album: TEdit;
    Lblv2Year: TEdit;
    Lblv2Comment: TEdit;
    Lblv2Track: TEdit;
    CoverBox: TComboBox;
    cbPictures: TComboBox;
    Memo_Lyrics: TMemo;
    ReloadTimer: TTimer;
    LblRatingImage: TLabel;
    RatingImageID3: TImage;
    BtnResetRating: TButton;
    LblPlayCounter: TLabel;
    cbIDv1Genres: TComboBox;
    cbIDv2Genres: TComboBox;
    Tab_VorbisComments: TTabSheet;
    GrpBox_StandardVorbisComments: TGroupBox;
    Lbl_VorbisArtist: TLabel;
    Edt_VorbisArtist: TEdit;
    Lbl_VorbisTitle: TLabel;
    Edt_VorbisTitle: TEdit;
    Lbl_VorbisAlbum: TLabel;
    Edt_VorbisAlbum: TEdit;
    Lbl_VorbisComment: TLabel;
    Edt_VorbisComment: TEdit;
    Lbl_VorbisGenre: TLabel;
    cb_VorbisGenre: TComboBox;
    Lbl_VorbisYear: TLabel;
    Edt_VorbisYear: TEdit;
    Lbl_VorbisTrack: TLabel;
    Edt_VorbisTrack: TEdit;
    Lbl_VorbisRating: TLabel;
    RatingImageVorbis: TImage;
    Btn_ResetVorbisRating: TButton;
    GrpBox_AllVorbisComments: TGroupBox;
    Memo_Vorbis: TMemo;
    Edt_VorbisCopyright: TLabeledEdit;
    Lbl_VorbisContent: TLabel;
    Lbl_VorbisKey: TLabel;
    Tab_MoreTags: TTabSheet;
    GrpBox_TagCloud: TGroupBox;
    Btn_GetTagsLastFM: TButton;
    BtnSynchRatingID3: TButton;
    BtnSynchRatingOggVorbis: TButton;
    LblConst_ID3v2CD: TLabel;
    Lblv2CD: TEdit;
    Lbl_VorbisCD: TLabel;
    Edt_VorbisCD: TEdit;
    lv_VorbisComments: TListBox;
    LblConst_Format: TLabel;
    LblFormat: TLabel;
    lb_Tags: TListBox;
    btn_AddTag: TButton;
    Btn_RemoveTag: TButton;
    Btn_RenameTag: TButton;
    PM_EditExtendedTags: TPopupMenu;
    pm_AddTag: TMenuItem;
    pm_RenameTag: TMenuItem;
    pm_RemoveTag: TMenuItem;
    Btn_TagCloudEditor: TButton;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);

    // Used by webstreams - Open the URL in Webbrowser or copy it
    procedure LBLPfadClick(Sender: TObject);
    procedure PM_CopyURLToClipboardClick(Sender: TObject);

    // three Buttons and CheckBox on bottom of the form
    procedure BtnApplyClick(Sender: TObject);
    procedure BtnUndoClick(Sender: TObject);
    procedure Btn_CloseClick(Sender: TObject);

    // Some EventHandler for page 1
    procedure Btn_ExploreClick(Sender: TObject);
    procedure Btn_PropertiesClick(Sender: TObject);
    procedure Btn_ActualizeClick(Sender: TObject);

    // Procedures for editing the rating of the current file
    procedure RatingImageID3MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure RatingImageID3MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RatingImageID3MouseLeave(Sender: TObject);
    procedure BtnResetRatingClick(Sender: TObject);

    // EventHandler for Cover on page 1
    procedure Btn_OpenImageClick(Sender: TObject);
    procedure CoverIMAGEDblClick(Sender: TObject);
    procedure CoverBoxChange(Sender: TObject);
    // Load an image from Pfad and shows it on page 1
    procedure ZeigeBild(Pfad: UnicodeString);
    // Timer that calls "ZeigeBild" with a short delay
    procedure Timer1Timer(Sender: TObject);

    // Some methods to (de)activate some controls
    procedure UpdateMediaBibEnabledStatus;
    //Procedure UpdateID3ReadOnlyStatus;
    Procedure UpdateID3v1EnabledStatus;
    Procedure UpdateID3v2EnabledStatus;
    Procedure UpdateMPEGEnabledStatus;

    // Some Eventhandler dealing with ID3-stuff
    procedure CBID3v1Click(Sender: TObject);
    procedure CBID3v2Click(Sender: TObject);
    procedure BtnCopyFromV1Click(Sender: TObject);
    procedure BtnCopyFromV2Click(Sender: TObject);

    // Live-Checking for valid inputs
    procedure Lblv2TrackChange(Sender: TObject);
    procedure Lblv1TrackChange(Sender: TObject);
    procedure Lblv1YearChange(Sender: TObject);
    procedure Lblv2YearChange(Sender: TObject);

    // Show all the Details for an AudioFile
    // Source: Gibt an, ob bei einem Edit der Datei die Medienbib aktualisiert werden muss
    procedure ShowDetails(AudioFile: TAudioFile; Source: Integer = SD_MEDIENBIB);

    // Methods for advanced ID3v2-Tag Editing
    // Lyrics and Pictures
    procedure Btn_DeleteLyricFrameClick(Sender: TObject);
    procedure cbPicturesChange(Sender: TObject);
    procedure Btn_NewPictureClick(Sender: TObject);
    procedure Btn_DeletePictureClick(Sender: TObject);
    procedure Btn_SavePictureToFileClick(Sender: TObject);

    // DoubleClick on an URL-Frame will open the URL in webbrowser
    procedure LvFramesDblClick(Sender: TObject);

    // used for Ctrl+A
    procedure Memo_LyricsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    // Getting Lyrics
    procedure BtnLyricWikiClick(Sender: TObject);
    procedure BtnLyricWikiManualClick(Sender: TObject);
    procedure ReloadTimerTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Lblv1Change(Sender: TObject);
    procedure Lblv2Change(Sender: TObject);
    procedure Memo_LyricsChange(Sender: TObject);
    procedure TagsHasChanged(newIdx: Integer; hasChanged: Boolean = True);
    procedure Btn_GetTagsLastFMClick(Sender: TObject);
    procedure BtnSynchRatingID3Click(Sender: TObject);
    procedure lv_VorbisCommentsClick(Sender: TObject);
    procedure Edt_VorbisChange(Sender: TObject);
    procedure btn_AddTagClick(Sender: TObject);
    procedure Btn_RenameTagClick(Sender: TObject);
    procedure Btn_RemoveTagClick(Sender: TObject);
    //procedure lb_TagsKeyDown(Sender: TObject; var Key: Word;
    //  Shift: TShiftState);
    procedure lb_TagsDblClick(Sender: TObject);
    procedure Btn_TagCloudEditorClick(Sender: TObject);
    //procedure pm_AddIgnoreRuleClick(Sender: TObject);
    //procedure pm_AddRenameRuleClick(Sender: TObject);

  private
    Coverpfade : TStringList;

    PictureFrames: TObjectList;
    fFileFromMedienBib: Boolean;

    // Speichert die "temporäre Existenz" der ID3Tags, d.h. ob der User sie aktiviert hat oder nicht
    ID3v1Activated: Boolean;
    ID3v2Activated: Boolean;
    CurrentTagRatingChanged: Boolean;
    CurrentTagRating: Byte;
    CurrentTagCounter: Cardinal;
    CurrentBibRating: Byte;
    CurrentBibCounter: Cardinal;
    PictureHasChanged: Boolean;
    ID3v1HasChanged: Boolean;
    ID3v2HasChanged: Boolean;
    VorbisCommentHasChanged: Boolean;
    ApeTagHasChanged: Boolean;
    M4aTagHasChanged: Boolean;

    // ForceChange: ShowDetails without showing a "Do you want to save..."-Message
    fForceChange: Boolean;

    DetailRatingHelper: TRatingHelper;

    // Show some information of the selected audiofile
    procedure ShowMediaBibDetails;
    procedure ShowMPEGDetails(mp3: TMp3File);
    procedure ShowID3v1Details(mp3: TMp3File);
    procedure EnablePictureButtons;
    procedure LoadApeImage(aKey: AnsiString);
    procedure ShowPictures;
    procedure ShowLyrics;
    procedure ShowAdditionalTags;

    //procedure ShowRating(Value: Integer);
    procedure FillFrameView(mp3: TMp3File);
    procedure ShowID3v2Details(mp3: TMp3File);

    procedure ShowOggDetails(ogg: TOggVorbisFile);
    procedure ShowFlacDetails(flac: TFlacFile);
    procedure ShowApeDetails(ape: TBaseApeFile);
    procedure ShowM4ADeatils(m4a: TM4AFile);

    // Save information to ID3-Tag
    function UpdateID3v1InFile(mp3: TMp3File): TMp3Error;
    function UpdateID3v2InFile(mp3: TMp3File): TMp3Error;
    function UpdateOggVorbisInFile(ogg: TOggVorbisFile): TAudioError;
    function UpdateFlacInFile(flac: TFlacFile): TAudioError;
    function UpdateM4AInFile(m4a: TM4AFile): TAudioError;
    function UpdateApeTagInFile(ape: TbaseApeFile): TAudioError;



    function CurrentFileHasBeenChanged: Boolean;

  public
    CurrentTagObject: TGeneralAudioFile;
    CurrentAudioFile : TAudioFile;

    // Gibt an, ob aktuelles AudioFile ein gültiges MP3-File ist
    ValidMp3File: Boolean;
    ValidOggFile: Boolean;
    ValidFlacFile: Boolean;
    ValidM4AFile: Boolean;
    ValidApeFile: Boolean;

    procedure LoadStarGraphics;
  end;


var
  FDetails: TFDetails;


implementation

Uses NempMainUnit, NewPicture, Clipbrd, MedienbibliothekClass, MainFormHelper, TagHelper,
    AudioFileHelper, CloudEditor;

{$R *.dfm}

procedure TFDetails.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    if CurrentFileHasBeenChanged then
    begin
        case TranslateMessageDLG((DetailForm_SaveChanges), mtConfirmation, [MBYes, MBNo, MBAbort], 0) of
          mrYes   : begin
                BtnApply.Click;   // save Changes
                CanClose := True;
          end;
          mrNo    : CanClose := True;
          mrAbort : CanClose := False;             // Abort showing Details
        end;
    end;
end;

procedure TFDetails.FormCreate(Sender: TObject);
var i:integer;
begin
  PictureFrames := Nil;
  fForceChange := False;
  TranslateComponent (self);
  CurrentTagObject := Nil;
  Coverpfade := TStringList.Create;

  cbIDv1Genres.Items := ID3Genres;
  cbIDv1Genres.Items.Add('');
  for i := 0 to ID3Genres.Count - 1 do
  begin
      cbIDv2Genres.Items.Add(ID3Genres[i]);
      cb_VorbisGenre.Items.Add(ID3Genres[i]);
  end;

  DetailRatingHelper := TRatingHelper.Create;
  LoadStarGraphics;

  //MainPageControl.OnChange := Nil;
  //MainPageControl.ActivePageIndex := 0;
  //MainPageControl.ActivePage := Tab_General;
  //MainPageControl.OnChange := MainPageControlChange;


  //self.RatingImageID3.
  //doubleBuffered := True;
end;


procedure TFDetails.FormDestroy(Sender: TObject);
begin
  if assigned(PictureFrames) then
      PictureFrames.Free;
  if assigned(CurrentTagObject) then
      FreeAndNil(CurrentTagObject);
  Coverpfade.Free;
  DetailRatingHelper.Free;
end;


procedure TFDetails.FormShow(Sender: TObject);
begin
    MainPageControl.ActivePageIndex := 0;
    MainPageControl.ActivePage := Tab_General;
    refresh;
end;

procedure TFDetails.FormHide(Sender: TObject);
begin
    Nemp_MainForm.AutoShowDetailsTMP := False;
    CurrentAudioFile := Nil;
end;

procedure TFDetails.LoadStarGraphics;
var s,h,u: TBitmap;
    baseDir: String;

begin
  // exit;
  s := TBitmap.Create;
  h := TBitmap.Create;
  u := TBitmap.Create;


  if Nemp_MainForm.NempSkin.isActive
      and (not Nemp_MainForm.NempSkin.UseDefaultStarBitmaps)
      and Nemp_MainForm.NempSkin.UseAdvancedSkin
      and Nemp_MainForm.GlobalUseAdvancedSkin
  then
      BaseDir := Nemp_MainForm.NempSkin.Path + '\'
  else
      // Detail-Form is not skinned, use default images
      BaseDir := ExtractFilePath(ParamStr(0)) + 'Images\';

  try
      s.Transparent := True;
      h.Transparent := True;
      u.Transparent := True;

      Nemp_MainForm.NempSkin.LoadGraphicFromBaseName(s, BaseDir + 'starset')    ;
      Nemp_MainForm.NempSkin.LoadGraphicFromBaseName(h, BaseDir + 'starhalfset');
      Nemp_MainForm.NempSkin.LoadGraphicFromBaseName(u, BaseDir + 'starunset')  ;

      DetailRatingHelper.SetStars(s,h,u);
  finally
      s.Free;
      h.Free;
      u.Free;
  end;
end;

{
    --------------------------------------------------------
    LBLPfadClick
    PM_CopyURLToClipboardClick
    - 2 little helpers for WebStreams and their paths
    --------------------------------------------------------
}
procedure TFDetails.LBLPfadClick(Sender: TObject);
begin
    ShellExecute(Handle, 'open', PChar(LBLPfad.caption), nil, nil, SW_SHOW);
end;
procedure TFDetails.PM_CopyURLToClipboardClick(Sender: TObject);
begin
    ClipBoard.AsText := LBLPfad.caption;
end;

{
    --------------------------------------------------------
    BtnApplyClick
    BtnUndoClick
    Btn_CloseClick
    CB_StayOnTopClick
    - EventHandler for the three buttons on bottom of the form
    --------------------------------------------------------
}
procedure TFDetails.BtnApplyClick(Sender: TObject);
var ListOfFiles: TObjectList;
    listFile: TAudioFile;
    i: Integer;
    aErr: TNempAudioError;
//    backupRating: Byte;
//    backupCounter: Cardinal;
begin

    // Do not Change anything in non-mp3-Files here!
    if Not (ValidMP3File or ValidOggFile or ValidFlacFile or ValidApeFile or ValidM4AFile) then
        Exit;

    PictureHasChanged := False;
    ID3v1HasChanged := False;
    ID3v2HasChanged := False;
    VorbisCommentHasChanged := False;
    ApeTagHasChanged := False;
    M4aTagHasChanged := False;

    if assigned(CurrentAudioFile)
        and (MedienBib.StatusBibUpdate <= 1)
        and (MedienBib.CurrentThreadFilename <> CurrentAudioFile.Pfad)
    then
    begin
        aErr := AUDIOERR_None;
        // write Tags to file
        case CurrentTagObject.FileType of
            at_Mp3: begin
                        Mp3ToAudioError(UpdateID3v1InFile(CurrentTagObject.MP3File));
                        aErr := Mp3ToAudioError(UpdateID3v2InFile(CurrentTagObject.MP3File));
                    end;
            at_Ogg: aErr := AudioToNempAudioError(UpdateOggVorbisInFile(CurrentTagObject.OggFile));
            at_Flac: aErr := AudioToNempAudioError(UpdateFlacInFile(CurrentTagObject.FlacFile));
            at_M4A: aErr := AudioToNempAudioError(UpdateM4AInFile(CurrentTagObject.M4AFile));
            at_Monkey,
            at_WavPack,
            at_MusePack,
            at_OptimFrog,
            at_TrueAudio: aErr := AudioToNempAudioError(UpdateApeTagInFile(CurrenttagObject.BaseApeFile));
            at_Wma: ;
            at_Wav: ;
            at_Invalid: ;
        end;

        // Read FileInfo from File again
        // (Set the fields in the CurrentAudioFile-Object properly)
        CurrentAudioFile.GetAudioData(CurrentAudioFile.Pfad, GAD_Rating);

        if aErr <> AUDIOERR_None then
        begin
            TranslateMessageDLG(AudioErrorString[aErr], mtWarning, [MBOK], 0);
            HandleError(afa_EditingDetails, CurrentAudioFile, aErr, True);
            exit;
        end;

        /// SynchronizeAudioFile on a File from the Library will delete the
        /// Rating/Counter-Data in the library: So: backup, synch file, write rating back
        ///  (this works, as we set CurrentFile.Rating in the UpdateID3/Ogg/Flac-Methods)
        // backupRating := CurrentBibRating; // CurrentAudioFile.Rating;
        // backupCounter:= CurrentBibCounter; //CurrentAudioFile.PlayCounter;
        // SynchronizeAudioFile(CurrentAudioFile, CurrentAudioFile.Pfad, True);
        // CurrentAudioFile.Rating      := backupRating ;
        // CurrentAudioFile.PlayCounter := backupCounter;

        // Update other copies of this file
        ListOfFiles := TObjectList.Create(False);
        try
            GetListOfAudioFileCopies(CurrentAudioFile, ListOfFiles);
            for i := 0 to ListOfFiles.Count - 1 do
            begin
                listFile := TAudioFile(ListOfFiles[i]);
                // copy Data from AktuellesAudioFile to the files in the list.
                listFile.Assign(CurrentAudioFile);
                // Set Rating/Playcounter to Bib-Values
                // ( If rating was changed manually, the CurrentBibRating was
                //   set by the Update<Type>InFile-methods )
                listFile.Rating      := CurrentBibRating;
                listFile.PlayCounter := CurrentBibCounter;
            end;
        finally
            ListOfFiles.Free;
        end;

        MedienBib.Changed := True;
        // Correct GUI
        CorrectVCLAfterAudioFileEdit(CurrentAudioFile);
    end else
        TranslateMessageDLG((Warning_MedienBibIsBusyCritical), mtWarning, [MBOK], 0);
end;
procedure TFDetails.BtnUndoClick(Sender: TObject);
begin
    fForceChange := True;
    if fFilefromMedienBib then
        ShowDetails(CurrentAudioFile, SD_MedienBib)
    else
        ShowDetails(CurrentAudioFile, SD_PLAYLIST);
    fForceChange := False;
end;
procedure TFDetails.Btn_CloseClick(Sender: TObject);
begin
    BtnUndoClick(Sender);
    hide;
end;

{
    --------------------------------------------------------
    Btn_ExploreClick
    Btn_PropertiesClick
    Btn_ActualizeClick
    --------------------------------------------------------
}
procedure TFDetails.Btn_ExploreClick(Sender: TObject);
begin
  if DirectoryExists(CurrentAudioFile.Ordner) then
        ShellExecute(Handle, 'open' ,'explorer.exe'
        , Pchar('/e,/select,"'+CurrentAudioFile.Pfad+'"'), '', sw_ShowNormal);


    //datei_ordner := Data^.FAudioFile.Ordner;

    // showmessage('/e,/select,"'+Data^.FAudioFile.Pfad+'"');
    //if DirectoryExists(datei_ordner) then
     //   ShellExecute(Handle, 'open' ,'explorer.exe'
     //                 , PChar('/e,/select,"'+Data^.FAudioFile.Pfad+'"'), '', sw_ShowNormal);


end;
procedure TFDetails.Btn_PropertiesClick(Sender: TObject);
begin
  ShowFileProperties(Nemp_MainForm.Handle, pChar(CurrentAudioFile.Pfad),'');
end;


procedure TFDetails.Btn_ActualizeClick(Sender: TObject);
var ListOfFiles: TObjectList;
    listFile: TAudioFile;
    i: Integer;
begin
    if assigned(CurrentAudioFile)
        and (MedienBib.StatusBibUpdate <= 1)
        and (MedienBib.CurrentThreadFilename <> CurrentAudioFile.Pfad)
    then
    begin
        case CurrentAudioFile.AudioType of

            at_File: begin
                // Read file information from disk
                //if Fileexists(CurrentAudioFile.Pfad) then
                //begin
                    //SynchronizeAudioFile(CurrentAudioFile, CurrentAudioFile.Pfad, True);
                    ///XXXXXX//// This will reset the bib-rating to the file-rating - Intended??
                    // FileExist wird hier grade doppelt gecheckt
                SynchAFileWithDisc(CurrentAudioFile, True);
                //end;

                // Generate a List of Files which should be updated now
                ListOfFiles := TObjectList.Create(False);
                try
                    GetListOfAudioFileCopies(CurrentAudioFile, ListOfFiles);
                    for i := 0 to ListOfFiles.Count - 1 do
                    begin
                        listFile := TAudioFile(ListOfFiles[i]);
                        // copy Data from AktuellesAudioFile to the files in the list.
                        listFile.Assign(CurrentAudioFile);
                    end;
                finally
                    ListOfFiles.Free;
                end;
                MedienBib.Changed := True;
            end;
            at_CDDA: begin
                ClearCDDBCache;
                if Nemp_MainForm.NempOptions.UseCDDB then
                    CurrentAudioFile.GetAudioData(CurrentAudioFile.Pfad, gad_CDDB)
                else
                    CurrentAudioFile.GetAudioData(CurrentAudioFile.Pfad, 0);
            end;
        end;
        // Correct GUI
        CorrectVCLAfterAudioFileEdit(CurrentAudioFile);
    end else
        TranslateMessageDLG((Warning_MedienBibIsBusyCritical), mtWarning, [MBOK], 0);
end;

procedure TFDetails.btn_AddTagClick(Sender: TObject);
var newTagDummy: String;
    IgnoreWarningsDummy: Boolean;
begin
    if HandleSingleFileTagChange(CurrentAudioFile, '', newTagDummy, IgnoreWarningsDummy) then
        TagsHasChanged(lb_Tags.Items.Count-1,  True);
end;

procedure TFDetails.Btn_RemoveTagClick(Sender: TObject);
var CurrentTagToChange: String;
    CurrentIdx: Integer;
begin
    CurrentIdx := lb_Tags.ItemIndex;
    if (MedienBib.StatusBibUpdate <= 1)
        and assigned(CurrentAudioFile)
        and (MedienBib.CurrentThreadFilename <> CurrentAudioFile.Pfad)
        and (CurrentIdx >= 0)
    then
    begin
        CurrentTagToChange := lb_Tags.Items[CurrentIdx];
        if CurrentAudioFile.RemoveTag(CurrentTagToChange) then
            TagsHasChanged(CurrentIdx, True);
    end;
end;

procedure TFDetails.Btn_RenameTagClick(Sender: TObject);
var newTagDummy, CurrentTagToChange: String;
    IgnoreWarningsDummy: Boolean;
    CurrentIdx: Integer;
begin
    CurrentIdx := lb_Tags.ItemIndex;
    if (MedienBib.StatusBibUpdate <= 1)
        and assigned(CurrentAudioFile)
        and (MedienBib.CurrentThreadFilename <> CurrentAudioFile.Pfad)
        and (CurrentIdx >= 0)
    then
    begin
        CurrentTagToChange := lb_Tags.Items[CurrentIdx];
        if HandleSingleFileTagChange(CurrentAudioFile, CurrentTagToChange, newTagDummy, IgnoreWarningsDummy) then
            TagsHasChanged(lb_Tags.Count - 1, true);
    end;
end;

procedure TFDetails.Btn_TagCloudEditorClick(Sender: TObject);
begin
    if MedienBib.BrowseMode <> 2 then
        MedienBib.ReBuildTagCloud;

    if not assigned(CloudEditorForm) then
        Application.CreateForm(TCloudEditorForm, CloudEditorForm);
    CloudEditorForm.Show;
end;


{
// DO NOT add "change rules" in Details-Dialog
// Reason: adding rules will change files immediately. Other changes in ths dialog will
// occur only after the user clicks "apply"
procedure TFDetails.pm_AddIgnoreRuleClick(Sender: TObject);
begin
    // exit;
end;

procedure TFDetails.pm_AddRenameRuleClick(Sender: TObject);
begin
    // exit;
end;
}

(*
procedure TFDetails.lb_TagsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var newTagDummy, CurrentTagToChange: String;
    IgnoreWarningsDummy: Boolean;
    currentIdx: Integer;
begin
    {
    currentIdx := lb_Tags.ItemIndex;

    if (MedienBib.StatusBibUpdate <= 1)
        and (currentIdx >= 0)
        and assigned(CurrentAudioFile)
        and (MedienBib.CurrentThreadFilename <> CurrentAudioFile.Pfad) then

    begin
          case key of
              vk_F2: begin
                      CurrentTagToChange := lb_Tags.Items[lb_Tags.ItemIndex];
                      if HandleSingleFileTagChange(CurrentAudioFile, CurrentTagToChange, newTagDummy, IgnoreWarningsDummy) then
                          TagsHasChanged(currentIdx, True);
              end;

              VK_DELETE: begin
                  CurrentTagToChange := lb_Tags.Items[lb_Tags.ItemIndex];
                  if CurrentAudioFile.RemoveTag(CurrentTagToChange) then
                      TagsHasChanged(currentIdx, True);
              end;

              //was zum einfügen?
          end;
    end;
    }
end;
*)

{
    --------------------------------------------------------
    RatingImageMouseMove
    RatingImageMouseDown
    RatingImageMouseLeave
    BtnResetRatingClick
    - Edit the rating of the current audiofile
    --------------------------------------------------------
}
procedure TFDetails.RatingImageID3MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var rat: Integer;
begin
    if (Sender as TImage).Enabled then
    begin
        rat := DetailRatingHelper.MousePosToRating(x, 70);//((x div 8)) * 8;
        DetailRatingHelper.DrawRatingInStarsOnBitmap(rat, (Sender as TImage).Picture.Bitmap, (Sender as TImage).Width, (Sender as TImage).Height);
    end;
end;


procedure TFDetails.RatingImageID3MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    CurrentTagRating := DetailRatingHelper.MousePosToRating(x, 70);
    CurrentTagCounter := CurrentBibCounter;
    CurrentTagRatingChanged := True;
    // Actualize Read-Only-Image
    // No. This is changed only after "Save changes"
    // DetailRatingHelper.DrawRatingInStarsOnBitmap(CurrentTagRating, RatingImageBib.Picture.Bitmap, RatingImageBib.Width, RatingImageBib.Height);
end;
procedure TFDetails.RatingImageID3MouseLeave(Sender: TObject);
begin
    if RatingImageID3.Enabled then
        DetailRatingHelper.DrawRatingInStarsOnBitmap(CurrentTagRating, (Sender as TImage).Picture.Bitmap, (Sender as TImage).Width, (Sender as TImage).Height);
end;
procedure TFDetails.BtnResetRatingClick(Sender: TObject);
begin
    if CurrentBibCounter > 20 then
    begin
         if TranslateMessageDLG(Format(DetailForm_HighPlayCounter,[CurrentBibCounter]), mtConfirmation, [MBOk, MBCancel], 0, mrCancel)
            = mrCancel then EXIT;
    end;

    CurrentTagRating := 0;
    CurrentTagCounter := 0;
    CurrentTagRatingChanged := True;
    DetailRatingHelper.DrawRatingInStarsOnBitmap(CurrentTagRating, RatingImageID3.Picture.Bitmap, RatingImageID3.Width, RatingImageID3.Height);
    // DetailRatingHelper.DrawRatingInStarsOnBitmap(ActualRating, RatingImageBib.Picture.Bitmap, RatingImageBib.Width, RatingImageBib.Height);
    DetailRatingHelper.DrawRatingInStarsOnBitmap(CurrentTagRating, RatingImageVorbis.Picture.Bitmap, RatingImageVorbis.Width, RatingImageVorbis.Height);
end;

procedure TFDetails.BtnSynchRatingID3Click(Sender: TObject);
begin
    CurrentTagRating  := CurrentBibRating; //CurrentAudioFile.Rating;
    CurrentTagCounter := CurrentBibCounter;
    CurrentTagRatingChanged := True;
    DetailRatingHelper.DrawRatingInStarsOnBitmap(CurrentTagRating, RatingImageID3.Picture.Bitmap, RatingImageID3.Width, RatingImageID3.Height);
    DetailRatingHelper.DrawRatingInStarsOnBitmap(CurrentTagRating, RatingImageVorbis.Picture.Bitmap, RatingImageVorbis.Width, RatingImageVorbis.Height);
end;

{
    --------------------------------------------------------
    Btn_OpenImageClick
    CoverIMAGEDblClick
    CoverBoxChange
    - EventHandler of the Cover-stuff on Page 1
    --------------------------------------------------------
}
procedure TFDetails.Btn_OpenImageClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar(Coverpfade[Coverbox.itemindex]), nil, nil, SW_SHOWNORMAl)
end;
procedure TFDetails.CoverIMAGEDblClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar(Coverpfade[Coverbox.itemindex]), nil, nil, SW_SHOWNORMAl)
end;

procedure TFDetails.CoverBoxChange(Sender: TObject);
begin
  if Coverbox.itemindex < Coverpfade.Count then
      ZeigeBild(Coverpfade[Coverbox.itemindex]);
end;
{
    --------------------------------------------------------
    ZeigeBild
    - load an image from Pfad and shows it on page 1
    --------------------------------------------------------
}
procedure TFDetails.ZeigeBild(Pfad: UnicodeString);
var
  aCoverbmp: TBitmap;
  aPic: TPicture;
begin
  aCoverbmp := tBitmap.Create;
  try
      aCoverbmp.Width := CoverIMAGE.Width;
      aCoverbmp.Height := CoverIMAGE.Height;
      aPic := TPicture.Create;
      try
          try
              aPic.LoadFromFile(Pfad);
              FitBitmapIn(aCoverbmp, aPic.Graphic);
              aCoverbmp.Canvas.StretchDraw(aCoverbmp.Canvas.ClipRect, aPic.Graphic);
              CoverIMAGE.Picture.Bitmap.Assign(aCoverbmp);
          except
              on E: Exception do
              begin
                  GetDefaultCover(dcFile, aCoverBmp, 0);
                  CoverIMAGE.Picture.Bitmap.Assign(aCoverbmp);
                  TranslateMessageDLG(Error_CoverInvalid + #13#10 + #13#10 + E.Message, mtError, [mbOK], 0);
              end;
          end;
      finally
          aPic.Free;
      end;
  finally
      aCoverbmp.Free;
  end;
end;
{
    --------------------------------------------------------
    Timer1Timer
    - load an image from Pfad and shows it on page 1
      with a short delay
    --------------------------------------------------------
}
procedure TFDetails.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  if Coverbox.itemindex < Coverpfade.Count then
      ZeigeBild(CoverPfade[CoverBox.ItemIndex]);
end;

{
    --------------------------------------------------------
    ReloadTimerTimer
    - When editing files in the MainVST, the Information here
      should be reloaded.
      Directly via "AktualisiereDetailForm" results in some strange
      access-violations sometimes (probably because "Enter" select the next row in the VST)
    --------------------------------------------------------
}
procedure TFDetails.ReloadTimerTimer(Sender: TObject);
begin
    fForceChange := True;
    ReloadTimer.Enabled := False;
    if fFilefromMedienBib then
        ShowDetails(CurrentAudioFile, SD_MedienBib)
    else
        ShowDetails(CurrentAudioFile, SD_PLAYLIST);
    fForceChange := False;
end;

{
    --------------------------------------------------------
    UpdateMediaBibEnabledStatus
    - (de)activate some MediaLibrary stuff
    --------------------------------------------------------
}
procedure TFDetails.UpdateMediaBibEnabledStatus;
var ControlsEnable, ButtonsEnable: Boolean;
begin
  ButtonsEnable := (CurrentAudioFile <> NIL) AND (CurrentAudioFile.IsFile) AND FileExists(CurrentAudioFile.Pfad);
  ControlsEnable:= (CurrentAudioFile <> NIL);

  Btn_Properties.Enabled := ButtonsEnable;
  Btn_Explore.Enabled := ButtonsEnable;
  Btn_Actualize.Enabled := assigned(CurrentAudioFile) AND ((CurrentAudioFile.isCDDA) or (CurrentAudioFile.IsFile));
  LlblConst_FileSize.Enabled := ControlsEnable;
  LlblConst_Path.Enabled := ControlsEnable;
  LlblConst_Filename.Enabled := ControlsEnable;
  LblName.Enabled := ControlsEnable;
  LblPfad.Enabled := ControlsEnable;
  LblSize.Enabled := ControlsEnable;
  LlblConst_Artist.Enabled := ControlsEnable;
  LlblConst_Title.Enabled := ControlsEnable;
  LlblConst_Album.Enabled := ControlsEnable;
  LlblConst_Year.Enabled := ControlsEnable;
  LlblConst_Genre.Enabled := ControlsEnable;
  LlblConst_Duration.Enabled := ControlsEnable;
  LlblConst_Comment.Enabled := ControlsEnable;
  LlblConst_Track.Enabled := ControlsEnable;
  LblAlbum.Enabled := ControlsEnable;
  LBLTrack.Enabled := ControlsEnable;
  LblArtist.Enabled := ControlsEnable;
  LblDauer.Enabled := ControlsEnable;
  LblGenre.Enabled := ControlsEnable;
  LblTitel.Enabled := ControlsEnable;
  LblYear.Enabled := ControlsEnable;
  LblKommentar.Enabled := ControlsEnable;
  LlblConst_Bitrate.Enabled := ControlsEnable;
  LlblConst_Samplerate.Enabled := ControlsEnable;
  LblBitrate.Enabled := ControlsEnable;
  LblSamplerate.Enabled := ControlsEnable;
  LblPlayCounter.Enabled := ControlsEnable;
end;

{
    --------------------------------------------------------
    UpdateID3v1EnabledStatus
    - (de)activate some ID3v1 stuff
    --------------------------------------------------------
}

Procedure TFDetails.UpdateID3v1EnabledStatus;
var ControlsEnable: Boolean;
begin
  ControlsEnable := ValidMp3File and ID3v1Activated;
  CBID3v1.Enabled := ValidMp3File;
  CBID3v1.OnClick := Nil; // ! Wichtig, sonst Endlossschleife!
  CBID3v1.Checked := ControlsEnable;
  CBID3v1.OnClick := CBID3v1Click;
  Lblv1Artist.Enabled := ControlsEnable;
  Lblv1Album.Enabled := ControlsEnable;
  Lblv1Titel.Enabled := ControlsEnable;
  Lblv1Year.Enabled := ControlsEnable;
  cbIDv1Genres.Enabled := ControlsEnable;
  Lblv1Comment.Enabled := ControlsEnable;
  Lblv1Track.Enabled := ControlsEnable;
  LblConst_ID3v1Artist.Enabled := ControlsEnable;
  LblConst_ID3v1Title.Enabled := ControlsEnable;
  LblConst_ID3v1Album.Enabled := ControlsEnable;
  LblConst_ID3v1Comment.Enabled := ControlsEnable;
  LblConst_ID3v1Genre.Enabled := ControlsEnable;
  LblConst_ID3v1Track.Enabled := ControlsEnable;
  LblConst_ID3v1Year.Enabled := ControlsEnable;
  BtnCopyFromV1.Enabled := ControlsEnable;// and ID3v2Activated;
end;
{
    --------------------------------------------------------
    UpdateID3v2EnabledStatus
    - (de)activate some ID3v2 stuff
    --------------------------------------------------------
}
Procedure TFDetails.UpdateID3v2EnabledStatus;
var ControlsEnable: Boolean;
begin
  ControlsEnable := ValidMp3File and ID3v2Activated;
  //ButtonsEnable := ValidMp3File and ID3v2Activated;
  CBID3v2.Enabled := ValidMp3File;
  CBID3v2.OnClick := Nil;  // ! Wichtig, sonst Endlossschleife!
  CBID3v2.Checked := ControlsEnable;
  CBID3v2.OnClick := CBID3v2Click;
  Lblv2Artist.Enabled := ControlsEnable;
  Lblv2Album.Enabled := ControlsEnable;
  Lblv2Titel.Enabled := ControlsEnable;
  Lblv2Year.Enabled := ControlsEnable;
  Lblv2CD.Enabled := ControlsEnable;
  cbIDv2Genres.Enabled := ControlsEnable;
  Lblv2Comment.Enabled := ControlsEnable;
  Lblv2Track.Enabled := ControlsEnable;
  LblRatingImage.Enabled := ControlsEnable;
  RatingImageID3.Enabled := ControlsEnable;
  BtnResetRating.Enabled := ControlsEnable;
  if ControlsEnable then
      DetailRatingHelper.DrawRatingInStarsOnBitmap(CurrentTagRating, RatingImageID3.Picture.Bitmap, RatingImageID3.Width, RatingImageID3.Height)
  else
  begin
      if FileExists(ExtractFilePath(ParamStr(0)) + 'Images\stardisabled.bmp') then
          RatingImageID3.Picture.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'Images\stardisabled.bmp');
  end;

  BtnSynchRatingID3.Visible := ControlsEnable;
  LblConst_ID3v2Artist.Enabled := ControlsEnable;
  LblConst_ID3v2Title.Enabled := ControlsEnable;
  LblConst_ID3v2Album.Enabled := ControlsEnable;
  LblConst_ID3v2Comment.Enabled := ControlsEnable;
  LblConst_ID3v2Genre.Enabled := ControlsEnable;
  LblConst_ID3v2Track.Enabled := ControlsEnable;
  LblConst_ID3v2Year.Enabled := ControlsEnable;
  BtnCopyFromV2.Enabled := ControlsEnable;

  LvFrames.Enabled := ControlsEnable;
  // Seite 4
  Lblv2Copyright.Enabled := ControlsEnable;
  Lblv2Composer.Enabled := ControlsEnable;

  LblConst_Id3v2Version.Enabled := ControlsEnable;
  LblConst_Id3v2Size.Enabled := ControlsEnable;
end;

procedure TFDetails.Edt_VorbisChange(Sender: TObject);
begin
    VorbisCommentHasChanged := True;
    ApeTagHasChanged := True;
    M4aTagHasChanged := True;
end;

procedure TFDetails.EnablePictureButtons;
var picsEnabled: Boolean;
begin
    picsEnabled  := (ValidMp3File and ID3v2Activated) or ValidFlacFile or ValidApeFile or ValidM4AFile;

    cbPictures.Enabled := picsEnabled;
    ID3Image.Visible := picsEnabled;
    Btn_NewPicture.Enabled := picsEnabled;
    Btn_DeletePicture.Enabled := picsEnabled;
    Btn_SavePictureToFile.Enabled := picsEnabled;
end;

{
    --------------------------------------------------------
    UpdateMPEGEnabledStatus
    - (de)activate some MPEG stuff
    --------------------------------------------------------
}
Procedure TFDetails.UpdateMPEGEnabledStatus;
var ControlsEnable: Boolean;
begin
  ControlsEnable := ValidMp3File;
  LblDETBitrate.Enabled := ControlsEnable;
  LblDETSamplerate.Enabled := ControlsEnable;
  LblDETDauer.Enabled := ControlsEnable;
  LblDETVersion.Enabled := ControlsEnable;
  LblDETHeaderAt.Enabled := ControlsEnable;
  LblDETProtection.Enabled := ControlsEnable;
  LblDETExtension.Enabled := ControlsEnable;
  LblDETCopyright.Enabled := ControlsEnable;
  LblDETOriginal.Enabled := ControlsEnable;
  LblDETEmphasis.Enabled := ControlsEnable;
  LblConst_MpegBitrate.Enabled := ControlsEnable;
  LblConst_MpegCopyright.Enabled := ControlsEnable;
  LblConst_MpegDuration.Enabled := ControlsEnable;
  LblConst_MpegEmphasis.Enabled := ControlsEnable;
  LblConst_MpegExtension.Enabled := ControlsEnable;
  LblConst_MpegHeader.Enabled := ControlsEnable;
  LblConst_MpegOriginal.Enabled := ControlsEnable;
  LblConst_MpegProtection.Enabled := ControlsEnable;
  LblConst_MpegSamplerate.Enabled := ControlsEnable;
  LblConst_MpegVersion.Enabled := ControlsEnable;
end;


{
    --------------------------------------------------------
    CBID3v1Click
    CBID3v2Click
    BtnCopyFromV1Click
    BtnCopyFromV2Click
    - some eventhandler for ID3 stuff
    --------------------------------------------------------
}
procedure TFDetails.CBID3v1Click(Sender: TObject);
begin
    ID3v1Activated := CBID3v1.Checked;
    UpdateID3v1EnabledStatus;
end;
procedure TFDetails.CBID3v2Click(Sender: TObject);
begin
  ID3v2Activated := CBID3v2.Checked;
  UpdateID3v2EnabledStatus;
end;
procedure TFDetails.BtnCopyFromV1Click(Sender: TObject);
begin
  if not Validmp3File then exit;
  // Infos von v1 auf v2 übertragen
  // zuerst: ggf. v2Tag aktivieren
  ID3v2Activated := True;
  CBID3v2.Checked := True; //(dadurch werden die Controls auch aktiviert)
  Lblv2Titel.Text   := Lblv1Titel.Text   ;
  Lblv2Artist.Text  := Lblv1Artist.Text  ;
  Lblv2Album.Text   := Lblv1Album.Text   ;
  Lblv2Comment.Text := Lblv1Comment.Text ;
  Lblv2Year.Text    := Lblv1Year.Text    ;
  Lblv2Track.Text   := Lblv1Track.Text   ;
  cbIDv2Genres.Text := cbIDv1Genres.Text ;
end;
procedure TFDetails.BtnCopyFromV2Click(Sender: TObject);
begin
  if not Validmp3File then exit;
  // Infos von v2 auf v1 übertragen
  // zuerst: ggf. v1Tag aktivieren
  ID3v1Activated := True;
  CBID3v1.Checked := True; //(dadurch werden die Controls auch aktiviert)
  Lblv1Titel.Text   := Lblv2Titel.Text   ;
  Lblv1Artist.Text  := Lblv2Artist.Text  ;
  Lblv1Album.Text   := Lblv2Album.Text   ;
  Lblv1Comment.Text := Lblv2Comment.Text ;
  Lblv1Year.Text    := Lblv2Year.Text    ;
  Lblv1Track.Text   := Lblv2Track.Text   ;
  cbIDv1Genres.Text := cbIDv2Genres.Text ;
end;


{
    --------------------------------------------------------
    Lblv2TrackChange
    Lblv1TrackChange
    Lblv1YearChange
    Lblv2YearChange
    - Live-Checking for valid inputs
    --------------------------------------------------------
}
procedure TFDetails.Lblv2Change(Sender: TObject);
begin
    ID3v2HasChanged := True;
end;

procedure TFDetails.Lblv2TrackChange(Sender: TObject);
begin
  if NOT Lblv2Artist.ReadOnly then
  begin
    if (Sender as TEdit).Modified then
    begin
      if IsValidV2TrackString(Lblv2Track.Text) then
        Lblv2Track.Font.Color := clWindowText
      else
        Lblv2Track.Font.Color := clred;
    end;
    ID3v2HasChanged := True;
  end;
end;
procedure TFDetails.Lblv1Change(Sender: TObject);
begin
  ID3v1HasChanged := True;
end;

procedure TFDetails.Lblv1TrackChange(Sender: TObject);
begin
  if NOT Lblv1Artist.ReadOnly then
  begin
    if (Sender as TEdit).Modified then
    begin
      if IsValidV1TrackString(Lblv1Track.Text) then
        Lblv1Track.Font.Color := clWindowText
      else
        Lblv1Track.Font.Color := clred;
    end;
    ID3v1HasChanged := True;
  end;
end;
procedure TFDetails.Lblv1YearChange(Sender: TObject);
begin
  if NOT Lblv1Artist.ReadOnly then
  begin
    if (Sender as TEdit).Modified then
    begin
      if IsValidYearString(Lblv1Year.Text)
      then
        Lblv1Year.Font.Color := clWindowText
      else
        Lblv1Year.Font.Color := clRed;
    end;
    ID3v1HasChanged := True;
  end;
end;
procedure TFDetails.Lblv2YearChange(Sender: TObject);
begin
  if NOT Lblv2Artist.ReadOnly then
  begin
    if (Sender as TEdit).Modified then
    begin
      if IsValidYearString(Lblv2Year.Text)
      then
        Lblv2Year.Font.Color := clWindowText
      else
        Lblv2Year.Font.Color := clRed;
    end;
    ID3v2HasChanged := True;
  end;
end;

procedure TFDetails.lb_TagsDblClick(Sender: TObject);
begin
    if lb_Tags.ItemIndex > 0 then
        MedienBib.GlobalQuickTagSearch(lb_Tags.Items[lb_Tags.ItemIndex]);
end;



{
    --------------------------------------------------------
    ShowMediaBibDetails
    - Showing information saved in the medialibrary (page 1)
    --------------------------------------------------------
}

procedure TFDetails.ShowMediaBibDetails;
var i: Integer;
    mbAudioFile: TAudioFile;
    FirstCoverIsFromMB: Boolean;
    baseName: String;
begin
  if CurrentAudioFile = Nil then
  begin
      CurrentAudioFile := NIL;
      CoverBox.Items.Add((Warning_Coverbox_NoCover));
      CoverImage.Picture.Bitmap.Assign(NIL);
      CoverImage.Visible := False;
      Btn_OpenImage.Enabled := False;
      CoverBox.ItemIndex := 0;
      CoverBox.Enabled := False;
      Lbl_FoundCovers.Enabled := False;

      ValidMP3File := False;
      ID3v1Activated := False;
      ID3v2Activated := False;
      ValidApeFile := False;
      ValidM4AFile := False;
      FDetails.Caption := Format('%s [N/A]', [(DetailForm_Caption)]);

      LblName.Caption := 'N/A';
      LblPfad.Caption := 'N/A';
      LblSize.Caption := 'N/A';
      LblAlbum.Caption := 'N/A';
      LblArtist.Caption := 'N/A';
      LblDauer.Caption := 'N/A';
      LblKommentar.Caption := 'N/A';
      LblGenre.Caption := 'N/A';
      LblTitel.Caption := 'N/A';
      LblYear.Caption := '';
      LBLTrack.Caption := '0';
      LblBitrate.Caption := 'N/A';
      LblSamplerate.Caption := 'N/A';
      LblPlayCounter.Caption := '';
  end else
  begin
        Timer1.Enabled := False;
        if not CurrentAudioFile.ReCheckExistence then
        begin
            Lbl_Warnings.Caption := (Warning_FileNotFound);
            Lbl_Warnings.Hint := (Warning_FileNotFound_Hint);
            PnlWarnung.Visible := True;
        end;

        //DateiPfad := Pfad;
        LBLPfad.Caption := CurrentAudioFile.Ordner;
        LBLName.Caption := CurrentAudioFile.DateiName;

        case CurrentAudioFile.AudioType of
            at_File: begin
                    FDetails.Caption := Format('%s (%s)', [(DetailForm_Caption), CurrentAudioFile.Dateiname]);

                    if Not FileExists(CurrentAudioFile.Pfad) then
                        FDetails.Caption := FDetails.Caption + ' ' + DetailForm_Caption_FileNotFound
                    else
                        if FileIsWriteProtected(CurrentAudioFile.Pfad) then
                            FDetails.Caption := FDetails.Caption + ' ' + DetailForm_Caption_WriteProtected ;

                    LlblConst_Path.Caption := (DetailForm_InfoLblPath);
                    LlblConst_Filename.Caption := (DetailForm_InfoLblFilename);
                    Lblsize.Font.Style := [];
                    LlblConst_Filesize.Font.Style := [];
                    LlblConst_FileSize.Caption := (DetailForm_InfoLblFileSize);
                    LBLSize.Caption := FloatToStrF((CurrentAudioFile.Size / 1024 / 1024),ffFixed,4,2) + ' MB'
                                    + ' (' + inttostr(CurrentAudioFile.Size) + ' Bytes)' ;
                    LBLPfad.Font.Color := clWindowText;
                    LBLPfad.Font.Style := [];
                    LBLPfad.OnClick := NIL;
                    LBLPfad.PopupMenu := NIL;
                    LBLPfad.Cursor := crDefault;
                    LBLDauer.Caption  := SekToZeitString(CurrentAudioFile.Duration);

                    if CurrentAudioFile.vbr then
                        LBLBitrate.Caption := inttostr(CurrentAudioFile.Bitrate) + ' kbit/s (vbr)'
                    else
                        LBLBitrate.Caption := inttostr(CurrentAudioFile.Bitrate) + ' kbit/s';
                    LBLSamplerate.Caption := CurrentAudioFile.Samplerate + ', ' + CurrentAudioFile.ChannelMode;

                    if fFilefromMedienBib and (NOT MedienBib.AnzeigeShowsPlaylistFiles) then
                    begin
                        CurrentBibRating := CurrentAudioFile.Rating;
                        CurrentBibCounter:= CurrentAudioFile.PlayCounter;
                    end
                    else
                    begin
                        mbAudioFile := MedienBib.GetAudioFileWithFilename(CurrentAudioFile.Pfad);
                        if assigned(mbAudioFile) then
                        begin
                            CurrentBibRating := mbAudioFile.Rating;
                            CurrentBibCounter:= mbAudioFile.PlayCounter;
                        end else
                        begin
                            // File is not in MediaLibrary, but PlaylistFile
                            // use data from the metatag
                            case CurrentTagObject.FileType of
                                at_Mp3: begin
                                            CurrentBibRating := CurrentTagObject.MP3File.ID3v2Tag.Rating;
                                            CurrentBibCounter:= CurrentTagObject.MP3File.ID3v2Tag.PlayCounter;
                                        end;
                                at_Ogg: begin
                                            CurrentBibRating := StrToIntDef(CurrentTagObject.OggFile.GetPropertyByFieldname(VORBIS_RATING),0);
                                            CurrentBibCounter:= StrToIntDef(CurrentTagObject.OggFile.GetPropertyByFieldname(VORBIS_PLAYCOUNT),0);
                                        end;
                                at_Flac: begin
                                            CurrentBibRating := StrToIntDef(CurrentTagObject.FlacFile.GetPropertyByFieldname(VORBIS_RATING),0);
                                            CurrentBibCounter:= StrToIntDef(CurrentTagObject.FlacFile.GetPropertyByFieldname(VORBIS_PLAYCOUNT),0);
                                         end;
                                at_Monkey,
                                at_WavPack,
                                at_MusePack,
                                at_OptimFrog,
                                at_TrueAudio: begin
                                            CurrentBibRating := StrToIntDef(CurrentTagObject.BaseApeFile.GetValueByKey(APE_RATING),0);
                                            CurrentBibCounter:= StrToIntDef(CurrentTagObject.BaseApeFile.GetValueByKey(APE_PLAYCOUNT),0);
                                        end;
                                at_Invalid: ;
                                at_Wma: ;
                                at_Wav: ;
                            end;
                        end;
                    end;
                    DetailRatingHelper.DrawRatingInStarsOnBitmap(CurrentBibRating, RatingImageBib.Picture.Bitmap, RatingImageBib.Width, RatingImageBib.Height);
                    LblPlayCounter.Caption := Format(DetailForm_PlayCounter, [CurrentBibCounter]);
                    if CurrentTagObject.FileType = at_Invalid then
                        LblFormat.Caption := CurrentAudioFile.Extension
                    else
                        LblFormat.Caption := CurrentTagObject.FileTypeName;
            end;

            at_Stream: begin
                    FDetails.Caption := Format('%s (%s)', [(DetailForm_Caption), CurrentAudioFile.Ordner]);
                    LlblConst_Path.Caption := (DetailForm_InfoLblWebStream);
                    LlblConst_Filename.Caption := (DetailForm_InfoLblDescription);
                    Lblsize.Font.Style := [fsbold];
                    LlblConst_FileSize.Font.Style := [fsbold];
                    LlblConst_Filesize.Caption := (DetailForm_InfoLblHint);
                    LBLSize.Caption := (DetailForm_InfoLblHinttext);
                    LBLPfad.Font.Color := clblue;
                    LBLPfad.Font.Style := [fsUnderline];
                    LBLPfad.OnClick := LBLPfadClick;
                    LBLPfad.PopupMenu := PM_URLCopy;
                    LBLPfad.Cursor := crHandPoint;
                    LBLDauer.Caption := '(inf)';
                    LBLBitrate.Caption := inttostr(CurrentAudioFile.Bitrate) + ' kbit/s';
                    LBLSamplerate.Caption := '-';
                    LblPlayCounter.Caption := '';
                    LblFormat.Caption := 'Webstream';
            end;

            at_CDDA: begin
                // todo
                LBLDauer.Caption  := SekToZeitString(CurrentAudioFile.Duration);
                LBLBitrate.Caption := '1.4 mbit/s (CD-Audio)';
                LBLSamplerate.Caption := '44.1 kHz, Stereo';
                LBLSize.Caption := '';

                DetailRatingHelper.DrawRatingInStarsOnBitmap(CurrentBibRating, RatingImageBib.Picture.Bitmap, RatingImageBib.Width, RatingImageBib.Height);
                LblPlayCounter.Caption := '';
                LblFormat.Caption := 'Compact Disc Digital Audio';
            end;
        end;

        LBLArtist.Caption := CurrentAudioFile.GetReplacedArtist(Nemp_MainForm.NempOptions.ReplaceNAArtistBy); // Artist;
        LBLTitel.Caption  := CurrentAudioFile.GetReplacedTitle(Nemp_MainForm.NempOptions.ReplaceNATitleBy)  ; // Titel;
        LBLAlbum.Caption  := CurrentAudioFile.GetReplacedAlbum(Nemp_MainForm.NempOptions.ReplaceNAAlbumBy) ;  //Album;

        LBLTrack.Caption  := IntToStr(CurrentAudioFile.Track);
        LBLYear.Caption   := CurrentAudioFile.Year;
        LBLGenre.Caption  := CurrentAudioFile.genre;
        LblKommentar.Caption := CurrentAudioFile.Comment;
        LBLSamplerate.Caption := CurrentAudioFile.Samplerate + ', ' + CurrentAudioFile.ChannelMode;

        CoverBox.Items.Clear;
        Coverpfade.Clear;

        // ToDo:  Hinzufügen: Das "Hash-Cover"
        if (CurrentAudioFile.CoverID <> 'all')
        and (CurrentAudioFile.CoverID <> '')
        and FileExists(MedienBib.CoverSavePath + CurrentAudioFile.CoverID + '.jpg') then
        begin
          Coverpfade.Add(MedienBib.CoverSavePath + CurrentAudioFile.CoverID + '.jpg');
          FirstCoverIsFromMB := True;
        end else
          FirstCoverIsFromMB := False;

        if CurrentAudioFile.isCDDA then
        begin
            // Todo
            FirstCoverIsFromMB := true;

            baseName := CoverFilenameFromCDDA(CurrentAudioFile.Pfad);
            //completeName := '';
            if FileExists(Medienbib.CoverSavePath + baseName + '.jpg') then
                  Coverpfade.Add(Medienbib.CoverSavePath + baseName + '.jpg')
              else if FileExists(Medienbib.CoverSavePath + baseName + '.png') then
                  Coverpfade.Add(Medienbib.CoverSavePath + baseName + '.png');
        end else
            Medienbib.GetCoverListe(CurrentAudioFile,  Coverpfade);

        if Coverpfade.Count = 0 then
        begin
          CoverBox.Items.Add((Warning_Coverbox_NoCover));
          CoverImage.Picture.Bitmap.Assign(NIL);
          CoverImage.Visible := False;
          Btn_OpenImage.Enabled := False;
          CoverBox.ItemIndex := 0;
          CoverBox.Enabled := False;
          Lbl_FoundCovers.Enabled := False;
        end else
        begin // Cover gefunden
          if FirstCoverIsFromMB then
            CoverBox.Items.Add('<Cover>')
          else
            CoverBox.Items.Add(ExtractFilename(CoverPfade[0]));

          for i := 1 to Coverpfade.Count-1 do
            CoverBox.Items.Add(ExtractFilename(CoverPfade[i]));

          if FirstCoverIsFromMB then
            CoverBox.ItemIndex := 0
          else
            CoverBox.ItemIndex := GetFrontCover(CoverBox.Items);
          CoverImage.Visible := True;
          Btn_OpenImage.Enabled := True;
          // ZeigeBild(CoverPfade[CoverBox.ItemIndex]);
          // aber mit einer Verzögerung --- Timer1
          Timer1.Enabled := True;
          CoverBox.Enabled := True;
          Lbl_FoundCovers.Enabled := True;
        end;
  end;
end;
{
    --------------------------------------------------------
    ShowMPEGDetails
    --------------------------------------------------------
}
procedure TFDetails.ShowMPEGDetails(mp3: TMp3File);
begin
    if mp3.MpegInfo.vbr then
      LblDETBitrate.Caption := inttostr(mp3.MpegInfo.bitrate) + 'kbit/s (vbr)'
    else
      LblDETBitrate.Caption := inttostr(mp3.MpegInfo.bitrate) + 'kbit/s';

    LblDETSamplerate.Caption := inttostr(mp3.MpegInfo.samplerate) + ' Hz, '
      + channel_modes[mp3.MpegInfo.channelmode];

    LblDETDauer.Caption := Format('%s (%d Frames)', [SekToZeitString(mp3.MpegInfo.dauer), mp3.MpegInfo.frames]);

    if mp3.MpegInfo.version = 3 then
      LblDETVersion.Caption := '2.5 (Layer '+ inttostr(mp3.MpegInfo.layer) + ')'
    else
      LblDETVersion.Caption := inttostr(mp3.MpegInfo.version) + ' (Layer '+
        inttostr(mp3.MpegInfo.layer) + ')';

    LblDETHeaderAt.Caption := inttostr(mp3.MpegInfo.FirstHeaderPosition);
    if mp3.MpegInfo.protection then
      LblDETProtection.Caption := 'Yes'
    else
      LblDETProtection.Caption := 'No';
    LblDETExtension.Caption := extensions[mp3.MpegInfo.layer][mp3.MpegInfo.extension];
    if mp3.MpegInfo.copyright then
      LblDETCopyright.Caption := 'Yes'
    else
      LblDETCopyright.Caption := 'No';
    if mp3.MpegInfo.original then
      LblDETOriginal.Caption := 'Yes'
    else
      LblDETOriginal.Caption := 'No';
    LblDETEmphasis.Caption := emphasis_values[mp3.MpegInfo.emphasis];
end;
{
    --------------------------------------------------------
    ShowID3v1Details
    --------------------------------------------------------
}
procedure TFDetails.ShowID3v1Details(mp3: TMp3File);
begin
  if ID3v1Activated then //ID3v1Tag.exists then
  begin
      Lblv1Artist.Text := mp3.Id3v1Tag.Artist;
      Lblv1Album.Text  := mp3.Id3v1Tag.Album;
      Lblv1Titel.Text  := mp3.Id3v1Tag.Title;
      Lblv1Year.Text   := UnicodeString(mp3.Id3v1Tag.year);
      // hier den Itemindex nehmen - id3v1Genre kann nicht beliebig sein
      cbIDv1Genres.ItemIndex := cbIDv1Genres.Items.IndexOf(mp3.Id3v1Tag.genre);
      Lblv1Comment.Text := mp3.Id3v1Tag.Comment;
      Lblv1Track.Text   := mp3.Id3v1Tag.Track;
      if IsValidV1TrackString(Lblv1Track.Text) then
          Lblv1Track.Font.Color := clWindowText
      else
          Lblv1Track.Font.Color := clred;

      if IsValidYearString(Lblv1Year.Text) then
          Lblv1Year.Font.Color := clWindowText
      else
          Lblv1Year.Font.Color := clRed;
  end else
  begin
      Lblv1Artist.Text := '';
      Lblv1Album.Text := '';
      Lblv1Titel.Text := '';
      Lblv1Year.Text := '';
      cbIDv1Genres.ItemIndex := -1;
      Lblv1Comment.Text := '';
      Lblv1Track.Text := '0';
      Lblv1Track.Font.Color := clWindowText;
      Lblv1Year.Font.Color := clWindowText;      
  end;
end;

{
    --------------------------------------------------------
    ShowOggDetails
    ShowFlacDetails
    - Show Details from Ogg- or Flac-Files
    --------------------------------------------------------
}
procedure TFDetails.ShowOggDetails(ogg: TOggVorbisFile);
begin
    // OggVorbisFile: TOggVorbisFile;
    Tab_VorbisComments.Caption := DetailForm_VorbisCaption;
    Edt_VorbisArtist.Text    := ogg.Artist;
    Edt_VorbisTitle.Text     := ogg.Title;
    Edt_VorbisAlbum.Text     := ogg.Album;
    Edt_VorbisComment.Text   := ogg.GetPropertyByFieldname(VORBIS_COMMENT);
    Edt_VorbisYear.Text      := ogg.Year;
    Edt_VorbisTrack.Text     := ogg.Track;
    Edt_VorbisCopyright.Text := ogg.Copyright;
    cb_VorbisGenre.Text      := ogg.Genre;
    Edt_VorbisCD.Text        := ogg.GetPropertyByFieldname(VORBIS_DISCNUMBER);

    CurrentTagRatingChanged := False;
    CurrentTagRating := StrToIntDef(ogg.GetPropertyByFieldname(VORBIS_RATING),0);
    CurrentTagCounter:= StrToIntDef(ogg.GetPropertyByFieldname(VORBIS_PLAYCOUNT),0);
    DetailRatingHelper.DrawRatingInStarsOnBitmap(CurrentTagRating, RatingImageVorbis.Picture.Bitmap, RatingImageVorbis.Width, RatingImageVorbis.Height);

    BtnSynchRatingOggVorbis.Visible := CurrentTagRating <> CurrentBibRating;

    ogg.GetAllFields(lv_VorbisComments.Items);
    if lv_VorbisComments.Items.Count > 0 then
    begin
        lv_VorbisComments.ItemIndex := 0;
        Memo_Vorbis.Text := ogg.GetPropertyByIndex(0);
    end else
        Memo_Vorbis.Text := '';
end;
procedure TFDetails.ShowFlacDetails(flac: TFlacFile);
begin
    Tab_VorbisComments.Caption := DetailForm_VorbisCaption;
    //FlacFile: TFlacFile;
    Edt_VorbisArtist.Text    := Flac.Artist;
    Edt_VorbisTitle.Text     := Flac.Title;
    Edt_VorbisAlbum.Text     := Flac.Album;
    Edt_VorbisComment.Text   := Flac.GetPropertyByFieldname(VORBIS_COMMENT);
    Edt_VorbisYear.Text      := Flac.Year;
    Edt_VorbisTrack.Text     := Flac.Track;
    Edt_VorbisCopyright.Text := Flac.Copyright;
    cb_VorbisGenre.Text      := Flac.Genre;
    Edt_VorbisCD.Text        := Flac.GetPropertyByFieldname(VORBIS_DISCNUMBER);

    CurrentTagRatingChanged := False;
    CurrentTagRating := StrToIntDef(Flac.GetPropertyByFieldname(VORBIS_RATING),0);
    CurrentTagCounter:= StrToIntDef(Flac.GetPropertyByFieldname(VORBIS_PLAYCOUNT),0);
    DetailRatingHelper.DrawRatingInStarsOnBitmap(CurrentTagRating, RatingImageVorbis.Picture.Bitmap, RatingImageVorbis.Width, RatingImageVorbis.Height);
    BtnSynchRatingOggVorbis.Visible := CurrentTagRating <> CurrentBibRating;

    Flac.GetAllFields(lv_VorbisComments.Items);
    if lv_VorbisComments.Items.Count > 0 then
    begin
        lv_VorbisComments.ItemIndex := 0;
        Memo_Vorbis.Text := Flac.GetPropertyByIndex(0);
    end else
        Memo_Vorbis.Text := '';
end;

procedure TFDetails.ShowApeDetails(ape: TBaseApeFile);
begin
    Tab_VorbisComments.Caption := DetailForm_ApeCaption;
    Edt_VorbisArtist.Text    := ape.Artist;
    Edt_VorbisTitle.Text     := ape.Title;
    Edt_VorbisAlbum.Text     := ape.Album;
    Edt_VorbisComment.Text   := ape.GetValueByKey(APE_COMMENT);
    Edt_VorbisYear.Text      := ape.Year;
    Edt_VorbisTrack.Text     := ape.Track;
    Edt_VorbisCopyright.Text := ape.Copyright;
    cb_VorbisGenre.Text      := ape.Genre;
    Edt_VorbisCD.Text        := ape.GetValueByKey(APE_DISCNUMBER);

    CurrentTagRatingChanged := False;
    CurrentTagRating := StrToIntDef(ape.GetValueByKey(APE_RATING),0);
    CurrentTagCounter:= StrToIntDef(ape.GetValueByKey(APE_PLAYCOUNT),0);
    DetailRatingHelper.DrawRatingInStarsOnBitmap(CurrentTagRating, RatingImageVorbis.Picture.Bitmap, RatingImageVorbis.Width, RatingImageVorbis.Height);
    BtnSynchRatingOggVorbis.Visible := CurrentTagRating <> CurrentBibRating;

    ape.GetAllFrames(lv_VorbisComments.Items);
    if lv_VorbisComments.Items.Count > 0 then
    begin
        lv_VorbisComments.ItemIndex := 0;
        Memo_Vorbis.Text := ape.GetValueByKey(AnsiString(lv_VorbisComments.Items[lv_VorbisComments.ItemIndex]))
    end else
        Memo_Vorbis.Text := '';
end;

procedure TFDetails.ShowM4ADeatils(m4a: TM4AFile);
begin
    Tab_VorbisComments.Caption := DetailForm_iTunesCaption;
    Edt_VorbisArtist.Text    := m4a.Artist;
    Edt_VorbisTitle.Text     := m4a.Title;
    Edt_VorbisAlbum.Text     := m4a.Album;
    Edt_VorbisComment.Text   := m4a.Comment;
    Edt_VorbisYear.Text      := m4a.Year;
    Edt_VorbisTrack.Text     := m4a.Track;
    Edt_VorbisCopyright.Text := m4a.Copyright;
    cb_VorbisGenre.Text      := m4a.Genre;
    Edt_VorbisCD.Text        := m4a.Disc;

    CurrentTagRatingChanged := False;

    CurrentTagCounter := StrToIntDef(m4a.GetSpecialData(DEFAULT_MEAN, M4APlayCounter),0);
    CurrentTagRating  := StrToIntDef(m4a.GetSpecialData(DEFAULT_MEAN, M4ARating), 0);

    DetailRatingHelper.DrawRatingInStarsOnBitmap(CurrentTagRating, RatingImageVorbis.Picture.Bitmap, RatingImageVorbis.Width, RatingImageVorbis.Height);
    BtnSynchRatingOggVorbis.Visible := CurrentTagRating <> CurrentBibRating;

    m4a.GetAllTextAtomDescriptions(lv_VorbisComments.Items);
    if lv_VorbisComments.Items.Count > 0 then
    begin
        lv_VorbisComments.ItemIndex := 0;
        Memo_Vorbis.Text := m4a.GetTextDataByDescription(lv_VorbisComments.Items[lv_VorbisComments.ItemIndex]);
    end else
        Memo_Vorbis.Text := '';
end;

{
    --------------------------------------------------------
    lv_VorbisCommentsChange
    - Show selected Comment in Memo
    --------------------------------------------------------
}
procedure TFDetails.lv_VorbisCommentsClick(Sender: TObject);
begin
    case self.CurrentTagObject.FileType of
        at_Ogg: Memo_Vorbis.Text := CurrentTagObject.OggFile.GetPropertyByIndex(lv_VorbisComments.ItemIndex);
        at_Flac: Memo_Vorbis.Text := CurrentTagObject.FlacFile.GetPropertyByIndex(lv_VorbisComments.ItemIndex);
        at_M4A: Memo_Vorbis.Text := CurrentTagObject.M4aFile.GetTextDataByDescription(lv_VorbisComments.Items[lv_VorbisComments.ItemIndex]);
        at_Monkey,
        at_WavPack,
        at_MusePack,
        at_OptimFrog,
        at_TrueAudio: Memo_Vorbis.Text := CurrentTagObject.BaseApeFile.GetValueByKey(AnsiString(lv_VorbisComments.Items[lv_VorbisComments.ItemIndex]))
    end;

end;


{
    --------------------------------------------------------
    ShowPictures
    - Pictures within the id3-tag, Page 3.
    --------------------------------------------------------
}
procedure TFDetails.LoadApeImage(aKey: AnsiString);
var picStream: TMemoryStream;
    picDescription: UnicodeString;
begin
    if CurrentTagObject.FileType in [at_Monkey, at_WavPack, at_MusePack, at_OptimFrog, at_TrueAudio] then
    begin
        picDescription := '';
        picStream := tMemoryStream.Create;
        try
            if CurrentTagObject.BaseApeFile.GetPicture(aKey, picStream, picDescription) then
            begin
                //if not StreamToBitmap(picStream, ID3Image.Picture.Bitmap) then
                if not PicStreamToImage(picStream, 'image/jpeg', ID3Image.Picture.Bitmap) then
                    if not PicStreamToImage(picStream, 'image/png', ID3Image.Picture.Bitmap) then
                        if not PicStreamToImage(picStream, 'image/bmp', ID3Image.Picture.Bitmap) then
                            ID3Image.Picture.Assign(NIL);
            end else
                ID3Image.Picture.Assign(NIL);
        finally
            picStream.Free;
        end;
    end;
end;

procedure TFDetails.ShowPictures;
var i: Integer;
  stream: TMemoryStream;
  mime: AnsiString;
  PicType: Byte;
  m4aPictype: TM4APicTypes;
  Description: UnicodeString;
begin
    if assigned(PictureFrames) then
        FreeAndNil(PictureFrames);

    cbPictures.Items.Clear;

    case CurrentTagObject.FileType of
        at_Invalid: ;
        at_Mp3: begin
                    PictureFrames := CurrentTagObject.MP3File.ID3v2Tag.GetAllPictureFrames;
                    stream := TMemoryStream.Create;
                    try
                        for i := PictureFrames.Count - 1 downto 0 do // andersrum, damit das erste Bild am Ende im Speicher ist. ;-)
                        begin
                            Stream.Clear;
                            (PictureFrames[i] as TID3v2Frame).GetPicture(Mime, PicType, Description, stream);
                            if PicType < length(Picture_Types) then
                                cbPictures.Items.Insert(0, Format('[%s] %s', [Picture_Types[PicType], Description]))
                            else
                                cbPictures.Items.Insert(0, Format('[%s] %s', [Picture_Types[0], Description]));
                        end;

                        Btn_DeletePicture.Enabled := cbPictures.Items.Count > 0;
                        Btn_SavePictureToFile.Enabled := cbPictures.Items.Count > 0;
                        Btn_NewPicture.Enabled := True;

                        if cbPictures.Items.Count > 0 then
                        begin
                            cbPictures.ItemIndex := 0;
                            ID3Image.Visible := True;
                            stream.Seek(0, soFromBeginning);
                            PicStreamToImage(stream, Mime, ID3IMAGE.Picture.Bitmap);
                        end else
                        begin
                            cbPictures.ItemIndex := -1;
                            ID3Image.Picture.Assign(NIL);
                            ID3Image.Visible := False;
                        end;
                    finally
                        stream.Free;
                    end;
                end;
        at_Ogg: ;
        at_Flac: begin
                      if not assigned(PictureFrames) then
                          PictureFrames := TObjectList.Create(False);

                      CurrentTagObject.FlacFile.GetAllPictureBlocks(PictureFrames);
                      for i := PictureFrames.Count - 1 downto 0 do
                      begin
                          PicType := TFlacPictureBlock(PictureFrames[i]).PictureType;
                          Description := TFlacPictureBlock(PictureFrames[i]).Description;
                          if PicType < length(Picture_Types) then
                              cbPictures.Items.Insert(0, Format('[%s] %s', [Picture_Types[PicType], Description]))
                          else
                              cbPictures.Items.Insert(0, Format('[%s] %s', [Picture_Types[0], Description]));
                      end;

                      Btn_DeletePicture.Enabled := cbPictures.Items.Count > 0;
                      Btn_SavePictureToFile.Enabled := cbPictures.Items.Count > 0;
                      ID3Image.Visible := cbPictures.Items.Count > 0;
                      Btn_NewPicture.Enabled := True;

                      if cbPictures.Items.Count > 0 then
                      begin
                          cbPictures.ItemIndex := 0;
                          //stream.Seek(0, soFromBeginning);
                          stream := TMemoryStream.Create;
                          try
                              TFlacPictureBlock(PictureFrames[0]).CopyPicData(stream);
                              PicStreamToImage(stream, TFlacPictureBlock(PictureFrames[0]).Mime, ID3IMAGE.Picture.Bitmap);
                          finally
                              stream.Free;
                          end;
                      end else
                      begin
                          cbPictures.ItemIndex := -1;
                          ID3Image.Picture.Assign(NIL);
                      end;
                  end;
        at_M4A: begin
                      // Show Picture
                      stream := TMemoryStream.Create;
                      try
                          if CurrentTagObject.M4aFile.GetPictureStream(stream, m4aPictype) then
                          begin
                              case m4aPictype of
                                M4A_JPG: mime := 'image/jpeg';
                                M4A_PNG: mime := 'image/png';
                                M4A_Invalid: mime := '-'; // invalid
                              end;
                              cbPictures.Items.Add(DetailForm_OnlyOneM4ACover);
                              cbPictures.ItemIndex := 0;
                              PicStreamToImage(stream, mime, ID3IMAGE.Picture.Bitmap);
                          end else
                          begin
                              cbPictures.ItemIndex := -1;
                              ID3Image.Picture.Assign(NIL);
                          end;
                      finally
                          stream.Free;
                      end;

                  end;
        at_Monkey,
        at_WavPack,
        at_MusePack,
        at_OptimFrog,
        at_TrueAudio: begin
                      CurrentTagObject.BaseApeFile.GetAllPictureFrames(cbPictures.Items);
                      if cbPictures.Items.Count > 0 then
                      begin
                          cbPictures.ItemIndex := 0;
                          LoadApeImage(AnsiString(cBPictures.Text));
                      end
                      else
                          Id3Image.Picture.Assign(NIL);
                  end;
        at_Wma: ;
        at_Wav: ;
    end;
end;

procedure TFDetails.ShowLyrics;
var ButtonsEnable: Boolean;
    ext: String;
begin
    ButtonsEnable := (ValidMp3File and ID3v2Activated) or (ValidOggFile) or (ValidFlacFile) or ValidApeFile or ValidM4AFile;
    ext := AnsiLowerCase(ExtractFileExt(CurrentAudioFile.Pfad));
    // Sonderstatus Lyrics: Auch anzeigen, wenn Datei gerade nicht zu finden ist.
    if (CurrentAudioFile <> NIL)
        AND CurrentAudioFile.HasSupportedTagFormat
        AND (not FileExists(CurrentAudioFile.Pfad))
        AND (trim(UnicodeString(CurrentAudioFile.Lyrics)) <> '')
    then
    begin
        // d.h. es ist ein mp3/ogg/flac/ape/...-File, was gerade nicht da ist, das aber Lyrics in der DB hat
        Memo_Lyrics.ReadOnly := True;
        Memo_Lyrics.Enabled := True;
        Memo_Lyrics.Text :=  UTF8ToString(CurrentAudioFile.Lyrics);
    end else
    begin
        Memo_Lyrics.ReadOnly := False;
        Memo_Lyrics.Enabled := ButtonsEnable;
        Memo_Lyrics.Text := '';
    end;

    case CurrentTagObject.FileType of
        at_Mp3: Memo_Lyrics.Text := CurrentTagObject.MP3File.ID3v2Tag.Lyrics;
        at_Ogg: Memo_Lyrics.Text := CurrentTagObject.OggFile.GetPropertyByFieldname(VORBIS_LYRICS);
        at_Flac: Memo_Lyrics.Text := CurrentTagObject.FlacFile.GetPropertyByFieldname(VORBIS_LYRICS);
        at_M4A: Memo_Lyrics.Text := CurrentTagObject.M4aFile.Lyrics;
        at_Monkey,
        at_WavPack,
        at_MusePack,
        at_OptimFrog,
        at_TrueAudio: Memo_Lyrics.Text := CurrentTagObject.BaseApeFile.GetValueByKey(APE_LYRICS);
        at_Invalid,
        at_Wma,
        at_Wav: Memo_Lyrics.Text := '';
    end;

    Btn_DeleteLyricFrame.Enabled := ButtonsEnable and (Memo_Lyrics.Text <> '');
    BtnLyricWiki.Enabled         := ButtonsEnable;
    //BtnLyricWikiManual can be always activated
end;

procedure TFDetails.ShowAdditionalTags;
var TagStream: TMemoryStream;
    localtags: UTF8String;
begin
    lb_Tags.Enabled := assigned(CurrentAudioFile) AND (FileExists(CurrentAudioFile.Pfad));

    if assigned(CurrentTagObject) then
    begin
        case self.CurrentTagObject.FileType of
            at_Mp3: begin
                        // get Nemp/Tags
                        localtags := '';
                        TagStream := TMemoryStream.Create;
                        try
                            if CurrentTagObject.MP3File.ID3v2Tag.GetPrivateFrame('NEMP/Tags', TagStream) and (TagStream.Size > 0) then
                            begin
                                // We found a Tag-Frame with Information in the ID3Tag
                                TagStream.Position := 0;
                                SetLength(localtags, TagStream.Size);
                                TagStream.Read(localtags[1], TagStream.Size);
                            end;
                        finally
                            TagStream.Free;
                        end;
                    end;
            at_Ogg: localtags := UTF8String(CurrentTagObject.OggFile.GetPropertyByFieldname(VORBIS_CATEGORIES));
            at_Flac: localtags := UTF8String(CurrentTagObject.FlacFile.GetPropertyByFieldname(VORBIS_CATEGORIES));
            at_M4A: localtags := UTF8String(CurrentTagObject.M4aFile.Keywords);
            at_Monkey,
            at_WavPack,
            at_MusePack,
            at_OptimFrog,
            at_TrueAudio: localtags := UTF8String(CurrentTagObject.BaseApeFile.GetValueByKey(APE_CATEGORIES));
            at_Invalid,
            at_Wma,
            at_Wav: lb_Tags.Items.Text := '';
        end;

        lb_Tags.Items.Text := String(localtags);
        // in addition: Assign these tags from the File-Metadate to the
        // CurrentAudioFile-Object (the file in the medialibrary/playlist)
        // unsaved changes done to these tags (meddienbib-tags <> file-tags)
        // will be lost then. Just as the warning said, as you closed Nemp without
        // writing the change metadata (e.g. after adding ignore/rename rules) back into the files
        CurrentAudioFile.RawTagLastFM := localTags;
        // reason: The extendede tag-managament runs on TNempAudioFile(= currentAudioFile), not on TGeneralaudiofile (= CurrentTagObject)

    end;

    // else   ???  28.03.2012 Does this make any sense ???
    //  Memo_Tags.Text := String(CurrentAudioFile.RawTagLastFM);
end;

{
    --------------------------------------------------------
    FillFrameView
    - Fills the list on page 4.
    --------------------------------------------------------
}
procedure TFDetails.FillFrameView(mp3: TMp3File);
var newItem: TListItem;
    FrameList: TObjectlist;
    i: Integer;
    lang: AnsiString;
    Description: UnicodeString;
    Value: UnicodeString;
begin
    LvFrames.Clear;

    FrameList := mp3.ID3v2Tag.GetAllURLFrames;
    for i := 0 to FrameList.Count - 1 do
    begin
        newItem := LvFrames.Items.Add;
        newItem.Caption := (FrameList[i] as TID3v2Frame).FrameTypeDescription;
        NewItem.SubItems.Add(UnicodeString((FrameList[i] as TID3v2Frame).GetURL));
        NewItem.Data := (FrameList[i] as TID3v2Frame);
    end;

    FrameList.Free;
    FrameList := mp3.ID3v2Tag.GetAllTextFrames;
    for i := 0 to FrameList.Count - 1 do
    begin
        if not ((FrameList[i] as TID3v2Frame).FrameID in
              [IDv2_ARTIST, IDv2_TITEL, IDv2_ALBUM, IDv2_YEAR, IDv2_GENRE, IDv2_TRACK, IDv2_COPYRIGHT])
        then
        begin
            newItem := LvFrames.Items.Add;
            newItem.Caption := (FrameList[i] as TID3v2Frame).FrameTypeDescription;
            NewItem.SubItems.Add((FrameList[i] as TID3v2Frame).GetText);
            NewItem.Data := (FrameList[i] as TID3v2Frame);
        end;
    end;

    FrameList.Free;
    FrameList := mp3.ID3v2Tag.GetAllUserTextFrames;
    for i := 0 to FrameList.Count - 1 do
    begin
        Value := (FrameList[i] as TID3v2Frame).GetUsertext(Description);
        newItem := LvFrames.Items.Add;
        if Description = '' then
            newItem.Caption := 'Usertext'
        else
            newItem.Caption := 'Usertext: ' + Description;

        NewItem.SubItems.Add(Value);
        NewItem.Data := (FrameList[i] as TID3v2Frame);
    end;

    FrameList.Free;
    FrameList := mp3.ID3v2Tag.GetAllCommentFrames;
    for i := 0 to FrameList.Count - 1 do
    begin
        Value := (FrameList[i] as TID3v2Frame).GetCommentsLyrics(lang, Description);
        if Description <> '' then
        begin
            newItem := LvFrames.Items.Add;
            newItem.Caption := 'Comment: ' + Description;

            value := StringReplace(value, #10, ' ', [rfReplaceAll]);
            value := StringReplace(value, #13, ' ', [rfReplaceAll]);
            NewItem.SubItems.Add(Value);
            NewItem.Data := (FrameList[i] as TID3v2Frame);
        end;
    end;

    FrameList.Free;
    FrameList := mp3.ID3v2Tag.GetAllUserDefinedURLFrames;
    for i := 0 to FrameList.Count - 1 do
    begin
        Value := UnicodeString((FrameList[i] as TID3v2Frame).GetUserdefinedURL(Description));
        if Description <> '' then
        begin
            newItem := LvFrames.Items.Add;
            newItem.Caption := 'URL: ' + Description;
            NewItem.SubItems.Add(Value);
            NewItem.Data := (FrameList[i] as TID3v2Frame);
        end;
    end;
    FrameList.Free;
end;

{
    --------------------------------------------------------
    LvFramesDblClick
    - Open URLs in WebBrowser
    --------------------------------------------------------
}
procedure TFDetails.LvFramesDblClick(Sender: TObject);
begin
  if assigned(LvFrames.ItemFocused) then
  begin
      if (TID3v2Frame((LvFrames.ItemFocused).Data).FrameType = FT_URLFrame)
          or
         (TID3v2Frame((LvFrames.ItemFocused).Data).FrameType = FT_UserDefinedURLFrame)
      then
          ShellExecute(Handle, 'open', PChar((LvFrames.ItemFocused).SubItems[0]), nil, nil, SW_SHOW);
  end;
end;

{
    --------------------------------------------------------
    ShowID3v2Details
    - Shows the complete ID3v2-Stuff
    --------------------------------------------------------
}
procedure TFDetails.ShowID3v2Details(mp3: TMp3File);
var tmp: UnicodeString;
begin
  if ID3v2Activated then //ID3v2Tag.exists then
  begin
        Lblv2Artist.Text := mp3.Id3v2Tag.Artist;
        Lblv2Album.Text := mp3.Id3v2Tag.Album;
        Lblv2Titel.Text := mp3.Id3v2Tag.Title;
        Lblv2Year.Text := mp3.Id3v2Tag.year;
        cbIDv2Genres.Text := mp3.Id3v2Tag.genre;

        tmp := StringReplace(mp3.id3v2Tag.comment, #10, ' ', [rfReplaceAll]);
        tmp := StringReplace(tmp, #13, ' ', [rfReplaceAll]);
        Lblv2Comment.Text := tmp;
        Lblv2Track.Text := mp3.Id3v2Tag.Track;
        Lblv2CD.Text := mp3.ID3v2Tag.GetText(IDv2_PARTOFASET);

        CurrentTagRatingChanged := False;
        CurrentTagRating := mp3.Id3v2Tag.Rating;
        CurrentTagCounter:= mp3.Id3v2Tag.PlayCounter;
        DetailRatingHelper.DrawRatingInStarsOnBitmap(CurrentTagRating, RatingImageID3.Picture.Bitmap, RatingImageID3.Width, RatingImageID3.Height);
        BtnSynchRatingID3.Visible := CurrentTagRating <> CurrentBibRating;

        if IsValidYearString(Lblv2Year.Text)
        then
          Lblv2Year.Font.Color := clWindowText
        else
          Lblv2Year.Font.Color := clRed;

        if IsValidV2TrackString(Lblv2Track.Text) then
          Lblv2Track.Font.Color := clWindowText
        else
          Lblv2Track.Font.Color := clred;

        Lblv2_Version.Caption := '2.'+IntToStr(mp3.id3v2Tag.Version.Major) + '.' + IntToStr(mp3.id3v2Tag.Version.Minor);
        Lblv2_Size   .Caption := Format(DetailForm_ID3v2Info, [mp3.id3v2Tag.Size, mp3.id3v2Tag.Size - mp3.id3v2Tag.PaddingSize]);

        FillFrameView(mp3);
        Lblv2Copyright.Text := mp3.Id3v2Tag.Copyright;
        Lblv2Composer.Text  := mp3.Id3v2Tag.Composer;
  end else
  begin
        Btn_DeleteLyricFrame.Enabled := False;
        BtnLyricWiki.Enabled := False;

        Lblv2_Version.Caption := '';
        Lblv2_Size   .Caption := '';

        LvFrames.Clear;
        Lblv2Artist.Text    := '';
        Lblv2Album.Text     := '';
        Lblv2Titel.Text     := '';
        Lblv2Year.Text      := '';
        cbIDv2Genres.Text   := '';
        Lblv2Comment.Text   := '';
        Lblv2Track.Text     := '0';
        Lblv2CD.Text        := '';
        Lblv2Copyright.Text := '';
        Lblv2Composer.Text  := '';
  end;
end;

{
    --------------------------------------------------------
    ShowDetails
    - Show all available information
    --------------------------------------------------------
}
procedure TFDetails.ShowDetails(AudioFile: TAudioFile; Source: Integer = SD_MEDIENBIB);
var ci: Integer;
    mp3: TMp3File;
begin
  // Hier auch die Abfrage zum Speichern rein
  if (not fForceChange) and CurrentFileHasBeenChanged then
  begin
      case TranslateMessageDLG((DetailForm_SaveChanges), mtConfirmation, [MBYes, MBNo, MBAbort], 0) of
        mrYes   : BtnApply.Click;   // save Changes
        mrNo    : ;                 // Nothing to do
        mrAbort : Exit;             // Abort showing Details
      end;
  end;


  if Source <> -1 then
    fFilefromMedienBib := Source = SD_MedienBib;

  CurrentAudioFile := AudioFile;

  if (Nemp_MainForm.AutoShowDetailsTMP) AND (CurrentAudioFile <> NIL) then
      FDetails.Visible := True
  else
      exit;

  PnlWarnung.Visible := False;

    // Das zuerst machen - hier wird ggf. Das WarnPanel auf der ersten Seite gesetzt
    // hinten machen - wegen Validmp3File, was für cbWriteRatingToTag.Enabled gebraucht wird
    //UpdateMediaBibEnabledStatus;
    //ShowMediaBibDetails;

  // new file, init as "invalid"
  ValidMp3File  := False;
  ValidOggFile  := False;
  ValidFlacFile := False;
  ValidApeFile  := False;
  ValidM4AFile  := False;

  if FileExists(AudioFile.Pfad) then
  begin
      if assigned(CurrentTagObject) then
          FreeAndNil(CurrentTagObject);

      CurrentTagObject := TGeneralAudioFile.Create(AudioFile.Pfad);

      case CurrentTagObject.FileType of
          at_Mp3: begin
                      mp3 := CurrentTagObject.MP3File;

                      ValidMp3File := (CurrentTagObject.LastError = FileErr_None)
                                   or (CurrentTagObject.LastError = Mp3ERR_NoTag);

                      if not ValidMp3File then
                      begin
                          ID3v1Activated := False;
                          ID3v2Activated := False;
                          Lbl_Warnings.Caption := (Warning_InvalidMp3file);
                          Lbl_Warnings.Hint    := (Warning_InvalidMp3file_Hint);
                          PnlWarnung.Visible   := True;
                      end else
                      begin
                          ID3v1Activated := mp3.Id3v1Tag.Exists;
                          ID3v2Activated := mp3.Id3v2Tag.Exists;
                      end;

                      if MedienBib.NempCharCodeOptions.  AutoDetectCodePage then
                      begin
                          mp3.ID3v1Tag.CharCode := GetCodepage(AudioFile.Pfad, MedienBib.NempCharCodeOptions);
                          mp3.ID3v2Tag.CharCode := mp3.ID3v1Tag.CharCode;
                      end; //else: Standardwerte behalten
                      mp3.ID3v1Tag.AutoCorrectCodepage := MedienBib.NempCharCodeOptions.AutoDetectCodePage;
                      mp3.ID3v2Tag.AutoCorrectCodepage := MedienBib.NempCharCodeOptions.AutoDetectCodePage;
                  end;
          at_Ogg: begin
                      ValidOggFile := CurrentTagObject.LastError = FileErr_None;
                      if not ValidOggFile then
                      begin
                          Lbl_Warnings.Caption := AudioErrorString[AudioToNempAudioError(CurrentTagObject.LastError)];
                          Lbl_Warnings.Hint := (Warning_ReadError_Hint);
                          PnlWarnung.Visible := True;
                      end;
                  end;
          at_Flac: begin
                        ValidFlacFile := (CurrentTagObject.LastError = FileErr_None);
                        if not ValidFlacFile then
                        begin
                            Lbl_Warnings.Caption := AudioErrorString[AudioToNempAudioError(CurrentTagObject.LastError)];
                            Lbl_Warnings.Hint := (Warning_ReadError_Hint);
                            PnlWarnung.Visible := True;
                        end;
                    end;
          at_M4a: begin
                        ValidM4AFile := (CurrentTagObject.LastError = FileErr_None);
                        if not ValidM4AFile then
                        begin
                            Lbl_Warnings.Caption := AudioErrorString[AudioToNempAudioError(CurrentTagObject.LastError)];
                            Lbl_Warnings.Hint := (Warning_ReadError_Hint);
                            PnlWarnung.Visible := True;
                        end;
                  end;
          at_Monkey,
          at_WavPack,
          at_MusePack,
          at_OptimFrog,
          at_TrueAudio: begin
                          ValidApeFile := (CurrentTagObject.LastError = FileErr_None)
                                       or (CurrentTagObject.LastError = ApeErr_NoTag);
                          if not ValidApeFile then
                          begin
                              Lbl_Warnings.Caption := AudioErrorString[AudioToNempAudioError(CurrentTagObject.LastError)];
                              Lbl_Warnings.Hint := (Warning_ReadError_Hint);
                              PnlWarnung.Visible := True;
                          end;
                    end;

          at_Invalid,
          at_Wma,
          at_Wav: ; // nothing to do
      end;
  end
  else
  begin
      // Datei existiert nicht
      ID3v1Activated := False;
      ID3v2Activated := False;

      if assigned(CurrentTagObject) then
          FreeAndNil(CurrentTagObject);

      CurrentTagObject := TGeneralAudioFile.Create(AudioFile.Pfad);
  end;

  MainPageControl.OnChange := Nil;
  // backup Current active Page
  ci := MainPageControl.ActivePageIndex;

  // Set proper Tabs (in)visible
  Tab_MpegInformation.Visible := ValidMp3File; // This is the one with id3v1 // id3v2
  Tab_Lyrics.Visible          := ValidMp3File or ValidFlacFile or ValidOggFile or ValidApeFile or ValidM4AFile;
  Tab_VorbisComments.Visible  := ValidFlacFile or ValidOggFile or ValidApeFile or ValidM4AFile;
  Tab_ExtendedID3v2.Visible   := ValidMp3File;
  Tab_MoreTags.Visible        := ValidMp3File or ValidFlacFile or ValidOggFile or ValidApeFile or ValidM4AFile;

  Tab_MpegInformation.TabVisible := ValidMp3File; // This is the one with id3v1 // id3v2
  Tab_Lyrics.TabVisible          := ValidMp3File or ValidFlacFile or ValidOggFile or ValidApeFile or ValidM4AFile;
  Tab_VorbisComments.TabVisible  := ValidFlacFile or ValidOggFile or ValidApeFile or ValidM4AFile;
  Tab_ExtendedID3v2.TabVisible   := ValidMp3File;
  Tab_MoreTags.TabVisible        := ValidMp3File or ValidFlacFile or ValidOggFile or ValidApeFile or ValidM4AFile;

  if (ci = 1) or (ci=2) then
  begin
      // current page was "ID3-tags" or "Vorbis-Comments"
      // => Set this Page as new page
      if Tab_VorbisComments.Visible then
      begin
          MainPageControl.ActivePageIndex := 2;
          MainPageControl.ActivePage := Tab_VorbisComments;
      end;
      if Tab_MpegInformation.Visible then
      begin
          MainPageControl.ActivePageIndex := 1;
          MainPageControl.ActivePage := Tab_MpegInformation;
      end;
  end;

  // Medien-Bib-Infos
  UpdateMediaBibEnabledStatus;
  ShowMediaBibDetails;

  // MPEG INFOS
  if validMP3File then
  begin
      UpdateMPEGEnabledStatus;
      ShowMPEGDetails(CurrentTagObject.MP3File);
      // ID3Tags
      UpdateID3v1EnabledStatus;
      UpdateID3v2EnabledStatus;
      EnablePictureButtons;
      ShowID3v1Details(CurrentTagObject.MP3File);
      ShowID3v2Details(CurrentTagObject.MP3File);
      ShowPictures;
      ShowLyrics;
  end;

  if ValidOggFile then
  begin
      EnablePictureButtons;
      ShowOggDetails(CurrentTagObject.OggFile);
      ShowLyrics;
      ShowPictures; // To clear the ComboBox
  end;

  if ValidFlacFile then
  begin
      EnablePictureButtons;
      ShowFlacDetails(CurrentTagObject.FlacFile);
      ShowPictures;
      ShowLyrics;
  end;

  if ValidM4AFile then
  begin
      EnablePictureButtons;
      ShowM4ADeatils(CurrentTagObject.M4aFile);
      ShowPictures;
      ShowLyrics;
  end;

  if ValidApeFile then
  begin
      EnablePictureButtons;
      ShowApeDetails(CurrentTagObject.BaseApeFile);
      ShowPictures;
      ShowLyrics;
  end;

  ShowAdditionalTags;

  BtnApply.Enabled := (ValidMP3File or ValidOggFile or ValidFlacFile or ValidApeFile or ValidM4AFile);
  BtnUndo.Enabled := (ValidMP3File or ValidOggFile or ValidFlacFile or ValidApeFile or ValidM4AFile);

  PictureHasChanged := False;
  ID3v1HasChanged := False;
  ID3v2HasChanged := False;
  VorbisCommentHasChanged := False;
  ApeTagHasChanged := False;
  M4aTagHasChanged := False;
end;


{
    --------------------------------------------------------
    UpdateID3v1InFile
    UpdateID3v2InFile
    - Save information to id3-tag
      Note: On ID3v2 only "basic information" are set here
            Pictures and other stuff are set in other methods
            But they are stored in the ID3v2tag-strucure,
            so saving here saves everything. ;-)
    --------------------------------------------------------
}
function TFDetails.UpdateID3v1InFile(mp3: TMp3File): TMp3Error;
begin
    if ID3v1Activated and ValidMp3File then
    begin
        mp3.Id3v1Tag.Title := Lblv1Titel.Text;
        mp3.Id3v1Tag.Artist := Lblv1Artist.Text;
        mp3.Id3v1Tag.Album := Lblv1Album.Text;
        mp3.Id3v1Tag.Comment := Lblv1Comment.Text;
        mp3.Id3v1Tag.Genre := cbIDv1Genres.Text;
        mp3.Id3v1Tag.Track := Lblv1Track.Text;
        mp3.Id3v1Tag.Year := AnsiString(Lblv1Year.Text);
        result := mp3.id3v1Tag.WriteToFile(CurrentAudioFile.Pfad);
    end else
        result := mp3.id3v1Tag.RemoveFromFile(CurrentAudioFile.pfad);
end;
function TFDetails.UpdateID3v2InFile(mp3: TMp3File): TMp3Error;
var ms: TMemoryStream;
    s: UTF8String;
begin
  //if (ID3v2Activated or (cbWriteRatingToTag.Checked and cbWriteRatingToTag.Enabled)) and ValidMp3File then
  if ID3v2Activated and ValidMp3File then
  begin
      mp3.Id3v2Tag.Title := Lblv2Titel.Text;
      mp3.Id3v2Tag.Artist := Lblv2Artist.Text;
      mp3.Id3v2Tag.Album := Lblv2Album.Text;
      mp3.Id3v2Tag.Comment := Lblv2Comment.Text;
      mp3.Id3v2Tag.Genre := cbIDv2Genres.Text;
      mp3.Id3v2Tag.Track := Lblv2Track.Text;
      mp3.ID3v2Tag.SetText(IDv2_PARTOFASET, Lblv2CD.Text);
      mp3.Id3v2Tag.Year := Lblv2Year.Text;
      // weitere Frames
      mp3.ID3v2Tag.Copyright := Lblv2Copyright.Text;
      mp3.Id3v2Tag.Composer  := Lblv2Composer.Text;
      // Lyrics
      mp3.ID3v2Tag.Lyrics := Memo_Lyrics.Text;

      // Bewertung. Nur schreiben, wenn gechecked
      // No write always - rating-image is now an ID3v2-Page
      // if (cbWriteRatingToTag.Checked) and (cbWriteRatingToTag.Enabled) then
      if CurrentTagRatingChanged then
      begin
          mp3.ID3v2Tag.Rating := CurrentTagRating;
          // copy Playcounter as well
          mp3.ID3v2Tag.PlayCounter := CurrentTagCounter; //CurrentAudioFile.PlayCounter;
          CurrentTagRatingChanged := False;
          // Change Bib-Rating!!
          // IMPORTANT for later call of SynchronizeAudioFile,
          // as the rating should NOT be changed in that sync!
          CurrentBibRating  := CurrentTagRating;
          CurrentBibCounter := CurrentTagCounter;
      end;

      s := Utf8String(Trim(lb_Tags.Items.Text));
      if length(s) > 0 then
      begin
          ms := TMemoryStream.Create;
          try
              ms.Write(s[1], length(s));
              mp3.ID3v2Tag.SetPrivateFrame('NEMP/Tags', ms);
          finally
              ms.Free;
          end;
      end else
          // delete Tags-Frame
          mp3.ID3v2Tag.SetPrivateFrame('NEMP/Tags', NIL);


      result := mp3.id3v2Tag.WriteToFile(CurrentAudioFile.Pfad);
  end else
    result := mp3.id3v2Tag.RemoveFromFile(CurrentAudioFile.Pfad);
end;

function TFDetails.UpdateOggVorbisInFile(ogg: TOggVorbisFile): TAudioError;
begin
    if ValidOggFile then
    begin
        ogg.Artist := Edt_VorbisArtist.Text;
        ogg.Title  := Edt_VorbisTitle.Text;
        ogg.Album  := Edt_VorbisAlbum.Text;
        ogg.Genre  := cb_VorbisGenre.Text;
        ogg.Track  := Edt_VorbisTrack.Text;
        ogg.Year        := Edt_VorbisYear.Text;
        ogg.Copyright   := Edt_VorbisCopyright.Text;

        ogg.SetPropertyByFieldname(VORBIS_DISCNUMBER, Edt_VorbisCD.Text);
        ogg.SetPropertyByFieldname(VORBIS_COMMENT, Edt_VorbisComment.Text);
        ogg.SetPropertyByFieldname(VORBIS_LYRICS, Trim(Memo_Lyrics.Text));
        if CurrentTagRatingChanged then
        begin
            ogg.SetPropertyByFieldname(VORBIS_RATING, IntToStr(CurrentTagRating));
            // copy playcounter as well
            ogg.SetPropertyByFieldname(VORBIS_PLAYCOUNT, IntToStr(CurrentTagCounter));
            CurrentTagRatingChanged := False;
            // Change Bib-Rating!!
            // IMPORTANT for later call of SynchronizeAudioFile,
            // as the rating should NOT be changed in that sync!
            //CurrentAudioFile.Rating := CurrentTagRating;
            //CurrentAudioFile.PlayCounter := CurrentTagCounter;
            CurrentBibRating  := CurrentTagRating;
            CurrentBibCounter := CurrentTagCounter;
        end;
        ogg.SetPropertyByFieldname(VORBIS_CATEGORIES, Trim(lb_Tags.Items.Text));

        result := ogg.WriteToFile(CurrentAudioFile.Pfad);
    end else
        result := FileErr_NoFile;
end;
function TFDetails.UpdateFlacInFile(flac: TFlacFile): TAudioError;
begin
    if ValidFlacFile then
    begin
        Flac.Artist := Edt_VorbisArtist.Text;
        Flac.Title  := Edt_VorbisTitle.Text;
        Flac.Album  := Edt_VorbisAlbum.Text;
        Flac.Genre  := cb_VorbisGenre.Text;
        Flac.Track  := Edt_VorbisTrack.Text;
        Flac.Year        := Edt_VorbisYear.Text;
        Flac.Copyright   := Edt_VorbisCopyright.Text;

        Flac.SetPropertyByFieldname(VORBIS_DISCNUMBER, Edt_VorbisCD.Text);
        Flac.SetPropertyByFieldname(VORBIS_COMMENT, Edt_VorbisComment.Text);
        Flac.SetPropertyByFieldname(VORBIS_LYRICS, Trim(Memo_Lyrics.Text));
        if CurrentTagRatingChanged then
        begin
            Flac.SetPropertyByFieldname(VORBIS_RATING, IntToStr(CurrentTagRating));
            Flac.SetPropertyByFieldname(VORBIS_PLAYCOUNT, IntToStr(CurrentTagCounter));
            CurrentTagRatingChanged := False;
            // Change Bib-Rating!!
            // IMPORTANT for later call of SynchronizeAudioFile,
            // as the rating should NOT be changed in that sync!
            //CurrentAudioFile.Rating := CurrentTagRating;
            CurrentBibRating  := CurrentTagRating;
            CurrentBibCounter := CurrentTagCounter;
        end;
        Flac.SetPropertyByFieldname(VORBIS_CATEGORIES, Trim(lb_Tags.Items.Text));

        result := Flac.WriteToFile(CurrentAudioFile.Pfad);
    end else
        result := FileErr_NoFile;
end;

function TFDetails.UpdateM4AInFile(m4a: TM4AFile): TAudioError;
begin
    if ValidM4AFile then
    begin
        m4a.Artist := Edt_VorbisArtist.Text;
        m4a.Title  := Edt_VorbisTitle.Text;
        m4a.Album  := Edt_VorbisAlbum.Text;
        m4a.Genre  := cb_VorbisGenre.Text;
        m4a.Track  := Edt_VorbisTrack.Text;
        m4a.Year        := Edt_VorbisYear.Text;
        m4a.Copyright   := Edt_VorbisCopyright.Text;

        m4a.Disc := Edt_VorbisCD.Text;
        m4a.Comment := Edt_VorbisComment.Text;
        m4a.Lyrics := Trim(Memo_Lyrics.Text);

        if CurrentTagRatingChanged then
        begin
            m4a.SetSpecialData(DEFAULT_MEAN, M4ARating, IntToStr(CurrentTagRating));
            m4a.SetSpecialData(DEFAULT_MEAN, M4APlayCounter, IntToStr(CurrentTagCounter));
            CurrentTagRatingChanged := False;
            // Change Bib-Rating!!
            // IMPORTANT for later call of SynchronizeAudioFile,
            // as the rating should NOT be changed in that sync!
            //CurrentAudioFile.Rating := CurrentTagRating;
            CurrentBibRating  := CurrentTagRating;
            CurrentBibCounter := CurrentTagCounter;
        end;
        m4a.Keywords := Trim(lb_Tags.Items.Text);

        result := m4a.WriteToFile(CurrentAudioFile.Pfad);
    end else
        result := FileErr_NoFile;
end;

function TFDetails.UpdateApeTagInFile(ape: TbaseApeFile): TAudioError;
begin
    if ValidApeFile then
    begin
        ape.Artist := Edt_VorbisArtist.Text;
        ape.Title  := Edt_VorbisTitle.Text;
        ape.Album  := Edt_VorbisAlbum.Text;
        ape.Genre  := cb_VorbisGenre.Text;
        ape.Track  := Edt_VorbisTrack.Text;
        ape.Year        := Edt_VorbisYear.Text;
        ape.Copyright   := Edt_VorbisCopyright.Text;

        ape.SetValueByKey(APE_DISCNUMBER, Edt_VorbisCD.Text);
        ape.SetValueByKey(APE_COMMENT, Edt_VorbisComment.Text);
        ape.SetValueByKey(APE_LYRICS, Trim(Memo_Lyrics.Text));
        if CurrentTagRatingChanged then
        begin
            ape.SetValueByKey(APE_RATING, IntToStr(CurrentTagRating));
            ape.SetValueByKey(APE_PLAYCOUNT, IntToStr(CurrentTagCounter));
            CurrentTagRatingChanged := False;
            // Change Bib-Rating!!
            // IMPORTANT for later call of SynchronizeAudioFile,
            // as the rating should NOT be changed in that sync!
            //CurrentAudioFile.Rating := CurrentTagRating;
            CurrentBibRating  := CurrentTagRating;
            CurrentBibCounter := CurrentTagCounter;
        end;
        ape.SetValueByKey(APE_CATEGORIES, Trim(lb_Tags.Items.Text));

        result := ape.WriteToFile(CurrentAudioFile.Pfad);
    end else
        result := FileErr_NoFile;
end;

{
    --------------------------------------------------------
    Btn_DeleteLyricFrameClick
    cbPicturesChange
    Btn_NewPictureClick
    Btn_DeletePictureClick
    - Advanced Editing of ID3-Tags
    --------------------------------------------------------
}
procedure TFDetails.Btn_DeleteLyricFrameClick(Sender: TObject);
begin
    case CurrentTagObject.FileType of
        at_Mp3: begin
                    CurrentTagObject.MP3File.ID3v2Tag.Lyrics := '';
                    ID3v2HasChanged := True;
                end;
        at_Ogg: begin
                    CurrentTagObject.OggFile.SetPropertyByFieldname(VORBIS_LYRICS, '');
                    VorbisCommentHasChanged := True;
                end;
        at_Flac: begin
                    CurrentTagObject.FlacFile.SetPropertyByFieldname(VORBIS_LYRICS, '');
                    VorbisCommentHasChanged := True;
                end;
        at_M4A: begin
                    CurrentTagObject.M4aFile.Lyrics := '';
                    M4aTagHasChanged := True;
                end;
        at_Monkey,
        at_WavPack,
        at_MusePack,
        at_OptimFrog,
        at_TrueAudio: begin
                    CurrentTagObject.BaseApeFile.SetValueByKey(APE_LYRICS, '');
                    ApeTagHasChanged := True;
                end;

        at_Invalid: ;
        at_Wma: ;
        at_Wav: ;
    end;

    // Maybe there are some other Lyrics in the id3-tag ;-)
    ShowLyrics;
end;
procedure TFDetails.cbPicturesChange(Sender: TObject);
var stream: TMemorystream;
    mime: AnsiString;
    PicType: Byte;
    Description: UnicodeString;
    idx: Integer;
begin

    stream := TMemoryStream.Create;
    try
        if ValidMP3File then
        begin
            ID3Image.Visible := True;
            (PictureFrames[cbPictures.ItemIndex] as TID3v2Frame).GetPicture(Mime, PicType, Description, stream);
            PicStreamToImage(stream, Mime, ID3IMAGE.Picture.Bitmap);
        end;
        if ValidFlacFile then
        begin
            idx := cbPictures.ItemIndex;
            TFlacPictureBlock(PictureFrames[idx]).CopyPicData(stream);
            PicStreamToImage(stream, TFlacPictureBlock(PictureFrames[idx]).Mime, ID3IMAGE.Picture.Bitmap);
        end;
        if ValidApeFile then
        begin
            LoadApeImage(AnsiString(cBPictures.Text));
        end;
    finally
      stream.Free;
    end;
end;

procedure TFDetails.Btn_NewPictureClick(Sender: TObject);
begin
  if Not Assigned(FNewPicture) then
      Application.CreateForm(TFNewPicture, FNewPicture);

  FNewPicture.LblConst_PictureType.Enabled := CurrentTagObject.FileType <> at_M4A;
  FNewPicture.LblConst_PictureDescription.Enabled := CurrentTagObject.FileType <> at_M4A;
  FNewPicture.cbPictureType.Enabled := CurrentTagObject.FileType <> at_M4A;
  FNewPicture.EdtPictureDescription.Enabled := CurrentTagObject.FileType <> at_M4A;

  if FNewPicture.Showmodal = MROK then
      PictureHasChanged := True;

  ShowPictures;
end;
procedure TFDetails.Btn_DeletePictureClick(Sender: TObject);
begin
    case CurrentTagObject.FileType of
        at_Invalid: ;
        at_Mp3: CurrentTagObject.MP3File.Id3v2Tag.DeleteFrame(PictureFrames[cbPictures.ItemIndex] as TID3v2Frame );
        at_Ogg: ;
        at_Flac: CurrentTagObject.FlacFile.DeletePicture(TFlacPictureBlock(PictureFrames[cbPictures.ItemIndex]));
        at_M4A: CurrentTagObject.M4aFile.SetPicture(Nil, M4A_Invalid);
        at_Monkey,
        at_WavPack,
        at_MusePack,
        at_OptimFrog,
        at_TrueAudio: CurrentTagObject.BaseApeFile.SetPicture(AnsiString(cbPictures.Text), '', NIL );
        at_Wma: ;
        at_Wav: ;
    end;
    ShowPictures;
end;

{
    --------------------------------------------------------
    Btn_SavePictureToFileClick
    - Extract a picture from id3tag and save it to a file
    --------------------------------------------------------
}
procedure TFDetails.Btn_SavePictureToFileClick(Sender: TObject);
var Stream: TMemoryStream;
    mime: AnsiString;
    PicType: Byte;
    m4aPictype: TM4APicTypes;
    Description: UnicodeString;
    idx: Integer;
    tmpBmp: TBitmap;
begin
    Stream := TMemoryStream.Create;
    try
        mime := ''; // invalid

        // Get Picture-Data from current Frame/MetaBlock
        if ValidMP3File then
            (PictureFrames[cbPictures.ItemIndex] as TID3v2Frame).GetPicture(Mime, PicType, Description, stream);

        if ValidFlacFile then
        begin
            idx := cbPictures.ItemIndex;
            mime := TFlacPictureBlock(PictureFrames[idx]).Mime;
            TFlacPictureBlock(PictureFrames[idx]).CopyPicData(stream);
        end;

        if ValidM4AFile then
        begin
            mime := '';
            if CurrentTagObject.M4aFile.GetPictureStream(stream, m4aPictype) then
            begin
                case m4aPictype of
                  M4A_JPG: mime := 'image/jpeg';
                  M4A_PNG: mime := 'image/png';
                  M4A_Invalid: mime := '-'; // invalid
                end;
            end;
        end;

        if ValidApeFile then
        begin
            if CurrentTagObject.BaseApeFile.GetPicture(AnsiString(cbPictures.Text), Stream, Description) then
            begin
                // try to get the MimeType
                tmpBmp := TBitmap.Create;
                try
                    if PicStreamToImage(Stream, 'image/jpeg', tmpBmp) then
                        mime := 'image/jpeg'
                    else
                        if PicStreamToImage(Stream, 'image/png', tmpBmp) then
                            mime := 'image/png'
                finally
                      tmpBmp.Free;
                end;
            end;
        end;

        // Get proper Filter for SaveDialog
        if (mime = 'image/png') or (Uppercase(UnicodeString(Mime)) = 'PNG') then
        begin
            SaveDialog1.DefaultExt := 'png';
            SaveDialog1.Filter := '*.png|*.png;';
        end else
        begin
            SaveDialog1.DefaultExt := 'jpg';
            SaveDialog1.Filter := '*.jpg;*.jpeg;|*.jpg;*.jpeg;';
        end;

        // Save the Picture
        if SaveDialog1.execute then
        begin
            try
                Stream.SaveToFile(saveDialog1.FileName);
            except
                on E: Exception do TranslateMessageDLG(E.Message, mtError, [mbOK], 0);
            end;
        end;
    finally
        stream.Free;
    end;
end;


procedure TFDetails.Btn_GetTagsLastFMClick(Sender: TObject);
var s: String;
    af: TAudioFile;
    TagPostProcessor: TTagPostProcessor;
begin
    // use a temporary AudioFile here     WHY ????? Because CurrentTagObject has no "Extended tags"
    af := TAudioFile.Create;
    try
        af.Assign(CurrentAudioFile);
        af.RawTagLastFM := UTF8String(Trim(lb_Tags.Items.Text));

        TagPostProcessor := TTagPostProcessor.Create;
        try
            TagPostProcessor.LoadFiles;
            s := MedienBib.BibScrobbler.GetTags(af);
            if trim(s) = '' then
                TranslateMessageDLG(MediaLibrary_GetTagsFailed, mtInformation, [MBOK], 0)
            else
                // process new Tags. Rename, delete ignored and duplicates.
                MedienBib.AddNewTag(af, s, False);

            // Show tags of temporary file in teh memo
            lb_Tags.Items.Text := String(af.RawTagLastFM);
        finally
            TagPostProcessor.Free;
        end;
    finally
        af.Free
    end;
end;

// extended tags has changed
procedure TFDetails.TagsHasChanged(newIdx: Integer; hasChanged: Boolean = True);
begin
    if ValidMp3File then
        ID3v2HasChanged := hasChanged;
    if ValidOggFile or ValidflacFile then
        VorbisCommentHasChanged := hasChanged;
    if ValidApeFile then
        ApeTagHasChanged := hasChanged;
    if ValidM4aFile then
        M4aTagHasChanged := hasChanged;

    // refresh tags in the view
    if assigned(currentAudioFile) then
    begin
        lb_Tags.Items.Text := String(currentAudioFile.RawTagLastFM);

        if newIdx < 0 then
            newIdx := 0;
        if newIdx >= lb_Tags.Count then
            newIdx := lb_Tags.Count-1;

        if (newIdx < lb_Tags.Count) and (newIdx >= 0) then
            lb_Tags.Selected[newIdx] := True;
    end;
end;



{
    --------------------------------------------------------
    Memo_LyricsKeyDown
    - Just select the whole text
    --------------------------------------------------------
}
procedure TFDetails.Memo_LyricsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    $41: if ssCtrl in Shift then
        begin
          key := 0;
          (Sender as TMemo).SelectAll;
        end;
  end;
end;



procedure TFDetails.Memo_LyricsChange(Sender: TObject);
begin
    if ValidMp3File then
        ID3v2HasChanged := True;
    if ValidOggFile or ValidflacFile then
        VorbisCommentHasChanged := True;
    if ValidApeFile then
        ApeTagHasChanged := True;
    if ValidM4AFile then
        M4aTagHasChanged := True;
end;
{
    --------------------------------------------------------
    BtnLyricWikiClick
    BtnLyricWikiManualClick
    - Search on LyricWiki.org for Lyrics
      ManualSearch opens URL in Webbrowser
    --------------------------------------------------------
}
procedure TFDetails.BtnLyricWikiClick(Sender: TObject);
var Lyrics: TLyrics;
    LyricString: String;
begin
        //if Fileexists(AktuellesAudioFile.Pfad)
        //   AND (AnsiLowerCase(ExtractFileExt(AktuellesAudioFile.Pfad))='.mp3')
        if ValidMp3File or ValidOggFile or ValidFlacFile or ValidApeFile or ValidM4AFile then
        begin
            CurrentAudioFile.FileIsPresent:=True;
            Lyrics := TLyrics.Create;
            try
                LyricString := Lyrics.GetLyrics(CurrentAudioFile.Artist, CurrentAudioFile.Titel);

                if LyricString = '' then
                begin
                    if Lyrics.ExceptionOccured then
                        // no connection
                        TranslateMessageDLG(MediaLibrary_LyricsFailed, mtWarning, [MBOK], 0)
                    else
                    begin
                        // no lyrics found
                        if (TranslateMessageDLG(LyricsSearch_NotFoundMessage, mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
                            BtnLyricWikiManual.Click;
                    end;
                end else
                begin
                    // ok, Lyrics found
                    Memo_Lyrics.Text := LyricString;
                    if ValidMp3File then
                        ID3v2HasChanged := True;
                    if ValidOggFile or ValidflacFile then
                        VorbisCommentHasChanged := True;
                    if ValidApeFile then
                        ApeTagHasChanged := True;
                    if ValidM4AFile then
                        M4aTagHasChanged := True;
                end;
            finally
                Lyrics.Free;
            end;
        end
        else
            CurrentAudioFile.FileIsPresent:=False;
end;
procedure TFDetails.BtnLyricWikiManualClick(Sender: TObject);
var LyricQuery: AnsiString;
begin
    LyricQuery := 'http://lyrics.wikia.com';
    ShellExecuteA(Handle, 'open', PAnsiChar(LyricQuery), nil, nil, SW_SHOW);
end;



function TFDetails.CurrentFileHasBeenChanged: Boolean;
var mp3: TMp3File;
begin
    result := False;
    if Not assigned(CurrentAudioFile) then
        exit; // no current AudioFile, no changes.

    case CurrentTagObject.FileType of
        at_Invalid: ;
        at_Mp3: begin
                    mp3 := CurrentTagObject.MP3File;
                    // aktuellesAudiofile is not NIL here.
                    if (mp3.Id3v1Tag.Exists <> CBID3v1.Checked)
                        or (mp3.Id3v2Tag.Exists <> CBID3v2.Checked)
                    then
                    begin
                        result := True;     // User changed existance of the ID3Tags
                        exit;
                    end;

                    if (mp3.Id3v1Tag.Exists) and (CBID3v1.Checked)  // ID3v1Tag exists
                        and ID3v1HasChanged                     // and changed
                    then
                    begin
                        result := True;
                        exit;
                    end;

                    if (mp3.Id3v2Tag.Exists) and (CBID3v2.Checked)  // ID3v2Tag exists
                        and
                        ( ID3v2HasChanged                      // and changed
                          or PictureHasChanged
                          or (CurrentTagRatingChanged) )
                    then
                    begin
                        result := True;
                        exit;
                    end;
                end;
        at_Ogg: result := VorbisCommentHasChanged;
        at_Flac: result := VorbisCommentHasChanged or PictureHasChanged;
        at_M4A: result := M4aTagHasChanged or PictureHasChanged;
        at_Monkey,
        at_WavPack,
        at_MusePack,
        at_OptimFrog,
        at_TrueAudio: result := ApeTagHasChanged or PictureHasChanged;
        at_Wma: ;
        at_Wav: ;
    end;
end;


end.

