{
IPTVPLAYER unit2.pas :: XE7 :: @@@ By M.Aek Progs @@@
}


unit SL;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.CategoryButtons, Vcl.StdCtrls;

type
  TSLfrm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  SLfrm: TSLfrm;

implementation

{$R *.dfm}

uses unit2;

procedure TSLfrm.Button1Click(Sender: TObject);
var
Sfile:textFile;
i:integer;
begin
//check if list avai
if form2.listbox1.count>0 then begin
assignfile(sfile,extractfilepath(application.ExeName)+'Playlst.ppl');
rewrite(sfile);
for I := 0 to chlst.Count-1 do begin

Writeln(sfile,chlst.ToArray[i].Key);
Writeln(sfile,chlst.ToArray[i].value);
end;

Closefile(sfile);
end;



end;




///load
procedure TSLfrm.Button2Click(Sender: TObject);
var
Sfile:textFile;
i:integer;
lnk,name:string;
begin

assignfile(sfile,extractfilepath(application.ExeName)+'Playlst.ppl');
reset(sfile);

i:=0;
chlst.Clear;
form2.listbox1.Clear;

while not eof(sfile) do begin
if (odd(i)) then begin
readln(sfile,lnk);
chlst.Add(name,lnk);
end



else begin
readln(sfile,name);
form2.listbox1.Items.Add(name);
end;

inc(i);
end;

Closefile(sfile);

form2.efps.Text:='';
form2.rate.Text:= '';
form2.catego.Text:='';
form2.title.Text:='';
form2.times.Text:='';

MediaAlive:=false;

form2.panel2.Caption:='0';
form2.timer1.Enabled:=false;
form2.shape2.Width:= 0;
form2.vlcplug.Refresh;

totalchan:=chlst.Count;
form2.edit6.Text:= 'N° Channels: '+inttostr(totalchan);
form2.stb.Panels[2].Text:= 'nch: '+inttostr(totalchan);

end;





end.
