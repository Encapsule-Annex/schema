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
# encapsule-lib-omm-object-selector.coffee
#
# OMM stands for Object Model Manager


namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.omm = Encapsule.code.lib.omm? and Encapsule.code.lib.omm or @Encapsule.code.lib.omm = {}



#
# An OM selector represents a unique object namespace within the space defined
# by the object model parameter.
# pathId_ = zero-based index of OM path
# selectKeyVector_ = orderred array of extension array keys (we're concerned only
#     with the existence or size of this array here; undefined or length = 0 are
#     both taken as "no keys provided" (i.e. okay for pathId's corresponding to
#     OM paths that do not have embedded extension points).
#
# ****************************************************************************
class Encapsule.code.lib.omm.ObjectModelNamespaceSelector
    constructor: (objectModel_, pathId_, selectKeyVector_) ->
        try
            if not (objectModel_? and objectModel_) then throw "Missing object model input parameter."
            if not (pathId_?) then throw "Missing object model path parameter."

            if (pathId_ < 0) or (pathId_ >= objectModel_.objectModelDescriptorById.length)
                throw "Out of range path ID specified in request."

            @objectModel = objectModel_
            @selectKeyVector = selectKeyVector_
            @pathId = pathId_


            # Get the OM descriptor associated with the specified OM path.

            @objectModelDescriptor = @objectModel.objectModelDescriptorById[pathId_]
            if not (@objectModelDescriptor? and @objectModelDescriptor)
                throw "Unable to resolve object model descriptor for path #{objectModelPath_}"

            @selectKeysRequired = @objectModelDescriptor.parentPathExtensionPoints.length
            @selectKeysProvided = selectKeyVector_? and selectKeyVector_ and selectKeyVector_.length or 0
            @selectKeysReady = @selectKeysRequired == @selectKeysProvided

            Console.message("Encapsule.code.lib.omm.ObjectModelNamespaceSelector created selector for pathID=#{pathId_}. #{@selectKeysProvided} keys provided.")

            #
            # ============================================================================
            @getSelectKey = (index_) =>
                try
                    keyValue = undefined
                    if not index_? then throw "Missing index input parameter!"
                    if @selectKeyVector? and @selectKeyVector and @selectKeyVector.length? and @selectKeyVector.length and (index_ < 0) and (@selectKeyVector.length <= index_)
                        keyValue = @selectKeyVector[index_]
                    return keyValue
                catch exception
                    throw "Encapsule.code.lib.omm.ObjectModelNamespaceSelector.getSelectKey failure: #{exception}"
            # ============================================================================
            #


        catch exception
            throw "Encapsule.code.lib.omm.ObjectModelNamespaceSelector construction fail: #{exception}"
