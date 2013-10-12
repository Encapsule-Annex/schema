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
ONMjs.observers = ONMjs.observers? and ONMjs.observers or ONMjs.observers = {}



class ONMjs.observers.NavigatorModelView
    constructor: ->
        # \ BEGIN: constructor
        try
            @objectStore = undefined
            @rootMenuModelView = undefined

            # Navigator may be attached to a single ONMjs.Store object as an observer. Once registered as an
            # ONMjs.Store observer, Navigator will throw an exception if it receives callbacks from the same
            # or other store using an unknown observerId.

            # Navigator may observe a single ONMjs.Store instance.
            @store = undefined
            @storeObserverId = undefined

            # User click events write a new selection address to a ONMjs.CachedAddress.
            # Which CachedAddress to write is selected by @currentlySelectedCachedAddress.
            @selectedCachedAddressSinkStore = undefined

            #
            # ============================================================================
            @attachToStore = (store_) =>
                try
                    if not (store_? and store_) then throw "Missing store input parameter."
                    if @storeObserverId? and @storeObserverId then throw "This navigator instance is already observing an ONMjs.Store instance."
                    @store = store_
                    @storeObserverId = store_.registerObserver(@objectStoreObserverInterface, @)
                    true
                catch exception
                   throw "ONMjs.observers.NavigatorModelView.attachToStore failure: #{exception}"

            #
            # ============================================================================
            @detachFromStore = =>
                try
                    if not @storeObserverId? and @storeObserverId then throw "This navigator instance is not attached to an ONMjs.Store instance."
                    @store.unregisterObserver(@storeObserverId)
                    @storeObserverId = undefined
                    true
                catch exception
                    throw "ONMjs.observers.NavigatorModelView.detachFromStore failure: #{exception}"

            #
            # ============================================================================
            @attachToCachedAddress = (cachedAddress_) =>
                try
                    if not (cachedAddress_? and cachedAddress_) then throw "Missing cached address input parameter."
                    observerId = cachedAddress_.registerObserver(@cachedAddressObserverInterface, @)
                    return observerId
                catch exception
                    throw "ONMjs.observers.NavigatorModelView.attachToCachedAddress failure: #{excpetion}"

            #
            # ============================================================================
            @detachFromCachedAddress = (cachedAddres_, observerId_) =>
                try
                    if not (cachedAddress_? and cachedAddres_) then throw "Missing cached address input parameter."
                    if not (observerId_? and observerId_) then throw "Missing observer ID input parameter."
                    cachedAddress_.unregisterObserver(observerId_)
                    true
                catch exception
                    throw "ONMjs.observers.NavigatorModelView.detachFromCachedAddress failure: #{exception}"

            #
            # ============================================================================
            @setCachedAddressSinkStore = (cachedAddress_) =>
                try
                    if not (cachedAddress_? and cachedAddress_) then throw "Missing cached address input parameter."
                    @selectedCachedAddressSinkStore = cachedAddress_

                catch exception
                    throw "ONMjs.observers.NavigatorModelView.setCachedAddressSinkStore failure: #{exception}"


            #
            # ============================================================================
            @routeUserSelectAddressRequest = (address_) =>
                try
                    if @selectedCachedAddressSinkStore? and @selectedCachedAddressSinkStore
                        @selectedCachedAddressSinkStore.setAddress(address_)
                        return
                    message = "ONMjs.obsevers.NavigatorModelView.routeUserSelectAddressRequest for address  '#{address_.getHashString()}'failed. " +
                        "setCachedAddressSinkStore method must be called to set the routing destination."
                    alert(message)
                    
                
                catch exception
                    throw "ONMjs.observers.NavigatorModelView.routeUserSelectAddressRequest failure: #{exception}"

            #
            # ============================================================================
            # ONMjs.Store OBSERVER INTERFACE
            #
            @objectStoreObserverInterface = {

                #
                # ----------------------------------------------------------------------------
                onObserverAttachBegin: (store_, observerId_) =>
                    try
                        Console.message("ONMjs.observer.NavigatorModelview is now observing ONMjs.Store.")
                        if @storeObserverId? and @storeObserverId
                            throw "This navigator instance is already observing an ONMjs.Store."
                        @storeObserverId = observerId_
                        true
                    catch exception
                        throw "ONMjs.observers.NavigatorModelView.objectStoreObserverCallbacks.onObserverAttach failure: #{exception}"

                #
                # ----------------------------------------------------------------------------
                onObserverDetachEnd: (store_, observerId_) =>
                    try
                        Console.message("ONMjs.observers.NavigatorModelView is no longer observing ONMjs.Store.")
                        if not (@storeObserverId? and @storeObserverId)
                            throw "Internal error: received detach callback but it doesn't apprear we're attached?"
                        if @storeObserverId != observerId_
                            throw "Internal error: received detach callback for un unrecognized observer ID?"
                        @storeObserverId = undefined
                        true

                    catch exception
                        throw "ONMjs.observers.NavigatorModelView.objectStoreObserverCallbacks.onObserverDetach failure: #{exception}"

                #
                # ----------------------------------------------------------------------------
                onNamespaceCreated: (store_, observerId_, address_) =>
                    try
                        if @storeObserverId != observerId_ then throw "Unrecognized observer ID."
                        namespaceState = store_.openObserverNamespaceState(observerId_, address_)
                        namespaceState.description = "Hey this is the ONMjs.observers.NavigatorModelView class saving some submenu state."
                        namespaceState.itemModelView = new ONMjs.observers.implementation.NavigatorItemModelView(store_, @, address_)

                        if address_.isRoot()
                            @rootMenuModelView = namespaceState.itemModelView

                        parentAddress = address_.createParentAddress()
                        if parentAddress? and parentAddress?
                            parentNamespaceState = store_.openObserverNamespaceState(observerId_, parentAddress)
                            parentNamespaceState.itemModelView.children.push namespaceState.itemModelView
                            namespaceState.indexInParentChildArray = parentNamespaceState.itemModelView.children().length - 1

                    catch exception
                        throw "ONMjs.observers.NavigatorModelView failure: #{exception}"
        
                #
                # ----------------------------------------------------------------------------
                onNamespaceUpdated: (store_, observerId_, address_) =>
                    try
                        if @storeObserverId != observerId_ then throw "Unrecognized observer ID."
                        namespaceModel = address_.getModel()
                        if namespaceModel.namespaceType != "component"
                            return
                        namespace = store_.openNamespace(address_)
                        namespaceState = store_.openObserverNamespaceState(observerId_, address_)
                        namespaceState.itemModelView.label(namespace.getResolvedLabel())

                    catch exception
                        throw "ONMjs.observers.NavigatorModelView.onNamespaceUpdated failure: #{excpetion}"


                #
                # ----------------------------------------------------------------------------
                onNamespaceRemoved: (store_, observerId_, address_) =>
                    try
                        if @storeObserverId != observerId_ then throw "Unrecognized observer ID."
                        namespaceState = store_.openObserverNamespaceState(observerId_, address_)

                        if address_.isRoot()
                            @rootMenuModelView = undefined

                        parentAddress = address_.createParentAddress()
                        if parentAddress? and parentAddress
                            parentNamespaceState = store_.openObserverNamespaceState(observerId_, parentAddress)
                            parentChildItemArray = parentNamespaceState.itemModelView.children()
                            spliceIndex = namespaceState.indexInParentChildArray
                            parentChildItemArray.splice(spliceIndex, 1)

                            while spliceIndex < parentChildItemArray.length
                                item = parentChildItemArray[spliceIndex]
                                itemAddress = item.address
                                itemState = store_.openObserverNamespaceState(observerId_, itemAddress)
                                itemState.indexInParentChildArray = spliceIndex++

                            parentNamespaceState.itemModelView.children(parentChildItemArray)

                            return true

                    catch exception
                        throw "ONMjs.observers.NavigatorModelView.onNamespaceRemoved failure: #{exception}"

            }

            @selectedNamespacesBySelectorHash = {}

            #
            # ============================================================================
            # ONMjs.CachedAddress OBSERVER INTERFACE

            @cachedAddressObserverInterface = {

                #
                # ----------------------------------------------------------------------------
                # Called when the Navigator is attached to a ONMjs.CachedAddress instance.
                onComponentCreated: (store_, observerId_, address_) => 
                    try
                        # Simply forward to onComponentUpdated - we don't have create/update cases seperately.
                        @cachedAddressObserverInterface.onComponentUpdated(store_, observerId_, address_)
                    catch exception
                        throw "ONMjs.observers.NavigatorModelView.cachedAddressObserverInterface.onComponentCreated failure: #{exception}"

                #
                # ----------------------------------------------------------------------------
                # Called whenever any entity calls ONMjs.CachedAddress.setAddress.
                onComponentUpdated: (store_, observerId_, address_) =>
                    try
                        # The ONMjs.Address held by ONMjs.CachedAddress has been updated.
                        # Note that the address_ parameter species a namespace in the CachedAddress store
                        # that contains the actual cahced reference to ONMjs.Address. We don't leverage
                        # address_ parameter here because CachedSchema's object model schema declaration
                        # defines only a single namespace (that address_ always refers to).

                        # Obtain this observer's unique state from the store.
                        observerState = store_.openObserverState(observerId_)

                        # Has this observer previously marked a sub-item as selected?
                        # If yes, inform the currently selected item that this particular CachedAddress no longer
                        # wishes it to be selected (this allows for multi-selection support via multiple attached
                        # CachedAddresses) as the selection state of an item is a reference count - not a boolean.
                        #
                        if observerState.itemModelView? and observerState.itemModelView
                            observerState.itemModelView.removeSelection(observerId_)

                        # Get the newly-selected ONMjs.Address from the ONMjs.CachedAddress store.
                        cachedAddress = store_.getAddress()

                        # It's possible that the cached address is undefined indicating that this CachedAddress
                        # no longer holds a valid cached address.

                        if cachedAddress? and cachedAddress
                            # Now find the item model view associated with the address.
                            namespaceState = @store.openObserverNamespaceState(@storeObserverId, cachedAddress)
                            if not (namespaceState.itemModelView? and namespaceState.itemModelView)
                                throw "Internal error: namespace state cache for this namespace is not initialized."
                            namespaceState.itemModelView.addSelection(observerId_)

                            # Finally, save a reference to the item model view in the
                            observerState.itemModelView = namespaceState.itemModelView

                    catch exception
                        throw "ONMjs.observers.NavigatorModelView.cachedAddressObserverInterface.onComponentUpdated failure: #{exception}"

            }


        catch exception
            throw " ONMjs.observers.NavigatorModelView consructor failure: #{exception}"

        # / END: constructor


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_NavigatorViewModel", ( -> """
<span data-bind="if: rootMenuModelView">
    <div class="classONMjsNavigator">
        <span data-bind="template: { name: 'idKoTemplate_NavigatorItemViewModel', foreach: rootMenuModelView.children }"></span>
    </div>
</span>
"""))


