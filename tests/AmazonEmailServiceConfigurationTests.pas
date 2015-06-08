unit AmazonEmailServiceConfigurationTests;

interface

uses
  DUnitX.TestFramework,
  AmazonEmailServiceConfiguration;

type
  [TestFixture]
  TAmazonEmailServiceConfigurationTests = class
  strict private
    FAmazonEmailServiceConfiguration: TAmazonEmailServiceConfiguration;
  private
    function SetEnvVarValue(const VarName, VarValue: string): Boolean;
    procedure DeleteEnvVarValue(const VarName: string);
  public
    [Setup]
    procedure SetUp;
    [TearDown]
    procedure TearDown;
  published
    procedure GetFromEnvironment_WithSetVars_ReturnEnvVars;
    procedure GetFromEnvironment_WithoutSetRegion_EArgumentNilException;
    procedure GetFromEnvironment_WithoutSetAccessKey_EArgumentNilException;
    procedure GetFromEnvironment_WithoutSetSecretAccessKey_EArgumentNilException;
  end;

implementation

uses
  SysUtils,
  Windows;

const
  VarRegion = 'us-east-1';
  VarAccessKey = 'QWERTYUIOP1234567890';
  VarSecretAccessKey = 'QWERTYUIOP1234567890/*-+.,asdfghjklç';

procedure TAmazonEmailServiceConfigurationTests.DeleteEnvVarValue(const VarName: string);
begin
  SetEnvironmentVariable(PChar(VarName), nil);
end;

procedure TAmazonEmailServiceConfigurationTests.GetFromEnvironment_WithoutSetAccessKey_EArgumentNilException;
var
  Region: string;
  AccessKey: string;
  SecretAccessKey: string;
begin
  try
    SetEnvVarValue(AWS_REGION, VarRegion);
    SetEnvVarValue(AWS_SECRET_ACCESS_KEY, VarSecretAccessKey);

    Assert.WillRaise(
      procedure
      begin
        FAmazonEmailServiceConfiguration.GetFromEnvironment(Region, AccessKey, SecretAccessKey)
      end, EArgumentNilException);

  finally
    DeleteEnvVarValue(AWS_REGION);
    DeleteEnvVarValue(AWS_SECRET_ACCESS_KEY);
  end;
end;

procedure TAmazonEmailServiceConfigurationTests.GetFromEnvironment_WithoutSetRegion_EArgumentNilException;
var
  Region: string;
  AccessKey: string;
  SecretAccessKey: string;
begin
  Assert.WillRaise(
    procedure
    begin
      FAmazonEmailServiceConfiguration.GetFromEnvironment(Region, AccessKey, SecretAccessKey)
    end, EArgumentNilException);
end;

procedure TAmazonEmailServiceConfigurationTests.GetFromEnvironment_WithoutSetSecretAccessKey_EArgumentNilException;
var
  Region: string;
  AccessKey: string;
  SecretAccessKey: string;
begin
  try
    SetEnvVarValue(AWS_REGION, VarRegion);
    SetEnvVarValue(AWS_ACCESS_KEY_ID, VarAccessKey);

    Assert.WillRaise(
      procedure
      begin
        FAmazonEmailServiceConfiguration.GetFromEnvironment(Region, AccessKey, SecretAccessKey)
      end, EArgumentNilException);

  finally
    DeleteEnvVarValue(AWS_REGION);
    DeleteEnvVarValue(AWS_ACCESS_KEY_ID);
  end;
end;

procedure TAmazonEmailServiceConfigurationTests.GetFromEnvironment_WithSetVars_ReturnEnvVars;
var
  Region: string;
  AccessKey: string;
  SecretAccessKey: string;
begin
  try
    SetEnvVarValue(AWS_REGION, VarRegion);
    SetEnvVarValue(AWS_ACCESS_KEY_ID, VarAccessKey);
    SetEnvVarValue(AWS_SECRET_ACCESS_KEY, VarSecretAccessKey);

    FAmazonEmailServiceConfiguration.GetFromEnvironment(Region, AccessKey, SecretAccessKey);

    Assert.AreEqual(VarRegion, Region);
    Assert.AreEqual(VarAccessKey, AccessKey);
    Assert.AreEqual(VarSecretAccessKey, SecretAccessKey);
  finally
    DeleteEnvVarValue(AWS_REGION);
    DeleteEnvVarValue(AWS_ACCESS_KEY_ID);
    DeleteEnvVarValue(AWS_SECRET_ACCESS_KEY);
  end;
end;

function TAmazonEmailServiceConfigurationTests.SetEnvVarValue(const VarName, VarValue: string): Boolean;
begin
  Result := SetEnvironmentVariable(PChar(VarName), PChar(VarValue));
end;

procedure TAmazonEmailServiceConfigurationTests.SetUp;
begin
  FAmazonEmailServiceConfiguration := TAmazonEmailServiceConfiguration.Create;
end;

procedure TAmazonEmailServiceConfigurationTests.TearDown;
begin
  FAmazonEmailServiceConfiguration.Free;
end;

initialization
  TDUnitX.RegisterTestFixture(TAmazonEmailServiceConfigurationTests);

end.
