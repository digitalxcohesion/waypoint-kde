import QtQuick

// Waypoint splash (dark). Uses core QtQuick only.
// KSplash sets `stage` from 1 to 6 as the session starts.
Rectangle {
    id: root
    color: "#0F1217"
    property int stage

    onStageChanged: {
        if (stage === 2) {
            introAnimation.running = true
        }
    }

    Item {
        id: content
        anchors.fill: parent
        opacity: 0

        Image {
            id: mark
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -32
            source: "images/waypoint-mark.svg"
            sourceSize.width: 160
            sourceSize.height: 160
        }

        Rectangle {
            id: track
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: mark.bottom
            anchors.topMargin: 40
            width: 264
            height: 2
            color: "#3A434F"

            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                height: parent.height
                color: "#D69A50"
                width: parent.width * Math.min(1, Math.max(0, (root.stage - 1) / 5))
                Behavior on width {
                    NumberAnimation { duration: 450; easing.type: Easing.OutCubic }
                }
            }
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: track.bottom
            anchors.topMargin: 20
            text: "WAYPOINT"
            color: "#9AA6B2"
            font.pixelSize: 12
            font.letterSpacing: 8
        }
    }

    OpacityAnimator {
        id: introAnimation
        target: content
        from: 0
        to: 1
        duration: 600
        easing.type: Easing.InOutQuad
    }
}
