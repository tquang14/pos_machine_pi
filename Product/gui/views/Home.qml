import QtQuick 2.9
import QtQuick.Controls 1.0
import "../Styling"
import "../components"
Item {
    width: Styling._DISPLAY_WIDTH
    height: Styling._DISPLAY_HEIGHT
    signal requestChangePage(var identify)
    //background
    Rectangle {
        anchors.fill: parent
        color: Styling._BACKGOUND_COLOR
    }
    //red Rectangle at the right side
    Rectangle {
        id: sideColor
        color: Styling._COLOR_RED
        anchors.right: parent.right
        width: Styling._RIGHT_CONTENT_WIDTH
        height: parent.height
    }
    //Image represent home page
    // TODO: replace with image when have resources
    Rectangle {
        id: img
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: (sideColor.width - height / 2)
        width: 290
        height: 290
        radius: width*0.5
        color: "blue"
        opacity: 0.5
    }
    // Main content
    Item {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 50
        width: parent.width - img.width
        height: childrenRect.height
        Text {
            id: title
            text: Styling._HOME_TITLE
            color: Styling._COLOR_BLACK
            font.pixelSize: Styling._SIZE_F0
            font.bold: true
            font.family: Styling._DEFAULT_FONT
            lineHeight: 0.6
        }

        Text {
            anchors.top: title.bottom
            anchors.topMargin: 40
            id: subTitle
            text: Styling._HOME_SUB_TITLE
            color: Styling._COLOR_BLACK
            font.pixelSize: Styling._SIZE_F1
            font.family: Styling._DEFAULT_FONT
        }
        Row {
            anchors.top: subTitle.bottom
            anchors.topMargin: 30
            anchors.horizontalCenter: subTitle.horizontalCenter
            spacing: 15
            MyButton {
                textContent: Styling._ADMIN
                onBtnClicked: {
                    requestChangePage(identify)
                }
            }

            MyButton {
                textContent: Styling._ORDER_NOW
                onBtnClicked: {
                    requestChangePage(identify)
                }
            }
        }
    }
}
