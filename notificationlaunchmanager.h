#ifndef NOTIFICATIONLAUNCHMANAGER_H
#define NOTIFICATIONLAUNCHMANAGER_H

#include <QObject>
#include <QSettings>

class NotificationLaunchManager : public QObject
{
    Q_OBJECT

public:
    explicit NotificationLaunchManager(
        QObject *parent = nullptr
        );

    Q_INVOKABLE void setOpenChecklist();
    Q_INVOKABLE bool shouldOpenChecklist();
    Q_INVOKABLE void clearFlag();

private:
    QSettings settings;
};

#endif