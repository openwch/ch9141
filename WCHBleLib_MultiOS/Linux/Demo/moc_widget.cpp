/****************************************************************************
** Meta object code from reading C++ file 'widget.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.9.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "widget.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'widget.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.9.1. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_Widget_t {
    QByteArrayData data[22];
    char stringdata0[342];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_Widget_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_Widget_t qt_meta_stringdata_Widget = {
    {
QT_MOC_LITERAL(0, 0, 6), // "Widget"
QT_MOC_LITERAL(1, 7, 19), // "DevDisconnectSignal"
QT_MOC_LITERAL(2, 27, 0), // ""
QT_MOC_LITERAL(3, 28, 17), // "ShowAboutPageSlot"
QT_MOC_LITERAL(4, 46, 19), // "GetBluetoothVerSlot"
QT_MOC_LITERAL(5, 66, 15), // "FlushBleDevSlot"
QT_MOC_LITERAL(6, 82, 14), // "OpenBleDevSlot"
QT_MOC_LITERAL(7, 97, 19), // "DisonnectActionSlot"
QT_MOC_LITERAL(8, 117, 18), // "GetBleSeriviceSlot"
QT_MOC_LITERAL(9, 136, 25), // "GetBleCharacteristicsSlot"
QT_MOC_LITERAL(10, 162, 16), // "ClearBleFuncSlot"
QT_MOC_LITERAL(11, 179, 5), // "index"
QT_MOC_LITERAL(12, 185, 13), // "GetActionSlot"
QT_MOC_LITERAL(13, 199, 20), // "OpenNotificationSlot"
QT_MOC_LITERAL(14, 220, 15), // "ReadBleDataSlot"
QT_MOC_LITERAL(15, 236, 16), // "WriteBleDataSlot"
QT_MOC_LITERAL(16, 253, 13), // "IsHexShowSlot"
QT_MOC_LITERAL(17, 267, 5), // "state"
QT_MOC_LITERAL(18, 273, 13), // "IsHexSendSlot"
QT_MOC_LITERAL(19, 287, 19), // "InputHexContentSlot"
QT_MOC_LITERAL(20, 307, 25), // "ClearPlaintextContentSlot"
QT_MOC_LITERAL(21, 333, 8) // "buttonId"

    },
    "Widget\0DevDisconnectSignal\0\0"
    "ShowAboutPageSlot\0GetBluetoothVerSlot\0"
    "FlushBleDevSlot\0OpenBleDevSlot\0"
    "DisonnectActionSlot\0GetBleSeriviceSlot\0"
    "GetBleCharacteristicsSlot\0ClearBleFuncSlot\0"
    "index\0GetActionSlot\0OpenNotificationSlot\0"
    "ReadBleDataSlot\0WriteBleDataSlot\0"
    "IsHexShowSlot\0state\0IsHexSendSlot\0"
    "InputHexContentSlot\0ClearPlaintextContentSlot\0"
    "buttonId"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_Widget[] = {

 // content:
       7,       // revision
       0,       // classname
       0,    0, // classinfo
      17,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       1,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    0,   99,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
       3,    0,  100,    2, 0x08 /* Private */,
       4,    0,  101,    2, 0x08 /* Private */,
       5,    0,  102,    2, 0x08 /* Private */,
       6,    0,  103,    2, 0x08 /* Private */,
       7,    0,  104,    2, 0x08 /* Private */,
       8,    0,  105,    2, 0x08 /* Private */,
       9,    0,  106,    2, 0x08 /* Private */,
      10,    1,  107,    2, 0x08 /* Private */,
      12,    0,  110,    2, 0x08 /* Private */,
      13,    0,  111,    2, 0x08 /* Private */,
      14,    0,  112,    2, 0x08 /* Private */,
      15,    0,  113,    2, 0x08 /* Private */,
      16,    1,  114,    2, 0x08 /* Private */,
      18,    1,  117,    2, 0x08 /* Private */,
      19,    0,  120,    2, 0x08 /* Private */,
      20,    1,  121,    2, 0x08 /* Private */,

 // signals: parameters
    QMetaType::Void,

 // slots: parameters
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, QMetaType::Int,   11,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, QMetaType::Bool,   17,
    QMetaType::Void, QMetaType::Bool,   17,
    QMetaType::Void,
    QMetaType::Void, QMetaType::Int,   21,

       0        // eod
};

void Widget::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        Widget *_t = static_cast<Widget *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->DevDisconnectSignal(); break;
        case 1: _t->ShowAboutPageSlot(); break;
        case 2: _t->GetBluetoothVerSlot(); break;
        case 3: _t->FlushBleDevSlot(); break;
        case 4: _t->OpenBleDevSlot(); break;
        case 5: _t->DisonnectActionSlot(); break;
        case 6: _t->GetBleSeriviceSlot(); break;
        case 7: _t->GetBleCharacteristicsSlot(); break;
        case 8: _t->ClearBleFuncSlot((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 9: _t->GetActionSlot(); break;
        case 10: _t->OpenNotificationSlot(); break;
        case 11: _t->ReadBleDataSlot(); break;
        case 12: _t->WriteBleDataSlot(); break;
        case 13: _t->IsHexShowSlot((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 14: _t->IsHexSendSlot((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 15: _t->InputHexContentSlot(); break;
        case 16: _t->ClearPlaintextContentSlot((*reinterpret_cast< int(*)>(_a[1]))); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        void **func = reinterpret_cast<void **>(_a[1]);
        {
            typedef void (Widget::*_t)();
            if (*reinterpret_cast<_t *>(func) == static_cast<_t>(&Widget::DevDisconnectSignal)) {
                *result = 0;
                return;
            }
        }
    }
}

const QMetaObject Widget::staticMetaObject = {
    { &QWidget::staticMetaObject, qt_meta_stringdata_Widget.data,
      qt_meta_data_Widget,  qt_static_metacall, nullptr, nullptr}
};


const QMetaObject *Widget::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *Widget::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_Widget.stringdata0))
        return static_cast<void*>(const_cast< Widget*>(this));
    return QWidget::qt_metacast(_clname);
}

int Widget::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QWidget::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 17)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 17;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 17)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 17;
    }
    return _id;
}

// SIGNAL 0
void Widget::DevDisconnectSignal()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
