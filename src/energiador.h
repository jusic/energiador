#ifndef ENERGIADOR_H
#define ENERGIADOR_H

#include <sailfishapp.h>
#include "worker.h"

class Energiador : public QObject
{
    Q_OBJECT
    Controller* contr;
    QTimer* timer;

public:
    Energiador() {
        contr = new Controller;
        timer = new QTimer(this);

        contr->connect(contr, SIGNAL(resultReady(QString)), this, SLOT(putresult(QString)));

        timer->connect(timer, SIGNAL(timeout()), this, SLOT(update()));
        timer->start(250);
    }

    ~Energiador() {
        delete contr;
        delete timer;
    }

public slots:
    void update()
    {
        contr->operate();
    }

    void putresult(const QString & result)
    {
        //qDebug("putresult");
        emit resultReady(result);
    }

signals:
    void resultReady(const QString & result);
};

#endif // ENERGIADOR_H
