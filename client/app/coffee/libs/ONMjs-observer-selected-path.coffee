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
ONMjs.observers.implementation = ONMjs.observers.implementation? and ONMjs.observers.implementation or ONMjs.observers.implementation = {}


class ONMjs.observers.implementation.SelectedPathElementModelView
    constructor: (addressCache_, count_, selectedCount_, objectStoreAddress_) ->
        try
            @cachedAddressStore = addressCache_
            @objectStoreAddress = objectStoreAddress_
            @isSelected = (count_ == selectedCount_)
            objectStoreNamespace = addressCache_.referenceStore.openNamespace(objectStoreAddress_)
            objectStoreDescriptor = objectStoreNamespace.getResolvedToken().namespaceDescriptor
            resolvedLabel = objectStoreNamespace.getResolvedLabel()

            @prefix = ""
            switch count_
                when 0
                    break
                when 1
                    @prefix += """ :: """
                    break
                else
                    @prefix += """ / """
                    break

            if @prefix.length
                @prefix = """<span class="prefix">""" + @prefix + """</span>"""

            @label = ""
            if @isSelected
                @label += """<span class="selected">#{resolvedLabel}</span>"""
            else
                styleClasses = "parent classONMjsMouseOverPointer"
                if objectStoreDescriptor.isComponent
                    styleClasses += " component"
                @label += """<span class="#{styleClasses}">#{resolvedLabel}</span>"""

            @onClick = => 
                try
                    if not @isSelected
                        @cachedAddressStore.setAddress(@objectStoreAddress)
                catch exception
                    Console.messageError("ONMjs.observers.implementation.SelectedPathElementModelView.onClick failure: #{exception}")

        catch exception
            throw "ONMjs.observers.SelectedPathElementModelView failure: #{exception}"


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SelectedPathElementViewModel", ( -> """
<span class="classONMjsSelectedPathElement"><span data-bind="html: prefix"></span><span data-bind="html: label, click: onClick"></span></span>
"""))




class ONMjs.observers.SelectedPathModelView
    constructor: ->
        # \ BEGIN: constructor
        try
            # \ BEGIN: try

            @pathElements = ko.observableArray []
            @cachedAddressStore = undefined
            @cachedAddressStoreObserverId = undefined

            @addressHumanString = ko.observable("not connected")
            @addressHashString = ko.observable("not connected")

            @attachToCachedAddress = (cachedAddress_) =>
                try
                    if not (cachedAddress_? and cachedAddress_) then throw "Missing cached address input parameter."
                    if @cachedAddressStore? and @cachedAddressStore then throw "Already attached to an ONMjs.CachedAddress object."
                    @cachedAddressStore = cachedAddress_
                    @cachedAddressStoreObserverId = cachedAddress_.registerObserver(@cachedAddressObserverInterface, @)
                    true
                catch exception
                    throw "ONMjs.observers.SelectedPathModelView.attachToCachedAddress failure: #{exception}"

            @detachFromCachedAddress = =>
                try
                    if not (@cachedAddressStoreObserverId? and @cachedAddressStoreObserverId) then throw "Not attached to an ONMjs.CachedAddress object."
                    @cachedAddressStore.unregisterObserver(@cachedAddressStoreObserverId)
                    true
                catch exception
                    throw "ONMjs.observers.SelectedPathModelView.detachFromCachedAddress failure: #{exception}"


            @cachedAddressObserverInterface =
            {
                onAttachEnd: (store_, observerId_) =>
                    Console.message("ONMjs.observers.SelectedPathModelView has attached to and is observing in ONMjs.CachedAddress instance.")

                onDetachEnd: (store_, observerId_) =>
                    @pathElements.removeAll()
                    @addressHashString("not connected")
                    @addressHumanString("not connected")
                    @cachedAddress = undefined
                    @cachedAddressStoreObserverId = undefined
                    Console.message("ONMjs.observers.SelectedPathModelView has detached from and is no longer observing an ONMjs.CachedAddress instance.")

                onComponentCreated: (store_, observerId_, address_) =>
                    try
                        @cachedAddressObserverInterface.onComponentUpdated(store_, observerId_, address_)
                    catch exception
                        "ONMjs.observers.SelectedPathModelView.cachedAddressObserverInterface.onComponentCreated failure: #{exception}"

                onComponentUpdated: (store_, observerId_, address_) =>
                    try
                        selectedAddress = store_.getAddress()
                        if not (selectedAddress? and selectedAddress) then return true
                        @addressHumanString(selectedAddress.getHumanReadableString())
                        @addressHashString(selectedAddress.getHashString())
                        addresses = []
                        selectedAddress.visitParentAddressesAscending( (address__) => 
                            addresses.push address__ )
                        addresses.push selectedAddress
                        count = 0
                        selectedCount = addresses.length - 1
                        @pathElements.removeAll()

                        for address in addresses
                            pathElementObject = new ONMjs.observers.implementation.SelectedPathElementModelView(store_, count++, selectedCount, address)
                            @pathElements.push pathElementObject

                        true

                    catch exception
                        throw "OMNjs.observers.SelectedPathModelView.cachedAddressObserverInterface.onComponentUpdated failure: #{exception}"

            }
            # / END: try

        catch exception
            throw "ONMjs.observers.SelectedPathModelView construction failure: #{exception}"

        # / END: connstructor

Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SelectedPathViewModel", ( -> """
<div class="classONMjsSelectedPath"><span data-bind="template: { name: 'idKoTemplate_SelectedPathElementViewModel', foreach: pathElements }"></span></div>
<div style="margin-top: 8px; font-family: Courier;"><span data-bind="text: addressHumanString"></span></div>
<div style="font-family: Courier;"><span data-bind="text: addressHashString"></span></div>
"""))

