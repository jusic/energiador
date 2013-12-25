import QtQuick 2.0
import QtSystemInfo 5.0
import Sailfish.Silica 1.0
import "../components"

Page {
    id: page

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height

        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: "Energiador"
            }
            Label {
                x: Theme.paddingLarge
                text: "Current status"
            }

            Label { id: status
                x: Theme.paddingLarge
                font.pointSize: 10
                Connections {
                    target: energiadorInstance
                    onResultReady: status.text = result
                }
            }

            LinePlot {
                id: plot
                width: parent.width - 2*Theme.paddingLarge
                height: 400
                //anchors.top: status.bottom
                //anchors.bottom: parent.bottom
                x: Theme.paddingLarge

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
    }
}


