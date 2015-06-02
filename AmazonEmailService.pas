unit AmazonEmailService;

interface

uses
  Classes,
  IPPeerAPI,
  PrepareRequestSignature,
  Data.Cloud.CloudAPI,
  IPPeerClient;

type
  AwsRegions = (USEast, USWest, EUIreland);

  TAmazonEmailService = class
  private
    FAWSRegion: AwsRegions;
    FAWSAccessKey: string;
    FAWSSecretKey: string;
    FIsHtmlEmail: Boolean;
    procedure IssueRequest(const QueryParameters: TStringStream; out Response: TCloudResponseInfo);
    procedure PopulateResponseInfo(const ResponseInfo: TCloudResponseInfo; const Peer: IIPHTTP); overload;
    procedure PopulateResponseInfo(const ResponseInfo: TCloudResponseInfo; const E: EIPHTTPProtocolExceptionPeer); overload;
    function BuildQueryParameters(const Recipients: TStrings; const From, Subject, MessageBody: string): TStringStream;
    procedure PrepareRequest(const Peer: IIPHTTP);
    function GetCurrentTime: string;
    function GetSignature(const StringToSign: string): string;
  public
    constructor Create(const AWSRegion: AwsRegions; const AWSAccessKey, AWSSecretKey: string);
    function SendMail(const Recipients: TStrings; const FromAddress, Subject, MessageBody: string;
      out Response: TCloudResponseInfo; const IsHtmlEmail: Boolean = False): Boolean; overload;
    function SendMail(const Recipients: TStrings; const FromAddress, Subject, MessageBody: string; const IsHtmlEmail: Boolean = False): Boolean; overload;
    property IsHtmlEmail: Boolean read FIsHtmlEmail write FIsHtmlEmail;
  end;

implementation

uses
  ActiveX,
  DateUtils,
  SysUtils,
  EncodeQueryParams,
  PopulateResponseInfo,
  AmazonEmailServiceRegions;

{ TAmazonEmailService }

constructor TAmazonEmailService.Create(const AWSRegion: AwsRegions; const AWSAccessKey, AWSSecretKey: string);
begin
  FAWSRegion := AWSRegion;
  FAWSAccessKey := AWSAccessKey;
  FAWSSecretKey := AWSSecretKey;
end;

function TAmazonEmailService.GetCurrentTime: string;
const
  FORMAT_HTTP_DATE = 'ddd, dd mmm yyyy hh:nn:ss "GMT"';
begin
  Result := FormatDateTime(FORMAT_HTTP_DATE, TTimeZone.Local.ToUniversalTime(Now), TFormatSettings.Create('en-US'));
end;

procedure TAmazonEmailService.IssueRequest(const QueryParameters: TStringStream; out Response: TCloudResponseInfo);
var
  Peer: IIPHTTP;
  ServiceUrl: string;
begin
  Peer := PeerFactory.CreatePeer('', IIPHTTP, nil) as IIPHTTP;
  try
    Peer.IOHandler := PeerFactory.CreatePeer('', IIPSSLIOHandlerSocketOpenSSL, nil) as IIPSSLIOHandlerSocketOpenSSL;

    PrepareRequest(Peer);

    try
      ServiceUrl := TAmazonEmailServiceRegions.GetServiceURL(FAWSRegion);
      Peer.DoPost(ServiceUrl, QueryParameters);
      PopulateResponseInfo(Response, Peer);
    except
      on E: EIPHTTPProtocolExceptionPeer do
      begin
	      PopulateResponseInfo(Response, E);
        raise;
      end;
      on E: Exception do
      begin
	      PopulateResponseInfo(Response, Peer);
        raise;
      end;
    end;
  finally
    if Assigned(Peer) then
    begin
      Peer.FreeIOHandler;
      Peer := nil;
    end;
  end;
end;

procedure TAmazonEmailService.PopulateResponseInfo(const ResponseInfo: TCloudResponseInfo;
  const Peer: IIPHTTP);
begin
  with TPopulateResponseInfo.Create do
    try
      FromPeer(ResponseInfo, Peer);
    finally
      Free;
    end;
end;

procedure TAmazonEmailService.PopulateResponseInfo(const ResponseInfo: TCloudResponseInfo;
  const E: EIPHTTPProtocolExceptionPeer);
begin
  with TPopulateResponseInfo.Create do
    try
      FromExceptionPeer(ResponseInfo, E);
    finally
      Free;
    end;
end;

procedure TAmazonEmailService.PrepareRequest(const Peer: IIPHTTP);
var
  CurrentTime: string;
  AuthorizationHeader: string;
begin
  Peer.GetRequest.ContentType := 'application/x-www-form-urlencoded';
  Peer.GetRequest.ContentLength := 230;

  CurrentTime := GetCurrentTime;
  Peer.GetRequest.CustomHeaders.AddValue('Date', CurrentTime);

  AuthorizationHeader := Format('AWS3-HTTPS AWSAccessKeyId=%s, Algorithm=HmacSHA256, Signature=%s',
    [FAWSAccessKey, GetSignature(CurrentTime)]);
  Peer.GetRequest.CustomHeaders.AddValue('X-Amzn-Authorization', AuthorizationHeader);
end;

function TAmazonEmailService.SendMail(const Recipients: TStrings;
  const FromAddress, Subject, MessageBody: string; const IsHtmlEmail: Boolean): Boolean;
var
  Response: TCloudResponseInfo;
begin
  Result := SendMail(Recipients, FromAddress, Subject, MessageBody, Response, IsHtmlEmail);
end;

function TAmazonEmailService.GetSignature(const StringToSign: string): string;
var
  PrepareRequestSignature: TPrepareRequestSignature;
begin
  PrepareRequestSignature := TPrepareRequestSignature.Create(FAWSAccessKey, FAWSSecretKey);
  try
    Result := PrepareRequestSignature.GetSignature(StringToSign);
  finally
    PrepareRequestSignature.Free;
  end;
end;

function TAmazonEmailService.BuildQueryParameters(const Recipients: TStrings;
  const From, Subject, MessageBody: string): TStringStream;
const
  ACTION = 'SendEmail';
var
  I: Integer;
  BodyType: string;
begin
  Result := TStringStream.Create(EmptyStr, TEncoding.UTF8);
  Result.WriteString('Action=' + ACTION);
  Result.WriteString(Format('&Source=%s', [TEncodeQueryParams.Encode(From)]));
  for I := 0 to Recipients.Count -1 do
    Result.WriteString(Format('&Destination.ToAddresses.member.%d=%s',
      [I+1, TEncodeQueryParams.Encode(Recipients[I])]));

  Result.WriteString('&Message.Subject.Charset=UTF-8');
  Result.WriteString(Format('&Message.Subject.Data=%s', [TEncodeQueryParams.Encode(Subject)]));

  if FIsHtmlEmail then
    BodyType := 'Html'
  else
    BodyType := 'Text';
  Result.WriteString(Format('&Message.Body.%s.Charset=UTF-8', [BodyType]));
  Result.WriteString(Format('&&Message.Body.%s.Data=%s', [BodyType, TEncodeQueryParams.Encode(MessageBody)]));
end;

function TAmazonEmailService.SendMail(const Recipients: TStrings; const FromAddress, Subject,
  MessageBody: string; out Response: TCloudResponseInfo; const IsHtmlEmail: Boolean): Boolean;
var
  QueryParameters: TStringStream;
begin
  FIsHtmlEmail := IsHtmlEmail;

  CoInitialize(nil);
  try
    Response := TCloudResponseInfo.Create;

    QueryParameters := BuildQueryParameters(Recipients, FromAddress, Subject, MessageBody);
    try
      IssueRequest(QueryParameters, Response);
      Result := (Response <> nil) and (Response.StatusCode = 200);
    finally
      if Assigned(QueryParameters) then
        QueryParameters.Free;
    end;
  finally
    CoUninitialize;
  end;
end;

end.
