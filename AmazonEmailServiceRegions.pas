unit AmazonEmailServiceRegions;

interface

type
  TAmazonEmailServiceRegions = class
  public
    class function DefineServiceURL(const AWSRegionEndpoint: string): string;
  end;

implementation

uses
  IdHTTP,
  StrUtils,
  SysUtils;

class function TAmazonEmailServiceRegions.DefineServiceURL(const AWSRegionEndpoint: string): string;
const
  AwsSESOnlySupportHTTPS = 'For security reasons, Amazon SES only support HTTPS requests.';
  Protocol = 'https';
begin
  if AnsiContainsStr(AWSRegionEndpoint, '://') then
  begin
    if not AnsiContainsStr(AWSRegionEndpoint, Protocol + '://') then
      raise EIdHTTPProtocolException.Create(AwsSESOnlySupportHTTPS);
    Result := AWSRegionEndpoint;
  end
  else
    Result := Format('%s://%s', [Protocol, AWSRegionEndpoint]);
end;

end.
