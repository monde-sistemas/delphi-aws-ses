unit AmazonEmailServiceRequests;

interface

uses
  IPPeerAPI;

type
  TAmazonEmailServiceRequests = class
  private
    FAWSAccessKey: string;
    FAWSSecretKey: string;
    FDateRequest: TDateTime;
    function GetCurrentDate: string;
    function GetSignature(const StringToSign: string): string;
  public
    constructor Create(const AWSAccessKey, AWSSecretKey: string);
    procedure PrepareRequest(const Peer: IIPHTTP);
    property DateRequest: TDateTime read FDateRequest;
  end;

implementation

uses
  DateUtils,
  SysUtils,
  PrepareRequestSignature;

constructor TAmazonEmailServiceRequests.Create(const AWSAccessKey, AWSSecretKey: string);
begin
  FAWSAccessKey := AWSAccessKey;
  FAWSSecretKey := AWSSecretKey;
end;

function TAmazonEmailServiceRequests.GetCurrentDate: string;
const
  FORMAT_HTTP_DATE = 'ddd, dd mmm yyyy hh:nn:ss "GMT"';
begin
  FDateRequest := Now;
  Result := FormatDateTime(FORMAT_HTTP_DATE, TTimeZone.Local.ToUniversalTime(FDateRequest), TFormatSettings.Create('en-US'));
end;

function TAmazonEmailServiceRequests.GetSignature(const StringToSign: string): string;
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

procedure TAmazonEmailServiceRequests.PrepareRequest(const Peer: IIPHTTP);
var
  CurrentTime: string;
  AuthorizationHeader: string;
begin
  Peer.GetRequest.ContentType := 'application/x-www-form-urlencoded';
  Peer.GetRequest.ContentLength := 230;

  CurrentTime := GetCurrentDate;
  Peer.GetRequest.CustomHeaders.AddValue('Date', CurrentTime);

  AuthorizationHeader := Format('AWS3-HTTPS AWSAccessKeyId=%s, Algorithm=HmacSHA256, Signature=%s',
    [FAWSAccessKey, GetSignature(CurrentTime)]);
  Peer.GetRequest.CustomHeaders.AddValue('X-Amzn-Authorization', AuthorizationHeader);
end;

end.
