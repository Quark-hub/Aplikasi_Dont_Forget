#ifndef DATABASEMANAGER_H
#define DATABASEMANAGER_H

#include <QObject>
#include <QVariant>

class DatabaseManager : public QObject
{
    Q_OBJECT

public:
    explicit DatabaseManager(QObject *parent = nullptr);

    Q_INVOKABLE void saveReminder(
        QString judul,
        QString kategori,
        QString tanggal,
        QString waktu,
        QString catatan,
        qint64 timestamp,
        int isDone
        );
    Q_INVOKABLE QVariantList loadReminders();


    Q_INVOKABLE void updateChecklist(
        QString judul,
        int isDone
        );
    Q_INVOKABLE void deleteReminder(
        QString judul,
        qint64 timestamp
        );
};

#endif