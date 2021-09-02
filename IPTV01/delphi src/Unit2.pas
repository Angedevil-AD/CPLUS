{
IPTVPLAYER unit2.pas :: XE7 :: @@@ By M.Aek Progs @@@
}

unit Unit2;

interface

uses
  Winapi.Windows,SL, Winapi.Messages,System.Generics.Collections,strutils, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.OleCtrls,PasLibVlcUnit, AXVLC_TLB, Vcl.ImgList, PasLibVlcPlayerUnit,
  Vcl.Menus, Vcl.ComCtrls;

type
  TForm2 = class(TForm)
    GroupBox1: TGroupBox;
    searchbox: TEdit;
    search: TImage;
    Image1: TImage;
    ListBox1: TListBox;
    TV: TPanel;
    control: TPanel;
    progrsactive: TImage;
    Timer1: TTimer;
    fullscnimage: TImage;
    panelinfo: TPanel;
    Label1: TLabel;
    title: TEdit;
    Label2: TLabel;
    times: TEdit;
    Label3: TLabel;
    catego: TEdit;
    Label4: TLabel;
    efps: TEdit;
    Label5: TLabel;
    rate: TEdit;
    Label6: TLabel;
    Edit6: TEdit;
    Bevel1: TBevel;
    Image2: TImage;
    Button1: TButton;
    Button2: TButton;
    vlcplug: TPasLibVlcPlayer;
    Button7: TButton;
    Shape1: TShape;
    Shape2: TShape;
    Panel2: TPanel;
    BH: TBalloonHint;
    pop: TPopupMenu;
    Play1: TMenuItem;
    pause1: TMenuItem;
    Stop1: TMenuItem;
    N1: TMenuItem;
    Screenshot1: TMenuItem;
    N2: TMenuItem;
    info1: TMenuItem;
    TrackBar1: TTrackBar;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button8: TButton;
    SaveDialog1: TSaveDialog;
    stb: TStatusBar;
    Button9: TButton;
    Button10: TButton;
    procedure FormCreate(Sender: TObject);
    procedure searchMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure searchMouseLeave(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ProgressMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);

    procedure fullscnimageMouseLeave(Sender: TObject);
    procedure fullscnimageClick(Sender: TObject);
    procedure TVMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure vlcplugMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);



    procedure fullscnimageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormActivate(Sender: TObject);
    procedure searchClick(Sender: TObject);
    procedure searchboxChange(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure vlcplugMediaPlayerTimeChanged(Sender: TObject; time: Int64);
    procedure Button1Click(Sender: TObject);
    procedure vlcplugMediaPlayerStopped(Sender: TObject);
    procedure vlcplugMediaPlayerPositionChanged(Sender: TObject;
      position: Single);
    procedure vlcplugMediaPlayerEndReached(Sender: TObject);
    procedure vlcplugMediaPlayerPaused(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure titleClick(Sender: TObject);
    procedure Shape1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Shape1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Shape1MouseLeave(Sender: TObject);
    procedure playbuttMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure stopbuttMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Play1Click(Sender: TObject);
    procedure pause1Click(Sender: TObject);
    procedure Stop1Click(Sender: TObject);
    procedure info1Click(Sender: TObject);
    procedure vlcplugMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TrackBar1Change(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Screenshot1Click(Sender: TObject);
    procedure vlcplugMediaPlayerPlaying(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure vlcplugMediaPlayerEncounteredError(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);


  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;





type
TMODE =(onn,off);



var
Form2: TForm2;
ol1,ol2:olevariant;
tim:integer=0;
lock:integer=0;
maxtim:integer=0;
progaverage:integer=0;
fullmode:integer;
savedleft,savedtop,savedwidth,savedheigth:integer;
controlsavedleft,controlsavedtop,controlsavedwidth,controlsavedheigth:integer;
saveddef,savedPA,savedPRO,savedSCN:integer;
THH:THANDLE;
chlst: TDictionary<string, string>;
Enum: TPair<string, string>;
pipe:THANDLE;
totalchan:integer=0;
searchindex:integer=0;
terminated:boolean=false;
exitcode:boolean=true;
idx:integer=-1;
alreadystarted:integer=0;
tmchangedX2:integer=1;
MediaAlive:boolean=false;
MODED_SECONDE:integer=1;
lastXpos:integer=0;
Vlcopt : Array[0..9] of string;
Ch_blist:TstringList;
currmedia:string ;


Mdir:string;
VDM:string;
Netcache:integer=1500;
RFormat:string;
Savmode:integer;
ImgFormat:string;
imgX,imgY:integer;



implementation

{$R *.dfm}

uses prevent,setting,About;











//process data
function proccess(gotten:string):integer;
var
name:string;
link:string;
I,J: Integer;
modi:integer;
found:integer;
begin


modi:=0;

for I := 1  to strlen(pchar(gotten)) do begin
if (gotten[i]<>#10) then begin
//get name
if modi = 0  then name:= name+gotten[i];
if modi = 1  then link:= link+gotten[i];
end

else begin
if modi=0 then begin //inverse mode
modi:=1;
//form2.Memo1.Lines.Add(name);
//name:='';
end
else begin
modi:=0;
//form2.Memo1.Lines.Add(link);
//add to diction




//
//deny / accept ?

found:=-1;
if(ch_blist.Count>0) then begin
for j := 0 to ch_blist.Count-1 do begin
if containstext(name,ch_blist.Strings[j])then begin
found:=1;
break;
end;
end;

if(found=1) then //prevent
exit;
end;


chlst.Add(name,link);
form2.listbox1.Items.Add(name);//update listboxi

link:='';
name:='';
end;

end;
end;
//

//link:=gotten;
//update chlist
//chlst.Add(name,link);
end;




















//reader
Function Server(x:pointer):integer;stdcall;
var
ACTIVE:integer;
pipe:THANDLE;
len:CARDINAL;
ret:BOOLEAN;
buffer: array [0 .. 110000] of ansichar;
gotten:string;

begin


pipe := CreateNamedPipe('\\.\pipe\MKPlayer',PIPE_ACCESS_DUPLEX,PIPE_TYPE_MESSAGE or PIPE_READMODE_MESSAGE or PIPE_WAIT,
1,110000,110000,NMPWAIT_USE_DEFAULT_WAIT,nil);


if(pipe = INVALID_HANDLE_VALUE) then begin
TerminateThread(thh,0);
application.Terminate;
end;



Sleep(200);



while(exitcode) do begin



if ConnectNamedPipe(pipe, 0) then begin
ACTIVE:=1;

if (form2.ListBox1.Count>0) then
form2.ListBox1.Clear;

if (chlst.Count>0) then
chlst.Clear;







Form2.Visible :=false;

//init.Show;

//(init.agif.Picture.Graphic as TGIFImage).Animate := True;
//form2.memo1.lines.Add('connected');

Sleep(200);




while(true) do begin //------------ reading


ret := ReadFile(pipe, buffer, 110000, len, 0);

if(ret ) and (len >0) then begin //incom data
buffer[len]:=#0;
gotten := buffer;
if strlen(pchar(gotten))>0 then
proccess(gotten);
gotten:='';
//FlushFileBuffers(pipe);
end

else if (len<=0) then begin // no data mean cli disc
//form2.memo1.lines.Add('ennnnnnnnd');
//FlushFileBuffers(pipe);
//form2.panel6.caption := 'N° channel: '+(inttostr(chlst.Count));
totalchan:= chlst.Count;
break;
end;


end; //reading




FlushFileBuffers(pipe);
DisconnectNamedPipe(Pipe);
break;

//Form2.Visible :=true;
//init.Close;

end //con
else begin //


end;

end;

Form2.Visible :=true;


form2.edit6.Text:= 'N° Channels: '+inttostr(totalchan);
form2.stb.Panels[2].Text:= 'nch: '+inttostr(totalchan);
FlushFileBuffers(pipe);
DisconnectNamedPipe(Pipe);
CloseHandle(Pipe);//
terminated := true;
exit;

end;































































//-----------------------------------------------
//            Stylise
//-----------------------------------------------
function stylise(image:TIMAGE;default:TIMAGE;mode:TMODE):integer;
var
bmp:tbitmap;
begin



bmp:= tbitmap.Create;
bmp.PixelFormat :=pf32bit;
bmp.SetSize(image.Width,image.Height);
bmp.Canvas.StretchDraw(default.ClientRect,default.Picture.Graphic);

image.Picture:=nil;

image.Picture.Bitmap.PixelFormat := pf32bit;
image.Picture.Bitmap.AlphaFormat:=afDefined;
if (mode=onn) then
image.Picture.Bitmap.Canvas.Brush.Color := clMaroon;


image.Picture.Bitmap.SetSize(image.Width, image.Height);

if (mode=onn) then
image.Canvas.Draw(0,0,bmp,100)
else
image.Canvas.Draw(0,0,bmp);
bmp.Free;


end;



















//-----------------------------------------------
//            Stylise  2
//-----------------------------------------------
function stylise2(image:TIMAGE;default:TIMAGE;mode:TMODE):integer;
var
bmp:tbitmap;
begin



bmp:= tbitmap.Create;
bmp.PixelFormat :=pf32bit;
bmp.SetSize(image.Width,image.Height);
bmp.Canvas.StretchDraw(default.ClientRect,default.Picture.Graphic);

image.Picture:=nil;

image.Picture.Bitmap.PixelFormat := pf32bit;
image.Picture.Bitmap.AlphaFormat:=afDefined;
if (mode=onn) then
image.Picture.Bitmap.Canvas.Brush.Color := clGreen;


image.Picture.Bitmap.SetSize(image.Width, image.Height);

if (mode=onn) then
image.Canvas.Draw(0,0,bmp,100)
else
image.Canvas.Draw(0,0,bmp);
bmp.Free;


end;









//-----------------------------------------------
//            progress vids
//-----------------------------------------------
function progrs(image:TSHAPE;timepos:integer):integer;

begin

image.Width:=timepos;


end;












































































































procedure TForm2.Button10Click(Sender: TObject);
begin
Form2.Close;
end;

procedure TForm2.Button1Click(Sender: TObject);

begin




if(vlcplug.IsPlay=true) then
exit;




//addopt

Vlcopt[0] := ':network-caching='+inttostr(Netcache);

//vidformat
if(VDM='Default') then
Vlcopt[1]:= '--vout=default'
else if(VDM='Directx') then
Vlcopt[1]:= '--vout=directx'
else if(VDM='Opengl') then
Vlcopt[1]:= '--vout=opengl';



lock:=1;
if(vlcplug.IsPause=true) and(mediaalive=true) then begin
vlcplug.Resume;
end


else begin
if currmedia.Length>0 then

vlcplug.Play(currmedia);
end;

end;





procedure TForm2.Button2Click(Sender: TObject);
begin
//
Vlcopt[2] := '';
if vlcplug.IsPlay=true or vlcplug.Ispause=true then
vlcplug.Stop;
end;


























































function ScShot():integer;
var
tms:tdatetime;
sc_Filename:string;
hr,mi,sec,ms:word;
begin

if(savmode=0) then begin  //autosave
tms:=now();
decodetime(tms,hr,mi,sec,ms) ;
sc_Filename:= Mdir+'/Sc/mk_Player_'+hr.ToString+mi.ToString+ sec.ToString+ms.ToString+'.'+imgFormat;
form2.vlcplug.SnapShotFmt:= imgFormat;
form2.vlcplug.Snapshot(sc_Filename,imgX,imgY);
end

else if(savmode=1) then begin  //dial
form2.vlcplug.SnapShotFmt:= imgFormat;
form2.vlcplug.Snapshot('s.tmp',imgX,imgY);
form2.savedialog1.Filter:='Picture|*.*';
if form2.SaveDialog1.Execute then
sc_Filename:=form2.SaveDialog1.FileName+'.'+imgFormat;
if(sc_Filename.Length>0) then
renameFile('s.tmp',sc_Filename);

DeleteFile('s.tmp');
end;




end;



procedure TForm2.Button3Click(Sender: TObject);
begin
if(mediaalive=true) then
Scshot();//
end;




procedure TForm2.Button4Click(Sender: TObject);
begin
Slfrm.ShowModal
end;

//SaveLoad PLY
procedure TForm2.Button5Click(Sender: TObject);
begin
preventfrm.ShowModal;
end;














function createccmd(mode:integer):string;
var
nmc,nmc2:string;
id:integer;
begin
nmc:= currmedia;
id:=currmedia.LastIndexOf('/');
nmc2:=nmc.Substring(id+1);
nmc:='';
nmc:=mdir+'\Rec\'+nmc2;




if(mode=1) then begin

result:=':sout=#duplicate{dst=display,dst=standard{mux=ts,access=file,dst='+nmc+'.ts}}'

end

else if(mode=0) then begin

result:=':sout=#duplicate{dst=display,dst=standard{mux=mp4,access=file,dst='+nmc+'.mp4}}'

end;








end;




procedure TForm2.Button6Click(Sender: TObject);
var
ccmd:string;
extn:string;
begin

if mediaalive=false  then
exit;

if Rformat='TS' then begin
ccmd:=createccmd(1);
end;


if Rformat='Mp4' then begin
ccmd:=createccmd(0);
end;



//ccmd:=libvlc_media_record_str(extn,mx,vcodec,0,20,1,Acodec,128,2,44100,true);







//MyOptions[0] := ':network-caching=5000';
Vlcopt[2] := ccmd;
vlcplug.Play(currmedia,Vlcopt);
end;










procedure TForm2.Button7Click(Sender: TObject);
begin
if vlcplug.IsPlay=true then   begin
vlcplug.Pause;

end;
end;

procedure TForm2.Button8Click(Sender: TObject);
begin
settfrm.ShowModal;
end;

procedure TForm2.Button9Click(Sender: TObject);
begin
aboutbox.ShowModal;
end;

//------------------------------------
//close form
//-----------------------------------
procedure TForm2.FormActivate(Sender: TObject);

var
ID: DWORD;

begin

chlst := TDictionary<string, string>.Create;

Sleep(1000);
THH := CreateThread(0, 0, @Server, 0, 0, ID);
end;











procedure TForm2.FormClick(Sender: TObject);
begin
vlcplug.MarqueeShowText('ok',0,0,$00A7D6F5,18,255,0);
end;

procedure TForm2.FormClose(Sender: TObject; var Action: TCloseAction);
begin

Ch_blist.Free;
DisconnectNamedPipe(Pipe);
CloseHandle(Pipe);//

exitcode:=false;
chlst.Free;

end;



























procedure up_setting(keywd,vald:string);
begin

if keywd = 'Mdir' then
Mdir:=vald


else if keywd = 'VDM' then
VDM:=vald


else if keywd = 'Net-cache' then
Netcache:=strtoint(vald)


else if keywd = 'RFormat' then
RFormat:=vald

else if keywd = 'Savmode' then
Savmode:=strtoint(vald)


else if keywd = 'ImgFormat' then
imgFormat:=vald


else if keywd = 'imgX' then
imgX:=strtoint(vald)


else if keywd = 'imgY' then
imgY:=strtoint(vald)





end;





procedure create_N_Load();
var
strl:TstringList;
retval,index,i:integer;
keywd,valwd:string;
exiting:integer;
getch:array[0..255]  of char;
begin

exiting:=0;
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


//create setting.s   not exits
if not fileexists(extractfilepath(application.exename)+'setting.s') then begin
strl:=tstringlist.Create;
strl.Add('Mdir='+extractfilepath(application.exename)+'Local');
strl.Add('VDM=Default');
strl.Add('Net-cache=1000');
strl.Add('RFormat=Mp4');
strl.Add('Savmode=0');
strl.Add('ImgFormat=png');
strl.Add('imgX=640');
strl.Add('imgY=480');
strl.SaveToFile('setting.s');
strl.Free;

Mdir:=extractfilepath(application.exename)+'Local';
VDM:='Default';
Netcache:=1000;
RFormat:='Mp4';
Savmode:=0;
ImgFormat:='png';
imgX:=640;
imgY:=480;

end;


//load & set
strl:=tstringlist.Create;
strl.LoadFromFile(extractfilepath(application.exename)+'setting.s');
for I := 0 to strl.Count-1 do begin

index:=strl.Strings[i].IndexOf('=');
if index=-1 then begin //errr
retval:=MessageDlg('Config File corrupted? do you want create a new one',mtwarning,[mbok,mbcancel],0);
if(retval=1) then begin
deletefile(extractfilepath(application.exename)+'setting.s');
Create_N_Load();
break;
end
else begin
exiting:=1;
break;
end;

end;


//cop key & val
strl.Strings[i].CopyTo(0,getch,0,index);
getch[index]:=#0;
keywd:=getch;


strl.Strings[i].CopyTo(index+1,getch,0,strl.Strings[i].Length-(index+1));
getch[strl.Strings[i].Length-(index+1)]:=#0;
valwd:=getch;


//check
if(valwd.Length<=0) or (keywd.Length<=0) then begin
retval:=MessageDlg('Config File corrupted? do you want create a new one',mtwarning,[mbok,mbcancel],0);
if(retval=1) then begin
deletefile(extractfilepath(application.exename)+'setting.s');
Create_N_Load();
break;
end
else begin
exiting:=1;
break;
end;
end;



//update
up_setting(keywd,valwd);


end;//


if(exiting=1) then
application.Terminate; //exit



end;













//------------------------------------
//create form
//-----------------------------------
procedure TForm2.FormCreate(Sender: TObject);
var
retval:integer;
begin

ch_blist:= tstringlist.Create;
if(Fileexists('Blacklist.bl')) then
ch_blist.LoadFromFile('Blacklist.bl');

Create_N_Load();

vlcplug.Parent := TV;
vlcplug.Align:=alClient;
//fullmode:=false;
{vlcplug.Align:=alClient;
vlcplug.DefaultInterface.FullscreenEnabled:=false;
vlcplug.DefaultInterface.Visible:=false;
vlcplug.DefaultInterface.Toolbar:=false;
vlcplug.DefaultInterface.Branding:=false;
 }

end;
















//----------------------------------------------
//         go fullscreen
//----------------------------------------------
procedure TForm2.fullscnimageClick(Sender: TObject);
var
avg:integer;
tmp,tmpmin:extended;
val:double;
intrvl:double;
wid:double;
gvms:double;
timerintv:integer;
begin




if fullmode=0 then begin

if mediaalive=false then
exit;

button3.Visible:=false;
tmp:= shape1.Width;

form2.Visible:=false;
panelinfo.Visible:=false;

controlsavedtop := control.Top;
controlsavedleft := control.left;
controlsavedwidth := control.width;
controlsavedheigth := control.height;


fullmode := 1;
TV.Align:= Talign(5);
FormStyle := fsStayOnTop;
BorderStyle := bsNone;
savedleft:=   left;
savedtop:= top;
savedwidth:= width;
savedheigth:=height;
Left := -2;
Top := -2;
Width := Screen.Width+5;
Height := Screen.Height+5;


control.Align:= alBOTTOM;


savedPRO := shape1.Width;
savedSCN := fullscnimage.Left;


progrsactive.Width := control.Width-200;




if(vlcplug.GetVideoLenInMs>0) then begin
tmp :=shape1.Width / tmp;
tmp:=shape2.Width *(tmp);
shape2.Width:=round(tmp);
end;



button3.Visible:=false;
button4.Visible:=false;
button5.Visible:=false;
button6.Visible:=false;
button8.Visible:=false;
button9.Visible:=false;
button10.Visible:=false;

stb.Visible:=false;
form2.Visible:=true;

end




else if fullmode=1 then begin

tmp:= shape1.Width;

form2.Visible:=false;
fullmode := 0;
Sleep(300);
TV.Align:= Talign(0);
FormStyle := fsnormal;
BorderStyle := bstoolwindow;
Left := savedleft;
Top := savedtop;
Width := savedwidth;
Height := savedheigth;

control.Align:= alcustom;

control.Top :=controlsavedtop;
control.left :=controlsavedleft;
control.width :=controlsavedwidth;
control.Height :=controlsavedheigth;






control.Visible:=true;
panelinfo.Visible:=true;


if(vlcplug.GetVideoLenInMs>0) then begin
tmp := tmp / shape1.Width;
tmp:=shape2.Width / tmp;
shape2.Width:=round(tmp);

end;


button3.Visible:=true;
button4.Visible:=true;
button5.Visible:=true;
button6.Visible:=true;
button8.Visible:=true;
button9.Visible:=true;
button10.Visible:=true;

form2.Visible:=true;

stb.Visible:=true;
end
end;




//----------------------------------------------
//         fullscreen mouse leave
//----------------------------------------------
procedure TForm2.fullscnimageMouseLeave(Sender: TObject);
begin
stylise(fullscnimage,image2,off);
end;



//----------------------------------------------
//         fullscreen mouse move
//----------------------------------------------
procedure TForm2.fullscnimageMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
stylise(fullscnimage,image2,onn);
end;





























procedure TForm2.info1Click(Sender: TObject);
begin
Aboutbox.ShowModal;
end;

//----------------------------------------------
//         go play
//----------------------------------------------
procedure TForm2.ListBox1Click(Sender: TObject);
var
lnk:string;
begin
if listbox1.Count=0 then
exit;

if(idx =-1) then
exit;




//addopt

Vlcopt[0] := ':network-caching='+inttostr(Netcache);

//vidformat
if(VDM='Default') then
Vlcopt[1]:= '--vout=default'
else if(VDM='Directx') then
Vlcopt[1]:= '--vout=directx'
else if(VDM='Opengl') then
Vlcopt[1]:= '--vout=opengl';



//playit
lnk := (chlst.Items[listbox1.items[idx]]);
currmedia:=lnk;
if vlcplug.IsPlay=true then
vlcplug.Stop;
vlcplug.Play(lnk);

form2.stb.Panels[3].Text:= 'ci '+inttostr(idx);

//
stb.Panels[0].Text:=listbox1.items[idx];

vlcplug.SetAudioVolume(40);
form2.stb.Panels[4].Text:= 'vol: '+inttostr(40);
title.Text := listbox1.items[idx];
times.Text :=  vlcplug.GetVideoLenStr();
if((vlcplug.GetVideoLenInMs) =0) then
catego.Text:='Live'
else
catego.Text:='undefined...' ;

efps.Text:=inttostr(round(vlcplug.GetVideoFps));
rate.Text:= inttostr(vlcplug.GetPlayRate);
end;










procedure TForm2.ListBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
//get idx
idx := listbox1.ItemAtPos(Point(X,Y),true);
end;












procedure TForm2.pause1Click(Sender: TObject);
begin
if vlcplug.IsPlay=true then   begin
vlcplug.Pause;
end;
end;

procedure TForm2.Play1Click(Sender: TObject);
begin
lock:=1;




//addopt

Vlcopt[0] := ':network-caching='+inttostr(Netcache);

//vidformat
if(VDM='Default') then
Vlcopt[1]:= '--vout=default'
else if(VDM='Directx') then
Vlcopt[1]:= '--vout=directx'
else if(VDM='Opengl') then
Vlcopt[1]:= '--vout=opengl';



if(vlcplug.IsPlay=true) then
exit;

if(vlcplug.IsPause=true) and(mediaalive=true) then begin
vlcplug.Resume;
end


else begin
if currmedia.Length>0 then

vlcplug.Play(currmedia);
end;
end;






procedure TForm2.playbuttMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin

end;

//----------------------------------------------
//         progress mouse move
//----------------------------------------------
procedure TForm2.ProgressMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
//;
end;













procedure TForm2.Screenshot1Click(Sender: TObject);
begin
if(mediaalive=true) then
Scshot();//
end;

//----------------------------------------------
//         search
//----------------------------------------------
procedure TForm2.searchboxChange(Sender: TObject);
begin
searchindex:=0;
end;



procedure TForm2.searchClick(Sender: TObject);
var
i:integer;
found:integer;
xrect:trect;
begin


found:=0;
if (searchindex>listbox1.Count-1) then
searchindex:=0;

if(strlen(pchar(searchbox.Text))>0) and (searchbox.Text<>'') then begin
for I := searchindex to listbox1.Count-1 do begin
if(ContainsText(listbox1.Items[i] , searchbox.Text)) then begin
//showmessage('found at '+inttostr(i));
searchindex:=i+1;
found:=1;
listbox1.Selected[i]:=true;
listbox1.SetFocus;
//Focus-----------
xrect:=listbox1.ItemRect(i);
listbox1.Canvas.Brush.Color:=$000B87CA;
listbox1.Canvas.FillRect(xrect);
listbox1.Canvas.font.Color:=clblack;
listbox1.canvas.TextRect(xRect, xRect.Left+2, xRect.Top+2, ListBox1.Items[i]);
listbox1.Canvas.Brush.Color:=clred;
listbox1.Canvas.DrawFocusRect(xrect);

//----------------
break;
end;

end;
if(found=0) then searchindex:=0;
end;
if(found=0) then searchindex:=0;

end;



//----------------------------------------------
//         search mouse leave
//----------------------------------------------
procedure TForm2.searchMouseLeave(Sender: TObject);
begin

stylise(search,image1,off);

end;

//----------------------------------------------
//         search mouse move
//----------------------------------------------
procedure TForm2.searchMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin

stylise(search,image1,onn);

end;
























////-----------------------------------------
//          change pos
//-------------------------------------------
procedure TForm2.Shape1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
xtime:integer;
  begin


if  mediaalive=true then begin

if(vlcplug.GetVideoLenInMs=0) then exit ; //dont up in live modea

//update position
shape2.Width:= x;
xtime := (x*MODED_SECONDE) div 1000;
//memo1.Lines.Add('  xtime= '+xtime.ToString());

vlcplug.SetVideoPosInMs(xtime*1000);
tmchangedX2:= (xtime*1000);
//memo1.Lines.Add('xxxxxxxxxxxxxx=: '+(tmchangedX2).ToString());
end;
end;











procedure TForm2.Shape1MouseLeave(Sender: TObject);
begin
BH.HideHint;
end;




procedure TForm2.Shape1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
  var
xtime:integer;
LHintWindow : TCustomHintWindow;
ts:ttimestamp;
rettimestamp:extended;
LPoint:TPOINT;
  begin
if(lastxpos=x) then exit;

if x<=0 then begin
exit;
end;

if(vlcplug.GetVideoLenInMs=0) then exit ; //dont up in live modea

lastxpos:=x;
if (vlcplug.IsPlay=true)  and mediaalive=true then begin
//update position
xtime := (x*MODED_SECONDE) div 1000;

//----------- hint----------------

ts.Time:=round(xtime*1000);
ts.Date:= 1;
rettimestamp:=round(timestamptodatetime(ts));

 LHintWindow := TCustomHintWindow.Create(Application);

LHintWindow.Width := 400;
LHintWindow.Height := 400;
LHintWindow.HintParent := BH;
BH.SetHintSize(LHintWindow);
LPoint.X := x;
LPoint.Y := shape1.Top-2;
BH.HideAfter := 4000;
BH.Description:= timetostr((timestamptodatetime(ts)));//------
BH.ShowHint(shape1.ClientToScreen(LPoint)) ;
LHintWindow.Free;
end;

end;






procedure TForm2.Stop1Click(Sender: TObject);
begin
Vlcopt[2] := '';
if vlcplug.IsPlay=true or vlcplug.Ispause=true then
vlcplug.Stop;
end;

procedure TForm2.stopbuttMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin

end;

////-----------------------------------------
//           TIMER PROGRESS
//-------------------------------------------
procedure TForm2.Timer1Timer(Sender: TObject);
begin

//memo1.Lines.Add(shape2.Width.ToString()+'   '+shape1.Width.ToString());
//progrs(shape2,tim);
//inc(tim,1);


end;










////-----------------------------------------
//           change pos
//-------------------------------------------
procedure TForm2.titleClick(Sender: TObject);
begin
if (vlcplug.IsPlay = true or vlcplug.IsPause=true) then

end;




////-----------------------------------------
//           MOUSE MOVE TV
//-------------------------------------------
procedure TForm2.TrackBar1Change(Sender: TObject);
begin
vlcplug.SetAudioVolume(trackbar1.Position);
form2.stb.Panels[4].Text:= 'vol: '+inttostr(trackbar1.Position);
end;

procedure TForm2.TVMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin

//
end;












//--------------------------------------------------
//video pos changed
//--------------------------------------------------
procedure TForm2.vlcplugMediaPlayerEncounteredError(Sender: TObject);
begin
stb.panels[1].Text:= 'status: '+vlcplug.GetStateName;
end;

procedure TForm2.vlcplugMediaPlayerEndReached(Sender: TObject);
begin
if mediaalive=true then
vlcplug.Stop;
end;


//--------------------------------------------------
//video pos changed
//--------------------------------------------------
procedure TForm2.vlcplugMediaPlayerPaused(Sender: TObject);
begin
timer1.Enabled:=false;
stb.panels[1].Text:= 'status: '+vlcplug.GetStateName;
end;

procedure TForm2.vlcplugMediaPlayerPlaying(Sender: TObject);
begin
vlcplug.SetAudioVolume(60);
end;

procedure TForm2.vlcplugMediaPlayerPositionChanged(Sender: TObject;
  position: Single);
var
val:double;
intrvl:double;
wid:double;
gvms:double;
timerintv:integer;
tin2:double;
begin


if(lock=1) then
exit;


if position<=0 then
exit;



times.Text :=  vlcplug.GetVideoLenStr();

maxtim:= vlcplug.GetVideoLenInMs;




gvms:=vlcplug.GetVideoLenInMs;


val := round(gvms / 1000); //get sec


if val > shape1.Width then begin
timerintv:= round(val) mod shape1.Width ;


wid:=shape1.Width;

intrvl:= round(val / wid )  ; //tick
intrvl := round(intrvl*1000);
end;

if val <= shape1.Width then begin
timerintv:=shape1.Width mod round(val);
shape1.Width:= shape1.Width-timerintv;

wid:=shape1.Width;

intrvl:= round(wid / val)  ; //tick
intrvl := round(1000/intrvl);
end;
//showmessage(intrvl.ToString());


tim:=0;
//showmessage(intrvl.ToString());

timerintv:=round(intrvl);






timer1.Interval:=timerintv;

timer1.Enabled:=true;
lock:=1;

end;




//--------------------------------------------------
//video stoped
//--------------------------------------------------
procedure TForm2.vlcplugMediaPlayerStopped(Sender: TObject);
begin
efps.Text:='';
rate.Text:= '';
catego.Text:='';
title.Text:='';
times.Text:='';

MediaAlive:=false;

panel2.Caption:='0';
timer1.Enabled:=false;
shape2.Width:= 0;
vlcplug.Refresh;
 stb.panels[1].Text:= 'status: '+vlcplug.GetStateName;
end;



//--------------------------------------------------
//video movon
//--------------------------------------------------
procedure TForm2.vlcplugMediaPlayerTimeChanged(Sender: TObject; time: Int64);
var
ttm:integer;
ts:ttimestamp;
tm:ttime;
rettimestamp:extended;
var
val:double;
intrvl:double;
wid:double;
test,timerintv:integer;
begin

stb.panels[1].Text:= 'status: '+vlcplug.GetStateName;

test := round(vlcplug.GetVideoLenInMs / 1000); //get sec
//memo1.Lines.Add('tottime=: '+test.ToString()+'  width '+shape1.Width.ToString());

//memo1.Lines.Add('Time: '+(time).ToString());



MediaAlive:=true; //

ttm:= time ;
ts.Time:=(ttm);
ts.Date:= 1;
panel2.Caption:=timetostr(timestamptodatetime(ts));  //get current seek



//----------------update  --------- info ----------------------
if((vlcplug.GetVideoLenInMs) =0) then
catego.Text:='Live'
else
catego.Text:='undefined...' ;

times.Text :=  vlcplug.GetVideoLenStr();
efps.Text:=inttostr(round(vlcplug.GetVideoFps));
rate.Text:= inttostr(vlcplug.GetPlayRate);
//--------------------------------------------------------------


if(vlcplug.GetVideoLenInMs=0) then exit ; //dont up in live mode


//------------------
if(time<tmchangedX2) then
exit;





//if(vlcplug.GetVideoLenInMs=0) then exit ; //dont up in live mode

val := round(vlcplug.GetVideoLenInMs / 1000); //get sec




if val > shape1.Width then begin

wid:=shape1.Width; //get shape 1 unit count

intrvl:= (val / wid )  ; //tick
intrvl := trunc(intrvl*1000);
MODED_SECONDE:=round(intrvl);

shape2.Width:=shape2.Width+1; //inc prog
//memo1.Lines.Add('int=: '+(tmchangedX2).ToString());
inc(tmchangedX2,round(intrvl)); //prep for next

end ;




if val <= shape1.Width then begin

wid:=shape1.Width; //get shape 1 unit count

intrvl:= (val / wid )  ; //tick
intrvl := trunc(intrvl*1000);
MODED_SECONDE:=round(intrvl);

shape2.Width:=shape2.Width+1; //inc prog
//memo1.Lines.Add('int=: '+(tmchangedX2).ToString());
inc(tmchangedX2,round(intrvl)); //prep for next


end ;
















end;












procedure TForm2.vlcplugMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
if fullmode=0 then
exit;
if button=mbright then
pop.Popup(x,y);
end;

procedure TForm2.vlcplugMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
//mouse in bottom area
if fullmode= 1 then begin

if Y>=screen.Height-40 then begin
control.Visible:=true;
end
else begin
control.Visible:=false;
end;

end;

if fullmode= 0 then begin
control.Visible:=true;
end;


end;

end.
