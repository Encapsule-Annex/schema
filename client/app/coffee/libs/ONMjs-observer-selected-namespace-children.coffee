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
class ONMjs.observers.ObjectModelNavigatorNamespaceChildren
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
                    @childModelViews.push new ONMjs.observers.ObjectModelNavigatorNamespaceContextElement(prefix, label, childSelector, selectorStore_)
                
        catch exception
            throw "ONMjs.observers.ObjectModelNavigatorNamespaceChildren failure: #{exception}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorNamespaceChildren", ( -> """
<span data-bind="if: childModelViews.length">
    <div class="classObjectModelNavigatorNamespaceSectionTitle">Child Namespaces (<span data-bind="text: childModelViews.length"></span>):</div>
    <div class="classObjectModelNavigatorNamespaceSectionCommon classObjectModelNavigatorNamespaceChildren">
        <span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorNamespaceContextElement', foreach: childModelViews }"></span>
    </div>
</span>
"""))

