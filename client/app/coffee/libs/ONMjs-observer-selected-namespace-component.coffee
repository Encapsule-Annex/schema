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
class ONMjs.observers.SelectedNamespaceComponentModelView
    constructor: (params_) ->
        try

            componentAddress = ONMjs.address.ComponentAddress(params_.selectedAddress)
            componentDescriptor = componentAddress.getDescriptor()
            componentNamespace = params_.cachedAddressStore.referenceStore.openNamespace(componentAddress)

            ###
            @componentModelView = new ONMjs.observers.helers.AddressSelectionLinkModelView(
                "", componentNamespace.getResolvedLabel(), componentAddress, params_.cachedAddressStore, { noLink: true } )
            ###

            @extensionPointModelViewArray = []

            index = 0
            for extensionPointPath, extensionPointDescriptor of componentDescriptor.extensionPoints
                extensionPointAddress = ONMjs.address.NewAddressSameComponent(componentAddress, extensionPointDescriptor.id)
                extensionPointNamespace = params_.cachedAddressStore.referenceStore.openNamespace(extensionPointAddress)
                noLinkFlag = extensionPointAddress.isEqual(params_.selectedAddress)
                prefix = undefined
                if index++ then prefix = " &bull; "
                label = "#{extensionPointNamespace.getResolvedLabel()}"
                subcomponentCount = Encapsule.code.lib.js.dictionaryLength(extensionPointNamespace.data())
                label += " (#{subcomponentCount})"

                @extensionPointModelViewArray.push new ONMjs.observers.helpers.AddressSelectionLinkModelView(
                    prefix, label, extensionPointAddress, params_.cachedAddressStore, { noLink: noLinkFlag })

        catch exception
            throw "ONMjs.observers.SelectedNamespaceComponentModelView failure: #{exception}"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SelectedNamespaceComponentViewModel", ( -> """

<span data-bind="if: extensionPointModelViewArray.length">
    <div class="classONMjsSelectedNamespaceSectionTitle">
        Extension Points (<span data-bind="text: extensionPointModelViewArray.length"></span>):
    </div>
    <span data-bind="ifnot: extensionPointModelViewArray.length"><i>Extension point contains no subcomponents.</i></span>
    <span data-bind="if: extensionPointModelViewArray.length">
    <div class="classONMjsSelectedNamespaceSectionCommon classObjectModelNavigatorNamespaceComponent">
        <span data-bind="template: { name: 'idKoTemplate_AddressSelectionLinkViewModel', foreach: extensionPointModelViewArray }"></span>
    </div>
    </span>
</span>
"""))

