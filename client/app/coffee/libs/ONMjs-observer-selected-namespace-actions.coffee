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
Encapsule.code.lib.onm = Encapsule.code.lib.onm? and Encapsule.code.lib.onm or @Encapsule.code.lib.onm = {}

ONMjs = Encapsule.code.lib.onm
ONMjs.observers = ONMjs.observers? and ONMjs.observers or ONMjs.observers = {}


#
# ============================================================================
class ONMjs.observers.SelectedNamespaceActionsModelView
    constructor: (params_) ->
        try

            #
            # ============================================================================
            @onClickAddSubcomponent = (prefix_, label_, address_, selectorStore_, options_) =>
                try
                    Console.message("ObjectModelNavigatorNamespaceActions.onClickAddSubcomponent starting...")
                    componentNamespace = selectorStore_.referenceStore.createComponent(address_)
                    selectorStore_.setAddress(componentNamespace.getResolvedAddress())

                catch exception
                    Console.messageError("ONMjs.observers.SelectedNamespaceActionsModelView.onClickAddSubcomponent failure: #{exception}")

            #
            # ============================================================================
            @onClickRemoveComponent = (prefix_, label_, address_, selectorStore_, options_) =>
                try
                    @showConfirmRemove(true)
                catch exception
                    throw "ONMjs.observers.SelectedNamespaceActionsModelView.onClickRemoveComponent failure: #{exception}"

            #
            # ============================================================================
            @onDoRemoveComponent = (prefix_, label_, address_, selectorStore_, options_) =>
                try
                    selectorStore_.referenceStore.removeComponent(address_)

                catch exception
                    Console.messageError("ONMjs.observers.SelectedNamespaceActionsModelView.onClickRemoveComponent failure: #{exception}")

            #
            # ============================================================================
            @onClickRemoveAllSubcomponents = (prefix_, label_, address_, selectorStore_, options_) =>
                try
                    @showConfirmRemoveAll(true)
                catch exception
                    throw "ONMjs.observers.SelectedNamespaceActionsModelView.onClickRemoveAllSubcomponents failure: #{exception}"

            #
            # ============================================================================
            @onDoRemoveAllSubcomponents = (prefix_, label_, address_, selectorStore_, options_) =>
                try
                    store = selectorStore_.referenceStore
                    namespace = store.openNamespace(address_)
                    subcomponentAddresses = [] 
                    namespace.visitExtensionPointSubcomponents( (address__) => subcomponentAddresses.push(address__) )
                    for address in subcomponentAddresses
                        store.removeComponent(address)

                catch exception
                    Console.messageError("ONMjs.observers.SelectedNamespaceActionsModelView.onClickRemoveAllSubcomponents failure: #{exception}")

            #
            # ============================================================================
            @onClickCancelActionRequest  = (prefix_, label_, address_, selectorStore_, options_) =>
                try
                    @showConfirmRemoveAll(false)
                    @showConfirmRemove(false)
                catch exception
                    throw "ONMjs.observers.SelectedNamespaceActionsModelView.onClickCancelActionRequest failure: #{exception}"



            #
            # ==============================================================================
            @actionsForNamespace = false

            @callbackLinkAddSubcomponent = undefined

            @callbackLinkRequestRemoveAllSubcomponents = undefined
            @callbackLinkRemoveAllSubcomponents = undefined

            @callbackLinkRequestRemoveComponent = undefined
            @callbackLinkRemoveComponent = undefined

            @callbackLinkCancelActionRequest = new ONMjs.observers.helpers.CallbackLinkModelView(
                "", "Cancel Request", undefined, undefined, { styleClass: "classONMjsActionButtonCancel" }, @onClickCancelActionRequest
                )

            @showConfirmRemove = ko.observable(false)
            @showConfirmRemoveAll = ko.observable(false)

            switch params_.selectedNamespaceModel.namespaceType
                when "root"
                    break

                when "child"
                    break

                when "extensionPoint"

                    # ACTION: add

                    componentAddress = params_.selectedAddress.createSubcomponentAddress()
                    componentModel = componentAddress.getModel()
                    archetypeLabel = componentModel.____label? and componentModel.____label or "<no label provided>"
                    
                    @callbackLinkAddSubcomponent = new ONMjs.observers.helpers.CallbackLinkModelView(
                        "", "Add #{archetypeLabel}", componentAddress, params_.cachedAddressStore, { styleClass: "classONMjsActionButtonAdd" }, @onClickAddSubcomponent)

                    # ACTION: remove all subcomponents

                    subcomponentCount = Encapsule.code.lib.js.dictionaryLength(params_.selectedNamespace.data())

                    label = params_.selectedNamespaceModel.____label? and params_.selectedNamespaceModel.____label or "<no label defined>"

                    @callbackLinkRequestRemoveAllSubcomponents = new ONMjs.observers.helpers.CallbackLinkModelView(
                        "", "Remove All #{label}", undefined, undefined,
                        { noLink: subcomponentCount == 0, styleClass: subcomponentCount != 0 and "classONMjsActionButtonRemoveAll" or undefined }, @onClickRemoveAllSubcomponents
                        )

                    @callbackLinkRemoveAllSubcomponents = new ONMjs.observers.helpers.CallbackLinkModelView(
                        "", "Proceed with Remove All", params_.selectedAddress, params_.cachedAddressStore,
                        { noLink: subcomponentCount == 0, styleClass: subcomponentCount != 0 and "classONMjsActionButtonConfirm" or undefined }, @onDoRemoveAllSubcomponents
                        )

                    @actionsForNamespace = true
                    break

                when "component"

                    # ACTION: remove

                    label = params_.selectedNamespaceModel.____label? and params_.selectedNamespaceModel.____label or "<no label provided>"
                    @callbackLinkRequestRemoveComponent = new ONMjs.observers.helpers.CallbackLinkModelView(
                        "", "Remove #{label}", undefined, undefined, { styleClass: "classONMjsActionButtonRemove" }, @onClickRemoveComponent)

                    @callbackLinkRemoveComponent = new ONMjs.observers.helpers.CallbackLinkModelView(
                        "", "Proceed with Remove", params_.selectedAddress, params_.cachedAddressStore, { styleClass: "classONMjsActionButtonConfirm" }, @onDoRemoveComponent)

                    @actionsForNamespace = true
                    break



        catch exception
            throw "ONMjs.observers.SelectedNamespaceActions construction failure: #{exception}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SelectedNamespaceActionsViewModel", ( -> """
<div class="classONMjsSelectedNamespaceSectionTitle">
    Actions:
</div>
<div class="classONMjsSelectedNamespaceSectionCommon classONMjsSelectedNamespaceActions">
    <span data-bind="if: actionsForNamespace">
        <div>
            <span data-bind="if: callbackLinkAddSubcomponent">
                <span data-bind="with: callbackLinkAddSubcomponent">
                    <span data-bind="template: { name: 'idKoTemplate_CallbackLinkViewModel' }"></span>
                </span>
            </span>
            <span data-bind="if: callbackLinkRequestRemoveAllSubcomponents">
                <span data-bind="with: callbackLinkRequestRemoveAllSubcomponents">
                    <span data-bind="template: { name: 'idKoTemplate_CallbackLinkViewModel' }"></span>
                </span>
            </span>
            <span data-bind="if: callbackLinkRequestRemoveComponent">
                <span data-bind="with: callbackLinkRequestRemoveComponent">
                    <span data-bind="template: { name: 'idKoTemplate_CallbackLinkViewModel' }"></span>
                </span>
            </span>

            <span data-bind="if: showConfirmRemove">
                <div class="classONMjsActionConfirmation">
                    Please confirm <strong><span data-bind="text: callbackLinkRequestRemoveComponent.label"></span></span></strong> request.<br><br>
                    <span data-bind="with: callbackLinkCancelActionRequest">
                        <span data-bind="template: { name: 'idKoTemplate_CallbackLinkViewModel' }"></span>
                    </span>
                    <span data-bind="with: callbackLinkRemoveComponent">
                        <span data-bind="template: { name: 'idKoTemplate_CallbackLinkViewModel' }"></span>
                    </span>
                </div>
            </span>

            <span data-bind="if: showConfirmRemoveAll">
                <div class="classONMjsActionConfirmation">
                    Please confirm <strong><span data-bind="text: callbackLinkRequestRemoveAllSubcomponents.label"></span></span></strong> request.<br><br>
                    <span data-bind="with: callbackLinkCancelActionRequest">
                        <span data-bind="template: { name: 'idKoTemplate_CallbackLinkViewModel' }"></span>
                    </span>
                    <span data-bind="with: callbackLinkRemoveAllSubcomponents">
                        <span data-bind="template: { name: 'idKoTemplate_CallbackLinkViewModel' }"></span>
                    </span>
                </div>
            </span>

        </div>
    </span>
    <span data-bind="ifnot: actionsForNamespace"><i>No actions defined for this namespace.</i></span>
</div>
"""))

