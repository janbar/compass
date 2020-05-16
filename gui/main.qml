/*
 * Copyright (C) 2020
 *      Jean-Luc Barriere <jlbarriere68@gmail.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.2
import QtQuick.Controls.Universal 2.2
import Qt.labs.settings 1.0
import QtGraphicalEffects 1.0
import Compass 1.0

ApplicationWindow {
    id: mainView
    visible: true

    // Design stuff
    width: 360
    height: 640

    Settings {
        id: settings
        // General settings
        property string style: "Material"
        property int theme: 1
        property real scaleFactor: 1.0
        property real fontScaleFactor: 1.0
        property bool firstRun: true
        property int widthGU: Math.round(mainView.width / units.gridUnit)
        property int heightGU: Math.round(mainView.height / units.gridUnit)
        property real magneticDip: 0.0
    }

    Material.accent: Material.Grey
    Universal.accent: "grey"

    Item {
        id: palette
        property color base: {
//            if (settings.style === "Material") {
//                return Material.background
//            } else if (settings.style === "Universal") {
//                return Universal.background
//            } else return "white"
            return "black";
        }
        property color text: {
//            if (settings.style === "Material") {
//                return Material.foreground
//            } else if (settings.style === "Universal") {
//                return Universal.foreground
//            } else return "black"
            return "white"
        }
        property color highlight: "gray"
        property color shadow: "black"
        property color brightText: "dimgray"
        property color button: "darkgray"
        property color link: "green"
        property color toolTipBase: "black"
        property color toolTipText: "white"
    }

    StyleLight {
        id: mainStyle
    }

    Universal.theme: settings.theme
    Material.theme: settings.theme

    Units {
        id: units
        scaleFactor: settings.scaleFactor
        fontScaleFactor: settings.fontScaleFactor
    }

    // Variables
    property int debugLevel: 2          // My debug level
    property bool startup: true         // is running the cold startup ?

    // Property to store the state of the application (active or suspended)
    property bool applicationSuspended: false

    // setting alias to check first run
    property alias firstRun: settings.firstRun

    // property to detect if the UI has finished
    property bool loadedUI: false
    property bool wideAspect: width >= units.gu(100) && loadedUI

    // Constants
    readonly property int queueBatchSize: 100
    readonly property real minSizeGU: 42

    minimumHeight: units.gu(minSizeGU)
    minimumWidth: units.gu(minSizeGU)

    Connections {
        target: Qt.application
        onStateChanged: {
            switch (Qt.application.state) {
            case Qt.ApplicationSuspended:
            case Qt.ApplicationInactive:
                if (!applicationSuspended) {
                    console.log("Application state changed to suspended");
                    applicationSuspended = true;
                }
                break;
            case Qt.ApplicationHidden:
            case Qt.ApplicationActive:
                if (applicationSuspended) {
                    console.log("Application state changed to active");
                    applicationSuspended = false;
                }
                break;
            }
        }
    }


    ////////////////////////////////////////////////////////////////////////////
    ////
    //// Global keyboard shortcuts
    ////

    // Child can connect this signal to handle the event
    signal keyBackPressed

    Timer {
        id: postponeKeyBackPressed
        interval: 100
        onTriggered: keyBackPressed()
    }

    // On android catch the signal 'closing'
    onClosing: {
        if (Android) {
            close.accepted = false;
            if (stackView.depth > 1) {
                if (stackView.currentItem.isRoot)
                    stackView.pop();
                else
                    stackView.currentItem.goUpClicked();
            } else {
                // don't trigger any op synchronously
                postponeKeyBackPressed.start();
            }
        }
    }

    // On desktop catch the key 'ESC'
    Shortcut {
        sequences: ["Esc"]
        onActivated: {
            if (stackView.depth > 1) {
                if (stackView.currentItem.isRoot)
                    stackView.pop();
                else
                    stackView.currentItem.goUpClicked();
            } else {
                 postponeKeyBackPressed.start();
            }
        }
    }


    ////////////////////////////////////////////////////////////////////////////
    ////
    //// Application main view
    ////

    onApplicationSuspendedChanged: {
        //if (!applicationSuspended) {
        //} else {
        //}
    }

    Component.onCompleted: {
        // resize main view according to user settings
        if (!Android) {
            mainView.width = (settings.widthGU >= minSizeGU ? units.gu(settings.widthGU) : units.gu(minSizeGU));
            mainView.height = (settings.heightGU >= minSizeGU ? units.gu(settings.heightGU) : units.gu(minSizeGU));
        }
        settings.theme = 1;
        compass.active = true;
    }

    CompassSensor {
        id: compass
        active: false
        magneticDip: settings.magneticDip
        signal polled(real azimuth, real rotation)
        onAzimuthChanged: {
            if (!poll.running) poll.start();
        }
        Timer {
            id: poll
            interval: 200
            onTriggered: {
                compass.polled(compass.azimuth, (360 - compass.azimuth) * Math.PI / 180.0);
            }
        }
    }

    header: Rectangle {
        Material.foreground: mainStyle.view.foregroundColor
        Material.background: mainStyle.view.backgroundColor
        color: mainStyle.view.backgroundColor
        height: units.gu(8)
        width: parent.width

        RowLayout {
            spacing: 0
            anchors.fill: parent

            Label {
                id: titleLabel
                text: "|"
                font.pointSize: units.fs("x-large")
                //elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }
        }
    }

    property alias pageTitle: titleLabel.text

    StackView {
        id: stackView
        anchors {
            bottom: toolbar.top
            fill: undefined
            left: parent.left
            right: parent.right
            top: parent.top
        }
        initialItem: "qrc:/SensorPage.qml"
    }

    Loader {
        id: toolbar
        active: true
        anchors {
            left: parent.left
            right: parent.right
            top: parent.bottom
            topMargin: visible && status === Loader.Ready ? -height : 0
        }
        asynchronous: true
        source: "qrc:/SensorToolbar.qml"
        visible: status === Loader.Ready &&
                 (stackView.currentItem && (stackView.currentItem.showToolbar || stackView.currentItem.showToolbar === undefined))
    }

}
