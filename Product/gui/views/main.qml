import QtQuick 2.9
import QtQuick.Controls 1.0
import "../Styling"
ApplicationWindow {
    id: window
    width: Styling._DISPLAY_WIDTH
    height: Styling._DISPLAY_HEIGHT
    visible: true
    visibility: (SCREEN_WIDTH <= 800 && SCREEN_HEIGHT <= 480)? "FullScreen" : "Windowed"
    Component.onCompleted: console.log(SCREEN_WIDTH + " " + SCREEN_HEIGHT )
    title: qsTr("Nhà hàng KMT")

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: homePage
        Home {
            id: homePage
            onRequestChangePage: {
                if (identify === Styling._ADMIN)
                    stackView.push(adminPage)
                else if (identify === Styling._ORDER_NOW)
                    stackView.push(orderPage)
            }
        }
    }
    Component  {
        Admin {
            onRequestChangePage: stackView.pop()
        }

        id: adminPage
    }
    Component  {
        Order {
            onRequestChangePage: stackView.pop()
        }

        id: orderPage
    }
}
