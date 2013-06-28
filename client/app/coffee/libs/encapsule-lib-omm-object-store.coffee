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
class Encapsule.code.lib.omm.ObjectStore
    constructor: (objectModel_, initialStateJSON_) ->
        try

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

                    componentStoreNamespace = new Encapsule.code.lib.omm.ObjectStoreNamespace(@, objectModelNamespaceSelector_)

                    arrayIndexToRemove = componentStoreNamespace.resolvedKeyIndexVector[componentStoreNamespace.resolvedKeyIndexVector.length - 1]

                    extensionPointSelector = @objectModel.createNamespaceSelectorFromPathId(
                        objectModelNamespaceSelector_.objectModelDescriptor.parent.id,
                        objectModelNamespaceSelector_.selectKeyVector)

                    extensionPointNamespace = new Encapsule.code.lib.omm.ObjectStoreNamespace(@, extensionPointSelector)

                    extensionPointNamespace.objectStoreNamespace.splice(arrayIndexToRemove, 1)


                catch exception
                    throw "Encapsule.code.lib.omm.ObjectStore.removeComponent failure: #{exception}"


            #
            # ============================================================================
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
                




            #
            # ============================================================================
            @createStoreNamespace = (objectModelNamespaceSelector_, mode_) =>
                try
                    if not (objectModelNamespaceSelector_? and objectModelNamespaceSelector_) then throw "Missing object model namespace selector input parameter!"
                    objectStoreNamespace = new Encapsule.code.lib.omm.ObjectStoreNamespace(@, objectModelNamespaceSelector_, mode_)
                    return objectStoreNamespace

                catch exception
                    throw "Encapsule.code.lib.omm.ObjectStore.createStoreNamespace failed: #{exception}"




                    


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
            @objectStoreSource = undefined

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
            throw "Encapsule.code.lib.omm.Object construction failed: #{exception}"


        

        
