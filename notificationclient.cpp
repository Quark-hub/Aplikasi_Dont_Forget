#include "notificationclient.h"

#ifdef Q_OS_ANDROID
#include <QJniObject>
#include <QCoreApplication>
#endif

NotificationClient::NotificationClient(QObject *parent)
    : QObject(parent)
{
}

void NotificationClient::showNotification(const QString &title, const QString &message)
{
#ifdef Q_OS_ANDROID
    QJniObject javaTitle = QJniObject::fromString(title);
    QJniObject javaMessage = QJniObject::fromString(message);
    QJniObject context = QNativeInterface::QAndroidApplication::context();

    QJniObject::callStaticMethod<void>(
        "org/qtproject/example/NotificationHelper",
        "showNotification",
        "(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V",
        context.object(),
        javaTitle.object<jstring>(),
        javaMessage.object<jstring>()
        );
#endif
}

// TAMBAHKAN IMPLEMENTASI FUNGSI BARU INI DI BAWAH
void NotificationClient::scheduleNotification(
    int id,
    const QString &title,
    const QString &message,
    const QString &tanggal,
    const QString &waktu,
    qint64 timestamp)
{
#ifdef Q_OS_ANDROID

    QJniObject javaTitle =
        QJniObject::fromString(title);

    QJniObject javaMessage =
        QJniObject::fromString(message);

    QJniObject javaTanggal =
        QJniObject::fromString(tanggal);

    QJniObject javaWaktu =
        QJniObject::fromString(waktu);

    QJniObject context =
        QNativeInterface::QAndroidApplication::context();

    QJniObject::callStaticMethod<void>(
        "org/qtproject/example/NotificationHelper",
        "scheduleNotification",
        "(Landroid/content/Context;ILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;J)V",
        context.object(),
        (jint)id,
        javaTitle.object<jstring>(),
        javaMessage.object<jstring>(),
        javaTanggal.object<jstring>(),
        javaWaktu.object<jstring>(),
        (jlong)timestamp
        );

#endif
}

void NotificationClient::requestExactAlarmPermission()
{
#ifdef Q_OS_ANDROID

    QJniObject context =
        QNativeInterface::QAndroidApplication::context();

    QJniObject::callStaticMethod<void>(
        "org/qtproject/example/NotificationHelper",
        "requestExactAlarmPermission",
        "(Landroid/content/Context;)V",
        context.object()
        );

#endif
}