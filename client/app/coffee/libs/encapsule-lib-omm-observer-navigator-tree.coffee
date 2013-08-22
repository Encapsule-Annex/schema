###

  http://schema.encapsule.org/schema.html

  A single-page HTML5 application for creating, visualizing, and editing
  JSON-encoded Soft Circuit Description Language (SCDL) models.

  Copyright 2013 Encapsule Project, Copyright 2013 Chris Russell

  Distributed under the terms of the Boost Software License Version 1.0
  See included license.txt or http://www.boost.org/LICENSE_1_0.txt

  Sources on GitHub: https://github.com/Encapsule-Project/schema

  Visit http://www.encapsule.org for more information and happy hacking.

###
#
# encapsule-lib-omm-observer-navigator-tree.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.modelview = Encapsule.code.lib.modelview? and Encapsule.code.lib.modelview or @Encapsule.code.lib.modelview = {}


class Encapsule.code.lib.modelview.ObjectModelNavigatorWindow

    constructor: (objectStore_, initialSelector_) ->
        # \ BEGIN: constructor
        try
            if not (objectStore_? and objectStore_) then throw "Missing required object store input parameter."
            if not (objectStore_.jsonTag == "schema") then throw "Specified object store has unexpected JSON tag. Expected 'schema' found '#{objectStore_.jsonTag}'"

            @blipper = Encapsule.runtime.boot.phase0.blipper
            @objectStore = objectStore_            

            @rootMenuModelView = undefined

            objectStoreObserverCallbacks =

                onNamespaceCreated: (objectStore_, observerId_, namespaceSelector_) =>
                    try
                        Console.message("ObjectModelNavigatorWindowBase.onNamespaceCreated observerId=#{observerId_}")
                        namespaceState = objectStore_.openObserverNamespaceState(observerId_, namespaceSelector_)
                        namespaceState.menuModelView = new Encapsule.code.lib.modelview.ObjectModelNavigatorMenuWindow(objectStore_, @, namespaceSelector_)

                        if namespaceSelector_.pathId == 0
                            @rootMenuModelView = namespaceState.menuModelView

                        parentSelector = namespaceSelector_.createParentSelector()
                        if parentSelector? and parentSelector
                            parentNamespaceState = objectStore_.openObserverNamespaceState(observerId_, parentSelector)
                            parentNamespaceState.menuModelView.children.push namespaceState.menuModelView
                            namespaceState.indexInParentChildArray = parentNamespaceState.menuModelView.children().length - 1
                    catch exception
                        throw "Encapsule.code.lib.modelview.ObjectModelNavigatorWindowBase.onNamespaceCreated failure: #{exception}"
        
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

            # Register this ObjectModelNavigatorWindow object as an observer of the objectStore_
            @objectStoreObserverId = objectStore_.registerModelViewObserver(objectStoreObserverCallbacks)

            # Create a SelectorStore instance associated with objectStore_.
            @selectorStore = new Encapsule.code.lib.modelview.SelectorStore(objectStore_, initialSelector_)

            @selectedNamespacesBySelectorHash = {}

            selectorStoreCallbacks = {

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

            @selectorStoreObserverId = @selectorStore.registerModelViewObserver(selectorStoreCallbacks)

            # Test
            cataloguesSelector = @objectStore.objectModel.createNamespaceSelectorFromPath("schema.client.catalogues")
            @selectorStore.setSelector(cataloguesSelector)

            


        catch exception
            throw " Encapsule.code.lib.modelview.ObjectModelNavigatorWindowBase constructor failure: #{exception}"

        # / END: constructor


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorWindow", ( -> """
<span data-bind="if: rootMenuModelView">
    <div class="classObjectModelNavigatorWindow">
        <span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorMenuWindow', foreach: rootMenuModelView.children }"></span>
    </div>
</span>
"""))


