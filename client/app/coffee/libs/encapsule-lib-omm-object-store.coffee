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
            Console.message("Encapsule.code.lib.omm.ObjectStore instance '#{objectModel_.jsonTag}'")

            # Validate parameters.
            if not (objectModel_? and objectModel_) then throw "Missing object model parameter!"

            # Keep a reference to this object store's associated object model.
            @objectModel = objectModel_

            @jsonTag = objectModel_.jsonTag
            @label = objectModel_.label
            @description = objectModel_.description

            @objectStore = undefined
            @objectStoreSource = undefined

            if initialStateJSON_? and initialStateJSON_
                Console.message("... deserializing from JSON string")
                @objectStore = JSON.parse(initialStateJSON_)
                @objectStoreSource = "json"
                if not (@objectStore? and @objectStore)
                    throw "Cannot deserialize specified JSON string!"
                Console.message("... Store initialized from deserialized JSON string.")
            else
                Console.message("... Initializing new instance of the '#{@jsonTag}' object model.")
                @objectStore = {}
                @objectStoreSource = "new"


            #
            # ============================================================================



            #
            # ============================================================================
            @toJSON = =>
                try
                    Console.message("Encapsule.code.lib.omm.ObjectStore.toJSON for object store #{@jsonTag}")
                    resultObject = {}
                    resultObject[@jsonTag] = @objectStore
                    resultJSON = JSON.stringify(resultObject)
                    if not (resultJSON? and resultJSON)
                        throw "Cannot serialize Javascript object to JSON!"
                    return resultJSON

                catch exception
                    throw "Encapsule.code.lib.omm.ObjectStore.toJSON fail on object store #{@jsonTag} : #{exception}"


            #
            # ============================================================================
            @createNamespace = (objectModelNamespaceSelector_) =>
                try
                    if not (objectModelNamespaceSelector_? and objectModelNamespaceSelector_) then throw "Missing object model namespace selector input parameter!"

                    pathId = objectModelNamespaceSelector_.pathId

                    storeNamespaceBinder = @objectStoreNamespaceBinders[pathId]
                    if not (storeNamespaceBinder? and storeNamespaceBinder)
                        throw "Unable to resolve store namespace binder for specified model namespace path!"

                    storeNamespace = storeNamespaceBinder.bind(objectModelNamespaceSelector_)

                    return storeNamespace

                catch exception
                    throw "Encapsule.code.lib.omm.ObjectStore.createNamespace failed: #{exception}"



            #
            # ============================================================================
            @createNamespaceFromPathId = (pathId_, selectKeyVector_) =>
                try
                    selector = @objectModel.createNamespaceSelectorFromPathId(pathId_, selectKeyVector_)
                    storeNamespace = @createNamespace(selector)
                    return storeNamespace
                catch exception
                    throw "Encapsule.code.lib.omm.ObjectStore.createNamespaceFromPathId failed: #{exception}"

            #
            # ============================================================================
            @createNamespaceFromPath = (path_, selectKeyVector_) =>
                try
                    pathId = @objectModel.getPathIdFromPath(path_)
                    storeNamespace = @createNamespaceFromPathId(pathId, selectKeyVector_)
                    return storeNamespace
                catch exception
                    throw "Encapsule.code.lib.omm.ObjectStore.createNamespaceFromPath failed: #{exception}"

            #
            # ============================================================================

            #
            # ============================================================================

            #
            # ============================================================================

            #
            # ============================================================================

            #
            # ============================================================================

            #
            # ============================================================================


        catch exception
            throw "Encapsule.code.lib.omm.Object construction failed: #{exception}"


        

        