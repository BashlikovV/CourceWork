  unit Window_Main;

  { the main form designed to ensure user interaction with the program }

  interface

  uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, System.Types, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ComCtrls, Vcl.ToolWin,
    Vcl.ActnMan, Vcl.ActnCtrls, System.Actions, Vcl.ActnList, System.ImageList,
    Vcl.ImgList, Vcl.ExtCtrls, Graph_Edit, Graph_Drawing, Window_ArcInput,
    Vcl.StdCtrls, Vcl.Buttons, Graph_Algorithms, Window_SrchOutput, Vcl.WinXCtrls, Window_About,
    Vcl.ActnColorMaps;

  type
    TCanvasState = (stAddVertice, stAddArc, stDeleteVertice, stDeleteArc, stMove,
                    stDFS, stBFS, stDijkstra, stNone, stUndo, stRedo, stTrace);
    //TCanvasState - The type that determines the condition of the canvas

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
      mniOpen: TMenuItem;
      mniSaveAll: TMenuItem;
      mniExit: TMenuItem;
      actSave1: TMenuItem;
      mniN1: TMenuItem;
      mniEdit: TMenuItem;
      mniUndo: TMenuItem;
      mniRedo: TMenuItem;
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
      actAbout: TAction;
      About1: TMenuItem;
      actExport: TAction;
      actExport1: TMenuItem;
      N1: TMenuItem;
      actExit1: TMenuItem;
      btn2: TToolButton;
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
      procedure actAboutExecute(Sender: TObject);
      procedure actExportExecute(Sender: TObject);
      procedure btnStepOverClick(Sender: TObject);
      procedure actDijkstraExecute(Sender: TObject);
      procedure actInWidthExecute(Sender: TObject);
      procedure actInHeightExecute(Sender: TObject);
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

  procedure TMainForm.actAboutExecute(Sender: TObject);
  { Show information about program }
  begin
    frmAbout.Show;
  end;

  procedure TMainForm.actClearExecute(Sender: TObject);
  { Cleans the canvas }
  begin
    Graph_Delete(FGraph);
    Graph_Create(FGraph);
    pbCanvas.Invalidate;
  end;

  procedure TMainForm.actDijkstraExecute(Sender: TObject);
  { Changing the state of the canvas }
  begin
    FState := stDijkstra;
  end;

  procedure TMainForm.actExitExecute(Sender: TObject);
  { Shuts down the application }
  begin
    if (MessageBox(MainForm.Handle, 'Do you want to close the program?', '',
      MB_OKCANCEL)) = 1 then
      MainForm.Close;

    Graph_Delete(FGraph);
  end;

  procedure TMainForm.actExportExecute(Sender: TObject);
  { Export graph in PNG }
  var
    BitMap: TBitMap;

  begin
    if (dlgSave.Execute()) then
    begin
      BitMap := TBitmap.Create;
      try
        BitMap.SetSize(pbCanvas.Width,pbCanvas.Height);
        Graph_Redraw(BitMap.Canvas, BitMap.Width, BitMap.Height, FGraph);
        BitMap.SaveToFile(ExtractFileName(dlgSave.FileName));
      finally
        BitMap.Free;
      end;
    end;
  end;

  procedure TMainForm.actInHeightExecute(Sender: TObject);
  { Changing the state of the canvas }
  begin
    FState := stDFS;
  end;

  procedure TMainForm.actInWidthExecute(Sender: TObject);
  { Changing the state of the canvas }
  begin
    FState := stBFS;
  end;

  procedure TMainForm.actOpenExecute(Sender: TObject);
  { opens typed files with graph structure }
  var
    VerFileName, ArcFileName: string;
    NewGraph: TGraph;
    //VerFileName -- Vertex file name
    //ArcFileName -- Edge file name
    //NewGraph -- new variable

  begin
    //Choosing the vertice file
    MessageBox(MainForm.Handle, '�������� ���� ������ (*.ver)', 'VerFileName', MB_OK);
    dlgOpen.Execute();
    VerFileName := dlgOpen.FileName;

    //Choosing the arc file
    MessageBox(MainForm.Handle, '�������� ���� ����� (*.arc)', 'ArcFileName', MB_OK);
    dlgOpen.Execute();
    ArcFileName := dlgOpen.FileName;

    try
      Graph_Open(NewGraph, VerFileName, ArcFileName);
    finally
      btnRun.Enabled := True;
      btnAddVertex.Enabled := True;
      btnClear.Enabled := True;
      btnAddEdge.Enabled := True;
    end;

    Graph_Delete(FGraph);
    FGraph := NewGraph;
    FActiveVertice := nil;
    pbCanvas.Invalidate;


    //Redraw opened graph
    pbCanvasPaint(Sender);  //...?
  end;

  procedure TMainForm.actRedoExecute(Sender: TObject);
  { Ctrl + Shift + Z }
  begin
    FState := stRedo;
    pbCanvasClick(Sender);  //...?
  end;

  procedure TMainForm.actSaveExecute(Sender: TObject);
  { Saves graph structure in typed files }
  var
    VerFileName, ArcFileName: string;
    //VerFileName -- Vertex file name
    //ArcFileName -- Edge file name

  begin
    dlgSave.Execute();
    VerFileName := dlgSave.FileName + '.Ver';
    ArcFileName := VerFileName + '.Arc';
    Graph_Save(FGraph, VerFileName, ArcFileName);
  end;

  procedure TMainForm.actUndoExecute(Sender: TObject);
  { Ctrl + Z }
  begin
    FState := stUndo;
    pbCanvasClick(Sender);  //...?
  end;

  procedure TMainForm.btnAddEdgeClick(Sender: TObject);
  { Adding an edge to a graph }
  begin
    FState := stAddArc;
    btnDeleteEdge.Enabled := True;
    btnRun.Enabled := True;
  end;

  procedure TMainForm.btnAddVertexClick(Sender: TObject);
  { Adding a vertex to a graph }
  begin
    FState := stAddVertice;
    btnAddEdge.Enabled := True;
    btnDeleteVertex.Enabled := True;
  end;

  procedure TMainForm.btnDeleteEdgeClick(Sender: TObject);
  { Removing an edge from a graph }
  begin
    FState := stDeleteArc;
  end;

  procedure TMainForm.btnDeleteVertexClick(Sender: TObject);
  { Removing a vertex from a graph }
  begin
    FState := stDeleteVertice;
  end;

  procedure TMainForm.btnRunClick(Sender: TObject);
  { Launching changed algorithm }
  begin
    pbCanvasClick(Sender);
  end;

  procedure TMainForm.btnStepOverClick(Sender: TObject);
  { Changing the state of the canvas }
  begin
    FState := stTrace;
  end;

  procedure TMainForm.FormCreate(Sender: TObject);
  { Actions when creating a form }
  begin
    FState := stNone;
    Graph_Create(FGraph);
    FActiveVertice := nil;
    About1.Enabled := True;

    { Setting the switch values }
    tglswtch1.StateCaptions.CaptionOff := '�����';
    tglswtch1.StateCaptions.CaptionOn := '���';
  end;

  procedure TMainForm.pbCanvasClick(Sender: TObject);
  { Handler for right-clicking on the canvas }
  var
    Pos: TPoint;
    SelectedVertice: TPVertice;
    WRes: TModalResult;
    //Pos -- Cursor position (X, Y) during click
    //SelectedVertice -- Pointer to the selected vertex
    //Window_MInput -- Edge length input window

  begin
    if (FGraph.isPainted) then
    begin
      Vertce_MakePassive(FGraph);
    end;

    Pos := ScreenToClient(Mouse.CursorPos);
    //Getting (X, Y) of clicks

    case FState of
      stAddVErtice:
        Graph_AddVertice(FGraph, Pos);
        //Adding a vertex

      stDeleteVertice:
      { Deleting a vertex }
        begin
          SelectedVertice := Graph_GetVertByPoint(FGraph, Pos);
          if (SelectedVertice <> nil) then
          Begin
            VerticeStack_Push(FVertStack, SelectedVertice);
            Graph_DeleteVertice(FGraph, SelectedVertice.Number);
          End;
        end;

      stUndo:
      { Ctrl + Z }
        begin
          SelectedVertice := Graph_GetLastVert(FGraph);
          if (SelectedVertice <> nil) then
          Begin
            VerticeStack_Push(FVertStack, SelectedVertice);
            Graph_DeleteVertice(FGraph, SelectedVertice.Number);
          End;
        end;

      stRedo:
      { Ctrl + Chift + Z }
        begin
          if (FVertStack <> nil) then
          begin
            SelectedVertice := VerticeStack_Pop(FVertStack);
            Graph_AddVertice(FGraph, SelectedVertice.Center);
          end;
        end;

      stAddArc, stDeleteArc, stDFS, stBFS, stDijkstra:
      { Adding or removing edges and algorithms }
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
            { Adding adge }
              begin
                if (FGraphType) then
                { Weighted graph }
                begin
                  WRes := Window_Input.ShowModal;
                  WRes := mrOk;
                end
                else
                { unweighted graph. Weights of edges := 1 }
                begin
                  Window_Input.Weight := 1;
                  WRes := mrOk;
                end;

                if (WRes = mrOk) then
                  Graph_AddEdge(FGraph, FActiveVertice.Number,
                    SelectedVertice.Number, Window_Input.Weight);
                //Adding edge
              end;

            stDeleteArc:
            { Deleting edge }
              begin
                Graph_DeleteEdge(FGraph, FActiveVertice.Number,
                  SelectedVertice.Number);
              end;

            stDijkstra, stDFS, stBFS:
            { Algorithms }
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
    //Clearing the canvas for redrawing

    pbCanvasPaint(Self);
    //Redrawing the canvas
  
    FState := stNone;
    //Returning the canvas state to the passive value
  end;

  procedure TMainForm.pbCanvasDblClick(Sender: TObject);
  { Double Click -- The beginning of the movement of the object }
  begin
    FState := stMove;
  end;

  procedure TMainForm.pbCanvasMouseDown(Sender: TObject; Button: TMouseButton;
    Shift: TShiftState; X, Y: Integer);
  { Handler for the button click event }
  var
    Pos: TPoint;
    //Pos -- Cursor position (X, Y) during click

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
  { Handler for the mouse dragging event with the button pressed }
  var
    Pos: TPoint;
    //Pos -- Cursor position (X, Y) during click

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
  { Handler for releasing the mouse button during dragging }
  begin
    if (FState = stMove) then
    begin
      FActiveVertice.Style := stPassive;
      FActiveVertice := nil;
      pbCanvas.Invalidate;
    end;
  end;

  procedure TMainForm.pbCanvasPaint(Sender: TObject);
  { Canvas Drawing Handler }
  begin
    try
      Graph_Redraw(pbCanvas.Canvas, pbCanvas.Width, pbCanvas.Height, FGraph)
    except
      Graph_Delete(FGraph);
      Graph_Create(FGraph);
      ShowMessage('Redraw error. Graph deleted');
    end;
  end;

  procedure TMainForm.Search_Start(AState: TCanvasState; v, u: Integer);
  { The method that calls the search algorithms }
  var
    Weights: TWeightMatrix;
    AInfo: TInfo;
    fmShowResult: TfrmSrchOutput;
    isTrace: Boolean;
    //Weights -- The matrix of weights
    //AInfo -- Type of information about the completed path
    //fmShowRedult -- The form of output of the results of algorithms execution

  begin
    isTrace := False;
    if (FState = stTrace) then isTrace := True;

    Weights := GraphStruct_ToMAtrix(FGraph);

    case AState of
      stDijkstra:
      { Dijkstra }
        begin
          AInfo := Graph_Dijkstra(Weights, v, u, pbProgressBar);
        end;

      stDFS:
      { in height }
        begin
          AInfo := Graph_DFS(Weights, v, u, pbProgressBar);
        end;


      stBFS:
      { in width }
        begin
          AInfo := Graph_BFS(Weights, v, u, pbProgressBar);
        end;
    end;

    if (AInfo.Patch <> nil) then
    begin
      Vertce_MakeVisited(FGraph, AInfo.Patch);
      frmSrchOutput.Info := AInfo;
      frmSrchOutput.FormShow(pbCanvas, pbProgressBar);
      frmSrchOutput.Show;
    end
    else
      MessageBox(MainForm.Handle, 'No way.', 'Info about way', MB_OK);
  end;

  procedure TMainForm.tglswtch1Click(Sender: TObject);
  { Switching graph type (Directional Weighted / Directional Unweighted) }
  begin
    if (tglswtch1.State = tssOff) then
      FGraphType := False
    else
    if (tglswtch1.State = tssOn) then
      FGraphType := true;
  end;

  end.
