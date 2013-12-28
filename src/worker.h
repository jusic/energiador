#ifndef WORKER_H
#define WORKER_H

#include <QtQuick>
#include <sailfishapp.h>

class BatteryWorker : public QObject
{
    Q_OBJECT
    QThread workerThread;

public slots:
    void checkBatteryStatus() {
        // crude hacks to get instant data from the power sensor

        QFile f("/sys/devices/LNXSYSTM:00/device:00/PNP0A03:00/PNP0C0A:00/power_supply/BAT0");
        if (f.exists()) {
            QProcess p;
            //p.start("sh", QStringList() << "-c" << "upower -d | grep updated; upower -d | grep rate");
            p.start("sh", QStringList() << "-c" << "cat /sys/devices/LNXSYSTM:00/device:00/PNP0A03:00/PNP0C0A:00/power_supply/BAT0/power_now");
            p.waitForFinished(-1);

            QString p_stdout = p.readAllStandardOutput();
            QString p_stderr = p.readAllStandardError();

            p.start("sh", QStringList() << "-c" << "cat /sys/devices/LNXSYSTM:00/device:00/PNP0A03:00/PNP0C0A:00/power_supply/BAT0/voltage_now");
            p.waitForFinished(-1);

            QString p_stdout2 = p.readAllStandardOutput();
            QString p_stderr2 = p.readAllStandardError();

            float voltage = p_stdout2.toFloat() / 1e6;
            float power = p_stdout.toFloat() / 1e6;

            emit resultReady(voltage, power/voltage, power);
        }
        else
        {
            qDebug("reading");
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
            qDebug("reading done");

            float voltage = p_stdout2.toFloat() / 1e6;
            float current = p_stdout.toFloat() / 1e6;

            emit resultReady(voltage, current, voltage*current);
        }
    }

signals:
    void resultReady(float voltage, float current, float power);
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
        connect(worker, SIGNAL(resultReady(float,float,float)), this, SLOT(handleResults(float,float,float)));
        workerThread.start();
    }
    ~Controller() {
        workerThread.quit();
        workerThread.wait();
    }

public slots:
    void handleResults(float v, float c, float p) {
        //qDebug("update");
        //qDebug("%s", result.toUtf8().constData());
        emit resultReady(v,c,p);
    }

signals:
    void operate();
    void resultReady(float,float,float);
};

#endif // WORKER_H
