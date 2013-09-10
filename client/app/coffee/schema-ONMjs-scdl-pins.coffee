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
# schema-scdl-navigator-window-layout-pins.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
Encapsule.code.app.modelview = Encapsule.code.app.modelview? and Encapsule.code.app.modelview or Encapsule.code.app.modelview = {}

Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutInputPin = {
    namespaceType: "component"
    jsonTag: "inputPin"
    label: "Input Pin"
    description: "SCDL input pin model."
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
            type: {
                type: "uuidSelection"
                selectionSource: "schema/catalogues/catalogue/models/types"
                fnCreate: -> Encapsule.code.lib.util.uuidNull
                fnReinitialize: -> Encapsule.code.lib.util.uuidNull
            }
        } # userMutable
    } # namespaceProperties
} # inputPin


Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutInputPins = {
    namespaceType: "extensionPoint"
    jsonTag: "inputPins"
    label: "Input Pins"
    description: "SCDL input pin models."
    componentArchetype: Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutInputPin
} # inputPins



Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutOutputPinChild = {
    namespaceType: "child"                                                                     
    jsonTag: "outputPin"
    label: "Output Pin"
    description: "SCDL output pin model."
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
            type: {
                type: "uuidSelection"
                selectionSource: "schema/catalogues/catalogue/models/types"
                fnCreate: -> Encapsule.code.lib.util.uuidNull
                fnReinitialize: -> Encapsule.code.lib.util.uuidNull
            }
        } # userMutable
    } # namespaceProperties
} # outputPinChild


Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutOutputPinArchetype = {
    namespaceType: "component"
    jsonTag: "outputPin"
    label: "Output Pin"
    description: "SCDL output pin model."
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
            type: {
                type: "uuidSelection"
                selectionSource: "schema/catalogues/catalogue/models/types"
                fnCreate: -> Encapsule.code.lib.util.uuidNull
                fnReinitialize: -> Encapsule.code.lib.util.uuidNull
            }
        } # userMutable
    } # namespaceProperties
} # outputPinArchetype



Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutOutputPins = {
    namespaceType: "extensionPoint"
    jsonTag: "outputPins"
    label: "Output Pins"
    description: "SCDL output pin models."
    componentArchetype: Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutOutputPinArchetype
} # outputPins


