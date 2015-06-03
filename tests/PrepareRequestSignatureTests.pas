unit PrepareRequestSignatureTests;

interface

uses
  DUnitX.TestFramework,
  PrepareRequestSignature;

type
  [TestFixture]
  TPrepareRequestSignatureTests = class
  strict private
    FPrepareRequestSignature: TPrepareRequestSignature;
  public
    [Setup]
    procedure SetUp;
    [TearDown]
    procedure TearDown;
  published
    procedure GetSignature_WithCorrectStringToSign_ReturnValidSignature;
  end;

implementation

uses
  { It needed make sure IPPeerCommon (or an alternative IP Implementarion unit) is in the uses clause }
  IPPeerClient;

{ TPrepareRequestSignatureTests }

procedure TPrepareRequestSignatureTests.GetSignature_WithCorrectStringToSign_ReturnValidSignature;
var
  StringToSign: string;
  ReturnedSignature: string;
begin
  StringToSign := 'Tue, 02 Jun 2015 15:01:19 GMT';
  ReturnedSignature := FPrepareRequestSignature.GetSignature(StringToSign);
  Assert.AreEqual('QufC+soH9Cq9LAnOmTGgAs5dA4cjTptgGZhj3KuhQKs=', ReturnedSignature);
end;

procedure TPrepareRequestSignatureTests.SetUp;
const
  AWSAccessKey = 'AKIAJQF6P3QUHRSJPZCA';
  AWSSecretKey = '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';
begin
  inherited;
  FPrepareRequestSignature := TPrepareRequestSignature.Create(AWSAccessKey, AWSSecretKey);
end;

procedure TPrepareRequestSignatureTests.TearDown;
begin
  inherited;
  FPrepareRequestSignature.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TPrepareRequestSignatureTests);

end.
