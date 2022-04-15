#ifndef  _CH9140DLL_H
#define  _CH9140DLL_H


#ifdef __cplusplus
extern "C" {
#endif

typedef void (CALLBACK* pFunReadCallBack)(void* ParamInf,PCHAR ReadBuf,ULONG ReadBufLen);
typedef void (CALLBACK* pFunDevConnChangeCallBack)(void*  hDev, UCHAR ConnectStatus);
typedef void (CALLBACK* pFunRSSICallBack)(PCHAR pMAC, int rssi, UCHAR ChipVer);
typedef void (CALLBACK* pFunRecvModemCallBack)(void* hDev, BOOL DCD,BOOL RI, BOOL DSR, BOOL CTS );
typedef void* CH9140HANDLE;
struct BLENameDevID
{
	UCHAR Name[MAX_PATH];
	UCHAR DevID[MAX_PATH];
	int  Rssi;
	UCHAR ChipVer;
};
void WINAPI CH9140Init();
BOOL WINAPI CH9140IsBluetoothOpened();
UCHAR WINAPI CH9140GetBluetoothVer();

void WINAPI CH9140EnumDevice(ULONG scanTimes, PCHAR DevNameFilter, BLENameDevID* pBLENameDevIDArry, PULONG pNum);
CH9140HANDLE WINAPI CH9140UartOpenDevice(char* DevID, pFunDevConnChangeCallBack pFun, pFunRecvModemCallBack pModem, pFunReadCallBack pRead);
int  WINAPI  CH9140UartWriteBuffer(CH9140HANDLE DevHandle, char* buf, int buflen);
BOOL WINAPI  CH9140UartSetSerialBaud(CH9140HANDLE DevHandle, int baudRate, int dataBit, int stopBit, int parity);
BOOL WINAPI  CH9140UartSetSerialModem(CH9140HANDLE DevHandle, bool flow, int DTR, int RTS);

CH9140HANDLE WINAPI CH9140OpenDevice(PCHAR deviceID, pFunDevConnChangeCallBack pFunDevConnChange);
void WINAPI CH9140CloseDevice(CH9140HANDLE pDev);
UCHAR WINAPI CH9140GetAllOpHandle(CH9140HANDLE pDev, PUSHORT pHandleArry, PUSHORT pHandleArryLen);
UCHAR WINAPI CH9140GetHandleAction(CH9140HANDLE pDev, USHORT AttributeHandle, PULONG pAction);
UCHAR WINAPI CH9140WriteBuffer(CH9140HANDLE pDev, USHORT AttributeHandle, BOOL bWriteWithResponse, PCHAR buffer, UINT length);
UCHAR WINAPI CH9140ReadBuffer(CH9140HANDLE pDev, USHORT AttributeHandle, PCHAR buffer, PUINT pLength);
UCHAR WINAPI CH9140RegisterReadNotify(CH9140HANDLE pDev, USHORT AttributeHandle, pFunReadCallBack pFun, void* paramInf);
UCHAR WINAPI CH9140RegisterRSSINotify(pFunRSSICallBack pFun);
UCHAR WINAPI CH9140GetMtu(CH9140HANDLE pDev, PUSHORT pMTU);
BOOL WINAPI CH9140GetCfgPara(CH9140HANDLE pDev, PCHAR buf);
BOOL WINAPI CH9140SetCfgPara(CH9140HANDLE pDev, PCHAR buf);
BOOL WINAPI CH9140ResetCfgPara(CH9140HANDLE pDev);
BOOL WINAPI CH9140GetExdCfg(CH9140HANDLE pDev, PCHAR buf);
BOOL WINAPI CH9140SetExdCfg(CH9140HANDLE pDev, PCHAR buf);
BOOL WINAPI CH9140ResetExdCfg(CH9140HANDLE pDev);
BOOL WINAPI CH9140ResetCh(CH9140HANDLE pDev);

#ifdef __cplusplus
}
#endif

#endif