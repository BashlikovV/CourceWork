unit Struct_Dynamic;

interface

type
  TPItem = ^Titem;
  TItem = record
    Number: Integer;
    Next: TPItem;
  end;

  TStack = TPItem;

  TQueue = record
    Head: TPItem;
    Tail: TPItem;
  end;

  procedure Stack_Initialize(var AStack: TStack);
  procedure Queue_Initialize(var AQueue: TQueue);
  procedure List_Destroy(var AHead: TPItem);
  procedure Stack_Push(var AStack: TStack; n: Integer);
  procedure Queue_Add(var AQueue: TQueue; n: Integer);
  function Stack_Pop(var AStack: TStack): Integer;
  function Queue_Extract(var AQueue: TQueue): Integer;

implementation

  procedure Stack_Initialize(var AStack: TStack);
  begin
    AStack := Nil;
  end;

  procedure Queue_Initialize(var AQueue: TQueue);
  begin
    AQueue.Head := nil;
    AQueue.Tail := nil;
  end;

  procedure List_Destroy(var AHead: TPItem);
  var
    Item: TPItem;

  begin
    while (AHead <> nil) do
    begin
      Item := AHead;
      AHead := AHead.Next;
      Dispose(AHead);
    end;
  end;

  procedure Stack_Push(var AStack: TStack; n: Integer);
  var
    Item: TPitem;

  begin
    New(Item);
    Item.Number := n;
    Item.Next := AStack;
    AStack := Item;
  end;

  procedure Queue_Add(var AQueue: TQueue; n: Integer);
  var
    Item: TPItem;

  begin
    New(Item);
    Item.Number := n;
    Item.Next := nil;

    if (AQueue.Head <> nil) then
      AQueue.Head.Next := Item
    else
      AQueue.Head := Item;

      AQueue.Tail := Item;
  end;

  function Stack_Pop(var AStack: TStack): Integer;
  var
    Item: TPitem;

  begin
    if (AStack <> nil) then
    begin
      Item := AStack;
      AStack := AStack.Next;

      Result := Item.Number;
      Dispose(Item);
    end
    else
      Result := 0;
  end;

  function Queue_Extract(var AQueue: TQueue): Integer;
  var
    Item: TPItem;

  begin
    if (AQueue.Head <> nil) then
    begin
      Item := AQueue.Head;
      AQueue.Head := AQueue.Head.Next;

      Result := Item.Number;
      Dispose(Item);
    end
    else
      Result := 0;
  end;
end.
