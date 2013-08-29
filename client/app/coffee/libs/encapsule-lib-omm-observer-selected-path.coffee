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
ONMjs.observers.implementation = ONMjs.observers.implementation? and ONMjs.observers.implementation or ONMjs.observers.implementation = {}

class ONMjs.observers.implementation.PathElementModelView
    constructor: (addressCache_, count_, objectStoreAddress_) ->
        try
            @addressCacheStore = addressCache_
            @objectStoreAddress = objectStoreAddress_
            objectStoreNamespace = addressCache_.referenceStore.openNamespace(objectStoreAddress_)
            objectStoreDescriptor = objectStoreNamespace.getLastBinder().resolvedToken.namespaceDescriptor
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
                styleClasses = "parent classObjectModelNavigatorMouseOverCursorPointer"
                if objectStoreDescriptor.isComponent
                    styleClasses += " component"
                @label += """<span class="#{styleClasses}">#{resolvedLabel}</span>"""

            @onClick = => 
                if not @isSelected
                    @objectStore.setSelector(@pathElementSelector)

        catch exception
            throw "ONMjs.observers.PathElementModelView failure: #{exception}"


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorPathElementWindow", ( -> """
<span class="classObjectModelNavigatorSelectorPathElement"><span data-bind="html: prefix"></span><span data-bind="html: label, click: onClick"></span></span>
"""))



class ONMjs.observers.SelectedPathModelView
    constructor: ->
        try

            @myTest = "what the fuck is going on here?"

            @pathElements = ko.observableArray []
            @cachedAddressStore = undefined
            @cachedAddressStoreObserverId = undefined

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
                    @cachedAddressStore = undefined
                    @cachedAddressStoreObserverId = undefined
                    true
                catch exception
                    throw "ONMjs.observers.SelectedPathModelView.detachFromCachedAddress failure: #{exception}"


            @cachedAddressObserverInterface =
            {
                onComponentCreated: (store_, observerId_, address_) =>
                    try
                        @cachedAddressObserverInterface.onComponentUpdated(store_, observerId_, address_)
                    catch exception
                        "ONMjs.observers.SelectedPathModelView.cachedAddressObserverInterface.onComponentCreated failure: #{exception}"

                onComponentUpdated: (store_, observerId_, address_) =>
                    try
                        selectedAddress = store_.getAddress()
                        @pathElements.removeAll()
                        if not (selectedAddress? and selectedAddress) then return true
                        count = 0 
                        selectedAddress.visitParentNamespacesAscending( (address__) =>
                            @pathElements.push new ONMjs.observers.implementation.PathElementModelView(store_, count++, address__)
                            )
                        @pathElements.push new ONMjs.observers.implementation.PathElementModelView(store_, count++, selectedAddress)
                        true

                    catch exception
                        throw "OMNjs.observers.SelectedPathModelView.cachedAddressObserverInterface.onComponentUpdated failure: #{exception}"


            }

        catch exception
            throw "ONMjs.observers.SelectedPathModelView construction failure: #{exception}"

Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorSelectorWindow", ( -> """
<div class="classObjectModelNavigatorSelectorWindow">
<span data-bind="text: myTest"></span>
</div>
"""))

# <span class="classObjectModelNavigatorPathElementPrefix"></span><span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorPathElementWindow', foreach: pathElements }">
