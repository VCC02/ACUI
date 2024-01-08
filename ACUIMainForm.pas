{
    Copyright (C) 2023 VCC
    creation date: 15 May 2021
    initial release date: 31 Dec 2023

    author: VCC
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"),
    to deal in the Software without restriction, including without limitation
    the rights to use, copy, modify, merge, publish, distribute, sublicense,
    and/or sell copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following conditions:
    The above copyright notice and this permission notice shall be included
    in all copies or substantial portions of the Software.
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
    DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
    OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
}


unit ACUIMainForm;

{$IFDEF FPC}
  {$mode Delphi}{$H+}
{$ENDIF}

interface

uses
  {$IFDEF FPC}
    {$IFDEF Windows}
      Windows,
    {$ELSE}
      LCLIntf, LCLType,
    {$ENDIF}
  {$ELSE}
    Windows,
  {$ENDIF}
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, Buttons, WaveformUtils,
  WaveformsEditorFrame, Menus, ImgList, VirtualTrees;

type
//  TReadThread = class(TThread)
//  protected
//    procedure Execute; override;
//  end;

  { TfrmACUIMain }

  TfrmACUIMain = class(TForm)
    grpCOMPort: TGroupBox;
    btnConnect: TButton;
    btnDisconnect: TButton;
    cmbCOMPort: TComboBox;
    chkShowAll: TCheckBox;
    memLog: TMemo;
    PageControl1: TPageControl;
    tabSheetLEDs: TTabSheet;
    tabSheetLogicScope: TTabSheet;
    tmrStartup: TTimer;
    bitbtnSetLED_YELLOW: TBitBtn;
    lblLEDsInfo: TLabel;
    bitbtnSetLED_ORANGE: TBitBtn;
    bitbtnSetLED_GREEN: TBitBtn;
    bitbtnSetLED_RED: TBitBtn;
    cmbYellowLED: TComboBox;
    cmbOrangeLED: TComboBox;
    cmbGreenLED: TComboBox;
    cmbRedLED: TComboBox;
    lblYellowLEDInfo: TLabel;
    lblOrangeLEDInfo: TLabel;
    lblGreenLEDInfo: TLabel;
    lblRedLEDInfo: TLabel;
    trbSampleCount: TTrackBar;
    btnReadLogicScope: TButton;
    lblLSSampleCount: TLabel;
    btnSetResponseFormatToJSON: TButton;
    StatusBar1: TStatusBar;
    chkLimitMaxTo255: TCheckBox;
    lbeLSFreq: TLabeledEdit;
    btnZoomIn: TButton;
    btnZoomOut: TButton;
    rdgrpLSStyle: TRadioGroup;
    tabSheetManualCommands: TTabSheet;
    lbeManualCommands: TLabeledEdit;
    btnSendManualCommand: TButton;
    spdbtnCommandMenu: TSpeedButton;
    pmCommandsMenu: TPopupMenu;
    lstCommandGet: TListBox;
    GenericCommandItem1: TMenuItem;
    lstCommandSet: TListBox;
    lblResponseFormat: TLabel;
    btnSetResponseFormatToBIN: TButton;
    lblScopeFormatInfo: TLabel;
    spdbtnFreqMenu: TSpeedButton;
    imglstPageIcons: TImageList;
    pmFreqMenu: TPopupMenu;
    GenericFreqItem1: TMenuItem;
    tabSheetDigitalVoltmeter: TTabSheet;
    btnReadDVM: TButton;
    btnFlushInputBuffer: TButton;
    lblDVMFormatInfo: TLabel;
    chkReadDVMInLoop: TCheckBox;
    tmrReadDVM: TTimer;
    pmZoom: TPopupMenu;
    ResetZoom1: TMenuItem;
    lblCOMStatus: TLabel;
    lblStatusMsg: TLabel;
    tmrReadScope: TTimer;
    chkReadLogicScopeInLoop: TCheckBox;
    procedure cmbCOMPortDropDown(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
    procedure tmrStartupTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure bitbtnSetLED_YELLOWClick(Sender: TObject);
    procedure bitbtnSetLED_ORANGEClick(Sender: TObject);
    procedure bitbtnSetLED_GREENClick(Sender: TObject);
    procedure bitbtnSetLED_REDClick(Sender: TObject);
    procedure trbSampleCountChange(Sender: TObject);
    procedure btnReadLogicScopeClick(Sender: TObject);
    procedure rdgrpResponseFormatClick(Sender: TObject);
    procedure btnSetResponseFormatToJSONClick(Sender: TObject);
    procedure btnZoomInClick(Sender: TObject);
    procedure btnZoomOutClick(Sender: TObject);
    procedure btnSendManualCommandClick(Sender: TObject);
    procedure GenericCommandItem1Click(Sender: TObject);
    procedure spdbtnCommandMenuClick(Sender: TObject);
    procedure btnSetResponseFormatToBINClick(Sender: TObject);
    procedure GenericFreqItem1Click(Sender: TObject);
    procedure spdbtnFreqMenuClick(Sender: TObject);
    procedure btnReadDVMClick(Sender: TObject);
    procedure vstDVMGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: {$IFDEF FPC}string{$ELSE}WideString{$ENDIF});
    procedure btnFlushInputBufferClick(Sender: TObject);
    procedure chkReadDVMInLoopClick(Sender: TObject);
    procedure tmrReadDVMTimer(Sender: TObject);
    procedure ResetZoom1Click(Sender: TObject);
    procedure tmrReadScopeTimer(Sender: TObject);
    procedure chkReadLogicScopeInLoopClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FrameWaveformsEditor1: TFrameWaveformsEditor;
    vstDVM: TVirtualStringTree;
    
    FCOMName: string;
    FConnHandle: THandle;
    FReadingScopeFromTimerEnabled: Boolean;  //prevents calling from timer if AppProcMsg is called

    FResponseFormat: Integer;
    FSampleCountInBinMode: Integer;
    FDVMValues: array[0..13] of Double;

    procedure LoadSettingsFromIni;
    procedure SaveSettingsToIni;
    procedure AddToLog(s: string);
    procedure CreateRemainingUIComponents;

    procedure DisplayExtraErrorMessage(AMsg: string; AExtraInfo: string = '');
    procedure ClearExtraErrorMessage;

    {$IFnDEF UNIX}
      procedure DetectDeviceChange(var Msg: TMessage); message WM_DEVICECHANGE;
    {$ENDIF}

    procedure ConnectToCOMPort;
    procedure DisconnectFromCOMPort;
    function ReadStringFromCom(AConnHandle: THandle): AnsiString;
    function GetCurrentCOMName: string;

    procedure UpdateListOfCOMPorts;
    procedure SetLEDLabelsToUnassigned;
    procedure AddSignalsToLogicScope;
    procedure UpdateSampleCountLabel;
    procedure UpdateResponseFormat;
    procedure ReadLogicScope;
    function GetLScopeSampleDuration: Extended;  //decodes LS frequency and converts it to sample period
    procedure UpdateLogicScopeWithSignalValues(LSSignalValues: AnsiString);
    procedure UpdateDVMWithValues(DVMValues: AnsiString);
    procedure AddCommandToCommandsMenu(ACommand: string; ParentMenuItem: TMenuItem);
    procedure AddFreqToFreqMenu(AFreq: string; ParentMenuItem: TMenuItem);
    procedure PopulateCommandsMenu;
    procedure PopulateFreqMenu;

    procedure ZoomIn;
    procedure ZoomOut;
    procedure ResetZoom;

    function SendCmdReceiveResponse(ACmd: AnsiString; Timeout: Integer = 10; MinByteCountToStopWaiting: Cardinal = 20): AnsiString;
    function SetLED(LEDColor: AnsiString; LEDIndex: Byte): Boolean;
    procedure GetProduct;
    function LogicScope(Freq: AnsiString; SampleCount: Integer): AnsiString;
    function DVM(Freq: AnsiString; SampleCount: Integer): AnsiString;
    procedure SetResponseFormat(AFormat: string);
    procedure SendManualCommand(ACommand: AnsiString);
  public
    { Public declarations }
    property COMName: string read FCOMName;
  end;

var
  frmACUIMain: TfrmACUIMain;


//  This project defines OpenComFilter compiler directive,
//  used by the SimpleCOM unit, to filter out dangling COM port connnections.
//  These connections are listed by ListExistentCOMPorts.

implementation

{$IFDEF FPC}
  {$R *.frm}
{$ELSE}
  {$R *.dfm}
{$ENDIF}

{$R Theme.res}


uses
  SimpleCOM,
  {$IFnDEF Windows}
    termio,
  {$ENDIF}
  IniFiles, WaveformFuncUtils;

const
  CBufferSize = 20000;
  CLED_YELLOW = 'YELLOW';
  CLED_ORANGE = 'ORANGE';
  CLED_GREEN = 'GREEN';
  CLED_RED = 'RED';

  //C_LS_MinSampleCountOnJSON = 1;
  //C_LS_MinSampleCountOnBIN = 1;
  C_LS_MaxSampleCountOnJSON = 100;
  C_LS_MaxSampleCountOnBIN = 255;   //found experimentally   (542 is reported by firmware, but values greater than 255 result in corrupt/truncated/overwritten responses)

  C_ResponseFormat_JSON = 0;
  C_ResponseFormat_BIN = 1;
  C_ResponseFormat_XTERM = 2;
  C_ResponseFormat_ANSI = 3;

//type
//  TArr = array[0..0] of AnsiChar;

var
  AllSignals: TPSignalArr; //all pointers


//procedure TReadThread.Execute;
//var
//  Buffer: array[0..CBufferSize - 1] of AnsiChar;
//  arr: ^TArr;
//  TempNrCharsReceived: Integer;
//begin
//  try
//    repeat
//      if GetReceivedByteCount(FConnHandle) > 0 then
//        if ReceiveDataFromCOM(FConnHandle, Buffer, TempNrCharsReceived) <> -1 then
//    until Terminated;
//  except
//
//  end;
//end;


procedure TfrmACUIMain.LoadSettingsFromIni;
var
  Ini: TMemIniFile;
begin
  Ini := TMemIniFile.Create(ExtractFilePath(ParamStr(0)) + 'ACUI.ini');
  try
    Left := Ini.ReadInteger('Window', 'Left', Left);
    Top := Ini.ReadInteger('Window', 'Top', Top);
    Width := Ini.ReadInteger('Window', 'Width', Width);
    Height := Ini.ReadInteger('Window', 'Height', Height);
    PageControl1.ActivePageIndex := Ini.ReadInteger('Window', 'Page', PageControl1.ActivePageIndex);

    FCOMName := Ini.ReadString('Settings', 'COM', '');
    cmbYellowLED.ItemIndex := Ini.ReadInteger('Settings', 'YellowLED', cmbYellowLED.ItemIndex);
    cmbOrangeLED.ItemIndex := Ini.ReadInteger('Settings', 'OrangeLED', cmbOrangeLED.ItemIndex);
    cmbGreenLED.ItemIndex := Ini.ReadInteger('Settings', 'GreenLED', cmbGreenLED.ItemIndex);
    cmbRedLED.ItemIndex := Ini.ReadInteger('Settings', 'RedLED', cmbRedLED.ItemIndex);

    chkLimitMaxTo255.Checked := Ini.ReadBool('Settings', 'LimitMaxTo255', chkLimitMaxTo255.Checked);
    FResponseFormat := Ini.ReadInteger('Settings', 'ResponseFormat', FResponseFormat);
    UpdateResponseFormat;

    trbSampleCount.Position := Ini.ReadInteger('Settings', 'LSSampleCount', trbSampleCount.Position);
    UpdateSampleCountLabel;

    lbeLSFreq.Text := Ini.ReadString('Settings', 'LSFreq', lbeLSFreq.Text);

    FrameWaveformsEditor1.LoadSettings(Ini);
  finally
    Ini.Free;
  end;
end;


procedure TfrmACUIMain.SaveSettingsToIni;
var
  Ini: TMemIniFile;
begin
  Ini := TMemIniFile.Create(ExtractFilePath(ParamStr(0)) + 'ACUI.ini');
  try
    Ini.WriteInteger('Window', 'Left', Left);
    Ini.WriteInteger('Window', 'Top', Top);
    Ini.WriteInteger('Window', 'Width', Width);
    Ini.WriteInteger('Window', 'Height', Height);
    Ini.WriteInteger('Window', 'Page', PageControl1.ActivePageIndex);

    Ini.WriteString('Settings', 'COM', FCOMName);
    Ini.WriteInteger('Settings', 'YellowLED', cmbYellowLED.ItemIndex);
    Ini.WriteInteger('Settings', 'OrangeLED', cmbOrangeLED.ItemIndex);
    Ini.WriteInteger('Settings', 'GreenLED', cmbGreenLED.ItemIndex);
    Ini.WriteInteger('Settings', 'RedLED', cmbRedLED.ItemIndex);

    Ini.WriteBool('Settings', 'LimitMaxTo255', chkLimitMaxTo255.Checked);
    Ini.WriteInteger('Settings', 'ResponseFormat', FResponseFormat);
    Ini.WriteInteger('Settings', 'LSSampleCount', trbSampleCount.Position);
    Ini.WriteString('Settings', 'LSFreq', lbeLSFreq.Text);

    FrameWaveformsEditor1.SaveSettings(Ini);
    
    Ini.UpdateFile;
  finally
    Ini.Free;
  end;
end;


procedure TfrmACUIMain.AddToLog(s: string);
begin
  memLog.Lines.Add('(' + TimeToStr(Now) + ')  ' + s);
end;


procedure TfrmACUIMain.DisplayExtraErrorMessage(AMsg: string; AExtraInfo: string = '');
begin
  lblStatusMsg.Caption := 'Msg: ' + AMsg;
  lblStatusMsg.Font.Color := clMaroon;
  lblStatusMsg.Font.Style := [fsBold];
  lblStatusMsg.Hint := AExtraInfo;

  {$IFDEF UNIX}
    if AMsg = 'Permission denied' then
      lblStatusMsg.Hint := lblStatusMsg.Hint + #13#10 +
                           'Type this into a terminal, then relogin: ' + #13#10 +
                           'sudo usermod -a -G dialout $USER';
  {$ENDIF}
end;


procedure TfrmACUIMain.ClearExtraErrorMessage;
begin
  lblStatusMsg.Caption := 'Msg';
  lblStatusMsg.Font.Color := clWindowText;
  lblStatusMsg.Font.Style := [];
end;


function TfrmACUIMain.ReadStringFromCom(AConnHandle: THandle): AnsiString;
var
  Buffer: array[0..CBufferSize - 1] of AnsiChar;
  RecLen: Integer;
begin
  RecLen := GetReceivedByteCount(AConnHandle);
  if RecLen = -1 then
  begin
    Result := SysErrorMessage(GetCOMError(FCOMName)) + '  ' + GetCOMExtraError(FCOMName);
    Exit;
  end;
    
  RecLen := ReceiveDataFromCOM(AConnHandle, Buffer, RecLen);
  SetLength(Result, RecLen);
  Move(Buffer[0], Result[1], RecLen);
end;


{$IFnDEF UNIX}
  procedure TfrmACUIMain.DetectDeviceChange(var Msg: TMessage);
  begin
    Sleep(100);
    UpdateListOfCOMPorts;  //if the handle is still connected (open), then the COM port is listed in registry, so ListExistentCOMPorts will return unavailable ports 

    if cmbCOMPort.Items.IndexOf(FCOMName) = -1 then  //current com is disconnected
    begin
      if COMIsConnected(FCOMName) then
      begin
        AddToLog('Disconnecting current COM port: ' + FCOMName);
        DisconnectFromCOMPort;
      end;

      AddToLog(FCOMName + ' is not available anymore.'); //setting FCOMName to '', would prevent this message to be displayed multiple times, but it will break other logic
    end
    else
      if not COMIsConnected(FCOMName) then
        if cmbCOMPort.ItemIndex = -1 then
        begin
          cmbCOMPort.ItemIndex := cmbCOMPort.Items.IndexOf(FCOMName);
          AddToLog(FCOMName + ' is available...');
        end;
  end;
{$ENDIF}


procedure TfrmACUIMain.UpdateListOfCOMPorts;
var
  OldSelection: string;
  NewSelectionIndex: Integer;
  AllCOMs: TStringList;
begin
  AllCOMs := TStringList.Create;
  try
    ListExistentCOMPorts(AllCOMs, Visible and chkShowAll.Checked);

    if cmbCOMPort.Items.Text <> AllCOMs.Text then
    begin
      OldSelection := '';
      if cmbCOMPort.ItemIndex <> -1 then
        OldSelection := cmbCOMPort.Items.Strings[cmbCOMPort.ItemIndex];

      cmbCOMPort.Items.Text := AllCOMs.Text;

      if OldSelection <> '' then
      begin
        NewSelectionIndex := cmbCOMPort.Items.IndexOf(OldSelection);
        if NewSelectionIndex <> -1 then
          cmbCOMPort.ItemIndex := NewSelectionIndex;
      end;
    end;
  finally
    AllCOMs.Free;
  end;
end;


procedure TfrmACUIMain.GenericCommandItem1Click(Sender: TObject);
var
  AComand: string;
begin
  AComand := (Sender as TMenuItem).Caption;
  AComand := StringReplace(AComand, '&', '', [rfReplaceAll]);

  lbeManualCommands.Text := AComand;
end;


procedure TfrmACUIMain.GenericFreqItem1Click(Sender: TObject);
var
  AFreq: string;
  PosBlank: Integer;
begin
  AFreq := (Sender as TMenuItem).Caption;
  AFreq := StringReplace(AFreq, '&', '', [rfReplaceAll]);

  PosBlank := Pos(' ', AFreq);
  if PosBlank > 0 then
    AFreq := Copy(AFreq, 1, PosBlank - 1);

  lbeLSFreq.Text := AFreq;
end;


procedure TfrmACUIMain.bitbtnSetLED_YELLOWClick(Sender: TObject);
begin
  if SetLED(CLED_YELLOW, cmbYellowLED.ItemIndex) then
    lblYellowLEDInfo.Caption := cmbYellowLED.Items.Strings[cmbYellowLED.ItemIndex];
end;


procedure TfrmACUIMain.bitbtnSetLED_ORANGEClick(Sender: TObject);
begin
  if SetLED(CLED_ORANGE, cmbOrangeLED.ItemIndex) then
    lblOrangeLEDInfo.Caption := cmbOrangeLED.Items.Strings[cmbOrangeLED.ItemIndex];
end;


procedure TfrmACUIMain.bitbtnSetLED_GREENClick(Sender: TObject);
begin
  if SetLED(CLED_GREEN, cmbGreenLED.ItemIndex) then
    lblGreenLEDInfo.Caption := cmbGreenLED.Items.Strings[cmbGreenLED.ItemIndex];
end;


procedure TfrmACUIMain.bitbtnSetLED_REDClick(Sender: TObject);
begin
  if SetLED(CLED_RED, cmbRedLED.ItemIndex) then
    lblRedLEDInfo.Caption := cmbRedLED.Items.Strings[cmbRedLED.ItemIndex];
end;


procedure TfrmACUIMain.ConnectToCOMPort;
begin
  lblCOMStatus.Font.Color := $00006800;
  lblCOMStatus.Caption := 'Status: Connected';
  lblCOMStatus.Hint := 'Status is updated on connect/disconnect.';

  ClearExtraErrorMessage;

  btnConnect.Enabled := False;
  btnDisconnect.Enabled := True;
  cmbCOMPort.Enabled := False;

  Sleep(500);

  AddToLog(ReadStringFromCom(FConnHandle));

  {$IFnDEF UNIX} //this IFDEF will not work on MAC and TD2006 at the same time
    PurgeComm(FConnHandle, PURGE_RXABORT or PURGE_RXCLEAR);
  {$ENDIF}  

  Sleep(50);

  GetProduct;
  SetLEDLabelsToUnassigned;

  if FResponseFormat = C_ResponseFormat_BIN then
    SetResponseFormat('BIN');

  btnSetResponseFormatToJSON.Enabled := True;
  btnSetResponseFormatToBIN.Enabled := True;

  bitbtnSetLED_YELLOW.Enabled := True;
  bitbtnSetLED_ORANGE.Enabled := True;
  bitbtnSetLED_GREEN.Enabled := True;
  bitbtnSetLED_RED.Enabled := True;

  btnReadLogicScope.Enabled := True;
  btnSendManualCommand.Enabled := True;
  btnFlushInputBuffer.Enabled := True;
  btnReadDVM.Enabled := True;
end;


procedure TfrmACUIMain.DisconnectFromCOMPort;
begin
  DisconnectFromCOM(FCOMName);  //set internal library info to "disconnected"

  try
    lblCOMStatus.Hint := SysErrorMessage(GetCOMError(FCOMName));
  except
    //GetComErrors may throw an AV if the COM port is closed  :(
  end;

  lblCOMStatus.Font.Color := clMaroon;
  lblCOMStatus.Caption := 'Status: Disconnected';

  ClearExtraErrorMessage;
  
  btnConnect.Enabled := True;
  btnDisconnect.Enabled := False;
  cmbCOMPort.Enabled := True;

  btnConnect.Enabled := True;
  btnDisconnect.Enabled := False;
  btnReadLogicScope.Enabled := False;
end;


function TfrmACUIMain.GetCurrentCOMName: string;
begin
  if cmbCOMPort.ItemIndex = -1 then
  begin
    Result := '';
    Exit;
  end;

  Result := cmbCOMPort.Items.Strings[cmbCOMPort.ItemIndex];
end;


procedure TfrmACUIMain.ReadLogicScope;
var
  LSSignalValues: AnsiString;
begin
  btnReadLogicScope.Enabled := False;
  try
    LSSignalValues := LogicScope(lbeLSFreq.Text, trbSampleCount.Position);
  finally
    btnReadLogicScope.Enabled := True;
  end;

  if FResponseFormat = C_ResponseFormat_BIN then
    UpdateLogicScopeWithSignalValues(LSSignalValues);
end;


{$IFnDEF Windows}
  procedure HandleOnOverrideCOMSettings(AComName: string; var tios: Termios);
  begin
    tios.c_iflag := 4;
    tios.c_oflag := 0;
    tios.c_cflag := 5362;
    tios.c_lflag := 0;
    tios.c_line := #0;

    tios.c_cc[0] := 3;
    tios.c_cc[1] := 28;
    tios.c_cc[2] := 127;
    tios.c_cc[3] := 21;
    tios.c_cc[4] := 1;
    tios.c_cc[5] := 0;
    tios.c_cc[6] := 1;
    tios.c_cc[7] := 0;
    tios.c_cc[8] := 17;
    tios.c_cc[9] := 19;
    tios.c_cc[10] := 26;
    tios.c_cc[11] := 0;
    tios.c_cc[12] := 18;
    tios.c_cc[13] := 15;
    tios.c_cc[14] := 23;
    tios.c_cc[15] := 22;
    tios.c_cc[16] := 0;
    tios.c_cc[17] := 0;
    tios.c_cc[18] := 0;
    tios.c_cc[19] := 64;
    tios.c_cc[20] := 110;
    tios.c_cc[21] := 11;
    tios.c_cc[22] := 10;
    tios.c_cc[23] := 42;
    tios.c_cc[24] := 149;
    tios.c_cc[25] := 7;
    tios.c_cc[26] := 8;
    tios.c_cc[27] := 48;
    tios.c_cc[28] := 235;
    tios.c_cc[29] := 127;
    tios.c_cc[30] := 182;
    tios.c_cc[31] := 0;

    tios.c_ispeed := 3216363864;
    tios.c_ospeed := 134613246;
  end;
{$ENDIF}

procedure TfrmACUIMain.btnConnectClick(Sender: TObject);
begin
  FCOMName := GetCurrentCOMName;
  if FCOMName = '' then
  begin
    DisplayExtraErrorMessage('No COM is selected.');
    Exit;
  end;

  {$IFnDEF Windows}
    OnOverrideCOMSettings := HandleOnOverrideCOMSettings;
  {$ENDIF}

  FConnHandle := ConnectToCOM(FCOMName, 115200, {Parity_none, 8, ONESTOPBIT,} 4096, 4096);
  if FConnHandle > 0 then
    ConnectToCOMPort
  else
  begin
    try
      DisplayExtraErrorMessage(SysErrorMessage(GetCOMError(FCOMName)), GetCOMExtraError(FCOMName)); //SysErrorMessage(GetLastError);
    except
      //GetComErrors may throw an AV if the COM port is closed  :(
    end;
  end;
end;


procedure TfrmACUIMain.btnDisconnectClick(Sender: TObject);
begin
  DisconnectFromCOMPort;
end;


procedure TfrmACUIMain.btnFlushInputBufferClick(Sender: TObject);
begin
  {$IFnDEF UNIX} //this IFDEF will not work on MAC and TD2006 at the same time
    PurgeComm(FConnHandle, PURGE_RXABORT or PURGE_RXCLEAR);
  {$ENDIF}
end;


procedure TfrmACUIMain.btnReadDVMClick(Sender: TObject);
var
  DVMValues: AnsiString;
begin
  btnReadDVM.Enabled := False;
  try
    DVMValues := DVM(lbeLSFreq.Text, trbSampleCount.Position);
  finally
    btnReadDVM.Enabled := True;
  end;

  if FResponseFormat = C_ResponseFormat_BIN then
    UpdateDVMWithValues(DVMValues);
end;


procedure TfrmACUIMain.btnReadLogicScopeClick(Sender: TObject);
begin
  ReadLogicScope;
end;


procedure TfrmACUIMain.btnSendManualCommandClick(Sender: TObject);
begin
  SendManualCommand(lbeManualCommands.Text);
end;


procedure TfrmACUIMain.btnSetResponseFormatToBINClick(Sender: TObject);
begin
  SetResponseFormat('BIN');
  UpdateResponseFormat;
end;


procedure TfrmACUIMain.btnSetResponseFormatToJSONClick(Sender: TObject);
begin
  SetResponseFormat('JSON');
  UpdateResponseFormat;
end;


procedure TfrmACUIMain.ZoomIn;
begin
  FrameWaveformsEditor1.Zoom := FrameWaveformsEditor1.Zoom * 2;
  StatusBar1.Panels.Items[1].Text := 'Zoom level: ' + FloatToStr(FrameWaveformsEditor1.Zoom);
  FrameWaveformsEditor1.SetWaveformEditorScrollMax;
  //vstWaveformsEditor.Repaint;
  FrameWaveformsEditor1.PaintAllWaveforms;
end;


procedure TfrmACUIMain.ZoomOut;
begin
  FrameWaveformsEditor1.Zoom := FrameWaveformsEditor1.Zoom / 2;
  StatusBar1.Panels.Items[1].Text := 'Zoom level: ' + FloatToStr(FrameWaveformsEditor1.Zoom);
  FrameWaveformsEditor1.SetWaveformEditorScrollMax;
  //vstWaveformsEditor.Repaint;
  FrameWaveformsEditor1.PaintAllWaveforms;
end;


procedure TfrmACUIMain.ResetZoom;
begin
  FrameWaveformsEditor1.Zoom := 1;
  StatusBar1.Panels.Items[1].Text := 'Zoom level: 1';
  FrameWaveformsEditor1.SetWaveformEditorScrollMax;
  FrameWaveformsEditor1.scrbarTimeWaveforms.Position := 0;
  //vstWaveformsEditor.Repaint;
  //FrameWaveformsEditor1.PaintAllWaveforms;
end;


procedure TfrmACUIMain.btnZoomInClick(Sender: TObject);
begin
  ZoomIn;
end;


procedure TfrmACUIMain.btnZoomOutClick(Sender: TObject);
begin
  ZoomOut;
end;


procedure TfrmACUIMain.chkReadDVMInLoopClick(Sender: TObject);
begin
  tmrReadDVM.Enabled := chkReadDVMInLoop.Checked;
end;


procedure TfrmACUIMain.chkReadLogicScopeInLoopClick(Sender: TObject);
begin
  tmrReadScope.Enabled := chkReadLogicScopeInLoop.Checked;
end;


procedure TfrmACUIMain.cmbCOMPortDropDown(Sender: TObject);
begin
  UpdateListOfCOMPorts;
end;


procedure TfrmACUIMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  tmrReadDVM.Enabled := False;
  tmrReadScope.Enabled := False;

  try
    SaveSettingsToIni;
  except

  end;
end;


procedure TfrmACUIMain.CreateRemainingUIComponents;
var
  NewColum: TVirtualTreeColumn;
begin
  FrameWaveformsEditor1 := TFrameWaveformsEditor.Create(Self);
  FrameWaveformsEditor1.Parent := tabSheetLogicScope;
  FrameWaveformsEditor1.Left := 3;
  FrameWaveformsEditor1.Top := 70;
  FrameWaveformsEditor1.Width := 605;
  FrameWaveformsEditor1.Height := {$IFDEF FPC} 240 {$ELSE} 200 {$ENDIF};//174;
  FrameWaveformsEditor1.Anchors := [akLeft, akTop, akRight, akBottom];
  FrameWaveformsEditor1.Color := clWindow;
  FrameWaveformsEditor1.ParentColor := False;
  FrameWaveformsEditor1.TabOrder := 2;
  FrameWaveformsEditor1.TabStop := True;

  vstDVM := TVirtualStringTree.Create(Self);
  vstDVM.Parent := tabSheetDigitalVoltmeter;

  vstDVM.Left := 4;
  vstDVM.Top := 48;
  vstDVM.Width := 605;
  vstDVM.Height := 233;
  vstDVM.DefaultNodeHeight := 26;
  vstDVM.Font.Charset := DEFAULT_CHARSET;
  vstDVM.Font.Color := clWindowText;
  vstDVM.Font.Height := -19;
  vstDVM.Font.Name := 'Tahoma';
  vstDVM.Font.Style := [];
  vstDVM.Header.AutoSizeIndex := 0;
  vstDVM.Header.DefaultHeight := 21;
  vstDVM.Header.Font.Charset := DEFAULT_CHARSET;
  vstDVM.Header.Font.Color := clWindowText;
  vstDVM.Header.Font.Height := -11;
  vstDVM.Header.Font.Name := 'Tahoma';
  vstDVM.Header.Font.Style := [];
  vstDVM.Header.Height := 21;
  vstDVM.Header.Options := [hoColumnResize, hoDblClickResize, hoDrag, hoShowSortGlyphs, hoVisible];
  vstDVM.Header.Style := hsFlatButtons;
  vstDVM.Indent := 0;
  vstDVM.ParentFont := False;
  vstDVM.RootNodeCount := 7;
  vstDVM.TabOrder := 1;
  vstDVM.TreeOptions.PaintOptions := [toShowButtons, toShowDropmark, toShowRoot, toThemeAware, toUseBlendedImages];
  vstDVM.TreeOptions.SelectionOptions := [toFullRowSelect];
  vstDVM.OnGetText := vstDVMGetText;

  NewColum := vstDVM.Header.Columns.Add;
  NewColum.MinWidth := 120;
  NewColum.Position := 0;
  NewColum.Width := 120;
  NewColum.Text := 'Pin';

  NewColum := vstDVM.Header.Columns.Add;
  NewColum.MinWidth := 150;
  NewColum.Position := 1;
  NewColum.Width := 150;
  NewColum.Text := 'Voltage [V]';

  NewColum := vstDVM.Header.Columns.Add;
  NewColum.MinWidth := 35;
  NewColum.Position := 2;
  NewColum.Width := 35;
  NewColum.Text := '';

  NewColum := vstDVM.Header.Columns.Add;
  NewColum.MinWidth := 150;
  NewColum.Position := 3;
  NewColum.Width := 150;
  NewColum.Text := 'Voltage [V]';

  NewColum := vstDVM.Header.Columns.Add;
  NewColum.MinWidth := 125;
  NewColum.Position := 4;
  NewColum.Width := 125;
  NewColum.Text := 'Pin';
end;


procedure TfrmACUIMain.FormCreate(Sender: TObject);
begin
  FConnHandle := 0;
  FCOMName := '';
  FReadingScopeFromTimerEnabled := True;
  FSampleCountInBinMode := C_LS_MaxSampleCountOnBIN;
  FResponseFormat := C_ResponseFormat_JSON;

  CreateRemainingUIComponents;

  tmrStartup.Enabled := True;
end;


procedure TfrmACUIMain.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  try
    for i := 0 to 14 - 1 do
      Dispose(AllSignals[i]);

    SetLength(AllSignals, 0);
  except
    on E: Exception do
      MessageBox(Handle, PChar('Signals cleanup exception: ' + E.Message), PChar(Application.Title), MB_ICONERROR);
  end;
end;


function TfrmACUIMain.SendCmdReceiveResponse(ACmd: AnsiString; Timeout: Integer = 10; MinByteCountToStopWaiting: Cardinal = 20): AnsiString;
var
  tk: Int64;
  RecCnt, OldRecCnt: Integer;
begin
  RecCnt := -1;

  SendDataToCOM(FConnHandle, ACmd[1], Length(ACmd));
  if Timeout = 10 then
    Sleep(10)
  else
  begin
    {$IFDEF FPC}
      tk := GetTickCount64;
    {$ELSE}
      tk := GetTickCount;
    {$ENDIF}

    repeat
      OldRecCnt := RecCnt;

      RecCnt := GetReceivedByteCount(FConnHandle);
      if (RecCnt <> -1) and (RecCnt > Integer(MinByteCountToStopWaiting)) then
        Break;

      if (RecCnt = OldRecCnt) and (RecCnt > 2) then
        Break;

      Sleep(1);
      Application.ProcessMessages;
    until {$IFDEF FPC}GetTickCount64{$ELSE}GetTickCount{$ENDIF} - tk >= Timeout;
  end;

  SetLength(Result, RecCnt);
  ReceiveDataFromCOM(FConnHandle, Result[1], RecCnt);
end;



function TfrmACUIMain.SetLED(LEDColor: AnsiString; LEDIndex: Byte): Boolean;
var
  s: AnsiString;
begin
  if not COMIsConnected(FConnHandle) then
  begin
    MessageBox(Handle, 'Please open the COM port first.', PChar(Caption), MB_ICONERROR);
    Result := False;
    Exit;
  end;

  s := 'LED ' + LEDColor + '=' + IntToStr(LEDIndex) + ';';
  AddToLog(SendCmdReceiveResponse(s));
  Result := True;
end;


procedure TfrmACUIMain.GetProduct;
var
  s: AnsiString;
begin
  if not COMIsConnected(FConnHandle) then
  begin
    MessageBox(Handle, 'Please open the COM port first.', PChar(Caption), MB_ICONERROR);
    Exit;
  end;

  s := 'GET PRODUCT;';
  AddToLog(SendCmdReceiveResponse(s));

  //s := 'LED;';
  //AddToLog(SendCmdReceiveResponse('LED;'));
end;


function StringToHex(AString: AnsiString): AnsiString;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to Length(AString) do
    Result := Result + IntToHex(Ord(AString[i]), 2) + ' ';
end;


function TfrmACUIMain.LogicScope(Freq: AnsiString; SampleCount: Integer): AnsiString;
var
  s, Response: AnsiString;
begin
  Result := '';
  if not COMIsConnected(FConnHandle) then
  begin
    chkReadLogicScopeInLoop.Checked := False;
    tmrReadScope.Enabled := False;
    MessageBox(Handle, 'Please open the COM port first.', PChar(Caption), MB_ICONERROR);
    Exit;
  end;

  s := 'LS FREQ=' + Freq + ' NUMSMP=' + IntToStr(SampleCount) + ';';
  Response := SendCmdReceiveResponse(s, 5000, 1200);   //1200 ~= 542 * 2 + 15 + header           5s is the experimental timeout required to get 255 samples at 61Hz

  if FResponseFormat = C_ResponseFormat_JSON then
    AddToLog(Response)
  else
  begin
    AddToLog(StringToHex(Response));
    Result := Response;
  end;

  memLog.Lines.Add('');
end;


function TfrmACUIMain.DVM(Freq: AnsiString; SampleCount: Integer): AnsiString;
var
  s, Response: AnsiString;
begin
  Result := '';
  if not COMIsConnected(FConnHandle) then
  begin
    MessageBox(Handle, 'Please open the COM port first.', PChar(Caption), MB_ICONERROR);
    Exit;
  end;

  s := 'DVM;';
  Response := SendCmdReceiveResponse(s, 2000, 1200);   //1200 ~= 542 * 2 + 15 + header           5s is the experimental timeout required to get 255 samples at 61Hz

  if FResponseFormat = C_ResponseFormat_JSON then
    AddToLog(Response)
  else
  begin
    AddToLog(StringToHex(Response));
    Result := Response;
  end;

  memLog.Lines.Add('');
end;


procedure TfrmACUIMain.SetResponseFormat(AFormat: string);
var
  s: AnsiString;
begin
  if not COMIsConnected(FConnHandle) then
  begin
    MessageBox(Handle, 'Please open the COM port first.', PChar(Caption), MB_ICONERROR);
    Exit;
  end;

  s := 'SET OUTPUT ' + AFormat + ';';
  AddToLog(SendCmdReceiveResponse(s, 1000, 100));

  if AFormat = 'BIN' then
    FResponseFormat := C_ResponseFormat_BIN;

  if AFormat = 'JSON' then
    FResponseFormat := C_ResponseFormat_JSON;

  if AFormat = 'XTERM' then
    FResponseFormat := C_ResponseFormat_XTERM;

  if AFormat = 'ANSI' then
    FResponseFormat := C_ResponseFormat_ANSI;
end;


procedure TfrmACUIMain.spdbtnCommandMenuClick(Sender: TObject);
var
  tp: TPoint;
begin
  GetCursorPos(tp);
  pmCommandsMenu.Popup(tp.X, tp.Y);
end;


procedure TfrmACUIMain.spdbtnFreqMenuClick(Sender: TObject);
var
  tp: TPoint;
begin
  GetCursorPos(tp);
  pmFreqMenu.Popup(tp.X, tp.Y);
end;


procedure TfrmACUIMain.SendManualCommand(ACommand: AnsiString);
var
  Response: AnsiString;
begin
  if not COMIsConnected(FConnHandle) then
  begin
    MessageBox(Handle, 'Please open the COM port first.', PChar(Caption), MB_ICONERROR);
    Exit;
  end;

  Response := SendCmdReceiveResponse(ACommand, 700, 5000);

  AddToLog(Response);
  if FResponseFormat = 1 then
    AddToLog(StringToHex(Response));
  memLog.Lines.Add('');

  if ACommand = 'SET OUTPUT BIN;' then
    FResponseFormat := C_ResponseFormat_BIN;

  if ACommand = 'SET OUTPUT JSON;' then
    FResponseFormat := C_ResponseFormat_JSON;

  if ACommand = 'SET OUTPUT XTERM;' then
    FResponseFormat := C_ResponseFormat_XTERM;

  if ACommand = 'SET OUTPUT ANSI;' then
    FResponseFormat := C_ResponseFormat_ANSI;
end;


procedure TfrmACUIMain.rdgrpResponseFormatClick(Sender: TObject);
begin
  UpdateResponseFormat;
end;


procedure TfrmACUIMain.ResetZoom1Click(Sender: TObject);
begin
  ResetZoom;
end;


procedure TfrmACUIMain.AddCommandToCommandsMenu(ACommand: string; ParentMenuItem: TMenuItem);
var
  AMenuItem: TMenuItem;
begin
  AMenuItem := TMenuItem.Create(ParentMenuItem);
  AMenuItem.Caption := ACommand;
  AMenuItem.OnClick := GenericCommandItem1Click;

  ParentMenuItem.Add(AMenuItem);
end;


procedure TfrmACUIMain.AddFreqToFreqMenu(AFreq: string; ParentMenuItem: TMenuItem);
var
  AMenuItem: TMenuItem;
begin
  AMenuItem := TMenuItem.Create(ParentMenuItem);
  AMenuItem.Caption := AFreq;
  AMenuItem.OnClick := GenericFreqItem1Click;

  ParentMenuItem.Add(AMenuItem);
end;


procedure TfrmACUIMain.PopulateCommandsMenu;
var
  i: Integer;
begin
  pmCommandsMenu.Items.Clear;

  AddCommandToCommandsMenu('COMMANDS;', pmCommandsMenu.Items);
  AddCommandToCommandsMenu('GOTOBOOTLOADER;', pmCommandsMenu.Items);
  AddCommandToCommandsMenu('LED;', pmCommandsMenu.Items);
  AddCommandToCommandsMenu('LS NUMSMP=10 FREQ=10K;', pmCommandsMenu.Items);
  AddCommandToCommandsMenu('LS NUMSMP=255 FREQ=10K;', pmCommandsMenu.Items);
  AddCommandToCommandsMenu('DVM;', pmCommandsMenu.Items);
  AddCommandToCommandsMenu('SCOPE PIN=1 NUMSMP=10 FREQ=10K;', pmCommandsMenu.Items);
  AddCommandToCommandsMenu('-', pmCommandsMenu.Items);

  for i := 0 to lstCommandGet.Count - 1 do
    AddCommandToCommandsMenu(lstCommandGet.Items.Strings[i], pmCommandsMenu.Items);

  AddCommandToCommandsMenu('-', pmCommandsMenu.Items);

  for i := 0 to lstCommandSet.Count - 1 do
    AddCommandToCommandsMenu(lstCommandSet.Items.Strings[i], pmCommandsMenu.Items);
end;


procedure TfrmACUIMain.PopulateFreqMenu;
begin
  pmFreqMenu.Items.Clear;
  AddFreqToFreqMenu('100 Hz  (61.035156 Hz)', pmFreqMenu.Items);
  AddFreqToFreqMenu('200 Hz  (183.105468 Hz)', pmFreqMenu.Items);
  AddFreqToFreqMenu('500 Hz  (488.281248 Hz)', pmFreqMenu.Items);

  AddFreqToFreqMenu('-', pmFreqMenu.Items);
  AddFreqToFreqMenu('1K Hz  (976.562496 Hz)', pmFreqMenu.Items);
  AddFreqToFreqMenu('2K Hz  (1.953125 kHz)', pmFreqMenu.Items);
  AddFreqToFreqMenu('5K Hz  (4.943875008 kHz)', pmFreqMenu.Items);

  AddFreqToFreqMenu('-', pmFreqMenu.Items);
  AddFreqToFreqMenu('10K Hz  (9.94875 kHz)', pmFreqMenu.Items);
  AddFreqToFreqMenu('20K Hz  (19.9585 kHz)', pmFreqMenu.Items);
  AddFreqToFreqMenu('50K Hz  (49988 kHz)', pmFreqMenu.Items);

  AddFreqToFreqMenu('-', pmFreqMenu.Items);
  AddFreqToFreqMenu('100K Hz  (99.976 kHz)', pmFreqMenu.Items);
  AddFreqToFreqMenu('200K Hz  (199.952 kHz)', pmFreqMenu.Items);
  AddFreqToFreqMenu('500K Hz  (500 kHz)', pmFreqMenu.Items);

  AddFreqToFreqMenu('-', pmFreqMenu.Items);
  AddFreqToFreqMenu('1M Hz', pmFreqMenu.Items);
  AddFreqToFreqMenu('2M Hz', pmFreqMenu.Items);
  AddFreqToFreqMenu('4M Hz', pmFreqMenu.Items);
end;


procedure TfrmACUIMain.tmrReadDVMTimer(Sender: TObject);
begin
  if not COMIsConnected(FConnHandle) then
    chkReadDVMInLoop.Checked := False;
    
  btnReadDVM.Click;
end;


procedure TfrmACUIMain.tmrReadScopeTimer(Sender: TObject);
begin
  if FReadingScopeFromTimerEnabled then
  begin
    FReadingScopeFromTimerEnabled := False;  //prevent reentring here if ReadLogicScope takes longer than timer intercal, so it is called again
    try
      ReadLogicScope;
    finally
      FReadingScopeFromTimerEnabled := True;
    end;
  end;
end;


procedure TfrmACUIMain.tmrStartupTimer(Sender: TObject);   
begin
  tmrStartup.Enabled := False;

  FrameWaveformsEditor1.StatusBar := statusbar1;
  FrameWaveformsEditor1.InitFrame;
  FrameWaveformsEditor1.EnabledPaintingTransitionsAsInserting := False;

  FrameWaveformsEditor1.chkXes.Hide;

  FrameWaveformsEditor1.vstWaveformsEditor.Header.Columns.Items[0].Width := 200;
  FrameWaveformsEditor1.vstWaveformsEditor.Header.Columns.Items[1].Width := 50;
  FrameWaveformsEditor1.vstWaveformsEditor.Header.Columns.Items[3].Options := FrameWaveformsEditor1.vstWaveformsEditor.Header.Columns.Items[3].Options - [coVisible];

  FrameWaveformsEditor1.vstHeaderWaves.Header.Columns.Items[0].Width := 200;
  FrameWaveformsEditor1.vstHeaderWaves.Header.Columns.Items[1].Width := 50;
  FrameWaveformsEditor1.vstHeaderWaves.Header.Columns.Items[3].Options := FrameWaveformsEditor1.vstWaveformsEditor.Header.Columns.Items[3].Options - [coVisible];

  FrameWaveformsEditor1.RefreshOnColumnResize;

  AddSignalsToLogicScope;
  PopulateCommandsMenu;
  PopulateFreqMenu;

  UpdateListOfCOMPorts;
  LoadSettingsFromIni;
  
  cmbCOMPort.ItemIndex := cmbCOMPort.Items.IndexOf(FComName);

  AddToLog('Previously used COM port: ' + FCOMName);
end;


procedure TfrmACUIMain.UpdateSampleCountLabel;
begin
  lblLSSampleCount.Caption := 'Sample count: ' + IntToStr(trbSampleCount.Position);
end;


procedure TfrmACUIMain.vstDVMGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: {$IFDEF FPC}string{$ELSE}WideString{$ENDIF});
begin
  try
    case Column of
      0: CellText := cmbYellowLED.Items.Strings[Node^.Index + 1];
      1: CellText := FloatToStrF(FDVMValues[Node^.Index], ffFixed, 15, 7);
      2: CellText := '';
      3: CellText := FloatToStrF(FDVMValues[13 - Node^.Index], ffFixed, 15, 7);
      4: CellText := cmbYellowLED.Items.Strings[14 - Node^.Index];
    end;
  except
    CellText := '';
  end;
end;


procedure TfrmACUIMain.UpdateResponseFormat;
begin
  case FResponseFormat of
    C_ResponseFormat_JSON:
    begin
      trbSampleCount.Max := C_LS_MaxSampleCountOnJSON;
      lblResponseFormat.Caption := 'Response Format: JSON';
    end;

    C_ResponseFormat_BIN:
    begin
      trbSampleCount.Max := C_LS_MaxSampleCountOnBIN;

      if chkLimitMaxTo255.Checked then
        trbSampleCount.Max := C_LS_MaxSampleCountOnBIN;

      lblResponseFormat.Caption := 'Response Format: BIN';

      if trbSampleCount.Position = 100 then
        if FSampleCountInBinMode > 100 then
          trbSampleCount.Position := FSampleCountInBinMode;
    end;

    C_ResponseFormat_XTERM:
    begin
      lblResponseFormat.Caption := 'Response Format: XTERM';
    end;

    C_ResponseFormat_ANSI:
    begin
      lblResponseFormat.Caption := 'Response Format: ANSI';
    end;

    else
    begin
      trbSampleCount.Max := 1000; //some unknown big value

      if chkLimitMaxTo255.Checked then
        trbSampleCount.Max := 255;
    end;
  end;
end;


procedure TfrmACUIMain.trbSampleCountChange(Sender: TObject);
begin
  UpdateSampleCountLabel;

  if FResponseFormat = C_ResponseFormat_BIN then
    FSampleCountInBinMode := trbSampleCount.Position;
end;


procedure TfrmACUIMain.SetLEDLabelsToUnassigned;
begin
  lblYellowLEDInfo.Caption := 'Unassigned';
  lblOrangeLEDInfo.Caption := 'Unassigned';
  lblGreenLEDInfo.Caption := 'Unassigned';
  lblRedLEDInfo.Caption := 'Unassigned';
end;


procedure SetSignalForLogicScope(ASignalName: string; ASignal: PSignal);
begin
  ASignal.SignalName := ASignalName;
  ASignal.SignalValueSource := 2; //ignored
  ASignal.SignalDirection := 1; //ignored
  ASignal.OwnerCircuit := ''; //ignored
  ASignal.ValueType := sutNumeric; //binary
       
  ASignal.Size := 1; //binary
  ASignal.AddedBy := sabUser; //ignored
  ASignal.Editing := False;
  ASignal.SynchronizedBySignal := ''; //ignored
  ASignal.SynchronizedByCircuit := ''; //ignored
  ASignal.DrawType := dtNumeric;
end;


procedure TfrmACUIMain.AddSignalsToLogicScope;
var
  i: Integer;
begin
  SetLength(AllSignals, 14);

  for i := 0 to 14 - 1 do
  begin
    New(AllSignals[i]);
    SetSignalForLogicScope(cmbYellowLED.Items.Strings[i + 1], AllSignals[i]);
    //FrameWaveformsEditor1.AddSignalToWaveformEditorVSTWithCopy(AllSignals[i]);
    FrameWaveformsEditor1.AddSignalToWaveformEditorVST(AllSignals[i]);
  end;

  FrameWaveformsEditor1.SetWaveformEditorScrollMax;
  FrameWaveformsEditor1.PaintAllWaveforms;
end;


function TfrmACUIMain.GetLScopeSampleDuration: Extended;  //decodes LS frequency and converts it to sample period
var
  Freq: Extended;
  PosK, PosM: Integer;
  FreqStr: string;
begin
  FreqStr := lbeLSFreq.Text;

  PosK := Pos('K', FreqStr);
  PosM := Pos('M', FreqStr);

  if PosK > 0 then
  begin
    FreqStr := Copy(FreqStr, 1, PosK - 1);
    Freq := StrToFloatDef(FreqStr, 1) * 1000;   //Hz
  end
  else
    if PosM > 0 then
    begin
      FreqStr := Copy(FreqStr, 1, PosM - 1);
      Freq := StrToFloatDef(FreqStr, 1) * 1000000;  //Hz
    end
    else
      Freq := StrToFloatDef(FreqStr, 1);

  if Freq <= 0 then
    Freq := 1;   

  Result := 1000000000 / Freq;    //1 means 1ns
end;


procedure TfrmACUIMain.UpdateLogicScopeWithSignalValues(LSSignalValues: AnsiString);
var
  i, j: Integer;
  ASignal: PSignal;
  PosLS, Pos0E, PinValuesCount: Integer;
  DataLen: Word;
  PinMask, PinValues: AnsiString;
  Samples: array of Word;
  AllPinMasks: array[0..13] of Word;
  SampleValue, OldSampleValue: Integer;
  BinSamples: array[0..13] of array of Byte;  //on byte for binary storage
  //s: string;
begin
  PosLS := Pos('LS', LSSignalValues);

  if PosLS = 0 then
    Exit;

  LSSignalValues := Copy(LSSignalValues, Pos('LS', LSSignalValues) + 2, MaxInt);
  Pos0E := Pos(Chr($0E), LSSignalValues);
  if Pos0E = 2 then
    DataLen := Ord(LSSignalValues[1])
  else
    if Pos0E = 3 then
      DataLen := Ord(LSSignalValues[2]) shl 8 + Ord(LSSignalValues[1])
    else
    begin
      AddToLog('Unsupported data format. 0x0E is expected either one or two bytes after "LS" keyword in header.');
      Exit;
    end;

  PinMask := Copy(LSSignalValues, Pos0E + 1, 14);
  //AddToLog('PinMask (before) = ' + StringToHex(PinMask));
  //PinMask[13] := Chr(12);  //manual correction
  //PinMask[14] := Chr(3);   //manual correction
  //AddToLog('PinMask (after) = ' + StringToHex(PinMask));

  PinValues := Copy(LSSignalValues, Pos0E + 1 + 14, MaxInt);
  //AddToLog('Len1(PinValues) = ' + IntToStr(Length(PinValues)));
  PinValuesCount := DataLen - 14 - 1;
  SetLength(PinValues, PinValuesCount);
  //AddToLog('Len2(PinValues) = ' + IntToStr(Length(PinValues)));

  for i := 0 to 14 - 1 do
    AllPinMasks[i] := TwoPowered(Ord(PinMask[i + 1]));

  SetLength(Samples, Length(PinValues) shr 1);
  for j := 0 to Length(Samples) - 1 do
    Samples[j] := Ord(PinValues[j shl 1 + 1 + 1]) shl 8 + Ord(PinValues[j shl 1 + 1]);

  for i := 0 to 14 - 1 do
  begin
    SetLength(BinSamples[i], Length(Samples));

    for j := 0 to Length(Samples) - 1 do
      BinSamples[i][j] := Ord((Samples[j] and AllPinMasks[i]) > 0);
  end;

  //clear first
  for i := 0 to 14 - 1 do
  begin
    ASignal := AllSignals[i];
    for j := 0 to Length(ASignal.SignalEvents) - 1 do
      SetLength(ASignal.SignalEvents[j].ValueAfterEvent.NumericValue, 0);

    SetLength(ASignal.SignalEvents, 0);  
  end;

  for i := 0 to 14 - 1 do
  begin
    ASignal := AllSignals[i];
    //s := '';

    SampleValue := -1;
    for j := 0 to Length(Samples) - 1 do
    begin
      OldSampleValue := SampleValue;
      SampleValue := BinSamples[i][j];

      if SampleValue <> OldSampleValue then  //transition
      begin
        //s := s + IntToStr(SampleValue);
        SetLength(ASignal.SignalEvents, Length(ASignal.SignalEvents) + 1);
        ASignal.SignalEvents[Length(ASignal.SignalEvents) - 1].Moment := j; //based on sample time
        ASignal.SignalEvents[Length(ASignal.SignalEvents) - 1].EditingEvent := False;
        SetLength(ASignal.SignalEvents[Length(ASignal.SignalEvents) - 1].ValueAfterEvent.NumericValue, 1);   //allocate 1 byte to use 1 bit

        ASignal.SignalEvents[Length(ASignal.SignalEvents) - 1].ValueAfterEvent.NumericValue[0] := SampleValue;

        ASignal.SignalEvents[Length(ASignal.SignalEvents) - 1].CauseOfEvent := Ord(j > 0);
        ASignal.SignalEvents[Length(ASignal.SignalEvents) - 1].EventType := 0; //real transition
      end;
    end; //for j

    //memLog.Lines.Add('ch ' + IntToStr(i + 1) + '  ' + s);
  end; //for i

  FrameWaveformsEditor1.SampleDuration := GetLScopeSampleDuration;
  FrameWaveformsEditor1.PaintAllWaveforms;
  FrameWaveformsEditor1.vstWaveformsEditor.Repaint;
end;


procedure TfrmACUIMain.UpdateDVMWithValues(DVMValues: AnsiString);
const
  COutOfRange: array[Boolean] of string = ('', '  > 4095');
var
  PosDVM, Pos0E: Integer;
  PayloadLen: Integer;
  VrefVoltageInt: DWord;
  VrefVoltage: Single;
  SamplesStr: AnsiString;
  i: Integer;
  SampleInt: Word;
  ADCBits: Byte;
  ADMax: DWord;
  SampleFloat: Double;
begin
  PosDVM := Pos('DV', DVMValues);

  if PosDVM = 0 then
    Exit;

  DVMValues := Copy(DVMValues, PosDVM + 2, MaxInt);
  PayloadLen := Ord(DVMValues[2]) shl 8 + Ord(DVMValues[1]);
  VrefVoltageInt := Ord(DVMValues[5]) shl 24 + Ord(DVMValues[4]) shl 16 + Ord(DVMValues[3]) shl 8;
  Move(VrefVoltageInt, VrefVoltage, 4);

  ADCBits := Ord(DVMValues[6]);
  ADMax := TwoPowered(ADCBits);

  AddToLog('VrefVoltage: ' + FloatToStrF(VrefVoltage, ffFixed, 15, 7) + 'V');
  AddToLog('ADMax: ' + IntToStr(ADMax) + '   ADCBits: ' + IntToStr(ADCBits));

  Pos0E := Pos(Chr($0E), DVMValues);
  SamplesStr := Copy(DVMValues, Pos0E + 1, MaxInt);

  if Length(SamplesStr) <> PayloadLen - 5 then
    AddToLog('Length of samples array does not match length from header: ' + IntToStr(Length(SamplesStr)) + ' vs. ' + IntToStr(PayloadLen - 5));

  //AddToLog('Raw samples: ' + StringToHex(SamplesStr));

  for i := 0 to 13 do
  begin
    SampleInt := Ord(SamplesStr[i shl 1 + 1 + 1]) shl 8 + Ord(SamplesStr[i shl 1 + 1]);
    SampleFloat := (VrefVoltage / (ADMax - 1)) * SampleInt;
    FDVMValues[i] := SampleFloat;
    memLog.Lines.Add('Ch ' + IntToStr(i + 1) + ': ' + FloatToStrF(SampleFloat, ffFixed, 15, 7) + 'V    Num:' + IntToStr(SampleInt) + COutOfRange[SampleInt > 4095]{ + '   [' + IntToStr(i shl 1 + 1 + 1) + '][' + IntToStr(i shl 1 + 1) + ']'});
  end;

  vstDVM.Repaint;
end;

end.
