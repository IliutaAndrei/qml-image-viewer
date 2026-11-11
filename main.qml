import QtQuick
import QtCore
import QtQuick.Window 2.2
import QtQuick.Controls
import QtQuick.Dialogs
import Qt.labs.folderlistmodel


Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Home Task - Image Viewer")

    Rectangle {
        id: controls
        height: 32
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        border.color: "black"
        border.width: 1

        Row {
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10

            Text {
                id: infoText
                anchors.verticalCenter: parent.verticalCenter
                text: "Select a path:"
                font.pixelSize: 16
                color: "black"
            }

            Button {
                id: browseButton
                anchors.verticalCenter: parent.verticalCenter
                onClicked: folderDialog.open()
                text: "Browse.."
                palette.buttonText: "black"
            }

            ComboBox {
                id: viewMode
                anchors.verticalCenter: parent.verticalCenter
                model: ["List", "Grid", "Path"]
                palette.buttonText: "black"
            }
        }
    }

    ListView  {
        id: imageList
        anchors.top: controls.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        model: imageModel
        visible: viewMode.currentIndex === 0
        spacing: 10

        delegate: Image {
            required property url fileUrl

            width: imageList.width
            height: 100
            source: fileUrl
            fillMode: Image.PreserveAspectFit

            TapHandler {
                onTapped: {
                    enlargedImage.source = fileUrl
                    imagePreview.open()
                }
            }
        }
    }

    GridView {
        id: imageGrid

        anchors.fill: imageList
        visible: viewMode.currentIndex === 1
        clip: true
        model: imageModel

        cellWidth: Math.floor(width / 3)
        cellHeight: 120

        delegate: Image {
            required property url fileUrl

            width: imageGrid.cellWidth - 8
            height: imageGrid.cellHeight - 8
            source: fileUrl
            fillMode: Image.PreserveAspectFit

            TapHandler {
                onTapped: {
                    enlargedImage.source = fileUrl
                    imagePreview.open()
                }
            }
        }
    }
    PathView {
        id: imagePath

        anchors.fill: imageList
        visible: viewMode.currentIndex === 2
        clip: true
        model: imageModel
        pathItemCount: 3

        delegate: Image {
            required property url fileUrl

            width: 120
            height: 100
            source: fileUrl
            fillMode: Image.PreserveAspectFit

            TapHandler {
                onTapped: {
                    enlargedImage.source = fileUrl
                    imagePreview.open()
                }
            }
        }

        path: Path {
            startX: 70
            startY: imagePath.height / 2

            PathLine {
                x: imagePath.width - 70
                y: imagePath.height / 2
            }
        }
    }

    FolderDialog {
        id: folderDialog
        currentFolder: StandardPaths.standardLocations(StandardPaths.PicturesLocation)[0]
        onAccepted: imageModel.folder = selectedFolder
    }

    FolderListModel {
        id: imageModel
        showDirs: false
        nameFilters: ["*.jpg", "*.jpeg", "*.png"]
        onCountChanged: console.log("Images found:", count)
    }

    Dialog {
        id: imagePreview

        parent: Overlay.overlay
        anchors.centerIn: parent
        width: parent.width * 0.9
        height: parent.height * 0.9

        title: "Image Maximized"
        modal: true
        standardButtons: Dialog.Close

        contentItem: Image {
            id: enlargedImage
            fillMode: Image.PreserveAspectFit
        }
    }
}
