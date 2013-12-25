import QtQuick 2.0
import Sailfish.Silica 1.0
import QtSystemInfo 5.0
import "../components"

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
/*
    Label {
        id: label
        anchors.centerIn: parent
        text: "Energiador"
    }
*/
    Label {
        id: currentflow
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: Theme.paddingLarge
        verticalAlignment: Text.AlignTop
        text: ""
        Connections {
            target: energiadorInstance
            onResultReady: currentflow.text = result
        }
    }

    LinePlot {
        id: plot
        width: parent.width - 2*Theme.paddingMedium
        height: parent.height / 2.
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom

        /*Component.onCompleted: {

        }*/

        Connections {
            target: energiadorInstance
            onUpdateList: {
                plot.dataListModel = list
                plot.update()
            }
        }
    }
}


