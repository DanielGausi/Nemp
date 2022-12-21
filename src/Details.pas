{

    Unit Details
    Form TFDetails

    - Show Details from AudioFiles
    - Edit ID3Tags, including basic-stuff like title, artist,
                    Lyrics
                    Pictures

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
unit Details;

interface

{$I xe.inc}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Contnrs,
  Dialogs, NempAudioFiles, StdCtrls, ExtCtrls, StrUtils, JPEG, PNGImage,
  ShellApi, ComCtrls, U_CharCode, myDialogs,
  AudioFiles.Base, AudioFiles.Declarations, AudioFiles.Factory, ID3v1Tags, ID3v2Tags, MpegFrames, ID3v2Frames, ID3GenreList, Mp3Files, FlacFiles, OggVorbisFiles,
  VorbisComments, BaseApeFiles, Apev2Tags, ApeTagItem, MusePackFiles, cddaUtils,
  M4AFiles, M4AAtoms, md5, NempHelp,

  CoverHelper, Buttons, ExtDlgs, ImgList,  Hilfsfunktionen, Systemhelper, HtmlHelper,
  Nemp_ConstantsAndTypes, gnuGettext, Lyrics, TagClouds, LibraryOrganizer.Base,
  Nemp_RessourceStrings, Menus, RatingCtrls, Spin, VirtualTrees, Vcl.Themes, vcl.styles,
  System.ImageList, System.Actions, Vcl.ActnList;

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

        constructor Create(aTagType: TTagType; aKey, aValue: String; aID3v2Frame: TID3v2Frame); overload;
        procedure InitEditability;
  end;

  TEPictureItemType = (ptIndexedMetaData, ptNamedMetaData, ptFile);

  TPictureItem = class
      private
        fItemType: TEPictureItemType;
        fMetaDataType: String;
        fDescription: String; // Description in MetaData
        fFileName: String; // Filename
        fMetaFrame: TObject; // TID3v2Frame or TFlacPictureBlock, for APE use Description tpo access a Frame
        fSize: Int64;
        function GetCaption: String;
      public
        property ItemType: TEPictureItemType read fItemType write fItemType;
        property Description: String read fDescription write fDescription;
        property FileName: String read fFileName write fFileName;

        property Caption: String read GetCaption;

        constructor Create(MetaType, MetaDescription: String; Frame: TObject); overload;
        constructor Create(aFilename: String); overload;
  end;

  TFDetails = class(TForm)
    MainPageControl: TPageControl;
    Tab_General: TTabSheet;
    GrpBox_File: TGroupBox;
    Tab_MetaData: TTabSheet;
    Tab_Lyrics: TTabSheet;
    GrpBox_Lyrics: TGroupBox;
    PnlWarnung: TPanel;
    Image1: TImage;
    Tab_Pictures: TTabSheet;
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
    Pnl_ID3v1_MPEG: TPanel;
    GrpBox_ID3v1: TGroupBox;
    LblConst_ID3v1Artist: TLabel;
    LblConst_ID3v1Title: TLabel;
    LblConst_ID3v1Album: TLabel;
    LblConst_ID3v1Year: TLabel;
    LblConst_ID3v1Genre: TLabel;
    LblConst_ID3v1Comment: TLabel;
    LblConst_ID3v1Track: TLabel;
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
    GrpBox_MetaDataLibrary: TGroupBox;
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
    CB_LibraryGenre: TComboBox;
    Edit_LibraryCD: TEdit;
    LblReplayGainTitle: TLabel;
    LblReplayGainAlbum: TLabel;
    pnlButtons: TPanel;
    Btn_Close: TButton;
    BtnUndo: TButton;
    BtnApply: TButton;
    OpenDlgCoverArt: TOpenPictureDialog;
    PanelCoverArtFile: TPanel;
    gpBoxExistingCoverArt: TGroupBox;
    ImgCurrentSelection: TImage;
    BtnRefreshCoverflow: TButton;
    VST_MetaData: TVirtualStringTree;
    btnSearchLyrics: TButton;
    PM_SearchEngines: TPopupMenu;
    lblLyricSearchEngines: TLabel;
    pnlSearchLyrics: TPanel;
    MainMenu1: TMainMenu;
    mmFile: TMenuItem;
    mmShowInExplorer: TMenuItem;
    mmWindowsProperties: TMenuItem;
    mmResetRating: TMenuItem;
    mmSynchronizeRating: TMenuItem;
    mmRefresh: TMenuItem;
    lblAlbumArtist: TLabel;
    Edit_LibraryAlbumArtist: TEdit;
    lblComposer: TLabel;
    Edit_LibraryComposer: TEdit;
    VSTCover: TVirtualStringTree;
    imgListCovertypes: TImageList;
    ActionList1: TActionList;
    ActionShowInExplorer: TAction;
    ActionWindowsProperties: TAction;
    ActionResetRating: TAction;
    ActionSynchronizeRating: TAction;
    ActionRefreshFile: TAction;
    ActionTagAdd: TAction;
    ActionTagRename: TAction;
    ActionTagRemove: TAction;
    ActionTagGetLastFM: TAction;
    ActionTagOpenCloudEditor: TAction;
    mmExtendedTags: TMenuItem;
    mmAddTag: TMenuItem;
    mmEditTag: TMenuItem;
    mmRemoveTag: TMenuItem;
    mmGetExtendedTagsFromLastFM: TMenuItem;
    mmOpenCloudEditor: TMenuItem;
    N1: TMenuItem;
    Getextendedtagsfromlastfm1: TMenuItem;
    N2: TMenuItem;
    Opencloudeditor1: TMenuItem;
    pnlExtendedTags: TPanel;
    lb_Tags: TListBox;
    pnlMetadataOverview: TPanel;
    lblExtendedTags: TLabel;
    mmLyrics: TMenuItem;
    ActionCoverNewMetaData: TAction;
    ActionCoverDeleteMetaData: TAction;
    ActionCoverMetaDataSaveToFile: TAction;
    ActionCoverMetaDataOpenFile: TAction;
    ActionCoverLoadLibrary: TAction;
    ActionCoverUseCurrentSelectionForMediaLibrary: TAction;
    ActionCoverResetMediaLibrary: TAction;
    mmCoverArt: TMenuItem;
    mmAddCoverToMetadata: TMenuItem;
    mmCoverDelete: TMenuItem;
    mmCoverReset: TMenuItem;
    mmCoverUseSelectedForLibrary: TMenuItem;
    mmCoverLoadLibrary: TMenuItem;
    N3: TMenuItem;
    mmCoverSaveToFile: TMenuItem;
    mmOpenSelectedFile: TMenuItem;
    PM_CoverArt: TPopupMenu;
    Addcovertometadata1: TMenuItem;
    Deleteselectedcoverfrommetadata1: TMenuItem;
    Saveselectedcovertofile1: TMenuItem;
    Openselectedimagefile1: TMenuItem;
    LoadcoverforMedialibrary1: TMenuItem;
    UseselectedcoverforMedialibrary1: TMenuItem;
    ResetcoverinMedialibrary1: TMenuItem;
    N4: TMenuItem;
    lblCoverInfo: TLabel;
    pnlCoverCurrentSelection: TPanel;
    GrpBox_CoverLibrary: TGroupBox;
    CoverLibrary2: TImage;
    lblChangeCoverArt: TLabel;
    cbChangeCoverArt: TComboBox;
    ActionMetaNewFrame: TAction;
    ActionMetaCopyFromID3v1: TAction;
    ActionMetaCopyFromID3v2: TAction;
    mmMetaData: TMenuItem;
    mmNewDataFrame: TMenuItem;
    mmCopyfromID3v1: TMenuItem;
    mmCopyfromID3v2: TMenuItem;
    N5: TMenuItem;
    PM_TagStructure: TPopupMenu;
    Newdataframe1: TMenuItem;
    CopyID3v2APEfromID3v11: TMenuItem;
    CopyID3v1fromID3v2APE1: TMenuItem;
    PM_FileOverview: TPopupMenu;
    ShowinExplorer1: TMenuItem;
    Windowsproperties1: TMenuItem;
    Resetratingandplaycounter1: TMenuItem;
    Synchronizerating1: TMenuItem;
    Refresh1: TMenuItem;
    cbQuickRefresh: TCheckBox;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormHide(Sender: TObject);

    // Used by webstreams - Open the URL in Webbrowser or copy it
    procedure LBLPfadClick(Sender: TObject);
    procedure PM_CopyURLToClipboardClick(Sender: TObject);

    // three Buttons and CheckBox on bottom of the form
    procedure BtnApplyClick(Sender: TObject);
    procedure BtnUndoClick(Sender: TObject);
    procedure Btn_CloseClick(Sender: TObject);

    // Procedures for editing the rating of the current file
    procedure IMG_LibraryRatingMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure IMG_LibraryRatingMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure IMG_LibraryRatingMouseLeave(Sender: TObject);
    procedure CoverIMAGEDblClick(Sender: TObject);
    // Load an image from Pfad and shows it on page 1
    procedure ShowSelectedImage_Files(PicItem: TPictureItem = NIL);
    procedure ShowSelectedImage_MetaData(PicItem: TPictureItem = NIL);
    procedure ExtractPicStreamFromMetaData(PicItem: TPictureItem; stream: TStream; var MimeType: AnsiString);

    // Live-Checking for valid inputs
    procedure Edit_LibraryTrackChange(Sender: TObject);
    procedure Lblv1TrackChange(Sender: TObject);
    procedure Lblv1YearChange(Sender: TObject);
    procedure Edit_LibraryYearChange(Sender: TObject);

    // used for Ctrl+A
    procedure Memo_LyricsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);

    // Getting Lyrics
    procedure SelectLyricSourceClick(Sender: TObject);
    procedure BtnLyricWikiClick(Sender: TObject);

    procedure ReloadTimerTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure edtID3v1Exit(Sender: TObject);
    procedure EditLibraryChange(Sender: TObject);
    procedure Memo_LyricsChange(Sender: TObject);
    procedure TagsHasChanged(newIdx: Integer);
    procedure lb_TagsDblClick(Sender: TObject);
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
    procedure MainPageControlChange(Sender: TObject);
    procedure BtnRefreshCoverflowClick(Sender: TObject);
    procedure VST_MetaDataCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure cbIDv1GenresChange(Sender: TObject);
    procedure btnSearchLyricsClick(Sender: TObject);
    procedure VSTCoverFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure VSTCoverGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure VSTCoverPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure VSTCoverFocusChanged(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex);
    procedure VSTCoverGetImageIndex(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
      var Ghosted: Boolean; var ImageIndex: TImageIndex);
    procedure ActionShowInExplorerExecute(Sender: TObject);
    procedure ActionWindowsPropertiesExecute(Sender: TObject);
    procedure ActionResetRatingExecute(Sender: TObject);
    procedure ActionSynchronizeRatingExecute(Sender: TObject);
    procedure ActionRefreshFileExecute(Sender: TObject);
    procedure ActionTagAddExecute(Sender: TObject);
    procedure ActionTagRemoveExecute(Sender: TObject);
    procedure ActionTagRenameExecute(Sender: TObject);
    procedure ActionTagGetLastFMExecute(Sender: TObject);
    procedure ActionTagOpenCloudEditorExecute(Sender: TObject);
    procedure ActionCoverNewMetaDataExecute(Sender: TObject);
    procedure ActionCoverDeleteMetaDataExecute(Sender: TObject);
    procedure ActionCoverMetaDataSaveToFileExecute(Sender: TObject);
    procedure ActionCoverMetaDataOpenFileExecute(Sender: TObject);
    procedure ImgCurrentSelectionDblClick(Sender: TObject);
    procedure ActionCoverLoadLibraryExecute(Sender: TObject);
    procedure ActionCoverUseCurrentSelectionForMediaLibraryExecute(
      Sender: TObject);
    procedure ActionCoverResetMediaLibraryExecute(Sender: TObject);
    procedure PM_CoverArtPopup(Sender: TObject);
    procedure ActionMetaNewFrameExecute(Sender: TObject);
    procedure ActionMetaCopyFromID3v1Execute(Sender: TObject);
    procedure ActionMetaCopyFromID3v2Execute(Sender: TObject);
    procedure mmLyricsClick(Sender: TObject);
    procedure mmMetaDataClick(Sender: TObject);
    procedure mmExtendedTagsClick(Sender: TObject);
    procedure mmFileClick(Sender: TObject);
    procedure Memo_LyricsExit(Sender: TObject);
    procedure Edit_LibraryExit(Sender: TObject);
    procedure cbQuickRefreshClick(Sender: TObject);
    procedure edtID3v1Change(Sender: TObject);
  protected

  private
    // new Concept 2022: Use 2 copies of the displayed AudioFile
    // 1.) An original copy, which can be used for "undo"
    // 2.) A copy which saves all changes when they're done by the User (like OnEditExit)
    fOriginalFileCopy,
    fEditFile: TAudioFile;
    fReloadFile: TAudioFile;
    fEditTag: TBaseAudioFile;

    CurrentTagObjectWriteAccessPossible: Boolean;
    fDataChanged: Boolean;
    fRatingsAreSynched: Boolean;
    CoverArtHasChanged: Boolean;
    PicturesLoaded: Boolean;

    // When we change the "media library cover" for a file, it may be wanted for other files as well.
    // The changed CoverID ist stored in NewLibraryCoverID.
    // However, if we want to delete a manually set ID and use the default one again, the Frame
    // "UserCoverID" should be removed from the MetaData of the file. In that case, use "NewLibraryCoverID_FileSave := ''"
    NewLibraryCoverID,
    NewLibraryCoverID_FileSave: String;

    DetailRatingHelper: TRatingHelper;
    CoverArtSearcher: TCoverArtSearcher;

    procedure LoadPictureIntoImage(aFilename: String; aImage: TImage);

    // Show some information of the selected audiofile
    procedure ShowMetaDataFrames;

    procedure FillTagWithID3v1Values(Dest: TID3v2Tag); Overload;
    procedure FillTagWithID3v1Values(Dest: TApeTag); Overload;
    procedure Fillv1TagWithTagValues(Source: TID3v2Tag; Dest: TID3v1Tag); Overload;
    procedure Fillv1TagWithTagValues(Source: TApeTag; Dest: TID3v1Tag); Overload;

    procedure AddWantedTag(aTag: TMetaTag);
    procedure FrameBasedTagNeeded;
    // Change the values in the AudioFile- and Tag-Objects according to the Edits
    procedure ApplyRatingToAudioFile(newRating: Byte);
    procedure ApplyExtendedTagsToAudioFile;
    procedure ApplyLyricsToAudioFile;
    procedure ApplyEditsToAudioFile; // NOT including lyrics
    procedure ApplyEditFileToEditTag;
    // if we've edited some Frames, these changes must be applied to the general TAudioFile-Object
    procedure MetaDataFramesToAudioFile;
    // Note: Displaying the changes in the Frame-TreeView or in the general Edits must be done separately

    procedure UpdateRatingGUI(ValuesAreSynched: Boolean = False);
    procedure ShowMainProperties; // Editable properties on the first page.
    procedure ShowLyrics;
    function CheckRatings: Boolean;
    function ApplyExternalChanges: Boolean;

    // Show all the Details for an AudioFile
    // Source: Gibt an, ob bei einem Edit der Datei die Medienbib aktualisiert werden muss
    procedure ShowDetails(AudioFile: TAudioFile);
    procedure ProcessFileToDisplay(AudioFile: TAudioFile);

    procedure RemoveNiledFrames;
    procedure ApplyCoverIDChanges;

    procedure InitCurrentTagObject;
    procedure GetRatingFromLibrary;
    procedure UpdateMediaBibEnabledStatus;

    procedure ShowMediaBibDetails;
    procedure ShowMPEGDetails(mp3: TMp3File);
    procedure ShowID3v1Details(ID3v1Tag: TID3v1Tag);
    procedure ShowCoverArt;
    procedure SelectFirstCover;
    procedure GetListOfCoverArt_MetaFrames;
    procedure GetListOfCoverArt_Files;

    procedure HandleCoverIDSetting(aNewID: String);

    procedure SyncFilesAfterEdit;

    procedure CheckForChangedData(BackupFile: TAudioFile);
    function CurrentFileHasBeenChanged: Boolean;

    function GetID3v1TagfromBaseAudioFile(aBaseAudioFile: TBaseAudioFile): TID3v1Tag;
    procedure PrepareLyricSearchEngines;

  public

    procedure AudioFileEdited(AudioFile: TAudioFile);
    procedure NewAudioFileSelected(AudioFile: TAudioFile; UserDoWantShow: Boolean);

    procedure RefreshStarGraphics;
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


{ TPictureItem }

constructor TPictureItem.Create(aFilename: String);
begin
  inherited create;
  fItemType := ptFile;
  fFileName := aFilename;
  fMetaFrame := Nil;
end;

constructor TPictureItem.Create(MetaType, MetaDescription: String; Frame: TObject);
begin
  fItemType := ptIndexedMetaData;
  fMetaDataType := MetaType;
  fDescription := MetaDescription;
  fMetaFrame := Frame;
end;

function TPictureItem.GetCaption: String;
begin
  case self.fItemType of
    ptIndexedMetaData: result := Format('%s, %s', [fMetaDataType, Description]);
    ptNamedMetaData: result := Description;
    ptFile: result := ExtractFilename(fFileName);
  else
    result  := '';
  end;
end;


{$REGION 'Basic FormEvent-Handler ... create, destroy, show, hide, FormCloseQuery (!!)'}
procedure TFDetails.FormCreate(Sender: TObject);
var i:integer;
begin
  HelpContext := HELP_MetaDataExtendedEdit;

  BackUpComboBoxes(self);
  TranslateComponent (self);
  RestoreComboboxes(self);

  fEditTag := Nil;

  fOriginalFileCopy := TAudioFile.Create;
  fEditFile := TAudioFile.Create;
  fReloadFile := Nil;

  cbIDv1Genres.Items := ID3Genres;
  cbIDv1Genres.Items.Add('');
  for i := 0 to ID3Genres.Count - 1 do
      CB_LibraryGenre.Items.Add(ID3Genres[i]);

  DetailRatingHelper := TRatingHelper.Create;
  LoadStarGraphics(DetailRatingHelper);

  VST_MetaData.NodeDataSize := sizeOf(TTagEditItem);
  VSTCover.NodeDataSize := SizeOf(TPictureItem);
  CoverArtSearcher := TCoverArtSearcher.Create;

  cbQuickRefresh.Checked := NempOptions.QuickRefreshDetails;
  PrepareLyricSearchEngines;

  MainPageControl.ActivePageIndex := 0;
  MainPageControl.ActivePage := Tab_General;
end;


procedure TFDetails.FormDestroy(Sender: TObject);
begin
    if assigned(fEditTag) then
        FreeAndNil(fEditTag);
    DetailRatingHelper.Free;
    fOriginalFileCopy.Free;
    fEditFile.Free;
    CoverArtSearcher.Free;
end;

procedure TFDetails.FormHide(Sender: TObject);
begin
  fDataChanged := False;
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


procedure TFDetails.cbQuickRefreshClick(Sender: TObject);
begin
  NempOptions.QuickRefreshDetails := cbQuickRefresh.Checked;
end;


procedure TFDetails.AudioFileEdited(AudioFile: TAudioFile);
begin
  if not visible then exit;
  if not assigned(AudioFile) then exit;

  if AudioFile.pfad = fEditFile.Pfad then begin
    ReloadTimer.Enabled := False;
    fReloadFile := AudioFile;
    ReloadTimer.Enabled := True;
  end;
end;

{
    --------------------------------------------------------
    ReloadTimerTimer
    - When editing files in the MainVST, the Information here should be reloaded.
      However, if the user changed something here as well, the user should decide, what to do
      (especially when the file was automatically changed by the Autorating-System

    --------------------------------------------------------
}
procedure TFDetails.ReloadTimerTimer(Sender: TObject);
var
  oldChanged: Boolean;
begin
    ReloadTimer.Enabled := False;
    oldChanged := self.fDataChanged;

    if ApplyExternalChanges then begin
      ApplyEditFileToEditTag;
      ShowMainProperties;
      ShowMetaDataFrames;
      fDataChanged := oldChanged;
    end
    else begin
      // reload the file data, discard all changes made here
      ProcessFileToDisplay(fReloadFile);
    end;
end;

function TFDetails.ApplyExternalChanges: Boolean;
begin
  result := True;
  if (fReloadFile.Rating <> fOriginalFileCopy.Rating) or (fReloadFile.PlayCounter <> fOriginalFileCopy.PlayCounter) then begin
    if (fEditFile.Rating = fOriginalFileCopy.Rating) then begin
      // Rating wasn't changed here, so apply the new rating
      fEditFile.Rating := fReloadFile.Rating;
      fEditFile.PlayCounter := fReloadFile.PlayCounter;
      fOriginalFileCopy.Rating := fReloadFile.Rating;
      fOriginalFileCopy.PlayCounter := fReloadFile.PlayCounter;
      ApplyRatingToAudioFile(fEditFile.Rating);
      UpdateRatingGUI(True);
    end;
  end;

  if fReloadFile.Artist <> fOriginalFileCopy.Artist then begin
    if fEditFile.Artist = fOriginalFileCopy.Artist then begin
      fEditFile.Artist := fReloadFile.Artist;
      fOriginalFileCopy.Artist := fReloadFile.Artist;
    end
    else
      result := False;
  end;

  if fReloadFile.Titel <> fOriginalFileCopy.Titel then begin
    if fEditFile.Titel = fOriginalFileCopy.Titel then begin
      fEditFile.Titel := fReloadFile.Titel;
      fOriginalFileCopy.Titel := fReloadFile.Titel;
    end
    else
      result := False;
  end;

  if fReloadFile.Album <> fOriginalFileCopy.Album then begin
    if fEditFile.Album = fOriginalFileCopy.Album then begin
      fEditFile.Album := fReloadFile.Album;
      fOriginalFileCopy.Album := fReloadFile.Album;
    end
    else
      result := False;
  end;

  if fReloadFile.Comment <> fOriginalFileCopy.Comment then begin
    if fEditFile.Comment = fOriginalFileCopy.Comment then begin
      fEditFile.Comment := fReloadFile.Comment;
      fOriginalFileCopy.Comment := fReloadFile.Comment;
    end
    else
      result := False;
  end;

  if fReloadFile.AlbumArtist <> fOriginalFileCopy.AlbumArtist then begin
    if fEditFile.AlbumArtist = fOriginalFileCopy.AlbumArtist then begin
      fEditFile.AlbumArtist := fReloadFile.AlbumArtist;
      fOriginalFileCopy.AlbumArtist := fReloadFile.AlbumArtist;
    end
    else
      result := False;
  end;

  if fReloadFile.Composer <> fOriginalFileCopy.Composer then begin
    if fEditFile.Composer = fOriginalFileCopy.Composer then begin
      fEditFile.Composer := fReloadFile.Composer;
      fOriginalFileCopy.Composer := fReloadFile.Composer;
    end
    else
      result := False;
  end;

  if fReloadFile.Genre <> fOriginalFileCopy.Genre then begin
    if fEditFile.Genre = fOriginalFileCopy.Genre then begin
      fEditFile.Genre := fReloadFile.Genre;
      fOriginalFileCopy.Genre := fReloadFile.Genre;
    end
    else
      result := False;
  end;

  if fReloadFile.Year <> fOriginalFileCopy.Year then begin
    if fEditFile.Year = fOriginalFileCopy.Year then begin
      fEditFile.Year := fReloadFile.Year;
      fOriginalFileCopy.Year := fReloadFile.Year;
    end
    else
      result := False;
  end;

  if fReloadFile.Track <> fOriginalFileCopy.Track then begin
    if fEditFile.Track = fOriginalFileCopy.Track then begin
      fEditFile.Track := fReloadFile.Track;
      fOriginalFileCopy.Track := fReloadFile.Track;
    end
    else
      result := False;
  end;

  if fReloadFile.CD <> fOriginalFileCopy.CD then begin
    if fEditFile.CD = fOriginalFileCopy.CD then begin
      fEditFile.CD := fReloadFile.CD;
      fOriginalFileCopy.CD := fReloadFile.CD;
    end
    else
      result := False;
  end;

  if (fReloadFile.TrackGain <> fOriginalFileCopy.TrackGain) or
     (fReloadFile.AlbumGain <> fOriginalFileCopy.AlbumGain) or
     (fReloadFile.TrackPeak <> fOriginalFileCopy.TrackPeak) or
     (fReloadFile.AlbumPeak <> fOriginalFileCopy.AlbumPeak)
  then
    result := false;
end;

procedure TFDetails.ProcessFileToDisplay(AudioFile: TAudioFile);
begin
  // create copies of the file
  fOriginalFileCopy.Assign(AudioFile);
  fEditFile.Assign(AudioFile);
  // get the rating information from the library (because this is not necessarily stored in the MetaData of the file)
  GetRatingFromLibrary;

  // init the currenttagObject
  // - display the Warning-Panel if the file is Not Valid
  // - Activate/Deactivate Tab-Pages for Non-File-Objects (webstream, CDDA)
  InitCurrentTagObject;

  // show file information (including: "actually show the Form")
  ShowDetails(fEditFile);
end;

procedure TFDetails.NewAudioFileSelected(AudioFile: TAudioFile; UserDoWantShow: Boolean);
begin
  if not (Visible or UserDoWantShow) // Form is hidden, and User does not explicitly want to see details
    or not (UserDoWantShow or NempOptions.QuickRefreshDetails) // User doesn't explictly want the details, and Quickrefresh is off
  then
    exit; // nothing todo.

  // now: Nemp should display the file information.
  if CurrentFileHasBeenChanged then begin
    case TranslateMessageDLG((DetailForm_SaveChanges), mtConfirmation, [MBYes, MBNo, MBAbort], 0) of
      mrYes   : BtnApply.Click;   // save changes and proceed
      mrNo    : ;                 // discard changes and proceed
      mrAbort : Exit;             // Abort showing file details
      end;
  end;

  ProcessFileToDisplay(AudioFile);
end;

{
    --------------------------------------------------------
    ShowDetails
    - Show all available information
    --------------------------------------------------------
}
procedure TFDetails.ShowDetails(AudioFile: TAudioFile);
begin
    // First Page: MediaLibrary Information
    ShowMediaBibDetails;
    UpdateMediaBibEnabledStatus;
    ShowMainProperties;

    // display detailed MetaTag-Information, List of all(?) Frames
    ShowMetaDataFrames;
    // for mp3Files: Show additional Controls for ID3v1-Tags and some more detailed data about MPEG
    if fEditTag.Valid and (fEditTag.filetype = at_mp3) then
      ShowMPEGDetails(TMP3File(fEditTag));

    if MainPageControl.ActivePage = Tab_Pictures then begin
      PicturesLoaded := True;
      ShowCoverArt;
    end else
      PicturesLoaded := False; // Show Pictures later, if needed
    ShowLyrics;
    fDataChanged := False;
    CoverArtHasChanged := False;
    if not visible then
      self.Show;
end;

{
    --------------------------------------------------------
    <*>ToAudioFile
    - Copy the edited Values to the Data-Objects
    --------------------------------------------------------
}
procedure TFDetails.ApplyEditsToAudioFile;
begin
    fEditFile.Artist := Edit_LibraryArtist.Text;
    fEditFile.Titel  := Edit_LibraryTitle.Text;
    fEditFile.Album  := Edit_LibraryAlbum.Text;
    fEditFile.Comment := Edit_LibraryComment.Text;
    fEditFile.AlbumArtist := Edit_LibraryAlbumArtist.Text;
    fEditFile.Composer := Edit_LibraryComposer.Text;
    fEditFile.Genre  := CB_LibraryGenre.Text;
    fEditFile.Year   := Edit_LibraryYear.Text;
    fEditFile.Track := StrToIntDef(Edit_LibraryTrack.Text, 0);
    fEditFile.CD := Edit_LibraryCD.Text;
    // Change the TagObject as well
    ApplyEditFileToEditTag;
end;

procedure TFDetails.ApplyEditFileToEditTag;
var
  mp3File: TMP3File;
  oggFile: TOggVorbisFile;
  flacFile: TFlacFile;
  m4aFile: TM4aFile;
  apeFile: TBaseApeFile;
begin
    // Copy the Changes applied to the NempAudioFile into the current low-level-Tag-Object
    // Set the values only if there was a change, so that there are no unneccessary changes in the Frames (and in the File)
    if fEditTag.Artist <> fEditFile.Artist then fEditTag.Artist := fEditFile.Artist;
    if fEditTag.Title <> fEditFile.Titel then fEditTag.Title := fEditFile.Titel;
    if fEditTag.Album <> fEditFile.Album then fEditTag.Album := fEditFile.Album;
    if fEditTag.Genre <> fEditFile.Genre then fEditTag.Genre := fEditFile.Genre;
    if fEditTag.Year <> fEditFile.Year then  fEditTag.Year := fEditFile.Year;
    if fEditTag.Track <> IntToStrEmptyZero(fEditFile.Track) then fEditTag.Track := IntToStrEmptyZero(fEditFile.Track);

    case fEditTag.FileType of
        at_Mp3: begin
                    mp3File := TMP3File(fEditTag);

                    if (mp3File.Comment <> fEditFile.Comment) then
                      mp3File.Comment := fEditFile.Comment;

                    // The following properties actually need the ID3v2Tag in the File.
                    // EnsureID3v2Exists will copy the basic values into the v2Tag, if it doesn't already exist.
                    // If a value is set to '', and the ID3v2Tag does NOT exist already, it will not be written into the file
                    // If a value is set to '', and the ID3v2Tag DOES exist already, the frame will be removed from the tag
                    // (the same is true for the APETag

                    if fEditFile.AlbumArtist <> '' then
                      fEditFile.EnsureID3v2Exists(mp3File);
                    if fEditTag.AlbumArtist <> fEditFile.AlbumArtist then
                      fEditTag.AlbumArtist := fEditFile.AlbumArtist;

                    // Composer
                    if fEditFile.Composer <> '' then
                      fEditFile.EnsureID3v2Exists(mp3File);
                    if mp3File.ID3v2Tag.Composer <> fEditFile.Composer then
                      mp3File.ID3v2Tag.Composer := fEditFile.Composer;
                    if mp3file.ApeTag.Composer <> fEditFile.Composer then
                      mp3file.ApeTag.Composer := fEditFile.Composer;

                    // CD
                    if fEditFile.CD <> '' then
                      fEditFile.EnsureID3v2Exists(mp3File);
                    if mp3File.ID3v2Tag.GetText(IDv2_PARTOFASET) <> fEditFile.CD then
                      mp3File.ID3v2Tag.SetText(IDv2_PARTOFASET, fEditFile.CD);
                    if mp3file.ApeTag.GetValueByKey(APE_DISCNUMBER) <> fEditFile.CD then
                      mp3file.ApeTag.SetValueByKey(APE_DISCNUMBER, fEditFile.CD);
        end;

        at_Ogg: begin
                    fEditTag.AlbumArtist := fEditFile.AlbumArtist;
                    oggFile := TOggVorbisFile(fEditTag);
                    oggFile.SetPropertyByFieldname(VORBIS_COMMENT, fEditFile.Comment);
                    oggFile.SetPropertyByFieldname(VORBIS_DISCNUMBER, fEditFile.CD);
                    oggFile.SetPropertyByFieldname(VORBIS_COMPOSER, fEditFile.Composer);
        end;

        at_Flac: begin
                    fEditTag.AlbumArtist := fEditFile.AlbumArtist;
                    flacFile := TFlacFile(fEditTag);
                    flacFile.SetPropertyByFieldname(VORBIS_COMMENT, fEditFile.Comment);
                    flacFile.SetPropertyByFieldname(VORBIS_DISCNUMBER, fEditFile.CD);
                    flacFile.SetPropertyByFieldname(VORBIS_COMPOSER, fEditFile.Composer);
        end;

        at_M4A: begin
                    fEditTag.AlbumArtist := fEditFile.AlbumArtist;
                    m4aFile := TM4aFile(fEditTag);
                    m4aFile.Comment := fEditFile.Comment;
                    m4aFile.Disc := fEditFile.CD;
                    m4aFile.Composer := fEditFile.Composer;
        end;

        at_Monkey,
        at_WavPack,
        at_MusePack,
        at_OptimFrog,
        at_TrueAudio: begin
                    fEditTag.AlbumArtist := fEditFile.AlbumArtist;
                    apeFile := TBaseApeFile(fEditTag);
                    apeFile.ApeTag.SetValueByKey(APE_COMMENT, fEditFile.Comment);
                    apeFile.ApeTag.SetValueByKey(APE_DISCNUMBER, fEditFile.CD);
                    apeFile.ApeTag.Composer := fEditFile.Composer;
        end;
        at_Wma: ;
        at_Wav: ;
        at_Invalid: ;
    end;
end;


procedure TFDetails.ApplyRatingToAudioFile(newRating: Byte);
var
  mp3File: TMP3File;
  oggFile: TOggVorbisFile;
  flacFile: TFlacFile;
  m4aFile: TM4aFile;
  apeFile: TBaseApeFile;
begin
  fEditFile.Rating := newRating;

  case fEditTag.FileType of
    at_Mp3: begin
                mp3File := TMP3File(fEditTag);
                fEditFile.EnsureID3v2Exists(mp3File);
                // This will automatically delete the frame, if both values are 0
                mp3File.ID3v2Tag.Rating := fEditFile.Rating;
                mp3File.ID3v2Tag.PlayCounter := fEditFile.PlayCounter;
    end;

    at_Ogg: begin
                oggFile := TOggVorbisFile(fEditTag);
                // Empty values (= '') will delete the field from the Tag
                oggFile.SetPropertyByFieldname(VORBIS_RATING   , IntToStrEmptyZero(fEditFile.Rating) );
                oggFile.SetPropertyByFieldname(VORBIS_PLAYCOUNT, IntToStrEmptyZero(fEditFile.PlayCounter));
    end;

    at_Flac: begin
                flacFile := TFlacFile(fEditTag);
                flacFile.SetPropertyByFieldname(VORBIS_RATING   , IntToStrEmptyZero(fEditFile.Rating) );
                flacFile.SetPropertyByFieldname(VORBIS_PLAYCOUNT, IntToStrEmptyZero(fEditFile.PlayCounter));
    end;

    at_M4A: begin
                m4aFile := TM4aFile(fEditTag);
                m4aFile.SetSpecialData(DEFAULT_MEAN, M4ARating     , IntToStrEmptyZero(fEditFile.Rating));
                m4aFile.SetSpecialData(DEFAULT_MEAN, M4APlayCounter, IntToStrEmptyZero(fEditFile.PlayCounter));
    end;

    at_Monkey,
    at_WavPack,
    at_MusePack,
    at_OptimFrog,
    at_TrueAudio: begin
                apeFile := TBaseApeFile(fEditTag);
                apeFile.ApeTag.SetValueByKey(APE_RATING   , IntToStrEmptyZero(fEditFile.Rating) );
                apeFile.ApeTag.SetValueByKey(APE_PLAYCOUNT, IntToStrEmptyZero(fEditFile.PlayCounter));
    end;
    at_Wma: ;
    at_Wav: ;
    at_Invalid: ;
  end;
end;

procedure TFDetails.ApplyLyricsToAudioFile;
var
  mp3File: TMP3File;
begin
  fEditFile.Lyrics := UTF8String(Trim(Memo_Lyrics.Text));

  case fEditTag.FileType of
        at_Mp3: begin
                    mp3File := TMP3File(fEditTag);
                    // Lyrics (no default-lyrics in APE-Tag, skip that)
                    if fEditFile.Lyrics <> '' then
                      fEditFile.EnsureID3v2Exists(mp3File);
                    if mp3File.ID3v2Tag.Lyrics <> string(fEditFile.Lyrics) then
                      mp3File.ID3v2Tag.Lyrics := string(fEditFile.Lyrics);
        end;

        at_Ogg: TOggVorbisFile(fEditTag).SetPropertyByFieldname(VORBIS_LYRICS, string(fEditFile.Lyrics));
        at_Flac: TFlacFile(fEditTag).SetPropertyByFieldname(VORBIS_LYRICS, string(fEditFile.Lyrics));
        at_M4A: TM4aFile(fEditTag).Lyrics := string(fEditFile.Lyrics);

        at_Monkey,
        at_WavPack,
        at_MusePack,
        at_OptimFrog,
        at_TrueAudio: TBaseApeFile(fEditTag).ApeTag.SetValueByKey(APE_LYRICS, string(fEditFile.Lyrics));

        at_Wma: ;
        at_Wav: ;
        at_Invalid: ;
    end;
end;

procedure TFDetails.ApplyExtendedTagsToAudioFile;
var s: UTF8String;
    ms: TMemoryStream;
begin
    case fEditTag.FileType of
        at_Mp3: begin

                    if self.lb_Tags.Items.Count > 0 then
                    begin
                        // Ensure that ID3v2Tag exists and set PrivateFrame with "Tags"
                        fEditFile.EnsureID3v2Exists(TMP3File(fEditTag));
                        s := Utf8String(Trim(lb_Tags.Items.Text));
                        if length(s) > 0 then
                        begin
                            ms := TMemoryStream.Create;
                            try
                                ms.Write(s[1], length(s));
                                TMP3File(fEditTag).ID3v2Tag.SetPrivateFrame('NEMP/Tags', ms);
                            finally
                                ms.Free;
                            end;
                        end else
                            // delete Tags-Frame, if there are none
                            TMP3File(fEditTag).ID3v2Tag.SetPrivateFrame('NEMP/Tags', NIL);
                    end else
                    begin
                        // If ID3v2Tag exists, remove "Tags", if the user removed all of them
                        if TMP3File(fEditTag).ID3v2Tag.Exists then
                            TMP3File(fEditTag).ID3v2Tag.SetPrivateFrame('NEMP/Tags', NIL);
                    end;
        end;

        at_Ogg:     TOggVorbisFile(fEditTag).SetPropertyByFieldname(VORBIS_CATEGORIES, Trim(lb_Tags.Items.Text));
        at_Flac:    TFlacFile(fEditTag).SetPropertyByFieldname(VORBIS_CATEGORIES, Trim(lb_Tags.Items.Text));
        at_M4A:     TM4aFile(fEditTag).Keywords := Trim(lb_Tags.Items.Text);
        at_Monkey,
        at_WavPack,
        at_MusePack,
        at_OptimFrog,
        at_TrueAudio: TBaseApeFile(fEditTag).ApeTag.SetValueByKey(APE_CATEGORIES, Trim(lb_Tags.Items.Text));
        at_Wma: ;
        at_Wav: ;
        at_Invalid: ;
    end;
end;

procedure TFDetails.MetaDataFramesToAudioFile;
begin
  fEditFile.GetAudioData(fEditTag);
end;


{
    --------------------------------------------------------
    AudioFileToEdits
    - Display the properties of the fEditFile in the GUI
    --------------------------------------------------------
}
procedure TFDetails.UpdateRatingGUI(ValuesAreSynched: Boolean = False);
begin
  DetailRatingHelper.DrawRatingInStarsOnBitmap(fEditFile.Rating, IMG_LibraryRating.Picture.Bitmap, IMG_LibraryRating.Width, IMG_LibraryRating.Height);
  LblPlayCounter.Caption := Format(DetailForm_PlayCounter, [fEditFile.PlayCounter]);

  if ValuesAreSynched then begin
    fRatingsAreSynched := True;
    ActionSynchronizeRating.Enabled := False;
  end;
end;

procedure TFDetails.ShowMainProperties;
begin
  // Fill Edits with properties of the AudioFile
  case fEditFile.AudioType of
    at_File: begin
        Edit_LibraryArtist   .Text := fEditFile.Artist ;
        Edit_LibraryTitle    .Text := fEditFile.Titel ;
        Edit_LibraryAlbum    .Text := fEditFile.Album ;
        Edit_LibraryYear     .Text := fEditFile.Year ;
        Edit_LibraryComment  .Text := fEditFile.Comment ;
        Edit_LibraryAlbumArtist.Text := fEditFile.AlbumArtist;
        Edit_LibraryComposer .Text := fEditFile.Composer;
        Edit_LibraryTrack    .Text := IntToStr(fEditFile.Track);
        Edit_LibraryCD       .Text := fEditFile.CD ;
        // Genre
        CB_LibraryGenre      .Text := fEditFile.Genre;
        // Rating and PlayCounter
        UpdateRatingGUI;
        // Additional Tags for TagCloud
        lb_Tags.Items.Text := String(fEditFile.RawTagLastFM);
        // replayGain Values
        if fEditFile.TrackGain = 0 then
            LblReplayGainTitle.Caption := 'N/A'
        else
            LblReplayGainTitle.Caption := Format((rsFormatReplayGainTrack_WithPeak), [fEditFile.TrackGain, fEditFile.TrackPeak]);
        if fEditFile.AlbumGain = 0 then
            LblReplayGainAlbum.Caption := 'N/A'
        else
            LblReplayGainAlbum.Caption := Format((rsFormatReplayGainAlbum_WithPeak), [fEditFile.AlbumGain, fEditFile.AlbumPeak]);
    end;
    at_CDDA: begin
          Edit_LibraryArtist   .Text := fEditFile.Artist ;
          Edit_LibraryTitle    .Text := fEditFile.Titel ;
          Edit_LibraryAlbum    .Text := fEditFile.Album ;
          Edit_LibraryYear     .Text := fEditFile.Year ;
          Edit_LibraryComment  .Text := ''; // fEditFile.Comment;
          Edit_LibraryAlbumArtist.Text := '';
          Edit_LibraryComposer .Text := '';
          Edit_LibraryTrack    .Text := IntToStr(fEditFile.Track);
          Edit_LibraryCD       .Text := '';
          CB_LibraryGenre      .Text := fEditFile.Genre;
          lb_Tags.Items.Text := '';
          // Rating and PlayCounter
          LblPlayCounter.Caption := '';
          DetailRatingHelper.DrawRatingInStarsOnBitmap(0, IMG_LibraryRating.Picture.Bitmap, IMG_LibraryRating.Width, IMG_LibraryRating.Height);
          // ReplayGain
          LblReplayGainTitle  .Caption := 'N/A';
          LblReplayGainAlbum  .Caption := 'N/A';
    end;
  else
    begin
        Edit_LibraryArtist   .Text := '';
        Edit_LibraryTitle    .Text := '';
        Edit_LibraryAlbum    .Text := '';
        Edit_LibraryYear     .Text := '';
        Edit_LibraryComment  .Text := '';
        Edit_LibraryAlbumArtist.Text := '';
        Edit_LibraryComposer .Text := '';
        Edit_LibraryTrack    .Text := '';
        Edit_LibraryCD       .Text := '';

        lb_Tags.Items.Text := '';
        // Genre
        CB_LibraryGenre      .Text := '';
        // Rating and PlayCounter
        LblPlayCounter.Caption := '';
        DetailRatingHelper.DrawRatingInStarsOnBitmap(0, IMG_LibraryRating.Picture.Bitmap, IMG_LibraryRating.Width, IMG_LibraryRating.Height);
        // ReplayGain
        LblReplayGainTitle  .Caption := 'N/A';
        LblReplayGainAlbum  .Caption := 'N/A';
    end;
  end;
end;

procedure TFDetails.ShowLyrics;
begin
    {
      Lyrics may NOT be stored in the media library, and therefore not in the fEditFile-Object
      Therefore: Use the fEditTag-Object here to display the Lyrics
    }
    case fEditTag.FileType of
        at_Mp3: Memo_Lyrics.Text := TMP3File(fEditTag).ID3v2Tag.Lyrics;
        at_Ogg: Memo_Lyrics.Text := TOggVorbisFile(fEditTag).GetPropertyByFieldname(VORBIS_LYRICS);
        at_Flac: Memo_Lyrics.Text := TFlacFile(fEditTag).GetPropertyByFieldname(VORBIS_LYRICS);
        at_M4A: Memo_Lyrics.Text := TM4aFile(fEditTag).Lyrics;
        at_Monkey,
        at_WavPack,
        at_MusePack,
        at_OptimFrog,
        at_TrueAudio: Memo_Lyrics.Text := TBaseApeFile(fEditTag).ApeTag.GetValueByKey(APE_LYRICS);
    else
        Memo_Lyrics.Text := '';
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
  OldCoverID := fOriginalFileCopy.CoverID;

  fEditFile.CoverID := NewLibraryCoverID;
  //  Change also all the files in the library
  //  Note: Setting the Value to CurrentAudioFile is still useful, as this file may be in the Playlist only
  if cbChangeCoverArt.ItemIndex > 0 then
  begin
      ///  We don't need to do a InitCover for the currentAudioFile,
      ///  but we may need it for the other files with the oldCoverID, as
      ///  they may have been grouped together by the same User-CoverID before.
      ///  Now they should be separated again, if needed.
      CoverArtSearcher.StartNewSearch;
      CoverIDFiles := TAudioFileList.create(False);
      try
          // get the list of files which need to be changed
          case cbChangeCoverArt.ItemIndex of
              1: MedienBib.GetTitelListFromCoverIDUnsorted(CoverIDFiles, OldCoverID);
              2: MedienBib.GetTitelListFromDirectoryUnsorted(CoverIDFiles, fEditFile.Ordner);
          end;

          for i := 0 to CoverIDFiles.Count - 1 do
          begin
              loopAudioFile := CoverIDFiles[i];
              loopAudioFile.CoverID := NewLibraryCoverID_FileSave;

              aErr := loopAudioFile.WriteUserCoverIDToMetaData(AnsiString(NewLibraryCoverID_FileSave), True);
              if aErr <> AUDIOERR_None then
                  HandleError(afa_EditingDetails, loopAudioFile, aErr, True);

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
    if not fDataChanged then
        // nothing to do
        exit;

    // If the Item has been Niled by the User (i.e. new value = ''), then
    // we should remove the matching Frame/MetaAtom from the inner Tag structure.
    // For Ogg/Flac/Ape, this is not necessary, as we just work with "KEY=VALUE"
    // items there.
    if (fEditTag.FileType = at_Mp3) OR (fEditTag.FileType = at_M4A) then
    begin
        aNode := VST_MetaData.GetFirst;
        while assigned(aNode) do
        begin
            aTagEditItem := VST_MetaData.GetNodeData<TTagEditItem>(aNode);

            if aTagEdititem.fNiledByUser then
            begin
                nextNode := VST_MetaData.GetNext(aNode);

                if fEditTag.FileType = at_Mp3 then
                    TMP3File(fEditTag).ID3v2Tag.DeleteFrame(aTagEdititem.ID3v2Frame);

                if fEditTag.FileType = at_M4A then
                    TM4aFile(fEditTag).RemoveMetaAtom(aTagEditItem.MetaAtom);

                VST_MetaData.DeleteNode(aNode);
                aNode := nextNode;
            end else
                aNode := VST_MetaData.GetNext(aNode);
        end;
    end;
end;

{
    --------------------------------------------------------
    BtnApplyClick
    BtnUndoClick
    Btn_CloseClick
    - EventHandler for the three buttons on bottom of the form
    --------------------------------------------------------
}
procedure TFDetails.BtnApplyClick(Sender: TObject);
var
  aErr: TNempAudioError;
begin
    if not fEditTag.Valid then
        Exit;

    if (MedienBib.StatusBibUpdate > 1) or (MedienBib.CurrentThreadFilename = fEditFile.Pfad) then begin
        ///  If we just want to edit one file, it is ok to do it, unless
        ///  a working thread is editing just this very file in this very moment,
        ///  or the library is in a critical phase of an update
        TranslateMessageDLG((Warning_MedienBibIsBusyCritical), mtWarning, [MBOK], 0);
        exit;
    end;

    if (CoverArtHasChanged and (cbChangeCoverArt.ItemIndex > 0))
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

    // synchronize Library-Rating with Tag-Rating automatically
    // all other Edits are already applied to the fEditFile and the fEditTag
    if not fRatingsAreSynched then
      ActionSynchronizeRating.Execute;

    // remove some ID3v2Frames or M4A-Atoms, if needed
    RemoveNiledFrames;
    aErr := AudioToNempAudioError(fEditTag.UpdateFile);

    if aErr <> AUDIOERR_None then begin
        TranslateMessageDLG(NempAudioErrorString[aErr], mtWarning, [MBOK], 0);
        HandleError(afa_EditingDetails, fEditFile, aErr, True);
    end;

    if CoverArtHasChanged then
      ApplyCoverIDChanges;

    // Show the Refresh-Coverflow-Button, if CoverArt has been changed
    if CoverArtHasChanged AND (MedienBib.BrowseMode = 1) then
        BtnRefreshCoverflow.Visible := True;

    fDataChanged := False;
    CoverArtHasChanged := False;

    // Mark Collections in MainWindow as "dirty", if needed
    CheckForChangedData(fOriginalFileCopy);
    // Synch other files
    SyncFilesAfterEdit;
end;

procedure TFDetails.BtnUndoClick(Sender: TObject);
begin
  // assign the OriginalFileCopy
  fEditFile.Assign(fOriginalFileCopy);

  // init the currenttagObject
  // - display the Warning-Panel if the file is Not Valid
  // - Activate/Deactivate Tab-Pages for Non-File-Objects (webstream, CDDA)
  InitCurrentTagObject;

  // show file information again
  ShowDetails(fEditFile);
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


procedure TFDetails.MainPageControlChange(Sender: TObject);
begin
  if (MainPageControl.ActivePage = Tab_Pictures) and (NOT PicturesLoaded) then begin
    PicturesLoaded := True;
    ShowCoverArt;
  end;
end;


{$REGION 'Small Supporting methods, little QoL-Features'}

procedure TFDetails.RefreshStarGraphics;
begin
  LoadStarGraphics(DetailRatingHelper);
  UpdateRatingGUI;
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
procedure TFDetails.ActionShowInExplorerExecute(Sender: TObject);
begin
  if DirectoryExists(fEditFile.Ordner) then
        ShellExecute(Handle, 'open' ,'explorer.exe'
        , Pchar('/e,/select,"'+fEditFile.Pfad+'"'), '', sw_ShowNormal);
end;

procedure TFDetails.ActionWindowsPropertiesExecute(Sender: TObject);
begin
  ShowFileProperties(Nemp_MainForm.Handle, pChar(fEditFile.Pfad),'');
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

procedure TFDetails.ActionTagAddExecute(Sender: TObject);
var newTagDummy: String;
    IgnoreWarningsDummy: Boolean;
begin
    if HandleSingleFileTagChange(fEditFile, '', newTagDummy, IgnoreWarningsDummy) then
        TagsHasChanged(lb_Tags.Items.Count-1);
end;

procedure TFDetails.ActionTagRemoveExecute(Sender: TObject);
var CurrentTagToChange: String;
    CurrentIdx: Integer;
begin
    CurrentIdx := lb_Tags.ItemIndex;
    if (MedienBib.StatusBibUpdate <= 1)
        and assigned(fEditFile)
        and (MedienBib.CurrentThreadFilename <> fEditFile.Pfad)
        and (CurrentIdx >= 0)
    then
    begin
        CurrentTagToChange := lb_Tags.Items[CurrentIdx];
        if fEditFile.RemoveTag(CurrentTagToChange) then
            TagsHasChanged(CurrentIdx);
    end;
end;


procedure TFDetails.ActionTagRenameExecute(Sender: TObject);
var newTagDummy, CurrentTagToChange: String;
    IgnoreWarningsDummy: Boolean;
    CurrentIdx: Integer;
begin
    CurrentIdx := lb_Tags.ItemIndex;
    if (MedienBib.StatusBibUpdate <= 1)
        and assigned(fEditFile)
        and (MedienBib.CurrentThreadFilename <> fEditFile.Pfad)
        and (CurrentIdx >= 0)
    then
    begin
        CurrentTagToChange := lb_Tags.Items[CurrentIdx];
        if HandleSingleFileTagChange(fEditFile, CurrentTagToChange, newTagDummy, IgnoreWarningsDummy) then
            TagsHasChanged(lb_Tags.Count - 1);
    end;
end;

procedure TFDetails.ActionTagGetLastFMExecute(Sender: TObject);
var s: String;
    TagPostProcessor: TTagPostProcessor;
begin
    fEditFile.RawTagLastFM := UTF8String(Trim(lb_Tags.Items.Text));

    TagPostProcessor := TTagPostProcessor.Create;
    try
        TagPostProcessor.LoadFiles;
        s := MedienBib.BibScrobbler.GetTags(fEditFile);
        if trim(s) = '' then
            TranslateMessageDLG(MediaLibrary_GetTagsFailed, mtInformation, [MBOK], 0)
        else
        begin
            // process new Tags. Rename, delete ignored and duplicates.
            MedienBib.AddNewTag(fEditFile, s, False);
            fDataChanged := True;
        end;

        // Show tags of temporary file in the memo
        lb_Tags.Items.Text := String(fEditFile.RawTagLastFM);
        ApplyExtendedTagsToAudioFile;
        ShowMetaDataFrames;
    finally
        TagPostProcessor.Free;
    end;
end;

procedure TFDetails.ActionTagOpenCloudEditorExecute(Sender: TObject);
begin
    if not assigned(CloudEditorForm) then
        Application.CreateForm(TCloudEditorForm, CloudEditorForm);
    CloudEditorForm.Show;
end;

// extended tags has changed
procedure TFDetails.TagsHasChanged(newIdx: Integer);
begin
    // refresh tags in the view
    if assigned(fEditFile) then begin
      lb_Tags.Items.Text := String(fEditFile.RawTagLastFM);
      ApplyExtendedTagsToAudioFile;
      ShowMetaDataFrames;

      if newIdx < 0 then
          newIdx := 0;
      if newIdx >= lb_Tags.Count then
          newIdx := lb_Tags.Count-1;

      if (newIdx < lb_Tags.Count) and (newIdx >= 0) then
          lb_Tags.Selected[newIdx] := True;

      fDataChanged := True;
    end;
end;

{$ENDREGION}


{$REGION 'Handling of Lyrics'}


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

procedure TFDetails.mmExtendedTagsClick(Sender: TObject);
begin
  if MainPageControl.ActivePage <> Tab_General then
    MainPageControl.ActivePage := Tab_General;
end;

procedure TFDetails.mmFileClick(Sender: TObject);
begin
  if MainPageControl.ActivePage <> Tab_General then
    MainPageControl.ActivePage := Tab_General;
end;

procedure TFDetails.mmLyricsClick(Sender: TObject);
begin
  if MainPageControl.ActivePage <> Tab_Lyrics then
    MainPageControl.ActivePage := Tab_Lyrics;
end;

procedure TFDetails.mmMetaDataClick(Sender: TObject);
begin
  if MainPageControl.ActivePage <> Tab_MetaData then
    MainPageControl.ActivePage := Tab_MetaData;
end;

procedure TFDetails.Memo_LyricsChange(Sender: TObject);
begin
    fDataChanged := True;
end;


procedure TFDetails.Memo_LyricsExit(Sender: TObject);
begin
  ApplyLyricsToAudioFile;
  ShowMetaDataFrames;
end;

procedure TFDetails.PrepareLyricSearchEngines;
var
  urlList: TStringList;
  i: Integer;
  aMenuItem: TMenuItem;
begin
  urlList := TStringList.Create;
  try
    TLyrics.GetLyricSources(urlList);

    for i := 0 to urlList.Count - 1 do begin
      aMenuItem := TMenuItem.Create(self);
      aMenuItem.AutoHotkeys := maManual;
      aMenuItem.OnClick := SelectLyricSourceClick;
      aMenuItem.Caption := urlList[i];
      aMenuItem.Tag := i;
      PM_SearchEngines.Items.Add(aMenuItem);
      // another copy for the MainMenu
      aMenuItem := TMenuItem.Create(self);
      aMenuItem.AutoHotkeys := maManual;
      aMenuItem.OnClick := SelectLyricSourceClick;
      aMenuItem.Caption := urlList[i];
      aMenuItem.Tag := i;
      mmLyrics.Add(aMenuItem);
    end;

    if NempOptions.PreferredLyricSearch >= urlList.Count then
      NempOptions.PreferredLyricSearch := 0;

    btnSearchLyrics.Tag := NempOptions.PreferredLyricSearch;
    btnSearchLyrics.Caption := urlList[NempOptions.PreferredLyricSearch];

  finally
    urlList.Free;
  end;
end;

procedure TFDetails.SelectLyricSourceClick(Sender: TObject);
begin
  btnSearchLyrics.Tag := (Sender as TMenuItem).Tag;
  btnSearchLyrics.Caption := (Sender as TMenuItem).Caption;
  NempOptions.PreferredLyricSearch := (Sender as TMenuItem).Tag;
  btnSearchLyrics.Click;
end;

procedure TFDetails.btnSearchLyricsClick(Sender: TObject);
var
  SearchURL: String;
begin
  SearchURL := TLyrics.GetLyricsURL(btnSearchLyrics.Tag, fEditFile.Artist, fEditFile.Titel);
  ShellExecute(Handle, 'open', PChar(SearchURL), nil, nil, SW_SHOW);
end;


procedure TFDetails.BtnLyricWikiClick(Sender: TObject);
//var Lyrics: TLyrics;
//    LyricString: String;
begin
  MessageDLG((MediaLibrary_SearchLyricsDisabled), mtInformation, [MBOK], 0);
  (*
  if CurrentTagObject.Valid then
  begin
      CurrentAudioFile.FileIsPresent:=True;
      Lyrics := TLyrics.Create;
      try
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
  *)
end;


{$ENDREGION}

procedure TFDetails.AddWantedTag(aTag: TMetaTag);
begin
  case fEditTag.FileType of
    at_Mp3: TMp3File(fEditTag).TagsToBeWritten := TMp3File(fEditTag).TagsToBeWritten + [aTag];

    at_Monkey,
    at_WavPack,
    at_MusePack,
    at_OptimFrog,
    at_TrueAudio: TBaseApeFile(fEditTag).TagsToBeWritten := TBaseApeFile(fEditTag).TagsToBeWritten + [aTag];
  end;
end;

procedure TFDetails.FrameBasedTagNeeded;
begin
  case fEditTag.FileType of
    at_Mp3: TMp3File(fEditTag).TagsToBeWritten := TMp3File(fEditTag).TagsToBeWritten + [mt_ID3v2];
    at_Monkey,
    at_WavPack,
    at_MusePack,
    at_OptimFrog,
    at_TrueAudio: TBaseApeFile(fEditTag).TagsToBeWritten := TBaseApeFile(fEditTag).TagsToBeWritten + [mt_APE];
  end;
end;

procedure TFDetails.SyncFilesAfterEdit;
var
  ListOfFiles: TAudioFileList;
  i: Integer;
begin
    fOriginalFileCopy.Assign(fEditFile);

    // Update other copies of this file
    ListOfFiles := TAudioFileList.Create(False);
    try
      GetListOfAudioFileCopies(fEditFile, ListOfFiles, False);
      for i := 0 to ListOfFiles.Count - 1 do
        ListOfFiles[i].Assign(fEditFile);
    finally
      ListOfFiles.Free;
    end;

    MedienBib.Changed := True;
    // Correct GUI, but do NOT include the Detailform (we already applied the cahnges here)
    CorrectVCLAfterAudioFileEdit(fEditFile, False);
end;


procedure TFDetails.CheckForChangedData(BackupFile: TAudioFile);
var
  CollectionDirty, SearchDirty: Boolean;
begin
  CollectionDirty := False;
  SearchDirty := False;
  // Check for relevant changes for the QuickSearch-String
  if (BackupFile.Artist <> fEditFile.Artist)
    or (BackupFile.Titel <> fEditFile.Titel)
    or (BackupFile.Album <> fEditFile.Album)
  then
    // Artist, Title and Album are handled the same for Searchstrings, so one test for all is enough
    // (they are all included, or Search is not accelerated at all)
    SearchDirty := SearchDirty or MedienBib.SearchStringIsDirty(colIdx_ARTIST);
  // other properties may be included or not
  if (BackupFile.Comment  <> fEditFile.Comment) then
    SearchDirty := SearchDirty or MedienBib.SearchStringIsDirty(colIdx_COMMENT);
  if (BackupFile.Genre  <> fEditFile.Genre) then
    SearchDirty := SearchDirty or MedienBib.SearchStringIsDirty(colIdx_GENRE);
  if (BackupFile.AlbumArtist  <> fEditFile.AlbumArtist) then
    SearchDirty := SearchDirty or MedienBib.SearchStringIsDirty(colIdx_ALBUMARTIST);
  if (BackupFile.Composer  <> fEditFile.Composer) then
    SearchDirty := SearchDirty or MedienBib.SearchStringIsDirty(colIdx_COMPOSER);

  // Check for relevant changes for the collections
  if (BackupFile.Artist <> fEditFile.Artist) or (BackupFile.AlbumArtist <> fEditFile.AlbumArtist) then
    CollectionDirty := CollectionDirty or MedienBib.CollectionsAreDirty(colIdx_ARTIST);
  if (BackupFile.Album <> fEditFile.Album) then
    CollectionDirty := CollectionDirty or MedienBib.CollectionsAreDirty(colIdx_ALBUM);
  if (BackupFile.Year <> fEditFile.Year) then
    CollectionDirty := CollectionDirty or MedienBib.CollectionsAreDirty(colIdx_YEAR);
  if (BackupFile.Genre <> fEditFile.Genre) then
    CollectionDirty := CollectionDirty or MedienBib.CollectionsAreDirty(colIdx_GENRE);
  if (BackupFile.RawTagLastFM <> fEditFile.RawTagLastFM) then
    CollectionDirty := CollectionDirty or MedienBib.CollectionsAreDirty(ccTagCloud);

  // Set Warning in BrowseTabs of the MainForm, if necessary
  if SearchDirty or CollectionDirty then
    SetBrowseTabWarning(True);
end;


function TFDetails.CheckRatings: Boolean;
var
  BibCounter, TagCounter: Cardinal;
  BibRating, TagRating: Byte;
begin
  BibRating := fEditFile.Rating;
  BibCounter := fEditFile.PlayCounter;
  TagRating := 0;
  TagCounter := 0;

  case fEditTag.FileType of
    at_Mp3: begin
      TagRating := TMP3File(fEditTag).ID3v2Tag.Rating;
      TagCounter := TMP3File(fEditTag).ID3v2Tag.PlayCounter;
    end;

    at_Ogg: begin
      TagRating := StrToIntDef(TOggVorbisFile(fEditTag).GetPropertyByFieldname(VORBIS_RATING), 0);
      TagCounter := StrToIntDef(TOggVorbisFile(fEditTag).GetPropertyByFieldname(VORBIS_PLAYCOUNT), 0);
    end;

    at_Flac: begin
      TagRating := StrToIntDef(TFlacFile(fEditTag).GetPropertyByFieldname(VORBIS_RATING), 0);
      TagCounter := StrToIntDef(TFlacFile(fEditTag).GetPropertyByFieldname(VORBIS_PLAYCOUNT), 0);
    end;

    at_M4A: begin
      TagRating := StrToIntDef(TM4aFile(fEditTag).GetSpecialData(DEFAULT_MEAN, M4ARating), 0);
      TagCounter := StrToIntDef(TM4aFile(fEditTag).GetSpecialData(DEFAULT_MEAN, M4APlayCounter), 0);
    end;

    at_Monkey,
    at_WavPack,
    at_MusePack,
    at_OptimFrog,
    at_TrueAudio: begin
      TagRating := StrToIntDef(TBaseApeFile(fEditTag).ApeTag.GetValueByKey(APE_RATING), 0);
      TagCounter := StrToIntDef(TBaseApeFile(fEditTag).ApeTag.GetValueByKey(APE_PLAYCOUNT), 0);
    end;
  end;

  result := (BibCounter = TagCounter) and (BibRating = TagRating);
end;

procedure TFDetails.GetRatingFromLibrary;
var
  bibFile: TAudioFile;
begin
  bibFile := MedienBib.GetAudioFileWithFilename(fEditFile.Pfad);
  if assigned(bibFile) then
  begin
    fOriginalFileCopy.Rating      := bibFile.Rating;
    fOriginalFileCopy.PlayCounter := bibFile.PlayCounter;
    fEditFile.Rating      := bibFile.Rating;
    fEditFile.PlayCounter := bibFile.PlayCounter;
  end
end;

procedure TFDetails.InitCurrentTagObject;
var aErr: TAudioError;
begin
    BtnApply.Enabled := fEditFile.IsFile AND FileExists(fEditFile.Pfad);
    BtnUndo.Enabled  := fEditFile.IsFile AND FileExists(fEditFile.Pfad);
    fDataChanged := False;

    if not FileExists(fEditFile.Pfad) then
    begin
        // File does not exist
        if assigned(fEditTag) then
            FreeAndNil(fEditTag);
        // set default values
        fEditTag := AudioFileFactory.CreateAudioFile(fEditFile.Pfad, True);
        CurrentTagObjectWriteAccessPossible := False;
    end
    else
    begin
        if assigned(fEditTag) then
          FreeAndNil(fEditTag);

        // initialise the CurrentTagObject from Filename
        fEditTag := AudioFileFactory.CreateAudioFile(fEditFile.Pfad, True);
        aErr := fEditTag.ReadFromFile(fEditFile.Pfad);

        if not fOriginalFileCopy.isCDDA then
          PnlWarnung.Visible := (not assigned(fEditTag)) or (not fEditTag.Valid)
        else
          PnlWarnung.Visible := False;

        if assigned(fEditTag) and fEditTag.Valid then
        begin
            case fEditTag.FileType of
                at_Mp3,
                at_Ogg,
                at_Flac,
                at_M4a,
                at_Monkey,
                at_WavPack,
                at_MusePack,
                at_OptimFrog,
                at_TrueAudio: CurrentTagObjectWriteAccessPossible := True;
            end;
        end;

        if (not fEditTag.Valid) then
        begin
            CurrentTagObjectWriteAccessPossible := False;
            case fEditTag.FileType of
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
                                Lbl_Warnings.Caption := (Warning_InvalidBaseApefile);
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

    Tab_MetaData  .TabVisible := fEditFile.IsFile AND CurrentTagObjectWriteAccessPossible;
    Tab_Lyrics    .TabVisible := fEditFile.IsFile AND CurrentTagObjectWriteAccessPossible;
    Tab_Pictures  .TabVisible := fEditFile.IsFile AND CurrentTagObjectWriteAccessPossible;

    mmExtendedTags.Enabled := fEditFile.IsFile AND CurrentTagObjectWriteAccessPossible;
    mmLyrics.Enabled   := fEditFile.IsFile AND CurrentTagObjectWriteAccessPossible;
    mmCoverArt.Enabled := fEditFile.IsFile AND CurrentTagObjectWriteAccessPossible;
    mmMetaData.Enabled := fEditFile.IsFile AND CurrentTagObjectWriteAccessPossible;
end;


{$REGION 'First Page: MediaLibrary Details. Reading/Writing on "AudioFile-Level", not on "Metadata-Level" }

{
    --------------------------------------------------------
    UpdateMediaBibEnabledStatus
    - (de)activate some MediaLibrary stuff
    --------------------------------------------------------
}
procedure TFDetails.UpdateMediaBibEnabledStatus;
var BasicInfoEnable, EditsAndButtonsEnable: Boolean;
begin
    BasicInfoEnable:= (fEditFile <> NIL);

    EditsAndButtonsEnable := assigned(fEditFile) AND (fEditFile.IsFile) AND FileExists(fEditFile.Pfad)
                            AND assigned(fEditTag) AND fEditTag.Valid
                            AND CurrentTagObjectWriteAccessPossible ;

    ActionShowInExplorer.Enabled := assigned(fEditFile) AND (fEditFile.IsFile) AND FileExists(fEditFile.Pfad);
    ActionWindowsProperties.Enabled := assigned(fEditFile) AND (fEditFile.IsFile) AND FileExists(fEditFile.Pfad);

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
    lblAlbumArtist  .Enabled := EditsAndButtonsEnable;
    lblComposer     .Enabled := EditsAndButtonsEnable;
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
    Edit_LibraryAlbumArtist.Enabled := EditsAndButtonsEnable;
    Edit_LibraryComposer .Enabled := EditsAndButtonsEnable;
    Edit_LibraryTrack    .Enabled := EditsAndButtonsEnable;
    Edit_LibraryCD       .Enabled := EditsAndButtonsEnable;
    IMG_LibraryRating    .Enabled := EditsAndButtonsEnable;
    CB_LibraryGenre      .Enabled := EditsAndButtonsEnable;

    lblConst_ReplayGain.Enabled := EditsAndButtonsEnable;
    LblReplayGainTitle .Enabled := EditsAndButtonsEnable;
    LblReplayGainAlbum .Enabled := EditsAndButtonsEnable;

    LblPlayCounter.Enabled := EditsAndButtonsEnable;
    ActionResetRating.Enabled := EditsAndButtonsEnable;

    fRatingsAreSynched := CheckRatings;
    ActionSynchronizeRating.Enabled := EditsAndButtonsEnable AND (not fRatingsAreSynched);
    ActionSynchronizeRating.Visible := EditsAndButtonsEnable AND (not fRatingsAreSynched);

    // Controls for TagCloud
    lb_Tags            .Enabled := EditsAndButtonsEnable;
    ActionTagAdd.Enabled := EditsAndButtonsEnable;
    ActionTagRename.Enabled := EditsAndButtonsEnable;
    ActionTagRemove.Enabled := EditsAndButtonsEnable;
    ActionTagGetLastFM.Enabled := EditsAndButtonsEnable;
    ActionTagOpenCloudEditor.Enabled := EditsAndButtonsEnable;
    // Main Controls
    BtnApply.Enabled := EditsAndButtonsEnable;
    BtnUndo.Enabled  := EditsAndButtonsEnable;
end;

procedure TFDetails.ShowMediaBibDetails;

    procedure LoadLibraryCoverIntoImage(dest: TImage);
    begin
        dest.Picture.Assign(Nil);
        dest.Refresh;
        dest.Picture.Bitmap.Width := dest.Width;
        dest.Picture.Bitmap.Height := dest.Height;
        // Get the picture (only using the *CoverID*.jpg)
        TCoverArtSearcher.GetCover_Fast(fEditFile, dest.Picture);
        dest.Picture.Assign(dest.Picture);
        dest.Refresh;
    end;

begin
        if not fEditFile.ReCheckExistence then
        begin
            Lbl_Warnings.Caption := (Warning_FileNotFound);
            Lbl_Warnings.Hint := (Warning_FileNotFound_Hint);
            PnlWarnung.Visible := True;
        end;

        LBLPfad.Caption := fEditFile.Ordner;
        LBLName.Caption := fEditFile.DateiName;
        if fEditFile.AudioType = at_Stream then
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

        case fEditFile.AudioType of
            at_File: begin
                    FDetails.Caption := Format('%s (%s)', [(DetailForm_Caption), fEditFile.Dateiname]);

                    if Not FileExists(fEditFile.Pfad) then
                        FDetails.Caption := FDetails.Caption + ' ' + DetailForm_Caption_FileNotFound
                    else
                        if FileIsWriteProtected(fEditFile.Pfad) then
                            FDetails.Caption := FDetails.Caption + ' ' + DetailForm_Caption_WriteProtected ;

                    // Size, Duration, Samplerate
                    LBLSize      .Caption := Format('%4.2f MB (%d Bytes)', [fEditFile.Size / 1024 / 1024, fEditFile.Size]);
                    LblDuration  .Caption := SekToZeitString(fEditFile.Duration);
                    LBLSamplerate.Caption := NempDisplay.DetailSummarySamplerate(fEditFile);

                    // Bitrate
                    if fEditFile.vbr then
                        LBLBitrate.Caption := Format('%d kbit/s (vbr)', [fEditFile.Bitrate])
                    else
                        LBLBitrate.Caption := Format('%d kbit/s', [fEditFile.Bitrate]);

                    // Audio Format (mp3, Flac, Ogg, ...)
                    if fEditTag.FileType = at_Invalid then
                        LblFormat.Caption := fEditFile.Extension
                    else
                        LblFormat.Caption := fEditTag.FileTypeDescription;
            end;

            at_Stream: begin
                    FDetails.Caption := Format('%s (%s)', [(DetailForm_Caption), fEditFile.Ordner]);
                    LBLSize      .Caption := '-';
                    LblDuration  .Caption := '-';
                    LBLBitrate   .Caption := inttostr(fEditFile.Bitrate) + ' kbit/s';
                    LBLSamplerate.Caption := '-';
                    LblFormat    .Caption := 'Webstream';
            end;

            at_CDDA: begin
                    FDetails.Caption := Format('%s (%s)', [(DetailForm_Caption), fEditFile.Dateiname]);
                    LBLSize      .Caption := '';
                    LblDuration  .Caption  := SekToZeitString(fEditFile.Duration);
                    LBLBitrate   .Caption := '1.4 mbit/s (CD-Audio)';
                    LBLSamplerate.Caption := '44.1 kHz, Stereo';
                    LblFormat    .Caption := 'Compact Disc Digital Audio';
            end;
        end;

        LoadLibraryCoverIntoImage(CoverLibrary1);
        LoadLibraryCoverIntoImage(CoverLibrary2);

        NewLibraryCoverID := fEditFile.CoverID;
        NewLibraryCoverID_FileSave := fEditFile.CoverID;
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
  ApplyRatingToAudioFile(DetailRatingHelper.MousePosToRating(x, 70));

  // Update GUI
  UpdateRatingGUI(True);
  fDataChanged := True;
end;

procedure TFDetails.IMG_LibraryRatingMouseLeave(Sender: TObject);
begin
  if IMG_LibraryRating.Enabled then
    DetailRatingHelper.DrawRatingInStarsOnBitmap(fEditFile.Rating, (Sender as TImage).Picture.Bitmap, (Sender as TImage).Width, (Sender as TImage).Height);
end;

procedure TFDetails.ActionResetRatingExecute(Sender: TObject);
begin
  if fEditFile.PlayCounter > 20 then begin
    if TranslateMessageDLG(Format(DetailForm_HighPlayCounter,[fEditFile.PlayCounter]), mtConfirmation, [MBOk, MBCancel], 0, mbCancel)
          = mrCancel then EXIT;
  end;
  // Set Rating/Playounter to 0
  fEditFile.PlayCounter := 0;
  ApplyRatingToAudioFile(0);
  // Update GUI
  UpdateRatingGUI(True);
  fDataChanged := True;
end;

procedure TFDetails.ActionSynchronizeRatingExecute(Sender: TObject);
begin
  ApplyRatingToAudioFile(fEditFile.Rating);
  // Update GUI
  UpdateRatingGUI(True);
  fDataChanged := True;
end;

procedure TFDetails.EditLibraryChange(Sender: TObject);
begin
  fDataChanged := True;
end;

procedure TFDetails.Edit_LibraryExit(Sender: TObject);
begin
  ApplyEditsToAudioFile;
  ShowMetaDataFrames;
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

    fDataChanged := True;

    case aTagEditItem.TagType of
        TT_ID3v2: begin
            AddWantedTag(mt_ID3v2);
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
            TOggVorbisFile(fEditTag).SetPropertyByFieldname(
                VST_MetaData.GetNodeData<TTagEditItem>(Node).KeyDescription,
                NewText);
        end;

        TT_Flac: begin
            TFlacFile(fEditTag).SetPropertyByFieldname(
                VST_MetaData.GetNodeData<TTagEditItem>(Node).KeyDescription,
                NewText);
        end;

        TT_Ape: begin
            AddWantedTag(mt_APE);
            case fEditTag.FileType of
              at_Invalid: ;
              at_Mp3: TMp3File(fEditTag).ApeTag.SetValueByKey(
                    AnsiString(VST_MetaData.GetNodeData<TTagEditItem>(Node).KeyDescription),
                    NewText);
              at_Ogg: ;
              at_Flac: ;
              at_M4A: ;
              at_Monkey,
              at_WavPack,
              at_MusePack,
              at_OptimFrog,
              at_TrueAudio: TBaseApeFile(fEditTag).ApeTag.SetValueByKey(
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

    MetaDataFramesToAudioFile;
    ShowMainProperties;
end;

procedure TFDetails.ActionMetaNewFrameExecute(Sender: TObject);
begin
  if not assigned(NewMetaFrameForm) then
    Application.CreateForm(TNewMetaFrameForm, NewMetaFrameForm);

  NewMetaFrameForm.CurrentTagObject := self.fEditTag;
  // Show "new-Frame"-input and show new frameset
  if NewMetaFrameForm.ShowModal = MrOK then begin
    case NewMetaFrameForm.SelectedTagType of
      TT_ID3v2: AddWantedTag(mt_ID3v2);
      TT_Ape: AddWantedTag(mt_APE);
    end;
    ShowMetaDataFrames;
    fDataChanged := True;
    MetaDataFramesToAudioFile;
    ShowMainProperties;
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

    if not assigned(fEditFile) then
        exit;
    if not assigned(fEditTag) then
        exit;
    if not FileExists(fEditFile.Pfad) then
        exit;

    // show the ID3v1-Box only for MP3-Files
    Pnl_ID3v1_MPEG.Visible := fEditTag.FileType in [at_Mp3, at_Monkey, at_WavPack, at_MusePack, at_OptimFrog, at_TrueAudio];
    GrpBox_Mpeg.Visible := (fEditTag.FileType = at_Mp3);

    case fEditTag.FileType of
          at_Mp3: begin
                      mp3File := TMp3File(fEditTag);

                      if (mp3File.ApeTag.Exists) or (mt_APE in mp3File.TagsToBeWritten) then
                        GrpBox_TextFrames.Caption := Format('ID3v2-Tag (Version 2.%d.%d), APE-Tag (Version %d.000)', [mp3File.id3v2Tag.Version.Major, mp3File.id3v2Tag.Version.Minor, mp3File.ApeTag.Version])
                      else
                        GrpBox_TextFrames.Caption := Format('ID3v2-Tag (Version 2.%d.%d)', [mp3File.id3v2Tag.Version.Major, mp3File.id3v2Tag.Version.Minor]);

                      mp3File.ID3v1Tag.AutoCorrectCodepage := NempCharCodeOptions.AutoDetectCodePage;
                      mp3File.ID3v2Tag.AutoCorrectCodepage := NempCharCodeOptions.AutoDetectCodePage;

                      ShowID3v1Details(mp3File.ID3v1Tag);

                      if fEditTag.Valid then
                      begin
                          if (mp3File.ID3v2Tag.Exists) or (mt_ID3v2 in mp3File.TagsToBeWritten) then begin
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
                          end;

                          if (mp3File.ApeTag.Exists) or (mt_APE in mp3File.TagsToBeWritten) then
                            FillApeFrames(Mp3File.ApeTag);

                      end else
                      begin
                          Lbl_Warnings.Caption := (Warning_InvalidMp3file);
                          Lbl_Warnings.Hint    := (Warning_InvalidMp3file_Hint);
                          PnlWarnung.Visible   := True;
                      end;

                      if NempCharCodeOptions.  AutoDetectCodePage then
                      begin
                          mp3File.ID3v1Tag.CharCode := GetCodepage(fEditFile.Pfad, NempCharCodeOptions);
                          mp3File.ID3v2Tag.CharCode := mp3File.ID3v1Tag.CharCode;
                      end; //else: keep default values, nothing to do
                      mp3File.ID3v1Tag.AutoCorrectCodepage := NempCharCodeOptions.AutoDetectCodePage;
                      mp3File.ID3v2Tag.AutoCorrectCodepage := NempCharCodeOptions.AutoDetectCodePage;
                  end;
          at_Ogg: begin
                      oggFile := TOggVorbisFile(fEditTag);
                      GrpBox_TextFrames.Caption := 'Vorbis-Comments';

                      if fEditTag.Valid then
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
                        flacFile := TFlacFile(fEditTag);
                        GrpBox_TextFrames.Caption := 'Vorbis-Comments';

                        if fEditTag.Valid then
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
                        m4aFile := TM4aFile(fEditTag);
                        GrpBox_TextFrames.Caption := 'iTunes-Tags';

                        if fEditTag.Valid then
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
                        apeFile := TBaseApeFile(fEditTag);
                        GrpBox_TextFrames.Caption := 'APEv2-Tags';

                        ShowID3v1Details(apeFile.ID3v1Tag);
                        if fEditTag.Valid then
                            FillApeFrames(apeFile.ApeTag);
                    end;

          at_Invalid,
          at_Wma,
          at_Wav: ; // nothing to do
      end;


      VST_MetaData.SortTree(0, sdAscending);
      ActionMetaCopyFromID3v1.Enabled := fEditTag.FileType in [at_Mp3, at_Monkey, at_WavPack, at_MusePack, at_OptimFrog, at_TrueAudio];
      ActionMetaCopyFromID3v2.Enabled := fEditTag.FileType in [at_Mp3, at_Monkey, at_WavPack, at_MusePack, at_OptimFrog, at_TrueAudio];
      case fEditTag.FileType of
        at_Mp3: ActionMetaCopyFromID3v1.Enabled := TMp3File(fEditTag).ID3v1Tag.TagExists;
        at_Monkey,
        at_WavPack,
        at_MusePack,
        at_OptimFrog,
        at_TrueAudio: ActionMetaCopyFromID3v1.Enabled := TBaseApeFile(fEditTag).ID3v1Tag.TagExists;
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



procedure TFDetails.ActionMetaCopyFromID3v1Execute(Sender: TObject);
var success: Boolean;
begin
  if (not fEditTag.Valid) then
        exit;

    case fEditTag.FileType of
        at_Mp3: begin
            success := True;
            AddWantedTag(mt_ID3v2);
            FillTagWithID3v1Values(TMp3File(fEditTag).ID3v2Tag);
            if TMp3File(fEditTag).ApeTag.Exists then
                FillTagWithID3v1Values(TMp3File(fEditTag).ApeTag);
        end;

        at_Monkey,
        at_WavPack,
        at_MusePack,
        at_OptimFrog,
        at_TrueAudio: begin
            success := True;
            AddWantedTag(mt_APE);
            FillTagWithID3v1Values(TBaseApeFile(fEditTag).ApeTag);
        end;
    else
        success := False;
    end;
    if success then begin
        // add/edit the List of MetaFrames
        ShowMetaDataFrames;
        fDataChanged := True;
    end;
end;

procedure TFDetails.Fillv1TagWithTagValues(Source: TID3v2Tag; Dest: TID3v1Tag);
var idx: Integer;
begin
    fDataChanged := True;
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
end;
procedure TFDetails.Fillv1TagWithTagValues(Source: TApeTag; Dest: TID3v1Tag);
begin
    fDataChanged := True;
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
end;

procedure TFDetails.ActionMetaCopyFromID3v2Execute(Sender: TObject);
var mp3: TMp3File;
    ApeFile: TBaseApeFile;
begin
  if (not fEditTag.Valid) then
        exit;

    case fEditTag.FileType of
        at_Mp3: begin
            mp3 := TMp3File(fEditTag);
            if mp3.ApeTag.Exists then
              Fillv1TagWithTagValues(mp3.ApeTag, mp3.ID3v1Tag);
            // ID3v2Tag has higher Priority
            Fillv1TagWithTagValues(mp3.ID3v2Tag, mp3.ID3v1Tag);
            AddWantedTag(mt_ID3v1);
            fDataChanged := True;
        end;
        at_Monkey,
        at_WavPack,
        at_MusePack,
        at_OptimFrog,
        at_TrueAudio: begin
            ApeFile := TBaseApeFile(fEditTag);
            Fillv1TagWithTagValues(ApeFile.ApeTag, ApeFile.ID3v1Tag);
            AddWantedTag(mt_ID3v1);
            fDataChanged := True;
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

procedure TFDetails.edtID3v1Change(Sender: TObject);
begin
  if (Sender as TEdit).Modified then begin
    fDataChanged := True;
    AddWantedTag(mt_ID3v1);
  end;
end;

procedure TFDetails.edtID3v1Exit(Sender: TObject);
var ID3v1Tag: TID3v1Tag;
begin
    if not fEditTag.Valid then
        exit;

    ID3v1Tag := GetID3v1TagfromBaseAudioFile(fEditTag);
    if assigned(ID3v1Tag) then begin
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

    MetaDataFramesToAudioFile;
    ShowMainProperties;
end;

procedure TFDetails.cbIDv1GenresChange(Sender: TObject);
var ID3v1Tag: TID3v1Tag;
begin
    if not fEditTag.Valid then
        exit;
    ID3v1Tag := GetID3v1TagfromBaseAudioFile(fEditTag);
    if assigned(ID3v1Tag) then begin
      Id3v1Tag.Genre := cbIDv1Genres.Text;
      fDataChanged := True;
      AddWantedTag(mt_ID3v1);
    end;
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

      ID3v1Tag := GetID3v1TagfromBaseAudioFile(fEditTag);
      if assigned(ID3v1Tag) then begin
        Id3v1Tag.Track := Lblv1Track.Text;
        fDataChanged := True;
        AddWantedTag(mt_ID3v1);
      end;
    end;
  end;
end;

procedure TFDetails.Lblv1YearChange(Sender: TObject);
var ID3v1Tag: TID3v1Tag;
begin
  if NOT Lblv1Artist.ReadOnly then
  begin
    if (Sender as TEdit).Modified then
    begin
      if IsValidYearString(Lblv1Year.Text) then
        Lblv1Year.Font.Color := clWindowText
      else
        Lblv1Year.Font.Color := clRed;

      ID3v1Tag := GetID3v1TagfromBaseAudioFile(fEditTag);
      if assigned(ID3v1Tag) then begin
        Id3v1Tag.Year := AnsiString(Lblv1Year.Text);
        fDataChanged := True;
        AddWantedTag(mt_ID3v1);
      end;
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
procedure TFDetails.ShowID3v1Details(ID3v1Tag: TID3v1Tag);
begin
    if ID3v1Tag.exists and fEditTag.Valid then // then
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


procedure TFDetails.ActionRefreshFileExecute(Sender: TObject);
var ListOfFiles: TAudioFileList;
    listFile: TAudioFile;
    i: Integer;
begin
    if assigned(fEditFile)
        and (MedienBib.StatusBibUpdate <= 1)
        and (MedienBib.CurrentThreadFilename <> fEditFile.Pfad)
    then
    begin
        NempPlayer.CoverArtSearcher.StartNewSearch;

        case fEditFile.AudioType of

            at_File: begin
                SynchAFileWithDisc(fEditFile, True);

                // Generate a List of Files which should be updated now
                ListOfFiles := TAudioFileList.Create(False);
                try
                    GetListOfAudioFileCopies(fEditFile, ListOfFiles);
                    for i := 0 to ListOfFiles.Count - 1 do
                    begin
                        listFile := ListOfFiles[i];
                        // copy Data from CurrentAudioFile to the files in the list.
                        listFile.Assign(fEditFile);
                    end;
                finally
                    ListOfFiles.Free;
                end;
                MedienBib.Changed := True;
            end;

            at_CDDA: begin
                // ClearCDDBCache;
                 if NempOptions.UseCDDB then
                     fEditFile.GetAudioData(fEditFile.Pfad, gad_CDDB)
                 else
                    fEditFile.GetAudioData(fEditFile.Pfad, 0);
            end;
        end;
        // Correct GUI
        CorrectVCLAfterAudioFileEdit(fEditFile);
    end else
        TranslateMessageDLG((Warning_MedienBibIsBusyCritical), mtWarning, [MBOK], 0);
end;


{$REGION 'Cover-Art'}

procedure TFDetails.VSTCoverFocusChanged(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex);
var
  PicItem: TPictureItem;
begin
  if assigned(Node) then begin
    PicItem := Node.GetData<TPictureItem>;
    case PicItem.fItemType of
      ptIndexedMetaData: ShowSelectedImage_MetaData(PicItem);
      ptNamedMetaData: ShowSelectedImage_MetaData(PicItem);
      ptFile: ShowSelectedImage_Files(PicItem);
    end;

    ImgCurrentSelection.Stretch := assigned(ImgCurrentSelection.Picture)
        and (ImgCurrentSelection.Picture.Bitmap.Width > ImgCurrentSelection.Width)
        and (ImgCurrentSelection.Picture.Bitmap.Height > ImgCurrentSelection.Height);

    lblCoverInfo.Caption := Format('%d x %d, %.2f kb ',
        [ ImgCurrentSelection.Picture.Bitmap.Width,
          ImgCurrentSelection.Picture.Bitmap.Height,
          PicItem.fSize / 1024
        ]);
  end;
end;

procedure TFDetails.VSTCoverFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
begin
  VSTCover.GetNodeData<TPictureItem>(Node).Free;
end;


procedure TFDetails.VSTCoverGetImageIndex(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Kind: TVTImageKind; Column: TColumnIndex;
  var Ghosted: Boolean; var ImageIndex: TImageIndex);
begin
  if Kind in [ikNormal, ikSelected] then begin
    case Node.GetData<TPictureItem>.fItemType of
      ptIndexedMetaData: ImageIndex := 0;
        ptNamedMetaData: ImageIndex := 0;
        ptFile: ImageIndex := 1;
    end;
  end;
end;

procedure TFDetails.VSTCoverGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
begin
  CellText := Node.GetData<TPictureItem>.Caption;
end;

procedure TFDetails.VSTCoverPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  TargetCanvas.Font.Color := TStyleManager.ActiveStyle.GetSystemColor(clWindowText)
end;

procedure TFDetails.SelectFirstCover;
var
  Node: PVirtualNode;
begin
  // Show first cover, if there is one.
  Node := VSTCover.GetFirst;
  if assigned(Node) then begin
    VSTCover.FocusedNode := Node;
    VSTCover.Selected[Node] := True;
  end else
    ImgCurrentSelection.Picture.Assign(NIL);
end;

procedure TFDetails.ShowCoverArt;
begin
  VSTCover.Clear;
  GetListOfCoverArt_MetaFrames;
  GetListOfCoverArt_Files;
  SelectFirstCover;
end;

procedure TFDetails.GetListOfCoverArt_MetaFrames;
var i: Integer;
  stream: TMemoryStream;
  mime: AnsiString;
  PicType: Byte;
  m4aPictype: TM4APicTypes;
  Description: UnicodeString;
  newPicItem: TPictureItem;
  tmpStrings: TStringList;
  picFrames: TObjectList;
begin
    if not assigned(fEditFile) then
        exit;
    if not assigned(fEditTag) then
        exit;
    if not FileExists(fEditFile.Pfad) then
        exit;

    case fEditTag.FileType of
        at_Invalid: ;
        at_Mp3: begin

                      picFrames := TObjectList.Create(False);
                      try
                        TMp3File(fEditTag).ID3v2Tag.GetAllPictureFrames(picFrames);
                        stream := TMemoryStream.Create;
                        try
                            for i := 0 to picFrames.Count - 1 do
                            begin
                                Stream.Clear;
                                (picFrames[i] as TID3v2Frame).GetPicture(Mime, PicType, Description, stream);
                                if PicType < length(Picture_Types) then
                                  newPicItem := TPictureItem.Create(Picture_Types[PicType], Description, picFrames[i])
                                else
                                  newPicItem := TPictureItem.Create(Picture_Types[0], Description, picFrames[i]);
                                VSTCover.AddChild(Nil, newPicItem);
                            end;
                        finally
                            stream.Free;
                        end;
                      finally
                        picFrames.Free;
                      end;
                end;
        at_Ogg: begin
                      // Pictures not supported in OggFiles by NEMP
                      // cbCoverArtMetadata.Items.Add(DetailForm_NoPictureInOggMetaDataSuppotred);
                end;
        at_Flac: begin
                      picFrames := TObjectList.Create(False);
                      try
                        TFlacFile(fEditTag).GetAllPictureBlocks(picFrames);

                        for i := 0 to picFrames.Count - 1 do
                        begin
                            PicType := TFlacPictureBlock(picFrames[i]).PictureType;
                            Description := TFlacPictureBlock(picFrames[i]).Description;
                            if PicType < length(Picture_Types) then
                              newPicItem := TPictureItem.Create(Picture_Types[PicType], Description, picFrames[i])
                            else
                              newPicItem := TPictureItem.Create(Picture_Types[0], Description, picFrames[i]);
                            VSTCover.AddChild(Nil, newPicItem);
                        end;
                      finally
                        picFrames.Free;
                      end;
                  end;
        at_M4A: begin
                      stream := TMemoryStream.Create;
                      try
                          // Only one Image supprted in M4A-Files
                          if TM4aFile(fEditTag).GetPictureStream(stream, m4aPictype) then begin
                              newPicItem := TPictureItem.Create(Picture_Types[3], '', Nil);
                              VSTCover.AddChild(Nil, newPicItem);
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
            tmpStrings := TStringList.Create;
            try
              TBaseApeFile(fEditTag).ApeTag.GetAllPictureFrames(tmpStrings);
              for i := 0 to tmpStrings.Count - 1 do begin
                newPicItem := TPictureItem.Create(Picture_Types[3], tmpStrings[i], Nil);
                newPicItem.fItemType := ptNamedMetaData;
                VSTCover.AddChild(Nil, newPicItem);
              end;
            finally
              tmpStrings.Free;
            end;
        end;

        at_Wma: ;
        at_Wav: ;
    end;

    ActionCoverResetMediaLibrary.Enabled := fEditFile.GetUserCoverIDFromMetaData(fEditTag) <> '';
end;

{
  Disable/Enable some CoverActions according to CurrentTagObject and the selected Item in the Cover-TreeView
}
procedure TFDetails.PM_CoverArtPopup(Sender: TObject);
var
  FileOK, MetaPicsAllowed, MetaPicSelected, FilePicSelected: Boolean;
  CurrentPicItem: TPictureItem;

begin
  if MainPageControl.ActivePage <> Tab_Pictures then
    MainPageControl.ActivePage := Tab_Pictures;

  if not PicturesLoaded then begin
    PicturesLoaded := True;
    ShowCoverArt;
  end;

  FileOK := assigned(fEditFile)
      and assigned(fEditTag)
      and FileExists(fEditFile.Pfad);

  if assigned(VSTCover.FocusedNode) then
    CurrentPicItem := VSTCover.FocusedNode.GetData<TPictureItem>
  else
    CurrentPicItem := Nil;

  MetaPicsAllowed := FileOK and (fEditTag.filetype <> at_Ogg);
  MetaPicSelected := assigned(CurrentPicItem) and (CurrentPicItem.ItemType <> ptFile);
  FilePicSelected := assigned(CurrentPicItem) and (CurrentPicItem.ItemType = ptFile);

  // Add Cover to MetaData
  ActionCoverNewMetaData.Enabled := MetaPicsAllowed;
  // Remove selected Cover from MetaData
  ActionCoverDeleteMetaData.Enabled := MetaPicsAllowed and MetaPicSelected;
  // Save MetaData picture to file
  ActionCoverMetaDataSaveToFile.Enabled := MetaPicsAllowed and MetaPicSelected;
  // OpenMetaData File
  ActionCoverMetaDataOpenFile.Enabled := FileOK and FilePicSelected;
  // For the Library
  ActionCoverUseCurrentSelectionForMediaLibrary.Enabled := FileOK and (MetaPicSelected or FilePicSelected);
  ActionCoverLoadLibrary.Enabled := CurrentTagObjectWriteAccessPossible;
  // ActionCoverResetMediaLibrary: Done in ShowCoverArt_MetaTag
end;

procedure TFDetails.GetListOfCoverArt_Files;
var baseName: String;
    i: Integer;
    newPicItem: TPictureItem;
    CoverFilenames: TStringList;
begin

    if not assigned(fEditFile) then
        exit;
    if not assigned(fEditTag) then
        exit;
    if not FileExists(fEditFile.Pfad) then
        exit;

    CoverFilenames := TStringList.Create;
    try
      // special case: CDDA
      if fEditFile.isCDDA then begin
        baseName := CoverFilenameFromCDDA(fEditFile.Pfad);
        if FileExists(TCoverArtSearcher.SavePath + baseName + '.jpg') then
          CoverFilenames.Add(TCoverArtSearcher.SavePath + baseName + '.jpg')
        else if FileExists(TCoverArtSearcher.SavePath + baseName + '.png') then
          CoverFilenames.Add(TCoverArtSearcher.SavePath + baseName + '.png');
      end;

      if fEditFile.IsFile then
        CoverArtSearcher.GetCandidateFilelist(fEditFile, CoverFilenames);

      // Add found Coverfiles to the TreeView
      if CoverFilenames.Count > 0 then begin
        for i := 0 to CoverFilenames.Count-1 do begin
          newPicItem := TPictureItem.Create(CoverFilenames[i]);
          VSTCover.AddChild(Nil, newPicItem);
        end;
      end;
    finally
      CoverFilenames.Free;
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
var
  aPic: TPicture;
begin
  aPic := TPicture.Create;
  try
    try
      aPic.LoadFromFile(aFileName);
      aImage.Picture.Bitmap.Assign(aPic.Graphic);
    except
      on E: Exception do begin
        TCoverArtSearcher.GetDefaultCover(dcFile, aPic, 0);
        aImage.Picture.Assign(aPic);
        TranslateMessageDLG(Error_CoverInvalid + #13#10 + #13#10 + E.Message, mtError, [mbOK], 0);
      end;
    end;
  finally
    aPic.Free;
  end;
end;

procedure TFDetails.ShowSelectedImage_Files(PicItem: TPictureItem = NIL);
begin
    if not assigned(PicItem) then
      exit;

    LoadPictureIntoImage(PicItem.FileName, ImgCurrentSelection);
    PicItem.fSize := GetFileSize(PicItem.FileName);
end;

procedure TFDetails.ExtractPicStreamFromMetaData(PicItem: TPictureItem; stream: TStream; var MimeType: AnsiString);
var
  PicType: Byte;
  m4aPictype: TM4APicTypes;
  Description: UnicodeString;
begin
    if not assigned(PicItem) then exit;

    case fEditTag.FileType of
      at_Mp3: TID3v2Frame(PicItem.fMetaFrame).GetPicture(MimeType, PicType, Description, stream);
      at_Flac: TFlacPictureBlock(PicItem.fMetaFrame).CopyPicData(stream);

      at_M4A: begin
            if TM4aFile(fEditTag).GetPictureStream(stream, m4aPictype) then
            begin
                case m4aPictype of
                  M4A_JPG: MimeType := 'image/jpeg';
                  M4A_PNG: MimeType := 'image/png';
                  M4A_Invalid: MimeType := '-'; // invalid
                end;
            end else
              MimeType := '-';
      end;
      at_Monkey,
      at_WavPack,
      at_MusePack,
      at_OptimFrog,
      at_TrueAudio: begin
            // Load APE-Image
            if TBaseApeFile(fEditTag).ApeTag.GetPicture(AnsiString( PicItem.Description ), Stream, Description) then
              MimeType := '' // unknown
            else
              MimeType := '-'; // invalid
      end;
    else
      MimeType := '-'; // invalid
    end;
end;

procedure TFDetails.ShowSelectedImage_MetaData(PicItem: TPictureItem = NIL);
var
  stream: TMemorystream;
  MimeType: AnsiString;
begin
    if not assigned(PicItem) then
      exit;

    stream := TMemoryStream.Create;
    try
      // Get the PictureData fomr the PicItems assigned MetaFrame ando display it in the Image.
      ExtractPicStreamFromMetaData(PicItem, stream, MimeType);
      if (MimeType = '-') or (stream.Size = 0) then begin
        // invalid MimeType or empty PicData
        ImgCurrentSelection.Picture.Assign(NIL);
        PicItem.fSize := 0;
      end else
      if (MimeType = '') then begin
        // unknown MimeType, try different types
        PicItem.fSize := Stream.Size;
        if not PicStreamToBitmap(Stream, 'image/jpeg', ImgCurrentSelection.Picture.Bitmap) then
          if not PicStreamToBitmap(Stream, 'image/png', ImgCurrentSelection.Picture.Bitmap) then
              if not PicStreamToBitmap(Stream, 'image/bmp', ImgCurrentSelection.Picture.Bitmap) then begin
                ImgCurrentSelection.Picture.Assign(NIL);
                PicItem.fSize := 0;
              end;
      end else begin
        // the regular case, defined MimeType
        PicStreamToBitmap(stream, MimeType, ImgCurrentSelection.Picture.Bitmap);
        PicItem.fSize := Stream.Size;
      end;
    finally
      stream.Free;
    end;
end;


procedure TFDetails.ActionCoverNewMetaDataExecute(Sender: TObject);
begin
    if Not Assigned(FNewPicture) then
        Application.CreateForm(TFNewPicture, FNewPicture);

    FNewPicture.CurrentTagObject := fEditTag;
    FNewPicture.LblConst_PictureType.Enabled := fEditTag.FileType <> at_M4A;
    FNewPicture.LblConst_PictureDescription.Enabled := fEditTag.FileType <> at_M4A;
    FNewPicture.cbPictureType.Enabled := fEditTag.FileType <> at_M4A;
    FNewPicture.EdtPictureDescription.Enabled := fEditTag.FileType <> at_M4A;

    // Adding the Picture to the CurrentTagObject is done in the Form FNewPicture
    if FNewPicture.Showmodal = MROK then begin
        fDataChanged := True;
        FrameBasedTagNeeded;
        // not exactly the most efficient method to add the new frame to the tree view ...
        ShowCoverArt;
        ShowMetaDataFrames;
    end;
end;


procedure TFDetails.ActionCoverDeleteMetaDataExecute(Sender: TObject);
var
  PicItem: TPictureItem;
begin
  if not assigned(VSTCover.FocusedNode) then
    exit;

  PicItem := VSTCover.FocusedNode.GetData<TPictureItem>;

  if not assigned(PicItem.fMetaFrame) then
    exit;

  case fEditTag.FileType of
      at_Mp3: TMp3File(fEditTag).Id3v2Tag.DeleteFrame(PicItem.fMetaFrame as TID3v2Frame );
      at_Flac: TFlacFile(fEditTag).DeletePicture(TFlacPictureBlock(PicItem.fMetaFrame));
      at_M4A: TM4aFile(fEditTag).SetPicture(Nil, M4A_Invalid);
      at_Monkey,
      at_WavPack,
      at_MusePack,
      at_OptimFrog,
      at_TrueAudio: TBaseApeFile(fEditTag).ApeTag.SetPicture(AnsiString(PicItem.Description), '', NIL );
      // at_Invalid: ;at_Ogg: ; at_Wma: ; at_Wav: ; // nothing to do, not supported.
  end;
  VSTCover.DeleteNode(VSTCover.FocusedNode);
  SelectFirstCover;
  fDataChanged := True;
  ShowMetaDataFrames;
end;

{
    --------------------------------------------------------
    ActionCoverMetaDataSaveToFileExecute
    - Extract a picture from id3tag and save it to a file
    --------------------------------------------------------
}

procedure TFDetails.ActionCoverMetaDataSaveToFileExecute(Sender: TObject);
var Stream: TMemoryStream;
    mime: AnsiString;
    PicType: Byte;
    m4aPictype: TM4APicTypes;
    Description: UnicodeString;
    tmpBmp: TBitmap;
    PicItem: TPictureItem;
begin
  if not assigned(VSTCover.FocusedNode) then
    exit;

  PicItem := VSTCover.FocusedNode.GetData<TPictureItem>;

  if not assigned(PicItem.fMetaFrame) then
    exit;


  stream := TMemoryStream.Create;
  try
      mime := ''; // something invalid

      case fEditTag.FileType of

          at_Mp3: begin
                (PicItem.fMetaFrame as TID3v2Frame).GetPicture(Mime, PicType, Description, stream);
                PicStreamToBitmap(stream, Mime, ImgCurrentSelection.Picture.Bitmap);
          end;

          at_Flac: begin
                mime := TFlacPictureBlock(PicItem.fMetaFrame).Mime;
                TFlacPictureBlock(PicItem.fMetaFrame).CopyPicData(stream);
          end;

          at_M4A: begin
                if TM4aFile(fEditTag).GetPictureStream(stream, m4aPictype) then
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
                if TBaseApeFile(fEditTag).ApeTag.GetPicture(AnsiString(PicItem.Description), Stream, Description) then
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
    if (not assigned(fEditFile))
        or (MedienBib.StatusBibUpdate > 1)
        or (MedienBib.CurrentThreadFilename = fEditFile.Pfad)
    then
    begin
        TranslateMessageDLG((Warning_MedienBibIsBusyCritical), mtWarning, [MBOK], 0);
        exit;
    end;

    fDataChanged := True;
    FrameBasedTagNeeded;
    CoverArtHasChanged := True;

    case fEditTag.FileType of
        at_Mp3: begin
              AnsiID := AnsiString(aNewID);
              if length(AnsiID) > 0 then
              begin
                  fEditFile.EnsureID3v2Exists(TMp3File(fEditTag));
                  ms := TMemoryStream.Create;
                  try
                      ms.Write(AnsiID[1], length(AnsiID));
                      TMp3File(fEditTag).ID3v2Tag.SetPrivateFrame('NEMP/UserCoverID', ms);
                  finally
                      ms.Free;
                  end;
              end else
                  // delete UserCoverID-Frame
                  TMp3File(fEditTag).ID3v2Tag.SetPrivateFrame('NEMP/UserCoverID', NIL);
        end;

        at_Ogg : TOggVorbisFile(fEditTag).SetPropertyByFieldname(VORBIS_USERCOVERID, aNewID);
        at_Flac: TFlacFile(fEditTag).SetPropertyByFieldname(VORBIS_USERCOVERID, aNewID);
        at_M4A : TM4aFile(fEditTag).SetSpecialData(DEFAULT_MEAN, M4AUserCoverID, aNewID);
        at_Monkey,
        at_WavPack,
        at_MusePack,
        at_OptimFrog,
        at_TrueAudio:  TBaseApeFile(fEditTag).ApeTag.SetValueByKey(APE_USERCOVERID  , aNewID);
        //at_Wma: ; at_Invalid: ; at_Wav: ;
    end;

    if (aNewID <> '') and FileExists(TCoverArtSearcher.SavePath + aNewID + '.jpg') then
    begin
        // display the current selection in Library-Image
        LoadPictureIntoImage(TCoverArtSearcher.SavePath + aNewID + '.jpg', CoverLibrary2);
        NewLibraryCoverID := aNewID;
        fEditFile.CoverID := NewLibraryCoverID;
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
        CoverArtSearcher.InitCover(fEditFile, tm_VCL, INIT_COVER_FORCE_RESCAN OR INIT_COVER_IGNORE_USERID);

        CoverArtSearcher.GetCover_Fast(fEditFile, CoverLibrary2.Picture);
        CoverLibrary2.Refresh;
        NewLibraryCoverID := fEditFile.CoverID;
    end;

    ShowMetaDataFrames;

    if (aNewID = '') then
      NewLibraryCoverID_FileSave := ''
    else
      NewLibraryCoverID_FileSave := NewLibraryCoverID;

end;


procedure TFDetails.ActionCoverUseCurrentSelectionForMediaLibraryExecute(
  Sender: TObject);
var
  newID: String;
  stream: TMemoryStream;
  currentPic: TPictureItem;
  MimeType: AnsiString;
begin
  if not Assigned(VSTCover.FocusedNode) then
    exit;

  stream := TMemoryStream.Create;
  try
    currentPic := VSTCover.FocusedNode.GetData<TPictureItem>;
    if currentPic.fItemType = ptFile then
      stream.LoadFromFile(currentpic.FileName)
    else
      ExtractPicStreamFromMetaData(currentPic, stream, MimeType);
    stream.Seek(0, soFromBeginning);
    // calculate a new ID from the stream data
    newID := MD5DigestToStr(MD5Stream(stream));
    // try to save a resized JPG from the content of the stream
    // if this fails, there was something wrong with the image data :(
    if FileExists(TCoverArtSearcher.SavePath + newID + '.jpg')
       OR TCoverArtSearcher.ScalePicStreamToFile_AllSizes(stream, newID, Nil)
    then
      HandleCoverIDSetting(newID)
  finally
    stream.free;
  end;
end;


procedure TFDetails.ActionCoverResetMediaLibraryExecute(Sender: TObject);
begin
    HandleCoverIDSetting('');
end;

procedure TFDetails.ActionCoverLoadLibraryExecute(Sender: TObject);
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
    ActionCoverMetaDataOpenFileExecute
    CoverIMAGEDblClick
    - open the image in the default application
    --------------------------------------------------------
}

procedure TFDetails.ActionCoverMetaDataOpenFileExecute(Sender: TObject);
var
  currentPic: TPictureItem;
begin
  if not Assigned(VSTCover.FocusedNode) then
    exit;

  currentPic := VSTCover.FocusedNode.GetData<TPictureItem>;
  if currentPic.fItemType = ptFile then
    ShellExecute(Handle, nil, PChar(currentPic.FileName), nil, nil, SW_SHOWNORMAl)
end;

procedure TFDetails.ImgCurrentSelectionDblClick(Sender: TObject);
begin
  ActionCoverMetaDataOpenFile.Execute;
end;

procedure TFDetails.CoverIMAGEDblClick(Sender: TObject);
begin
    if FileExists(TCoverArtSearcher.Savepath + fEditFile.CoverID + '.jpg') then
        ShellExecute(Handle, Nil, PChar(TCoverArtSearcher.Savepath + fEditFile.CoverID + '.jpg'), '', nil, SW_SHOWNORMAl);
end;                      {'open'}



function TFDetails.CurrentFileHasBeenChanged: Boolean;
begin
  result := assigned(fEditFile) and fDataChanged;
end;

end.

