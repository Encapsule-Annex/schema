###

  http://schema.encapsule.org/

  A single-page HTML5 application for creating, visualizing, and editing
  JSON-encoded Soft Circuit Description Language (SCDL) models.

  Copyright 2013 Encapsule Project, Copyright 2013 Chris Russell

  Distributed under the terms of the Boost Software License Version 1.0
  See included license.txt or http://www.boost.org/LICENSE_1_0.txt

  Sources on GitHub: https://github.com/Encapsule-Project/schema

  Visit http://www.encapsule.org for more information and happy hacking.

###
#
# encapsule-lib-omm-nav-namespace-model-view.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.modelview = Encapsule.code.lib.modelview? and Encapsule.code.lib.modelview or @Encapsule.code.lib.modelview = {}
Encapsule.code.lib.modelview.detail = Encapsule.code.lib.modelview.detail? and Encapsule.code.lib.modelview.detail or @Encapsule.code.lib.modelview.detail = {}


class Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceContextElement
    constructor: (prefix_, label_, selector_, selectorStore_) ->
        try
            @selector = selector_.clone()
            @selectorStore = selectorStore_
            @prefix= prefix_
            @label = label_
            @onClick = =>
                @selectorStore.setSelector(@selector)

        catch exception
            throw "Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceContextElement failure: #{exception}"

Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorNamespaceContextElement", ( -> """
<span class="classObjectModelNavigatorNamespaceContextPrefix" data-bind="text: prefix"></span>
<span class="classObjectModelNavigatorNamespaceContextLabel classObjectModelNavigatorMouseOverCursorPointer" data-bind="text: label, click: onClick"></span>
"""))


class Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceWindow
    constructor: ->
        try

            @objectStoreName = ko.observable "<not connected>"
            @hashString = ko.observable "<not connected>"

            @title = ko.observable "<not connected>"
            @subtitle = ko.observable "<not connected>"
            @context = ko.observableArray []

            @selectorStoreCallbacks = {

                onComponentCreated: (objectStore_, observerId_, namespaceSelector_) =>
                    @selectorStoreCallbacks.onComponentUpdated(objectStore_, observerId_, namespaceSelector_)


                onComponentUpdated: (objectStore_, observerId_, namespaceSelector_) =>

                    @context.removeAll()

                    # Get the new selector
                    selector = objectStore_.getSelector()
                    selectedNamespace = objectStore_.associatedObjectStore.openNamespace(selector)

                    @objectStoreName = objectStore_.associatedObjectStore.jsonTag
                    @hashString(selector.getHashString())

                    resolvedLabel = selectedNamespace.getResolvedLabel() or "<unresolved label>"

                    mvvmTypeToNamespaceTypeMap = {
                        "root": "Object Store"
                        "child": "Namespace"
                        "extension": "Collection"
                        "archetype": "Component"
                    }

                    mvvmType = selector.objectModelDescriptor.mvvmType

                    @title("#{resolvedLabel}")
                    @subtitle(selector.objectModelDescriptor.description)

                    if selector.objectModelDescriptor.isComponent
                        parentExtensionPointPathIds = Encapsule.code.lib.js.clone(selector.objectModelDescriptor.parentPathExtensionPoints)
                    else
                        parentComponentId = selector.objectModelDescriptor.idComponent
                        parentComponentSelector = objectStore_.associatedObjectStore.objectModel.createNamespaceSelectorFromPathId(parentComponentId, selector.selectKeyVector)
                        parentExtensionPointPathIds = Encapsule.code.lib.js.clone(parentComponentSelector.objectModelDescriptor.parentPathExtensionPoints)
                        parentExtensionPointPathIds.push parentComponentSelector.pathId

                    if parentExtensionPointPathIds? and parentExtensionPointPathIds and parentExtensionPointPathIds.length
                        index = 0
                        for parentExtensionPointPathId in parentExtensionPointPathIds

                            parentExtensionPointSelector = objectStore_.associatedObjectStore.objectModel.createNamespaceSelectorFromPathId(parentExtensionPointPathId, selector.selectKeyVector)
                            parentComponentId = parentExtensionPointSelector.objectModelDescriptor.idComponent
                            parentExtensionPointNamespace = objectStore_.associatedObjectStore.openNamespace(parentExtensionPointSelector)
                            parentComponentSelector = objectStore_.associatedObjectStore.objectModel.createNamespaceSelectorFromPathId(parentComponentId, selector.selectKeyVector)
                            if true # parentComponentSelector.pathId
                                parentComponentNamespace = objectStore_.associatedObjectStore.openNamespace(parentComponentSelector)
                                prefix = index++ and " : " or undefined
                                label = "#{parentComponentNamespace.getResolvedLabel()}"
                                @context.push new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceContextElement(prefix, label, parentComponentNamespace.getResolvedSelector(), objectStore_)

            }


        catch exception
            throw "Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceWindow construction failure: #{exception}"


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorNamespaceWindow", ( -> """

    <div class="classObjectModelNavigatorNamespaceHash">
        &gt; <span data-bind="text: objectStoreName"></span> [ <span data-bind="text: hashString"></span> ]
    </div>

    <span data-bind="if: context().length">
    <div class="classObjectModelNavigatorNamespaceContext" data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceContextElement', foreach: context }"></div>
    </span>


<div class="classObjectModelNavigatorNamespaceTitleBar">
    <span class="classObjectModelNavigatorNamespaceTitle" data-bind="text: title"></span><br>
    <span class="classObjectModelNavigatorNamespaceSubtitle" data-bind="text: subtitle"></span>
</div>
"""))