program Playground;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Classes,
  Data.Cloud.CloudAPI,
  AmazonEmailService in '..\AmazonEmailService.pas',
  PrepareRequestSignature in '..\PrepareRequestSignature.pas',
  AmazonEmailAuthentication in '..\AmazonEmailAuthentication.pas',
  EncodeQueryParams in '..\EncodeQueryParams.pas',
  PopulateResponseInfo in '..\PopulateResponseInfo.pas',
  AmazonEmailServiceRegions in '..\AmazonEmailServiceRegions.pas',
  AmazonEmailServiceHeaders in '..\AmazonEmailServiceHeaders.pas';

const
  AWS_ACCESS_KEY = 'AKIAJQF6P3QUHRSJPZCA';
  AWS_SECRET_KEY = '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';
var
  AmazonEmailService: TAmazonEmailService;
  Recipients: TStrings;
  FromAddress, Subject, MessageBody: string;
  Response: TCloudResponseInfo;
begin
  Recipients := TStringList.Create;
  Recipients.Add('martinusso@gmail.com');
  FromAddress := 'martinusso@gmail.com';
  Subject := 'This is the subject line with HTML.';
//  MessageBody := 'Hello. I hope you are having a good day.';
  MessageBody := '<!DOCTYPE html>' +
    '<html>' +
    '<body>' +
    '<p>' +
    'This is an email link:' +
    '<a href="mailto:someone@example.com?Subject=Hello%20again" target="_top">Send Mail</a>' +
    '</p>' +
    '<p>' +
    '<b>Note:</b> Spaces between words should be replaced by %20 to ensure that the browser will display the text properly.' +
    '</p>' +
    '</body>' +
    '</html>';
  try
    AmazonEmailService := TAmazonEmailService.Create(USWest, AWS_ACCESS_KEY, AWS_SECRET_KEY);
    try
      AmazonEmailService.SendMail(Recipients, FromAddress, Subject, MessageBody, Response);
    finally
      Writeln('Code: ' + IntToStr(Response.StatusCode));
      Writeln('Message: ' + Response.StatusMessage);
      AmazonEmailService.Free;
    end;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;
end.

