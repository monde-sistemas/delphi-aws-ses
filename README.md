# delphi-aws-ses

Amazon Simple Email (Amazon SES) library for Delphi applications.

[Amazon SES](http://docs.aws.amazon.com/ses/latest/DeveloperGuide/Welcome.html) is an outbound-only email-sending service that provides an easy, cost-effective way for you to send email.

## Features

  * Send emails through Amazon SES
  * The email body can be sent in the formats HTML and Plain Text

## Using

### Using with configuration from environment

A option is to get configuration from environment variables, and keep the keys out of the code.

It is easy to accomplish this, simply create the three following environment variables: `AWS_REGION`, `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`. Internally, the Access Keys and Region Endpoint will be assigned from the environment variables.

```pascal
var
  AmazonEmailService: TAmazonEmailService;
  Recipients: TStrings;
  FromAddress, Subject, MessageBody: string;
begin
  Recipients := TStringList.Create;
  try
    Recipients.Add('email@mail.com');
    FromAddress := 'email@mail.com';
    Subject := 'This is the subject line with HTML.';
    MessageBody := 'Hello. I hope you are having a good day.';

    AmazonEmailService := TAmazonEmailService.Create;
    try
      AmazonEmailService.SendMail(Recipients, FromAddress, Subject, MessageBody);
    finally
      AmazonEmailService.Free;
    end;
  finally
    Recipients.Free;
  end;
end;
```

### Using with method parameters

You may also pass parameters to the constructor method:

```pascal
const
  AWS_REGION = 'email.us-west-2.amazonaws.com';
  AWS_ACCESS_KEY_ID = 'AKIAJQF6P3QUHRSJPZCA_EXAMPLE';
  AWS_SECRET_ACCESS_KEY = 'BeVo2wwiGIg25t4jKxsqmzS3ljSxrdZfl/SJ+32K_EXAMPLE';
  // ...
  AmazonEmailService := TAmazonEmailService.Create(AWS_REGION, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY);
  // ...
```

### Aws Regions

To reduce network latency, it's a good idea to choose an endpoint closest to your application.

Region name | API (HTTPS) endpoint
------------ | -------------
US East (N. Virginia) | `email.us-east-1.amazonaws.com`
US West (Oregon) | `email.us-west-2.amazonaws.com`
EU (Ireland) | `email.eu-west-1.amazonaws.com`

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
