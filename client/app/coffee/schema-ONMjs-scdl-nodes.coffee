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
# schema-scdl-navigator-window-layout-nodes.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
Encapsule.code.app.ONMjs = Encapsule.code.app.ONMjs? and Encapsule.code.app.ONMjs or Encapsule.code.app.ONMjs = {}

Encapsule.code.app.ONMjs.SchemaAppDataNodes = {
    namespaceType: "extensionPoint"
    jsonTag: "nodes"
    ____label: "Nodes"
    ____description: "SCDL node descriptor instances."
    componentArchetype: {
        namespaceType: "component"
        jsonTag: "node"
        ____label: "Node"
        ____description: "SCDL node object."
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
            } # user mutable
        } # node namespaceProperties

        subNamespaces: [
            Encapsule.code.app.ONMjs.SchemaAppDataOutputPinChild
            Encapsule.code.app.ONMjs.SchemaAppDataInputPins
        ] # node subMenus
    } # node componentArchetype
} # Encapsule.code.app.ONMjs.SchemaAppDataNodes
