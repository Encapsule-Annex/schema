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
            # mode_ should be set to:
            #     "bypass" - no checking of extension keys. If the selector cannot be resolved, an error is thrown.
            #     "new" - create new extension keys as needed to complete the requested create operation.
            #     "strict" - verify the extension keys in the selector and throw an error on missing/unresolved keys in the store.
            #
            # Note that if mode_ == "new" and the selector specifies a path within a component that does not exist, this method
            # will create the entire component and return the requested namespace.
            #
            ###
            # This is currently not being called from anywhere. Keep it around temporarily
            @internalCreateStoreNamespace = (objectModelNamespaceSelector_, mode_) =>
                try
                    if not (objectModelNamespaceSelector_? and objectModelNamespaceSelector_) then throw "Missing object model namespace selector input parameter!"
                    objectStoreNamespace = new Encapsule.code.lib.omm.ObjectStoreNamespace(@, objectModelNamespaceSelector_, mode_)
                    return objectStoreNamespace

                catch exception
                    throw "Encapsule.code.lib.omm.ObjectStore.createStoreNamespace failed: #{exception}"
            ###

            #
            # ============================================================================
            @internalRegisterModelViewObserver = (modelViewObject_) =>
                try
                    observerIdCode = uuid.v4()
                    @modelViewObservers[observerIdCode] = modelViewObject_
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
                    @modelViewObservers[observerIdCode_] = undefined

                catch exception
                    throw "Encapsule.code.lib.omm.ObjectStoreBase.internalUnregisterModelViewObserver failure: #{exception}"

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
                component = new Encapsule.code.lib.omm.ObjectStoreComponent(@, undefined, @objectModel.getPathIdFromPath(@jsonTag), "new")


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

            @registerModelViewObserver = (modelViewObject_) =>
                try

                catch exception
                    throw "Encapsule.code.lib.omm.ObjectStore.registerModelViewObserver failure: #{exception}"

            @unregisterModelViewObserver = (observerIdCode_) =>
                try

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
                        throw "Invalid resolved namespace selector in request."

                    if not objectModelNamespaceSelector_.objectModelDescriptor.isComponent
                        throw "Invalid selector specifies non-component root namespace."

                    if objectModelNamespaceSelector_.pathId == 0
                        throw "Invalid selector specifies root component which cannot be removed."

                    # Creating the root namespace of a component automatically creates all its sub-namespaces as well.
                    objectStoreNamespace = new Encapsule.code.lib.omm.ObjectStoreNamespace(@, objectModelNamespaceSelector_, "new")
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

                    objectStoreNamespace = new Encapsule.code.lib.omm.ObjectStoreNamespace(@, objectModelNamespaceSelector_)

                    arrayIndexToRemove = objectStoreNamespace.resolvedKeyIndexVector[objectStoreNamespace.resolvedKeyIndexVector.length - 1]

                    extensionPointSelector = @objectModel.createNamespaceSelectorFromPathId(
                        objectModelNamespaceSelector_.objectModelDescriptor.parent.id,
                        objectModelNamespaceSelector_.selectKeyVector)

                    extensionPointNamespace = new Encapsule.code.lib.omm.ObjectStoreNamespace(@, extensionPointSelector)

                    extensionPointNamespace.objectStoreNamespace.splice(arrayIndexToRemove, 1)

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
                    objectStoreNamespace = new Encapsule.code.lib.omm.ObjectStoreNamespace(@, objectModelNamespaceSelector_)

                    return objectStoreNamespace

                catch exception
                    throw "Encapsule.code.lib.omm.ObjectStore.openNamespace failure: #{exception}"
                






        catch exception
            throw "Encapsule.code.lib.omm.Object construction failed: #{exception}"


        

        
