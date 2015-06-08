unit AmazonEmailServiceRegions;

interface

type
  TAmazonEmailServiceRegions = class
  public
    class function FormatServiceURL(const Region: string): string;
  end;

implementation

uses
  SysUtils;

class function TAmazonEmailServiceRegions.FormatServiceURL(const Region: string): string;
const
  Protocol = 'https';
begin
  Result := Format('%s://email.%s.amazonaws.com', [Protocol, Region]);
end;

end.
