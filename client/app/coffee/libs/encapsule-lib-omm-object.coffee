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
class Encapsule.code.lib.omm.Object
    constructor: (objectModelDeclaration_, jsonString_) ->
        try
            Console.message("Encapsule.code.lib.omm.Object construction.")

            # Validate parameter.
            if not (objectModelDeclaration_? and objectModelDeclaration_) then throw "Missing object model declaration parameter!"

            @objectModel = new Encapsule.code.lib.omm.ObjectModel(objectModelDeclaration_)

            @jsonTag = @objectModel.jsonTag
            @label = @objectModel.label
            @description = @objectModel.description
            @objectData = {}

            @instancePrivateState = {}
            @instancePrivateState.objectDataRevision = 0
            @instancePrivateState.objectDataCreateTime = 0
            @instancePrivateState.objectDataUpdateTime = 0

            #
            # ============================================================================
            @fromJSON = (jsonString_) =>
                try
                    Console.message("Encapsule.code.lib.omm.Object.initializeFromJSON for object #{@jsonTag}")
                    if not (jsonString_? and jsonString_)
                        throw "Missing JSON string input parameter!"
                    deserializedObject = JSON.parse(jsonString_) or {}
                    if not (deserializedObject? and deserializedObject)
                        throw "Cannot deserialized Javascript object from JSON!"
                    @objectData = deserializedObject[@jsonTag]
                    

                catch exception
                    throw "Encapsule.code.lib.omm.Object.fromJson fail on object #{@jsonTag} : #{exception}"

            #
            # ============================================================================
            @toJSON = =>
                try
                    Console.message("Encapsule.code.lib.omm.Object.toJSON for obejct #{@jsonTag}")
                    resultObject = {}
                    resultObject[@jsonTag] = @objectData
                    resultJSON = JSON.stringify(resultObject)
                    if not (resultJSON? and resultJSON)
                        throw "Cannot serialize Javascript object to JSON!"
                    return resultJSON

                catch exception
                    throw "Encapsule.code.lib.omm.Object.toJSON fail on object #{@jsonTag} : #{exception}"


            #
            # ============================================================================
            @getPathIdFromPath = (objectModelPath_) =>
                try
                    if not (@objectModel? and @objectModel) then throw "Internal error: Unable to resolve internal object model instance!"
                    if not (objectModelPath_? and objectModelPath_) then throw "Missing object model path parameter!"

                    objectModelDescriptor = @objectModel.objectModelPathMap[objectModelPath_]
                    if not (objectModelDescriptor? and objectModelDescriptor)
                        throw "Internal error: Unable to resolve object model descriptor!"
        
                    objectModelPathId = objectModelDescriptor.id
                    if not objectModelPathId?
                        throw "Internal error: Unable to resolve object model path ID from object model descriptor."

                    return objectModelPathId

                catch exception
                    throw "Encapsule.code.lib.omm.Object.getPathIdFromPath fail: #{exception}"


            #
            # ============================================================================
            @getPathFromPathId = (pathId_) =>
                try
                    if not (pathId_?) then throw "Missing path ID parameter!"

                    objectModelDescriptor = @objectModel.objectModelDescriptorById[pathId_]
                    if not (objectModelDescriptor? and objectModelDescriptor)
                        throw "Unable to resolve object descriptor for path ID #{pathId_}"
                    path = objectModelDescriptor.path
                    return path

                catch exception
                    throw "Encapsule.code.lib.omm.Object.getPathFromPathId fail: #{exception}"



            #
            # ============================================================================
            @getSelector = (pathId_, selectKeyVector_) =>
                try
                    if not pathId_? then throw "Missing object model path ID input parameter!"

                    selector = new Encapsule.code.lib.omm.ObjectModelSelector(@objectModel, pathId_, selectKeyVector_)
                    if not (selector? and selector)
                        throw "Unable to resolve selector for path ID #{pathId_}"
                    return selector

                catch exception
                    throw "Encapsule.code.lib.omm.Object.getNamespaceProxy fail on object #{@jsonTag} : #{exception}"


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


        

        
