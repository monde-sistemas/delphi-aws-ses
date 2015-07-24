unit BuildQueryParameters;

interface

uses
  AmazonEmailMessage,
  AmazonEmailService,
  System.Classes;

type
  TBuildQueryParameters = class
  public
    class function GetQueryParams(const EmailMessage: TEmailMessage): TStringStream;
  end;

implementation

uses
  SysUtils,
  EncodeQueryParams,
  System.NetEncoding;

class function TBuildQueryParameters.GetQueryParams(const EmailMessage: TEmailMessage): TStringStream;
const
  Action = 'SendEmail';
var
  I: Integer;
  BodyType, Source: string;
begin
  Result := TStringStream.Create(EmptyStr, TEncoding.UTF8);
  try
    Result.WriteString('Action=' + ACTION);

    Source := Format('=?utf-8?B?%s?= <%s>', [TNetEncoding.Base64.Encode(EmailMessage.FromName), EmailMessage.FromAddress]);
    Result.WriteString(Format('&Source=%s', [TEncodeQueryParams.Encode(Source)]));

    for I := Low(EmailMessage.Recipients) to High(EmailMessage.Recipients) do
      Result.WriteString(Format('&Destination.ToAddresses.member.%d=%s', [I+1, TEncodeQueryParams.Encode(EmailMessage.Recipients[I])]));

    for I := Low(EmailMessage.ReplyTo) to High(EmailMessage.ReplyTo) do
      Result.WriteString(Format('&ReplyToAddresses.member.%d=%s', [I+1, TEncodeQueryParams.Encode(EmailMessage.ReplyTo[I])]));

    Result.WriteString('&Message.Subject.Charset=UTF-8');
    Result.WriteString(Format('&Message.Subject.Data=%s', [TEncodeQueryParams.Encode(EmailMessage.Subject)]));

    if EmailMessage.BodyType = btHTML then
      BodyType := 'Html'
    else
      BodyType := 'Text';
    Result.WriteString(Format('&Message.Body.%s.Charset=UTF-8', [BodyType]));
    Result.WriteString(Format('&Message.Body.%s.Data=%s', [BodyType, TEncodeQueryParams.Encode(EmailMessage.Body)]));
  except
    Result.Free;
    raise
  end;
end;

end.
