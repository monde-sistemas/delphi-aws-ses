unit AmazonEmailServiceRequestsTests;

interface

uses
  DUnitX.TestFramework,
  AmazonEmailServiceRequests;

type
  [TestFixture]
  TAmazonEmailServiceRequestsTests = class
  strict private
    FAmazonEmailServiceRequests: TAmazonEmailServiceRequests;
    function GetCurrentDate(const ADateTime: TDateTime): string;
  public
    [Setup]
    procedure SetUp;
    [TearDown]
    procedure TearDown;
  published
    procedure PrepareRequest_Peer_AssignRequests;
  end;

implementation

uses
  DateUtils,
  SysUtils,
  IPPeerAPI;

function TAmazonEmailServiceRequestsTests.GetCurrentDate(const ADateTime: TDateTime): string;
const
  FORMAT_HTTP_DATE = 'ddd, dd mmm yyyy hh:nn:ss "GMT"';
begin
  Result := FormatDateTime(FORMAT_HTTP_DATE, TTimeZone.Local.ToUniversalTime(ADateTime), TFormatSettings.Create('en-US'));
end;

procedure TAmazonEmailServiceRequestsTests.PrepareRequest_Peer_AssignRequests;
var
  Peer: IIPHTTP;
begin
  Peer := PeerFactory.CreatePeer('', IIPHTTP, nil) as IIPHTTP;
  try
    FAmazonEmailServiceRequests.PrepareRequest(Peer);

    Assert.AreEqual('application/x-www-form-urlencoded', Peer.GetRequest.ContentType);
    Assert.AreEqual<Int64>(230, Peer.GetRequest.ContentLength);
    Assert.AreEqual(GetCurrentDate(FAmazonEmailServiceRequests.DateRequest), Peer.GetRequest.CustomHeaders.Values['Date']);
    Assert.AreEqual('AWS3-HTTPS AWSAccessKeyId=AKIAJQF6P3QUHRSJPZCA, Algorithm=HmacSHA256, Signature=', Copy(Peer.GetRequest.CustomHeaders.Values['X-Amzn-Authorization'], 1, 80));
    Assert.AreEqual(124, Length(Peer.GetRequest.CustomHeaders.Values['X-Amzn-Authorization']));
  finally
    Peer := nil;
  end;
end;

procedure TAmazonEmailServiceRequestsTests.SetUp;
const
  FAKE_AWS_ACCESS_KEY = 'AKIAJQF6P3QUHRSJPZCA';
  FAKE_AWS_SECRET_KEY = 'BeVo2wwiGIg25t4jKxsqmzS3ljSxrdZfl/SJ+32K';
begin
  inherited;
  FAmazonEmailServiceRequests := TAmazonEmailServiceRequests.Create(FAKE_AWS_ACCESS_KEY, FAKE_AWS_SECRET_KEY);
end;

procedure TAmazonEmailServiceRequestsTests.TearDown;
begin
  inherited;
  FAmazonEmailServiceRequests.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TAmazonEmailServiceRequestsTests);

end.
