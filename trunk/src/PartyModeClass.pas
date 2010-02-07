{

    Unit PartyModeClass

    - a class for the Party-Mode in Nemp
      e.g. resizing of the controls

    ---------------------------------------------------------------
    Nemp - Noch ein Mp3-Player
    Copyright (C) 2009, Daniel Gaussmann
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

    Additional permissions

    If you modify this Program, or any covered work, by linking or combining it
    with
        - the bass.dll and it addons
          (including, but not limited to the bass_fx.dll)
        - MadExcept
        - DGL-OpenGL
    or a modified version of these libraries, the licensors of this Program
    grant you additional permission to convey the resulting work.

    ---------------------------------------------------------------
}


unit PartyModeClass;

interface

uses Windows, Forms, Controls, StdCtrls, Classes, SysUtils, SkinButtons,
    Nemp_ConstantsAndTypes, IniFiles, math;

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


          fResizeFactor: Single;

          // Array of PlayerControls/Positions.
          // These are "completely doubled" i.e. width, height,top, left
          fPartyControls: Array of TControl;
          fPositionArray: Array of TPosRecord;
          // Some additional Controls, not "completely doubled"
          // Only e.g. Height, Left, Top, but not Width.
          fAdditionalControls: Array of TControl;
          fAdditionalPositionsArray: Array of TPosrecord;

          procedure CorrectMainForm;


          procedure SetActive(value: Boolean);
          procedure SetScaleFactor(Value: Single);
          procedure SetOriginalPosition(aControl: TControl; var aIndex: Integer);
          procedure SetAdditionalOriginalPosition(aControl: TControl; var aIndex: Integer);

      public
          property Active: Boolean read fActive write SetActive;
          property ResizeProc: TChangeProc read fResizeProc;

          property ResizeFactor: Single read fResizeFactor write SetScaleFactor;

          constructor Create;

          procedure LoadFromIni(Ini: TMemIniFile);
          procedure WriteToIni(Ini: TMemIniFile);
          // FactorToIndex: Transform the 0, 1.5, 2, 2.5 into 0, 1, 2, 3
          // These Integers are used for the ComboBox in the OptionsDialog and in the Inifile.
          function FactorToIndex: Integer;
          function IndexToFactor(value: Integer): single;

          procedure BackupOriginalPositions;

          procedure SetButtonPos(aButton: TNempButtonData; var aIndex: Integer); // used by Skin.SetButtonsizes

          function Bigger(value: Integer): Integer;
          function Smaller(value: Integer): Integer;
          function Equal(value: Integer): Integer;

         
    end;



implementation

uses NempMainUnit, MainFormHelper, spectrum_vis;


{ TNempPartyMode }

constructor TNempPartyMode.Create;
begin
    fActive := False;
    fResizeProc := Equal;

    fResizeFactor := 1.5;
end;

procedure TNempPartyMode.LoadFromIni(Ini: TMemIniFile);
var tmp: Integer;
begin
    tmp := Ini.ReadInteger('PartyMode', 'Factor', 1);
    fResizeFactor := IndexToFactor(tmp);
end;


procedure TNempPartyMode.WriteToIni(Ini: TMemIniFile);
begin
    Ini.WriteInteger('PartyMode', 'Factor', FactorToIndex);
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
    Setlength(fPositionArray, 100);
    SetLength(fPartyControls, 100);
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
        // 3 System-Buttons
        SetOriginalPosition(BtnMinimize         , i);
        SetOriginalPosition(BtnClose            , i);
        SetOriginalPosition(BtnMenu            , i);

        // Other Controls
        SetOriginalPosition(PlayerPanel         , i);
        SetOriginalPosition(GRPBOXCover         , i);
        SetOriginalPosition(CoverImage          , i);
        SetOriginalPosition(NewPlayerPanel      , i);
        SetOriginalPosition(PaintFrame          , i);
        SetOriginalPosition(TextAnzeigeIMAGE    , i);
        SetOriginalPosition(TimePaintBox        , i);
        SetOriginalPosition(SlideBarShape       , i);
        SetOriginalPosition(VolShape            , i);
        SetOriginalPosition(SleepImage          , i);
        SetOriginalPosition(WebserverImage      , i);
        SetOriginalPosition(BirthdayImage       , i);
        SetOriginalPosition(ScrobblerImage      , i);
        SetOriginalPosition(RatingImage         , i);
        SetOriginalPosition(LblPlayerTitle      , i);
        SetOriginalPosition(LblPlayerArtist     , i);
        SetOriginalPosition(LblPlayerAlbum      , i);
        SetOriginalPosition(SlideBarButton      , i);
        SetOriginalPosition(VolButton           , i);
        SetOriginalPosition(AudioPanel          , i);
        SetOriginalPosition(TabBtn_Cover        , i);
        SetOriginalPosition(TabBtn_Lyrics       , i);
        SetOriginalPosition(TabBtn_Equalizer    , i);
        SetOriginalPosition(TabBtn_Effects      , i);
        SetOriginalPosition(GRPBOXEffekte       , i);
        SetOriginalPosition(HallShape           , i);
        SetOriginalPosition(HallLBL             , i);
        SetOriginalPosition(EchoWetDryMixShape  , i);
        SetOriginalPosition(EchoTimeShape       , i);
        SetOriginalPosition(EchoTimeLBL         , i);
        SetOriginalPosition(EchoMixLBL          , i);
        SetOriginalPosition(EffekteLBL2         , i);
        SetOriginalPosition(EffekteLBL1         , i);
        SetOriginalPosition(SampleRateShape     , i);
        SetOriginalPosition(SampleRateLBL       , i);
        SetOriginalPosition(EffekteLBL3         , i);
        SetOriginalPosition(DirectionPositionBTN, i);
        SetOriginalPosition(Btn_EffectsOff      , i);
        SetOriginalPosition(EchoWetDryMixButton , i);
        SetOriginalPosition(HallButton          , i);
        SetOriginalPosition(EchoTimeButton      , i);
        SetOriginalPosition(SampleRateButton    , i);
        SetOriginalPosition(GRPBOXEqualizer     , i);
        SetOriginalPosition(EqualizerShape5     , i);
        SetOriginalPosition(EqualizerShape2     , i);
        SetOriginalPosition(EqualizerShape3     , i);
        SetOriginalPosition(EqualizerShape4     , i);
        SetOriginalPosition(EqualizerShape6     , i);
        SetOriginalPosition(EqualizerShape7     , i);
        SetOriginalPosition(EqualizerShape8     , i);
        SetOriginalPosition(EqualizerShape9     , i);
        SetOriginalPosition(EqualizerShape10    , i);
        SetOriginalPosition(EQLBL1              , i);
        SetOriginalPosition(EQLBL2              , i);
        SetOriginalPosition(EQLBL3              , i);
        SetOriginalPosition(EQLBL4              , i);
        SetOriginalPosition(EQLBL5              , i);
        SetOriginalPosition(EQLBL6              , i);
        SetOriginalPosition(EQLBL7              , i);
        SetOriginalPosition(EQLBL8              , i);
        SetOriginalPosition(EQLBL9              , i);
        SetOriginalPosition(EQLBL10             , i);
        SetOriginalPosition(EqualizerShape1     , i);
        SetOriginalPosition(EqualizerDefaultShape, i);
        SetOriginalPosition(EqualizerButton1    , i);
        SetOriginalPosition(EqualizerButton2    , i);
        SetOriginalPosition(EqualizerButton3    , i);
        SetOriginalPosition(EqualizerButton5    , i);
        SetOriginalPosition(EqualizerButton4    , i);
        SetOriginalPosition(EqualizerButton6    , i);
        SetOriginalPosition(EqualizerButton7    , i);
        SetOriginalPosition(EqualizerButton8    , i);
        SetOriginalPosition(EqualizerButton9    , i);
        SetOriginalPosition(EqualizerButton10   , i);
        SetOriginalPosition(Btn_EqualizerPresets, i);
        SetOriginalPosition(GRPBOXLyrics        , i);
        SetOriginalPosition(LyricsMemo          , i);

        SetOriginalPosition(TabBtn_Preselection , i);
        SetOriginalPosition(TabBtn_Browse       , i);
        SetOriginalPosition(TabBtn_CoverFlow    , i);
        SetOriginalPosition(TabBtn_TagCloud     , i);

        SetOriginalPosition(TabBtn_Playlist     , i);
        SetOriginalPosition(TabBtn_Medialib     , i);

        Setlength(fPositionArray, i);
        SetLength(fPartyControls, i);


        // Additional Controls
        i := 0;
        Setlength(fAdditionalControls, 14);
        SetLength(fAdditionalPositionsArray, 14);

        SetAdditionalOriginalPosition(AuswahlHeaderPanel, i);
        SetAdditionalOriginalPosition(AuswahlFillPanel, i);
        SetAdditionalOriginalPosition(AuswahlStatusLBL, i);
        SetAdditionalOriginalPosition(GRPBOXArtistsAlben, i);

        SetAdditionalOriginalPosition(PlayerHeaderPanel, i);
        SetAdditionalOriginalPosition(PlaylistFillPanel, i);
        SetAdditionalOriginalPosition(PlayListStatusLBL, i);
        SetAdditionalOriginalPosition(GRPBOXPlaylist   , i);

        SetAdditionalOriginalPosition(MedienBibHeaderPanel, i);
        SetAdditionalOriginalPosition(MedienlisteFillPanel, i);
        SetAdditionalOriginalPosition(MedienListeStatusLBL, i);
        SetAdditionalOriginalPosition(GRPBOXVST           , i);
        SetAdditionalOriginalPosition(EDITFastSearch               , i);
        SetAdditionalOriginalPosition(CB_MedienBibGlobalQuickSearch, i);


        //SetAdditionalOriginalPosition(, i);

    end;
end;


procedure TNempPartyMode.CorrectMainForm;
var ChangeProc: TChangeProc;
    i: Integer;
    c: tControl;
    d: Boolean;
begin
    if fActive then
    begin
        ChangeProc := Bigger;
        fResizeProc := Bigger;
        d := true;
    end
    else
    begin
        ChangeProc := Equal; //Smaller;
        fResizeProc := Equal;
        d := False;
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
        AuswahlHeaderPanel.Height := ChangeProc(fAdditionalPositionsArray[0].Height);
        AuswahlFillPanel.Left := ChangeProc(fAdditionalPositionsArray[1].Left);
        AuswahlFillPanel.Height := ChangeProc(fAdditionalPositionsArray[1].Height);
        AuswahlFillPanel.Top := ChangeProc(fAdditionalPositionsArray[1].Top);
        AuswahlFillPanel.Width := AuswahlPanel.Width - AuswahlFillPanel.Left;
        AuswahlStatusLBL.Top := ChangeProc(fAdditionalPositionsArray[2].Top);
        AuswahlStatusLBL.Height := ChangeProc(fAdditionalPositionsArray[2].Height);
        AuswahlStatusLBL.Font.Size := ChangeProc(fAdditionalPositionsArray[2].FontSize);
        GRPBOXArtistsAlben.Top := ChangeProc(fAdditionalPositionsArray[3].Top);

        PlayerHeaderPanel.Height := ChangeProc(fAdditionalPositionsArray[4].Height);
        PlaylistFillPanel.Left := ChangeProc(fAdditionalPositionsArray[5].Left);
        PlaylistFillPanel.Height := ChangeProc(fAdditionalPositionsArray[5].Height);
        PlaylistFillPanel.Top := ChangeProc(fAdditionalPositionsArray[5].Top);
        PlaylistFillPanel.Width := PlayerHeaderPanel.Width - PlaylistFillPanel.Left;
        PlayListStatusLBL.Top := ChangeProc(fAdditionalPositionsArray[6].Top);
        PlayListStatusLBL.Height := ChangeProc(fAdditionalPositionsArray[6].Height);
        PlayListStatusLBL.Font.Size := ChangeProc(fAdditionalPositionsArray[6].FontSize);
        GRPBOXPlaylist.Top := ChangeProc(fAdditionalPositionsArray[7].Top);

        MedienBibHeaderPanel.Height := ChangeProc(fAdditionalPositionsArray[8].Height);
        MedienlisteFillPanel.Left := ChangeProc(fAdditionalPositionsArray[9].Left);
        MedienlisteFillPanel.Height := ChangeProc(fAdditionalPositionsArray[9].Height);
        MedienlisteFillPanel.Top := ChangeProc(fAdditionalPositionsArray[9].Top);
        MedienListeStatusLBL.Top := ChangeProc(fAdditionalPositionsArray[10].Top);
        MedienListeStatusLBL.Height := ChangeProc(fAdditionalPositionsArray[10].Height);
        MedienListeStatusLBL.Font.Size := ChangeProc(fAdditionalPositionsArray[10].FontSize);
        GRPBOXVST.Top := ChangeProc(fAdditionalPositionsArray[11].Top);
        MedienlisteFillPanel.Width := MedienBibHeaderPanel.Width - MedienlisteFillPanel.Left;
        EDITFastSearch.Height := ChangeProc(fAdditionalPositionsArray[12].Height);
        EDITFastSearch.Width := ChangeProc(fAdditionalPositionsArray[12].Width);
        EDITFastSearch.Left := ChangeProc(fAdditionalPositionsArray[12].Left);
        EDITFastSearch.Top := ChangeProc(fAdditionalPositionsArray[12].Top);
        EDITFastSearch.Font.Size := ChangeProc(fAdditionalPositionsArray[12].FontSize);

        CB_MedienBibGlobalQuickSearch.Height := ChangeProc(fAdditionalPositionsArray[13].Height);
        CB_MedienBibGlobalQuickSearch.Width := ChangeProc(fAdditionalPositionsArray[13].Width);
        CB_MedienBibGlobalQuickSearch.Left := ChangeProc(fAdditionalPositionsArray[13].Left);
        CB_MedienBibGlobalQuickSearch.Top := ChangeProc(fAdditionalPositionsArray[13].Top);
        CB_MedienBibGlobalQuickSearch.Font.Size := EDITFastSearch.Font.Size;


        for i := 0 to 9 do CorrectEQButton(i);
        CorrectHallButton;
        CorrectEchoButtons;
        CorrectSpeedButton;
        CorrectVolButton;


        // correct Splitter
        Splitter2.Left := AuswahlPanel.Width;

        // Load correctly scaled graphics
        if Nemp_MainForm.NempSkin.isActive then
            Nemp_MainForm.NempSkin.ActivateSkin
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

end;


procedure TNempPartyMode.SetActive(value: Boolean);
begin
    if value = fActive then exit;
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