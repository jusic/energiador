import QtQuick 2.0
import Sailfish.Silica 1.0

Rectangle {
    id: chart
    width: 400
    height: 300
    color: "transparent"

    property var dataListModel: null  // QVariantList containing QVariantMaps {"date": xyz, "power": 123.4}
    property string column: "power"

    function update() {
        var last = dataListModel.length - 1;
        var first = 0;
        xStart.text = Qt.formatDateTime(dataListModel[last]["date"], "hh:mm:ss")
        xEnd.text = Qt.formatDateTime(dataListModel[0]["date"], "hh:mm:ss")

        var max = 1;
        var min = 0;

        for (var i = first; i <= last; i++) {
            var l = dataListModel[i]

            if (l[column] > max)
                max = l[column];
            if (l[column] < min)
                min = l[column];
        }

        valueMax.text = max.toFixed(2) + " W"
        valueMin.text = min.toFixed(2) + " W"
        valueMiddle.text = ((max+min) / 2.).toFixed(2) + " W"
        canvas.requestPaint();
    }

    Text {
        id: xStart
        color: Theme.primaryColor
        font.pointSize: 10
        wrapMode: Text.WordWrap
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.top: parent.top
        text: ""
    }

    Text {
        id: xEnd
        color: Theme.primaryColor
        font.pointSize: 10
        wrapMode: Text.WordWrap
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        horizontalAlignment: Text.AlignRight
        text: ""
    }

    Text {
        id: valueMax
        color: Theme.primaryColor
        width: 50
        font.pointSize: 10
        wrapMode: Text.WordWrap
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: xEnd.bottom
        text: "1.00 W"
    }

    Text {
        id: valueMin
        color: Theme.primaryColor
        width: 50
        font.pointSize: 10
        wrapMode: Text.WordWrap
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        text: "0.00 W"
    }

    Text {
        id: valueMiddle
        color: Theme.primaryColor
        width: 50
        font.pointSize: 10
        wrapMode: Text.WordWrap
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.verticalCenter: canvas.verticalCenter
        text: "0.50 W"
        z: 10
    }


    Canvas {
        id: canvas
        width: parent.width
        anchors.top: valueMax.bottom
        anchors.bottom: valueMin.top
        renderTarget: Canvas.FramebufferObject
        antialiasing: true

        property int first: 0
        property int last: 0

        function drawBackground(ctx) {
            ctx.save();

            // clear previous plot
            ctx.clearRect(0,0,canvas.width, canvas.height);

            // fill translucent background
            ctx.fillStyle = Qt.rgba(0,0,0,0.5);
            ctx.fillRect(0, 0, canvas.width, canvas.height);

            // draw grid lines
            ctx.strokeStyle = Qt.rgba(1,1,1,0.3);
            ctx.beginPath();

            var cols = 6.0;
            var rows = 5.0;

            for (var i = 0; i < rows; i++) {
                ctx.moveTo(0, i * (canvas.height/rows));
                ctx.lineTo(canvas.width, i * (canvas.height/rows));
            }
            for (i = 0; i < cols; i++) {
                ctx.moveTo(i * (canvas.width/cols), 0);
                ctx.lineTo(i * (canvas.width/cols), canvas.height);
            }
            ctx.stroke();

            ctx.restore();
        }

        function drawPlot(ctx, data, color, column, ymin, ymax)
        {
            ctx.save();
            ctx.globalAlpha = 1.0;
            ctx.strokeStyle = color;
            ctx.lineWidth = 1;
            ctx.beginPath();

            var xstart = data[0]["date"].getTime() // convert to epoch time
            var xend = data[data.length-1]["date"].getTime()

            for (var i = 0; i < data.length; i++) {
                var x = (data[i]["date"].getTime() - xstart)/(xend-xstart);
                var y = (data[i][column]-ymin)/(ymax-ymin);

                if (i == 0) {
                    ctx.moveTo(x * canvas.width, (1-y) * canvas.height);
                } else {
                    ctx.lineTo(x * canvas.width, (1-y) * canvas.height);
                }
            }
            ctx.stroke();
            ctx.restore();
        }

        onCanvasSizeChanged: requestPaint();

        onPaint: {
            var ctx = canvas.getContext("2d");

            ctx.globalCompositeOperation = "source-over";
            ctx.lineWidth = 1;

            drawBackground(ctx);

            if (!dataListModel) {
                console.log("not ready")
                return;
            }

            first = 0;
            last = dataListModel.length - 1;
            var max = 1;
            var min = 0;

            for (var i = first; i <= last; i++) {
                var l = dataListModel[i]

                if (l[column] > max)
                    max = l[column];
                if (l[column] < min)
                    min = l[column];
            }

            drawPlot(ctx, dataListModel, Qt.rgba(0.8, 0.0, 0.0, 1), column, min, max);
        }
    }
}
