unit AmazonEmailServiceRegionsTests;

interface

uses
  TestFramework,
  AmazonEmailServiceRegions;

type
  TAmazonEmailServiceRegionsTests = class(TTestCase)
  published
    procedure GetServiceURL_ToUSEast_ReturneEndpointEast1;
    procedure GetServiceURL_ToUSWest_ReturneEndpointWest2;
    procedure GetServiceURL_ToEUIreland_ReturneEndpointWest1;
  end;

implementation

uses
  AmazonEmailService;

procedure TAmazonEmailServiceRegionsTests.GetServiceURL_ToEUIreland_ReturneEndpointWest1;
var
  ServiceURL: string;
begin
  ServiceURL := TAmazonEmailServiceRegions.GetServiceURL(EUIreland);
  CheckEquals('https://email.eu-west-1.amazonaws.com', ServiceURL);
end;

procedure TAmazonEmailServiceRegionsTests.GetServiceURL_ToUSEast_ReturneEndpointEast1;
var
  ServiceURL: string;
begin
  ServiceURL := TAmazonEmailServiceRegions.GetServiceURL(USEast);
  CheckEquals('https://email.us-east-1.amazonaws.com', ServiceURL);
end;

procedure TAmazonEmailServiceRegionsTests.GetServiceURL_ToUSWest_ReturneEndpointWest2;
var
  ServiceURL: string;
begin
  ServiceURL := TAmazonEmailServiceRegions.GetServiceURL(USWest);
  CheckEquals('https://email.us-west-2.amazonaws.com', ServiceURL);
end;

initialization
   RegisterTest(TAmazonEmailServiceRegionsTests.Suite);

end.
