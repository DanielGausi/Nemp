unit BaseForms;

interface

uses Windows, Messages, Graphics, Forms, Classes, Controls, WinApi.ShellApi,
Nemp_ConstantsAndTypes ;


  type

    TNempForm = class(TForm)
      public
        NempRegionsDistance: TNempRegionsDistance;
    end;

    TNempCustomMainForm = class(TNempForm)
      public
        procedure SaveWindowPosition(aMode: Integer);
        procedure LoadWindowPosition;
        procedure LoadWindowPositionLegacy;
    end;

    TNempSubForm = class(TNempForm)
      private
        procedure LoadWindowPositionLegacy;

      protected
        fNempFormID: TENempFormIDs;
        MainForm: TNempForm;
        DownX: Integer;
        DownY: Integer;
        BLeft: Integer;
        BTop: Integer;
        BWidth: Integer;
        BHeight: Integer;

        procedure CreateParams(var Params: TCreateParams); override;

      public
        procedure InitForm(aID: TENempFormIDs; aMainForm: TNempForm);
        procedure SaveWindowPosition;
        procedure LoadWindowPosition;
        procedure DoFormResize;
    end;

implementation

uses gnuGettext;

function GetIniPrefix(aID: TENempFormIDs): String;
begin
  case aID of
    nfMain:     result := 'Main';
    nfMainMini: result := 'Mini';
    nfPlaylist: result := 'Playlist';
    nfMediaLibrary: result := 'Medienliste';
    nfBrowse:       result := 'AuswahlSuche';
    nfExtendedControls: result := 'ExtendedControls';
  else
    result := '';
  end;
end;

{ TNempSubForm }

procedure TNempSubForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.WndParent := Application.Handle;
end;

procedure TNempSubForm.DoFormResize;
begin
  if assigned(OnResize) then
    OnResize(self);
end;

procedure TNempSubForm.InitForm(aID: TENempFormIDs; aMainForm: TNempForm);
begin
  TranslateComponent (self);
  DragAcceptFiles (Handle, True);

  fNempFormID := aID;
  MainForm := aMainForm;

  LoadWindowPosition;

  Top     := NempOptions.FormPositions[fNempFormID].Top;
  Left    := NempOptions.FormPositions[fNempFormID].Left;
  Height  := NempOptions.FormPositions[fNempFormID].Height;
  Width   := NempOptions.FormPositions[fNempFormID].Width;

  BTop    := NempOptions.FormPositions[fNempFormID].Top;
  BLeft   := NempOptions.FormPositions[fNempFormID].Left;
  BHeight := NempOptions.FormPositions[fNempFormID].Height;
  BWidth  := NempOptions.FormPositions[fNempFormID].Width;

  NempRegionsDistance.docked := NempOptions.FormPositions[fNempFormID].Docked;

  NempRegionsDistance.RelativPositionX := Left - NempOptions.FormPositions[nfMainMini].Left;
  NempRegionsDistance.RelativPositionY := Top - NempOptions.FormPositions[nfMainMini].Top;

  Caption := NEMP_CAPTION;
end;

procedure TNempSubForm.LoadWindowPosition;
var rawIniString: String;
begin
  if NempSettingsManager.SectionExists('NempForms') then
  begin
    rawIniString := NempSettingsManager.ReadString('NempForms', cDefaultWindowData[fNempFormID].Key, '');
    NempOptions.FormPositions[fNempFormID].GetDataFromString(rawIniString);
  end else
    LoadWindowPositionLegacy;
end;

procedure TNempSubForm.LoadWindowPositionLegacy;
var
  iniPrefix: String;
begin
  iniPrefix := GetIniPrefix(fNempFormID);

  NempOptions.FormPositions[fNempFormID].Top :=
    NempSettingsManager.ReadInteger('Windows', iniPrefix+'Top', cDefaultWindowData[fNempFormID].Top);

  NempOptions.FormPositions[fNempFormID].Left :=
    NempSettingsManager.ReadInteger('Windows', iniPrefix+'Left', cDefaultWindowData[fNempFormID].Left);

  NempOptions.FormPositions[fNempFormID].Width :=
    NempSettingsManager.ReadInteger('Windows', iniPrefix+'Width', cDefaultWindowData[fNempFormID].Width);

  NempOptions.FormPositions[fNempFormID].Height :=
    NempSettingsManager.ReadInteger('Windows', iniPrefix+'Height', cDefaultWindowData[fNempFormID].Height);

  // some of these setting may not be loaded correctly, but I'll ignore that here
  // (inconsistent IniKeys in previous Versions)
  //NempOptions.FormPositions[fNempFormID].Visible :=
  //  NempSettingsManager.ReadBool('Windows', iniPrefix+'Visible', cDefaultWindowData[fNempFormID].Visible);

  NempOptions.FormPositions[fNempFormID].Docked :=
    NempSettingsManager.ReadBool('Windows', iniPrefix+'Docked', cDefaultWindowData[fNempFormID].Docked);
end;

procedure TNempSubForm.SaveWindowPosition;
begin
  // Copy Data into the Settings-Object
  NempOptions.FormPositions[fNempFormID].Top     := Top;
  NempOptions.FormPositions[fNempFormID].Left    := Left;
  NempOptions.FormPositions[fNempFormID].Width   := Width;
  NempOptions.FormPositions[fNempFormID].Height  := Height;
  NempOptions.FormPositions[fNempFormID].Docked  := NempRegionsDistance.docked ;
  // store settings in the SettingsManager
  NempSettingsManager.WriteString('NempForms', cDefaultWindowData[fNempFormID].Key,
      NempOptions.FormPositions[fNempFormID].SetDataToString );
end;

{ TNempCustomMainForm }

procedure TNempCustomMainForm.LoadWindowPosition;
var rawIniString: String;
begin
  if NempSettingsManager.SectionExists('NempForms') then
  begin
    rawIniString := NempSettingsManager.ReadString('NempForms', cDefaultWindowData[nfMain].Key, '');
    NempOptions.FormPositions[nfMain].GetDataFromString(rawIniString);

    rawIniString := NempSettingsManager.ReadString('NempForms', cDefaultWindowData[nfMainMini].Key, '');
    NempOptions.FormPositions[nfMainMini].GetDataFromString(rawIniString);

    NempOptions.MainFormMaximized := NempSettingsManager.ReadBool('NempForms', 'MainFormMaximized' , False);
  end else
    LoadWindowPositionLegacy
end;

procedure TNempCustomMainForm.LoadWindowPositionLegacy;

    procedure ReadPart(aID: TENempFormIDs);
    var iniPrefix: string;
    begin
      iniPrefix := GetIniPrefix(aID);
      NempOptions.FormPositions[aID].Top :=
        NempSettingsManager.ReadInteger('Windows', iniPrefix+'Top', cDefaultWindowData[aID].Top);
      NempOptions.FormPositions[aID].Left :=
        NempSettingsManager.ReadInteger('Windows', iniPrefix+'Left', cDefaultWindowData[aID].Left);
      NempOptions.FormPositions[aID].Width :=
        NempSettingsManager.ReadInteger('Windows', iniPrefix+'Width', cDefaultWindowData[aID].Width);
      NempOptions.FormPositions[aID].Height :=
        NempSettingsManager.ReadInteger('Windows', iniPrefix+'Height', cDefaultWindowData[aID].Height);
    end;

begin
  ReadPart(nfMain);
  ReadPart(nfMainMini);
  NempOptions.FormPositions[nfMainMini].Height := 560;
  NempOptions.MainFormMaximized := NempSettingsManager.ReadBool('Windows', 'maximiert_0' ,False);
end;

procedure TNempCustomMainForm.SaveWindowPosition(aMode: Integer);
var aFormID: TENempFormIDs;
begin
  case aMode of
    0: aFormID := nfMain;
    1: aFormID := nfMainMini;
  else
    aFormID := nfMain;
  end;

  NempOptions.FormPositions[aFormID].Top     := Top;
  NempOptions.FormPositions[aFormID].Left    := Left;
  NempOptions.FormPositions[aFormID].Width   := Width;
  NempOptions.FormPositions[aFormID].Height  := Height;

  NempSettingsManager.WriteString('NempForms', cDefaultWindowData[aFormID].Key,
      NempOptions.FormPositions[aFormID].SetDataToString );

  if aMode = 0 then
    NempSettingsManager.WriteBool('NempForms', 'MainFormMaximized' , NempOptions.MainFormMaximized);

end;

end.
