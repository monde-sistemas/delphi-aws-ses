# delphi-aws-ses

Amazon Simple Email (Amazon SES) library for Delphi applications.

[Amazon SES](http://docs.aws.amazon.com/ses/latest/DeveloperGuide/Welcome.html) is an outbound-only email-sending service that provides an easy, cost-effective way for you to send email.

## Features

  * Send emails through Amazon SES
  * The email body can be sent in the formats HTML and Plain Text

## Using

```pascal
const
  FAKE_AWS_ACCESS_KEY = 'AKIAJQF6P3QUHRSJPZCA_EXAMPLE';
  FAKE_AWS_SECRET_KEY = 'BeVo2wwiGIg25t4jKxsqmzS3ljSxrdZfl/SJ+32K_EXAMPLE';
var
  AmazonEmailService: TAmazonEmailService;
  Recipients: TStrings;
  FromAddress, Subject, MessageBody: string;
begin
  Recipients := TStringList.Create;
  Recipients.Add('email@mail.com');
  FromAddress := 'email@mail.com';
  Subject := 'This is the subject line with HTML.';
  MessageBody := 'Hello. I hope you are having a good day.';

  AmazonEmailService := TAmazonEmailService.Create(USWest, FAKE_AWS_ACCESS_KEY, FAKE_AWS_SECRET_KEY);
  try
    AmazonEmailService.SendMail(Recipients, FromAddress, Subject, MessageBody);
  finally
    AmazonEmailService.Free;
  end;
end;
```

### Aws Regions

To reduce network latency, it's a good idea to choose an endpoint closest to your application.

Aws Regions | Region name | API (HTTPS) endpoint
------------ | ------------ | -------------
`USEast` | US East (N. Virginia) | email.us-east-1.amazonaws.com
`USWest` | US West (Oregon) | email.us-west-2.amazonaws.com
`EUIreland` | EU (Ireland) | email.eu-west-1.amazonaws.com

### Email Body

**Declaration:** `TEmailBody = (eHTML, eText);`

The email body can be sent in the following formats:

  * HTML - If the recipient's email client can interpret HTML, the body can include formatted text and hyperlinks
  * Plain text - If the recipient's email client is text-based, the body must not contain any nonprintable characters.

By default, the email will have HTML-enabled. To use text-based email will need you to set the EmailBody parameter values to `eText`.

### Response Info

It's also possible to get the response information, setting as a parameter to the SendMail method a variable of type TCloudResponseInfo.

```pascal
var
  ResponseInfo: TCloudResponseInfo;
begin
  // ...
  AmazonEmailService.SendMail(Recipients, FromAddress, Subject, MessageBody, ResponseInfo);
  // ...
```

For example, if the email was sent successfully will be returned:

```
Response.StatusCode = 200
Response.StatusMessage = 'HTTP/1.1 200 OK'
```

## Executing the tests

**Dependencies:** [DunitX](https://github.com/VSoftTechnologies/DUnitX/)

  * Clone the [DunitX](https://github.com/VSoftTechnologies/DUnitX/) repository locally
  * Define a `DUNITX` environment variable, pointing to the DunitX clone directory.

## Contributing

If you got something that's worth including into the project please [submit a Pull Request](https://github.com/monde-sistemas/delphi-aws-ses/pulls) or [open an issue](https://github.com/monde-sistemas/delphi-aws-ses/issues) for further discussion.

## License

This software is open source, licensed under the The MIT License (MIT). See [LICENSE](https://github.com/monde-sistemas/delphi-aws-ses/blob/master/LICENSE) for details.
