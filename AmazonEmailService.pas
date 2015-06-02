unit AmazonEmailService;

interface

uses
  Classes,
  IPPeerAPI,
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
  public
    constructor Create(const AWSRegion: AwsRegions; const AWSAccessKey, AWSSecretKey: string);
    function SendMail(const Recipients: TStrings; const FromAddress, Subject, MessageBody: string;
      out Response: TCloudResponseInfo; const IsHtmlEmail: Boolean = True): Boolean; overload;
    function SendMail(const Recipients: TStrings; const FromAddress, Subject, MessageBody: string; const IsHtmlEmail: Boolean = True): Boolean; overload;
    property IsHtmlEmail: Boolean read FIsHtmlEmail write FIsHtmlEmail;
  end;

implementation

uses
  ActiveX,
  DateUtils,
  SysUtils,
  PopulateResponseInfo,
  AmazonEmailServiceRequests,
  AmazonEmailServiceRegions,
  BuildQueryParameters;

constructor TAmazonEmailService.Create(const AWSRegion: AwsRegions; const AWSAccessKey, AWSSecretKey: string);
begin
  FAWSRegion := AWSRegion;
  FAWSAccessKey := AWSAccessKey;
  FAWSSecretKey := AWSSecretKey;
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
  AmazonEmailServiceRequests: TAmazonEmailServiceRequests;
begin
  AmazonEmailServiceRequests := TAmazonEmailServiceRequests.Create(FAWSAccessKey, FAWSSecretKey);
  try
    AmazonEmailServiceRequests.PrepareRequest(Peer);
  finally
    AmazonEmailServiceRequests.Free;
  end;
end;

function TAmazonEmailService.SendMail(const Recipients: TStrings;
  const FromAddress, Subject, MessageBody: string; const IsHtmlEmail: Boolean): Boolean;
var
  Response: TCloudResponseInfo;
begin
  Result := SendMail(Recipients, FromAddress, Subject, MessageBody, Response, IsHtmlEmail);
end;

function TAmazonEmailService.BuildQueryParameters(const Recipients: TStrings;
  const From, Subject, MessageBody: string): TStringStream;
var
  BuildQueryParameters: TBuildQueryParameters;
begin
  BuildQueryParameters := TBuildQueryParameters.Create(FIsHtmlEmail);
  try
    Result := BuildQueryParameters.GetQueryParams(Recipients, From, Subject, MessageBody);
  finally
    BuildQueryParameters.Free;
  end;
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
