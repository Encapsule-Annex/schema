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


class ONMjs.observers.NavigatorItemModelView

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

              @blipper = Encapsule.runtime.boot.phase0.blipper

              namespace = store_.openNamespace(address_)
              @label = ko.observable(namespace.getResolvedLabel())

              @onClick = =>
                  try
                      @objectModelNavigatorWindow.selectorStore.setSelector(@namespaceSelector)
                  catch exception
                      Console.messageError("Encapsule.code.lib.modelview.ObjectModelNavigatorMenuWindowChrome.onClick failure: #{exception}")

            # / END: constructor try scope
        catch exception
            throw "Encapsule.code.lib.modelview.NavigatorWindowMenuLevel failure: : #{exception}"
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

