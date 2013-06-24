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
    constructor: (objectModel_) ->
        try
            Console.message("Encapsule.code.lib.omm.ObjectStore construction for object namespace \"#{objectModel_.jsonTag}\".")

            # Validate parameter.
            if not (objectModel_? and objectModel_) then throw "Missing object model parameter!"

            # Keep a reference to this object store's associated object model.
            @objectModel = objectModel_

            @jsonTag = objectModel_.jsonTag
            @label = objectModel_.label
            @description = objectModel_.description

            @objectStore = {}

            # ObjectStoreNamespaceBinder by pathId
            @objectStoreNamespaceBinders = []

            descriptorArrayIndex = 0
            descriptorArray = @objectModel.objectModelDescriptorById

            while descriptorArrayIndex < descriptorArray.length
                objectModelDescriptor = descriptorArray[descriptorArrayIndex]
                @objectStoreNamespaceBinders.push new Encapsule.code.lib.omm.ObjectStoreNamespaceBinder(@, objectModelDescriptor)
                descriptorArrayIndex++


            #
            # ============================================================================
            @isValid = =>
                return @objectStoreNamespaces.length and true or false


            #
            # ============================================================================
            @fromJSON = (jsonString_) =>
                try
                    Console.message("Encapsule.code.lib.omm.ObjectStore.fromJSON for object store #{@jsonTag}")
                    if not (jsonString_? and jsonString_)
                        throw "Missing JSON string input parameter!"
                    deserializedObject = JSON.parse(jsonString_) or {}
                    if not (deserializedObject? and deserializedObject)
                        throw "Cannot deserialized Javascript object from JSON!"
                    @objectStore = deserializedObject[@jsonTag]
                    

                catch exception
                    throw "Encapsule.code.lib.omm.ObjectStore.fromJson fail on object store #{@jsonTag} : #{exception}"

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
            @bindNamespace = (objectModelNamespaceSelector_) =>
                try
                    if not (objectModelNamespaceSelector_? and objectModelNamespaceSelector_) then throw "Missing object model namespace selector input parameter!"

                    pathId = objectModelNamespaceSelector_.pathId

                    storeNamespaceBinder = @objectStoreNamespaceBinders[pathId]
                    if not (storeNamespaceBinder? and storeNamespaceBinder)
                        throw "Unable to resolve store namespace binder for specified model namespace path!"

                    storeNamespace = storeNamespaceBinder.bind(objectModelNamespaceSelector_)

                    return storeNamespace

                catch exception
                    throw "Encapsule.code.lib.omm.ObjectStore.createNamespaceInstance failed: #{exception}"
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

            #
            # ============================================================================

            #
            # ============================================================================


        catch exception
            throw "Encapsule.code.lib.omm.Object construction failed: #{exception}"


        

        
