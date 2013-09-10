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
Encapsule.code.app.modelview = Encapsule.code.app.modelview? and Encapsule.code.app.modelview or Encapsule.code.app.modelview = {}

# This object is referenced within an Encapsule Navigator 'layout declarartion'.
# e.g. item.objectDescriptor.namespaceDescriptor.userImmutable = Encapsule.code.app.modelview.ScdlNamespaceCommonMeta 

Encapsule.code.app.modelview.ScdlNamespaceCommonMeta = {
    uuid: {
        type: "uuid"
        fnCreate: -> uuid.v4()
        fnReinitialize: undefined
    }
    uuidRevision: {
        type: "uuid"
        fnCreate: -> uuid.v4()
        fnReinitialize: -> uuid.v4()
    }
    revision: {
        type: "revision"
        fnCreate: -> 0
        fnReinitialize: -> 0
    }
    createTime: {
        type: "epochTime"
        fnCreate: -> Encapsule.code.lib.util.getEpochTime()
        fnReinitialize: Encapsule.code.lib.util.getEpochTime()
    }
    updateTime: {
        type: "epochTime"
        fnCreate: -> Encapsule.code.lib.util.getEpochTime()
        fnReinitialize: -> Encapsule.code.lib.util.getEpochTime()
    }
}



Encapsule.code.app.modelview.ScdlModelUserMutableNamespaceProperties = {
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
        optional: true
        fnCreate: -> undefined
        fnReinitialize: undefined
    }
}