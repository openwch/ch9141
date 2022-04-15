#ifndef __GATTLIB_H__
#define __GATTLIB_H__

#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>
#include <stdbool.h>

#include <bluetooth/bluetooth.h>
#include <bluetooth/sdp.h>
#include <bluetooth/sdp_lib.h>

typedef struct _gatt_connection_t CH9140HANDLE;
//回调函数
typedef void(*FunConnectionStateCallback)(CH9140HANDLE *connection,int state);

typedef void(*FunGetModemStateCallback)(bool DCD, bool RI, bool DSR, bool CTS);

typedef void (*FunRegisterNotifyCallback)(const uuid_t *uuid, const uint8_t *data, size_t data_length);

typedef void(*FunDisconnectionStateCallback)(void *user_data);

typedef void (*FunDiscoverDeviceInfo)(const char *addr, const char *name, int8_t rssi, uint8_t *ChipVer);

//结构体
typedef struct {
	uint16_t  attr_handle_start; 
	uint16_t  attr_handle_end;   
	uuid_t    uuid;             
} gatt_primary_service;


typedef struct {
	uint16_t  handle;        
	uint8_t   properties;   //特征属性值:broadcast/read/write without response/write with response/notification/... 
	uuid_t    uuid;          
} gatt_characteristic;

//函数接口
int CH9140BleGetBluetoothVer();

int CH9140Ble_BLE_Scan(int ScanTime, FunDiscoverDeviceInfo Ble_AdvertisingDevice_Info);

CH9140HANDLE *CH9140Ble_Connect( const char *mac, FunConnectionStateCallback connectionstate);

void CH9140Ble_Disconnect(CH9140HANDLE *connection);

void CH9140Ble_register_on_disconnect(CH9140HANDLE *connection, FunDisconnectionStateCallback disconnection_state);

int CH9140Ble_discover_primary(CH9140HANDLE *connection, gatt_primary_service *services, int *services_count);

int CH9140Ble_discover_characteristics(CH9140HANDLE *connection, const char *ServiceHandle, gatt_characteristic *characteristics, int *characteristics_count);

int CH9140Ble_Read_Char_by_Handle(CH9140HANDLE *connection, uint16_t handle, char *buffer, size_t *buffer_length);

int CH9140Ble_Write_Characteristic(CH9140HANDLE *connection, const char *CharacteristicUUID, bool WriteWithResponse, const void *buffer, size_t buffer_length);

void CH9140Ble_register_notification(CH9140HANDLE *connection, FunRegisterNotifyCallback notification_handler);

int CH9140Ble_Open_Notification(CH9140HANDLE *connection, const char *CharacteristicUUID);

int CH9140Ble_Close_Notification(CH9140HANDLE *connection, const char *CharacteristicUUID);

int CH9140Ble_Get_MTU(CH9140HANDLE *connection, uint16_t *mtu);

int CH9140Ble_Set_SerialBaud(CH9140HANDLE *connection, int BaudRate, int DataBit, int StopBit, int Parity);

int CH9140Ble_Set_Modem(CH9140HANDLE *connection, int flow, int DTR, int RTS);

int CH9140BleUart_Write_Buffer(CH9140HANDLE *connection, char *buffer, int buffer_length, uint16_t mtu);

void CH9140Ble_Get_Modem_state(const uint8_t *data, FunGetModemStateCallback getmodemstate);

int gatt_uuid_to_string(const uuid_t *uuid, char *str, size_t size);

int gatt_string_to_uuid(const char *str, size_t size, uuid_t *uuid);

int gatt_uuid_cmp(const uuid_t *uuid1, const uuid_t *uuid2);

#ifdef __cplusplus
}
#endif

#endif
