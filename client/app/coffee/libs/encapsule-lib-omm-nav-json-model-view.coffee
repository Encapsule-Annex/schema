###

  http://schema.encapsule.org/

  A single-page HTML5 application for creating, visualizing, and editing
  JSON-encoded Soft Circuit Description Language (SCDL) models.

  Copyright 2013 Encapsule Project, Copyright 2013 Chris Russell

  Distributed under the terms of the Boost Software License Version 1.0
  See included license.txt or http://www.boost.org/LICENSE_1_0.txt

  Sources on GitHub: https://github.com/Encapsule-Project/schema

  Visit http://www.encapsule.org for more information and happy hacking.

###
#
# encapsule-lib-omm-nav-json-model-view.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.modelview = Encapsule.code.lib.modelview? and Encapsule.code.lib.modelview or @Encapsule.code.lib.modelview = {}
Encapsule.code.lib.modelview.detail = Encapsule.code.lib.modelview.detail? and Encapsule.code.lib.modelview.detail or @Encapsule.code.lib.modelview.detail = {}


class Encapsule.code.lib.modelview.ObjectModelNavigatorJsonModelView
    constructor: ->
        try
            @title = ko.observable "<not connected>"
            @jsonString = ko.observable "<not connected>"

            @selectorStoreCallbacks = {
                onComponentCreated: (objectStore_, observerId_, namespaceSelector_) =>
                    @selectorStoreCallbacks.onComponentUpdated(objectStore_, observerId_, namespaceSelector_)

                onComponentUpdated: (objectStore_, observerId_, namespaceSelector_) =>
                    selector = objectStore_.getSelector()
                    namespace = objectStore_.associatedObjectStore.openNamespace(selector)
                    @jsonString(namespace.toJSON(undefined, 2))
                    @title("#{namespace.getResolvedLabel()} JSON")

            }

        catch exception
            throw "Encapsule.code.lib.modelview.ObjectModelNavigatorJsonModelView failure: #{exception}"


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorJsonModelView", ( -> """
<div class="classObjectModelNavigatorJsonTitle" data-bind="text: title"></div>
<div class="classObjectModelNavigatorJsonBody">
    <pre class="classObjectModelNavigatorJsonPreformat" data-bind="text: jsonString"></pre>
</div>
"""))
