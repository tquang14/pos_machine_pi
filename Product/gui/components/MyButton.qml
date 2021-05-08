import QtQuick 2.9
import QtQuick.Controls 1.0
import "../Styling"

Item {
    id:root
    signal btnClicked(var identify)
    property string textContent: ""
    property string textContentSize: Styling._SIZE_F2
    property string textContentColor: Styling._BACKGOUND_COLOR
    property bool isTextContentBold: false
    property string btnColor: Styling._COLOR_RED
    property bool isRoundedCorners: true
    property int btnWidth: 125
    property int btnHeight: 31
    property int radius: btnWidth * 0.05

    width: btnWidth
    height: btnHeight

    Rectangle {
        anchors.fill: parent
        color: root.btnColor
        radius: root.radius
    }

    Text {
        text: textContent
        anchors.centerIn: parent
        font.pixelSize: root.textContentSize
        font.bold: root.isTextContentBold
        font.family: root.textContent
        color: root.textContentColor
    }
    MouseArea {
        anchors.fill: parent
        onClicked: {
            btnClicked(textContent)
        }
    }
}
