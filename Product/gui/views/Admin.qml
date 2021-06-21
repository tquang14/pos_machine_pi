import QtQuick 2.9
import QtQuick.Controls 2.0
import com.AdminModel 1.0
import QtQml 2.0
//import Qt.labs.qmlmodels 1.0
import "../Styling"
import "../components"
Item {
    width: Styling._DISPLAY_WIDTH
    height: Styling._DISPLAY_HEIGHT
    property var locale: Qt.locale()
//    property string dateTimeString: "21-05-2021"
//    property date currentDate: new Date()
    property var choosenDate: new Date() // set default choose date is current day
    property int income: 0
    signal requestChangePage(var identify)

    function updateTableIncome() {
        var listOfAllReceipt = []
        var count = 0
        income = 0
        for (var i in adminModel.listReceipt) {
            var p = adminModel.listReceipt[i]
            if (p.dateTime.substring(0, 10) === Qt.formatDate(choosenDate, 'yyyy-MM-dd')) {
                income += parseInt(p.price)
                count++
                listOfAllReceipt.push([count, p.ID, p.content, p.dateTime, p.price])
            }
        }
        tableIncome.dataModel = listOfAllReceipt
    }

    function removeQuantity(itemData, index) {
        // if quantity of clicked item > 0 allow to clear
        if (itemData[2] > 0) {
            // if the food hadn't expired but click to clear quantity Popup notification to confirm
            if (!adminModel.inventory[index].isExpired) {
                confirmClearNoti.visible = true
                okBtn.rowOfItemToClearQuantity = index
            }
            //else clear quantity of tthe food
            else
                if (adminModel.clearQuantityOfItemFromInventory(itemData[1]))
                    tableWarehouse.requestUpdateDataModel(index, 2, 0)
        }
    }

    AdminModel {
        id: adminModel
    }
    Component.onCompleted: {

        updateTableIncome()

        var inventory = []
        var colorForEachRow = []
        for (var i in adminModel.inventory) {
            var p = adminModel.inventory[i]
            inventory.push([i, p.name, p.quantity, p.expDate])
            colorForEachRow.push(parseInt(p.quantity) <= 0 ? Styling._COLOR_GRAY : p.isExpired ? Styling._COLOR_ORANGE : "transparent")
        }
        tableWarehouse.dataModel = inventory
        tableWarehouse.highlightModel = colorForEachRow
//        console.log("aaaaaaaaaaa: " + Date.fromLocaleString(locale, dateTimeString, "dd-MM-yyyy"))
    }

    // notification to confirm if user want to clear quantity of item in iventory
    Loader {
        id: confirmClearNoti
        width: 500
        height: 150
        anchors.centerIn: parent
        visible: false
        z: 100
        Item {
            id: container
            anchors.fill: parent

            Rectangle {
                anchors.fill: parent
                color: Styling._COLOR_ORANGE
                radius: 30
            }
            Text {
                id: info
                text: "Are you sure you want to remove this item?"
                font.pixelSize: Styling._SIZE_F4
                horizontalAlignment: Text.AlignHCenter
                width: parent.width
                wrapMode: Text.WordWrap
            }
            Row {
                anchors.top: info.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 30
                MyButton {
                    id: okBtn
                    property int rowOfItemToClearQuantity: 0
                    textContent: "OK"
                    onBtnClicked: {
                        if (adminModel.clearQuantityOfItemFromInventory(tableWarehouse.dataModel[rowOfItemToClearQuantity][1]))
                            tableWarehouse.requestUpdateDataModel(rowOfItemToClearQuantity, 2, 0)
                        confirmClearNoti.visible = false
                    }
                }
                MyButton {
                    textContent: "Cancel"
                    onBtnClicked: confirmClearNoti.visible = false
                }
            }

        }
    }

    //background
    Rectangle {
        anchors.fill: parent
        color: Styling._BACKGOUND_COLOR
    }
    // headline
    Item {
        width: parent.width
        height: 70
        id: headLine
        Rectangle {
            anchors.fill: parent
            color: Styling._COLOR_RED
        }
        Text {
            text: Styling._ADMIN
            color: Styling._COLOR_WHITE
            anchors.centerIn: parent
            font.pixelSize: Styling._SIZE_F4
        }
        Item {
            id: backBtn
            width: 30
            height: 30
            Text {
                text: "<<"
                font.pixelSize: Styling._SIZE_F3
                anchors.centerIn: parent
            }
            Rectangle {
                anchors.fill: parent
                color: Styling._COLOR_ORANGE
                z: -1
            }

            MouseArea {
                anchors.fill: parent
                onClicked: requestChangePage("admin");
            }
        }
    }
    //main view
    TabBar {
        id: bar
        width: parent.width - calendar.width
        height: 30
        anchors.top: headLine.bottom
        Repeater {
            model: ["Income", "Warehouse"]
            TabButton {
                contentItem: Text {
                    text: modelData
                    font: Styling._DEFAULT_FONT
                    opacity: enabled ? 1.0 : 0.3
                    color: Styling._COLOR_BLACK
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: index === 0 ? Styling._COLOR_LIGHT_RED : Styling._COLOR_YELLOW
                    border.color: Styling._COLOR_BLACK
                    border.width: 3
                }
            }
        }
    }

    SwipeView {
        width: parent.width
        anchors.top: bar.bottom
        currentIndex: bar.currentIndex
        enabled: !controlPanel.active
        Item {
            id: incomeTab
            Item {
                width: parent.width
                height: Styling._DISPLAY_HEIGHT - bar.height - headLine.height
                Rectangle {
                    anchors.fill: parent
                    color: Styling._COLOR_LIGHT_RED
                }
                Table {
                    id: tableIncome
                    width: parent.width - 60
                    height: parent.height - 80
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 15
                    headerModel: [ // widths must add to 1
                        {text: "Order"          ,   width: 0.1},
                        {text: "ID"             ,   width: 0.15},
                        {text: "Food"           ,   width: 0.35},
                        {text: "Datetime"       ,   width: 0.2},
                        {text: "Income"         ,   width: 0.2},
                    ]

                    dataModel: []
                }
                //total income
                Item {
                    anchors.top: tableIncome.bottom
                    anchors.topMargin: 5
                    anchors.right: tableIncome.right
                    width: 500
                    height: 50
                    Rectangle {
                        anchors.fill: parent
                        color: Styling._COLOR_WHITE
                        border.color: Styling._COLOR_BLACK
                        border.width: 1
                    }
                    Text {
                        id: totalIncome
                        anchors.verticalCenter: parent.verticalCenter
                        text: "Total income (day): " + income + "VND"
                        color: Styling._COLOR_RED
                        font.pixelSize: Styling._SIZE_F2
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
            }
        }
        Item {
            id: warehouse
            Item {
                width: parent.width
                height: Styling._DISPLAY_HEIGHT - bar.height - headLine.height
                Rectangle {
                    anchors.fill: parent
                    color: Styling._COLOR_YELLOW
                }
                Table {
                    id: tableWarehouse
                    signal requestUpdateDataModel(var row, var col, var newData)
                    onRequestUpdateDataModel: {
                        dataModel[row][col] = newData
                        highlightModel[row] = parseInt(dataModel[row][2]) <= 0 ? Styling._COLOR_GRAY : adminModel.inventory[row].isExpired ? Styling._COLOR_ORANGE : "transparent"//recalculate highlight model as data had changed
                        dataModelChanged()
                    }
                    width: parent.width - 60
                    height: parent.height - 80
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 15
                    headerModel: [ // widths must add to 1
                        {text: "Order"               ,   width: 0.1},
                        {text: "Food"                ,   width: 0.45},
                        {text: "Quantity"            ,   width: 0.15},
                        {text: "Expire date"         ,   width: 0.3},
                    ]
                    onClicked: {
                        var loader = controlPanel
//                        controlPanel.active = true
                        loader.active = true
//                        loader.itemData = rowData
                        loader.indexOfItem = row 
                    }

                    dataModel: []
                    isUseHighlight: true
                    highlightModel: []
                }
            }
        }
        //popup when click to item in table warehouse
    }

    Loader {
        id: controlPanel
        active: false
        width: 650
        height: 350
        property var itemData: tableWarehouse.dataModel[indexOfItem]
        property int indexOfItem: 0
        anchors.centerIn: parent
        sourceComponent:  Item {
            Component.onCompleted: {
                expiredDatePicker.set(Date.fromLocaleString(locale, itemData[3], "dd-MM-yyyy"))
            }
            //background
            Rectangle {
                anchors.fill: parent
                color: Styling._COLOR_WHITE
                radius: width * 0.01
            }
            Item {
                anchors.fill: parent
                // headline
                //title
                Text {
                    id: controlTitle
                    text: qsTr("Modify item: " + itemData[1])
                    font.pixelSize: Styling._SIZE_F1
                    color: Styling._COLOR_BLACK
                    anchors {
                        top: parent.top
                        horizontalCenter: parent.horizontalCenter
                        topMargin: 5
                    }
                }
                //back button
                Image {
                    id: closeBtn
                    width: 40
                    height: 40
                    source: "qrc:/Images/closeIcon.png"
                    anchors {
                        top: parent.top
                        left: parent.left
                        margins: 5
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            controlPanel.active = false
                        }
                    }
                }
                //content
                //main content
                Item {
                    id: quantityContainer
                    anchors.verticalCenter: parent.verticalCenter
                    width: childrenRect.width
                    Text {
                        id: quantityText
                        anchors {
                            left: parent.left
                            leftMargin: 20
                            verticalCenter: parent.verticalCenter
                        }
                        font{
                            bold: true
                            pixelSize: Styling._SIZE_F2
                        }
                        text: "Quantity: "
                    }

                    SpinBox {
                        id: quantitySpinBox
                        anchors {
                            left: quantityText.right
                            verticalCenter: parent.verticalCenter
                        }

                        value: parseInt(itemData[2])
                    }
                }
                Item {
                    id: expiredDateContainer
                    anchors {
                        left: quantityContainer.right
                        verticalCenter: parent.verticalCenter
                        leftMargin: 20
                    }

                    Text {
                        id: expiredDateText
                        anchors {
                            left: parent.left
                            leftMargin: 20
                            verticalCenter: parent.verticalCenter
                        }
                        font {
                            bold: true
                            pixelSize: Styling._SIZE_F2
                        }
                        text: "Expired date: "
                    }
                    property string expiredDateString: itemData[3]
                    onExpiredDateStringChanged: {
                        expiredDatePicker.set(Date.fromLocaleString(locale, itemData[3], "dd-MM-yyyy"))
                    }

                    DatePicker {
                        id: expiredDatePicker
                        width: 250
                        height: 250
                        anchors {
                            left: expiredDateText.right
                            verticalCenter: parent.verticalCenter
                        }
                    }
                }
                //apply button
                MyButton {
                    id: applyBtn
                    anchors {
                        bottom: parent.bottom
                        left: deleteBtn.right
                        leftMargin: 5
                    }

                    textContent: "Apply"
                    onBtnClicked: {
                        let selectedDate = expiredDatePicker.selectedDate
                        let success = adminModel.updateItemInInventory(itemData[1], quantitySpinBox.value, Qt.formatDate(selectedDate, 'dd-MM-yyyy'))
                        //update UI if update inventory success
                        if (success) {
                            let newData = adminModel.getInventoryByName(itemData[1])
                            tableWarehouse.dataModel[indexOfItem][2] = newData[0]
                            tableWarehouse.dataModel[indexOfItem][3] = newData[1]
                            tableWarehouse.highlightModel[indexOfItem] = parseInt(newData[0]) <= 0 ? Styling._COLOR_GRAY
                                                                                                   : selectedDate < choosenDate ? Styling._COLOR_ORANGE : "transparent"//recalculate highlight model as data had changed
                            tableWarehouse.dataModelChanged()
                        }
                    }
                }

                //delete button
                MyButton {
                    id: deleteBtn
                    anchors {
                        bottom: parent.bottom
                    }
                    active: parseInt(itemData[2]) > 0
                    textContent: "Delete"
                    onBtnClicked: {
                        removeQuantity(itemData, indexOfItem)
                    }
                }
            }
        }
    }

    MyButton {
        id: calendarButton
        anchors.top: headLine.bottom
        anchors.right: parent.right
        anchors.rightMargin: 5
        textContent: "V"
        btnWidth: bar.height
        btnHeight: bar.height
        btnColor: Styling._COLOR_ORANGE
        onBtnClicked: {
            calendarLoader.visible = !calendarLoader.visible
            calendarButton.textContent = calendarButton.textContent === "V" ? ">" : "V"
        }
    }

    Loader {
        id: calendarLoader
        visible: false
        width: 300
        height: 300
        anchors.top: calendarButton.bottom
        anchors.right: calendarButton.right
        anchors.topMargin: 5
        Rectangle {
            anchors.fill: parent
            color: Styling._BACKGOUND_COLOR
        }

        DatePicker {
            id: calendar
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
            onClicked: {
                if (Qt.formatDate(date, 'dd/MM/yyyy') !== Qt.formatDate(choosenDate, 'dd/MM/yyyy'))
                    choosenDate = date
            }
            Component.onCompleted: set(choosenDate)
        }
    }
    onChoosenDateChanged: {
        updateTableIncome()
    }
}
