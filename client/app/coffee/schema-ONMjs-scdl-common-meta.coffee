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
# schema-navigator-scdl-namespace-common-meta.coffee
#
# Shared namespace descriptor for common SCDL object properties
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
Encapsule.code.app.ONMjs = Encapsule.code.app.ONMjs? and Encapsule.code.app.ONMjs or Encapsule.code.app.ONMjs = {}

# This object is referenced within an Encapsule Navigator 'layout declarartion'.
# e.g. item.objectDescriptor.namespaceDescriptor.userImmutable = Encapsule.code.app.ONMjs.SchemaAppDataNamespaceCommonProperties 

Encapsule.code.app.ONMjs.SchemaAppDataNamespaceCommonProperties = {
    uuid: {
        ____type: "uuid"
        fnCreate: -> uuid.v4()
    }
    uuidRevision: {
        ____type: "uuid"
        fnCreate: -> uuid.v4()
    }
    revision: {
        ____type: "revision"
        fnCreate: -> 0
    }
    createTime: {
        ____type: "epochTime"
        fnCreate: -> Encapsule.code.lib.util.getEpochTime()
    }
    updateTime: {
        ____type: "epochTime"
        fnCreate: -> Encapsule.code.lib.util.getEpochTime()
    }
}



Encapsule.code.app.ONMjs.ScdlModelUserMutableNamespaceProperties = {
    name: {
        ____type: "string"
        fnCreate: -> ""
    }
    description: {
        ____type: "string"
        fnCreate: -> ""
    }
    tags: {
        ____type: "stringCSV"
        fnCreate: -> ""
    }
    author: {
        ____type: "uuidSelection"
        ____selectionSource: "schema.catalogues.catalogue.assets.people"
        fnCreate: -> Encapsule.code.lib.util.uuidNull
    }
    organization: {
        ____type: "uuidSelection"
        ____selectionSource: "schema.catalogues.catalogue.assets.organizations"
        fnCreate: -> Encapsule.code.lib.util.uuidNull
    }
    copyright: {
        ____type: "uuidSelection"
        ____selectionSource: "schema.catalogues.catalogue.assets.copyrights"
        fnCreate: -> Encapsule.code.lib.util.uuidNull
    }
    license: {
        ____type: "uuidSelection"
        ____selectionSource: "schema.catalogues.catalogue.assets.licenses"
        fnCreate: -> Encapsule.code.lib.util.uuidNull
    }
    platformBinding: {
        ____type: "uuid"
        ____optional: true
        fnCreate: -> undefined
    }
}