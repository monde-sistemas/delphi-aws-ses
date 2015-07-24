# delphi-aws-ses

Amazon Simple Email Service ([AWS SES](http://aws.amazon.com/ses)) library for Delphi applications.

## Using

If you call the class method `TAmazonEmailService.SendMail` the library will look for the following environment variables: `AWS_REGION`, `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`. 

```Delphi
var
  EmailMessage: TEmailMessage;
begin
  EmailMessage.Recipients := TArray<string>.Create('email@example.com', 'email2@example.com');
  EmailMessage.FromName := 'John Doe'
  EmailMessage.FromAddress := 'email@mail.com';
  EmailMessage.Subject := 'This is the subject line with HTML.';
  EmailMessage.Body := 'Hello. I hope you are having a good day.';

  TAmazonEmailService.SendMail(EmailMessage);
end;
```


You may also manually instantiate the class and pass parameters to the constructor method:

```Delphi
var
  AmazonEmailService: TAmazonEmailService;
begin
  // ...
  AmazonEmailService := TAmazonEmailService.Create(AWS_REGION, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY);
  try
    AmazonEmailService.Send(EmailMessage);    
  finally
    AmazonEmailService.Free;
  end;
  
```

### Body Type

**Declaration:** `TBodyType = (btHTML, btText);`

The email body can be sent in the following formats:

  * HTML - If the recipient's email client can interpret HTML, the body can include formatted text and hyperlinks
  * Plain text - If the recipient's email client is text-based, the body must not contain any nonprintable characters.

By default, the email will have HTML-enabled. To use text-based email will need you to set the EmailBody parameter values to `btText`.

### Response Info

It's also possible to get the response information, setting as a parameter to the SendMail method a variable of type TCloudResponseInfo.

```Delphi
var
  ResponseInfo: TCloudResponseInfo;
begin
  // ...
  TAmazonEmailService.SendMail(EmailMessage, ResponseInfo);
  // ...
```

For example, if the email was sent successfully will be returned:

```Delphi
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
