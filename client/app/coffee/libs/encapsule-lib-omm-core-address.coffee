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
# encapsule-lib-omm-core-address.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.omm = Encapsule.code.lib.omm? and Encapsule.code.lib.omm or @Encapsule.code.lib.omm = {}


# ****************************************************************************
# ****************************************************************************
#
#
class Encapsule.code.lib.omm.Address

    constructor: (objectModel_, tokenVector_) ->
        try
            @objectModel = objectModel_? and objectModel_ or throw "Missing required object model input parameter."
            @tokenVector = []
            @parentExtensionPointId = -1
            @rooted = false
            @keysRequired = false
            @keysSpecified = true

            # Performs cloning and validation
            for token in tokenVector_? and tokenVector_ or []
                @pushToken token

        catch exception
            throw "Encapsule.code.lib.omm.Address error: #{exception}"

    #
    # ============================================================================
    pushToken: (token_) =>
        try
            if @tokenVector.length
                parentToken = @tokenVector[@tokenVector.length - 1]
                @validateSelectKeyPair(parentToken, token_)

            @tokenVector.push token_.clone()

            if token_.componentDescriptor.id == 0
                @rooted = true

            if token_.keyRequired
                @keysRequired = true

            if not token_.isReady()
                @keysSpecified = false

        catch exception
            throw "Encapsule.code.lib.omm.Address.pushToken failure: #{exception}"



    #
    # ============================================================================
    validateSelectKeyPair: (parentToken_, childToken_) ->
        try
            if not (parentToken_? and parentToken_ and childToken_? and childToken_)
                throw "Internal error: input parameters are not correct."

            if not childToken_.keyRequired
                throw "Child select key does not require resolution yet is child."

            if parentToken_.namespaceDescriptor.id != childToken_.extensionPointDescriptor.id
                throw "Child select key is invalid because parent select key does not specifiy the expected extension point."

            if not parentToken_.isReady() and childToken_.isReady()
                throw "Parent select key specifies a new instance yet child select key specifies a key."

            true

        catch exception
            throw "Encapsule.code.lib.omm.Address.validateSelectKeyPair failure: #{exception}"

    #
    # ============================================================================
    getHashString: =>


    #
    # ============================================================================
    # clone: =>


    #
    # ============================================================================
    getParent: =>


    #
    # ============================================================================



    #
    # ============================================================================


#
#
# ****************************************************************************
# ****************************************************************************

Encapsule.code.lib.omm.address = {}

#
# ============================================================================
# Builds a rooted, non-recursive, unqualified, address to the subnamespace indicated
# by pathId_ in the namespace indicated by model_.

Encapsule.code.lib.omm.address.FromPathId = (model_, pathId_) ->
    try
        if not (model_? and model_) then throw "Missing object model input parameter."
        if not pathId_? then throw "Missing path input parameter."
        targetDescriptor = model_.getNamespaceDescriptorFromPathId(pathId_)
        newAddress = new Encapsule.code.lib.omm.Address(model_)
        token = undefined
        pathIds = Encapsule.code.lib.js.clone(targetDescriptor.parentPathIdVector)
        pathIds.push(targetDescriptor.id)
        for parentPathId in pathIds
            descriptor = model_.getNamespaceDescriptorFromPathId(parentPathId)
            if descriptor.mvvmType == "archetype"
                newAddress.pushToken token
            token = new Encapsule.code.lib.omm.AddressToken(model_, descriptor.idExtensionPoint, undefined, descriptor.id)
        newAddress.pushToken(token)
        return newAddress
    catch exception
        throw "Encapsule.code.lib.omm.address.FromPath failure: #{exception}"

#
# ============================================================================
Encapsule.code.lib.omm.address.FromPath = (model_, path_) ->
    try
        pathId = model_.getPathIdFromPath(path_)
        newAddress = Encapsule.code.lib.omm.address.FromPathId(model_, pathId)
        return newAddress
    catch exception
        throw "Encapsule.code.lib.omm.address.FromPath failure: #{exception}"


#
# ============================================================================
Encapsule.code.lib.omm.address.Parent = (address_, generations_) ->
    try
        if not (address_? and address_) then throw "Missing address input parameter."
        if not address_.tokenVector.length then "Invalid address contains no address tokens."

        generations = generations_? and generations_ or 1
        tokenSourceIndex = address_.tokenVector.length - 1
        token = address_.tokenVector[tokenSourceIndex--]

        while generations
            descriptor = token.namespaceDescriptor

            # If we have reached the root descriptor we're done regardless of the number
            # of generations the caller requested.

            if descriptor.id == 0
                break

            # If the current descriptor is within a component (i.e. not the component root)
            # then descriptor.parent.id indicates its parent ID from which we can trivially
            # update the current address token.
            #
            # However, if the current descriptor is the root of a component then its parent
            # is by definition an extension point. What makes this complicated is that 
            # the mapping of extension point ID to component ID is 1:1 but the converse is not
            # necessarily true. Component ID to containing extension point ID is 1:N potentially
            # because ONM allows extension points to specify the actual component declaration
            # or to specify a reference to some other component.

            if descriptor.mvvmType != "archetype"
                token = new Encapsule.code.lib.omm.AddressToken(token.model, token.idExtensionPoint, token.key, descriptor.parent.id)
            else
                token = tokenSourceIndex and address_.tokenVector[tokenSourceIndex--] or new Encapsule.code.lib.omm.AddressToken(token.model)

            generations--
                
        newTokenVector = (tokenSourceIndex > 0) and address_.tokenVector.slice(0, tokenSourceIndex + 1) or []
        newAddress = new Encapsule.code.lib.omm.Address(token.model, newTokenVector)
        newAddress.pushToken(token)
        return newAddress

    catch exception
        throw "Encapsule.code.lib.omm.address.Parent failure: #{exception}"


#
# ============================================================================
Encapsule.code.lib.omm.address.ChildFromPath = (address_, subPath_) ->
    try

    catch exception
        throw "Encapsule.code.lib.omm.address.ChildFromPath failure: #{exception}"


