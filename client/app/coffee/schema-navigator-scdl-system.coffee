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
    jsonTag: "system"
    label: "System"
    objectDescriptor: {
        mvvmType: "archetype"
        description: "SCDL system model."
        namespaceDescriptor: {
            userImmutable: Encapsule.code.app.modelview.ScdlNamespaceCommonMeta
            userMutable: Encapsule.code.app.modelview.ScdlModelUserMutableNamespaceProperties 
        }
    }
    subMenus: [
        Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutInputPins
        Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutOutputPins

        { 
            jsonTag: "subsystems"
            label: "System Instances"
            objectDescriptor: {
                mvvmType: "extension"
                description: "Contained SCDL system model instances."
                archetype: {
                    jsonTag: "subsystem"
                    label: "System Instance"
                    objectDescriptor: {
                        mvvmType: "archetype"
                        description: "Contained SCDL system instance."
                        namespaceDescriptor: {
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
                        } # namespaceDescriptor
                    } # subsystem objectDescriptor
                } # subsystem archetype
            } # subsystems objectDescriptor
        } # subsystems

        { 
            jsonTag: "submachines"
            label: "Machine Instances"
            objectDescriptor: {
                mvvmType: "extension"
                description: "Contained SCDL machine model instances."
                archetype: {
                    jsonTag: "submachine"
                    label: "Machine Instance"
                    objectDescriptor: {
                        mvvmType: "archetype"
                        description: "SCDL machine instance."
                        namespaceDescriptor: {
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
                        } # namespaceDescriptor
                    } # subsystem objectDescriptor
                } # subsystem archetype
            } # subsystems objectDescriptor
        } # subsystems


        { 
            jsonTag: "subsockets"
            label: "Socket Instances"
            objectDescriptor: {
                mvvmType: "extension"
                description: "Contained SCDL socket model instances."
                archetype: {
                    jsonTag: "subsocket"
                    label: "Socket Instance"
                    objectDescriptor: {
                        mvvmType: "archetype"
                        description: "SCDL socket instance."
                        namespaceDescriptor: {
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
                        } # namespaceDescriptor
                    } # subsystem objectDescriptor
                } # subsystem archetype
            } # subsystems objectDescriptor
        } # subsystems

        Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutNodes

    ] # system submenus
} # Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutSystemArchetype
