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
                description: "SCDL node object."
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
                    } # user mutable
                } # node namespaceDescriptor
            } # node objectDescriptor
            subMenus: [
                {
                    jsonTag: "outputPinInstance"
                    label: "Output Pin Instance"
                    objectDescriptor: {
                        mvvmType: "child"
                        description: "Output pin (source) instance."
                        namespaceDescriptor: {
                            userMutable: {
                                uuidOutputPinInstance: {
                                    type: "uuidSelection"
                                    selectionSource: "schema/catalogues/catalogue/models/systems/system"
                                    fnCreate: -> Encapsule.code.lib.util.uuidNull
                                    fnReinitialize: ->  Encapsule.code.lib.util.uuidNull
                                } # uuidOutputPinInstance
                            } # userMutable
                        } # namespaceDescriptor
                    } # outputPinInstance objectDescriptor
                } # outputPinInstance

                {
                    jsonTag: "inputPinInstances"
                    label: "Input Pins Instances"
                    objectDescriptor: {
                        mvvmType: "extension"
                        description: "Input Pin Instances"
                        archetype: {
                            jsonTag: "inputPinInstance"
                            label: "Input Pin Instance"
                            objectDescriptor: {
                                mvvmtType: "archetype"
                                description: "Input pin (sink) instance."
                                namespaceDescriptor: {
                                    userMutable: {
                                        uuidOutputPinInstance: {
                                            type: "uuidSelection"
                                            selectionSource: "schema/catalogues/catalogue/models/systems/system"
                                            fnCreate: -> Encapsule.code.lib.util.uuidNull
                                            fnReinitialize: ->  Encapsule.code.lib.util.uuidNull
                                        } # uuidOutputPinInstance
                                    } # userMutable
                                } # namespaceDescriptor
                            } # input pin objectDescriptor
                        } # input pin archetype
                    } # inputPinInstances objectDescriptor
                } # inputPinInstances
            ] # node subMenus
        } # node archetype
    } # nodes object descriptor
} # Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutNodes
