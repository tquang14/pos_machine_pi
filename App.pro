QT += quick
QT += sql
CONFIG += c++11

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES_PATH = Product/source

INCLUDE_PATH = Product/include

SOURCES += \
        main.cpp \
        $${SOURCES_PATH}/backend.cpp \
        $${SOURCES_PATH}/OrderModel.cpp

HEADERS += \
        $${INCLUDE_PATH}/backend.hpp \
        $${INCLUDE_PATH}/ProjectConst.hpp \
        $${INCLUDE_PATH}/OrderModel.hpp

RESOURCES += qml.qrc \
    Image.qrc

TRANSLATIONS += \
    App_vi_VN.ts

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
