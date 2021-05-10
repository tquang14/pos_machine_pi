import QtQuick 2.9
import QtQuick.Controls 1.0
import "../Styling"

Item {
    id: root
    signal cardClicked(var idx)
    property string textContent: ""
    property string textContentSize: Styling._SIZE_F3
    property string textContentColor: Styling._COLOR_BLACK
    property bool isTextContentBold: false

    property string subTextContent: ""
    property string subTextContentSize: Styling._SIZE_F3
    property string subTextContentColor: Styling._COLOR_ORANGE
    property bool isSubTextContentBold: false

    property string cardColor: Styling._BACKGOUND_COLOR
    property bool isRoundedCorners: true
    property int cardWidth: 465
    property int cardHeight: 70
    property int radius: cardHeight * 0.1
    property string imgPath: Styling._EMPTY_RESOURCE_PATH

    width: cardWidth
    height: cardHeight

    Rectangle {
        anchors.fill: parent
        color: root.cardColor
        radius: root.radius
    }
    Image {
        id: icon
        width: root.height // icon should be square
        height: root.height
        source: root.imgPath === Styling._EMPTY_RESOURCE_PATH ? "qrc:/Images/noImage.png" : root.imgPath
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: root.left
        fillMode: Image.PreserveAspectFit
    }
    //main content
    Text {
        id: mainText
        text: textContent
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 5
        anchors.left: icon.right
        font.pixelSize: root.textContentSize
        font.bold: root.isTextContentBold
        color: root.textContentColor
    }
    // subcontent (eg: price)
    Text {
        id: subText
        text: subTextContent
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 20
        anchors.right: parent.right
        font.pixelSize: root.subTextContentSize
        font.bold: root.isSubTextContentBold
        color: root.subTextContentColor
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            cardClicked(index)
        }
    }
}
