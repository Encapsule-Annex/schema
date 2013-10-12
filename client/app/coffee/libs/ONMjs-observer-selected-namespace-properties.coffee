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
class ONMjs.observers.SelectedNamespaceImmutablePropertiesModelView
    constructor: (params_) ->
        try
            @propertyModelViews = []

            namespaceModelProperties = params_.selectedAddress.getPropertiesModel()
            if not (namespaceModelProperties? and namespaceModelProperties)
                throw "Cannot resolve namespace properties declaration for selection."

            namespaceDeclarationImmutable = namespaceModelProperties.userImmutable? and namespaceModelProperties.userImmutable or undefined
            if not (namespaceDeclarationImmutable? and namespaceDeclarationImmutable)
                return

            dataReference = params_.selectedNamespace.data()

            # Enumerate the object model's declaration of this namespace's immutable properties.
            for name, members of namespaceDeclarationImmutable
                propertyDescriptor =
                    immutable: true
                    declaration:
                        property: name
                        members: members
                    store:
                        value: dataReference[name]
                @propertyModelViews.push propertyDescriptor

        catch exception
            throw "ONMjs.observers.SelectedNamespaceImmutablePropertiesModelView failure: #{exception}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SelectedNamespaceImmutablePropertiesViewModel", ( -> """
<div class="classONMjsSelectedNamespaceSectionTitle">
    Immutable Properties (<span data-bind="text: propertyModelViews.length"></span>):
</div>
<div class="classONMjsSelectedNamespaceSectionCommon">
    <span data-bind="if: propertyModelViews.length">
        <div class="classONMjsSelectedNamespacePropertiesCommon classONMjsSelectedNamespacePropertiesImmutable">
            <span data-bind="foreach: propertyModelViews">
                <div class="name"><span class="immutable" data-bind="text: declaration.property"></span></div>
                <div class="type" data-bind="text: declaration.members.____type"></div>
                <div class="value"><span class="immutable" data-bind="text: store.value"></span></div>
                <div style="clear: both;" />
            </span>
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
class ONMjs.observers.SelectedNamespaceMutablePropertiesModelView
    constructor: (params_) ->
        try
            @propertyModelViews = []
            @namespace = params_.selectedNamespace

            namespaceModelProperties = params_.selectedAddress.getPropertiesModel()
            if not (namespaceModelProperties? and namespaceModelProperties)
                throw "Cannot resolve namespace properties declaration for selection."

            namespaceDeclarationMutable = namespaceModelProperties.userMutable? and namespaceModelProperties.userMutable or undefined
            if not (namespaceDeclarationMutable? and namespaceDeclarationMutable)
                return

            @dataReference = params_.selectedNamespace.data()

            @onClickUpdateProperties = (prefix_, label_, addres_, selectorStore_, options_) =>
                try
                    propertiesUpdated = false
                    for propertyModelView in @propertyModelViews
                       valueEdit = propertyModelView.store.valueEdit()
                       if propertyModelView.store.value != valueEdit
                           @dataReference[propertyModelView.declaration.property] = valueEdit
                           propertiesUpdated = true
                    if propertiesUpdated
                        @namespace.update()
                catch exception
                    throw "ONMjs.observer.SelectedNamespaceMutablePropertiesModelView.onClickUpdateProperties failure: #{exception}"

            label = params_.selectedNamespaceModel.____label? and params_.selectedNamespaceModel.____label or "<no label defined>"

            @updateLinkModelView = new ONMjs.observers.helpers.CallbackLinkModelView(
                "", "Apply #{label} Edit", undefined, undefined, { styleClass: "classONMjsActionButtonConfirm" }, @onClickUpdateProperties)

            @onClickDiscardPropertyEdits = (prefix_, label_, address_, selectorStore_, options_) =>
                try
                    for propertyModelView in @propertyModelViews
                        propertyModelView.store.valueEdit(propertyModelView.store.value)
                catch exception
                    throw "ONMjs.observer.SelectedNamespaceMutablePropertiesModelView.onClickDiscardPropertyEdits failure: #{exception}"

            @discardLinkModelView = new ONMjs.observers.helpers.CallbackLinkModelView(
                "", "Discard #{label} Edits", undefined, undefined, { styleClass: "classONMjsActionButtonCancel" }, @onClickDiscardPropertyEdits)
               

            # Enumerate the object model's declaration of this namespace's mutable properties.
            for name, members of namespaceDeclarationMutable
                    
                propertyDescriptor =
                    immutable: false
                    declaration:
                        property: name
                        members: members
                    store:
                        value: @dataReference[name]
                        valueEdit: ko.observable(@dataReference[name])

                @propertyModelViews.push propertyDescriptor


            @propertiesUpdated = ko.computed =>
                propertiesUpdated = false
                for propertyModelView in @propertyModelViews
                   valueEdit = propertyModelView.store.valueEdit()
                   if propertyModelView.store.value != valueEdit
                       propertiesUpdated = true
                return propertiesUpdated


        catch exception
            throw "ONMjs.observers.SelectedNamespaceMutablePropertiesModelView failure: #{exception}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SelectedNamespaceMutablePropertiesViewModel", ( -> """
<div class="classONMjsSelectedNamespaceSectionTitle">
    Mutable Properties (<span data-bind="text: propertyModelViews.length"></span>):
</div>
<div class="classONMjsSelectedNamespaceSectionCommon">
    <span data-bind="if: propertyModelViews.length">
        <div class="classONMjsSelectedNamespacePropertiesCommon classONMjsSelectedNamespacePropertiesMutable">
            <span data-bind="foreach: propertyModelViews">
                <div class="name" data-bind="text: declaration.property"></div>
                <div class="type" data-bind="text: declaration.members.____type"></div>
                <div style="clear: both;" />
                <div type="text" class="value" contentEditable="true" data-bind="editableText: store.valueEdit"></div>
            </span>
            <span data-bind="if: propertiesUpdated">
                <div class="buttons">
                    <span data-bind="with: discardLinkModelView"><span data-bind="template: { name: 'idKoTemplate_CallbackLinkViewModel' }"></span></span>
                    <span data-bind="with: updateLinkModelView"><span data-bind="template: { name: 'idKoTemplate_CallbackLinkViewModel' }"></span></span>
                </div>
            </span>
        </div>
    </span>
    <span data-bind="ifnot: propertyModelViews.length">
        <i>This namespace has no mutable properties.</i>
    </span>
</div>
"""))

