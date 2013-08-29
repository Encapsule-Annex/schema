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

encapsule-lib-omm-core-store-reifier.coffee

------------------------------------------------------------------------------

###
#
#
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.omm = Encapsule.code.lib.omm? and Encapsule.code.lib.omm or @Encapsule.code.lib.omm = {}
Encapsule.code.lib.omm.implementation = Encapsule.code.lib.omm.implementation? and Encapsule.code.lib.omm.implementation or @Encapsule.code.lib.omm.implementation = {}

ONMjs = Encapsule.code.lib.omm

#
# ****************************************************************************

class ONMjs.implementation.StoreReifier
    constructor: (objectStore_) ->
        try

            @store = objectStore_

            # 
            # ============================================================================
            @dispatchCallback = (address_, callbackName_, observerId_) =>
                try
                    if observerId_? and observerId_
                        # Use the specified observer ID to obtain the callback interface  registered with the
                        # store and then dispatch the specified callback on that interface only.
                        callbackInterface = @store.observers[observerId_]
                        if not (callbackInterface? and callbackInterface)
                            throw "Internal error: unable to resolve observer ID to obtain callback interface."
                        callbackFunction = callbackInterface[callbackName_]
                        if callbackFunction? and callbackFunction
                            try
                                callbackFunction(@store, observerId_, address_)
                            catch exception
                                throw "Error occurred during execution of externally registerd observer callback function."
                    else
                        for observerId, callbackInterface of @store.observers
                            callbackFunction = callbackInterface[callbackName_]
                            if callbackFunction? and callbackFunction
                                try
                                    callbackFunction(@store, observerId, address_)
                                catch exception
                                    throw "Error occurred during execution of externally registered observer callback function."

                catch exception
                    exceptionMessage = "ONMjs.implementation.StoreRefier.dispatchCallback failure while processing " +
                        "address='#{address_.getHashString()}', callback='#{callbackName_}', observer='#{observerId_? and observerId_ or "[broadcast all]"}': #{exception}"
                    throw exceptionMessage


            # 
            # ============================================================================
            @reifyStoreComponent = (address_, observerId_) =>
                try
                    if not (address_? and address_) then throw "Internal error: Missing address input parameter."

                    # Return immediately if there are no observers registered.
                    if not Encapsule.code.lib.js.dictionaryLength(@store.observers) then return

                    dispatchCallback = @dispatchCallback
                    dispatchCallback(address_, "onComponentCreated", observerId_)
                    address_.visitSubnamespacesAscending( (addressSubnamespace_) -> dispatchCallback(addressSubnamespace_, "onNamespaceCreated", observerId_) )

                    true # that

                catch exception
                    throw "Encapsule.code.lib.omm.StoreBase.reifyStoreComponent failure: #{exception}"


            # 
            # ============================================================================
            @unreifyStoreComponent = (address_, observerId_) =>
                try

                    if not (address_? and address_) then throw "Internal error: Missing address input parameter."

                    # Return immediately if there are no observers registered.
                    if not Encapsule.code.lib.js.dictionaryLength(@store.observers) then return

                    dispatchCallback = @dispatchCallback
                    address_.visitSubnamespacesDescending( (addressSubnamespace_) -> dispatchCallback(addressSubnamespace_, "onNamespaceRemoved", observerId_) )
                    dispatchCallback(address_, "onComponentRemoved", observerId_)

                    true # that

                catch exception
                    throw "Encapsule.code.lib.omm.StoreBase.internalUnreifyStoreComponent failure: #{exception}"

            # 
            # ============================================================================
            @reifyStoreExtensions = (address_, observerId_, undoFlag_) =>
                try
                    if not (address_? and address_) then throw "Internal error: Missing address input parameter."

                    # Return immediately if there are no observers registered.
                    if not Encapsule.code.lib.js.dictionaryLength(@store.observers) then return

                    dispatchCallback = @dispatchCallback

                    address_.visitExtensionPoints( (addressExtensionPoint_) =>
                        extensionPointNamespace = new ONMjs.Namespace(@store, addressExtensionPoint_)
                        extensionPointNamespace.visitExtensionPointSubcomponents( (addressSubcomponent_) =>
                            if not undoFlag_
                                @reifyStoreComponent(addressSubcomponent_, observerId_)
                                @reifyStoreExtensions(addressSubcomponent_, observerId_, false)
                            else
                                @reifyStoreExtensions(addressSubcomponent_, observerId_, true)
                                @unreifyStoreComponent(addressSubcomponent_, observerId_)
                            true
                        )
                        true
                    )

                catch exception
                    throw "Encapsule.code.lib.omm.StoreBase.internalReifyStoreExtensions failure: #{exception}"

        catch exception
            throw "Encapsule.code.lib.omm.StoreBase constructor failed: #{exception}"

