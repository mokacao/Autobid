unit USetting;

interface
uses
  classes,SysUtils,Types,IniFiles,Forms,dialogs,windows,math;

type
  TScreanPointSetting = class
  private
    FFileName : string;
    procedure SetPoint(str:string;var p:TPoint);
    function  GetMidPos(beginPoint:TPoint;endPoint:TPoint):TPoint;
  public
    FPriceBeginPoint: TPoint;
    FPriceEndPoint: TPoint;

    FBidBeginPoint : TPoint;
    FBidEndPoint : TPoint;

    FCodeBeginPoint :TPoint;
    FCodeEndPoint :TPoint;

    FSubmitBeginPoint :TPoint;
    FSubmitEndPoint :TPoint;

    FPriceDisplayAreaLeftTop: TPoint;
    FPriceDisplayAreaRightBottom: TPoint;

    FCustomAddPriceLeftTop: TPoint;
    FCustomAddPriceRightBottom: TPoint;

    constructor Create();

    procedure Save2File();
    procedure LoadFromFile();

    procedure SetPriceArea(beginStr,endStr:string);
    procedure SetBidArea(beginStr,endStr:string);
    procedure SetCodeArea(beginStr,endStr:string);
    procedure SetSubmitArea(beginStr,endStr:string);
    procedure SetPriceDisplay(beginStr,endStr:string);
    procedure SetCustomAddPrice(beginStr,endStr:string);


    function GetPricePos: TPoint;
    function GetBidPos: TPoint;
    function GetCodePos: TPoint;
    function GetSubmitPos: TPoint;
    function GetPriceDisplayRect: TRect;
    function GetCustomAddPrice: TPoint;
  end;

  TCommitKeyInputType = (ckitCtrlEnter, ckitEnter);
  TAppSettings = class
  private
    FFileName : string;
    FTestTimeInterval: Integer;
    FCommitKeyInput: TCommitKeyInputType;
    procedure SetTestTimeInterval(const Value: Integer);
    procedure SetCommitKeyInput(const Value: TCommitKeyInputType);
  public
    procedure SaveToFile;
    procedure LoadFromFile;

  public

    property TestTimeInterval: Integer read FTestTimeInterval write SetTestTimeInterval;
    property CommitKeyInput: TCommitKeyInputType read FCommitKeyInput write SetCommitKeyInput;

    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;

  end;

var
  g_ScreanPointSetting: TScreanPointSetting;
  g_AppSettings: TAppSettings;

implementation

uses
  uHelp;

{ TScreanPointSetting }
constructor TScreanPointSetting.Create();
var
  appPath:String;
begin
  appPath := ExtractFileDir(Application.ExeName);
  FFileName := appPath+'\' + 'ScreanPointSettings.ini';
  LoadFromFile();
  //showMessage(FConfigFileName);
end;

function TScreanPointSetting.GetBidPos: TPoint;
begin
  Result := GetMidPos(FBidBeginPoint, FBidEndPoint);
end;

function TScreanPointSetting.GetCodePos: TPoint;
begin
  Result := GetMidPos(FCodeBeginPoint, FCodeEndPoint);
end;

function TScreanPointSetting.GetCustomAddPrice: TPoint;
begin
  Result := GetMidPos(FCustomAddPriceLeftTop, FCustomAddPriceRightBottom);
end;

function TScreanPointSetting.GetMidPos(beginPoint,
  endPoint: TPoint): TPoint;
var
  midPoint :TPoint;
begin
  midPoint.x := floor((beginPoint.x + endPoint.x)/2);
  midPoint.Y := floor((beginPoint.Y + endPoint.y) /2);
  result := midPoint;
end;

function TScreanPointSetting.GetPriceDisplayRect: TRect;
begin
  Result.Left := FPriceDisplayAreaLeftTop.X;
  Result.Top := FPriceDisplayAreaLeftTop.Y;
  Result.Right := FPriceDisplayAreaRightBottom.X;
  Result.Bottom := FPriceDisplayAreaRightBottom.Y;
end;

function TScreanPointSetting.GetPricePos: TPoint;
begin
  Result := GetMidPos(FPriceBeginPoint, FPriceEndPoint);
end;

function TScreanPointSetting.GetSubmitPos: TPoint;
begin
  Result := GetMidPos(FSubmitBeginPoint, FSubmitEndPoint);
end;

procedure TScreanPointSetting.LoadFromFile();
var
  iniFile : TIniFile;
  beginStr,endStr : string;
begin
  iniFile := TInifile.Create(FFileName);
  try
    beginStr := iniFile.ReadString('declare','price_begin','0,0');
    endStr := iniFile.ReadString('declare','price_end','0,0');
    SetPriceArea(beginStr,endStr);

    beginStr := iniFile.ReadString('declare','bidbutton_begin','0,0');
    endStr := iniFile.ReadString('declare','bidbutton_end','0,0');
    SetBidArea(beginStr,endStr);

    beginStr := iniFile.ReadString('declare','code_begin','0,0');
    endStr := iniFile.ReadString('declare','code_end','0,0');
    SetCodeArea(beginStr,endStr);

    beginStr := iniFile.ReadString('declare','submit_begin','0,0');
    endStr := iniFile.ReadString('declare','submit_end','0,0');
    SetSubmitArea(beginStr,endStr);


    beginStr := iniFile.ReadString('declare','pricedisplay_begin','0,0');
    endStr := iniFile.ReadString('declare','pricedisplay_end','0,0');
    SetPriceDisplay(beginStr,endStr);

    beginStr := iniFile.ReadString('declare','CustomAddPrice_begin','0,0');
    endStr := iniFile.ReadString('declare','CustomAddPrice_end','0,0');
    SetCustomAddPrice(beginStr,endStr);

  finally
     iniFile.Free;
  end;
end;


procedure TScreanPointSetting.Save2File();
var
  iniFile : TIniFile;
begin
  iniFile := TIniFile.Create(FFileName);
  try
    iniFile.WriteString('declare','price_begin',inttostr(FPriceBeginPoint.X)+','+inttostr(FPriceBeginPoint.Y));
    iniFile.WriteString('declare','price_end',inttostr(FPriceEndPoint.X)+','+inttostr(FPriceEndPoint.Y));

    iniFile.WriteString('declare','bidbutton_begin',inttostr(FBidBeginPoint.X)+','+inttostr(FBidBeginPoint.Y));
    iniFile.WriteString('declare','bidbutton_end',inttostr(FBidEndPoint.X)+','+inttostr(FBidEndPoint.Y));

    iniFile.WriteString('declare','code_begin',inttostr(FCodeBeginPoint.X)+','+inttostr(FCodeBeginPoint.Y));
    iniFile.WriteString('declare','code_end',inttostr(FCodeEndPoint.X)+','+inttostr(FCodeEndPoint.Y));

    iniFile.WriteString('declare','submit_begin',inttostr(FSubmitBeginPoint.X)+','+inttostr(FSubmitBeginPoint.Y));
    iniFile.WriteString('declare','submit_end',inttostr(FSubmitEndPoint.X)+','+inttostr(FSubmitEndPoint.Y));

    iniFile.WriteString('declare','pricedisplay_begin',inttostr(FPriceDisplayAreaLeftTop.X)+','+inttostr(FPriceDisplayAreaLeftTop.Y));
    iniFile.WriteString('declare','pricedisplay_end',inttostr(FPriceDisplayAreaRightBottom.X)+','+inttostr(FPriceDisplayAreaRightBottom.Y));

    iniFile.WriteString('declare','CustomAddPrice_begin',inttostr(FCustomAddPriceLeftTop.X)+','+inttostr(FCustomAddPriceLeftTop.Y));
    iniFile.WriteString('declare','CustomAddPrice_end',inttostr(FCustomAddPriceRightBottom.X)+','+inttostr(FCustomAddPriceRightBottom.Y));

    ShowMessage('����ɹ�');
  finally
    iniFile.Free;
  end;

end;

procedure TScreanPointSetting.SetBidArea(beginStr, endStr: string);
begin
  SetPoint(beginStr,FBidBeginPoint);
  setPoint(endStr,FBidEndPoint);
end;

procedure TScreanPointSetting.SetCodeArea(beginStr, endStr: string);
begin
  SetPoint(beginStr,FCodeBeginPoint);
  setPoint(endStr,FCodeEndPoint);
end;

procedure TScreanPointSetting.SetCustomAddPrice(beginStr, endStr: string);
begin
  SetPoint(beginStr,FCustomAddPriceLeftTop);
  SetPoint(endStr,FCustomAddPriceRightBottom);
end;

procedure TScreanPointSetting.SetPoint(str: string; var p: TPoint);
var
  x,y,loc:integer;
begin
  loc := pos(',',str);
  x := StrToInt(copy(str,0,loc-1));
  y := StrToInt(copy(str,loc+1,length(str)-loc+1));
  p.X := x;
  p.Y := y;
end;

procedure TScreanPointSetting.SetPriceArea(beginStr, endStr: string);
begin
  SetPoint(beginStr,FPriceBeginPoint);
  SetPoint(endStr,FPriceEndPoint);
end;

procedure TScreanPointSetting.SetPriceDisplay(beginStr, endStr: string);
begin
  SetPoint(beginStr,FPriceDisplayAreaLeftTop);
  setPoint(endStr,FPriceDisplayAreaRightBottom);
end;

procedure TScreanPointSetting.SetSubmitArea(beginStr, endStr: string);
begin
  SetPoint(beginStr,FSubmitBeginPoint);
  setPoint(endStr,FSubmitEndPoint);
end;


{ TAppSettings }

procedure TAppSettings.AfterConstruction;
var
  appPath:String;
begin
  inherited;
  appPath := ExtractFileDir(Application.ExeName);
  FFileName := appPath+'\'+ ChangeFileExt(ExtractFileName(Application.ExeName),'.ini');
  LoadFromFile();
end;

procedure TAppSettings.BeforeDestruction;
begin
  SaveToFile;
  inherited;
end;

procedure TAppSettings.LoadFromFile;
var
  iniFile : TIniFile;
begin
  iniFile := TInifile.Create(FFileName);
  try
    FTestTimeInterval := iniFile.ReadInteger('Settings','TestTimeInterval', 1000);
    FCommitKeyInput := TCommitKeyInputType(iniFile.ReadInteger('Settings','CommitKeyInput', 0));
  finally
     iniFile.Free;
  end;
end;

procedure TAppSettings.SaveToFile;
var
  iniFile : TIniFile;
begin
  iniFile := TIniFile.Create(FFileName);
  try
    iniFile.WriteInteger('Settings','TestTimeInterval', FTestTimeInterval);
    iniFile.WriteInteger('Settings','CommitKeyInput',Ord(FCommitKeyInput));
  finally
    iniFile.Free;
  end;
end;

procedure TAppSettings.SetCommitKeyInput(const Value: TCommitKeyInputType);
begin
  FCommitKeyInput := Value;
end;

procedure TAppSettings.SetTestTimeInterval(const Value: Integer);
begin
  FTestTimeInterval := Value;
end;

initialization
  g_ScreanPointSetting := TScreanPointSetting.Create;
  g_AppSettings := TAppSettings.Create;

finalization
  if Assigned(g_AppSettings) then
    g_AppSettings.Free;
  if Assigned(g_ScreanPointSetting) then
    g_ScreanPointSetting.Free;

end.
