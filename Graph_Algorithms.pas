unit Graph_Algorithms;

{ A unit with subroutines describing algorithms for graphs }

interface

uses Graph_Edit, Struct_Dynamic, System.SysUtils, Vcl.ComCtrls;

type
  //Matrix of graph weights
  TWeightMatrix = array of array of Integer;

  //Type of information about search
  TInfo = record
    Patch: TStack;
    PatchString: string;
    ArcsCount: Integer;
    Distans: Integer;
    VisitsCount: Integer;
  end;

  function GraphStruct_ToMAtrix(const AGraph: TGraph):TWeightMatrix;
  //The function of translating a graph-structure
  //into a graph-matrix of weights

  function Graph_Dijkstra(const AGraph: TWeightMatrix;
    Src, Dest: Integer; AProgressBar: TProgressBar): TInfo;
  //Finding a Path from Src to Des by Dijkstra's algorithm

  function Graph_DFS(const AGraph: TWeightMatrix; Src, Dest: Integer;
    AProgressBar: TProgressBar): TInfo;
  //Finding a Path from Src to Des by going Deep

  function Graph_BFS(const AGraph: TWeightMatrix; Src, Dest: Integer;
    AProgressBar: TProgressBar): TInfo;
  //Finding a path from Src to Des by traversing the width

implementation

  const INF = 1000000000;
  //Maximum value

  function Graph_RestorePatch(const AGraph: TWeightMatrix;
    const AParents: array of Integer; Src, Dest: Integer):TInfo;
  { The function of restoring the path by the weight matrix }
  const
    Splitter = ', ';
    //Splitter - separator between vertexes in the path line

  var
    v, u, w: Integer;
    //v - the number of the vertex-the beginning of the arc
    //u - the number of the vertex-end of the arc
    //w - weight

  begin
    with Result do
    begin
      PatchString := '';
      Stack_Initialize(Patch);
      ArcsCount := 0;
      Distans := 0;

      if (AParents[Dest - 1] <> 0) or (Src = Dest) then
      //Checking the existence of a path
      begin
        u := Dest;
        while (u <> Src) do
        begin
          v := AParents[u - 1];

          Stack_Push(Patch, u);
          PatchString := Splitter + IntToStr(u) + PatchString;
          Inc(ArcsCount);
          Distans := Distans + AGraph[v - 1,u - 1];

          u := v;
        end;

        Stack_Push(Patch, Src);
        PatchString := IntToStr(u) + PatchString;
      end;
    end;
  end;

  function GraphStruct_ToMAtrix(const AGraph: TGraph):TWeightMatrix;
  var
    Vertice: TPVertice;
    Neighbour: TPNeighbour;
    v, u: Integer;
    //Vertice - pointer in a current vertice
    //Neighbour - pointer in a current neighbour
    //v - vertyce cycle counter
    //u - neighbour cycle counter

  begin
    SetLength(Result, AGraph.Order, AGraph.Order);

    for v := 1 to AGraph.Order do
    begin
      for u := 1 to AGraph.Order do
      begin
        Result[v - 1, u - 1] := INF;
      end;
    end;

    Vertice := AGraph.Head;
    while (Vertice <> nil) do
    begin
      v := Vertice.Number;

      Neighbour := Vertice.Head;
      while (Neighbour <> nil) do
      begin
        u := Neighbour.Number;
        Result[v - 1,u - 1] := Neighbour.Weight;
        Neighbour := Neighbour.Next;
      end;

      Vertice := Vertice.Next;
    end;
  end;

  function Graph_Dijkstra(const AGraph: TWeightMatrix;
    Src, Dest: Integer; AProgressBar: TProgressBar): TInfo;
  { Finding a Path from Src to Des by Dijkstra's algorithm }
  var
    v, u: Integer;
    Order: Integer;
    Marks: array of Integer;
    isVisited: array of Boolean;
    Parents: array of Integer;
    d: Integer;
    //v - number of visiting vertice
    //u - number of neighbour vertice
    //Order - graph order
    //Marks - array of labels
    //isVisited - array of visited arc
    //Parents - array of parents
    //d - visiting vertice label

  begin
    AProgressBar.Min := 0;
    AProgressBar.Max := SizeOF(AGraph);
    AProgressBar.Step := Dest;
    //Setting progress bar statement

    Result.VisitsCount := 0;
    //Zeroinz visited vertices

    Order := Length(AGraph);
    SetLength(Marks, Order);
    SetLength(isVisited, Order);
    SetLength(Parents, Order);
    //prepairing variables

    for u := 1 to Order do
    { prepairing array`s to work }
    begin
      Marks[u - 1] := INF;
      Parents[u - 1] := 0;
      isVisited[u - 1] := False;
    end;

    Marks[Src - 1] := 0;

    //visiting vertices with minimal branches
    repeat
      d := INF;
      //First - max value

      for u := 1 to Order do
      begin
        if (not isVisited[u - 1]) and (Marks[u - 1] < d) then
        begin
          d := Marks[u - 1];
          v := u;
        end;
      end;

      //visiting searched vertice
      if (d <> INF) then
      begin
        isVisited[v - 1] := True;
        inc(Result.VisitsCount);
      end
      else
        Order := 0;
        //violation of the exit condition

      if (v = Dest) then
      { comparison with the lastest wertice }
      begin
        d := INF;
        Order := 0;
        //violation of the exit condition
      end;

      //reducing labels
      for u := 1 to Order do
      begin
        if (not isVisited[u - 1]) and (Marks[u - 1] > d + AGraph[v - 1, u - 1]) then
        begin
          Parents[u - 1] := v;
          //Saving the way

          Marks[u - 1] := d + AGraph[v - 1, u - 1];
        end;
      end;
      AProgressBar.Position := d;
    until d = INF;

    Result := Graph_RestorePatch(AGraph, Parents, Src, Dest);
    //restoring searched way
  end;

  function Graph_DFS(const AGraph: TWeightMatrix; Src, Dest: Integer;
    AProgressBar: TProgressBar): TInfo;
  { Finding a Path from Src to Des by going Deep }
  var
    v, u: Integer;
    Order: Integer;
    VertStack: TStack;
    isVisited: array of Boolean;
    Parents: array of Integer;
    //v - number of visiting vertice
    //u - number of neighbour vertice
    //Order - graph order
    //isVisited - array of visited arc
    //Parents - array of parents

  begin
    AProgressBar.Min := 0;
    AProgressBar.Max := SizeOF(AGraph);
    AProgressBar.Step := Dest;
    //Setting progress bar statement

    Result.VisitsCount := 0;
    //Zeroinz visited vertices

    //Help-data initialization
    Order := Length(AGraph);
    Stack_Initialize(VertStack);
    SetLength(isVisited, Order);
    SetLength(Parents, Order);

    for v := 1 to Order do
    begin
      Parents[v - 1] := 0;
      isVisited[v - 1] :=  False;
    end;

    // Vertices --> VertStack
    Stack_Push(VertStack, Src);
    while (VertStack <> nil) do
    { visiting the vertices in the stack }
    begin
      //Getting a vertex and comparing it with the final one
      v := Stack_Pop(VertStack);
      Inc(Result.VisitsCount);
      if (v = Dest) then
      begin
        List_Destroy(VertStack);
        isVisited[v - 1] := True;
      end;

      if (not isVisited[v - 1]) then
      { Adding neighbours in a stack }
      begin
        isVisited[v - 1] := True;
      end;

      //Adding not visited neighbors to the stack
      for u := Order downto 1 do
      begin
        if (not isVisited[u - 1]) and (AGraph[v - 1, u - 1] <> INF) then
        begin
          Parents[u - 1] := v;
          //Saving the way

          Stack_Push(VertStack, u);
        end;
      end;
      AProgressBar.Position := Result.VisitsCount;
      //Change progress bar posotoin
    end;

    Result := Graph_RestorePatch(AGraph, Parents, Src, Dest);
    //restoring searched way
  end;

  function Graph_BFS(const AGraph: TWeightMatrix; Src, Dest: Integer;
    AProgressBar: TProgressBar): TInfo;
  { Finding a path from Src to Des by traversing the width }
  var
    v, u: Integer;
    Order: Integer;
    VertQueue: TQueue;
    isVisited: array of Boolean;
    Parents: array of Integer;
    //v - number of visiting vertice
    //u - number of neighbour vertice
    //Order - graph order
    //VertQueue - queue of vertices
    //isVisited - array of visited arc
    //Parents - array of parents

  begin
    AProgressBar.Min := 0;
    AProgressBar.Max := SizeOF(AGraph);
    AProgressBar.Step := Dest;
    //Setting progress bar statement

    Result.VisitsCount := 0;
    //Zeroinz visited vertices

    Order := Length(AGraph);
    Queue_Initialize(VertQueue);
    SetLength(isVisited, Order);
    SetLength(Parents, Order);
    //Help-data initialization

    for v := 1 to Order do
    begin
      Parents[v - 1] := 0;
      isVisited[v - 1] :=  False;
    end;

    Queue_Add(VertQueue, Src);
    isVisited[Src - 1] := True;
    while (VertQueue.Head <> nil) do
    { visiting vertices in a queue }
    begin
      v := Queue_Extract(VertQueue);
      //getting vertice and comparison with the final

      Inc(Result.VisitsCount);
      if (v = Dest) then
      begin
        List_Destroy(VertQueue.Head);
        Order := 0;
        //violation of the exit condition
      end;

      for u := 1 to Order do
      { adding in queue neighbour vertice }
      begin
        if (not isVisited[u - 1]) and (AGraph[v - 1, u - 1] <> INF) then
        begin
          isVisited[u - 1] := True;
          Parents[u - 1] := v;
          Queue_Add(VertQueue, u);
        end;
      end;
      AProgressBar.Position := Result.VisitsCount;
      //Change progress bar posotoin
    end;
    Result := Graph_RestorePatch(AGraph, Parents, Src, Dest);
    //restoring searched way
  end;

end.

