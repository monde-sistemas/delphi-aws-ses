unit PrepareRequestSignature;

interface

uses
  Data.Cloud.CloudAPI;

type
  TPrepareRequestSignature = class
  private
    FConnectionInfo: TCloudConnectionInfo;
  public
    constructor Create(AWSAccessKey, AWSSecretKey: string);
    destructor Destroy; override;

    function GetSignature(const StringToSign: string): string;
  end;

implementation

uses
  AmazonEmailAuthentication;

constructor TPrepareRequestSignature.Create(AWSAccessKey, AWSSecretKey: string);
begin
  FConnectionInfo := TCloudConnectionInfo.Create(nil);
  FConnectionInfo.AccountName := AWSAccessKey;
  FConnectionInfo.AccountKey := AWSSecretKey;
end;

destructor TPrepareRequestSignature.Destroy;
begin
  if Assigned(FConnectionInfo) then
    FConnectionInfo.Free;
  inherited;
end;

function TPrepareRequestSignature.GetSignature(const StringToSign: string): string;
var
  AmazonEmailAuthentication: TAmazonEmailAuthentication;
begin
  AmazonEmailAuthentication := TAmazonEmailAuthentication.Create(FConnectionInfo);
  try
    Result := AmazonEmailAuthentication.BuildAuthorizationString(StringToSign);
  finally
    AmazonEmailAuthentication.Free;
  end;
end;

end.
