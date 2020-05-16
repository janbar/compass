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
import QtQuick.Controls 2.2
//import QtPositioning 5.8

Item {
    id: toolBar
    property alias color: bg.color
    height: units.gu(4.0)
    objectName: "toolbarObject"

    property alias coordinate: coordinate

    Rectangle {
        id: bg
        anchors.fill: parent
        color: mainStyle.view.backgroundColor
        opacity: 1.0

        Rectangle {
            color: "grey"
            anchors.top: parent.top
            width: parent.width
            height: units.dp(1)
            opacity: 0.1
        }
    }

    Item {
        id: toolbarContent
        anchors {
            fill: parent
        }

        Row {
            id: coordinate
            anchors.centerIn: parent
            spacing: units.gu(1)
            property string datetime: ""
            property alias timeString: time.text
//            property alias latitude: latitude.text
//            property alias longitude: longitude.text
//            property alias altitude: altitude.text

            Text {
                id: time
                color: mainStyle.view.primaryColor
                elide: Text.ElideRight
                font.family: "Fixed"
                font.pointSize: units.fs("medium")
                font.weight: Font.DemiBold
                text: "00:00:00"
            }
//            Label {
//                color: mainStyle.view.primaryColor
//                elide: Text.ElideRight
//                font.pointSize: units.fs("medium")
//                font.weight: Font.Normal
//                text: "Pos:"
//            }
//            Text {
//                id: latitude
//                color: mainStyle.view.primaryColor
//                elide: Text.ElideRight
//                font.family: "Fixed"
//                font.pointSize: units.fs("medium")
//                font.weight: Font.DemiBold
//                text: "0.0000"
//            }
//            Text {
//                id: longitude
//                color: mainStyle.view.primaryColor
//                elide: Text.ElideRight
//                font.family: "Fixed"
//                font.pointSize: units.fs("medium")
//                font.weight: Font.DemiBold
//                text: "0.0000"
//            }
//            Label {
//                color: mainStyle.view.primaryColor
//                elide: Text.ElideRight
//                font.pointSize: units.fs("medium")
//                font.weight: Font.Normal
//                text: "Alt:"
//            }
//            Text {
//                id: altitude
//                color: mainStyle.view.primaryColor
//                elide: Text.ElideRight
//                font.family: "Fixed"
//                font.pointSize: units.fs("medium")
//                font.weight: Font.DemiBold
//                text: "0"
//            }
        }

        Timer {
            interval: 1000
            repeat: true
            onTriggered: {
                var date = new Date();
                coordinate.datetime = date.toISOString();
                coordinate.timeString = date.toLocaleTimeString();
            }
            Component.onCompleted: start()
        }

//        PositionSource {
//            id: src
//            updateInterval: 1000
//            active: true

//            onPositionChanged: {
//                var coord = src.position.coordinate;
//                coordinate.longitude = coord.longitude.toPrecision(5);
//                coordinate.latitude = coord.latitude.toPrecision(5);
//                coordinate.altitude = coord.altitude.toFixed(0);
//            }
//        }

    }
}
