unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Button2: TButton;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  Unit2;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  LLfrm: TForm2;
begin
  LLfrm := TForm2.Create(Self);
  LLfrm.Left := self.Left + 200;
  LLfrm.Top := self.Top + 200;

  LLfrm.ShowModal;
  LLfrm.Free;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Edit1.Text := IntToStr(StrToIntDef(Edit2.Text, 0) +
    StrToIntDef(Edit3.Text, 0));
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  self.Left := 500;
  self.Top := 300;
end;

end.