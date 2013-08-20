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
#
# ****************************************************************************
# ****************************************************************************
class Encapsule.code.lib.omm.ObjectModelSelectKey
    constructor: (objectModel_, idExtensionPoint_, key_, idNamespace_) ->
        try
            @objectModel = objectModel_? and objectModel_ or throw "Missing object model input parameter."
            @extensionPointDescriptor = undefined
            if not idNamespace_? then throw "Missing target namespace path ID input parameter."
            idNamespace = idNamespace_
            @namespaceDescriptor = objectModel_.getNamespaceDescriptorFromPathId(idNamespace)
            idComponent = @namespaceDescriptor.idComponent
            @componentDescriptor = @namespaceDescriptor.isComponent and @namespaceDescriptor or objectModel_.getNamespaceDescriptorFromPathId(idComponent)
            @key =  (@componentDescriptor.id > 0) and key_? and key_ or undefined
            @keyRequired = false


            # The namespace specified by idNamespace is contained within a component.
            # If the component ID greater than zero, then not root component.
            # If not the root component, component is child of parent extension point.
            # This means that in order to resolve the root namespace of the component
            # we require (a) the identity of the parent extension point (b) a unique
            # key for the component.

            if @componentDescriptor.id == 0
                return;

            # Parent extension point must be resolved.
            @keyRequired = true

            idExtensionPoint = idExtensionPoint_? and idExtensionPoint_ or -1

            if idExtensionPoint == -1

                if not @componentDescriptor.extensionPointReferenceIds.length
                    idExtensionPoint = @componentDescriptor.parent.id
                else
                    throw "You must explicitly specify the parent extension point's path ID to create a select key addressing a '#{@componentDescriptor.path}' component namespace."

            @extensionPointDescriptor = objectModel_.getNamespaceDescriptorFromPathId(idExtensionPoint)

            if not (@extensionPointDescriptor? and @extensionPointDescriptor)
                throw "Internal error: unable to obtain extension point object model descriptor in request."

            if @extensionPointDescriptor.mvvmType != "extension"
                throw "Invalid selector key object specifies an invalid parent extension point ID. Not an extension point."

            if @extensionPointDescriptor.archetypePathId != @componentDescriptor.id
                throw "Invalid selector key object specifies unsupported extension point / component ID pair."

            return

        catch exception
            throw "Encapsule.code.lib.omm.ObjectModelSelectKey failure: #{exception}"

    #
    # ============================================================================
    clone: => new Encapsule.code.lib.omm.ObjectModelSelectKey(
        @objectModel
        @extensionPointDescriptor? and @extensionPointDescriptor and @extensionPointDescriptor.id or -1
        @key
        @namespaceDescriptor.id
        )

    #
    # ============================================================================
    keyReady: => 
        (not @keyRequired and true) or (@key? and @key and true) or false



# ****************************************************************************
# ****************************************************************************
#
#






#
#
# ****************************************************************************
# ****************************************************************************
class Encapsule.code.lib.omm.ObjectModelNamespaceSelector
    constructor: (objectModel_, pathId_, selectKeyVector_, secondaryKeyVector_) ->
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
            # Iff the namespace selector is complete (i.e. @selectKeysReady == true)
            # then return a unique string created by concatenating the selector's path ID
            # and the select keys. Model-view classes (e.g. classes that leverage Knockout.js
            # and D3js) leverage selector hash strings to associate internal state with
            # specific namespaces (e.g. map keys).
            #
            @getHashString = =>
                try
                    if @hashString? and @hashString
                        return @hashString

                    @internalVerifySelector()
                    if not @selectKeysReady
                        throw "A request has been made for the hash string of an unresolved selector. Only fully resolved selectors have valid hash strings!"

                    hashKey = "#{@objectModelDescriptor.id}"
                    index = 0
                    for selectKey in (@selectKeyVector? and @selectKeyVector or [])
                        hashKey += index and ":" or "::"
                        hashKey += "#{selectKey}"
                        index++

                    index = 0
                    for selectObject in (@secondaryKeyVector? and @secondaryKeyVector or [])
                        hashKey += index and "^" or "*"
                        hashKey += "#{selectObject.idExtensionPoint}:#{selectObject.selectKey}"

                    @hashString = hashKey
                    return hashKey

                catch exception
                    throw "Encapsule.code.lib.omm.ObjectModelNamespaceSelector.getHashString failure: #{exception}"

            #
            # ============================================================================
            @clone = =>
                @internalVerifySelector()
                clonedSelectKeyVector = Encapsule.code.lib.js.clone(@selectKeyVector)
                clonedSecondaryKeyVector = Encapsule.code.lib.js.clone(@secondaryKeyVector)
                clonedSelector = new Encapsule.code.lib.omm.ObjectModelNamespaceSelector(@objectModel, @pathId, clonedSelectKeyVector, clonedSecondaryKeyVector)
                return clonedSelector

            #
            # ============================================================================
            @createParentSelector = =>
                parentSelector = undefined
                parentDescriptor = @objectModelDescriptor.parent
                if parentDescriptor? and parentDescriptor

                    if @objectModelDescriptor.mvvmType != "archetype"
                        parentSelector = new Encapsule.code.lib.omm.ObjectModelNamespaceSelector(@objectModel, parentDescriptor.id, @selectKeyVector, @secondaryKeyVector)

                    else
                        if not @secondaryKeyVector.length
                            selectKeyVector = @selectKeyVector.slice(0, @selectKeyVector.length - 1)
                            parentSelector = new Encapsule.code.lib.omm.ObjectModelNamespaceSelector(@objectModel, parentDescriptor.id, selectKeyVector, undefined)
                        else
                            parentExtensionPointPathId = @secondaryKeyVector[@secondaryKeyVector.length - 1].idExtensionPoint
                            secondaryKeyVector = @secondaryKeyVector.slice(0, @secondaryKeyVector.length - 1)
                            parentSelector = new Encapsule.code.lib.omm.ObjectModelNamespaceSelector(@objectModel, parentExtensionPointPathId, @selectKeyVector, secondaryKeyVector)
                return parentSelector


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
            @secondaryKeyVector = secondaryKeyVector_? and secondaryKeyVector_ or []

            @secondaryKeyVectorResolved = true
            for keyObject in @secondaryKeyVector
                extensionPointDescriptor = objectModel_.getNamespaceDescriptorFromPathId(keyObject.idExtensionPoint)
                if extensionPointDescriptor.mvvmType != "extension"
                    throw "Error validating secondary key vector: key object specifies a non-extension point namespace path."
                if not (keyObject.selectKey? and keyObject.selectKey)
                    @secondaryKeyVectorResolved = false

            @selectKeysProvided = @selectKeyVector.length
            @selectKeysRequired = @objectModelDescriptor.parentPathExtensionPoints.length

            if @selectKeysProvided > @selectKeysRequired
                @selectKeyVector = Encapsule.code.lib.js.clone(selectKeyVector_)
                @selectKeyVector.splice(@selectKeysRequired, @selectKeysProvided - @selectKeysRequired)

            @selectKeysReady = (@selectKeysRequired <= @selectKeysProvided) and @secondaryKeyVectorResolved
            @internalVerifySelector()


        catch exception
            throw "Encapsule.code.lib.omm.ObjectModelNamespaceSelector construction fail: #{exception}"

