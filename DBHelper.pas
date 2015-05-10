Unit DBHelper;

Interface

Uses
  Data.DB,
  Data.Win.ADODB,
  System.Classes,
  System.SysUtils,
  System.Win.ComObj,
  VCL.Forms,
  VCL.Dialogs,
  WinAPI.Windows;

Procedure FindGroup;
Procedure OpenADOTable(Const TableName: String);
Procedure DeleteADOTable(Const TableName: String);
Procedure NewADOTable(Const TableName: String);
Procedure RenADOTable(Const OldName, NewName: String);
Procedure DelADOEntry(Const TableName, Entry: String);
Procedure NewADOEntry(Const TableName, Entryname, EntryURL: String);
Function DatabaseCompact(Const aAccess: String): Boolean;

Implementation

Uses
  Main2;

Function DatabaseCompact(Const aAccess: String): Boolean;
Var
  JetEngine: OleVariant;
  TempName: PWideChar;
  stAccessDB: String;
Begin
  Result := False;
  stAccessDB := 'Provider=Microsoft.Jet.OLEDB.4.0;' + 'Data Source=%s';
  TempName := PWideChar(ChangeFileExt(aAccess, '.$$$'));
  DeleteFile(TempName);
  JetEngine := CreateOleObject('JRO.JetEngine');
  Try
    JetEngine.CompactDatabase(Format(stAccessDB, [aAccess]),
      Format(stAccessDB, [TempName]));
    DeleteFile(PWideChar(aAccess));
    RenameFile(TempName, aAccess);
  Finally
    JetEngine := 'Unassigned';
    Result := True;
  End;
End;

Procedure FindGroup;
Var
  sl: TStringList;
Begin
  Try
    sl := TStringList.Create;
    frmMain.ADOConn.GetTableNames(sl);
    frmMain.cbCountry.Items.AddStrings(sl);
  Finally
    //
  End;
End;

Procedure OpenADOTable(Const TableName: String);
Var
  SQL: String;
Begin
  If TableName <> '' Then
    Try
      If (Not frmMain.ADOConn.Connected) Then
        frmMain.ADOConn.Open;
      SQL := 'Select Sender From ' + TableName;
      frmMain.ADOQuery1 := TADOQuery.Create(Nil);
      Try
        frmMain.CBsender.clear;
        Channels.clear;
        frmMain.ADOQuery1.Connection := frmMain.ADOConn;
        frmMain.ADOQuery1.SQL.Text := SQL;
        frmMain.ADOQuery1.Open;
        While Not frmMain.ADOQuery1.eof Do
        Begin
          frmMain.CBsender.Items.Add(frmMain.ADOQuery1.FieldByName('Sender')
            .AsString);
          frmMain.ADOQuery1.Next;
        End;
      Finally
        // frmMain.ADOQuery1.Free;
      End;
      SQL := 'Select URL From ' + TableName;
      frmMain.ADOQuery1 := TADOQuery.Create(Nil);
      Try
        frmMain.ADOQuery1.Connection := frmMain.ADOConn;
        frmMain.ADOQuery1.SQL.Text := SQL;
        frmMain.ADOQuery1.Open;
        While Not frmMain.ADOQuery1.eof Do
        Begin
          Channels.Add(frmMain.ADOQuery1.FieldByName('URL').AsString);
          frmMain.ADOQuery1.Next;
        End;
      Finally
        frmMain.ADOQuery1.Free;
      End;
      If (frmMain.ADOConn.Connected) Then
        frmMain.ADOConn.Close;
    Finally
      Sleep(200);
    End;
End;

Procedure DeleteADOTable(Const TableName: String);
Begin
  frmMain.ADOConn.Execute('DROP TABLE  ' + TableName);
  Sleep(200);
End;

Procedure NewADOTable(Const TableName: String);
Begin
  frmMain.ADOConn.Execute('CREATE TABLE ' + TableName +
    '(Sender String, URL String)');
  Sleep(200);
End;

Procedure RenADOTable(Const OldName, NewName: String);
Begin
  NewADOTable(NewName);
  frmMain.ADOConn.Execute('INSERT INTO ' + NewName + ' SELECT * FROM '
    + OldName);
  DeleteADOTable(OldName);
  Sleep(200);
End;

Procedure DelADOEntry(Const TableName, Entry: String);
Begin
  frmMain.ADOConn.Execute('DELETE FROM ' + TableName + ' WHERE Sender = "' +
    Entry + '"');
  Sleep(200);
End;

Procedure NewADOEntry(Const TableName, Entryname, EntryURL: String);
Begin
  frmMain.ADOConn.Execute('INSERT INTO ' + TableName + ' (Sender,URL) VALUES ("'
    + Entryname + '",' + '"' + EntryURL + '")');
  Sleep(200);
End;

End.
