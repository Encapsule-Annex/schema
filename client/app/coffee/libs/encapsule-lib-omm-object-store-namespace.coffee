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

    internalInitializeNamespaceMembers: (storeReference_, namespaceDescriptor_) ->
        try
            if not (storeReference_? and storeReference_ and namespaceDescriptor_? and namespaceDescriptor_)
                return

            if namespaceDescriptor_.userImmutable? and namespaceDescriptor_.userImmutable
                for memberName, functions of namespaceDescriptor_.userImmutable
                    if functions.fnCreate? and functions.fnCreate
                        storeReference_[memberName] = functions.fnCreate()

            if namespaceDescriptor_.userMutable? and namespaceDescriptor_.userMutable
                for memberName, functions of namespaceDescriptor_.userMutable
                    if functions.fnCreate? and functions.fnCreate
                        storeReference_[memberName] = functions.fnCreate()

        catch exception
            throw "Encapsule.code.lib.omm.ObjectStoreNamespace.internalInitializeNamespaceMembers failure '#{exception}'."

    internalVerifyNamespaceMembers: (storeReference_, namespaceDescriptor_) ->
        try
            if not (storeReference_? and storeReference_ and namespaceDescriptor_? and namespaceDescriptor_)
                return
           
            if namespaceDescriptor_.userImmutable? and namespaceDescriptor_.userImmutable
                for memberName, functions of namespaceDescriptor_.userImmutable
                    memberReference = storeReference_[memberName]
                    if not memberReference?
                        throw "Expected immutable member '#{memberName}' not found."

            if namespaceDescriptor_.userMutable? and namespaceDescriptor_.userMutable
                for memberName, functions of namespaceDescriptor_.userMutable
                    memberReference = storeReference_[memberName]
                    if not memberReference?
                        throw "Expected mutable member '#{memberName}' not found."

        catch exception
            throw "Encapsule.code.lib.omm.ObjectStoreNamespace.internalVerifyNamespaceMembers failure '#{exception}'."


    # 

    internalResolveNamespaceDescriptor: (objectStoreReference_, objectModelDescriptor_, mode_, key_) =>
        try
            storeReference = undefined

            if not (mode_? and mode_) then throw "Missing required mode input parameter value!"
            mode = mode_

            switch objectModelDescriptor_.mvvmType
                when "root"
                    storeReference = @objectStore.objectStore
                    switch mode
                        when "bypass"
                            break
                        when "new"
                            @internalInitializeNamespaceMembers(storeReference, objectModelDescriptor_.namespaceDescriptor)
                            break
                        when "strict"
                            @internalVerifyNamespaceMembers(storeReference, objectModelDescriptor_.namespaceDescriptor)
                            break
                        else
                            throw "Unrecognized mode for MVVM type."
                    break


                when "child"
                    storeReference = objectStoreReference_[objectModelDescriptor_.jsonTag]
                    switch mode
                        when "bypass"
                            break
                        when "new"
                            if not (storeReference? and storeReference)
                                storeReference = objectStoreReference_[objectModelDescriptor_.jsonTag] = {}
                            @internalInitializeNamespaceMembers(storeReference, objectModelDescriptor_.namespaceDescriptor)
                            break
                        when "strict"
                            @internalVerifyNamespaceMembers(storeReference, objectModelDescriptor_.namespaceDescriptor)
                            break
                        else
                            throw "Unrecognized mode for MVVM type."
                    break


                when "extension"
                    storeReference = objectStoreReference_[objectModelDescriptor_.jsonTag]
                    switch mode
                        when "bypass"
                            break
                        when "new"
                            if not (storeReference? and storeReference)
                                storeReference = objectStoreReference_[objectModelDescriptor_.jsonTag] = []
                            break
                        when "strict"
                            break
                        else
                            throw "Unrecognized mode for MVVM type."
                    break


                when "archetype"

                    if mode == "new"
                        storeReference = {}
                        @internalInitializeNamespaceMembers(storeReference, objectModelDescriptor_.namespaceDescriptor)
                        key_ = storeReference.uuid
                        objectReference = {}
                        objectReference[objectModelDescriptor_.jsonTag] = storeReference
                        objectStoreReference_.push objectReference
                        @resolvedKeyVector.push key_
                    else
                        # mode != "new" means we search for our archetype by its key.
                        for elementObject in objectStoreReference_
                            # Should hey "hey - is this your key?"
                            namespace = elementObject[objectModelDescriptor_.jsonTag]
                            if namespace.uuid? and namespace.uuid and namespace.uuid == key_
                                storeReference = namespace
                                @resolvedKeyVector.push key_
                                break
                        switch mode
                            when "bypass"
                                break
                            when "strict"
                                @internalVerifyNamespaceMembers(storeReference, objectModelDescriptor_.namespaceDescriptor)
                                break
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

            if mode == "strict" and not objectModelNamespaceSelector_.selectKeysReady
                throw "Object model selector extension key vector is incomplete. Cannot create object store namespace instance."

            # Save references to this namespace's backing object store and object model descriptor.
            @objectStore = objectStore_ # reference to ObjectStore instance
            @pathId = objectModelNamespaceSelector_.pathId 
            @resolvedKeyVector = []

            # STORE REFERENCE
            @objectStoreNamespace = undefined # reference to specific namespace within the object store

            # Obtain the target namespace's object model descriptor from the namespace selector.
            @objectModelDescriptor = objectStore_.objectModel.objectModelDescriptorById[objectModelNamespaceSelector_.pathId]

            # Prepare to resolve parent namespaces.
            objectModel = objectStore_.objectModel # alias
            extensionPointIndex = 0
            objectStoreReference = undefined

            # Resolve parent namespaces.
            for parentPathId in @objectModelDescriptor.parentPathIdVector
                key = undefined
                parentObjectModelDescriptor = objectModel.objectModelDescriptorById[parentPathId]
                if parentObjectModelDescriptor.mvvmType == "archetype"
                    key = objectModelNamespaceSelector_.getSelectKey(extensionPointIndex++)
                objectStoreReference = @internalResolveNamespaceDescriptor(objectStoreReference, parentObjectModelDescriptor, mode, key)

            if not (objectStoreReference? and objectStoreReference)
                throw "Unable to resolve parent namespace(s)"

            # Resolve this namespace.
            key = undefined
            if @objectModelDescriptor.mvvmType == "archetype"
                key = objectModelNamespaceSelector_.getSelectKey(extensionPointIndex++)

            @objectStoreNamespace = @internalResolveNamespaceDescriptor(objectStoreReference, @objectModelDescriptor, mode, key)

            if not (@objectStoreNamespace? and @objectStoreNamespace)
                throw "Unable to instantiate object store namespace."

        catch exception
            throw "Encapsule.code.lib.omm.ObjectStoreNamespace constructor failed: #{exception}"




