#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlError>
#include <QVariant>
#include <QDebug>
#include <QStandardPaths>
#include "notificationclient.h"
#include "databasemanager.h"
#include <QQmlContext>
#include <QSettings>
#include "settingsmanager.h"
#include "notificationlaunchmanager.h"

void createDatabase()
{
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    qDebug() << QSqlDatabase::drivers();

    QString dbPath =
        QStandardPaths::writableLocation(
            QStandardPaths::AppDataLocation
            ) + "/reminder.db";

    db.setDatabaseName(dbPath);

    if (!db.open()) {
        qDebug() << "Database gagal dibuka";
        qDebug() << db.lastError().text();
        return;
    }

    qDebug() << "Database berhasil dibuka";

    QSqlQuery query;

    query.exec(
        "CREATE TABLE IF NOT EXISTS reminders ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "judul TEXT,"
        "kategori TEXT,"
        "tanggal TEXT,"
        "waktu TEXT,"
        "catatan TEXT,"
        "timestamp INTEGER,"
        "isDone INTEGER DEFAULT 0)"
        );

    qDebug() << "Database siap";
}

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    createDatabase();

    // 1. Deklarasi objek diaktifkan
    NotificationClient notificationClient;
    DatabaseManager databaseManager;
    SettingsManager settingsManager;
    NotificationLaunchManager notificationLaunchManager;

    QQmlApplicationEngine engine;

    // 2. Mendaftarkan notificationClient ke QML diaktifkan
    engine.rootContext()->setContextProperty(
        "notificationClient",
        &notificationClient
        );

    engine.rootContext()->setContextProperty(
        "databaseManager",
        &databaseManager
        );

    engine.rootContext()->setContextProperty(
        "settingsManager",
        &settingsManager
        );

    engine.rootContext()->setContextProperty(
        "notificationLaunchManager",
        &notificationLaunchManager
        );

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule("Dont_Forget", "Main");

    return QGuiApplication::exec();
}