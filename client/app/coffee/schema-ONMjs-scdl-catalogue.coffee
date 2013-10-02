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
# schema-scdl-navigator-layout-catalogue.coffee

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
Encapsule.code.app.ONMjs = Encapsule.code.app.ONMjs? and Encapsule.code.app.ONMjs or Encapsule.code.app.ONMjs = {}


Encapsule.code.app.ONMjs.SchemaAppDataCatalogueArchetype = {

    namespaceType: "component"
    jsonTag: "catalogue"
    ____label: "Catalogue"
    ____description: "SCDL Model Catalogue object."
    namespaceProperties: {
        userImmutable: Encapsule.code.app.ONMjs.SchemaAppDataNamespaceCommonProperties
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
            author: {
                type: "uuidSelection"
                selectionSource: "schema/catalogues/catalogue/assets/people"
                fnCreate: -> Encapsule.code.lib.util.uuidNull
                fnReinitialize: ->  Encapsule.code.lib.util.uuidNull
            }
            organization: {
                type: "uuidSelection"
                selectionSource: "schema/catalogues/catalogue/assets/organizations"
                fnCreate: -> Encapsule.code.lib.util.uuidNull
                fnReinitialize: -> Encapsule.code.lib.util.uuidNull
            }
        }
    }
    subNamespaces: [
        {
            namespaceType: "extensionPoint"
            jsonTag: "specifications"
            ____label: "Specifications"
            ____description: "SCDL specification collection."
            componentArchetype: Encapsule.code.app.ONMjs.SchemaAppDataSpecificationArchetype 

        } # Specifications
        {
            namespaceType: "child"
            jsonTag: "models"
            ____label: "Models"
            ____description: "SCDL model namespace."

            subNamespaces: [
                {
                    namespaceType: "extensionPoint"
                    jsonTag: "systems"
                    ____label: "Systems"
                    ____description: "SCDL system model collection."
                    componentArchetype: Encapsule.code.app.ONMjs.SchemaAppDataSystemArchetype

                } # Systems
                {
                    namespaceType: "extensionPoint"
                    jsonTag: "sockets"
                    ____label: "Sockets"
                    ____description: "SCDL socket model collection."
                    componentArchetype: Encapsule.code.app.ONMjs.SchemaAppDataSocketArchetype
                } # Sockets
                {
                    namespaceType: "extensionPoint"
                    jsonTag: "contracts"
                    ____label: "Contracts"
                    ____description: "SCDL contract model collection."
                    componentArchetype: Encapsule.code.app.ONMjs.SchemaAppDataContractArchetype
                } # sockets
                {
                    namespaceType: "extensionPoint"
                    jsonTag: "machines"
                    ____label: "Machines"
                    ____description: "SCDL machine model collection."
                    componentArchetype: Encapsule.code.app.ONMjs.SchemaAppDataMachineArchetype
                } # machines
                {
                    namespaceType: "extensionPoint"
                    jsonTag: "types"
                    ____label: "Types"
                    ____description: "SCDL type model collection."
                    componentArchetype:  Encapsule.code.app.ONMjs.SchemaAppDataTypeArchetype
                } # types
            ] # Models submenus
        } # Models
        {
            namespaceType: "child"
            jsonTag: "resources"
            ____label: "Resources"
            ____description: "SCDL common resource namespace."
            subNamespaces: [
                {
                    namespaceType: "child"
                    jsonTag: "attribution"
                    ____label: "Attribution"
                    ____description: "Shared attribution namespace."

                    subNamespaces: [
                        {
                            namespaceType: "extensionPoint"
                            jsonTag: "people"
                            ____label: "People"
                            ____description: "SCDL person models."
                            componentArchetype: Encapsule.code.app.ONMjs.SchemaAppDataPersonArchetype
                        } # people
                        {
                            namespaceType: "extensionPoint"
                            jsonTag: "organizations"
                            ____label: "Organizations"
                            ____description: "SCDL organization models."
                            componentArchetype: Encapsule.code.app.ONMjs.SchemaAppDataOrganizationArchetype
                        } # organizations
                        {
                            namespaceType: "extensionPoint"
                            jsonTag: "licenses"
                            ____label: "Licenses"
                            ____description: "SCDL license models."
                            componentArchetype: Encapsule.code.app.ONMjs.SchemaAppDataLicenseArchetype
                        } # licenses
                        {
                            namespaceType: "extensionPoint"
                            jsonTag: "copyrights"
                            ____label: "Copyrights"
                            ____description: "SCDL copyright models."
                            componentArchetype: Encapsule.code.app.ONMjs.SchemaAppDataCopyrightArchetype
                        } # copyrights
                    ] # assets submenu
                } # assets
            ] # attribution subMenus
        } # attribution
    ] # Catalogue submenus
} # Catalogue archetype

