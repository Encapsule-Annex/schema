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
            #
            # ============================================================================
            @internalVerifySelector = =>
                try

                    if not (@objectModelDescriptor? and @objectModelDescriptor)
                        throw "**** Missing cached object model descriptor ****"

                    if not (@objectModelDescriptor.namespaceDescriptor? and @objectModelDescriptor.namespaceDescriptor)
                        throw "**** Missing cached namespace declaration ****"

                    if @selectKeyVector.length > @selectKeysRequired
                        throw "**** Invalid object model namespace selector specifies more select keys than required ****"



                catch exception

                    Console.message("Encapsule.code.lib.omm.ObjectModelNamespaceSelector.internalVerifySelector failure!")
                    Console.message("... OM='#{@objectModel.jsonTag}' path='#{@objectModelDescriptor.path}' id=#{@objectModelDescriptor.id}")
                    Console.message("... selectKeysRequired=#{@selectKeysRequired} selectKeysProvided=#{@selectKeysProvided} selectKeysReady=#{@selectKeysReady} selectKeyVector.length=#{@selectKeyVector.length}")
                    message = "... selectKeyVector=["
                    first = true
                    for key in @selectKeyVector
                        if not first
                            message += ", "
                        else
                            first = false
                        message += "'#{key}'"
                    message += "]"
                    Console.message(message)
    
                    throw "Encapsule.code.lib.omm.ObjectModelNamespaceSelector failure: #{exception}"
    

            #
            # ============================================================================
            @getSelectKey = (index_) =>
                try
                    @internalVerifySelector()
                    if not index_? then throw "Missing index input parameter!"


                    if (not @selectKeyVector?) or (not @selectKeyVector) or (not @selectKeyVector.length?) or (not @selectKeyVector.length) or (index_ < 0) or (index_ >= @selectKeyVector.length)
                        return undefined

                    return @selectKeyVector[index_]

                catch exception
                    throw "Encapsule.code.lib.omm.ObjectModelNamespaceSelector.getSelectKey failure: #{exception}"


            #
            # ============================================================================
            @getComponentKey = =>
                try
                    @internalVerifySelector()
                    if not (@selectKeyVector? and @selectKeyVector) then return undefined
                    if not (@selectKeyVector.length? and @selectKeyVector.length) then return undefined
                    return @selectKeyVector[@selectKeyVector.length - 1]

                catch exception
                    throw "Encapsule.code.lib.omm.ObjectModelNamespaceSelector.getSelectKey failure: #{exception}"

            #
            # ============================================================================
            # Iff the namespace selector is complete (i.e. @selectKeysReady == true)
            # then return a unique string created by concatenating the selector's path ID
            # and the select keys. Model-view classes (e.g. classes that leverage Knockout.js
            # and D3js) leverage selector hash strings to associate internal state with
            # specific namespaces (e.g. map keys).
            #
            @getHashString = =>
                try
                    @internalVerifySelector()
                    if not @selectKeysReady
                        throw "Unable to retrieve namespace selector hash key of abstract selector."

                    hashKey = "#{@objectModelDescriptor.id}"
                    index = 0
                    for selectKey in (@selectKeyVector? and @selectKeyVector or [])
                        hashKey += index and ":" or "::"
                        hashKey += "#{selectKey}"
                        index++
                    if index
                        hashKey += ""

                    return hashKey

                catch exception
                    throw "Encapsule.code.lib.omm.ObjectModelNamespaceSelector.getHashString failure: #{exception}"

            @clone = =>
                @internalVerifySelector()
                clonedSelectKeyVector = Encapsule.code.lib.js.clone(@selectKeyVector)
                clonedSelector = new Encapsule.code.lib.omm.ObjectModelNamespaceSelector(@objectModel, @pathId, clonedSelectKeyVector)
                clonedSelector.internalVerifySelector()
                return clonedSelector

            #
            # ============================================================================
            if not (objectModel_? and objectModel_) then throw "Missing object model input parameter."
            if not (pathId_?) then throw "Missing object model path parameter."

            if (pathId_ < 0) or (pathId_ >= objectModel_.objectModelDescriptorById.length)
                throw "Out of range path ID specified in request."

            @objectModel = objectModel_
            @pathId = pathId_

            # Get the OM descriptor associated with the specified OM path.

            @objectModelDescriptor = @objectModel.objectModelDescriptorById[pathId_]

            if not (@objectModelDescriptor? and @objectModelDescriptor)
                throw "Unable to resolve object model descriptor for path #{objectModelPath_}"

            if not (@objectModelDescriptor.namespaceDescriptor? and @objectModelDescriptor.namespaceDescriptor)
                Console.message "Object descriptor appears corrupt missing namespace descriptor"
            
            @selectKeyVector = selectKeyVector_? and selectKeyVector_ or []

            @selectKeysProvided = @selectKeyVector.length
            @selectKeysRequired = @objectModelDescriptor.parentPathExtensionPoints.length

            if @selectKeysProvided > @selectKeysRequired
                @selectKeyVector = Encapsule.code.lib.js.clone(selectKeyVector_)
                @selectKeyVector.splice(@selectKeysRequired, @selectKeysProvided - @selectKeysRequired)

            @selectKeysReady = @selectKeysRequired <= @selectKeysProvided
            @internalVerifySelector()


        catch exception
            throw "Encapsule.code.lib.omm.ObjectModelNamespaceSelector construction fail: #{exception}"

