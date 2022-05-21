unit Window_mbRightClick;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ButtonGroup;

type
  TForm1 = class(TForm)
    btn1: TButton;
    btn2: TButton;
    btn3: TButton;
    btn4: TButton;
    btn5: TButton;
    btn6: TButton;
    btn7: TButton;
    btn8: TButton;
    btn9: TButton;
    btn10: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure mbRightClickWindow_Open(var AmbRightClickWindow: TForm1);
    procedure mbRightClickWindow_Close(var AmbRightClickWindow: TForm1);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{ TForm1 }

procedure TForm1.mbRightClickWindow_Open(var AmbRightClickWindow: TForm1);
begin
  if (AmbRightClickWindow = nil) then
  begin
    Application.CreateForm(TForm1, AmbRightClickWindow);
    AmbRightClickWindow.Show;
  end;
end;

procedure TForm1.mbRightClickWindow_Close(var AmbRightClickWindow: TForm1);
begin
  if (AmbRightClickWindow <> nil) then
  begin
    AmbRightClickWindow.Close;
    FreeAndNil(AmbRightClickWindow);
  end;
end;
end.
