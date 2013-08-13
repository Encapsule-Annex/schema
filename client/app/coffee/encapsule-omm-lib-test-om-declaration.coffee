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
            userImmutable: {
                uuid: {
                    type: "uuid"
                    fnCreate: -> uuid.v4()
                    fnReinitialize: undefined
                } # uuid
            } # userImmutable
        } # namespaceDescriptor
    } # obejctDescriptor
    subMenus: [
        {
            jsonTag: "extensionPointA"
            label: "Extension Point A"
            objectDescriptor: {
                mvvmType: "extension"
                description: "This is a simple extension point that allows extension of this component by additional/removal of non-recursively-declared subobject(s)."
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
        } # extensionPointA object
        {
            jsonTag: "extensionPointB"
            label: "Extension Point B"
            objectDescriptor: {
                mvvmType: "extension"
                description: "This is a more complex extension point that allows recursive extension of this component."
                archetypeReference: "schema.omm"
            }
        } # extensionPointB object
    ] # omm (child) subMenus
} # omm (child) object
