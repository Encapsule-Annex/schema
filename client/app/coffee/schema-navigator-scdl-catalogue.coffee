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
Encapsule.code.app.modelview = Encapsule.code.app.modelview? and Encapsule.code.app.modelview or Encapsule.code.app.modelview = {}


Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutCatalogueArchetype = {

    jsonTag: "catalogue"
    label: "Catalogue"
    objectDescriptor: {
        jsonTag: "catalogue"
        mvvmType: "archetype"
        description: "SCDL catalogue object."
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
    }
    subMenus: [
        {
            jsonTag: "specifications"
            label: "Specifications"
            objectDescriptor: {
                mvvmType: "extension"
                description: "SCDL specification."
                archetype: Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutSpecificationArchetype 
            } # specification objectDescriptor
        } # Specifications
        {
            jsonTag: "models"
            label: "Models"
            objectDescriptor: {
                mvvmType: "child"
                description: "SCDL models by type."
            }
            subMenus: [
                {
                    jsonTag: "systems"
                    label: "Systems"
                    objectDescriptor: {
                        mvvmType: "extension"
                        description: "SCDL system models."
                        archetype: Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutSystemArchetype
                    } # systems objectDescriptor
                } # Systems
                {
                    jsonTag: "sockets"
                    label: "Sockets"
                    objectDescriptor: {
                        mvvmType: "extension"
                        description: "SCDL socket models."
                        archetype: Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutSocketArchetype
                    } # sockets objectDescriptor

                } # Sockets
                {
                    jsonTag: "contracts"
                    label: "Contracts"
                    objectDescriptor: {
                        mvvmType: "extension"
                        description: "SCDL contract models."
                        archetype: Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutContractArchetype
                    } # contracts objectDescriptor
                } # sockets
        
                {
                    jsonTag: "machines"
                    label: "Machines"
                    objectDescriptor: {
                        mvvmType: "extension"
                        description: "SCDL machine models."
                        archetype: Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutMachineArchetype
                    } # machines objectDescriptor
                } # machines

                {
                    jsonTag: "types"
                    label: "Types"
                    objectDescriptor: {
                        mvvmType: "extension"
                        description: "SCDL type models."
                        archetype:  Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutTypeArchetype
                    } # types objectDescriptor
                } # types
            ] # Models submenus
        } # Models
        {
            jsonTag: "assets"
            label: "Assets"
            objectDescriptor: {
                mvvmType: "child"
                description: "SCDL asset models by namespace."
            }
            subMenus: [
                {
                    jsonTag: "people"
                    label: "People"
                    objectDescriptor: {
                        mvvmType: "extension"
                        description: "SCDL person models."
                        archetype: {
                            jsonTag: "person"
                            label: "Person"
                            objectDescriptor: {
                                mvvmType: "archetype"
                                description: "SCDL person model."
                            } # person objectDescriptor
                        } # person archetype
                    } # people objectDescriptor
                } # people
                {
                    jsonTag: "organizations"
                    label: "Organizations"
                    objectDescriptor: {
                        mvvmType: "extension"
                        description: "SCDL organization models."
                        archetype: {
                            jsonTag: "organization"
                            label: "Organization"
                            objectDescriptor: {
                                mvvmType: "archetype"
                                description: "SCDL organization model."
                            } # organization objectDescriptor
                        } # organization archetype
                    } # organizations objectDescriptor
                } # organizations
                {
                    jsonTag: "licenses"
                    label: "Licenses"
                    objectDescriptor: {
                        mvvmType: "extension"
                        description: "SCDL license models."
                        archetype: {
                            jsonTag: "license"
                            label: "License"
                            objectDescriptor: {
                                mvvmType: "archetype"
                                description: "SCDL license model."
                            } # license objectDescriptor
                        } # license archetype
                    } # licenses objectDescriptor
                } # licenses
                {
                    jsonTag: "copyrights"
                    label: "Copyrights"
                    objectDescriptor: {
                        mvvmType: "extension"
                        description: "SCDL copyright models."
                        archetype: {
                            jsonTag: "copyright"
                            label: "Copyright"
                            objectDescriptor: {
                                mvvmType: "archetype"
                                description: "SCDL copyright model."
                            } # copyright objectDescriptor
                        } # copyright archetype
                    } # copyrights objectDescriptor
                } # copyrights
            ] # assets submenu
        } # assets
    ] # Catalogue submenus
} # Catalogue archetype

