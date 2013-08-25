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

Encapsule.code.lib.modelview = Encapsule.code.lib.modelview? and Encapsule.code.lib.modelview or @Encapsule.code.lib.modelview = {}
Encapsule.code.lib.modelview.detail = Encapsule.code.lib.modelview.detail? and Encapsule.code.lib.modelview.detail or @Encapsule.code.lib.modelview.detail = {}


class Encapsule.code.lib.modelview.ObjectModelNavigatorJsonModelView
    constructor: ->
        try
            @title = ko.observable "<not connected>"
            @selectorHash = ko.observable "<not connected>"
            @jsonString = ko.observable "<not connected>"

            @saveJSONAsLinkHtml = ko.computed =>
                # Inpsired by: http://stackoverflow.com/questions/3286423/is-it-possible-to-use-any-html5-fanciness-to-export-local-storage-to-excel/3293101#3293101
                html = """<a href=\"data:text/json;base64,#{window.btoa(@jsonString())}\" target=\"_blank\" title="Open raw JSON in new tab..."> 
                    <img src="./img/json_file-48x48.png" style="width: 24px; heigh: 24px; border: 0px solid black; vertical-align: middle;" ></a>"""


            @selectorStoreCallbacks = {
                onComponentCreated: (objectStore_, observerId_, namespaceSelector_) =>
                    @selectorStoreCallbacks.onComponentUpdated(objectStore_, observerId_, namespaceSelector_)

                onComponentUpdated: (objectStore_, observerId_, namespaceSelector_) =>
                    selector = objectStore_.getSelector()
                    namespace = objectStore_.associatedObjectStore.openNamespace(selector)
                    @title(namespace.getResolvedLabel())
                    @selectorHash("Selector: <strong>#{selector.getHashString()}</strong>")
                    @jsonString(namespace.toJSON(undefined, 2))

            }

        catch exception
            throw "Encapsule.code.lib.modelview.ObjectModelNavigatorJsonModelView failure: #{exception}"


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorJsonModelView", ( -> """
<div class="classObjectModelNavigatorJsonTitle">
    <span data-bind="html: saveJSONAsLinkHtml"></span>
    <span class="titleString" data-bind="html: title"></span>
</div>
<div class="classObjectModelNavigatorJsonSelectorHash" data-bind="html: selectorHash"></div>
<div class="classObjectModelNavigatorJsonBody">
    <pre class="classObjectModelNavigatorJsonPreformat" data-bind="html: jsonString"></pre>
</div>
"""))
