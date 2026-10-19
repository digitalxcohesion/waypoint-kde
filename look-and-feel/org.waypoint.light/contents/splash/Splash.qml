import QtQuick

// Waypoint splash (light). Uses core QtQuick only.
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
            id: art
            anchors.fill: parent
            source: "images/background.jpg"
            fillMode: Image.PreserveAspectCrop
            smooth: true
            asynchronous: false
        }

        // the Waypoint wordmark (logo + "WAYPOINT / LINUX DESKTOP THEME"), sized to the screen
        Image {
            id: wordmark
            source: "images/wordmark.png"
            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: true
            height: Math.round(parent.height * 0.34)
            width: height * sourceSize.width / Math.max(1, sourceSize.height)
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -Math.round(parent.height * 0.03)
        }

        // progress line under the wordmark
        Rectangle {
            id: track
            width: Math.round(wordmark.width * 0.42)
            height: 2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: wordmark.bottom
            anchors.topMargin: Math.round(parent.height * 0.04)
            color: Qt.rgba(1, 1, 1, 0.22)          // light track: visible on any part of the picture

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
