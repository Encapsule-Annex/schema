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
# encapsule-lib-omm-nav-selector-model-view.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.modelview = Encapsule.code.lib.modelview? and Encapsule.code.lib.modelview or @Encapsule.code.lib.modelview = {}
Encapsule.code.lib.modelview.detail = Encapsule.code.lib.modelview.detail? and Encapsule.code.lib.modelview.detail or @Encapsule.code.lib.modelview.detail = {}

class Encapsule.code.lib.modelview.ObjectModelNavigatorPathElementWindow
    constructor: (objectStore_, obsererId_, pathElementSelector_) ->
        try
            @objectStore = objectStore_
            @pathElementSelector = pathElementSelector_
            depth = pathElementSelector_.objectModelDescriptor.parentPathIdVector.length

            @labelPrefix = ko.observable ""
            @labelPrefix(
                ((depth == 0) and "" or "") +
                ((depth == 1) and " // " or "") +
                ((depth > 1) and " / " or ""))               

            @label = ko.observable "#{pathElementSelector_.objectModelDescriptor.label}"

            @onClick = => @objectStore.setSelector(@pathElementSelector)

        catch exception
            throw "Encapsule.code.lib.modelview.ObjectModelNavigatorPathElementWindow failure: #{exception}"


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorPathElementWindow", ( -> """<span class="classObjectModelNavigatorPathElementPrefix" data-bind="html: labelPrefix"></span><span class="classObjectModelNavigatorPathElementWindow" data-bind="event: { click: onClick }, html: label"></span>"""))



class Encapsule.code.lib.modelview.ObjectModelNavigatorSelectorWindow
    constructor: ->
        try
            @pathElements = ko.observableArray []

            @selectorStoreCallbacks =
            {
                onComponentCreated: (objectStore_, observerId_, namespaceSelector_) =>
                    @selectorStoreCallbacks.onComponentUpdated(objectStore_, observerId_, namespaceSelector_)

                onComponentUpdated: (objectStore_, observerId_, namespaceSelector_) =>
                    @pathElements.removeAll()
                    storeNamespace = objectStore_.openNamespace(namespaceSelector_)
                    pathElementSelectorArray = storeNamespace.objectStoreNamespace.pathElements
                    for pathElementSelector in pathElementSelectorArray
                        @pathElements.push new Encapsule.code.lib.modelview.ObjectModelNavigatorPathElementWindow(objectStore_, observerId_, pathElementSelector)
            }

        catch exception
            throw "Encapsule.code.lib.modelview.ObjectModelNavigatorSelectorWindow failure: #{exception}"

Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorSelectorWindow", ( -> """
<div class="classObjectModelNavigatorSelectorWindow">
<span class="classObjectModelNavigatorPathElementPrefix">&gt;&nbsp;</span><span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorPathElementWindow', foreach: pathElements }">
</div>
"""))
