{

    Unit PartyModeClass

    - a class for the Party-Mode in Nemp
      e.g. resizing of the controls

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2005-2019, Daniel Gaussmann
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


unit PartyModeClass;

interface

uses Windows, Forms, Controls, StdCtrls, Classes, SysUtils, SkinButtons,
    Nemp_ConstantsAndTypes, IniFiles, math, Details, Nemp_RessourceStrings
    ,SplitForm_Hilfsfunktionen
    ;

type
    TChangeProc = function(value: Integer): Integer of Object;

    TPosRecord = record
        Left: Integer;
        Top: Integer;
        Width: Integer;
        Height: Integer;
        FontSize: Integer;
    end;

    TNempPartyMode = Class
      private
          fActive: Boolean;
          fResizeProc: TChangeProc;
          // fLastTopHeight: Integer;
          flastHeight: Integer;
          fLastWidth: Integer;

          // settings
          fResizeFactor: Single;  // resize-factor
          fPassword: String;      // password, needed to deactivatre Party-Mode
          fBlockTreeEdit: Boolean;     // block editing inside the StringTree
          // (always block) fBlockDetailWindow: Boolean; // block showing the Detailform
          fBlockCurrentTitleRating: Boolean; // block editing the rating of the current title
          // (Always block) fBlockBibOperations: Boolean;     // Block adding, deleting, Get Tags, lyrics, reset rating, ... of files
          fBlockTools: Boolean;            // Block tools like Birthday, Scrobbler, ...

          fShowPasswordOnActivate: Boolean;


          // Array of PlayerControls/Positions.
          // These are "completely doubled" i.e. width, height,top, left
          fPartyControls: Array of TControl;
          fPositionArray: Array of TPosRecord;
          // Some additional Controls, not "completely doubled"
          // Only e.g. Height, Left, Top, but not Width.
          fAdditionalControls: Array of TControl;
          fAdditionalPositionsArray: Array of TPosrecord;

          procedure CorrectMainForm;
          procedure CorrectMenuStff;

          procedure SetActive(value: Boolean);
          procedure SetScaleFactor(Value: Single);
          procedure SetOriginalPosition(aControl: TControl; var aIndex: Integer);
          procedure SetAdditionalOriginalPosition(aControl: TControl; var aIndex: Integer);

      public
          property Active: Boolean read fActive write SetActive;
          property ResizeProc: TChangeProc read fResizeProc;

          property ResizeFactor: Single read fResizeFactor write SetScaleFactor;
          property BlockTreeEdit          : Boolean read fBlockTreeEdit           write fBlockTreeEdit           ;
          // property BlockDetailWindow      : Boolean read fBlockDetailWindow       write fBlockDetailWindow       ;
          property BlockCurrentTitleRating: Boolean read fBlockCurrentTitleRating write fBlockCurrentTitleRating ;
          // property BlockBibOperations     : Boolean read fBlockBibOperations      write fBlockBibOperations      ;
          property BlockTools             : Boolean read fBlockTools              write fBlockTools              ;
          property ShowPasswordOnActivate : boolean read fShowPasswordOnActivate write fShowPasswordOnActivate;

          property password: String read fPassword write fPassword;
          constructor Create;

          procedure LoadSettings;
          procedure SaveSettings;
          // FactorToIndex: Transform the 0, 1.5, 2, 2.5 into 0, 1, 2, 3
          // These Integers are used for the ComboBox in the OptionsDialog and in the Inifile.
          function FactorToIndex: Integer;
          function IndexToFactor(value: Integer): single;

          procedure BackupOriginalPositions;

          procedure SetButtonPos(aButton: TNempButtonData; var aIndex: Integer); // used by Skin.SetButtonsizes

          function Bigger(value: Integer): Integer;
          function Smaller(value: Integer): Integer;
          function Equal(value: Integer): Integer;

          // Pseudo-Getter for properties. AND with fActive.
          function DoBlockTreeEdit          : Boolean;
          function DoBlockDetailWindow      : Boolean;
          function DoBlockCurrentTitleRating: Boolean;
          function DoBlockBibOperations     : Boolean;
          function DoBlockTools             : Boolean;

    end;



implementation

uses NempMainUnit, MainFormHelper, spectrum_vis, TreeHelper, OptionsComplete;


{ TNempPartyMode }

constructor TNempPartyMode.Create;
begin
    fActive := False;
    fResizeProc := Equal;

    fResizeFactor := 1.5;
end;

function TNempPartyMode.DoBlockBibOperations: Boolean;
begin
    result := fActive;
end;

function TNempPartyMode.DoBlockCurrentTitleRating: Boolean;
begin
    result := fActive and fBlockCurrentTitleRating;
end;

function TNempPartyMode.DoBlockDetailWindow: Boolean;
begin
    result := fActive;
end;

function TNempPartyMode.DoBlockTools: Boolean;
begin
    result := fActive and fBlockTools;
end;

function TNempPartyMode.DoBlockTreeEdit: Boolean;
begin
    result := fActive and fBlockTreeEdit;
end;

procedure TNempPartyMode.LoadSettings;
var tmp: Integer;
begin
    tmp := NempSettingsManager.ReadInteger('PartyMode', 'Factor', 1);
    fResizeFactor := IndexToFactor(tmp);

    fBlockTreeEdit            := NempSettingsManager.ReadBool('PartyMode', 'BlockTreeEdit'          , True);
    fBlockCurrentTitleRating  := NempSettingsManager.ReadBool('PartyMode', 'BlockCurrentTitleRating', True);
    fBlockTools               := NempSettingsManager.ReadBool('PartyMode', 'BlockTools'             , True);
    fPassword                 := NempSettingsManager.ReadString('PartyMode', 'Password'             , 'nemp');
    fShowPasswordOnActivate   := NempSettingsManager.ReadBool('PartyMode', 'fShowPasswordOnActivate', True);
end;


procedure TNempPartyMode.SaveSettings;
begin
    NempSettingsManager.WriteInteger('PartyMode', 'Factor', FactorToIndex);
    NempSettingsManager.WriteBool('PartyMode', 'BlockTreeEdit'          , fBlockTreeEdit          );
    NempSettingsManager.WriteBool('PartyMode', 'BlockCurrentTitleRating', fBlockCurrentTitleRating);
    NempSettingsManager.WriteBool('PartyMode', 'BlockTools'             , fBlockTools             );
    NempSettingsManager.WriteString('PartyMode', 'Password'             , fPassword               );
    NempSettingsManager.WriteBool('PartyMode', 'fShowPasswordOnActivate', fShowPasswordOnActivate );
end;


function TNempPartyMode.Equal(value: Integer): Integer;
begin
    result := value;
end;

function TNempPartyMode.FactorToIndex: Integer;
begin
    if sameValue(fResizeFactor, 1, 0.001) then
        result := 0
    else if sameValue(fResizeFactor, 1.5, 0.001) then
        result := 1
    else if sameValue(fResizeFactor, 2, 0.001) then
        result := 2
    else if sameValue(fResizeFactor, 2.5, 0.001) then
        result := 3
    else
        result := 1;
end;

function TNempPartyMode.IndexToFactor(value: Integer): single;
begin
    case value of
        0: result := 1;
        1: result := 1.5;
        2: result := 2;
        3: result := 2.5;
    else
        result := 1.5;
    end;
end;

function TNempPartyMode.Bigger(value: Integer): Integer;
begin
    result := Round(value *  fResizeFactor);
end;

function TNempPartyMode.Smaller(value: Integer): Integer;
begin
    result := Round( value / fResizeFactor);
end;


procedure TNempPartyMode.SetOriginalPosition(aControl: TControl; var aIndex: Integer);
begin
    fPartyControls[aIndex] := aControl;
    fPositionArray[aIndex].Left := aControl.Left;
    fPositionArray[aIndex].Top  := aControl.Top;
    fPositionArray[aIndex].Width := aControl.Width;
    fPositionArray[aIndex].Height := aControl.Height;
    if (aControl is TLabel) then
        fPositionArray[aIndex].FontSize := (aControl as tLabel).Font.Size;
    inc(aIndex);
end;

procedure TNempPartyMode.SetAdditionalOriginalPosition(aControl: TControl; var aIndex: Integer);
begin
    fAdditionalControls[aIndex] := aControl;
    fAdditionalPositionsArray[aIndex].Left := aControl.Left;
    fAdditionalPositionsArray[aIndex].Top  := aControl.Top;
    fAdditionalPositionsArray[aIndex].Width := aControl.Width;
    fAdditionalPositionsArray[aIndex].Height := aControl.Height;
    if (aControl is TLabel) then
        fAdditionalPositionsArray[aIndex].FontSize := (aControl as TLabel).Font.Size;
    if (aControl is TEdit) then
        fAdditionalPositionsArray[aIndex].FontSize := (aControl as TEdit).Font.Size;
    inc(aIndex);
end;


procedure TNempPartyMode.SetButtonPos(aButton: TNempButtonData; var aIndex: Integer);
begin
    fPositionArray[aIndex].Left := aButton.Left;
    fPositionArray[aIndex].Top  := aButton.Top;
    fPositionArray[aIndex].Width := aButton.Width;
    fPositionArray[aIndex].Height := aButton.Height;
    inc(aIndex);
end;


procedure TNempPartyMode.BackupOriginalPositions;
var i: Integer;
begin
    // Store original positions of controls in an array
    Setlength(fPositionArray, 56);  // 114
    SetLength(fPartyControls, 56);
    i := 0;
    with Nemp_MainForm do
    begin
        // The first 11 Controls are skinnable
        // i.e. sizes and positions may vary on different skins
        // Note: The first eight MUST be in the same Order as in
        //       TControlButtons !
        // 8 Player-Controls
        SetOriginalPosition(PlayPauseBTN        , i);
        SetOriginalPosition(StopBTN             , i);
        SetOriginalPosition(PlayNextBTN         , i);
        SetOriginalPosition(PlayPrevBTN         , i);
        SetOriginalPosition(SlideForwardBTN     , i);
        SetOriginalPosition(SlideBackBTN        , i);
        SetOriginalPosition(RandomBtn           , i);
        SetOriginalPosition(RecordBtn           , i);
        SetOriginalPosition(PlayPauseHeadSetBtn    , i);
        SetOriginalPosition(StopHeadSetBtn         , i);
        SetOriginalPosition(BtnHeadsetPlaynow      , i);
        SetOriginalPosition(BtnHeadsetToPlaylist   , i);
        SetOriginalPosition(BtnMinimize         , i);
        SetOriginalPosition(BtnClose            , i);

        // ==============================
        SetOriginalPosition(VolButton           , i);
        SetOriginalPosition(VolumeImage         , i);

        // controls in Slide-part
        SetOriginalPosition(PlayerArtistLabel   , i);
        SetOriginalPosition(PlayerTitleLabel    , i);
        SetOriginalPosition(RatingImage         , i);

        // Other Controls
        SetOriginalPosition(ab1                 , i);
        SetOriginalPosition(ab2                 , i);

        SetOriginalPosition(LyricsMemo          , i);

        // HeadsetControls
        SetOriginalPosition(lblHeadphoneControl    , i);
        SetOriginalPosition(BtnLoadHeadset         , i); // disabled right now
        SetOriginalPosition(VolButtonHeadset       , i);
        SetOriginalPosition(VolShapeHeadset        , i);

        SetOriginalPosition(VolShape            , i);
        SetOriginalPosition(VolumeImageHeadset  , i);

        // "Tab"-Buttons
        SetOriginalPosition(TabBtn_Cover        , i);
        SetOriginalPosition(TabBtn_SummaryLock  , i);
        SetOriginalPosition(TabBtn_Equalizer    , i);
        SetOriginalPosition(TabBtn_MainPlayerControl , i);
        SetOriginalPosition(TabBtn_Headset      , i);

        SetOriginalPosition(TabBtn_Preselection0 , i);
        SetOriginalPosition(TabBtn_Browse0       , i);
        SetOriginalPosition(TabBtn_CoverFlow0    , i);
        SetOriginalPosition(TabBtn_TagCloud0     , i);
        //
        SetOriginalPosition(TabBtn_Preselection1 , i);
        SetOriginalPosition(TabBtn_Browse1       , i);
        SetOriginalPosition(TabBtn_CoverFlow1    , i);
        SetOriginalPosition(TabBtn_TagCloud1     , i);
        //
        SetOriginalPosition(TabBtn_Preselection2 , i);
        SetOriginalPosition(TabBtn_Browse2       , i);
        SetOriginalPosition(TabBtn_CoverFlow2    , i);
        SetOriginalPosition(TabBtn_TagCloud2     , i);

        SetOriginalPosition(TabBtn_Playlist     , i);
        SetOriginalPosition(TabBtn_Medialib     , i);
        SetOriginalPosition(TabBtn_Marker       , i);
        SetOriginalPosition(TabBtn_Favorites    , i);
        SetOriginalPosition(TabBtnTagCloudCategory, i);
        SetOriginalPosition(TabBtnCoverCategory, i);


        Setlength(fPositionArray, i);
        SetLength(fPartyControls, i);

        // Additional Controls
        i := 0;
        Setlength(fAdditionalControls, 41);
        SetLength(fAdditionalPositionsArray, 41);

        SetAdditionalOriginalPosition(AuswahlHeaderPanel0, i);
        SetAdditionalOriginalPosition(AuswahlControlPanel0, i);
        SetAdditionalOriginalPosition(AuswahlStatusLBL0, i);
        SetAdditionalOriginalPosition(TreePanel, i);

        SetAdditionalOriginalPosition(PlayerHeaderPanel, i);
        SetAdditionalOriginalPosition(PlaylistControlPanel, i);
        SetAdditionalOriginalPosition(PlayListStatusLBL, i);
        SetAdditionalOriginalPosition(GRPBOXPlaylist   , i);

        SetAdditionalOriginalPosition(MedienBibHeaderPanel, i);
        SetAdditionalOriginalPosition(MedienListeControlPanel, i);
        SetAdditionalOriginalPosition(MedienListeStatusLBL, i);
        SetAdditionalOriginalPosition(GRPBOXVST           , i);

        SetAdditionalOriginalPosition(EDITFastSearch     , i);
        SetAdditionalOriginalPosition(Lbl_CoverFlow      , i);
        SetAdditionalOriginalPosition(EditPlaylistSearch , i);

        SetAdditionalOriginalPosition(MedienBibDetailHeaderPanel, i);
        SetAdditionalOriginalPosition(MedienBibDetailControlPanel, i);
        SetAdditionalOriginalPosition(MedienBibDetailStatusLbl, i);
        SetAdditionalOriginalPosition(ContainerPanelMedienBibDetails, i);


        SetAdditionalOriginalPosition(_ControlPanel              , i);

        SetAdditionalOriginalPosition(ControlContainer1          , i);
        SetAdditionalOriginalPosition(  OutputControlPanel       , i);
        SetAdditionalOriginalPosition(  PlayerControlCoverPanel  , i);
        SetAdditionalOriginalPosition(  PlayerControlPanel       , i);
        SetAdditionalOriginalPosition(  HeadsetControlPanel      , i);
        SetAdditionalOriginalPosition(ControlContainer2          , i);
        SetAdditionalOriginalPosition(NewPlayerPanel             , i);
        SetAdditionalOriginalPosition(SlideBarShape   , i);
        SetAdditionalOriginalPosition(SlideBarButton  , i);
        SetAdditionalOriginalPosition(PlayerTimeLbl   , i);
        SetAdditionalOriginalPosition(PaintFrame      , i);

        //
        SetAdditionalOriginalPosition(AuswahlHeaderPanel1, i);
        SetAdditionalOriginalPosition(AuswahlControlPanel1, i);
        SetAdditionalOriginalPosition(AuswahlStatusLBL1, i);
        SetAdditionalOriginalPosition(CoverFlowPanel, i);
        //
        SetAdditionalOriginalPosition(AuswahlHeaderPanel2, i);
        SetAdditionalOriginalPosition(AuswahlControlPanel2, i);
        SetAdditionalOriginalPosition(AuswahlStatusLBL2, i);
        SetAdditionalOriginalPosition(CloudPanel, i);
        SetAdditionalOriginalPosition(edtCloudSearch, i);

        SetAdditionalOriginalPosition(Pnl_CoverFlowLabel, i);
        //SetAdditionalOriginalPosition(, i);

    end;
end;


procedure TNempPartyMode.CorrectMainForm;
var ChangeProc: TChangeProc;
    i, currentLeft, SlideBarDiff: Integer;
    c: tControl;
begin
    if fActive then
    begin
        ChangeProc := Bigger;
        fResizeProc := Bigger;
        fLastHeight    := Nemp_MainForm.Height;
        fLastWidth     := Nemp_MainForm.Width;
    end
    else
    begin
        ChangeProc := Equal; //Smaller;
        fResizeProc := Equal;
    end;

    // Update MainWindow
    with Nemp_MainForm do
    begin
        for i := 0 to length(fPartyControls) - 1 do
        begin

                c := fPartyControls[i];
                c.Top := ChangeProc( fPositionArray[i].Top   );
                c.Left := ChangeProc(fPositionArray[i].Left);
                c.Width := ChangeProc(fPositionArray[i].Width);
                // Cast to SkinButton is needed, as in the
                // width/Height-setter the Region of the Button is set!
                if (c is TSkinButton) then
                begin
                    // important: Set DoubleSize first!
                    {(c as TSkinButton).DoubleSized := d;
                    if d then
                        (c as TSkinButton).StretchFactor := fResizeFactor
                    else
                        (c as TSkinButton).StretchFactor := 1;
                    }
                    (c as TSkinButton).Height := ChangeProc(fPositionArray[i].Height);
                end
                else
                    c.Height := ChangeProc(fPositionArray[i].Height);

                if (c is TLabel) then
                    (c as TLabel).Font.Size := ChangeProc(fPositionArray[i].FontSize);
        end;

        // Additional Controls
        AuswahlHeaderPanel0.Height := ChangeProc(fAdditionalPositionsArray[0].Height);
        AuswahlControlPanel0.Width := ChangeProc(fAdditionalPositionsArray[1].Width);
        AuswahlStatusLBL0.Top := ChangeProc(fAdditionalPositionsArray[2].Top);
        AuswahlStatusLBL0.Height := ChangeProc(fAdditionalPositionsArray[2].Height);
        AuswahlStatusLBL0.Font.Size := ChangeProc(fAdditionalPositionsArray[2].FontSize);
        //
        AuswahlHeaderPanel1.Height := ChangeProc(fAdditionalPositionsArray[31].Height);
        AuswahlControlPanel1.Width := ChangeProc(fAdditionalPositionsArray[32].Width);
        AuswahlStatusLBL1.Top := ChangeProc(fAdditionalPositionsArray[33].Top);
        AuswahlStatusLBL1.Height := ChangeProc(fAdditionalPositionsArray[33].Height);
        AuswahlStatusLBL1.Font.Size := ChangeProc(fAdditionalPositionsArray[33].FontSize);
        //
        AuswahlHeaderPanel2.Height := ChangeProc(fAdditionalPositionsArray[35].Height);
        AuswahlControlPanel2.Width := ChangeProc(fAdditionalPositionsArray[36].Width);
        AuswahlStatusLBL2.Top := ChangeProc(fAdditionalPositionsArray[37].Top);
        AuswahlStatusLBL2.Height := ChangeProc(fAdditionalPositionsArray[37].Height);
        AuswahlStatusLBL2.Font.Size := ChangeProc(fAdditionalPositionsArray[37].FontSize);
        edtCloudSearch.Height := ChangeProc(fAdditionalPositionsArray[39].Height);
        edtCloudSearch.Width := ChangeProc(fAdditionalPositionsArray[39].Width);
        edtCloudSearch.Left := ChangeProc(fAdditionalPositionsArray[39].Left);
        edtCloudSearch.Top := ChangeProc(fAdditionalPositionsArray[39].Top);
        edtCloudSearch.Font.Size := ChangeProc(fAdditionalPositionsArray[39].FontSize);

        PlayerHeaderPanel.Height := ChangeProc(fAdditionalPositionsArray[4].Height);
        PlaylistControlPanel.Width := ChangeProc(fAdditionalPositionsArray[5].Width);
        PlayListStatusLBL.Top := ChangeProc(fAdditionalPositionsArray[6].Top);
        PlayListStatusLBL.Height := ChangeProc(fAdditionalPositionsArray[6].Height);
        PlayListStatusLBL.Font.Size := ChangeProc(fAdditionalPositionsArray[6].FontSize);
        EditPlaylistSearch.Height := ChangeProc(fAdditionalPositionsArray[14].Height);
        EditPlaylistSearch.Width := ChangeProc(fAdditionalPositionsArray[14].Width);
        EditPlaylistSearch.Left := ChangeProc(fAdditionalPositionsArray[14].Left);
        EditPlaylistSearch.Top := ChangeProc(fAdditionalPositionsArray[14].Top);
        EditPlaylistSearch.Font.Size := ChangeProc(fAdditionalPositionsArray[14].FontSize);

        MedienBibHeaderPanel.Height := ChangeProc(fAdditionalPositionsArray[8].Height);
        MedienListeControlPanel.Width := ChangeProc(fAdditionalPositionsArray[9].Width);
        MedienListeStatusLBL.Top := ChangeProc(fAdditionalPositionsArray[10].Top);
        MedienListeStatusLBL.Height := ChangeProc(fAdditionalPositionsArray[10].Height);
        MedienListeStatusLBL.Font.Size := ChangeProc(fAdditionalPositionsArray[10].FontSize);
        EDITFastSearch.Height := ChangeProc(fAdditionalPositionsArray[12].Height);
        EDITFastSearch.Width := ChangeProc(fAdditionalPositionsArray[12].Width);
        EDITFastSearch.Left := ChangeProc(fAdditionalPositionsArray[12].Left);
        EDITFastSearch.Top := ChangeProc(fAdditionalPositionsArray[12].Top);
        EDITFastSearch.Font.Size := ChangeProc(fAdditionalPositionsArray[12].FontSize);

        Pnl_CoverFlowLabel.Height := ChangeProc(fAdditionalPositionsArray[40].Height);
        Pnl_CoverFlowLabel.Top := CoverScrollbar.Top - Pnl_CoverFlowLabel.Height - 4;
        Lbl_CoverFlow.Height := ChangeProc(fAdditionalPositionsArray[13].Height);
        Lbl_CoverFlow.Font.Size := ChangeProc(fAdditionalPositionsArray[13].FontSize);
        Lbl_CoverFlow.Top := (Pnl_CoverFlowLabel.Height Div 2) - (Lbl_CoverFlow.Height Div 2);

        MedienBibDetailHeaderPanel.Height := ChangeProc(fAdditionalPositionsArray[15].Height);
        MedienBibDetailControlPanel.Width   := ChangeProc(fAdditionalPositionsArray[16].Width);
        MedienBibDetailStatusLbl.Top       := ChangeProc(fAdditionalPositionsArray[17].Top);
        MedienBibDetailStatusLbl.Height    := ChangeProc(fAdditionalPositionsArray[17].Height);
        MedienBibDetailStatusLbl.Font.Size := ChangeProc(fAdditionalPositionsArray[17].FontSize);
        // ContainerPanelMedienBibDetails.Top := ChangeProc(fAdditionalPositionsArray[18].Top);

        // PlayerControls (more difficult now)

        _ControlPanel           .Height := ChangeProc(fAdditionalPositionsArray[19].Height);
        ControlContainer1       .Height := ChangeProc(fAdditionalPositionsArray[20].Height);
        ControlContainer2       .Height := ChangeProc(fAdditionalPositionsArray[25].Height);
        OutputControlPanel      .Height := ChangeProc(fAdditionalPositionsArray[21].Height);
        PlayerControlCoverPanel .Height := ChangeProc(fAdditionalPositionsArray[22].Height);
        PlayerControlPanel      .Height := ChangeProc(fAdditionalPositionsArray[23].Height);
        HeadsetControlPanel     .Height := ChangeProc(fAdditionalPositionsArray[24].Height);
        NewPlayerPanel          .Height := ChangeProc(fAdditionalPositionsArray[26].Height);

        //ControlContainer1.Width := ChangeProc(fAdditionalPositionsArray[20].Width);
        OutputControlPanel      .Width  := ChangeProc(fAdditionalPositionsArray[21].Width);
        PlayerControlPanel      .Width  := ChangeProc(fAdditionalPositionsArray[23].Width);
        HeadsetControlPanel     .Width  := ChangeProc(fAdditionalPositionsArray[24].Width);

        if PlayerControlCoverPanel.Visible then
            currentLeft := OutputControlPanel.Left + OutputControlPanel.Width + PlayerControlCoverPanel.Width
        else
            currentLeft := OutputControlPanel.Left + OutputControlPanel.Width;
        PlayerControlPanel .Left := currentLeft;
        HeadsetControlPanel.Left := currentLeft;
        currentLeft := currentLeft + PlayerControlPanel.Width;
        ControlContainer1.Width := currentLeft;
        ControlContainer2.Left := ControlContainer1.Width;

        // some Controls in the Player-Slide-Panel
        currentLeft := SlideBarShape.Left;
        SlideBarShape.Left := ChangeProc(fAdditionalPositionsArray[27].Left);
        // shorten the slidebar a little bit
        SlideBarDiff := (SlideBarShape.Left - currentLeft);

        // Set it later, after TimLbl is also set
        // SlideBarShape.Width := SlideBarShape.Width - (SlideBarShape.Left - currentLeft);

        SlideBarButton.Width := ChangeProc(fAdditionalPositionsArray[28].Width);

        // top
        SlideBarShape  .Top := ChangeProc(fAdditionalPositionsArray[27].Top);
        SlideBarButton .Top := ChangeProc(fAdditionalPositionsArray[28].Top);
        //ab1            .Top := ChangeProc(fAdditionalPositionsArray[29].Top);
        //ab2            .Top := ChangeProc(fAdditionalPositionsArray[30].Top);
        PlayerTimeLbl  .Top := ChangeProc(fAdditionalPositionsArray[29].Top);
        PaintFrame     .Top := ChangeProc(fAdditionalPositionsArray[30].Top);
        // Height
        SlideBarShape  .Height := ChangeProc(fAdditionalPositionsArray[27].Height);
        SlideBarButton .Height := ChangeProc(fAdditionalPositionsArray[28].Height);
        //ab1            .Height := ChangeProc(fAdditionalPositionsArray[29].Height);
        //ab2            .Height := ChangeProc(fAdditionalPositionsArray[30].Height);
        PlayerTimeLbl  .Height := ChangeProc(fAdditionalPositionsArray[29].Height);
        PaintFrame     .Height := ChangeProc(fAdditionalPositionsArray[30].Height);

        currentLeft := PaintFrame.Width;
        PaintFrame.Width := ChangeProc(fAdditionalPositionsArray[30].Width);
        PaintFrame.Left := PaintFrame.Left - (PaintFrame.Width - currentLeft);

        currentLeft := PlayerTimeLbl.Width;
        PlayerTimeLbl.Width := ChangeProc(fAdditionalPositionsArray[29].Width);
        PlayerTimeLbl.Font.Size  := ChangeProc(fAdditionalPositionsArray[29].FontSize);
        PlayerTimeLbl.Left := PlayerTimeLbl.Left - (PlayerTimeLbl.Width - currentLeft);

        SlideBarDiff := SlideBarDiff + (PlayerTimeLbl.Width - currentLeft);
        SlideBarShape.Width := SlideBarShape.Width - SlideBarDiff;

        // =================================

        PlaylistVST.Font.Size := ChangeProc(NempOptions.DefaultFontSize);
        ArtistsVST.Font.Size  := ChangeProc(NempOptions.ArtistAlbenFontSize);
        AlbenVST.Font.Size    := ChangeProc(NempOptions.ArtistAlbenFontSize);
        VST.Font.Size         := ChangeProc(NempOptions.DefaultFontSize);

        ArtistsVST.DefaultNodeHeight  := ChangeProc(NempOptions.ArtistAlbenRowHeight);
        AlbenVST.DefaultNodeHeight    := ChangeProc(NempOptions.ArtistAlbenRowHeight);
        VST.DefaultNodeHeight         := ChangeProc(NempOptions.RowHeight);
        PlaylistVST.DefaultNodeHeight := ChangeProc(NempOptions.RowHeight);


        ReFillCategoryTree(True);
        FillCollectionTree(Nil ,True);
        FillTreeView(MedienBib.AnzeigeListe, Nil); //1);

        // Call the eventHandler for "Fill PlaylistView again"
        PlaylistChangedCompletely(NempPlaylist);
        NempPlaylist.ReInitPlaylist;

        CorrectVolButton;
        CorrectVCLForABRepeat;

        // Load correctly scaled graphics
        if Nemp_MainForm.NempSkin.isActive then
        begin
            Nemp_MainForm.NempSkin.Reload;
            Nemp_MainForm.NempSkin.ActivateSkin
        end
        else
            // Star-Graphics must be reloaded!
            Nemp_MainForm.NempSkin.DeActivateSkin;


        if fActive then
            Spectrum.SetScale(fResizeFactor)
        else
            Spectrum.SetScale(1);

        Spectrum.DrawRating(Nemp_MainForm.RatingImage.Tag);
        ReArrangeToolImages;
    end;

    if assigned(FDetails) and FDetails.visible then
      FDetails.Close;

    if assigned(OptionsCompleteForm) and OptionsCompleteForm.visible then
        OptionsCompleteForm.Close;

    Nemp_MainForm.Constraints.MinWidth  := min(Screen.Width, ChangeProc(MAINFORM_MinWidth));
    Nemp_MainForm.Constraints.MinHeight := min(Screen.Height-50, ChangeProc(MAINFORM_MinHeight));

    if Not fActive then
    begin
        // Nemp_MainForm._TopMainPanel.Height := fLastTopHeight;
        Nemp_MainForm.Height := fLastHeight ;
        Nemp_MainForm.Width  := fLastWidth  ;
        FormPosAndSizeCorrect(Nemp_MainForm);
    end;

    CorrectMenuStff;
end;


procedure TNempPartyMode.CorrectMenuStff;
var ShowGeneralMenuItems, ShowToolItems: Boolean;
begin
    ShowGeneralMenuItems := not fActive;
    ShowToolItems        := not DoBlockTools;
    with Nemp_MainForm do
    begin
        /// Enable/Disable is done in the OnPopup-Methods
        /// However: Disabled Items should be set to Invisible here (and vice versea)

        //// Popup-Menus
        ///  -----------
        // Medialist: Browse
        PM_ML_PlayBrowse                      .visible := ShowGeneralMenuItems;
        N16                                   .visible := ShowGeneralMenuItems;
        PM_ML_SearchDirectory                 .visible := ShowGeneralMenuItems;
        PM_ML_Medialibrary                    .visible := ShowGeneralMenuItems;
        PM_ML_Webradio                        .visible := ShowGeneralMenuItems;
        PM_ML_RemoveSelectedPlaylists         .visible := ShowGeneralMenuItems;
        // Medialist: View
        PM_ML_DeleteSelected                  .visible := ShowGeneralMenuItems;
        PM_ML_SetRatingsOfSelectedFilesCHOOSE .visible := ShowGeneralMenuItems;
        // PM_ML_GetLyrics                       .visible := ShowGeneralMenuItems;  Disabled for now (06.2022)
        PM_ML_GetTags                         .visible := ShowGeneralMenuItems;
        PM_ML_RefreshSelected                 .visible := ShowGeneralMenuItems;
        PM_ML_PasteFromClipboard              .visible := ShowGeneralMenuItems;
        PM_ML_Properties                      .visible := ShowGeneralMenuItems;
        // Playlist
        PM_PL_AddDirectories                  .visible := ShowGeneralMenuItems;
        PM_PL_AddWebstream                    .visible := ShowGeneralMenuItems;
        PM_PL_SortBy                          .visible := ShowGeneralMenuItems;
        PM_PL_GeneraterandomPlaylist          .visible := ShowGeneralMenuItems;
        PM_PL_LoadPlaylist                    .visible := ShowGeneralMenuItems;
        PM_PL_RecentPlaylists                 .visible := ShowGeneralMenuItems;
        PM_PL_DeleteMissingFiles              .visible := ShowGeneralMenuItems;
        PM_PL_SetRatingofSelectedFilesTo      .visible := ShowGeneralMenuItems;
        PM_PL_ExtendedAddToMedialibrary       .visible := ShowGeneralMenuItems;
        // player
        PM_P_Preferences                      .visible := ShowGeneralMenuItems;
        PM_P_Wizard                           .visible := ShowGeneralMenuItems;
        PM_P_View                             .visible := ShowGeneralMenuItems;
        PM_P_KeyboardDisplay                  .visible := ShowGeneralMenuItems;
        PM_P_Directories                      .visible := ShowGeneralMenuItems;
        PM_P_FormBuilder                      .visible := ShowGeneralMenuItems;
        // Player - Tools
        PM_P_ShutDown   .visible := ShowToolItems;
        PM_P_Birthday   .visible := ShowToolItems;
        PM_P_RemoteNemp .visible := ShowToolItems;
        PM_P_Scrobbler  .visible := ShowToolItems;

        //// Mainmenu
        /// --------------------
        // MediaLibrary
        MM_ML_SearchDirectory          .visible := ShowGeneralMenuItems;
        MM_ML_Webradio                 .visible := ShowGeneralMenuItems;
        N22                            .visible := ShowGeneralMenuItems;
        MM_ML_Load                     .visible := ShowGeneralMenuItems;
        MM_ML_Save                     .visible := ShowGeneralMenuItems;
        MM_ML_ExportAsCSV              .visible := ShowGeneralMenuItems;
        MM_ML_Delete                   .visible := ShowGeneralMenuItems;
        N71                            .visible := ShowGeneralMenuItems;
        MM_ML_RefreshAll               .visible := ShowGeneralMenuItems;
        MM_ML_RefreshPlaylists         .visible := ShowGeneralMenuItems;
        MM_ML_DeleteMissingFiles       .visible := ShowGeneralMenuItems;
        MM_T_CloudEditor               .visible := ShowGeneralMenuItems;
        // Playlist
        MM_PL_Directory                .visible := ShowGeneralMenuItems;
        MM_PL_WebStream                .visible := ShowGeneralMenuItems;
        MM_PL_SortBy                   .visible := ShowGeneralMenuItems;
        MM_PL_GenerateRandomPlaylist   .visible := ShowGeneralMenuItems;
        MM_PL_Load                     .visible := ShowGeneralMenuItems;
        MM_PL_RecentPlaylists          .visible := ShowGeneralMenuItems;
        MM_PL_DeleteMissingFiles       .visible := ShowGeneralMenuItems;
        MM_PL_ClearPlaylist            .visible := ShowGeneralMenuItems;
        MM_PL_ExtendedAddToMedialibrary.visible := ShowGeneralMenuItems;
        // Settings
        MM_O_Preferences               .visible := ShowGeneralMenuItems;
        MM_O_Wizard                    .visible := ShowGeneralMenuItems;
        MM_O_View                      .visible := ShowGeneralMenuItems;
        MM_O_FormBuilder               .visible := ShowGeneralMenuItems;
        // Tools
        MM_T_KeyboardDisplay           .visible := ShowGeneralMenuItems;
        MM_T_Directories               .visible := ShowGeneralMenuItems;
        MM_T_ShutDown   .visible := ShowToolItems;
        MM_T_Birthday   .visible := ShowToolItems;
        MM_T_RemoteNemp .visible := ShowToolItems;
        MM_T_Scrobbler  .visible := ShowToolItems;

        if ShowGeneralMenuItems then
        begin
            MM_O_PartyMode.Caption := MenuItem_Partymode;
            PM_P_PartyMode.Caption := MenuItem_Partymode;
        end
        else
        begin
            MM_O_PartyMode.Caption := MenuItem_PartymodeExit;
            PM_P_PartyMode.Caption := MenuItem_PartymodeExit;
        end;

        // Images
        ScrobblerImage    .Enabled := not DoBlockTools;
        BirthdayImage     .Enabled := not DoBlockTools;
        SleepImage        .Enabled := not DoBlockTools;
        WebserverImage    .Enabled := not DoBlockTools;
    end;

end;

procedure TNempPartyMode.SetActive(value: Boolean);
begin
    if value = fActive then exit;

    if value then BackupOriginalPositions;

    fActive := value;
    CorrectMainForm;
end;

procedure TNempPartyMode.SetScaleFactor(Value: Single);
begin
  if SameValue(Value, fResizeFactor) then exit;

  fResizeFactor := Value;
  if fActive then
      CorrectMainForm;
end;

end.
