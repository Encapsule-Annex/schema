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
# encapsule-lib-omm-core.coffee
#
# OMM stands for Object Model Manager


namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.omm = Encapsule.code.lib.omm? and Encapsule.code.lib.omm or @Encapsule.code.lib.omm = {}
Encapsule.code.lib.omm.core = Encapsule.code.lib.omm.core? and Encapsule.code.lib.omm.core or @Encapsule.code.lib.omm.core = {}

#
#
# ****************************************************************************
class Encapsule.code.lib.omm.core.ObjectModel
    constructor: (objectModelDeclaration_) ->
        try
            @namespaceRoot = undefined

            


        catch exception
            throw "Encapsule.code.lib.omm.core.ObjectModel construction fail: #{exception}"



#
#
# ****************************************************************************
class Encapsule.code.lib.omm.core.Object
    constructor: (objectModelDeclaration_, jsonString_) ->
        try
            Console.message("Encapsule.code.lib.omm.core.Object construction.")

            # Validate parameter.
            if not (objectModelDeclaration_? and objectModelDeclaration_) then throw "Missing object model declaration parameter!"

            @objectModelDeclaration = objectModelDeclaration_

            @jsonTag = objectModelDeclaration_.jsonTag
            @objectData = {}

            @instancePrivateState = {}
            @instancePrivateState.objectDataRevision = 0
            @instancePrivateState.objectDataCreateTime = 0
            @instancePrivateState.objectDataUpdateTime = 0






            #
            # ============================================================================
            @fromJSON = (jsonString_) =>
                try
                    Console.message("Encapsule.code.lib.omm.core.Object.initializeFromJSON for object #{@jsonTag}")
                    if not (jsonString_? and jsonString_)
                        throw "Missing JSON string input parameter!"
                    deserializedObject = JSON.parse(jsonString_) or {}
                    if not (deserializedObject? and deserializedObject)
                        throw "Cannot deserialized Javascript object from JSON!"
                    @objectData = deserializedObject[@jsonTag]
                    

                catch exception
                    throw "Encapsule.code.lib.omm.core.Object.fromJson fail on object #{@jsonTag} : #{exception}"

                

            #
            # ============================================================================
            @toJSON = =>
                try
                    Console.message("Encapsule.code.lib.omm.core.Object.toJSON for obejct #{@jsonTag}")
                    resultObject = {}
                    resultObject[@jsonTag] = @objectData
                    resultJSON = JSON.stringify(resultObject)
                    if not (resultJSON? and resultJSON)
                        throw "Cannot serialize Javascript object to JSON!"
                    return resultJSON

                catch exception
                    throw "Encapsule.code.lib.omm.core.Object.toJSON fail on object #{@jsonTag} : #{exception}"

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

            #
            # ============================================================================


        catch exception
            throw "Encapsule.code.lib.omm.core.Object construction failed: #{exception}"


        

        
