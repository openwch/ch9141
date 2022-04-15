#include <stdio.h>
#include "stdafx.h"
#include <commdlg.h.>
#include "resource.h"
ULONG AfxDbgI = 0;

extern CWnd *MainCwnd;
/*****���Ժ���****/

//���������Ϣ���ļ���
BOOL PrintToFile(PUCHAR Buffer,//��ӡ��Ϣ
				 ULONG OLen,   //��ӡ��Ϣ����
				 BOOL IsChar){ //��ӡ��Ϣ���ַ���ʽ��ʾ��������ֵ��ʽ��ʾ
	char tembuf[1000]="";
	CHAR tem[10]="";
	HANDLE DFileHandle;
	DWORD nNumberOfBytesToWrite,i;
	DFileHandle = CreateFile("DbgInfor.txt",GENERIC_READ|GENERIC_WRITE,FILE_SHARE_WRITE|FILE_SHARE_READ,NULL,OPEN_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,NULL);
	if(DFileHandle==INVALID_HANDLE_VALUE)
		return FALSE;
	nNumberOfBytesToWrite=OLen;
	ZeroMemory(tembuf,sizeof(tembuf));
	if(!IsChar){
		for(i=0;i<OLen;i++){
			sprintf(tem,"%02X",Buffer[i]);
			strcat(tembuf,tem);			
		}
		strcat(tembuf,"\r\n");
		nNumberOfBytesToWrite=OLen*2+1;
	}
	else{		
		strcpy(tembuf,(PCHAR)Buffer);
		strcat(tembuf,"\r\n\0");
		nNumberOfBytesToWrite=strlen((PCHAR)Buffer);
	}
	SetFilePointer(DFileHandle,0,NULL,FILE_END);
	WriteFile(DFileHandle,tembuf,nNumberOfBytesToWrite,&nNumberOfBytesToWrite,NULL);
	CloseHandle(DFileHandle);
	return FALSE;
}


VOID  DbgPrint (LPCTSTR lpFormat,...)
{   
	CHAR TextBufferTmp[5120]=""; 	
	{
		SYSTEMTIME lpSystemTime;
		GetLocalTime(&lpSystemTime);
		sprintf(TextBufferTmp,"%04d#%02d:%02d:%02d:%03d>> \0",AfxDbgI++,	
			lpSystemTime.wHour ,lpSystemTime.wMinute ,lpSystemTime.wSecond,lpSystemTime.wMilliseconds );
	}
	va_list arglist;
	va_start(arglist, lpFormat);
	//strcpy(TextBufferTmp,"        ");
	vsprintf(&TextBufferTmp[strlen(TextBufferTmp)],lpFormat,arglist);
	va_end(arglist);
	strcat(TextBufferTmp,"\r\n");
	
	OutputDebugString(TextBufferTmp);
	//SendDlgItemMessage(MainHwnd,IDC_Infor,LB_ADDSTRING,0,(LPARAM)(LPCTSTR)TextBufferTmp);
	
	SendDlgItemMessage(MainCwnd->m_hWnd,IDC_EDIT_TESTLOG,EM_SETSEL,0xFFFFFFFE,0xFFFFFFFE);
	SendDlgItemMessage(MainCwnd->m_hWnd,IDC_EDIT_TESTLOG,EM_REPLACESEL,0,(LPARAM)TextBufferTmp);
	SendDlgItemMessage(MainCwnd->m_hWnd,IDC_EDIT_TESTLOG,EM_SETSEL,0xFFFFFFFE,0xFFFFFFFE);
	
	//  LeaveCriticalSection (&AfxDbgPrintCr);   
	return ;
}



/*��ʮ�������ַ�ת����ʮ������,����ת�����ַ���ltoa()����*/
ULONG mStrToBcd(PCHAR str) 
{  
	char mlen,i=0;
	UCHAR iChar=0,Char[9]="";
	UINT mBCD=0,de=1;
	mlen=strlen(str);
	memcpy(Char,str,mlen);
	for(i=mlen-1;i>=0;i--)
	{	iChar=Char[i];
	if ( iChar >= '0' && iChar <= '9' )
		mBCD = mBCD+(iChar -'0')*de;
	else if ( iChar >= 'A' && iChar <= 'F' ) 
		mBCD =mBCD+ (iChar - 'A' + 0x0a)*de;
	else if ( iChar >= 'a' && iChar <= 'f' )
		mBCD =mBCD+ (iChar - 'a' + 0x0a)*de;
	else return(0);
	de*=16;
	}
	return(mBCD);
}

double GetCurrentTimerVal(){//��ȡӲ��������������ʱ��,msΪ��λ,��GetTickCount��׼ȷ
	LARGE_INTEGER litmp; 
	double dfFreq,QPart1; 
	QueryPerformanceFrequency(&litmp);  //Ƶ����HZΪ��λ
	dfFreq = (double)litmp.QuadPart;    //��ü�������ʱ��Ƶ��
	QueryPerformanceCounter(&litmp);
	QPart1 = (double)litmp.QuadPart;        //��ó�ʼֵ
	return(QPart1 *1000/dfFreq  );  //��ö�Ӧ��ʱ��ֵ=�񵴴���/��Ƶ�ʣ���λΪ��
}

//��ʱ����,��msΪ��λ
VOID DelayTime1(double TimerVal){//��ʱֵΪms,�䶨ʱ���һ�㲻����0.5΢�룬������CPU�Ȼ��������й�
	LARGE_INTEGER litmp; 
	LONGLONG QPart1,QPart2;
	double dfMinus, dfFreq, dfTim,NewTimerVal; 
	NewTimerVal = TimerVal*0.001;       //��ms��ʱֵת��sֵ
	QueryPerformanceFrequency(&litmp);  //Ƶ����HZΪ��λ
	dfFreq = (double)litmp.QuadPart;    //��ü�������ʱ��Ƶ��
	QueryPerformanceCounter(&litmp);
	QPart1 = litmp.QuadPart;            //��ó�ʼֵ
	do{
		QueryPerformanceCounter(&litmp);
		QPart2 = litmp.QuadPart;        //�����ֵֹ
		dfMinus = (double)(QPart2-QPart1);
		dfTim = dfMinus / dfFreq;       //��ö�Ӧ��ʱ��ֵ=�񵴴���/��Ƶ�ʣ���λΪ��		
	}while(dfTim<NewTimerVal);
	return;
}

/*��ʾ�ϴ����д���*/
void ShowLastError(LPCTSTR lpFormat,...) 
{
	DWORD LastResult=0; // pointer to variable to receive error codes	
	char szSysMsg[100],tem[1000]="";
	CHAR TextBufferTmp[5120]=""; 	

	{
		SYSTEMTIME lpSystemTime;
		GetLocalTime(&lpSystemTime);
		sprintf(TextBufferTmp,"%04d#%02d:%02d:%02d:%03d>> \0",AfxDbgI++,	
			lpSystemTime.wHour ,lpSystemTime.wMinute ,lpSystemTime.wSecond,lpSystemTime.wMilliseconds );
	}
	
	va_list arglist;
	va_start(arglist, lpFormat);
	vsprintf(&TextBufferTmp[strlen(TextBufferTmp)],lpFormat,arglist);
	va_end(arglist);

	LastResult=GetLastError();
	FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM,0,LastResult,
		MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),szSysMsg,sizeof(szSysMsg),0);
	sprintf(&TextBufferTmp[strlen(TextBufferTmp)],":Last Err(%x)%s",LastResult,szSysMsg);	

	OutputDebugString(TextBufferTmp);
	SendDlgItemMessage(MainCwnd->m_hWnd,IDC_EDIT_TESTLOG,EM_SETSEL,0xFFFFFFFE,0xFFFFFFFE);
	SendDlgItemMessage(MainCwnd->m_hWnd,IDC_EDIT_TESTLOG,EM_REPLACESEL,0,(LPARAM)TextBufferTmp);
	SendDlgItemMessage(MainCwnd->m_hWnd,IDC_EDIT_TESTLOG,EM_SETSEL,0xFFFFFFFE,0xFFFFFFFE);
}