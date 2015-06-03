unit AmazonEmailAuthentication;

interface

uses
  Data.Cloud.CloudAPI;

type
  TAmazonEmailAuthentication = class(TCloudSHA256Authentication)
  public
    constructor Create(ConnectionInfo: TCloudConnectionInfo); overload;
    function BuildAuthorizationString(const StringToSign: string): string; override;
  end;

implementation

function TAmazonEmailAuthentication.BuildAuthorizationString(const StringToSign: string): string;
begin
  Result := EncodeBytes64(SignString(StringToSign));
end;

constructor TAmazonEmailAuthentication.Create(ConnectionInfo: TCloudConnectionInfo);
begin
  inherited Create(ConnectionInfo, 'AWS3');
end;

end.
