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

Encapsule.app = Encapsule.app? and Encapsule.app or @Encapsule.app = {}
Encapsule.app.lib = Encapsule.app.lib? and Encapsule.app.lib or @Encapsule.app.lib = {}

class Encapsule.app.lib.DragonEggCompiler
    constructor: (backchannel_) ->
        try
            @backchannel = backchannel_? and backchannel_ or throw "Missing required backchannel input parameter."
            @title = "Dragon Egg Compiler"


            @saveJSONAsLinkHtml = ko.computed =>
                # Inpsired by: http://stackoverflow.com/questions/3286423/is-it-possible-to-use-any-html5-fanciness-to-export-local-storage-to-excel/3293101#3293101
                html = """<a href=\"data:text/json;base64,#{window.btoa(@title)}\" target=\"_blank\" title="Open raw JSON in new tab..."> 
                    <img src="./img/json_file-48x48.png" style="width: 24px; heigh: 24px; border: 0px solid black; vertical-align: middle;" ></a>"""

            @selectedDragonEggAddress = undefined

            @jsonTag = ko.observable "<no selection>"
            @label = ko.observable ""
            @description = ko.observable ""

            @dragonEggStoreAddressObserverInterface = {

                onComponentCreated: (store_, observerId_, address_) =>
                    try
                        @selectedDragonEggAddress = undefined
                        candidateAddress = store_.getAddress()

                        if candidateAddress.getModel().jsonTag == "dragonEgg"
                            @selectedDragonEggAddress = candidateAddress
                            return true

                        candidateAddress.visitParentAddressesDescending( (parentAddress_) =>
                            if parentAddress_.getModel().jsonTag == "dragonEgg"
                                @selectedDragonEggAddress = parentAddress_
                                return true
                            )

                        @jsonTag("<no selection>")
                        @label("")
                        @description("")
                        return false

                    catch exception
                        throw "Encapsule.app.lib.DragonEggCompiler.dragonEggStoreAddressObserverInterface.onComponentCreated failure: #{exception}"

                onComponentUpdated: (store_, observerId_, address_) =>
                    @dragonEggStoreAddressObserverInterface.onComponentCreated(store_, observerId_, address_)

            }

            @dragonEggStoreObserverInterface = {

                onComponentCreated: (store_, observerId_, address_) =>
                    try
                        if not (@selectedDragonEggAddress? and @selectedDragonEggAddress)
                            @backchannel.log("... no selected dragon egg address")
                            return true

                        if not @selectedDragonEggAddress.isEqual(address_)
                            @backchannel.log("... ignoring - not selected dragon egg")
                            return true

                        namespace = store_.openNamespace(address_)
                        data = namespace.data()

                        @jsonTag(data.jsonTag)
                        @label(data.____label)
                        @description(data.____description)

                        @backchannel.log("Dragon egg updated.")
                        return true

                    catch exception
                        throw "Encapsule.app.lib.DragonEggCompiler.dragonEggStoreObserverInterface.onComponentUpdated failure: #{exception}"

                onComponentUpdated: (store_, observerId_, address_) =>
                    @backchannel.log("... forwarding onComponentUpdated")
                    @dragonEggStoreObserverInterface.onComponentCreated(store_, observerId_, address_)

                onSubcomponentUpdated: (store_, observerId_, address_) =>
                    @backchannel.log("... forwarding onSubcomponentUpdated")
                    @dragonEggStoreObserverInterface.onComponentCreated(store_, observerId_, address_)
            }
                

        catch exception
            throw "Encapsule.app.lib.DragonEggCompiler failure: #{exception}"




Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_DragonEggCompilerView", ( -> """
<div class="classONMjsSelectedJson">
    <span data-bind="html: saveJSONAsLinkHtml"></span>
    <span class="titleString" data-bind="html: title"></span>
</div>

<div>
jsonTag: <span data-bind="text: jsonTag"></span><br>
label: <span data-bind="text: label"></span><br>
description: <span data-bind="text: description"></span><br>
</div>
<!--
<span class="classONMjsSelectedJsonAddressHash" data-bind="html: selectorHash"></span>
<div class="classObjectModelNavigatorJsonBody">
    <pre class="classONMjsSelectedJsonBody" data-bind="html: jsonString"></pre>
</div>
-->
"""))
