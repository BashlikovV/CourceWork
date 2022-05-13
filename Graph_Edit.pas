unit Graph_Edit;

interface

uses System.Types, System.SysUtils, System.Math, System.Win.ComObj,
  System.Variants, Winapi.ActiveX;

type
  TVerticeStyle = (stPassive, stActive, stVisited);

  TPNeighbour = ^TNeighbour;
  TNeighbour = record
    Number: Integer;
    Weight: Integer;
    isVisited: Boolean;
    Next: TPNeighbour;
  end;

  TPVertice = ^TVertice;
  TVertice = record
    Number: Integer;
    Center: TPoint;
    Style: TVerticeStyle;
    OutDeg: Integer;
    Head: TPNeighbour;
    Next: TPVertice;
  end;

  TGraph = record
    Head: TPVertice;
    Tail: TPVertice;
    Order: Integer;
    isPainted: Boolean;
    R: Integer;
  end;

  TVertStack = ^TVertStackElem;

  TVertStackElem = record
    Vertice: TPVertice;
    Next: TVertStack;
  end;

  procedure Graph_Create(var Graph: TGraph);
  procedure Graph_Delete(var Graph: TGraph);
  procedure Graph_AddVertice(var Graph: TGraph; C: Tpoint);
  procedure Graph_AddEdge(var Graph: TGraph; v, u, w: INteger);
  procedure Graph_DeleteVertice(var Graph: TGraph; v: Integer);
  procedure Graph_DeleteEdge(var Graph: TGraph; v, u: Integer);
  function Graph_GetVertByNum(const Graph: TGraph; v: Integer): TPVertice;
  function Graph_GetLastVert(const AGraph: TGraph): TPVertice;
  function Graph_GetVertByPoint(const Graph: TGraph; P: TPoint): TPVertice;
  procedure Graph_Open(var Graph: TGraph; VerFileName, ArcFileName: String);
  procedure Graph_Save(const Graph: TGraph; VerFileName, ArcFileName: String);
  procedure Graph_ExcelImport(var Graph: TGraph; ExeclFileName: String);
  procedure VerticeStack_Push(var AVertStack: TVertStack; const AVertice: TPvertice);
  function VerticeStack_Pop(var AVertStack: TVertStack): TPvertice;

implementation

  procedure AdjList_Destroy(var Head: TPNeighbour);
  var
    Neighbour: TPNeighbour;

  begin
    while (Head <> nil) do
    begin
      Neighbour := Head;
      Head := Head.Next;
      Dispose(Neighbour);
    end;
  end;

  procedure Graph_Create(var Graph: TGraph);
  begin
    with Graph do
    begin
      Head := nil;
      Tail := nil;
      Order := 0;
      isPainted := False;
      R := 40;
    end;
  end;

  procedure Graph_Delete(var Graph: TGraph);
  var
    Vertice: TPVertice;

  begin
    while (Graph.Head <> nil) do
    begin
      Vertice := Graph.Head;
      AdjList_Destroy(Vertice.Head);
      Graph.Head := Graph.Head.Next;
      Dispose(Vertice);
    end;
  end;

  function IsNeighbour(const Graph: TGraph; Vertice: TPVertice; u: Integer): Boolean;
  var
    Neighbour: TPNeighbour;

  begin
    Result := False;
    if (Vertice <> nil) then
      Neighbour := Vertice.Head
    else
      Neighbour := nil;

    while not Result and (Neighbour <> nil) do
    begin
      Result := Neighbour.Number = u;
      Neighbour := Neighbour.Next;
    end;
  end;

  procedure Graph_AddVertice(var Graph: TGraph; C: Tpoint);
  var
    Vertice: TPVertice;

  begin
    Inc(Graph.Order);

    New(Vertice);
    with Vertice^ do
    begin
      Center := C;
      Number := Graph.Order;
      Style := stPassive;
      Head := nil;
      Next := nil;
      OutDeg := 0;
    end;

    if (Graph.Head = nil) then
      Graph.Head := Vertice
    else
      Graph.Tail.Next := Vertice;
    Graph.Tail := Vertice;
  end;

  procedure Graph_AddEdge(var Graph: TGraph; v, u, w: INteger);
  var
    Vertice, AdjVertice: TPVertice;
    Neighbour: TPNeighbour;
    isIncorrect: Boolean;

  begin
    Vertice := Graph_GetVertByNum(Graph, v);
    AdjVertice := Graph_GetVertByNum(Graph, u);

    isIncorrect := (v = u) or isNeighbour(Graph, Vertice, u)
      or isNeighbour(Graph, AdjVertice, v);

    if (not isIncorrect) then
    begin
      Inc(Vertice.OutDeg);

      New(Neighbour);
      with Neighbour^ do
      begin
        Number := u;
        Weight := w;
        isVisited := False;
        Next := Vertice.Head;
      end;
      Vertice.Head := Neighbour;
    end;
  end;

  procedure Graph_DeleteVertice(var Graph: TGraph; v: Integer);
  var
    Vertice, PrevVertice: TPVertice;
    Neighbour, PrevNeighbour: TPNeighbour;
    Exists: Boolean;

  begin
    if (v <> Graph.Head.Number) then
    begin
      PrevVertice := Graph_GetVertByNum(Graph, v - 1);
      Exists := (PrevVertice <> nil) and (PrevVertice.Next <> nil);

      if (Exists) then
      begin
        Vertice := PrevVertice.Next;
        PrevVertice.Next := Vertice.Next;
      end;
    end
    else
    begin
      Vertice := Graph.Head;
      Graph.Head := Vertice.Next;
      Exists := True;
    end;

    if (Exists) then
    begin
      Dec(Graph.Order);

      AdjList_Destroy(Vertice.Head);
      Dispose(Vertice);

      Vertice := Graph.Head;
      while (Vertice <> nil) do
      begin
        if (Vertice.Number > v) then Dec(Vertice.Number);

        if (Vertice.Next = nil) then Graph.Tail := Vertice;

        PrevNeighbour := nil;
        Neighbour := Vertice.Head;

        while (Neighbour <> nil) do
        begin
          if (Neighbour.Number = v) then
          begin
            if (PrevNeighbour = nil) then
              Vertice.Head := Neighbour.Next
            else
              PrevNeighbour.Next := Neighbour.Next;
            Dispose(Neighbour);
          end
          else if (Neighbour.Number > v) then
            Dec(Neighbour.Number);
        end;

        Vertice := Vertice.Next;
      end;
    end;
  end;

  procedure Graph_DeleteEdge(var Graph: TGraph; v, u: Integer);
  var
    Vertice: TPVertice;
    Neighbour, PrevNeighbour: TPNeighbour;
    Exists: Boolean;

  begin
    Vertice := Graph_GetVertByNum(Graph, v);

    Exists := IsNeighbour(Graph, Vertice, u);
    if (Exists) then
    begin
      PrevNeighbour := nil;
      Neighbour := Vertice.Head;
      while (Neighbour <> nil) do
      begin
        if (u = Neighbour.Number) then
        begin
          Dec(Vertice.OutDeg);

          if (u = Vertice.Head.Number) then
            Vertice.Head := Neighbour.Next
          else
            PrevNeighbour.Next := Neighbour.Next;
          Dispose(Neighbour);
          Neighbour := nil;
        end
        else
        begin
          PrevNeighbour := Neighbour;
          Neighbour := Neighbour.Next;
        end;
      end;
    end;
  end;

  function Graph_GetVertByNum(const Graph: TGraph; v: Integer): TPVertice;
  begin
    Result := Graph.Head;
    while (Result <> nil) and (Result.Number <> v) do
      Result := Result.Next;
  end;

  function Graph_GetVertByPoint(const Graph: TGraph; P: TPoint): TPVertice;
  var
    Vertice: TPVertice;

  begin
    Result := nil;
    Vertice := Graph.Head;
    while (Vertice <> nil) do
    begin
      if P.Distance(Vertice.Center) <= Graph.R then
      begin
        Result := Vertice;
      end;
      Vertice := Vertice.Next;
    end;
  end;

  function Graph_GetLastVert(const AGraph: TGraph): TPVertice;
  var
    Vertice: TPVertice;
    Flag: Boolean;

  begin
    Result := nil;
    Flag := False;
    Vertice := AGraph.Head;
    while (Vertice <> nil) do
    begin
      if (Flag) then Vertice := Vertice.Next;
      Flag := True;
      Result := Vertice;
      if (Vertice.Next = nil) then Exit;
    end;
  end;

  procedure VerticeStack_Push(var AVertStack: TVertStack; const AVertice: TPvertice);
  var
    Item: TVertStack;

  begin
    New(Item);
    New(Item.Vertice);

    Item.Vertice.Number := AVertice.Number;
    Item.Vertice.Center := AVertice.Center;
    Item.Vertice.Style := stActive;
    Item.Vertice.OutDeg := AVertice.OutDeg;
    Item.Vertice.Head := AVertice.Head;
    Item.Vertice.Next := AVertice.Next;

    Item.Next := AVertStack;
    AVertStack := Item;
  end;

  function VerticeStack_Pop(var AVertStack: TVertStack): TPvertice;
  var
    Item: TVertStack;

  begin
    if (AVertStack <> nil) then
    begin
      Item := AVertStack;
      AVertStack := AVertStack.Next;

      Result := Item.Vertice;
    end;
  end;

  procedure Graph_Open(var Graph: TGraph; VerFileName, ArcFileName: String);
  begin
    //...
  end;

  procedure Graph_Save(const Graph: TGraph; VerFileName, ArcFileName: String);
  begin
    //...
  end;

  procedure Graph_ExcelImport(var Graph: TGraph; ExeclFileName: String);
  begin
    //...
  end;

end.