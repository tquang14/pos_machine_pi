import QtQuick 2.9
import QtQuick.Controls 1.0

import "../Styling"
import "../components"
import com.OrderModel 1.0

Item {
    width: Styling._DISPLAY_WIDTH
    height: Styling._DISPLAY_HEIGHT
    signal requestChangePage(var identify)
    //func to add thoundsand separator
    function addSeparatorsNF(nStr, outD, sep)
    {
        nStr += ''
        var nStrEnd = ''
        var rgx = /(\d+)(\d{3})/
        while (rgx.test(nStr)) {
            nStr = nStr.replace(rgx, '$1' + sep + '$2')
        }
        return nStr + nStrEnd
    }
    //func to get all order item, number of item
    function getReceipt() {
        var itemList = []
        for (var i = 0; i < billModel.rowCount(); i++) {
            itemList.push([billModel.get(i).name, billModel.get(i).numOfItem])
        }
        return itemList
    }
    function updateDataInMenu() {
        // if first time load this qml file, add new to food model
        if(foodModel.rowCount() <= 0) {
            for (var i in orderModel.listItem) {
                var p = orderModel.listItem[i];
                foodModel.append({name: p.name, imageP: "qrc:/Images/" + p.image, price: p.price, quantity: p.quantity})
            }
            menu.model = foodModel
        }
        // else update quantity of an item in this food model
        else {
            // find this item in the list
            for (var j = 0; i < foodModel.rowCount(); i++) {
                if (foodModel.get(j).quantity !== orderModel.listItem[j].quantity) {
                    foodModel.get(j).quantity = orderModel.listItem[j].quantity
                }
            }
        }
    }

    // notification to inform when the order success
    // TODO: add warning when order is null
    Loader {
        id: notification
        width: 300
        height: 100
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
                id: status
                text: "Order success"
                font.pixelSize: Styling._SIZE_F4
                anchors.centerIn: parent
            }
        }
    }
    // timer to hide notification after 3s display
    Timer {
        id: hideNotiTimer
        interval: 2000
        running: false
        repeat: false
        onTriggered: notification.visible = false
    }

    OrderModel {
        id: orderModel
        onOnListItemChanged: updateDataInMenu()
    }
    //background
    Rectangle {
        anchors.fill: parent
        color: Styling._BACKGOUND_COLOR
    }
    Item {
        id: rightContent
        //red Rectangle at the right side
        anchors.right: parent.right
        width: Styling._RIGHT_CONTENT_WIDTH
        height: parent.height
        Rectangle {
            id: sideColor
            color: Styling._COLOR_RED
            anchors.fill: parent
        }
        //Bill content
        Item {
            //background
            width: parent.width * 0.8
            height: parent.height * 0.85
            anchors.centerIn: parent
            Rectangle {
                anchors.fill: parent
                color: Styling._COLOR_WHITE
                radius: width * 0.07
            }
            //Icon at header
            //TODO: update when have resources
            Rectangle {
                id: img
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.margins: 10
                width: 36
                height: 36
                color: "blue"
                opacity: 0.5
            }
            ListModel {
                id: billModel
            }

            ListView {
                id: orderList
                width: parent.width - 4
                height: parent.height - totalContent.height - img.height - 20
                clip: true
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 2
                anchors.topMargin: 10
                anchors.top: img.bottom
                model: billModel
                focus: false
                delegate: Card {
                    id: listItem
                    textContent: name
                    imgPath: imageP
                    cardWidth: orderList.width
                    cardHeight: 36
                    subTextContent: "x" + numOfItem
                }
            }
            // total money
            Item {
                id: totalContent
                anchors.bottom: parent.bottom
                height: 70
                width: parent.width

                Text {
                    id: headline
                    text: "TẠM TÍNH"
                    font.pixelSize: Styling._SIZE_F1
                    anchors.left: parent.left
                    anchors.margins: 10
//                    anchors.top: parent.top
                }
                Text {
                    id: totalMoney
                    property int total: 0
                    text: addSeparatorsNF(total, ",", " ") + "-VNĐ"
                    color: Styling._COLOR_RED
                    font.pixelSize: Styling._SIZE_F1
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: headline.bottom
                }
                // OK Button
                MyButton {
                    id: applyBtn
                    anchors.top: totalMoney.bottom
                    anchors.topMargin: 6
                    anchors.right: parent.right
                    btnColor: Styling._COLOR_ORANGE
                    textContent: "APPLY"
                    btnWidth: 70
                    onBtnClicked: {
                        if (orderModel.order(getReceipt(), totalMoney.total)) {
                            notification.visible = true
                            hideNotiTimer.start()
                        }
                        billModel.clear()
                        totalMoney.total = 0
                    }
                }
            }
        }
    }
    //left content (menu)
    Item {
        id: leftContent
        width: parent.width - rightContent.width
        height: parent.height

        Item {
            anchors.leftMargin: 40
            anchors.rightMargin: 40
            anchors.fill: parent
            Item {
                id: backBtn
                width: 30
                height: 30
                anchors.topMargin: 10
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
                    onClicked: requestChangePage("order");
                }
            }

            Text {
                id: title
                text: "Thực Đơn"
                color: Styling._COLOR_BLACK
                font.pixelSize: Styling._SIZE_F4
                anchors.left : backBtn.right
                anchors.leftMargin: 20
            }
            //list of food
            ListModel {
                id: foodModel
            }
            Component.onCompleted: {
                updateDataInMenu()
            }

            ListView {
                id: menu
                width: parent.width
                height: parent.height - title.height
                clip: true
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 10
                anchors.topMargin: 10
                anchors.top: title.bottom
                model: foodModel
                focus: false
                delegate: Card {
                    textContent: name
                    textContentSize: Styling._SIZE_F2
                    textQuantity: "[" + quantity + "]"
                    imgPath: imageP
                    cardWidth: menu.width
                    overlayVisible: quantity <= 0? true : false
                    cardHeight: 70
                    cardColor: Styling._COLOR_WHITE
                    subTextContent: addSeparatorsNF(price, ",", " ") + "-VND"
                    subTextContentSize: Styling._SIZE_F2
                    onCardClicked: {
                        // check if quantity > 0 allow to add this item to billModel then decrease quantity by 1
                        if (quantity > 0) {
                            // if this item already order, increase quantity of this item in bill model by 1 else add it to model with quantity = 1
                            var containThisItemInList = false
                            for (var i = 0; i < billModel.rowCount(); i++) {
                                if (billModel.get(i).name === name) {
                                    billModel.get(i).numOfItem += 1
                                    containThisItemInList = true
                                }
                            }
                            if (!containThisItemInList)
                                billModel.append({name: name, imageP: imageP, price: price, numOfItem: 1})

                            totalMoney.total = parseInt(totalMoney.total) + parseInt(price)
                            // convert to int to decrease quantity by 1 then convert it back to string
                            quantity = (parseInt(quantity) - 1) + ""
                        }
                    }
                }
            }
        }
    }
}
