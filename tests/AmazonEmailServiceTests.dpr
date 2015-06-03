program AmazonEmailServiceTests;

{$APPTYPE CONSOLE}

uses
  ActiveX,
  PrepareRequestSignatureTests in 'PrepareRequestSignatureTests.pas',
  EncodeQueryParamsTests in 'EncodeQueryParamsTests.pas',
  PopulateResponseInfoTests in 'PopulateResponseInfoTests.pas',
  AmazonEmailServiceRegionsTests in 'AmazonEmailServiceRegionsTests.pas',
  BuildQueryParametersTests in 'BuildQueryParametersTests.pas',
  AmazonEmailServiceRequestsTests in 'AmazonEmailServiceRequestsTests.pas',
  DunitXTestRunner in 'DunitXTestRunner.pas';

{$R *.RES}

begin
  CoInitialize(nil);
  try
    TDUnitXTestRunner.RunTests;
  finally
    CoUninitialize;
  end;
end.
