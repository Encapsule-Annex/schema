###
------------------------------------------------------------------------------

The MIT License (MIT)

Copyright (c) 2013 Encapsule Project
  
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

**** Encapsule Project :: Build better software with circuit models ****

OPEN SOURCES: http://github.com/Encapsule HOMEPAGE: http://Encapsule.org
BLOG: http://blog.encapsule.org TWITTER: https://twitter.com/Encapsule

------------------------------------------------------------------------------



------------------------------------------------------------------------------

###
#
#
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.omm = Encapsule.code.lib.omm? and Encapsule.code.lib.omm or @Encapsule.code.lib.omm = {}
Encapsule.code.lib.omm.implementation = Encapsule.code.lib.omm.implementation? and Encapsule.code.lib.omm.implementation or @Encapsule.code.lib.omm.implementation = {}

ONMjs = Encapsule.code.lib.omm

#
# ****************************************************************************

class ONMjs.implementation.StoreReifier
    constructor: (objectStore_) ->
        try

            @objectStore = objectStore_

            # 
            # ============================================================================
            @internalReifyStoreComponent = (componentNamespaceSelector_, modelViewObject_, observerId_) =>
                try
                    componentNamespaceSelector_.internalVerifySelector()

                    # If broadcast (i.e. modelViewObject_ not specified or undefined) AND no observers then return.
                    if ( not (modelViewObserver_? and modelViewObserver_) ) and ( not Object.keys(@modelViewObservers).length )
                        return

                    # MODEL VIEW OBSERVER CALLBACK ORIGIN: onComponentCreated
                    # Invoke the model view object's onComponentCreate callback.
                    if modelViewObject_? and modelViewObject_
                        if (modelViewObject_.onComponentCreated? and modelViewObject_.onComponentCreated)
                            modelViewObject_.onComponentCreated(@, observerId_, componentNamespaceSelector_)
                    else
                        for observerId, modelViewObject of @modelViewObservers
                            if modelViewObject.onComponentCreated? and modelViewObject.onComponentCreated
                                modelViewObject.onComponentCreated(@, observerId, componentNamespaceSelector_)

                    # MODEL VIEW OBSERVER CALLBACK ORIGIN: onNamespaceCreate
                    # Invoke the model view object's onNamespaceCreate callback for each namespace in the root component.
                    for namespaceId in componentNamespaceSelector_.objectModelDescriptor.componentNamespaceIds
                        namespaceSelector = @objectModel.createNamespaceSelectorFromPathId(namespaceId, componentNamespaceSelector_.selectKeyVector, componentNamespaceSelector_.secondaryKeyVector)
                        if modelViewObject_? and modelViewObject_
                            if modelViewObject_.onNamespaceCreated? and modelViewObject_.onNamespaceCreated
                                modelViewObject_.onNamespaceCreated(@, observerId_, namespaceSelector)
                        else
                            for observerId, modelViewObject of @modelViewObservers
                                if modelViewObject.onNamespaceCreated? and modelViewObject.onNamespaceCreated
                                    modelViewObject.onNamespaceCreated(@, observerId, namespaceSelector)
                    true

                catch exception
                    throw "Encapsule.code.lib.omm.StoreBase.internalReifyStoreComponent failure: #{exception}"


            # 
            # ============================================================================
            @internalUnreifyStoreComponent = (componentNamespaceSelector_, modelViewObject_, observerId_) =>
                try
                    componentNamespaceSelector_.internalVerifySelector()

                    # If broadcast (i.e. modelViewObject_ not specified or undefined) AND no observers then return.
                    if ( not (modelViewObserver_? and modelViewObserver_) ) and ( not Object.keys(@modelViewObservers).length )
                        return

                    # MODEL VIEW OBSERVER CALLBACK ORIGIN: onNamespaceRemoved
                    # Invoke the model view object's onNamespaceRemoved callback for each namespace in the root component.
                    # (reverse order - children first, then parent(s))
                    componentNamespaceIdsReverse = Encapsule.code.lib.js.clone(componentNamespaceSelector_.objectModelDescriptor.componentNamespaceIds)
                    componentNamespaceIdsReverse.reverse()
                    for namespaceId in componentNamespaceIdsReverse
                        namespaceSelector = @objectModel.createNamespaceSelectorFromPathId(namespaceId, componentNamespaceSelector_.selectKeyVector, componentNamespaceSelector_.secondaryKeyVector)
                        if modelViewObject_? and modelViewObject_
                            if modelViewObject_.onNamespaceRemoved? and modelViewObject_.onNamespaceRemoved
                                modelViewObject_.onNamespaceRemoved(@, observerId_, namespaceSelector)
                        else
                            for observerId, modelViewObject of @modelViewObservers
                                if modelViewObject.onNamespaceRemoved? and modelViewObject.onNamespaceRemoved
                                    modelViewObject.onNamespaceRemoved(@, observerId, namespaceSelector)
                        @internalRemoveObserverNamespaceState(observerId, namespaceSelector)


                    # MODEL VIEW OBSERVER CALLBACK ORIGIN: onComponentRemoved
                    # Invoke the model view object's onComponentRemoved callback.
                    if modelViewObject_? and modelViewObject_
                        if modelViewObject_.onComponentRemoved? and modelViewObject_.onComponentRemoved
                            modelViewObject_.onComponentRemoved(@, observerId_, componentNamespaceSelector_)
                    else
                        for observerId, modelViewObject of @modelViewObservers
                            if modelViewObject.onComponentRemoved? and modelViewObject.onComponentRemoved
                                modelViewObject.onComponentRemoved(@, observerId, componentNamespaceSelector_)

                    @internalRemoveObserverNamespaceState(observerId, componentNamespaceSelector_)

                    true

                catch exception
                    throw "Encapsule.code.lib.omm.StoreBase.internalUnreifyStoreComponent failure: #{exception}"

            # 
            # ============================================================================
            @internalReifyStoreExtensions = (componentNamespaceSelector_, modelViewObject_, observerId_, undoFlag_) =>
                try
                    componentNamespaceSelector_.internalVerifySelector()

                    # undoFlag indicates that we should reverse a prior reification (e.g. in response to
                    # a component being removed from the store.
                    undoFlag = undoFlag_? and undoFlag_ or false

                    # Dereference the component's object model descriptor and find its extension points.
                    componentObjectModelDescriptor = componentNamespaceSelector_.objectModelDescriptor

                    if not componentObjectModelDescriptor.isComponent 
                        throw "Invalid namespace selector does not correspond to a component in this object model."

                    componentExtensionPointMap = componentNamespaceSelector_.objectModelDescriptor.extensionPoints

                    for path, namespaceDescriptor of componentExtensionPointMap

                        # Use the extension point's ID obtained from namespace descriptor to create an object model namespace selector for the extension point.
                        extensionPointSelector = @objectModel.createNamespaceSelectorFromPathId(namespaceDescriptor.id, componentNamespaceSelector_.selectKeyVector, componentNamespaceSelector_.secondaryKeyVector)

                        # Create a new store namespace object to gain access to the extension point array data.
                        extensionPointNamespace = new Encapsule.code.lib.omm.ObjectStoreNamespace(@, extensionPointSelector, "bypass")

                        extensionPointArray = extensionPointNamespace.objectStoreNamespace
                        if not (extensionPointArray.length?) then throw "Expected extension point array to support length property."

                        extensionJsonTag = namespaceDescriptor.children[0].jsonTag
                        extensionPath = "#{namespaceDescriptor.path}.#{extensionJsonTag}"
                        recursivelyDeclaredExtensionPoint = namespaceDescriptor.id > namespaceDescriptor.idArchetype

                        for component in extensionPointArray

                            subcomponentObject = component[extensionJsonTag]
                            subcomponentKey = @objectModel.getSemanticBindings().getUniqueKey(subcomponentObject)

                            subcomponentSelectKeyVector = undefined
                            subcomponentSecondaryKeyVector = undefined

                            if not recursivelyDeclaredExtensionPoint
                                subcomponentSelectKeyVector = Encapsule.code.lib.js.clone(componentNamespaceSelector_.selectKeyVector)
                                subcomponentSelectKeyVector.push subcomponentKey
                                subcomponentSecondaryKeyVector = []
                            else
                                subcomponentSelectKeyVector = componentNamespaceSelector_.selectKeyVector
                                subcomponentSecondaryKeyVector = Encapsule.code.lib.js.clone(componentNamespaceSelector_.secondaryKeyVector)
                                subcomponentSecondaryKeyVector.push({
                                    idExtensionPoint: namespaceDescriptor.id
                                    selectKey: subcomponentKey
                                    })

                            subcomponentNamespaceSelector = @objectModel.createNamespaceSelectorFromPath(extensionPath, subcomponentSelectKeyVector, subcomponentSecondaryKeyVector)

                            if not undoFlag
                                # Note that when we're reifying (i.e. reflecting the contents of the store out to the model view)
                                # that we proceed bottom-up (i.e. from root up towards leaves). The protocol is that namespaces are
                                # "created" parent-first and then the component is "created", and finally the component's 
                                # sub-components are evaluated until all leaf components have been processed and the entire branch
                                # or the store has been traversed.

                                # Reify the store subcomponent to the model view object.                                
                                @internalReifyStoreComponent(subcomponentNamespaceSelector, modelViewObject_, observerId_)

                                # *** RECURSION
                                @internalReifyStoreExtensions(subcomponentNamespaceSelector, modelViewObject_, observerId_, false)

                            else
                                # Note that when we're unreifying (i.e. undoing the a prior reification) that we proceed
                                # top-down (i.e. from the leaves down towards the root). Subcomponents are always evaluated 
                                # prior to their parent components. When a leaf component is discovered, it is "removed".
                                # The protocol is that the component is "removed" first, and then the namespaces are "removed"
                                # in the reverse order they were "created" during reification. Parent components are "removed"
                                # via the same protocol only after all their sub-components have been "removed" until the root
                                # component (which cannot be removed because it's not an extension) is reached.
                            
                                # *** RECURSION
                                @internalReifyStoreExtensions(subcomponentNamespaceSelector, modelViewObject_, observerId_, true)
                                
                                # Unreify the store subcomponent to the model view object.
                                @internalUnreifyStoreComponent(subcomponentNamespaceSelector, modelViewObject_, observerId_)

                            true

                            # END: for component in...

                        # END: for path, namespaceDescriptor of...

                    # extensionPointStoreNamespace = new Encapsule.code.lib.omm.ObjectStoreNamespace(@, extensionPointNamespaceSelector_, "bypass")

                catch exception
                    throw "Encapsule.code.lib.omm.StoreBase.internalReifyStoreExtensions failure: #{exception}"

        catch exception
            throw "Encapsule.code.lib.omm.StoreBase constructor failed: #{exception}"

#
# ****************************************************************************
class ONMjs.Store
    constructor: (objectModel_, initialStateJSON_) ->
        try
            @storeReifier = new ONMjs.implementation.StoreReifier(@)

            #
            # ============================================================================
            Console.message("Encapsule.code.lib.omm.StoreBase: Creating memory store instance for object model '#{objectModel_.jsonTag}'")

            # Validate parameters.
            if not (objectModel_? and objectModel_) then throw "Missing object model parameter!"

            # Keep a reference to this object store's associated object model.
            @objectModel = objectModel_

            @jsonTag = objectModel_.jsonTag
            @label = objectModel_.label
            @description = objectModel_.description

            @dataReference = undefined # the new store actual

            @objectStoreSource = undefined # this is flag indicating if the store was created from a JSON string

            # We use a map to store registered model view observers. 
            @modelViewObservers = {}

            # Private (and opaque) state managed on behalf of registered model view observers.
            @modelViewObserversState = {}

            if initialStateJSON_? and initialStateJSON_
                Console.message("... deserializing from JSON string")
                parsedObject = JSON.parse(initialStateJSON_)
                @objectStore = parsedObject[@jsonTag]
                if not (@objectStore? and @objectStore)
                    throw "Cannot deserialize specified JSON string!"
                @objectStoreSource = "json"
                Console.message("... Store initialized from deserialized JSON string.")
                
            else
                Console.message("... Initializing new instance of the '#{@jsonTag}' object model.")
                @dataReference = {}
                @objectStoreSource = "new"

                token = new Encapsule.code.lib.omm.AddressToken(objectModel_, undefined, undefined, 0)
                tokenBinder = new Encapsule.code.lib.omm.implementation.AddressTokenBinder(@, @dataReference, token, "new")


            #
            # ============================================================================
            @createComponent = (objectModelNamespaceSelector_) =>
                try
                    if not (objectModelNamespaceSelector_? and objectModelNamespaceSelector_)
                        throw "Missing object model namespace selector input parameter!"

                    if objectModelNamespaceSelector_.selectKeysReady
                        throw "Invalid resolved namespace selector: the namespace selector specified is resolved to an existing object and cannot be used to create a new component in the object store."

                    if not objectModelNamespaceSelector_.objectModelDescriptor.isComponent
                        throw "Invalid selector specifies non-component root namespace."

                    if objectModelNamespaceSelector_.pathId == 0
                        throw "Invalid selector specifies root component which cannot be removed."

                    # Creating the root namespace of a component automatically creates all its sub-namespaces as well.
                    objectStoreNamespace = new Encapsule.code.lib.omm.ObjectStoreNamespace(@, objectModelNamespaceSelector_, "new")

                    extensionPointId = objectModelNamespaceSelector_.objectModelDescriptor.parent.id
                    extensionPointSelector = @objectModel.createNamespaceSelectorFromPathId(extensionPointId, objectStoreNamespace.resolvedKeyVector)
                    extensionPointNamespace = new Encapsule.code.lib.omm.ObjectStoreNamespace(@, extensionPointSelector)
                    extensionPointNamespace.updateRevision()

                    return objectStoreNamespace

                catch exception

                    throw "Encapsule.code.lib.omm.Store.createComponent failure: #{exception}"

            #
            # ============================================================================
            @removeComponent = (objectModelNamespaceSelector_) =>
                try
                    if not (objectModelNamespaceSelector_? and objectModelNamespaceSelector_)
                        throw "Missing object model namespace selector input parameter!"

                    if not objectModelNamespaceSelector_.selectKeysReady
                        throw "Invalid unresolved namespace selector in request."

                    if not objectModelNamespaceSelector_.objectModelDescriptor.isComponent
                        throw "Invalid selector specifies non-component root namespace."

                    if objectModelNamespaceSelector_.pathId == 0
                        throw "Invalid selector specifies root component which cannot be removed."

                    # Unrefify the component before actually making any modifications to the store.
                    # modelViewObserver_ == undefined -> broadcast to all registered observers
                    # undoFlag_ == true -> invert namespace traversal order and invoke remove callbacks
                    @internalReifyStoreExtensions(objectModelNamespaceSelector_, undefined, undefined, true)
                    @internalUnreifyStoreComponent(objectModelNamespaceSelector_)

                    objectStoreNamespace = new Encapsule.code.lib.omm.ObjectStoreNamespace(@, objectModelNamespaceSelector_)
                    arrayIndexToRemove = objectStoreNamespace.resolvedKeyIndexVector[objectStoreNamespace.resolvedKeyIndexVector.length - 1]

                    extensionPointSelector = @objectModel.createNamespaceSelectorFromPathId(objectModelNamespaceSelector_.objectModelDescriptor.parent.id, objectModelNamespaceSelector_.selectKeyVector)

                    extensionPointNamespace = new Encapsule.code.lib.omm.ObjectStoreNamespace(@, extensionPointSelector)
                    extensionPointNamespace.objectStoreNamespace.splice(arrayIndexToRemove, 1)

                    extensionPointNamespace.updateRevision()

                    return objectStoreNamespace

                catch exception
                    throw "Encapsule.code.lib.omm.Store.removeComponent failure: #{exception}"


            #
            # ============================================================================
            # Assumes the existence of the namespace indicated by the specified selector.
            # Throws if the selector cannot be resolved against the contents of the store.
            #
            @openNamespace = (objectModelNamespaceSelector_) =>
                try
                    if not (objectModelNamespaceSelector_? and objectModelNamespaceSelector_)
                        throw "Missing object model namespace selector input parameter!"

                    if not objectModelNamespaceSelector_.selectKeysReady
                        throw "Invalid unresolved namespace selector in request."

                    # Leverage default "bypass" mode (i.e. no validation, no creation, throw if not exist)
                    objectStoreNamespace = new Encapsule.code.lib.omm.ObjectStoreNamespace(@, objectModelNamespaceSelector_, "bypass")

                    return objectStoreNamespace

                catch exception
                    throw "Encapsule.code.lib.omm.Store.openNamespace failure: #{exception}"
                

            #
            # ============================================================================
            @toJSON = (replacer_, space_) =>
                try
                    resultObject = {}
                    resultObject[@jsonTag] = @objectStore
                    space = space_? and space_ or 0
                    resultJSON = JSON.stringify(resultObject, replacer_, space)
                    if not (resultJSON? and resultJSON)
                        throw "Cannot serialize Javascript object to JSON!"
                    return resultJSON

                catch exception
                    throw "Encapsule.code.lib.omm.Store.toJSON fail on object store #{@jsonTag} : #{exception}"









            # 
            # ============================================================================
            # A model view object may be registered with the OM store object to receive
            # callbacks when the contents of the store is modified. In the context of
            # registration, the observer will receive series of callbacks (one per store
            # namespace) that the model view class leverages to initialize its internal
            # state. Subsequently, mutation of the store will generate additional callback(s)
            # specifying the namespace(s) that have been modified. Any number of model view
            # object may be registered with the store. Upon successful registration, this
            # method returns an "observer ID code" that the observer should cache. An
            # observer can be unregistered by calling unregisterModelViewObserver providing
            # the "observer ID code" received when it was registered.
            #
            @registerObserver = (observerCallbackInterface_) =>
                try
                    if not (observerCallbackInterface_? and observerCallbackInterface_) then throw "Missing model view object input parameter!"

                    # Create a new observer ID code (UUID because multiple registrations allowed).
                    observerIdCode = uuid.v4()

                    # Affect the registration using the observer ID as the key and the caller's modelViewObject_ by reference.
                    @modelViewObservers[observerIdCode] = observerCallbackInterface_

                    # The root namespace of an object store always exists and comprises the base of the root component -
                    # a hierarchy of sub-namespaces defined as the set of all descendents including extension point
                    # collections but excluding the components contained with child extension poitns.

                    # Get the store's root address.
                    rootAddress = ONMjs.address.RootAddress(@objectModel)

                    ###
                    THE BATTLE FRONT

                    # Reflect the root component to the model view object.
                    @internalReifyStoreComponent(rootNamespaceSelector, modelViewObject_, observerIdCode)

                    # Now kick off the recursive process of enumerating the stores extension points
                    # and registering sub-components found to exist in the store with the newly registered
                    # model view object. This process additionally registers each enumerated component's
                    # associated namespaces with the model view object.
                    #
                    # After the initial registration "catch-up", the model view object subsequently
                    # tracks changes to the store state via discrete component/namespace create,
                    # update, and remove callback notifications issued by the store.

                    @internalReifyStoreExtensions(rootNamespaceSelector, modelViewObject_, observerIdCode)

                    ###

                    return observerIdCode

                catch exception
                    throw "Encapsule.code.lib.omm.StoreBase.internalRegisterModelViewObserver failure: #{exception}"

            #
            # ============================================================================
            @unregisterModelViewObserver = (observerIdCode_) =>
                try
                    if not (observerIdCode_? and observerIdCode_) then throw "Missing observer ID code input parameter!"

                    registeredObserver = @modelViewObservers[observerIdCode_]

                    if not (registeredObserver? and registeredObserver)
                        throw "Unknown observer ID code provided. No registration to remove."

                    # Unreify the contents of the store before removing the registration.
                    rootSelector = @objectModel.createNamespaceSelectorFromPathId(0)
                    @internalReifyStoreExtensions(rootSelector, registeredObserver, observerIdCode_, true)
                    @internalUnreifyStoreComponent(rootSelector, registeredObserver, observerIdCode_)

                    @internalRemoveObserverState(observerIdCode_)

                    # Remove the registration.
                    @modelViewObservers[observerIdCode_] = undefined

                catch exception
                    throw "Encapsule.code.lib.omm.StoreBase.internalUnregisterModelViewObserver failure: #{exception}"

            #
            # ============================================================================
            @openObserverState = (observerId_) =>
                try
                    if not (observerId_? and observerId_) then throw "Missing observer ID parameter!"
                    observerState = @modelViewObserversState[observerId_]? and @modelViewObserversState[observerId_] or @modelViewObserversState[observerId_] = []
                    return observerState                    

                catch exception
                    throw "Encapsule.code.lib.omm.Store.openObserverStateObject failure: #{exception}"

            #
            # ============================================================================
            @removeObserverState = (observerId_) =>
                if not (observerId_? and observerId_) then throw "Missing observer ID parameter!"
                observerState = @openObserverState(observerId_)
                if observerState? and observerState
                    delete @modelViewObserverState[observerId_]
                @

            #
            # ============================================================================
            @openObserverComponentState = (observerId_, namespaceSelector_) =>
                try
                    if not (observerId_? and observerId_) then throw "Missing observer ID parameter!"
                    if not (namespaceSelector_? and namespaceSelector_) then throw "Missing namespace selector parameter!"
                    componentSelector = @objectModel.createNamespaceSelectorFromPathId(
                        namespaceSelector_.objectModelDescriptor.componentId, namespaceSelector_.selectKeyVector, namespaceSelector_.secondaryKeyVector)
                    return @internalOpenObserverNamespaceState(observerId_, componentSelector)

                catch exception
                    throw "Encapsule.code.lib.omm.Store.openObserverComponentState failure: #{exception}"

            #
            # ============================================================================
            @openObserverNamespaceState = (observerId_, namespaceSelector_) =>
                try
                    if not (observerId_? and observerId_) then throw "Missing observer ID parameter!"
                    if not (namespaceSelector_? and namespaceSelector_) then throw "Missing namespace selector parameter!"
                    observerState = @internalOpenObserverState(observerId_)
                    pathRecord = observerState[namespaceSelector_.pathId]? and observerState[namespaceSelector_.pathId] or observerState[namespaceSelector_.pathId] = {}
                    namespaceHash = namespaceSelector_.getHashString()
                    namespaceState = pathRecord[namespaceHash]? and pathRecord[namespaceHash] or pathRecord[namespaceHash] = {}
                    return namespaceState

                catch exception
                    throw "Encapsule.code.lib.omm.Store.openObserverNamespaceState failure: #{exception}"

            #
            # ============================================================================
            @removeObserverNamespaceState = (observerId_, namespaceSelector_) =>

                observerState = @modelViewObserversState[observerId_]
                if not (observerState? and observerState)
                    return @
                pathRecord = observerState[namespaceSelector_.pathId]
                if not (pathRecord? and pathRecord)
                    return @
                namespaceHash = namespaceSelector_.getHashString()
                delete pathRecord[namespaceHash]
                if Encapsule.code.lib.js.dictionaryLength(pathRecord) == 0
                    delete observerState[namespaceSelector_.pathId]
                return @


        catch exception
            throw "Encapsule.code.lib.omm.Store failure: #{exception}"


        

        
