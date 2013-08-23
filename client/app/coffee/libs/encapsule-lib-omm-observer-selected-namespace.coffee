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
# encapsule-lib-omm-observer-selected-namespace.coffee
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
Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorNamespaceContextElement", ( -> """<span data-bind="if: prefix"><span class="classObjectModelNavigatorNamespaceContextPrefix" data-bind="html: prefix"></span></span><span data-bind="ifnot: optionsNoLink"><span class="classObjectModelNavigatorNamespaceContextLabel classObjectModelNavigatorMouseOverCursorPointer" data-bind="html: label, click: onClick"></span></span><span data-bind="if: optionsNoLink"><span class="classObjectModelNavigatorNamespaceContextLabelNoLink" data-bind="html: label"></span></span>"""))

#
# ============================================================================
class Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceCallbackLink
    constructor: (prefix_, label_, selector_, selectorStore_, options_, callback_) ->
        try
            @prefix = prefix_? and prefix_ or ""
            @label = label_? and label_ or "<no label provided>"
            @selector = selector_? and selector_ and selector_.clone() or undefined
            @selectorStore = selectorStore_? and selectorStore_ or undefined
            @options = options_? and options_ or {}
            @optionsNoLink = @options.noLink? and @options.noLink or false
            @optionsStyleClass = @options.styleClass? and @options.styleClass or undefined
            @callback = callback_

            @onClick = =>
                @callback(@prefix, @label, @selector, @selectorStore, @options)

        catch exception
            throw "Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceCallbackLink failure: #{exception}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorNamespaceCallbackLink", ( -> """
<span class="classObjectModelNavigatorNamespaceCallbackLink">
<span data-bind="if: prefix"><span class="prefix" data-bind="html: prefix"></span></span>
<span data-bind="ifnot: optionsNoLink">
    <span class="link classObjectModelNavigatorMouseOverCursorPointer" data-bind="html: label, click: onClick, css: optionsStyleClass"></span>
</span>
<span data-bind="if: optionsNoLink">
    <span class="nolink" data-bind="html: label, css: optionsStyleClass"></span>
</span>
</span>
"""))

#
# ============================================================================
class Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceActions
    constructor: (namespace_, selectorStore_) ->
        try

            @onClickAddSubcomponent = (prefix_, label_, selector_, selectorStore_, options_) =>
                try
                    Console.message("ObjectModelNavigatorNamespaceActions.onClickAddSubcomponent starting...")
                    componentNamespace = selectorStore_.associatedObjectStore.createComponent(selector_)
                    @blipper.blip("23")
                    setTimeout( ( =>
                        selectorStore_.setSelector(componentNamespace.getResolvedSelector())
                        Console.message("... Success. A new component has been added and selected.")
                        ), 350)
                catch exception
                    Console.messageError("Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceActions.onClickAddSubcomponent failure: #{exception}")

            @onDoRemoveAllSubcomponents = (prefix_, label_, selector_, selectorStore_, options_) =>
                try
                    Console.message("ObjectModelNavigatorNamespaceActions.onClickRemoveComponent start...")
                    @blipper.blip("27")

                    archetypePathId = namespace_.objectModelDescriptor.archetypePathId
                    archetypeSelector = selectorStore_.associatedObjectStore.objectModel.createNamespaceSelectorFromPathId(archetypePathId)
                    archetypeJsonTag = archetypeSelector.objectModelDescriptor.jsonTag
                    semanticBindings = selectorStore_.associatedObjectStore.objectModel.getSemanticBindings()
                    extensionPointNamespace = selectorStore_.associatedObjectStore.openNamespace(selector_)

                    subcomponentSelectorVector = []
                    for subcomponentStoreNamespaceRecord in extensionPointNamespace.objectStoreNamespace
                        subcomponentStoreNamespace = subcomponentStoreNamespaceRecord[archetypeJsonTag]
                        subcomponentKeyVector = Encapsule.code.lib.js.clone(extensionPointNamespace.resolvedKeyVector)
                        subcomponentKeyVector.push semanticBindings.getUniqueKey(subcomponentStoreNamespace)
                        subcomponentSelector = selectorStore_.associatedObjectStore.objectModel.createNamespaceSelectorFromPathId(archetypePathId, subcomponentKeyVector)
                        subcomponentSelectorVector.push subcomponentSelector

                    for subcomponentSelector in subcomponentSelectorVector
                        selectorStore_.associatedObjectStore.removeComponent(subcomponentSelector)

                catch exception
                    Console.messageError("Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceActions.onClickRemoveAllSubcomponents failure: #{exception}")

            @onDoRemoveComponent = (prefix_, label_, selector_, selectorStore_, options_) =>
                try
                    Console.message("ObjectModelNavigatorNamespaceActions.onClickRemoveComponent start...")
                    @blipper.blip("27")

                    selectorStore_.associatedObjectStore.removeComponent(selector_)
                    Console.message("... Success. The component has been removed.")

                catch exception
                    Console.messageError("Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceActions.onClickRemoveComponent failure: #{exception}")


            @onClickRemoveComponent = (prefix_, label_, selector_, selectorStore_, options_) =>
                @blipper.blip("15")
                @showConfirmRemove(true)

            @onClickRemoveAllSubcomponents = (prefix_, label_, selector_, selectorStore_, options_) =>
                @blipper.blip("15")
                @showConfirmRemoveAll(true)

            @onClickCancelActionRequest  = (prefix_, label_, selector_, selectorStore_, options_) =>
                @showConfirmRemoveAll(false)
                @showConfirmRemove(false)




            #
            # ==============================================================================
            @blipper = Encapsule.runtime.boot.phase0.blipper
            @actionsForNamespace = false

            @callbackLinkAddSubcomponent = undefined

            @callbackLinkRequestRemoveAllSubcomponents = undefined
            @callbackLinkRemoveAllSubcomponents = undefined

            @callbackLinkRequestRemoveComponent = undefined
            @callbackLinkRemoveComponent = undefined

            @callbackLinkCancelActionRequest = new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceCallbackLink(
                "", "Cancel Request", undefined, undefined, { styleClass: "classActionCancel" }, @onClickCancelActionRequest
                )

            @showConfirmRemove = ko.observable(false)
            @showConfirmRemoveAll = ko.observable(false)

            switch namespace_.objectModelDescriptor.mvvmType
                when "root"
                    break

                when "child"
                    break

                when "extension"

                    # add

                    # Here we need to discriminate between a component archetype that was declared as a child of this
                    # extension point in the OM declaration vs. an archetype that was defined by reference. Note that
                    # because the declaration is processed depth-first, it's always the case that we can use a simple
                    # relational operator to make this determination.

                    secondaryKeyVector = undefined

                    if namespace_.objectModelDescriptor.id > namespace_.objectModelDescriptor.archetypePathId

                        # This is the more complex case where the component archetype is declared before the extension
                        # point in the OM declaration and referred back to by reference. (This is called a
                        # recursive component as it's extensible by instances of itself).
                        secondaryKeyVector = namespace_.secondaryResolvedKeyVector? and namespace_.secondaryResolvedKeyVector and
                            Encapsule.code.lib.js.clone(namespace_.secondaryResolvedKeyVector) or []

                        secondarySelectPair = {
                            idExtensionPoint: namespace_.pathId
                            selectKey: undefined # the resulting selector is to be used to create a new component instance
                            }

                        secondaryKeyVector.push secondarySelectPair

                    archetypeSelector = selectorStore_.associatedObjectStore.objectModel.createNamespaceSelectorFromPathId(
                        namespace_.objectModelDescriptor.archetypePathId, namespace_.resolvedKeyVector, secondaryKeyVector)

                    archetypeLabel = archetypeSelector.objectModelDescriptor.label
                    @callbackLinkAddSubcomponent = new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceCallbackLink(
                        "", "Add #{archetypeLabel}", archetypeSelector, selectorStore_, { styleClass: "classActionAdd" }, @onClickAddSubcomponent)

                    # remove all subcomponents

                    @callbackLinkRequestRemoveAllSubcomponents = new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceCallbackLink(
                        "", "Remove All #{namespace_.objectModelDescriptor.label}", undefined, undefined,
                        { noLink: namespace_.objectStoreNamespace.length == 0, styleClass: namespace_.objectStoreNamespace.length != 0 and "classActionRemoveAll" or undefined }, @onClickRemoveAllSubcomponents
                        )

                    @callbackLinkRemoveAllSubcomponents = new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceCallbackLink(
                        "", "Proceed with Remove All", namespace_.getResolvedSelector(), selectorStore_,
                        { noLink: namespace_.objectStoreNamespace.length == 0, styleClass: namespace_.objectStoreNamespace.length != 0 and "classActionConfirm" or undefined }, @onDoRemoveAllSubcomponents
                        )

                    @actionsForNamespace = true
                    break

                when "archetype"
                    # This namespace is a root of a component object. Ensure the namespace selector passed to the callback
                    # link constructor is valid.

                    componentSelector = namespace_.getResolvedSelector()

                    # remove
                    @callbackLinkRequestRemoveComponent = new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceCallbackLink(
                        "", "Remove #{componentSelector.objectModelDescriptor.label}", undefined, undefined, { styleClass: "classActionRemove" }, @onClickRemoveComponent)

                    @callbackLinkRemoveComponent = new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceCallbackLink(
                        "", "Proceed with Remove", componentSelector, selectorStore_, { styleClass: "classActionConfirm" }, @onDoRemoveComponent)

                    @actionsForNamespace = true
                    break



        catch exception
            throw "Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceActions #{exception}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorNamespaceActions", ( -> """
<div class="classObjectModelNavigatorNamespaceSectionTitle">
    Actions:
</div>
<div class="classObjectModelNavigatorNamespaceSectionCommon classObjectModelNavigatorNamespaceActions">
    <span data-bind="if: actionsForNamespace">
        <div>
            <span data-bind="if: callbackLinkAddSubcomponent">
                <span data-bind="with: callbackLinkAddSubcomponent">
                    <span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceCallbackLink' }"></span>
                </span>
            </span>
            <span data-bind="if: callbackLinkRequestRemoveAllSubcomponents">
                <span data-bind="with: callbackLinkRequestRemoveAllSubcomponents">
                    <span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceCallbackLink' }"></span>
                </span>
            </span>
            <span data-bind="if: callbackLinkRequestRemoveComponent">
                <span data-bind="with: callbackLinkRequestRemoveComponent">
                    <span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceCallbackLink' }"></span>
                </span>
            </span>

            <span data-bind="if: showConfirmRemove">
                <div class="classActionConfirmation">
                    Please confirm <strong><span data-bind="text: callbackLinkRequestRemoveComponent.label"></span></span></strong> request.<br><br>
                    <span data-bind="with: callbackLinkCancelActionRequest">
                        <span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceCallbackLink' }"></span>
                    </span>
                    <span data-bind="with: callbackLinkRemoveComponent">
                        <span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceCallbackLink' }"></span>
                    </span>
                </div>
            </span>

            <span data-bind="if: showConfirmRemoveAll">
                <div class="classActionConfirmation">
                    Please confirm <strong><span data-bind="text: callbackLinkRequestRemoveAllSubcomponents.label"></span></span></strong> request.<br><br>
                    <span data-bind="with: callbackLinkCancelActionRequest">
                        <span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceCallbackLink' }"></span>
                    </span>
                    <span data-bind="with: callbackLinkRemoveAllSubcomponents">
                        <span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceCallbackLink' }"></span>
                    </span>
                </div>
            </span>

        </div>
    </span>
    <span data-bind="ifnot: actionsForNamespace">
        <i>No actions defined for this namespace.</i>
    </span>
</div>
"""))



#
# ============================================================================
class Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceImmutable
    constructor: (namespace_) ->
        try
            @propertyModelViews = []

            namespaceSelector = namespace_.getResolvedSelector()
            namespaceDescriptor = namespaceSelector.objectModelDescriptor
            namespaceStoreData = namespace_.objectStoreNamespace

            # TODO: change namespaceDescriptor to namespaceDeclaration in descriptor
            namespaceDeclaration = namespaceDescriptor.namespaceDescriptor

            if not (namespaceDeclaration? and namespaceDeclaration)
                throw "Cannot resolve namespace declaration for selection."

            namespaceDeclarationImmutable = namespaceDeclaration.userImmutable? and namespaceDeclaration.userImmutable or undefined

            if not (namespaceDeclarationImmutable? and namespaceDeclarationImmutable)
                return

            # Enumerate the object model's declaration of this namespace's immutable properties.
            for name, value of namespaceDeclarationImmutable
                propertyDescriptor =
                    immutable: true
                    declaration:
                        property: name
                        members: value
                    store:
                        value: namespaceStoreData[name]

                @propertyModelViews.push propertyDescriptor

        catch exception
            throw "Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceImmutable failure: #{exception}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorNamespaceImmutable", ( -> """
<div class="classObjectModelNavigatorNamespaceSectionTitle">
    Immutable Properties (<span data-bind="text: propertyModelViews.length"></span>):
</div>
<div class="classObjectModelNavigatorNamespaceSectionCommon classObjectModelNavigatorNamespaceImmutable">
    <span data-bind="if: propertyModelViews.length">
        <div class="classObjectModelNavigatorNamespaceProperties">
            <span data-bind="foreach: propertyModelViews">
                <div class="name"><span class="immutable" data-bind="text: declaration.property"></span></div>
                <div class="type" data-bind="text: declaration.members.type"></div>
                <div class="value"><span class="immutable" data-bind="text: store.value"></span></div>
                <div style="clear: both;" />
            </div>
        </div>
    </span>
    <span data-bind="ifnot: propertyModelViews.length">
        <i>This namespace has no immutable properties.</i>
    </span>
</div>
"""))


# ******************************************************************************
# ******************************************************************************
# ******************************************************************************
# ******************************************************************************
#
# ============================================================================
class Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceMutable
    constructor: (namespace_) ->
        try
            @propertyModelViews = []

            namespaceSelector = namespace_.getResolvedSelector()
            namespaceDescriptor = namespaceSelector.objectModelDescriptor
            namespaceStoreData = namespace_.objectStoreNamespace

            # TODO: change namespaceDescriptor to namespaceDeclaration in descriptor
            namespaceDeclaration = namespaceDescriptor.namespaceDescriptor

            if not (namespaceDeclaration? and namespaceDeclaration)
                throw "Cannot resolve namespace declaration for selection."

            namespaceDeclarationMutable = namespaceDeclaration.userMutable? and namespaceDeclaration.userMutable or undefined

            if not (namespaceDeclarationMutable? and namespaceDeclarationMutable)
                return

            # Enumerate the object model's declaration of this namespace's mutable properties.
            for name, value of namespaceDeclarationMutable
                propertyDescriptor =
                    immutable: false
                    declaration:
                        property: name
                        members: value
                    store:
                        value: namespaceStoreData[name]

                @propertyModelViews.push propertyDescriptor


        catch exception
            throw "Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceMutable failure: #{exception}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorNamespaceMutable", ( -> """
<div class="classObjectModelNavigatorNamespaceSectionTitle">
    Mutable Properties (<span data-bind="text: propertyModelViews.length"></span>):
</div>
<div class="classObjectModelNavigatorNamespaceSectionCommon classObjectModelNavigatorNamespaceImmutable">
    <span data-bind="if: propertyModelViews.length">
        <div class="classObjectModelNavigatorNamespaceProperties">
            <span data-bind="foreach: propertyModelViews">
                <div class="name" data-bind="text: declaration.property"></div>
                <div class="type" data-bind="text: declaration.members.type"></div>
                <div class="value" data-bind="text: store.value"></div>
                <div style="clear: both;" />
            </div>
        </div>
    </span>
    <span data-bind="ifnot: propertyModelViews.length">
        <i>This namespace has no mutable properties.</i>
    </span>
</div>
"""))

# ******************************************************************************
# ******************************************************************************
# ******************************************************************************
# ******************************************************************************
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
                "", componentNamespace.getResolvedLabel(), componentSelector, selectorStore_, { noLink: namespace_.objectModelDescriptor.isComponent } )

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
                label += " (#{subcomponentCount})"
                @extensionPointModelViewArray.push new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceContextElement(
                    prefix, label, extensionPointSelector, selectorStore_, { noLink: noLinkFlag })

        catch exception
            throw "Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceComponent failure: #{exception}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorNamespaceComponent", ( -> """

<span data-bind="if: extensionPointModelViewArray.length">
    <div class="classObjectModelNavigatorNamespaceSectionTitle">
        Extension Points (<span data-bind="text: extensionPointModelViewArray.length"></span>):
    </div>
    <span data-bind="ifnot: extensionPointModelViewArray.length"><i>Extension point contains no subcomponents.</i></span>
    <span data-bind="if: extensionPointModelViewArray.length">
    <div class="classObjectModelNavigatorNamespaceSectionCommon classObjectModelNavigatorNamespaceComponent">
        <span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceContextElement', foreach: extensionPointModelViewArray }"></span>
    </div>
    </span>
</span>
"""))


# ******************************************************************************
# ******************************************************************************
# ******************************************************************************
# ******************************************************************************
#
# ============================================================================
class Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceChildren
    constructor: (namespace_, selectorStore_) ->
        try
            selector = namespace_.getResolvedSelector()
            @childModelViews = []

            if selector.objectModelDescriptor.children.length
                index = 0
                for descriptor in selector.objectModelDescriptor.children
                    childSelector = namespace_.objectStore.objectModel.createNamespaceSelectorFromPathId(descriptor.id, selector.selectKeyVector)
                    childNamespace = namespace_.objectStore.openNamespace(childSelector)
                    prefix = "#{index++ + 1}: "
                    label =  "#{childNamespace.getResolvedLabel()}"
                    if childSelector.objectModelDescriptor.mvvmType == "extension"
                        label += " (#{childNamespace.objectStoreNamespace.length})"
                    label += "<br>"
                    @childModelViews.push new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceContextElement(prefix, label, childSelector, selectorStore_)
                
        catch exception
            throw "Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceChildren failure: #{exception}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorNamespaceChildren", ( -> """
<span data-bind="if: childModelViews.length">
    <div class="classObjectModelNavigatorNamespaceSectionTitle">Child Namespaces (<span data-bind="text: childModelViews.length"></span>):</div>
    <div class="classObjectModelNavigatorNamespaceSectionCommon classObjectModelNavigatorNamespaceChildren">
        <span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceContextElement', foreach: childModelViews }"></span>
    </div>
</span>
"""))


# ******************************************************************************
# ******************************************************************************
# ******************************************************************************
# ******************************************************************************
#
# ============================================================================
class Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceCollection
    constructor: (namespace_, selectorStore_) ->
        try
            @namespaceLabel = namespace_.objectModelDescriptor.label

            semanticBindings = namespace_.objectStore.objectModel.getSemanticBindings()
            elementPathId = namespace_.objectModelDescriptor.archetypePathId
            @elementSelector = namespace_.objectStore.objectModel.createNamespaceSelectorFromPathId(elementPathId, namespace_.resolvedKeyVector)
            elementJsonTag = @elementSelector.objectModelDescriptor.jsonTag

            @subcomponentModelViews = []

            @addElementCallbackLink = new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceCallbackLink(
                "", "add", @elementSelector, selectorStore_, undefined, @onClickAddElement)

            index = 0
            for elementEntry in namespace_.objectStoreNamespace
                elementData = elementEntry[elementJsonTag]
                elementKey = semanticBindings.getUniqueKey(elementData)
                elementSelectKeyVector = Encapsule.code.lib.js.clone(namespace_.resolvedKeyVector)
                elementSelectKeyVector.push elementKey
                elementSelector = namespace_.objectStore.objectModel.createNamespaceSelectorFromPathId(elementPathId, elementSelectKeyVector)
                elementNamespace = namespace_.objectStore.openNamespace(elementSelector)
                prefix = "#{index++ + 1}: "
                label = "#{elementNamespace.getResolvedLabel()}<br>"
                @subcomponentModelViews.push new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceContextElement(
                    prefix, label, elementSelector, selectorStore_)
                
        catch exception
            throw "Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceCollection failure: #{exception}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorNamespaceCollection", ( -> """
<div class="classObjectModelNavigatorNamespaceSectionTitle">
<span class="class="classObjectModelNavigatorNamespaceContextLabelNoLink" data-bind="html: elementSelector.objectModelDescriptor.label"></span>
Subcomponents (<span data-bind="text: subcomponentModelViews.length"></span>):
</div>
<div class="classObjectModelNavigatorNamespaceSectionCommon classObjectModelNavigatorNamespaceCollection">
<span data-bind="ifnot: subcomponentModelViews.length">
<i><span class="classObjectModelNavigatorNamespaceContextLabelNoLink" data-bind="html: namespaceLabel"></span> extension point is empty.</i>
</span>
<span data-bind="if: subcomponentModelViews.length">
<span class="link" data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceContextElement', foreach: subcomponentModelViews }"></span>
</span>
</div>
"""))


# ******************************************************************************
# ******************************************************************************
# ******************************************************************************
# ******************************************************************************
#
# ============================================================================
class Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceTitle
    constructor: (namespace_, selectorStore_) ->
        try
            # aliases
            objectStore = selectorStore_.associatedObjectStore
            namespaceDescriptor = namespace_.objectModelDescriptor

            # model view members

            @namespaceLabelResolved = namespace_.getResolvedLabel()
            @namespaceDescription = namespaceDescriptor.description

            displayComponent = false
            componentPathId = undefined
            componentSelector = undefined
            componentLabelResolved = undefined
            @componentSuffixString = undefined # set to ':' or '::' based on if the component represents the store

            displayExtensionPoint = false
            extensionPointLabel = undefined

            @contextLinkModelViewComponent = undefined
            @contextLinkModelViewExtensionPoint = undefined

            if namespaceDescriptor.id != 0
                # We'll need the owning component's label and type information.
                displayComponent = true

                switch namespaceDescriptor.mvvmType
                    when "child"
                        componentPathId = namespaceDescriptor.idComponent
                        break
                    when "extension"
                        componentPathId = namespaceDescriptor.idComponent
                        break
                    when "archetype"
                        componentPathId = namespaceDescriptor.parent.idComponent
                        break
                    else
                        throw "Unexpected MVVM type in switch."

                componentSelector = objectStore.objectModel.createNamespaceSelectorFromPathId(componentPathId, namespace_.resolvedKeyVector)
                componentDescriptor = componentSelector.objectModelDescriptor
                componentNamespace = objectStore.openNamespace(componentSelector)
                @componentSuffixString = componentDescriptor.id and ":" or "::"
                componentLabelResolved = componentNamespace.getResolvedLabel()
                @contextLinkModelViewComponent = new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceContextElement(
                    "", componentLabelResolved, componentSelector, selectorStore_)

            if namespaceDescriptor.mvvmType == "archetype"
                # We'll need the owning extension point's label and type information.
                displayExtensionPoint = true

                extensionPointSelector = objectStore.objectModel.createNamespaceSelectorFromPathId(namespaceDescriptor.parent.id, namespace_.resolvedKeyVector)
                extensionPointDescriptor = extensionPointSelector.objectModelDescriptor
                @contextLinkModelViewExtensionPoint = new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceContextElement(
                    "", extensionPointDescriptor.label, extensionPointSelector, selectorStore_)

            @templateName = undefined

            if not displayComponent
                # Root namespace format title.
                @templateName = "idKoTemplate_ObjectModelNavigatorNamespaceTitleRoot"

            else if not displayExtensionPoint
                # Child or extension point format title
                @templateName = "idKoTemplate_ObjectModelNavigatorNamespaceTitleChildEP"

            else
                # Archetype (component) format title
                @templateName = "idKoTemplate_ObjectModelNavigatorNamespaceTitleComponent"

        catch exception
            throw "Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceTitle failure: #{exception}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorNamespaceTitleRoot", ( -> """
<span class="selected" data-bind="html: namespaceLabelResolved"></span>
"""))

Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorNamespaceTitleChildEP", ( -> """
<span data-bind="with: contextLinkModelViewComponent"><span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceContextElement' }"></span></span>
<span class="separator" data-bind="html: componentSuffixString"></span>
<span class="selected" data-bind="html: namespaceLabelResolved"></span>
"""))

Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorNamespaceTitleComponent", ( -> """
<span data-bind="with: contextLinkModelViewComponent"><span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceContextElement' }"></span></span>
<span class="separator" data-bind="html: componentSuffixString"></span>
<span data-bind="with: contextLinkModelViewExtensionPoint"><span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceContextElement' }"></span></span>
<span class="separator"> / </span>
<span class="selected" data-bind="html: namespaceLabelResolved"></span>
"""))

Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorNamespaceTitle", ( -> """
<div class="classObjectModelNavigatorNamespaceTitleBar">
    <span class="classObjectModelNavigatorNamespaceTitle" data-bind="template: { name: function () { return templateName; } }" ></span>
    <div class="description" data-bind="html: namespaceDescription"></div>
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

                    @modelviewSummary(new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceTitle(selectedNamespace, objectStore_))
                    @modelviewActions(new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceActions(selectedNamespace, objectStore_))

                    switch mvvmType
                        when "root"
                            @modelviewImmutable(new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceImmutable(selectedNamespace))
                            @modelviewMutable(undefined)
                            @modelviewComponent(new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceComponent(selectedNamespace, objectStore_))
                            newModelViewChildren = new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceChildren(selectedNamespace, objectStore_)
                            @modelviewChildren(newModelViewChildren.childModelViews.length and newModelViewChildren or undefined)
                            @modelviewCollection(undefined)
                            break
                        when "child"
                            immutableModelView = new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceImmutable(selectedNamespace)
                            @modelviewImmutable(immutableModelView.propertyModelViews.length and immutableModelView or undefined)
                            mutableModelView = new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceMutable(selectedNamespace)
                            @modelviewMutable(mutableModelView.propertyModelViews.length and mutableModelView or undefined)
                            @modelviewComponent(undefined)
                            newModelViewChildren = new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceChildren(selectedNamespace, objectStore_)
                            @modelviewChildren(newModelViewChildren.childModelViews.length and newModelViewChildren or undefined)                            
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
                            immutableModelView = new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceImmutable(selectedNamespace)
                            @modelviewImmutable(immutableModelView.propertyModelViews.length and immutableModelView or undefined)
                            mutableModelView = new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceMutable(selectedNamespace)
                            @modelviewMutable(mutableModelView.propertyModelViews.length and mutableModelView or undefined)
                            @modelviewComponent(new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceComponent(selectedNamespace, objectStore_))
                            newModelViewChildren = new Encapsule.code.lib.modelview.ObjectModelNavigatorNamespaceChildren(selectedNamespace, objectStore_)
                            @modelviewChildren(newModelViewChildren.childModelViews.length and newModelViewChildren or undefined)
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
<div class="classObjectModelNavigatorNamespaceHash"><span data-bind="text: objectStoreName"></span></div>
<span data-bind="if: modelviewSummary"><span data-bind="with: modelviewSummary"><span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceTitle' }"></span></span></span>
<span data-bind="if: modelviewActions"><span data-bind="with: modelviewActions"><span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceActions' }"></span></span></span>
<span data-bind="if: modelviewImmutable"><span data-bind="with: modelviewImmutable"><span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceImmutable' }"></span></span></span>
<span data-bind="if: modelviewMutable"><span data-bind="with: modelviewMutable"><span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceMutable'}"></span></span></span>
<span data-bind="if: modelviewCollection"><span data-bind="with: modelviewCollection"><span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceCollection'}"></span></span></span>
<span data-bind="if: modelviewComponent"><span data-bind="with: modelviewComponent"><span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceComponent'}"></span></span></span>
<span data-bind="if: modelviewChildren"><span data-bind="with: modelviewChildren"><span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceChildren'}"></span></span></span>
"""))