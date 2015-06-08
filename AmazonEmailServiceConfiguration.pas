unit AmazonEmailServiceConfiguration;

interface

type
  TAmazonEmailServiceConfiguration = class
  private
    function GetEnvVarValue(const VarName: string): string;
    procedure AssertValue(const VarValue, Description: string);
  public
    procedure GetFromEnvironment(var Region, AccessKey, SecretKey: string);
  end;

const
  AWS_REGION = 'AWS_REGION';
  AWS_ACCESS_KEY_ID = 'AWS_ACCESS_KEY_ID';
  AWS_SECRET_ACCESS_KEY = 'AWS_SECRET_ACCESS_KEY';

implementation

uses
  SysUtils,
  Windows;

procedure TAmazonEmailServiceConfiguration.AssertValue(const VarValue, Description: string);
begin
  if VarValue = '' then
    raise EArgumentNilException.Create(Format('No Amazon %s provided.', [Description]));
end;

function TAmazonEmailServiceConfiguration.GetEnvVarValue(const VarName: string): string;
var
  BufSize: Integer;
begin
  GetEnvironmentVariable(PChar(VarName), PChar(Result), 0);
  BufSize := GetEnvironmentVariable(PChar(VarName), nil, 0);
  if BufSize > 0 then
  begin
    SetLength(Result, BufSize - 1);
    GetEnvironmentVariable(PChar(VarName), PChar(Result), BufSize);
    Result := Trim(Result);
  end
  else
    Result := '';
end;

procedure TAmazonEmailServiceConfiguration.GetFromEnvironment(var Region, AccessKey, SecretKey: string);
begin
  Region := GetEnvVarValue(AWS_REGION);
  AssertValue(Region, 'Region');

  AccessKey := GetEnvVarValue(AWS_ACCESS_KEY_ID);
  AssertValue(AccessKey, 'Access Key');

  SecretKey := GetEnvVarValue(AWS_SECRET_ACCESS_KEY);
  AssertValue(SecretKey, 'Secret Access Key');
end;

end.
