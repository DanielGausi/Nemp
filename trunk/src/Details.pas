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
  Dialogs, AudioFileClass, StdCtrls, ExtCtrls, StrUtils, JPEG, PNGImage, GifImg,
  ShellApi, ComCtrls, Mp3FileUtils, id3v2Frames, CoverHelper,
  Buttons, ExtDlgs, ImgList,  Hilfsfunktionen, Systemhelper, U_CharCode, HtmlHelper,

  Nemp_ConstantsAndTypes, gnuGettext, Lyrics,
  Nemp_RessourceStrings,  IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, Menus, RatingCtrls;

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
    ___CB_StayOnTop: TCheckBox;
    GrpBox_ID3v1: TGroupBox;
    GrpBox_ID3v2: TGroupBox;
    Btn_Properties: TButton;
    Timer1: TTimer;
    pnlIDv1Genre: TPanel;
    cbIDv1Genres: TComboBox;
    pnlIDv2Genre: TPanel;
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
    Lblv2URL: TLabeledEdit;
    LvFrames: TListView;
    GrpBox_ID3v2Info: TGroupBox;
    LblConst_Id3v2Version: TLabel;
    LblConst_Id3v2Size: TLabel;
    Lblv2_Size: TLabel;
    Lblv2_Version: TLabel;
    RatingImageRO: TImage;
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
    cbIDv2Genres: TComboBox;
    cbPictures: TComboBox;
    Memo_Lyrics: TMemo;
    ReloadTimer: TTimer;
    LblRatingImage: TLabel;
    RatingImage: TImage;
    BtnResetRating: TButton;
    LblPlayCounter: TLabel;

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
////    procedure ___CB_StayOnTopClick(Sender: TObject);

    // Some EventHandler for page 1
    procedure Btn_ExploreClick(Sender: TObject);
    procedure Btn_PropertiesClick(Sender: TObject);
    procedure Btn_ActualizeClick(Sender: TObject);

    // Procedures for editing the rating of the current file
    procedure RatingImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure RatingImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure RatingImageMouseLeave(Sender: TObject);
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
    Procedure UpdateID3ReadOnlyStatus;
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
    procedure ShowDetails(AudioFile:TAudioFile; Source: Integer = SD_MEDIENBIB);

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

  private
    Coverpfade : TStringList;
    DateiPfad : String;

    PictureFrames: TObjectList;

    ID3v1tag: TID3v1Tag;
    mpegInfo:TMpegInfo;

    fFileFromMedienBib: Boolean;

    // Gibt an, ob aktuelles AudioFile ein gültiges MP3-File ist
    ValidMp3File: Boolean;
    // Speichert die "temporäre Existenz" der ID3Tags, d.h. ob der User sie aktiviert hat oder nicht
    ID3v1Activated: Boolean;
    ID3v2Activated: Boolean;
    ActualRating: Integer;
    PictureHasChanged: Boolean;
    ID3v1HasChanged: Boolean;
    ID3v2HasChanged: Boolean;

    // ForceChange: ShowDetails without showing a "Do you want to save..."-Message
    fForceChange: Boolean;


    DetailRatingHelper: TRatingHelper;

    // Show some information of the selected audiofile
    procedure ShowMediaBibDetails;
    procedure ShowMPEGDetails;
    procedure ShowID3v1Details;
    procedure ShowPictures;
    //procedure ShowRating(Value: Integer);
    procedure FillFrameView;
    procedure ShowID3v2Details;

    // Save information to ID3-Tag
    procedure UpdateID3v1InFile;
    procedure UpdateID3v2InFile;

    // Wenn ein PlaylistFile bearbeitet wird:
    // Dieses in der MedienBib suchen und aktualisieren
    procedure SearchAndUpdateFileInMB;

    function CurrentFileHasBeenChanged: Boolean;

  public
    ID3v2Tag: TID3V2Tag; // wird in NewPicture benötigt
    AktuellesAudioFile : TAudioFile;
  end;


var
  FDetails: TFDetails;


implementation

Uses NempMainUnit, NewPicture, Clipbrd, MedienbibliothekClass, MainFormHelper;

{$R *.dfm}

procedure TFDetails.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    if CurrentFileHasBeenChanged then
    begin
        case MessageDLG((DetailForm_SaveChanges), mtConfirmation, [MBYes, MBNo, MBAbort], 0) of
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
    s,h,u: TBitmap;
    baseDir: String;
begin
  PictureFrames := Nil;
  fForceChange := False;
  TranslateComponent (self);
  Coverpfade := TStringList.Create;
  ID3v2Tag:=TID3V2Tag.Create;
  ID3v1tag:=TID3v1Tag.Create;
  mpegInfo := TMpegInfo.create;
  cbIDv1Genres.Items := Genres;
  cbIDv1Genres.Items.Add('');
  for i := 0 to Genres.Count - 1 do
    cbIDv2Genres.Items.Add(Genres[i]);

  MainPageControl.ActivePageIndex := 0;
  DetailRatingHelper := TRatingHelper.Create;
  s := TBitmap.Create;
  h := TBitmap.Create;
  u := TBitmap.Create;
  BaseDir := ExtractFilePath(ParamStr(0)) + 'Images\';
  try
      Nemp_MainForm.NempSkin.LoadGraphicFromBaseName(s, BaseDir + 'starset')    ;
      Nemp_MainForm.NempSkin.LoadGraphicFromBaseName(h, BaseDir + 'starhalfset');
      Nemp_MainForm.NempSkin.LoadGraphicFromBaseName(u, BaseDir + 'starunset')  ;
      DetailRatingHelper.SetStars(s,h,u);
  finally
      s.Free;
      h.Free;
      u.Free;
  end;
  //doubleBuffered := True;
end;

procedure TFDetails.FormDestroy(Sender: TObject);
begin
  if assigned(PictureFrames) then
      PictureFrames.Free;
  Coverpfade.Free;
  ID3v2Tag.Free;
  ID3v1Tag.Free;
  mpegInfo.free;
  DetailRatingHelper.Free;
end;


procedure TFDetails.FormShow(Sender: TObject);
begin
    MainPageControl.ActivePageIndex := 0;
    UpdateID3ReadOnlyStatus;
end;

procedure TFDetails.FormHide(Sender: TObject);
begin
    Nemp_MainForm.AutoShowDetailsTMP := False;
    AktuellesAudioFile := Nil;
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
begin

    // Do not Change anything in non-mp3-Files here!
    // Do Not GetAudioData on Non-mp3-Files here!
    if Not ValidMP3File then
        Exit;

    // Note from 04.03.2010: Redo "DenyID3-Edit-stuff" here. - This will have to do something with partymode

    PictureHasChanged := False;
    ID3v1HasChanged := False;
    ID3v2HasChanged := False;

    if assigned(AktuellesAudioFile)
        and (MedienBib.StatusBibUpdate <= 1)
        and (MedienBib.CurrentThreadFilename <> AktuellesAudioFile.Pfad)
    then
    begin
        // write Tags to file
        UpdateID3v1InFile;
        UpdateID3v2InFile;
        // get the information again and store them in the audiofile-object
        AktuellesAudioFile.GetAudioData(Dateipfad, GAD_Cover or GAD_Rating);
        // Update other copies of this file
        ListOfFiles := TObjectList.Create(False);
        try
            GetListOfAudioFileCopies(AktuellesAudioFile, ListOfFiles);
            for i := 0 to ListOfFiles.Count - 1 do
            begin
                listFile := TAudioFile(ListOfFiles[i]);
                // copy Data from AktuellesAudioFile to the files in the list.
                listFile.Assign(AktuellesAudioFile);
            end;
        finally
            ListOfFiles.Free;
        end;
        MedienBib.Changed := True;
        // Correct GUI
        CorrectVCLAfterAudioFileEdit(AktuellesAudioFile);
    end else
        MessageDLG((Warning_MedienBibIsBusyCritical), mtWarning, [MBOK], 0);
end;
procedure TFDetails.BtnUndoClick(Sender: TObject);
begin
    if fFilefromMedienBib then
        ShowDetails(AktuellesAudioFile, SD_MedienBib)
    else
        ShowDetails(AktuellesAudioFile, SD_PLAYLIST);
end;
procedure TFDetails.Btn_CloseClick(Sender: TObject);
begin
    hide;
end;
(*
procedure TFDetails.___CB_StayOnTopClick(Sender: TObject);
begin
  if CB_StayOnTop.Checked then
    SetWindowPos(FDetails.Handle,HWND_TOPMOST,0,0,0,0,SWP_NOSIZE+SWP_NOMOVE)
  else
    SetWindowPos(FDetails.Handle,HWND_NOTOPMOST,0,0,0,0,SWP_NOSIZE+SWP_NOMOVE);
end;
*)

{
    --------------------------------------------------------
    Btn_ExploreClick
    Btn_PropertiesClick
    Btn_ActualizeClick
    --------------------------------------------------------
}
procedure TFDetails.Btn_ExploreClick(Sender: TObject);
begin
  if DirectoryExists(ExtractFilePath(dateipfad)) then
        ShellExecute(Handle, 'open' ,'explorer.exe'
                      , Pchar('/e,/select,"'+dateipfad+'"'), '', sw_ShowNormal);
end;
procedure TFDetails.Btn_PropertiesClick(Sender: TObject);
begin
  ShowFileProperties(Nemp_MainForm.Handle, pChar(dateipfad),'');
end;
procedure TFDetails.Btn_ActualizeClick(Sender: TObject);
var ListOfFiles: TObjectList;
    listFile: TAudioFile;
    i: Integer;
begin
    if assigned(AktuellesAudioFile)
        and (MedienBib.StatusBibUpdate <= 1)
        and (MedienBib.CurrentThreadFilename <> AktuellesAudioFile.Pfad)
    then
    begin
        // Read file information from disk
        if Fileexists(AktuellesAudioFile.Pfad) then
            AktuellesAudioFile.GetAudioData(AktuellesAudioFile.Pfad, GAD_Cover or GAD_Rating);

        // Generate a List of Files which should be updated now
        ListOfFiles := TObjectList.Create(False);
        try
            GetListOfAudioFileCopies(AktuellesAudioFile, ListOfFiles);
            for i := 0 to ListOfFiles.Count - 1 do
            begin
                listFile := TAudioFile(ListOfFiles[i]);
                // copy Data from AktuellesAudioFile to the files in the list.
                listFile.Assign(AktuellesAudioFile);
            end;
        finally
            ListOfFiles.Free;
        end;
        MedienBib.Changed := True;
        // Correct GUI
        CorrectVCLAfterAudioFileEdit(AktuellesAudioFile);
    end else
        MessageDLG((Warning_MedienBibIsBusyCritical), mtWarning, [MBOK], 0);
end;

{
    --------------------------------------------------------
    RatingImageMouseMove
    RatingImageMouseDown
    RatingImageMouseLeave
    BtnResetRatingClick
    cbWriteRatingToTagClick
    - Edit the rating of the current audiofile
    --------------------------------------------------------
}
procedure TFDetails.RatingImageMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var rat: Integer;
begin
    if RatingImage.Enabled then
    begin
        rat := DetailRatingHelper.MousePosToRating(x, 70);//((x div 8)) * 8;
        DetailRatingHelper.DrawRatingInStarsOnBitmap(rat, RatingImage.Picture.Bitmap, RatingImage.Width, RatingImage.Height);
    //ShowRating(rat);
    end;
end;


procedure TFDetails.RatingImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    ActualRating := DetailRatingHelper.MousePosToRating(x, 70);
    // Actualize Read-Only-Image
    DetailRatingHelper.DrawRatingInStarsOnBitmap(ActualRating, RatingImageRO.Picture.Bitmap, RatingImageRO.Width, RatingImageRO.Height);
end;
procedure TFDetails.RatingImageMouseLeave(Sender: TObject);
begin
    //ShowRating(ActualRating);
    if RatingImage.Enabled then
        DetailRatingHelper.DrawRatingInStarsOnBitmap(ActualRating, RatingImage.Picture.Bitmap, RatingImage.Width, RatingImage.Height);
end;
procedure TFDetails.BtnResetRatingClick(Sender: TObject);
begin
    ActualRating := 0;
    DetailRatingHelper.DrawRatingInStarsOnBitmap(ActualRating, RatingImage.Picture.Bitmap, RatingImage.Width, RatingImage.Height);
    DetailRatingHelper.DrawRatingInStarsOnBitmap(ActualRating, RatingImageRO.Picture.Bitmap, RatingImageRO.Width, RatingImageRO.Height);
end;

{
    --------------------------------------------------------
    ShowRating
    - Show the rating, build the image
    --------------------------------------------------------

procedure TFDetails.ShowRating(Value: Integer);
var aBmp: TBitmap;
begin
    if Value = 0 then
        Value := 128;
    aBmp := TBitmap.Create;
    try
        aBmp.Width := RatingImage.Width;
        aBmp.Height := RatingImage.Height;
        DetailRatingHelper.DrawRatingInStars(value, aBmp.canvas, RatingImage.Height);
         aBmp.Transparent := True;
        RatingImage.Picture.Bitmap.Assign(aBmp);
    finally
        aBmp.Free;
    end;
end;   }

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
                  GetDefaultCover(dcNoCover, aCoverBmp, 0);
                  CoverIMAGE.Picture.Bitmap.Assign(aCoverbmp);
                  MessageDLG(Error_CoverInvalid + #13#10 + #13#10 + E.Message, mtError, [mbOK], 0);
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
        ShowDetails(AktuellesAudioFile, SD_MedienBib)
    else
        ShowDetails(AktuellesAudioFile, SD_PLAYLIST);
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
  ButtonsEnable := (AktuellesAudioFile <> NIL) AND FileExists(AktuellesAudioFile.Pfad);
  ControlsEnable:= (AktuellesAudioFile <> NIL);

  Btn_Properties.Enabled := ButtonsEnable;
  Btn_Explore.Enabled := ButtonsEnable;
  Btn_Actualize.Enabled := ButtonsEnable;
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
    UpdateID3ReadOnlyStatus
    - Set ReadOnly to the ID3-Edits
    --------------------------------------------------------
}
Procedure TFDetails.UpdateID3ReadOnlyStatus;
var ControlsEnable, ControlsReadOnly: Boolean;
begin
  ControlsEnable := Not Nemp_MainForm.NempOptions.DenyID3Edit;
  ControlsReadOnly := Nemp_MainForm.NempOptions.DenyID3Edit;

  CBID3v1.Enabled := ControlsEnable;
  CBID3v2.Enabled := ControlsEnable;

//  cbWriteRatingToTag.Enabled := ValidMp3File and ControlsEnable;
//  cbWriteRatingToTag.OnClick := Nil;
//  if ControlsReadOnly then
//      cbWriteRatingToTag.Checked := False
//  else
//      cbWriteRatingToTag.Checked := MedienBib.WriteRatingToTag;
//  cbWriteRatingToTag.OnClick := cbWriteRatingToTagClick;

  Lblv1Artist.ReadOnly := ControlsReadOnly;
  Lblv1Album.ReadOnly := ControlsReadOnly;
  Lblv1Titel.ReadOnly := ControlsReadOnly;
  Lblv1Year.ReadOnly := ControlsReadOnly;
  Lblv1Comment.ReadOnly := ControlsReadOnly;
  Lblv1Track.ReadOnly := ControlsReadOnly;
  pnlIDv1Genre.Enabled := ControlsEnable;

  Lblv2Artist.ReadOnly := ControlsReadOnly;
  Lblv2Album.ReadOnly := ControlsReadOnly;
  Lblv2Titel.ReadOnly := ControlsReadOnly;
  Lblv2Year.ReadOnly := ControlsReadOnly;
  Lblv2Comment.ReadOnly := ControlsReadOnly;
  Lblv2Track.ReadOnly := ControlsReadOnly;
  pnlIDv2Genre.Enabled := ControlsEnable;
  Memo_Lyrics.ReadOnly := ControlsReadOnly;
  Lblv2Copyright.ReadOnly := ControlsReadOnly;
////  Lblv2EncodedBy.ReadOnly := ControlsReadOnly;
  Btn_DeleteLyricFrame.Enabled := ControlsEnable;
  BtnLyricWiki.Enabled := ControlsEnable;
  Btn_NewPicture.Enabled := ControlsEnable;
  Btn_DeletePicture.Enabled := ControlsEnable;
  Btn_SavePictureToFile.Enabled := ControlsEnable;
  BtnCopyFromV2.Enabled := ControlsEnable;
  BtnCopyFromV1.Enabled := ControlsEnable;
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
var ControlsEnable, ButtonsEnable: Boolean;
begin
  ControlsEnable := ValidMp3File and ID3v2Activated;
  ButtonsEnable := ValidMp3File and ID3v2Activated and (not Nemp_MainForm.NempOptions.DenyID3Edit);
  CBID3v2.Enabled := ValidMp3File;
  CBID3v2.OnClick := Nil;  // ! Wichtig, sonst Endlossschleife!
  CBID3v2.Checked := ControlsEnable;
  CBID3v2.OnClick := CBID3v2Click;
  Lblv2Artist.Enabled := ControlsEnable;
  Lblv2Album.Enabled := ControlsEnable;
  Lblv2Titel.Enabled := ControlsEnable;
  Lblv2Year.Enabled := ControlsEnable;
  cbIDv2Genres.Enabled := ControlsEnable;
  Lblv2Comment.Enabled := ControlsEnable;
  Lblv2Track.Enabled := ControlsEnable;
  LblRatingImage.Enabled := ControlsEnable;
  RatingImage.Enabled := ControlsEnable;
  BtnResetRating.Enabled := ControlsEnable;
  if ControlsEnable then
      DetailRatingHelper.DrawRatingInStarsOnBitmap(ActualRating, RatingImage.Picture.Bitmap, RatingImage.Width, RatingImage.Height)
  else
  begin
      if FileExists(ExtractFilePath(ParamStr(0)) + 'Images\stardisabled.bmp') then
          RatingImage.Picture.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'Images\stardisabled.bmp');
  end;

  LblConst_ID3v2Artist.Enabled := ControlsEnable;
  LblConst_ID3v2Title.Enabled := ControlsEnable;
  LblConst_ID3v2Album.Enabled := ControlsEnable;
  LblConst_ID3v2Comment.Enabled := ControlsEnable;
  LblConst_ID3v2Genre.Enabled := ControlsEnable;
  LblConst_ID3v2Track.Enabled := ControlsEnable;
  LblConst_ID3v2Year.Enabled := ControlsEnable;
  BtnCopyFromV2.Enabled := ControlsEnable;
//  cbWriteRatingToTag.Enabled := ValidMp3File and (not Nemp_MainForm.NempOptions.DenyID3Edit);
  // Sonderstatus Lyrics: Auch anzeigen, wenn Datei gerade nicht zu finden ist.
  if (AktuellesAudioFile <> NIL)
    AND (AnsiLowerCase(ExtractFileExt(AktuellesAudioFile.Pfad))='.mp3')
    AND (not FileExists(AktuellesAudioFile.Pfad))
    AND (trim(UnicodeString(AktuellesAudioFile.Lyrics)) <> '')
    then
  begin
      // d.h. es ist ein mp3File, was gerade nicht da ist, das aber Lyrics in der DB hat
      Memo_Lyrics.ReadOnly := True;
      Memo_Lyrics.Enabled := True;
  end else
  begin
      Memo_Lyrics.ReadOnly := Nemp_MainForm.NempOptions.DenyID3Edit;
      Memo_Lyrics.Enabled := ControlsEnable;
  end;

  LvFrames.Enabled := ControlsEnable;
  cbPictures.Enabled := ControlsEnable;
  ID3Image.Visible := ControlsEnable;
  // Seite 4
  Lblv2Copyright.Enabled := ControlsEnable;
  Lblv2URL.Enabled := ControlsEnable;
////  Lblv2EncodedBy.Enabled := ControlsEnable;
  Btn_DeleteLyricFrame.Enabled := ButtonsEnable;
  BtnLyricWiki.Enabled       := ButtonsEnable;
  Btn_NewPicture.Enabled       := ButtonsEnable;
  Btn_DeletePicture.Enabled    := ButtonsEnable;
  Btn_SavePictureToFile.Enabled := ButtonsEnable;
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
  ID3v2tag.Title  := Lblv1Titel.Text   ;
  ID3v2tag.Artist := Lblv1Artist.Text  ;
  ID3v2tag.album  := Lblv1Album.Text   ;
  ID3v2tag.Comment:= Lblv1Comment.Text ;
  ID3v2tag.Year   := Lblv1Year.Text    ;
  ID3v2tag.Track  := Lblv1Track.Text   ;
  ID3v2tag.Genre  := cbIDv1Genres.Text ;
  ShowID3v2Details;
end;
procedure TFDetails.BtnCopyFromV2Click(Sender: TObject);
begin
  if not Validmp3File then exit;
  // Infos von v2 auf v1 übertragen
  // zuerst: ggf. v1Tag aktivieren
  ID3v1Activated := True;
  CBID3v1.Checked := True; //(dadurch werden die Controls auch aktiviert)
  ID3v1tag.Title  := Lblv2Titel.Text   ;
  ID3v1tag.Artist := Lblv2Artist.Text  ;
  ID3v1tag.album  := Lblv2Album.Text   ;
  ID3v1tag.Comment:= Lblv2Comment.Text ;
  ID3v1tag.Year   := AnsiString(Lblv2Year.Text)    ;
  ID3v1tag.Track  := Lblv2Track.Text   ;
  ID3v1tag.Genre  := cbIDv2Genres.Text ;
  ShowID3v1Details;
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
begin
  if AktuellesAudioFile = Nil then
  begin
      AktuellesAudioFile := NIL;
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
        with AktuellesAudioFile do
        begin
          FDetails.Caption := Format('%s (%s)', [(DetailForm_Caption), Dateiname]);


          If not (Fileexists(Pfad) OR AktuellesAudioFile.isStream) then
          begin
            Lbl_Warnings.Caption := (Warning_FileNotFound);
            Lbl_Warnings.Hint := (Warning_FileNotFound_Hint);
            PnlWarnung.Visible := True;
          end;// else
            //PnlWarnung.Visible := False;

          DateiPfad := Pfad;
          LBLPfad.Caption := Ordner;
          LBLName.Caption := DateiName;

          if AktuellesAudioFile.isStream then
          begin
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
            LBLBitrate.Caption := inttostr(Bitrate) + ' kbit/s';
            LBLSamplerate.Caption := '-';
            LblPlayCounter.Caption := '';
          end
          else
          begin
            LlblConst_Path.Caption := (DetailForm_InfoLblPath);
            LlblConst_Filename.Caption := (DetailForm_InfoLblFilename);
            Lblsize.Font.Style := [];
            LlblConst_Filesize.Font.Style := [];
            LlblConst_FileSize.Caption := (DetailForm_InfoLblFileSize);
            LBLSize.Caption := FloatToStrF((Size / 1024 / 1024),ffFixed,4,2) + ' MB'
                            + ' (' + inttostr(Size) + ' Bytes)' ;
            LBLPfad.Font.Color := clWindowText;
            LBLPfad.Font.Style := [];
            LBLPfad.OnClick := NIL;
            LBLPfad.PopupMenu := NIL;
            LBLPfad.Cursor := crDefault;
            LBLDauer.Caption  := SekToZeitString(Duration);

            if vbr then
              LBLBitrate.Caption := inttostr(Bitrate) + ' kbit/s (vbr)'
            else
              LBLBitrate.Caption := inttostr(Bitrate) + ' kbit/s';

            LBLSamplerate.Caption := Samplerate + ', ' + ChannelMode;

            LblPlayCounter.Caption := Format(DetailForm_PlayCounter, [PlayCounter]);

            if fFilefromMedienBib and (NOT MedienBib.AnzeigeShowsPlaylistFiles) then
                ActualRating := Rating
            else
            begin
                mbAudioFile := MedienBib.GetAudioFileWithFilename(AktuellesAudioFile.Pfad);
                if assigned(mbAudioFile) then
                begin
                    ActualRating := mbAudioFile.Rating;
                    AktuellesAudioFile.Rating := mbAudioFile.Rating;
                end else
                begin
                    // File is not in MediaLibrary, but PlaylistFile
                    ActualRating := ID3v2Tag.Rating;
                end;
            end;
            //ShowRating(ActualRating);
            DetailRatingHelper.DrawRatingInStarsOnBitmap(ActualRating, RatingImageRO.Picture.Bitmap, RatingImageRO.Width, RatingImageRO.Height);

          end;

          LBLArtist.Caption := Artist;
          LBLTitel.Caption  := Titel;
          LBLAlbum.Caption  := Album;
          LBLTrack.Caption  := IntToStr(Track);
          LBLYear.Caption   := Year;
          LBLGenre.Caption  := genre;
          LblKommentar.Caption := Comment;
          LBLSamplerate.Caption := Samplerate + ', ' + ChannelMode;

          CoverBox.Items.Clear;
          Coverpfade.Clear;

          // ToDo:  Hinzufügen: Das "Hash-Cover"
          if (AktuellesAudioFile.CoverID <> 'all')
          and (AktuellesAudioFile.CoverID <> '')
          and FileExists(MedienBib.CoverSavePath + AktuellesAudioFile.CoverID + '.jpg') then
          begin
            Coverpfade.Add(MedienBib.CoverSavePath + AktuellesAudioFile.CoverID + '.jpg');
            FirstCoverIsFromMB := True;
          end else
            FirstCoverIsFromMB := False;

          Medienbib.GetCoverListe(AktuellesAudioFile,  Coverpfade);

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
end;
{
    --------------------------------------------------------
    ShowMPEGDetails
    --------------------------------------------------------
}
procedure TFDetails.ShowMPEGDetails;
begin
    if ValidMP3File and (AktuellesAudioFile <> NIL) then
    begin
        if MpegInfo.vbr then
          LblDETBitrate.Caption := inttostr(MpegInfo.bitrate) + 'kbit/s (vbr)'
        else
          LblDETBitrate.Caption := inttostr(MpegInfo.bitrate) + 'kbit/s';

        LblDETSamplerate.Caption := inttostr(MpegInfo.samplerate) + ' Hz, '
          + channel_modes[MpegInfo.channelmode];

        LblDETDauer.Caption := Format('%s (%d Frames)', [SekToZeitString(MpegInfo.dauer), MpegInfo.frames]);

        if MpegInfo.version = 3 then
          LblDETVersion.Caption := '2.5 (Layer '+ inttostr(MpegInfo.layer) + ')'
        else
          LblDETVersion.Caption := inttostr(MpegInfo.version) + ' (Layer '+
            inttostr(MpegInfo.layer) + ')';

        LblDETHeaderAt.Caption := inttostr(MpegInfo.FirstHeaderPosition);
        if MpegInfo.protection then
          LblDETProtection.Caption := 'Yes'
        else
          LblDETProtection.Caption := 'No';
        LblDETExtension.Caption := extensions[MpegInfo.layer][MpegInfo.extension];
        if MpegInfo.copyright then
          LblDETCopyright.Caption := 'Yes'
        else
          LblDETCopyright.Caption := 'No';
        if MpegInfo.original then
          LblDETOriginal.Caption := 'Yes'
        else
          LblDETOriginal.Caption := 'No';
        LblDETEmphasis.Caption := emphasis_values[MpegInfo.emphasis];
    end else
    begin
        LblDETBitrate.Caption := 'N/A';
        LblDETSamplerate.Caption := 'N/A';
        LblDETDauer.Caption   := 'N/A';
        LblDETVersion.Caption := 'N/A';
        LblDETHeaderAt.Caption   := 'N/A';
        LblDETProtection.Caption := 'N/A';
        LblDETExtension.Caption  := 'N/A';
        LblDETCopyright.Caption  := 'N/A';
        LblDETOriginal.Caption   := 'N/A';
        LblDETEmphasis.Caption   := 'N/A';
    end;
end;
{
    --------------------------------------------------------
    ShowID3v1Details
    --------------------------------------------------------
}
procedure TFDetails.ShowID3v1Details;
begin
  if ID3v1Activated then //ID3v1Tag.exists then
  begin
      Lblv1Artist.Text := Id3v1Tag.Artist;
      Lblv1Album.Text := Id3v1Tag.Album;
      Lblv1Titel.Text := Id3v1Tag.Title;
      Lblv1Year.Text := UnicodeString(Id3v1Tag.year);
      // hier den Itemindex nehmen - id3v1Genre kann nicht beliebig sein
      cbIDv1Genres.ItemIndex := cbIDv1Genres.Items.IndexOf(Id3v1Tag.genre);
      Lblv1Comment.Text := Id3v1Tag.Comment;
      Lblv1Track.Text := Id3v1Tag.Track;
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
    ShowPictures
    - Pictures within the id3-tag, Page 3.
    --------------------------------------------------------
}
procedure TFDetails.ShowPictures;
var i: Integer;
  stream: TMemoryStream;
  mime: AnsiString;
  PicType: Byte;
  Description: UnicodeString;
begin
    if assigned(PictureFrames) then
        FreeAndNil(PictureFrames);

    PictureFrames := ID3v2Tag.GetAllPictureFrames;
    cbPictures.Items.Clear;

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

        Btn_DeletePicture.Enabled := (Not Nemp_MainForm.NempOptions.DenyID3Edit) and  (cbPictures.Items.Count > 0);
        Btn_SavePictureToFile.Enabled := (cbPictures.Items.Count > 0);
        Btn_NewPicture.Enabled := Not Nemp_MainForm.NempOptions.DenyID3Edit;

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
{
    --------------------------------------------------------
    FillFrameView
    - Fills the list on page 4.
    --------------------------------------------------------
}
procedure TFDetails.FillFrameView;
var newItem: TListItem;
    FrameList: TObjectlist;
    i: Integer;
    lang: AnsiString;
    Description: UnicodeString;
    Value: UnicodeString;
begin
    LvFrames.Clear;

    FrameList := ID3v2Tag.GetAllURLFrames;
    for i := 0 to FrameList.Count - 1 do
    begin
        newItem := LvFrames.Items.Add;
        newItem.Caption := (FrameList[i] as TID3v2Frame).FrameTypeDescription;
        NewItem.SubItems.Add(UnicodeString((FrameList[i] as TID3v2Frame).GetURL));
        NewItem.Data := (FrameList[i] as TID3v2Frame);
    end;

    FrameList.Free;
    FrameList := ID3v2Tag.GetAllTextFrames;
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
    FrameList := ID3v2Tag.GetAllCommentFrames;
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
    FrameList := ID3v2Tag.GetAllUserDefinedURLFrames;
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
procedure TFDetails.ShowID3v2Details;
var tmp: UnicodeString;
begin
  if ID3v2Activated then //ID3v2Tag.exists then
  begin
        Lblv2Artist.Text := Id3v2Tag.Artist;
        Lblv2Album.Text := Id3v2Tag.Album;
        Lblv2Titel.Text := Id3v2Tag.Title;
        Lblv2Year.Text := Id3v2Tag.year;
        cbIDv2Genres.Text := Id3v2Tag.genre;

        tmp := StringReplace(id3v2Tag.comment, #10, ' ', [rfReplaceAll]);
        tmp := StringReplace(tmp, #13, ' ', [rfReplaceAll]);
        Lblv2Comment.Text := tmp;
        Lblv2Track.Text := Id3v2Tag.Track;

        DetailRatingHelper.DrawRatingInStarsOnBitmap(ActualRating, RatingImage.Picture.Bitmap, RatingImage.Width, RatingImage.Height);

        if IsValidYearString(Lblv2Year.Text)
        then
          Lblv2Year.Font.Color := clWindowText
        else
          Lblv2Year.Font.Color := clRed;

        if IsValidV2TrackString(Lblv2Track.Text) then
          Lblv2Track.Font.Color := clWindowText
        else
          Lblv2Track.Font.Color := clred;

        Lblv2_Version.Caption := '2.'+IntToStr(id3v2Tag.Version.Major) + '.' + IntToStr(id3v2Tag.Version.Minor);
        Lblv2_Size   .Caption := Format(DetailForm_ID3v2Info, [id3v2Tag.Size, id3v2Tag.Size - id3v2Tag.PaddingSize]);

        FillFrameView;

        Memo_Lyrics.Text := ID3v2Tag.Lyrics;

        ShowPictures;

        Lblv2Copyright.Text        := Id3v2Tag.Copyright;
////        Lblv2EncodedBy.Text        := Id3v2Tag.EncodedBy;
  end else
  begin
        Btn_DeletePicture.Enabled := False;
        Btn_NewPicture.Enabled := False;
        Btn_DeleteLyricFrame.Enabled := False;
        BtnLyricWiki.Enabled := False;
        Btn_SavePictureToFile.Enabled := False;

        ID3Image.Visible := False;

        // Sonderstatus Lyrics: Auch anzeigen, wenn Datei gerade nicht zu finden ist.
        if  (AktuellesAudioFile <> NIL)
          AND (AnsiLowerCase(ExtractFileExt(AktuellesAudioFile.Pfad))='.mp3')
          AND (not FileExists(AktuellesAudioFile.Pfad))
          AND (trim(UnicodeString(AktuellesAudioFile.Lyrics)) <> '')
          then
            // d.h. es ist ein mp3File, was gerade nicht da ist, das aber Lyrics in der DB hat
            Memo_Lyrics.Text :=  UTF8ToString(AktuellesAudioFile.Lyrics)
        else
            Memo_Lyrics.Text := '';

        Lblv2_Version.Caption := '';
        Lblv2_Size   .Caption := '';

        LvFrames.Clear;

        Lblv2Artist.Text := '';
        Lblv2Album.Text := '';
        Lblv2Titel.Text := '';
        Lblv2Year.Text := '';
        cbIDv2Genres.Text := '';
        Lblv2Comment.Text := '';
        Lblv2Track.Text := '0';
        Lblv2Copyright.Text        := '';
////        Lblv2EncodedBy.Text        := '';
  end;
end;

{
    --------------------------------------------------------
    ShowDetails
    - Show all available information
    --------------------------------------------------------
}
procedure TFDetails.ShowDetails(AudioFile:TAudioFile; Source: Integer = SD_MEDIENBIB);
begin


  // Hier auch die Abfrage zum Speichern rein
  if (not fForceChange) and CurrentFileHasBeenChanged then
  begin
      case MessageDLG((DetailForm_SaveChanges), mtConfirmation, [MBYes, MBNo, MBAbort], 0) of
        mrYes   : BtnApply.Click;   // save Changes
        mrNo    : ;                 // Nothing to do
        mrAbort : Exit;             // Abort showing Details
      end;
  end;


  if Source <> -1 then
    fFilefromMedienBib := Source = SD_MedienBib;

  AktuellesAudioFile := AudioFile;

  if (Nemp_MainForm.AutoShowDetailsTMP) AND (AktuellesAudioFile <> NIL) then
    FDetails.Visible := True
  else
    exit;

  PnlWarnung.Visible := False;

    // Das zuerst machen - hier wird ggf. Das WarnPanel auf der ersten Seite gesetzt
    // hinten machen - wegen Validmp3File, was für cbWriteRatingToTag.Enabled gebraucht wird
    //UpdateMediaBibEnabledStatus;
    //ShowMediaBibDetails;

  if (AnsiLowerCase(ExtractFileExt(AudioFile.Pfad))='.mp3')
    AND FileExists(AudioFile.Pfad) then
  begin
        ValidMp3File := True; // Positiv anfangen
        try
            if MedienBib.NempCharCodeOptions.  AutoDetectCodePage then
            begin
              ID3v1Tag.CharCode := GetCodepage(AudioFile.Pfad, MedienBib.NempCharCodeOptions);
              ID3v2Tag.CharCode := ID3v1Tag.CharCode;
            end; //else: Standardwerte behalten
            ID3v1Tag.AutoCorrectCodepage := MedienBib.NempCharCodeOptions.AutoDetectCodePage;
            ID3v2Tag.AutoCorrectCodepage := MedienBib.NempCharCodeOptions.AutoDetectCodePage;
            ID3v2Tag.AlwaysWriteUnicode := MedienBib.NempCharCodeOptions.AlwaysWriteUnicode;
            GetMp3Details(AudioFile.Pfad,mpegInfo,ID3v2Tag,ID3v1tag);
        except
            ValidMp3File := False;
            ID3v1Activated := False;
            ID3v2Activated := False;
            Lbl_Warnings.Caption := (Warning_ReadError);
            Lbl_Warnings.Hint := (Warning_ReadError_Hint);
            PnlWarnung.Visible := True;
        end;

        if ValidMp3File and (MpegInfo.FirstHeaderPosition = -1) then
        begin
             // Doch kein Valides MP3File
            ValidMp3File := False;
            ID3v1Activated := False;
            ID3v2Activated := False;
            Lbl_Warnings.Caption := (Warning_InvalidMp3file);
            Lbl_Warnings.Hint := (Warning_InvalidMp3file_Hint);
            PnlWarnung.Visible := True;
        end else
        begin
            ID3v1Activated := Id3v1Tag.Exists;
            ID3v2Activated := Id3v2Tag.Exists;
        end;
  end //if AudioFile.exists und ist .mp3
  else
  begin
        // Datei existiert nicht, oder ist kein mp3
        ValidMp3File := False;
        ID3v1Activated := False;
        ID3v2Activated := False;
  end;

  // Medien-Bib-Infos
  UpdateMediaBibEnabledStatus;
  ShowMediaBibDetails;

  // MPEG INFOS
  UpdateMPEGEnabledStatus;
  ShowMPEGDetails;
  // ID3Tags
  UpdateID3v1EnabledStatus;
  UpdateID3v2EnabledStatus;
  ShowID3v1Details;
  ShowID3v2Details;

  PictureHasChanged := False;
  ID3v1HasChanged := False;
  ID3v2HasChanged := False;
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
procedure TFDetails.UpdateID3v1InFile;
begin
  if ID3v1Activated and ValidMp3File then
  begin
    Id3v1Tag.Title := Lblv1Titel.Text;
    Id3v1Tag.Artist := Lblv1Artist.Text;
    Id3v1Tag.Album := Lblv1Album.Text;
    Id3v1Tag.Comment := Lblv1Comment.Text;
    Id3v1Tag.Genre := cbIDv1Genres.Text;
    Id3v1Tag.Track := Lblv1Track.Text;
    Id3v1Tag.Year := AnsiString(Lblv1Year.Text);
    id3v1Tag.WriteToFile(Dateipfad);
  end else
    id3v1Tag.RemoveFromFile(Dateipfad);
end;
procedure TFDetails.UpdateID3v2InFile;
begin
  //if (ID3v2Activated or (cbWriteRatingToTag.Checked and cbWriteRatingToTag.Enabled)) and ValidMp3File then
  if ID3v2Activated and ValidMp3File then
  begin
    Id3v2Tag.Title := Lblv2Titel.Text;
    Id3v2Tag.Artist := Lblv2Artist.Text;
    Id3v2Tag.Album := Lblv2Album.Text;
    Id3v2Tag.Comment := Lblv2Comment.Text;
    Id3v2Tag.Genre := cbIDv2Genres.Text;
    Id3v2Tag.Track := Lblv2Track.Text;
    Id3v2Tag.Year := Lblv2Year.Text;
    // weitere Frames
////    ID3v2Tag.EncodedBy := Lblv2EncodedBy.Text;
    ID3v2Tag.Copyright := Lblv2Copyright.Text;
    // Lyrics
    ID3v2Tag.Lyrics := Memo_Lyrics.Text;

    // Bewertung. Nur schreiben, wenn gechecked
    // No write always - rating-image is now an ID3v2-Page
    // if (cbWriteRatingToTag.Checked) and (cbWriteRatingToTag.Enabled) then
      ID3v2Tag.Rating := ActualRating;

    id3v2Tag.WriteToFile(Dateipfad);
  end else
    id3v2Tag.RemoveFromFile(Dateipfad);
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
  id3v2Tag.Lyrics := '';
  // Maybe there are some other Lyrics in the id3-tag ;-)
  Memo_Lyrics.Text := ID3v2Tag.Lyrics;
end;
procedure TFDetails.cbPicturesChange(Sender: TObject);
var stream: TMemorystream;
    mime: AnsiString;
    PicType: Byte;
    Description: UnicodeString;
begin
    stream := TMemoryStream.Create;
    try
        ID3Image.Visible := True;

        (PictureFrames[cbPictures.ItemIndex] as TID3v2Frame).GetPicture(Mime, PicType, Description, stream);
        PicStreamToImage(stream, Mime, ID3IMAGE.Picture.Bitmap);
    finally
      stream.Free;
    end;
end;
procedure TFDetails.Btn_NewPictureClick(Sender: TObject);
begin
  if Not Assigned(FNewPicture) then
    Application.CreateForm(TFNewPicture, FNewPicture);

  if FNewPicture.Showmodal = MROK then
      PictureHasChanged := True;

  ShowPictures;
end;
procedure TFDetails.Btn_DeletePictureClick(Sender: TObject);
begin
  Id3v2Tag.DeleteFrame(PictureFrames[cbPictures.ItemIndex] as TID3v2Frame );
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
    Description: UnicodeString;
begin
    Stream := TMemoryStream.Create;
    try
        (PictureFrames[cbPictures.ItemIndex] as TID3v2Frame).GetPicture(Mime, PicType, Description, Stream);
        if (mime = 'image/png') or (Uppercase(UnicodeString(Mime)) = 'PNG') then
        begin
          SaveDialog1.DefaultExt := 'png';
          SaveDialog1.Filter := '*.png|*.png;';
        end else
        begin
          SaveDialog1.DefaultExt := 'jpg';
          SaveDialog1.Filter := '*.jpg;*.jpeg;|*.jpg;*.jpeg;';
        end;
        if SaveDialog1.execute then
        begin
          try
              Stream.SaveToFile(saveDialog1.FileName);
          except
              on E: Exception do MessageDLG(E.Message, mtError, [mbOK], 0);
          end;
        end;

    finally
        stream.Free;
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
          Memo_Lyrics.SelectAll;
        end;
  end;
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
var LyricWikiResponse: String;
    LyricQuery: AnsiString;
    Lyrics: TLyrics;
    LyricString: String;
begin

        if Fileexists(AktuellesAudioFile.Pfad)
           AND (AnsiLowerCase(ExtractFileExt(AktuellesAudioFile.Pfad))='.mp3')
        then
        begin
            AktuellesAudioFile.FileIsPresent:=True;
            Lyrics := TLyrics.Create;
            try
                LyricString := Lyrics.GetLyrics(AktuellesAudioFile.Artist, AktuellesAudioFile.Titel);

                if LyricString = '' then
                begin
                    if Lyrics.ExceptionOccured then
                        // no connection
                        MessageDlg(MediaLibrary_LyricsFailed, mtWarning, [MBOK], 0)
                    else
                    begin
                        // no lyrics found
                        if (MessageDlg(LyricsSearch_NotFoundMessage, mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
                            BtnLyricWikiManual.Click;
                    end;
                end else
                begin
                    // ok, Lyrics found
                    Memo_Lyrics.Text := LyricString;
                    ID3v2HasChanged := True;
                end;
            finally
                Lyrics.Free;
            end;
            (*
            {$Message Hint 'Hier UTF8-Konzept überdenken'}
            {LyricQuery := 'http://lyricwiki.org/api.php?func=getSong&artist='
                        + StringToURLString(WordUppercase(UTF8Encode((AktuellesAudioFile.Artist))))
                        + '&song='
                        + StringToURLString(WordUppercase(UTF8Encode((AktuellesAudioFile.Titel))))
                        + '&fmt=text';
            }
            LyricQuery := 'http://lyricwiki.org/api.php?func=getSong&artist='
                        + StringToURLStringAND(UTF8Encode(WordUppercase((AktuellesAudioFile.Artist))))
                        + '&song='
                        + StringToURLStringAND(UTF8Encode(WordUppercase((AktuellesAudioFile.Titel))))
                        + '&fmt=text';


            try

                LyricWikiResponse := idHttp1.Get(String(LyricQuery));

                //showmessage(LyricWikiResponse);

                LyricWikiResponse := StringReplace(LyricWikiResponse, #10, #13#10, [rfReplaceAll]);

                If Trim(LyricWikiResponse) <> 'Not found' then
                begin
                    Memo_Lyrics.Text := ReplaceGeneralEntities(trim(LyricWikiResponse));
                end else
                    if (MessageDlg(LyricsSearch_NotFoundMessage, mtConfirmation, [mbYes, mbNo], 0) = mrYes) then
                    begin
                        BtnLyricWikiManual.Click;
                        {//LyricQuery := StringReplace(AktuellesAudioFile.Artist, ' ', '+', [rfReplaceAll])
                        //       + '+' + StringReplace(AktuellesAudioFile.Titel, ' ', '+', [rfReplaceAll]);
                        LyricQuery := StringToURLStringAnd(UTF8Encode(
                                StringReplace(AktuellesAudioFile.Artist, ' ', '+', [rfReplaceAll]) + '+' +
                                StringReplace(AktuellesAudioFile.Titel, ' ', '+', [rfReplaceAll])));

                        LyricQuery :=
                          'http://lyricwiki.org/Special:GoogleSearchResults?cx=partner-pub-7265006513689515%3Aenbi50a4igp&cof=FORID%3A9&ie=UTF-8&q='
                          + LyricQuery
                          + '&sa=Search';
                        ShellExecuteA(Handle, 'open', PAnsiChar(LyricQuery), nil, nil, SW_SHOW);
                        }
                    end;
            except
                MessageDlg(MediaLibrary_LyricsFailed, mtWarning, [MBOK], 0);
            end;
            *)

        end
        else
            AktuellesAudioFile.FileIsPresent:=False;
end;
procedure TFDetails.BtnLyricWikiManualClick(Sender: TObject);
var LyricQuery: AnsiString;
begin

//    LyricQuery := StringToURLStringAnd(UTF8Encode(
//                  StringReplace(AktuellesAudioFile.Artist, ' ', '+', [rfReplaceAll]) + '+' +
//                  StringReplace(AktuellesAudioFile.Titel, ' ', '+', [rfReplaceAll])));

//    LyricQuery :=
//    Format('http://lyrics.wikia.com/Special:Search?search=%s&go=1&x=0&y=0', [LyricQuery]);

    LyricQuery := 'http://lyrics.wikia.com';

    ShellExecuteA(Handle, 'open', PAnsiChar(LyricQuery), nil, nil, SW_SHOW);
end;

{
    --------------------------------------------------------
    SearchAndUpdateFileInMB
    - if a AudioFile from the Playlist was modified, it should
      be changed in the library as well. This is done here.
    --------------------------------------------------------
}
procedure TFDetails.SearchAndUpdateFileInMB;
var mbAudioFile: TAudioFile;
    oldCoverID: String;
begin
    if (MedienBib.StatusBibUpdate > 0) then
    begin
      MessageDLG((Warning_MedienBibIsBusy), mtWarning, [MBOK], 0);
      exit;
    end;

    // Datei in der MedienBib Suchen und erneuern
    mbAudioFile := MedienBib.GetAudioFileWithFilename(AktuellesAudioFile.Pfad);
    if assigned(mbAudioFile) then
    begin
      mbAudioFile.Rating := ActualRating;
      // backup der CoverID
      oldCoverID := mbAudioFile.CoverID;
      mbAudioFile.GetAudioData(AktuellesAudioFile.Pfad, GAD_Cover or GAD_Rating);
      // Falls CoverID jetzt '', dann ist im ID3-Tag (immer noch) kein Cover drin
      if mbAudioFile.CoverID = '' then
          mbAudioFile.CoverID := oldCoverID;

      if Not MedienBib.ValidKeys(mbAudioFile) then
      begin
          SetBrowseTabWarning(True);
          // MedienBib.RestoreSortOrderAfterItemChanged(mbAudioFile); // mbAudioFile, nicht AktuellesAudioFile !
          // Nemp_MainForm.ReFillBrowseTrees(True);
      end;
      MedienBib.Changed := True;
    end;
end;


function TFDetails.CurrentFileHasBeenChanged: Boolean;
begin
    result := False;
    if Not assigned(aktuellesAudioFile) then
        exit; // no current AudioFile, no changes.

    if not ValidMp3File then
        exit;                 // we can't edit non-mp3-Files here

    // aktuellesAudiofile is not NIL here.
    if (Id3v1Tag.Exists <> CBID3v1.Checked)
        or (Id3v2Tag.Exists <> CBID3v2.Checked)
    then
    begin
        result := True;     // User changed existance of the ID3Tags
        exit;
    end;

    if (Id3v1Tag.Exists) and (CBID3v1.Checked)  // ID3v1Tag exists
        and ID3v1HasChanged                     // and changed
    then
    begin
        result := True;
        exit;
    end;

    if (Id3v2Tag.Exists) and (CBID3v2.Checked)  // ID3v2Tag exists
        and
        (
          ID3v2HasChanged                      // and changed
          or PictureHasChanged
          or(ActualRating <> AktuellesAudioFile.Rating)
        )
    then
    begin
        result := True;
        exit;
    end;
end;


end.

