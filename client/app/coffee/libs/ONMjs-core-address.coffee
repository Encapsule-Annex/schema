###
------------------------------------------------------------------------------

The MIT License (MIT)

Copyright (c) 2013 Encapsule Project
  
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

**** Encapsule Project :: Build better software with circuit models ****

OPEN SOURCES: http://github.com/Encapsule HOMEPAGE: http://Encapsule.org
BLOG: http://blog.encapsule.org TWITTER: https://twitter.com/Encapsule

------------------------------------------------------------------------------



------------------------------------------------------------------------------

###
#
#
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.onm = Encapsule.code.lib.onm? and Encapsule.code.lib.onm or @Encapsule.code.lib.onm = {}

ONMjs = Encapsule.code.lib.onm

# ****************************************************************************
# ****************************************************************************
#
#
class ONMjs.Address

    constructor: (model_, tokenVector_) ->
        try
            @model = model_? and model_ or throw "Missing required object model input parameter."
            @tokenVector = []
            @parentExtensionPointId = -1

            # Addresses are said to be either complete or partial.
            # A complete address has one or more tokens and the first token refers to the root component.
            # A partial address has one or more tokens and the first token refers to a non-root component.
            @complete = false # set true iff first token refers to the root component
            @isComplete = => @complete

            # Addresses are said to be either qualified or unqualified.
            # A qualified address contains tokens that all specifiy a key (if required). Qualified addresses
            # may be resolved against a Store object when they're also complete addresses.
            # An unqualified address contains one or more tokens that do not specify a key (where required).
            # Unqualified addresses may only be used to create new components within a Store instance.

            @keysRequired = false
            @keysSpecified = true
            @isQualified = => not @keysRequired or @keysSpecified

            # Addresses are said to be resolvable, creatable, or unresolvable
            # A resolvable address is both complete and qualified meaning that it specifies both a complete
            # and unambiguous chain of tokens leading to the addressed namespace. A creatable address is
            # a complete but unqualified address. A creatable address may be used to create a component but
            # cannot be used to open a namespace. All incomplete addresses are by definition unresolvable;
            # because both namespace create and open operations performed by an object store must be able
            # to verify the entire path to the target namespace and this cannot be done if the first token
            # in an address does not address the store's root component.
            @isResolvable = => @isComplete() and @isQualified()
            @isCreatable = => @isComplete() and @keysRequired and not @keysSpecified

            # Performs cloning and validation
            for token in tokenVector_? and tokenVector_ or []
                @pushToken token

            # The following globals are used to cache namesapce traversal paths
            # on the first call to the related vistor function. Subsequent calls
            # on the same address object do not incur the overhead of recalculation.
            @parentAddressesAscending = undefined
            @parentAddressesDescending = undefined
            @subnamespaceAddressesAscending = undefined
            @subnamespaceAddressesDescending = undefined
            @subcomponentAddressesAscending = undefined
            @subcomponentsAddressesDescending = undefined

            @humanReadableString = undefined
            @hashString = undefined

        catch exception
            throw "ONMjs.Address error: #{exception}"

    #
    # ============================================================================
    pushToken: (token_) =>
        try
            if @tokenVector.length
                parentToken = @tokenVector[@tokenVector.length - 1]
                @validateTokenPair(parentToken, token_)

            @tokenVector.push token_.clone()

            if token_.componentDescriptor.id == 0
                @complete = true

            if token_.keyRequired
                @keysRequired = true

            if not token_.isQualified()
                @keysSpecified = false

            # Pushing a token changes the address so we must clear the cached hash string
            # so it's recomputed upon request.
            @humanReadableString = undefined
            @hashString = undefined

        catch exception
            throw "ONMjs.Address.pushToken failure: #{exception}"

    #
    # ============================================================================
    validateTokenPair: (parentToken_, childToken_) ->
        try
            if not (parentToken_? and parentToken_ and childToken_? and childToken_)
                throw "Internal error: input parameters are not correct."

            if not childToken_.keyRequired
                throw "Child select key does not require resolution yet is child."

            if parentToken_.namespaceDescriptor.id != childToken_.extensionPointDescriptor.id
                throw "Invalid token specifies an extension point ID that doesn't match the parent container's extension point ID."

            if not parentToken_.isQualified() and childToken_.isQualified()
                throw "Invalid token specifies a key without parent key context."

            true

        catch exception
            throw "ONMjs.Address.validateTokenPair failure: #{exception}"

    #
    # ============================================================================
    getHumanReadableString: =>
        try
            if @humanReadableString? and @humanReadableString
                return @humanReadableString

            index = 0
            humanReadableString = ""

            for token in @tokenVector
                if not index
                    humanReadableString += "#{token.model.jsonTag}:"

                if token.key? and token.key
                    humanReadableString += "[#{token.key}]."
                else
                    if token.idExtensionPoint > 0
                        humanReadableString += "[*]."
                    
                humanReadableString += "#{token.idNamespace}"
                index++

            @humanReadableString = humanReadableString
            return humanReadableString

        catch exception
            throw "ONMjs.Address.getHumanReadbleString failure: #{exception}"
    #
    # ============================================================================
    getHashString: =>
        try
            if @hashString? and @hashString
                return @hashString

            humanReadableString = @getHumanReadableString()

            # Given that an ONMjs object model is a singly-rooted tree structure, the raw
            # hash strings of different addresses created for the same object model all share
            # a common string prefix. All the information in the hash string is required to
            # reconstruct the address if the hash is used as a URN. However, for local in-app
            # processing, address hash strings are used as dictionary keys typically (e.g.
            # to open observer state). Speed equality/relational operations on hash string
            # by reversing the raw string (so that the common prefix appears at the tail
            # and does not need to evaluated typically). Note that WE DO NOT CARE if we break
            # Unicode character encoding here; the string is base64 encoded anyway and is
            # generally meaningless to humans, and the original string may be recovered
            # by reversing the process. https://github.com/mathiasbynens/esrever is a good
            # sample of how one should reverse a string if maintaining Unicode is important.

            reversedHashString = humanReadableString.split('').reverse().join('')
            @hashString = window.btoa(reversedHashString)
            return @hashString
            
        catch exception
            throw "ONMjs.Address.getHashString failure: #{exception}"

    #
    # ============================================================================
    isRoot: =>
        try
            token = @getLastToken()
            root = token.idNamespace == 0 and true or false
            return root
        catch exception
            throw "CNMjs.Address.isRoot failure: #{exception}"

    #
    # ============================================================================
    isEqual: (address_) =>
        try
            if not (address_? and address_) then throw "Missing address input parameter."
            if @tokenVector.length != address_.tokenVector.length then return false
            result = true
            index = 0
            while index < @tokenVector.length
                tokenA = @tokenVector[index]
                tokenB = address_.tokenVector[index]
                if not tokenA.isEqual(tokenB)
                    result = false
                    break
                index++
            return result
        catch exception
            throw "ONMjs.Address.isEqual failure: #{exception}"

    #
    # ============================================================================
    clone: => 
        try
            new ONMjs.Address(@model, @tokenVector)
        catch exception
            throw "ONMjs.Address.clone failure: #{exception}"
        
    #
    # ============================================================================
    getLastToken: =>
        try
            @tokenVector.length and @tokenVector[@tokenVector.length - 1] or throw "Internal error: unable to resolve last token in ONMjs.Address."
        catch exception
            throw "ONMjs.Address.getLastToken failure: #{exception}"

    
    #
    # ============================================================================
    getDescriptor: =>
        try
            return @getLastToken().namespaceDescriptor

        catch exception
            throw "ONMjs.Address.getDescriptor failure: #{exception}"


    #
    # ============================================================================
    getNamespaceModelDeclaration: =>
        try
            return @getDescriptor().namespaceModelDeclaration

        catch exception
            throw "ONMjs.Address.getNamespaceModelDeclaration failure: #{exception}"


    #
    # ============================================================================
    getNamespaceModelPropertiesDeclaration: =>
        try
            return @getDescriptor().namespaceModelPropertiesDeclaration

        catch exception
            throw "ONMjs.Address.getNamespaceModelPropertiesDeclaration failure: #{exception}"



    #
    # ============================================================================
    visitParentAddressesAscending: (callback_) =>
        try
            if not (callback_? and callback_) then return false
            if not (@parentAddressesAscending? and @parentAddressesAscending)
                @parentAddressesAscending = []
                @visitParentAddressesDescending( (address__) => @parentAddressesAscending.push(address__); true )
                @parentAddressesAscending.reverse()
            if not @parentAddressesAscending.length then return false
            for address in @parentAddressesAscending
                callback_(address)
            true # that
        catch exception
            throw "ONMjs.Address.visitParentAddressesAscending failure: #{exception}"
        
    #
    # ============================================================================
    visitParentAddressesDescending: (callback_) =>
        try
            if not (callback_? and callback_) then return false
            if not (@parentAddressesDesending? and @parentAddressesDesceding)
                @parentAddressesDescending = []
                parent = ONMjs.address.Parent(@)
                while parent
                    @parentAddressesDescending.push parent
                    parent = ONMjs.address.Parent(parent)
            if not @parentAddressesDescending.length then return false
            for address in @parentAddressesDescending
                callback_(address)
            true # that

        catch exception
            throw "ONMjs.Address.visitParentAddressesDescending failure: #{exception}"

    #
    # ============================================================================
    visitSubaddressesAscending: (callback_) =>
        try
            if not (callback_? and callback_) then return false
            if not (@subnamespaceAddressesAscending? and @subnamespaceAddressesAscending)
                @subnamespaceAddressesAscending = []
                namespaceDescriptor = @getLastToken().namespaceDescriptor
                for subnamespacePathId in namespaceDescriptor.componentNamespaceIds
                    subnamespaceAddress = ONMjs.address.NewAddressSameComponent(@, subnamespacePathId)
                    @subnamespaceAddressesAscending.push subnamespaceAddress
            for address in @subnamespaceAddressesAscending
                callback_(address)
            true # that
        catch exception
            throw "ONMjs.Address.visitSubaddressesAscending failure: #{exception}"

    #
    # ============================================================================
    visitSubaddressesDescending: (callback_) =>
        try
            if not (callback_ and callback_) then return false
            if not (@subnamespaceAddressesDescending? and @subnamespaceAddressesDescending)
                @subnamespaceAddressesDescending = []
                @visitSubaddressesAscending( (address__) => @subnamespaceAddressesDescending.push address__ )
                @subnamespaceAddressesDescending.reverse()
            for address in @subnamespaceAddressesDescending
                callback_(address)
            true # that
        catch exception
            throw "ONMjs.Address.visitSubaddressesAscending failure: #{exception}"

    #
    # ============================================================================
    visitExtensionPointAddresses: (callback_) =>
        try
            if not (callback_? and callback_) then return false
            if not (@extensionPointAddresses? and @extensionPointAddresses)
                @extensionPointAddresses = []
                namespaceDescriptor = @getLastToken().namespaceDescriptor
                for path, extensionPointDescriptor of namespaceDescriptor.extensionPoints
                    extensionPointAddress = ONMjs.address.NewAddressSameComponent(@, extensionPointDescriptor.id)
                    @extensionPointAddresses.push extensionPointAddress
            for address in @extensionPointAddresses
                callback_(address)
            true # that
        catch exception
            throw "ONMjs.Address.visitExtensionPointAddresses failure: #{exception}"









#
#
# ****************************************************************************
# ****************************************************************************

ONMjs.address = {}

#
# ============================================================================
ONMjs.address.ModelPathFromAddress = (address_) ->
    try
        if not (address_? and address_) then throw "Missing address input parameter.";
        if not address_.tokenVector.length then throw "Invalid address contains no address tokens."
        lastToken = address_.getLastToken()
        return lastToken.namespaceDescriptor.path

    catch exception
        throw "ONMjs.address.ModelPathFromAddress failure: #{exception}"

#
# ============================================================================
ONMjs.address.ModelDescriptorFromAddressAndSubpath = (address_, subpath_) ->
    try
        if not (subpath_? and subpath_) then throw "Missing subpath input parameter."
        path = "#{ONMjs.address.ModelPathFromAddress(address_)}.#{subpath_}"
        return descriptor = address_.model.getNamespaceDescriptorFromPath(path)


    catch exception
        throw "ONMjs.address.CreateNewModelPathFromAddressAndSubpath failure: #{exception}"

#
# ============================================================================
ONMjs.address.Synthesize = (address_, subpath_) ->
    try
        subpathDescriptor = ONMjs.address.ModelDescriptorFromAddressAndSubpath(address_, subpath_)
        baseDescriptor = address_.getLastToken().namespaceDescriptor

        if ((baseDescriptor.namespaceType == "extensionPoint") and (subpathDescriptor.namespaceType != "component"))
            throw "Invalid subpath string must begin with the name of the component contained by the base address' extension point."

        baseDescriptorHeight = baseDescriptor.parentPathIdVector.length
        subpathDescriptorHeight = subpathDescriptor.parentPathIdVector.length

        if ((subpathDescriptorHeight - baseDescriptorHeight) <= 0)
            throw "Internal error due to failed consistency check."

        subpathParentIdVector = subpathDescriptor.parentPathIdVector.slice(baseDescriptorHeight + 1, subpathDescriptorHeight)
        subpathParentIdVector.push subpathDescriptor.id
        baseTokenVector = address_.tokenVector.slice(0, address_.tokenVector.length - 1) or []
        newAddress = new ONMjs.Address(address_.model, baseTokenVector)
        token = address_.getLastToken().clone()
        
        for pathId in subpathParentIdVector
            descriptor = address_.model.getNamespaceDescriptorFromPathId(pathId)

            switch descriptor.namespaceType
                when "component"
                    newAddress.pushToken(token)
                    token = new ONMjs.AddressToken(token.model, token.namespaceDescriptor.id, undefined, pathId)
                    break
                else
                    token = new ONMjs.AddressToken(token.model, token.idExtensionPoint, token.key, pathId)

        newAddress.pushToken(token)
        return newAddress

    catch exception
        throw "ONMjs.address.SynthesizeAddress(address_, subpath_) failure: #{exception}"

#
# ============================================================================
ONMjs.address.RootAddress = (model_) ->
   try
       return new ONMjs.Address(model_, [ new ONMjs.AddressToken(model_, undefined, undefined, 0) ])
   catch exception
       throw "ONMjs.address.RootAddress failure: #{exception}"
#
# ============================================================================
# Builds a rooted, non-recursive, unqualified, address to the subnamespace indicated
# by pathId_ in the address space indicated by model_.

ONMjs.address.FromPathId = (model_, pathId_) ->
    try
        if not (model_? and model_) then throw "Missing object model input parameter."
        if not pathId_? then throw "Missing path input parameter."
        targetDescriptor = model_.getNamespaceDescriptorFromPathId(pathId_)
        newAddress = new ONMjs.Address(model_)
        token = undefined
        pathIds = Encapsule.code.lib.js.clone(targetDescriptor.parentPathIdVector)
        pathIds.push(targetDescriptor.id)
        for parentPathId in pathIds
            descriptor = model_.getNamespaceDescriptorFromPathId(parentPathId)
            if descriptor.namespaceType == "component"
                newAddress.pushToken token
            token = new ONMjs.AddressToken(model_, descriptor.idExtensionPoint, undefined, descriptor.id)
        newAddress.pushToken(token)
        return newAddress
    catch exception
        throw "ONMjs.address.FromPath failure: #{exception}"

#
# ============================================================================
ONMjs.address.FromPath = (model_, path_) ->
    try
        pathId = model_.getPathIdFromPath(path_)
        newAddress = ONMjs.address.FromPathId(model_, pathId)
        return newAddress
    catch exception
        throw "ONMjs.address.FromPath failure: #{exception}"


#
# ============================================================================
# Return the parent address (defaults to a single generation) or undefined
# if no parent address exists.
ONMjs.address.Parent = (address_, generations_) ->
    try
        if not (address_? and address_) then throw "Missing address input parameter."
        if not address_.tokenVector.length then throw "Invalid address contains no address tokens."

        generations = generations_? and generations_ or 1
        tokenSourceIndex = address_.tokenVector.length - 1
        token = address_.tokenVector[tokenSourceIndex--]

        if token.namespaceDescriptor.id == 0
            return undefined

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

            if descriptor.namespaceType != "component"
                token = new ONMjs.AddressToken(token.model, token.idExtensionPoint, token.key, descriptor.parent.id)
            else
                token = (tokenSourceIndex != -1) and address_.tokenVector[tokenSourceIndex--] or throw "Internal error: exhausted token stack."

            generations--
                
        newTokenVector = ((tokenSourceIndex < 0) and []) or address_.tokenVector.slice(0, tokenSourceIndex + 1)
        newAddress = new ONMjs.Address(token.model, newTokenVector)
        newAddress.pushToken(token)
        return newAddress

    catch exception
        throw "ONMjs.address.Parent failure: #{exception}"





#
# ============================================================================
# Given a source address, generate a new address to another namespace within
# the component specified by the source address.

ONMjs.address.NewAddressSameComponent = (address_, pathId_) ->
    try

        if not (address_? and address_) then throw "Missing address input parameter."
        if not (pathId_?  and pathId_ > -1) then throw "Missing namespace path ID input parameter."
        addressedComponentToken = address_.getLastToken()
        addressedComponentDescriptor = addressedComponentToken.componentDescriptor

        targetNamespaceDescriptor = address_.model.getNamespaceDescriptorFromPathId(pathId_)
        if targetNamespaceDescriptor.idComponent != addressedComponentDescriptor.id
            throw "Invalid path ID specified does not resolve to a namespace in the same component as the source address."

        newToken = new ONMjs.AddressToken(address_.model, addressedComponentToken.idExtensionPoint, addressedComponentToken.key, pathId_)

        newTokenVector = address_.tokenVector.length > 0 and address_.tokenVector.slice(0, address_.tokenVector.length - 1) or []
        newTokenVector.push newToken
        newAddress = new ONMjs.Address(address_.model, newTokenVector)

        return newAddress

    catch exception
        throw "ONMjs.address.NewAddressSameComponent failure: #{exception}"



#
# ============================================================================
# Given a source address, determine if it specifies the root namespame
# of the store or an extension component. If it does, simply return a reference
# to the source address. Otherwise, create and return a new address that
# specifies the source address' owning component address.

ONMjs.address.ComponentAddress = (address_) ->
    try
        if not (address_? and address_) then throw "Missing address input parameter."
        descriptor = address_.getDescriptor()
        if descriptor.isComponent
            return address_
        return ONMjs.address.NewAddressSameComponent(address_, descriptor.idComponent)

    catch excpetion
        throw "ONMjs.address.ComponentAddress failure: #{exception}"

