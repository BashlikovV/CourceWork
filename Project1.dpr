program Project1;

uses
  Vcl.Forms,
  Window_Main in 'Window_Main.pas' {MainForm},
  Algorithms in 'Algorithms.pas',
  Graph_Edit in 'Graph_Edit.pas',
  Graph_Drawing in 'Graph_Drawing.pas',
  Struct_Dynamic in 'Struct_Dynamic.pas',
  Window_ArcInput in 'Window_ArcInput.pas' {Window_Input},
  Window_SrchOutput in 'Window_SrchOutput.pas' {frmSrchOutput},
  Window_About in 'Window_About.pas' {frmAbout};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TWindow_Input, Window_Input);
  Application.CreateForm(TfrmSrchOutput, frmSrchOutput);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.Run;
end.
