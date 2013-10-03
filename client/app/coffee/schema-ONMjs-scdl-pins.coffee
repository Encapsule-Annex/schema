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
Encapsule.code.app.ONMjs = Encapsule.code.app.ONMjs? and Encapsule.code.app.ONMjs or Encapsule.code.app.ONMjs = {}

Encapsule.code.app.ONMjs.SchemaAppDataInputPin = {
    namespaceType: "component"
    jsonTag: "inputPin"
    ____label: "Input Pin"
    ____description: "SCDL input pin model."
    namespaceProperties: {
        userImmutable: Encapsule.code.app.ONMjs.SchemaAppDataNamespaceCommonProperties
        userMutable: {
            name: {
                ____type: "string"
                fnCreate: -> ""
            }
            description: {
                ____type: "string"
                fnCreate: -> ""
            }
            tags: {
                ____type: "stringCSV"
                fnCreate: -> ""
            }
            type: {
                ____type: "uuidSelection"
                ____selectionSource: "schema.catalogues.catalogue.models.types"
                fnCreate: -> Encapsule.code.lib.util.uuidNull
            }
        } # userMutable
    } # namespaceProperties
} # inputPin


Encapsule.code.app.ONMjs.SchemaAppDataInputPins = {
    namespaceType: "extensionPoint"
    jsonTag: "inputPins"
    ____label: "Input Pins"
    ____description: "SCDL input pin models."
    componentArchetype: Encapsule.code.app.ONMjs.SchemaAppDataInputPin
} # inputPins



Encapsule.code.app.ONMjs.SchemaAppDataOutputPinChild = {
    namespaceType: "child"                                                                     
    jsonTag: "outputPin"
    ____label: "Output Pin"
    ____description: "SCDL output pin model."
    namespaceDescriptor: {
        userImmutable: Encapsule.code.app.ONMjs.SchemaAppDataNamespaceCommonProperties
        userMutable: {
            name: {
                ____type: "string"
                fnCreate: -> ""
            }
            description: {
                ____type: "string"
                fnCreate: -> ""
            }
            tags: {
                ____type: "stringCSV"
                fnCreate: -> ""
            }
            type: {
                ____type: "uuidSelection"
                ____selectionSource: "schema.catalogues.catalogue.models.types"
                fnCreate: -> Encapsule.code.lib.util.uuidNull
            }
        } # userMutable
    } # namespaceProperties
} # outputPinChild


Encapsule.code.app.ONMjs.SchemaAppDataOutputPinArchetype = {
    namespaceType: "component"
    jsonTag: "outputPin"
    ____label: "Output Pin"
    ____description: "SCDL output pin model."
    namespaceProperties: {
        userImmutable: Encapsule.code.app.ONMjs.SchemaAppDataNamespaceCommonProperties
        userMutable: {
            name: {
                ____type: "string"
                fnCreate: -> ""
            }
            description: {
                ____type: "string"
                fnCreate: -> ""
            }
            tags: {
                ____type: "stringCSV"
                fnCreate: -> ""
            }
            type: {
                ____type: "uuidSelection"
                ____selectionSource: "schema.catalogues.catalogue.models.types"
                fnCreate: -> Encapsule.code.lib.util.uuidNull
            }
        } # userMutable
    } # namespaceProperties
} # outputPinArchetype



Encapsule.code.app.ONMjs.SchemaAppDataOutputPins = {
    namespaceType: "extensionPoint"
    jsonTag: "outputPins"
    ____label: "Output Pins"
    ____description: "SCDL output pin models."
    componentArchetype: Encapsule.code.app.ONMjs.SchemaAppDataOutputPinArchetype
} # outputPins


