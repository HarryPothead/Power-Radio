Unit newEntry;

Interface

Uses
  System.Classes,
  System.SysUtils,
  System.Variants,
  System.Win.ComObj,
  VCL.ComCtrls,
  VCL.Controls,
  VCL.Dialogs,
  VCL.ExtCtrls,
  VCL.Forms,
  VCL.StdCtrls,
  WinAPI.Windows;

Type
  TfrmNewGroup = Class(TForm)
    btnOK: TButton;
    btnClose: TButton;
    LabeledEdit1: TLabeledEdit;
    Procedure btnCloseClick(Sender: TObject);
    Procedure btnOKClick(Sender: TObject);
  Private
    { Private-Deklarationen }
  Public
    { Public-Deklarationen }
  End;

Var
  frmNewGroup: TfrmNewGroup;

Implementation

{$R *.dfm}

Procedure TfrmNewGroup.btnOKClick(Sender: TObject);
Begin
  If (LabeledEdit1.Text = '') Then
  Begin
    Showmessage('Group Name required');
    Exit;
  End
  Else
    ModalResult := MrOk;
End;

Procedure TfrmNewGroup.btnCloseClick(Sender: TObject);
Begin
  Close;
End;

End.
