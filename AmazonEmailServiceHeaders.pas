unit AmazonEmailServiceHeaders;

interface

type
  TAmazonEmailServiceHeaders = class
  public
    class function GetDate(const ADateTime: TDateTime): string;
  end;

implementation

uses
  DateUtils,
  SysUtils;

class function TAmazonEmailServiceHeaders.GetDate(const ADateTime: TDateTime): string;
const
  FORMAT_HTTP_DATE = 'ddd, dd mmm yyyy hh:nn:ss "GMT"';
begin
  Result := FormatDateTime(FORMAT_HTTP_DATE, TTimeZone.Local.ToUniversalTime(ADateTime), TFormatSettings.Create('en-US'));
end;

end.
