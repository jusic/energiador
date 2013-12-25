#ifndef ENERGIADOR_H
#define ENERGIADOR_H

#include <sailfishapp.h>
#include "worker.h"

class Energiador : public QObject
{
    Q_OBJECT
    Controller* contr;
    QTimer* timer;
    QVariantList* list;

public:
    Energiador() {
        contr = new Controller;
        timer = new QTimer(this);
        list = new QVariantList();

        contr->connect(contr, SIGNAL(resultReady(float,float,float)), this, SLOT(putresult(float,float,float)));

        timer->connect(timer, SIGNAL(timeout()), this, SLOT(update()));
        timer->start(250);

        //QDateTime endDate(QDate(2012, 7, 7), QTime(16, 30, 0));
    }

    ~Energiador() {
        timer->stop();
        delete timer;
        delete contr;
        delete list;
    }

public slots:
    void update()
    {
        contr->operate();
    }

    void putresult(float voltage, float current, float power)
    {
        static int count = 0;
        QString result = QString("P: ") + QString::number(voltage * current) + " W\n"
                "U: " + QString::number(voltage) + " V\n"
                "I: " + QString::number(current * 1000.) + " mA\n";

        QVariantMap map;
        map.insert("date", QDateTime::currentDateTime());
        map.insert("power", power);
        *list << map;

        // store only ~30s worth of data (120 data points)
        if (list->length() > 60*4*0.5) {
            list->pop_front();
        }

        emit resultReady(result);
        if (count++ % 4 == 0) {
            // update gui only every 4th value
            emit updateList(*list);
        }
    }

signals:
    void resultReady(const QString & result);
    void updateList(const QVariantList & list);
};

#endif // ENERGIADOR_H
