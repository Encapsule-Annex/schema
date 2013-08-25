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
