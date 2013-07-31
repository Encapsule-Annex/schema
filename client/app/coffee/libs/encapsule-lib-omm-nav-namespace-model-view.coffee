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


class Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceImmutable
    constructor: (namespace_) ->
        try
        catch exception
            throw "Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceImmutable failure: #{exception}"

Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorNamespaceImmutable", ( -> """
<div class="classObjectModelNavigatorNamespaceSectionTitle">Immutable Properties</div>
<div class="classObjectModelNavigatorNamespaceSectionCommon classObjectModelNavigatorNamespaceImmutable">
</div>
"""))


class Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceMutable
    constructor: (namespace_) ->
        try
        catch exception
            throw "Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceMutable failure: #{exception}"

Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorNamespaceMutable", ( -> """
<div class="classObjectModelNavigatorNamespaceSectionTitle">Mutable Properties</div>
<div class="classObjectModelNavigatorNamespaceSectionCommon classObjectModelNavigatorNamespaceMutable">
</div>
"""))

class Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceComponent
    constructor: (namespace_) ->
        try
            componentSelector = undefined
            if namespace_.objectModelDescriptor.isComponent
                componentSelector = namespace_.getResolvedSelector()
            else
                componentSelector = namespace_.objectStore.objectModel.createNamespaceSelectorFromPathId(
                    namespace_.objectModelDescriptor.idComponent, namespace_.resolvedKeyVector)
                
            @componentDescription = ""

            extensionPointsString = ""
            @extensionPointsCount = Encapsule.code.lib.js.dictionaryLength(componentSelector.objectModelDescriptor.extensionPoints)
            for extensionPointPath, extensionPointDescriptor of componentSelector.objectModelDescriptor.extensionPoints
                extensionPointSelector = namespace_.objectStore.objectModel.createNamespaceSelectorFromPathId(extensionPointDescriptor.id, namespace_.resolvedKeyVector)
                extensionPointNamespace = namespace_.objectStore.openNamespace(extensionPointSelector)
                extensionPointsString += " #{extensionPointNamespace.getResolvedLabel()}<br>"

            @extensionPointsString = ko.observable(extensionPointsString)



        catch exception
            throw "Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceComponent failure: #{exception}"

Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorNamespaceComponent", ( -> """
<div class="classObjectModelNavigatorNamespaceSectionTitle">Extension Points (<span data-bind="text: extensionPointsCount"></span>)</div>
</div>
<div class="classObjectModelNavigatorNamespaceSectionCommon classObjectModelNavigatorNamespaceComponent">
<span data-bind="html: extensionPointsString"></span>
</div>
"""))


class Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceChildren
    constructor: (namespace_) ->
        try
            selector = namespace_.getResolvedSelector()
            childrenString = undefined
            @childrenCount = 0
            if selector.objectModelDescriptor.children.length
                childrenString = ""
                @childrenCount = selector.objectModelDescriptor.children.length
                for descriptor in selector.objectModelDescriptor.children
                    childSelector = namespace_.objectStore.objectModel.createNamespaceSelectorFromPathId(descriptor.id, selector.selectKeyVector)
                    childNamespace = namespace_.objectStore.openNamespace(childSelector)
                    childrenString += " #{childNamespace.getResolvedLabel()}<br>"

            @childrenString = childrenString
                
        catch exception
            throw "Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceChildren failure: #{exception}"

Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorNamespaceChildren", ( -> """
<div class="classObjectModelNavigatorNamespaceSectionTitle">Child Namespaces (<span data-bind="text: childrenCount"></span>)</div>
<div class="classObjectModelNavigatorNamespaceSectionCommon classObjectModelNavigatorNamespaceChildren">
<span data-bind="html: childrenString"></span>
</div>
"""))


class Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceCollection
    constructor: (namespace_) ->
        try
            semanticBindings = namespace_.objectStore.objectModel.getSemanticBindings()
            elementPathId = namespace_.objectModelDescriptor.archetypePathId
            elementSelector = namespace_.objectStore.objectModel.createNamespaceSelectorFromPathId(elementPathId)
            elementJsonTag = elementSelector.objectModelDescriptor.jsonTag

            @elementsCount = namespace_.objectStoreNamespace.length

            elementsString = ""

            for elementEntry in namespace_.objectStoreNamespace
                elementData = elementEntry[elementJsonTag]
                elementKey = semanticBindings.getUniqueKey(elementData)
                elementSelectKeyVector = Encapsule.code.lib.js.clone(namespace_.resolvedKeyVector)
                elementSelectKeyVector.push elementKey
                elementSelector = namespace_.objectStore.objectModel.createNamespaceSelectorFromPathId(elementPathId, elementSelectKeyVector)
                elementNamespace = namespace_.objectStore.openNamespace(elementSelector)
                elementsString += " #{elementNamespace.getResolvedLabel()}<br>"

            @elementsString = ko.observable(elementsString)
                
            
        catch exception
            throw "Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceCollection failure: #{exception}"

Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorNamespaceCollection", ( -> """
<div class="classObjectModelNavigatorNamespaceSectionTitle">Collection (<span data-bind="text: elementsCount"></span>)</div>
<div class="classObjectModelNavigatorNamespaceSectionCommon classObjectModelNavigatorNamespaceChildren">
<span data-bind="html: elementsString"></span>
</div>
"""))



class Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceWindow
    constructor: ->
        try

            @objectStoreName = ko.observable "<not connected>"
            @hashString = ko.observable "<not connected>"

            @title = ko.observable "<not connected>"
            @subtitle = ko.observable "<not connected>"
            @context = ko.observableArray []

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


                    @context.removeAll()
                    labelLast = ""
                    if parentExtensionPointPathIds? and parentExtensionPointPathIds and parentExtensionPointPathIds.length
                        index = 0
                        for parentExtensionPointPathId in parentExtensionPointPathIds

                            parentExtensionPointSelector = objectStore_.associatedObjectStore.objectModel.createNamespaceSelectorFromPathId(parentExtensionPointPathId, selector.selectKeyVector)
                            parentComponentId = parentExtensionPointSelector.objectModelDescriptor.idComponent
                            parentExtensionPointNamespace = objectStore_.associatedObjectStore.openNamespace(parentExtensionPointSelector)
                            parentComponentSelector = objectStore_.associatedObjectStore.objectModel.createNamespaceSelectorFromPathId(parentComponentId, selector.selectKeyVector)
                            if true # parentComponentSelector.pathId
                                parentComponentNamespace = objectStore_.associatedObjectStore.openNamespace(parentComponentSelector)
                                prefix = index++ and " : " or "^ "
                                labelLast = parentComponentNamespace.objectModelDescriptor.label
                                label = "#{parentComponentNamespace.getResolvedLabel()}"
                                @context.push new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceContextElement(prefix, label, parentComponentNamespace.getResolvedSelector(), objectStore_)

                    if @context().length
                        @title("#{labelLast} : #{resolvedLabel}")
                    else
                        @title("#{resolvedLabel}")

                    mvvmTypeToNamespaceTypeMap = {
                        "root": "Object Store"
                        "child": "Namespace"
                        "extension": "Collection"
                        "archetype": "Component"
                    }

                    mvvmType = selector.objectModelDescriptor.mvvmType

                    subtitle = """
                        Type: <strong>#{mvvmTypeToNamespaceTypeMap[mvvmType]}</strong>
                        //
                        Description: <strong>#{selector.objectModelDescriptor.description}</strong>
                        """
                    @subtitle(subtitle)

                    switch mvvmType
                        when "root"
                            @modelviewImmutable(new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceImmutable(selectedNamespace))
                            @modelviewMutable(undefined)
                            @modelviewComponent(new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceComponent(selectedNamespace))
                            newModelViewChildren = new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceChildren(selectedNamespace)
                            @modelviewChildren(newModelViewChildren.childrenCount and newModelViewChildren or undefined)
                            @modelviewCollection(undefined)
                            break
                        when "child"
                            @modelviewImmutable(new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceImmutable(selectedNamespace))
                            @modelviewMutable(new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceMutable(selectedNamespace))
                            @modelviewComponent(new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceComponent(selectedNamespace))
                            newModelViewChildren = new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceChildren(selectedNamespace)
                            @modelviewChildren(newModelViewChildren.childrenCount and newModelViewChildren or undefined)                            
                            @modelviewCollection(undefined)
                            break
                        when "extension"
                            @modelviewImmutable(undefined)
                            @modelviewMutable(undefined)
                            @modelviewComponent(new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceComponent(selectedNamespace))
                            @modelviewChildren(undefined)
                            @modelviewCollection(new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceCollection(selectedNamespace))
                            break
                        when "archetype"
                            @modelviewImmutable(new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceImmutable(selectedNamespace))
                            @modelviewMutable(new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceMutable(selectedNamespace))
                            @modelviewComponent(new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceComponent(selectedNamespace))
                            newModelViewChildren = new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceChildren(selectedNamespace)
                            @modelviewChildren(newModelViewChildren.childrenCount and newModelViewChildren or undefined)
                            @modelviewCollection(undefined)
                            break
                        else
                            throw "Unrecognized MVVM type in request."

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
    <span class="classObjectModelNavigatorNamespaceTitle" data-bind="html: title"></span><br>
    <span class="classObjectModelNavigatorNamespaceSubtitle" data-bind="html: subtitle"></span>
</div>


<span data-bind="if: modelviewImmutable"><span data-bind="with: modelviewImmutable"><span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceImmutable' }"></span></span></span>
<span data-bind="if: modelviewMutable"><span data-bind="with: modelviewMutable"><span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceMutable'}"></span></span></span>
<span data-bind="if: modelviewChildren"><span data-bind="with: modelviewChildren"><span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceChildren'}"></span></span></span>
<span data-bind="if: modelviewCollection"><span data-bind="with: modelviewCollection"><span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceCollection'}"></span></span></span>
<span data-bind="if: modelviewComponent"><span data-bind="with: modelviewComponent"><span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceComponent'}"></span></span></span>

"""))