unit Editor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,

  Main, newEntry, newChannel, DBHelper;

type
  TfrmEditor = class(TForm)
    ListBoxGroups: TListBox;
    Label1: TLabel;
    ListBoxSender: TListBox;
    btnNewGroup: TButton;
    btnDelGroup: TButton;
    btnNewChannel: TButton;
    btnDelChannel: TButton;
    Label2: TLabel;
    btnClose: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ListBoxGroupsClick(Sender: TObject);
    procedure btnNewGroupClick(Sender: TObject);
    procedure btnNewChannelClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnDelChannelClick(Sender: TObject);
    procedure btnDelGroupClick(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  frmEditor: TfrmEditor;
  Nam: String;

implementation

{$R *.dfm}

procedure TfrmEditor.btnCloseClick(Sender: TObject);
begin
FindGroups(0);
  Close;
end;

procedure TfrmEditor.btnDelChannelClick(Sender: TObject);
begin
  DelADOEntry(ListBoxGroups.Items[ListBoxGroups.Itemindex], ListBoxSender.Items[ListBoxSender.Itemindex]);
  sleep(250);
  OpenADOTable(ListBoxGroups.Items[ListBoxGroups.Itemindex]);
end;

procedure TfrmEditor.btnDelGroupClick(Sender: TObject);
begin
  DeleteADOTable(ListBoxGroups.Items[ListBoxGroups.Itemindex]);
  FindGroups(1);
end;

procedure TfrmEditor.btnNewChannelClick(Sender: TObject);
begin
  if ListBoxGroups.Items.Count < 1 then
  begin
    showMessage('No Groups available');
    Exit;
  end;
  if frmNewChannel.Visible = False then
    frmNewChannel.ShowModal;
end;

procedure TfrmEditor.btnNewGroupClick(Sender: TObject);
begin
  if frmNewGroup.Visible = False then
    frmNewGroup.ShowModal;
end;

procedure TfrmEditor.FormCreate(Sender: TObject);
begin
 FindGroups(1);
end;

procedure TfrmEditor.ListBoxGroupsClick(Sender: TObject);
begin
  ListBoxSender.clear;
  OpenADOTable(ListBoxGroups.Items[ListBoxGroups.Itemindex],1);
end;

end.
