import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: addReminderRoot
    color: mainWindow.isDarkMode ? "#121212" : "#FFFFFF"

    property string textColor: mainWindow.isDarkMode ? "#FFFFFF" : "#000000"
    property string subTextColor: mainWindow.isDarkMode ? "#AAAAAA" : "#666666"
    property string borderColor: mainWindow.isDarkMode ? "#333333" : "#E0E0E0"
    property string popupBgColor: mainWindow.isDarkMode ? "#1E1E1E" : "#FFFFFF"

    property string selectedKategoriText: "Pilih kategori"
    property string selectedDateText: "Pilih tanggal"
    property string selectedTimeText: "Pilih waktu"
    property string selectedRepeatText: "Nonaktif"
    property string selectedSnoozeText: "5 menit"
    property var currentDate: new Date()
    property bool kategoriError: false
    property bool tanggalError: false
    property bool waktuError: false

    function padZero(num) {
        return num < 10 ? "0" + num : num.toString()
    }

    function formatDateToIndonesian(dateObj) {
        if (!dateObj) return ""
        var d = new Date(dateObj)
        var days = ["Minggu", "Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu"]
        var months = ["Januari", "Februari", "Maret", "April", "Mei", "Juni", "Juli", "Agustus", "September", "Oktober", "November", "Desember"]
        return days[d.getDay()] + ", " + d.getDate() + " " + months[d.getMonth()] + " " + d.getFullYear()
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
                    onClicked: {
                        stackView.pop()
                    }
                }
            }

            Text {
                text: "Tambah pengingat"
                font.pixelSize: 16
                font.bold: true
                color: textColor
                anchors.centerIn: parent
            }

            Rectangle {
                anchors.right: parent.right
                anchors.rightMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                width: 80
                height: 32
                radius: 16
                color: "#3B48FF"

                Text {
                    text: "Simpan"
                    color: "#FFFFFF"
                    font.bold: true
                    font.pixelSize: 13
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        kategoriError = selectedKategoriText === "Pilih kategori"
                        tanggalError = selectedDateText === "Pilih tanggal"
                        waktuError = selectedTimeText === "Pilih waktu"

                        if (kategoriError || tanggalError || waktuError) {
                            return
                        }
                        var d = new Date(datePopup.tempSelectedDate)

                        d.setHours(timePopup.tempHours)
                        d.setMinutes(timePopup.tempMinutes)
                        d.setSeconds(0)
                        d.setMilliseconds(0)

                        var timeStampValue = d.getTime()

                        mainWindow.addReminder(
                            inputJudul.inputText !== "" ? inputJudul.inputText : "Pengingat Tanpa Judul",
                            selectedKategoriText,
                            selectedDateText,
                            selectedTimeText,
                            inputCatatan.inputText !== "" ? inputCatatan.inputText : "-",
                            timeStampValue,
                            0
                        )
                        notificationClient.scheduleNotification(
                            Math.floor(Math.random() * 100000),
                            inputJudul.inputText,
                            inputCatatan.inputText,
                            selectedDateText,
                            selectedTimeText,
                            timeStampValue
                        )

                        notificationClient.showNotification(
                            "Don't Forget",
                            "Pengingat Berhasil Dibuat"
                        )

                        mainWindow.currentTab = "Beranda"
                        stackView.replace("Home.qml")
                    }
                }
            }
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            ScrollBar.vertical.policy: ScrollBar.AlwaysOff

            Item {
                width: addReminderRoot.width
                implicitHeight: formLayout.implicitHeight + 40

                ColumnLayout {
                    id: formLayout
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 25
                    spacing: 20

                    InputField {
                        id: inputJudul
                        labelText: "Judul"
                        placeholder: "Contoh: Kerja Kelompok AP"
                    }
                    Text {
                        visible: waktuError
                        text: "Wajib diisi"
                        color: "red"
                        font.pixelSize: 12
                    }

                    SelectorField {
                        labelText: "Kategori"
                        placeholder: selectedKategoriText
                        leftIcon:
                            selectedKategoriText === "Kerja" ? "💼"
                          : selectedKategoriText === "Pribadi" ? "📖"
                          : selectedKategoriText === "Kesehatan" ? "❤️"
                          : selectedKategoriText === "Pengembangan Diri" ? "🎓"
                          : "📁"
                        onClicked: {
                            kategoriPopup.open()
                        }
                    }
                    Text {
                        visible: kategoriError
                        text: "Wajib diisi"
                        color: "red"
                        font.pixelSize: 12
                    }

                    SelectorField {
                        labelText: "Tanggal"
                        placeholder: selectedDateText
                        leftIcon: "📅"
                        onClicked: {
                            datePopup.open()
                        }
                    }
                    Text {
                        visible: tanggalError
                        text: "Wajib diisi"
                        color: "red"
                        font.pixelSize: 12
                    }

                    SelectorField {
                        labelText: "Waktu"
                        placeholder: selectedTimeText
                        leftIcon: "🕒"
                        onClicked: {
                            timePopup.open()
                        }
                    }
                    Text {
                        visible: waktuError
                        text: "Wajib diisi"
                        color: "red"
                        font.pixelSize: 12
                    }

                    SelectorField {
                        labelText: "Ulangi"
                        placeholder: selectedRepeatText
                        leftIcon: "🔁"
                        onClicked: {
                            repeatPopup.open()
                        }
                    }

                    InputField {
                        id: inputCatatan
                        labelText: "Catatan"
                        placeholder: "Tambahkan catatan (opsional)"
                    }

                    SelectorField {
                        labelText: "Snooze"
                        placeholder: selectedSnoozeText
                        leftIcon: "⏰"
                        onClicked: {
                            snoozePopup.open()
                        }
                    }
                }
            }
        }
    }

    Popup {
        id: kategoriPopup
        width: parent.width
        height: parent.height
        modal: true
        focus: true
        background: Rectangle {
            color: popupBgColor
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
                        onClicked: {
                            kategoriPopup.close()
                        }
                    }
                }

                Text {
                    text: "Pilih Kategori"
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

                Column {
                    width: kategoriPopup.width - 40
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 15
                    topPadding: 15

                    RadioOption {
                        text: "Kerja"
                        iconSymbol: "💼"
                        isSelected: selectedKategoriText === "Kerja"
                        onClicked: {
                            selectedKategoriText = "Kerja"
                            kategoriPopup.close()
                        }
                    }

                    RadioOption {
                        text: "Pribadi"
                        iconSymbol: "📖"
                        isSelected: selectedKategoriText === "Pribadi"
                        onClicked: {
                            selectedKategoriText = "Pribadi"
                            kategoriPopup.close()
                        }
                    }

                    RadioOption {
                        text: "Kesehatan"
                        iconSymbol: "❤️"
                        isSelected: selectedKategoriText === "Kesehatan"
                        onClicked: {
                            selectedKategoriText = "Kesehatan"
                            kategoriPopup.close()
                        }
                    }

                    RadioOption {
                        text: "Pengembangan Diri"
                        iconSymbol: "🎓"
                        isSelected: selectedKategoriText === "Pengembangan Diri"
                        onClicked: {
                            selectedKategoriText = "Pengembangan Diri"
                            kategoriPopup.close()
                        }
                    }
                }
            }
        }
    }

    Popup {
        id: snoozePopup
        width: parent.width
        height: parent.height
        modal: true
        focus: true
        background: Rectangle {
            color: popupBgColor
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
                        onClicked: {
                            snoozePopup.close()
                        }
                    }
                }

                Text {
                    text: "Snooze"
                    font.pixelSize: 16
                    font.bold: true
                    color: textColor
                    anchors.centerIn: parent
                }

                Rectangle {
                    anchors.right: parent.right
                    anchors.rightMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                    width: 80
                    height: 32
                    radius: 16
                    color: "#3B48FF"

                    Text {
                        text: "Simpan"
                        color: "#FFFFFF"
                        font.bold: true
                        font.pixelSize: 13
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            snoozePopup.close()
                        }
                    }
                }
            }

            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                Column {
                    width: snoozePopup.width - 40
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 15
                    topPadding: 15

                    Text {
                        text: "Snooze"
                        font.bold: true
                        font.pixelSize: 18
                        color: textColor
                        bottomPadding: 10
                    }

                    RadioOption {
                        text: "5 menit"
                        iconSymbol: "🕒"
                        isSelected: selectedSnoozeText === "5 menit"
                        onClicked: {
                            selectedSnoozeText = "5 menit"
                        }
                    }

                    RadioOption {
                        text: "10 menit"
                        iconSymbol: "🕒"
                        isSelected: selectedSnoozeText === "10 menit"
                        onClicked: {
                            selectedSnoozeText = "10 menit"
                        }
                    }

                    RadioOption {
                        text: "30 menit"
                        iconSymbol: "🕒"
                        isSelected: selectedSnoozeText === "30 menit"
                        onClicked: {
                            selectedSnoozeText = "30 menit"
                        }
                    }

                    RadioOption {
                        text: "1 jam"
                        iconSymbol: "🕒"
                        isSelected: selectedSnoozeText === "1 jam"
                        onClicked: {
                            selectedSnoozeText = "1 jam"
                        }
                    }

                    RadioOption {
                        text: "Besok"
                        iconSymbol: "🕒"
                        isSelected: selectedSnoozeText === "Besok"
                        onClicked: {
                            selectedSnoozeText = "Besok"
                        }
                    }

                    RadioOption {
                        text: "Pilih waktu lainnya"
                        iconSymbol: "🕒"
                        isSelected: selectedSnoozeText === "Pilih waktu lainnya"
                        onClicked: {
                            selectedSnoozeText = "Pilih waktu lainnya"
                        }
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                height: 80

                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width - 60
                    height: 45
                    radius: 15
                    color: mainWindow.isDarkMode ? "#2C2C3E" : "#F0F0FF"

                    Text {
                        text: "Batal"
                        font.bold: true
                        color: textColor
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            snoozePopup.close()
                        }
                    }
                }
            }
        }
    }

    Popup {
        id: repeatPopup
        width: parent.width
        height: parent.height
        modal: true
        focus: true
        background: Rectangle {
            color: popupBgColor
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
                        onClicked: {
                            repeatPopup.close()
                        }
                    }
                }

                Text {
                    text: "Ulangi"
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

                Column {
                    width: repeatPopup.width - 40
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 15
                    topPadding: 15

                    RadioOption {
                        text: "Nonaktif"
                        iconSymbol: "🚫"
                        isSelected: selectedRepeatText === "Nonaktif"
                        onClicked: {
                            selectedRepeatText = "Nonaktif"
                            repeatPopup.close()
                        }
                    }

                    RadioOption {
                        text: "Setiap hari"
                        iconSymbol: "🔁"
                        isSelected: selectedRepeatText === "Setiap hari"
                        onClicked: {
                            selectedRepeatText = "Setiap hari"
                            repeatPopup.close()
                        }
                    }

                    RadioOption {
                        text: "Setiap minggu"
                        iconSymbol: "🗓️"
                        isSelected: selectedRepeatText === "Setiap minggu"
                        onClicked: {
                            selectedRepeatText = "Setiap minggu"
                            repeatPopup.close()
                        }
                    }

                    RadioOption {
                        text: "Setiap bulan (Pilih tanggal)..."
                        iconSymbol: "📆"
                        isSelected: selectedRepeatText.indexOf("Setiap bulan") !== -1
                        onClicked: {
                            repeatMonthDialog.open()
                        }
                    }

                    RadioOption {
                        text: "Setiap beberapa hari..."
                        iconSymbol: "⚙️"
                        isSelected: selectedRepeatText.indexOf("hari sekali") !== -1
                        onClicked: {
                            repeatDaysDialog.open()
                        }
                    }
                }
            }
        }
    }

    Popup {
        id: repeatMonthDialog
        width: parent.width * 0.8
        height: 350
        anchors.centerIn: parent
        modal: true
        focus: true
        background: Rectangle {
            color: popupBgColor
            radius: 20
            border.color: borderColor
            border.width: 1
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15

            Text {
                text: "Pilih Tanggal Pengulangan"
                font.bold: true
                color: textColor
                font.pixelSize: 16
                Layout.alignment: Qt.AlignHCenter
            }

            Tumbler {
                id: monthDayTumbler
                Layout.fillWidth: true
                Layout.fillHeight: true
                model: 31
                delegate: Text {
                    text: modelData + 1
                    font.pixelSize: Tumbler.tumbler.currentIndex === index ? 24 : 18
                    color: Tumbler.tumbler.currentIndex === index ? "#3B48FF" : subTextColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 45
                radius: 12
                color: "#3B48FF"

                Text {
                    text: "Simpan"
                    color: "#FFFFFF"
                    font.bold: true
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        selectedRepeatText = "Setiap bulan tgl " + (monthDayTumbler.currentIndex + 1)
                        repeatMonthDialog.close()
                        repeatPopup.close()
                    }
                }
            }
        }
    }

    Popup {
        id: repeatDaysDialog
        width: parent.width * 0.8
        height: 350
        anchors.centerIn: parent
        modal: true
        focus: true
        background: Rectangle {
            color: popupBgColor
            radius: 20
            border.color: borderColor
            border.width: 1
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15

            Text {
                text: "Ulangi setiap berapa hari?"
                font.bold: true
                color: textColor
                font.pixelSize: 16
                Layout.alignment: Qt.AlignHCenter
            }

            Tumbler {
                id: customDaysTumbler
                Layout.fillWidth: true
                Layout.fillHeight: true
                model: [2, 3, 4, 5, 6]
                delegate: Text {
                    text: modelData + " Hari"
                    font.pixelSize: Tumbler.tumbler.currentIndex === index ? 24 : 18
                    color: Tumbler.tumbler.currentIndex === index ? "#3B48FF" : subTextColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 45
                radius: 12
                color: "#3B48FF"

                Text {
                    text: "Simpan"
                    color: "#FFFFFF"
                    font.bold: true
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        selectedRepeatText = "Setiap " + customDaysTumbler.model[customDaysTumbler.currentIndex] + " hari sekali"
                        repeatDaysDialog.close()
                        repeatPopup.close()
                    }
                }
            }
        }
    }

    component RadioOption: Item {
        id: optionRoot
        property string text: ""
        property string iconSymbol: ""
        property bool isSelected: false
        signal clicked()

        width: parent.width
        height: 55

        Rectangle {
            id: iconBox
            width: 45
            height: 45
            radius: 12
            color: "transparent"
            border.color: isSelected ? "#3B48FF" : borderColor
            border.width: isSelected ? 2 : 1
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter

            Text {
                text: iconSymbol
                font.pixelSize: 20
                anchors.centerIn: parent
            }
        }

        Text {
            id: labelText
            text: optionRoot.text
            color: textColor
            font.pixelSize: 15
            anchors.left: iconBox.right
            anchors.leftMargin: 15
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: "✓"
            color: "#3B48FF"
            font.bold: true
            font.pixelSize: 18
            visible: isSelected
            anchors.left: labelText.right
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                optionRoot.clicked()
            }
        }
    }

    component InputField: ColumnLayout {
        property string labelText: ""
        property string placeholder: ""
        property alias inputText: inputComponent.text

        Layout.fillWidth: true
        spacing: 8

        Text {
            text: labelText
            font.bold: true
            font.pixelSize: 14
            color: addReminderRoot.textColor
        }

        TextField {
            id: inputComponent
            activeFocusOnPress: true

            onAccepted: {
                focus = false
                Qt.inputMethod.hide()
            }

            Layout.fillWidth: true
            placeholderText: placeholder
            font.pixelSize: 14
            color: addReminderRoot.textColor
            placeholderTextColor: mainWindow.isDarkMode ? "#777777" : "#AAAAAA"
            leftPadding: 12
            rightPadding: 12
            topPadding: 10
            bottomPadding: 10

            background: Rectangle {
                radius: 8
                border.color: addReminderRoot.borderColor
                border.width: 1
                color: "transparent"
            }
        }
    }

    component SelectorField: ColumnLayout {
        id: selectorRoot
        property string labelText: ""
        property string placeholder: ""
        property string leftIcon: ""
        signal clicked()

        Layout.fillWidth: true
        spacing: 8

        Text {
            text: labelText
            font.bold: true
            font.pixelSize: 14
            color: textColor
        }

        Rectangle {
            Layout.fillWidth: true
            height: 42
            radius: 8
            border.color: borderColor
            border.width: 1
            color: "transparent"

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 10

                Text {
                    text: leftIcon
                    visible: leftIcon !== ""
                    font.pixelSize: 16
                }

                Text {
                    text: placeholder
                    color: placeholder.indexOf("Pilih") !== -1 ? subTextColor : textColor
                    font.pixelSize: 14
                    Layout.fillWidth: true
                }

                Text {
                    text: ">"
                    color: subTextColor
                    font.bold: true
                    font.pixelSize: 16
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    selectorRoot.clicked()
                }
            }
        }
    }

    Popup {
        id: timePopup
        width: parent.width * 0.85
        height: 400
        anchors.centerIn: parent
        modal: true
        focus: true
        property int tempHours: hoursTumbler.currentIndex
        property int tempMinutes: minutesTumbler.currentIndex

        background: Rectangle {
            color: popupBgColor
            radius: 20
            border.color: borderColor
            border.width: 1
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20

            RowLayout {
                Layout.alignment: Qt.AlignHCenter

                Text {
                    text: "🕒"
                    font.pixelSize: 24
                    color: "#3B48FF"
                }

                Text {
                    text: padZero(hoursTumbler.currentIndex) + " : " + padZero(minutesTumbler.currentIndex)
                    font.pixelSize: 32
                    font.bold: true
                    color: "#3B48FF"
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 10

                Tumbler {
                    id: hoursTumbler
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: 24
                    visibleItemCount: 5

                    delegate: Text {
                        text: padZero(modelData)
                        font.pixelSize: Tumbler.tumbler.currentIndex === index ? 24 : 18
                        color: Tumbler.tumbler.currentIndex === index ? "#3B48FF" : textColor
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        opacity: 1.0 - Math.abs(Tumbler.tumbler.currentIndex - index) * 0.2
                    }
                }

                Text {
                    text: ":"
                    font.pixelSize: 24
                    font.bold: true
                    color: textColor
                }

                Tumbler {
                    id: minutesTumbler
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: 60
                    visibleItemCount: 5

                    delegate: Text {
                        text: padZero(modelData)
                        font.pixelSize: Tumbler.tumbler.currentIndex === index ? 24 : 18
                        color: Tumbler.tumbler.currentIndex === index ? "#3B48FF" : textColor
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        opacity: 1.0 - Math.abs(Tumbler.tumbler.currentIndex - index) * 0.2
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 45
                radius: 12
                color: "#3B48FF"

                Text {
                    text: "Simpan"
                    color: "#FFFFFF"
                    font.bold: true
                    font.pixelSize: 16
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        timePopup.tempHours = hoursTumbler.currentIndex
                        timePopup.tempMinutes = minutesTumbler.currentIndex
                        selectedTimeText = padZero(hoursTumbler.currentIndex) + ":" + padZero(minutesTumbler.currentIndex)
                        timePopup.close()
                    }
                }
            }
        }
    }

    Popup {
        id: datePopup
        width: parent.width * 0.9
        height: 520
        anchors.centerIn: parent
        modal: true
        focus: true
        property var tempSelectedDate: new Date()

        background: Rectangle {
            color: popupBgColor
            radius: 20
            border.color: borderColor
            border.width: 1
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 15

            Item {
                Layout.fillWidth: true
                height: 30

                Text {
                    text: "✖"
                    font.pixelSize: 16
                    font.bold: true
                    color: textColor
                    anchors.left: parent.left

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            datePopup.close()
                        }
                    }
                }

                Text {
                    text: "Pilih Tanggal"
                    font.bold: true
                    font.pixelSize: 16
                    color: textColor
                    anchors.centerIn: parent
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter

                Rectangle {
                    width: 30
                    height: 30
                    radius: 5
                    color: mainWindow.isDarkMode ? "#333333" : "#F5F5F5"

                    Text {
                        text: "<"
                        color: textColor
                        font.bold: true
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            monthGrid.month = monthGrid.month - 1
                        }
                    }
                }

                Text {
                    property var monthNames: ["Januari", "Februari", "Maret", "April", "Mei", "Juni", "Juli", "Agustus", "September", "Oktober", "November", "Desember"]
                    text: monthNames[monthGrid.month] + " " + monthGrid.year
                    font.bold: true
                    color: textColor
                    font.pixelSize: 16
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                }

                Rectangle {
                    width: 30
                    height: 30
                    radius: 5
                    color: mainWindow.isDarkMode ? "#333333" : "#F5F5F5"

                    Text {
                        text: ">"
                        color: textColor
                        font.bold: true
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            monthGrid.month = monthGrid.month + 1
                        }
                    }
                }
            }

            DayOfWeekRow {
                locale: Qt.locale("id_ID")
                Layout.fillWidth: true

                delegate: Text {
                    text: model.shortName
                    font.pixelSize: 12
                    color: subTextColor
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            MonthGrid {
                id: monthGrid
                month: currentDate.getMonth()
                year: currentDate.getFullYear()
                Layout.fillWidth: true
                Layout.fillHeight: true
                locale: Qt.locale("id_ID")

                delegate: Rectangle {
                    width: monthGrid.width / 7
                    height: monthGrid.height / 6
                    radius: 20
                    color: (model.date.getDate() === datePopup.tempSelectedDate.getDate() && model.date.getMonth() === datePopup.tempSelectedDate.getMonth()) ? "#3B48FF" : "transparent"

                    Text {
                        anchors.centerIn: parent
                        text: model.day
                        color: parent.color === "#3B48FF" ? "#FFFFFF" : (model.month === monthGrid.month ? textColor : subTextColor)
                        font.pixelSize: 14
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            datePopup.tempSelectedDate = model.date
                        }
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 15

                Rectangle {
                    width: 40
                    height: 40
                    radius: 8
                    color: mainWindow.isDarkMode ? "#2A2A35" : "#F0F0FF"

                    Text {
                        text: "📅"
                        font.pixelSize: 20
                        anchors.centerIn: parent
                    }
                }

                ColumnLayout {
                    spacing: 2

                    Text {
                        text: "Tanggal terpilih"
                        font.pixelSize: 11
                        color: subTextColor
                    }

                    Text {
                        text: formatDateToIndonesian(datePopup.tempSelectedDate)
                        font.pixelSize: 14
                        color: "#3B48FF"
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: 45
                radius: 12
                color: "#3B48FF"

                Text {
                    text: "Simpan"
                    color: "#FFFFFF"
                    font.bold: true
                    font.pixelSize: 16
                    anchors.centerIn: parent
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        selectedDateText = formatDateToIndonesian(datePopup.tempSelectedDate)
                        datePopup.close()
                    }
                }
            }
        }
    }
}
