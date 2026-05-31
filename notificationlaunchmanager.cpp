#include "notificationlaunchmanager.h"

NotificationLaunchManager::
    NotificationLaunchManager(
        QObject *parent
        )
    : QObject(parent),
    settings(
        "DontForget",
        "DontForget"
        )
{
}

void NotificationLaunchManager::
    setOpenChecklist()
{
    settings.setValue(
        "openChecklist",
        true
        );

    settings.sync();
}

bool NotificationLaunchManager::
    shouldOpenChecklist()
{
    return settings.value(
                       "openChecklist",
                       false
                       ).toBool();
}

void NotificationLaunchManager::
    clearFlag()
{
    settings.setValue(
        "openChecklist",
        false
        );

    settings.sync();
}