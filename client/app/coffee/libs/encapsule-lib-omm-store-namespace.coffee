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
    internalResolveNamespaceDescriptor: (objectStoreReference_, objectModelDescriptor_, mode_, key_, isSecondaryKey_) =>
        try
            #Console.message("ObjectStoreNamespace.internalResolveNamespaceDescriptor path='#{objectModelDescriptor_.path}'")
            #Console.message("... mode='#{mode_}'")
            #Console.message("... key='" + (key_? and key_ or "undefined") + "'")

            if not (objectModelDescriptor_? and objectModelDescriptor_) then throw "Missing required object model descriptor input parameter!"
            if not (mode_? and mode_) then throw "Missing required mode input parameter value!"
            isSecondaryKey = isSecondaryKey_? and isSecondaryKey_ or false

            storeReference = undefined
            semanticBindings = @objectStore.objectModel.getSemanticBindings() # local convenience alias

            switch objectModelDescriptor_.mvvmType
                when "root"
                    if not (@objectStore.objectStore? and @objectStore.objectStore)
                        throw "Error - root object store is undefined."
                    storeReference = @objectStore.objectStore
                    switch mode_
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
                    switch mode_
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
                    switch mode_
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
                            namespaceKey = semanticBindings.getUniqueKey(namespace)
                        
                            if namespaceKey == key_
                                storeReference = namespace
                                if not isSecondaryKey
                                    @resolvedKeyVector.push key_
                                    @resolvedKeyIndexVector.push index
                                else
                                    @secondaryResolvedKeyVector.push key_
                                    @secondaryResolvedIndexVector.push index
                                break

                            index++
                            # / END: for
                       # / END: if key_? and key

                    # Now decide what to do based on the mode
                    switch mode_
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
                            key_ = semanticBindings.getUniqueKey(storeReference)
                            if not (key_? and key_)
                                throw "Component does not correctly initialize its root namespace. Unable to obtain unique ID for new component."
                            objectReference = {}
                            objectReference[objectModelDescriptor_.jsonTag] = storeReference
                            objectStoreReference_.push objectReference
                            if not isSecondaryKey
                                @resolvedKeyVector.push key_
                                @resolvedKeyIndexVector.push @resolvedKeyVector.length - 1
                            else
                                @secondaryResolvedKeyVector.push key_
                                @secondaryResolvedIndexVector.push @secondaryResolvedKeyVector.length - 1

                            # Create this component's constituent namespace(s)

                            secondaryKeyVector = []
                            index = 0
                            while index < @secondaryExtensionPointPathIdVector.length
                                secondaryKeyVector.push {
                                    idExtensionPoint: @secondaryExtensionPointPathIdVector[index]
                                    selectKey: @secondaryResolvedKeyVector[index]
                                }
                                index++

                            componentSelector = @objectStore.objectModel.createNamespaceSelectorFromPathId(objectModelDescriptor_.id, @resolvedKeyVector, secondaryKeyVector)


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
    toJSON: (replacer_, space_) =>
        try
            selector = @getResolvedSelector()
            resultObject = {}
            resultObject[selector.objectModelDescriptor.jsonTag] = @objectStoreNamespace
            space = space_? and space_ or 0
            resultJSON = JSON.stringify(resultObject, replacer_, space)
            if not (resultJSON? and resultJSON)
                throw "Cannot serialize Javascript object to JSON!"
            return resultJSON

         catch exception
            throw "Encapsule.code.lib.omm.ObjectStoreNamespace.toJSON fail on object store #{@jsonTag} : #{exception}"


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
    # class Encapsule.code.lib.omm.ObjectStoreNamespace.getResolvedLabel
    # Returns the most descriptive label string for the namespace by considering multiple
    # sources in order of priority.
    getResolvedLabel: =>

        if @objectModelDescriptor.id == 0
            return "#{@objectModelDescriptor.label}"

        if @objectStoreNamespace.name? and @objectStoreNamespace.name and @objectStoreNamespace.name.length
            return "#{objectModelDescriptor.label} #{@objectStoreNamespace.name}"

        key = @objectStore.objectModel.getSemanticBindings().getUniqueKey(@objectStoreNamespace)
        if key? and key
            return "#{@objectModelDescriptor.label} #{key}"

        return "#{@objectModelDescriptor.label}"

        

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

            # TODO: This check was put in place hunting down a subtle bug in namespace selectors.
            # Investigate this further to ensure that hitting this condition is expected (I believe yes).
            if mode_ == "new" and objectModelNamespaceSelector_.selectKeysRequired and objectModelNamespaceSelector_.selectKeysReady
                Console.message("hey there!")


            @objectStore = objectStore_ # reference to ObjectStore instance
            @pathId = objectModelNamespaceSelector_.pathId 

            @resolvedKeyVector = []
            @resolvedKeyIndexVector = []

            @secondaryExtensionPointPathIdVector = []
            @secondaryResolvedKeyVector = []
            @secondaryResolvedIndexVector = []

            # STORE NAMESPACE DATA REFERENCE
            @objectStoreNamespace = undefined

            # Obtain the target namespace's object model descriptor from the namespace selector.
            @objectModelDescriptor = objectStore_.objectModel.getNamespaceDescriptorFromPathId(objectModelNamespaceSelector_.pathId)

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
                objectStoreReference = @internalResolveNamespaceDescriptor(objectStoreReference, parentObjectModelDescriptor, mode, key, false) # process primary key

            if @objectModelDescriptor.parentPathIdVector.length and not (objectStoreReference? and objectStoreReference)
                throw "Unable to resolve parent namespace(s)"

            # Resolve this namespace.
            key = undefined
            if @objectModelDescriptor.mvvmType == "archetype"
                if not ((mode_ == "new") and (objectModelNamespaceSelector_.selectKeysRequired == extensionPointIndex))
                    key = objectModelNamespaceSelector_.getSelectKey(extensionPointIndex)
                extensionPointIndex++

            objectStoreReference = @internalResolveNamespaceDescriptor(objectStoreReference, @objectModelDescriptor, mode, key, false) # process primary key

            # At this point we're in one of two states:
            # Resolved to the parent of the requested namespace OR resolved to the base component of a recursive hierarchy.
            # Which depends on if there's a secondary select key vector or not.

            for selectObject in objectModelNamespaceSelector_.secondaryKeyVector

                extensionPointDescriptor = objectStore_.objectModel.getNamespaceDescriptorFromPathId(selectObject.idExtensionPoint)
                extensionPointHeightOverBase = extensionPointDescriptor.parentPathIdVector.length - @objectModelDescriptor.parentPathIdVector.length

                parentPathIdsYetToResolve = extensionPointDescriptor.parentPathIdVector.slice(
                    extensionPointDescriptor.parentPathIdVector.length - extensionPointHeightOverBase, extensionPointHeightOverBase - 1)

                for parentPathId in parentPathIdsYetToResolve
                    parentObjectModelDescriptor = objectModel.objectModelDescriptorById[parentPathId]
                    objectStoreReference = @internalResolveNamespaceDescriptor(objectStoreReference, parentObjectModelDescriptor, mode, undefined, false) # keys not involved within a component

                # Now resolve the parent extension point.
                objectStoreReference = @internalResolveNamespaceDescriptor(objectStoreReference, extensionPointDescriptor, mode, undefined, false) # keys not involved within component

                # Finally resolve the contained recursively declared component.
                @secondaryExtensionPointPathIdVector.push extensionPointDescriptor.id
                objectStoreReference = @internalResolveNamespaceDescriptor(objectStoreReference, @objectModelDescriptor, mode, selectObject.selectKey, true) # process secondary key

            if not (objectStoreReference? and objectStoreReference)
                throw "Unable to instantiate object store namespace."

            if objectModelNamespaceSelector_.selectKeysRequired != @resolvedKeyVector.length
                throw "Internal select key resolution error!"

            @objectStoreNamespace = objectStoreReference

        catch exception
            throw "Encapsule.code.lib.omm.ObjectStoreNamespace constructor failed: #{exception}"
