# delphi-aws-ses

Amazon Simple Email Service ([AWS SES](http://aws.amazon.com/ses)) library for Delphi applications.

## Using

If you call the `TAmazonEmailService.Create` constructor without arguments the library will look for the following environment variables: `AWS_REGION`, `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`. 

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

You may also pass parameters to the constructor method:

```pascal
  // ...
  AmazonEmailService := TAmazonEmailService.Create(AWS_REGION, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY);
  // ...
```

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

```pascal
Response.StatusCode = 200
Response.StatusMessage = 'HTTP/1.1 200 OK'
```

## Executing the tests

You need DUnitX do run the tests.

  * Clone the [DUnitX](https://github.com/VSoftTechnologies/DUnitX/) repository locally
  * Define a `DUNITX` environment variable, pointing to the DUnitX clone directory.

## Contributing

If you got something that's worth including into the project please [submit a Pull Request](https://github.com/monde-sistemas/delphi-aws-ses/pulls) or [open an issue](https://github.com/monde-sistemas/delphi-aws-ses/issues) for further discussion.

## License

This software is open source, licensed under the The MIT License (MIT). See [LICENSE](https://github.com/monde-sistemas/delphi-aws-ses/blob/master/LICENSE) for details.
