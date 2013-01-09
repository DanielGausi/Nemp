program NempG15App;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {MainForm},
  lcdg15 in 'lcdg15.pas',
  lcdg15Nemp in 'lcdg15Nemp.pas',
  NempApi in '..\common\NempApi.pas';

{$R *.res}


begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
