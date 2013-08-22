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
# encapsule-lib-omm-observer-selected-path.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.modelview = Encapsule.code.lib.modelview? and Encapsule.code.lib.modelview or @Encapsule.code.lib.modelview = {}
Encapsule.code.lib.modelview.detail = Encapsule.code.lib.modelview.detail? and Encapsule.code.lib.modelview.detail or @Encapsule.code.lib.modelview.detail = {}

class Encapsule.code.lib.modelview.ObjectModelNavigatorPathElementWindow
    constructor: (objectStore_, obsererId_, pathElementSelector_, selectorTreeHeight_) ->
        try
            @objectStore = objectStore_
            @pathElementSelector = pathElementSelector_.clone()
            @pathElementNamespace = objectStore_.associatedObjectStore.openNamespace(@pathElementSelector)

            height = pathElementSelector_.objectModelDescriptor.parentPathIdVector.length
            @isSelected = height + 1 == selectorTreeHeight_

            @prefix = ""
            switch height
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

            resolvedLabel = @pathElementNamespace.getResolvedLabel()
            @label = ""
            if @isSelected
                @label += """<span class="selected">#{resolvedLabel}</span>"""
            else
                styleClasses = "parent classObjectModelNavigatorMouseOverCursorPointer"
                if pathElementSelector_.objectModelDescriptor.isComponent
                    styleClasses += " component"
                @label += """<span class="#{styleClasses}">#{resolvedLabel}</span>"""

            @onClick = => 
                if not @isSelected
                    @objectStore.setSelector(@pathElementSelector)

        catch exception
            throw "Encapsule.code.lib.modelview.ObjectModelNavigatorPathElementWindow failure: #{exception}"


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorPathElementWindow", ( -> """
<span class="classObjectModelNavigatorSelectorPathElement"><span data-bind="html: prefix"></span><span data-bind="html: label, click: onClick"></span></span>
"""))



class Encapsule.code.lib.modelview.ObjectModelNavigatorSelectorWindow
    constructor: ->
        try
            @pathElements = ko.observableArray []

            @selectorStoreCallbacks =
            {
                onComponentCreated: (objectStore_, observerId_, namespaceSelector_) =>
                    @selectorStoreCallbacks.onComponentUpdated(objectStore_, observerId_, namespaceSelector_)

                onComponentUpdated: (objectStore_, observerId_, namespaceSelector_) =>

                    storeNamespace = objectStore_.openNamespace(namespaceSelector_)
                    selectorTreeHeight = storeNamespace.objectStoreNamespace.parentSelectorVector.length
                    
                    pathElementSelectorArray = storeNamespace.objectStoreNamespace.parentSelectorVector
                    @pathElements.removeAll()
                    for pathElementSelector in pathElementSelectorArray
                        @pathElements.push new Encapsule.code.lib.modelview.ObjectModelNavigatorPathElementWindow(objectStore_, observerId_, pathElementSelector, selectorTreeHeight)
            }

        catch exception
            throw "Encapsule.code.lib.modelview.ObjectModelNavigatorSelectorWindow failure: #{exception}"

Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorSelectorWindow", ( -> """
<div class="classObjectModelNavigatorSelectorWindow">
<span class="classObjectModelNavigatorPathElementPrefix"></span><span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorPathElementWindow', foreach: pathElements }">
</div>
"""))
