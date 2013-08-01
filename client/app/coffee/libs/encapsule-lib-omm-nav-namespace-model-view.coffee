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


#
# ============================================================================
class Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceContextElement
    constructor: (prefix_, label_, selector_, selectorStore_, options_) ->
        try
            @prefix = prefix_? and prefix_ or ""
            @label = label_? and label_ or "<no label provided>"
            @selector = selector_? and selector_ and selector_.clone() or throw "Missing selector input parameter."
            @selectorStore = selectorStore_? and selectorStore_ or throw "Missing selector store input parameter."
            options = options_? and options_ or {}
            @optionsNoLink = options.noLink? and options.noLink or false

            @onClick = =>
                @selectorStore.setSelector(@selector)

        catch exception
            throw "Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceContextElement failure: #{exception}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorNamespaceContextElement", ( -> """
<span data-bind="if: prefix"><span class="classObjectModelNavigatorNamespaceContextPrefix" data-bind="html: prefix"></span></span>
<span data-bind="ifnot: optionsNoLink">
    <span class="classObjectModelNavigatorNamespaceContextLabel classObjectModelNavigatorMouseOverCursorPointer" data-bind="html: label, click: onClick"></span>
</span>
<span data-bind="if: optionsNoLink">
    <span class="classObjectModelNavigatorNamespaceContextLabelNoLink" data-bind="html: label"></span>
</span>

"""))


#
# ============================================================================
class Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceImmutable
    constructor: (namespace_) ->
        try
        catch exception
            throw "Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceImmutable failure: #{exception}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorNamespaceImmutable", ( -> """
<div class="classObjectModelNavigatorNamespaceSectionTitle">Immutable Properties</div>
<div class="classObjectModelNavigatorNamespaceSectionCommon classObjectModelNavigatorNamespaceImmutable">
</div>
"""))


#
# ============================================================================
class Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceMutable
    constructor: (namespace_) ->
        try
        catch exception
            throw "Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceMutable failure: #{exception}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorNamespaceMutable", ( -> """
<div class="classObjectModelNavigatorNamespaceSectionTitle">Mutable Properties</div>
<div class="classObjectModelNavigatorNamespaceSectionCommon classObjectModelNavigatorNamespaceMutable">
</div>
"""))

#
# ============================================================================
class Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceComponent
    constructor: (namespace_, selectorStore_) ->
        try
            namespaceSelector = namespace_.getResolvedSelector()
            namespaceSelectorHash = namespaceSelector.getHashString()
            componentSelector = undefined
            if namespace_.objectModelDescriptor.isComponent
                componentSelector = namespaceSelector
            else
                componentSelector = namespace_.objectStore.objectModel.createNamespaceSelectorFromPathId(
                    namespace_.objectModelDescriptor.idComponent, namespace_.resolvedKeyVector)

            componentNamespace = selectorStore_.associatedObjectStore.openNamespace(componentSelector)

            @componentModelView = new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceContextElement(
                "", componentNamespace.getResolvedLabel(), componentSelector, selectorStore_, { noLink: namespace_.objectModelDescriptor.isComponent} )

            @extensionPointModelViewArray = []

            index = 0
            for extensionPointPath, extensionPointDescriptor of componentSelector.objectModelDescriptor.extensionPoints
                extensionPointSelector = namespace_.objectStore.objectModel.createNamespaceSelectorFromPathId(extensionPointDescriptor.id, namespace_.resolvedKeyVector)
                extensionPointNamespace = namespace_.objectStore.openNamespace(extensionPointSelector)
                noLinkFlag = namespaceSelectorHash == extensionPointSelector.getHashString()
                prefix = undefined
                if index++ then prefix = " &bull; "
                label = "#{extensionPointNamespace.getResolvedLabel()}"
                subcomponentCount = extensionPointNamespace.objectStoreNamespace.length
                if subcomponentCount
                    label += " (#{subcomponentCount})"
                @extensionPointModelViewArray.push new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceContextElement(
                    prefix, label, extensionPointSelector, selectorStore_, { noLink: noLinkFlag })

        catch exception
            throw "Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceComponent failure: #{exception}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorNamespaceComponent", ( -> """

<span data-bind="if: extensionPointModelViewArray.length">
    <div class="classObjectModelNavigatorNamespaceSectionTitle">
        <span data-bind="with: componentModelView">
            <span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceContextElement' }"></span>
        </span>
        Extension Points (<span data-bind="text: extensionPointModelViewArray.length"></span>)
    </div>
    <span data-bind="ifnot: extensionPointModelViewArray.length"><i>Extension point contains no subcomponents.</i></span>
    <span data-bind="if: extensionPointModelViewArray.length">
    <div class="classObjectModelNavigatorNamespaceSectionCommon classObjectModelNavigatorNamespaceComponent">
        <span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceContextElement', foreach: extensionPointModelViewArray }"></span>
    </div>
    </span>
</span>
"""))


#
# ============================================================================
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
                    if not (childSelector.objectModelDescriptor.mvvmType == "extension")
                        childNamespace = namespace_.objectStore.openNamespace(childSelector)
                        childrenString += " #{childNamespace.getResolvedLabel()}<br>"

            @childrenString = childrenString
                
        catch exception
            throw "Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceChildren failure: #{exception}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorNamespaceChildren", ( -> """
<div class="classObjectModelNavigatorNamespaceSectionTitle">Child Namespaces (<span data-bind="text: childrenCount"></span>)</div>
<div class="classObjectModelNavigatorNamespaceSectionCommon classObjectModelNavigatorNamespaceChildren">
<span data-bind="html: childrenString"></span>
</div>
"""))


#
# ============================================================================
class Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceCollection
    constructor: (namespace_, selectorStore_) ->
        try
            @namespaceLabel = namespace_.objectModelDescriptor.label
            semanticBindings = namespace_.objectStore.objectModel.getSemanticBindings()
            elementPathId = namespace_.objectModelDescriptor.archetypePathId
            @elementSelector = namespace_.objectStore.objectModel.createNamespaceSelectorFromPathId(elementPathId)
            elementJsonTag = @elementSelector.objectModelDescriptor.jsonTag

            @subcomponentModelViews = []

            elementsString = ""
            index = 0
            for elementEntry in namespace_.objectStoreNamespace
                elementData = elementEntry[elementJsonTag]
                elementKey = semanticBindings.getUniqueKey(elementData)
                elementSelectKeyVector = Encapsule.code.lib.js.clone(namespace_.resolvedKeyVector)
                elementSelectKeyVector.push elementKey
                @elementSelector = namespace_.objectStore.objectModel.createNamespaceSelectorFromPathId(elementPathId, elementSelectKeyVector)
                elementNamespace = namespace_.objectStore.openNamespace(@elementSelector)
                prefix = "#{index++ + 1}: "
                label = "#{elementNamespace.getResolvedLabel()}<br>"
                @subcomponentModelViews.push new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceContextElement(
                    prefix, label, @elementSelector, selectorStore_)

                
            
        catch exception
            throw "Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceCollection failure: #{exception}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorNamespaceCollection", ( -> """
<div class="classObjectModelNavigatorNamespaceSectionTitle">
<span class="class="classObjectModelNavigatorNamespaceContextLabelNoLink" data-bind="html: elementSelector.objectModelDescriptor.label"></span>
Subcomponents (<span data-bind="text: subcomponentModelViews.length"></span>)</div>
<div class="classObjectModelNavigatorNamespaceSectionCommon classObjectModelNavigatorNamespaceChildren">
<span data-bind="ifnot: subcomponentModelViews.length">
<i><span class="classObjectModelNavigatorNamespaceContextLabelNoLink" data-bind="html: namespaceLabel"></span> extension point is empty.</i>
</span>
<span data-bind="if: subcomponentModelViews.length">
<span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceContextElement', foreach: subcomponentModelViews }"></span>
</span>
</div>
"""))


#
# ============================================================================
class Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceSummary
    constructor: (namespace_, selectorStore_) ->
        try
            objectStore = selectorStore_.associatedObjectStore

            mvvmToNamespaceIndefiniteArticle = {
                "root": "an"
                "child": "a"
                "extension": "an"
                "archetype": "a"
            }

            mvvmToNamespaceType = {
                "root": "object store"
                "child": "subnamespace"
                "extension": "extension point"
                "archetype": "component"
            }


            @namespaceLabel = namespace_.getResolvedLabel()
            namespaceMvvmType = namespace_.objectModelDescriptor.mvvmType
            @namespaceType = "#{mvvmToNamespaceIndefiniteArticle[namespaceMvvmType]} <strong>#{mvvmToNamespaceType[namespaceMvvmType]}</strong>"


            componentId = namespace_.objectModelDescriptor.idComponent
            isRootNamespace = componentId == namespace_.objectModelDescriptor.id
            isStoreComponent = componentId == 0

            @displayComponent = false
            @componentModelView = undefined
            @componentType = undefined

            @displayExtension = false
            @extendedComponentModelView = undefined
            @extendedComponentType = undefined
            @extensionPointModelView = undefined
            @extensionPointType = undefined

            if not isRootNamespace
                componentSelector = objectStore.objectModel.createNamespaceSelectorFromPathId(componentId, namespace_.resolvedKeyVector)
                componentNamespace = objectStore.openNamespace(componentSelector)
                @componentModelView = new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceContextElement("", componentNamespace.getResolvedLabel(), componentSelector, selectorStore_)
                @componentType = mvvmToNamespaceType[componentSelector.objectModelDescriptor.mvvmType]
                @displayComponent = true

            else if not isStoreComponent
                parentId = namespace_.objectModelDescriptor.parent.id
                parentSelector = objectStore.objectModel.createNamespaceSelectorFromPathId(parentId, namespace_.resolvedKeyVector)
                parentNamespace = objectStore.openNamespace(parentSelector)
                parentComponentId = parentSelector.objectModelDescriptor.idComponent
                parentComponentSelector = objectStore.objectModel.createNamespaceSelectorFromPathId(parentComponentId, namespace_.resolvedKeyVector)
                parentComponentNamespace = objectStore.openNamespace(parentComponentSelector)
                @extendedComponentType = mvvmToNamespaceType[parentComponentSelector.objectModelDescriptor.mvvmType]
                @extendedComponentModelView = new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceContextElement("", parentComponentNamespace.getResolvedLabel(), parentComponentSelector, selectorStore_)
                @extensionPointType = mvvmToNamespaceType[parentSelector.objectModelDescriptor.mvvmType]
                @extensionPointModelView = new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceContextElement("", parentNamespace.getResolvedLabel(), parentSelector, selectorStore_)
                @displayExtension = true


                

        catch exception
            throw "Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceSummary failure: #{exception}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorNamespaceSummary", ( -> """
    <div class="classObjectModelNavigatorNamespaceSectionTitle">Namespace Summary</div>
    <div class="classObjectModelNavigatorNamespaceSectionCommon classObjectModelNavigatorNamespaceSummary">
        <span class="classObjectModelNavigatorNamespaceContextLabelNoLink"><span data-bind="html: namespaceLabel"></span></span>
        is <span data-bind="html: namespaceType"></span><span data-bind="ifnot: displayComponent">.</span>
        <span data-bind="if: displayComponent">
            of the
            <span data-bind="with: componentModelView"><span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceContextElement' }"></span></span>
            <span data-bind="html: componentType"></span>.
        </span>
        <span data-bind="if: displayExtension">
            <br>Extends
            <span data-bind="with: extendedComponentModelView"><span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceContextElement' }"></span></span>
            <span data-bind="html: extendedComponentType"></span>
            via
            <span data-bind="with: extensionPointModelView"><span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceContextElement' }"></span></span>
            <span data-bind="html: extensionPointType"></span>.
        </span>
    </div>
"""))

# ******************************************************************************
# ******************************************************************************
# ******************************************************************************
# ******************************************************************************

class Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceWindow
    constructor: ->
        try

            @objectStoreName = ko.observable "<not connected>"
            @hashString = ko.observable "<not connected>"

            @title = ko.observable "<not connected>"
            @subtitle = ko.observable "<not connected>"
            @context = ko.observableArray []

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
                                prefix = index++ and " < " or ""
                                labelLast = parentComponentNamespace.objectModelDescriptor.label
                                label = "#{parentComponentNamespace.getResolvedLabel()}"
                                @context.push new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceContextElement(prefix, label, parentComponentNamespace.getResolvedSelector(), objectStore_)


                    mvvmType = selector.objectModelDescriptor.mvvmType

                    @title("""<strong>#{resolvedLabel}</strong>""")
                    subtitle = """#{selector.objectModelDescriptor.description}"""
                    @subtitle(subtitle)

                    @modelviewSummary(new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceSummary(selectedNamespace, objectStore_))

                    switch mvvmType
                        when "root"
                            @modelviewImmutable(new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceImmutable(selectedNamespace))
                            @modelviewMutable(undefined)
                            @modelviewComponent(new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceComponent(selectedNamespace, objectStore_))
                            newModelViewChildren = new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceChildren(selectedNamespace)
                            @modelviewChildren(newModelViewChildren.childrenCount and newModelViewChildren or undefined)
                            @modelviewCollection(undefined)
                            break
                        when "child"
                            @modelviewImmutable(new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceImmutable(selectedNamespace))
                            @modelviewMutable(new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceMutable(selectedNamespace))
                            @modelviewComponent(undefined)
                            newModelViewChildren = new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceChildren(selectedNamespace)
                            @modelviewChildren(newModelViewChildren.childrenCount and newModelViewChildren or undefined)                            
                            @modelviewCollection(undefined)
                            break
                        when "extension"
                            @modelviewImmutable(undefined)
                            @modelviewMutable(undefined)
                            @modelviewComponent(new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceComponent(selectedNamespace, objectStore_))
                            @modelviewChildren(undefined)
                            @modelviewCollection(new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceCollection(selectedNamespace, objectStore_))
                            break
                        when "archetype"
                            @modelviewImmutable(new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceImmutable(selectedNamespace))
                            @modelviewMutable(new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceMutable(selectedNamespace))
                            @modelviewComponent(new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceComponent(selectedNamespace, objectStore_))
                            newModelViewChildren = new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceChildren(selectedNamespace)
                            @modelviewChildren(newModelViewChildren.childrenCount and newModelViewChildren or undefined)
                            @modelviewCollection(undefined)
                            break
                        else
                            throw "Unrecognized MVVM type in request."

            }


        catch exception
            throw "Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceWindow construction failure: #{exception}"


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorNamespaceWindow", ( -> """

    <div class="classObjectModelNavigatorNamespaceHash">
        &gt; <span data-bind="text: objectStoreName"></span> [ <span data-bind="text: hashString"></span> ]
    </div>

    <span data-bind="if: context().length">
    <div class="classObjectModelNavigatorNamespaceContext" data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceContextElement', foreach: context }"></div>
    </span>


<div class="classObjectModelNavigatorNamespaceTitleBar">
    <span class="classObjectModelNavigatorNamespaceTitle" data-bind="html: title"></span>
    <span class="classObjectModelNavigatorNamespaceSubtitle" data-bind="html: subtitle"></span>
</div>

<span data-bind="if: modelviewSummary"><span data-bind="with: modelviewSummary"><span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceSummary'}"></span></span></span>

<span data-bind="if: modelviewImmutable"><span data-bind="with: modelviewImmutable"><span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceImmutable' }"></span></span></span>
<span data-bind="if: modelviewMutable"><span data-bind="with: modelviewMutable"><span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceMutable'}"></span></span></span>
<span data-bind="if: modelviewChildren"><span data-bind="with: modelviewChildren"><span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceChildren'}"></span></span></span>
<span data-bind="if: modelviewCollection"><span data-bind="with: modelviewCollection"><span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceCollection'}"></span></span></span>
<span data-bind="if: modelviewComponent"><span data-bind="with: modelviewComponent"><span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceComponent'}"></span></span></span>

"""))