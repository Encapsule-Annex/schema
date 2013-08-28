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

            @objectStoreObserverCallbacks =

                onNamespaceCreated: (store_, address_, observerId_) =>
                    try
                        Console.message("ObjectModelNavigatorWindowBase.onNamespaceCreated")
                        namespaceState = store_.openObserverNamespaceState(observerId_, address_)
                        namespaceState.description = "Hey this is the ONMjs.observers.NavigatorModelView class saving some submenu state."
                        namespaceState.menuModelView = new Encapsule.code.lib.modelview.ObjectModelNavigatorMenuWindow(objectStore_, @, address_)

                        if address_.isRoot()
                            @rootMenuModelView = namespaceState.menuModelView

                        parentAddress = ONMjs.address.Parent(address_)
                        if parentAddress? and parentAddress
                            parentNamespaceState = store_.openObserverNamespaceState(observerId_, parentAddress)
                            parentNamespaceState.menuModelView.children.push namespaceState.menuModelView
                            namspaceState.indexInParentChildArray = parentNamespaceState.menuModeView.children.length - 1

                    catch exception
                        throw "ONMjs.observers.NavigatorModelView failure: #{exception}"
        
                onNamespaceRemoved: (objectStore_, observerId_, namespaceSelector_) =>
                    try
                        Console.message("ObjectModelNavigatorWindowBase.onNamespaceRemoved observerId=#{observerId_}")
                        namespaceState = objectStore_.openObserverNamespaceState(observerId_, namespaceSelector_)

                        if namespaceSelector_.pathId == 0
                            @rootMenuModelView = undefined

                        parentSelector = namespaceSelector_.createParentSelector()
                        if parentSelector? and parentSelector
                            parentNamespaceState = objectStore_.openObserverNamespaceState(observerId_, parentSelector)

                            parentChildMenuArray = parentNamespaceState.menuModelView.children()
                            spliceIndex = namespaceState.indexInParentChildArray

                            parentChildMenuArray.splice(spliceIndex, 1)

                            while spliceIndex < parentChildMenuArray.length
                                tailChildMenuModelView = parentChildMenuArray[spliceIndex]
                                tailChildMenuModelViewSelector = tailChildMenuModelView.namespaceSelector
                                tailChildMenuNamespaceState = objectStore_.openObserverNamespaceState(observerId_, tailChildMenuModelViewSelector)
                                tailChildMenuNamespaceState.indexInParentChildArray = spliceIndex++

                            parentNamespaceState.menuModelView.children(parentChildMenuArray)

                            return true

                    catch exception
                        throw "Encapsule.code.lib.modelview.ObjectModelNavigatorWindow.onNamespaceRemoved failure: #{exception}"


            @selectedNamespacesBySelectorHash = {}

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


