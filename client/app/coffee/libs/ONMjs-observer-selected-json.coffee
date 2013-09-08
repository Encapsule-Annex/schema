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


class ONMjs.observers.SelectedJsonModelView
    constructor: ->
        try
            @title = ko.observable "<not connected>"
            @selectorHash = ko.observable "<not connected>"
            @jsonString = ko.observable "<not connected>"

            @cachedAddressStore = undefined
            @cahcedAddressStoreObserverId = undefined

            @saveJSONAsLinkHtml = ko.computed =>
                # Inpsired by: http://stackoverflow.com/questions/3286423/is-it-possible-to-use-any-html5-fanciness-to-export-local-storage-to-excel/3293101#3293101
                html = """<a href=\"data:text/json;base64,#{window.btoa(@jsonString())}\" target=\"_blank\" title="Open raw JSON in new tab..."> 
                    <img src="./img/json_file-48x48.png" style="width: 24px; heigh: 24px; border: 0px solid black; vertical-align: middle;" ></a>"""


            @attachToCachedAddress = (cachedAddress_) =>
                try
                    if not (cachedAddress_? and cachedAddress_) then throw "Missing cached address store input parameter."
                    if @cachedAddressStore? and @cachedAddressStore then throw "Already attached to an ONMjs.CachedAddress object."
                    @cachedAddressStore = cachedAddress_
                    @storeObserverId = cachedAddress_.registerObserver(@cachedAddressCallbackInterface, @)
                    true
                catch exception
                    throw "ONMjs.observers.SelectedJsonModelView.attachToCachedAddress failure: #{exception}."

            @detachFromCachedAddress = () =>
                try
                    if not (@cachedAddressStoreObserverId? and @cachedAddressStoreObserverId) then throw "Not attached to an ONMjs.CachedAddress object."
                    @cachedAddressStore.unregisterObserver(@cachedAddressStoreObserverId)
                    @cachedAddressStore = undefined
                    @cachedAddressStoreObserverId = undefined
                    true
                catch exception
                    throw "ONMjs.observers.SelectedJsonModelView.detachFromCachedAddress failure: #{exception}."


            @cachedAddressCallbackInterface = {

                onComponentCreated: (store_, observerId_, address_) =>
                    try
                        @cachedAddressCallbackInterface.onComponentUpdated(store_, observerId_, address_)
                    catch exception
                        throw "ONMjs.observers.SelectedJsonModelView.cachedAddressCallbackInterface.onComponentCreated failure: #{exception}"

                onComponentUpdated: (store_, observerId_, address_) =>
                    try
                        storeAddress = store_.getAddress()
                        if not (storeAddress? and storeAddress)
                            @title("<no selected address>")
                            @selectorHash("Address: <no selected address>")
                            @jsonString("<undefined>")
                            return true
                        selectedNamespace = store_.referenceStore.openNamespace(storeAddress)
                        @title(selectedNamespace.getResolvedLabel())
                        @selectorHash(selectedNamespace.getResolvedAddress().getHashString())
                        @jsonString(selectedNamespace.toJSON(undefined, 2))
                        true
                    catch exception
                        throw "ONMjs.observers.SelectedJsonModelView.cachedAddressCallbackInterface.onComponentUpdated failure: #{exception}"

            }

        catch exception
            throw "ONMjs.observers.SelectedJsonModelView construction failure: #{exception}"


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorJsonModelView", ( -> """
<div class="classONMjsSelectedJson">
    <span data-bind="html: saveJSONAsLinkHtml"></span>
    <span class="titleString" data-bind="html: title"></span>
</div>
address hash:<br>
<span class="classONMjsSelectedJsonAddressHash" data-bind="html: selectorHash"></span>
<div class="classObjectModelNavigatorJsonBody">
    <pre class="classONMjsSelectedJsonBody" data-bind="html: jsonString"></pre>
</div>
"""))
