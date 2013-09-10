###

  http://schema.encapsule.org/

  A single-page HTML5 application for creating, visualizing, and editing
  JSON-encoded Soft Circuit Description Language (SCDL) models.

  Copyright 2013 Encapsule Project, Copyright 2013 Chris Russell

  Distributed under the terms of the Boost Software License Version 1.0
  See included license.txt or http://www.boost.org/LICENSE_1_0.txt

  Sources on GitHub: https://github.com/Encapsule-Project/schema

  Visit http://www.encapsule.org for more information and happy hacking.

###
#
# schema-scdl-navigator-window-layout-system.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
Encapsule.code.app.modelview = Encapsule.code.app.modelview? and Encapsule.code.app.modelview or Encapsule.code.app.modelview = {}

Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutSystemArchetype = {
    namespaceType: "component"
    jsonTag: "system"
    label: "System"
    description: "SCDL system model."
    namespaceProperties: {
        userImmutable: Encapsule.code.app.modelview.ScdlNamespaceCommonMeta
        userMutable: Encapsule.code.app.modelview.ScdlModelUserMutableNamespaceProperties 
    }

    subNamespaces: [
        Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutInputPins
        Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutOutputPins

        { 
            namespaceType: "extensionPoint"
            jsonTag: "subsystems"
            label: "System Instances"
            description: "Contained SCDL system model instances."
            componentArchetype: {
                namespaceType: "component"
                jsonTag: "subsystem"
                label: "System Instance"
                description: "Contained SCDL system instance."
                namespaceProperties: {
                    userImmutable: Encapsule.code.app.modelview.ScdlNamespaceCommonMeta
                    userMutable: {
                        name: {
                            type: "string"
                            fnCreate: -> ""
                            fnReinitialize: -> ""
                        }
                        description: {
                            type: "string"
                            fnCreate: -> ""
                            fnReinitialize: -> ""
                        }
                        tags: {
                            type: "stringCSV"
                            fnCreate: -> ""
                            fnReinitialize: -> ""
                        }
                        systemUuid : {
                            type: "uuidSelection"
                            selectionSource: "schema/catalogues/catalogue/models/systems"
                            fnCreate: -> Encapsule.code.lib.util.uuidNull
                            fnReinitialize: ->  Encapsule.code.lib.util.uuidNull
                        }
                    } # userMutable
                } # namespaceProperties
            } # subsystem archetype
        } # subsystems

        { 
            namespaceType: "extensionPoint"
            jsonTag: "submachines"
            label: "Machine Instances"
            description: "Contained SCDL machine model instances."
            componentArchetype: {
                namespaceType: "component"
                jsonTag: "submachine"
                label: "Machine Instance"
                description: "SCDL machine instance."
                namespaceProperties: {
                    userImmutable: Encapsule.code.app.modelview.ScdlNamespaceCommonMeta
                    userMutable: {
                        name: {
                            type: "string"
                            fnCreate: -> ""
                            fnReinitialize: -> ""
                        }
                        description: {
                            type: "string"
                            fnCreate: -> ""
                            fnReinitialize: -> ""
                        }
                        tags: {
                            type: "stringCSV"
                            fnCreate: -> ""
                            fnReinitialize: -> ""
                        }
                        machineUuid : {
                            type: "uuidSelection"
                            selectionSource: "schema/catalogues/catalogue/models/systems"
                            fnCreate: -> Encapsule.code.lib.util.uuidNull
                            fnReinitialize: ->  Encapsule.code.lib.util.uuidNull
                        }
                    } # userMutable
                } # namespaceProperties
            } # subsystem archetype

        } # submachines


        { 
            namespaceType: "extensionPoint"
            jsonTag: "subsockets"
            label: "Socket Instances"
            description: "Contained SCDL socket model instances."
            componentArchetype: {
                namespaceType: "component"
                jsonTag: "subsocket"
                label: "Socket Instance"
                description: "SCDL socket instance."
                namespaceProperties: {
                    userImmutable: Encapsule.code.app.modelview.ScdlNamespaceCommonMeta
                    userMutable: {
                        name: {
                            type: "string"
                            fnCreate: -> ""
                            fnReinitialize: -> ""
                        }
                        description: {
                            type: "string"
                            fnCreate: -> ""
                            fnReinitialize: -> ""
                        }
                        tags: {
                            type: "stringCSV"
                            fnCreate: -> ""
                            fnReinitialize: -> ""
                        }
                        socketUuid : {
                            type: "uuidSelection"
                            selectionSource: "schema/catalogues/catalogue/models/systems"
                            fnCreate: -> Encapsule.code.lib.util.uuidNull
                            fnReinitialize: ->  Encapsule.code.lib.util.uuidNull
                        }
                    } # userMutable
                } # namespaceProperties
            } # subsystem archetype
        } # subsystems

        Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutNodes

    ] # system submenus
} # Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutSystemArchetype
