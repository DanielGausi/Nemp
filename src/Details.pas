{

    Unit Details
    Form TFDetails

    - Show Details from AudioFiles
    - Edit ID3Tags, including basic-stuff like title, artist,
                    Lyrics (with search function for LyricWiki.org)
                    Pictures

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2005-2020, Daniel Gaussmann
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

{$I xe.inc}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Contnrs,
  Dialogs, NempAudioFiles, StdCtrls, ExtCtrls, StrUtils, JPEG, PNGImage,
  ShellApi, ComCtrls, U_CharCode, myDialogs,
  AudioFiles.Base, AudioFiles.Declarations, AudioFiles.Factory, ID3v1Tags, ID3v2Tags, MpegFrames, ID3v2Frames, ID3GenreList, Mp3Files, FlacFiles, OggVorbisFiles,
  VorbisComments, BaseApeFiles, Apev2Tags, ApeTagItem, MusePackFiles, cddaUtils,
  M4AFiles, M4AAtoms, md5,

  CoverHelper, Buttons, ExtDlgs, ImgList,  Hilfsfunktionen, Systemhelper, HtmlHelper,
  Nemp_ConstantsAndTypes, gnuGettext, Lyrics, TagClouds, LibraryOrganizer.Base,
  Nemp_RessourceStrings, Menus, RatingCtrls, Spin, VirtualTrees, Vcl.Themes, vcl.styles;

type



  TTagEditItem = class
      private
        fTagType        : TTagType    ;
        fKey            : String      ;
        fKeyDescription : String      ;
        fValue          : String      ;
        fID3v2Frame     : TID3v2Frame ;
        fMetaAtom       : TMetaAtom   ;
        fEditable       : Boolean     ;
        fNiledByUser    : Boolean     ;
      public
        property TagType         : TTagType    read fTagType    write fTagType    ;
        property Key             : String      read fKey        write fKey        ;
        property KeyDescription  : String      read fKeyDescription write fKeyDescription;
        property Value           : String      read fValue      write fValue      ;
        property ID3v2Frame      : TID3v2Frame read fID3v2Frame write fID3v2Frame ;
        property MetaAtom        : TMetaAtom   read fMetaAtom   write fMetaAtom   ;
        property Editable        : Boolean     read fEditable; // not through a getter, as the getter is quite complex (probably)

        constructor Create(aTagType: TTagType; aKey, aValue: String; aID3v2Frame: TID3v2Frame); Overload;
        procedure InitEditability;

  end;

  TFDetails = class(TForm)
    MainPageControl: TPageControl;
    Tab_General: TTabSheet;
    GrpBox_File: TGroupBox;
    Btn_Explore: TButton;
    Tab_MetaData: TTabSheet;
    Btn_Properties: TButton;
    Tab_Lyrics: TTabSheet;
    GrpBox_Lyrics: TGroupBox;
    PnlWarnung: TPanel;
    Image1: TImage;
    Btn_DeleteLyricFrame: TButton;
    Tab_Pictures: TTabSheet;
    BtnLyricWiki: TButton;
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
    SaveDialog1: TSaveDialog;
    Memo_Lyrics: TMemo;
    ReloadTimer: TTimer;
    PM_EditExtendedTags: TPopupMenu;
    pm_AddTag: TMenuItem;
    pm_RenameTag: TMenuItem;
    pm_RemoveTag: TMenuItem;
    cbLyricOptions: TComboBox;
    LBLSamplerate: TLabel;
    LlblConst_Samplerate: TLabel;
    LlblConst_Bitrate: TLabel;
    LblFormat: TLabel;
    LblConst_Format: TLabel;
    LBLBitrate: TLabel;
    LblConst_Duration: TLabel;
    LblDuration: TLabel;
    GrpBox_TextFrames: TGroupBox;
    CoverLibrary1: TImage;
    Btn_NewMetaFrame: TButton;
    BtnCopyFromV1: TButton;
    Pnl_ID3v1_MPEG: TPanel;
    GrpBox_ID3v1: TGroupBox;
    LblConst_ID3v1Artist: TLabel;
    LblConst_ID3v1Title: TLabel;
    LblConst_ID3v1Album: TLabel;
    LblConst_ID3v1Year: TLabel;
    LblConst_ID3v1Genre: TLabel;
    LblConst_ID3v1Comment: TLabel;
    LblConst_ID3v1Track: TLabel;
    BtnCopyFromV2: TButton;
    Lblv1Album: TEdit;
    Lblv1Artist: TEdit;
    Lblv1Titel: TEdit;
    Lblv1Year: TEdit;
    Lblv1Comment: TEdit;
    Lblv1Track: TEdit;
    cbIDv1Genres: TComboBox;
    GrpBox_Mpeg: TGroupBox;
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
    PnlLibraryMetadata: TPanel;
    GrpBox_ID3v2: TGroupBox;
    LblConst_Artist: TLabel;
    LblConst_Title: TLabel;
    LblConst_Album: TLabel;
    LblConst_Year: TLabel;
    LblConst_Genre: TLabel;
    LblConst_Comment: TLabel;
    LblConst_Track: TLabel;
    LblConst_Rating: TLabel;
    IMG_LibraryRating: TImage;
    LblConst_CD: TLabel;
    LblPlayCounter: TLabel;
    lblConst_ReplayGain: TLabel;
    Edit_LibraryArtist: TEdit;
    Edit_LibraryTitle: TEdit;
    Edit_LibraryAlbum: TEdit;
    Edit_LibraryYear: TEdit;
    Edit_LibraryComment: TEdit;
    Edit_LibraryTrack: TEdit;
    BtnResetRating: TButton;
    CB_LibraryGenre: TComboBox;
    BtnSynchRatingLibrary: TButton;
    Edit_LibraryCD: TEdit;
    GrpBox_TagCloud: TGroupBox;
    Btn_GetTagsLastFM: TButton;
    btn_AddTag: TButton;
    Btn_TagCloudEditor: TButton;
    lb_Tags: TListBox;
    LblReplayGainTitle: TLabel;
    LblReplayGainAlbum: TLabel;
    Panel1: TPanel;
    Btn_Close: TButton;
    BtnUndo: TButton;
    BtnApply: TButton;
    Btn_Refresh: TButton;
    GrpBox_CoverLibrary: TGroupBox;
    CoverLibrary2: TImage;
    OpenDlgCoverArt: TOpenPictureDialog;
    BtnChangeCoverArtInLibrary: TButton;
    BtnRemoveUserCover: TButton;
    BtnLoadCoverArt: TButton;
    PanelCoverArtFile: TPanel;
    gpBoxCurrentSelection: TGroupBox;
    ImgCurrentSelection: TImage;
    PanelCoverArtSelection: TPanel;
    GrpBox_Cover: TGroupBox;
    Btn_OpenImage: TButton;
    cbCoverArtFiles: TComboBox;
    GrpBox_Pictures: TGroupBox;
    Btn_NewPicture: TButton;
    Btn_DeletePicture: TButton;
    Btn_SavePictureToFile: TButton;
    cbCoverArtMetadata: TComboBox;
    Btn_RenameTag: TButton;
    Btn_RemoveTag: TButton;
    BtnRefreshCoverflow: TButton;
    rgChangeCoverArt: TRadioGroup;
    cbFrameTypeSelection: TComboBox;
    VST_MetaData: TVirtualStringTree;
    cbStayOnTop: TCheckBox;

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
    procedure Btn_RefreshClick(Sender: TObject);

    // Procedures for editing the rating of the current file
    procedure IMG_LibraryRatingMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure IMG_LibraryRatingMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure IMG_LibraryRatingMouseLeave(Sender: TObject);
    procedure BtnResetRatingClick(Sender: TObject);

    // EventHandler for Cover on page 1
    procedure Btn_OpenImageClick(Sender: TObject);
    procedure CoverIMAGEDblClick(Sender: TObject);
    procedure cbCoverArtFilesChange(Sender: TObject);
    // Load an image from Pfad and shows it on page 1
    procedure ShowSelectedImage_Files;
    procedure ShowSelectedImage_MetaData;

    procedure InitCurrentTagObject;
    procedure UpdateMediaBibEnabledStatus;

    procedure BtnCopyFromV1Click(Sender: TObject);
    procedure BtnCopyFromV2Click(Sender: TObject);

    // Live-Checking for valid inputs
    procedure Edit_LibraryTrackChange(Sender: TObject);
    procedure Lblv1TrackChange(Sender: TObject);
    procedure Lblv1YearChange(Sender: TObject);
    procedure Edit_LibraryYearChange(Sender: TObject);

    // Show all the Details for an AudioFile
    // Source: Gibt an, ob bei einem Edit der Datei die Medienbib aktualisiert werden muss
    procedure ShowDetails(AudioFile: TAudioFile; Source: Integer = SD_MEDIENBIB);

    // Methods for advanced ID3v2-Tag Editing
    // Lyrics and Pictures
    procedure Btn_DeleteLyricFrameClick(Sender: TObject);
    procedure cbCoverArtMetadataChange(Sender: TObject);
    procedure Btn_NewPictureClick(Sender: TObject);
    procedure Btn_DeletePictureClick(Sender: TObject);
    procedure Btn_SavePictureToFileClick(Sender: TObject);

    // used for Ctrl+A
    procedure Memo_LyricsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    // Getting Lyrics
    procedure BtnLyricWikiClick(Sender: TObject);
    procedure BtnLyricWikiManualClick(Sender: TObject);
    procedure ReloadTimerTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Lblv1Change(Sender: TObject);
    procedure EditLibraryChange(Sender: TObject);
    procedure Memo_LyricsChange(Sender: TObject);
    procedure TagsHasChanged(newIdx: Integer);
    procedure Btn_GetTagsLastFMClick(Sender: TObject);
    procedure BtnSynchRatingLibraryClick(Sender: TObject);
    procedure btn_AddTagClick(Sender: TObject);
    procedure Btn_RenameTagClick(Sender: TObject);
    procedure Btn_RemoveTagClick(Sender: TObject);
    procedure lb_TagsDblClick(Sender: TObject);
    procedure Btn_TagCloudEditorClick(Sender: TObject);
    procedure VST_MetaDataFreeNode(Sender: TBaseVirtualTree;
      Node: PVirtualNode);
    procedure VST_MetaDataGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
        procedure VST_MetaDataPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure VST_MetaDataEditing(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; var Allowed: Boolean);
    procedure VST_MetaDataNewText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; NewText: string);
    procedure Btn_NewMetaFrameClick(Sender: TObject);
    procedure VST_MetaDataNodeDblClick(Sender: TBaseVirtualTree;
      const HitInfo: THitInfo);
    procedure MainPageControlChanging(Sender: TObject;
      var AllowChange: Boolean);
    procedure MainPageControlChange(Sender: TObject);
    procedure BtnUseCurrentSelectionInLibraryClick(Sender: TObject);
    procedure BtnRemoveUserCoverClick(Sender: TObject);
    procedure BtnLoadAnotherImageClick(Sender: TObject);
    procedure BtnRefreshCoverflowClick(Sender: TObject);
    procedure VST_MetaDataCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure cbIDv1GenresChange(Sender: TObject);
    procedure cbStayOnTopClick(Sender: TObject);
  protected
    procedure CreateParams(var Params: TCreateParams); override;

  private
    Coverpfade : TStringList;

    PictureFrames: TObjectList;
    fFileFromMedienBib: Boolean;

    CurrentTagRatingChanged: Boolean;
    CurrentTagRating: Byte;
    CurrentTagCounter: Cardinal;
    CurrentBibRating: Byte;
    CurrentBibCounter: Cardinal;

    CurrentCoverStream: TMemoryStream;

    AudioFileCopy: TAudioFile;

    PictureHasChanged: Boolean;
    LyricsHasChanged: Boolean;

    ID3v1HasChanged: Boolean;
    MetaFramesHasChanged: Boolean;
    CoverArtHasChanged: Boolean;

    TagCloudTagsChanged: Boolean;
    LibraryPropertyChanged: Boolean;

    PicturesLoaded: Boolean;

    // ForceChange: ShowDetails without showing a "Do you want to save..."-Message
    fForceChange: Boolean;

    DetailRatingHelper: TRatingHelper;

    fLastActivePage: TTabSheet;

    CoverArtSearcher: TCoverArtSearcher;

    // procedure SetStayOnTop(aValue: Boolean);

    procedure LoadPictureIntoImage(aFilename: String; aImage: TImage);

    // Show some information of the selected audiofile
    procedure ShowMetaDataFrames;

    procedure FillTagWithID3v1Values(Dest: TID3v2Tag); Overload;
    procedure FillTagWithID3v1Values(Dest: TApeTag); Overload;

    procedure Fillv1TagWithTagValues(Source: TID3v2Tag; Dest: TID3v1Tag); Overload;
    procedure Fillv1TagWithTagValues(Source: TApeTag; Dest: TID3v1Tag); Overload;



    procedure ApplyLyricsToTagObject;
    procedure ApplyEditsToTagObject;
    procedure ApplyTagListToTagObject;
    procedure RemoveNiledFrames;
    procedure ApplyCoverIDChanges;

    procedure ShowMediaBibDetails;
    procedure ShowMPEGDetails(mp3: TMp3File);
    procedure ShowID3v1Details(ID3v1Tag: TID3v1Tag);
    procedure ShowCoverArt_MetaTag;
    procedure ShowCoverArt_Files;
    procedure ShowLyrics;

    // Save information to ID3-Tag
    function UpdateID3v1InFile(ID3v1Tag: TID3v1Tag): TAudioError;
    procedure HandleCoverIDSetting(aNewID: String);

    procedure ReloadDataAfterEdit(aERR: TNempAudioError);
    procedure CheckForChangedData(BackupFile: TAudioFile);
    function CurrentFileHasBeenChanged: Boolean;

    function GetID3v1TagfromBaseAudioFile(aBaseAudioFile: TBaseAudioFile): TID3v1Tag;

  public
    CurrentTagObject: TBaseAudioFile;
    CurrentTagObjectWriteAccessPossible: Boolean;
    CurrentAudioFile : TAudioFile;
    NewLibraryCoverID,
    NewLibraryCoverID_FileSave: String;

    MetaTagType: TTagType;

    procedure RefreshStarGraphics;
    procedure BuildGetLyricButtonHint;
  end;


var
  FDetails: TFDetails;


implementation

Uses NempMainUnit, NewPicture, Clipbrd, MedienbibliothekClass, MainFormHelper, TagHelper,
    AudioFileHelper, CloudEditor, NewMetaFrame, MetaTagSorting, math, AudioDisplayUtils;

{$R *.dfm}


{$REGION ' TTagEditItem, used for storing data in the VirtualStringTree '}

{ TTagEditItem }

constructor TTagEditItem.Create(aTagType: TTagType; aKey, aValue: String;
  aID3v2Frame: TID3v2Frame);
begin
    fTagType   := aTagType    ;
    fKey       := aKey        ;
    fValue     := aValue      ;
    fID3v2Frame:= aID3v2Frame ;
    fNiledByUser := False;
end;

procedure TTagEditItem.InitEditability;
var i: Integer;
begin
    // default setting: Do not allow editing
    fEditable := False;
    case fTagType of
      TT_ID3v2: begin
            fEditable := (self.ID3v2Frame.FrameType = FT_TextFrame) OR
                         (self.ID3v2Frame.FrameType = FT_CommentFrame) OR         // careful!!
                         (self.ID3v2Frame.FrameType = FT_UserDefinedURLFrame) OR  // careful!!
                         (self.ID3v2Frame.FrameType = FT_URLFrame);
      end;
      TT_OggVorbis,
      TT_Flac,
      TT_Ape: begin
            fEditable := True;
            if SameText(KeyDescription, 'CATEGORIES') or
               //SameText(KeyDescription, 'REPLAYGAIN_TRACK_GAIN') OR
               //SameText(KeyDescription, 'REPLAYGAIN_ALBUM_GAIN') OR
               //SameText(KeyDescription, 'REPLAYGAIN_TRACK_PEAK') OR
               //SameText(KeyDescription, 'REPLAYGAIN_ALBUM_PEAK') OR
               AnsiStartsText('REPLAYGAIN', KeyDescription) OR
               AnsiStartsText('MP3GAIN', KeyDescription) OR
               SameText(KeyDescription, 'UNSYNCEDLYRICS') OR
               SameText(KeyDescription, 'CATEGORIES')
            then
                fEditable := False
      end;
      TT_M4A: begin
          if not assigned(self.MetaAtom) then
              fEditable := False
          else
          begin
              // there are some special cases here ...
              // not really clean code, but for now it should be ok
              if (MetaAtom.Name = 'trkn') or (MetaAtom.Name = 'disk') then
                  fEditable := true
              else
              begin
                  if not MetaAtom.ContainsTextData then
                      fEditable := False
                  else
                  begin
                      for i := 0 to length(KnownMetaAtoms) - 1 do
                          if SameText(String(KnownMetaAtoms[i].AtomName), String(MetaAtom.Name)) then
                          begin
                              fEditable := True;
                              break;
                          end;
                      // exclude some known Atoms from editing, as they're kinda "special"
                      if (MetaAtom.Name = '©lyr') OR  // Lyrics
                         (MetaAtom.Name = 'keyw') OR  // Keyword // Nemp-Tags
                         (MetaAtom.Name = '©too') OR  // Encoding Tool
                         (MetaAtom.Name = '©enc') OR
                         (MetaAtom.Name = 'apID')
                      then
                          fEditable := False;
                  end;
              end;
          end;
      end;
    end;
end;
{$ENDREGION}


{$REGION 'Basic FormEvent-Handler ... create, destroy, show, hide, FormCloseQuery (!!)'}
procedure TFDetails.FormCreate(Sender: TObject);
var i:integer;
begin
  PictureFrames := Nil;
  fForceChange := False;

  BackUpComboBoxes(self);
  TranslateComponent (self);
  RestoreComboboxes(self);

  CurrentTagObject := Nil;

  Coverpfade         := TStringList.Create;
  CurrentCoverStream := TMemoryStream.Create;
  AudioFileCopy      := TAudioFile.Create;

  cbIDv1Genres.Items := ID3Genres;
  cbIDv1Genres.Items.Add('');
  for i := 0 to ID3Genres.Count - 1 do
      CB_LibraryGenre.Items.Add(ID3Genres[i]);

  DetailRatingHelper := TRatingHelper.Create;
  LoadStarGraphics(DetailRatingHelper);

  VST_MetaData.NodeDataSize := sizeOf(TTagEditItem);
  CoverArtSearcher := TCoverArtSearcher.Create;

  cbStayOnTop.Checked := NempOptions.DetailFormStayOnTop;
  // SetStayOnTop(NempOptions.DetailFormStayOnTop);
end;


procedure TFDetails.FormDestroy(Sender: TObject);
begin
    if assigned(PictureFrames) then
        PictureFrames.Free;
    if assigned(CurrentTagObject) then
        FreeAndNil(CurrentTagObject);
    Coverpfade.Free;
    DetailRatingHelper.Free;
    AudioFileCopy.Free;
    CurrentCoverStream.Free;
    CoverArtSearcher.Free;
end;

procedure TFDetails.FormShow(Sender: TObject);
begin
//    MainPageControl.ActivePageIndex := 0;
//    MainPageControl.ActivePage := Tab_General;
    BuildGetLyricButtonHint;
    // refresh;

end;



procedure TFDetails.FormHide(Sender: TObject);
begin
    Nemp_MainForm.AutoShowDetailsTMP := False;
    CurrentAudioFile := Nil;
end;

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
          mrAbort : CanClose := False; // Abort showing Details
        end;
    end;
end;
{$ENDREGION}

procedure TFDetails.cbStayOnTopClick(Sender: TObject);
begin
  NempOptions.DetailFormStayOnTop := cbStayOnTop.Checked;
  RecreateWnd;
  //SetStayOnTop(NempOptions.DetailFormStayOnTop);
end;
procedure TFDetails.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  if not NempOptions.DetailFormStayOnTop then
    Params.WndParent := Application.Handle;
end;
(*
procedure TFDetails.SetStayOnTop(aValue: Boolean);
begin
  //RecreateWnd;
  //if aValue then
    //FormStyle := fsStayOnTop
    //SetWindowPos (Handle, HWND_TOPMOST, -1, -1, -1, -1, SWP_NOMOVE + SWP_NOSIZE)
 //   self.PopupParent := Nemp_MainForm
  //else
    //FormStyle := fsNormal;
    //SetWindowPos (Handle, HWND_NOTOPMOST, -1, -1, -1, -1, SWP_NOMOVE + SWP_NOSIZE)
  //  self.PopupParent := Nil;
end; *)


{
    --------------------------------------------------------
    ShowDetails
    - Show all available information
    --------------------------------------------------------
}
procedure TFDetails.ShowDetails(AudioFile: TAudioFile; Source: Integer = SD_MEDIENBIB);
begin
    // Hier auch die Abfrage zum Speichern rein
    if (not fForceChange) and CurrentFileHasBeenChanged and (CurrentAudioFile <> AudioFile) then
    begin
        case TranslateMessageDLG((DetailForm_SaveChanges), mtConfirmation, [MBYes, MBNo, MBAbort], 0) of
          mrYes   : BtnApply.Click;   // save Changes
          mrNo    : ;                 // Nothing to do
          mrAbort : Exit;             // Abort showing Details
        end;
    end;

    if Source <> -1 then
        fFilefromMedienBib := Source = SD_MedienBib;

    if (Nemp_MainForm.AutoShowDetailsTMP) AND (AudioFile <> NIL) then
        FDetails.Visible := True
    else
        exit;

    CurrentAudioFile := AudioFile;
    AudioFileCopy.Assign(CurrentAudioFile);

    // init the currenttagObject
    // - set internal variable CurrentTagRating and CurrentTagCounter
    // - display the Warning-Panel if the file is Not Valid
    // - Activate/Deactivate Tab-Pages for Non-File-Objects (webstream, CDDA)
    InitCurrentTagObject;

    // First Page: MediaLibrary Information
    // note: UpdateEnableStatus AFTER ShowDetails,
    //       because "CurrentBibRating" is used to Show/Hide the SyncRating-Button
    ShowMediaBibDetails;
    UpdateMediaBibEnabledStatus;

    // Second Page (Later the last page??)
    // - display detailed MetaTag-Information, List of all(?) Frames
    ShowMetaDataFrames;
    // for mp3Files:
    // - Show additional Controls for ID3v1-Tags and some more detailed data about MPEG
    if CurrentTagObject.Valid and (CurrentTagObject.filetype = at_mp3) then
        ShowMPEGDetails(TMP3File(CurrentTagObject));

    if MainPageControl.ActivePage = Tab_Pictures then
    begin
        PicturesLoaded := True;
        ShowCoverArt_MetaTag;
        ShowCoverArt_Files;
    end else
        // Show Pictures later, if needed
        PicturesLoaded := False;

    ShowLyrics;

    LibraryPropertyChanged := False;
    TagCloudTagsChanged    := False;
    ID3v1HasChanged        := False;
    MetaFramesHasChanged   := False;
    CoverArtHasChanged     := False;
    PictureHasChanged      := False;
    LyricsHasChanged       := False;
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
procedure TFDetails.ApplyLyricsToTagObject;
begin
    case CurrenttagObject.FileType of
        at_Mp3: begin
              if Trim(Memo_Lyrics.Text) <> '' then
              begin
                  // Ensure that ID3v2Tag exists and set "PARTOFASET"
                  CurrentAudioFile.EnsureID3v2Exists(TMP3File(CurrentTagObject));
                  TMP3File(CurrentTagObject).ID3v2Tag.Lyrics := Trim(Memo_Lyrics.Text)
              end else
              begin
                  // If ID3v2Tag exists, remove Lyrics, if it is set to '' by the User
                  if TMP3File(CurrentTagObject).ID3v2Tag.Exists then
                      TMP3File(CurrentTagObject).ID3v2Tag.Lyrics := '';
              end;
        end;

        at_Ogg:  TOggVorbisFile(CurrentTagObject).SetPropertyByFieldname(VORBIS_LYRICS, Trim(Memo_Lyrics.Text));
        at_Flac: TFlacFile(CurrentTagObject).SetPropertyByFieldname(VORBIS_LYRICS, Trim(Memo_Lyrics.Text));
        at_M4A:  TM4aFile(CurrentTagObject).Lyrics := Trim(Memo_Lyrics.Text);

        at_Monkey,
        at_WavPack,
        at_MusePack,
        at_OptimFrog,
        at_TrueAudio:  TBaseApeFile(CurrentTagObject).ApeTag.SetValueByKey(APE_LYRICS, Trim(Memo_Lyrics.Text));

        at_Wma: ;
        at_Wav: ;
        at_Invalid: ;
    end;
end;


procedure TFDetails.ApplyEditsToTagObject;
var mp3File: TMP3File;
    oggFile: TOggVorbisFile;
    flacFile: TFlacFile;
    m4aFile: TM4aFile;
    apeFile: TBaseApeFile;
begin
    // Apply the Changes made in the Edits
    // (and save them into the Metadata of the AudioFile after this)
    CurrentTagObject.Artist := Edit_LibraryArtist.Text;
    CurrentTagObject.Title  := Edit_LibraryTitle.Text;
    CurrentTagObject.Album  := Edit_LibraryAlbum.Text;
    CurrentTagObject.Genre  := CB_LibraryGenre.Text;
    CurrentTagObject.Year   := Edit_LibraryYear.Text;
    if Edit_LibraryTrack.Text = '0' then
        CurrentTagObject.Track := ''
    else
        CurrentTagObject.Track  := Edit_LibraryTrack.Text;

    case CurrenttagObject.FileType of
        at_Mp3: begin
                    mp3File := TMP3File(CurrentTagObject);
                    mp3File.Comment := Edit_LibraryComment.Text;
                    if Edit_LibraryCD.Text <> '' then
                    begin
                        // Ensure that ID3v2Tag exists and set "PARTOFASET"
                        CurrentAudioFile.EnsureID3v2Exists(mp3File);
                        mp3File.ID3v2Tag.SetText(IDv2_PARTOFASET, Edit_LibraryCD.Text);
                    end else
                    begin
                        // If ID3v2Tag exists, remove the PARTOFASET, if it is set to '' by the User
                        if mp3File.ID3v2Tag.Exists then
                            mp3File.ID3v2Tag.SetText(IDv2_PARTOFASET, Edit_LibraryCD.Text);
                    end;
                    if currentTagRatingChanged then
                    begin
                        CurrentAudioFile.EnsureID3v2Exists(mp3File);
                        // User input: Set the new rating
                        mp3File.ID3v2Tag.Rating := CurrentTagRating;
                        CurrentBibRating  := CurrentTagRating;
                        // Set Playcounter as well to "TagValue"?
                        // No: The Playcounter was not edited (unless the user clicked "reset")
                        //     Therefore, the "library-counter" should have priority, if there is a difference
                        mp3File.ID3v2Tag.PlayCounter := CurrentBibCounter;
                        CurrentTagCounter := CurrentBibCounter;
                    end;
        end;

        at_Ogg: begin
                    oggFile := TOggVorbisFile(CurrentTagObject);
                    oggFile.SetPropertyByFieldname(VORBIS_COMMENT, Edit_LibraryComment.Text);
                    oggFile.SetPropertyByFieldname(VORBIS_DISCNUMBER, Edit_LibraryCD.Text);
                    if currentTagRatingChanged then
                    begin
                        oggFile.SetPropertyByFieldname(VORBIS_RATING   , IntToStr(CurrentTagRating) );
                        oggFile.SetPropertyByFieldname(VORBIS_PLAYCOUNT, IntToStr(CurrentBibCounter));
                        CurrentBibRating  := CurrentTagRating;
                        CurrentTagCounter := CurrentBibCounter;
                    end;
        end;

        at_Flac: begin
                    flacFile := TFlacFile(CurrentTagObject);
                    flacFile.SetPropertyByFieldname(VORBIS_COMMENT, Edit_LibraryComment.Text);
                    flacFile.SetPropertyByFieldname(VORBIS_DISCNUMBER, Edit_LibraryCD.Text);
                    if currentTagRatingChanged then
                    begin
                        flacFile.SetPropertyByFieldname(VORBIS_RATING   , IntToStr(CurrentTagRating) );
                        flacFile.SetPropertyByFieldname(VORBIS_PLAYCOUNT, IntToStr(CurrentBibCounter));
                        CurrentBibRating  := CurrentTagRating;
                        CurrentTagCounter := CurrentBibCounter;
                    end;
        end;

        at_M4A: begin
                    m4aFile := TM4aFile(CurrentTagObject);
                    m4aFile.Comment := Edit_LibraryComment.Text;
                    m4aFile.Disc := Edit_LibraryCD.Text;
                    if currentTagRatingChanged then
                    begin
                        m4aFile.SetSpecialData(DEFAULT_MEAN, M4ARating     , IntToStr(CurrentTagRating));
                        m4aFile.SetSpecialData(DEFAULT_MEAN, M4APlayCounter, IntToStr(CurrentBibCounter));
                    end;
        end;

        at_Monkey,
        at_WavPack,
        at_MusePack,
        at_OptimFrog,
        at_TrueAudio: begin
                    apeFile := TBaseApeFile(CurrentTagObject);
                    apeFile.ApeTag.SetValueByKey(APE_COMMENT, Edit_LibraryComment.Text);
                    apeFile.ApeTag.SetValueByKey(APE_DISCNUMBER, Edit_LibraryCD.Text);
                    if currentTagRatingChanged then
                    begin
                        apeFile.ApeTag.SetValueByKey(APE_RATING   , IntToStr(CurrentTagRating) );
                        apeFile.ApeTag.SetValueByKey(APE_PLAYCOUNT, IntToStr(CurrentBibCounter));
                        CurrentBibRating  := CurrentTagRating;
                        CurrentTagCounter := CurrentBibCounter;
                    end;
        end;
        at_Wma: ;
        at_Wav: ;
        at_Invalid: ;
    end;
end;

procedure TFDetails.ApplyTagListToTagObject;
var s: UTF8String;
    ms: tMemoryStream;
begin
    case CurrenttagObject.FileType of
        at_Mp3: begin
                    TMP3File(CurrentTagObject).Comment := Edit_LibraryComment.Text;

                    if self.lb_Tags.Items.Count > 0 then
                    begin
                        // Ensure that ID3v2Tag exists and set ProvateFrame with "Tags"
                        CurrentAudioFile.EnsureID3v2Exists(TMP3File(CurrentTagObject));
                        s := Utf8String(Trim(lb_Tags.Items.Text));
                        if length(s) > 0 then
                        begin
                            ms := TMemoryStream.Create;
                            try
                                ms.Write(s[1], length(s));
                                TMP3File(CurrentTagObject).ID3v2Tag.SetPrivateFrame('NEMP/Tags', ms);
                            finally
                                ms.Free;
                            end;
                        end else
                            // delete Tags-Frame, if there are none
                            TMP3File(CurrentTagObject).ID3v2Tag.SetPrivateFrame('NEMP/Tags', NIL);
                    end else
                    begin
                        // If ID3v2Tag exists, remove "Tags", if the user removed all of them
                        if TMP3File(CurrentTagObject).ID3v2Tag.Exists then
                            TMP3File(CurrentTagObject).ID3v2Tag.SetPrivateFrame('NEMP/Tags', NIL);
                    end;
        end;

        at_Ogg:     TOggVorbisFile(CurrentTagObject).SetPropertyByFieldname(VORBIS_CATEGORIES, Trim(lb_Tags.Items.Text));
        at_Flac:    TFlacFile(CurrentTagObject).SetPropertyByFieldname(VORBIS_CATEGORIES, Trim(lb_Tags.Items.Text));
        at_M4A:     TM4aFile(CurrentTagObject).Keywords := Trim(lb_Tags.Items.Text);
        at_Monkey,
        at_WavPack,
        at_MusePack,
        at_OptimFrog,
        at_TrueAudio: TBaseApeFile(CurrentTagObject).ApeTag.SetValueByKey(APE_CATEGORIES, Trim(lb_Tags.Items.Text));
        at_Wma: ;
        at_Wav: ;
        at_Invalid: ;
    end;
end;

procedure TFDetails.ApplyCoverIDChanges;
var
  aErr: TNempAudioError;
  oldCoverID: String;
  CoverIDFiles: TAudioFileList;
  loopAudioFile: TAudioFile;
  i: Integer;
begin
  OldCoverID := CurrentAudioFile.CoverID;

  CurrentAudioFile.CoverID := NewLibraryCoverID;
  //  Change also all the files in the library
  //  Note: Setting the Value to CurrentAudioFile is still useful, as this file may be in the Playlist only
  if rgChangeCoverArt.ItemIndex > 0 then
  begin
      ///  We don't need to do a InitCover for the currentAudioFile,
      ///  but we may need it for the other files with the oldCoverID, as
      ///  they may have been grouped together by the same User-CoverID before.
      ///  Now they should be separated again, if needed.
      CoverArtSearcher.StartNewSearch;
      CoverIDFiles := TAudioFileList.create(False);
      try
          // get the list of files which need to be changed
          case rgChangeCoverArt.ItemIndex of
              1: MedienBib.GetTitelListFromCoverIDUnsorted(CoverIDFiles, OldCoverID);
              2: MedienBib.GetTitelListFromDirectoryUnsorted(CoverIDFiles, CurrentAudioFile.Ordner);
          end;

          for i := 0 to CoverIDFiles.Count - 1 do
          begin
              loopAudioFile := CoverIDFiles[i];
              loopAudioFile.CoverID := NewLibraryCoverID_FileSave;

              aErr := loopAudioFile.WriteUserCoverIDToMetaData(AnsiString(NewLibraryCoverID_FileSave), True);
              if aErr <> AUDIOERR_None then
                  HandleError(afa_EditingDetails, CurrentAudioFile, aErr, True);

              /// get a "new valid" Cover-ID with the usual Nemp methods
              ///  In most cases this should be the same as NewLibraryCoverID
              if NewLibraryCoverID_FileSave = '' then
                CoverArtSearcher.InitCover(loopAudioFile, tm_VCL, INIT_COVER_DEFAULT);
          end;
      finally
          CoverIDFiles.Free;
      end;

      // also: Set the Cover-ID of all Playlist-Files
      // But do not write the MetaTags again. That should have been done in the Library-Loop
      for i := 0 to NempPlayList.Playlist.count - 1 do
      begin
          loopAudioFile := NempPlaylist.Playlist.Items[i];
          if loopAudioFile.IsFile and (loopAudioFile.CoverID = OldCoverID) then
          begin
            if NewLibraryCoverID_FileSave = '' then
              CoverArtSearcher.InitCover(loopAudioFile, tm_VCL, INIT_COVER_DEFAULT)
            else
              loopAudioFile.CoverID := NewLibraryCoverID;
          end;
      end;
  end;
end;

procedure TFDetails.RemoveNiledFrames;
var aNode, nextNode: PVirtualNode;
    aTagEditItem: TTagEditItem;
begin
    if not MetaFramesHasChanged then
        // nothing to do
        exit;

    // If the Item has been Niled by the User (i.e. new value = ''), then
    // we should remove the matching Frame/MetaAtom from the inner Tag structure.
    // For Ogg/Flac/Ape, this is not necessary, as we just work with "KEY=VALUE"
    // items there.
    if (CurrentTagObject.FileType = at_Mp3) OR (CurrentTagObject.FileType = at_M4A) then
    begin
        aNode := VST_MetaData.GetFirst;
        while assigned(aNode) do
        begin
            aTagEditItem := VST_MetaData.GetNodeData<TTagEditItem>(aNode);

            if aTagEdititem.fNiledByUser then
            begin
                nextNode := VST_MetaData.GetNext(aNode);

                if CurrentTagObject.FileType = at_Mp3 then
                    TMP3File(CurrentTagObject).ID3v2Tag.DeleteFrame(aTagEdititem.ID3v2Frame);

                if CurrentTagObject.FileType = at_M4A then
                    TM4aFile(CurrentTagObject).RemoveMetaAtom(aTagEditItem.MetaAtom);

                VST_MetaData.DeleteNode(aNode);
                aNode := nextNode;
            end else
                aNode := VST_MetaData.GetNext(aNode);
        end;
    end;
end;

{
    --------------------------------------------------------
    UpdateID3v1InFile
    - Save information to id3v1-tag
    --------------------------------------------------------
}
function TFDetails.UpdateID3v1InFile(ID3v1Tag: TID3v1Tag): TAudioError;

    function v1TagEditsAreEmpty: Boolean;
    begin
        result := (Trim(Lblv1Titel.Text  ) = '') AND
       (Trim(Lblv1Artist.Text ) = '') AND
       (Trim(Lblv1Album.Text  ) = '') AND
       (Trim(Lblv1Comment.Text) = '') AND
       (Trim(cbIDv1Genres.Text) = '') AND
       ((Trim(Lblv1Track.Text  ) = '')  or (Lblv1Track.Text = '0')) AND
       ((Trim(Lblv1Year.Text   ) = '')  or (Lblv1Year.Text = '0'))
    end;

begin
    result := FileErr_None;
    if not CurrentTagObject.Valid then
        exit;

    if ID3v1Tag.Exists and v1TagEditsAreEmpty then
        result := id3v1Tag.RemoveFromFile(CurrentAudioFile.pfad);

    if not v1TagEditsAreEmpty then
        result := id3v1Tag.WriteToFile(CurrentAudioFile.Pfad);
end;


procedure TFDetails.BtnApplyClick(Sender: TObject);
var aErr: TNempAudioError;
    ApeFile: TBaseApeFile;
    mp3File: TMp3File;
    DataWritten: Boolean;
    Backup: TAudioFile;
begin

    if not CurrentTagObject.Valid then
        Exit;

    if (not assigned(CurrentAudioFile))
        or (MedienBib.StatusBibUpdate > 1)
        or (MedienBib.CurrentThreadFilename = CurrentAudioFile.Pfad)
    then
    begin
        ///  If we just want to edit one file, it is ok to do it, unless
        ///  a working thread is editing just this very file in this very moment,
        ///  or the library is in a critical phase of an update
        TranslateMessageDLG((Warning_MedienBibIsBusyCritical), mtWarning, [MBOK], 0);
        exit;
    end;

    if (CoverArtHasChanged and (rgChangeCoverArt.ItemIndex > 0))
        and
        (MedienBib.StatusBibUpdate <> 0)
    then
    begin
        ///  we need to do some more in the library than just editing one file,
        ///  which involves CoverSearch (InitCover and stuff)
        ///  Therefore: Do NOT do it now.
        TranslateMessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
        exit;
    end;


    Backup := TAudioFile.Create;
    try
        Backup.Assign(CurrentAudioFile);

        // Update TagCloud-Tags
        if TagCloudTagsChanged  then
            ApplyTagListToTagObject;

        // Update Lyrics
        if LyricsHasChanged then
            ApplyLyricsToTagObject;

        // remove some ID3v2Frames or M4A-Atoms, if needed
        RemoveNiledFrames;

        // Update TagObject
        // Note: This may overwrite some changes made in the Tab_MetaData-Page
        //       (But the user has been warned, so it's ok ;-) )
        if LibraryPropertyChanged or CurrentTagRatingChanged then
            ApplyEditsToTagObject;

        aErr := AUDIOERR_None;
        DataWritten := False;
        case currenttagObject.FileType of
            ///  Apetags are now supported in mp3Files
            ///  However, Lyrics and Pictures are only stored in ID3v2. There will be no duplicates
            ///  of these in the APETag.
            at_Mp3: begin
                  mp3File := TMP3File(CurrentTagObject);
                  // we need to take care of ID3v1 vs. ID3v2 vs. APEv2 here.
                  if ID3v1HasChanged or (LibraryPropertyChanged and mp3File.ID3v1Tag.Exists) then
                  begin
                      // this will also remove the ID3v1-Tag, if all Edits are empty
                      aErr := AudioToNempAudioError(UpdateID3v1InFile(mp3File.ID3v1Tag));
                      DataWritten := aErr = AUDIOERR_None;
                  end;

                  // New in 4.15.: ApeTags are supported as well for mp3-files
                  // (but only rudimentary)
                  if  (LibraryPropertyChanged AND mp3File.ApeTag.Exists)
                      or MetaFramesHasChanged
                  then begin
                      // if ApeTag contains no data any more, it will be removed by "WriteToFile".
                      aErr := AudioToNempAudioError(mp3File.ApeTag.WriteToFile(CurrentAudioFile.Pfad));
                      DataWritten := aErr = AUDIOERR_None;
                  end;

                  if  (LibraryPropertyChanged AND mp3File.ID3v2Tag.Exists)
                      or CurrentTagRatingChanged or MetaFramesHasChanged or LyricsHasChanged
                      or TagCloudTagsChanged or PictureHasChanged or CoverArtHasChanged
                  then begin
                      // write the ID3v2-MetaFrames into the file now
                      aErr := AudioToNempAudioError(mp3File.ID3v2Tag.WriteToFile(CurrentAudioFile.Pfad));
                      DataWritten := aErr = AUDIOERR_None;
                  end;

                  if LibraryPropertyChanged and (not DataWritten) then
                    mp3File.WriteToFile(CurrentAudioFile.Pfad);
            end;

            at_Monkey,
            at_WavPack,
            at_MusePack,
            at_OptimFrog,
            at_TrueAudio: begin
                  ApeFile := TBaseApeFile(CurrentTagObject);
                  if ID3v1HasChanged or (LibraryPropertyChanged and ApeFile.ID3v1Tag.Exists) then
                  begin
                      // this will also remove the ID3v1-Tag, if all Edits are empty
                      aErr := AudioToNempAudioError(UpdateID3v1InFile(ApeFile.ID3v1Tag));
                      DataWritten := aErr = AUDIOERR_None;
                  end;

                  if  (LibraryPropertyChanged AND ApeFile.ApeTag.Exists)
                      or CurrentTagRatingChanged or MetaFramesHasChanged or LyricsHasChanged
                      or TagCloudTagsChanged or PictureHasChanged or CoverArtHasChanged
                  then begin
                      // write the Apev2-Tag into the file
                      aErr := AudioToNempAudioError(ApeFile.ApeTag.WriteToFile(CurrentAudioFile.Pfad));
                      DataWritten := aErr = AUDIOERR_None;
                  end;

                  if LibraryPropertyChanged and (not DataWritten) then
                    ApeFile.WriteToFile(CurrentAudioFile.Pfad);
            end;

        else
            aErr := AudioToNempAudioError(CurrentTagObject.UpdateFile);
        end;

        if aErr <> AUDIOERR_None then
        begin
            TranslateMessageDLG(NempAudioErrorString[aErr], mtWarning, [MBOK], 0);
            HandleError(afa_EditingDetails, CurrentAudioFile, aErr, True);
        end;

        if CoverArtHasChanged then
        begin
          ApplyCoverIDChanges;

        end;

        // Show the Refresh-Coverflow-Button, if CoverArt has been changed
        if CoverArtHasChanged AND (MedienBib.BrowseMode = 1) then
            BtnRefreshCoverflow.Visible := True;


        LibraryPropertyChanged := False;
        TagCloudTagsChanged    := False;
        ID3v1HasChanged        := False;
        MetaFramesHasChanged   := False;
        CoverArtHasChanged     := False;
        PictureHasChanged      := False;
        LyricsHasChanged       := False;
        CurrentTagRatingChanged := False;
        ReloadDataAfterEdit(aErr);
        CheckForChangedData(Backup);
    finally
      Backup.Free;
    end;
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

procedure TFDetails.BtnRefreshCoverflowClick(Sender: TObject);
var idx: Integer;
begin
    if MedienBib.BrowseMode <> 1 then
        TranslateMessageDLG((DetailForm_CoverflowNotActive), mtInformation, [MBOk], 0)
    else
    begin
          SwitchMediaLibrary(1);
          Nemp_MainForm.CoverScrollbarChange(Nil);
          // double setting because of some repaint-issues ...
          idx := MedienBib.NewCoverFlow.CurrentItem;
          Nemp_MainForm.CoverScrollbar.Position := 0;
          Nemp_MainForm.CoverScrollbar.Position := idx;
    end;
end;


procedure TFDetails.MainPageControlChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
    fLastActivePage := MainPageControl.ActivePage;
end;

procedure TFDetails.MainPageControlChange(Sender: TObject);
begin

    if (MainPageControl.ActivePage = Tab_Pictures) and (NOT PicturesLoaded) then
    begin
        PicturesLoaded := True;
        ShowCoverArt_MetaTag;
        ShowCoverArt_Files;
    end;

    if LibraryPropertyChanged then
    begin
        if (fLastActivePage <> Tab_MetaData) and (MainPageControl.ActivePage = Tab_MetaData) then
        begin
            if TranslateMessageDLG((DetailForm_LibraryTagChanged), mtWarning, [MBYes, MBNo], 0) = mrYes then
                BtnApply.Click;
        end;
    end;

    if MetaFramesHasChanged or ID3v1HasChanged then
    begin
        if (fLastActivePage <> Tab_General) and  (MainPageControl.ActivePage = Tab_General) then
        begin
            if TranslateMessageDLG((DetailForm_LibraryTagChanged), mtWarning, [MBYes, MBNo], 0) = mrYes then
                BtnApply.Click;
        end;
    end;
end;


{$REGION 'Small Supporting methods, little QoL-Features'}

(*
procedure TFDetails.LoadStarGraphics;
var s,h,u: TBitmap;
    baseDir: String;
begin
    s := TBitmap.Create;
    h := TBitmap.Create;
    u := TBitmap.Create;

    if Nemp_MainForm.NempSkin.isActive
        and (not Nemp_MainForm.NempSkin.UseDefaultStarBitmaps)
        and Nemp_MainForm.NempSkin.UseAdvancedSkin
        and NempOptions.GlobalUseAdvancedSkin
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
*)

procedure TFDetails.RefreshStarGraphics;
begin
    LoadStarGraphics(DetailRatingHelper);
    DetailRatingHelper.DrawRatingInStarsOnBitmap(CurrentBibRating, IMG_LibraryRating.Picture.Bitmap, IMG_LibraryRating.Width, IMG_LibraryRating.Height);
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
    Btn_ExploreClick
    Btn_PropertiesClick
    - Show CurrentFile in Explorer,
    - Open the Windows-Properties dialog for the CurrentFile
    --------------------------------------------------------
}
procedure TFDetails.Btn_ExploreClick(Sender: TObject);
begin
  if DirectoryExists(CurrentAudioFile.Ordner) then
        ShellExecute(Handle, 'open' ,'explorer.exe'
        , Pchar('/e,/select,"'+CurrentAudioFile.Pfad+'"'), '', sw_ShowNormal);
end;
procedure TFDetails.Btn_PropertiesClick(Sender: TObject);
begin
    ShowFileProperties(Nemp_MainForm.Handle, pChar(CurrentAudioFile.Pfad),'');
end;

{
    --------------------------------------------------------
    lb_TagsDblClick
    - Show all Files with this Tag in Main window
    --------------------------------------------------------
}
procedure TFDetails.lb_TagsDblClick(Sender: TObject);
begin
    if lb_Tags.ItemIndex > 0 then
        MedienBib.GlobalQuickTagSearch(lb_Tags.Items[lb_Tags.ItemIndex]);
end;

{$ENDREGION}


{$REGION 'Handling of Tags for the TagCloud'}

procedure TFDetails.btn_AddTagClick(Sender: TObject);
var newTagDummy: String;
    IgnoreWarningsDummy: Boolean;
begin
    if HandleSingleFileTagChange(AudioFileCopy, '', newTagDummy, IgnoreWarningsDummy) then
        TagsHasChanged(lb_Tags.Items.Count-1);
end;

procedure TFDetails.Btn_RemoveTagClick(Sender: TObject);
var CurrentTagToChange: String;
    CurrentIdx: Integer;
begin
    CurrentIdx := lb_Tags.ItemIndex;
    if (MedienBib.StatusBibUpdate <= 1)
        and assigned(AudioFileCopy)
        and (MedienBib.CurrentThreadFilename <> AudioFileCopy.Pfad)
        and (CurrentIdx >= 0)
    then
    begin
        CurrentTagToChange := lb_Tags.Items[CurrentIdx];
        if AudioFileCopy.RemoveTag(CurrentTagToChange) then
            TagsHasChanged(CurrentIdx);
    end;
end;

procedure TFDetails.Btn_RenameTagClick(Sender: TObject);
var newTagDummy, CurrentTagToChange: String;
    IgnoreWarningsDummy: Boolean;
    CurrentIdx: Integer;
begin
    CurrentIdx := lb_Tags.ItemIndex;
    if (MedienBib.StatusBibUpdate <= 1)
        and assigned(AudioFileCopy)
        and (MedienBib.CurrentThreadFilename <> AudioFileCopy.Pfad)
        and (CurrentIdx >= 0)
    then
    begin
        CurrentTagToChange := lb_Tags.Items[CurrentIdx];
        if HandleSingleFileTagChange(AudioFileCopy, CurrentTagToChange, newTagDummy, IgnoreWarningsDummy) then
            TagsHasChanged(lb_Tags.Count - 1);
    end;
end;


procedure TFDetails.Btn_GetTagsLastFMClick(Sender: TObject);
var s: String;
    TagPostProcessor: TTagPostProcessor;
begin
    AudioFileCopy.RawTagLastFM := UTF8String(Trim(lb_Tags.Items.Text));

    TagPostProcessor := TTagPostProcessor.Create;
    try
        TagPostProcessor.LoadFiles;
        s := MedienBib.BibScrobbler.GetTags(AudioFileCopy);
        if trim(s) = '' then
            TranslateMessageDLG(MediaLibrary_GetTagsFailed, mtInformation, [MBOK], 0)
        else
        begin
            // process new Tags. Rename, delete ignored and duplicates.
            MedienBib.AddNewTag(AudioFileCopy, s, False);
            TagCloudTagsChanged := True;
        end;

        // Show tags of temporary file in the memo
        lb_Tags.Items.Text := String(AudioFileCopy.RawTagLastFM);
    finally
        TagPostProcessor.Free;
    end;
end;

procedure TFDetails.Btn_TagCloudEditorClick(Sender: TObject);
begin
    {
    Neu machen ....

    if MedienBib.BrowseMode <> 2 then
        MedienBib.ReBuildTagCloud;

    }

    if not assigned(CloudEditorForm) then
        Application.CreateForm(TCloudEditorForm, CloudEditorForm);
    CloudEditorForm.Show;
end;

// extended tags has changed
procedure TFDetails.TagsHasChanged(newIdx: Integer);
begin
    // refresh tags in the view
    if assigned(AudioFileCopy) then
    begin
        lb_Tags.Items.Text := String(AudioFileCopy.RawTagLastFM);

        if newIdx < 0 then
            newIdx := 0;
        if newIdx >= lb_Tags.Count then
            newIdx := lb_Tags.Count-1;

        if (newIdx < lb_Tags.Count) and (newIdx >= 0) then
            lb_Tags.Selected[newIdx] := True;

        TagCloudTagsChanged := True;
    end;
end;

{$ENDREGION}


{$REGION 'Handling of Lyrics'}


procedure TFDetails.ShowLyrics;
var ButtonsEnable: Boolean;
    ext: String;
begin
    ButtonsEnable := CurrentTagObject.Valid; // (ValidOggFile) or (ValidFlacFile) or ValidApeFile or ValidM4AFile;

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
        at_Mp3: Memo_Lyrics.Text := TMP3File(CurrentTagObject).ID3v2Tag.Lyrics;
        at_Ogg: Memo_Lyrics.Text := TOggVorbisFile(CurrentTagObject).GetPropertyByFieldname(VORBIS_LYRICS);
        at_Flac: Memo_Lyrics.Text := TFlacFile(CurrentTagObject).GetPropertyByFieldname(VORBIS_LYRICS);
        at_M4A: Memo_Lyrics.Text := TM4aFile(CurrentTagObject).Lyrics;
        at_Monkey,
        at_WavPack,
        at_MusePack,
        at_OptimFrog,
        at_TrueAudio: Memo_Lyrics.Text := TBaseApeFile(CurrentTagObject).ApeTag.GetValueByKey(APE_LYRICS);
        at_Invalid,
        at_Wma,
        at_Wav: Memo_Lyrics.Text := '';
    end;

    Btn_DeleteLyricFrame.Enabled := ButtonsEnable and (Memo_Lyrics.Text <> '');
    BtnLyricWiki.Enabled         := ButtonsEnable;
    //BtnLyricWikiManual can be always activated
end;

procedure TFDetails.Btn_DeleteLyricFrameClick(Sender: TObject);
begin
    case CurrentTagObject.FileType of
        at_Mp3: begin
                    TMP3File(CurrentTagObject).ID3v2Tag.Lyrics := '';
                    LyricsHasChanged := True;
                end;
        at_Ogg: begin
                    TOggVorbisFile(CurrentTagObject).SetPropertyByFieldname(VORBIS_LYRICS, '');
                    LyricsHasChanged := True;
                end;
        at_Flac: begin
                    TFlacFile(CurrentTagObject).SetPropertyByFieldname(VORBIS_LYRICS, '');
                    LyricsHasChanged := True;
                end;
        at_M4A: begin
                    TM4aFile(CurrentTagObject).Lyrics := '';
                    LyricsHasChanged := True;
                end;
        at_Monkey,
        at_WavPack,
        at_MusePack,
        at_OptimFrog,
        at_TrueAudio: begin
                    TBaseApeFile(CurrentTagObject).ApeTag.SetValueByKey(APE_LYRICS, '');
                    LyricsHasChanged := True;
                end;

        at_Invalid: ;
        at_Wma: ;
        at_Wav: ;
    end;

    // Maybe there are some other Lyrics in the id3-tag ;-)
    ShowLyrics;
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
    LyricsHasChanged := True;
end;
{
    --------------------------------------------------------
    BtnLyricWikiClick
    BtnLyricWikiManualClick
    - Search on LyricWiki.org for Lyrics
      ManualSearch opens URL in Webbrowser
    --------------------------------------------------------
}
procedure TFDetails.BuildGetLyricButtonHint;
var Prio1, Prio2: TLyricFunctionsEnum;
begin
    MedienBib.GetLyricPriorities(Prio1, Prio2);
    BtnLyricWiki.Hint := Format(Hint_LyricPriorities, [GetGenericPriorityString(Prio1, Prio2)]);
end;


procedure TFDetails.BtnLyricWikiClick(Sender: TObject);
var Lyrics: TLyrics;
    LyricString: String;
    Prio1, Prio2: TLyricFunctionsEnum;
begin
        // if ValidMp3File or ValidOggFile or ValidFlacFile or ValidApeFile or ValidM4AFile then
        if CurrentTagObject.Valid then

        begin
            CurrentAudioFile.FileIsPresent:=True;
            Lyrics := TLyrics.Create;
            try
                MedienBib.GetLyricPriorities(Prio1, Prio2);
                Lyrics.SetLyricSearchPriorities(Prio1, Prio2);

                // ShowMessage(Lyrics.PriorityString);
                LyricString := Lyrics.GetLyrics(CurrentAudioFile.Artist, CurrentAudioFile.Titel);
                if LyricString = '' then
                begin
                    // no lyrics found
                    if (TranslateMessageDLG(LyricsSearch_NotFoundMessage, mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
                        BtnLyricWikiManual.Click;
                end else
                begin
                    // ok, Lyrics found
                    Memo_Lyrics.Text := LyricString;
                    LyricsHasChanged := True;
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
    case cbLyricOptions.ItemIndex of
        0: LyricQuery := AnsiString(BuildURL_LyricWiki(CurrentAudioFile.Artist, CurrentAudioFile.Titel));
        1: LyricQuery := AnsiString(BuildURL_ChartLyricsManual(CurrentAudioFile.Artist, CurrentAudioFile.Titel));
    else
        LyricQuery := AnsiString(BuildURL_LyricWiki(CurrentAudioFile.Artist, CurrentAudioFile.Titel));
    end;

    ShellExecuteA(Handle, 'open', PAnsiChar(LyricQuery), nil, nil, SW_SHOW);
end;


{$ENDREGION}

procedure TFDetails.ReloadDataAfterEdit(aERR: TNempAudioError);
var ListOfFiles: TAudioFileList;
    listFile: TAudioFile;
    i: Integer;
begin
    aErr := CurrentAudioFile.GetAudioData(CurrentAudioFile.Pfad, GAD_Rating);

    if aErr <> AUDIOERR_None then
    begin
        TranslateMessageDLG(NempAudioErrorString[aErr], mtWarning, [MBOK], 0);
        HandleError(afa_EditingDetails, CurrentAudioFile, aErr, True);
        exit;
    end;

    // Update other copies of this file
    ListOfFiles := TAudioFileList.Create(False);
    try
        GetListOfAudioFileCopies(CurrentAudioFile, ListOfFiles);
        for i := 0 to ListOfFiles.Count - 1 do
        begin
            listFile := ListOfFiles[i];
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
    // note: This will also activate ReloadTimerTimer
    //       which will call "ShowDetails" again to refresh this whole form
    CorrectVCLAfterAudioFileEdit(CurrentAudioFile);
end;

procedure TFDetails.CheckForChangedData(BackupFile: TAudioFile);
var
  CollectionDirty, SearchDirty: Boolean;
begin
  CollectionDirty := False;
  SearchDirty := False;
  // Check for relevant changes for the QuickSearch-String
  if (BackupFile.Artist <> CurrentAudioFile.Artist)
    or (BackupFile.Titel <> CurrentAudioFile.Titel)
    or (BackupFile.Album <> CurrentAudioFile.Album)
  then
    // Artist, Title and Album are handled the same for Searchstrings, so one test for all is enough
    // (they are all included, or Search is not accelerated at all)
    SearchDirty := SearchDirty or MedienBib.SearchStringIsDirty(CON_ARTIST);
  // other properties may be included or not
  if (BackupFile.Comment  <> CurrentAudioFile.Comment) then
    SearchDirty := SearchDirty or MedienBib.SearchStringIsDirty(CON_STANDARDCOMMENT);
  if (BackupFile.Genre  <> CurrentAudioFile.Genre) then
    SearchDirty := SearchDirty or MedienBib.SearchStringIsDirty(CON_GENRE);

  // Check for relevant changes for the collections
  if (BackupFile.Artist <> CurrentAudioFile.Artist) then
    CollectionDirty := CollectionDirty or MedienBib.CollectionsAreDirty(CON_ARTIST);
  if (BackupFile.Album <> CurrentAudioFile.Album) then
    CollectionDirty := CollectionDirty or MedienBib.CollectionsAreDirty(CON_ALBUM);
  if (BackupFile.Year <> CurrentAudioFile.Year) then
    CollectionDirty := CollectionDirty or MedienBib.CollectionsAreDirty(CON_YEAR);
  if (BackupFile.Genre <> CurrentAudioFile.Genre) then
    CollectionDirty := CollectionDirty or MedienBib.CollectionsAreDirty(CON_GENRE);
  if (BackupFile.RawTagLastFM <> CurrentAudioFile.RawTagLastFM) then
    CollectionDirty := CollectionDirty or MedienBib.CollectionsAreDirty(ccTagCloud);

  // Set Warning in BrowseTabs of the MainForm, if necessary
  if SearchDirty or CollectionDirty then
    SetBrowseTabWarning(True);
end;


procedure TFDetails.InitCurrentTagObject;
var aErr: TAudioError;
begin

    BtnApply.Enabled := CurrentAudioFile.IsFile AND FileExists(CurrentAudioFile.Pfad);
    BtnUndo.Enabled  := CurrentAudioFile.IsFile AND FileExists(CurrentAudioFile.Pfad);

    if not FileExists(CurrentAudioFile.Pfad) then
    begin
        // File does not exist
        if assigned(CurrentTagObject) then
            FreeAndNil(CurrentTagObject);
        // set default values
        CurrentTagObject := AudioFileFactory.CreateAudioFile(CurrentAudioFile.Pfad, True);
        aErr := FileErr_NoFile; //CurrentTagObject.ReadFromFile(CurrentAudioFile.Pfad)
        CurrentTagRatingChanged := False;
        CurrentTagObjectWriteAccessPossible := False;
        CurrentTagRating := 0;
        CurrentTagCounter := 0;
    end
    else
    begin
        if assigned(CurrentTagObject) then
            FreeAndNil(CurrentTagObject);

        // initialise the CurrentTagObject from Filename
        CurrentTagObject := AudioFileFactory.CreateAudioFile(CurrentAudioFile.Pfad, True);
        aErr := CurrentTagObject.ReadFromFile(CurrentAudioFile.Pfad);

        CurrentTagRatingChanged := False;
        PnlWarnung.Visible := (not assigned(CurrentTagObject)) or (not CurrentTagObject.Valid);

        if assigned(CurrentTagObject) and CurrentTagObject.Valid then
        begin
            case CurrentTagObject.FileType of
                    at_Mp3: begin
                                CurrentTagRating := TMp3File(CurrentTagObject).Id3v2Tag.Rating;
                                CurrentTagCounter:= TMp3File(CurrentTagObject).Id3v2Tag.PlayCounter;
                                CurrentTagObjectWriteAccessPossible := True;
                            end;

                    at_Ogg: begin
                                CurrentTagRating := StrToIntDef(TOggVorbisFile(CurrentTagObject).GetPropertyByFieldname(VORBIS_RATING),0);
                                CurrentTagCounter:= StrToIntDef(TOggVorbisFile(CurrentTagObject).GetPropertyByFieldname(VORBIS_PLAYCOUNT),0);
                                CurrentTagObjectWriteAccessPossible := True;
                            end;

                    at_Flac: begin
                                CurrentTagRating := StrToIntDef(TFlacFile(CurrentTagObject).GetPropertyByFieldname(VORBIS_RATING),0);
                                CurrentTagCounter:= StrToIntDef(TFlacFile(CurrentTagObject).GetPropertyByFieldname(VORBIS_PLAYCOUNT),0);
                                CurrentTagObjectWriteAccessPossible := True;
                              end;

                    at_M4a: begin
                                CurrentTagCounter := StrToIntDef(TM4aFile(CurrentTagObject).GetSpecialData(DEFAULT_MEAN, M4APlayCounter),0);
                                CurrentTagRating  := StrToIntDef(TM4aFile(CurrentTagObject).GetSpecialData(DEFAULT_MEAN, M4ARating), 0);
                                CurrentTagObjectWriteAccessPossible := True;
                            end;

                    at_Monkey,
                    at_WavPack,
                    at_MusePack,
                    at_OptimFrog,
                    at_TrueAudio: begin
                                  CurrentTagRating := StrToIntDef(TBaseApeFile(CurrentTagObject).ApeTag.GetValueByKey(APE_RATING),0);
                                  CurrentTagCounter:= StrToIntDef(TBaseApeFile(CurrentTagObject).ApeTag.GetValueByKey(APE_PLAYCOUNT),0);
                                  CurrentTagObjectWriteAccessPossible := True;
                              end;

                    at_Invalid,
                    at_Wma,
                    at_Wav: begin
                            CurrentTagRating := 0;
                            CurrentTagCounter := 0;
                            CurrentTagObjectWriteAccessPossible := False;
                    end;
            end;
        end;

        if (not CurrentTagObject.Valid) then
        begin
            CurrentTagRating := 0;
            CurrentTagCounter := 0;
            CurrentTagObjectWriteAccessPossible := False;
                case CurrentTagObject.FileType of
                    at_Mp3: begin
                                    Lbl_Warnings.Caption := (Warning_InvalidMp3file);
                                    Lbl_Warnings.Hint    := (Warning_InvalidMp3file_Hint);
                            end;
                    at_Ogg: begin
                                    Lbl_Warnings.Caption := NempAudioErrorString[AudioToNempAudioError(aErr)];
                                    Lbl_Warnings.Hint := (Warning_ReadError_Hint);
                            end;
                    at_Flac: begin
                                    Lbl_Warnings.Caption := NempAudioErrorString[AudioToNempAudioError(aErr)];
                                    Lbl_Warnings.Hint := (Warning_ReadError_Hint);
                              end;
                    at_M4a: begin
                                    Lbl_Warnings.Caption := NempAudioErrorString[AudioToNempAudioError(aErr)];
                                    Lbl_Warnings.Hint := (Warning_ReadError_Hint);
                            end;
                    at_Monkey,
                    at_WavPack,
                    at_MusePack,
                    at_OptimFrog,
                    at_TrueAudio: begin
                                    Lbl_Warnings.Caption := (Warning_InvalidBaseApefile); //AudioErrorString[AudioToNempAudioError(CurrentTagObject.LastError)];
                                    Lbl_Warnings.Hint := (Warning_InvalidBaseApefile_Hint);
                              end;
                    at_Invalid: begin
                                  Lbl_Warnings.Caption := (Warning_NotSupportedFileType);
                                  Lbl_Warnings.Hint    := (Warning_NotSupportedFileType_Hint);
                    end;
                    at_Wma,
                    at_Wav: ; // nothing to do
                end;
        end;
    end;

    Tab_MetaData  .TabVisible := CurrentAudioFile.IsFile AND CurrentTagObjectWriteAccessPossible;
    Tab_Lyrics    .TabVisible := CurrentAudioFile.IsFile AND CurrentTagObjectWriteAccessPossible;
    Tab_Pictures  .TabVisible := CurrentAudioFile.IsFile AND CurrentTagObjectWriteAccessPossible;
end;


{$REGION 'First Page: MediaLibrary Details. Reading/Writing on "AudioFile-Level", bnot on "Metadata-Level" }

{
    --------------------------------------------------------
    UpdateMediaBibEnabledStatus
    - (de)activate some MediaLibrary stuff
    --------------------------------------------------------
}
procedure TFDetails.UpdateMediaBibEnabledStatus;
var BasicInfoEnable, EditsAndButtonsEnable: Boolean;
begin
    BasicInfoEnable:= (CurrentAudioFile <> NIL);

    EditsAndButtonsEnable := assigned(CurrentAudioFile) AND (CurrentAudioFile.IsFile) AND FileExists(CurrentAudioFile.Pfad)
                            AND assigned(CurrentTagObject) AND CurrentTagObject.Valid
                            AND CurrentTagObjectWriteAccessPossible ;

    Btn_Properties.Enabled := assigned(CurrentAudioFile) AND (CurrentAudioFile.IsFile) AND FileExists(CurrentAudioFile.Pfad);
    Btn_Explore.Enabled := assigned(CurrentAudioFile) AND (CurrentAudioFile.IsFile) AND FileExists(CurrentAudioFile.Pfad);

    // Display of basic file information
    LlblConst_Path      .Enabled := BasicInfoEnable;
    LlblConst_Filename  .Enabled := BasicInfoEnable;
    LlblConst_FileSize  .Enabled := BasicInfoEnable;
    LblConst_Duration   .Enabled := BasicInfoEnable;
    LlblConst_Samplerate.Enabled := BasicInfoEnable;
    LlblConst_Bitrate   .Enabled := BasicInfoEnable;
    LblConst_Format     .Enabled := BasicInfoEnable;

    LblPfad      .Enabled := BasicInfoEnable;
    LblName      .Enabled := BasicInfoEnable;
    LblSize      .Enabled := BasicInfoEnable;
    LblDuration  .Enabled := BasicInfoEnable;
    LblSamplerate.Enabled := BasicInfoEnable;
    LblBitrate   .Enabled := BasicInfoEnable;
    LblFormat    .Enabled := BasicInfoEnable;

    // Edits for basic tags
    LblConst_Artist .Enabled := EditsAndButtonsEnable;
    LblConst_Title  .Enabled := EditsAndButtonsEnable;
    LblConst_Album  .Enabled := EditsAndButtonsEnable;
    LblConst_Comment.Enabled := EditsAndButtonsEnable;
    LblConst_Genre  .Enabled := EditsAndButtonsEnable;
    LblConst_Track  .Enabled := EditsAndButtonsEnable;
    LblConst_Year   .Enabled := EditsAndButtonsEnable;
    LblConst_CD     .Enabled := EditsAndButtonsEnable;
    LblConst_Rating .Enabled := EditsAndButtonsEnable;

    Edit_LibraryArtist   .Enabled := EditsAndButtonsEnable;
    Edit_LibraryTitle    .Enabled := EditsAndButtonsEnable;
    Edit_LibraryAlbum    .Enabled := EditsAndButtonsEnable;
    Edit_LibraryYear     .Enabled := EditsAndButtonsEnable;
    Edit_LibraryComment  .Enabled := EditsAndButtonsEnable;
    Edit_LibraryTrack    .Enabled := EditsAndButtonsEnable;
    Edit_LibraryCD       .Enabled := EditsAndButtonsEnable;
    IMG_LibraryRating    .Enabled := EditsAndButtonsEnable;
    CB_LibraryGenre      .Enabled := EditsAndButtonsEnable;

    lblConst_ReplayGain.Enabled := EditsAndButtonsEnable;
    LblReplayGainTitle .Enabled := EditsAndButtonsEnable;
    LblReplayGainAlbum .Enabled := EditsAndButtonsEnable;

    LblPlayCounter.Enabled := EditsAndButtonsEnable;
    BtnResetRating.Enabled := EditsAndButtonsEnable;
    BtnSynchRatingLibrary.Visible := EditsAndButtonsEnable AND (CurrentTagRating <> CurrentBibRating);

    // Controls for TagCloud
    lb_Tags            .Enabled := EditsAndButtonsEnable;
    Btn_AddTag         .Enabled := EditsAndButtonsEnable;
    Btn_RenameTag      .Enabled := EditsAndButtonsEnable;
    Btn_RemoveTag      .Enabled := EditsAndButtonsEnable;
    Btn_GetTagsLastFM  .Enabled := EditsAndButtonsEnable;
    Btn_TagCloudEditor .Enabled := EditsAndButtonsEnable;

    // Main Controls
    BtnApply.Enabled := EditsAndButtonsEnable;
    BtnUndo.Enabled  := EditsAndButtonsEnable;
end;

procedure TFDetails.ShowMediaBibDetails;
var mbAudioFile: TAudioFile;

    procedure LoadLibraryCoverIntoImage(dest: TImage);
    begin
        dest.Picture.Assign(Nil);
        dest.Refresh;
        dest.Picture.Bitmap.Width := dest.Width;
        dest.Picture.Bitmap.Height := dest.Height;
        // Get the picture (only using the *CoverID*.jpg)
        TCoverArtSearcher.GetCover_Fast(CurrentAudioFile, dest.Picture);
        //GetCover(CurrentAudioFile, dest.Picture, False);
        dest.Picture.Assign(dest.Picture);
        dest.Refresh;
    end;

begin
  if (CurrentAudioFile = Nil) then
  begin
        CoverLibrary1.Picture.Bitmap.Assign(NIL);

        FDetails.Caption := Format('%s [N/A]', [(DetailForm_Caption)]);
        LblPfad      .Caption := 'N/A';
        LblName      .Caption := 'N/A';
        LblSize      .Caption := 'N/A';
        LblDuration  .Caption := 'N/A';
        LblSamplerate.Caption := 'N/A';
        LblBitrate   .Caption := 'N/A';
        LblFormat    .Caption := 'N/A';
        Edit_LibraryArtist   .Text := '';
        Edit_LibraryArtist   .Text := '';
        Edit_LibraryTitle    .Text := '';
        Edit_LibraryAlbum    .Text := '';
        Edit_LibraryYear     .Text := '';
        Edit_LibraryComment  .Text := '';
        Edit_LibraryTrack    .Text := '';
        Edit_LibraryCD       .Text := '';
        CB_LibraryGenre      .Text := '';
        LblPlayCounter      .Caption := '';
        LblReplayGainTitle  .Caption := '';
        LblReplayGainAlbum  .Caption := '';
        DetailRatingHelper.DrawRatingInStarsOnBitmap(0, IMG_LibraryRating.Picture.Bitmap, IMG_LibraryRating.Width, IMG_LibraryRating.Height);
        NewLibraryCoverID := '';
        NewLibraryCoverID_FileSave := '';
  end else
  begin
        if not CurrentAudioFile.ReCheckExistence then
        begin
            Lbl_Warnings.Caption := (Warning_FileNotFound);
            Lbl_Warnings.Hint := (Warning_FileNotFound_Hint);
            PnlWarnung.Visible := True;
        end;

        LBLPfad.Caption := CurrentAudioFile.Ordner;
        LBLName.Caption := CurrentAudioFile.DateiName;
        if CurrentAudioFile.AudioType = at_Stream then
        begin
            // make the Path-Label clickable (to get to the URL)
            LBLPfad.Font.Color := clblue;
            LBLPfad.Font.Style := [fsUnderline];
            LBLPfad.OnClick    := LBLPfadClick;
            LBLPfad.PopupMenu  := PM_URLCopy;
            LBLPfad.Cursor     := crHandPoint;
            LlblConst_Path    .Caption := (DetailForm_InfoLblWebStream);
            LlblConst_Filename.Caption := (DetailForm_InfoLblDescription);
        end else
        begin
            LBLPfad.Font.Color := clWindowText;
            LBLPfad.Font.Style := [];
            LBLPfad.OnClick    := NIL;
            LBLPfad.PopupMenu  := NIL;
            LBLPfad.Cursor     := crDefault;
            LlblConst_Path    .Caption := (DetailForm_InfoLblPath);
            LlblConst_Filename.Caption := (DetailForm_InfoLblFilename);
        end;

        case CurrentAudioFile.AudioType of
            at_File: begin
                    FDetails.Caption := Format('%s (%s)', [(DetailForm_Caption), CurrentAudioFile.Dateiname]);

                    if Not FileExists(CurrentAudioFile.Pfad) then
                        FDetails.Caption := FDetails.Caption + ' ' + DetailForm_Caption_FileNotFound
                    else
                        if FileIsWriteProtected(CurrentAudioFile.Pfad) then
                            FDetails.Caption := FDetails.Caption + ' ' + DetailForm_Caption_WriteProtected ;

                    // Size, Duration, Samplerate
                    LBLSize      .Caption := Format('%4.2f MB (%d Bytes)', [CurrentAudioFile.Size / 1024 / 1024, CurrentAudioFile.Size]);
                    LblDuration  .Caption := SekToZeitString(CurrentAudioFile.Duration);
                    LBLSamplerate.Caption := NempDisplay.DetailSummarySamplerate(CurrentAudioFile);
                    // Format('%s, %s', [CurrentAudioFile.Samplerate, CurrentAudioFile.ChannelMode]);

                    // Bitrate
                    if CurrentAudioFile.vbr then
                        LBLBitrate.Caption := Format('%d kbit/s (vbr)', [CurrentAudioFile.Bitrate])
                    else
                        LBLBitrate.Caption := Format('%d kbit/s', [CurrentAudioFile.Bitrate]);

                    // Audio Format (mp3, Flac, Ogg, ...)
                    if CurrentTagObject.FileType = at_Invalid then
                        LblFormat.Caption := CurrentAudioFile.Extension
                    else
                        LblFormat.Caption := CurrentTagObject.FileTypeDescription;

                    // Additional Tags for TagCloud
                    lb_Tags.Items.Text := String(CurrentAudioFile.RawTagLastFM);


                    // Rating
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
                                            CurrentBibRating := TMp3File(CurrentTagObject).ID3v2Tag.Rating;
                                            CurrentBibCounter:= TMp3File(CurrentTagObject).ID3v2Tag.PlayCounter;
                                        end;
                                at_Ogg: begin
                                            CurrentBibRating := StrToIntDef(TOggVorbisFile(CurrentTagObject).GetPropertyByFieldname(VORBIS_RATING),0);
                                            CurrentBibCounter:= StrToIntDef(TOggVorbisFile(CurrentTagObject).GetPropertyByFieldname(VORBIS_PLAYCOUNT),0);
                                        end;
                                at_Flac: begin
                                            CurrentBibRating := StrToIntDef(TFlacFile(CurrentTagObject).GetPropertyByFieldname(VORBIS_RATING),0);
                                            CurrentBibCounter:= StrToIntDef(TFlacFile(CurrentTagObject).GetPropertyByFieldname(VORBIS_PLAYCOUNT),0);
                                         end;
                                at_Monkey,
                                at_WavPack,
                                at_MusePack,
                                at_OptimFrog,
                                at_TrueAudio: begin
                                            CurrentBibRating := StrToIntDef(TBaseApeFile(CurrentTagObject).ApeTag.GetValueByKey(APE_RATING),0);
                                            CurrentBibCounter:= StrToIntDef(TBaseApeFile(CurrentTagObject).ApeTag.GetValueByKey(APE_PLAYCOUNT),0);
                                        end;
                                at_Invalid: ;
                                at_Wma: ;
                                at_Wav: ;
                            end;
                        end;
                    end;
                    DetailRatingHelper.DrawRatingInStarsOnBitmap(CurrentBibRating, IMG_LibraryRating.Picture.Bitmap, IMG_LibraryRating.Width, IMG_LibraryRating.Height);
                    LblPlayCounter.Caption := Format(DetailForm_PlayCounter, [CurrentBibCounter]);
            end;

            at_Stream: begin
                    FDetails.Caption := Format('%s (%s)', [(DetailForm_Caption), CurrentAudioFile.Ordner]);

                    LBLSize      .Caption := '-';
                    LblDuration  .Caption := '-';
                    LBLBitrate   .Caption := inttostr(CurrentAudioFile.Bitrate) + ' kbit/s';
                    LBLSamplerate.Caption := '-';
                    LblFormat    .Caption := 'Webstream';

                    LblPlayCounter.Caption := '';
                    DetailRatingHelper.DrawRatingInStarsOnBitmap(0, IMG_LibraryRating.Picture.Bitmap, IMG_LibraryRating.Width, IMG_LibraryRating.Height);
            end;

            at_CDDA: begin
                    FDetails.Caption := Format('%s (%s)', [(DetailForm_Caption), CurrentAudioFile.Dateiname]);
                    LBLSize      .Caption := '';
                    LblDuration  .Caption  := SekToZeitString(CurrentAudioFile.Duration);
                    LBLBitrate   .Caption := '1.4 mbit/s (CD-Audio)';
                    LBLSamplerate.Caption := '44.1 kHz, Stereo';
                    LblFormat    .Caption := 'Compact Disc Digital Audio';

                    LblPlayCounter.Caption := '';
                    DetailRatingHelper.DrawRatingInStarsOnBitmap(0, IMG_LibraryRating.Picture.Bitmap, IMG_LibraryRating.Width, IMG_LibraryRating.Height);
            end;
        end;

        // Fill Edits with properties of the AudioFile
        if CurrentAudioFile.IsFile then
        begin
            Edit_LibraryArtist   .Text := CurrentAudioFile.Artist ;
            Edit_LibraryTitle    .Text := CurrentAudioFile.Titel ;
            Edit_LibraryAlbum    .Text := CurrentAudioFile.Album ;
            Edit_LibraryYear     .Text := CurrentAudioFile.Year ;
            Edit_LibraryComment  .Text := CurrentAudioFile.Comment ;
            Edit_LibraryTrack    .Text := IntToStr(CurrentAudioFile.Track);
            Edit_LibraryCD       .Text := CurrentAudioFile.CD ;
            // Genre
            CB_LibraryGenre      .Text := CurrentAudioFile.Genre;
            // Rating and PlayCounter
            DetailRatingHelper.DrawRatingInStarsOnBitmap(CurrentBibRating, IMG_LibraryRating.Picture.Bitmap, IMG_LibraryRating.Width, IMG_LibraryRating.Height);
            LblPlayCounter.Caption := Format(DetailForm_PlayCounter, [CurrentBibCounter]);

            // replayGain Values
            if currentAudioFile.TrackGain = 0 then
                LblReplayGainTitle  .Caption := 'N/A'
            else
                LblReplayGainTitle  .Caption :=
                    Format((rsFormatReplayGainTrack_WithPeak), [currentAudioFile.TrackGain, currentAudioFile.TrackPeak]);

            if currentAudioFile.AlbumGain = 0 then
                LblReplayGainAlbum  .Caption := 'N/A'
            else
                LblReplayGainAlbum  .Caption :=
                    Format((rsFormatReplayGainAlbum_WithPeak), [currentAudioFile.AlbumGain, currentAudioFile.AlbumPeak]);
        end else
        begin
            Edit_LibraryArtist   .Text := '';
            Edit_LibraryTitle    .Text := '';
            Edit_LibraryAlbum    .Text := '';
            Edit_LibraryYear     .Text := '';
            Edit_LibraryComment  .Text := '';
            Edit_LibraryTrack    .Text := '';
            Edit_LibraryCD       .Text := '';
            // Genre
            CB_LibraryGenre      .Text := '';
            // Rating and PlayCounter
            LblPlayCounter.Caption := '';
            LblReplayGainTitle  .Caption := 'N/A';
            LblReplayGainAlbum  .Caption := 'N/A';
            DetailRatingHelper.DrawRatingInStarsOnBitmap(0, IMG_LibraryRating.Picture.Bitmap, IMG_LibraryRating.Width, IMG_LibraryRating.Height);
        end;
        LibraryPropertyChanged := False;
        TagCloudTagsChanged    := False;

        LoadLibraryCoverIntoImage(CoverLibrary1);
        LoadLibraryCoverIntoImage(CoverLibrary2);

        NewLibraryCoverID := CurrentAudioFile.CoverID;
        NewLibraryCoverID_FileSave := CurrentAudioFile.CoverID;
  end;
end;


{
    --------------------------------------------------------
    RatingImageMouseMove
    RatingImageMouseDown
    RatingImageMouseLeave
    BtnResetRatingClick
    - Edit the rating of the current audiofile
    --------------------------------------------------------
}
procedure TFDetails.IMG_LibraryRatingMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var rat: Integer;
begin
    if (Sender as TImage).Enabled then
    begin
        rat := DetailRatingHelper.MousePosToRating(x, 70);//((x div 8)) * 8;
        DetailRatingHelper.DrawRatingInStarsOnBitmap(rat, IMG_LibraryRating.Picture.Bitmap, IMG_LibraryRating.Width, IMG_LibraryRating.Height);
    end;
end;

procedure TFDetails.IMG_LibraryRatingMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    CurrentTagRating := DetailRatingHelper.MousePosToRating(x, 70);
    CurrentTagCounter := CurrentBibCounter;
    CurrentTagRatingChanged := True;
    // also set the CurrentBibRating to the new Value
    // CurrentBibRating := CurrentTagRating; // no, this is done in "Apply"
    // draw the new rating
    DetailRatingHelper.DrawRatingInStarsOnBitmap(CurrentTagRating, IMG_LibraryRating.Picture.Bitmap, IMG_LibraryRating.Width, IMG_LibraryRating.Height);
end;
procedure TFDetails.IMG_LibraryRatingMouseLeave(Sender: TObject);
begin
    if IMG_LibraryRating.Enabled then
        DetailRatingHelper.DrawRatingInStarsOnBitmap(CurrentTagRating, (Sender as TImage).Picture.Bitmap, (Sender as TImage).Width, (Sender as TImage).Height);
end;

procedure TFDetails.BtnResetRatingClick(Sender: TObject);
begin
    if CurrentBibCounter > 20 then
    begin
         if TranslateMessageDLG(Format(DetailForm_HighPlayCounter,[CurrentBibCounter]), mtConfirmation, [MBOk, MBCancel], 0, mbCancel)
            = mrCancel then EXIT;
    end;

    CurrentTagRating := 0;
    CurrentTagCounter := 0;
    CurrentTagRatingChanged := True;
    // also reset the CurrentBibRating/Counter
    CurrentBibRating  := 0;
    CurrentBibCounter := 0;

    // Update GUI, display the nulled values
    DetailRatingHelper.DrawRatingInStarsOnBitmap(CurrentTagRating, IMG_LibraryRating.Picture.Bitmap, IMG_LibraryRating.Width, IMG_LibraryRating.Height);
    LblPlayCounter.Caption := Format(DetailForm_PlayCounter, [CurrentTagCounter]);
    BtnSynchRatingLibrary.Visible := False;
end;

procedure TFDetails.BtnSynchRatingLibraryClick(Sender: TObject);
begin
    // set the current "Tag values" to the ones stored in the MediaLibrary
    CurrentTagRating  := CurrentBibRating;
    CurrentTagCounter := CurrentBibCounter;
    CurrentTagRatingChanged := True;

    // Update GUI
    DetailRatingHelper.DrawRatingInStarsOnBitmap(CurrentTagRating, IMG_LibraryRating.Picture.Bitmap, IMG_LibraryRating.Width, IMG_LibraryRating.Height);
    LblPlayCounter.Caption := Format(DetailForm_PlayCounter, [CurrentTagCounter]);
end;

procedure TFDetails.EditLibraryChange(Sender: TObject);
begin
    LibraryPropertyChanged := True;
end;

procedure TFDetails.Edit_LibraryTrackChange(Sender: TObject);
begin
  if NOT Edit_LibraryArtist.ReadOnly then
  begin
    if (Sender as TEdit).Modified then
    begin
      if IsValidV2TrackString(Edit_LibraryTrack.Text) then
        Edit_LibraryTrack.Font.Color := clWindowText
      else
        Edit_LibraryTrack.Font.Color := clred;
    end;
    LibraryPropertyChanged := True;
  end;
end;
procedure TFDetails.Edit_LibraryYearChange(Sender: TObject);
begin
  if NOT Edit_LibraryArtist.ReadOnly then
  begin
    if (Sender as TEdit).Modified then
    begin
      if IsValidYearString(Edit_LibraryYear.Text)
      then
        Edit_LibraryYear.Font.Color := clWindowText
      else
        Edit_LibraryYear.Font.Color := clRed;
    end;
    LibraryPropertyChanged := True;
  end;
end;

{$ENDREGION}


{$REGION 'Display and editing of Metadata on FrameLevel, through VirtualStringTree'}


function ID3v2FrameAsString(aFrame: TID3v2Frame): String;
var aFrameDescription, tmp: String;
    aLang, aEmail, dataString: AnsiString;
    aRating: Byte;
    Data: TMemoryStream;
    i: Integer;
begin

    case aFrame.FrameType of
      FT_INVALID       : result := '';
      FT_UNKNOWN       : begin
            if aFrame.DataSize > 200 then
                // too much data, just show a summary
                result := Format('<Binary Data>, %d Bytes', [aFrame.DataSize])
            else
            begin
                // visualize the Frame as a String
                Data := TMemoryStream.Create;
                try
                    aFrame.GetData(Data);
                    setlength(dataString, Data.Size);
                    Data.Position := 0;
                    Data.Read(dataString[1], length(dataString));
                    for i := 1 to length(dataString) do
                        if ord(dataString[i]) < 32 then
                            dataString[i] := '.';
                    result := String(dataString);
                finally
                    Data.Free;
                end;
            end;
      end;

      FT_TextFrame     : result := aFrame.GetText;
      FT_CommentFrame  : result := aFrame.GetCommentsLyrics(aLang, aFrameDescription);
      FT_LyricFrame    : result := aFrame.GetCommentsLyrics(aLang, aFrameDescription);
      FT_UserDefinedURLFrame : begin
          tmp := aFrame.GetCommentsLyrics(aLang, aFrameDescription);
          result := Format('%s: %s', [aFrameDescription, tmp]);
      end;

      FT_PictureFrame        : result := Format('<Binary Data>, %d Bytes', [aFrame.DataSize]);

      FT_PopularimeterFrame  : begin
            aRating := aFrame.GetRating(aEmail);
            result := Format('%d, %s', [aRating, aEmail]);
      end;
      FT_URLFrame            : result := String(aFrame.GetURL);
      FT_UserTextFrame       : begin
            tmp := aFrame.GetUserText(aFrameDescription);
            result := Format('%s: %s', [aFrameDescription, tmp]);
      end;
    end;
end;



procedure TFDetails.VST_MetaDataEditing(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; var Allowed: Boolean);
begin
    Allowed := (Column = 3) AND (VST_MetaData.GetNodeData<TTagEditItem>(Node).Editable);
end;

procedure TFDetails.VST_MetaDataNewText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; NewText: string);
var aTagEditItem: TTagEditItem;
    aFrame: TID3v2Frame;
    aLang, dummyA: AnsiString;
    dummy, aDesc: String;
    aAtom: TMetaAtom;
begin

    aTagEditItem := VST_MetaData.GetNodeData<TTagEditItem>(Node);
    aTagEditItem.fValue := NewText;
    aTagEditItem.fNiledByUser := NewText = '';

    MetaFramesHasChanged := True;

    case aTagEditItem.TagType of
        TT_ID3v2: begin
            // we have different FrameTypes here
            aFrame := VST_MetaData.GetNodeData<TTagEditItem>(Node).ID3v2Frame;
            case aFrame.FrameType of
                FT_TextFrame: begin
                    // this is simple, just a new string :)
                    aFrame.SetText(NewText);
                end;

                FT_CommentFrame: begin
                    // get the current "Meta-stuff" from this comment Frame
                    dummy := aFrame.GetCommentsLyrics(aLang, aDesc);
                    // set the new comment, leave other content as it is
                    aFrame.SetCommentsLyrics(aLang, aDesc, NewText);
                end;

                FT_UserDefinedURLFrame : begin
                    // get the current "Meta-stuff" from this URL Frame
                    dummyA := aFrame.GetUserdefinedURL(aDesc);
                    // set the new URL, leave other content as it is
                    aFrame.SetUserdefinedURL(aDesc, AnsiString(NewText));
                end;

                FT_URLFrame: begin
                    // there may be several such URL-Frames in the ID3v2-Tag,
                    // but settng a new value is easy.
                    aFrame.SetURL(AnsiString(NewText));
                end;
            end;

        end;
        TT_OggVorbis: begin
            TOggVorbisFile(CurrentTagObject).SetPropertyByFieldname(
                VST_MetaData.GetNodeData<TTagEditItem>(Node).KeyDescription,
                NewText);
        end;

        TT_Flac: begin
            TFlacFile(CurrentTagObject).SetPropertyByFieldname(
                VST_MetaData.GetNodeData<TTagEditItem>(Node).KeyDescription,
                NewText);
        end;

        TT_Ape: begin
            case currenttagObject.FileType of
              at_Invalid: ;
              at_Mp3: TMp3File(CurrentTagObject).ApeTag.SetValueByKey(
                    AnsiString(VST_MetaData.GetNodeData<TTagEditItem>(Node).KeyDescription),
                    NewText);
              at_Ogg: ;
              at_Flac: ;
              at_M4A: ;
              at_Monkey,
              at_WavPack,
              at_MusePack,
              at_OptimFrog,
              at_TrueAudio: TBaseApeFile(CurrentTagObject).ApeTag.SetValueByKey(
                    AnsiString(VST_MetaData.GetNodeData<TTagEditItem>(Node).KeyDescription),
                    NewText);
              at_Wma: ;
              at_Wav: ;
              at_AbstractApe: ;
            end;

        end;

        TT_M4A: begin
            aAtom := VST_MetaData.GetNodeData<TTagEditItem>(Node).MetaAtom;

            if (aAtom.Name = 'trkn') or (aAtom.Name = 'disk') then
                // Note: "Track" and "Disk" have the same format, so we can just
                // do it that way ... both Methods "set***Number" will call "prepareDiskTrackAtom" anyway
                aAtom.setTrackNumber(newText)
            else
                aAtom.SetTextData(NewText);
        end;
    end;
end;

procedure TFDetails.VST_MetaDataNodeDblClick(Sender: TBaseVirtualTree;
  const HitInfo: THitInfo);
begin
    // TODO :: URL aufrufen, falls es ein URL-Frame eist?
end;

procedure TFDetails.Btn_NewMetaFrameClick(Sender: TObject);
begin
    if not assigned(NewMetaFrameForm) then
        Application.CreateForm(TNewMetaFrameForm, NewMetaFrameForm);

    if CurrentTagObject.FileType = at_Mp3 then
    begin
        if cbFrameTypeSelection.Visible and (cbFrameTypeSelection.ItemIndex = 1) then
            NewMetaFrameForm.TagType := TT_APE
        else
            NewMetaFrameForm.TagType := TT_ID3v2
    end else
        NewMetaFrameForm.TagType := self.MetaTagType;

    NewMetaFrameForm.CurrentTagObject := self.CurrentTagObject;

    if NewMetaFrameForm.PrepareFrameSelection = 0 then
        // no additional Frames are allowed, all are set.
        TranslateMessageDLG((DetailForm_NoNewFramesPossible), mtInformation, [MBOk], 0)
    else
    begin
        // Show "new-Frame"-input and show new frameset
        if NewMetaFrameForm.ShowModal = MrOK then
        begin
            ShowMetaDataFrames;
            MetaFramesHasChanged := True;
        end;
    end;
end;

procedure TFDetails.VST_MetaDataFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
    VST_MetaData.GetNodeData<TTagEditItem>(Node).Free;
end;

procedure TFDetails.VST_MetaDataGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
begin
    case Column of
        0: Celltext := TagTypeDescriptions[VST_MetaData.GetNodeData<TTagEditItem>(Node).TagType];
        1: CellText := VST_MetaData.GetNodeData<TTagEditItem>(Node).Key;
        2: CellText := VST_MetaData.GetNodeData<TTagEditItem>(Node).KeyDescription;
        3: CellText := VST_MetaData.GetNodeData<TTagEditItem>(Node).Value;
    end;
end;


procedure TFDetails.VST_MetaDataPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
    if VST_MetaData.GetNodeData<TTagEditItem>(Node).Editable then
        TargetCanvas.Font.Color := TStyleManager.ActiveStyle.GetSystemColor(clWindowText)
    else
        TargetCanvas.Font.Color := TStyleManager.ActiveStyle.GetSystemColor(clGrayText);

end;

procedure TFDetails.ShowMetaDataFrames;
var mp3File: TMP3File;
    oggFile: TOggVorbisFile;
    flacFile: TFlacFile;
    apeFile: TBaseApeFile;
    m4aFile: TM4aFile;
    FrameList: TObjectlist;
    i: Integer;
    NewTagEditItem: TTagEditItem;
    aFrame: TID3v2Frame;
    aAtom: TMetaAtom;
    CommentList: TStringList;

    procedure FillApeFrames(aApetag: TApetag);
    var j: Integer;
    begin
        CommentList := TStringList.Create;
        try
            aApeTag.GetAllFrames(CommentList);
            for j := 0 to CommentList.Count - 1 do
            begin
                NewTagEditItem := TTagEditItem.Create; //

                NewTagEditItem.TagType := TT_APE;
                NewTagEditItem.Key     := '';
                NewTagEditItem.KeyDescription := CommentList[j];
                NewTagEditItem.Value   := aApeTag.GetValueByKey(AnsiString(CommentList[j]));
                NewTagEditItem.ID3v2Frame := NIL;
                NewTagEditItem.MetaAtom   := Nil;
                NewTagEditItem.InitEditability;

                VST_MetaData.AddChild(Nil, NewTagEditItem);
            end;
        finally
            CommentList.Free;
        end;
    end;

begin
    VST_MetaData.Clear;

    if not assigned(CurrentAudioFile) then
        exit;
    if not assigned(CurrentTagObject) then
        exit;
    if not FileExists(CurrentAudioFile.Pfad) then
        exit;

    // show the ID3v1-Box only for MP3-Files
    Pnl_ID3v1_MPEG.Visible := CurrentTagObject.FileType in [at_Mp3, at_Monkey, at_WavPack, at_MusePack, at_OptimFrog, at_TrueAudio];
    GrpBox_Mpeg.Visible := (CurrentTagObject.FileType = at_Mp3);

    // FrameTypeSelection only for mp3Files, and only if there is already an APEv2Tag
    // if not: Nemp should not try to push Ape-Tags into mp3Files. It's not standard.
    cbFrameTypeSelection.Visible := (CurrentTagObject.FileType = at_Mp3)
                          AND (TMp3File(CurrentTagObject).ApeTag.ContainsData);

    case CurrentTagObject.FileType of
          at_Mp3: begin
                      mp3File := TMp3File(CurrentTagObject);
                      MetaTagType := TT_ID3v2;

                      if mp3File.ApeTag.Exists then
                        GrpBox_TextFrames.Caption := Format('ID3v2-Tag (Version 2.%d.%d), APE-Tag (Version %d.000)', [mp3File.id3v2Tag.Version.Major, mp3File.id3v2Tag.Version.Minor, mp3File.ApeTag.Version])
                      else
                        GrpBox_TextFrames.Caption := Format('ID3v2-Tag (Version 2.%d.%d)', [mp3File.id3v2Tag.Version.Major, mp3File.id3v2Tag.Version.Minor]);

                      mp3File.ID3v1Tag.AutoCorrectCodepage := NempCharCodeOptions.AutoDetectCodePage;
                      mp3File.ID3v2Tag.AutoCorrectCodepage := NempCharCodeOptions.AutoDetectCodePage;

                      ShowID3v1Details(mp3File.ID3v1Tag);

                      if CurrentTagObject.Valid then
                      begin
                          FrameList := TObjectList.Create(False);
                          try
                            MP3File.ID3v2Tag.GetAllFrames(FrameList);
                            for i := 0 to FrameList.Count - 1 do
                            begin
                                aFrame := (FrameList[i] as TID3v2Frame);
                                NewTagEditItem := TTagEditItem.Create; //
                                NewTagEditItem.TagType := TT_ID3v2;
                                NewTagEditItem.Key     := String(aFrame.FrameIDString);
                                NewTagEditItem.Value   := ID3v2FrameAsString(aFrame);
                                NewTagEditItem.ID3v2Frame := aFrame;
                                NewTagEditItem.MetaAtom   := Nil;
                                NewTagEditItem.KeyDescription := aFrame.FrameTypeDescription;
                                NewTagEditItem.InitEditability;

                                VST_MetaData.AddChild(Nil, NewTagEditItem);
                            end;
                          finally
                              FrameList.Free;
                          end;

                          //if Mp3File.ApeTag.Exists then
                          FillApeFrames(Mp3File.ApeTag);

                      end else
                      begin
                          Lbl_Warnings.Caption := (Warning_InvalidMp3file);
                          Lbl_Warnings.Hint    := (Warning_InvalidMp3file_Hint);
                          PnlWarnung.Visible   := True;
                      end;

                      if NempCharCodeOptions.  AutoDetectCodePage then
                      begin
                          mp3File.ID3v1Tag.CharCode := GetCodepage(CurrentAudioFile.Pfad, NempCharCodeOptions);
                          mp3File.ID3v2Tag.CharCode := mp3File.ID3v1Tag.CharCode;
                      end; //else: keep default values, nothing to do
                      mp3File.ID3v1Tag.AutoCorrectCodepage := NempCharCodeOptions.AutoDetectCodePage;
                      mp3File.ID3v2Tag.AutoCorrectCodepage := NempCharCodeOptions.AutoDetectCodePage;
                  end;
          at_Ogg: begin
                      oggFile := TOggVorbisFile(CurrentTagObject);
                      MetaTagType := TT_OggVorbis;
                      GrpBox_TextFrames.Caption := 'Vorbis-Comments';

                      if CurrentTagObject.Valid then
                      begin
                          CommentList := TStringList.Create;
                          try
                              oggFile.GetAllFields(CommentList);
                              for i := 0 to CommentList.Count - 1 do
                              begin
                                  NewTagEditItem := TTagEditItem.Create; //

                                  NewTagEditItem.TagType := TT_OggVorbis;
                                  NewTagEditItem.Key     := '';
                                  NewTagEditItem.KeyDescription := CommentList[i];
                                  NewTagEditItem.Value   := oggFile.GetPropertyByIndex(i);
                                  NewTagEditItem.ID3v2Frame := NIL;
                                  NewTagEditItem.MetaAtom   := Nil;
                                  NewTagEditItem.InitEditability;

                                  VST_MetaData.AddChild(Nil, NewTagEditItem);
                              end;

                          finally
                              CommentList.Free;
                          end;

                      end;
                  end;
          at_Flac: begin
                        flacFile := TFlacFile(CurrentTagObject);
                        MetaTagType := TT_Flac;
                        GrpBox_TextFrames.Caption := 'Vorbis-Comments';

                        if CurrentTagObject.Valid then
                        begin
                            CommentList := TStringList.Create;
                            try
                                flacFile.GetAllFields(CommentList);
                                for i := 0 to CommentList.Count - 1 do
                                begin
                                    NewTagEditItem := TTagEditItem.Create; //

                                    NewTagEditItem.TagType := TT_Flac;
                                    NewTagEditItem.Key     := '';
                                    NewTagEditItem.KeyDescription := CommentList[i];
                                    NewTagEditItem.Value   := flacFile.GetPropertyByIndex(i);
                                    NewTagEditItem.ID3v2Frame := NIL;
                                    NewTagEditItem.MetaAtom   := Nil;
                                    NewTagEditItem.InitEditability;

                                    VST_MetaData.AddChild(Nil, NewTagEditItem);
                                end;

                            finally
                                CommentList.Free;
                            end;
                        end;
                    end;
          at_M4a: begin
                        m4aFile := TM4aFile(CurrentTagObject);
                        MetaTagType := TT_M4A;
                        GrpBox_TextFrames.Caption := 'iTunes-Tags';

                        if CurrentTagObject.Valid then
                        begin
                            FrameList := TObjectList.Create(False);
                            try
                                m4aFile.GetAllAtoms(FrameList);
                                for i := 0 to FrameList.Count - 1 do
                                begin
                                    NewTagEditItem := TTagEditItem.Create; //
                                    aAtom := TMetaAtom(FrameList[i]);

                                    NewTagEditItem.TagType := TT_M4A;
                                    NewTagEditItem.Key     :=  String(aAtom.Name);
                                    NewTagEditItem.KeyDescription :=  aAtom.GetListDescription;
                                    if aAtom.ContainsTextData then
                                        NewTagEditItem.Value   := aAtom.GetTextData
                                    else
                                        if aAtom.Name = 'trkn' then
                                            NewTagEditItem.Value := aAtom.GetTrackNumber
                                        else
                                            if aAtom.Name = 'disk' then
                                                NewTagEditItem.Value := aAtom.GetDiscNumber
                                            else
                                                if aAtom.Name = 'covr' then
                                                    NewTagEditItem.Value := Format('<Picture>, %d Bytes', [aAtom.Size])
                                                else
                                                    NewTagEditItem.Value := ''; //'<Binary Data>';

                                    NewTagEditItem.ID3v2Frame := NIL;
                                    NewTagEditItem.MetaAtom   := aAtom;
                                    NewTagEditItem.InitEditability;

                                    VST_MetaData.AddChild(Nil, NewTagEditItem);
                                end;
                            finally
                                FrameList.Free;
                            end;
                        end;
                  end;
          at_Monkey,
          at_WavPack,
          at_MusePack,
          at_OptimFrog,
          at_TrueAudio: begin
                        apeFile := TBaseApeFile(CurrentTagObject);
                        MetaTagType := TT_APE;
                        GrpBox_TextFrames.Caption := 'APEv2-Tags';

                        ShowID3v1Details(apeFile.ID3v1Tag);
                        if CurrentTagObject.Valid then
                            FillApeFrames(apeFile.ApeTag);
                    end;

          at_Invalid,
          at_Wma,
          at_Wav: ; // nothing to do
      end;


      VST_MetaData.SortTree(0, sdAscending);

      ID3v1HasChanged := False;
      MetaFramesHasChanged := False;

      BtnCopyFromV1.Visible := CurrentTagObject.FileType in [at_Mp3, at_Monkey, at_WavPack, at_MusePack, at_OptimFrog, at_TrueAudio];
      case CurrentTagObject.FileType of
        at_Mp3: begin
            BtnCopyFromV1.Enabled := TMp3File(CurrentTagObject).ID3v1Tag.TagExists;
            BtnCopyFromV2.Caption := DetailForm_CopyFromID3v2;
        end;

        at_Monkey,
        at_WavPack,
        at_MusePack,
        at_OptimFrog,
        at_TrueAudio: begin
          BtnCopyFromV1.Enabled := TBaseApeFile(CurrentTagObject).ID3v1Tag.TagExists;
          BtnCopyFromV2.Caption := DetailForm_CopyFromAPE;
        end;

      end;
end;

procedure TFDetails.VST_MetaDataCompareNodes(Sender: TBaseVirtualTree; Node1,
  Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var idx1, idx2: Integer;
    aTagItem1, aTagItem2: TTagEditItem;
begin

    result := 0;
    idx1 := 0;
    idx2 := 0;
    case Column of
        0: begin
            aTagItem1 := VST_MetaData.GetNodeData<TTagEditItem>(Node1);
            aTagItem2 := VST_MetaData.GetNodeData<TTagEditItem>(Node2);

            case atagItem1.TagType of
                TT_ID3v2: begin
                        if length(aTagItem1.Key) = 3 then
                        begin
                            idx1 := SL_ID3_22.IndexOf(aTagItem1.Key);
                            idx2 := SL_ID3_22.IndexOf(aTagItem2.Key);
                        end else
                        begin
                            idx1 := SL_ID3_23.IndexOf(aTagItem1.Key);
                            idx2 := SL_ID3_23.IndexOf(aTagItem2.Key);
                        end;
                end;
                TT_OggVorbis, TT_Flac: begin
                        idx1 := SL_OGG.IndexOf(aTagItem1.KeyDescription);
                        idx2 := SL_OGG.IndexOf(aTagItem2.KeyDescription);
                end;
                TT_Ape: begin
                        idx1 := SL_APE.IndexOf(aTagItem1.KeyDescription);
                        idx2 := SL_APE.IndexOf(aTagItem2.KeyDescription);
                end;
                TT_M4A:  begin
                        idx1 := SL_M4A.IndexOf(aTagItem1.Key);
                        idx2 := SL_M4A.IndexOf(aTagItem2.Key);
                end;
            end;

            // correct index "-1" (not existing) to "put it somewhere at the end"
            if idx1 = -1 then idx1 := 5000;
            if idx2 = -1 then idx2 := 5000;

            result := CompareValue(idx1, idx2);
        end
    else
        Result := 0;
    end;

end;
{$ENDREGION}


{$REGION 'Special Handling of ID3v1-Tags and MPEG-Details for mp3-Files'}
{
    --------------------------------------------------------
    BtnCopyFromV1Click
    BtnCopyFromV2Click
    - some eventhandler for ID3 stuff
    --------------------------------------------------------
}

procedure TFDetails.FillTagWithID3v1Values(Dest: TID3v2Tag);
begin
    Dest.Title   := Lblv1Titel.Text   ;
    Dest.Artist  := Lblv1Artist.Text  ;
    Dest.Album   := Lblv1Album.Text   ;
    Dest.Comment := Lblv1Comment.Text ;
    Dest.Year    := Lblv1Year.Text    ;
    Dest.Track   := Lblv1Track.Text   ;
    // special case genre: do not copy it always to prevent data loss
    if Dest.Genre = '' then
      // Genre is NOT set in ID3v2: use value from v1
      Dest.Genre := cbIDv1Genres.Text
    else
    begin
        // If genre IS set in ID3v2, and it is a "standard" genre: Overwrite it
        if ID3Genres.IndexOf(Dest.Genre) >= 0 then
          Dest.Genre := cbIDv1Genres.Text;
        // if v2-Genre is a "unknown" genre (index = -1): do NOT use value from v1
    end;
end;
procedure TFDetails.FillTagWithID3v1Values(Dest: TApeTag);
begin
    Dest.Title   := Lblv1Titel.Text   ;
    Dest.Artist  := Lblv1Artist.Text  ;
    Dest.Album   := Lblv1Album.Text   ;
    Dest.Comment := Lblv1Comment.Text ;
    Dest.Year    := Lblv1Year.Text    ;
    Dest.Track   := Lblv1Track.Text   ;
    // special case genre: do not copy it always to prevent data loss
    if Dest.Genre = '' then
      // Genre is NOT set in ApeTag: use value from v1
      Dest.Genre := cbIDv1Genres.Text
    else
    begin
        // If genre IS set in ApeTag, and it is a "standard" genre: Overwrite it
        if ID3Genres.IndexOf(Dest.Genre) >= 0 then
          Dest.Genre := cbIDv1Genres.Text;
        // if v2-Genre is a "unknown" genre (index = -1): do NOT use value from v1
    end;
end;


procedure TFDetails.BtnCopyFromV1Click(Sender: TObject);
var success: Boolean;
begin
    if (not CurrentTagObject.Valid) then
        exit;

    case CurrentTagObject.FileType of
        at_Mp3: begin
            success := True;
            FillTagWithID3v1Values(TMp3File(CurrentTagObject).ID3v2Tag);
            if TMp3File(CurrentTagObject).ApeTag.ContainsData then
                FillTagWithID3v1Values(TMp3File(CurrentTagObject).ApeTag);
        end;

        at_Monkey,
        at_WavPack,
        at_MusePack,
        at_OptimFrog,
        at_TrueAudio: begin
            success := True;
            FillTagWithID3v1Values(TBaseApeFile(CurrentTagObject).ApeTag);
        end;
    else
        success := False;
    end;
    if success then
    begin
        // add/edit the List of MetaFrames
        ShowMetaDataFrames;
        MetaFramesHasChanged := True;
    end;
end;

procedure TFDetails.Fillv1TagWithTagValues(Source: TID3v2Tag; Dest: TID3v1Tag);
var idx: Integer;
begin
    // Apply values to the TagObject
    Dest.Title   :=  Source.Title   ;
    Dest.Artist  :=  Source.Artist  ;
    Dest.Album   :=  Source.Album   ;
    Dest.Comment :=  Source.Comment ;
    Dest.Genre   :=  Source.Genre   ;
    Dest.Track   :=  Source.Track   ;
    Dest.Year    :=  AnsiString(Source.Year) ;
    // Change the Edits
    Lblv1Titel.Text   :=  Source.Title   ;
    Lblv1Artist.Text  :=  Source.Artist  ;
    Lblv1Album.Text   :=  Source.Album   ;
    Lblv1Comment.Text :=  Source.Comment ;
    Lblv1Year.Text    :=  Source.Year    ;
    Lblv1Track.Text   :=  Source.Track   ;

    idx := cbIDv1Genres.Items.IndexOf(Dest.Genre);
    if idx >= 0 then
        cbIDv1Genres.ItemIndex := idx
    else
        cbIDv1Genres.ItemIndex := 0;

    ID3v1HasChanged := True;
end;
procedure TFDetails.Fillv1TagWithTagValues(Source: TApeTag; Dest: TID3v1Tag);
begin
    // Apply values to the TagObject
    Dest.Title   :=  Source.Title   ;
    Dest.Artist  :=  Source.Artist  ;
    Dest.Album   :=  Source.Album   ;
    Dest.Comment :=  Source.Comment ;
    Dest.Genre   :=  Source.Genre   ;
    Dest.Track   :=  Source.Track   ;
    Dest.Year    :=  AnsiString(Source.Year) ;
    // Change the Edits
    Lblv1Titel.Text   :=  Source.Title   ;
    Lblv1Artist.Text  :=  Source.Artist  ;
    Lblv1Album.Text   :=  Source.Album   ;
    Lblv1Comment.Text :=  Source.Comment ;
    Lblv1Year.Text    :=  Source.Year    ;
    Lblv1Track.Text   :=  Source.Track   ;
    cbIDv1Genres.Text :=  Source.Genre   ;
    ID3v1HasChanged := True;
end;

procedure TFDetails.BtnCopyFromV2Click(Sender: TObject);
var mp3: TMp3File;
    ApeFile: TBaseApeFile;
begin
    if (not CurrentTagObject.Valid) then
        exit;

    case CurrentTagObject.FileType of
        at_Mp3: begin
            mp3 := TMp3File(CurrentTagObject);
            Fillv1TagWithTagValues(mp3.ID3v2Tag, mp3.ID3v1Tag);
        end;
        at_Monkey,
        at_WavPack,
        at_MusePack,
        at_OptimFrog,
        at_TrueAudio: begin
            ApeFile := TBaseApeFile(CurrentTagObject);
            Fillv1TagWithTagValues(ApeFile.ApeTag, ApeFile.ID3v1Tag);
        end;
    end;
end;
{
    --------------------------------------------------------
    Lblv1TrackChange
    Lblv1YearChange
    - Live-Checking for valid inputs
    --------------------------------------------------------
}
function TFDetails.GetID3v1TagfromBaseAudioFile(aBaseAudioFile: TBaseAudioFile): TID3v1Tag;
begin
  case aBaseAudioFile.FileType of
    at_Mp3: result := TMP3File(aBaseAudioFile).ID3v1Tag;
    at_Monkey,
    at_WavPack,
    at_MusePack,
    at_OptimFrog,
    at_TrueAudio: result := TBaseApeFile(aBaseAudioFile).ID3v1Tag;
  else
    result := Nil;
  end;
end;

procedure TFDetails.Lblv1Change(Sender: TObject);
var ID3v1Tag: TID3v1Tag;
begin
    if not CurrentTagObject.Valid then
        exit;

    ID3v1Tag := GetID3v1TagfromBaseAudioFile(CurrentTagObject);
    if assigned(ID3v1Tag) then
    begin
        ID3v1HasChanged := True;
        // Apply the values
        case (Sender as TWinControl).Tag of
            1: Id3v1Tag.Artist  := Lblv1Artist.Text  ;
            2: Id3v1Tag.Title   := Lblv1Titel.Text   ;
            3: Id3v1Tag.Album   := Lblv1Album.Text   ;
            4: Id3v1Tag.Comment := Lblv1Comment.Text ;
            5: Id3v1Tag.Track   := Lblv1Track.Text   ;
            //6: Id3v1Tag.Genre   := cbIDv1Genres.Text ;
            7: Id3v1Tag.Year    := AnsiString(Lblv1Year.Text);
        end;
    end;
end;

procedure TFDetails.cbIDv1GenresChange(Sender: TObject);
var ID3v1Tag: TID3v1Tag;
begin
    if not CurrentTagObject.Valid then
        exit;
    ID3v1Tag := GetID3v1TagfromBaseAudioFile(CurrentTagObject);
    if assigned(ID3v1Tag) then
      Id3v1Tag.Genre := cbIDv1Genres.Text ;
end;

procedure TFDetails.Lblv1TrackChange(Sender: TObject);
var ID3v1Tag: TID3v1Tag;
begin
  if NOT Lblv1Artist.ReadOnly then
  begin
    if (Sender as TEdit).Modified then
    begin
      if IsValidV1TrackString(Lblv1Track.Text) then
        Lblv1Track.Font.Color := clWindowText
      else
        Lblv1Track.Font.Color := clred;

      ID3v1Tag := GetID3v1TagfromBaseAudioFile(CurrentTagObject);
      if assigned(ID3v1Tag) then
        Id3v1Tag.Track := Lblv1Track.Text;
    end;
    ID3v1HasChanged := True;
  end;
end;

procedure TFDetails.Lblv1YearChange(Sender: TObject);
var ID3v1Tag: TID3v1Tag;
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

      ID3v1Tag := GetID3v1TagfromBaseAudioFile(CurrentTagObject);
      if assigned(ID3v1Tag) then
        Id3v1Tag.Year := AnsiString(Lblv1Year.Text);
    end;
    ID3v1HasChanged := True;
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
procedure TFDetails.ShowID3v1Details(ID3v1Tag: TID3v1Tag);
begin
    if ID3v1Tag.exists and CurrentTagObject.Valid then // then
    begin
        Lblv1Artist.Text := ID3v1Tag.Artist;
        Lblv1Album.Text  := ID3v1Tag.Album;
        Lblv1Titel.Text  := ID3v1Tag.Title;
        Lblv1Year.Text   := UnicodeString(ID3v1Tag.year);
        // hier den Itemindex nehmen - id3v1Genre kann nicht beliebig sein
        cbIDv1Genres.ItemIndex := cbIDv1Genres.Items.IndexOf(ID3v1Tag.genre);
        Lblv1Comment.Text := ID3v1Tag.Comment;
        Lblv1Track.Text   := ID3v1Tag.Track;
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
        Lblv1Track.Text := '';
        Lblv1Track.Font.Color := clWindowText;
        Lblv1Year.Font.Color := clWindowText;
    end;
end;

{$ENDREGION}



procedure TFDetails.Btn_RefreshClick(Sender: TObject);
var ListOfFiles: TAudioFileList;
    listFile: TAudioFile;
    i: Integer;
begin
    if assigned(CurrentAudioFile)
        and (MedienBib.StatusBibUpdate <= 1)
        and (MedienBib.CurrentThreadFilename <> CurrentAudioFile.Pfad)
    then
    begin
        NempPlayer.CoverArtSearcher.StartNewSearch;

        case CurrentAudioFile.AudioType of

            at_File: begin
                SynchAFileWithDisc(CurrentAudioFile, True);

                // Generate a List of Files which should be updated now
                ListOfFiles := TAudioFileList.Create(False);
                try
                    GetListOfAudioFileCopies(CurrentAudioFile, ListOfFiles);
                    for i := 0 to ListOfFiles.Count - 1 do
                    begin
                        listFile := ListOfFiles[i];
                        // copy Data from CurrentAudioFile to the files in the list.
                        listFile.Assign(CurrentAudioFile);
                    end;
                finally
                    ListOfFiles.Free;
                end;
                MedienBib.Changed := True;
            end;

            at_CDDA: begin
                ClearCDDBCache;
                if NempOptions.UseCDDB then
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

{$REGION 'Cover-Art'}

procedure TFDetails.ShowCoverArt_MetaTag;
var i: Integer;
  stream: TMemoryStream;
  mime: AnsiString;
  PicType: Byte;
  m4aPictype: TM4APicTypes;
  Description, UserCoverID: UnicodeString;
  MetaPicsAllowed: Boolean;
begin
    if assigned(PictureFrames) then
        FreeAndNil(PictureFrames);

    CurrentCoverStream.Clear;
    cbCoverArtMetadata.Items.Clear;

    if not assigned(CurrentAudioFile) then
        exit;
    if not assigned(CurrentTagObject) then
        exit;
    if not FileExists(CurrentAudioFile.Pfad) then
        exit;

    case CurrentTagObject.FileType of
        at_Invalid: ;
        at_Mp3: begin
                      if not assigned(PictureFrames) then
                          PictureFrames := TObjectList.Create(False);

                      TMp3File(CurrentTagObject).ID3v2Tag.GetAllPictureFrames(PictureFrames);

                      stream := TMemoryStream.Create;
                      try
                          for i := 0 to PictureFrames.Count - 1 do
                          begin
                              Stream.Clear;
                              (PictureFrames[i] as TID3v2Frame).GetPicture(Mime, PicType, Description, stream);
                              if PicType < length(Picture_Types) then
                                  cbCoverArtMetadata.Items.Add(Format('[%s] %s', [Picture_Types[PicType], Description]))
                              else
                                  cbCoverArtMetadata.Items.Add(Format('[%s] %s', [Picture_Types[0], Description]));
                          end;
                      finally
                          stream.Free;
                      end;
                end;
        at_Ogg: begin
                      // Pictures not supported in OggFiley by NEMP
                      cbCoverArtMetadata.Items.Add(DetailForm_NoPictureInOggMetaDataSuppotred);
                end;
        at_Flac: begin
                      if not assigned(PictureFrames) then
                          PictureFrames := TObjectList.Create(False);
                      TFlacFile(CurrentTagObject).GetAllPictureBlocks(PictureFrames);

                      for i := 0 to PictureFrames.Count - 1 do
                      begin
                          PicType := TFlacPictureBlock(PictureFrames[i]).PictureType;
                          Description := TFlacPictureBlock(PictureFrames[i]).Description;
                          if PicType < length(Picture_Types) then
                              cbCoverArtMetadata.Items.Add(Format('[%s] %s', [Picture_Types[PicType], Description]))
                          else
                              cbCoverArtMetadata.Items.Add(Format('[%s] %s', [Picture_Types[0], Description]));
                      end;
                  end;
        at_M4A: begin
                      stream := TMemoryStream.Create;
                      try
                          // Only one Image supprted in M4A-Files
                          if TM4aFile(CurrentTagObject).GetPictureStream(stream, m4aPictype) then
                              cbCoverArtMetadata.Items.Add(DetailForm_OnlyOneM4ACover);
                      finally
                          stream.Free;
                      end;

                  end;
        at_Monkey,
        at_WavPack,
        at_MusePack,
        at_OptimFrog,
        at_TrueAudio: TBaseApeFile(CurrentTagObject).ApeTag.GetAllPictureFrames(cbCoverArtMetadata.Items);

        at_Wma: ;
        at_Wav: ;
    end;

    // Endable/Disable control
    MetaPicsAllowed := CurrentTagObject.filetype <> at_Ogg;
    cbCoverArtMetadata.Enabled := MetaPicsAllowed and (cbCoverArtMetadata.Items.Count > 0);
    Btn_NewPicture.Enabled := MetaPicsAllowed ;
    Btn_DeletePicture.Enabled := MetaPicsAllowed AND (cbCoverArtMetadata.Items.Count > 0);
    Btn_SavePictureToFile.Enabled := MetaPicsAllowed and (cbCoverArtMetadata.Items.Count > 0);

    UserCoverID := CurrentAudioFile.GetUserCoverIDFromMetaData(CurrentTagObject);
    BtnRemoveUserCover.Enabled := UserCoverID <> '';

    // Display first image
    if (cbCoverArtMetadata.Items.Count > 0) then
    begin
        cbCoverArtMetadata.ItemIndex := 0;
        if currentTagObject.FileType <> at_Ogg then
            ShowSelectedImage_MetaData
        else
            ImgCurrentSelection.Picture.Assign(NIL);
    end
    else
        ImgCurrentSelection.Picture.Assign(NIL);
end;

procedure TFDetails.ShowCoverArt_Files;
var baseName: String;
    i: Integer;
begin
    cbCoverArtFiles.Items.Clear;
    Coverpfade.Clear;

    if not assigned(CurrentAudioFile) then
        exit;
    if not assigned(CurrentTagObject) then
        exit;
    if not FileExists(CurrentAudioFile.Pfad) then
        exit;


    if CurrentAudioFile.isCDDA then
    begin
        baseName := CoverFilenameFromCDDA(CurrentAudioFile.Pfad);
        if FileExists(TCoverArtSearcher.SavePath + baseName + '.jpg') then
              Coverpfade.Add(TCoverArtSearcher.SavePath + baseName + '.jpg')
          else if FileExists(TCoverArtSearcher.SavePath + baseName + '.png') then
              Coverpfade.Add(TCoverArtSearcher.SavePath + baseName + '.png');
    end;

    if CurrentAudioFile.IsFile then
        CoverArtSearcher.GetCandidateFilelist(CurrentAudioFile, Coverpfade);

    if Coverpfade.Count = 0 then
    begin
        cbCoverArtFiles.Items.Add((Warning_Coverbox_NoCover));
        Btn_OpenImage.Enabled := False;
        cbCoverArtFiles.ItemIndex    := 0;
        cbCoverArtFiles.Enabled      := False;
    end else
    begin // Cover gefunden

        for i := 0 to Coverpfade.Count-1 do
            cbCoverArtFiles.Items.Add(ExtractFilename(CoverPfade[i]));

        cbCoverArtFiles.ItemIndex := 0;

        CoverLibrary1.Visible := True;
        Btn_OpenImage.Enabled := True;

        // If Metadata contains no cover art:
        // Show the first cover art from Files
        if (cbCoverArtMetadata.Items.Count = 0) or (currentTagObject.FileType = at_Ogg) then
            ShowSelectedImage_Files; //(CoverPfade[CoverBox.ItemIndex]);

        cbCoverArtFiles.Enabled := True;
    end;
end;

{
    --------------------------------------------------------
    ShowSelectedImage_Files
    ShowSelectedImage_MetaData
    - load the selected Image from File or Metadata and display ist
    --------------------------------------------------------
}

procedure TFDetails.LoadPictureIntoImage(aFilename: String; aImage: TImage);
var aCoverbmp: TBitmap;
    aPic: TPicture;
begin
    aCoverbmp := tBitmap.Create;
    try
        aCoverbmp.Width := aImage.Width;
        aCoverbmp.Height := aImage.Height;
        aPic := TPicture.Create;
        try
            try
                aPic.LoadFromFile(aFileName);
                CurrentCoverStream.LoadFromFile(aFilename);

                FitBitmapIn(aCoverbmp, aPic.Graphic);
                aImage.Picture.Bitmap.Assign(aCoverbmp);
            except
                on E: Exception do
                begin
                    TCoverArtSearcher.GetDefaultCover(dcFile, aPic, 0);
                    aImage.Picture.Assign(aPic);
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

procedure TFDetails.ShowSelectedImage_Files;
begin
    if cbCoverArtFiles.itemindex >= Coverpfade.Count then
        exit;

    CurrentCoverStream.Clear;
    LoadPictureIntoImage(Coverpfade[cbCoverArtFiles.itemindex], ImgCurrentSelection);
end;

procedure TFDetails.ShowSelectedImage_MetaData;
var stream: TMemorystream;
    mime: AnsiString;
    PicType: Byte;
    m4aPictype: TM4APicTypes;
    Description: UnicodeString;
    idx: Integer;
begin
    idx := cbCoverArtMetadata.ItemIndex;

    if idx < 0 then
        exit;

    CurrentCoverStream.Clear;
    stream := TMemoryStream.Create;
    try
        case CurrentTagObject.FileType of

            at_Mp3: begin
                  // Load Image from ID3v2-Tag
                  (PictureFrames[idx] as TID3v2Frame).GetPicture(Mime, PicType, Description, stream);
                  PicStreamToBitmap(stream, Mime, ImgCurrentSelection.Picture.Bitmap);
                  CurrentCoverStream.CopyFrom(stream, 0);
            end;

            at_Flac: begin
                  // Load Image from FLAC file
                  TFlacPictureBlock(PictureFrames[idx]).CopyPicData(stream);
                  PicStreamToBitmap(stream, TFlacPictureBlock(PictureFrames[idx]).Mime, ImgCurrentSelection.Picture.Bitmap);
                  CurrentCoverStream.CopyFrom(stream, 0);
            end;

            at_M4A: begin
                  // Load *the* M4A-Image
                  // do it, as this method is also called on "OnEnter"
                  if TM4aFile(CurrentTagObject).GetPictureStream(stream, m4aPictype) then
                  begin
                      case m4aPictype of
                        M4A_JPG: mime := 'image/jpeg';
                        M4A_PNG: mime := 'image/png';
                        M4A_Invalid: mime := '-'; // invalid
                      end;
                      PicStreamToBitmap(stream, mime, ImgCurrentSelection.Picture.Bitmap);
                      CurrentCoverStream.CopyFrom(stream, 0);
                  end else
                  begin
                      ImgCurrentSelection.Picture.Assign(NIL);
                  end;
            end;

            at_Monkey,
            at_WavPack,
            at_MusePack,
            at_OptimFrog,
            at_TrueAudio: begin
                  // Load APE-Image
                  if TBaseApeFile(CurrentTagObject).ApeTag.GetPicture(AnsiString(cbCoverArtMetadata.Text), Stream, Description) then
                  begin
                      CurrentCoverStream.CopyFrom(stream, 0);
                      if not PicStreamToBitmap(Stream, 'image/jpeg', ImgCurrentSelection.Picture.Bitmap) then
                          if not PicStreamToBitmap(Stream, 'image/png', ImgCurrentSelection.Picture.Bitmap) then
                              if not PicStreamToBitmap(Stream, 'image/bmp', ImgCurrentSelection.Picture.Bitmap) then
                              begin
                                  CurrentCoverStream.Clear;  // stream contains no valid data
                                  ImgCurrentSelection.Picture.Assign(NIL);
                              end;
                  end else
                  begin
                      ImgCurrentSelection.Picture.Assign(NIL);
                  end;
            end;
            // at_Ogg, at_Invalid, at_Wma, at_Wav: ; // nothing todo, cover art is not supported here
        end;
    finally
        stream.Free;
    end;
end;


procedure TFDetails.cbCoverArtFilesChange(Sender: TObject);
begin
    if cbCoverArtFiles.itemindex < Coverpfade.Count then
        ShowSelectedImage_Files;
end;

procedure TFDetails.cbCoverArtMetadataChange(Sender: TObject);
begin
    ShowSelectedImage_MetaData;
end;




procedure TFDetails.Btn_NewPictureClick(Sender: TObject);
begin
    if Not Assigned(FNewPicture) then
        Application.CreateForm(TFNewPicture, FNewPicture);

    FNewPicture.LblConst_PictureType.Enabled := CurrentTagObject.FileType <> at_M4A;
    FNewPicture.LblConst_PictureDescription.Enabled := CurrentTagObject.FileType <> at_M4A;
    FNewPicture.cbPictureType.Enabled := CurrentTagObject.FileType <> at_M4A;
    FNewPicture.EdtPictureDescription.Enabled := CurrentTagObject.FileType <> at_M4A;

    // Adding the Picture to the CurrentTagObject is done in the Form FNewPicture
    if FNewPicture.Showmodal = MROK then
        PictureHasChanged := True;

    ShowCoverArt_MetaTag;
end;
procedure TFDetails.Btn_DeletePictureClick(Sender: TObject);
begin
    case CurrentTagObject.FileType of
        at_Mp3: TMp3File(CurrentTagObject).Id3v2Tag.DeleteFrame(PictureFrames[cbCoverArtMetadata.ItemIndex] as TID3v2Frame );
        at_Flac: TFlacFile(CurrentTagObject).DeletePicture(TFlacPictureBlock(PictureFrames[cbCoverArtMetadata.ItemIndex]));
        at_M4A: TM4aFile(CurrentTagObject).SetPicture(Nil, M4A_Invalid);
        at_Monkey,
        at_WavPack,
        at_MusePack,
        at_OptimFrog,
        at_TrueAudio: TBaseApeFile(CurrentTagObject).ApeTag.SetPicture(AnsiString(cbCoverArtMetadata.Text), '', NIL );
        // at_Invalid: ;at_Ogg: ; at_Wma: ; at_Wav: ; // nothing to do, not supported.
    end;
    ShowCoverArt_MetaTag;
    PictureHasChanged := True;
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

    stream := TMemoryStream.Create;
    try
        mime := ''; // something invalid
        idx := cbCoverArtMetadata.ItemIndex;
        case CurrentTagObject.FileType of

            at_Mp3: begin
                  (PictureFrames[idx] as TID3v2Frame).GetPicture(Mime, PicType, Description, stream);
                  PicStreamToBitmap(stream, Mime, ImgCurrentSelection.Picture.Bitmap);
            end;

            at_Flac: begin
                  mime := TFlacPictureBlock(PictureFrames[idx]).Mime;
                  TFlacPictureBlock(PictureFrames[idx]).CopyPicData(stream);
            end;

            at_M4A: begin
                  if TM4aFile(CurrentTagObject).GetPictureStream(stream, m4aPictype) then
                  begin
                      case m4aPictype of
                        M4A_JPG: mime := 'image/jpeg';
                        M4A_PNG: mime := 'image/png';
                        M4A_Invalid: mime := '-'; // invalid
                      end;
                  end;
            end;

            at_Monkey,
            at_WavPack,
            at_MusePack,
            at_OptimFrog,
            at_TrueAudio: begin
                  if TBaseApeFile(CurrentTagObject).ApeTag.GetPicture(AnsiString(cbCoverArtMetadata.Text), Stream, Description) then
                  begin
                      // try to get the MimeType
                      tmpBmp := TBitmap.Create;
                      try
                          if PicStreamToBitmap(Stream, 'image/jpeg', tmpBmp) then
                              mime := 'image/jpeg'
                          else
                              if PicStreamToBitmap(Stream, 'image/png', tmpBmp) then
                                  mime := 'image/png'
                      finally
                            tmpBmp.Free;
                      end;
                  end;
            end;
            // at_Ogg, at_Invalid, at_Wma, at_Wav: ; // nothing todo, cover art is not supported here
        end;

        // Prepare SaveDialog
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
        if SaveDialog1.execute(Handle) then
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


procedure TFDetails.HandleCoverIDSetting(aNewID: String);
var ms: TMemoryStream;
    AnsiID: AnsiString;
begin
    ///  If the user selects a different CoverArt than Nemp suggests, Nemp will write this
    ///  User-Selected Cover-ID into the MetaTag
    ///  (Private-Frame for ID3v2, "NEMP_COVER_ID" for Ogg/Flac/Ape "NEMP COVER ID" for M4A)
    ///  This Cover-ID will get Top-Priority when refreshing CoverArt via "F5"-> GetAudioData/InitCover
    ///
    ///  When changing the cover, this new CoverID is added to the currentTagObject
    ///  ... and written into the file on BtnApplyClick
    ///  If wanted, this ID is also changed on all other files with the "old" coverID (and also written into Metadata)
    if (not assigned(CurrentAudioFile))
        or (MedienBib.StatusBibUpdate > 1)
        or (MedienBib.CurrentThreadFilename = CurrentAudioFile.Pfad)
    then
    begin
        TranslateMessageDLG((Warning_MedienBibIsBusyCritical), mtWarning, [MBOK], 0);
        exit;
    end;

    CoverArtHasChanged := True;

    case CurrentTagObject.FileType of
        at_Mp3: begin
              AnsiID := AnsiString(aNewID);
              if length(AnsiID) > 0 then
              begin
                  CurrentAudioFile.EnsureID3v2Exists(TMp3File(CurrentTagObject));
                  ms := TMemoryStream.Create;
                  try
                      ms.Write(AnsiID[1], length(AnsiID));
                      TMp3File(CurrentTagObject).ID3v2Tag.SetPrivateFrame('NEMP/UserCoverID', ms);
                  finally
                      ms.Free;
                  end;
              end else
                  // delete UserCoverID-Frame
                  TMp3File(CurrentTagObject).ID3v2Tag.SetPrivateFrame('NEMP/UserCoverID', NIL);
        end;

        at_Ogg : TOggVorbisFile(CurrentTagObject).SetPropertyByFieldname(VORBIS_USERCOVERID, aNewID);
        at_Flac: TFlacFile(CurrentTagObject).SetPropertyByFieldname(VORBIS_USERCOVERID, aNewID);
        at_M4A : TM4aFile(CurrentTagObject).SetSpecialData(DEFAULT_MEAN, M4AUserCoverID, aNewID);
        at_Monkey,
        at_WavPack,
        at_MusePack,
        at_OptimFrog,
        at_TrueAudio:  TBaseApeFile(CurrentTagObject).ApeTag.SetValueByKey(APE_USERCOVERID  , aNewID);
        //at_Wma: ; at_Invalid: ; at_Wav: ;
    end;

    if (aNewID <> '') and FileExists(TCoverArtSearcher.SavePath + aNewID + '.jpg') then
    begin
        // display the current selection in Library-Image
        LoadPictureIntoImage(TCoverArtSearcher.SavePath + aNewID + '.jpg', CoverLibrary2);
        NewLibraryCoverID := aNewID;
    end
    else
    begin
        // get the Cover for "CurrentAudioFile" again
        CoverLibrary2.Picture.Assign(Nil);
        CoverLibrary2.Refresh;
        CoverLibrary2.Picture.Bitmap.Width := CoverLibrary2.Width;
        CoverLibrary2.Picture.Bitmap.Height := CoverLibrary2.Height;

        ///  The user wants to remove his/her choice here, so Nemp should choose some CoverArt on its own again.
        ///  Issue (with previous code):
        ///  - "InitCover" scans MetaData for CoverArt in the actual file - but this hasn't been updated yet.
        ///    Therefore: Set a Flag to "Ignore the UserCover-ID in the Metatags"
        CoverArtSearcher.StartNewSearch;
        CoverArtSearcher.InitCover(AudioFileCopy, tm_VCL, INIT_COVER_FORCE_RESCAN OR INIT_COVER_IGNORE_USERID);

        CoverArtSearcher.GetCover_Fast(AudioFileCopy, CoverLibrary2.Picture);
        CoverLibrary2.Refresh;
        NewLibraryCoverID := AudioFileCopy.CoverID;
    end;

    if (aNewID = '') then
      NewLibraryCoverID_FileSave := ''
    else
      NewLibraryCoverID_FileSave := NewLibraryCoverID;

end;


procedure TFDetails.BtnUseCurrentSelectionInLibraryClick(Sender: TObject);
var newID: String;
begin
      CurrentCoverStream.Seek(0, soFromBeginning);
      // calculate a new ID from the stream data
      newID := MD5DigestToStr(MD5Stream(CurrentCoverStream));
      // try to save a resized JPG from the content of the stream
      // if this fails, there was something wrong with the image data :(
      if FileExists(TCoverArtSearcher.SavePath + newID + '.jpg')
         OR
         TCoverArtSearcher.ScalePicStreamToFile_AllSizes(CurrentCoverStream, newID, Nil)
      then
          HandleCoverIDSetting(newID)
end;

procedure TFDetails.BtnRemoveUserCoverClick(Sender: TObject);
begin
    HandleCoverIDSetting('');
end;

procedure TFDetails.BtnLoadAnotherImageClick(Sender: TObject);
var newID: String;
    fs: TFileStream;
begin
    if OpenDlgCoverArt.Execute(self.Handle) then
    begin
        fs := TFileStream.Create(OpenDlgCoverArt.FileName, fmOpenread);
        try
            newID := MD5DigestToStr(MD5Stream(fs));
            // try to save a resized JPG from the content of the stream
            // if this fails, there was something wrong with the image data :(
            if FileExists(TCoverArtSearcher.Savepath + newID + '.jpg')
               OR
               TCoverArtSearcher.ScalePicStreamToFile_AllSizes(fs, newID, Nil)
            then
                HandleCoverIDSetting(newID);
        finally
            fs.Free;
        end;
    end;
end;

{$ENDREGION}


{
    --------------------------------------------------------
    Btn_OpenImageClick
    CoverIMAGEDblClick
    - open the image in the default application
    --------------------------------------------------------
}
procedure TFDetails.Btn_OpenImageClick(Sender: TObject);
begin
  ShellExecute(Handle, nil {'open'}, PChar(Coverpfade[cbCoverArtFiles.itemindex]), nil, nil, SW_SHOWNORMAl)
end;



procedure TFDetails.CoverIMAGEDblClick(Sender: TObject);
begin
    if FileExists(TCoverArtSearcher.Savepath + currentAudioFile.CoverID + '.jpg') then
        ShellExecute(Handle, Nil, PChar(TCoverArtSearcher.Savepath + currentAudioFile.CoverID + '.jpg'), '', nil, SW_SHOWNORMAl);
end;                      {'open'}




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




function TFDetails.CurrentFileHasBeenChanged: Boolean;
begin
    result := assigned(CurrentAudioFile)
             AND (LibraryPropertyChanged or TagCloudTagsChanged
                   or PictureHasChanged or LyricsHasChanged
                  or ID3v1HasChanged or MetaFramesHasChanged or CoverArtHasChanged
                  or CurrentTagRatingChanged
                  );
end;

end.

