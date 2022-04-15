#ifndef WIDGET_H
#define WIDGET_H

#include "CH9140LIB/CH9140lib.h"
#include <QWidget>
#include <QAction>
#include <QDebug>
#include <QRegExp>
#include <string.h>
#include <QList>
#include <QMessageBox>
#include <QByteArray>
#include <QButtonGroup>
#include <QByteArray>
#include <QTextCodec>
#include <QPlainTextEdit>
#include <QDesktopWidget>

#define BLESCAN_TIMEOUT 2   // 蓝牙单次扫描时间定义
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
    void CH9140BleDemoInit();
    void SignalSlotDef();
    void InitUartSetElement();
    void InitModemSetElement(bool state);
    void ControlNotification(bool state);
    void StrHexExchange(QPlainTextEdit *plainText,bool mode);
    void closeEvent(QCloseEvent *event);
    static Ui::Widget *S_Widget;
    static Widget *T_Widget;
    static void BleAdvertisingDeviceInfo(const char *addr, const char *name, int8_t rssi, uint8_t *chipVer);
    static void ConnectionState(CH9140HANDLE *connection, int state);
    static void DisconnectStateCallBack(void *arg);
    static void NotificationCallBack(const uuid_t* uuid, const uint8_t* data, size_t data_length);
    static void GetDevModemSignal(bool DCD, bool RING, bool DSR, bool CTS);
    ~Widget();

private:
    CH9140HANDLE *connection = NULL;
    uint16_t MTU = 0;
    char *UuidRecord = NULL;
    bool OpenDevState = true;
    bool OpenNotificationState= true;
    const char Notify_FFF1[10] = "0xfff1";
    const char Notify_FFF3[10] = "0xfff3";
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

    void SetUartArgSlot();
    void SetHardFlowSlot(bool state);
    void SetRtsDtrSignalSlot();

    void IsHexShowSlot(bool state);
    void IsHexSendSlot(bool state);
    void InputHexContentSlot();
    void SendInputContentSlot();
    void ClearPlaintextContentSlot(int buttonId);
};

#endif // WIDGET_H
