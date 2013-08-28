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
ONMjs.observers = Encapsule.code.lib.omm.observers? and Encapsule.code.lib.omm.observers or @Encapsule.code.lib.omm.observers = {}


class ONMjs.observers.NavigatorModelView
    constructor: ->
        # \ BEGIN: constructor
        try

            @blipper = Encapsule.runtime.boot.phase0.blipper

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
                    @storeObserverId = store_.registerObserver(@objectStoreObserverCallbacks, @)
                catch exception
                   throw "ONMjs.observers.NavigatorModelView.attachToStore failure: #{exception}"

            #
            # ============================================================================
            @detachFromStore = =>
                try
                    if not @storeObserverId? and @storeObserverId then throw "This navigator instance is not attached to an ONMjs.Store instance."
                    @store.unregisterObserver(@storeObserverId)
                    @storeObserverId = undefined
                catch exception
                    throw "ONMjs.observers.NavigatorModelView.detachFromStore failure: #{exception}"

            #
            # ============================================================================
            @attachToCachedAddress = (cachedAddress_) =>
                try
                    if not (cachedAddress_? and cachedAddress_) then throw "Missing cached address input parameter."
                    observerId = cachedAddress_.registerObserver(@selectorStoreCallbacks, @)
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
            # ONMjs.Store OBSERVER INTERFACE
            #
            @objectStoreObserverCallbacks = {

                onObserverAttachBegin: (store_, observerId_) =>
                    try
                        Console.message("ONMjs.observer.NavigatorModelview is now observing ONMjs.Store.")
                        if @storeObserverId? and @storeObserverId
                            throw "This navigator instance is already observing an ONMjs.Store."
                        @storeObserverId = observerId_
                        true
                    catch exception
                        throw "ONMjs.observers.NavigatorModelView.objectStoreObserverCallbacks.onObserverAttach failure: #{exception}"


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


                onNamespaceCreated: (store_, observerId_, address_) =>
                    try
                        Console.message("ONMjs.observersNavigatorModelView.onNamespaceCreated")
                        if @storeObserverId != observerId_ then throw "Unrecognized observer ID."
                        namespaceState = store_.openObserverNamespaceState(observerId_, address_)
                        namespaceState.description = "Hey this is the ONMjs.observers.NavigatorModelView class saving some submenu state."
                        namespaceState.menuModelView = new ONMjs.observers.NavigatorItemModelView(store_, @, address_)

                        if address_.isRoot()
                            @rootMenuModelView = namespaceState.menuModelView

                        parentAddress = ONMjs.address.Parent(address_)
                        if parentAddress? and parentAddress?
                            parentNamespaceState = store_.openObserverNamespaceState(observerId_, parentAddress)
                            parentNamespaceState.menuModelView.children.push namespaceState.menuModelView
                            namespaceState.indexInParentChildArray = parentNamespaceState.menuModelView.children().length - 1

                    catch exception
                        throw "ONMjs.observers.NavigatorModelView failure: #{exception}"
        

                onNamespaceRemoved: (store_, observerId_, address_) =>
                    try
                        Console.message("ONMjs.observers.NavigatorModelView.onNamespaceRemoved")
                        if @storeObserverId != observerId_ then throw "Unrecognized observer ID."
                        namespaceState = store_.openObserverNamespaceState(observerId_, address_)

                        if address_.isRoot()
                            @rootMenuModelView = undefined

                        parentAddress = ONMjs.address.Parent(address_)
                        if parentAddress? and parentAddress
                            parentNamespaceState = store_.openObserverNamespaceState(observerId_, parentAddress)
                            parentChildItemArray = parentNamespaceState.menuModelView.children()
                            spliceIndex = namespaceState.indexInParentChildArray
                            parentChildItemArray.splice(spliceIndex, 1)

                            while spliceIndex < parentChildItemArray.length
                                item = parentChildItemArray[spliceIndex]
                                itemAddress = item.address
                                itemState = store_.openObserverNamespaceState(observerId, itemAddress)
                                itemState.indexInParentChildArray = spliceIndex++

                            parentNamespaceState.menuModelView.children(parentChildItemArray)

                            return true

                    catch exception
                        throw "Encapsule.code.lib.modelview.ObjectModelNavigatorWindow.onNamespaceRemoved failure: #{exception}"

            }

            @selectedNamespacesBySelectorHash = {}

            #
            # ============================================================================
            # ONMjs.CachedAddress OBSERVER INTERFACE

            @selectorStoreCallbacks = {

                onComponentCreated: (objectStore_, observerId_, namespaceSelector_) => selectorStoreCallbacks.onComponentUpdated(objectStore_, observerId_, namespaceSelector_)

                onComponentUpdated: (objectStore_, observerId_, namespaceSelector_) =>

                    Console.message("ObjectModelNavigatorWindow processing selector update for observer #{observerId_}")

                    # First obtain new namespace selector from the selector store.
                    newObjectStoreSelector = objectStore_.getSelector()

                    if newObjectStoreSelector.selectKeyVector? and newObjectStoreSelector.selectKeyVector
                        if newObjectStoreSelector.selectKeyVector.length > newObjectStoreSelector.selectKeysRequired
                            throw "Internal error malformed namespace selector select key array exceeds required number of keys."

                    # Next obtain the namespace selector last selected observer instance.
                    observerState = objectStore_.openObserverState(observerId_)
                    if observerState.hash? and observerState.hash
                        Console.message("... #{observerId_} previously selected #{observerState.hash}")
                        
                        selectors = @selectedNamespacesBySelectorHash[observerState.hash]
                        if not (selectors? and selectors) then throw "Internal error unable to resolve selectors."

                        selectorCount = Encapsule.code.lib.js.dictionaryLength(selectors)
                        if selectorCount < 1 then throw "Internal error selector count less than one."
                        if selectorCount == 1
                            # We're about to remove the last selection request for the current selection.
                            # Toggle the select flag of the menu model view associated with the current selection.
                            selector = selectors[observerId_]
                            if not (selector? and selector) then throw "Internal error unable to resolve selector needed to open outgoing selection's menu model view."
                            namespaceState = @objectStore.openObserverNamespaceState(@objectStoreObserverId, selector)
                            if not (namespaceState.menuModelView? and namespaceState.menuModelView) then throw "Internal error unable to resolve menu model view for outgoing selector."
                            namespaceState.menuModelView.isSelected(false)
                            delete @selectedNamespacesBySelectorHash[observerState.hash]
                            Console.message("... #{observerId_} previously selected #{observerState.hash} select state is now FALSE.")
                        else
                            delete selectors[observerId_]
                            Console.message("... #{observerId_} previously selected #{observerState.hash} select state is still TRUE due to other selectors.")

                    observerState.hash = newObjectStoreSelector.getHashString()
                    Console.message("... #{observerId_} selecting #{observerState.hash}")
                    
                    selectors = @selectedNamespacesBySelectorHash[observerState.hash]? and @selectedNamespacesBySelectorHash[oberverState.hash] or @selectedNamespacesBySelectorHash[observerState.hash] = {}
                    selectors[observerId_] = newObjectStoreSelector

                    selectorCount = Encapsule.code.lib.js.dictionaryLength(selectors)
                    if selectorCount == 1
                        # First selector to select this namespace.
                        # Toggle the select flag of the menu model view associated with the new selection.
                        namespaceState = @objectStore.openObserverNamespaceState(@objectStoreObserverId, newObjectStoreSelector)
                        if not (namespaceState.menuModelView? and namespaceState.menuModelView) then throw "Internal error unable to resolve menu model view for new selection."
                        namespaceState.menuModelView.isSelected(true)
                        Console.message("... #{observerId_} added to selecting observers list for #{observerState.hash}")
                        Console.message("... #{observerId_} #{observerState.hash} select state is now TRUE.")
                    else
                        Console.message("... #{observerId_} added to selecting observers list for #{observerState.hash}")
                        Console.message("... #{observerId_} #{observerState.hash} select state was and remains TRUE due to other selectors.")

            }


        catch exception
            throw " Encapsule.code.lib.modelview.ObjectModelNavigatorWindowBase constructor failure: #{exception}"

        # / END: constructor


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_OmmObserverNavigatorViewModel", ( -> """
<span data-bind="if: rootMenuModelView">
    <div class="classObjectModelNavigatorWindow">
        <span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorMenuWindow', foreach: rootMenuModelView.children }"></span>
    </div>
</span>
"""))


