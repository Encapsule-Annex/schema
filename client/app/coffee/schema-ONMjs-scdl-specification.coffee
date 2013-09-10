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
# schema-scdl-navigator-window-layout-specification.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
Encapsule.code.app.modelview = Encapsule.code.app.modelview? and Encapsule.code.app.modelview or Encapsule.code.app.modelview = {}


Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutSpecificationArchetype = {
    namespaceType: "component"                                                                             
    jsonTag: "specification"
    label: "Specification"
    description: "SCDL specification."
    namespaceProperties: {
        userImmutable:  Encapsule.code.app.modelview.ScdlNamespaceCommonMeta
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
                type: "string"
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
            copyright: {
                type: "uuidSelection"
                selectionSource: "schema/catalogues/catalogue/assets/copyrights"
                fnCreate: -> Encapsule.code.lib.util.uuidNull
                fnReinitialize: -> Encapsule.code.lib.util.uuidNull
            }
            license: {
                type: "uuidSelection"
                selectionSource: "schema/catalogues/catalogue/assets/licenses"
                fnCreate: -> Encapsule.code.lib.util.uuidNull
                fnReinitialize: -> Encapsule.code.lib.util.uuidNull
            }
        }
    }
    subNamespaces: [
        {
            namespaceType: "extensionPoint"
            jsonTag: "systemInstances"
            label: "System Instances"
            description: "SCDL system model instances."
            componentArchetype: {
                namespaceType: "component"
                jsonTag: "systemInstance"
                label: "System Instance"
                description: "SCDL system model instance."
                namespaceProperties: {
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
                        uuidModel: {
                            type: "uuidSelection"
                            selectionSource: "schema/catalogues/catalogue/models/systems"
                            fnCreate: ->  Encapsule.code.lib.util.uuidNull
                            fnReinitialize: Encapsule.code.lib.util.uuidNull
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
                    subNamespaces: [
                        {
                            namespaceType: "extensionPoint"
                            jsonTag: "socketInstances"
                            label: "Socket Instances"
                            description: "SCDL socket model instances."
                            componentArchetype: {
                                namespaceType: "component"
                                jsonTag: "socketInstance"
                                label: "Socket Instance"
                                description: "SCDL socket model instance."
                                namespaceProperties: {
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
                                        uuidModel: {
                                            type: "uuidSelection"
                                            selectionSource: "schema/catalogues/catalogue/models/sockets"
                                            fnCreate: ->  Encapsule.code.lib.util.uuidNull
                                            fnReinitialize: Encapsule.code.lib.util.uuidNull
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
                                    subNamespaces: [
                                        {
                                            namespaceType: "extensionPoint"
                                            jsonTag: "instanceBindings"
                                            label: "Instance Bindings"
                                            description: "SCDL socket model instance bindings."
                                            componentArchetype: {
                                                namespaceType: "component"
                                                jsonTag: "instanceBinding"
                                                label: "Instance Binding"
                                                description: "SCDL socket model instance binding."
                                                namespaceProperties: {
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
                                                        uuidModel: {
                                                            type: "uuidSelection"
                                                            selectionSource: "schema/catalogues/catalogue/models/sockets"
                                                            fnCreate: ->  Encapsule.code.lib.util.uuidNull
                                                            fnReinitialize: Encapsule.code.lib.util.uuidNull
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
                                        }
                                    ]
                                }
                            }
                        }
                    ]
                }
            }
        }
    ]
}

