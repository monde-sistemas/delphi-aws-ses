unit BuildQueryParameters;

interface

uses
  Classes,
  AmazonEmailService;

type
  TBuildQueryParameters = class
  private
    FEmailBody: TEmailBody;
  public
    constructor Create(const EmailBody: TEmailBody);
    function GetQueryParams(const Recipients: TStrings; const From, Subject, MessageBody: string): TStringStream;
    property EmailBody: TEmailBody read FEmailBody write FEmailBody;
  end;

implementation

uses
  SysUtils,
  EncodeQueryParams;

constructor TBuildQueryParameters.Create(const EmailBody: TEmailBody);
begin
  FEmailBody := EmailBody;
end;

function TBuildQueryParameters.GetQueryParams(const Recipients: TStrings; const From, Subject,
  MessageBody: string): TStringStream;
const
  ACTION = 'SendEmail';
var
  I: Integer;
  BodyType: string;
begin
  Result := TStringStream.Create(EmptyStr, TEncoding.UTF8);
  try
    Result.WriteString('Action=' + ACTION);
    Result.WriteString(Format('&Source=%s', [TEncodeQueryParams.Encode(From)]));
    for I := 0 to Recipients.Count -1 do
      Result.WriteString(Format('&Destination.ToAddresses.member.%d=%s',
        [I+1, TEncodeQueryParams.Encode(Recipients[I])]));

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
