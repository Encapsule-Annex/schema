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

    #
    # ============================================================================
    # class Encapsule.code.lib.omm.ObjectStoreNamespace
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

    #
    # ============================================================================
    # class Encapsule.code.lib.omm.ObjectStoreNamespace
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
    # ============================================================================
    # class Encapsule.code.lib.omm.ObjectStoreNamespace
    internalResolveNamespaceDescriptor: (objectStoreReference_, objectModelDescriptor_, mode_, key_) =>
        try
            #Console.message("ObjectStoreNamespace.internalResolveNamespaceDescriptor path='#{objectModelDescriptor_.path}'")
            #Console.message("... mode='#{mode_}'")
            #Console.message("... key='" + (key_? and key_ or "undefined") + "'")

            storeReference = undefined

            if not (mode_? and mode_) then throw "Missing required mode input parameter value!"
            mode = mode_

            switch objectModelDescriptor_.mvvmType
                when "root"
                    if not (@objectStore.objectStore? and @objectStore.objectStore)
                        throw "Error - root object store is undefined."
                    storeReference = @objectStore.objectStore
                    switch mode
                        when "bypass"
                            if not (storeReference? and storeReference)
                                throw "Error - unable to resolve root namespace."
                        when "new"
                            @internalInitializeNamespaceMembers(storeReference, objectModelDescriptor_.namespaceDescriptor)
                            break
                        when "strict"
                            if not (storeReference? and storeReference)
                                throw "Error - unable to resolve root namespace."
                            @internalVerifyNamespaceMembers(storeReference, objectModelDescriptor_.namespaceDescriptor)
                            break
                        else
                            throw "Unrecognized mode for MVVM type."
                    break


                when "child"
                    if not (objectStoreReference_? and objectStoreReference_)
                        throw "Error - no parent namespace provided to resolve child namespace!"
                    storeReference = objectStoreReference_[objectModelDescriptor_.jsonTag]
                    switch mode
                        when "bypass"
                            if not (storeReference? and storeReference)
                                throw "Error - unable to resolve child namespace."
                        when "new"
                            if not (storeReference? and storeReference)
                                storeReference = objectStoreReference_[objectModelDescriptor_.jsonTag] = {}
                            @internalInitializeNamespaceMembers(storeReference, objectModelDescriptor_.namespaceDescriptor)
                            break
                        when "strict"
                            if not (storeReference? and storeReference)
                                throw "Error - unable to resolve child namespace."
                            @internalVerifyNamespaceMembers(storeReference, objectModelDescriptor_.namespaceDescriptor)
                            break
                        else
                            throw "Unrecognized mode for MVVM type."
                    break


                when "extension"
                    storeReference = objectStoreReference_[objectModelDescriptor_.jsonTag]
                    switch mode
                        when "bypass"
                            if not (storeReference? and storeReference)
                                throw "Error - unable to resolve extension point namespace."
                        when "new"
                            if not (storeReference? and storeReference)
                                storeReference = objectStoreReference_[objectModelDescriptor_.jsonTag] = []
                            break
                        when "strict"
                            if not (storeReference? and storeReference)
                                throw "Error - unable to resolve extension point namespace."
                        else
                            throw "Unrecognized mode for MVVM type."
                    break


                when "archetype"

                    if storeReference? and storeReference
                        throw "Unexepcted storeReference should be undefined"

                    if key_? and key_
                        index = 0
                        for elementObject in objectStoreReference_
                            # Should hey "hey - is this your key?"

                            # Get namespace data actual
                            namespace = elementObject[objectModelDescriptor_.jsonTag]

                            # Get the namespace's key actual
                            namespaceKey = @objectStore.objectModel.getSemanticBindings().getUniqueKey(namespace)
                        
                            if namespaceKey == key_
                                storeReference = namespace
                                @resolvedKeyVector.push key_
                                @resolvedKeyIndexVector.push index
                                break

                            index++
                            # / END: for
                       # / END: if key_? and key

                    # Now decide what to do based on the mode
                    switch mode
                        when "bypass"
                            # "bypass" mode minimally ensures the existence of the storeReference
                            if not (storeReference? and storeReference)
                                throw "Error - unresolved store reference requested in bypass mode."
                            break
                        when "new"
                            # Create a new component iff we didn't resolve the key above.
                            if storeReference? and storeReference
                                break
                            storeReference = {}
                            @internalInitializeNamespaceMembers(storeReference, objectModelDescriptor_.namespaceDescriptor)
                            key_ = storeReference.uuid
                            objectReference = {}
                            objectReference[objectModelDescriptor_.jsonTag] = storeReference
                            objectStoreReference_.push objectReference
                            @resolvedKeyVector.push key_
                            @resolvedKeyIndexVector.push @resolvedKeyVector.length - 1
                            component = new Encapsule.code.lib.omm.ObjectStoreComponent(@objectStore, @resolvedKeyVector, objectModelDescriptor_.id, "new")
                            break
                        when "strict"
                            if not (storeReference? and storeReference)
                                throw "Error - unresolved store reference requested in strict mode."
                            @internalVerifyNamespaceMembers(storeReference, objectModelDescriptor_.namespaceDescriptor)
                            break
                        else
                            throw "Unrecognized MVVM type."

                    break
                else
                    throw "Unrecognized mvvmType \"#{objectModelDescriptor.mvvmType}\"!"
            if not (storeReference? and storeReference)
                throw "Cannot resolve store reference!"
            return storeReference
        catch exception
            throw "Encapsule.code.lib.omm.ObjectStoreNamespace.internalResolveNamespaceDescriptor failure for path='#{objectModelDescriptor_.path}' : '#{exception}'"



    #
    # ============================================================================
    # class Encapsule.code.lib.omm.ObjectStoreNamespace
    getResolvedSelector: =>
        try
            objectModelNamespaceSelector = @objectStore.objectModel.createNamespaceSelectorFromPathId(@pathId, @resolvedKeyVector)
            return objectModelNamespaceSelector
        catch exception
            throw "Encapsule.code.lib.omm.ObjectStoreNamespace.getResolvedSelector failure: #{exception}"

    #
    # ============================================================================
    # class Encapsule.code.lib.omm.ObjectStoreNamespace
    updateRevision: =>
        try
            # Many OM namespaces include associated revision numbers and/or revision timestamp information.
            # The OMM doesn't know or care precisely what any particular OM uses for a scheme but supports
            # generically a simple protocol that allows client code to grossly mark store namespaces as
            # "revised". Revision of a store namespace has the following semantics:
            #
            # The namespace store data is modified via a call to objectModelDeclaration.sementicBindings.update()
            # The revised namespace's parent namespace's are similarly modified via calls to objectModelDeclaration.semanticBindings.update()
            # onNamespaceUpdated for the revised namespace is called for each registered store observer.
            # onChildNamespaceUpdated for the revised namespace parents is called for each registered store observer.
            # onParentNamespaceUpdated for the revised namespace children is called for each registered store observer.
            #

            revisedNamespaceSelector = @getResolvedSelector()
            signalComponentUpdated = @objectModelDescriptor.isComponent
            semanticBindings = @objectStore.objectModel.getSemanticBindings()

            # Update this namespace's revision metadata.
            if semanticBindings? and semanticBindings and semanticBindings.update? and semanticBindings.update
                semanticBindings.update(@objectStoreNamespace)

            for observerId, modelViewObserver of @objectStore.modelViewObservers
                if modelViewObserver.onNamespaceUpdated? and modelViewObserver.onNamespaceUpdated
                    modelViewObserver.onNamespaceUpdated(@objectStore, observerId, revisedNamespaceSelector)
                if signalComponentUpdated
                    if modelViewObserver.onComponentUpdated? and modelViewObserver.onComponentUpdated
                        modelViewObserver.onComponentUpdated(@objectStore, observerId, revisedNamespaceSelector)

            parentPathIdsReverse = Encapsule.code.lib.js.clone @objectModelDescriptor.parentPathIdVector
            parentPathIdsReverse.reverse()

            for parentPathId in parentPathIdsReverse
                parentSelector = @objectStore.objectModel.createNamespaceSelectorFromPathId(parentPathId, revisedNamespaceSelector.selectKeyVector)
                parentNamespace = new Encapsule.code.lib.omm.ObjectStoreNamespace(@objectStore, parentSelector)

                # Update the parent namespace's revision metadata.
                if semanticBindings? and semanticBindings and semanticBindings.update? and semanticBindings.update
                    semanticBindings.update(parentNamespace.objectStoreNamespace)

                signalComponentUpdated = parentNamespace.objectModelDescriptor.isComponent

                for observerId, modelViewObserver of @objectStore.modelViewObservers
                    if modelViewObserver.onChildNamespaceUpdated? and modelViewObserver.onChildNamespaceUpdated
                        modelViewObserver.onChildNamespaceUpdated(@objectStore, observerId, parentSelector)
                    if signalComponentUpdated
                        if modelViewObserver.onChildComponentUpdated? and modelViewObserver.onChildComponentUpdated
                            modelViewObserver.onChildComponentUpdated(@objectStore_, observerId, parentSelector)

            if not (@objectModelDescriptor.mvvmType == "extension")
                for childNamespaceDescriptor in @objectModelDescriptor.children
                    childSelector = @objectStore.objectModel.createNamespaceSelectorFromPathId(childNamespaceDescriptor.id, revisedNamespaceSelector.selectKeyVector)
                    for observerId, modelViewObserver of @objectStore.modelViewObservers
                        if modelViewObserver.onParentNamespaceUpdated? and modelViewObserver.onParentNamespaceUpdated
                            modelViewObserver.onParentNamespaceUpdated(@objectStore, observerId, childSelector)

        catch exception
            throw "Encapsule.code.lib.omm.ObjectStoreNamespace.updateRevision failure: #{exception}"


    #
    # ============================================================================
    # class Encapsule.code.lib.omm.ObjectStoreNamespace.constructor
    # mode_ should be set to:
    #     "bypass" - no checking of extension keys. If the selector cannot be resolved, an error is thrown.
    #     "new" - create new extension keys as needed to complete the requested create operation.
    #     "strict" - verify the extension keys in the selector and throw an error on missing/unresolved keys in the store.
    #
    constructor: (objectStore_, objectModelNamespaceSelector_, mode_) ->
        try
            # Console.message("ObjectStoreNamespace constructor path='#{objectModelNamespaceSelector_.objectModelDescriptor.path}'")

            if not (objectStore_? and objectStore_) then throw "Missing object store input parameter!"
            if not (objectModelNamespaceSelector_? and objectModelNamespaceSelector_) then throw "Missing object model namespace selector input parameter!"
            objectModelNamespaceSelector_.internalVerifySelector()

            storeOM = objectStore_.objectModel.jsonTag
            selectorOM = objectModelNamespaceSelector_.objectModel.jsonTag
            if storeOM != selectorOM
                throw "You cannot use a '#{selectorOM}' selector to open a '#{storeOM}' namespace."

            mode = mode_? and mode_ or "bypass"

            if mode == "strict" and not objectModelNamespaceSelector_.selectKeysReady
                throw "Object model selector extension key vector is incomplete. Cannot create object store namespace instance."

            if mode_ == "new" and objectModelNamespaceSelector_.selectKeysRequired and objectModelNamespaceSelector_.selectKeysReady
                Console.message("hey there!")


            # Save references to this namespace's backing object store and object model descriptor.
            @objectStore = objectStore_ # reference to ObjectStore instance
            @pathId = objectModelNamespaceSelector_.pathId 
            @resolvedKeyVector = []
            @resolvedKeyIndexVector = []

            # STORE NAMESPACE DATA REFERENCE
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

            if @objectModelDescriptor.parentPathIdVector.length and not (objectStoreReference? and objectStoreReference)
                throw "Unable to resolve parent namespace(s)"

            # Resolve this namespace.
            key = undefined
            if @objectModelDescriptor.mvvmType == "archetype"
                if not ((mode_ == "new") and (objectModelNamespaceSelector_.selectKeyRequired == extensionPointIndex))
                    key = objectModelNamespaceSelector_.getSelectKey(extensionPointIndex)
                extensionPointIndex++

            @objectStoreNamespace = @internalResolveNamespaceDescriptor(objectStoreReference, @objectModelDescriptor, mode, key)

            if not (@objectStoreNamespace? and @objectStoreNamespace)
                throw "Unable to instantiate object store namespace."

            if objectModelNamespaceSelector_.selectKeysRequired != @resolvedKeyVector.length
                throw "Internal select key resolution error!"

        catch exception
            throw "Encapsule.code.lib.omm.ObjectStoreNamespace constructor failed: #{exception}"
