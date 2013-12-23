import QtQuick 2.0
import Sailfish.Silica 1.0
import QtSystemInfo 5.0

CoverBackground {
/*
    BatteryInfo {
        onCurrentFlowChanged: {
            // battery parameter skipped
            currentflow.text = "Cur. flow: " + flow + " mA"
        }

        Component.onCompleted: {
            var battery = 0
            onCurrentFlowChanged(battery, currentFlow(battery))
        }
    }*/

    Label {
        id: label
        anchors.centerIn: parent
        text: "Energiador"
    }

    Label {
        id: currentflow
        text: ""
        Connections {
            target: energiadorInstance
            onResultReady: currentflow.text = result
        }
    }
}


