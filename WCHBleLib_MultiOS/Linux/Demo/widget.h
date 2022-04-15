#ifndef WIDGET_H
#define WIDGET_H

#include "WCHBLElib/WCHBLElib.h"
#include <QWidget>
#include <QAction>
#include <QDebug>
#include <QRegExp>
#include <string.h>
#include <QMessageBox>
#include <QByteArray>
#include <QButtonGroup>
#include <QByteArray>
#include <QTextCodec>
#include <QPlainTextEdit>
#include <QDesktopWidget>

#define BLESCAN_TIMEOUT 3   // 蓝牙单次扫描时间定义
#define BLE_SUCCESS     0
#define BLE_FAILED      1

typedef struct node {
    int id;
    QString mac_addr;
    QString name;
    int8_t rssi;
    int upTime;
    uint8_t *ChipVersion;
} bleMac;

Q_DECLARE_METATYPE(node)

namespace Ui {
class Widget;
}

class Widget : public QWidget
{
    Q_OBJECT

public:
    explicit Widget(QWidget *parent = 0);
    void WCHBleDemoInit();
    void SignalSlotDef();
    void DisableGetFunc();
    void DisableBleFunc();
    void StrHexExchange(QPlainTextEdit *plainText,bool mode);
    void closeEvent(QCloseEvent *event);
    static Ui::Widget *S_Widget;
    static Widget *T_Widget;
    static void BleAdvertisingDeviceInfo(const char* addr, const char* name, int8_t rssi);
    static void ConnectionState(WCHBLEHANDLE *connection, int state);
    static void DisconnectStateCallBack(void *arg);
    static void NotificationCallBack(const uuid_t* uuid, const uint8_t* data, size_t data_length);
    ~Widget();

private:
    WCHBLEHANDLE *connection = NULL;
    char *UuidRecord = NULL;
    bool OpenDevState = true;
    bool OpenNotificationState= true;
    QStringList attr_handle_list;
    QAction *AboutPage;
    QButtonGroup   *ReceviceSendBtGroup;
    QDesktopWidget *Desktop;
    Ui::Widget *ui;

signals:
    void DevDisconnectSignal();

private slots:
    void ShowAboutPageSlot();
    void GetBluetoothVerSlot();
    void FlushBleDevSlot();
    void OpenBleDevSlot();
    void DisonnectActionSlot();
    void GetBleSeriviceSlot();
    void GetBleCharacteristicsSlot();
    void ClearBleFuncSlot(int index);

    void GetActionSlot();
    void OpenNotificationSlot();
    void ReadBleDataSlot();
    void WriteBleDataSlot();

    void IsHexShowSlot(bool state);
    void IsHexSendSlot(bool state);
    void InputHexContentSlot();
    void ClearPlaintextContentSlot(int buttonId);
};

#endif // WIDGET_H
