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
class ONMjs.observers.SelectedNamespaceImmutablePropertiesModelView
    constructor: (params_) ->
        try
            @propertyModelViews = []

            # TODO: change namespaceDescriptor to namespaceDeclaration in descriptor
            namespaceDeclaration = params_.selectedNamespaceDescriptor.namespaceDescriptor
            if not (namespaceDeclaration? and namespaceDeclaration)
                throw "Cannot resolve namespace declaration for selection."

            namespaceDeclarationImmutable = namespaceDeclaration.userImmutable? and namespaceDeclaration.userImmutable or undefined
            if not (namespaceDeclarationImmutable? and namespaceDeclarationImmutable)
                return

            dataReference = params_.selectedNamespace.data()

            # Enumerate the object model's declaration of this namespace's immutable properties.
            for name, value of namespaceDeclarationImmutable
                propertyDescriptor =
                    immutable: true
                    declaration:
                        property: name
                        members: value
                    store:
                        value: dataReference[name]
                @propertyModelViews.push propertyDescriptor

        catch exception
            throw "ONMjs.observers.SelectedNamespaceImmutablePropertiesModelView failure: #{exception}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SelectedNamespaceImmutablePropertiesViewModel", ( -> """
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
class ONMjs.observers.SelectedNamespaceMutablePropertiesModelView
    constructor: (params_) ->
        try
            @propertyModelViews = []

            # TODO: change namespaceDescriptor to namespaceDeclaration in descriptor
            namespaceDeclaration = params_.selectedNamespaceDescriptor.namespaceDescriptor
            if not (namespaceDeclaration? and namespaceDeclaration)
                throw "Cannot resolve namespace declaration for selection."

            namespaceDeclarationMutable = namespaceDeclaration.userMutable? and namespaceDeclaration.userMutable or undefined
            if not (namespaceDeclarationMutable? and namespaceDeclarationMutable)
                return

            dataReference = params_.selectedNamespace.data()

            # Enumerate the object model's declaration of this namespace's mutable properties.
            for name, value of namespaceDeclarationMutable
                propertyDescriptor =
                    immutable: false
                    declaration:
                        property: name
                        members: value
                    store:
                        value: dataReference[name]

                @propertyModelViews.push propertyDescriptor


        catch exception
            throw "ONMjs.observers.SelectedNamespaceMutablePropertiesModelView failure: #{exception}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SelectedNamespaceMutablePropertiesViewModel", ( -> """
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

