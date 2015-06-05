unit AmazonEmailServiceConfiguration;

interface

type
  TAmazonEmailServiceConfiguration = class
  private
    function GetEnvVarValue(const VarName: string): string;
  public
    procedure GetFromEnvironment(var AwsSESEndpoint, AwsSESAccessKey, AwsSESSecretKey: string);
  end;

const
  AWS_SES_REGION_ENDPOINT = 'AWS_SES_REGION_ENDPOINT';
  AWS_SES_ACCESS_KEY_ID = 'AWS_SES_ACCESS_KEY_ID';
  AWS_SES_SECRET_ACCESS_KEY = 'AWS_SES_SECRET_ACCESS_KEY';

implementation

uses
  SysUtils,
  Windows;

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

procedure TAmazonEmailServiceConfiguration.GetFromEnvironment(var AwsSESEndpoint, AwsSESAccessKey, AwsSESSecretKey: string);
begin
  AwsSESEndpoint := GetEnvVarValue(AWS_SES_REGION_ENDPOINT);
  if AwsSESEndpoint = '' then
    raise EArgumentNilException.Create('No Amazon SES Endpoint provided.');

  AwsSESAccessKey := GetEnvVarValue(AWS_SES_ACCESS_KEY_ID);
  if AwsSESAccessKey = '' then
    raise EArgumentNilException.Create('No Amazon SES Access Key provided.');

  AwsSESSecretKey := GetEnvVarValue(AWS_SES_SECRET_ACCESS_KEY);
  if AwsSESSecretKey = '' then
    raise EArgumentNilException.Create('No Amazon SES Secret Access Key provided.');
end;

end.
