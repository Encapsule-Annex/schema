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
class ONMjs.observers.SelectedNamespaceTitleModelView
    constructor: (namespace_, selectorStore_) ->
        try

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
                @contextLinkModelViewComponent = new ONMjs.observers.ObjectModelNavigatorNamespaceContextElement(
                    "", componentLabelResolved, componentSelector, selectorStore_)

            if namespaceDescriptor.mvvmType == "archetype"
                # We'll need the owning extension point's label and type information.
                displayExtensionPoint = true

                extensionPointSelector = objectStore.objectModel.createNamespaceSelectorFromPathId(namespaceDescriptor.parent.id, namespace_.resolvedKeyVector)
                extensionPointDescriptor = extensionPointSelector.objectModelDescriptor
                @contextLinkModelViewExtensionPoint = new ONMjs.observers.ObjectModelNavigatorNamespaceContextElement(
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
            throw "ONMjs.observers.ObjectModelNavigatorNamespaceTitle failure: #{exception}"

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

