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
Encapsule.code.lib.omm = Encapsule.code.lib.omm? and Encapsule.code.lib.omm or @Encapsule.code.lib.omm = {}

ONMjs = Encapsule.code.lib.omm

class ONMjs.Namespace
    constructor: (store_, address_, mode_) ->
        try
            if not (store_? and store_) then throw "Missing object store input parameter."
            @store = store_

            # As a matter of policy, if no address is specified or if a zero-length address is specified, open the root namespace.
            address = undefined
            if not (address_? and address_ and address_.tokenVector.length)
                objectModel = store_.model
                address = new ONMjs.Address(objectModel, [ new ONMjs.AddressToken(objectModel, undefined, undefined, 0) ] )
            else
                address = address_
            
            # Ensure that address and store objects were both created using the same model.
            objectModelNameStore = store_.model.jsonTag
            objectModelNameKeys = address.model.jsonTag
            if objectModelNameStore != objectModelNameKeys
                throw "You cannot access a '#{objectModelNameStore}' store namespace with a '#{objectModelNameKeys}' object model address!"

            # Token in the address specifies a root component namespace?
            if not address.isComplete() then throw "Specified address is invalid because the first address token does not specify the object store's root component."

            mode = mode_? and mode_ or "bypass"

            if (mode != "new") and not address.isResolvable()
                throw "Specified address is unresolvable in #{mode} mode."

            # The actual store data.
            @dataReferences = []
            dataReference = store_.dataReference? and store_.dataReference or throw "Cannot resolve object store's root data reference."
            @dataReferences.push dataReference
            
            @addressTokenBinders = for addressToken in address.tokenVector
                tokenBinder = new ONMjs.implementation.AddressTokenBinder(store_, dataReference, addressToken, mode)
                dataReference = tokenBinder.dataReference
                @dataReferences.push dataReference
                tokenBinder

            @resolvedAddress = undefined

        catch exception
            throw "ONMjs.Namespace failure: #{exception}"

    #
    # ============================================================================
    getResolvedAddress: =>
        try
            if @resolvedAddress? and @resolvedAddress
                return @resolvedAddress
            resolvedTokenVector = for addressTokenBinder in @addressTokenBinders
                addressTokenBinder.resolvedToken
            @resolvedAddress = new ONMjs.Address(@store.model, resolvedTokenVector)
            return @resolvedAddress
        catch exception
            throw "ONMjs.Namespace.address failure: #{exception}"


    #
    # ============================================================================
    getResolvedLabel: =>
        try
            # TODO: This needs to take advantage of semantic bindings. Currently
            # this is the unsophisticated version.

            resolvedDescriptor = @getLastBinder().resolvedToken.namespaceDescriptor
            return resolvedDescriptor.label
            
        catch exception
            throw "ONMjs.Namespace.getResolvedLabel failure: #{exception}"

    #
    # ============================================================================
    data: =>
        try
            dataReferences = @dataReferences.length
            if not dataReferences
                throw "Internal error: Unable to retrieve data reference from Namespace object."
            dataReference = @dataReferences[dataReferences - 1]

        catch exception
            throw "ONMjs.Namespace.data failure: #{exception}"

    #
    # ============================================================================
    toJSON: (replacer_, space_) =>
        try
            namespaceDescriptor = @getLastBinder().resolvedToken.namespaceDescriptor
            resultObject = {}
            resultObject[namespaceDescriptor.jsonTag] = @data()
            space = space_? and space_ or 0
            resultJSON = JSON.stringify(resultObject, replacer_, space)
            if not (resultJSON? and resultJSON)
                throw "Cannot serialize Javascript object to JSON!"
            return resultJSON

        catch exception
            throw "ONMjs.Namespace.toJSON failure: #{exception}"



    #
    # ============================================================================
    update: =>
        try
            # First update the store namespace data and all its parents.
            # Note the search direction is fixed but the callback is defined in the
            # object model declaration (or not).

            address = @getResolvedAddress()
            semanticBindings = @store.model.getSemanticBindings()
            updateAction = semanticBindings? and semanticBindings and semanticBindings.update? and semanticBindings.update or undefined

            # Update all the parent namespaces. (may mutate store data depending on updateAction implementation)
            if updateAction? and updateAction
                updateAction(@data())
                address.visitParentAddressesDescending( (address__) =>
                    dataReference = @store.openNamespace(address__).data()
                    updateAction(dataReference))


            # Now we need to generate some observer notification.
            count = 0
            containingComponentNotified = false
            while address? and address
                descriptor = address.getDescriptor()
                if count == 0
                    @store.reifier.dispatchCallback(address, "onNamespaceUpdated", undefined)
                else
                    @store.reifier.dispatchCallback(address, "onSubnamespaceUpdated", undefined)

                if descriptor.mvvmType == "archetype" or descriptor.mvvmType == "root"
                   if not containingComponentNotified
                       @store.reifier.dispatchCallback(address, "onComponentUpdated", undefined)
                       containingComponentNotified = true
                   else
                       @store.reifier.dispatchCallback(address, "onSubcomponentUpdated", undefined)

                address = ONMjs.address.Parent(address) # returns undefined if address == root namespace of the store
                count++
            
        catch exception
            throw "ONMjs.Namespace.update failure: #{exception}"



    #
    # ============================================================================
    # This is pretty low-level for a public-facing API?
    getLastBinder: => @addressTokenBinders.length and @addressTokenBinders[@addressTokenBinders.length - 1] or throw "Internal error: unable to retrieve the last token binder for this namespace."

    #
    # ============================================================================
    visitExtensionPointSubcomponents: (callback_) =>
        try
            resolvedToken = @getLastBinder().resolvedToken
            if not (resolvedToken? and resolvedToken) then throw "Internal error: unable to resolve token."

            if resolvedToken.namespaceDescriptor.mvvmType != "extension"
                throw "You may only visit the subcomponents of an extension point namespace."

            for key, object of @data()
                address = @getResolvedAddress().clone()
                token = new ONMjs.AddressToken(@store.model, resolvedToken.idNamespace, key, resolvedToken.namespaceDescriptor.archetypePathId)
                address.pushToken(token)
                callback_(address)

            true

        catch exception
            throw "ONMjs.Namepsace.visitExtensionPointSubcomponents failure: #{exception}"
    # ============================================================================


