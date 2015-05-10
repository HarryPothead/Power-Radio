Unit Main2;

Interface

Uses
  Data.DB,
  Data.Win.ADODB,
  System.Classes,
  System.IniFiles,
  System.SysUtils,
  System.UITypes,
  System.Variants,
  System.Win.ComObj,
  VCL.Clipbrd,
  VCL.ComCtrls,
  VCL.Controls,
  VCL.Dialogs,
  VCL.ExtCtrls,
  VCL.Forms,
  VCL.Graphics,
  VCL.Menus,
  VCL.StdCtrls,
  WinAPI.CommCtrl,
  WinAPI.Messages,
  WinAPI.ShellAPI,
  WinAPI.TlHelp32,
  WinAPI.Windows,
  // 3nd Party
  ACS_DXAudio,
  ACS_Classes,
  ACS_WinMedia,
  ACS_LAME,
  ScrollText;

Type
  TfrmMain = Class(TForm)
    WMATap1: TWMATap;
    RecordTimer: TTimer;
    TrayPopup: TPopupMenu;
    mbtnMaximize: TMenuItem;
    mbtnClose: TMenuItem;
    mbtnPlay: TMenuItem;
    mbtnRecord: TMenuItem;
    PopChannels: TPopupMenu;
    NewChannel: TMenuItem;
    RenameChannel: TMenuItem;
    DeleteChannel: TMenuItem;
    PopGroups: TPopupMenu;
    NewGroup: TMenuItem;
    Renamegroup: TMenuItem;
    DeleteGroup: TMenuItem;
    ADOConn: TADOConnection;
    ADOQuery1: TADOQuery;
    sTrackBar1: TTrackBar;
    btnRecord: TButton;
    btnPlay: TButton;
    StatusBar1: TStatusBar;
    cbOnTop: TCheckBox;
    sLabel1: TLabel;
    sLabel2: TLabel;
    lblVolume: TLabel;
    cbCountry: TComboBox;
    CBsender: TComboBox;
    ImportPLS: TMenuItem;
    ExportPLS: TMenuItem;
    DXAudioOut: TDXAudioOut;
    WMStreamedIn1: TWMStreamedIn;
    ImportM3U: TMenuItem;
    ExportM3U: TMenuItem;
    ScrollTimer: TTimer;
    CopyURLtoClipboard: TMenuItem;
    MP3Out1: TMP3Out;
    cbOut: TCheckBox;
    Procedure btnPlayClick(Sender: TObject);
    Procedure RecordTimerTimer(Sender: TObject);
    Procedure FormCreate(Sender: TObject);
    Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
    Procedure CBsenderChange(Sender: TObject);
    Procedure TrackBar2Change(Sender: TObject);
    Procedure cbCountryChange(Sender: TObject);
    Procedure cbOnTopClick(Sender: TObject);
    Procedure FormDestroy(Sender: TObject);
    Procedure mbtnCloseClick(Sender: TObject);
    Procedure mbtnMaximizeClick(Sender: TObject);
    Procedure mbtnPlayClick(Sender: TObject);
    Procedure FormShow(Sender: TObject);
    Procedure FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
    Procedure NewGroupClick(Sender: TObject);
    Procedure NewChannelClick(Sender: TObject);
    Procedure DeleteGroupClick(Sender: TObject);
    Procedure DeleteChannelClick(Sender: TObject);
    Procedure RenamegroupClick(Sender: TObject);
    Procedure RenameChannelClick(Sender: TObject);
    Procedure sTrackBar1Change(Sender: TObject);
    Procedure btnRecordClick(Sender: TObject);
    Procedure ImportPLSClick(Sender: TObject);
    Procedure ExportPLSClick(Sender: TObject);
    Function OpenPLS(Const FileName: String; Table: String): Boolean;
    Function SavePLS(Const FileName: String; Playlist: TStringlist): Boolean;
    Procedure ImportM3UClick(Sender: TObject);
    Procedure ExportM3UClick(Sender: TObject);
    Procedure ScrollTimerTimer(Sender: TObject);
    Procedure CopyURLtoClipboardClick(Sender: TObject);
  Private
    TaskBarNewReg: DWORD;
    IconData: TNotifyIconData;
  Public
    Procedure WndProc(Var Msg: TMessage); Override;
    Procedure WMSysCommand(Var Message: TWMSysCommand); Message WM_SYSCOMMAND;
    Function ShowModalDimmed(Form: TForm; Centered: Boolean = true)
      : TModalResult;
  End;

Var
  frmMain: TfrmMain;
  StartTime: TTime;
  IniFile: TInifile = Nil;
  IniFileName: String = '.\Power.ini';
  Nam: String;
  BitRate, SampleRate: String;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
  ContinueLoop: BOOL;
  Channels: TStringlist;
  OpenDLG: TOpenDialog;
  SaveDLG: TSaveDialog;
  ScrollSize: Integer;
  ScrollText: String;
  Rect: TRect;

Const
  FieldNum = 0;

Implementation

Uses
  Mixer, NewChannel, NewEntry, DBHelper;
{$R *.dfm}

Function TfrmMain.ShowModalDimmed(Form: TForm; Centered: Boolean = true)
  : TModalResult;
Var
  Back: TForm;
Begin
  Back := TForm.Create(Nil);
  Try
    With Back Do
    Begin
      Position := poDesigned;
      BorderStyle := bsNone;
      AlphaBlend := true;
      AlphaBlendValue := 150;
      Color := clBlack;
      SetBounds(0, 0, Screen.Width, Screen.Height);
      Show;
    End;
    If Centered Then
    Begin
      Form.Left := (Back.ClientWidth - Form.Width) Div 2;
      Form.Top := (Back.ClientHeight - Form.Height) Div 2;
    End;
    result := Form.ShowModal;
  Finally
    Back.Free;
  End;
End;

Procedure TfrmMain.WndProc(Var Msg: TMessage);
Var
  Point: TPoint;
Begin
  If Msg.Msg = WM_USER + 20 Then
  Begin
    Case Msg.lParam Of
      WM_RBUTTONDOWN:
        Begin
          SetForegroundWindow(Handle);
          GetCursorPos(Point);
          TrayPopup.PopUp(Point.X, Point.Y);
        End;
      WM_LBUTTONDOWN:
        Begin
          //
        End;
      WM_LBUTTONDBLCLK:
        Begin
          frmMain.Show;
          Shell_NotifyIcon(NIM_DELETE, @IconData);
        End;
    End;
  End
  Else If Msg.Msg = TaskBarNewReg Then
  Begin
    Shell_NotifyIcon(NIM_ADD, @IconData);
  End;
  Inherited;
End;

Procedure TfrmMain.WMSysCommand(Var Message: TWMSysCommand);
Var
  hwndOwner: HWnd;
Begin
  If Message.CmdType And $FFF0 = SC_MINIMIZE Then
  Begin
    Hide;
    Shell_NotifyIcon(NIM_ADD, @IconData);
    Application.MainForm.Hide;
    hwndOwner := GetWindow(Handle, GW_OWNER);
    ShowWindow(hwndOwner, SW_HIDE);
    ShowWindowAsync(hwndOwner, SW_HIDE);
    ShowWindowAsync(Self.Handle, SW_HIDE);
  End
  Else
    Inherited;
End;

Procedure TfrmMain.mbtnPlayClick(Sender: TObject);
Begin
  btnRecordClick(Self);
End;

Procedure TfrmMain.mbtnMaximizeClick(Sender: TObject);
Begin
  Show;
  Shell_NotifyIcon(NIM_DELETE, @IconData);
  Application.MainForm.Show;
End;

Procedure TfrmMain.mbtnCloseClick(Sender: TObject);
Begin
  frmMain.Close;
End;

Procedure TfrmMain.btnPlayClick(Sender: TObject);
Begin
  Case btnPlay.Tag Of
    0:
      Begin
        If CBsender.ItemIndex > -1 Then
        Begin
          Try
            // {$IFDEF DEBUG}
            // ShowMessage(Channels[CBsender.ItemIndex]);
            // {$ENDIF}
            WMStreamedIn1.FileName := Channels[CBsender.ItemIndex];
            WMStreamedIn1.BufferingTime := 2;
            If Not WMStreamedIn1.Valid Then
              Exception.Create('Decoder library required (Bass.dll)');
            If Not WMStreamedIn1.HasAudio Then
              Exception.Create('Audiostream is Missing or Invalid');
            If (Not WMStreamedIn1.TimedOut) Then
              Exception.Create('Connection Timeout');
            DXAudioOut.Run;
            BitRate := InttoStr(WMStreamedIn1.BitRate Div 1000) + ' kbps';
            SampleRate := InttoStr(WMStreamedIn1.SampleRate) + ' Hz';
            // StatusBar1.Panels[0].Text := CBsender.Text;
            StatusBar1.Panels[1].Text := SampleRate + ' @ ' + BitRate;
            If WMStreamedIn1.Channels = 1 Then
              StatusBar1.Panels[2].Text := 'Mono'
            Else
              StatusBar1.Panels[2].Text := 'Stereo';
            btnPlay.Tag := 1;
            btnPlay.Caption := 'Stop';
            mbtnPlay.Caption := 'Stop';
            btnRecord.Enabled := true;
            If Not cbOut.Checked Then
              WMATap1.Id3v2Tags := WMStreamedIn1.Id3v2Tags
            Else
            Begin
              // MP3Out1.Id3v1Tags := WMStreamedIn1.id;
              MP3Out1.Id3v2Tags := WMStreamedIn1.Id3v2Tags;
            End;
            ScrollText := CBsender.Text + '     ****      ' +
              Channels[CBsender.ItemIndex] + '      ****      ';
            ScrollTimer.Enabled := true;
          Except
            On E: Exception Do
            Begin
              // {$IFDEF DEBUG}
              // ShowMessage('Exception class name = ' + E.ClassName +
              // #10#13'Exception Unit = ' + E.UnitName);
              //
              // {$ELSE}
              ShowMessage('Stream URL Invalid');
              // {$ENDIF}
            End;
          End;
        End;
      End;
    1:
      Begin
        DXAudioOut.Stop(true);
        btnPlay.Tag := 0;
        btnPlay.Caption := 'Play';
        mbtnPlay.Caption := 'Play';
        StatusBar1.Panels[0].Text := ('');
        StatusBar1.Panels[1].Text := ('');
        StatusBar1.Panels[2].Text := ('');
        ScrollText := '';
        btnRecord.Enabled := False;
        btnPlay.Tag := 0;
        ScrollTimer.Enabled := False;
      End;
  End;
End;

Procedure TfrmMain.btnRecordClick(Sender: TObject);
Var
  sName: String;
Begin
  Case btnRecord.Tag Of
    0: // recording
      Begin
        If (DXAudioOut.Status = tosIdle) Then
          Exit;
        If (WMATap1.Status = tosIdle) And (MP3Out1.Status = tosIdle) Then
        Begin
          sName := ExtractFilePath(ParamStr(0)) + CBsender.Text + ' - ' +
            FormatDateTime('hh-nn-ss - dd.mm.yyyy', Now);
          WMATap1.FileName := sName + '.wma';
          MP3Out1.FileName := sName + '.mp3';
          btnRecord.Caption := 'Record Stop';
          mbtnRecord.Caption := 'Record Stop';
          btnPlay.Enabled := False;
          If Not cbOut.Checked Then
          Begin // WMA Mode
            /// btnRecord.Enabled := False;
            WMATap1.Id3v2Tags := WMStreamedIn1.Id3v2Tags;
            WMATap1.DesiredBitrate := 128;
            WMATap1.StartRecord;
          End
          Else
          Begin // MP3 Mode
            MP3Out1.Id3v2Tags := WMStreamedIn1.Id3v2Tags;
            MP3Out1.AverageBitrate := mbr128;
            MP3Out1.Run;
          End;
          StatusBar1.Panels[1].Text := ('Recording');
          RecordTimer.Enabled := true;
          StartTime := Time;
          StatusBar1.Panels[2].Text := '';
          btnRecord.Tag := 1;
        End;
      End;
    1: // idle
      Begin
        If Not cbOut.Checked Then
        Begin
          WMATap1.StopRecord;
          ShowMessage('Saved to - ' + WMATap1.FileName);
        End
        Else
        Begin
          MP3Out1.Stop(False);
          ShowMessage('Saved to - ' + MP3Out1.FileName);
        End;
        btnRecord.Caption := 'Record';
        mbtnRecord.Caption := 'Record';
        btnPlay.Enabled := true;
        RecordTimer.Enabled := False;
        If (WMATap1.Status = tosIdle) And (MP3Out1.Status = tosIdle) Then
        Begin
          BitRate := InttoStr(WMStreamedIn1.BitRate Div 1000) + ' kbps';
          SampleRate := InttoStr(WMStreamedIn1.SampleRate) + ' Hz';
          StatusBar1.Panels[1].Text := SampleRate + ' @ ' + BitRate;
          If WMStreamedIn1.Channels = 1 Then
            StatusBar1.Panels[2].Text := 'Mono'
          Else
            StatusBar1.Panels[2].Text := 'Stereo';
        End;
        btnRecord.Tag := 0;
      End;
  End;
End;

Procedure TfrmMain.sTrackBar1Change(Sender: TObject);
Var
  vol: Word;
Begin
  vol := MaxMixerMasterVolume - Abs(sTrackBar1.Position - 65535);
  SetMasterVolume(vol);
  lblVolume.Caption := 'Volume ' + Format('%1.0f %%',
    [(vol / MaxMixerMasterVolume) * 100]);
End;

Procedure TfrmMain.cbCountryChange(Sender: TObject);
Begin
  CBsender.Clear;
  Channels.Clear;
  If cbCountry.Text <> '' Then
    OpenADOTable(cbCountry.Text);
  CBsender.ItemIndex := 0;
  cbCountry.Hint := cbCountry.Text;
End;

Procedure TfrmMain.cbOnTopClick(Sender: TObject);
Begin
  If cbOnTop.Checked Then
    frmMain.FormStyle := fsStayOnTop
  Else
    frmMain.FormStyle := fsNormal;
End;

Procedure TfrmMain.CBsenderChange(Sender: TObject);
Begin
  CBsender.Hint := CBsender.Text;
End;

Procedure TfrmMain.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin
  With IniFile Do
  Begin
    If IniFile <> Nil Then
    Begin
      WriteBool('Setup', 'OnTop', cbOnTop.Checked);
      WriteBool('Setup', 'Output', cbOut.Checked);
      WriteString('Setup', 'LastGroup', cbCountry.Text);
      WriteInteger('Setup', 'LastGroupID', cbCountry.ItemIndex);
      WriteString('Setup', 'LastChannel', CBsender.Text);
      WriteInteger('Setup', 'LastChannelID', CBsender.ItemIndex);
    End;
    UpdateFile;
    Free;
    Shell_NotifyIcon(NIM_DELETE, @IconData);
  End;
End;

Procedure TfrmMain.FormCloseQuery(Sender: TObject; Var CanClose: Boolean);
Begin
  If btnPlay.Tag = 1 Then
    btnPlayClick(Self);
  If btnRecord.Tag = 1 Then
    btnRecordClick(Self);
  Channels.Free;
  Sleep(100);
  ADOConn.Connected := False;
  CanClose := true;
  Sleep(1000);
  CanClose := true;
  CanClose := DatabaseCompact('PowerDB.mdb');
End;

Procedure TfrmMain.FormCreate(Sender: TObject);
Var
  I: Integer;
Begin
  Channels := TStringlist.Create;
  Channels.Clear;
  With IniFile Do
  Begin
    If IniFile = Nil Then
      IniFile := TInifile.Create(IniFileName);
    cbOnTop.Checked := ReadBool('Setup', 'OnTop', False);
    cbOut.Checked := ReadBool('Setup', 'Output', False);
    FindGroup;
    cbCountry.Text := ReadString('Setup', 'LastGroup', '');
    cbCountry.ItemIndex := ReadInteger('Setup', 'LastGroupID', 0);
    OpenADOTable(cbCountry.Text);
    CBsender.Text := ReadString('Setup', 'LastChannel', '');
    CBsender.ItemIndex := ReadInteger('Setup', 'LastChannelID', 0);
  End;
  sTrackBar1.Max := MaxMixerMasterVolume;
  sTrackBar1.Frequency := MaxMixerMasterVolume Div 10;
  sTrackBar1.Position := Abs(MaxMixerMasterVolume - GetMasterVolume - 65535);
  // Task Icon
  TaskBarNewReg := RegisterWindowMessage('Power Radio');
  With IconData Do
  Begin
    cbSize := SizeOf;
    Wnd := Handle;
    uID := 100;
    uFlags := NIF_MESSAGE + NIF_ICON + NIF_TIP;
    uCallBackMessage := WM_USER + 20;
    hIcon := Application.Icon.Handle;
    szTip := 'Power Radio';
  End;
  // ScrollText in Statusbar
  With StatusBar1 Do
  Begin
    DoubleBuffered := true;
    canvas.Brush.Style := bsclear;
    canvas.Font.Name := 'DEFAULT_CHARSET';
    canvas.Font.Color := clSilver + $060F0F;
    canvas.Font.Size := 9;
    ScrollSize := 0;
    For I := 0 To FieldNum Do
      ScrollSize := ScrollSize + StatusBar1.Panels[I].Width;
  End;
End;

Procedure TfrmMain.FormDestroy(Sender: TObject);
Begin
  Shell_NotifyIcon(NIM_DELETE, @IconData);
End;

Procedure TfrmMain.FormShow(Sender: TObject);
// var
// r: TRect;
Begin
  // StatusBar1.Perform(SB_GETRECT, 0, Integer(@r));
  // ScrollTxt1.Parent := StatusBar1;
  // ScrollTxt1.BoundsRect := r;
  // ScrollTxt1.Caption := CBsender.Text;
  // sTrackBar1.Max := MaxMixerMasterVolume;
  // sTrackBar1.Frequency :=  MaxMixerMasterVolume div 10;
  // sTrackBar1.Position := Abs(MaxMixerMasterVolume - GetMasterVolume - 65535);
  CBsender.Hint := CBsender.Text;
  cbCountry.Hint := cbCountry.Text;
End;

Procedure TfrmMain.RecordTimerTimer(Sender: TObject);
Begin
  StatusBar1.Panels[2].Text := TimetoStr(Time - StartTime);
End;

Procedure TfrmMain.ScrollTimerTimer(Sender: TObject);
Var
  I: Integer;
Begin
  StatusBar1.Perform(SB_GETRECT, FieldNum, Integer(@Rect));
  Rect.Right := Rect.Right - 5;
  Rect.Left := Rect.Left + 3;
  StatusBar1.Repaint;
  If (ScrollSize > (StatusBar1.canvas.TextWidth(ScrollText) - Rect.Left)
    * -1) Then
  Begin
    I := StatusBar1.canvas.Font.Size Div 2;
    StatusBar1.canvas.FillRect(Rect);
    StatusBar1.canvas.TextRect(Rect, ScrollSize,
      ((Rect.Bottom - Rect.Top) Div 2) - I, ScrollText);
    dec(ScrollSize);
  End
  Else
    ScrollSize := Rect.Right;
End;

Procedure TfrmMain.TrackBar2Change(Sender: TObject);
Var
  vol: Word;
Begin
  vol := MaxMixerMasterVolume - Abs(sTrackBar1.Position - 65535);
  SetMasterVolume(vol);
  lblVolume.Caption := 'Volume ' + Format('%0.1f %%',
    [(vol / MaxMixerMasterVolume) * 100]);
End;

// ==============================================================================
// Gruppen Popup
// ==============================================================================
Procedure TfrmMain.NewGroupClick(Sender: TObject);
Begin
  frmNewGroup.LabeledEdit1.Text := '';
  If ShowModalDimmed(frmNewGroup, true) = mrOk Then
  Begin
    NewADOTable(frmNewGroup.LabeledEdit1.Text);
    frmMain.cbCountry.Items.Add(frmNewGroup.LabeledEdit1.Text);
    frmMain.cbCountry.ItemIndex := frmMain.cbCountry.Items.Count - 1;
    Sleep(200);
    FindGroup;
  End;
End;

Procedure TfrmMain.RenamegroupClick(Sender: TObject);
Begin
  frmNewGroup.LabeledEdit1.Text := cbCountry.Text;
  If ShowModalDimmed(frmNewGroup, true) = mrOk Then
  Begin
    RenADOTable(cbCountry.Text, frmNewGroup.LabeledEdit1.Text);
    cbCountry.Clear;
    // Channels.Clear;
    Sleep(200);
    FindGroup;
    cbCountry.Text := frmNewGroup.LabeledEdit1.Text;
  End
  Else
    Exit;
End;

Procedure TfrmMain.DeleteGroupClick(Sender: TObject);
Begin
  If cbCountry.Text <> '' Then
    If MessageDlg('Delete Group "' + cbCountry.Text + '" ?', mtConfirmation,
      [mbyes, mbno], 0) = mrYes Then
    Begin
      DeleteADOTable(cbCountry.Items[cbCountry.ItemIndex]);
      cbCountry.DeleteSelected;
      CBsender.Clear;
      Channels.Clear;
    End;
  frmMain.cbCountry.Clear;
  Sleep(200);
  FindGroup;
End;

// ==============================================================================
// Sender Popup
// ==============================================================================
Procedure TfrmMain.NewChannelClick(Sender: TObject);
Begin
  If cbCountry.Items.Count < 1 Then
  Begin
    ShowMessage('No Groups available');
    Exit;
  End;
  If cbCountry.Text = '' Then
  Begin
    ShowMessage('No Group Selected');
    Exit;
  End;
  ShowModalDimmed(frmNewChannel, true);
End;

Procedure TfrmMain.RenameChannelClick(Sender: TObject);
Var
  URL: String;
Begin
  URL := Channels[CBsender.ItemIndex];
  frmNewGroup.LabeledEdit1.Text := CBsender.Text;
  If ShowModalDimmed(frmNewGroup, true) = mrOk Then
  Begin
    ShowMessage('Neuer Sender: - ' + frmNewGroup.LabeledEdit1.Text + URL);
    DelADOEntry(cbCountry.Text, CBsender.Items[CBsender.ItemIndex]);
    // Tabelle Löschen
    Sleep(500);
    NewADOEntry(cbCountry.Text, frmNewGroup.LabeledEdit1.Text, URL);
    Sleep(500);
    OpenADOTable(cbCountry.Text);
  End
  Else
    Exit;
End;

Procedure TfrmMain.DeleteChannelClick(Sender: TObject);
Begin
  If CBsender.Text <> '' Then
    If MessageDlg('Delete Channel "' + CBsender.Text + '" ?', mtConfirmation,
      [mbyes, mbno], 0) = mrYes Then
    Begin
      DelADOEntry(cbCountry.Items[cbCountry.ItemIndex],
        CBsender.Items[CBsender.ItemIndex]);
      Sleep(250);
      OpenADOTable(cbCountry.Items[cbCountry.ItemIndex]);
    End;
End;

Procedure TfrmMain.CopyURLtoClipboardClick(Sender: TObject);
Var
  clb: TClipboard;
Begin
  clb := TClipboard.Create;
  clb.SetTextBuf(PWideChar(Channels[CBsender.ItemIndex]));
End;

// ==============================================================================
// Import/Export Functions
// ==============================================================================
Function TfrmMain.OpenPLS(Const FileName: String; Table: String): Boolean;
Var
  pls: TInifile;
  I, c: Integer;
Begin
  pls := TInifile.Create(FileName);
  c := pls.ReadInteger('playlist', 'NumberOfEntries', -1);
  If c > 0 Then
  Begin
    For I := 1 To c Do
      NewADOEntry(Table, pls.ReadString('playlist', 'Title' + InttoStr(I), ''),
        pls.ReadString('playlist', 'file' + InttoStr(I), ''));
    result := true;
  End
  Else
    result := False;
  pls.Free;
End;

Function TfrmMain.SavePLS(Const FileName: String;
  Playlist: TStringlist): Boolean;
Var
  pls: TInifile;
  I: Integer;
  File_N: String;
Begin
  pls := TInifile.Create(FileName);
  If Not Assigned(Playlist) Then
  Begin
    result := False;
    Exit;
  End;
  Try
    pls.WriteInteger('playlist', 'NumberOfEntries', Playlist.Count - 1);
    For I := 0 To Playlist.Count - 1 Do
    Begin
      pls.WriteString('playlist', 'file' + InttoStr(I), Playlist.Strings[I]);
      File_N := CBsender.Items[I];
      pls.WriteString('playlist', 'title' + InttoStr(I), File_N);
    End;
    result := true;
  Except
    result := False;
  End;
  pls.Free;
End;

Procedure TfrmMain.ImportPLSClick(Sender: TObject);
Var
  Table: String;
Begin
  OpenDLG := TOpenDialog.Create(Self);
  OpenDLG.Filter := 'WinAmp Playlist|*.pls';
  OpenDLG.DefaultExt := '.pls';
  If OpenDLG.Execute Then
  Begin
    Channels.Clear;
    Table := ExtractFileName(ChangeFileExt(OpenDLG.FileName, ''));
    NewADOTable(Table);
    If OpenPLS(OpenDLG.FileName, Table) Then
    Begin
      ShowMessage('Playlist successfully Imported');
      cbCountry.Clear;
      FindGroup;
      // cbCountry.Text := Table;
      OpenADOTable(Table);
    End
    Else
      // DeleteADOTable(Table);
  End;
  OpenDLG.Destroy;
End;

Procedure TfrmMain.ExportPLSClick(Sender: TObject);
Begin
  SaveDLG := TSaveDialog.Create(Self);
  SaveDLG.Filter := 'WinAmp Playlist|*.pls';
  SaveDLG.DefaultExt := '.pls';
  If SaveDLG.Execute Then
    If SavePLS(SaveDLG.FileName, Channels) Then
      ShowMessage('Playlist successfully Exported');
  SaveDLG.Destroy;
End;

Procedure TfrmMain.ImportM3UClick(Sender: TObject);
Var
  sl: TStringlist;
  I: Integer;
  TableN: String;
Begin
  sl := TStringlist.Create;
  OpenDLG := TOpenDialog.Create(Self);
  OpenDLG.Filter := 'Playlist|*.m3u';
  OpenDLG.DefaultExt := '.m3u';
  If OpenDLG.Execute Then
  Begin
    sl.LoadFromFile(OpenDLG.FileName);
    TableN := ExtractFileName(ChangeFileExt(OpenDLG.FileName, ''));
    For I := 0 To sl.Count - 1 Do
      NewADOEntry(TableN, sl[I], sl[I]);
  End;
  ShowMessage('Playlist successfully Imported');
  OpenDLG.Destroy;
End;

Procedure TfrmMain.ExportM3UClick(Sender: TObject);
Begin
  SaveDLG := TSaveDialog.Create(Self);
  SaveDLG.Filter := 'Playlist|*.m3u';
  SaveDLG.DefaultExt := '.m3u';
  If SaveDLG.Execute Then
    Channels.SaveToFile(SaveDLG.FileName);
  ShowMessage('Playlist successfully Exported');
  SaveDLG.Destroy;
End;

End.
