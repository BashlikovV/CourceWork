unit Window_ArcInput;

{ A form that provides the user with the ability
  to enter the weight of the arc }

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TWindow_Input = class(TForm)
    pnlButtomPanel: TPanel;
    btnOk: TButton;
    btnCancel: TButton;
    pnlTopPanel: TPanel;
    lbledtWeight: TLabeledEdit;
    procedure FormShow(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Weight: Integer;
  end;

var
  Window_Input: TWindow_Input;

implementation

{$R *.dfm}

procedure TWindow_Input.btnCancelClick(Sender: TObject);
{ Skip changes }
begin
  ModalResult := mrCancel;
end;

procedure TWindow_Input.btnOkClick(Sender: TObject);
{ Share changes }
var
  Error: Integer;

begin
  Val(lbledtWeight.Text, Weight, Error);
  if (Error <> 0) or (Weight <= 0)then Weight := 1;

  lbledtWeight.Text := '';
  if (Sender = btnOk) then Close;

  ModalResult := mrOk;
end;

procedure TWindow_Input.FormShow(Sender: TObject);
{ initializing values }
begin
  lbledtWeight.SetFocus;
  Weight := 1;
  lbledtWeight.Text := '';
end;

end.
