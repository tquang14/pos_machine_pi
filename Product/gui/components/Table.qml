import QtQuick 2.0
import QtQuick.Controls 2.2
Item { // size controlled by width
    id: root
    property color bgColor: "#ffffff"
    property bool isUseHighlight: false
    Rectangle {
        anchors.fill: parent
        color: bgColor
    }

// public
    //data for header
    property variant headerModel: [ // widths must add to 1
        // {text: 'Color',         width: 0.5},
        // {text: 'Hexadecimal',   width: 0.5},
    ]
    //data to draw table
    property variant dataModel: [
        // ['red',   '#ff0000'],
        // ['green', '#00ff00'],
        // ['blue',  '#0000ff'],
    ]
    // data to specify color for each row
    property variant highlightModel: []

    signal clicked(int row, variant rowData);  //onClicked: print('onClicked', row, JSON.stringify(rowData))

// private
    width: 500;  height: 200

    Rectangle {
        id: header

        width: parent.width;  height: 0.08 * root.width
        color: bgColor
//        radius: 0.03 * root.width

        Rectangle { // half height to cover bottom rounded corners
            width: parent.width;  height: 0.5 * parent.height
            color: parent.color
            anchors.bottom: parent.bottom
        }

        ListView { // header
            anchors.fill: parent
            orientation: ListView.Horizontal
            interactive: false

            model: headerModel

            delegate: Item { // cell
                width: modelData.width * root.width;  height: header.height
                Rectangle {
                    anchors.fill: parent
                    border.width: 1
                    border.color: "black"
                }
                Text {
//                    x: 0.03 * root.width
                    text: modelData.text
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 0.03 * root.width
                    color: "black"
                }
            }
        }
    }

    ListView { // data
        anchors{fill: parent;  topMargin: header.height}
        interactive: contentHeight > height
        clip: true

        model: dataModel

        delegate: Item { // row
            width: root.width;  height: header.height
            opacity: !mouseArea.pressed? 1: 0.3 // pressed state

            property int     row:     index     // outer index
            property variant rowData: modelData // much faster than listView.model[row]
            Row {
                anchors.fill: parent
                Repeater { // index is column
                    model: rowData // headerModel.length

                    delegate: Item { // cell
                        width: headerModel[index].width * root.width
                        height: header.height

                        Rectangle {
                            anchors.fill: parent
                            border.width: 1
                            border.color: "black"
                        }
                        Text {
                            width: parent.width
                            height: parent.height
                            text: modelData
                            anchors.verticalCenter: parent.verticalCenter
                            font.pixelSize: 0.03 * root.width
                            wrapMode: Text.WordWrap
                            clip: true
                            maximumLineCount: 2
                        }
                    }
                }
            }

            Loader {
                anchors.fill: parent
                active: isUseHighlight
                sourceComponent: Rectangle {
                    anchors.fill: parent
                    color: isUseHighlight? highlightModel[index] : "transparent"
                    opacity: 0.3
                }
            }

            MouseArea {
                id: mouseArea

                anchors.fill: parent

                onClicked:  root.clicked(row, rowData)
            }
        }
    }
}
