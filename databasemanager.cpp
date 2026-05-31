#include "databasemanager.h"

#include <QSqlQuery>
#include <QVariant>
#include <QDebug>

DatabaseManager::DatabaseManager(QObject *parent)
    : QObject(parent)
{
}

void DatabaseManager::saveReminder(
    QString judul,
    QString kategori,
    QString tanggal,
    QString waktu,
    QString catatan,
    qint64 timestamp,
    int isDone
    )
{
    QSqlQuery query;

    query.prepare(
        "INSERT INTO reminders "
        "(judul, kategori, tanggal, waktu, catatan, timestamp, isDone) "
        "VALUES (?, ?, ?, ?, ?, ?, ?)"
        );

    query.addBindValue(judul);
    query.addBindValue(kategori);
    query.addBindValue(tanggal);
    query.addBindValue(waktu);
    query.addBindValue(catatan);
    query.addBindValue(timestamp);
    query.addBindValue(isDone);

    if (!query.exec()) {

        qDebug() << "Gagal simpan reminder";
    }
}
QVariantList DatabaseManager::loadReminders()
{
    QVariantList reminderList;

    QSqlQuery query;

    query.exec(
        "SELECT judul, kategori, tanggal, waktu, catatan, timestamp, isDone "
        "FROM reminders"
        );

    while (query.next()) {

        QVariantMap reminder;

        reminder["judul"] =
            query.value(0).toString();

        reminder["kategori"] =
            query.value(1).toString();

        reminder["tanggal"] =
            query.value(2).toString();

        reminder["waktu"] =
            query.value(3).toString();

        reminder["catatan"] =
            query.value(4).toString();

        reminder["timestamp"] =
            query.value(5).toLongLong();

        reminder["isDone"] =
            query.value(6).toInt();

        reminderList.append(reminder);
    }

    return reminderList;
}
void DatabaseManager::updateChecklist(
    QString judul,
    int isDone
    )
{
    QSqlQuery query;

    query.prepare(
        "UPDATE reminders "
        "SET isDone = ? "
        "WHERE judul = ?"
        );

    query.addBindValue(isDone);
    query.addBindValue(judul);

    query.exec();
}

void DatabaseManager::deleteReminder(
    QString judul,
    qint64 timestamp
    )
{
    QSqlQuery query;

    query.prepare(
        "DELETE FROM reminders "
        "WHERE judul = ? "
        "AND timestamp = ?"
        );

    query.addBindValue(judul);
    query.addBindValue(timestamp);

    query.exec();
}