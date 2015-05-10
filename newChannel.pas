Unit newChannel;

Interface

Uses
  System.Classes,
  System.SysUtils,
  System.Variants,
  System.Win.ComObj,
  VCL.Clipbrd,
  VCL.ComCtrls,
  VCL.Controls,
  VCL.Dialogs,
  VCL.ExtCtrls,
  VCL.Forms,
  VCL.StdCtrls,
  WinAPI.Windows;

Type
  TfrmNewChannel = Class(TForm)
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    btnOk: TButton;
    btnClose: TButton;
    btn1: TButton;
    Procedure btnCloseClick(Sender: TObject);
    Procedure btnOkClick(Sender: TObject);
    Procedure FormShow(Sender: TObject);
    Procedure btn1Click(Sender: TObject);
  Private
    { Private-Deklarationen }
  Public
    { Public-Deklarationen }
  End;

Var
  frmNewChannel: TfrmNewChannel;

Implementation

{$R *.dfm}

Uses
  Main2, DBHelper;

Procedure TfrmNewChannel.btnOkClick(Sender: TObject);
Begin
  If (LabeledEdit1.Text = '') Or (LabeledEdit2.Text = '') Or
    (frmMain.cbCountry.ItemIndex = -1) Then
  Begin
    Showmessage('Channel Name or Stream URL required');
    Exit;
  End;
  NewADOEntry(frmMain.cbCountry.Text, LabeledEdit1.Text, LabeledEdit2.Text);
  sleep(250);
  frmMain.CBsender.Items.Add(LabeledEdit1.Text);
  frmMain.CBsender.ItemIndex := frmMain.CBsender.Items.Count - 1;
  Close;
End;

Procedure TfrmNewChannel.btn1Click(Sender: TObject);
Var
  cl: TClipboard;
Begin
  cl := TClipboard.Create;
  If cl.HasFormat(CF_TEXT Or CF_UNICODETEXT) Then
    LabeledEdit2.Text := cl.AsText;
End;

Procedure TfrmNewChannel.btnCloseClick(Sender: TObject);
Begin
  Close;
End;

Procedure TfrmNewChannel.FormShow(Sender: TObject);
Begin
  LabeledEdit1.clear;
  LabeledEdit2.clear;
End;

End.
