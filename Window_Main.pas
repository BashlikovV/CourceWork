unit Window_Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Types, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ComCtrls, Vcl.ToolWin,
  Vcl.ActnMan, Vcl.ActnCtrls, System.Actions, Vcl.ActnList, System.ImageList,
  Vcl.ImgList, Vcl.ExtCtrls, Graph_Edit, Graph_Drawing, Window_ArcInput,
  Vcl.StdCtrls, Vcl.Buttons, Algorithms, Window_SrchOutput, Vcl.WinXCtrls;

type
  TCanvasState = (stAddVertice, stAddArc, stDeleteVertice, stDeleteArc, stMove,
                  stDFS, stBFS, stDijkstra, stNone, stUndo, stRedo);

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
    actAddVertex: TAction;
    actDeleteVertex: TAction;
    btnSp2: TToolButton;
    dlgSave: TSaveDialog;
    btnDeleteVertex: TToolButton;
    btnSp3: TToolButton;
    btnAddEdge: TToolButton;
    btnDeleteEdge: TToolButton;
    actAddEdge: TAction;
    actDeleteEdge: TAction;
    pnlProgressPanel: TPanel;
    pbProgressBar: TProgressBar;
    pmMainPopUpMenu: TPopupMenu;
    actDeleteEdge1: TMenuItem;
    actDeleteVertex1: TMenuItem;
    N2: TMenuItem;
    actDijkstra1: TMenuItem;
    actInHeight1: TMenuItem;
    actInWidth1: TMenuItem;
    pbCanvas: TPaintBox;
    N3: TMenuItem;
    N4: TMenuItem;
    btnAddVertex: TToolButton;
    actAddVertex1: TMenuItem;
    actClear: TAction;
    btnsp4: TToolButton;
    btnClear: TToolButton;
    tglswtch1: TToggleSwitch;
    btn1: TToolButton;
    procedure actNewExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pbCanvasClick(Sender: TObject);
    procedure pbCanvasMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbCanvasMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure pbCanvasMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pbCanvasPaint(Sender: TObject);
    procedure chkTopBoxClick(Sender: TObject);
    procedure btnSpeedButtonClick(Sender: TObject);
    procedure btnAddEdgeClick(Sender: TObject);
    procedure btnDeleteVertexClick(Sender: TObject);
    procedure btnDeleteEdgeClick(Sender: TObject);
    procedure pbCanvasDblClick(Sender: TObject);
    procedure actUndoExecute(Sender: TObject);
    procedure actRedoExecute(Sender: TObject);
    procedure btnAddVertexClick(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
    procedure Search_Start(AState: TCanvasState; v, u: Integer);
    procedure actClearExecute(Sender: TObject);
    procedure actOpenExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure tglswtch1Click(Sender: TObject);
  private
    { Private declarations }
    FGraph: TGraph;
    FGraphType: Boolean;
    FState: TCanvasState;
    FActiveVertice: TPVertice;
    FVertStack: TVertStack;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.actClearExecute(Sender: TObject);
begin
  FGraph.Order := 0;
  Graph_Delete(FGraph);
  pbCanvasPaint(Sender);
end;

procedure TMainForm.actExitExecute(Sender: TObject);
begin
  ShowMessage('Exit');
  Graph_Delete(FGraph);
end;

procedure TMainForm.actNewExecute(Sender: TObject);
begin
  //...
end;

procedure TMainForm.actOpenExecute(Sender: TObject);
var
  VerFileName, ArcFileName: string;

begin
  MessageBox(MainForm.Handle, 'Выберите файл вершин (*.ver)', 'VerFileName', MB_OK);
  dlgOpen.Execute();
  VerFileName := ExtractFileName(dlgOpen.FileName);

  MessageBox(MainForm.Handle, 'Выберите файл ребер (*.arc)', 'ArcFileName', MB_OK);
  dlgOpen.Execute();
  ArcFileName := ExtractFileName(dlgOpen.FileName);

  Graph_Open(FGraph, VerFileName, ArcFileName);

  pbCanvasPaint(Sender);
end;

procedure TMainForm.actRedoExecute(Sender: TObject);
begin
  FState := stRedo;
  pbCanvasClick(Sender);
end;

procedure TMainForm.actSaveExecute(Sender: TObject);
var
  VerFileName, ArcFileName: string;

begin
  dlgSave.Execute();
  VerFileName := dlgSave.FileName + '.Vert';
  ArcFileName := VerFileName + '.Arc';
  Graph_Save(FGraph, VerFileName, ArcFileName);
end;

procedure TMainForm.actUndoExecute(Sender: TObject);
begin
  FState := stUndo;
  pbCanvasClick(Sender);
end;

procedure TMainForm.btnAddEdgeClick(Sender: TObject);
begin
  FState := stAddArc;
  btnDeleteEdge.Enabled := True;
  btnRun.Enabled := True;
end;

procedure TMainForm.btnAddVertexClick(Sender: TObject);
begin
  FState := stAddVertice;
  btnAddEdge.Enabled := True;
  btnDeleteVertex.Enabled := True;
end;

procedure TMainForm.btnDeleteEdgeClick(Sender: TObject);
begin
  FState := stDeleteArc;
end;

procedure TMainForm.btnDeleteVertexClick(Sender: TObject);
begin
  FState := stDeleteVertice;
end;

procedure TMainForm.btnRunClick(Sender: TObject);
begin
  FState := stDijkstra;
  pbCanvasClick(Sender);
end;

procedure TMainForm.btnSpeedButtonClick(Sender: TObject);
begin
  if (FGraph.isPainted) then
  begin
    Vertce_MakePassive(FGraph);
    pbCanvas.Invalidate;
  end
  else if (FActiveVertice <> nil) then
  begin
    FActiveVertice.Style := stPassive;
    FActiveVertice := nil;
    pbCanvas.Invalidate;
  end;
  if (Sender as TSpeedButton).Down then
    FState := TCanvasState((Sender as TSpeedButton).Tag)
  else
    FState := stNone;
end;

procedure TMainForm.chkTopBoxClick(Sender: TObject);
begin
  Window_Input.Weight := 1;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FState := stNone;
  Graph_Create(FGraph);
  FActiveVertice := nil;

  tglswtch1.StateCaptions.CaptionOff := 'Невзв';
  tglswtch1.StateCaptions.CaptionOn := 'Взв';
end;

procedure TMainForm.pbCanvasClick(Sender: TObject);
var
  Pos: TPoint;
  SelectedVertice: TPVertice;
  Window_MInput: TModalResult;

begin
  if (FGraph.isPainted) then
  begin
    Vertce_MakePassive(FGraph);
  end;

  Pos := ScreenToClient(Mouse.CursorPos);

  case FState of
    stAddVErtice:
      Graph_AddVertice(FGraph, Pos);

    stDeleteVertice:
      begin
        SelectedVertice := Graph_GetVertByPoint(FGraph, Pos);
        if (SelectedVertice <> nil) then
        Begin
          VerticeStack_Push(FVertStack, SelectedVertice);
          Graph_DeleteVertice(FGraph, SelectedVertice.Number);
        End;
      end;

    stUndo:
      begin
        SelectedVertice := Graph_GetLastVert(FGraph);
        if (SelectedVertice <> nil) then
        Begin
          VerticeStack_Push(FVertStack, SelectedVertice);
          Graph_DeleteVertice(FGraph, SelectedVertice.Number);
        End;
      end;

    stRedo:
      begin
        if (FVertStack <> nil) then
        begin
          SelectedVertice := VerticeStack_Pop(FVertStack);
          Graph_AddVertice(FGraph, SelectedVertice.Center);
        end;
      end;

    stAddArc, stDeleteArc, stDFS, stBFS, stDijkstra:
      begin
        SelectedVertice := Graph_GetVertByPoint(FGraph, Pos);
        if (SelectedVertice <> nil) and (FActiveVertice = nil) then
        begin
          FActiveVertice := SelectedVertice;
          FActiveVertice.Style := stActive;
          SelectedVertice := nil;
          pbCanvas.Invalidate;
        end;
        if (FActiveVertice = nil) or (SelectedVertice = nil) then Exit;

        case FState of
          stAddArc:
            begin
              if (FGraphType) then
              begin
                Window_MInput := Window_Input.ShowModal;
                Window_MInput := mrOk;
              end
              else
              begin
                Window_Input.Weight := 1;
                Window_MInput := mrOk;
              end;

              if (Window_MInput = mrOk) then
                Graph_AddEdge(FGraph, FActiveVertice.Number,
                  SelectedVertice.Number, Window_Input.Weight);
            end;

          stDeleteArc:
            begin
              Graph_DeleteEdge(FGraph, FActiveVertice.Number,
                SelectedVertice.Number);
            end;

          stDijkstra:
            begin
              Search_Start(FState, FActiveVertice.Number, SelectedVertice.Number);
            end;
        end;

        if (FActiveVertice.Style = stActive) then
          FActiveVertice.Style := stPassive;
        FActiveVertice := nil;
      end;
  end;

  if (FState = stNone) then
    pbCanvas.Invalidate;

  pbCanvasPaint(Self);
  FState := stNone;
end;

procedure TMainForm.pbCanvasDblClick(Sender: TObject);
begin
  FState := stMove;
end;

procedure TMainForm.pbCanvasMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Pos: TPoint;

begin
  if (FState = stMove) then
  begin
    Pos := ScreenToClient(Mouse.CursorPos);
    FActiveVertice := Graph_GetVertByPoint(FGraph, Pos);

    if (FActiveVertice <> nil) then
      FActiveVertice.Style := stActive;
  end;
end;

procedure TMainForm.pbCanvasMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  Pos: TPoint;

begin
  if (FState = stMove) and (FActiveVertice <> nil) then
  begin
    Pos := ScreenToClient(Mouse.CursorPos);
    FActiveVertice.Center := Pos;
    pbCanvas.Invalidate;
  end;

end;

procedure TMainForm.pbCanvasMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (FState = stMove) then
  begin
    FActiveVertice.Style := stPassive;
    FActiveVertice := nil;
    pbCanvas.Invalidate;
  end;
end;

procedure TMainForm.pbCanvasPaint(Sender: TObject);
var
  i: Integer;
begin
  try
    Graph_Redraw(pbCanvas.Canvas, pbCanvas.Width, pbCanvas.Height, FGraph)
  except
    Graph_Delete(FGraph);
    Graph_Create(FGraph);
    ShowMessage('Error. Graph deleted');
  end;
end;

procedure TMainForm.Search_Start(AState: TCanvasState; v, u: Integer);
var
  Weights: TWeightMatrix;
  AInfo: TInfo;
  fmShowResult: TfrmSrchOutput;

begin
  Weights := GraphStruct_ToMAtrix(FGraph);

  case AState of
    stDijkstra:
      AInfo := Graph_Dijkstra(Weights, v, u);

    //stDFS:
      //...

    //stBFS:
      //...
  end;

  if (AInfo.Patch <> nil) then
  begin
    Vertce_MakeVisited(FGraph, AInfo.Patch);
    frmSrchOutput.Info := AInfo;
    frmSrchOutput.Show;
  end
  else
    MessageBox(MainForm.Handle, 'No way.', 'Info about way', MB_OK);
end;

procedure TMainForm.tglswtch1Click(Sender: TObject);
begin
  if (tglswtch1.State = tssOff) then
    FGraphType := False
  else
  if (tglswtch1.State = tssOn) then
    FGraphType := true;
end;

end.
