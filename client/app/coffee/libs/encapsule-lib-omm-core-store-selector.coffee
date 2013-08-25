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




# encapsule-lib-omm-core-store-selector.coffee
#
# Encapsulates the creation of an Encapsule.code.lib.omm.ObjectStore
# instance using the "selector" object model.

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.modelview = Encapsule.code.lib.modelview? and Encapsule.code.lib.modelview or @Encapsule.code.lib.modelview = {}
Encapsule.code.lib.modelview.detail = Encapsule.code.lib.modelview.detail? and Encapsule.code.lib.modelview.detail or @Encapsule.code.lib.modelview.detail = {}


# customized for the Encapsule.code.lib.modelview.detail.SelectorObjectModelDescriptor
# object model (declaration above). 

class Encapsule.code.lib.modelview.SelectorStore extends Encapsule.code.lib.omm.Store
    constructor: (objectStore_, initialObjectStoreSelector_) ->
        try
            #
            # ============================================================================
            @getSelector = =>
                try
                    selector = @rootNamespace.objectStoreNamespace.parentSelectorVector[@rootNamespace.objectStoreNamespace.parentSelectorVector.length - 1]
                    return selector
                catch exception
                    throw "Encapsule.code.lib.modelview.SelectorStore.getSelector failure: #{exception}"

            #
            # ============================================================================
            @setSelector = (externalSelector_) =>
                try
                    externalSelector_.internalVerifySelector()

                    # Verify that externalSelector_ addresses an actual store namespace.
                    externalStoreNamespace = @associatedObjectStore.openNamespace(externalSelector_)

                    parentSelectorVector = 
                        @rootNamespace.objectStoreNamespace.parentSelectorVector? and 
                        @rootNamespace.objectStoreNamespace.parentSelectorVector or
                        @rootNamespace.objectStoreNamespace.parentSelectorVector = []

                    parentSelectorVector.splice(0, parentSelectorVector.length)
                    parentSelectorVector.push externalSelector_
                    selector = externalSelector_.createParentSelector()
                    while selector? and selector
                        parentSelectorVector.push selector
                        selector = selector.createParentSelector()
                    parentSelectorVector.reverse()
                    @blipper.blip("21") # double click sound
                    @rootNamespace.updateRevision()

                catch exception
                    throw "Encapsule.code.lib.modelview.SelectorStore.setSelector failure: #{exception}"


            #
            # ============================================================================
            # constructor
            #

            if not (objectStore_? and objectStore_) then throw "Missing object store input parameter. Unable to determine external selector type."
            # Cache the associated objectStore parameter for later use.
            @associatedObjectStore = objectStore_
            # Create an ObjectModel instance from the selector object model declaration.
            selectorObjectModel = new Encapsule.code.lib.omm.ObjectModel(
                {
                    jsonTag: "selector"
                    label: "#{appName} Selector"
                    description: "#{appName} selector root."
                })

            # Initialize the base ObjectStore class for this SelectorStore
            super(selectorObjectModel)

            @blipper = Encapsule.runtime.boot.phase0.blipper

            externalSelector = initialObjectStoreSelector_
            if not (externalSelector? and externalSelector)
                externalSelector = @associatedObjectStore.objectModel.createNamespaceSelectorFromPathId(0)
            
            rootSelector = selectorObjectModel.createNamespaceSelectorFromPath("selector")
            @rootNamespace = @openNamespace(rootSelector)
            
            @setSelector(externalSelector)

            @objectStoreCallbacks = {

                # In general seek to minimize the number of times the current selector is reset.
                # Respond to component-level callbacks primarily (low frequency) and leverage
                # namespace-level callbacks only to handle point updates to the current selection.
                #

                # onComponentCreated: (objectStore_, observerId_, namespaceSelector_) =>
                # onComponentUpdated: (objectStore_, observerId_, namespaceSelector_) =>
                # onChildComponentUpdated: (objectStore_, observerId_, namespaceSelector_) =>
                # onComponentRemoved: (objectStore_, observerId_, namespaceSelector_) =>
                # onNamespaceCreated: (objectStore_, observerId_, namespaceSelector_) =>

                onNamespaceUpdated: (objectStore_, observerId_, namespaceSelector_) =>
                    try
                        selector = @getSelector()
                        if selector.getHashString() == namespaceSelector_.getHashString()
                            # TODO:
                            # This is _convenient_ as it automatically keeps hits observers
                            # with a callback when the currently selected store namespace
                            # is modified. But this is actually sort of wrong...
                            # We really don't want the selector involved in this detail because
                            # it's the business of whoever is doing the observing to decide
                            # what they want to watch. It's far better to foist the additional
                            # complexity on observers than to OR the two disjoint concepts
                            # together (and provide no way to discriminate between the two
                            # cases). Simle fix.
                            @setSelector(@getSelector())
                    catch exception
                        throw "Encapsule.code.lib.modelview.SelectorStore.objectStoreCallbacks.onNamespaceUpdated failure: #{exception}"

                onChildNamespaceUpdated: (objectStore_, observerId_, namespaceSelector_) =>
                    try
                        selector = @getSelector()
                        if selector.getHashString() == namespaceSelector_.getHashString()
                            # TODO: same as above
                            @setSelector(@getSelector())
                    catch exception
                        throw "Encapsule.code.lib.modelview.SelectorStore.objectStoreCallbacks.onChildNamespaceUpdated failure: #{exception}"

                # onParentNamespaceUpdated: (objectStore_, observerId_, namespaceSelector_) =>

                onNamespaceRemoved: (objectStore_, observerId_, namespaceSelector_) =>
                    try
                        currentSelector = @getSelector()
                        if currentSelector.getHashString() == namespaceSelector_.getHashString()
                            parentId = currentSelector.objectModelDescriptor.parent.id
                            parentSelector = currentSelector.createParentSelector()
                            @setSelector(parentSelector)
                        return
                    catch exception
                        throw "Encapsule.code.lib.modelview.SelectorStore.objectStoreCallbacks.onNamespaceRemoved failure: #{exception}"

            }

            @associatedObjectStore.registerModelViewObserver(@objectStoreCallbacks)

            

        catch exception
            throw "Encapsule.code.lib.modelview.SelectorStore failure: #{exception}"


