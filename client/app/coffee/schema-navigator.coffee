###

  http://schema.encapsule.org/schema.html

  A single-page HTML5 application for creating, visualizing, and editing
  JSON-encoded Soft Circuit Description Language (SCDL) models.

  Copyright 2013 Encapsule Project, Copyright 2013 Chris Russell

  Distributed under the terms of the Boost Software License Version 1.0
  See included license.txt or http://www.boost.org/LICENSE_1_0.txt

  Sources on GitHub: https://github.com/Encapsule-Project/schema

  Visit http://www.encapsule.org for more information and happy hacking.

###
#
# schema-scdl-navigator-window-layout.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
Encapsule.code.app.modelview = Encapsule.code.app.modelview? and Encapsule.code.app.modelview or Encapsule.code.app.modelview = {}


Encapsule.code.app.modelview.ScdlNavigatorWindowLayout = {

    jsonTag: "schema"
    label: "#{appName}"
    description: "#{appName} client root."

    semanticBindings: {
        update: (namespaceObjectReference_) ->
            if namespaceObjectReference_.revision?
                namespaceObjectReference_.revision++
            if namespaceObjectReference_.updateTime?
                namespaceObjectReference_.updateTime = Encapsule.code.lib.util.getEpochTime()
            if namespaceObjectReference_.uuidRevision?
                namespaceObjectReference_.uuidRevision = uuid.v4()
            return true

        getLabel: (namespaceObjectReference_) ->
            label = namespaceObjectReference_["name"]? and namespaceObjectReference_["name"] or
                namespaceObjectReference_["uuid"]? and namespaceObjectReference_["uuid"] or
                undefined
            return label

        getUniqueKey: (namespaceObjectReference_) ->
            key = namespaceObjectReference_["uuid"]? and namespaceObjectReference_["uuid"] or undefined
            return key

    } # semanticBindings



    subNamespaces: [
    
        # Encapsule.code.app.modelview.OMMDeclarationTest

        {
            namespaceType: "child"
            jsonTag: "client"
            label: "Client"
            description: "#{appName} client home."
            namespaceProperties: {
                userImmutable: {
                    clientDeployment: {
                        type: "uuid"
                        fnCreate: -> uuid.v4()
                        fnReinitialize: undefined
                    } # clientDeployment
                    localSession: {
                        type: "object"
                        fnCreate: -> {
                            uuid: uuid.v4()
                            timeStart: Encapsule.code.lib.util.getEpochTime()
                        }
                        fnReinitialize: undefined
                    } # localSession
                } # userImmutable
            } # namespaceProperties
    
            subNamespaces: [

                # Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutTools

                {
                    namespaceType: "extensionPoint"
                    jsonTag: "catalogues"
                    label: "Catalogues"
                    description: "SCDL catalogue object collection."
                    componentArchetype: Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutCatalogueArchetype
                } # catalogues


                {
                    namespaceType: "child"
                    jsonTag: "help"
                    label: "Help"
                    description: "#{appName} help."
                } # help

                {
                    namespaceType: "child"
                    jsonTag: "about"
                    label: "About"
                    description: "About namespace."
                } # about



            ] # Schema submenus
        } # Schema

    ] # ScdlNavigatorWindowLayout
} # layout object    
    

