unit BuildQueryParameters;

interface

uses
  AmazonEmailService,
  System.Classes;

type
  TBuildQueryParameters = class
  private
    FEmailBody: TEmailBody;
  public
    constructor Create(const EmailBody: TEmailBody);
    function GetQueryParams(const Recipients: TArray<string>; const FromName, FromAddress, Subject, MessageBody: string):
        TStringStream; overload;
    function GetQueryParams(const Recipients, ReplyTo: TArray<string>; const FromName, FromAddress, Subject, MessageBody:
        string): TStringStream; overload;
    property EmailBody: TEmailBody read FEmailBody write FEmailBody;
  end;

implementation

uses
  SysUtils,
  EncodeQueryParams,
  System.NetEncoding;

constructor TBuildQueryParameters.Create(const EmailBody: TEmailBody);
begin
  FEmailBody := EmailBody;
end;

function TBuildQueryParameters.GetQueryParams(const Recipients: TArray<string>; const FromName, FromAddress, Subject,
    MessageBody: string): TStringStream;
begin
  Result := GetQueryParams(Recipients, nil, FromName, FromAddress, Subject, MessageBody);
end;

function TBuildQueryParameters.GetQueryParams(const Recipients, ReplyTo: TArray<string>; const FromName, FromAddress,
    Subject, MessageBody: string): TStringStream;
const
  ACTION = 'SendEmail';
var
  I: Integer;
  BodyType, Source: string;
begin
  Result := TStringStream.Create(EmptyStr, TEncoding.UTF8);
  try
    Result.WriteString('Action=' + ACTION);
    Source := Format('=?utf-8?B?%s?= <%s>', [TNetEncoding.Base64.Encode(FromName), FromAddress]);
    Result.WriteString(Format('&Source=%s', [TEncodeQueryParams.Encode(Source)]));

    for I := Low(Recipients) to High(Recipients) do
      Result.WriteString(Format('&Destination.ToAddresses.member.%d=%s', [I+1, TEncodeQueryParams.Encode(Recipients[I])]));

    for I := Low(ReplyTo) to High(ReplyTo) do
      Result.WriteString(Format('&ReplyToAddresses.member.%d=%s', [I+1, TEncodeQueryParams.Encode(ReplyTo[I])]));

    Result.WriteString('&Message.Subject.Charset=UTF-8');
    Result.WriteString(Format('&Message.Subject.Data=%s', [TEncodeQueryParams.Encode(Subject)]));

    if FEmailBody = eHTML then
      BodyType := 'Html'
    else
      BodyType := 'Text';
    Result.WriteString(Format('&Message.Body.%s.Charset=UTF-8', [BodyType]));
    Result.WriteString(Format('&Message.Body.%s.Data=%s', [BodyType, TEncodeQueryParams.Encode(MessageBody)]));
  except
    Result.Free;
    raise
  end;
end;

end.
