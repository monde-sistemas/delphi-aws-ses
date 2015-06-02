unit PopulateResponseInfo;

interface

uses
  Data.Cloud.CloudAPI,
  IPPeerAPI;

type
  TPopulateResponseInfo = class
  public
    procedure FromPeer(const ResponseInfo: TCloudResponseInfo; const Peer: IIPHTTP); overload;
    procedure FromExceptionPeer(const ResponseInfo: TCloudResponseInfo; const ExceptionPeer: EIPHTTPProtocolExceptionPeer); overload;
  end;

implementation

uses
  Classes,
  SysUtils,
  XmlIntf,
  XmlDoc;

{ TPopulateResponseInfo }

procedure TPopulateResponseInfo.FromExceptionPeer(const ResponseInfo: TCloudResponseInfo;
  const ExceptionPeer: EIPHTTPProtocolExceptionPeer);
const
  NODE_ERRORS = 'Errors';
  NODE_ERROR = 'Error';
  NODE_ERROR_MESSAGE = 'Message';
  NODE_ERROR_CODE = 'Code';
  NODE_REQUEST_ID = 'RequestId';
  NODE_RESPONSE_METADATA = 'ResponseMetadata';
var
  XmlDoc: IXMLDocument;
  IsErrors: Boolean;
  Aux, ErrorNode, MessageNode: IXMLNode;
  ErrorCode, ErrorMsg: string;
begin
  if ExceptionPeer.ErrorMessage = EmptyStr then
    Exit;

  XmlDoc := TXMLDocument.Create(nil);
  XmlDoc.LoadFromXML(ExceptionPeer.ErrorMessage);

  ResponseInfo.StatusCode := ExceptionPeer.ErrorCode;
  ResponseInfo.StatusMessage := ExceptionPeer.Message;

  IsErrors := AnsiPos(Format('<%s>', [NODE_ERRORS]), ExceptionPeer.ErrorMessage) > 0;

  //Parse the error and update the ResponseInfo StatusMessage
  if IsErrors or (AnsiPos('<ErrorResponse', ExceptionPeer.ErrorMessage) > 0) then
  begin
    //Amazon has different formats for returning errors as XML
    if IsErrors then
    begin
      ErrorNode := xmlDoc.DocumentElement.ChildNodes.FindNode(NODE_ERRORS);
      ErrorNode := ErrorNode.ChildNodes.FindNode(NODE_ERROR);
    end
    else
      ErrorNode := xmlDoc.DocumentElement.ChildNodes.FindNode(NODE_ERROR);

    if (ErrorNode <> nil) and (ErrorNode.HasChildNodes) then
    begin
      MessageNode := ErrorNode.ChildNodes.FindNode(NODE_ERROR_MESSAGE);

      if (MessageNode <> nil) then
        ErrorMsg := MessageNode.Text;

      if ErrorMsg <> EmptyStr then
      begin
        //Populate the error code
        Aux := ErrorNode.ChildNodes.FindNode(NODE_ERROR_CODE);
        if (Aux <> nil) then
          ErrorCode := Aux.Text;
        ResponseInfo.StatusMessage := Format('%s - %s (%s)', [ResponseInfo.StatusMessage, ErrorMsg, ErrorCode]);
      end;
    end;

    //populate the RequestId, which is structured differently than if this is not an error ResponseInfo
    Aux := xmlDoc.DocumentElement.ChildNodes.FindNode(NODE_REQUEST_ID);
    if (Aux <> nil) and (Aux.IsTextElement) then
    begin
      if not Assigned(ResponseInfo.Headers) then
        ResponseInfo.Headers := TStringList.Create;
      ResponseInfo.Headers.Values[NODE_REQUEST_ID] := Aux.Text;
    end;
  end
  //Otherwise, it isn't an error, but try to pase the RequestId anyway.
  else
  begin
    Aux := xmlDoc.DocumentElement.ChildNodes.FindNode(NODE_RESPONSE_METADATA);
    if Aux <> nil then
    begin
      Aux := Aux.ChildNodes.FindNode(NODE_REQUEST_ID);
      if Aux <> nil then
        if not Assigned(ResponseInfo.Headers) then
          ResponseInfo.Headers := TStringList.Create;
        ResponseInfo.Headers.Values[NODE_REQUEST_ID] := Aux.Text;
    end;
  end;
end;

procedure TPopulateResponseInfo.FromPeer(const ResponseInfo: TCloudResponseInfo; const Peer: IIPHTTP);
begin
  ResponseInfo.StatusCode := Peer.ResponseCode;
  ResponseInfo.StatusMessage := Peer.ResponseText;
end;

end.
