/********************************************************************************
** Form generated from reading UI file 'widget.ui'
**
** Created by: Qt User Interface Compiler version 5.9.1
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_WIDGET_H
#define UI_WIDGET_H

#include <QtCore/QVariant>
#include <QtWidgets/QAction>
#include <QtWidgets/QApplication>
#include <QtWidgets/QButtonGroup>
#include <QtWidgets/QCheckBox>
#include <QtWidgets/QComboBox>
#include <QtWidgets/QGridLayout>
#include <QtWidgets/QHBoxLayout>
#include <QtWidgets/QHeaderView>
#include <QtWidgets/QLabel>
#include <QtWidgets/QPlainTextEdit>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QSpacerItem>
#include <QtWidgets/QTableWidget>
#include <QtWidgets/QVBoxLayout>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_Widget
{
public:
    QGridLayout *gridLayout;
    QVBoxLayout *verticalLayout_4;
    QHBoxLayout *horizontalLayout;
    QVBoxLayout *verticalLayout;
    QSpacerItem *verticalSpacer_2;
    QPushButton *BtGetBleVer;
    QPushButton *BtFlushDev;
    QPushButton *BtOpenDev;
    QSpacerItem *verticalSpacer;
    QTableWidget *tableWidget_BleDev;
    QHBoxLayout *horizontalLayout_2;
    QPushButton *BtGetService;
    QComboBox *comboBox_Serivices;
    QSpacerItem *horizontalSpacer;
    QPushButton *BtGetchara;
    QComboBox *comboBox_Chara;
    QHBoxLayout *horizontalLayout_3;
    QPushButton *BtGetAction;
    QSpacerItem *horizontalSpacer_4;
    QPushButton *BtOpenNotify;
    QSpacerItem *horizontalSpacer_5;
    QPushButton *BtReadFunc;
    QSpacerItem *horizontalSpacer_6;
    QPushButton *BtWriteFUnc;
    QSpacerItem *horizontalSpacer_7;
    QHBoxLayout *horizontalLayout_6;
    QVBoxLayout *verticalLayout_2;
    QHBoxLayout *horizontalLayout_4;
    QLabel *label_RecvArea;
    QSpacerItem *horizontalSpacer_2;
    QCheckBox *checkBox_HexShow;
    QPushButton *BtClearReceive;
    QPlainTextEdit *plainTextEdit_RecvData;
    QVBoxLayout *verticalLayout_3;
    QHBoxLayout *horizontalLayout_5;
    QLabel *label_SendingArea;
    QSpacerItem *horizontalSpacer_3;
    QCheckBox *checkBox_HexSend;
    QPushButton *BtClearSend;
    QPlainTextEdit *plainTextEdit_SendData;

    void setupUi(QWidget *Widget)
    {
        if (Widget->objectName().isEmpty())
            Widget->setObjectName(QStringLiteral("Widget"));
        Widget->resize(731, 555);
        QSizePolicy sizePolicy(QSizePolicy::Maximum, QSizePolicy::Maximum);
        sizePolicy.setHorizontalStretch(0);
        sizePolicy.setVerticalStretch(0);
        sizePolicy.setHeightForWidth(Widget->sizePolicy().hasHeightForWidth());
        Widget->setSizePolicy(sizePolicy);
        gridLayout = new QGridLayout(Widget);
        gridLayout->setSpacing(6);
        gridLayout->setContentsMargins(11, 11, 11, 11);
        gridLayout->setObjectName(QStringLiteral("gridLayout"));
        verticalLayout_4 = new QVBoxLayout();
        verticalLayout_4->setSpacing(6);
        verticalLayout_4->setObjectName(QStringLiteral("verticalLayout_4"));
        horizontalLayout = new QHBoxLayout();
        horizontalLayout->setSpacing(6);
        horizontalLayout->setObjectName(QStringLiteral("horizontalLayout"));
        verticalLayout = new QVBoxLayout();
        verticalLayout->setSpacing(6);
        verticalLayout->setObjectName(QStringLiteral("verticalLayout"));
        verticalSpacer_2 = new QSpacerItem(20, 30, QSizePolicy::Minimum, QSizePolicy::Fixed);

        verticalLayout->addItem(verticalSpacer_2);

        BtGetBleVer = new QPushButton(Widget);
        BtGetBleVer->setObjectName(QStringLiteral("BtGetBleVer"));
        BtGetBleVer->setMinimumSize(QSize(100, 30));
        BtGetBleVer->setMaximumSize(QSize(100, 30));
        QFont font;
        font.setPointSize(10);
        BtGetBleVer->setFont(font);

        verticalLayout->addWidget(BtGetBleVer);

        BtFlushDev = new QPushButton(Widget);
        BtFlushDev->setObjectName(QStringLiteral("BtFlushDev"));
        BtFlushDev->setMinimumSize(QSize(100, 30));
        BtFlushDev->setMaximumSize(QSize(100, 30));
        BtFlushDev->setFont(font);

        verticalLayout->addWidget(BtFlushDev);

        BtOpenDev = new QPushButton(Widget);
        BtOpenDev->setObjectName(QStringLiteral("BtOpenDev"));
        BtOpenDev->setMinimumSize(QSize(100, 30));
        BtOpenDev->setMaximumSize(QSize(100, 30));
        BtOpenDev->setFont(font);

        verticalLayout->addWidget(BtOpenDev);

        verticalSpacer = new QSpacerItem(20, 30, QSizePolicy::Minimum, QSizePolicy::Fixed);

        verticalLayout->addItem(verticalSpacer);


        horizontalLayout->addLayout(verticalLayout);

        tableWidget_BleDev = new QTableWidget(Widget);
        if (tableWidget_BleDev->columnCount() < 3)
            tableWidget_BleDev->setColumnCount(3);
        QTableWidgetItem *__qtablewidgetitem = new QTableWidgetItem();
        tableWidget_BleDev->setHorizontalHeaderItem(0, __qtablewidgetitem);
        QTableWidgetItem *__qtablewidgetitem1 = new QTableWidgetItem();
        tableWidget_BleDev->setHorizontalHeaderItem(1, __qtablewidgetitem1);
        QTableWidgetItem *__qtablewidgetitem2 = new QTableWidgetItem();
        tableWidget_BleDev->setHorizontalHeaderItem(2, __qtablewidgetitem2);
        tableWidget_BleDev->setObjectName(QStringLiteral("tableWidget_BleDev"));

        horizontalLayout->addWidget(tableWidget_BleDev);


        verticalLayout_4->addLayout(horizontalLayout);

        horizontalLayout_2 = new QHBoxLayout();
        horizontalLayout_2->setSpacing(6);
        horizontalLayout_2->setObjectName(QStringLiteral("horizontalLayout_2"));
        BtGetService = new QPushButton(Widget);
        BtGetService->setObjectName(QStringLiteral("BtGetService"));
        BtGetService->setMinimumSize(QSize(100, 30));
        BtGetService->setMaximumSize(QSize(100, 30));
        BtGetService->setFont(font);

        horizontalLayout_2->addWidget(BtGetService);

        comboBox_Serivices = new QComboBox(Widget);
        comboBox_Serivices->setObjectName(QStringLiteral("comboBox_Serivices"));
        comboBox_Serivices->setMinimumSize(QSize(0, 30));
        comboBox_Serivices->setMaximumSize(QSize(16777215, 30));
        comboBox_Serivices->setFont(font);
        comboBox_Serivices->setEditable(true);

        horizontalLayout_2->addWidget(comboBox_Serivices);

        horizontalSpacer = new QSpacerItem(25, 30, QSizePolicy::Fixed, QSizePolicy::Minimum);

        horizontalLayout_2->addItem(horizontalSpacer);

        BtGetchara = new QPushButton(Widget);
        BtGetchara->setObjectName(QStringLiteral("BtGetchara"));
        BtGetchara->setMinimumSize(QSize(100, 30));
        BtGetchara->setMaximumSize(QSize(100, 30));
        BtGetchara->setFont(font);

        horizontalLayout_2->addWidget(BtGetchara);

        comboBox_Chara = new QComboBox(Widget);
        comboBox_Chara->setObjectName(QStringLiteral("comboBox_Chara"));
        comboBox_Chara->setMinimumSize(QSize(0, 30));
        comboBox_Chara->setMaximumSize(QSize(16777215, 30));
        QFont font1;
        font1.setPointSize(10);
        font1.setBold(false);
        font1.setItalic(false);
        font1.setWeight(50);
        comboBox_Chara->setFont(font1);
        comboBox_Chara->setEditable(true);

        horizontalLayout_2->addWidget(comboBox_Chara);


        verticalLayout_4->addLayout(horizontalLayout_2);

        horizontalLayout_3 = new QHBoxLayout();
        horizontalLayout_3->setSpacing(6);
        horizontalLayout_3->setObjectName(QStringLiteral("horizontalLayout_3"));
        BtGetAction = new QPushButton(Widget);
        BtGetAction->setObjectName(QStringLiteral("BtGetAction"));
        BtGetAction->setMinimumSize(QSize(100, 30));
        BtGetAction->setMaximumSize(QSize(100, 30));
        BtGetAction->setFont(font);

        horizontalLayout_3->addWidget(BtGetAction);

        horizontalSpacer_4 = new QSpacerItem(120, 20, QSizePolicy::Preferred, QSizePolicy::Minimum);

        horizontalLayout_3->addItem(horizontalSpacer_4);

        BtOpenNotify = new QPushButton(Widget);
        BtOpenNotify->setObjectName(QStringLiteral("BtOpenNotify"));
        BtOpenNotify->setMinimumSize(QSize(140, 30));
        BtOpenNotify->setMaximumSize(QSize(140, 30));
        BtOpenNotify->setFont(font);

        horizontalLayout_3->addWidget(BtOpenNotify);

        horizontalSpacer_5 = new QSpacerItem(100, 20, QSizePolicy::Maximum, QSizePolicy::Minimum);

        horizontalLayout_3->addItem(horizontalSpacer_5);

        BtReadFunc = new QPushButton(Widget);
        BtReadFunc->setObjectName(QStringLiteral("BtReadFunc"));
        BtReadFunc->setMinimumSize(QSize(140, 30));
        BtReadFunc->setMaximumSize(QSize(140, 30));
        BtReadFunc->setFont(font);

        horizontalLayout_3->addWidget(BtReadFunc);

        horizontalSpacer_6 = new QSpacerItem(100, 20, QSizePolicy::Maximum, QSizePolicy::Minimum);

        horizontalLayout_3->addItem(horizontalSpacer_6);

        BtWriteFUnc = new QPushButton(Widget);
        BtWriteFUnc->setObjectName(QStringLiteral("BtWriteFUnc"));
        BtWriteFUnc->setMinimumSize(QSize(140, 30));
        BtWriteFUnc->setMaximumSize(QSize(140, 30));
        BtWriteFUnc->setFont(font);

        horizontalLayout_3->addWidget(BtWriteFUnc);

        horizontalSpacer_7 = new QSpacerItem(100, 20, QSizePolicy::Maximum, QSizePolicy::Minimum);

        horizontalLayout_3->addItem(horizontalSpacer_7);


        verticalLayout_4->addLayout(horizontalLayout_3);

        horizontalLayout_6 = new QHBoxLayout();
        horizontalLayout_6->setSpacing(6);
        horizontalLayout_6->setObjectName(QStringLiteral("horizontalLayout_6"));
        verticalLayout_2 = new QVBoxLayout();
        verticalLayout_2->setSpacing(6);
        verticalLayout_2->setObjectName(QStringLiteral("verticalLayout_2"));
        horizontalLayout_4 = new QHBoxLayout();
        horizontalLayout_4->setSpacing(6);
        horizontalLayout_4->setObjectName(QStringLiteral("horizontalLayout_4"));
        label_RecvArea = new QLabel(Widget);
        label_RecvArea->setObjectName(QStringLiteral("label_RecvArea"));
        label_RecvArea->setMinimumSize(QSize(0, 30));
        label_RecvArea->setMaximumSize(QSize(16777215, 30));
        label_RecvArea->setFont(font);

        horizontalLayout_4->addWidget(label_RecvArea);

        horizontalSpacer_2 = new QSpacerItem(40, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        horizontalLayout_4->addItem(horizontalSpacer_2);

        checkBox_HexShow = new QCheckBox(Widget);
        checkBox_HexShow->setObjectName(QStringLiteral("checkBox_HexShow"));
        checkBox_HexShow->setMinimumSize(QSize(0, 30));
        checkBox_HexShow->setMaximumSize(QSize(16777215, 30));
        checkBox_HexShow->setFont(font);

        horizontalLayout_4->addWidget(checkBox_HexShow);

        BtClearReceive = new QPushButton(Widget);
        BtClearReceive->setObjectName(QStringLiteral("BtClearReceive"));
        BtClearReceive->setMinimumSize(QSize(100, 30));
        BtClearReceive->setMaximumSize(QSize(100, 30));
        BtClearReceive->setFont(font);

        horizontalLayout_4->addWidget(BtClearReceive);


        verticalLayout_2->addLayout(horizontalLayout_4);

        plainTextEdit_RecvData = new QPlainTextEdit(Widget);
        plainTextEdit_RecvData->setObjectName(QStringLiteral("plainTextEdit_RecvData"));
        plainTextEdit_RecvData->setMinimumSize(QSize(0, 150));

        verticalLayout_2->addWidget(plainTextEdit_RecvData);


        horizontalLayout_6->addLayout(verticalLayout_2);

        verticalLayout_3 = new QVBoxLayout();
        verticalLayout_3->setSpacing(6);
        verticalLayout_3->setObjectName(QStringLiteral("verticalLayout_3"));
        horizontalLayout_5 = new QHBoxLayout();
        horizontalLayout_5->setSpacing(6);
        horizontalLayout_5->setObjectName(QStringLiteral("horizontalLayout_5"));
        label_SendingArea = new QLabel(Widget);
        label_SendingArea->setObjectName(QStringLiteral("label_SendingArea"));
        label_SendingArea->setMinimumSize(QSize(0, 30));
        label_SendingArea->setMaximumSize(QSize(16777215, 30));
        label_SendingArea->setFont(font);

        horizontalLayout_5->addWidget(label_SendingArea);

        horizontalSpacer_3 = new QSpacerItem(40, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        horizontalLayout_5->addItem(horizontalSpacer_3);

        checkBox_HexSend = new QCheckBox(Widget);
        checkBox_HexSend->setObjectName(QStringLiteral("checkBox_HexSend"));
        checkBox_HexSend->setMinimumSize(QSize(0, 30));
        checkBox_HexSend->setMaximumSize(QSize(16777215, 30));
        checkBox_HexSend->setFont(font);

        horizontalLayout_5->addWidget(checkBox_HexSend);

        BtClearSend = new QPushButton(Widget);
        BtClearSend->setObjectName(QStringLiteral("BtClearSend"));
        BtClearSend->setMinimumSize(QSize(100, 30));
        BtClearSend->setMaximumSize(QSize(100, 30));
        BtClearSend->setFont(font);

        horizontalLayout_5->addWidget(BtClearSend);


        verticalLayout_3->addLayout(horizontalLayout_5);

        plainTextEdit_SendData = new QPlainTextEdit(Widget);
        plainTextEdit_SendData->setObjectName(QStringLiteral("plainTextEdit_SendData"));
        plainTextEdit_SendData->setMinimumSize(QSize(0, 150));

        verticalLayout_3->addWidget(plainTextEdit_SendData);


        horizontalLayout_6->addLayout(verticalLayout_3);


        verticalLayout_4->addLayout(horizontalLayout_6);


        gridLayout->addLayout(verticalLayout_4, 0, 0, 1, 1);


        retranslateUi(Widget);

        QMetaObject::connectSlotsByName(Widget);
    } // setupUi

    void retranslateUi(QWidget *Widget)
    {
        Widget->setWindowTitle(QApplication::translate("Widget", "WCHBleDemo", Q_NULLPTR));
        BtGetBleVer->setText(QApplication::translate("Widget", "\346\237\245\350\257\242\346\216\247\345\210\266\345\231\250\347\211\210\346\234\254", Q_NULLPTR));
        BtFlushDev->setText(QApplication::translate("Widget", "\345\210\267\346\226\260\350\256\276\345\244\207", Q_NULLPTR));
        BtOpenDev->setText(QApplication::translate("Widget", "\346\211\223\345\274\200\350\256\276\345\244\207", Q_NULLPTR));
        QTableWidgetItem *___qtablewidgetitem = tableWidget_BleDev->horizontalHeaderItem(0);
        ___qtablewidgetitem->setText(QApplication::translate("Widget", "\350\256\276\345\244\207", Q_NULLPTR));
        QTableWidgetItem *___qtablewidgetitem1 = tableWidget_BleDev->horizontalHeaderItem(1);
        ___qtablewidgetitem1->setText(QApplication::translate("Widget", "Mac\345\234\260\345\235\200", Q_NULLPTR));
        QTableWidgetItem *___qtablewidgetitem2 = tableWidget_BleDev->horizontalHeaderItem(2);
        ___qtablewidgetitem2->setText(QApplication::translate("Widget", "\344\277\241\345\217\267\345\200\274", Q_NULLPTR));
        BtGetService->setText(QApplication::translate("Widget", "\350\216\267\345\217\226\346\234\215\345\212\241", Q_NULLPTR));
        BtGetchara->setText(QApplication::translate("Widget", "\350\216\267\345\217\226\347\211\271\345\276\201", Q_NULLPTR));
        BtGetAction->setText(QApplication::translate("Widget", "\350\216\267\345\217\226\346\223\215\344\275\234", Q_NULLPTR));
        BtOpenNotify->setText(QApplication::translate("Widget", "\346\211\223\345\274\200\350\256\242\351\230\205", Q_NULLPTR));
        BtReadFunc->setText(QApplication::translate("Widget", "Read", Q_NULLPTR));
        BtWriteFUnc->setText(QApplication::translate("Widget", "Write", Q_NULLPTR));
        label_RecvArea->setText(QApplication::translate("Widget", "\346\216\245\346\224\266\345\214\272:", Q_NULLPTR));
        checkBox_HexShow->setText(QApplication::translate("Widget", "16\350\277\233\345\210\266\346\230\276\347\244\272", Q_NULLPTR));
        BtClearReceive->setText(QApplication::translate("Widget", "\346\216\245\346\224\266\346\270\205\347\251\272", Q_NULLPTR));
        label_SendingArea->setText(QApplication::translate("Widget", "\345\217\221\351\200\201\345\214\272:", Q_NULLPTR));
        checkBox_HexSend->setText(QApplication::translate("Widget", "16\350\277\233\345\210\266\345\217\221\351\200\201", Q_NULLPTR));
        BtClearSend->setText(QApplication::translate("Widget", "\345\217\221\351\200\201\346\270\205\347\251\272", Q_NULLPTR));
    } // retranslateUi

};

namespace Ui {
    class Widget: public Ui_Widget {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_WIDGET_H
