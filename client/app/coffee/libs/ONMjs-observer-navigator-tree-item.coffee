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
ONMjs.observers = ONMjs.observers? and ONMjs.observers or ONMjs.observer = {}
ONMjs.observers.implementation = ONMjs.observers.implementation? and ONMjs.observers.implementation or ONMjs.observers.implementation = {}


class ONMjs.observers.implementation.NavigatorItemModelView

    constructor: (store_, navigatorModelView_, address_) ->

        # \ BEGIN: constructor scope
        try
            # \ BEGIN: constructor try scope
            if not (store_? and store_)
                throw "Missing object store input parameter."
            if not (navigatorModelView_? and navigatorModelView_)
                throw "Missing parent object model navigator window input parameter."
            if not (address_? and address_)
                throw "Missing address input parameter."

            # Cache references to this instance's construction parameters.
            @store = store_
            @navigatorModelView = navigatorModelView_
            @address = address_
            @children = ko.observableArray []
            @isSelected = ko.observable false
            @selectionsByObserverId = {}
            @blipper = Encapsule.runtime.boot.phase0.blipper

            namespace = store_.openNamespace(address_)
            @label = ko.observable(namespace.getResolvedLabel())

            #
            # ----------------------------------------------------------------------------
            @onClick = =>
                try
                    @navigatorModelView.routeUserSelectAddressRequest(@address)
                catch exception
                    Console.messageError("ONMjs.observers.implementation.PathElementModelView.onClick failure: #{exception}")


            #
            # ----------------------------------------------------------------------------
            @addSelection = (observerId_) =>
                try
                    if not (observerId_? and observerId_) then throw "Missing observer ID input parameter."
                    @selectionsByObserverId[observerId_] = true
                    @isSelected(true)
                catch exception
                    throw "ONMjs.observers.implementation.PathElementModelView.addSelection failure: #{exception}"


            #
            # ----------------------------------------------------------------------------
            @removeSelection = (observerId_) =>
                try
                    if not (observerId_? and observerId_) then throw "Missing observer ID input parameter."
                    delete @selectionsByObserverId[observerId_]
                    @isSelected( Encapsule.code.lib.js.dictionaryLength(@selectionsByObserverId) and true or false )
                catch exception
                    throw "ONMjs.observers.implementation.PathElementModelView.removeSelection failure: #{exception}"



            # / END: constructor try scope
        catch exception
            throw "ONMjs.observers.implementation.PathElementModelView construction failure: : #{exception}"
        # / END: constructor




Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorMenuWindow", ( -> """
<span data-bind="if: isSelected()">
    <div class="classObjectModelNavigatorMenuWindow classMenuSelectedOuter">
        <div class="classMenuSelected" data-bind="text: label" ></div>
        <span data-bind="if: children().length">
            <div class="classObjectModelNavigatorMenuWindowInner">
                <div data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorMenuWindow', foreach: children }"></div>
            </div>
        </span>
    </div>
</span>
<span data-bind="ifnot: isSelected()">
    <div class="classObjectModelNavigatorMenuWindow classObjectModelNavigatorMouseOverCursorPointer" data-bind="click: onClick, clickBubble: false" >
        <div class="classMenuUnselected" data-bind="text: label"></div>
        <span data-bind="if: children().length">
            <div class="classObjectModelNavigatorMenuWindowInner">
                <div data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorMenuWindow', foreach: children }"></div>
            </div>
        </span>
    </div>
</span>
"""))

