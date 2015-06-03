unit AmazonEmailServiceRegionsTests;

interface

uses
  DUnitX.TestFramework,
  AmazonEmailServiceRegions;

type
  [TestFixture]
  TAmazonEmailServiceRegionsTests = class
  published
    procedure FormatServiceURL_WithEndpoint_ReturnServiceURL;
    procedure FormatServiceURL_WithEndpointAndProtocolHTTPS_ReturnServiceURL;
    procedure FormatServiceURL_WithEndpointAndIncorrectProtocol_EIdHTTPProtocolException;
  end;

implementation

uses
  IdHTTP,
  SysUtils;

procedure TAmazonEmailServiceRegionsTests.FormatServiceURL_WithEndpointAndProtocolHTTPS_ReturnServiceURL;
var
  ServiceURL: string;
begin
  ServiceURL := TAmazonEmailServiceRegions.FormatServiceURL('https://email.us-east-1.amazonaws.com');
  Assert.AreEqual('https://email.us-east-1.amazonaws.com', ServiceURL);
end;

procedure TAmazonEmailServiceRegionsTests.FormatServiceURL_WithEndpointAndIncorrectProtocol_EIdHTTPProtocolException;
begin
  Assert.WillRaise(
    procedure
    begin
      TAmazonEmailServiceRegions.FormatServiceURL('http://email.us-west-2.amazonaws.com');
    end, EIdHTTPProtocolException);
end;

procedure TAmazonEmailServiceRegionsTests.FormatServiceURL_WithEndpoint_ReturnServiceURL;
var
  ServiceURL: string;
begin
  ServiceURL := TAmazonEmailServiceRegions.FormatServiceURL('email.eu-west-1.amazonaws.com');
  Assert.AreEqual('https://email.eu-west-1.amazonaws.com', ServiceURL);
end;

initialization
  TDUnitX.RegisterTestFixture(TAmazonEmailServiceRegionsTests);

end.
