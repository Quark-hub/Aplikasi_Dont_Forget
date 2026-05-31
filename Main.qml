import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtCore

ApplicationWindow {
    id: mainWindow
    Settings {
        id: appSettings
        category: "Appearance"
    }
    property alias settingsStore: appSettings
    visible: true
    width: 400
    height: 800
    title: "Don't Forget"

    topPadding: 0
    bottomPadding: 25

    property bool isDarkMode: false
    property string currentTab: "Beranda"
    property bool openChecklistFromNotification: false

    Component.onCompleted: {
        if (
            notificationLaunchManager
                .shouldOpenChecklist()
        ) {

            currentTab = "Checklist"

            stackView.replace(
                "Checklist.qml"
            )

            notificationLaunchManager
                .clearFlag()
        }
        isDarkMode = settingsManager.loadDarkMode()

        var reminders =
                databaseManager.loadReminders()

        for (var i = 0; i < reminders.length; i++) {

            globalReminderModel.append(reminders[i])
        }

        sortReminders()
        notificationClient.requestExactAlarmPermission()
    }

    // DATABASE PENGINGAT
    ListModel {
        id: globalReminderModel
    }

    property alias reminderModel: globalReminderModel

    function addReminder(
            judulData,
            kategoriData,
            tanggalData,
            waktuData,
            catatanData,
            timestampData,
            isDoneData)
    {
        globalReminderModel.append({

            "judul": judulData,
            "kategori": kategoriData,
            "tanggal": tanggalData,
            "waktu": waktuData,
            "catatan": catatanData,
            "timestamp": timestampData,
            "isDone": isDoneData
        })

        saveReminderToDatabase(
            judulData,
            kategoriData,
            tanggalData,
            waktuData,
            catatanData,
            timestampData,
            isDoneData
        )

        sortReminders()
    }
    function deleteReminder(judulData, timestampData) {

        for (var i = 0;
             i < globalReminderModel.count;
             i++) {

            var item =
                    globalReminderModel.get(i)

            if (item.judul === judulData
                    && item.timestamp === timestampData) {

                globalReminderModel.remove(i)

                break
            }
        }

        databaseManager.deleteReminder(
                    judulData,
                    timestampData)
    }

    function saveReminderToDatabase(
            judulData,
            kategoriData,
            tanggalData,
            waktuData,
            catatanData,
            timestampData,
            isDoneData)
    {
        databaseManager.saveReminder(
                    judulData,
                    kategoriData,
                    tanggalData,
                    waktuData,
                    catatanData,
                    timestampData,
                    isDoneData)
    }

    function sortReminders() {
        var arr = []
        var i = 0

        while (i < globalReminderModel.count) {
            var item = globalReminderModel.get(i)
            arr.push({
                "judul": item.judul,
                "kategori": item.kategori,
                "tanggal": item.tanggal,
                "waktu": item.waktu,
                "catatan": item.catatan,
                "timestamp": item.timestamp,
                "isDone": item.isDone
            })
            i++
        }

        arr.sort(function(a, b) {
            return a.timestamp - b.timestamp
        })

        globalReminderModel.clear()

        var j = 0
        while (j < arr.length) {
            globalReminderModel.append(arr[j])
            j++
        }
    }

    function getCountByCategory(cat) {
        var count = 0
        var i = 0

        while (i < globalReminderModel.count) {
            if (globalReminderModel.get(i).kategori === cat) {
                count++
            }
            i++
        }

        return count
    }
    function autoCompleteExpiredTasks() {

        var now = new Date().getTime()

        for (var i = 0; i < globalReminderModel.count; i++) {

            var item = globalReminderModel.get(i)

            if (item.isDone === 0
                    && item.timestamp < now) {

                globalReminderModel.setProperty(
                    i,
                    "isDone",
                    1
                )

                databaseManager.updateChecklist(
                    item.judul,
                    1
                )
            }
        }
    }

    // FUNGSI NAVIGASI KATEGORI
    function navigateToKategori() {
        currentTab = "Kategori"
        stackView.replace("Kategori.qml")
    }

    StackView {
        id: stackView
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        anchors.topMargin: 35
        initialItem: "Home.qml"
    }

    // FOOTER NAVIGASI
    Timer {
        interval: 1000
        repeat: true
        running: true

        onTriggered: {
            mainWindow.autoCompleteExpiredTasks()
        }
    }
    footer: Rectangle {
        width: parent.width
        height: 130
        anchors.topMargin: 5
        anchors.bottomMargin: 20
        color: mainWindow.isDarkMode ? "#121212" : "#FFFFFF"

        Behavior on color {
            ColorAnimation {
                duration: 300
            }
        }

        Rectangle {
            width: parent.width
            height: 1
            color: mainWindow.isDarkMode ? "#333333" : "#EAEAEA"
            anchors.top: parent.top
        }

        RowLayout {
            anchors.fill: parent
            spacing: 0

            NavItem {
                iconSymbol: "🏠"
                label: "Beranda"
                isActive: mainWindow.currentTab === "Beranda"
                onClicked: {
                    mainWindow.currentTab = "Beranda"
                    stackView.replace("Home.qml")
                }
            }

            NavItem {
                iconSymbol: "📁"
                label: "Kategori"
                isActive: mainWindow.currentTab === "Kategori"
                onClicked: {
                    mainWindow.navigateToKategori()
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Rectangle {
                    width: 50
                    height: 50
                    radius: 25
                    color: "#7B61FF"
                    anchors.centerIn: parent

                    Text {
                        text: "+"
                        color: "#FFFFFF"
                        font.pixelSize: 32
                        anchors.centerIn: parent
                        anchors.verticalCenterOffset: -3
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            stackView.push("AddReminder.qml")
                        }
                    }
                }
            }

            NavItem {
                iconSymbol: "📊"
                label: "Statistik"
                isActive: mainWindow.currentTab === "Statistik"

                onClicked: {
                    mainWindow.currentTab = "Statistik"
                    stackView.replace("Statistik.qml")
                }
            }

            NavItem {
                iconSymbol: "☑️"
                label: "Checklist"

                isActive: mainWindow.currentTab === "Checklist"

                onClicked: {

                    mainWindow.currentTab = "Checklist"

                    stackView.replace("Checklist.qml")
                }
            }
        }
    }

    // TEMPLATE TOMBOL NAVIGASI
    component NavItem: Item {
        property string iconSymbol: ""
        property string label: ""
        property bool isActive: false
        signal clicked()

        Layout.fillWidth: true
        Layout.fillHeight: true

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 2

            Text {
                text: iconSymbol
                font.pixelSize: 22
                Layout.alignment: Qt.AlignHCenter
                opacity: isActive ? 1.0 : 0.4
            }

            Text {
                text: label
                font.pixelSize: 10
                font.bold: isActive
                color: isActive ? "#7B61FF" : (mainWindow.isDarkMode ? "#AAAAAA" : "#999999")
                Layout.alignment: Qt.AlignHCenter
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                parent.clicked()
            }
        }
    }
}