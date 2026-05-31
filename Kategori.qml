import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: kategoriRoot
    color: mainWindow.isDarkMode ? "#121212" : "#FFFFFF"
    property string textColor: mainWindow.isDarkMode ? "#FFFFFF" : "#000000"
    property string subTextColor: mainWindow.isDarkMode ? "#AAAAAA" : "#333333"
    property string activeJudul: ""
    property string activeTanggal: ""
    property string activeWaktu: ""
    property string activeCatatan: ""

    ListModel {
        id: filteredModel
    }

    property string activeKategoriName: ""

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            Layout.fillWidth: true
            height: 70

            Text {
                text: "<"
                font.pixelSize: 22
                font.bold: true
                color: textColor

                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -15

                    onClicked: {
                        mainWindow.currentTab = "Beranda"
                        stackView.replace("Home.qml")
                    }
                }
            }

            Text {
                text: "Kategori"
                font.pixelSize: 16
                font.bold: true
                color: textColor
                anchors.centerIn: parent
            }
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ScrollBar.vertical.policy: ScrollBar.AlwaysOff

            Column {
                width: kategoriRoot.width - 40
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 15

                Item {
                    height: 10
                    width: 1
                }

                KategoriCard {
                    title: "Kerja"
                    iconSymbol: "💼"
                    bgColor: "#9BA4FF"
                    iconBoxColor: "#8D96FF"
                }

                KategoriCard {
                    title: "Pribadi"
                    iconSymbol: "📖"
                    bgColor: "#FFD180"
                    iconBoxColor: "#FFB74D"
                }

                KategoriCard {
                    title: "Kesehatan"
                    iconSymbol: "❤️"
                    bgColor: "#81E6D9"
                    iconBoxColor: "#4FD1C5"
                }

                KategoriCard {
                    title: "Pengembangan Diri"
                    iconSymbol: "🎓"
                    bgColor: "#90CAF9"
                    iconBoxColor: "#64B5F6"
                }
            }
        }
    }

    component KategoriCard: Rectangle {
        property string title: ""
        property string iconSymbol: ""
        property string bgColor: ""
        property string iconBoxColor: ""
        property int count: {

            var total = 0

            for (var i = 0;
                 i < mainWindow.reminderModel.count;
                 i++) {

                var item =
                        mainWindow.reminderModel.get(i)

                if (item.kategori === title
                        && item.isDone === 0
                        && item.timestamp > new Date().getTime()) {

                    total++
                }
            }

            return total
        }

        width: parent.width
        height: 90
        radius: 12
        color: bgColor

        RowLayout {
            anchors.fill: parent
            anchors.margins: 15
            spacing: 15

            Rectangle {
                width: 60
                height: 60
                radius: 12
                color: iconBoxColor

                Layout.alignment: Qt.AlignVCenter

                Text {
                    text: iconSymbol
                    font.pixelSize: 26
                    anchors.centerIn: parent
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                spacing: 2

                Text {
                    text: title
                    font.bold: true
                    font.pixelSize: 16
                    color: mainWindow.isDarkMode ? "#FFFFFF" : "#000000"
                }

                Text {
                    text: count + " Pengingat"
                    font.pixelSize: 13
                    color: mainWindow.isDarkMode ? "#E0E0E0" : "#333333"
                }
            }

            Text {
                text: ">"
                font.pixelSize: 20
                color: mainWindow.isDarkMode ? "#FFFFFF" : "#000000"
                Layout.alignment: Qt.AlignVCenter
            }
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                activeKategoriName = title
                filteredModel.clear()

                var i = 0

                while (i < mainWindow.reminderModel.count) {
                    var item = mainWindow.reminderModel.get(i)

                    if (item.kategori === title
                            && item.isDone === 0
                            && item.timestamp > new Date().getTime()) {
                        filteredModel.append({
                            "judul": item.judul,
                            "tanggal": item.tanggal,
                            "waktu": item.waktu,
                            "catatan": item.catatan,
                            "timestamp": item.timestamp,
                            "isDone": item.isDone
                        })
                    }

                    i++
                }

                categoryDetailPopup.open()
            }
        }
    }

    Popup {
        id: categoryDetailPopup
        width: parent.width
        height: parent.height
        modal: true
        focus: true

        background: Rectangle {
            color: mainWindow.isDarkMode ? "#121212" : "#FFFFFF"
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            Item {
                Layout.fillWidth: true
                height: 70

                Text {
                    text: "<"
                    font.pixelSize: 22
                    font.bold: true
                    color: textColor

                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.verticalCenter: parent.verticalCenter

                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -15
                        onClicked: categoryDetailPopup.close()
                    }
                }

                Text {
                    text: "Kategori: " + activeKategoriName
                    font.pixelSize: 16
                    font.bold: true
                    color: textColor
                    anchors.centerIn: parent
                }
            }

            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                ColumnLayout {
                    width: categoryDetailPopup.width - 40
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 15

                    Item {
                        height: 15
                        width: 1
                    }

                    Item {
                        Layout.fillWidth: true
                        width: parent.width
                        height: 300
                        visible: filteredModel.count === 0

                        Column {
                            anchors.centerIn: parent
                            spacing: 10
                            width: parent.width

                            Text {
                                text: "📭"
                                font.pixelSize: 50
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: "Kategori ini kosong"
                                font.bold: true
                                font.pixelSize: 16
                                color: textColor

                                width: parent.width
                                horizontalAlignment: Text.AlignHCenter
                                wrapMode: Text.WordWrap
                            }
                        }
                    }

                    Repeater {
                        model: filteredModel

                        delegate: Rectangle {
                            visible:
                                model.isDone === 0
                                && model.timestamp > new Date().getTime()
                            width: categoryDetailPopup.width - 40
                            height: 80
                            radius: 12
                            color: mainWindow.isDarkMode ? "#1C1C1C" : "#F8F9FA"

                            border.color: "#E0E0E0"
                            border.width: mainWindow.isDarkMode ? 0 : 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 15
                                spacing: 15

                                Rectangle {
                                    width: 50
                                    height: 50
                                    radius: 10

                                    color: activeKategoriName === "Kerja" ? "#9BA4FF"
                                           : activeKategoriName === "Pribadi" ? "#FFD180"
                                           : activeKategoriName === "Kesehatan" ? "#81E6D9"
                                           : activeKategoriName === "Pengembangan Diri" ? "#90CAF9"
                                           : "#E6E0F8"

                                    Text {
                                        text: activeKategoriName === "Kerja" ? "💼"
                                              : activeKategoriName === "Pribadi" ? "📖"
                                              : activeKategoriName === "Kesehatan" ? "❤️"
                                              : activeKategoriName === "Pengembangan Diri" ? "🎓"
                                              : "📅"

                                        anchors.centerIn: parent
                                        font.pixelSize: 24
                                    }
                                }

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 2

                                    Text {
                                        text: model.judul
                                        font.bold: true
                                        font.pixelSize: 15
                                        color: textColor
                                    }

                                    Text {
                                        text: model.tanggal + " • " + model.waktu
                                        font.pixelSize: 12
                                        color: subTextColor
                                    }
                                }
                            }

                            MouseArea {
                                anchors.fill: parent

                                onClicked: {
                                    activeJudul = model.judul
                                    activeTanggal = model.tanggal
                                    activeWaktu = model.waktu
                                    activeCatatan = model.catatan
                                    kategoriDetailPopup2.open()
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    Popup {
        id: kategoriDetailPopup2
        width: parent.width * 0.85
        height: 380
        anchors.centerIn: parent
        modal: true
        focus: true

        background: Rectangle {
            color: mainWindow.isDarkMode ? "#1E1E1E" : "#FFFFFF"
            radius: 20
            border.color: mainWindow.isDarkMode ? "#333333" : "#E0E0E0"
            border.width: 1
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15

            Text {
                text: "Keterangan Aktivitas"
                font.bold: true
                font.pixelSize: 18
                color: textColor
                Layout.alignment: Qt.AlignHCenter
            }

            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: mainWindow.isDarkMode ? "#333333" : "#EAEAEA"
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 10

                Text {
                    text: "<b>Judul:</b> " + activeJudul
                    font.pixelSize: 15
                    color: textColor
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }

                Text {
                    text: "<b>Kategori:</b> " + activeKategoriName
                    font.pixelSize: 15
                    color: textColor
                }

                Text {
                    text: "<b>Tanggal:</b> " + activeTanggal
                    font.pixelSize: 15
                    color: textColor
                }

                Text {
                    text: "<b>Waktu:</b> " + activeWaktu
                    font.pixelSize: 15
                    color: textColor
                }

                Text {
                    text: "<b>Catatan:</b> " + activeCatatan
                    font.pixelSize: 15
                    color: textColor
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }
            }

            Item {
                Layout.fillHeight: true
            }

            Rectangle {
                Layout.fillWidth: true
                height: 45
                radius: 12
                color: "#3B48FF"

                Text {
                    text: "Tutup"
                    color: "#FFFFFF"
                    font.bold: true
                    font.pixelSize: 15
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: kategoriDetailPopup2.close()
                }
            }
        }
    }
}