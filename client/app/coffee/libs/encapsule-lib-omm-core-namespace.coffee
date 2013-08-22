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
# encapsule-lib-omm-core-namespace.coffee
#


namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.omm = Encapsule.code.lib.omm? and Encapsule.code.lib.omm or @Encapsule.code.lib.omm = {}
Encapsule.code.lib.omm.core = Encapsule.code.lib.omm.core? and Encapsule.code.lib.omm.core or @Encapsule.code.lib.omm.core = {}


class Encapsule.code.lib.omm.ObjectStoreNamespace2
    constructor: (objectStore_, selectKeyVector_, mode_) ->
        try
            if not (objectStore_? and objectStore_)
                throw "Missing object store input parameter."

            if not (selectKeyVector_? and selectKeyVector_ and selectKeyVector_.selectKeyVector.length)
                throw "Missing or zero-length object model select key vector input parameter."

            # Ensure that the select key vector and object store were both created using the same object model.
            objectModelNameStore = objectStore_.objectModel.jsonTag
            objectModelNameKeys = selectKeyVector_.objectModel.jsonTag
            if objectModelNameStore != objectModelNameKeys
                throw "You cannot create a '#{objectModelNameStore}' store namespace with a '#{objectModelNameKeys}' select key vector."

            # First select key in the vector specifies a root component namespace?
            if not selectKeyVector_.rooted
                throw "Sorry. You can only resolve rooted select key vectors currently."

            mode = mode_? and mode_ or "bypass"

            if (mode != "new") and selectKeyVector_.keysRequired and not selectKeyVector_.keysSpecified
                throw "The specified select key vector does not resolve to an existing store namespace."

            # The actual store data.

            @dataReference = objectStore_.dataReference? and objectStore_.dataReference or objectStore_.dataReference = {}
            @resolvedSelectKey = undefined

            @resolvedSelectKeys = []

            for selectKey in selectKeyVector_.selectKeyVector
                @resolvedSelectKey = new Encapsule.code.lib.omm.ObjectStoreNamespaceResolver(objectStore_, @dataReference, selectKey, mode)
                @dataReference = @resolvedSelectKey.dataReference
                @resolvedSelectKeys.push @resolvedSelectKey


        catch exception
            throw "Encapsule.code.lib.omm.ObjectStoreNamespace2 failure: #{exception}"



