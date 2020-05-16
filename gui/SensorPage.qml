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

Page {
    id: compassPage
    footer: Item { height: 0; width: parent.width }

    background: Rectangle {
        color: mainStyle.view.backgroundColor
    }

    Column {
        spacing: units.gu(2)
        anchors {
            margins: units.gu(2)
            fill: parent
        }

        Item {
            id: sensorCompass
            width: parent.width
            height: compassItem.height

            Rectangle {
                id: compassItem
                color: "transparent"
                width: parent.width
                height: width
                x: (parent.width - width) / 2
                radius: width / 2

                Image {
                    id: compassForeground
                    source: settings.theme === 0 ? "qrc:/images/compass-360-l.svg" : "qrc:/images/compass-360-d.svg"
                    anchors.fill: parent
                    rotation: 0.0

                    Behavior on rotation {
                        RotationAnimation { duration: 500; direction: RotationAnimation.Shortest; }
                    }
                }

                Rectangle {
                    anchors.centerIn: compassForeground
                    height: units.dp(2)
                    width: units.gu(14)
                    color: mainStyle.view.foregroundColor
                    opacity: 0.5
                }
                Rectangle {
                    anchors.centerIn: compassForeground
                    width: units.dp(2)
                    height: units.gu(14)
                    color: mainStyle.view.foregroundColor
                    opacity: 0.5
                }
                Rectangle {
                    anchors.top: compassForeground.top
                    anchors.horizontalCenter: compassForeground.horizontalCenter
                    anchors.topMargin: -units.gu(1.0)
                    width: units.dp(5)
                    height: units.gu(6)
                    color: mainStyle.view.foregroundColor
                    opacity: 0.5
                }

                Connections {
                    target: compass
                    onPolled: {
                        compassForeground.rotation = rotation * 180.0 / Math.PI;
                        mainView.pageTitle = Math.round(azimuth).toString() + "°";
                    }
                }
            }
        }

        Text {
            id: statusLine
            color: mainStyle.view.foregroundColor
            font.pointSize: units.fs("small")
            text: "Cal " + Math.round(compass.calibration * 100.0) + "%"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            height: units.gu(4)
            width: parent.width
        }

    }
}
