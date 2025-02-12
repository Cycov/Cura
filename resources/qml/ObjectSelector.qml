// Copyright (c) 2022 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.10
import QtQuick.Controls 2.3

import UM 1.5 as UM
import Cura 1.0 as Cura

Item
{
    id: objectSelector
    width: UM.Theme.getSize("objects_menu_size").width
    property bool opened: UM.Preferences.getValue("cura/show_list_of_objects")

    // Eat up all the mouse events (we don't want the scene to react or have the scene context menu showing up)
    MouseArea
    {
        anchors.fill: parent
        acceptedButtons: Qt.AllButtons
    }

    Button
    {
        id: openCloseButton
        width: parent.width
        height: contentItem.height + bottomPadding
        hoverEnabled: true
        padding: 0
        bottomPadding: UM.Theme.getSize("narrow_margin").height / 2 | 0

        anchors
        {
            bottom: contents.top
            horizontalCenter: parent.horizontalCenter
        }

        contentItem: Item
        {
            width: parent.width
            height: label.height

            UM.RecolorImage
            {
                id: openCloseIcon
                width: UM.Theme.getSize("standard_arrow").width
                height: UM.Theme.getSize("standard_arrow").height
                sourceSize.width: width
                anchors.left: parent.left
                color: openCloseButton.hovered ? UM.Theme.getColor("small_button_text_hover") : UM.Theme.getColor("small_button_text")
                source: objectSelector.opened ? UM.Theme.getIcon("ChevronSingleDown") : UM.Theme.getIcon("ChevronSingleUp")
            }

            UM.Label
            {
                id: label
                anchors.left: openCloseIcon.right
                anchors.leftMargin: UM.Theme.getSize("default_margin").width
                text: catalog.i18nc("@label", "Object list")
                color: openCloseButton.hovered ? UM.Theme.getColor("small_button_text_hover") : UM.Theme.getColor("small_button_text")
                elide: Text.ElideRight
            }
        }

        background: Item {}

        onClicked:
        {
            UM.Preferences.setValue("cura/show_list_of_objects", !objectSelector.opened)
            objectSelector.opened = UM.Preferences.getValue("cura/show_list_of_objects")
        }
    }

    Rectangle
    {
        id: contents
        width: parent.width
        visible: objectSelector.opened
        height: visible ? listView.height + border.width * 2 : 0
        color: UM.Theme.getColor("main_background")
        border.width: UM.Theme.getSize("default_lining").width
        border.color: UM.Theme.getColor("lining")

        Behavior on height { NumberAnimation { duration: 100 } }

        anchors.bottom: parent.bottom

        property var extrudersModel: CuraApplication.getExtrudersModel()
        UM.SettingPropertyProvider
        {
            id: machineExtruderCount

            containerStack: Cura.MachineManager.activeMachine
            key: "machine_extruder_count"
            watchedProperties: [ "value" ]
            storeIndex: 0
        }

        ListView
        {
            id: listView
            anchors
            {
                left: parent.left
                right: parent.right
                top: parent.top
                margins: UM.Theme.getSize("default_lining").width
            }
            property real maximumHeight: UM.Theme.getSize("objects_menu_size").height
            height: Math.min(contentHeight, maximumHeight)

            ScrollBar.vertical: UM.ScrollBar
            {
                id: scrollBar
            }
            clip: true

            model: Cura.ObjectsModel {}

            delegate: ObjectItemButton
            {
                id: modelButton
                Binding
                {
                    target: modelButton
                    property: "checked"
                    value: model.selected
                }
                text: model.name
                width: listView.width - scrollBar.width
                property bool outsideBuildArea: model.outside_build_area
                property int perObjectSettingsCount: model.per_object_settings_count
                property string meshType: model.mesh_type
                property int extruderNumber: model.extruder_number
                property string extruderColor:
                {
                    if (model.extruder_number == -1)
                    {
                        return "";
                    }
                    return contents.extrudersModel.getItem(model.extruder_number).color;
                }
                property bool showExtruderSwatches: machineExtruderCount.properties.value > 1
            }
        }
    }
}
