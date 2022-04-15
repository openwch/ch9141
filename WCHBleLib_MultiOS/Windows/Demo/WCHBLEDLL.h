#ifndef  _WCHBLEDLL_H
#define  _WCHBLEDLL_H


#ifdef __cplusplus
extern "C" {
#endif
typedef void (CALLBACK* pFunReadCallBack)(void* ParamInf, PCHAR ReadBuf, ULONG ReadBufLen);
typedef void (CALLBACK* pFunDevConnChangeCallBack)(void* hDev, UCHAR ConnectStatus);
typedef void (CALLBACK* pFunRSSICallBack)(PCHAR pMAC, int rssi);
typedef void* WCHBLEHANDLE;
struct BLENameDevID
{
	UCHAR Name[MAX_PATH];
	UCHAR DevID[MAX_PATH];
	int  Rssi;
};
void WINAPI WCHBLEInit();
BOOL WINAPI WCHBLEIsBluetoothOpened();
UCHAR WINAPI WCHBLEGetBluetoothVer();
BOOL WINAPI WCHBLEIsLowEnergySupported();
BOOL WINAPI WCHBLEIsPeripheralRoleSupported();
BOOL WINAPI WCHBLEIsCentralRoleSupported();
BOOL WINAPI WCHBLEAreLowEnergySecureConnectionsSupported();
BOOL WINAPI WCHBLEIsAdvertisementOffloadSupported();
void WINAPI WCHBLEEnumDevice(ULONG scanTimes, PCHAR DevNameFilter, BLENameDevID* pBLENameDevIDArry, PULONG pNum);
void WINAPI WCHBLEEnumCH914X(ULONG scanTimes, BLENameDevID* pBLENameDevIDArry, PULONG pNum);
WCHBLEHANDLE WINAPI WCHBLEOpenDevice(PCHAR deviceID, pFunDevConnChangeCallBack pFunDevConnChange);
void WINAPI WCHBLECloseDevice(WCHBLEHANDLE pDev);
UCHAR WINAPI WCHBLEGetAllServicesUUID(WCHBLEHANDLE pDev, PUSHORT pUUIDArry, PUSHORT pUUIDArryLen);
UCHAR WINAPI WCHBLEGetCharacteristicByUUID(WCHBLEHANDLE pDev, USHORT ServiceUUID, PUSHORT pUUIDArry, PUSHORT pUUIDArryLen);
UCHAR WINAPI WCHBLEGetCharacteristicAction(WCHBLEHANDLE pDev, USHORT ServiceUUID, USHORT CharacteristicUUID, PULONG pAction);
UCHAR WINAPI WCHBLEWriteCharacteristic(WCHBLEHANDLE pDev, USHORT ServiceUUID, USHORT CharacteristicUUID, BOOL bWriteWithResponse, PCHAR buffer, UINT length);
UCHAR WINAPI WCHBLEReadCharacteristic(WCHBLEHANDLE pDev, USHORT ServiceUUID, USHORT CharacteristicUUID, PCHAR buffer, PUINT length);
UCHAR WINAPI WCHBLERegisterReadNotify(WCHBLEHANDLE pDev, USHORT ServiceUUID, USHORT CharacteristicUUID, pFunReadCallBack pFun, void* paramInf);
UCHAR WINAPI WCHBLERegisterRSSINotify(pFunRSSICallBack pFun);
UCHAR WINAPI WCHBLEGetMtu(WCHBLEHANDLE pDev, PUSHORT pMTU);
#ifdef __cplusplus
}
#endif

#endif