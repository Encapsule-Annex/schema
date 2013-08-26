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

class ONMjs.Store
    constructor: (objectModel_, initialStateJSON_) ->
        try
            @reifier = new ONMjs.implementation.StoreReifier(@)

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
                    @storeReifier.internalReifyStoreExtensions(objectModelNamespaceSelector_, undefined, undefined, true)
                    @storeReifier.internalUnreifyStoreComponent(objectModelNamespaceSelector_)

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

                    # Reify the store's root component in the eye of the observer. Not that this function
                    # also reifieis all of the component's descendant namespaces as well.
                    @reifier.reifyStoreComponent(rootAddress, observerCallbackInterface_, observerIdCode)

                    # Enumerate and reify this component's subcomponents contained in its extension points.
                    # Note that this process is "recursive" in that it repeats for every component discovered
                    # until all descendant subcomponents of the specified component have been enumerated and
                    # reified in the eye of the observer.
                    @reifier.reifyStoreExtensions(rootAddress, observerCallbackInterface_, observerIdCode)



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


        

        
