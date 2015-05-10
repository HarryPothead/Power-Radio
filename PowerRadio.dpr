Program PowerRadio;

uses
  VCL.Forms,
  VCL.Themes,
  Mixer in 'Mixer.pas',
  DBHelper in 'DBHelper.pas',
  newChannel in 'newChannel.pas' {frmNewChannel} ,
  newEntry in 'newEntry.pas' {frmNewGroup} ,
  Main2 in 'Main2.pas' {frmMain} ,
  VCL.Styles;

{$R *.res}

Begin
  Application.Initialize;
  TStyleManager.TrySetStyle('Charcoal Dark Slate');
  Application.Title := 'Power Radio';
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmNewChannel, frmNewChannel);
  Application.CreateForm(TfrmNewGroup, frmNewGroup);
  Application.Run;

End.
