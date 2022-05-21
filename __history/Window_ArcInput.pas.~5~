unit Window_ArcInput;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TWindow_Input = class(TForm)
    pnlTopPanel: TPanel;
    lbledtWeight: TLabeledEdit;
    pnlButtomPanel: TPanel;
    btnOk: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOkMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnOkKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
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

procedure TWindow_Input.btnOkKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
const
  Enter = 13;
begin
  if (Key = Enter) then
    Window_Input.DoExit;
end;

procedure TWindow_Input.btnOkMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Error: Integer;

begin
  Val(lbledtWeight.Text, Weight, Error);
  if (Error <> 0) or (Weight <= 0)then Weight := 1;

  lbledtWeight.Text := '';
  if (Sender = btnOk) then Close;

end;

procedure TWindow_Input.FormCreate(Sender: TObject);
begin
  Weight := 1;
end;

procedure TWindow_Input.FormShow(Sender: TObject);
begin
  lbledtWeight.SetFocus;
end;

end.
