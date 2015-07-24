unit AmazonEmailService;

interface

uses
  IPPeerAPI,
  Data.Cloud.CloudAPI,
  IPPeerClient,
  System.Classes;

type
  TEmailBody = (eHTML, eText);

  TAmazonEmailService = class
  private
    FRegion: string;
    FAWSAccessKey: string;
    FAWSSecretKey: string;
    FEmailBody: TEmailBody;
    procedure IssueRequest(const QueryParameters: TStringStream; out Response: TCloudResponseInfo);
    procedure PopulateResponseInfo(const ResponseInfo: TCloudResponseInfo; const Peer: IIPHTTP); overload;
    procedure PopulateResponseInfo(const ResponseInfo: TCloudResponseInfo; const E: EIPHTTPProtocolExceptionPeer); overload;
    function BuildQueryParameters(const Recipients, ReplyTo: TArray<string>; const FromName, FromAddress, Subject,
        MessageBody: string): TStringStream;
    procedure PrepareRequest(const Peer: IIPHTTP);
  public
    constructor Create(const Region, AWSAccessKey, AWSSecretKey: string); overload;
    constructor Create; overload;

    function SendMail(const Recipients, ReplyTo: TArray<string>; const FromName, FromAddress, Subject, MessageBody: string;
        out Response: TCloudResponseInfo; const EmailBody: TEmailBody): Boolean; overload;
    function SendMail(const Recipients, ReplyTo: TArray<string>; const FromName, FromAddress, Subject, MessageBody: string;
        const EmailBody: TEmailBody): Boolean; overload;
    property EmailBody: TEmailBody read FEmailBody write FEmailBody;
  end;

implementation

uses
  ActiveX,
  DateUtils,
  SysUtils,
  AmazonEmailServiceConfiguration,
  AmazonEmailServiceRegions,
  AmazonEmailServiceRequests,
  BuildQueryParameters,
  PopulateResponseInfo;

constructor TAmazonEmailService.Create(const Region, AWSAccessKey, AWSSecretKey: string);
begin
  FRegion := TAmazonEmailServiceRegions.FormatServiceURL(Region);
  FAWSAccessKey := AWSAccessKey;
  FAWSSecretKey := AWSSecretKey;
end;

constructor TAmazonEmailService.Create;
var
  Configuration: TAmazonEmailServiceConfiguration;
  Region: string;
  AccessKey: string;
  SecretKey: string;
begin
  Configuration := TAmazonEmailServiceConfiguration.Create;
  try
    Configuration.GetFromEnvironment(Region, AccessKey, SecretKey);
  finally
    Configuration.Free;
  end;

  Create(Region, AccessKey, SecretKey);
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
      Peer.DoPost(FRegion, QueryParameters);
      PopulateResponseInfo(Response, Peer);
    except
      on E: EIPHTTPProtocolExceptionPeer do
        PopulateResponseInfo(Response, E)
      else
        raise;
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

function TAmazonEmailService.SendMail(const Recipients, ReplyTo: TArray<string>; const FromName, FromAddress, Subject,
    MessageBody: string; const EmailBody: TEmailBody): Boolean;
var
  Response: TCloudResponseInfo;
begin
  try
    Result := SendMail(Recipients, ReplyTo, FromName, FromAddress, Subject, MessageBody, Response, EmailBody);
  finally
    if Assigned(Response) then
      Response.Free;
  end;
end;

function TAmazonEmailService.BuildQueryParameters(const Recipients, ReplyTo: TArray<string>; const FromName,
    FromAddress, Subject, MessageBody: string): TStringStream;
var
  BuildQueryParameters: TBuildQueryParameters;
begin
  BuildQueryParameters := TBuildQueryParameters.Create(FEmailBody);
  try
    Result := BuildQueryParameters.GetQueryParams(Recipients, ReplyTo, FromName, FromAddress, Subject, MessageBody);
  finally
    BuildQueryParameters.Free;
  end;
end;

function TAmazonEmailService.SendMail(const Recipients, ReplyTo: TArray<string>; const FromName, FromAddress, Subject,
    MessageBody: string; out Response: TCloudResponseInfo; const EmailBody: TEmailBody): Boolean;
var
  QueryParameters: TStringStream;
begin
  FEmailBody := EmailBody;

  CoInitialize(nil);
  try
    Response := TCloudResponseInfo.Create;

    QueryParameters := BuildQueryParameters(Recipients, ReplyTo, FromName, FromAddress, Subject, MessageBody);
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
