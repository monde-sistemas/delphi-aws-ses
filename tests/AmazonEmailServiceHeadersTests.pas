unit AmazonEmailServiceHeadersTests;

interface

uses
  TestFramework,
  AmazonEmailServiceHeaders;

type
  TAmazonEmailServiceHeadersTests = class(TTestCase)
  published
    procedure GetDate_DateParam_ReturnsFormattedDate;
  end;

implementation

uses
  SysUtils;

{ TAmazonEmailServiceHeadersTests }

procedure TAmazonEmailServiceHeadersTests.GetDate_DateParam_ReturnsFormattedDate;
const
  DATE_AS_DOUBLE = 42157.7710685532;
  DATE_AS_STRING = 'Tue, 02 Jun 2015 21:30:20 GMT';
var
  Date: string;
begin
  Date := TAmazonEmailServiceHeaders.GetDate(DATE_AS_DOUBLE);
  CheckEquals(DATE_AS_STRING, Date);
end;

initialization
   RegisterTest(TAmazonEmailServiceHeadersTests.Suite);

end.
