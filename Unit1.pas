unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.ActnMan, Vcl.ActnCtrls, System.Actions, Vcl.ActnList, System.ImageList,
  Vcl.ImgList, Vcl.ExtCtrls;

type
  TMainForm = class(TForm)
    ActionList: TActionList;
    actNew: TAction;
    actOpen: TAction;
    actSave: TAction;
    actSaveAs: TAction;
    actSaveAll: TAction;
    actExit: TAction;
    actUndo: TAction;
    actRedo: TAction;
    actCut: TAction;
    actCopy: TAction;
    actDelete: TAction;
    actRun: TAction;
    actStepOver: TAction;
    actDijkstra: TAction;
    actInWidth: TAction;
    actInHeight: TAction;
    MainMenu: TMainMenu;
    mniFile: TMenuItem;
    mniNew: TMenuItem;
    mniOpen: TMenuItem;
    mniSaveAll: TMenuItem;
    mniSaveAs: TMenuItem;
    mniExit: TMenuItem;
    actSave1: TMenuItem;
    mniN1: TMenuItem;
    mniExit1: TMenuItem;
    mniEdit: TMenuItem;
    mniUndo: TMenuItem;
    mniRedo: TMenuItem;
    mniN2: TMenuItem;
    N1: TMenuItem;
    mniCut: TMenuItem;
    mniCopy: TMenuItem;
    mniDelete: TMenuItem;
    mniRun: TMenuItem;
    mniRun1: TMenuItem;
    mniStepOver: TMenuItem;
    mniAlgorithm: TMenuItem;
    mniDijkstra: TMenuItem;
    mniInWidth: TMenuItem;
    mniInHeight: TMenuItem;
    toolBar: TToolBar;
    btnOpen: TToolButton;
    btnSave: TToolButton;
    btnRun: TToolButton;
    btnStepOver: TToolButton;
    btnNew: TToolButton;
    btnsp1: TToolButton;
    dlgOpen: TOpenDialog;
    mainImageList: TImageList;
    mainImage: TImage;
    actAddVertex: TAction;
    actDeleteVertex: TAction;
    btnSp2: TToolButton;
    dlgSave: TSaveDialog;
    btnAddVertex: TToolButton;
    btnDeleteVertex: TToolButton;
    btnSp3: TToolButton;
    btnAddEdge: TToolButton;
    btnDeleteEdge: TToolButton;
    actAddEdge: TAction;
    actDeleteEdge: TAction;
    procedure actNewExecute(Sender: TObject);
    procedure btnStepOverClick(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
    procedure actOpenExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actSaveAsExecute(Sender: TObject);
    procedure actSaveAllExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure ActionListUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure FormPaint(Sender: TObject);
    procedure mainImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnAddVertexMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    FCanOpenFiles: Boolean;
    FIsSelected: TMenuItem;
    FIsCanPaint: Boolean;
    FX, FY: Integer;
    Counter: Integer;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.actExitExecute(Sender: TObject);
begin
  ShowMessage('Exit');
end;

procedure TMainForm.ActionListUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
   actNew.Enabled := True;
   mniDijkstra.Enabled := True;
   mniInWidth.Enabled := True;
   mniInHeight.Enabled := True;
   btnAddVertex.Enabled := True;
end;

procedure TMainForm.actNewExecute(Sender: TObject);
begin

  ShowMessage('New file is chnged');
end;

procedure TMainForm.actOpenExecute(Sender: TObject);
begin
  if not dlgOpen.Execute then
  Begin
    ShowMessage('Files are not selected!');
    Exit;
  End;

  ShowMessage('Selected files: ' + IntToStr(dlgOpen.Files.Count));
end;

procedure TMainForm.actSaveAllExecute(Sender: TObject);
begin
  ShowMessage('File saved all');
end;

procedure TMainForm.actSaveAsExecute(Sender: TObject);
begin
  ShowMessage('File saved as');
end;

procedure TMainForm.actSaveExecute(Sender: TObject);
begin
  if (not dlgSave.Execute) then ShowMessage('File are not saved')
  else ShowMessage('File saved');
end;

procedure TMainForm.btnAddVertexMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if ((X > 0) and (Y > 0)) and (Button = mbLeft) then
  Begin
    FIsCanPaint := True;
  End;

  if (Button = mbRight) then
  Begin

  End;
end;

procedure TMainForm.btnRunClick(Sender: TObject);
begin
  ShowMessage('Algorithm is started');
end;

procedure TMainForm.btnStepOverClick(Sender: TObject);
begin
  ShowMessage('Tracing is started');
end;

{ Test }
procedure TMainForm.FormPaint(Sender: TObject);
var
  R,rm : integer;
  n,i : integer;
  x,y : integer;

begin
  if (FIsCanPaint) then
  Begin
    Inc(counter);
    mainImage.Canvas.Brush.Color := clWhite;
    //mainImage.Canvas.FillRect(Canvas.ClipRect);    //��������

    R := 40;
    rm := 5;
    mainImage.Canvas.Ellipse(FX-R,FY-R,FX+R,FY+R);
    mainImage.Canvas.TextOut(FX-4,FY-8, IntToStr(counter));

    n := 8;
    for i:=1 to n do
    begin
      x := round(FX+R*cos(i*2*pi/n));
      y := round(FY+R*sin(i*2*pi/n));
      mainImage.Canvas.Ellipse(x-rm,y-rm,x+rm,y+rm);
    end;
  end;

  FIsCanPaint := False;
end;

procedure TMainForm.mainImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (FIsCanPaint) then
  Begin
    FX := X;
    FY := Y;

    FormPaint(mainImage);
  End;

  if (Button = mbRight) then ShowMessage('Right');
end;

end.