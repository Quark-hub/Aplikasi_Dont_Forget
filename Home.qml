import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: homeRoot
    color: mainWindow.isDarkMode ? "#000000" : "#F8F9FA"

    property string activeJudul: ""
    property string activeKategori: ""
    property string activeTanggal: ""
    property string activeWaktu: ""
    property string activeCatatan: ""

    ScrollView {
        anchors.fill: parent
        clip: true

        ScrollBar.vertical.policy: ScrollBar.AlwaysOff
        anchors.margins: 20

        ColumnLayout {
            width: parent.width
            spacing: 20

            Rectangle {
                Layout.fillWidth: true
                height: 50
                radius: 25
                color: mainWindow.isDarkMode ? "#E8E8E8" : "#F0F0F0"

                Text {
                    anchors.centerIn: parent
                    text: "<b>Hello</b>, welcome to don't forget"
                    color: "#000000"
                }
            }

            ColumnLayout {
                spacing: 5

                Text {
                    text: "Daily Plan"
                    font.bold: true
                    font.pixelSize: 20
                    color: mainWindow.isDarkMode ? "#FFFFFF" : "#000000"
                }

                Text {
                    text: "Atur aktivitas harianmu, jangan sampai ada yang terlewat."
                    font.pixelSize: 12
                    color: "#6A5ACD"
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                }
            }

            Item {
                Layout.fillWidth: true
                height: 300
                visible: {

                    var adaReminder = false

                    for (var i = 0;
                         i < mainWindow.reminderModel.count;
                         i++) {

                        if (mainWindow.reminderModel.get(i).isDone === 0
                                && mainWindow.reminderModel.get(i).timestamp > new Date().getTime()) {

                            adaReminder = true
                        }
                    }

                    return !adaReminder
                }
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 10

                    Text {
                        text: "📭"
                        font.pixelSize: 50
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: "Belum ada pengingat"
                        font.bold: true
                        font.pixelSize: 16
                        color: mainWindow.isDarkMode ? "#FFFFFF" : "#000000"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: "Tekan tombol + di bawah untuk menambahkan."
                        font.pixelSize: 12
                        color: mainWindow.isDarkMode ? "#AAAAAA" : "#666666"
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 15
                visible: {

                    var adaReminder = false

                    for (var i = 0;
                         i < mainWindow.reminderModel.count;
                         i++) {

                        if (mainWindow.reminderModel.get(i).isDone === 0
                                && mainWindow.reminderModel.get(i).timestamp > new Date().getTime()) {

                            adaReminder = true
                        }
                    }

                    return adaReminder
                }

                Repeater {
                    model: mainWindow.reminderModel

                    delegate: Rectangle {
                        visible:
                            model.isDone === 0
                            && model.timestamp > new Date().getTime()
                        width: homeRoot.width - 40
                        height: 80
                        radius: 12
                        color: mainWindow.isDarkMode ? "#1C1C1C" : "#FFFFFF"
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
                                color: model.kategori === "Kerja" ? "#9BA4FF" : (model.kategori === "Pribadi" ? "#FFD180" : (model.kategori === "Kesehatan" ? "#81E6D9" : (model.kategori === "Pengembangan Diri" ? "#90CAF9" : "#E6E0F8")))

                                Text {
                                    text: model.kategori === "Kerja" ? "💼" : (model.kategori === "Pribadi" ? "📖" : (model.kategori === "Kesehatan" ? "❤️" : (model.kategori === "Pengembangan Diri" ? "🎓" : "📅")))
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
                                    color: mainWindow.isDarkMode ? "#FFFFFF" : "#000000"
                                }

                                Text {
                                    text: model.tanggal + " • " + model.waktu
                                    font.pixelSize: 12
                                    color: mainWindow.isDarkMode ? "#BBBBBB" : "#666666"
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                homeRoot.activeJudul = model.judul
                                homeRoot.activeKategori = model.kategori
                                homeRoot.activeTanggal = model.tanggal
                                homeRoot.activeWaktu = model.waktu
                                homeRoot.activeCatatan = model.catatan
                                detailPopup.open()
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.topMargin: 20
                Layout.bottomMargin: 20
                height: 100
                radius: 15
                color: mainWindow.isDarkMode ? "#1A1A24" : "#F4F5F9"

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 10

                    ColumnLayout {
                        spacing: 2
                        Layout.alignment: Qt.AlignHCenter

                        Text {
                            text: "Tema Aplikasi"
                            font.bold: true
                            font.pixelSize: 14
                            color: mainWindow.isDarkMode ? "#FFFFFF" : "#000000"
                            Layout.alignment: Qt.AlignHCenter
                        }

                        Text {
                            text: "Pilih mode terang atau gelap."
                            font.pixelSize: 12
                            color: mainWindow.isDarkMode ? "#AAAAAA" : "#666666"
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }

                    Rectangle {
                        width: 110
                        height: 36
                        radius: 18
                        color: mainWindow.isDarkMode ? "#FFFFFF" : "#1A1A1A"
                        border.color: "#DDDDDD"
                        border.width: mainWindow.isDarkMode ? 1 : 0
                        Layout.alignment: Qt.AlignHCenter

                        Text {
                            text: "☀️"
                            anchors.verticalCenter: parent.verticalCenter
                            x: 12
                            font.pixelSize: 14
                        }

                        Text {
                            text: "🌙"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            anchors.rightMargin: 12
                            font.pixelSize: 14
                        }

                        Rectangle {
                            width: 44
                            height: 30
                            radius: 15
                            color: mainWindow.isDarkMode ? "#1A1A1A" : "#FFFFFF"
                            anchors.verticalCenter: parent.verticalCenter
                            x: mainWindow.isDarkMode ? (parent.width - width - 3) : 3

                            Behavior on x {
                                NumberAnimation {
                                    duration: 250
                                    easing.type: Easing.InOutQuad
                                }
                            }

                            Text {
                                text: mainWindow.isDarkMode ? "🌙" : "☀️"
                                anchors.centerIn: parent
                                font.pixelSize: 16
                            }
                        }

                        MouseArea {
                            anchors.fill: parent

                            onClicked: {

                                mainWindow.isDarkMode =
                                    !mainWindow.isDarkMode

                                settingsManager.saveDarkMode(
                                    mainWindow.isDarkMode
                                )
                            }
                        }
                    }
                }
            }
        }
    }

    Popup {
        id: detailPopup
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
                color: mainWindow.isDarkMode ? "#FFFFFF" : "#000000"
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
                    text: "<b>Judul:</b> " + homeRoot.activeJudul
                    font.pixelSize: 15
                    color: mainWindow.isDarkMode ? "#FFFFFF" : "#000000"
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }

                Text {
                    text: "<b>Kategori:</b> " + homeRoot.activeKategori
                    font.pixelSize: 15
                    color: mainWindow.isDarkMode ? "#FFFFFF" : "#000000"
                }

                Text {
                    text: "<b>Tanggal:</b> " + homeRoot.activeTanggal
                    font.pixelSize: 15
                    color: mainWindow.isDarkMode ? "#FFFFFF" : "#000000"
                }

                Text {
                    text: "<b>Waktu:</b> " + homeRoot.activeWaktu
                    font.pixelSize: 15
                    color: mainWindow.isDarkMode ? "#FFFFFF" : "#000000"
                }

                Text {
                    text: "<b>Catatan:</b> " + homeRoot.activeCatatan
                    font.pixelSize: 15
                    color: mainWindow.isDarkMode ? "#FFFFFF" : "#000000"
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
                    onClicked: {
                        detailPopup.close()
                    }
                }
            }
        }
    }
}