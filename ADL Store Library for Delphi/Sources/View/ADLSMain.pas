/// <summary>
///   From Microsoft Docs: Azure Data Lake Store is an enterprise-wide
///   hyper-scale repository for big data analytic workloads. Azure Data Lake
///   enables you to capture data of any size, type, and ingestion speed in one
///   single place for operational and exploratory analytics
/// </summary>
/// <remarks>
///   Some useful links:
///   <list type="bullet">
///     <item>
///       <see href="https://docs.microsoft.com/en-us/azure/data-lake-store/data-lake-store-overview">
///       Overview of Azure Data Lake Store</see>
///     </item>
///   </list>
/// </remarks>
unit ADLSMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, ADLSConnector.Interfaces, ADLSConnector.Presenter,
  ADLSFileManager.Interfaces, ADLSFileManager.Presenter, IPPeerClient,
  REST.Response.Adapter, REST.Client, Data.Bind.Components, Data.Bind.ObjectScope,
  Vcl.ComCtrls, Vcl.Imaging.pngimage;

type
  TfrmADLSMain= class(TForm, IADLSConnector, IADLSFileManager)
    pnlHeader: TPanel;
    pnlResponse: TPanel;
    pgcMain: TPageControl;
    tsConnector: TTabSheet;
    tsFileManager: TTabSheet;
    sbConnector: TScrollBox;
    edt_Connector_AccessTokenEndpoint: TLabeledEdit;
    edt_Connector_ClientID: TLabeledEdit;
    edt_Connector_ClientSecret: TLabeledEdit;
    edt_Connector_AccessToken: TLabeledEdit;
    edt_Connector_AuthCode: TLabeledEdit;
    edt_Connector_BaseURL: TLabeledEdit;
    edt_Connector_AuthorizationEndpoint: TLabeledEdit;
    edt_FilePath: TLabeledEdit;
    edt_FileManager_BaseURL: TLabeledEdit;
    btnGetToken: TButton;
    btnOpenFile: TButton;
    btnUpload: TButton;
    odSelectFile: TOpenDialog;
    imgAzureDataLake: TImage;
    memoResponseData: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure btnGetTokenClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnOpenFileClick(Sender: TObject);
    procedure btnUploadClick(Sender: TObject);
  private
    FADLSConnectorPresenter: TADLSConnectorPresenter;
    FADLSFileManagerPresenter: TADLSFileManagerPresenter;
  public
    // Input connector
    function GetBaseURL: string;
    function GetClientID: string;
    function GetClientSecret: string;
    function GetAccessTokenEndpoint: string;
    function GetAuthorizationEndpoint: string;
    // Input file manager
    function GetFMFilePath: string;
    function GetFMBaseURL: string;
    // Output connector
    procedure SetAccessToken(const AValue: string);
    procedure SetResponseData(const AValue: string);
    procedure AddResponseData(const AValue: string);
  end;

var
  frmADLSMain: TfrmADLSMain;

implementation

{$R *.dfm}

{ TfrmADLSConnector }

procedure TfrmADLSMain.AddResponseData(const AValue: string);
begin
  memoResponseData.Lines.Add(AValue);
end;

procedure TfrmADLSMain.btnGetTokenClick(Sender: TObject);
begin
  FADLSConnectorPresenter.GetAccessToken;
end;

procedure TfrmADLSMain.btnOpenFileClick(Sender: TObject);
begin
  odSelectFile.Filter := 'JSON and TXT files (*.json; *.txt)|*.json; *.txt';
  odSelectFile.FilterIndex := 2;
  if odSelectFile.Execute then
    edt_FilePath.Text := odSelectFile.FileName;
end;

procedure TfrmADLSMain.btnUploadClick(Sender: TObject);
begin
  FADLSFileManagerPresenter.UploadFile;
end;

procedure TfrmADLSMain.Button1Click(Sender: TObject);
begin
  FADLSFileManagerPresenter.GetListFolders;
end;

procedure TfrmADLSMain.FormCreate(Sender: TObject);
begin
  FADLSConnectorPresenter := TADLSConnectorPresenter.Create(Self);
  FADLSFileManagerPresenter := TADLSFileManagerPresenter.Create(FADLSConnectorPresenter, Self);
end;

function TfrmADLSMain.GetAccessTokenEndpoint: string;
begin
  Result := edt_Connector_AccessTokenEndpoint.Text;
end;

function TfrmADLSMain.GetAuthorizationEndpoint: string;
begin
  Result := edt_Connector_AuthorizationEndpoint.Text
end;

function TfrmADLSMain.GetBaseURL: string;
begin
  Result := edt_Connector_BaseURL.Text;
end;

function TfrmADLSMain.GetClientID: string;
begin
  Result := edt_Connector_ClientID.Text;
end;

function TfrmADLSMain.GetClientSecret: string;
begin
  Result := edt_Connector_ClientSecret.Text;
end;

function TfrmADLSMain.GetFMBaseURL: string;
begin
  Result := edt_FileManager_BaseURL.Text;
end;

function TfrmADLSMain.GetFMFilePath: string;
begin
  Result := edt_FilePath.Text
end;

procedure TfrmADLSMain.SetAccessToken(const AValue: string);
begin
  edt_Connector_AccessToken.Text := AValue;
end;

procedure TfrmADLSMain.SetResponseData(const AValue: string);
begin
  memoResponseData.Lines.Text := AValue;
end;

end.
