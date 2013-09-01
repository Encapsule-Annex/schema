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
ONMjs.observers = ONMjs.observers? and ONMjs.observers or ONMjs.observers = {}




# ******************************************************************************
# ******************************************************************************
# ******************************************************************************
# ******************************************************************************

class ONMjs.observers.SelectedNamespaceModelView
    constructor: ->
        try

            @objectStoreName = ko.observable "<not connected>"
            @hashString = ko.observable "<not connected>"

            @title = ko.observable "<not connected>"
            @subtitle = ko.observable "<not connected>"
            # @context = ko.observableArray []

            @modelviewActions = ko.observable undefined
            @modelviewSummary = ko.observable undefined
            @modelviewImmutable = ko.observable undefined
            @modelviewMutable = ko.observable undefined
            @modelviewComponent = ko.observable undefined
            @modelviewChildren = ko.observable undefined
            @modelviewCollection = ko.observable undefined

            @selectorStoreCallbacks = {

                onComponentCreated: (objectStore_, observerId_, namespaceSelector_) =>
                    @selectorStoreCallbacks.onComponentUpdated(objectStore_, observerId_, namespaceSelector_)


                onComponentUpdated: (objectStore_, observerId_, namespaceSelector_) =>

                    # Get the new selector
                    selector = objectStore_.getSelector()
                    selectedNamespace = objectStore_.associatedObjectStore.openNamespace(selector)

                    @objectStoreName = objectStore_.associatedObjectStore.jsonTag
                    @hashString(selector.getHashString())

                    resolvedLabel = selectedNamespace.getResolvedLabel() or "<unresolved label>"

                    if selector.objectModelDescriptor.isComponent
                        parentExtensionPointPathIds = Encapsule.code.lib.js.clone(selector.objectModelDescriptor.parentPathExtensionPoints)
                    else
                        parentComponentId = selector.objectModelDescriptor.idComponent
                        parentComponentSelector = objectStore_.associatedObjectStore.objectModel.createNamespaceSelectorFromPathId(parentComponentId, selector.selectKeyVector)
                        parentExtensionPointPathIds = Encapsule.code.lib.js.clone(parentComponentSelector.objectModelDescriptor.parentPathExtensionPoints)
                        parentExtensionPointPathIds.push parentComponentSelector.pathId

                    mvvmType = selector.objectModelDescriptor.mvvmType

                    subtitle = """#{selector.objectModelDescriptor.description}"""
                    @subtitle(subtitle)

                    @modelviewSummary(new ONMjs.observers.ObjectModelNavigatorNamespaceTitle(selectedNamespace, objectStore_))
                    @modelviewActions(new ONMjs.observers.ObjectModelNavigatorNamespaceActions(selectedNamespace, objectStore_))

                    switch mvvmType
                        when "root"
                            @modelviewImmutable(new ONMjs.observers.ObjectModelNavigatorNamespaceImmutable(selectedNamespace))
                            @modelviewMutable(undefined)
                            @modelviewComponent(new ONMjs.observers.ObjectModelNavigatorNamespaceComponent(selectedNamespace, objectStore_))
                            newModelViewChildren = new ONMjs.observers.ObjectModelNavigatorNamespaceChildren(selectedNamespace, objectStore_)
                            @modelviewChildren(newModelViewChildren.childModelViews.length and newModelViewChildren or undefined)
                            @modelviewCollection(undefined)
                            break
                        when "child"
                            immutableModelView = new ONMjs.observers.ObjectModelNavigatorNamespaceImmutable(selectedNamespace)
                            @modelviewImmutable(immutableModelView.propertyModelViews.length and immutableModelView or undefined)
                            mutableModelView = new ONMjs.observers.ObjectModelNavigatorNamespaceMutable(selectedNamespace)
                            @modelviewMutable(mutableModelView.propertyModelViews.length and mutableModelView or undefined)
                            @modelviewComponent(undefined)
                            newModelViewChildren = new ONMjs.observers.ObjectModelNavigatorNamespaceChildren(selectedNamespace, objectStore_)
                            @modelviewChildren(newModelViewChildren.childModelViews.length and newModelViewChildren or undefined)                            
                            @modelviewCollection(undefined)
                            break
                        when "extension"
                            @modelviewImmutable(undefined)
                            @modelviewMutable(undefined)
                            @modelviewComponent(new ONMjs.observers.ObjectModelNavigatorNamespaceComponent(selectedNamespace, objectStore_))
                            @modelviewChildren(undefined)
                            @modelviewCollection(new ONMjs.observers.ObjectModelNavigatorNamespaceCollection(selectedNamespace, objectStore_))
                            break
                        when "archetype"
                            immutableModelView = new ONMjs.observers.ObjectModelNavigatorNamespaceImmutable(selectedNamespace)
                            @modelviewImmutable(immutableModelView.propertyModelViews.length and immutableModelView or undefined)
                            mutableModelView = new ONMjs.observers.ObjectModelNavigatorNamespaceMutable(selectedNamespace)
                            @modelviewMutable(mutableModelView.propertyModelViews.length and mutableModelView or undefined)
                            @modelviewComponent(new ONMjs.observers.ObjectModelNavigatorNamespaceComponent(selectedNamespace, objectStore_))
                            newModelViewChildren = new ONMjs.observers.ObjectModelNavigatorNamespaceChildren(selectedNamespace, objectStore_)
                            @modelviewChildren(newModelViewChildren.childModelViews.length and newModelViewChildren or undefined)
                            @modelviewCollection(undefined)
                            break
                        else
                            throw "Unrecognized MVVM type in request."

            }


        catch exception
            throw "ONMjs.observers.ObjectModelNavigatorNamespaceWindow construction failure: #{exception}"


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorNamespaceWindow", ( -> """
<div class="classObjectModelNavigatorNamespaceHash"><span data-bind="text: objectStoreName"></span></div>
<span data-bind="if: modelviewSummary"><span data-bind="with: modelviewSummary"><span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceTitle' }"></span></span></span>
<span data-bind="if: modelviewActions"><span data-bind="with: modelviewActions"><span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceActions' }"></span></span></span>
<span data-bind="if: modelviewImmutable"><span data-bind="with: modelviewImmutable"><span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceImmutable' }"></span></span></span>
<span data-bind="if: modelviewMutable"><span data-bind="with: modelviewMutable"><span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceMutable'}"></span></span></span>
<span data-bind="if: modelviewCollection"><span data-bind="with: modelviewCollection"><span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceCollection'}"></span></span></span>
<span data-bind="if: modelviewComponent"><span data-bind="with: modelviewComponent"><span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceComponent'}"></span></span></span>
<span data-bind="if: modelviewChildren"><span data-bind="with: modelviewChildren"><span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceChildren'}"></span></span></span>
"""))

