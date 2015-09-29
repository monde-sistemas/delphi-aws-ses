unit AmazonEmailServiceConfiguration;

interface

type
  TAmazonEmailServiceConfiguration = class
  private
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
  if VarValue.Trim = '' then
    raise EArgumentNilException.Create(Format('No Amazon %s provided.', [Description]));
end;

procedure TAmazonEmailServiceConfiguration.GetFromEnvironment(var Region, AccessKey, SecretKey: string);
begin
  Region := GetEnvironmentVariable(AWS_REGION);
  AssertValue(Region, 'Region');

  AccessKey := GetEnvironmentVariable(AWS_ACCESS_KEY_ID);
  AssertValue(AccessKey, 'Access Key');

  SecretKey := GetEnvironmentVariable(AWS_SECRET_ACCESS_KEY);
  AssertValue(SecretKey, 'Secret Access Key');
end;

end.
