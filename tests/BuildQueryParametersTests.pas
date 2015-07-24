unit BuildQueryParametersTests;

interface

uses
  Classes,
  DUnitX.TestFramework,
  BuildQueryParameters;

type
  [TestFixture]
  TBuildQueryParametersTests = class
  strict private
    FRecipients: TArray<string>;
    FBuildQueryParameters: TBuildQueryParameters;
  private
    procedure AddRecipient(const Address: string);
  public
    [Setup]
    procedure SetUp;
    [TearDown]
    procedure TearDown;
  published
    procedure GetQueryParams_WithHTMLBody_EncodedParamsReturned;
    procedure GetQueryParams_WithTextBody_EncodedParamsReturned;
    procedure GetQueryParams_MutipleRecipients_RecipientsAdded;
    procedure GetQueryParams_WithReplyToAddresses_AddressesAdded;
    procedure GetQueryParams_FromNameSpecified_FromNameEncoded;
  end;

implementation

uses
  AmazonEmailService;

procedure TBuildQueryParametersTests.AddRecipient(const Address: string);
begin
  SetLength(FRecipients, Length(FRecipients) +1);
  FRecipients[High(FRecipients)] := Address;
end;

procedure TBuildQueryParametersTests.GetQueryParams_MutipleRecipients_RecipientsAdded;
const
  ExpectedRecipients = '&Destination.ToAddresses.member.1=emailFrom%40mail.com' +
                    '&Destination.ToAddresses.member.2=emailFrom2%40mail.com';
var
  EncodedParams: TStringStream;
begin
  AddRecipient('emailFrom2@mail.com');

  EncodedParams := FBuildQueryParameters.GetQueryParams(FRecipients, '', 'email@email.com', '', '');
  try
    Assert.Contains(EncodedParams.DataString, ExpectedRecipients);
  finally
    EncodedParams.Free;
  end;
end;

procedure TBuildQueryParametersTests.GetQueryParams_FromNameSpecified_FromNameEncoded;
const
  ExpectedSource = '&Source=%3D%3Futf-8%3FB%3FW0FDTUVdIEpvaG4gRG9l%3F%3D%20%3Cemail%40email.com%3E';
var
  EncodedParams: TStringStream;
begin
  EncodedParams := FBuildQueryParameters.GetQueryParams(FRecipients, '[ACME] John Doe', 'email@email.com', '', '');
  try
    Assert.Contains(EncodedParams.DataString, ExpectedSource);
  finally
    EncodedParams.Free;
  end;
end;

procedure TBuildQueryParametersTests.GetQueryParams_WithHTMLBody_EncodedParamsReturned;
const
  EXPECTED_RETURN = 'Action=SendEmail' +
                    '&Source=%3D%3Futf-8%3FB%3F%3F%3D%20%3Cemail%40mail.com%3E' +
                    '&Destination.ToAddresses.member.1=emailFrom%40mail.com' +
                    '&Message.Subject.Charset=UTF-8' +
                    '&Message.Subject.Data=This%20is%20the%20subject%20line%20with%20HTML.' +
                    '&Message.Body.Html.Charset=UTF-8' +
                    '&Message.Body.Html.Data=%3C%21DOCTYPE%20html%3E%3Chtml%3E%3Cbody%3E%3Cp%3EThis%20is%20' +
                    'an%20email%20link%3A%3Ca%20href%3D%22mailto%3Asomeone%40example.com%3FSubject%3DHello' +
                    '%2520again%22%20target%3D%22_top%22%3ESend%20Mail%3C%2Fa%3E%3C%2Fp%3E%3Cp%3E%3Cb%3ENote' +
                    '%3A%3C%2Fb%3E%20Spaces%20between%20words%20should%20be%20replaced%20by%20%2520%20to%20' +
                    'ensure%20that%20the%20browser%20will%20display%20the%20text%20properly.%3C%2Fp%3E%3C%2' +
                    'Fbody%3E%3C%2Fhtml%3E';
var
  FromAddress, Subject, MessageBody: string;
  EncodedParams: TStringStream;
begin
  FromAddress := 'email@mail.com';
  Subject := 'This is the subject line with HTML.';
  MessageBody := '<!DOCTYPE html>' +
    '<html>' +
    '<body>' +
    '<p>' +
    'This is an email link:' +
    '<a href="mailto:someone@example.com?Subject=Hello%20again" target="_top">Send Mail</a>' +
    '</p>' +
    '<p>' +
    '<b>Note:</b> Spaces between words should be replaced by %20 to ensure that the browser will display the text properly.' +
    '</p>' +
    '</body>' +
    '</html>';

  EncodedParams := FBuildQueryParameters.GetQueryParams(FRecipients, '', FromAddress, Subject, MessageBody);
  try
    Assert.AreEqual(EXPECTED_RETURN, EncodedParams.DataString);
  finally
    EncodedParams.Free;
  end;
end;

procedure TBuildQueryParametersTests.GetQueryParams_WithReplyToAddresses_AddressesAdded;
const
  ExpectedRecipients = '&ReplyToAddresses.member.1=emailtoreply1%40mail.com' +
                    '&ReplyToAddresses.member.2=emailtoreply2%40mail.com';
var
  EncodedParams: TStringStream;
  ReplyTo: TArray<string>;
begin
  ReplyTo := TArray<string>.Create('emailtoreply1@mail.com', 'emailtoreply2@mail.com');

  EncodedParams := FBuildQueryParameters.GetQueryParams(FRecipients, ReplyTo, '', 'email@email.com', '', '');
  try
    Assert.Contains(EncodedParams.DataString, ExpectedRecipients);
  finally
    EncodedParams.Free;
  end;
end;

procedure TBuildQueryParametersTests.GetQueryParams_WithTextBody_EncodedParamsReturned;
const
  EXPECTED_RETURN = 'Action=SendEmail' +
                    '&Source=%3D%3Futf-8%3FB%3F%3F%3D%20%3Cemail%40mail.com%3E' +
                    '&Destination.ToAddresses.member.1=emailFrom%40mail.com' +
                    '&Message.Subject.Charset=UTF-8' +
                    '&Message.Subject.Data=This%20is%20the%20subject%20line.' +
                    '&Message.Body.Text.Charset=UTF-8' +
                    '&Message.Body.Text.Data=Hello.%20I%20hope%20you%20are%20having%20a%20good%20day.';
var
  FromAddress, Subject, MessageBody: string;
  EncodedParams: TStringStream;
begin
  FromAddress := 'email@mail.com';
  Subject := 'This is the subject line.';
  MessageBody := 'Hello. I hope you are having a good day.';

  FBuildQueryParameters.EmailBody := eText;
  EncodedParams := FBuildQueryParameters.GetQueryParams(FRecipients, '', FromAddress, Subject, MessageBody);
  try
    Assert.AreEqual(EXPECTED_RETURN, EncodedParams.DataString);
  finally
    EncodedParams.Free;
  end;
end;

procedure TBuildQueryParametersTests.SetUp;
begin
  inherited;
  FBuildQueryParameters := TBuildQueryParameters.Create(eHTML);
  FRecipients := TArray<string>.Create('emailFrom@mail.com');
end;

procedure TBuildQueryParametersTests.TearDown;
begin
  inherited;
  FBuildQueryParameters.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TBuildQueryParametersTests);

end.
