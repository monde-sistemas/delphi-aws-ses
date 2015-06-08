unit AmazonEmailServiceRegionsTests;

interface

uses
  DUnitX.TestFramework,
  AmazonEmailServiceRegions;

type
  [TestFixture]
  TAmazonEmailServiceRegionsTests = class
  published
    procedure FormatServiceURL_WithRegion_ReturnServiceURL;
  end;

implementation

uses
  SysUtils;

procedure TAmazonEmailServiceRegionsTests.FormatServiceURL_WithRegion_ReturnServiceURL;
var
  ServiceURL: string;
begin
  ServiceURL := TAmazonEmailServiceRegions.FormatServiceURL('eu-west-1');
  Assert.AreEqual('https://email.eu-west-1.amazonaws.com', ServiceURL);
end;

initialization
  TDUnitX.RegisterTestFixture(TAmazonEmailServiceRegionsTests);

end.
