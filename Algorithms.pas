unit Algorithms;

interface

uses Graph_Edit, Struct_Dynamic, System.SysUtils;

type
  TWeightMatrix = array of array of Integer;

  TInfo = record
    Patch: TStack;
    PatchString: string;
    ArcsCount: Integer;
    Distans: Integer;
    VisitsCount: Integer;
  end;

  function GraphStruct_ToMAtrix(const AGraph: TGraph):TWeightMatrix;
  function Graph_Dijkstra(const AGraph: TWeightMatrix;
    Src, Dest: Integer): TInfo;
implementation

  const INF = 1000000000;

  function Graph_RestorePatch(const AGraph: TWeightMatrix;
    const AParents: array of Integer; Src, Dest: Integer):TInfo;
  const
    Splitter = ', ';
    //Splitter - ����������� ����� ��������� � ������ ����

  var
    v, u, w: Integer;
    //v - ����� ������-������ ����
    //u - ����� �������-����� ����
    //w - weight

  begin
      with Result do
      begin
        PatchString := '';
        Stack_Initialize(Patch);
        ArcsCount := 0;
        Distans := 0;

        if (AParents[Dest - 1] <> 0) or (Src = Dest) then
        //�������� ������������� ����
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
    //Vertice - ������ �� ������� �������
    //Neighbour - ������ �� �������� ������
    //v - �������� ����� �� ��������
    //u - �������� ����� �� �������

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
    Src, Dest: Integer): TInfo;
  var
    v, u: Integer;
    Order: Integer;
    Marks: array of Integer;
    isVisited: array of Boolean;
    Parents: array of Integer;
    d: Integer;
    //v - ����� ���������� �������
    //u - ����� ������ �������
    //Order - ������� �����
    //Marks - ������ �����
    //isVisited - ������ ������
    //Parents - ������ �������
    //d - ����� ���������� �������

  begin
    Result.VisitsCount := 0;

    Order := Length(AGraph);
    SetLength(Marks, Order);
    SetLength(isVisited, Order);
    SetLength(Parents, Order);

    for u := 1 to Order do
    begin
      Marks[u - 1] := INF;
      Parents[u - 1] := 0;
      isVisited[u - 1] := False;
    end;

    Marks[Src - 1] := 0;

    repeat
      d := INF;
      for u := 1 to Order do
      begin
        if (not isVisited[u - 1]) and (Marks[u - 1] < d) then
        begin
          d := Marks[u - 1];
          v := u;
        end;
      end;

      if (d <> INF) then
      begin
        isVisited[v - 1] := True;
        inc(Result.VisitsCount);
      end
      else
        Order := 0;

      if (v = Dest) then
      begin
        d := INF;
        Order := 0;
      end;

      for u := 1 to Order do
      begin
        if (not isVisited[u - 1]) and (Marks[u - 1] > d + AGraph[v - 1, u - 1]) then
        begin
          Parents[u - 1] := v;
          Marks[u - 1] := d + AGraph[v - 1, u - 1];
        end;
      end;
    until d = INF;

    Result := Graph_RestorePatch(AGraph, Parents, Src, Dest);
  end;

end.
