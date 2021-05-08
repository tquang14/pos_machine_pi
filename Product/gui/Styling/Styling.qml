/*
 * This file use to define const use for determine some parameter for frontend like: width, height, color, ...
 */
pragma Singleton
import QtQuick 2.9

QtObject {
    //main window size
    readonly property int _DISPLAY_WIDTH: 800
    readonly property int _DISPLAY_HEIGHT: 480
    readonly property int _RIGHT_CONTENT_WIDTH: 240
    //default resource path
    readonly property string _EMPTY_RESOURCE_PATH: ""
    //color
    readonly property color _BACKGOUND_COLOR: "#efefef"
    readonly property color _COLOR_RED: "#bc1823"
    readonly property color _COLOR_LIGHT_RED: "#ed1c24"
    readonly property color _COLOR_BLACK: "#000000"
    readonly property color _COLOR_WHITE: "#ffffff"
    readonly property color _COLOR_ORANGE: "#fab919"
    readonly property color _COLOR_YELLOW: "#fff200"

    //Font
    readonly property string _DEFAULT_FONT: "Comic Sans MS"
    //text size
    readonly property int _SIZE_F0: 54
    readonly property int _SIZE_F1: 24
    readonly property int _SIZE_F2: 20
    readonly property int _SIZE_F3: 16
    readonly property int _SIZE_F4: 40
    //text
    readonly property string _HOME_TITLE: "The\nSunday Bite"
    readonly property string _HOME_SUB_TITLE: "Delicious food for every mood"
    readonly property string _ADMIN: "ADMIN"
    readonly property string _ORDER_NOW: "ORDER NOW"
}


