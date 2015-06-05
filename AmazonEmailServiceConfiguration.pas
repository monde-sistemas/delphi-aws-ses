unit AmazonEmailServiceConfiguration;

interface

type
  TAmazonEmailServiceConfiguration = class
  private
    function GetEnvVarValue(const VarName: string): string;
    procedure AssertValue(const VarValue, Description: string);
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

procedure TAmazonEmailServiceConfiguration.AssertValue(const VarValue, Description: string);
begin
  if VarValue = '' then
    raise EArgumentNilException.Create(Format('No Amazon SES %s provided.', [Description]));
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

procedure TAmazonEmailServiceConfiguration.GetFromEnvironment(var AwsSESEndpoint, AwsSESAccessKey, AwsSESSecretKey: string);
begin
  AwsSESEndpoint := GetEnvVarValue(AWS_SES_REGION_ENDPOINT);
  AssertValue(AwsSESEndpoint, 'Endpoint');

  AwsSESAccessKey := GetEnvVarValue(AWS_SES_ACCESS_KEY_ID);
  AssertValue(AwsSESAccessKey, 'Access Key');

  AwsSESSecretKey := GetEnvVarValue(AWS_SES_SECRET_ACCESS_KEY);
  AssertValue(AwsSESSecretKey, 'Secret Access Key');
end;

end.
