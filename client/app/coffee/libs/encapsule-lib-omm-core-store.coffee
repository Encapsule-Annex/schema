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
    constructor: (model_, initialStateJSON_) ->
        try
            # Reifer "makes real" the contents of the store in the eye of the beholder (i.e. registered observers).
            # In other words, reifier traverses the contents of the stores and calls specific methods on registered
            # observer interfaces in response to various ONMjs.Store observable state change events. 
            @reifier = new ONMjs.implementation.StoreReifier(@)

            #
            # ============================================================================
            Console.message("Encapsule.code.lib.omm.StoreBase: Creating memory store instance for object model '#{model_.jsonTag}'")

            # Validate parameters.
            if not (model_? and model_) then throw "Missing object model parameter!"

            # Keep a reference to this object store's associated object model.
            @model = model_

            @jsonTag = model_.jsonTag
            @label = model_.label
            @description = model_.description

            @dataReference = undefined # the new store actual

            @objectStoreSource = undefined # this is flag indicating if the store was created from a JSON string

            # We use a map to store registered model view observers. 
            @observers = {}

            # Private (and opaque) state managed on behalf of registered model view observers.
            @observersState = {}

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

                token = new Encapsule.code.lib.omm.AddressToken(model_, undefined, undefined, 0)
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
                    extensionPointSelector = @model.createNamespaceSelectorFromPathId(extensionPointId, objectStoreNamespace.resolvedKeyVector)
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

                    extensionPointSelector = @model.createNamespaceSelectorFromPathId(objectModelNamespaceSelector_.objectModelDescriptor.parent.id, objectModelNamespaceSelector_.selectKeyVector)

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
            @registerObserver = (observerCallbackInterface_, observingEntityReference_) =>
                try
                    if not (observerCallbackInterface_? and observerCallbackInterface_) then throw "Missing callback interface namespace input parameter.."
                    observerCallbackInterface_.observingEntity = observingEntityReference_

                    # Create a new observer ID code (UUID because multiple registrations allowed).
                    observerIdCode = uuid.v4()

                    # Affect the registration using the observer ID as the key and the caller's modelViewObject_ by reference.
                    @observers[observerIdCode] = observerCallbackInterface_

                    # The root namespace of an object store always exists and comprises the base of the root component -
                    # a hierarchy of sub-namespaces defined as the set of all descendents including extension point
                    # collections but excluding the components contained with child extension points.

                    # Get the store's root address.
                    rootAddress = ONMjs.address.RootAddress(@model)

                    @reifier.dispatchCallback(undefined, "onObserverAttachBegin", observerIdCode)

                    # Reify the store's root component in the eye of the observer. Not that this function
                    # also reifieis all of the component's descendant namespaces as well.
                    @reifier.reifyStoreComponent(rootAddress, observerIdCode)

                    # Enumerate and reify this component's subcomponents contained in its extension points.
                    # Note that this process is repeated for every component discovered until all descendant
                    # subcomponents of the specified component have been enumerated and reified in the eye
                    # of the observer.
                    @reifier.reifyStoreExtensions(rootAddress, observerIdCode)

                    @reifier.dispatchCallback(undefined, "onObserverAttachEnd", observerIdCode)

                    return observerIdCode

                catch exception
                    throw "Encapsule.code.lib.omm.StoreBase.internalRegisterModelViewObserver failure: #{exception}"

            #
            # ============================================================================
            @unregisterObserver = (observerIdCode_) =>
                try
                    if not (observerIdCode_? and observerIdCode_) then throw "Missing observer ID code input parameter!"

                    registeredObserver = @observers[observerIdCode_]

                    if not (registeredObserver? and registeredObserver)
                        throw "Unknown observer ID code provided. No registration to remove."

                    @reifier.dispatchCallback(undefined, "onObserverDetachBegin", observerIdCode_)

                    # Get the store's root address.
                    rootAddress = ONMjs.address.RootAddress(@model)

                    @reifier.reifyStoreExtensions(rootAddress, observerIdCode_, true)
                    @reifier.unreifyStoreComponent(rootAddress, observerIdCode_)

                    @reifier.dispatchCallback(undefined, "onObserverDetachEnd", observerIdCode_)

                    @removeObserverState(observerIdCode_)

                    # Remove the registration.
                    @observers[observerIdCode_] = undefined

                catch exception
                    throw "Encapsule.code.lib.omm.StoreBase.internalUnregisterModelViewObserver failure: #{exception}"

            #
            # ============================================================================
            @openObserverState = (observerId_) =>
                try
                    if not (observerId_? and observerId_) then throw "Missing observer ID parameter!"
                    observerState = @observersState[observerId_]? and @observersState[observerId_] or @observersState[observerId_] = []
                    return observerState                    

                catch exception
                    throw "Encapsule.code.lib.omm.Store.openObserverStateObject failure: #{exception}"

            #
            # ============================================================================
            @removeObserverState = (observerId_) =>
                if not (observerId_? and observerId_) then throw "Missing observer ID parameter!"
                if observerState? and observerState
                    if @observerState[observerId_]? and @observerState[observerId_]
                        delete @observerState[observerId_]
                @

            #
            # ============================================================================
            @openObserverComponentState = (observerId_, address_) =>
                try
                    if not (observerId_? and observerId_) then throw "Missing observer ID parameter."
                    if not (address_? and address_) then throw "Missing address input parameter."
                    token = address_.getLastToken()
                    componentNamespaceId = token.componentDescriptor.id
                    componentAddress = ONMjs.address.newAddressSameComponent(address_, componentNamespaceId)
                    return @openObserverNamespaceState(observerId_, componentAddress)
                catch exception
                    throw "Encapsule.code.lib.omm.Store.openObserverComponentState failure: #{exception}"

            #
            # ============================================================================
            @openObserverNamespaceState = (observerId_, address_) =>
                try
                    if not (observerId_? and observerId_) then throw "Missing observer ID parameter."
                    if not (address_? and address_) then throw "Missing address input parameter."
                    observerState = @openObserverState(observerId_)
                    token = address_.getLastToken()
                    namespacePathId = token.namespaceDescriptor.id
                    namespacePathState = observerState[namespacePathId]? and observerState[namespacePathId] or observerState[namespacePathId] = {}
                    namespaceURN = address_.getHashString()
                    namespaceState = namespacePathState[namespaceURN]? and namespacePathStae[namespaceURN] or namespacePathState[namespaceURN] = {}
                    return namespaceState

                catch exception
                    throw "Encapsule.code.lib.omm.Store.openObserverNamespaceState failure: #{exception}"

            #
            # ============================================================================
            @removeObserverNamespaceState = (observerId_, address_) =>

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


        

        
