import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: statistikRoot
    color: mainWindow.isDarkMode ? "#121212" : "#F5F5F5"

    property string selectedMode: "Hari"

    property date currentDate: new Date()

    function isTaskFinished(timestampValue) {
        return timestampValue < new Date().getTime()
    }

    function isInSelectedRange(timestampValue) {

        var d = new Date(timestampValue)
        var now = currentDate

        if (selectedMode === "Hari") {

            return d.getDate() === now.getDate()
                    && d.getMonth() === now.getMonth()
                    && d.getFullYear() === now.getFullYear()
        }

        if (selectedMode === "Minggu") {

            var firstDay = new Date(now)
            firstDay.setDate(now.getDate() - now.getDay() + 1)

            var lastDay = new Date(firstDay)
            lastDay.setDate(firstDay.getDate() + 6)

            return d >= firstDay && d <= lastDay
        }

        if (selectedMode === "Bulan") {

            return d.getMonth() === now.getMonth()
                    && d.getFullYear() === now.getFullYear()
        }

        if (selectedMode === "Tahun") {

            return d.getFullYear() === now.getFullYear()
        }

        return false
    }

    function totalTask() {

        var total = 0

        for (var i = 0;
             i < mainWindow.reminderModel.count;
             i++) {

            var item =
                    mainWindow.reminderModel.get(i)

            if (isInSelectedRange(item.timestamp)) {
                total++
            }
        }

        return total
    }

    function finishedTask() {

        var total = 0

        for (var i = 0;
             i < mainWindow.reminderModel.count;
             i++) {

            var item =
                    mainWindow.reminderModel.get(i)

            if (isInSelectedRange(item.timestamp)
                    && item.isDone === 1) {

                total++
            }
        }

        return total
    }

    function unfinishedTask() {
        return totalTask() - finishedTask()
    }

    function getCategoryCount(categoryName) {

        var total = 0

        for (var i = 0;
             i < mainWindow.reminderModel.count;
             i++) {

            var item =
                    mainWindow.reminderModel.get(i)

            if (item.kategori === categoryName
                    && isInSelectedRange(item.timestamp)) {

                total++
            }
        }

        return total
    }

    function getDateText() {

        var months = [
            "Januari","Februari","Maret","April",
            "Mei","Juni","Juli","Agustus",
            "September","Oktober","November","Desember"
        ]

        if (selectedMode === "Hari") {

            return currentDate.getDate()
                    + " "
                    + months[currentDate.getMonth()]
                    + " "
                    + currentDate.getFullYear()
        }

        if (selectedMode === "Minggu") {

            var start = new Date(currentDate)
            start.setDate(currentDate.getDate() - currentDate.getDay() + 1)

            var end = new Date(start)
            end.setDate(start.getDate() + 6)

            return start.getDate()
                    + " - "
                    + end.getDate()
                    + " "
                    + months[end.getMonth()]
        }

        if (selectedMode === "Bulan") {

            return months[currentDate.getMonth()]
                    + " "
                    + currentDate.getFullYear()
        }

        if (selectedMode === "Tahun") {

            return currentDate.getFullYear()
        }

        return ""
    }

    ScrollView {
        id: statistikScrollView
        anchors.fill: parent
        clip: true
        contentWidth: availableWidth

        // Komponen pembungkus untuk menstabilkan tinggi dan lebar konten
        Item {
            width: statistikScrollView.contentWidth
            implicitHeight: mainLayout.implicitHeight + 30 // Memberi ruang ekstra di bawah agar tidak menempel

            ColumnLayout {
                id: mainLayout
                anchors.top: parent.top
                anchors.topMargin: 15
                anchors.horizontalCenter: parent.horizontalCenter

                // Kalkulasi lebar yang aman: menyisakan 15px di kiri & kanan (total 30px) dari layar HP,
                // atau maksimal 600px jika dibuka di perangkat yang lebih lebar
                width: Math.min(parent.width - 30, 600)

                spacing: 15

                Text {
                    text: "Statistik"
                    font.bold: true
                    font.pixelSize: 22
                    color: mainWindow.isDarkMode ? "#FFFFFF" : "#000000"

                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                }

                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    width: 260
                    height: 55
                    radius: 12
                    color: mainWindow.isDarkMode ? "#1E1E1E" : "#EBEBEB"

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 6
                        spacing: 8

                        Repeater {
                            model: ["Hari", "Minggu", "Bulan", "Tahun"]

                            delegate: Rectangle {

                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                radius: 10

                                color: selectedMode === modelData
                                       ? "#FFFFFF"
                                       : "transparent"

                                Text {
                                    text: modelData
                                    anchors.centerIn: parent
                                    font.bold: selectedMode === modelData
                                    color: selectedMode === modelData
                                           ? "#5A54FF"
                                           : (mainWindow.isDarkMode ? "#FFFFFF" : "#000000")
                                }

                                MouseArea {
                                    anchors.fill: parent

                                    onClicked: {
                                        selectedMode = modelData
                                    }
                                }
                            }
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        text: "<"
                        visible: selectedMode === "Hari"

                        font.pixelSize: 22
                        color: mainWindow.isDarkMode ? "#FFFFFF" : "#000000"

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                currentDate.setDate(currentDate.getDate() - 1)
                                currentDate = new Date(currentDate)
                            }
                        }
                    }

                    Text {
                        id: tanggalText
                        text: "📅  " + getDateText()

                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: 16
                        color: mainWindow.isDarkMode ? "#FFFFFF" : "#000000"

                        MouseArea {
                            anchors.fill: parent

                            enabled: selectedMode === "Hari"

                            onClicked: {
                                statistikDatePopup.open()
                            }
                        }
                    }

                    Text {
                        text: ">"
                        visible: selectedMode === "Hari"

                        font.pixelSize: 22
                        color: mainWindow.isDarkMode ? "#FFFFFF" : "#000000"

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {
                                currentDate.setDate(currentDate.getDate() + 1)
                                currentDate = new Date(currentDate)
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 130
                    radius: 15
                    color: mainWindow.isDarkMode ? "#1C1C1C" : "#FFFFFF"

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 15

                        ColumnLayout {

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter

                            Text {
                                text: totalTask()
                                font.bold: true
                                font.pixelSize: 28
                                color: "#2D4BFF"
                                Layout.alignment: Qt.AlignHCenter
                            }

                            Text {

                                text: "Total Tugas"

                                font.pixelSize: 11

                                color: mainWindow.isDarkMode
                                       ? "#FFFFFF"
                                       : "#000000"

                                horizontalAlignment: Text.AlignHCenter

                                Layout.preferredHeight: 35
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }

                        Rectangle {
                            width: 1
                            Layout.fillHeight: true
                            color: "#DDDDDD"
                        }

                        ColumnLayout {

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter

                            Text {
                                text: finishedTask()
                                font.bold: true
                                font.pixelSize: 28
                                color: "#00B140"
                                Layout.alignment: Qt.AlignHCenter
                            }

                            Text {

                                text: "Selesai"

                                font.pixelSize: 11

                                color: mainWindow.isDarkMode
                                       ? "#FFFFFF"
                                       : "#000000"

                                horizontalAlignment: Text.AlignHCenter

                                Layout.preferredHeight: 35
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }

                        Rectangle {
                            width: 1
                            Layout.fillHeight: true
                            color: "#DDDDDD"
                        }

                        ColumnLayout {

                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter

                            spacing: 8

                            Item {
                                Layout.fillHeight: true
                            }

                            Text {
                                text: unfinishedTask()

                                font.bold: true
                                font.pixelSize: 28

                                color: "#FF0000"

                                Layout.alignment: Qt.AlignHCenter
                            }

                            Text {

                                text: "Belum\nSelesai"

                                font.pixelSize: 11

                                color: mainWindow.isDarkMode
                                       ? "#FFFFFF"
                                       : "#000000"

                                horizontalAlignment: Text.AlignHCenter

                                Layout.preferredHeight: 35
                                Layout.alignment: Qt.AlignHCenter
                            }

                            Item {
                                Layout.fillHeight: true
                            }
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 160
                    radius: 15
                    color: mainWindow.isDarkMode ? "#1C1C1C" : "#FFFFFF"

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 10

                        RowLayout {
                            Layout.fillWidth: true

                            Text {
                                text: "Progress"
                                font.bold: true
                                Layout.fillWidth: true
                                color: mainWindow.isDarkMode ? "#FFFFFF" : "#000000"
                            }

                            Text {
                                text: totalTask() === 0
                                      ? "0%"
                                      : Math.round((finishedTask() / totalTask()) * 100) + "%"

                                color: mainWindow.isDarkMode ? "#FFFFFF" : "#000000"
                            }
                        }

                        ProgressBar {
                            width: parent.width
                            Layout.fillWidth: true

                            value: totalTask() === 0
                                   ? 0
                                   : finishedTask() / totalTask()
                        }

                        Text {
                            text: finishedTask()
                                  + " dari "
                                  + totalTask()
                                  + " tugas selesai"

                            font.pixelSize: 12
                            color: "#777777"
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 260
                    radius: 15
                    color: mainWindow.isDarkMode ? "#1C1C1C" : "#FFFFFF"

                    ColumnLayout {
                        Layout.fillWidth: true
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 15

                        Text {
                            text: "Tugas per Kategori"
                            font.bold: true
                            font.pixelSize: 16
                            color: mainWindow.isDarkMode ? "#FFFFFF" : "#000000"
                        }

                        Repeater {

                            model: [
                                {
                                    "nama":"Kerja",
                                    "icon":"💼"
                                },

                                {
                                    "nama":"Pribadi",
                                    "icon":"📖"
                                },

                                {
                                    "nama":"Kesehatan",
                                    "icon":"❤️"
                                },

                                {
                                    "nama":"Pengembangan Diri",
                                    "icon":"🎓"
                                }
                            ]

                            delegate: Rectangle {

                                Layout.fillWidth: true
                                width: parent.width
                                height: 45
                                color: "transparent"

                                RowLayout {
                                    anchors.fill: parent
                                    spacing: 12

                                    Text {
                                        text: modelData.icon
                                        font.pixelSize: 18
                                    }

                                    Text {
                                        text: modelData.nama
                                        Layout.fillWidth: true
                                        font.pixelSize: 14
                                        color: mainWindow.isDarkMode ? "#FFFFFF" : "#000000"
                                    }

                                    Text {
                                        text: getCategoryCount(modelData.nama)
                                        font.pixelSize: 14
                                        color: mainWindow.isDarkMode ? "#FFFFFF" : "#000000"
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    Popup {
        id: statistikDatePopup

        width: parent.width * 0.9
        height: 520

        anchors.centerIn: parent

        modal: true
        focus: true

        background: Rectangle {
            color: mainWindow.isDarkMode ? "#1E1E1E" : "#FFFFFF"
            radius: 20
            border.color: "#DDDDDD"
            border.width: 1
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15

            Text {
                text: "Pilih Tanggal"
                font.bold: true
                font.pixelSize: 18
                color: mainWindow.isDarkMode ? "#FFFFFF" : "#000000"

                Layout.alignment: Qt.AlignHCenter
            }

            DayOfWeekRow {
                locale: Qt.locale("id_ID")
                Layout.fillWidth: true

                delegate: Text {
                    text: model.shortName
                    horizontalAlignment: Text.AlignHCenter
                    color: "#888888"
                }
            }

            MonthGrid {

                id: statistikMonthGrid

                month: currentDate.getMonth()
                year: currentDate.getFullYear()

                Layout.fillWidth: true
                Layout.fillHeight: true

                locale: Qt.locale("id_ID")

                delegate: Rectangle {

                    width: statistikMonthGrid.width / 7
                    height: statistikMonthGrid.height / 6

                    radius: 20

                    color: (
                                model.date.getDate() === currentDate.getDate()
                                && model.date.getMonth() === currentDate.getMonth()
                            )
                            ? "#6C63FF"
                            : "transparent"

                    Text {
                        anchors.centerIn: parent

                        text: model.day

                        color: parent.color === "#6C63FF"
                               ? "#FFFFFF"
                               : (mainWindow.isDarkMode ? "#FFFFFF" : "#000000")
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {

                            currentDate = model.date
                            statistikDatePopup.close()
                        }
                    }
                }
            }

            Rectangle {

                Layout.fillWidth: true
                height: 45
                radius: 12

                color: "#6C63FF"

                Text {
                    text: "Tutup"
                    anchors.centerIn: parent
                    color: "#FFFFFF"
                    font.bold: true
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        statistikDatePopup.close()
                    }
                }
            }
        }
    }
}