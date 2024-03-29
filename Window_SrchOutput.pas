unit Window_SrchOutput;

{ A form displaying the results of the performed algorithms }

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils,
  System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, Graph_Algorithms, Vcl.ComCtrls;

type
  TfrmSrchOutput = class(TForm)
    pnlTopPanel: TPanel;
    lblTopLabel: TLabel;
    procedure FormShow(Sender: TObject; APrBar: TProgressBar); overload;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    FClose: Boolean;
    procedure SetClose(const Value: Boolean);
    { Private declarations }
  public
    { Public declarations }
    Info: TInfo;
    FProgressBar: TProgressBar;
    property isClose: Boolean read FClose write SetClose;
    procedure SetPBar(AClose: Boolean; AProgressBar: TProgressBar);
  end;

var
  frmSrchOutput: TfrmSrchOutput;

implementation

{$R *.dfm}

{ TForm1 }

procedure TfrmSrchOutput.FormClose(Sender: TObject; var Action: TCloseAction);
{ Zeroing values }
begin
  FProgressBar.Position := 0;
end;

procedure TfrmSrchOutput.FormShow(Sender: TObject; APrBar: TProgressBar);
{ Showing the result }
const
  NL = #10#13;

var
  ResString: string;

begin
  Info.PatchString := NL + Info.PatchString;
  ResString := 'Searched way: %s' + NL;
  ResString := ResString + 'Quantity of arc in the way: %d' + NL;
  ResString := ResString + 'Length of cearched way: %d' + NL;
  ResString := ResString + 'Quatity of visits: %d' + NL;

  with Info do
  begin
    lblTopLabel.Caption := Format(ResString, [PatchString, ArcsCount, Distans,
      VisitsCount]);
  end;

  FProgressBar := APrBar;
end;

procedure TfrmSrchOutput.SetClose(const Value: Boolean);
{ Return Info about closing form }
begin
  FClose := Value;
end;

procedure TfrmSrchOutput.SetPBar(AClose: Boolean; AProgressBar: TProgressBar);
{ Zeroing progress bar position }
begin
  AClose := isClose;
  if (AClose) then AProgressBar.Position := 0;
end;

end.
