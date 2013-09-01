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
class ONMjs.observers.ObjectModelNavigatorNamespaceComponent
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

            @componentModelView = new ONMjs.observers.ObjectModelNavigatorNamespaceContextElement(
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
                @extensionPointModelViewArray.push new ONMjs.observers.ObjectModelNavigatorNamespaceContextElement(
                    prefix, label, extensionPointSelector, selectorStore_, { noLink: noLinkFlag })

        catch exception
            throw "ONMjs.observers.ObjectModelNavigatorNamespaceComponent failure: #{exception}"

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

