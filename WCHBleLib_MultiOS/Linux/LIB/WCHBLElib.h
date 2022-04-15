#ifndef __WCHBLELIB_H__
#define __WCHBLELIB_H__

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>
#include <stdbool.h>
#include <bluetooth/bluetooth.h>
#include <bluetooth/sdp.h>
#include <bluetooth/sdp_lib.h>

typedef struct _gatt_connection_t WCHBLEHANDLE;
//回调函数
typedef void(*FunConnectionStateCallBack)(WCHBLEHANDLE* connection,int state);

typedef void (*FunRegisterNotifyCallBack)(const uuid_t* uuid, const uint8_t* data, size_t data_length);

typedef void(*FunDisconnectionStateCallBack)(void* user_data);

typedef void (*FunDiscoverDeviceAdvInfo)(const char* addr, const char* name, int8_t rssi);

typedef struct {
	uint16_t  attr_handle_start; 
	uint16_t  attr_handle_end;   
	uuid_t    uuid;             
} GattPrimaryService;


typedef struct {
	uint16_t  handle;        
	uint8_t   properties;    
	uuid_t    uuid;          
} GattCharacteristic;

int WCHBLEGetBluetoothVer();

bool WCHBLEIsLowEnergySupported();

int WCHBle_BLE_Scan(int ScanTime, FunDiscoverDeviceAdvInfo Ble_AdvertisingDevice_Info);

WCHBLEHANDLE *WCHBle_Connect( const char *mac, FunConnectionStateCallBack connectionstate);

void WCHBle_Disconnect(WCHBLEHANDLE* connection);

void WCHBle_register_on_disconnect(WCHBLEHANDLE* connection, FunDisconnectionStateCallBack disconnection_state);

int WCHBle_Discover_Primary(WCHBLEHANDLE* connection, GattPrimaryService* Services, int* Services_Count);

int WCHBle_Discover_Characteristics(WCHBLEHANDLE* connection, const char* ServiceHandle, GattCharacteristic* Characteristics, int* Characteristics_Count);

int WCHBle_Read_Char_by_UUID(WCHBLEHANDLE* connection, const char* CharacteristicUUID, char* Buffer, size_t* Buffer_Length);

int WCHBle_Write_Characteristic(WCHBLEHANDLE* connection, const char* CharacteristicUUID, bool WriteWithResponse, const char* Buffer, size_t Buffer_Length);

void WCHBle_register_notification(WCHBLEHANDLE* connection, FunRegisterNotifyCallBack notification_handler);

int WCHBle_Open_Notification(WCHBLEHANDLE* connection, const char* CharacteristicUUID);

int WCHBle_Close_Notification(WCHBLEHANDLE* connection, const char* CharacteristicUUID);

int WCHBle_Get_MTU(WCHBLEHANDLE* connection, const char* CharacteristicUUID, uint16_t* mtu);

void WCHBle_Set_Secondary_Advertising(uint32_t phy);

void WCHBle_Set_PHY_TX_RX(uint32_t phys);

int Gatt_UUID_to_Str(const uuid_t *CharacteristicUUID, char *str, size_t size);

int Gatt_Str_to_UUID(const char *str, size_t size, uuid_t *CharacteristicUUID);

int Gatt_UUID_Cmp(const uuid_t *CharacteristicUUID1, const uuid_t *CharacteristicUUID2);


#ifdef __cplusplus
}
#endif

#endif
