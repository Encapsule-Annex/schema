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
Encapsule.code.app.ONMjs = Encapsule.code.app.ONMjs? and Encapsule.code.app.ONMjs or Encapsule.code.app.ONMjs = {}


Encapsule.code.app.ONMjs.ScdlNavigatorWindowLayout = {

    jsonTag: "schema"
    label: "#{appName}"
    description: "#{appName} client root."

    semanticBindings: {
        update: (dataReference_) ->
            if dataReference_.revision?
                dataReference_.revision++
            if dataReference_.updateTime?
                dataReference_.updateTime = Encapsule.code.lib.util.getEpochTime()
            if dataReference_.uuidRevision?
                dataReference_.uuidRevision = uuid.v4()
            return true

        getLabel: (dataReference_, namespaceDescriptor_) ->
            label = (dataReference_["name"]? and dataReference_["name"]) or
                (dataReference_["uuid"]? and dataReference_["uuid"] and "#{namespaceDescriptor_.label} #{dataReference_["uuid"]}") or
                namespaceDescriptor_.label
            return label

        getUniqueKey: (dataReference_) ->
            key = dataReference_["uuid"]? and dataReference_["uuid"] or undefined
            return key

    } # semanticBindings



    subNamespaces: [
    
        # Encapsule.code.app.ONMjs.OMMDeclarationTest

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

                # Encapsule.code.app.ONMjs.ScdlNavigatorWindowLayoutTools

                {
                    namespaceType: "extensionPoint"
                    jsonTag: "catalogues"
                    label: "Catalogues"
                    description: "SCDL catalogue object collection."
                    componentArchetype: Encapsule.code.app.ONMjs.ScdlNavigatorWindowLayoutCatalogueArchetype
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
    

