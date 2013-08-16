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
# encapsule-lib-omm-object.coffee
#
# OMM stands for Object Model Manager


namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.omm = Encapsule.code.lib.omm? and Encapsule.code.lib.omm or @Encapsule.code.lib.omm = {}

#
# ****************************************************************************
class Encapsule.code.lib.omm.ObjectStoreBase
    constructor: (objectModel_, initialStateJSON_) ->
        try

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
                    throw "Encapsule.code.lib.omm.ObjectStoreBase.internalReifyStoreComponent failure: #{exception}"


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
                    throw "Encapsule.code.lib.omm.ObjectStoreBase.internalUnreifyStoreComponent failure: #{exception}"


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
                    throw "Encapsule.code.lib.omm.ObjectStoreBase.internalReifyStoreExtensions failure: #{exception}"


            # 
            # ============================================================================
            @internalRegisterModelViewObserver = (modelViewObject_) =>
                try
                    # Test modelViewObject_ interface for compatibility.

                    # Create a new observer ID code (UUID because multiple registrations allowed).
                    observerIdCode = uuid.v4()
                    # Affect the registration using the observer ID as the key and the caller's modelViewObject_ by reference.
                    @modelViewObservers[observerIdCode] = modelViewObject_


                    # The root namespace of an object store always exists and comprises the base of the root component -
                    # a hierarchy of sub-namespaces defined as the set of all descendents excluding extension namespaces
                    # and their descendents.

                    # Create a namespace selector that references the root namespace of the store.
                    rootNamespaceSelector = @objectModel.createNamespaceSelectorFromPathId(0)

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

                    return observerIdCode

                catch exception
                    throw "Encapsule.code.lib.omm.ObjectStoreBase.internalRegisterModelViewObserver failure: #{exception}"


            #
            # ============================================================================
            @internalUnregisterModelViewObserver = (observerIdCode_) =>
                try
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
                    throw "Encapsule.code.lib.omm.ObjectStoreBase.internalUnregisterModelViewObserver failure: #{exception}"


            #
            # ============================================================================
            @internalOpenObserverState = (observerId_) =>
                return @modelViewObserversState[observerId_]? and @modelViewObserversState[observerId_] or @modelViewObserversState[observerId_] = []

            #
            # ============================================================================
            @internalRemoveObserverState = (observerId_) =>
                delete @modelViewObserversState[observerId_]
                @

            #
            # ============================================================================
            @internalOpenObserverComponentState = (observerId_, namespaceSelector_) =>
                componentSelector = @objectModel.createNamespaceSelectorFromPathId(namespaceSelector_.objectModelDescriptor.componentId, namespaceSelector_.selectKeyVector, namespaceSelector_.secondaryKeyVector)
                return @internalOpenObserverNamespaceState(observerId_, componentSelector)

            #
            # ============================================================================
            @internalOpenObserverNamespaceState = (observerId_, namespaceSelector_) =>

                observerState = @internalOpenObserverState(observerId_)
                pathRecord = observerState[namespaceSelector_.pathId]? and observerState[namespaceSelector_.pathId] or observerState[namespaceSelector_.pathId] = {}
                namespaceHash = namespaceSelector_.getHashString()
                namespaceState = pathRecord[namespaceHash]? and pathRecord[namespaceHash] or pathRecord[namespaceHash] = {}
                return namespaceState


            #
            # ============================================================================
            @internalRemoveObserverNamespaceState = (observerId_, namespaceSelector_) =>

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

            #
            # ============================================================================
            Console.message("Encapsule.code.lib.omm.ObjectStore: Creating memory store instance for object model '#{objectModel_.jsonTag}'")

            # Validate parameters.
            if not (objectModel_? and objectModel_) then throw "Missing object model parameter!"

            # Keep a reference to this object store's associated object model.
            @objectModel = objectModel_

            @jsonTag = objectModel_.jsonTag
            @label = objectModel_.label
            @description = objectModel_.description

            @objectStore = undefined # THE ACTUAL DATA
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
                @objectStore = {}
                @objectStoreSource = "new"
                rootSelector = @objectModel.createNamespaceSelectorFromPathId(0)
                component = new Encapsule.code.lib.omm.ObjectStoreComponent(@, rootSelector, "new")


        catch exception
            throw "Encapsule.code.lib.omm.ObjectStoreBase constructor failed: #{exception}"

#
# ****************************************************************************
class Encapsule.code.lib.omm.ObjectStore extends Encapsule.code.lib.omm.ObjectStoreBase
    constructor: (objectModel_, initialStateJSON_) ->
        try
            super(objectModel_, initialStateJSON_)
            
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
            # ============================================================================
            @registerModelViewObserver = (modelViewObject_) =>
                try
                    if not (modelViewObject_? and modelViewObject_) then throw "Missing model view object input parameter!"
                    return @internalRegisterModelViewObserver(modelViewObject_)

                catch exception
                    throw "Encapsule.code.lib.omm.ObjectStore.registerModelViewObserver failure: #{exception}"

            #
            # ============================================================================
            @unregisterModelViewObserver = (observerIdCode_) =>
                try
                    if not (observerIdCode_? and observerIdCode_) then throw "Missing observer ID code input parameter!"
                    @internalUnregisterModelViewObserver(observerIdCode_)

                catch exception
                    throw "Encapsule.code.lib.omm.ObjectStore.unregisterModelViewObserver failure: #{exception}"



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
                    throw "Encapsule.code.lib.omm.ObjectStore.toJSON fail on object store #{@jsonTag} : #{exception}"


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

                    throw "Encapsule.code.lib.omm.ObjectStore.createComponent failure: #{exception}"

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
                    throw "Encapsule.code.lib.omm.ObjectStore.removeComponent failure: #{exception}"


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
                    throw "Encapsule.code.lib.omm.ObjectStore.openNamespace failure: #{exception}"
                


            #
            # ============================================================================
            @openObserverState = (observerId_) =>
                try
                    if not (observerId_? and observerId_) then throw "Missing observer ID parameter!"
                    return @internalOpenObserverState(observerId_)
                catch exception
                    throw "Encapsule.code.lib.omm.ObjectStore.openObserverStateObject failure: #{exception}"

            #
            # ============================================================================
            @openObserverComponentState = (observerId_, namespaceSelector_) =>
                try
                    if not (observerId_? and observerId_) then throw "Missing observer ID parameter!"
                    if not (namespaceSelector_? and namespaceSelector_) then throw "Missing namespace selector parameter!"
                    return @internalOpenObserverComponentState(observerId_, namespaceSelector_)
                catch exception
                    throw "Encapsule.code.lib.omm.ObjectStore.openObserverComponentState failure: #{exception}"


            #
            # ============================================================================
            @openObserverNamespaceState = (observerId_, namespaceSelector_) =>
                try
                    if not (observerId_? and observerId_) then throw "Missing observer ID parameter!"
                    if not (namespaceSelector_? and namespaceSelector_) then throw "Missing namespace selector parameter!"
                    return @internalOpenObserverNamespaceState(observerId_, namespaceSelector_)
                catch exception
                    throw "Encapsule.code.lib.omm.ObjectStore.openObserverNamespaceState failure: #{exception}"



        catch exception
            throw "Encapsule.code.lib.omm.Object construction failed: #{exception}"


        

        
