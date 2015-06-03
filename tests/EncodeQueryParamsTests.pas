unit EncodeQueryParamsTests;

interface

uses
  DUnitX.TestFramework,
  EncodeQueryParams;

type
  [TestFixture]
  TEncodeQueryParamsTests = class
  published
    procedure Encode_Email_ReturnValidEncodedEmail;
    procedure Encode_Subject_ReturnValidEncodedSubject;
  end;

implementation

{ TEncodeQueryParamsTests }

procedure TEncodeQueryParamsTests.Encode_Email_ReturnValidEncodedEmail;
var
  EncodedStr: string;
begin
  EncodedStr := TEncodeQueryParams.Encode('name@gmail.com');
  Assert.AreEqual('name%40gmail.com', EncodedStr);
end;

procedure TEncodeQueryParamsTests.Encode_Subject_ReturnValidEncodedSubject;
var
  EncodedStr: string;
begin
  EncodedStr := TEncodeQueryParams.Encode('Hello. I hope you are having a good day.');
  Assert.AreEqual('Hello.%20I%20hope%20you%20are%20having%20a%20good%20day.', EncodedStr);
end;

initialization
  TDUnitX.RegisterTestFixture(TEncodeQueryParamsTests);

end.
