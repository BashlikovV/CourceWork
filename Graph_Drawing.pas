unit Graph_Drawing;

{ A module with routines designed to draw and
 redraw the graph structure }

interface

Uses System.Types, Vcl.Graphics, System.Math, Graph_Edit,
     Struct_Dynamic, System.SysUtils;

procedure Vertce_MakeVisited(var AGraph: TGraph; var APatch: TStack);
//Procedure for redrawing graph vertices used during pathfinding

procedure Vertce_MakePassive(var AGraph: TGraph);
//Procedure for redrawing graph vertices to the inactive state

procedure Vertce_MakeRegPolygon(var AGraph: TGraph; AWidth, AHeight: Integer);
//Coordinate change routine procedure

procedure Graph_Redraw(const ACanvas: TCanvas; Width, Height: Integer;
  const AGraph: TGraph);
//Graph redraw procedure

implementation

type
  //Array type for the polyline method for drawing arrows
  TArcLine = array[1..5] of TPoint;

function Arc_GetPoints(p1, p2: Tpoint; R: Integer): TArcLine;
{ polyline subroutine for polyline method }
const
  ArrowAngle = Pi / 4;

var
  XStart, YStart: Integer;
  XEnd, YEnd: Integer;
  d: Integer;
  LineAngle: Real;
  Sign: Integer;
  //XStart, YStart - cordinates of arc start
  //XEnd, YEnd - coordinates of arc end
  //d - variable for distance calculating
  //LineAngle - Angle of arc
  //Sign - The sign of the difference between
  // the abscissa of the first and second vertex

begin
  d := Trunc(p1.Distance(p2));

  { Line coordinates calculating }
  XEnd := Round(p2.X + R * (p1.X - p2.X) / d);
  YEnd := Round(p2.Y + R * (p1.Y - p2.Y) / d);
  XStart := Round(p1.X + R * (p2.X - p1.X) / d);
  YStart := Round(p1.Y + R * (p2.Y - p1.Y) / d);

  { X, Y - start of arc }
  Result[1].X := XStart;
  Result[1].Y := YStart;

  { X, Y - End of arc }
  Result[2].X := XEnd;
  Result[2].Y := YEnd;

  // Result[2] - (X, Y - end) - the beginning of the arrow
  Result[4] := Result[2];

  d := Trunc(Result[1].Distance(Result[2]));
  if (d <> 0) then
    LineAngle := ArcSin((YStart - YEnd) / d)
  else
    LineAngle := 0;

  Sign := (2 * Ord(XStart >= XEnd) - 1);
  d := (R div 2);

  { First part of the  arrow X, Y }
  Result[3].X := XEnd + Sign * Trunc(Cos(ArrowAngle - Sign * LineAngle) * d);
  Result[3].Y := YEnd - Sign * Trunc(Sin(ArrowAngle - Sign * LineAngle) * d);

  { Second part of the  arrow X, Y }
  Result[5].X := XEnd + Sign * Trunc(Cos(ArrowAngle + Sign * LineAngle) * d);
  Result[5].Y := YEnd + Sign * Trunc(Sin(ArrowAngle + Sign * LineAngle) * d);
end;

procedure Arc_Draw(const ACanvas: TCanvas; R: Integer; 
  const ASrcCenter, ADstSenter: TPoint; const ANeighbour: TPneighbour);
{ Arc drawing routine }
var
  Points: TArcLine;
  SWeight: string;
  XMid, YMid: Integer;
  HText, WText: Integer;
  //Points - 5 points (X, Y) for arc drawing
  //SWeight - string witch the number of vertice
  //XMid, YMid - coordinates of SWeight
  //HText, WTwxt - Height and Weight of Text
  
begin
  with ACanvas do
  begin
    //Initialixation data for drawing
    if ANeighbour.isVisited then
    begin
      Pen.Color := clTeal;
      Font.Color := clWhite;
      Brush.Color := clBlack;
    end
    else
    begin
      Pen.Color := clBlack;
      Font.Color := clBlack;
      Brush.Color := clWhite;
    end;

    Points := Arc_GetPoints(ASrcCenter, ADstSenter, R);
    //Getting points of TPoints for drawing

    Polyline(Points);
    //Drawing line witch arrow

    if (ANeighbour.Weight <> 1) then
    begin
      Str(ANeighbour.Weight, SWeight);
      WText := TextWidth(SWeight);
      HText := TextHeight(SWeight);
      XMid := (Points[1].x + Points[2].x - WText) div 2;
      YMid := (Points[1].Y + Points[2].Y - HText) div 2;
      Rectangle(XMid - 1, YMid - 1, XMid + WText + 2, YMid + HText + 2);
      //Drawing rectangle in a line

      TextOut(XMid, YMid, SWeight);
      //Drawing text in a rectangle
    end;

  end;
end;

procedure Vertice_Draw(const ACanvas: TCanvas; R: Integer;
  const AVertice: TPVertice);
{ vertex rendering routine }
var
  SNumber: String;
  XMid, YMid: Integer;

begin
  with ACanvas, AVertice^, AVertice.Center do
  begin
    //Initialixation data for drawing
    case Style of
      stPassive:
        begin
          Pen.Color := clBlack;
          Font.Color := clBlack;
          Brush.Color := clWhite;
        end;

      stActive:
        begin
          Pen.Color := clRed;
          Font.Color := clBlack;
          Brush.Color := clMoneyGreen;
        end;

      stVisited:
        begin
          Pen.Color := clDkGray;
          Font.Color := clWhite;
          Brush.Color := clLime;
        end;
    end;

    Str(AVertice.Number, SNumber);
    XMid := X - TextWidth(SNumber) div 2;
    YMid := Y - TextHeight(SNumber) div 2;
    // cordinates of arc center

    Ellipse(x - R, y - R, x + R, y + R);
    //Vertice drawing

    TextOut(XMid, YMid, SNumber);
    //Text drawing
  end;
end;

procedure Vertce_MakeVisited(var AGraph: TGraph; var APatch: TStack);
{ Redrawing vertexes to visited ones }
var
  Vertice: TPvertice;
  Neighbour: TPNeighbour;
  v: Integer;
  //Vertice - variable for vertice changing
  //Neighbour - Link to a neighbor
  //v - number of changed vertice
  
begin
  while (APatch <> nil) do
  begin
    v := Stack_Pop(APatch);
    Vertice := Graph_GetVertByNum(AGraph, v);
    Vertice.Style := stVisited;

    if (APatch <> nil) then
    begin
      v := Stack_Pop(APatch);
      Neighbour := Vertice.Head;

      while (v <> Neighbour.Number) do
        Neighbour := Neighbour.Next;
      Neighbour.isVisited := True;
      Stack_Push(APatch, v);
    end;
  end;  

  AGraph.isPainted := True;
end;

procedure Vertce_MakePassive(var AGraph: TGraph);
{ Redrawing vertexes to not visited ones }
var
  Vertice: TPVertice;
  Neighbour: TPNeighbour;
  //Vertice - variable for vertice changing
  //Neighbour - Link to a neighbor
  
begin
  Vertice := AGraph.Head;
  while (Vertice <> nil) do
  begin
    Vertice.Style := stPassive;

    Neighbour := Vertice.Head;
    while (Neighbour <> nil) do
    begin
      Neighbour.isVisited := False;
      Neighbour := Neighbour.Next;
    end;  
    Vertice := Vertice.Next;
  end;  

  AGraph.isPainted := False;
end;

procedure Vertce_MakeRegPolygon(var AGraph: TGraph; AWidth, AHeight: Integer);
{ Coordinate change routine procedure }
var
  Vertice: TPVertice;
  ImageSenter: TPoint;
  PolygonRadius: Integer;
  Angle: Real;
  //Vertice - variable for vertice changing
  //ImageSenter - center of image
  //PolygonRadius - radius of right polygon
  
begin
  //Angle, Radius and coordinates of canter of circle
  Angle := 0;
  PolygonRadius := Min(AWidth, AHeight) div 2 - AGraph.R;
  ImageSenter.X := AWidth div 2;
  ImageSenter.Y := AHeight div 2;

  Vertice := AGraph.Head;
  while (Vertice <> nil) do
  begin
    Vertice.Center.X := ImageSenter.X + Trunc(PolygonRadius * Sin(Angle));
    Vertice.Center.Y := ImageSenter.Y - Trunc(PolygonRadius * Cos(Angle));

    Vertice := Vertice.Next;
    Angle := Angle + 2 * pi / AGraph.Order;
  end;  
end;

procedure Graph_Redraw(const ACanvas: TCanvas; Width, Height: Integer;
  const AGraph: TGraph);
{ routine of graph redrawing }
var
  Vertice, AdjVertice, Active: TPVertice;
  Neighbour: TPNeighbour;
  //Vertice - current vertice
  //AdjVertice - adjacent vertex for Vertice
  //Active - active vertice
  //Neighbour - Link to a neighbor

begin
  Active := nil;
  with ACanvas do
  begin
    Pen.Color := clWhite;
    Rectangle(0, 0, Width, Height);
    Pen.Width := 3;
    Font.Size := 15;
    Font.Style := [TFontStyle.fsBold];
  end;

  Vertice := AGraph.Head;

  //Movement along the vertices
  while (Vertice <> nil) do
  begin
    Neighbour := Vertice.Head;
    //Movement along the neighboures
    while (Neighbour <> nil) do
    begin
      AdjVertice := Graph_GetVertByNum(AGraph, Neighbour.Number);
      Arc_Draw(ACanvas, AGraph.R, Vertice.Center, AdjVertice.Center, Neighbour);
      Neighbour := Neighbour.Next;
    end;

    Vertice := Vertice.Next;
  end;

  Vertice := AGraph.Head;

  //Movement along the vertices
  while (Vertice <> nil) do
  begin
    Vertice_Draw(ACanvas, AGraph.R, Vertice);

    if (Vertice.Style = stActive) then Active := Vertice;

    Vertice := Vertice.Next;
  end;

  //Active vertice redrawing
  if (Active <> nil) then
    Vertice_Draw(ACanvas, AGraph.R, Active);
  
end;

end.
