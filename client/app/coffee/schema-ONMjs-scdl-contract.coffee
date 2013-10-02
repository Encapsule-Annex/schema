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
# schema-scdl-navigator-window-layout-socket.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
Encapsule.code.app.ONMjs = Encapsule.code.app.ONMjs? and Encapsule.code.app.ONMjs or Encapsule.code.app.ONMjs = {}

Encapsule.code.app.ONMjs.SchemaAppDataContractArchetype = {
    namespaceType: "component"
    jsonTag: "contract"
    ____label: "Contract"
    ____description: "SCDL contract model."
    namespaceProperties: {
        userImmutable: Encapsule.code.app.ONMjs.SchemaAppDataNamespaceCommonProperties
        userMutable: Encapsule.code.app.ONMjs.ScdlModelUserMutableNamespaceProperties
    } # namespaceProperties

    subNamespaces: [
        {
            namespaceType: "child"
            jsonTag: "socketReference"
            ____label: "Socket Reference"
            ____description: "SCDL socket reference."
        } # socketReference

        {
            namespaceType: "child"
            jsonTag: "modelReference"
            ____label: "Model Reference"
            ____description: "SCDL model reference."
        } # modelReference

        # Easy to miss this slipped in down here.
        Encapsule.code.app.ONMjs.SchemaAppDataNodes

    ] # Socket Contract submenus

} # Encapsule.code.app.ONMjs.SchemaAppDataContractArchetype 