Unit Mixer;

Interface

Uses
  Data.DB,
  Data.Win.ADODB,
  System.Classes,
  System.SysUtils,
  System.Variants,
  System.Win.ComObj,
  VCL.ComCtrls,
  VCL.Controls,
  VCL.Dialogs,
  VCL.Forms,
  WinAPI.MMSystem,
  WinAPI.Windows;

Const
  MaxMixerMasterVolume = 65535;

Procedure Mute(Enabled: Boolean);
Function GetMasterVolumeCtrl(Mixer: hMixerObj; Var Control: TMixerControl)
  : MMResult;
Function GetMasterVolume: Cardinal;
Procedure SetMasterVolume(Value: Word);

Implementation

Procedure Mute(Enabled: Boolean);
Var
  hMix: HMIXER;
  mxlc: MIXERLINECONTROLS;
  mxcd: TMIXERCONTROLDETAILS;
  mcdb: MIXERCONTROLDETAILS_BOOLEAN;
  mxc: MIXERCONTROL;
  mxl: TMIXERLINE;
  intRet, nMixerDevs: Integer;
Begin
  nMixerDevs := mixerGetNumDevs();
  If (nMixerDevs < 1) Then
    Exit;
  intRet := mixerOpen(@hMix, 0, 0, 0, 0);
  If (intRet = MMSYSERR_NOERROR) Then
  Begin
    mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_DST_SPEAKERS;
    mxl.cbStruct := SizeOf(mxl);
    intRet := mixerGetLineInfo(hMix, @mxl, MIXER_GETLINEINFOF_COMPONENTTYPE);
    If (intRet = MMSYSERR_NOERROR) Then
    Begin
      FillChar(mxlc, SizeOf(mxlc), 0);
      With mxlc Do
      Begin
        cbStruct := SizeOf(mxlc);
        dwLineID := mxl.dwLineID;
        dwControlType := MIXERCONTROL_CONTROLTYPE_MUTE;
        cControls := 1;
        cbmxctrl := SizeOf(mxc);
        pamxctrl := @mxc;
      End;
      intRet := mixerGetLineControls(hMix, @mxlc,
        MIXER_GETLINECONTROLSF_ONEBYTYPE);
      If (intRet = MMSYSERR_NOERROR) Then
      Begin
        FillChar(mxcd, SizeOf(mxcd), 0);
        With mxcd Do
        Begin
          cbStruct := SizeOf(TMIXERCONTROLDETAILS);
          dwControlID := mxc.dwControlID;
          cChannels := 1;
          cbDetails := SizeOf(MIXERCONTROLDETAILS_BOOLEAN);
          paDetails := @mcdb;
        End;
        mcdb.fValue := Ord(Enabled);
        intRet := mixerSetControlDetails(hMix, @mxcd,
          MIXER_SETCONTROLDETAILSF_VALUE);
        If (intRet <> MMSYSERR_NOERROR) Then
          ShowMessage('SetControlDetails Error');
      End
      Else
        ShowMessage('GetLineInfo Error');
    End;
    mixerClose(hMix);
  End;
End;

Function GetMasterVolumeCtrl(Mixer: hMixerObj; Var Control: TMixerControl)
  : MMResult;
Var
  Line: TMIXERLINE;
  Controls: TMixerLineControls;
Begin
  ZeroMemory(@Line, SizeOf(Line));
  Line.cbStruct := SizeOf(Line);
  Line.dwComponentType := MIXERLINE_COMPONENTTYPE_DST_SPEAKERS;
  Result := mixerGetLineInfo(Mixer, @Line, MIXER_GETLINEINFOF_COMPONENTTYPE);
  If Result = MMSYSERR_NOERROR Then
  Begin
    ZeroMemory(@Controls, SizeOf(Controls));
    With Controls Do
    Begin
      cbStruct := SizeOf(Controls);
      dwLineID := Line.dwLineID;
      cControls := 1;
      dwControlType := MIXERCONTROL_CONTROLTYPE_VOLUME;
      cbmxctrl := SizeOf(Control);
      pamxctrl := @Control;
    End;
    Result := mixerGetLineControls(Mixer, @Controls,
      MIXER_GETLINECONTROLSF_ONEBYTYPE);
  End;
End;

Procedure SetMasterVolume(Value: Word);
Var
  MasterVolume: TMixerControl;
  Details: TMIXERCONTROLDETAILS;
  UnsignedDetails: TMixerControlDetailsUnsigned;
  Mixer: hMixerObj;
  Code: MMResult;
Begin
  mixerOpen(@Mixer, 0, 0, 0, 0);
  Code := GetMasterVolumeCtrl(Mixer, MasterVolume);
  If Code = MMSYSERR_NOERROR Then
  Begin
    With Details Do
    Begin
      cbStruct := SizeOf(Details);
      dwControlID := MasterVolume.dwControlID;
      cChannels := 1; // set all channels
      cMultipleItems := 0;
      cbDetails := SizeOf(UnsignedDetails);
      paDetails := @UnsignedDetails;
    End;
    UnsignedDetails.dwValue := Value;
    Code := mixerSetControlDetails(Mixer, @Details,
      MIXER_SETCONTROLDETAILSF_VALUE);
  End;
  If Code <> MMSYSERR_NOERROR Then
    Raise Exception.CreateFmt('SetMasterVolume failure, ' +
      'multimedia system error #%d', [Code]);
End;

Function GetMasterVolume: Cardinal;
Var
  MasterVolume: TMixerControl;
  Details: TMIXERCONTROLDETAILS;
  UnsignedDetails: TMixerControlDetailsUnsigned;
  Code: MMResult;
  Mixer: hMixerObj;
  mmError: Cardinal;
Begin
  mmError := mixerOpen(@Mixer, 0, 0, 0, 0);
  If mmError <> MMSYSERR_NOERROR Then
  Begin
    Raise Exception.CreateFmt('GetMasterVolume failure, ' +
      'multimedia system error #%d', [mmError]);
  End
  Else
  Begin
    Result := 0;
    Code := GetMasterVolumeCtrl(Mixer, MasterVolume);
    If (Code = MMSYSERR_NOERROR) Then
    Begin
      With Details Do
      Begin
        cbStruct := SizeOf(Details);
        dwControlID := MasterVolume.dwControlID;
        cChannels := 1; // set all channels
        cMultipleItems := 0;
        cbDetails := SizeOf(UnsignedDetails);
        paDetails := @UnsignedDetails;
      End;
      If (mixerGetControlDetails(Mixer, @Details,
        MIXER_GETCONTROLDETAILSF_VALUE) = MMSYSERR_NOERROR) Then
        Result := UnsignedDetails.dwValue;
    End;
  End;
End;

End.
