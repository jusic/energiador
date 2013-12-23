#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <stdio.h>
#include <sailfishapp.h>

#include "energiador.h"

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> app(SailfishApp::application(argc, argv));
    QScopedPointer<QQuickView> view(SailfishApp::createView());

    QScopedPointer<Energiador> energiador(new Energiador());

    view->rootContext()->setContextProperty("energiadorInstance", energiador.data());
    view->setSource(SailfishApp::pathTo("qml/Energiador.qml"));
    view->showFullScreen();
    return app->exec();
}

