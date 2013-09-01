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


#
# ============================================================================
class ONMjs.observers.ObjectModelNavigatorNamespaceActions
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
                    Console.messageError("ONMjs.observers.ObjectModelNavigatorNamespaceActions.onClickAddSubcomponent failure: #{exception}")

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
                    Console.messageError("ONMjs.observers.ObjectModelNavigatorNamespaceActions.onClickRemoveAllSubcomponents failure: #{exception}")

            @onDoRemoveComponent = (prefix_, label_, selector_, selectorStore_, options_) =>
                try
                    Console.message("ObjectModelNavigatorNamespaceActions.onClickRemoveComponent start...")
                    @blipper.blip("27")

                    selectorStore_.associatedObjectStore.removeComponent(selector_)
                    Console.message("... Success. The component has been removed.")

                catch exception
                    Console.messageError("ONMjs.observers.ObjectModelNavigatorNamespaceActions.onClickRemoveComponent failure: #{exception}")


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

            @callbackLinkCancelActionRequest = new ONMjs.observers.ObjectModelNavigatorNamespaceCallbackLink(
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
                    @callbackLinkAddSubcomponent = new ONMjs.observers.ObjectModelNavigatorNamespaceCallbackLink(
                        "", "Add #{archetypeLabel}", archetypeSelector, selectorStore_, { styleClass: "classActionAdd" }, @onClickAddSubcomponent)

                    # remove all subcomponents

                    @callbackLinkRequestRemoveAllSubcomponents = new ONMjs.observers.ObjectModelNavigatorNamespaceCallbackLink(
                        "", "Remove All #{namespace_.objectModelDescriptor.label}", undefined, undefined,
                        { noLink: namespace_.objectStoreNamespace.length == 0, styleClass: namespace_.objectStoreNamespace.length != 0 and "classActionRemoveAll" or undefined }, @onClickRemoveAllSubcomponents
                        )

                    @callbackLinkRemoveAllSubcomponents = new ONMjs.observers.ObjectModelNavigatorNamespaceCallbackLink(
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
                    @callbackLinkRequestRemoveComponent = new ONMjs.observers.ObjectModelNavigatorNamespaceCallbackLink(
                        "", "Remove #{componentSelector.objectModelDescriptor.label}", undefined, undefined, { styleClass: "classActionRemove" }, @onClickRemoveComponent)

                    @callbackLinkRemoveComponent = new ONMjs.observers.ObjectModelNavigatorNamespaceCallbackLink(
                        "", "Proceed with Remove", componentSelector, selectorStore_, { styleClass: "classActionConfirm" }, @onDoRemoveComponent)

                    @actionsForNamespace = true
                    break



        catch exception
            throw "ONMjs.observers.ObjectModelNavigatorNamespaceActions #{exception}"

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

