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
# schema-scdl-navigator-window-layout-machine.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
Encapsule.code.app.modelview = Encapsule.code.app.modelview? and Encapsule.code.app.modelview or Encapsule.code.app.modelview = {}

Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutMachineArchetype = {
    jsonTag: "machine"
    label: "Machine"
    objectDescriptor: {
        mvvmType: "archetype"
        description: "SCDL machine model."
        namespaceDescriptor: {
            userImmutable: Encapsule.code.app.modelview.ScdlNamespaceCommonMeta
            userMutable: Encapsule.code.app.modelview.ScdlModelUserMutableNamespaceProperties 
        } # namespaceDescriptor
    } # objectDescriptor
    subMenus: [
        Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutPins
        {
            jsonTag: "states"
            label: "States"
            objectDescriptor: {
                mvvmType: "extension"
                description: "SCDL state descriptors."
                archetype: {
                    jsonTag: "state"
                    label: "State"
                    objectDescriptor: {
                        mvvmType: "archetype"
                        description: "SCDL state descriptor."
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
                                stateEnterExpression: {
                                    type: "string"
                                    fnCreate: -> ""
                                    fnReinitialize: -> ""
                                }
                                stateExitExpression: {
                                    type: "string"
                                    fnCreate: -> ""
                                    fnReinitialize: -> ""
                                }
                            } # userMutable
                        } # namespaceDescriptor
                    } # state objectDescriptor
                    subMenus: [
                        {
                            jsonTag: "transitions"
                            label: "Transitions"
                            objectDescriptor: {
                                mvvmType: "extension"
                                description: "SCDL state transition descriptors."
                                archetype: {
                                    jsonTag: "transition"
                                    label: "Transition"
                                    objectDescriptor: {
                                        mvvmType: "archetype"
                                        description: "SCDL state transition descriptor."
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
                                                finalState: {
                                                    type: "uuidSelection"
                                                    selectionSource: "schema/catalogues/catalogue/models/machines/machine/states"
                                                    fnCreate: -> Encapsule.code.lib.util.uuidNull
                                                    fnReinitialize: -> Encapsule.code.lib.util.uuidNull
                                                }
                                                vectorExpression: {
                                                    type: "string"
                                                    fnCreate: -> ""
                                                    fnReinitialize: -> ""
                                                }
                                            } # userMutable
                                        } # namespaceDescriptor
                                    } # transition objectDescriptor
                                } # transition archetype
                            } # transitions objectDescriptor
                        } # Transitions

                    ] # state subMenus
                } # state archetype
            } # states objectDescriptor
        } # States
     ] # Machine submenus
} # Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutMachineArchetype