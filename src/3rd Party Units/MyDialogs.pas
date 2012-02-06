{== MyDialogs =========================================================}
{: Collects modified dialog functions
@author Dr. Peter Below
@desc   Version: 1.0  Created: 07.06.98<BR>
        Version 1.01 created 4 Juli 2001, added translation of
          button captions.<BR>
        Last modified       4 Juli 2001<P>

        modified by Gausi (No-More-Checkbox-Caption-Parameter)
   }
{======================================================================}
unit MyDialogs;

interface

uses Windows, Classes, Controls, stdctrls, sysutils, forms, Dialogs;

function DefMessageDlg(const aCaption : string;
  const Msg : string;
  DlgType : TMsgDlgType;
  Buttons : TMsgDlgButtons;
  DefButton : integer;
  HelpCtx : longint): integer;

function MessageDlgWithNoMorebox(const aCaption : string;
  const Msg : string;
  DlgType : TMsgDlgType;
  Buttons : TMsgDlgButtons;
  DefButton : integer;
  HelpCtx : longint;
  var askNoMore : boolean;
  CBCaption: String): integer;

function TranslateMessageDlg(const Msg : string; DlgType : TMsgDlgType;
    Buttons : TMsgDlgButtons; HelpCtx : longint; DefButton : integer = mrOK): integer;

implementation

uses gnugettext;

{.$DEFINE STANDARDCAPTIONS}

resourcestring
  //{.$IFDEF GERMAN}
 { cmbYes = '&Ja';
  cmbNo = '&Nein';
  cmbOK = 'OK';
  cmbCancel = 'Abbrechen';
  cmbHelp = '&Hilfe';
  cmbAbort = '&Abbrechen';
  cmbRetry = '&Wiederholen';
  cmbIgnore = '&Ignorieren';
  cmbAll = '&Alle';
  cmbNoToAll = 'N&ein für alle';
  cmbYesToAll = 'Ja für &alle';  }
  //{.$ELSE}
  XcmbYes = '&Yes'; //'&Yes';
  XcmbNo = '&No';
  XcmbOK = 'OK';
  XcmbCancel = 'Cancel';
  XcmbHelp = '&Help';
  XcmbAbort = '&Abort';
  XcmbRetry = '&Retry';
  XcmbIgnore = '&Ignore';
  XcmbAll = '&All';
  XcmbNoToAll = 'N&o to All';
  XcmbYesToAll = 'Yes to &All';
  //{.$ENDIF}

const { Copied from Dialogs }
  ModalResults : array[TMsgDlgBtn] of integer = (mrYes, mrNo, mrOk,
    mrCancel, mrAbort, mrRetry, mrIgnore, mrAll,
    mrNoToAll, mrYesToAll, 0,0);

var
  MyButtonCaptions : array[TMsgDlgBtn] of string;


procedure InitButtonCaptions;
begin
  MyButtonCaptions[mbYes]      := XcmbYes;
  MyButtonCaptions[mbNo]       := XcmbNo;
  MyButtonCaptions[mbOK]       := XcmbOK;
  MyButtonCaptions[mbCancel]   := XcmbCancel;
  MyButtonCaptions[mbAbort]    := XcmbAbort;
  MyButtonCaptions[mbRetry]    := XcmbRetry;
  MyButtonCaptions[mbIgnore]   := XcmbIgnore;
  MyButtonCaptions[mbAll]      := XcmbAll;
  MyButtonCaptions[mbNoToAll]  := XcmbNoToAll;
  MyButtonCaptions[mbYesToAll] := XcmbYesToAll;
  MyButtonCaptions[mbHelp]     := XcmbHelp;
end; { InitButtonCaptions }


  { Convert a modal result to a TMsgDlgBtn code. }
function ModalResultToBtn(res : TModalResult): TMsgDlgBtn;
begin
  for Result := Low(Result) to High(Result) do
  begin
    if ModalResults[Result] = res then
      Exit;
  end; { For }
  Result := mbHelp;  // to remove warning only
  Assert(False, 'ModalResultToBtn: unknown modalresult ' +
    IntToStr(res));
end; { ModalResultToBtn }

{ When the button captions on the message form are translated
  the button size and as a consequence the button positions need
  to be adjusted. }
procedure AdjustButtons(aForm : TForm);
var
  buttons : TList;
  btnWidth : integer;
  btnGap : integer;

  procedure CollectButtons;
  var
    i : integer;
  begin
    for i := 0 to aForm.Controlcount - 1 do
      if aForm.Controls[i] is TButton then
        buttons.Add(aForm.Controls[i]);
  end; { CollectButtons }

  procedure MeasureButtons;
  var
    i : integer;
    textrect : TRect;
    w : integer;
  begin
    btnWidth := TButton(buttons[0]).Width;
    aForm.Canvas.Font := aForm.Font;
    for i := 0 to buttons.Count - 1 do
    begin
      TextRect := Rect(0, 0, 0, 0);
      Windows.DrawText(aform.canvas.handle,
        PChar(TButton(buttons[i]).Caption), - 1,
        TextRect,
        DT_CALCRECT or DT_LEFT or DT_SINGLELINE);
      with TextRect do w := Right - Left + 16;
      if w > btnWidth then btnWidth := w;
    end; { For }
    if buttons.Count > 1 then
      btnGap := TButton(buttons[1]).Left -
        TButton(buttons[0]).Left -
        TButton(buttons[0]).Width
    else
      btnGap := 0;
  end; { MeasureButtons }

  procedure SizeButtons;
  var
    i : integer;
  begin
    for i := 0 to buttons.Count - 1 do
      TButton(buttons[i]).Width := btnWidth;
  end; { SizeButtons }

  procedure ArrangeButtons;
  var
    i : integer;
    total, left : integer;
  begin
    total := (buttons.Count - 1) * btnGap;
    for i := 0 to buttons.Count - 1 do
      Inc(total, TButton(buttons[i]).Width);
    left := (aForm.ClientWidth - total) div 2;
    if left < 0 then
    begin
      aForm.Width := aForm.Width + 2 * Abs(left) + 16;
      left := 8;
    end; { If }
    for i := 0 to buttons.Count - 1 do
    begin
      TButton(buttons[i]).Left := left;
      Inc(left, btnWidth + btnGap);
    end;
  end; { ArrangeButtons }
begin
  buttons := TList.Create;
  try
    CollectButtons;
    if buttons.Count = 0 then
      Exit;
    MeasureButtons;
    SizeButtons;
    ArrangeButtons;
  finally
    buttons.Free;
  end; { finally }
end; { AdjustButtons }

procedure InitMsgForm(aForm : TForm; const aCaption : string;
  helpCtx : longint; DefButton : integer);
var
  i : integer;
  btn : TButton;
begin
    InitButtonCaptions;

  with aForm do
  begin
    if Length(aCaption) > 0 then
      Caption := aCaption;
    HelpContext := HelpCtx;
    for i := 0 to ComponentCount - 1 do
    begin
      if Components[i] is TButton then
      begin
        btn := TButton(Components[i]);
        btn.Default := btn.ModalResult = DefButton;
        if btn.Default then
          ActiveControl := Btn;
        btn.Caption := MyButtonCaptions[ModalResultToBtn(btn.Modalresult)];
      end;
    end; { For }

    AdjustButtons(aForm);
  end;
end; { InitMsgForm }


procedure InitTranslateMessageDlg(aForm : TForm; helpCtx : longint; DefButton: Integer);
var
  i : integer;
  btn : TButton;
begin
    InitButtonCaptions;

    with aForm do
    begin
        HelpContext := HelpCtx;
        for i := 0 to ComponentCount - 1 do
        begin
            if Components[i] is TButton then
            begin
                btn := TButton(Components[i]);
                btn.Default := btn.ModalResult = DefButton;
                if btn.Default then
                    ActiveControl := Btn;
                btn.Caption := MyButtonCaptions[ModalResultToBtn(btn.Modalresult)];
            end;
        end; { For }

        AdjustButtons(aForm);
    end;
end; { InitMsgForm }

{-- DefMessageDlg -----------------------------------------------------}
{: Creates a MessageDlg with translated button captions and a configurable
   default button and caption.
@Param aCaption   Caption to use for the dialog. If empty the
                  default is used.
@Param Msg        message to display
@Param DlgType    type of dialog, see MessageDlg online help
@Param Buttons    buttons to display, see MessageDlg online help
@Param DefButton  ModalResult of the button that should be the
                  default.
@Param HelpCtx    help context (optional)
@Returns the ModalResult of the dialog
}{ Created 07.06.1998 by P. Below, modified 04.07.2001
-----------------------------------------------------------------------}
function DefMessageDlg(const aCaption : string; const Msg : string;
  DlgType : TMsgDlgType; Buttons : TMsgDlgButtons; DefButton : integer;
  HelpCtx : longint): integer;
var
  aForm : TForm;
begin { DefMessageDlg }
  aForm := CreateMessageDialog(Msg, DlgType, Buttons);
  try
    InitMsgForm(aForm, aCaption, helpCtx, DefButton);
    Result := aForm.ShowModal;
  finally
    aForm.Free;
  end;
end; { DefMessageDlg }

resourcestring
  AskNoMoreCaption = 'Don''t show this dialog again';

  {-- MessageDlgWithNoMorebox -------------------------------------------}
{: Creates a MessageDlg with translated button captions and a configurable
   default button and caption.
@Param aCaption   Caption to use for the dialog. If empty the
                  default is used.
@Param Msg        message to display
@Param DlgType    type of dialog, see MessageDlg online help
@Param Buttons    buttons to display, see MessageDlg online help
@Param DefButton  ModalResult of the button that should be the
                  default.
@Param HelpCtx    help context (optional)
@Param askNoMore  if this is passed in as True the function will directly
                  return the DefButton result. Otherwise a checkbox is
                  shown beneath the buttons which the user can check to
                  not have this dialog show up in the future. Its checked
                  state is returned in the parameter.
@Returns the ModalResult of the dialog
}{ Created 4.7.2001 by P. Below
-----------------------------------------------------------------------}
function MessageDlgWithNoMorebox(const aCaption : string;
  const Msg : string; DlgType : TMsgDlgType; Buttons : TMsgDlgButtons;
  DefButton : integer; HelpCtx : longint;
  var askNoMore : boolean;
  CBCaption: String): integer;
var
  aForm : TForm;
  chk : TCheckbox;
begin { MessageDlgWithNoMorebox }
  if askNoMore then
    Result := DefButton
  else
  begin
    aForm := CreateMessageDialog(Msg, DlgType, Buttons);
    try
      InitMsgForm(aForm, aCaption, helpCtx, DefButton);
      chk := TCheckbox.Create(aForm);
      chk.Parent := aForm;
      chk.SetBounds(16, aForm.ClientHeight, aForm.Clientwidth - 32,
        chk.Height);
      chk.Checked := False;
      chk.Caption := CBCaption;
      AForm.Height := aForm.Height + chk.Height + 8;
      Result := aForm.ShowModal;
      askNoMore := chk.Checked;
    finally
      aForm.Free;
    end;
  end;
end; { MessageDlgWithNoMorebox }



function TranslateMessageDlg(const Msg : string; DlgType : TMsgDlgType;
    Buttons : TMsgDlgButtons; HelpCtx : longint; DefButton : integer = mrOK): integer;
var
  aForm : TForm;
begin { MessageDlgWithNoMorebox }
    aForm := CreateMessageDialog(Msg, DlgType, Buttons);
    try
      InitTranslateMessageDlg(aForm, helpCtx, DefButton);
      Result := aForm.ShowModal;
    finally
      aForm.Free;
    end;
end; { MessageDlgWithNoMorebox }


end.
 