unit prevent;

interface

uses
  Winapi.Windows,StrUtils, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage;

type
  Tpreventfrm = class(TForm)
    GroupBox1: TGroupBox;
    Button1: TButton;
    editbox: TEdit;
    blacklist: TListBox;
    removebutt: TButton;
    clearbutt: TButton;
    exitbutt: TButton;
    myiptv: TListBox;
    Panel1: TPanel;
    Label1: TLabel;
    Image1: TImage;
    procedure Button1Click(Sender: TObject);
    procedure removebuttClick(Sender: TObject);
    procedure clearbuttClick(Sender: TObject);
    procedure exitbuttClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  preventfrm: Tpreventfrm;

implementation

{$R *.dfm}



//----------------------------------------------
//           AD TO LIST
//----------------------------------------------
procedure Tpreventfrm.Button1Click(Sender: TObject);
var
i:integer;
found:integer;
begin
found:=-1;

//search for dup
if (editbox.Text <>'') and (strlen(pchar(editbox.Text))>0) then begin
for I := 0 to blacklist.Count-1 do begin
if comparetext(editbox.Text,blacklist.Items[i])=0 then begin
found:=1;
break;
end;
end;
end;


if(found=1) then begin
showmessage('Already exists!');
exit;
end;

blacklist.Items.Add(editbox.Text);
blacklist.Items.SaveToFile('Blacklist.bl');


end;










//----------------------------------------------
//           REMOVE FROM LIST
//----------------------------------------------
procedure Tpreventfrm.removebuttClick(Sender: TObject);
var
i:integer;
begin
if blacklist.Count<=0 then
exit;

if blacklist.SelCount > 0 then begin
blacklist.DeleteSelected;
end;


blacklist.Items.SaveToFile('Blacklist.bl');

end;



//----------------------------------------------
//           Cler LIST
//----------------------------------------------
procedure Tpreventfrm.clearbuttClick(Sender: TObject);
begin
blacklist.Clear;
blacklist.Items.SaveToFile('Blacklist.bl');
end;




//----------------------------------------------
//           goodby
//----------------------------------------------
procedure Tpreventfrm.exitbuttClick(Sender: TObject);
begin
editbox.Text:='';
Close;
end;




//----------------------------------------------
//           show hiden sec
//----------------------------------------------
procedure Tpreventfrm.Button5Click(Sender: TObject);
begin

end;



//----------------------------------------------
//           create
//----------------------------------------------
procedure Tpreventfrm.FormCreate(Sender: TObject);
begin
if(Fileexists('Blacklist.bl')) then
blacklist.Items.LoadFromFile('Blacklist.bl');
end;

procedure Tpreventfrm.Image1Click(Sender: TObject);
begin
if clientwidth < 500 then
clientwidth := 744
else
clientwidth := 450;
end;

end.
