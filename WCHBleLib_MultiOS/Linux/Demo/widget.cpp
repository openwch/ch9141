#include "widget.h"
#include "ui_widget.h"

/* 全局变量区 */
Ui::Widget *Widget::S_Widget = nullptr;
Widget *Widget::T_Widget = nullptr;
static bool HexShow = false;
static bool HexSend = false;
bleMac bleDevInfo;
QList<bleMac> DevList;
QList<GattCharacteristic> GattCharacteristicList;

Widget::Widget(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Widget)
{
    ui->setupUi(this);

    /* 初始化 */
    WCHBleDemoInit();
    DisableGetFunc();
    DisableBleFunc();
    SignalSlotDef();
}

/* 
 *  功能：初始化窗体并设置部分控件属性
 */
void Widget::WCHBleDemoInit()
{
    S_Widget = ui;
    T_Widget = this;

    this->setFixedSize(this->frameGeometry().width(),this->frameGeometry().height());

    Desktop = QApplication::desktop();
    move((Desktop->width() - this->width()) / 2, (Desktop->height() - this->height()) / 2);

    AboutPage = new QAction(this);
    AboutPage->setText(tr("关于WCHBleDemo(About)"));
    addAction(AboutPage);
    setContextMenuPolicy(Qt::ActionsContextMenu);

    ui->tableWidget_BleDev->setEditTriggers(QAbstractItemView::NoEditTriggers);
    ui->tableWidget_BleDev->setSelectionBehavior(QAbstractItemView::SelectRows);
    ui->tableWidget_BleDev->setSelectionMode(QAbstractItemView::SingleSelection);

    ui->tableWidget_BleDev->setColumnWidth(0,150);
    ui->tableWidget_BleDev->setColumnWidth(1,300);
    ui->tableWidget_BleDev->setColumnWidth(2,150);

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
    connect(ui->BtGetService,SIGNAL(clicked(bool)),this,SLOT(GetBleSeriviceSlot()));
    connect(ui->BtGetchara,SIGNAL(clicked(bool)),this,SLOT(GetBleCharacteristicsSlot()));
    connect(ui->comboBox_Chara,SIGNAL(currentIndexChanged(int)),this,SLOT(ClearBleFuncSlot(int)));

    connect(ui->BtGetAction,SIGNAL(clicked(bool)),this,SLOT(GetActionSlot()));
    connect(ui->BtOpenNotify,SIGNAL(clicked(bool)),this,SLOT(OpenNotificationSlot()));
    connect(ui->BtReadFunc,SIGNAL(clicked(bool)),this,SLOT(ReadBleDataSlot()));
    connect(ui->BtWriteFUnc,SIGNAL(clicked(bool)),this,SLOT(WriteBleDataSlot()));

    connect(ui->checkBox_HexShow,SIGNAL(clicked(bool)),this,SLOT(IsHexShowSlot(bool)));
    connect(ui->checkBox_HexSend,SIGNAL(clicked(bool)),this,SLOT(IsHexSendSlot(bool)));
    connect(ui->plainTextEdit_SendData,SIGNAL(textChanged()),this,SLOT(InputHexContentSlot()));
    connect(ReceviceSendBtGroup,SIGNAL(buttonClicked(int)),this,SLOT(ClearPlaintextContentSlot(int)));
    connect(this,SIGNAL(DevDisconnectSignal()),this,SLOT(DisonnectActionSlot()));
}

/* 
 *  功能：将获取类控件恢复初始化
 */ 
void Widget::DisableGetFunc()
{
    ui->BtGetService->setDisabled(true);
    ui->BtGetchara->setDisabled(true);
    ui->BtGetAction->setDisabled(true);

    ui->comboBox_Serivices->clear();
    ui->comboBox_Chara->clear();
}

/* 
 *  功能：将操作类按键恢复初始化
 */ 
void Widget::DisableBleFunc()
{
    if (QString::compare(ui->BtOpenNotify->text(),"关闭订阅") == 0) {
        OpenNotificationState = true;
        ui->BtOpenNotify->setText("打开订阅");
    }
    ui->BtOpenNotify->setDisabled(true);
    ui->BtReadFunc->setDisabled(true);
    ui->BtWriteFUnc->setDisabled(true);
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
        WCHBle_Disconnect(connection);
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
void Widget::BleAdvertisingDeviceInfo(const char *addr, const char *name, int8_t rssi)
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
void Widget::ConnectionState(WCHBLEHANDLE *connection, int state)
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

    recvdata = QByteArray((char *)data, data_length);

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
    QApplication::processEvents();
}

/* 
 *  功能：显示 “关于WCHBleDemo” 信息 
 */ 
void Widget::ShowAboutPageSlot()
{
    QMessageBox AboutSoft(QMessageBox::NoIcon, "关于WCHBleDemo", "WCHBleDemo, 版本1.0\n版权所有（C）2021");
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
    int ret = WCHBLEGetBluetoothVer();
    if (ret == -1) {
        QMessageBox::critical(this,"WCHBleDemo", "设备查询超时!", "确定");
    } else if (ret == -2) {
        QMessageBox::critical(this,"WCHBleDemo", "系统蓝牙未打开!", "确定");
    } else {
        QString str = "控制器版本为" +versionList.at(ret);
        QMessageBox::information(this,"WCHBleDemo", str, "确定");
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
    ret = WCHBle_BLE_Scan(BLESCAN_TIMEOUT, BleAdvertisingDeviceInfo);
    if (ret == BLE_FAILED) {
        QMessageBox::critical(this, "WCHBleDemo", "请先打开系统蓝牙!", "确定");
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
            QMessageBox::warning(this, "WCHBleDemo", "打开设备失败!", "确定");
            return ;
        }

        QString macAddr = ui->tableWidget_BleDev->item(rowID, 1)->text();

        char *mac_addr = NULL;
        QByteArray temp = macAddr.toLatin1();
        mac_addr = temp.data();

        /* 通过蓝牙MAC地址进行连接，返回WCHBLEHANDLE *类型结构体指针 */
        connection = WCHBle_Connect(mac_addr,ConnectionState);
        if (connection == NULL) {
            /* 连接失败则返回值为NULL */
            QMessageBox::warning(this, "WCHBleDemo", "打开设备失败!", "确定");
        } else {
            OpenDevState = false;
            ui->BtGetService->setDisabled(false);
            ui->BtOpenDev->setText(tr("关闭设备"));
            /* 注册断开连接回调 */
            WCHBle_register_on_disconnect(connection,DisconnectStateCallBack);
            /* 打开通知 */
            WCHBle_register_notification(connection, NotificationCallBack);
        }
    } else {
        /* 断开连接 */
        OpenDevState = true;
        ui->comboBox_Serivices->clear();
        ui->comboBox_Chara->clear();
        DisableGetFunc();
        DisableBleFunc();
        ui->BtOpenDev->setText(tr("打开设备"));

        WCHBle_Disconnect(connection);
    }
}

/* 
 *  功能：蓝牙意外断开连接后处理函数 
 */ 
void Widget::DisonnectActionSlot()
{
    QMessageBox::information(this, "WCHBleDemo", "蓝牙连接已断开!", "确定");
    if (connection) {
        WCHBle_Disconnect(connection);
        DisableBleFunc();
        DisableGetFunc();
        OpenDevState = true;
        ui->BtOpenDev->setText("打开设备");
    }
}

/* 
 * 功能：获取服务 
 */
void Widget::GetBleSeriviceSlot()
{
    /* 用于存储连接设备的服务值 */
    GattPrimaryService services[10] = { 0 };
    int services_count;
    char uuid_str[MAX_LEN_UUID_STR+1];
    int ret, i;
    QStringList serviceList;

    if (ui->comboBox_Serivices->count())
        ui->comboBox_Serivices->clear();

    attr_handle_list.clear();

    /* 获取设备服务值 */
    ret = WCHBle_Discover_Primary(connection, services, &services_count);
    if (ret != BLE_SUCCESS) {
        fprintf(stderr, "Fail to discover primary services.\n");
        exit(1);
    }

    for (i = 0; i < services_count; i++) {
        Gatt_UUID_to_Str(&services[i].uuid, uuid_str, sizeof(uuid_str));
        serviceList << QString(uuid_str).toUpper().mid(2);
        attr_handle_list << QString(uuid_str).toUpper().mid(2) ;
        attr_handle_list << QString("%1").sprintf("%04x",services[i].attr_handle_start);
        qDebug("service[%d] start_handle:0x%04x end_handle:0x%04x uuid:%s\n", i,
                services[i].attr_handle_start, services[i].attr_handle_end,
                uuid_str);
    }

    if (!serviceList.isEmpty()) {
        qSort(serviceList.begin(),serviceList.end(),[](const QString &S1, const QString &S2)
        {return S1 < S2;});
        ui->comboBox_Serivices->addItems(serviceList);
        ui->BtGetchara->setDisabled(false);
    } else {
        QMessageBox::warning(this, "WCHBleDemo", "获取服务失败!", "确定");
    }
}

/* 
 *  功能：获取特征值 
 */ 
void Widget::GetBleCharacteristicsSlot()
{
    /* 用于存储连接设备的特征值 */
    GattCharacteristic characteristics[200] = { 0 };
    int characteristics_count;
    char uuid_str[MAX_LEN_UUID_STR+1] = { 0 };
    int ret, i, id;
    QStringList characteristicList;

    if (ui->comboBox_Chara->count())
        ui->comboBox_Chara->clear();

    QString service = ui->comboBox_Serivices->currentText();
    for (i = 0; i < attr_handle_list.size(); i++) {
        if (attr_handle_list.at(i) == service) {
            id = i;
            break;
        }
    }

    QString temp = attr_handle_list.at(id+1);
    char *handle;
    QByteArray data = temp.toLower().toLatin1();
    handle = data.data();

    /* 获取设备特征 */
    ret = WCHBle_Discover_Characteristics(connection, handle, characteristics, &characteristics_count);
    if (ret != BLE_SUCCESS) {
        fprintf(stderr, "Fail to discover characteristics.\n");
        qDebug() << "Fail to discover characteristics." << endl;
        exit(1);
    }

    for (i = 0; i < characteristics_count; i++) {
        Gatt_UUID_to_Str(&characteristics[i].uuid, uuid_str, sizeof(uuid_str));
        characteristicList << QString(uuid_str).toUpper().mid(2);
        GattCharacteristicList << characteristics[i];
        qDebug("characteristic[%d] properties:0x%02x handle:0x%04x uuid:%s\n", i,
                characteristics[i].properties, characteristics[i].handle,
                uuid_str);
    }

    if (!characteristicList.isEmpty()) {
        qSort(characteristicList.begin(),characteristicList.end(),[](const QString &S1, const QString &S2)
        {return S1 < S2;});
        ui->comboBox_Chara->addItems(characteristicList);
        ui->BtGetAction->setDisabled(false);
    } else {
        QMessageBox::warning(this, "WCHBleDemo", "获取特征失败!", "确定");
    }
}

/* 
 *  功能：切换特征值的同时初始化功能性按键 
 */ 
void Widget::ClearBleFuncSlot(int index)
{
    DisableBleFunc();
}

/* 
 *  功能：获取当前特征值下可执行操作 
 */ 
void Widget::GetActionSlot()
{
    int i = 0;
    uint8_t properties;
    char uuid_str[MAX_LEN_UUID_STR+1] = {0};;
    QByteArray recvdata;
    QString uuid, uuid_t;
    uuid = ui->comboBox_Chara->currentText().insert(0,"0x").toLower();

    for (i = 0; i < GattCharacteristicList.length(); i++) {
        /* 将UUID转换为char *型数据 */
        Gatt_UUID_to_Str(&GattCharacteristicList.at(i).uuid, uuid_str, sizeof(uuid_str));
        
        recvdata = QByteArray(uuid_str);
        uuid_t = recvdata.data();
        if (QString::compare(uuid, uuid_t) == 0) {
            properties = GattCharacteristicList.at(i).properties;
        }
        recvdata.clear();
        uuid_t.clear();
    }

    if ((properties & 0x02) == 0x02) {
        ui->BtReadFunc->setDisabled(false);
    }

    if ((properties & 0x04) == 0x04) {
        ui->BtWriteFUnc->setDisabled(false);
    }

    if ((properties & 0x08) == 0x08) {
        ui->BtWriteFUnc->setDisabled(false);
    }

    if ((properties & 0x10) == 0x10) {
        ui->BtOpenNotify->setDisabled(false);
    }
}

/* 
 *  功能：打开通知 
 */ 
void Widget::OpenNotificationSlot()
{
    int ret = -1;
    char *uuid_t = NULL;
    char *closeUuid = NULL;
    QByteArray temp;
    QString uuid = ui->comboBox_Chara->currentText().insert(0,"0x").toLower();
    temp = uuid.toLocal8Bit();
    uuid_t = temp.data();

    if (OpenNotificationState) {
        /* 打开对应特征标识通知 */
        ret = WCHBle_Open_Notification(connection, uuid_t);
        if (ret != BLE_SUCCESS) {
            fprintf(stderr, "Open notification failed\n");
            return ;
        }
        UuidRecord = uuid_t;
        OpenNotificationState = false;
        ui->BtOpenNotify->setText(tr("关闭订阅"));
    } else {
        /* 关闭通知 */
        if (UuidRecord == NULL) {
            closeUuid = uuid_t;
        } else {
            closeUuid = UuidRecord;
            UuidRecord = NULL;
        }
        ret = WCHBle_Close_Notification(connection, closeUuid);
        if (ret != BLE_SUCCESS) {
            fprintf(stderr, "close notification failed\n");
            return ;
        }
        OpenNotificationState = true;
        ui->BtOpenNotify->setText(tr("打开订阅"));
    }
}

/* 
 *  功能：读取特征值 
 */ 
void Widget::ReadBleDataSlot()
{
    uint8_t buffer[256] = { 0 };
    char *uuid_t = NULL;
    size_t length;
    QByteArray temp, data;
    QString uuid, tempData;

    int ret, i;
    QString str, str_temp;

    uuid = ui->comboBox_Chara->currentText().insert(0,"0x").toLower();
    temp = uuid.toLocal8Bit();
    uuid_t = temp.data();
    qDebug("Read UUID = %s\n",uuid_t);

    /* 读取设备特征值 */
    ret = WCHBle_Read_Char_by_UUID(connection, uuid_t, (char *)buffer, &length);
    if (ret != BLE_SUCCESS) {
        qDebug("read handle = %s failed\n",uuid_t);
    }

    QByteArray recvdata((char *)buffer);

    for (i = 0; i < recvdata.length(); i++) {
        str_temp.sprintf("%02x ", (uint8_t)recvdata.at(i));
        str += str_temp.toUpper();
    }

    QStringList hexToStr;
    hexToStr = str.split(" ");
    for (i = 0; i < hexToStr.length(); i++) {
        tempData = hexToStr.at(i);
        data += QByteArray::fromHex(tempData.toUtf8());
    }

    if (!HexShow) {
        str = data.data();
    }

    ui->plainTextEdit_RecvData->insertPlainText(str);
}

/* 
 *  功能：写入特征值 
 */ 
void Widget::WriteBleDataSlot()
{
    uint8_t buffer[256] = { 0 };
    char *uuid_t = NULL;
    int buf_len = 0;
    int ret = 0;
    int i = 0;
    QString str, uuid;
    QByteArray buf, temp;

    uuid = ui->comboBox_Chara->currentText().insert(0,"0x").toLower();
    temp = uuid.toLocal8Bit();
    uuid_t = temp.data();

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

    memcpy((void *)buffer, (void *)buf.data(), buf.length());
    buf_len = buf.length();

    if (buf_len > 1024) {
        QMessageBox::warning(this, "WCHBleDemo", "超过发送缓冲区(1024B)大小", "确定");
        return ;
    }

    /* 写入设备特征值 */
    ret = WCHBle_Write_Characteristic(connection, uuid_t, true, (char *)buffer, buf_len);
    if (ret != BLE_SUCCESS) {
        QMessageBox::information(this, "WCHBleDemo", "传输出错", "确定");
        return;
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

