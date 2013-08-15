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

Encapsule.code.app.modelview.OMMDeclarationTest = {
    jsonTag: "omm"
    label: "OMM Lib Test"
    objectDescriptor: {
        mvvmType: "child"
        description: "Encapsule Project Object Model Manager (OMM) library test & demo."
        namespaceDescriptor: {
        } # namespaceDescriptor
    } # obejctDescriptor
    subMenus: [
        {
            jsonTag: "extensionPointSimple"
            label: "Simple Object Extension Point"
            objectDescriptor: {
                mvvmType: "extension"
                description: "Simple (non-recurring) extension point."
                archetype: {
                    jsonTag: "extensionA"
                    label: "Subcomponent A"
                    objectDescriptor: {
                        mvvmType: "archetype"
                        description: "This is an instance of trivial subcomponent A"
                        namespaceDescriptor: {
                            userImmutable: {
                                uuid: {
                                    type: "uuid"
                                    fnCreate: -> uuid.v4()
                                    fnReinitialize: undefined
                                } # uuid
                            } # userImmutable
                        } # namespaceDescriptor
                    } # objectDescriptor
                } # archetype
            } # extensionPointA objectDescriptor
        } # extensionPointSimple object
        {
            jsonTag: "extensionPointB"
            label: "Recurring Object Extension Point"
            objectDescriptor: {
                mvvmType: "extension"
                description: "This is a more complex extension point that allows recursive extension of this component."
                archetype: {
                    jsonTag: "recursiveObject"
                    label: "Recursive Object"
                    objectDescriptor: {
                        mvvmType: "archetype"
                        description: "This object contains an extension point extended by instances of itself."
                        namespaceDescriptor: {
                            userImmutable: {
                                uuid: {
                                    type: "uuid"
                                    fnCreate: -> uuid.v4()
                                    fnReinitialize: undefined
                                } # uuid
                            } # userImmutable
                        } # namespaceDescriptor
                    } # objectDescriptor
                    subMenus: [
                        {
                            jsonTag: "extensionPointC"
                            label: "Extension Point"
                            objectDescriptor: {
                                mvvmType: "extension"
                                description: "This extension point is extended by new instances of Recursive Object"
                                archetypeReference: "schema.omm.extensionPointB.recursiveObject"
                            }
                        }
                    ]
                } # archetype
            } # objectDescriptor
        } # extensionPointB object
    ] # omm (child) subMenus
} # omm (child) object
