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


class Encapsule.code.lib.omm.Namespace
    constructor: (objectStore_, address_, mode_) ->
        try
            if not (objectStore_? and objectStore_) then throw "Missing object store input parameter."

            # As a matter of policy, if no address is specified or if a zero-length address is specified, open the root namespace.
            address = undefined
            if not (address_? and address_ and address_.tokenVector.length)
                objectModel = objectStore_.objectModel
                address = new Encapsule.code.lib.omm.Address(objectModel, [ new Encapsule.code.lib.omm.AddressToken(objectModel, undefined, undefined, 0) ] )
            else
                address = address_
            

            # Ensure that the select key vector and object store were both created using the same object model.
            objectModelNameStore = objectStore_.objectModel.jsonTag
            objectModelNameKeys = address.objectModel.jsonTag
            if objectModelNameStore != objectModelNameKeys
                throw "You cannot create a '#{objectModelNameStore}' store namespace with a '#{objectModelNameKeys}' select key vector."

            # First select key in the vector specifies a root component namespace?
            if not address.rooted then throw "Specified address is invalid because the first address token does not specify the object store's root component."

            mode = mode_? and mode_ or "bypass"

            if (mode != "new") and address.keysRequired and not address.keysSpecified
                throw "Specified address is invalid because it is not fully-qualified and the mode flag is #{mode} (i.e. not new)."

            # The actual store data.
            @dataReferences = []
            dataReference = objectStore_.dataReference? and objectStore_.dataReference or throw "Cannot resolve object store's root data reference."
            @dataReferences.push dataReference
            
            @addressTokenBinders = for addressToken in address.tokenVector
                tokenBinder = new Encapsule.code.lib.omm.implementation.AddressTokenBinder(objectStore_, dataReference, addressToken, mode)
                dataReference = tokenBinder.dataReference
                @dataReferences.push dataReference
                tokenBinder

            

        catch exception
            throw "Encapsule.code.lib.omm.Namespace failure: #{exception}"



