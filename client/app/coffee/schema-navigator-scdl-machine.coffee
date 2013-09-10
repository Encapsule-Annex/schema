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
    namespaceType: "component"
    jsonTag: "machine"
    label: "Machine"
    description: "SCDL machine model."
    namespaceProperties: {
        userImmutable: Encapsule.code.app.modelview.ScdlNamespaceCommonMeta
        userMutable: Encapsule.code.app.modelview.ScdlModelUserMutableNamespaceProperties 
    } # namespaceProperties

    subNamespaces: [
        Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutInputPins
        Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutOutputPins
        {
            namespaceType: "extensionPoint"
            jsonTag: "states"
            label: "States"
            description: "SCDL state descriptors."
            componentArchetype: {
                namespaceType: "component"
                jsonTag: "state"
                label: "State"
                description: "SCDL state descriptor."
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
                } # state namespaceProperties

                subNamespaces: [
                    {
                        namespaceType: "extensionPoint"
                        jsonTag: "transitions"
                        label: "Transitions"
                        description: "SCDL state transition descriptors."
                        componentArchetype: {
                            namespaceType: "component"
                            jsonTag: "transition"
                            label: "Transition"
                            description: "SCDL state transition descriptor."
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
                            } # namespaceProperties
                        } # transition
                    } # transition
                ] # state subNamespaces

            } # states objectDescriptor
        } # States
     ] # Machine submenus
} # Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutMachineArchetype