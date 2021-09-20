// Copyright (c) 2021 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.10
import QtQuick.Controls 2.3

import UM 1.4 as UM
import Cura 1.1 as Cura

Button
{
    id: base

    property alias iconSource: applicationIcon.source
    property alias displayName: applicationDisplayName.text
    property alias tooltipText: tooltip.text
    property bool isExternalLink: false

    width: UM.Theme.getSize("application_switcher_item").width
    height: UM.Theme.getSize("application_switcher_item").height

    background: Rectangle
    {
        color: parent.hovered ? UM.Theme.getColor("action_button_hovered") : UM.Theme.getColor("action_button")
        border.color: parent.hovered ? UM.Theme.getColor("primary") : "transparent"
        border.width: UM.Theme.getSize("default_lining").width
    }

    UM.TooltipArea
    {
        id: tooltip
        anchors.fill: parent
    }

    Column
    {
        id: applicationButtonContent
        anchors.centerIn: parent
        spacing: UM.Theme.getSize("default_margin").width

        UM.RecolorImage
        {
            id: applicationIcon
            anchors.horizontalCenter: parent.horizontalCenter

            color: UM.Theme.getColor("monitor_icon_primary")
            width: UM.Theme.getSize("application_switcher_icon").width
            height: width

            Item
            {
                id: externalLinkIndicator

                visible: base.isExternalLink

                anchors
                {
                    bottom: parent.bottom
                    bottomMargin: - Math.round(height * 1 / 6)
                    right: parent.right
                    rightMargin: - Math.round(width * 5 / 6)
                }

                Rectangle
                {
                    id: externalLinkIndicatorBackground
                    anchors.centerIn: parent
                    width: UM.Theme.getSize("small_button_icon").width
                    height: width
                    color: base.hovered ? UM.Theme.getColor("action_button_hovered") : UM.Theme.getColor("action_button")
                    radius: 0.5 * width
                }

                UM.RecolorImage
                {
                    id: externalLinkIndicatorIcon
                    anchors.centerIn: parent

                    width: UM.Theme.getSize("printer_status_icon").width
                    height: width
                    color: UM.Theme.getColor("monitor_icon_primary")
                    source: UM.Theme.getIcon("LinkExternal")
                }
            }
        }

        Label
        {
            id: applicationDisplayName

            anchors.horizontalCenter: parent.horizontalCenter

            width: base.width - UM.Theme.getSize("default_margin").width
            horizontalAlignment: Text.AlignHCenter
            maximumLineCount: 2
            wrapMode: Text.Wrap
            elide: Text.ElideRight
        }
    }
}