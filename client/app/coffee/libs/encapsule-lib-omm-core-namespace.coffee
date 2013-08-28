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


class Encapsule.code.lib.omm.Namespace
    constructor: (store_, address_, mode_) ->
        try
            if not (store_? and store_) then throw "Missing object store input parameter."
            @store = store_

            # As a matter of policy, if no address is specified or if a zero-length address is specified, open the root namespace.
            address = undefined
            if not (address_? and address_ and address_.tokenVector.length)
                objectModel = store_.model
                address = new Encapsule.code.lib.omm.Address(objectModel, [ new Encapsule.code.lib.omm.AddressToken(objectModel, undefined, undefined, 0) ] )
            else
                address = address_
            
            # Ensure that address and store objects were both created using the same model.
            objectModelNameStore = store_.model.jsonTag
            objectModelNameKeys = address.model.jsonTag
            if objectModelNameStore != objectModelNameKeys
                throw "You cannot create a '#{objectModelNameStore}' store namespace with a '#{objectModelNameKeys}' select key vector."

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
                tokenBinder = new Encapsule.code.lib.omm.implementation.AddressTokenBinder(store_, dataReference, addressToken, mode)
                dataReference = tokenBinder.dataReference
                @dataReferences.push dataReference
                tokenBinder

        catch exception
            throw "Encapsule.code.lib.omm.Namespace failure: #{exception}"

    #
    # ============================================================================
    address: =>
        try
            if not (@address? and @address)
                resolvedTokenVector = for addressTokenBinder in @addressTokenBinders
                    addressTokenBinder.resolvedToken
                newAddress = @address = new ONMjs.Address(@model, resolvedTokenVector)
                return newAddress

        catch exception
            throw "ONMjs.Namespace.address failure: #{exception}"


    #
    # ============================================================================
    getResolvedLabel: =>
        try
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
            throw "Encapsule.code.lib.omm.Namespace.data failure: #{exception}"

    #
    # ============================================================================
    update: =>
        try
            # First update the store namespace data and all its parents.
            # Note the search direction is fixed but the callback is defined in the
            # object model declaration (or not).

            semanticBindings = @store.model.getSemanticBindings()
            updateAction = semanticActions? and semanticActions and semanticActions.update? and semanticActions.update or undefined

            # Update all the parent namespaces. (may mutate store data depending on updateAction implementation)
            if updateAction? and updateAction
                ### Does this need to be reversed? ###
                for dataReference in @dataReferences
                    updateAction(dataReference)

            # Now we need to generate some observer notification.
            address = @address()
            count = 0
            containingComponentNotified = false
            while address? and address
                token = address.getLastToken()
                descriptor = token.namespaceDescriptor
                if count == 0
                    @store.reify.dispatchCallback(address, "onNamespaceUpdated", undefined)
                else
                    @store.reify.dispatchCallback(address, "onSubnamespaceUpdated", undefined)

                if descriptor.mvvmType == "archetype" or descriptor.mvvmType == "root"
                   if not containingComponentNotified
                       @store.reifier.dispatchCallback(address, "onComponentUpdated", undefined)
                       containingComponentNotified = true
                   else
                       @store.reifier.dispatchCallback(address, "onSubcomponentUpdated", undefined)

                if address.isRoot()
                    break

                ONMjs.address.Parent(address)
            
        catch exception
            throw "Encapsule.code.lib.omm.Namespace.update failure: #{exception}"



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
                address = @address()
                token = ONMjs.AddressToken(@model, resolvedToken.namespaceDescriptor.id, key, resolvedToken.namespaceDescriptor.idArchetype)
                address.pushToken(token)
                callback_(address)

            true

        catch exception
            throw "ONMjs.Namepsace.visitExtensionPointSubcomponents failure: #{exception}"
    # ============================================================================


