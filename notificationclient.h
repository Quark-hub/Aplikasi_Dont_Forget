#ifndef NOTIFICATIONCLIENT_H
#define NOTIFICATIONCLIENT_H

#include <QObject>
#include <QString>

class NotificationClient : public QObject
{
    Q_OBJECT
public:
    explicit NotificationClient(QObject *parent = nullptr);

    Q_INVOKABLE void showNotification(const QString &title, const QString &message);

    // TAMBAH BARIS INI
    Q_INVOKABLE void scheduleNotification(
        int id,
        const QString &title,
        const QString &message,
        const QString &tanggal,
        const QString &waktu,
        qint64 timestamp
        );
    Q_INVOKABLE void requestExactAlarmPermission();
};

#endif // NOTIFICATIONCLIENT_H