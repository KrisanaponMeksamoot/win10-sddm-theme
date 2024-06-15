import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 2.15
import "Components"

Item {
    id: root
    width: Screen.width
    height: Screen.height

    Rectangle {
        id: background
        anchors.fill: parent
        width: parent.width
        height: parent.height

        Image {
            anchors.fill: parent
            width: parent.width
            height: parent.height
            source: config.Background

            Rectangle {
                width: parent.width
                height: parent.height
                color: "#75000000"
            }
        }
    }

    Rectangle {
        id: startupBg
        width: Screen.width
        height: Screen.height
        color: "transparent"
        z: 4

        Image {
            anchors.fill: parent
            width: Screen.width
            height: Screen.height
            smooth: true
            source: config.Background

            Rectangle {
                id: backRect
                width: Screen.width
                height: Screen.height
                color: "#15000000"
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            focus: true

            onClicked: {
                listView.focus = true
                mouseArea.focus = false
                mouseArea.enabled = false
                seqStart.start()
                parStart.start()
            }

            Keys.onPressed: {
                listView.focus = true
                mouseArea.focus = false
                mouseArea.enabled = false
                seqStart.start()
                parStart.start()
            }
        }

        ParallelAnimation {
            id: parStart
            running: false

            NumberAnimation {
                target: timeDate
                properties: "y"
                from: 0
                to: -45
                duration: 125
            }

            NumberAnimation {
                target: timeDate
                properties: "visible"
                from: 1
                to: 0
                duration: 125
            }

            NumberAnimation {
                target: startupBg
                properties: "opacity"
                from: 1
                to: 0
                duration: 100
            }
        }

        SequentialAnimation {
            id: seqStart
            running: false

            ColorAnimation {
                target: backRect
                properties: "color"
                from: "#15000000"
                to: "#75000000"
                duration: 125
            }

            ParallelAnimation {

                ScaleAnimator {
                    target: background
                    from: 1
                    to: 1.01
                    duration: 250
                }

                NumberAnimation {
                    target: centerPanel
                    properties: "opacity"
                    from: 0
                    to: 1
                    duration: 225
                }

                NumberAnimation {
                    target: rightPanel
                    properties: "opacity"
                    from: 0
                    to: 1
                    duration: 100
                }

                NumberAnimation {
                    target: leftPanel
                    properties: "opacity"
                    from: 0
                    to: 1
                    duration: 100
                }
            }
        }

        Rectangle {
            id: timeDate
            width: parent.width
            height: parent.height
            color: "transparent"

            FontLoader {
                id: segoeuil
                source: Qt.resolvedUrl("fonts/segoeuil.ttf")
            }

            Column {
                id: timeContainer

                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    bottomMargin: 75
                    leftMargin: 30
                }

                property date dateTime: new Date()

                Timer {
                    interval: 100; running: true; repeat: true;
                    onTriggered: timeContainer.dateTime = new Date()
                }

                Text {
                    id: time

                    color: "white"
                    font.pointSize: 80
                    font.family: segoeuil.name
                    font.weight: Font.Thin
                    renderType: Text.NativeRendering
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        left: parent.left
                    }

                    text: Qt.formatTime(timeContainer.dateTime, "hh:mm")
                }

                Text {
                    id: date

                    color: "white"
                    font.pointSize: 45
                    font.family: segoeuil.name
                    font.weight: Font.Thin
                    renderType: Text.NativeRendering
                    horizontalAlignment: Text.AlignLeft

                    anchors {
                        horizontalCenter: parent.horizontalCenter
                    }

                    text: Qt.formatDate(timeContainer.dateTime, "dddd, MMMM dd")
                }
            }
        }
    }          

    Item {
        id: rightPanel
        z: 2
        opacity: 0

        anchors {
            bottom: parent.bottom
            right: parent.right
            margins: 85
        }

        PowerPanel {
            id: powerPanel
        }

        SessionPanel {
            id: sessionPanel
            anchors {
                right: powerPanel.left
            }
        }

        LayoutPanel {
            id: layoutPanel
            anchors {
                right: sessionPanel.left
            }
        }
    }

    Rectangle {
        id: leftPanel
        color: "transparent"
        anchors.fill: parent
        z: 2
        opacity: 0

        visible: listView2.count > 1 ? true : false
        enabled: listView2.count > 1 ? true : false

        Component {
            id: userDelegate2

            UserList {
                id: userList
                name: (model.realName === "") ? model.name : model.realName
                icon: model.icon

                anchors {
                    horizontalCenter: parent.horizontalCenter
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        listView2.currentIndex = index
                        listView2.focus = true
                        listView.currentIndex = index
                        listView.focus = true
                    }
                }
            }
        }

        Rectangle {
            width: 150
            height: 58 * listView2.count
            color: "transparent"
            clip: true

            anchors {
                bottom: parent.bottom
                bottomMargin: 35
                left: parent.left
                leftMargin: 35
            }

            Item {
                id: usersContainer2
                width: 255
                height: parent.height

                anchors {
                    bottom: parent.bottom
                    left: parent.left
                }

                Button {
                    id: prevUser2
                    visible: true
                    enabled: false
                    width: 0

                    anchors {
                        bottom: parent.bottom
                        left: parent.left
                    }
                }

                ListView {
                    id: listView2
                    height: parent.height
                    focus: true
                    model: userModel
                    currentIndex: userModel.lastIndex
                    delegate: userDelegate2
                    verticalLayoutDirection: ListView.BottomToTop
                    orientation: ListView.Vertical

                    anchors {
                        left: prevUser2.right
                        right: nextUser2.left
                    }
                }

                Button {
                    id: nextUser2
                    visible: true
                    width: 0
                    enabled: false

                    anchors {
                        bottom: parent.bottom
                        right: parent.right
                    }
                }
            }
        }
    }

    Item {
        id: centerPanel
        anchors.centerIn: root
        z: 2
        opacity: 0

        Item {

            Component {
                id: userDelegate

                UserPanel {
                    anchors.centerIn: parent
                    name: (model.realName === "") ? model.name : model.realName
                    icon: model.icon
                }
            }

            Button {
                id: prevUser
                anchors.left: parent.left
                visible: false
            }

            ListView {
                id: listView
                focus: true
                model: userModel
                delegate: userDelegate
                currentIndex: userModel.lastIndex

                anchors {
                    left: prevUser.right
                    right: nextUser.left
                }
            }

            Button {
                id: nextUser
                anchors.right: parent.right
                visible: false
            }
        }
    }
}