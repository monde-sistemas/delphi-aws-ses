unit AmazonEmailServiceRegions;

interface

type
  TAmazonEmailServiceRegions = class
  public
    class function FormatServiceURL(const Endpoint: string): string;
  end;

implementation

uses
  IdHTTP,
  StrUtils,
  SysUtils;

class function TAmazonEmailServiceRegions.FormatServiceURL(const Endpoint: string): string;
const
  AwsSESOnlySupportHTTPS = 'For security reasons, Amazon SES only support HTTPS requests.';
  Protocol = 'https';
begin
  if AnsiContainsStr(Endpoint, '://') then
  begin
    if not AnsiContainsStr(Endpoint, Protocol + '://') then
      raise EIdHTTPProtocolException.Create(AwsSESOnlySupportHTTPS);
    Result := Endpoint;
  end
  else
    Result := Format('%s://%s', [Protocol, Endpoint]);
end;

end.
