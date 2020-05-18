/*
 * Copyright (C) 2017
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

QtObject {
    property QtObject view: QtObject {
        property color foregroundColor: palette.text
        property color backgroundColor: palette.base
        property color highlightedColor: palette.highlight
        property color labelColor: palette.text
        property color primaryColor: palette.text
        property color secondaryColor: palette.text
        property color linkColor: palette.link
        property color footerColor: backgroundColor
        property color headerColor: backgroundColor
    }

    property QtObject dialog: QtObject {
        property color backgroundColor: palette.base
        property color foregroundColor: palette.text
        property color labelColor: palette.text
        property color confirmButtonColor: "green"
        property color confirmRemoveButtonColor: "red"
        property color cancelButtonColor: palette.button
    }

    property QtObject popover: QtObject {
        property color backgroundColor: palette.toolTipBase
        property color foregroundColor: palette.toolTipText
        property color labelColor: palette.toolTipText
    }
}
