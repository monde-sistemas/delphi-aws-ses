unit AmazonEmailServiceRegionsTests;

interface

uses
  DUnitX.TestFramework,
  AmazonEmailServiceRegions;

type
  [TestFixture]
  TAmazonEmailServiceRegionsTests = class
  private
    function GetUrlWithProtocolHTTPS(const Endpoint: string): string;
    function GetUrlWithProtocolIncorrect(const Endpoint: string): string;
  published
    procedure GetServiceURL_ToUSEast_ReturneEndpointEast1;
    procedure GetServiceURL_ToUSEastWithProtocolHTTPS_ReturneEndpointEast1;
    procedure GetServiceURL_ToUSEastWithProtocolIncorrect_ReturneEndpointEast1;
    procedure GetServiceURL_ToUSWest_ReturneEndpointWest2;
    procedure GetServiceURL_ToUSWestWithProtocolHTTPS_ReturneEndpointEast1;
    procedure GetServiceURL_ToUSWestWithProtocolIncorrect_ReturneEndpointEast1;
    procedure GetServiceURL_ToEUIreland_ReturneEndpointWest1;
    procedure GetServiceURL_ToEUIrelandWithProtocolHTTPS_ReturneEndpointEast1;
    procedure GetServiceURL_ToEUIrelandWithProtocolIncorrect_ReturneEndpointEast1;
  end;

implementation

uses
  IdHTTP,
  SysUtils;

const
  EUIrelandEndpoint = 'email.eu-west-1.amazonaws.com';
  USEastEndpoint = 'email.us-east-1.amazonaws.com';
  USWestEndpoint = 'email.us-west-2.amazonaws.com';
  URL_EUIrelandEndpoint = 'https://' + EUIrelandEndpoint;
  URL_USEastEndpoint = 'https://' + USEastEndpoint;
  URL_USWestEndpoint = 'https://' + USWestEndpoint;

procedure TAmazonEmailServiceRegionsTests.GetServiceURL_ToEUIrelandWithProtocolHTTPS_ReturneEndpointEast1;
var
  ServiceURL: string;
  EUIrelandEndpointWithCorrectProtocol: string;
begin
  EUIrelandEndpointWithCorrectProtocol := GetUrlWithProtocolHTTPS(EUIrelandEndpoint);
  ServiceURL := TAmazonEmailServiceRegions.DefineServiceURL(EUIrelandEndpointWithCorrectProtocol);
  Assert.AreEqual(URL_EUIrelandEndpoint, ServiceURL);
end;

procedure TAmazonEmailServiceRegionsTests.GetServiceURL_ToEUIrelandWithProtocolIncorrect_ReturneEndpointEast1;
var
  EUIrelandEndpointWithIncorrectProtocol: string;
begin
  EUIrelandEndpointWithIncorrectProtocol := GetUrlWithProtocolIncorrect(EUIrelandEndpoint);
  Assert.WillRaise(
    procedure
    begin
      TAmazonEmailServiceRegions.DefineServiceURL(EUIrelandEndpointWithIncorrectProtocol);
    end, EIdHTTPProtocolException);
end;

procedure TAmazonEmailServiceRegionsTests.GetServiceURL_ToEUIreland_ReturneEndpointWest1;
var
  ServiceURL: string;
begin
  ServiceURL := TAmazonEmailServiceRegions.DefineServiceURL(EUIrelandEndpoint);
  Assert.AreEqual(URL_EUIrelandEndpoint, ServiceURL);
end;

procedure TAmazonEmailServiceRegionsTests.GetServiceURL_ToUSEastWithProtocolHTTPS_ReturneEndpointEast1;
var
  ServiceURL: string;
  USEastEndpointWithCorrectProtocol: string;
begin
  USEastEndpointWithCorrectProtocol := GetUrlWithProtocolHTTPS(USEastEndpoint);
  ServiceURL := TAmazonEmailServiceRegions.DefineServiceURL(USEastEndpointWithCorrectProtocol);
  Assert.AreEqual(URL_USEastEndpoint, ServiceURL);
end;

procedure TAmazonEmailServiceRegionsTests.GetServiceURL_ToUSEastWithProtocolIncorrect_ReturneEndpointEast1;
var
  USEastEndpointWithIncorrectProtocol: string;
begin
  USEastEndpointWithIncorrectProtocol := GetUrlWithProtocolIncorrect(USEastEndpoint);
  Assert.WillRaise(
    procedure
    begin
      TAmazonEmailServiceRegions.DefineServiceURL(USEastEndpointWithIncorrectProtocol);
    end, EIdHTTPProtocolException);
end;

procedure TAmazonEmailServiceRegionsTests.GetServiceURL_ToUSEast_ReturneEndpointEast1;
var
  ServiceURL: string;
begin
  ServiceURL := TAmazonEmailServiceRegions.DefineServiceURL(USEastEndpoint);
  Assert.AreEqual(URL_USEastEndpoint, ServiceURL);
end;

procedure TAmazonEmailServiceRegionsTests.GetServiceURL_ToUSWestWithProtocolHTTPS_ReturneEndpointEast1;
var
  ServiceURL: string;
  USWestEndpointWithCorrectProtocol: string;
begin
  USWestEndpointWithCorrectProtocol := GetUrlWithProtocolHTTPS(USWestEndpoint);
  ServiceURL := TAmazonEmailServiceRegions.DefineServiceURL(USWestEndpointWithCorrectProtocol);
  Assert.AreEqual(URL_USWestEndpoint, ServiceURL);
end;

procedure TAmazonEmailServiceRegionsTests.GetServiceURL_ToUSWestWithProtocolIncorrect_ReturneEndpointEast1;
var
  USWestEndpointWithIncorrectProtocol: string;
begin
  USWestEndpointWithIncorrectProtocol := GetUrlWithProtocolIncorrect(USWestEndpoint);
  Assert.WillRaise(
    procedure
    begin
      TAmazonEmailServiceRegions.DefineServiceURL(USWestEndpointWithIncorrectProtocol);
    end, EIdHTTPProtocolException);
end;

procedure TAmazonEmailServiceRegionsTests.GetServiceURL_ToUSWest_ReturneEndpointWest2;
var
  ServiceURL: string;
begin
  ServiceURL := TAmazonEmailServiceRegions.DefineServiceURL(USWestEndpoint);
  Assert.AreEqual(URL_USWestEndpoint, ServiceURL);
end;

function TAmazonEmailServiceRegionsTests.GetUrlWithProtocolHTTPS(const Endpoint: string): string;
const
  PROTOCOL_HTTPS = 'https';
begin
  Result := Format('%s://%s', [PROTOCOL_HTTPS, Endpoint]);
end;

function TAmazonEmailServiceRegionsTests.GetUrlWithProtocolIncorrect(const Endpoint: string): string;
const
  PROTOCOL_HTTP = 'http';
begin
  Result := Format('%s://%s', [PROTOCOL_HTTP, Endpoint]);
end;

initialization
  TDUnitX.RegisterTestFixture(TAmazonEmailServiceRegionsTests);

end.

