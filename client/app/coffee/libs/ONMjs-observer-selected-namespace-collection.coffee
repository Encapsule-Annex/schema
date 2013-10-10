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
class ONMjs.observers.SelectedNamespaceCollectionModelView
    constructor: (params_) ->
        try
            @subcomponentModelViews = []
          
            label = params_.selectedNamespaceModel.____label
            @namespaceLabel = label? and label or "<no label provided>"

            semanticBindings = params_.cachedAddressStore.referenceStore.model.getSemanticBindings()
            index = 0

            params_.selectedNamespace.visitExtensionPointSubcomponents( (address__) =>
                subcomponentNamespace = params_.cachedAddressStore.referenceStore.openNamespace(address__)
                prefix = "#{index++ + 1}: "
                label = "#{subcomponentNamespace.getResolvedLabel()}<br>"
                @subcomponentModelViews.push new ONMjs.observers.helpers.AddressSelectionLinkModelView(prefix, label, address__, params_.cachedAddressStore)
                )
                
        catch exception
            throw "ONMjs.observers.SelectedNamespaceCollectionModelView failure: #{exception}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SelectedNamespaceCollectionViewModel", ( -> """
<div class="classONMjsSelectedNamespaceSectionTitle">
<span class="class="classONMjsAddressSelectionLinkLabelNoLink" data-bind="html: namespaceLabel"></span>
Subcomponents (<span data-bind="text: subcomponentModelViews.length"></span>):
</div>
<div class="classONMjsSelectedNamespaceSectionCommon classONMjsSelectedNamespaceCollection">
<span data-bind="ifnot: subcomponentModelViews.length">
<i><span class="classONMjsAddressSelectionLinkLabelNoLink" data-bind="html: namespaceLabel"></span> extension point is empty.</i>
</span>
<span data-bind="if: subcomponentModelViews.length">
<span class="link" data-bind="template: { name: 'idKoTemplate_AddressSelectionLinkViewModel', foreach: subcomponentModelViews }"></span>
</span>
</div>
"""))

