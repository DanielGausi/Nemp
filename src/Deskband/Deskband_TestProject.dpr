program Deskband_TestProject;

uses
  Forms,
  FormMainBand in 'FormMainBand.pas' {FormMainBand},
  VolumeUnit in 'VolumeUnit.pas' {VolumeForm},
  InfoUnit in 'InfoUnit.pas' {InfoForm},
  SearchUnit in 'SearchUnit.pas' {SuchForm},
  PlaylistUnit in 'PlaylistUnit.pas' {PlaylistForm},
  TaskbarStuff in 'TaskbarStuff.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TNempDeskBand, NempDeskBand);
  Application.Run;
end.                              
