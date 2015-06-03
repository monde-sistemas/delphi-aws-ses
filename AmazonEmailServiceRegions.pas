unit AmazonEmailServiceRegions;

interface

uses
  AmazonEmailService;

type
  TAmazonEmailServiceRegions = class
  public
    class function GetServiceURL(const Region: AwsRegions): string;
  end;

implementation

uses
  SysUtils;

class function TAmazonEmailServiceRegions.GetServiceURL(const Region: AwsRegions): string;
const
  Protocol = 'https';
var
  Endpoint: string;
begin
  case Region of
    USEast: Endpoint := 'email.us-east-1.amazonaws.com';
    USWest: Endpoint := 'email.us-west-2.amazonaws.com';
    EUIreland: Endpoint := 'email.eu-west-1.amazonaws.com';
  end;
  Result := Format('%s://%s', [Protocol, Endpoint]);
end;

end.
