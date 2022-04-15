#-------------------------------------------------
#
# Project created by QtCreator 2021-03-23T13:23:03
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = Demo
TEMPLATE = app

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked as deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0


SOURCES += \
        main.cpp \
        widget.cpp

HEADERS += \
        widget.h

FORMS += \
        widget.ui



win32:CONFIG(release, debug|release): LIBS += -L$$PWD/CH9140LIB/release/ -lCH9140lib
else:win32:CONFIG(debug, debug|release): LIBS += -L$$PWD/CH9140LIB/debug/ -lCH9140lib
else:unix: LIBS += -L$$PWD/CH9140LIB/ -lCH9140lib

INCLUDEPATH += $$PWD/CH9140LIB
DEPENDPATH += $$PWD/CH9140LIB
