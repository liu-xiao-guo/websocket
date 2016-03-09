import QtQuick 2.0
import Ubuntu.Components 1.1
import QtQuick.Layouts 1.1
import Qt.WebSockets 1.0

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "websocket.liu-xiao-guo"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true

    // Removes the old toolbar and enables new features of the new header.
    useDeprecatedToolbar: false

    width: units.gu(60)
    height: units.gu(85)

    function appendMessage(msg) {
        var length = output.length;
        output.insert(length, msg + "\r\n");
    }

    Page {
        id: page
        title: i18n.tr("websocket")

        WebSocket {
            id: socket
            url: input.text
            onTextMessageReceived: {
                console.log("something is received!");
                appendMessage("received: " + message);
            }

            onStatusChanged: if (socket.status == WebSocket.Error) {
                                 console.log("Error: " + socket.errorString)
                             } else if (socket.status == WebSocket.Open) {
                                 appendMessage("sending \"Hello world\"");
                                 socket.sendTextMessage("Hello World")
                             } else if (socket.status == WebSocket.Closed) {
                                 appendMessage("Socket closed");
                             }
            active: true
        }

        Column {
            anchors.fill: parent
            spacing: units.gu(1)

            RowLayout {
                id: top
                width: parent.width

                TextField {
                    id: input
                     Layout.minimumWidth: page.width *.7
                    text: "ws://echo.websocket.org"
                }

                Button {
                    id: get
                    text: "Get"
                    onClicked: {
                        socket.active = true
                        var message = "Nice to meet you!";
                        socket.sendTextMessage(message)
                        appendMessage("sending " + message);
                    }
                }
            }

            TextArea {
                id: output
                width: parent.width
                height: page.height - top.height - units.gu(1)
            }
        }
    }
}

