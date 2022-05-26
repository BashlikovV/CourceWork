unit Graph_Edit;

{ a unit with subroutines and
 data structures for working with a graph
 and its structure }

interface

uses System.Types, System.SysUtils, System.Math, System.Win.ComObj,
  System.Variants, Winapi.ActiveX, Vcl.Graphics;

type
  //Type of vertice statemant
  TVerticeStyle = (stPassive, stActive, stVisited);

  //Type of neighbor list
  TPNeighbour = ^TNeighbour;
  TNeighbour = record
    Number: Integer;
    Weight: Integer;
    isVisited: Boolean;
    Next: TPNeighbour;
  end;

  //Type of graph vertices
  TPVertice = ^TVertice;
  TVertice = record
    Number: Integer;
    Center: TPoint;
    Style: TVerticeStyle;
    OutDeg: Integer;
    Head: TPNeighbour;
    Next: TPVertice;
  end;

  //Type of graph structure
  TGraph = packed record
    Head: TPVertice;
    Tail: TPVertice;
    Order: Integer;
    isPainted: Boolean;
    R: Integer;
  end;

  //Stack of vertices
  TVertStack = ^TVertStackElem;

  TVertStackElem = record
    Vertice: TPVertice;
    Next: TVertStack;
  end;

  procedure Graph_Create(var AGraph: TGraph);
  //Procedure for graph initialize

  procedure Graph_Delete(var AGraph: TGraph);
  //Procedure for graph deleting

  procedure Graph_AddVertice(var AGraph: TGraph; C: Tpoint);
  //Procedure for adding vertice in a graph

  procedure Graph_AddEdge(var AGraph: TGraph; v, u, w: INteger);
  //Procedure for adding arc in a graph

  procedure Graph_DeleteVertice(var AGraph: TGraph; v: Integer);
  //Procedure for removing a vertex from a graph

  procedure Graph_DeleteEdge(var AGraph: TGraph; v, u: Integer);
  //Procedure for removing an arc from a graph

  function Graph_GetVertByNum(const AGraph: TGraph; v: Integer): TPVertice;
  //Function for getting vertive using number

  function Graph_GetLastVert(const AGraph: TGraph): TPVertice;
  //Function for getting last vertice of graph

  function Graph_GetVertByPoint(const AGraph: TGraph; P: TPoint): TPVertice;
  //Function for getting vert using value of TPoint

  procedure Graph_Open(var AGraph: TGraph; AVerFileName, AArcFileName: String);
  //Procedure for open graph using typed files

  procedure Graph_Save(const Graph: TGraph; VerFileName, ArcFileName: String);
  //Procedure for saving graph from typed files

  procedure Graph_ExcelImport(var AGraph: TGraph; AExeclFileName: String);
  //

  procedure VerticeStack_Push(var AVertStack: TVertStack; const AVertice: TPvertice);
  //Procedure for push data of vertice from stack

  function VerticeStack_Pop(var AVertStack: TVertStack): TPvertice;
  //Function for getting data about vertice from stack

implementation

  procedure AdjList_Destroy(var Head: TPNeighbour);
  { Reamoving neighbout list }
  var
    Neighbour: TPNeighbour;
    //Neighbour - list of neighbour

  begin
    while (Head <> nil) do
    begin
      Neighbour := Head;
      Head := Head.Next;
      Dispose(Neighbour);
    end;
  end;

  procedure Graph_Create(var AGraph: TGraph);
  { Graph initialize }
  begin
    with AGraph do
    { Start data }
    begin
      Head := nil;
      Tail := nil;
      Order := 0;
      isPainted := False;
      R := 35;
    end;
  end;

  procedure Graph_Delete(var AGraph: TGraph);
  { Graph removing }
  var
    Vertice: TPVertice;
    //Vertice - value for storage data about vertice

  begin
    while (AGraph.Head <> nil) do
    { Delete all graph vertice }
    begin
      Vertice := AGraph.Head;
      AdjList_Destroy(Vertice.Head);
      AGraph.Head := AGraph.Head.Next;
      Dispose(Vertice);
    end;
  end;

  function IsNeighbour(const Graph: TGraph; Vertice: TPVertice; u: Integer): Boolean;
  { Checking for connectivity }
  var
    Neighbour: TPNeighbour;
    //Neighbour - list of neighbour

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

  procedure Graph_AddVertice(var AGraph: TGraph; C: Tpoint);
  { Adding vertice in a graph }
  var
    Vertice: TPVertice;
    //Vertice - variable for storage data about vertice

  begin
    //Increment graph order
    Inc(AGraph.Order);

    New(Vertice);
    with Vertice^ do
    begin
      Center := C;
      Number := AGraph.Order;
      Style := stPassive;
      Head := nil;
      Next := nil;
      OutDeg := 0;
    end;

    if (AGraph.Head = nil) then
      AGraph.Head := Vertice
    else
      AGraph.Tail.Next := Vertice;
    AGraph.Tail := Vertice;
  end;

  procedure Graph_AddEdge(var AGraph: TGraph; v, u, w: INteger);
  { Adding edge in a graph }
  var
    Vertice, AdjVertice: TPVertice;
    Neighbour: TPNeighbour;
    isIncorrect: Boolean;
    //Vertice - current vertice
    //AdjVertice - connected vertex
    //Neighbour - list of neighbour
    //isIncorrect - checking for correctly

  begin
    Vertice := Graph_GetVertByNum(AGraph, v);
    //Getting current vertice

    AdjVertice := Graph_GetVertByNum(AGraph, u);
    //Getting changed vertice

    isIncorrect := (v = u) or isNeighbour(AGraph, Vertice, u)
      or isNeighbour(AGraph, AdjVertice, v);
    //Checking for correctly

    if (not isIncorrect) then
    begin
      Inc(Vertice.OutDeg);

      New(Neighbour);
      //Update list of neighbour
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

  procedure Graph_DeleteVertice(var AGraph: TGraph; v: Integer);
  { Deleteng vrtice from a graph }
  var
    Vertice, PrevVertice: TPVertice;
    Neighbour, PrevNeighbour: TPNeighbour;
    Exists: Boolean;
    //Vertice - current vertice
    //PrevVertice - previous vertice
    //Neighbour - connected vertice
    //PrevNeighbour - pointer for a neighbour neighbour
    //Exists - flag about the presence of a vertex

  begin
    try
      //Deleting vertice
      if (v <> AGraph.Head.Number) then
      begin
        PrevVertice := Graph_GetVertByNum(AGraph, v - 1);
        Exists := (PrevVertice <> nil) and (PrevVertice.Next <> nil);

        if (Exists) then
        begin
          Vertice := PrevVertice.Next;
          PrevVertice.Next := Vertice.Next;
        end;
      end
      else
      begin
        //Delete list head
        Vertice := AGraph.Head;
        AGraph.Head := Vertice.Next;
        Exists := True;
      end;
    except
      raise Exception.Create('Error. Graph deleted');
      Graph_Delete(AGraph);
    end;

    if (Exists) then
    begin
      Dec(AGraph.Order);
      //Decrement graph order

      try
        AdjList_Destroy(Vertice.Head);
        //Freeing up memory

        Dispose(Vertice);
      except
        raise Exception.Create('Vertice not found');
      end;

      Vertice := AGraph.Head;
      //Passing through the vertices of the graph
      while (Vertice <> nil) do
      begin
        if (Vertice.Number > v) then Dec(Vertice.Number);
        //Reducing vertex numbers

        if (Vertice.Next = nil) then AGraph.Tail := Vertice;
        //Redacting a tail of vertice list

        //Moving for a neighbour of a vertice
        PrevNeighbour := nil;
        Neighbour := Vertice.Head;

        while (Neighbour <> nil) do
        begin
          if (Neighbour.Number = v) then
          { Selete neighbour of courent vertice }
          begin
            if (PrevNeighbour = nil) then
              Vertice.Head := Neighbour.Next
            else
              PrevNeighbour.Next := Neighbour.Next;
            try
              Dispose(Neighbour);
              Neighbour := nil; //nil?
            except
              raise Exception.Create('Neighbour error');
            end;
          end
          else if (Neighbour.Number > v) then
            Dec(Neighbour.Number);
        end;

        Vertice := Vertice.Next;
      end;
    end;
  end;

  procedure Graph_DeleteEdge(var AGraph: TGraph; v, u: Integer);
  { Deletting arc from a graph }
  var
    Vertice: TPVertice;
    Neighbour, PrevNeighbour: TPNeighbour;
    Exists: Boolean;
    //Vertice - current vertice
    //Neighbour - connected vertice
    //PrevNeighbour - pointer for a neighbour neighbour
    //Exists - flag about the presence of a vertex

  begin
    Vertice := Graph_GetVertByNum(AGraph, v);
    //Getting data about vertice witch number v

    Exists := IsNeighbour(AGraph, Vertice, u);
    //Checking

    if (Exists) then
    begin
      //Moving for neighbout list
      PrevNeighbour := nil;
      Neighbour := Vertice.Head;
      while (Neighbour <> nil) do
      begin
        if (u = Neighbour.Number) then
        { Delete the changed arc }
        begin
          Dec(Vertice.OutDeg);

          if (u = Vertice.Head.Number) then
            Vertice.Head := Neighbour.Next
          else
            PrevNeighbour.Next := Neighbour.Next;
          try
            Dispose(Neighbour);
            Neighbour := nil;
          except
            raise Exception.Create('Neighbour error');
          end;
        end
        else
        begin
          PrevNeighbour := Neighbour;
          Neighbour := Neighbour.Next;
        end;
      end;
    end;
  end;

  function Graph_GetVertByNum(const AGraph: TGraph; v: Integer): TPVertice;
  { Getting vrtice using number of vertices }
  begin
    Result := AGraph.Head;
    while (Result <> nil) and (Result.Number <> v) do
      Result := Result.Next;
  end;

  function Graph_GetVertByPoint(const AGraph: TGraph; P: TPoint): TPVertice;
  { Getting vertice using value of TPoint(X, Y) }
  var
    Vertice: TPVertice;
    //Vertice - current vertice

  begin
    try
      Result := nil;
      Vertice := AGraph.Head;
      while (Vertice <> nil) do
      begin
        if P.Distance(Vertice.Center) <= AGraph.R then
        { If the distance from the point to the center
         of the vertex is <= than the radius of the vertices of the graph, the vertex fits }
        begin
          Result := Vertice;
        end;
        Vertice := Vertice.Next;
      end;
    except
      raise Exception.Create('Vertice not found');
    end;
  end;

  function Graph_GetLastVert(const AGraph: TGraph): TPVertice;
  { Getting last vertice in a graph }
  var
    Vertice: TPVertice;
    Flag: Boolean;
    //Vertice - current vertice
    //Flag - Checking for a first vertice

  begin
    try
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
    except
      raise Exception.Create('Last vertice isn`t get.');
    end;
  end;

  procedure VerticeStack_Push(var AVertStack: TVertStack; const AVertice: TPvertice);
  { Adding data about vertice in a stack }
  var
    Item: TVertStack;

  begin
    try
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
    except
      raise Exception.Create('Vertice not found');
    end;
  end;

  function VerticeStack_Pop(var AVertStack: TVertStack): TPvertice;
  { Extraction data about vertice from a stack }
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

  procedure Graph_Open(var AGraph: TGraph; AVerFileName, AArcFileName: String);
  { Open graph used typed files }
  var
    VerFile: file of TVertice;
    ArcFile: file of TNeighbour;
    Vertice: TPVertice;
    Neighbour: TPNeighbour;
    v: Integer;
    //VerFile - file witch data about Vertices
    //ArcFile - file witch data about arc
    //Vertice - current vertice
    //Neighbour - connected vertice
    //v - sycle counter

  begin
    try
      Assign(VerFile, AVerFileName);
      Assign(ArcFile, AArcFileName);
      Reset(VerFile);
      Reset(ArcFile);
    except
      raise Exception.Create('File not found. Try again');
    end;

    Graph_Create(AGraph);
    New(Vertice);
    New(Neighbour);

    while (not Eof(VerFile)) do
    begin
      read(VerFile, Vertice^);
      Graph_AddVertice(AGraph, Vertice.Center);

      for v := 1 to Vertice.OutDeg do
      begin
        read(ArcFile, Neighbour^);
        Graph_AddEdge(AGraph, Vertice.Number, Neighbour.Number, Neighbour.Weight);
      end;
    end;

    Dispose(Vertice);
    Dispose(Neighbour);

    CloseFile(VerFile);
    CloseFile(ArcFile);
  end;

  procedure Graph_Save(const Graph: TGraph; VerFileName, ArcFileName: String);
  { Saving graph structure in a type files }
  var
    VerFile: file of TVertice;
    ArcFile: file of TNeighbour;
    Vertice: TPVertice;
    Neighbour: TPNeighbour;
    //VerFile - file witch data about Vertices
    //ArcFile - file witch data about arc
    //Vertice - current vertice
    //Neighbour - connected vertice

  begin
    try
      Assign(VerFile, VerFileName);
      Assign(ArcFile, ArcFileName);
      Rewrite(VerFile);
      Rewrite(ArcFile);
    except
      raise Exception.Create('Saving arror. Try again');
    end;

    Vertice := Graph.Head;
    while (Vertice <> nil) do
    begin
      write(VerFile, Vertice^);

      Neighbour := Vertice.Head;
      while (Neighbour <> nil) do
      begin
        write(ArcFile, Neighbour^);
        Neighbour := Neighbour.Next;
      end;
      Vertice := Vertice.Next;
    end;

    CloseFile(VerFile);
    CloseFile(ArcFile);
  end;

  procedure Graph_ExcelImport(var AGraph: TGraph; AExeclFileName: String);
  begin
    //...
  end;

end.
