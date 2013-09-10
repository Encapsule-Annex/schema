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
# schema-scdl-navigator-layout-tools.coffee

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
Encapsule.code.app.ONMjs = Encapsule.code.app.ONMjs? and Encapsule.code.app.ONMjs or Encapsule.code.app.ONMjs = {}


Encapsule.code.app.ONMjs.SchemaAppDataTools = {
    jsonTag: "toolsMenu"
    label: "Tools"
    objectDescriptor: {
        mvvmType: "child"
        description: "SCDL catalogue editors organized by activity."
    }
    subMenus: [
        {
            jsonTag: "compose"
            label: "Compose"
            objectDescriptor: {
                mvvmType: "child"
                description: "SCDL system composer."
            }
        }
        {
            jsonTag: "design"
            label: "Design"
            objectDescriptor: {
                mvvmType: "child"
                description: "SCDL system designer."
            }
        }

        {
            jsonTag: "model"
            label: "Model"
            objectDescriptor: {
                mvvmType: "child"
                description: "SCDL model designer."
            }
        }
        {
            jsonTag: "test"
            label: "Test"
            objectDescriptor: {
                mvvmType: "child"
                description: "SCDL test bench."
            }
        }
        {
            jsonTag: "visualize"
            label: "Visualize"
            objectDescriptor: {
                mvvmType: "child"
                description: "SCDL model visualizer."
            }
        }
        {
            jsonTag: "share"
            label: "Share"
            objectDescriptor: {
                mvvmType: "child"
                description: "Share your work."
            }
        }
    ] # tools submenus

} # Encapsule.code.app.ONMjs.SchemaAppDataTools
