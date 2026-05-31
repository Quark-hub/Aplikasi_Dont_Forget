#ifndef SETTINGSMANAGER_H
#define SETTINGSMANAGER_H

#include <QObject>
#include <QSettings>

class SettingsManager : public QObject
{
    Q_OBJECT

public:
    explicit SettingsManager(QObject *parent = nullptr);

    Q_INVOKABLE bool loadDarkMode();
    Q_INVOKABLE void saveDarkMode(bool value);

private:
    QSettings settings;
};

#endif