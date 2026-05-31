#include "settingsmanager.h"

SettingsManager::SettingsManager(QObject *parent)
    : QObject(parent),
    settings("DontForget", "DontForget")
{
}

bool SettingsManager::loadDarkMode()
{
    return settings.value("darkMode", false).toBool();
}

void SettingsManager::saveDarkMode(bool value)
{
    settings.setValue("darkMode", value);
    settings.sync();
}