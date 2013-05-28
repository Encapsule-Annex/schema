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
# schema-scdl-navigator-window-layout-pins.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
Encapsule.code.app.modelview = Encapsule.code.app.modelview? and Encapsule.code.app.modelview or Encapsule.code.app.modelview = {}

Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutPins = {
    jsonTag: "pins"
    label: "I/O Pins"
    objectDescriptor: {
        mvvmType: "child"
        description: "SCDL pin models by function."
    }
    subMenus: [
        {
            jsonTag: "inputPins"
            label: "Input Pins"
            objectDescriptor: {
                mvvmType: "extension"
                description: "SCDL input pin models."
                archetype: {
                    jsonTag: "inputPin"
                    label: "Input Pin"
                    objectDescriptor: {
                        mvvmType: "archetype"
                        description: "SCDL input pin model."
                        namespaceDescriptor: {
                            userImmutable: Encapsule.code.app.modelview.ScdlNamespaceCommonMeta
                            userMutable: {
                                name: {
                                }
                                description: {
                                }
                                tags: {
                                }
                                type: {
                                }
                            } # userMutable
                        } # namespaceDescriptor
                    } # inputPin objectDescriptor
                } # inputPin archetype
            } # inputPins objectDescriptor
        } # inputPins
        {
            jsonTag: "outputPins"
            label: "Output Pins"
            objectDescriptor: {
                mvvmType: "extension"
                description: "SCDL output pin models."
                archetype: {
                    jsonTag: "outputPin"
                    label: "Output Pin"
                    objectDescriptor: {
                        mvvmType: "archetype"
                        description: "SCDL output pin model."
                        namespaceDescriptor: {
                            userImmutable: Encapsule.code.app.modelview.ScdlNamespaceCommonMeta
                            userMutable: {
                                name: {
                                }
                                description: {
                                }
                                tags: {
                                }
                                type: {
                                }
                            } # userMutable
                        } # namespaceDescriptor
                    } # outputPin objectDescriptor
                } # outputPin archetype
            } # outputPins objectDescriptor
        } # outputPins
    ] # pins submenus

} # Encapsule.code.app.modelview.ScdlNavigatorWindowLayoutPins

