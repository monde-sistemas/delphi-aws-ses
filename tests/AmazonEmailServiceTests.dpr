program AmazonEmailServiceTests;

{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}

uses
  ActiveX,
  TestFramework,
  TextTestRunner,
  EncodeQueryParams in '..\EncodeQueryParams.pas',
  AmazonEmailAuthentication in '..\AmazonEmailAuthentication.pas',
  PrepareRequestSignature in '..\PrepareRequestSignature.pas',
  PrepareRequestSignatureTests in 'PrepareRequestSignatureTests.pas',
  EncodeQueryParamsTests in 'EncodeQueryParamsTests.pas',
  PopulateResponseInfo in '..\PopulateResponseInfo.pas',
  PopulateResponseInfoTests in 'PopulateResponseInfoTests.pas',
  AmazonEmailServiceRegions in '..\AmazonEmailServiceRegions.pas',
  AmazonEmailService in '..\AmazonEmailService.pas',
  AmazonEmailServiceRegionsTests in 'AmazonEmailServiceRegionsTests.pas',
  AmazonEmailServiceHeaders in '..\AmazonEmailServiceHeaders.pas',
  AmazonEmailServiceHeadersTests in 'AmazonEmailServiceHeadersTests.pas',
  BuildQueryParameters in '..\BuildQueryParameters.pas',
  BuildQueryParametersTests in 'BuildQueryParametersTests.pas';

{$R *.RES}

begin
  CoInitialize(nil);
  try
    TextTestRunner.RunRegisteredTests(rxbPause);
  finally
    CoUninitialize;
  end;
end.
