unit NewMetaFrame;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  System.Contnrs,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, NempAudioFiles, AudioFiles.Base, AudioFiles.Declarations,
  Mp3Files, FlacFiles, OggVorbisFiles, M4AFiles, BaseApeFiles, ID3v2Tags, Apev2Tags,
  ID3v2Frames, M4aAtoms;

type
  TNewMetaFrameForm = class(TForm)
    cbFrameType: TComboBox;
    lbl_FrameType: TLabel;
    lbl_FrameValue: TLabel;
    edt_FrameValue: TEdit;
    BtnOK: TButton;
    BtnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
  private
    { Private declarations }

    ///  * fFrameTypeList *
    ///  stores Pointers to a matching index of the "KnownFrames"-Array
    ///  for ID3v2- and M4A-Tags.
    ///  These are needed to create the correct frame after editing
    ///
    ///  For Oggg/Flac/Ape this is not neccessary, as we store the "FrameKey" directly in the Combobox,
    ///  as OggVorbis-Keas are more descriptive from the beginning ...
    fFrameTypList: TList;
    procedure PrepareID3FramesSelection(ID3v2Tag: TID3v2Tag);
    procedure PrepareAPEFramesSelection(ApeTag: TApeTag);

  public
    { Public declarations }
    TagType: TTagType;

    // The Tag-Object currently displayed in FormDetails
    CurrentTagObject: TBaseAudioFile;

    function PrepareFrameSelection: Integer;

  end;

var
  NewMetaFrameForm: TNewMetaFrameForm;

implementation

uses gnugettext;

{$R *.dfm}

procedure TNewMetaFrameForm.PrepareID3FramesSelection(ID3v2Tag: TID3v2Tag);
var TextList, URLList: TList;
    FrameList: TObjectList;
    i: Integer;
    CommentExists: Boolean;
begin
    TextList := TList.Create;
    URLList  := TList.Create;
    try
        ID3v2Tag.GetAllowedTextFrames(TextList);
        ID3v2Tag.GetAllowedURLFrames(URLList);

        CommentExists := False;
        FrameList := TObjectList.Create(False);
        try
            ID3v2Tag.GetAllFrames(FrameList);
            for i := 0 to FrameList.Count - 1 do
                if TID3v2Frame(FrameList[i]).FrameType = FT_CommentFrame then
                begin
                    CommentExists := True;
                    break;
                end;
        finally
            FrameList.Free;
        end;

        // add possible TextFrames
        for i := 0 to TextList.Count - 1 do
        begin
            fFrameTypList.Add(TextList[i]);

            cbFrameType.Items.Add(
                ID3v2KnownFrames[ TFrameIDs(TextList[i])].Description
                + ' ('
                + String(ID3v2KnownFrames[ TFrameIDs(TextList[i])].IDs[
                  TID3v2FrameVersions(Id3v2Tag.Version.Major)])+ ') ');
        end;

        // add Comment-Frame (if it doesn't exist already)
        if not CommentExists then
        begin
            fFrameTypList.Add(Pointer(IDv2_COMMENT));

            cbFrameType.Items.Add(
                ID3v2KnownFrames[IDv2_COMMENT].Description
                + ' ('
                + String(ID3v2KnownFrames[IDv2_COMMENT].IDs[
                  TID3v2FrameVersions(Id3v2Tag.Version.Major)])+ ') ');
        end;

        // add possible URLFrames
        for i := 0 to URLList.Count - 1 do
        begin
            fFrameTypList.Add(URLList[i]);

            cbFrameType.Items.Add(
                ID3v2KnownFrames[ TFrameIDs(URLList[i])].Description
                + ' ('
                + String(ID3v2KnownFrames[ TFrameIDs(URLList[i])].IDs[
                  TID3v2FrameVersions(Id3v2Tag.Version.Major)])+ ') ');
        end;

    finally
        TextList.Free;
        URLList.Free;
    end;
end;

procedure TNewMetaFrameForm.PrepareAPEFramesSelection(ApeTag: TApeTag);
var CommentList: TStringList;
begin
    CommentList := TStringList.Create;
    try
        CommentList.CaseSensitive := False;
        ApeTag.GetAllFrames(CommentList);

        if CommentList.IndexOf('Artist')           = -1 then cbFrameType.Items.Add('Artist');
        if CommentList.IndexOf('Title')            = -1 then cbFrameType.Items.Add('Title');
        if CommentList.IndexOf('Album')            = -1 then cbFrameType.Items.Add('Album');
        if CommentList.IndexOf('Genre')            = -1 then cbFrameType.Items.Add('Genre');
        if CommentList.IndexOf('Track')            = -1 then cbFrameType.Items.Add('Track');
        if CommentList.IndexOf('Year')             = -1 then cbFrameType.Items.Add('Year');
        if CommentList.IndexOf('Abstract')         = -1 then cbFrameType.Items.Add('Abstract');
        if CommentList.IndexOf('Bibliography')     = -1 then cbFrameType.Items.Add('Bibliography');
        if CommentList.IndexOf('Catalog')          = -1 then cbFrameType.Items.Add('Catalog');
        if CommentList.IndexOf('Comment')          = -1 then cbFrameType.Items.Add('Comment');
        if CommentList.IndexOf('Composer')         = -1 then cbFrameType.Items.Add('Composer');
        if CommentList.IndexOf('Conductor')        = -1 then cbFrameType.Items.Add('Conductor');
        if CommentList.IndexOf('Copyright')        = -1 then cbFrameType.Items.Add('Copyright');
        if CommentList.IndexOf('Debut album')      = -1 then cbFrameType.Items.Add('Debut album');
        if CommentList.IndexOf('EAN/UBC')          = -1 then cbFrameType.Items.Add('EAN/UBC');
        if CommentList.IndexOf('File')             = -1 then cbFrameType.Items.Add('File');
        if CommentList.IndexOf('Index')            = -1 then cbFrameType.Items.Add('Index');
        if CommentList.IndexOf('Introplay')        = -1 then cbFrameType.Items.Add('Introplay');
        if CommentList.IndexOf('ISBN')             = -1 then cbFrameType.Items.Add('ISBN');
        if CommentList.IndexOf('ISRC')             = -1 then cbFrameType.Items.Add('ISRC');
        if CommentList.IndexOf('Language')         = -1 then cbFrameType.Items.Add('Language');
        if CommentList.IndexOf('LC')               = -1 then cbFrameType.Items.Add('LC');
        if CommentList.IndexOf('Media')            = -1 then cbFrameType.Items.Add('Media');
        if CommentList.IndexOf('Publicationright') = -1 then cbFrameType.Items.Add('Publicationright');
        if CommentList.IndexOf('Publisher')        = -1 then cbFrameType.Items.Add('Publisher');
        if CommentList.IndexOf('Record Date')      = -1 then cbFrameType.Items.Add('Record Date');
        if CommentList.IndexOf('Record Location')  = -1 then cbFrameType.Items.Add('Record Location');
        if CommentList.IndexOf('Related')          = -1 then cbFrameType.Items.Add('Related');
        if CommentList.IndexOf('Subtitle')         = -1 then cbFrameType.Items.Add('Subtitle');
    finally
        CommentList.Free;
    end;
end;

function TNewMetaFrameForm.PrepareFrameSelection: Integer;
var FrameList: TObjectList;
    AtomExists, AtomFixed: Boolean;
    CommentList: TStringList;
    i, idx: Integer;
begin
    // Fill Combobox with possible TagFrames
    fFrameTypList.Clear;
    cbFrameType.clear;

    case TagType of
        TT_ID3v2:  begin
              PrepareID3FramesSelection(TMP3File(CurrentTagObject).ID3v2Tag);
        end;

        TT_OggVorbis,
        TT_Flac : begin
              CommentList := TStringList.Create;
              try
                  CommentList.CaseSensitive := False;
                  if TagType = TT_OggVorbis then
                      TOggVorbisFile(CurrentTagObject).GetAllFields(CommentList)
                  else
                      TFlacFile(CurrentTagObject).GetAllFields(CommentList);

                  if CommentList.IndexOf('artist')       = -1 then cbFrameType.Items.Add('artist');
                  if CommentList.IndexOf('title')        = -1 then cbFrameType.Items.Add('title');
                  if CommentList.IndexOf('album')        = -1 then cbFrameType.Items.Add('album');
                  if CommentList.IndexOf('genre')        = -1 then cbFrameType.Items.Add('genre');
                  if CommentList.IndexOf('year')         = -1 then cbFrameType.Items.Add('year');
                  if CommentList.IndexOf('tracknumber')  = -1 then cbFrameType.Items.Add('tracknumber');
                  if CommentList.IndexOf('tracktotal')   = -1 then cbFrameType.Items.Add('tracktotal');
                  if CommentList.IndexOf('discnumber')   = -1 then cbFrameType.Items.Add('discnumber');
                  if CommentList.IndexOf('disctotal')    = -1 then cbFrameType.Items.Add('disctotal');
                  if CommentList.IndexOf('date')         = -1 then cbFrameType.Items.Add('date');
                  if CommentList.IndexOf('contact')      = -1 then cbFrameType.Items.Add('contact');
                  if CommentList.IndexOf('copyright')    = -1 then cbFrameType.Items.Add('copyright');
                  if CommentList.IndexOf('description')  = -1 then cbFrameType.Items.Add('description');
                  if CommentList.IndexOf('isrc')         = -1 then cbFrameType.Items.Add('isrc');
                  if CommentList.IndexOf('license')      = -1 then cbFrameType.Items.Add('license');
                  if CommentList.IndexOf('location')     = -1 then cbFrameType.Items.Add('location');
                  if CommentList.IndexOf('organization') = -1 then cbFrameType.Items.Add('organization');
                  if CommentList.IndexOf('performer')    = -1 then cbFrameType.Items.Add('performer');
                  if CommentList.IndexOf('version')      = -1 then cbFrameType.Items.Add('version');
              finally
                  CommentList.Free
              end;
        end;

        TT_Ape: begin
            case CurrentTagObject.FileType of
                at_Mp3: PrepareAPEFramesSelection(TMP3File(CurrentTagObject).ApeTag);
                at_Monkey,
                at_WavPack,
                at_MusePack,
                at_OptimFrog,
                at_TrueAudio: PrepareAPEFramesSelection(TBaseApeFile(CurrentTagObject).ApeTag);
            end;
        end;

        TT_M4A: begin
              FrameList := TObjectList.Create(False);
              try
                  Tm4aFile(CurrentTagObject).GetAllAtoms(FrameList);

                  // special case: track and disk
                  // -----------------------------
                          AtomExists := False;
                          for idx := 0 to FrameList.Count - 1 do
                          begin
                              if SameText (String(TMetaAtom(FrameList[idx]).Name), 'trkn') then
                              begin
                                  AtomExists := True;
                                  break;
                              end;
                          end;
                          if (not AtomExists) then
                          begin
                              fFrameTypList.Add(Pointer(1042));
                              cbFrameType.Items.Add('Track number (trkn)');
                          end;

                          AtomExists := False;
                          for idx := 0 to FrameList.Count - 1 do
                          begin
                              if SameText (String(TMetaAtom(FrameList[idx]).Name), 'disk') then
                              begin
                                  AtomExists := True;
                                  break;
                              end;
                          end;
                          if (not AtomExists) then
                          begin
                              fFrameTypList.Add(Pointer(1043));
                              cbFrameType.Items.Add('Disk number (disk)');
                          end;
                  // -----------------------------

                  for i := 0 to Length(KnownMetaAtoms) - 1 do
                  begin
                      // AtomFixed: Sync with TTagEditItem.InitEditability
                      // Some Atoms should not be edited here ....
                      AtomFixed := (KnownMetaAtoms[i].AtomName = '�lyr') OR  // Lyrics
                                   (KnownMetaAtoms[i].AtomName = 'keyw') OR  // Keyword // Nemp-Tags
                                   (KnownMetaAtoms[i].AtomName = '�too') OR  // Encoding Tool
                                   (KnownMetaAtoms[i].AtomName = '�enc') OR
                                   (KnownMetaAtoms[i].AtomName = 'apID');

                      AtomExists := False;
                      for idx := 0 to FrameList.Count - 1 do
                      begin
                          if SameText (String(TMetaAtom(FrameList[idx]).Name), String(KnownMetaAtoms[i].AtomName)) then
                          begin
                              AtomExists := True;
                              break;
                          end;
                      end;
                      if (not AtomExists) and (not AtomFixed) then
                      begin
                          fFrameTypList.Add(Pointer(i));

                          cbFrameType.Items.Add(
                              KnownMetaAtoms[i].Description + ' (' + String(KnownMetaAtoms[i].AtomName) + ')' );
                      end;
                  end;
              finally
                  FrameList.Free;
              end;
        end;
    end;

    // select first entry
    if cbFrameType.Items.Count > 0 then
        cbFrameType.ItemIndex := 0;
    // clear value-Edit
    edt_FrameValue.Text := '';

    result := cbFrameType.Items.Count;
end;


procedure TNewMetaFrameForm.BtnCancelClick(Sender: TObject);
begin
    ModalResult := mrCancel;
end;

procedure TNewMetaFrameForm.BtnOKClick(Sender: TObject);
var newFrame: TID3v2Frame;
begin
    if Trim(edt_FrameValue.Text) = '' then
        exit;

    case TagType of
        TT_ID3v2:  begin

            NewFrame := TMP3File(CurrentTagObject).Id3v2Tag.AddFrame(
                TFrameIDS(fFrameTypList[cbFrameType.ItemIndex]) );

            case newFrame.FrameType of
                FT_TextFrame: NewFrame.SetText(edt_FrameValue.Text);
                FT_CommentFrame: NewFrame.SetCommentsLyrics('eng', '', edt_FrameValue.Text);
                FT_URLFrame: NewFrame.SetURL(AnsiString(edt_FrameValue.Text));

                FT_INVALID,
                FT_UNKNOWN,
                FT_LyricFrame,
                FT_UserDefinedURLFrame,
                FT_PictureFrame,
                FT_PopularimeterFrame,
                FT_UserTextFrame: ; // Not supported here, and cannot happen
            end;

            ModalResult := MROK;
        end;

        TT_OggVorbis: begin
            TOggVorbisFile(CurrentTagObject).SetPropertyByFieldname(cbFrameType.Text, edt_FrameValue.Text);
            ModalResult := MROK;
        end;

        TT_Flac: begin
            TFlacFile(CurrentTagObject).SetPropertyByFieldname(cbFrameType.Text, edt_FrameValue.Text);
            ModalResult := MROK;
        end;

        TT_Ape: begin
            case CurrentTagObject.FileType of
                at_Mp3: begin
                    TMP3File(CurrentTagObject).ApeTag.SetValueByKey(AnsiString(cbFrameType.Text), edt_FrameValue.Text);
                    // Note: By now, Nemp does not allow to initiate an APE-Tag in an mp3File.
                    //       So, if we get here, the APETag already exists
                    //       For later changes however it could be better to explicitly set the existence to True now.
                    // TMP3File(CurrentTagObject).ApeTag.Exists := True;
                end;
                at_Monkey,
                at_WavPack,
                at_MusePack,
                at_OptimFrog,
                at_TrueAudio: TBaseApeFile(CurrentTagObject).ApeTag.SetValueByKey(AnsiString(cbFrameType.Text), edt_FrameValue.Text);
            end;
            ModalResult := MROK;
        end;

        TT_M4A: begin
            case Integer(fFrameTypList[cbFrameType.ItemIndex]) of
                1042: TM4aFile(CurrentTagObject).MOOV.UdtaAtom.SetTrackNumber(edt_FrameValue.Text);
                1043: TM4aFile(CurrentTagObject).MOOV.UdtaAtom.SetDiscNumber(edt_FrameValue.Text);
            else
                TM4aFile(CurrentTagObject).MOOV.UdtaAtom.SetTextData(
                      KnownMetaAtoms[
                          Integer(fFrameTypList[cbFrameType.ItemIndex])
                      ].AtomName
                      ,
                      edt_FrameValue.Text);
            end;

            ModalResult := MROK;
        end;
    end;
end;

procedure TNewMetaFrameForm.FormCreate(Sender: TObject);
begin
    fFrameTypList := TList.Create;

    //BackupComboboxes(self);
    TranslateComponent (self);
    //RestoreComboboxes(self);
end;

procedure TNewMetaFrameForm.FormDestroy(Sender: TObject);
begin
    fFrameTypList.Free;
end;

end.
