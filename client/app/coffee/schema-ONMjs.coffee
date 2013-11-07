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


Encapsule.code.app.ONMjs.SchemaAppData = {

    jsonTag: "schema"
    ____label: "#{appName}"
    ____description: "#{appName} client root."

    semanticBindings: {
        update: (dataReference_) ->
            if dataReference_.revision?
                dataReference_.revision++
            if dataReference_.updateTime?
                dataReference_.updateTime = Encapsule.code.lib.util.getEpochTime()
            if dataReference_.uuidRevision?
                dataReference_.uuidRevision = uuid.v4()
            return true

        getLabel: (dataReference_, address_) ->
            model = address_.getModel();
            label = (dataReference_["name"]? and dataReference_["name"]) or
                (dataReference_["uuid"]? and dataReference_["uuid"] and "#{model.____label} #{dataReference_["uuid"]}") or model.____label
            return label

        setUniqueKey: (dataReference_) ->
            dataReference_.uuid = uuid.v4()

        getUniqueKey: (dataReference_) ->
            key = dataReference_["uuid"]? and dataReference_["uuid"] or undefined
            return key

    } # semanticBindings



    subNamespaces: [
    
        # Encapsule.code.app.ONMjs.OMMDeclarationTest

        {
            namespaceType: "extensionPoint"
            jsonTag: "extendoTest"
            ____label: "Extendo Objects Test"
            ____description: "A collection of objects that are recursively extensible."
            componentArchetype: {
                namespaceType: "component"
                jsonTag: "extendo"
                ____label: "Extendo Component"
                ____description: "This is an extendo component. An extendo component declares an extension point containing instances of its own type."
                namespaceProperties: {
                    userImmutable: {
                        uuid: {
                            ____type: "uuid"
                            fnCreate: -> uuid.v4()
                        }
                    }
                }
                subNamespaces: [
                    {
                        namespaceType: "extensionPoint"
                        jsonTag: "extendoCollection"
                        ____label: "Extendo Collection"
                        ____description: "This is a collection of extendo objects."
                        componentArchetypePath: "schema.extendoTest.extendo"
                    }
                    {
                        namespaceType: "extensionPoint"
                        jsonTag: "people"
                        ____label: "Cabal"
                        ____description: "My cabal."
                        componentArchetype: Encapsule.code.app.ONMjs.SchemaAppDataPersonArchetype 
                    }
                ]
            }
        }

        {
            namespaceType: "child"
            jsonTag: "client"
            ____label: "Client"
            ____description: "#{appName} client home."
            namespaceProperties: {
                userImmutable: {
                    clientDeployment: {
                        ____type: "uuid"
                        fnCreate: -> uuid.v4()
                    } # clientDeployment
                    localSession: {
                        ____type: "object"
                        fnCreate: -> {
                            uuid: uuid.v4()
                            timeStart: Encapsule.code.lib.util.getEpochTime()
                        }
                    } # localSession
                } # userImmutable
            } # namespaceProperties
    
            subNamespaces: [

                # Encapsule.code.app.ONMjs.SchemaAppDataTools

                {
                    namespaceType: "extensionPoint"
                    jsonTag: "catalogues"
                    ____label: "Catalogues"
                    ____description: "SCDL catalogue object collection."
                    componentArchetype: Encapsule.code.app.ONMjs.SchemaAppDataCatalogueArchetype
                } # catalogues


                {
                    namespaceType: "child"
                    jsonTag: "help"
                    ____label: "Help"
                    ____description: "#{appName} help."
                } # help

                {
                    namespaceType: "child"
                    jsonTag: "about"
                    ____label: "About"
                    ____description: "About namespace."
                } # about



            ] # Schema submenus
        } # Schema

    ] # SchemaAppData
} # layout object    
    

