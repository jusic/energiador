import QtQuick 2.0
import QtSystemInfo 5.0
import Sailfish.Silica 1.0

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

            Label { id: foo
                x: Theme.paddingLarge
                font.pointSize: 10
                Connections {
                    target: energiadorInstance
                    onResultReady: foo.text = result
                }
            }
        }
    }
}


