import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: loginButton
    hoverEnabled: true
    width: 32
    height: 32
    x: passwordField.width

    Text {
    color: "white"
    text: String.fromCodePoint(0xebe7)
    font.family: iconfont.name
    font.pointSize: 12
    renderType: Text.NativeRendering
    anchors.centerIn: parent
    }

    background: Rectangle {
        id: loginbuttonBackground
        color: "#35FFFFFF"
    }

    states: [
       State {
            name: "pressed"
            when: loginButton.down
            PropertyChanges {
                target: loginbuttonBackground
                color: "#75FFFFFF"
            }
        }
    ]
}
