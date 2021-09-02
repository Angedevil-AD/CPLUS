{
IPTVPLAYER unit2.pas :: XE7 :: @@@ By M.Aek Progs @@@
}


unit setting;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.FileCtrl, Vcl.Grids, Vcl.Outline,
  Vcl.Samples.DirOutln;

type
  Tsettfrm = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Edit1: TEdit;
    Bevel1: TBevel;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    Bevel2: TBevel;
    Label3: TLabel;
    ComboBoxEx1: TComboBoxEx;
    Bevel3: TBevel;
    TabSheet3: TTabSheet;
    Edit5: TEdit;
    Label13: TLabel;
    Label14: TLabel;
    Edit6: TEdit;
    Label15: TLabel;
    Label16: TLabel;
    ComboBoxEx7: TComboBoxEx;
    Bevel5: TBevel;
    Bevel6: TBevel;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    Panel1: TPanel;
    Label5: TLabel;
    Bevel4: TBevel;
    ComboBoxEx3: TComboBoxEx;
    Image2: TImage;
    procedure FormCreate(Sender: TObject);
    procedure Edit1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure RadioButton3Click(Sender: TObject);
    procedure RadioButton4Click(Sender: TObject);
    procedure Edit5Change(Sender: TObject);
    procedure Edit6Change(Sender: TObject);
    procedure ComboBoxEx7Select(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure ComboBoxEx1Select(Sender: TObject);

    procedure Image1Click(Sender: TObject);
    procedure ComboBoxEx3Select(Sender: TObject);


    procedure FormClose(Sender: TObject; var Action: TCloseAction);




  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
settfrm: Tsettfrm;
savedLastbite:string='0';
implementation

{$R *.dfm}
uses unit2;









procedure Tsettfrm.ComboBoxEx1Select(Sender: TObject);
begin

if comboboxEx1.ItemIndex=0 then
VDM:='Default'
else if comboboxEx1.ItemIndex=1 then
VDM:='Directx'
else if comboboxEx1.ItemIndex=2 then
VDM:='Opengl'
end;








procedure Tsettfrm.ComboBoxEx3Select(Sender: TObject);
begin
if ComboBoxEx3.ItemIndex=0 then
RFormat:='Mp4'
else if ComboBoxEx3.ItemIndex=1 then
RFormat:='TS';

end;









procedure Tsettfrm.ComboBoxEx7Select(Sender: TObject);
begin
if ComboBoxEx7.ItemIndex=0 then
imgformat:='png'
else if ComboBoxEx7.ItemIndex=1 then
imgformat:='jpg'
else if ComboBoxEx7.ItemIndex=2 then
imgformat:='bmp';

end;




procedure Tsettfrm.Edit1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
edit1.Hint:=edit1.Text;
edit1.ShowHint:=true;
end;



procedure Tsettfrm.Edit2Change(Sender: TObject);
begin
if (strtoint(edit2.Text)>0) and  (strtoint(edit2.Text)<15000)then
netcache:= strtoint(edit2.Text);
end;




























procedure Tsettfrm.Edit5Change(Sender: TObject);
begin
if (strtoint(edit5.Text)>0) and  (strtoint(edit5.Text)<2000)then
imgX:= strtoint(edit5.Text);
end;

procedure Tsettfrm.Edit6Change(Sender: TObject);
begin
if (strtoint(edit6.Text)>0) and  (strtoint(edit6.Text)<2000)then
imgY:= strtoint(edit6.Text);
end;





















//save when exit
procedure Tsettfrm.FormClose(Sender: TObject; var Action: TCloseAction);
var
strl:TstringList;
begin
//create parent dir if not exits
if not directoryexists(extractfilepath(application.exename)+'Local') then begin
Createdir(extractfilepath(application.exename)+'/Local');
end;


//create sc dir if not exits
if not directoryexists(extractfilepath(application.exename)+'Local/Sc') then begin
Createdir(extractfilepath(application.exename)+'/Local/Sc');
end;


//create Rec dir if not exits
if not directoryexists(extractfilepath(application.exename)+'Local/Rec') then begin
Createdir(extractfilepath(application.exename)+'/Local/Rec');
end;


strl:=tstringlist.Create;
strl.Add('Mdir='+Mdir);
strl.Add('VDM='+VDM);
strl.Add('Net-cache='+inttostr(NetCache));
strl.Add('RFormat='+RFormat);
strl.Add('Savmode='+inttostr(SavMode));
strl.Add('ImgFormat='+ImgFormat);
strl.Add('imgX='+inttostr(imgX));
strl.Add('imgY='+inttostr(imgY));
strl.SaveToFile('setting.s');
strl.Free;


end;








procedure Tsettfrm.FormCreate(Sender: TObject);
begin
//upd comp
edit1.Text := mdir;

edit2.Text:= inttostr(netcache);
//-------------------
if(VDM='Default') then
comboboxEx1.ItemIndex:=0
else if(VDM='Directx') then
comboboxEx1.ItemIndex:=1
else if(VDM='Opengl') then
comboboxEx1.ItemIndex:=2;


//6------------------------
if (RFormat='Mp4') then
comboboxEx3.ItemIndex:=0
else if (RFormat='TS') then
comboboxEx3.ItemIndex:=1;




//--------------------


if (Savmode=0) then
RadioButton3.Checked:=true//auto
else if (Savmode=1) then
RadioButton4.Checked:=true;//dial

//---------------------------
if (imgformat='png') then
comboboxEx7.ItemIndex:=0
else if (imgformat='jpg') then
comboboxEx7.ItemIndex:=1
else if (imgformat='bmp') then
comboboxEx7.ItemIndex:=2;


//-----------------------------
edit5.Text := inttostr(imgX);
edit6.Text := inttostr(imgY);

//--------------------



end;




















procedure Tsettfrm.Image1Click(Sender: TObject);
var
retv:string;
begin
SelectDirectory('Mdir','',retv);
if retv.Length<=0 then
exit;

mdir:=retv;
edit1.Text:=mdir;


end;









procedure Tsettfrm.RadioButton3Click(Sender: TObject);
begin
savmode:=0;
end;

procedure Tsettfrm.RadioButton4Click(Sender: TObject);
begin
savmode:=1;
end;





end.
