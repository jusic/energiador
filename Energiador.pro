# The name of your app.
# NOTICE: name defined in TARGET has a corresponding QML filename.
#         If name defined in TARGET is changed, following needs to be
#         done to match new name:
#         - corresponding QML filename must be changed
#         - desktop icon filename must be changed
#         - desktop filename must be changed
#         - icon definition filename in desktop file must be changed
TARGET = Energiador

CONFIG += sailfishapp

SOURCES += src/Energiador.cpp

OTHER_FILES += qml/Energiador.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    rpm/Energiador.spec \
    rpm/Energiador.yaml \
    Energiador.desktop \
    qml/components/LinePlot.qml

HEADERS += \
    src/worker.h \
    src/energiador.h

