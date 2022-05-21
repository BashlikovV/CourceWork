unit Algorithms;

interface

uses Vcl.Graphics, GraphView;

type
  TDijkstra = class
    private
    { Private declarations }
    constructor Create(N: Integer);
    destructor Destroy;
    public
    { Public declarations }
    FVertexsArray: array of array of Integer;
    FEdgesArray: array of array of Integer;
    N: Integer;
    FStrat: Integer;
    FIsVisited: Boolean;
  end;

implementation

{ TAlgorithms }

constructor TDijkstra.Create(N: Integer);
begin
  SetLength(FVertexsArray, N);
  SetLength(FEdgesArray, N);
end;

destructor TDijkstra.Destroy;
begin

end;



end.
