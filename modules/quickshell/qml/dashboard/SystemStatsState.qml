pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io
import "../theme"

Singleton {
    id: root

    property real cpuUsage: 0
    property real ramUsage: 0
    property real cpuTemp: 0

    Process {
        id: statsProc
        running: SessionState.dashboardVisible
        command: [
            "bash",
            "-c",
            "script=\"$HOME/.config/quickshell/scripts/stats-daemon.sh\"; if [ -x \"$script\" ]; then exec \"$script\"; else echo '0 0 0'; sleep 2; fi"
        ]
        stdout: SplitParser {
            onRead: (line) => {
                let parts = line.trim().split(" ")
                if (parts.length >= 3) {
                    root.cpuUsage = Math.min(100, Math.max(0, parseInt(parts[0]) || 0))
                    root.ramUsage = Math.min(100, Math.max(0, parseInt(parts[1]) || 0))

                    let rawTemp = parseInt(parts[2]) || 0
                    let smoothVal = (rawTemp * 0.3) + (root.cpuTemp * 0.7)
                    root.cpuTemp = Math.min(110, Math.max(0, smoothVal))
                }
            }
        }
    }
}
