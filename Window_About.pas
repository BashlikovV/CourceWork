unit Window_About;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfrmAbout = class(TForm)
    mmoMainMemo: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAbout: TfrmAbout;

implementation

{$R *.dfm}

procedure TfrmAbout.FormCreate(Sender: TObject);
const
  FileName = 'README.txt';
  NL = #13#10;

var
  fText: TextFile;
  Line: string;

begin
  try
    AssignFile(fText, FileName);
    Reset(fText);
    while (not Eof(fText)) do
    begin
      ReadLn(fText, Line);
      mmoMainMemo.Lines.Add(Utf8ToAnsi(Line));
    end;
    CloseFile(FText);
  except
    mmoMainMemo.Lines.Add(Format('File %s not found.', [FileName]));
  end;
end;

end.
