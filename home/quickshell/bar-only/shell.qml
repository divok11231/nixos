import QtQuick
import Quickshell
import Quickshell.Wayland
import "bar"
import "theme"

ShellRoot {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 60
            color: "transparent"
            exclusiveZone: implicitHeight

            Bar {
                anchors.fill: parent
            }
        }
    }
}
