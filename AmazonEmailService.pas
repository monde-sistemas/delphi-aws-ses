unit AmazonEmailService;

interface

uses
  Classes,
  IPPeerAPI,
  Data.Cloud.CloudAPI,
  IPPeerClient;

type
  TEmailBody = (eHTML, eText);

  TAmazonEmailService = class
  private
    FEndpoint: string;
    FAWSAccessKey: string;
    FAWSSecretKey: string;
    FEmailBody: TEmailBody;
    procedure IssueRequest(const QueryParameters: TStringStream; out Response: TCloudResponseInfo);
    procedure PopulateResponseInfo(const ResponseInfo: TCloudResponseInfo; const Peer: IIPHTTP); overload;
    procedure PopulateResponseInfo(const ResponseInfo: TCloudResponseInfo; const E: EIPHTTPProtocolExceptionPeer); overload;
    function BuildQueryParameters(const Recipients: TStrings; const From, Subject, MessageBody: string): TStringStream;
    procedure PrepareRequest(const Peer: IIPHTTP);
  public
    constructor Create(const Endpoint, AWSAccessKey, AWSSecretKey: string);
    function SendMail(const Recipients: TStrings; const FromAddress, Subject, MessageBody: string;
      out Response: TCloudResponseInfo; const EmailBody: TEmailBody = eHTML): Boolean; overload;
    function SendMail(const Recipients: TStrings; const FromAddress, Subject, MessageBody: string; const EmailBody: TEmailBody = eHTML): Boolean; overload;
    property EmailBody: TEmailBody read FEmailBody write FEmailBody;
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

constructor TAmazonEmailService.Create(const Endpoint, AWSAccessKey, AWSSecretKey: string);
begin
  FEndpoint := TAmazonEmailServiceRegions.FormatServiceURL(Endpoint);
  FAWSAccessKey := AWSAccessKey;
  FAWSSecretKey := AWSSecretKey;
end;

procedure TAmazonEmailService.IssueRequest(const QueryParameters: TStringStream; out Response: TCloudResponseInfo);
var
  Peer: IIPHTTP;
begin
  Peer := PeerFactory.CreatePeer('', IIPHTTP, nil) as IIPHTTP;
  try
    Peer.IOHandler := PeerFactory.CreatePeer('', IIPSSLIOHandlerSocketOpenSSL, nil) as IIPSSLIOHandlerSocketOpenSSL;

    PrepareRequest(Peer);

    try
      Peer.DoPost(FEndpoint, QueryParameters);
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

procedure TAmazonEmailService.PopulateResponseInfo(const ResponseInfo: TCloudResponseInfo; const Peer: IIPHTTP);
var
  PopulateResponseInfo: TPopulateResponseInfo;
begin
  PopulateResponseInfo := TPopulateResponseInfo.Create;
  try
    PopulateResponseInfo.FromPeer(ResponseInfo, Peer);
  finally
    PopulateResponseInfo.Free;
  end;
end;

procedure TAmazonEmailService.PopulateResponseInfo(const ResponseInfo: TCloudResponseInfo; const E: EIPHTTPProtocolExceptionPeer);
var
  PopulateResponseInfo: TPopulateResponseInfo;
begin
  PopulateResponseInfo := TPopulateResponseInfo.Create;
  try
    PopulateResponseInfo.FromExceptionPeer(ResponseInfo, E);
  finally
    PopulateResponseInfo.Free;
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
  const FromAddress, Subject, MessageBody: string; const EmailBody: TEmailBody): Boolean;
var
  Response: TCloudResponseInfo;
begin
  try
    Result := SendMail(Recipients, FromAddress, Subject, MessageBody, Response, EmailBody);
  finally
    if Assigned(Response) then
      Response.Free;
  end;
end;

function TAmazonEmailService.BuildQueryParameters(const Recipients: TStrings;
  const From, Subject, MessageBody: string): TStringStream;
var
  BuildQueryParameters: TBuildQueryParameters;
begin
  BuildQueryParameters := TBuildQueryParameters.Create(FEmailBody);
  try
    Result := BuildQueryParameters.GetQueryParams(Recipients, From, Subject, MessageBody);
  finally
    BuildQueryParameters.Free;
  end;
end;

function TAmazonEmailService.SendMail(const Recipients: TStrings; const FromAddress, Subject,
  MessageBody: string; out Response: TCloudResponseInfo; const EmailBody: TEmailBody): Boolean;
var
  QueryParameters: TStringStream;
begin
  FEmailBody := EmailBody;

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
