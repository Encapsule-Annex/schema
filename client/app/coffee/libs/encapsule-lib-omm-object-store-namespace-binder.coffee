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
# encapsule-lib-omm-object-store-namespace.coffee
#
# OMM stands for Object Model Manager


namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.omm = Encapsule.code.lib.omm? and Encapsule.code.lib.omm or @Encapsule.code.lib.omm = {}
Encapsule.code.lib.omm.implementation = Encapsule.code.lib.omm.implementation? and Encapsule.code.lib.omm.implementation or @Encapsule.code.lib.omm.implementation = {}



# are these actually BINDERS?

#
# ****************************************************************************
class Encapsule.code.lib.omm.ObjectStoreNamespaceBinder
    constructor: (objectStore_, objectModelDescriptor_) ->
        try
            if not (objectStore_? and objectStore_) then throw "Missing object store input parameter!"
            if not (objectModelDescriptor_? and objectModelDescriptor_) then throw "Missing object model descriptor input parameter."

            # Keep references to this namespace's backing store.
            @objectStore = objectStore_
            @objectModelDescriptor = objectModelDescriptor_

            @keysRequiredToBind = objectModelDescriptor_.pathResolveExtensionPoints.length


            # A reference to the actual namespace storage owned by the object store.
            @dataReference = undefined

            # Returns a new Encapsule.code.lib.omm.ObjectStoreNamespaceInstance object.

            @bind = (objectModelNamespaceSelector_) =>
                try
                    if not (objectModelNamespaceSelector_? and objectModelNamespaceSelector_) then throw "Missing object model namespace selector input parameter!"

                    newStoreNamespace = new Encapsule.code.lib.omm.ObjectStoreNamespace(@, objectModelNamespaceSelector_)

                    return newStoreNamespace

                catch exception
                    throw "Encapsule.code.lib.omm.ObjectStoreNamespace.bind failed: #{exception}"


        catch exception
            throw "Encapsule.code.lib.omm.ObjectStoreNamespaceBinder constructor failed: #{exception}"

