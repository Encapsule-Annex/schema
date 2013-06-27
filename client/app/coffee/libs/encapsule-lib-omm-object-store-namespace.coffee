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
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.omm = Encapsule.code.lib.omm? and Encapsule.code.lib.omm or @Encapsule.code.lib.omm = {}

Encapsule.code.lib.omm.implementation = Encapsule.code.lib.omm.implementation? and Encapsule.code.lib.omm.implementation or @Encapsule.code.lib.omm.implementation = {}


# An ObjectStoreNamespace represents an addressed sub-object within an ObjectStore instance
# specified by its objectModelNamespaceSelector.


class Encapsule.code.lib.omm.ObjectStoreNamespace


    #
    # returns reference to raw object store data corresponding to specified descriptor, relative to specified
    # parent store namespace, and per specified mode.
    #

    internalResolveNamespaceDescriptor: (objectStoreReference_, objectModelDescriptor_, mode_, key_) =>
        try
            storeReference = undefined
            mode = mode_? and mode_ or "new"

            switch objectModelDescriptor_.mvvmType
                when "root"
                    storeReference = @objectStore.objectStore
                    break
                when "child"
                    storeReference = objectStoreReference_[objectModelDescriptor_.jsonTag]
                    if not (storeReference? and storeReference)
                        if mode == "new"
                            storeReference = objectStoreReference_[objectModelDescriptor_.jsonTag] = {}
                        else
                            throw "Strict mode binding failure: child namespace does not exist for '#{objectModelDescriptor_.jsonTag}'."
                    break
                when "extension"
                    storeReference = objectStoreReference_[objectModelDescriptor_.jsonTag]
                    if not (storeReference? and storeReference)
                        if mode == "new"
                            storeReference = objectStoreReference_[objectModelDescriptor_.jsonTag] = []
                        else
                            throw "Strict mode binding failure: extension namespace deos not exisit for '#{objectModelDescriptor_.jsonTag}'."
                    break
                when "archetype"
                    for elementObject in objectStoreReference_
                        # Should hey "hey - is this your key?"
                        namespace = elementObject[objectModelDescriptor_.jsonTag]
                        if namespace.uuid? and namespace.uuid and namespace.uuid == key_
                            storeReference = namespace
                            @resolvedKeyVector.push key_
                            break
                    if not (storeReference? and storeReference)
                        if mode == "new"
                            storeReference = {}
                            key_ = storeReference.uuid = uuid.v4()
                            objectReference = {}
                            objectReference[objectModelDescriptor_.jsonTag] = storeReference
                            objectStoreReference_.push objectReference
                            @resolvedKeyVector.push key_

                        else
                            throw "Strict mode binding failure: "
                    break
                else
                    throw "Unrecognized mvvmType \"#{objectModelDescriptor.mvvmType}\"!"
            if not (storeReference? and storeReference)
                throw "Cannot resolve store reference!"
            return storeReference
        catch exception
            throw "Encapsule.code.lib.omm.ObjectStoreNamespace.internalResolveNamespaceDescriptor failure: '#{exception}'"


    getObjectModelNamespaceSelector: =>
        objectModelNamespaceSelector = @objectStore.objectModel.createNamespaceSelectorFromPathId(@pathId, @resolvedKeyVector)
        return objectModelNamespaceSelector

    constructor: (objectStore_, objectModelNamespaceSelector_, mode_) ->
        try
            if not (objectStore_? and objectStore_) then throw "Missing object store input parameter!"
            if not (objectModelNamespaceSelector_? and objectModelNamespaceSelector_) then throw "Missing object model namespace selector input parameter!"

            mode = mode_? and mode_ or "strict"

            # Save references to this namespace's backing object store and object model descriptor.
            @objectStore = objectStore_ # reference to ObjectStore instance
            @pathId = objectModelNamespaceSelector_.pathId 
            @resolvedKeyVector = []

            # STORE REFERENCE
            @objectStoreNamespace = undefined # reference to specific namespace within the object store

            # Obtain the target namespace's object model descriptor from the namespace selector.
            objectModelDescriptor = objectStore_.objectModel.objectModelDescriptorById[objectModelNamespaceSelector_.pathId]

            # Prepare to resolve parent namespaces.
            objectModel = objectStore_.objectModel # alias
            extensionPointIndex = 0
            objectStoreReference = undefined

            # Resolve parent namespaces.
            for parentPathId in objectModelDescriptor.parentPathIdVector
                key = undefined
                parentObjectModelDescriptor = objectModel.objectModelDescriptorById[parentPathId]
                if parentObjectModelDescriptor.mvvmType == "archetype"
                    key = objectModelNamespaceSelector_.getSelectKey(extensionPointIndex++)
                objectStoreReference = @internalResolveNamespaceDescriptor(objectStoreReference, parentObjectModelDescriptor, mode, key)

            if not (objectStoreReference? and objectStoreReference)
                throw "Unable to resolve parent namespace(s)"

            # Resolve this namespace.
            key = undefined
            if objectModelDescriptor.mvvmType == "archetype"
                key = objectModelNamespaceSelector_.getSelectKey(extensionPointIndex++)

            @objectStoreNamespace = @internalResolveNamespaceDescriptor(objectStoreReference, objectModelDescriptor, mode, key)



        catch exception
            throw "Encapsule.code.lib.omm.ObjectStoreNamespace constructor failed: #{exception}"




