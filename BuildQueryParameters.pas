unit BuildQueryParameters;

interface

uses
  Classes;

type
  TBuildQueryParameters = class
  private
    FIsHtmlEmail: Boolean;
  public
    constructor Create(IsHtmlEmail: Boolean);
    function GetQueryParams(const Recipients: TStrings; const From, Subject, MessageBody: string): TStringStream;
    property IsHtmlEmail: Boolean read FIsHtmlEmail write FIsHtmlEmail;
  end;

implementation

uses
  SysUtils,
  EncodeQueryParams;

constructor TBuildQueryParameters.Create(IsHtmlEmail: Boolean);
begin
  FIsHtmlEmail := IsHtmlEmail;
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
  Result.WriteString('Action=' + ACTION);
  Result.WriteString(Format('&Source=%s', [TEncodeQueryParams.Encode(From)]));
  for I := 0 to Recipients.Count -1 do
    Result.WriteString(Format('&Destination.ToAddresses.member.%d=%s',
      [I+1, TEncodeQueryParams.Encode(Recipients[I])]));

  Result.WriteString('&Message.Subject.Charset=UTF-8');
  Result.WriteString(Format('&Message.Subject.Data=%s', [TEncodeQueryParams.Encode(Subject)]));

  if FIsHtmlEmail then
    BodyType := 'Html'
  else
    BodyType := 'Text';
  Result.WriteString(Format('&Message.Body.%s.Charset=UTF-8', [BodyType]));
  Result.WriteString(Format('&Message.Body.%s.Data=%s', [BodyType, TEncodeQueryParams.Encode(MessageBody)]));
end;

end.
