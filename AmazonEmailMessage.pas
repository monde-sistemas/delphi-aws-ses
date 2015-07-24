unit AmazonEmailMessage;

interface

type
  TBodyType = (btHTML, btText);

  TEmailMessage = record
    FromName: string;
    FromAddress: string;
    Recipients: TArray<string>;
    ReplyTo: TArray<string>;
    CC: TArray<string>;
    BCC: TArray<string>;
    Subject: string;
    Body: string;
    BodyType: TBodyType;
  end;

implementation

end.
