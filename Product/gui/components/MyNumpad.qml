import QtQuick 2.9

Item {
    id: root
    property int btnWidth: 50
    property int btnHeight: 50
    property var layout: layout
    width: layout.width
    height: layout.height

    signal buttonPressed(var btn)

    Grid {
        id: layout
        columns: 3
        columnSpacing: 3
        rowSpacing: 3

        MyButton { textContent: "7"; btnWidth: root.btnWidth; btnHeight: root.btnHeight; onBtnClicked: buttonPressed("7")}
        MyButton { textContent: "8"; btnWidth: root.btnWidth; btnHeight: root.btnHeight; onBtnClicked: buttonPressed("8")}
        MyButton { textContent: "9"; btnWidth: root.btnWidth; btnHeight: root.btnHeight; onBtnClicked: buttonPressed("9")}
        MyButton { textContent: "4"; btnWidth: root.btnWidth; btnHeight: root.btnHeight; onBtnClicked: buttonPressed("4")}
        MyButton { textContent: "5"; btnWidth: root.btnWidth; btnHeight: root.btnHeight; onBtnClicked: buttonPressed("5")}
        MyButton { textContent: "6"; btnWidth: root.btnWidth; btnHeight: root.btnHeight; onBtnClicked: buttonPressed("6")}
        MyButton { textContent: "1"; btnWidth: root.btnWidth; btnHeight: root.btnHeight; onBtnClicked: buttonPressed("1")}
        MyButton { textContent: "2"; btnWidth: root.btnWidth; btnHeight: root.btnHeight; onBtnClicked: buttonPressed("2")}
        MyButton { textContent: "3"; btnWidth: root.btnWidth; btnHeight: root.btnHeight; onBtnClicked: buttonPressed("3")}
        MyButton { textContent: "0"; btnWidth: root.btnWidth; btnHeight: root.btnHeight; onBtnClicked: buttonPressed("0")}
        MyButton { textContent: "c"; btnWidth: root.btnWidth; btnHeight: root.btnHeight; onBtnClicked: buttonPressed("c")}

    }
}


