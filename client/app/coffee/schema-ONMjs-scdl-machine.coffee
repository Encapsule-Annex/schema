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
Encapsule.code.app.ONMjs = Encapsule.code.app.ONMjs? and Encapsule.code.app.ONMjs or Encapsule.code.app.ONMjs = {}

Encapsule.code.app.ONMjs.ScdlNavigatorWindowLayoutMachineArchetype = {
    namespaceType: "component"
    jsonTag: "machine"
    label: "Machine"
    description: "SCDL machine model."
    namespaceProperties: {
        userImmutable: Encapsule.code.app.ONMjs.ScdlNamespaceCommonMeta
        userMutable: Encapsule.code.app.ONMjs.ScdlModelUserMutableNamespaceProperties 
    } # namespaceProperties

    subNamespaces: [
        Encapsule.code.app.ONMjs.ScdlNavigatorWindowLayoutInputPins
        Encapsule.code.app.ONMjs.ScdlNavigatorWindowLayoutOutputPins
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
                    userImmutable: Encapsule.code.app.ONMjs.ScdlNamespaceCommonMeta
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
                                userImmutable: Encapsule.code.app.ONMjs.ScdlNamespaceCommonMeta
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
} # Encapsule.code.app.ONMjs.ScdlNavigatorWindowLayoutMachineArchetype