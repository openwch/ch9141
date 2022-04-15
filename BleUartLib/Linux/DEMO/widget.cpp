#include "widget.h"
#include "ui_widget.h"

/* 全局变量区 */
Ui::Widget *Widget::S_Widget = nullptr;
Widget *Widget::T_Widget = nullptr;
static bool HexShow = false;
static bool HexSend = false;
bleMac bleDevInfo;
QList<bleMac> DevList;

Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    ui->setupUi(this);

    /* 初始化 */
    CH9140BleDemoInit();
    InitUartSetElement();
    SignalSlotDef();
}

/* 
 *  功能：初始化窗体并设置部分控件属性
 */
void Widget::CH9140BleDemoInit()
{
    S_Widget = ui;
    T_Widget = this;

    this->setFixedSize(this->frameGeometry().width(),this->frameGeometry().height());

    Desktop = QApplication::desktop();
    move((Desktop->width() - this->width()) / 2, (Desktop->height() - this->height()) / 2);

    AboutPage = new QAction(this);
    AboutPage->setText(tr("关于CH9140BleDemo(About)"));
    addAction(AboutPage);
    setContextMenuPolicy(Qt::ActionsContextMenu);

    ui->tableWidget_BleDev->setEditTriggers(QAbstractItemView::NoEditTriggers);
    ui->tableWidget_BleDev->setSelectionBehavior(QAbstractItemView::SelectRows);
    ui->tableWidget_BleDev->setSelectionMode(QAbstractItemView::SingleSelection);

    ui->tableWidget_BleDev->setColumnWidth(0,180);
    ui->tableWidget_BleDev->setColumnWidth(1,332);
    ui->tableWidget_BleDev->setColumnWidth(2,180);

    ReceviceSendBtGroup = new QButtonGroup(this);
    ReceviceSendBtGroup->addButton(ui->BtClearReceive,0);
    ReceviceSendBtGroup->addButton(ui->BtClearSend,1);
}

/* 
 *  功能：连接所使用到的信号槽
 */ 
void Widget::SignalSlotDef()
{
    connect(AboutPage,SIGNAL(triggered(bool)),this,SLOT(ShowAboutPageSlot()));
    connect(ui->BtGetBleVer,SIGNAL(clicked(bool)),this,SLOT(GetBluetoothVerSlot()));
    connect(ui->BtFlushDev,SIGNAL(clicked(bool)),this,SLOT(FlushBleDevSlot()));
    connect(ui->BtOpenDev,SIGNAL(clicked(bool)),this,SLOT(OpenBleDevSlot()));

    connect(ui->BtSetUart,SIGNAL(clicked(bool)),this,SLOT(SetUartArgSlot()));
    connect(ui->checkBox_RTS,SIGNAL(clicked(bool)),this,SLOT(SetRtsDtrSignalSlot()));
    connect(ui->checkBox_DTR,SIGNAL(clicked(bool)),this,SLOT(SetRtsDtrSignalSlot()));
    connect(ui->checkBox_HardFlow,SIGNAL(clicked(bool)),this,SLOT(SetHardFlowSlot(bool)));

    connect(ui->checkBox_HexShow,SIGNAL(clicked(bool)),this,SLOT(IsHexShowSlot(bool)));
    connect(ui->checkBox_HexSend,SIGNAL(clicked(bool)),this,SLOT(IsHexSendSlot(bool)));
    connect(ui->plainTextEdit_SendData,SIGNAL(textChanged()),this,SLOT(InputHexContentSlot()));
    connect(ui->BtSendInput,SIGNAL(clicked(bool)),this,SLOT(SendInputContentSlot()));
    connect(ReceviceSendBtGroup,SIGNAL(buttonClicked(int)),this,SLOT(ClearPlaintextContentSlot(int)));
    connect(this,SIGNAL(DevDisconnectSignal()),this,SLOT(DisonnectActionSlot()));
}

/* 
 *  功能：初始化控件
 */ 
void Widget::InitUartSetElement()
{
    int i = 0;
    ui->BtSetUart->setDisabled(true);
    QList<QCheckBox *> CheckBoxList;
    CheckBoxList << ui->checkBox_CTS << ui->checkBox_DSR << ui->checkBox_RING << ui->checkBox_DCD
                 << ui->checkBox_RTS << ui->checkBox_DTR << ui->checkBox_HardFlow;
    for (i = 0; i < CheckBoxList.length(); i++) {
        CheckBoxList.at(i)->setDisabled(true);
    }
}

/* 
 *  功能：初始化控件
 */ 
void Widget::InitModemSetElement(bool state)
{
    int i = 0;
    QList<QCheckBox *> CheckBoxList;

    CheckBoxList << ui->checkBox_RTS << ui->checkBox_DTR << ui->checkBox_HardFlow
                 << ui->checkBox_CTS << ui->checkBox_DSR << ui->checkBox_RING << ui->checkBox_DCD;

    if (state) {
        for (i = 0; i < CheckBoxList.length(); i++) {
            CheckBoxList.at(i)->setChecked(false);
        }
    }

    for (i = 0; i < 3; i++) {
        CheckBoxList.at(i)->setDisabled(state);
    }
}

/* 
 *  功能：控制通知的打开/关闭
 */ 
void Widget::ControlNotification(bool state)
{
    int ret = 0;
    if (state) {
        ret = CH9140Ble_Open_Notification(connection, Notify_FFF1);
        if (ret != BLE_SUCCESS) {
            qDebug() << "Open notification 0xFFF1 failed\n" << endl;
        }
        ret = CH9140Ble_Open_Notification(connection, Notify_FFF3);
        if (ret != BLE_SUCCESS) {
            qDebug() << "Open notification 0xFFF3 failed\n" << endl;
        }
    } else {
        ret = CH9140Ble_Close_Notification(connection, Notify_FFF1);
        if (ret != BLE_SUCCESS) {
            qDebug() << "close notification 0xFFF1 failed!" << endl;
        }
        ret = CH9140Ble_Close_Notification(connection, Notify_FFF3);
        if (ret != BLE_SUCCESS) {
            qDebug() << "close notification 0xFFF3 failed!" << endl;
        }
    }
}

/* 
 *  功能：当选择 “16进制显示/发送” 时，对对应显示框进行当前内容转换 
 */ 
void Widget::StrHexExchange(QPlainTextEdit *plainText, bool mode)
{
    int i = 0;
    if (mode) {
        QString str_temp, str;
        QByteArray data = plainText->toPlainText().toLocal8Bit();
        for (i = 0; i < data.count(); i++) {
            str_temp.sprintf("%02x ", (uint8_t)data.at(i));
            str += str_temp;
        }
        plainText->clear();
        plainText->setPlainText(str.toUpper());
    } else {
        QString str, str_temp, tempData;
        QByteArray data;
        QStringList hexToStr;
        str_temp = plainText->toPlainText();
        hexToStr = str_temp.split(" ");
        for (i = 0; i < hexToStr.length(); i++) {
            tempData = hexToStr.at(i);
            data += QByteArray::fromHex(tempData.toUtf8());
        }
        str = data.data();
        plainText->clear();
        plainText->setPlainText(str);
    }
}

/* 
 *  功能：软件关闭事件，关闭前断开若还保持蓝牙连接则断开 
 */
void Widget::closeEvent(QCloseEvent *event)
{
    if (connection != NULL) {
        CH9140Ble_Disconnect(connection);
    }
    event->accept();
}

/* 
 *  功能：蓝牙扫描回调函数，在函数获取蓝牙设备信息
 *  参数： 
 *        @addr ：蓝牙MAC地址
 *        @name ：蓝牙设备名称
 *        @rssi ：当前信号值
 */
void Widget::BleAdvertisingDeviceInfo(const char *addr, const char *name, int8_t rssi, uint8_t *chipVer)
{
    int i = 0;
    qDebug() << "inside the callback" << addr  << rssi << name <<endl;
    if (name) {
        bleDevInfo.mac_addr = QString(addr);
        bleDevInfo.name = QString(name);
        bleDevInfo.rssi = rssi;
    } else if (addr) {
        bleDevInfo.mac_addr = QString(addr);
        bleDevInfo.name = "Unknown";
        bleDevInfo.rssi = rssi;
    }
    if (DevList.isEmpty()) {
        DevList << bleDevInfo;
    } else {
        for (i = 0; i < DevList.size(); i++) {
            if (QString::compare(bleDevInfo.mac_addr, DevList[i].mac_addr) == 0) {
                DevList[i].rssi = bleDevInfo.rssi;
                return ;
            }
        }
    }
    QString rs = QString::number(bleDevInfo.rssi);
    S_Widget->tableWidget_BleDev->insertRow(0);
    S_Widget->tableWidget_BleDev->setItem(0, 0, new QTableWidgetItem(bleDevInfo.name));
    S_Widget->tableWidget_BleDev->item(0, 0)->setTextAlignment(Qt::AlignHCenter | Qt::AlignVCenter);
    S_Widget->tableWidget_BleDev->setItem(0, 1, new QTableWidgetItem(bleDevInfo.mac_addr));
    S_Widget->tableWidget_BleDev->item(0, 1)->setTextAlignment(Qt::AlignHCenter | Qt::AlignVCenter);
    S_Widget->tableWidget_BleDev->setItem(0, 2, new QTableWidgetItem(rs));
    S_Widget->tableWidget_BleDev->item(0, 2)->setTextAlignment(Qt::AlignHCenter | Qt::AlignVCenter);
}

/* 
 *  功能：蓝牙连接回调函数 
 */ 
void Widget::ConnectionState(CH9140HANDLE *connection, int state)
{
    if (connection)
        qDebug() << "connect OK!" << endl;
    else
        qDebug() << "connect failed!" << endl;
}

/* 
 *  功能：注册断开连接函数 
 */ 
void Widget::DisconnectStateCallBack(void *arg)
{
    emit T_Widget->DevDisconnectSignal();
}

/* 
 *  功能：蓝牙注册通知回调函数，接收来自设备的数据 
 */
void Widget::NotificationCallBack(const uuid_t *uuid, const uint8_t *data, size_t data_length)
{
    int i = 0;
    QString str, str_temp;
    QTextCursor tc;
    QByteArray recvdata;
    QTextCodec *tcs = QTextCodec::codecForName("GBK");

    char uuid_str[MAX_LEN_UUID_STR + 1] = {0};
    gatt_uuid_to_string(uuid, uuid_str, sizeof(uuid_str));

    recvdata = QByteArray((char *)data, data_length);

    if (strcmp(uuid_str, "0xfff3") == 0) {
        CH9140Ble_Get_Modem_state(data, GetDevModemSignal);
        return ;
    } else {
        if (HexShow) {
            for (i = 0; i < recvdata.count(); i++) {
                str_temp.sprintf("%02x ", (uint8_t)recvdata.at(i));
                str += str_temp.toUpper();
            }
        } else {
            str = tcs->toUnicode(recvdata);
        }

        tc = S_Widget->plainTextEdit_RecvData->textCursor();
        tc.insertText(str);
        S_Widget->plainTextEdit_RecvData->setTextCursor(tc);
        S_Widget->plainTextEdit_RecvData->moveCursor(QTextCursor::End);

        str_temp.clear();
        str.clear();
        recvdata.clear();
    }
    QApplication::processEvents();
}

/* 
 *  功能：Modem状态回调函数
 */ 
void Widget::GetDevModemSignal(bool DCD, bool RING, bool DSR, bool CTS)
{
    S_Widget->checkBox_DCD->setChecked(DCD);
    S_Widget->checkBox_RING->setChecked(RING);
    S_Widget->checkBox_DSR->setChecked(DSR);
    S_Widget->checkBox_CTS->setChecked(CTS);
}

/* 
 *  功能：显示 “关于CH9140BleDemo” 信息
 */ 
void Widget::ShowAboutPageSlot()
{
    QMessageBox AboutSoft(QMessageBox::NoIcon, "关于CH9140BleDemo", "CH9140BleDemo, 版本1.0\n版权所有（C）2021");
    AboutSoft.setButtonText(QMessageBox::Ok, "确定");
    AboutSoft.exec();
}

/* 
 *  功能：获取蓝牙控制器版本号 
 */
void Widget::GetBluetoothVerSlot()
{
    QList<QString> versionList;
    versionList << "1.0" << "1.1" << "1.2" << "2.0" << "2.1" << "3.0" << "4.0" << "4.1" << "4.2" << "5.0" << "5.1" << "5.2" ;
    
    /* 根据返回值获取蓝牙控制器版本 */
    int ret = CH9140BleGetBluetoothVer();
    if (ret == -1) {
        QMessageBox::critical(this,"CH9140BleDemo", "设备查询超时!", "确定");
    } else if (ret == -2) {
        QMessageBox::critical(this,"CH9140BleDemo", "系统蓝牙未打开!", "确定");
    } else {
        QString str = "控制器版本为" +versionList.at(ret);
        QMessageBox::information(this,"CH9140BleDemo", str, "确定");
    }
}

/* 
 *  功能：调用蓝牙扫描函数进行扫描 
 */
void Widget::FlushBleDevSlot()
{
    int count = 0;
    int ret = 0;
    int i = 0;
    count = ui->tableWidget_BleDev->rowCount();
    for (i = count; i >= 0; i--) {
        ui->tableWidget_BleDev->removeRow(i);
    }

    if (!DevList.isEmpty()) {
        DevList.clear();
    }

    /* 执行蓝牙扫描函数，扫描结果可在BleAdvertisingDeviceInfo回调函数中获取 */
    ret = CH9140Ble_BLE_Scan(BLESCAN_TIMEOUT, BleAdvertisingDeviceInfo);
    if (ret == BLE_FAILED) {
        QMessageBox::critical(this, "CH9140BleDemo", "请先打开系统蓝牙!", "确定");
    }
}

/* 
 *  功能：对当前所选设备进行连接 
 */ 
void Widget::OpenBleDevSlot()
{
    if (OpenDevState) {
        /* 连接设备 */
        int rowID = ui->tableWidget_BleDev->currentRow();

        if (rowID == -1) {
            QMessageBox::warning(this, "CH9140BleDemo", "打开设备失败!", "确定");
            return ;
        }

        QString macAddr = ui->tableWidget_BleDev->item(rowID, 1)->text();

        char *mac_addr = NULL;
        QByteArray temp = macAddr.toLatin1();
        mac_addr = temp.data();

        /* 通过蓝牙MAC地址进行连接，返回CH9140BLEHANDLE *类型结构体指针 */
        connection = CH9140Ble_Connect(mac_addr,ConnectionState);
        if (connection == NULL) {
            /* 连接失败则返回值为NULL */
            QMessageBox::warning(this, "CH9140BleDemo", "打开设备失败!", "确定");
        } else {
            OpenDevState = false;
            ui->BtSetUart->setDisabled(false);
            InitModemSetElement(false);
            ui->BtOpenDev->setText(tr("关闭设备"));
            /* 注册断开连接回调 */
            CH9140Ble_register_on_disconnect(connection,DisconnectStateCallBack);
            /* 打开通知 */
            CH9140Ble_register_notification(connection, NotificationCallBack);
            CH9140Ble_Get_MTU(connection, &MTU);
            ControlNotification(true);
        }
    } else {
        /* 断开连接 */
        OpenDevState = true;
        InitUartSetElement();
        InitModemSetElement(true);
        ControlNotification(false);
        ui->BtSetUart->setDisabled(true);
        ui->BtOpenDev->setText(tr("打开设备"));
        CH9140Ble_Disconnect(connection);
    }
}

/* 
 *  功能：蓝牙意外断开连接后处理函数 
 */ 
void Widget::DisonnectActionSlot()
{
    QMessageBox::information(this, "CH9140BleDemo", "蓝牙连接已断开!", "确定");
    if (connection) {
        ControlNotification(false);
        CH9140Ble_Disconnect(connection);
        connection = NULL;
        InitUartSetElement();
        InitModemSetElement(true);
        OpenDevState = true;
        ui->BtOpenDev->setText("打开设备");
    }
}

/* 
 *  功能：设置串口参数
 */ 
void Widget::SetUartArgSlot()
{
    int ret = 0;
    int BaudRate = 0;
    int Databits = 0;
    int Stopbits = 0;
    int ParityCheck = 0;

    BaudRate = ui->comboBox_baudrate->currentText().toInt();
    Databits = ui->comboBox_databits->currentText().toInt();
    Stopbits = ui->comboBox_stopbits->currentText().toInt();
    ParityCheck = ui->comboBox_parity->currentIndex();

    ret = CH9140Ble_Set_SerialBaud(connection, BaudRate, Databits, Stopbits, ParityCheck);
    if (ret != BLE_SUCCESS) {
        QMessageBox::warning(this, "CH9140BleDemo", "设置失败，请重新设置!", "确定");
    } else {
        QMessageBox::information(this, "CH9140BleDemo", "设置串口参数成功", "确定");
    }
}

/* 
 *  功能：设置串口流控
 */ 
void Widget::SetHardFlowSlot(bool state)
{
    int ret = 0;
    if (state) {
        ret = CH9140Ble_Set_Modem(connection, 1, 1, 1);
        qDebug() << ret << endl;
        if (ret == BLE_SUCCESS) {
            QMessageBox::information(this, "CH9140BleDemo", "设置串口流控成功", "确定");
        } else {
            QMessageBox::information(this, "CH9140BleDemo", "设置串口流控失败", "确定");
        }
    } else {
        ret = CH9140Ble_Set_Modem(connection, 0, 0, 0);
        if (ret == BLE_SUCCESS) {
            QMessageBox::information(this, "CH9140BleDemo", "设置串口流控成功", "确定");
        } else {
            QMessageBox::information(this, "CH9140BleDemo", "设置串口流控失败", "确定");
        }
    }
}

/* 
 *  功能：设置modem信号RTS/DTR，流控开启情况下只可控制DTR
 */ 
void Widget::SetRtsDtrSignalSlot()
{
    int ret = 0;
    int RTS = ui->checkBox_RTS->isChecked() ? 1 : 0;
    int DTR = ui->checkBox_DTR->isChecked() ? 1 : 0;
    int Mode = ui->checkBox_HardFlow->isChecked() ? 1 : 0;

    ret = CH9140Ble_Set_Modem(connection, Mode, DTR, RTS);
    if (ret == BLE_SUCCESS) {
        QMessageBox::information(this, "CH9140BleDemo", "设置串口参数成功", "确定");
    } else {
        QMessageBox::information(this, "CH9140BleDemo", "设置串口参数失败", "确定");
    }
}

/* 
 *  功能：HEX接收状态切换 
 */ 
void Widget::IsHexShowSlot(bool state)
{
    if (state) {
        StrHexExchange(ui->plainTextEdit_RecvData, true);
        HexShow = true;
    } else {
        StrHexExchange(ui->plainTextEdit_RecvData, false);
        HexShow = false;
    }
}

/* 
 *  功能：HEX发送状态切换 
 */ 
void Widget::IsHexSendSlot(bool state)
{
    if (state) {
        HexSend = true;
        StrHexExchange(ui->plainTextEdit_SendData, true);
    } else {
        HexSend = false;
        StrHexExchange(ui->plainTextEdit_SendData, false);
    }
}

/* 
 *  功能：当处于HEX发送状态时对输入进行处理 
 */ 
void Widget::InputHexContentSlot()
{
    QString content = ui->plainTextEdit_SendData->toPlainText();
    if (HexSend && (!content.isEmpty())) {
        content = ui->plainTextEdit_SendData->toPlainText();
        if (content.at(content.length()-1) == " ") {
            return ;
        } else {
            content.remove(QRegExp("\\s"));
            int length = content.length();
            int yu = length%2;
            if (yu == 0) {
                ui->plainTextEdit_SendData->insertPlainText(" ");
            }
        }
    }
}

/* 
 *  功能：发送输入框内容
 */ 
void Widget::SendInputContentSlot()
{
    QString str;
    QByteArray buf;
    char *buffer;
    int i = 0;
    int ret = 0;
    int mlen = 0;
    int buf_len = 0;
    const char *handle = "0xfff2";

    if (ui->plainTextEdit_SendData->toPlainText().isEmpty()) {
        QMessageBox::warning(this, "CH9140BleDemo", "发送框不能为空", "确定");
        return;
    }

    str = ui->plainTextEdit_SendData->toPlainText();

    if (HexSend) {
        str.remove(QRegExp("\\s"));
        if (str.length()%2)
            str.insert(str.length(),"0");
        for (i = 0; i < str.length(); i += 2) {
            buf[i/2] = (str.mid(i,2).toInt(nullptr,16))&0xFF;
        }
    } else {
        buf = str.toLocal8Bit();
    }

    buffer = buf.data();
    buf_len = strlen(buffer);
    if (buf_len > 4096) {
        QMessageBox::warning(this, "CH9140BleDemo", "超过发送缓冲区大小", "确定");
        return ;
    }

    if (connection != NULL) {
        /* 根据MTU值将数据进行分包发送 */
        while(buf_len) {
            if (buf_len > MTU-3) {
                ret = CH9140Ble_Write_Characteristic(connection, handle, true, buffer+mlen, MTU-3);
                if (ret != BLE_SUCCESS) {
                    QMessageBox::information(this, "CH9140BleDemo", "传输出错", "确定");
                    return;
                }
                buf_len -= MTU-3;
                mlen += MTU-3;
                buffer += MTU-3;
            } else {
                ret = CH9140Ble_Write_Characteristic(connection, handle, true, buffer, buf_len);
                if (ret != BLE_SUCCESS) {
                    QMessageBox::information(this, "CH9140BleDemo", "传输出错", "确定");
                    return;
                }
                buffer += buf_len;
                buf_len = 0;
            }
        }
    }
}

/* 
 *  功能：清空数据显示框 
 */ 
void Widget::ClearPlaintextContentSlot(int buttonId)
{
    switch (buttonId) {
    case 0:
        ui->plainTextEdit_RecvData->clear();
        break;
    case 1:
        ui->plainTextEdit_SendData->clear();
        break;
    }
}

/* 
 *  功能：析构函数 
 */ 
Widget::~Widget()
{
    delete ui;
}

