#ifndef WORKER_H
#define WORKER_H

#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>

class BatteryWorker : public QObject
{
    Q_OBJECT
    QThread workerThread;

public slots:
    void checkBatteryStatus() {
        // crude hacks to get instant data from the power sensor

        QProcess p;
        //p.start("sh", QStringList() << "-c" << "upower -d | grep updated; upower -d | grep rate");
        p.start("sh", QStringList() << "-c" << "cat /sys/devices/platform/msm_ssbi.0/pm8038-core/pm8921-charger/power_supply/battery/current_now");
        p.waitForFinished(-1);

        QString p_stdout = p.readAllStandardOutput();
        QString p_stderr = p.readAllStandardError();

        p.start("sh", QStringList() << "-c" << "cat /sys/devices/platform/msm_ssbi.0/pm8038-core/pm8921-charger/power_supply/battery/voltage_now");
        p.waitForFinished(-1);

        QString p_stdout2 = p.readAllStandardOutput();
        QString p_stderr2 = p.readAllStandardError();

        float voltage = p_stdout2.toFloat() / 1e6;
        float current = p_stdout.toFloat() / 1e6;

        QString result = QString("P: ") + QString::number(voltage * current) + " W\n"
                "U: " + QString::number(voltage) + " V\n"
                "I: " + QString::number(current * 1000.) + " mA\n";

        emit resultReady(result);
    }

signals:
    void resultReady(const QString &result);
};

class Controller : public QObject
{
    Q_OBJECT
    QThread workerThread;
public:
    Controller() {
        BatteryWorker *worker = new BatteryWorker;
        worker->moveToThread(&workerThread);
        connect(this, SIGNAL(operate()), worker, SLOT(checkBatteryStatus()));
        connect(worker, SIGNAL(resultReady(QString)), this, SLOT(handleResults(QString)));
        workerThread.start();
    }
    ~Controller() {
        workerThread.quit();
        workerThread.wait();
    }

public slots:
    void handleResults(const QString &result) {
        //qDebug("update");
        //qDebug("%s", result.toUtf8().constData());
        emit resultReady(result);
    }

signals:
    void operate();
    void resultReady(const QString &);
};

#endif // WORKER_H
