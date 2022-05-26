unit Struct_Dynamic;

{ A unit containing a description of the main
 data structures and routines for working with
 these data structures }

interface

type
  { Type unidirectional list containing natural numbers }
  TPItem = ^Titem;
  TItem = record
    Number: Integer;
    Next: TPItem;
  end;

  TStack = TPItem;
  //Type stack

  { Type Queue }
  TQueue = record
    Head: TPItem;
    Tail: TPItem;
  end;

  procedure Stack_Initialize(var AStack: TStack);
  //Stack initialization procedure

  procedure Queue_Initialize(var AQueue: TQueue);
  //Queue initialization procedure

  procedure List_Destroy(var AHead: TPItem);
  //Queue destroy procedure

  procedure Stack_Push(var AStack: TStack; n: Integer);
  //Procedure for placing a value on the stack

  procedure Queue_Add(var AQueue: TQueue; n: Integer);
  //The procedure for placing a value in a queue

  function Stack_Pop(var AStack: TStack): Integer;
  //The function of extracting an element from the stack

  function Queue_Extract(var AQueue: TQueue): Integer;
  //The function of extracting an element from the queue

implementation

  procedure Stack_Initialize(var AStack: TStack);
  { Stack initialize }
  begin
    AStack := Nil;
  end;

  procedure Queue_Initialize(var AQueue: TQueue);
  { Queue initialize }
  begin
    AQueue.Head := nil;
    AQueue.Tail := nil;
  end;

  procedure List_Destroy(var AHead: TPItem);
  { List destroy }
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
  { placing a value on the stack }
  var
    Item: TPitem;

  begin
    New(Item);
    Item.Number := n;
    Item.Next := AStack;
    AStack := Item;
  end;

  procedure Queue_Add(var AQueue: TQueue; n: Integer);
  { placing a value on the queue }
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
  { function of extracting an element from the stack }
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
  { function of extracting an element from the queue }
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
