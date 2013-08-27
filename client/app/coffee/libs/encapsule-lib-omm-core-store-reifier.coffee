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
                            callbackFunction(@store, observerId_, address_)
                    else
                        for observerId, callbackInterface of @store.observers
                            callbackFunction = callbackInterface[callbackName_]
                            if callbackFunction? and callbackFunction
                                callbackFunction(@store, observerId_, address_)

                catch exception
                    throw "ONMjs.implementation.StoreRefier.dispatchCallback failure: #{exception}"


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


                    throw "Whoops you just stepped on a pile of shit."
                    if not (address_? and address_) then throw "Internal error: Missing address input parameter."



                    componentNamespaceSelector_.internalVerifySelector()

                    # If broadcast (i.e. modelViewObject_ not specified or undefined) AND no observers then return.
                    if ( not (modelViewObserver_? and modelViewObserver_) ) and ( not Object.keys(@modelViewObservers).length )
                        return

                    # MODEL VIEW OBSERVER CALLBACK ORIGIN: onNamespaceRemoved
                    # Invoke the model view object's onNamespaceRemoved callback for each namespace in the root component.
                    # (reverse order - children first, then parent(s))
                    componentNamespaceIdsReverse = Encapsule.code.lib.js.clone(componentNamespaceSelector_.objectModelDescriptor.componentNamespaceIds)
                    componentNamespaceIdsReverse.reverse()
                    for namespaceId in componentNamespaceIdsReverse
                        namespaceSelector = @objectModel.createNamespaceSelectorFromPathId(namespaceId, componentNamespaceSelector_.selectKeyVector, componentNamespaceSelector_.secondaryKeyVector)
                        if modelViewObject_? and modelViewObject_
                            if modelViewObject_.onNamespaceRemoved? and modelViewObject_.onNamespaceRemoved
                                modelViewObject_.onNamespaceRemoved(@, observerId_, namespaceSelector)
                        else
                            for observerId, modelViewObject of @modelViewObservers
                                if modelViewObject.onNamespaceRemoved? and modelViewObject.onNamespaceRemoved
                                    modelViewObject.onNamespaceRemoved(@, observerId, namespaceSelector)
                        @internalRemoveObserverNamespaceState(observerId, namespaceSelector)


                    # MODEL VIEW OBSERVER CALLBACK ORIGIN: onComponentRemoved
                    # Invoke the model view object's onComponentRemoved callback.
                    if modelViewObject_? and modelViewObject_
                        if modelViewObject_.onComponentRemoved? and modelViewObject_.onComponentRemoved
                            modelViewObject_.onComponentRemoved(@, observerId_, componentNamespaceSelector_)
                    else
                        for observerId, modelViewObject of @modelViewObservers
                            if modelViewObject.onComponentRemoved? and modelViewObject.onComponentRemoved
                                modelViewObject.onComponentRemoved(@, observerId, componentNamespaceSelector_)

                    @internalRemoveObserverNamespaceState(observerId, componentNamespaceSelector_)

                    true

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

