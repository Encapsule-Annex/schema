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
class ONMjs.observers.ObjectModelNavigatorNamespaceCollection
    constructor: (namespace_, selectorStore_) ->
        try
            @namespaceLabel = namespace_.objectModelDescriptor.label

            semanticBindings = namespace_.objectStore.objectModel.getSemanticBindings()
            elementPathId = namespace_.objectModelDescriptor.archetypePathId
            @elementSelector = namespace_.objectStore.objectModel.createNamespaceSelectorFromPathId(elementPathId, namespace_.resolvedKeyVector)
            elementJsonTag = @elementSelector.objectModelDescriptor.jsonTag

            @subcomponentModelViews = []

            @addElementCallbackLink = new ONMjs.observers.ObjectModelNavigatorNamespaceCallbackLink(
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
                @subcomponentModelViews.push new ONMjs.observers.ObjectModelNavigatorNamespaceContextElement(
                    prefix, label, elementSelector, selectorStore_)
                
        catch exception
            throw "ONMjs.observers.ObjectModelNavigatorNamespaceCollection failure: #{exception}"

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

