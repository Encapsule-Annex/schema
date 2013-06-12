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
# encapsule-lib-omm-object-store-selector.coffee
#
# OMM stands for Object Model Manager


namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.omm = Encapsule.code.lib.omm? and Encapsule.code.lib.omm or @Encapsule.code.lib.omm = {}

class Encapsule.code.lib.omm.ObjectStoreNamespaceSelector
    constructor: (objectStore_, objectNamespaceSelector_) ->
        try
            if not (objectStore_? and objectStore_) then throw "Missing object store input parameter!"
            if not (objectNamespaceSelector_? and objectNamespaceSelector_) then throw "Missing object namespace selector input parameter!"

            # Keep references to this store namespace selector's backing store and model namespace selector objects.
            @objectStore = objectStore_
            @objectNamespaceSelector = objectNamespaceSelector_



        catch exception
            throw "Encapsule.code.lib.omm.ObjectStoreSelector constructor failed: #{exception}"



