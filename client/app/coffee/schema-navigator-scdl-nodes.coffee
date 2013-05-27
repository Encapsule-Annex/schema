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
Encapsule.code.app.modelview = Encapsule.code.app.modelview? and Encapsule.code.app.modelview or Encapsule.code.app.modelview = {}

Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutNodes = {
    jsonTag: "nodes"
    label: "Nodes"
    objectDescriptor: {
        mvvmType: "extension"
        description: "SCDL node descriptor instances."
        archetype: {
            jsonTag: "node"
            label: "Node"
            objectDescriptor: {
                mvvmType: "archetype"
                description: "SCDL node descriptor instance."
            } # node objectDescriptor
        } # node archetype
    } # nodes object descriptor
} # Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutNodes