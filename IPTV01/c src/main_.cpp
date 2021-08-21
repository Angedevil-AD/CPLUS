/*----------------------------------------------------
IPTV CTRL V1.0 source code 
Compiler IDE: DevC++/DevCpp
Author: M.Aek
All right reserved by M.Aek (Angedevil AD)
----------------------------------------------------*/


#include <windows.h>
#include <iostream>
#include <string>
#include <sstream>
#include <fstream>
#include <winsock.h>
#include <map>
#include <tchar.h>





using namespace std;

enum
{
WSAError,
InDataError,
HostentError,
InvalidSocket,
ConnectError,
ConnectTimo,
Socket_OK
};



struct GET
{
string http;
string host;
string rest;
string 	ContentType;
string accept;
string userAgent;
string Connection;
};



SOCKET sock;
WSADATA wsa;
string GET_PROTO="";
string PLY_PATH="";
HANDLE pipe;
int ACTIVE=0;
HANDLE XHP;

struct _CONPRC
{
int size;
int Data;		
}
CONPRC,*PCONPRC ;

typedef std::map<string,string> HCHLST;
HCHLST chlst;













//--------------------------------------------------------
//            SOCKET CLEAN
//--------------------------------------------------------
int Clean()
{
closesocket(sock);
WSACleanup();		
}






















//--------------------------------------------------------
//            SOCKET INIT & CONNECT
//--------------------------------------------------------

int initSock(char *url,int Port)
{
int ret,errcode;
hostent *host;

if((Port<0)	 && (strlen(url)<2))
return InDataError;

sockaddr_in addr;
errcode = WSAStartup(MAKEWORD(1,1),&wsa);
if(errcode != 0)
{
WSACleanup()	;
return WSAError;
}

sock = socket(AF_INET,SOCK_STREAM,IPPROTO_TCP);
if(sock == INVALID_SOCKET)
{
WSACleanup()	;
closesocket(sock);
return InvalidSocket;
}


DWORD timeout = 20 * 1000;//20 sec



addr.sin_family = AF_INET;
addr.sin_port=htons(Port);

host = gethostbyname(url);
if(!host)
{
WSACleanup()	;	
closesocket(sock);
return HostentError;
}

memcpy((char*)&addr.sin_addr,host->h_addr_list[0], sizeof addr.sin_addr);





//Set non-block
u_long block = 1;

if(ioctlsocket(sock,FIONBIO,&block) == SOCKET_ERROR)
{
WSACleanup();
closesocket(sock);
return ConnectError;	
}



ret= connect(sock,(SOCKADDR*)&addr,sizeof addr);
if(ret == SOCKET_ERROR) 
{
 if (WSAGetLastError() !=WSAEWOULDBLOCK)
{
 
WSACleanup()	;
closesocket(sock);
return ConnectError;	
}


fd_set fdrd, fdwr;

FD_ZERO(&fdrd);
FD_SET(sock, &fdrd);
FD_ZERO(&fdwr);
FD_SET(sock, &fdwr);

timeval tm = {0};
tm.tv_sec = 6; //6sec timeout
tm.tv_usec = 5; 

ret = select(0, NULL,&fdrd, &fdwr,&tm);

if (ret < 0)
{
WSACleanup()	;
closesocket(sock);
return ConnectError;
}


if (ret == 0)
{
WSACleanup()	;
closesocket(sock);
return ConnectTimo;
}


} //nn block


//ret to block
block = 0;
if (ioctlsocket(sock, FIONBIO,&block) == SOCKET_ERROR)
{
WSACleanup();
closesocket(sock);
return ConnectError;
}
	
return Socket_OK;
	
}





















//--------------------------------------------------------
//            SOCKET RECV  
//--------------------------------------------------------
ULONG RecvSock(char *recvbuf,UINT64 len)
{

fd_set rds;
int ret;
timeval tm = {0};
tm.tv_sec = 5; //5sec timeout
tm.tv_usec = 0; 

	
FD_ZERO(&rds);
FD_SET(sock, &rds);

ret = select(0, &rds, NULL, NULL, &tm);
if (ret < 0)
{
FD_CLR(sock,&rds);
printf("ERROR recv==%d\n",ret);
return ConnectError;
}


if (ret == 0)
{
printf("ERROR recv Timeout (No data)==%d\n",ret);
FD_CLR(sock,&rds);
return ConnectTimo;
}



if (ret >0)
{
//printf("Data Avaiable==%d\n",ret);
ret=recv(sock, recvbuf, len, 0) ;
//printf("Incomming data==%d\n",ret);
FD_CLR(sock,&rds);
return ret;
}


FD_CLR(sock,&rds);
return Socket_OK;
}


















//whitespace ----------------------------
int whitespace(BYTE b)
{
if(b== 0x20 )
return 1; //white space found
else return 0;	
}

















//-------- extract host-----------------------
char *extracthost(char *link)
{
int i;
string fixed;
int HTTP=0;
int found=0;
int lastpos=0;



if(strlen(link)<5)
return NULL;

for(i=0 ; i<strlen(link) ;i++)	
{
if(found=whitespace(link[i])==0)
break;	
}	

string tmplink(link);

if(i>0)
{
fixed = tmplink.substr(found);
}
else
{
fixed =tmplink;
}


//bypass HTTP---------------------------------
found= fixed.find("http://");
if(found ==-1)
{
found= fixed.find("https://");	
if(found==-1)
{
 // NO HTTPS
 HTTP=-1;
}
else
{
HTTP=1;	
tmplink=fixed.substr(found+8);
}
}
else
{

HTTP=1;
tmplink=fixed.substr(found+7);	

}

if(HTTP==1)
fixed=tmplink;




found=-1;
//Get host---------
for(i=0 ; i<strlen(link) ;i++)	
{
if( (fixed[i] ==':' )  || (fixed[i] =='/'))
{
found=i;
break;
}
}

if(found==-1)
return NULL;


tmplink ="";
tmplink.insert(0,fixed.c_str(),found);
return (char*)tmplink.c_str();

}


















//--- Process link-----------------------------
int Process_link(char *link,string *host,int *port,string *rst)
{
int i;
string fixed;
int HTTP=0;
int found=0;
int lastpos=0;


*rst="";
if(strlen(link)<5)
return -1;

for(i=0 ; i<strlen(link) ;i++)	
{
if(found=whitespace(link[i])==0)
break;	
}	

string tmplink(link);

if(i>0)
{
fixed = tmplink.substr(found);
}
else
{
fixed =tmplink;
}



//bypass HTTP---------------------------------
found= fixed.find("http://");
if(found ==-1)
{
found= fixed.find("https://");	
if(found==-1)
{
 // NO HTTPS
 HTTP=-1;
}
else
{
HTTP=1;	
tmplink=fixed.substr(found+8);
}
}
else
{

HTTP=1;
tmplink=fixed.substr(found+7);	

}

if(HTTP==1)
fixed=tmplink;


//--------------------------------------------



found=-1;
//Get host---------
for(i=0 ; i<strlen(link) ;i++)	
{
if( (fixed[i] ==':' )  || (fixed[i] =='/'))
{
found=i;
break;
}
}

if(found==-1)
return -1;


tmplink ="";
tmplink.insert(0,fixed.c_str(),found);
*host = tmplink;

fixed= fixed.substr(found+1);





found=-1;
//GET PORT-------------------
for(i=0 ; i<strlen(fixed.c_str()) ;i++)	
{
if(fixed[i] =='/')
{
found=i;
break;
}
}


if(found==-1)
{

*port=80;  //force default
*rst = fixed.substr(lastpos);
}


else
{
lastpos=found;	
tmplink ="";

tmplink.insert(0,fixed.c_str(),found);

for(i=0 ; i<strlen(tmplink.c_str()) ;i++)	
{
if( (fixed[i] >='0') && (fixed[i] <='9') )
continue;
else
{
found=-1;
break;
}
}


if(found==-1 || strlen(tmplink.c_str())<2) //port err force make it  80
{
*port=80;
}
else
{
i=stoi(tmplink.c_str());
*port=i;
}


*rst = fixed.substr(lastpos);


}

return 1;
	
}





















string itos(int port)
{
std::stringstream s;
s << port;
return s.str();
	
}































int getRemote_filename_n_subGarbage(unsigned char *data,ULONG size,string *fname,HANDLE hp)
{
int found,S;
char filename[1000]={0};
*fname="";
string cl;
found=-1;
for (S=0;S<size-5;S++)	
{
if ((data[S]=='f') && (data[S+1]=='i') && (data[S+2]=='l') && (data[S+3]=='e') && (data[S+4]=='n') && (data[S+5]=='a') &&
    (data[S+6]=='m')	&& (data[S+7]=='e'))
    {
    	found=S+7;
    	break;
	}
}

if(found==-1)
{
*fname="default_0001.m3u";
}
	
else
{
// bypass ="
found+=3;
for (S=0;S<size;S++)
{
	if(data[S+found]==0x22) //"
	break;
	filename[S]= data[S+found];
}

if(S<1000)
{
*fname=filename;
}
else
{
*fname="default_0001.m3u";
}

}



//dell garbage-----------------------------------
found=-1;

for (S=0;S<size-3;S++)	
{
if ( (data[S+0]==0x0D) && (data[S+1]==0x0A) && (data[S+2]==0x0D) && (data[S+3]==0x0A) )
    {
    	found=S+3+2;
    	break;
	}
}




if(found==-1)
{
return -2; // Separation not founf (/r/r/n/r/r/n)
}



if(found>size)
return -3;




//last step find length content
int lenfound =-1;
for (S=0;S<size-13;S++)	
{
if ((data[S]=='C') && (data[S+1]=='o') && (data[S+2]=='n') && (data[S+3]=='t') && (data[S+4]=='e') && (data[S+5]=='n') &&
    (data[S+6]=='t') && (data[S+7]=='-') && (data[S+8]=='L') && (data[S+9]=='e') && (data[S+10]=='n') && (data[S+11]=='g')
	&& (data[S+12]=='t') && (data[S+13]=='h'))
    {
    	lenfound=S+13 +1+1;
    	break;
	}
}



if(lenfound==-1)
{
return -4;// Data len not found ????
}


//get it
memset(filename,0,1000);
for (S=0;S<size;S++)
{
if(data[S+lenfound]==0x0D) //"
break;
filename[S]= data[S+lenfound+1];
}


if(S==size-1) //reach fin and not get the datalen
return -5;

if(strlen(filename)<=0)
return -6;

string clt(&filename[0],&filename[strlen(filename)]);

for(S=0;S<strlen(filename);S++)
if(filename[S] <'0' && filename[S] >'9' )
return -8;

//printf("a %d\n",stoi(clt.c_str()));
//printf("b %d\n",size-found);

if(  (stoi(clt.c_str())!= size-found) && (stoi(clt.c_str())!= size-found+1)  )
return -7;



return found;
	
}




































//------------------------------------------------------
//           IPT LINK CHECKER
//------------------------------------------------------
int IsIpTvLink(char *data)
{

int found;
int j;
char adress[5000]={0};
unsigned long ADDR=0;






int i=0;
if    ( ((data[i]=='H') || (data[i]=='h')) &&  ((data[i+1]=='T') || (data[i+1]=='t')) &&
       ((data[i+2]=='T') || (data[i+2]=='t')) && ((data[i+3]=='p') || (data[i+3]=='P')) &&	
	   (data[i+4]==':' ) && (data[i+5]=='/' ) && (data[i+6]=='/' ) )

{


//sub http

//chack address

for(j=0;j<strlen(data)-6;j++)
{
if(data[j+7]=='/' || data[j+7]==':')	//check breaker
break;
adress[j]=data[j+7]; //copy
}




if(j>strlen(data)) //end reached
return -1;





//retreive addr from lnk
ADDR=inet_addr(adress);

if(ADDR==INADDR_NONE || ADDR==INADDR_ANY)
{
return -2;
}

return 99;	
}












else if ((data[0]!='H') || (data[0]!='h')) //link das not have http 'lookup for //
{

found=-1;
for(i=0;i<strlen(data);i++)
if ((data[i]=='/') && (data[i+1]=='/')) 
{
found=1;
break;	
}

if(found==-1) return -1; //bad link






//sub unknow proto

//chack address

for(j=0;j<strlen(data)-6;j++)
{
if(data[j+i+2]=='/' || data[j+i+7]==':')	//check breaker
break;
adress[j]=data[j+i+2]; //copy
}


if(j>strlen(data)) //end reached
return -1;


//retreive addr from lnk
ADDR=inet_addr(adress);

if(ADDR==INADDR_NONE || ADDR==INADDR_ANY)
{

return -2;

}


return 98;	

}




else	
return -99;
}






























//------------------------------------------------------
//           Channeles & LINK
//------------------------------------------------------
int GetCh(unsigned char *data,ULONG pos,ULONG size)
{
ULONG i;
ULONG chpos=0;
ULONG comma=-1;
char channel[5000] = {0}; //max = 5000
char link[5000] = {0}; //max = 5000




//
for(i=pos;i<size;i++)	//look from extinf  to , (dis must be smaller than 256)
{
//look for comma
if(data[i]==',')
{
comma = i;
break;
}
}

if(comma==-1)
return -1; //comma not found maybe bad line

if(i>=size) //end of data reached (nothing found)
return -1;




//copy chanell 
chpos = comma+1;
for(i=0;i<size-2;i++)	//look for chaneel linebreak - eoln 
{
//copy chanell & break if endline reached-----------------
if  ( (data[chpos+i]==0x0D) && (data[chpos+i+1]==0x0A) || (chpos+i==size)) 
{
break;
}


if(i>=5000) return -2; //limit reached = 5000
channel[i]=data[i+chpos];
}



//bypass
chpos=chpos+i+2;



//get link of this chanel---------------------------------
for(i=0;i<size-2;i++)	//look for link breakif eokn found
{
//copy chanell & break if endline reached-----------------
if  ( (data[chpos+i]==0x0D) && (data[chpos+i+1]==0x0A) || (chpos+i==size)) 
{
break;
}

if(i>=5000) return -2;//limit reached = 5000
link[i]=data[i+chpos];
}




///check len
if(strlen(channel)<=0 || strlen(link)<=0)
return -4; //Bad Channel informtion




//check link validity
i= IsIpTvLink(link);
if( i<0)
return -5;// INVALID LINK




//insert to list
string ch(channel);
string lnk(link);

chlst.insert(HCHLST::value_type(ch,lnk));

return 1;



}



























//--------------------------------------------------
//       PARSE CHANNELS
//--------------------------------------------------
int update_map(unsigned char *data,ULONG size)
{
ULONG i;
ULONG pos=0;
ULONG chpos=0;
ULONG retc=0;
char channel[1000];


//
printf("\nParsing channel List ...Please Wait\n");

pos=-1;
//EXTM3U
for(i=0;i<size-5;i++)	
{
if ( (data[i]=='E')	&& (data[i+1]=='X') && (data[i+2]=='T') && (data[i+3]=='M') && (data[i+4]=='3') && (data[i+5]=='U') )
{
pos=i+5+2;	
break;
}
	
}

if(pos==-1) //nothing new (EXTM3U not found) ??
return -1;







chpos=-1;
//restart from pos : looking forchannel name----------
for(i=pos;i<size-10;i++)	
{

//Chanell name------
if ( (data[i]=='#')	&& (data[i+1]=='E') && (data[i+2]=='X') && (data[i+3]=='T') && (data[i+4]=='I') && (data[i+5]=='N') && (data[i+6]=='F'))
{

chpos=i+7+1;	
retc  =  GetCh(data,chpos,size); //<<------------ Get channel
if(retc<0)
printf("Error: Cant Get Channel ..Ignore & Pass to Next Line\n");
}

	
	
}



if(chpos==-1) //nothing new (EXTINF not found =BAD LINE) ??
return -2;




if(chlst.size()<=0)
return -3; // Error  (No channel)
printf("\nTotal Channel found: %d\n",chlst.size());




	
}

































int Go_Show()
{
string cmd="";
DWORD   bw;
std::map<string,string>::iterator it;





pipe = CreateFile("\\\\.\\pipe\\MKPlayer", GENERIC_READ | GENERIC_WRITE, 0,NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
if (pipe == INVALID_HANDLE_VALUE)
{
printf(" .Error -> Cant Access to PLYR\n");
return 0;
}



for(it = chlst.begin() ;it !=chlst.end(); ++it)	
{

cmd=cmd + it->first+'\n'+it->second+'\n';

if( strlen(cmd.c_str())<100000 )
if(strlen(cmd.c_str()) < chlst.size())
continue;

if(!WriteFile(pipe, cmd.c_str(), strlen(cmd.c_str()), &bw, NULL))
{
cout << " .Error -> Cant Send Data to Player\n" << endl << endl;
return 0;
}

//printf("data sended\n %s\n",cmd.c_str());

cmd=""; //clear

}

printf("Terminate\n\n");

DisconnectNamedPipe(pipe);
CloseHandle(pipe);//Close the pipe







}









int go_search(string chn)
{





ULONG i=0;
int idx=0;
printf("::: Total: %d :::\n\n",chlst.size())	;

std::map<string,string>::iterator it;
	
for(it = chlst.begin() ;it !=chlst.end(); ++it)	
{
//if(first.c_str()
if (it->first.find(chn.c_str())!=-1)
{
printf("Channel found: ( %s ) index  ( %d )\n",it->first.c_str(),idx);
}
idx++;
}

printf("\n\n")	;
	












}
























int Show_CH(string filename, unsigned char *buf,ULONG fsize)
{
	
int inputuser;
string chn;


STARTUPINFO si;
PROCESS_INFORMATION pi;
ZeroMemory( &si, sizeof(si) );
si.cb = sizeof(si);
ZeroMemory( &pi, sizeof(pi) );


TerminateProcess(XHP,0);
//__Run__
CreateProcess(PLY_PATH.c_str(),NULL,NULL,NULL,false,CREATE_NEW_CONSOLE,NULL,NULL,&si,&pi);

XHP=pi.hProcess;


int trytry =0;
retry:
printf("\nLooking For PLAYER . . . please wait\n");
Sleep(4000);
HWND FWND = FindWindowA(NULL,"PLYR");
if(FWND == NULL)
{
printf("\nExternal Player is Not Running ! retry...\n\n");
if (trytry >=3)
return -1;

trytry++;
goto retry;
}



printf("-------------------- :: MENU :: --------------------\n\n");
printf(" .1: goto player\n");
printf(" .2: Export m3u\n");
printf(" .3: Return \n\n");

cin >> inputuser;


if(inputuser == 1)
{
Go_Show();
return 0;	
}




//save file
else if(inputuser == 2)
{
//-------------------Save Data------------------------------------
FILE *f;
f = fopen ( filename.c_str() , "w" );
if(f==NULL)
{
printf("cant save file !!!\n");
fclose(f);
return -1;
}

fwrite(buf,1,fsize,f);
fclose(f);
return 0;	
}





else if(inputuser == 3)
{
return 0;	
}

else
{
printf("Unreconized !\n")	;
return 0;
}

//
	
	
}























int main(int argc, char** argv) 
{

GET get;

char buf[100];
int linkmode=0;
char recvbuf[10000];//1MO
unsigned char *buffer;
unsigned char *buffer2;
int d_avail=0;
UINT64 sum=0;
HANDLE hp;
string host;
string rst;
int port;
ULONG ret;
int retc;
string fname;
string IPTVLINK="";
string OLDIPTVLINK="";



PLY_PATH="pl\\Player.exe";


ACTIVE=0;


if(OLDIPTVLINK.length()<=0)
linkmode=1; //new


redo:  //---------------------------------------


	
host="";
port=0;
rst="";
fname="";


memset(buf,0,100);
memset(recvbuf,0,10000);
//----------------------- Process LINK ----------------------



 if(linkmode==1) //new link & file
{
printf(".1: Input your Link then press Ok\n\n");
printf(".2: Load From File (res.iptv)  ---Note: iptvFile must be in the same location as EXE\n\n");

 //cin >> ret;
 cin >> ret;
 

 if(ret==1) //nw link
 {


 printf("::New Link::\n");
cin >> IPTVLINK;
 //check it
if(IPTVLINK.length()<=0)
goto redo;
}




else if(ret==2) //Load From File
{
char arrayiptv[][512]={0};
printf("::Loading::\n");
ifstream ipf("res.iptv");
if(!ipf.is_open())
{
printf("Cant open IPTV File...\n\n")	;
goto redo;
}

int found=-1;
int iptvidx = 0;
while(!ipf.eof())
{
getline(ipf,IPTVLINK);
if(IPTVLINK.length()>0)
{
found=1;
//add to array
strcpy(arrayiptv[iptvidx],IPTVLINK.c_str());
iptvidx++;
//break;
}
}

if(found==-1)
{

printf("This file is corrupted\n")	;
ipf.close();
goto redo;
}

ipf.close();

//List ALL iptvlink
if(iptvidx>0)
{
for(int y=0;y<iptvidx;y++)	
printf(" :: %d - lnk: %s\n",y, extracthost(arrayiptv[y]));
printf("\n\n------------------------------------\n\n");
}

else //no link
{
printf("Err [ No link found !!!]\n");
goto redo;
}

//chhose IPTV TO CONNECT TO:
printf("Select Host:\n");
int chs;
cin >> chs;


if (cin.fail())
{
cin.clear();
cin.ignore();
goto redo;
}



if ((chs>=0) && (chs<iptvidx))
{
strcpy((char*)IPTVLINK.c_str(),arrayiptv[chs]);	
}

else 
{
printf("Bad CMD !!!\n");
goto redo;
}



}


else
{
printf("BAD CMD ! !!\n\n");
return 0;
}


}




else if(linkmode!=0 && linkmode!=1)
{
printf("Bad CMD\n\n");
goto redo ;
}








ret = Process_link((char*)IPTVLINK.c_str(),&host,&port,&rst);
if(ret==-1)
{
if(buffer!=NULL)
free(buffer);
Clean();
}

printf("Host:  %s\n",host.c_str() );
printf("Port:  %d\n",port);
//printf("Rest:  %s\n",rst.c_str() );




if(buffer!=NULL)
buffer = (unsigned char*)malloc(10000);
else
buffer = (unsigned char*)realloc(buffer,10000);


//----------------------CONNECT------------------------------  
ret=initSock((char*)host.c_str(),port);
if(ret != Socket_OK) //err code 
{

if(ret == ConnectTimo)
{
printf("\n\nErr (%d) Timeout \n\n",ConnectTimo)	;
if(buffer!=NULL)
free(buffer);
Clean();
goto redo;	
}

printf("cant''t Connect !!! exit\n")	;
if(buffer!=NULL)
free(buffer);
Clean();
goto redo;
}


//------------------------UPDATE--------------------------------------------
get.http= "1.1";
get.host=host+":"+itos(port);
get.ContentType="html/multipart";
get.accept="text/html";
get.userAgent=" Mozilla/2.0 (Windows; U; Windows NT 6.1; fr; rv:4.2.1.3) Gecko/20070 Firefox/10.0.0.3";
get.Connection="keep-alive";
get.rest = rst;

GET_PROTO="GET "+get.rest+" HTTP/"+get.http+"\r\nHost: "+get.host+"\r\nUser-Agent"+get.userAgent+"\r\nConnection: "+get.Connection+"\r\n\r\n";








//--------------SAVE LINK-----------------------
OLDIPTVLINK=IPTVLINK;

//senf GET CMD-------------
ret = send(sock, (char*)GET_PROTO.c_str(), GET_PROTO.length(), 0);
if(ret  == SOCKET_ERROR )
{
printf("Send [Err]\n");
if(buffer!=NULL)
free(buffer);
Clean();
goto redo;
}


printf("Send/Recv ...\n\n");












//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
//recv every 10000 byte-------------------
d_avail=1;
int idx=0;
sum=0;
UINT64 packlen=10000;
int timorerr=0;
int FAKE=0;

while(d_avail)
{

//ret=recv(sock, recvbuf, 10000, 0) ;
memset(recvbuf,0,10000);
ret= RecvSock(recvbuf,packlen);

if(FAKE>30) //
{
//printf("Server not response !!!\n");
break;
}
if(ret==0) //no data redo 30 time if nothing exit loop ..FAKE SERVER OR SERV WONT SEND DATA TO US 
FAKE++;

if(ret==ConnectError)
{
timorerr=-1;
break;
}



if(ret==ConnectTimo)
{
break;//timeout or end of data 
}


if(ret>0) //data in
{
FAKE=0;
sum += ret;
//printf("sum=: %d\n",sum);
buffer=(unsigned char*)realloc(buffer,sum);
memcpy(buffer+(sum-ret),recvbuf,ret);

}





}


//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------


//timeout
if(timorerr==-1 &&FAKE>30)
{
timorerr=0;
if(buffer!=NULL)
free(buffer);
Clean();
goto redo;

}



if(sum<10) //data notenougth
{
if(buffer!=NULL)
free(buffer);
Clean();
goto redo;
}






//----------------Resize & GETNAME------------------------------
ret = getRemote_filename_n_subGarbage(buffer,sum,&fname,hp);
printf("Error Code:  %d\n",ret);
if(ret==-1 || ret==-2 || ret==-3)
{
if(buffer!=NULL)
free(buffer);
Clean();
goto redo;
}



else if(ret==-4)
{
printf("Bad Data len reconnectiong .......\n");
free(buffer);
Clean();
Sleep(3000);
goto redo;// < ------- Sleep & jump to send GET CMD
}

else if(ret==-5)
{
printf("Some data not found try again \n");
free(buffer);
Clean();
Sleep(3000);
goto redo;// < ------- Sleep & jump to send GET CMD
}


else if(ret==-6 || ret==-7)
{
printf("Invalid len (!) \n");
free(buffer);
Clean();
Sleep(3000);
goto redo;// < ------- Sleep & jump to send GET CMD
}


else if(ret==-8)
{
//printf("Error (ret) \n"); //len != number
free(buffer);
Clean();
Sleep(3000);
goto redo;// < ------- Sleep & jump to send GET CMD
}






//--------------- Realloc & Move DATA----------------------------
buffer2 = (unsigned char*)malloc(sum-ret);
memcpy(buffer2,buffer+ret,sum-ret);

printf("Iptv Filename: %s\n",fname.c_str());







//---------Update Map----------------------------
update_map(buffer2,sum-ret);








// --
int userinput;
BOOL lp=true;
int inp;




while(lp)
{

printf("\n\nIPTV Cmd :\n\n1: print Channels List\n2: Reconnect\n3: Exit\n");
cin >> userinput;

switch(userinput)	
{


case 1:
{
printf("-----------------------------------------\n");
printf("[+] Channels List\n");
printf("-----------------------------------------\n")	;

retc=Show_CH(fname,buffer2,sum-ret); //<< ------- show ch list
if(retc==-1)
{
if(buffer!=NULL)
free(buffer);
if(buffer2!=NULL)
free(buffer2);
Clean();
goto redo;	
}
break;
}





case 2:
{
printf("-----------------------------------------\n");	
printf("[+] Reconnect\n");
printf("-----------------------------------------\n")	;
printf("Destroying ...\n");
if(buffer!=NULL)
free(buffer);
if(buffer2!=NULL)
free(buffer2);
Clean();


//NEW LINK OT USE THE SAME
relink:
printf("\n\n.1: New link\n.2: Use same Link\n");
cin >> inp;
if(inp==1)
linkmode=1;
else if(inp==2)
linkmode=0;
else
goto relink;

goto redo;
break;
}



case 3:
{
lp=false;
break;
}

default:
printf("[-] Cmd not reconized !\n");	

}


}






//------------------Clean -----------------------------------

if(buffer!=NULL)
free(buffer);
if(buffer2!=NULL)
free(buffer2);

Clean();

system("pause");

return 0;
}
