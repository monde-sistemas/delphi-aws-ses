unit PopulateResponseInfoTests;

interface

uses
  DUnitX.TestFramework,
  PopulateResponseInfo,
  Data.Cloud.CloudAPI;

type
  [TestFixture]
  TPopulateResponseInfoTests = class
  strict private
    FPopulateResponseInfo: TPopulateResponseInfo;
    FResponseInfo: TCloudResponseInfo;
  public
    [Setup]
    procedure SetUp;
    [TearDown]
    procedure TearDown;
  published
    procedure PopulateResponseInfoFromExceptionPeer_WhenSignatureDoesNotMatch_Populate;
    procedure PopulateResponseInfoFromExceptionPeer_WithInvalidParameterValue_Populate;
  end;

implementation

uses
  IPPeerAPI,
  SysUtils;

{ TPopulateResponseInfoTests }

procedure TPopulateResponseInfoTests.PopulateResponseInfoFromExceptionPeer_WhenSignatureDoesNotMatch_Populate;
const
  ERROR_MESSAGE = '<ErrorResponse xmlns="http://ses.amazonaws.com/doc/2010-12-01/">'+
                  '  <Error>' +
                  '    <Type>Sender</Type>' +
                  '    <Code>SignatureDoesNotMatch</Code>' +
                  '    <Message>The request signature we calculated does not match the signature you provided. Check your AWS Secret Access Key and signing method. Consult the service documentation for details.</Message>' +
                  '  </Error>' +
                  '  <RequestId>1c37cce2-095f-11e5-b310-9f55ca999f88</RequestId>' +
                  '</ErrorResponse>';
  STATUS_MESSAGE = 'HTTP/1.1 403 Forbidden';
  STATUS_CODE = 403;
var
  ExceptionPeer: EIPHTTPProtocolExceptionPeer;
  MsgError: string;
begin
  ExceptionPeer := EIPHTTPProtocolExceptionPeer.Create(nil, ERROR_MESSAGE, STATUS_MESSAGE, STATUS_CODE);
  try
    FPopulateResponseInfo.FromExceptionPeer(FResponseInfo, ExceptionPeer);
    Assert.AreEqual(STATUS_CODE, FResponseInfo.StatusCode);
    MsgError := Format('%s - %s (%s)', [STATUS_MESSAGE, 'The request signature we calculated does not match the signature you provided. Check your AWS Secret Access Key and signing method. Consult the service documentation for details.', 'SignatureDoesNotMatch']);
    Assert.AreEqual(MsgError, FResponseInfo.StatusMessage);
  finally
    ExceptionPeer.Free;
  end;
end;

procedure TPopulateResponseInfoTests.PopulateResponseInfoFromExceptionPeer_WithInvalidParameterValue_Populate;
const
  ERROR_MESSAGE = '<ErrorResponse xmlns="http://ses.amazonaws.com/doc/2010-12-01/">' +
                  '  <Error>' +
                  '    <Type>Sender</Type>' +
                  '    <Code>InvalidParameterValue</Code>' +
                  '    <Message>Missing final ''@domain''</Message>' +
                  '  </Error>' +
                  '  <RequestId>4dbff96d-0962-11e5-ac94-dbc2e43ecbb8</RequestId>' +
                  '</ErrorResponse>';
  STATUS_MESSAGE = 'HTTP/1.1 400 Bad Request';
  STATUS_CODE = 400;
var
  ExceptionPeer: EIPHTTPProtocolExceptionPeer;
  MsgError: string;
begin
  ExceptionPeer := EIPHTTPProtocolExceptionPeer.Create(nil, ERROR_MESSAGE, STATUS_MESSAGE, STATUS_CODE);
  try
    FPopulateResponseInfo.FromExceptionPeer(FResponseInfo, ExceptionPeer);
    Assert.AreEqual(STATUS_CODE, FResponseInfo.StatusCode);
    MsgError := Format('%s - %s (%s)', [STATUS_MESSAGE, 'Missing final ''@domain''', 'InvalidParameterValue']);
    Assert.AreEqual(MsgError, FResponseInfo.StatusMessage);
  finally
    ExceptionPeer.Free;
  end;
end;

procedure TPopulateResponseInfoTests.SetUp;
begin
  inherited;
  FPopulateResponseInfo := TPopulateResponseInfo.Create;
  FResponseInfo := TCloudResponseInfo.Create;
end;

procedure TPopulateResponseInfoTests.TearDown;
begin
  inherited;
  FPopulateResponseInfo.Free;
  FResponseInfo.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TPopulateResponseInfoTests);

end.
