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
# schema-scdl-navigator-window-layout-machine.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
Encapsule.code.app.ONMjs = Encapsule.code.app.ONMjs? and Encapsule.code.app.ONMjs or Encapsule.code.app.ONMjs = {}

Encapsule.code.app.ONMjs.SchemaAppDataTypeArchetype = {
    namespaceType: "component"                                                                    
    jsonTag: "type"
    label: "Type"
    description: "SCDL type model."
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
                fnReinitialize: ->  Encapsule.code.lib.util.uuidNull
            }
            platformBinding: {
                type: "uuid"
                fnCreate: -> Encapsule.code.lib.util.uuidNull
                fnReinitialize: -> Encapsule.code.lib.util.uuidNull
            }
        } # type userMutable
    } # type namespaceDescriptor

} # SchemaAppDataTypeArchetype
