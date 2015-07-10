unit EncodeQueryParams;

interface

type
  TEncodeQueryParams = class
  public
    class function Encode(const Str: string): string; static;
  end;

implementation

uses
  SysUtils;

class function TEncodeQueryParams.Encode(const Str: string): string;
const
  SAFE_CHARS = ['A'..'Z', 'a'..'z', '0', '1'..'9', '-', '_', '~', '.'];
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(Str) do
    if not CharInSet(Str[I], SAFE_CHARS) then
      Result := Result + '%'+ IntToHex(Ord(Str[I]),2)
    else
      Result := Result + Str[I];
end;

end.
