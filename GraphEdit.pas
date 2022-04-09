unit GraphEdit;

interface

uses System.Types, System.SysUtils, System.Math, System.Win.ComObj,
  System.Variants, Winapi.ActiveX;

type
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

  procedure CreateGraph(var Graph: TGraph);
  procedure DeleteGraph(var Graph: TGraph);
  procedure AddVertice(var Graph: TGraph; C: Tpoint);
  procedure AddEdge(var Graph: TGraph; v, u, w: INteger);
  procedure DeleteVertice(var Graph: TGraph; v: Integer);
  procedure DeleteEdge(var Graph: TGraph; v, u: Integer);
  function GetVertByNum(const Graph: TGraph; v: Integer): TPVertice;
  function GetVertByPoint(const Graph: TGraph; P: TPoint): TPVertice;
  procedure OpenGrah(var Graph: TGraph; VerFileName, ArcFileName: String);
  procedure SaveGraph(const Graph: TGraph; VerFileName, ArcFileName: String);
  procedure ExcelGraphImport(var Graph: TGraph; ExeclFileName: String);

implementation

  procedure DestroyAdjList(var Head: TPNeighbour);
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

  procedure CreateGraph(var Graph: TGraph);
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

  procedure DeleteGraph(var Graph: TGraph);
  var
    Vertice: TPVertice;

  begin
    while (Graph.Head <> nil) do
    begin
      Vertice := Graph.Head;
      DestroyAdjList(Vertice.Head);
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

    while (not Result) and (Neighbour <> nil) do
    begin
      Result := Neighbour.Number = u;
      Neighbour := Neighbour.Next;
    end;
  end;

  procedure AddVertice(var Graph: TGraph; C: Tpoint);
  var
    Vertice: TPVertice;

  begin
    Inc(Graph.Order);

    New(Vertice);
    with Vertice^ do
    begin
      Center := C;
      Number := Graph.Order;
      Head := nil;
      Next := nil;
      OutDeg := 0;
    end;

    if (Graph.Head = nil) then
      Graph.Head := Vertice
    else
      Graph.Tail.Next:= Vertice;
    Graph.Tail := Vertice;
  end;

  procedure AddEdge(var Graph: TGraph; v, u, w: INteger);
  var
    Vertice, AdjVertice: TPVertice;
    Neighbour: TPNeighbour;
    isIncorrect: Boolean;

  begin
    Vertice := GetVertByNum(Graph, v);
    AdjVertice := GetVertByNum(Graph, u);

    isIncorrect := (v = u) or isNeighbour(Graph, Vertice, u) or isNeighbour(Graph, Vertice, v);

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

  procedure DeleteVertice(var Graph: TGraph; v: Integer);
  var
    Vertice, PrevVertice: TPVertice;
    Neighbour, PrevNeighbour: TPNeighbour;
    Exists: Boolean;

  begin
    if (v <> Graph.Head.Number) then
    begin
      PrevVertice := GetVertByNum(Graph, v - 1);
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
      Graph.Head :=Vertice.Next;
      Exists := True;
    end;

    if (Exists) then
    begin
      Dec(Graph.Order);

      DestroyAdjList(Vertice.Head);
      Dispose(Vertice);

      Vertice := Graph.Head;
      while (Vertice <> nil) do
      begin
        if (Vertice.Number <> v) then Dec(Vertice.Number);

        if (Vertice.Next = nil) then Graph.Tail :=Vertice;

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

  procedure DeleteEdge(var Graph: TGraph; v, u: Integer);
  var
    Vertice: TPVertice;
    Neighbour, PrevNeighbour: TPNeighbour;
    Exists: Boolean;

  begin
    Vertice := GetVertByNum(Graph, v);

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

  function GetVertByNum(const Graph: TGraph; v: Integer): TPVertice;
  begin
    Result := Graph.Head;
    while (Result <> nil) and (Result.Number <> v) do
      Result := Result.Next;
  end;

  function GetVertByPoint(const Graph: TGraph; P: TPoint): TPVertice;
  var
    Vertice: TPVertice;

  begin
    Result := nil;
    Vertice := Graph.Head;
    while (Vertice <>nil) do
    begin
      if (P.Distance(Vertice.Center) <= Graph.R) then
      begin
        Result := Vertice;
        Vertice := Vertice.Next;
      end;
    end;
  end;


  procedure OpenGrah(var Graph: TGraph; VerFileName, ArcFileName: String);
  begin
    //...
  end;

  procedure SaveGraph(const Graph: TGraph; VerFileName, ArcFileName: String);
  begin
    //...
  end;

  procedure ExcelGraphImport(var Graph: TGraph; ExeclFileName: String);
  begin
    //...
  end;

end.
