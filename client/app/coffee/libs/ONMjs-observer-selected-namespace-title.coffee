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
class ONMjs.observers.SelectedNamespaceTitleModelView
    constructor: (params_) ->
        try

            @namespaceLabelResolved = params_.selectedNamespace.getResolvedLabel()
            @namespaceDescription = params_.selectedNamespaceModel.____description? and params_.selectedNamespaceModel.____description or "<no description provided>"

            displayComponent = false
            componentPathId = undefined
            componentSelector = undefined
            componentLabelResolved = undefined
            @componentSuffixString = undefined # is set to ':' or '::' based on if the component represents the store

            displayExtensionPoint = false
            extensionPointLabel = undefined

            @contextLinkModelViewComponent = undefined
            @contextLinkModelViewExtensionPoint = undefined

            # If the selected namespace isn't the root namespace, by definition it is owned by a component:
            # may be a subnamespace of a component or the root namespace of an extension component.

            componentAddress = undefined
            componentDescriptor = undefined
            extensionPointAddress = undefined

            namespaceType = params_.selectedAddress.getModel().namespaceType            

            if not (namespaceType == "root")
                displayComponent = true
                if params_.selectedNamespaceModel.namespaceType != "component"
                    # The selected namespace is a subnamespace of a component.
                    componentAddress = params_.selectedAddress.createComponentAddress()
                else
                    # The selected namespace is the root of an extension component.
                    extensionPointAddress = params_.selectedAddress.createParentAddress()
                    componentAddress = extensionPointAddress.createComponentAddress()

                componentNamespace = params_.objectStore.openNamespace(componentAddress)
                componentLabelResolved = componentNamespace.getResolvedLabel()
                @componentSuffixString = (componentAddress.getModel().namespaceType != "root" and ":") or "::"
                @componentClickableLink = new ONMjs.observers.helpers.AddressSelectionLinkModelView(
                    "", componentLabelResolved, componentAddress, params_.cachedAddressStore)

            if namespaceType == "component"
                # We'll need the owning extension point's label and type information.
                displayExtensionPoint = true

                if not (extensionPointAddress? and extensionPointAddress)
                    extensionPointAddress = params_.selectedAddress.createParentAddress()
                    
                extensionPointModel = extensionPointAddress.getModel()
                label = extensionPointModel.____label? and extensionPointModel.____label or "<no label defined>"

                @extensionPointClickableLink = new ONMjs.observers.helpers.AddressSelectionLinkModelView(
                    "", label, extensionPointAddress, params_.cachedAddressStore)

            @templateName = undefined

            if not displayComponent
                # Root namespace format title.
                @templateName = "idKoTemplate_SelectedNamespaceTitleRootViewModel"

            else if not displayExtensionPoint
                # Child or extension point format title
                @templateName = "idKoTemplate_SelectedNamespaceTitleExtensionPointViewModel"

            else
                # Archetype (component) format title
                @templateName = "idKoTemplate_SelectedNamespaceTitleComponentViewModel"

        catch exception
            throw "ONMjs.observers.ObjectModelNavigatorNamespaceTitle failure: #{exception}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SelectedNamespaceTitleRootViewModel", ( -> """
<span class="selected" data-bind="html: namespaceLabelResolved"></span>
"""))

Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SelectedNamespaceTitleExtensionPointViewModel", ( -> """
<span data-bind="with: componentClickableLink"><span data-bind="template: { name: 'idKoTemplate_AddressSelectionLinkViewModel' }"></span></span>
<span class="separator" data-bind="html: componentSuffixString"></span>
<span class="selected" data-bind="html: namespaceLabelResolved"></span>
"""))

Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SelectedNamespaceTitleComponentViewModel", ( -> """
<span data-bind="with: componentClickableLink"><span data-bind="template: { name: 'idKoTemplate_AddressSelectionLinkViewModel' }"></span></span>
<span class="separator" data-bind="html: componentSuffixString"></span>
<span data-bind="with: extensionPointClickableLink"><span data-bind="template: { name: 'idKoTemplate_AddressSelectionLinkViewModel' }"></span></span>
<span class="separator"> / </span>
<span class="selected" data-bind="html: namespaceLabelResolved"></span>
"""))

Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SelectedNamespaceTitleViewModel", ( -> """
<div class="classONMjsSelectedNamespaceTitle">
    <span class="classONMjsSelectedNamespaceTitleLinks" data-bind="template: { name: function () { return templateName; } }" ></span>
    <div class="description" data-bind="html: namespaceDescription"></div>
</div>
"""))

