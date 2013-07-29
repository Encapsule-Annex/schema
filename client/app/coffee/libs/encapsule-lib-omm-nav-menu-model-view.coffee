###

  http://schema.encapsule.org/schema.html

  A single-page HTML5 application for creating, visualizing, and editing
  JSON-encoded Soft Circuit Description Language (SCDL) models.

  Copyright 2013 Encapsule Project, Copyright 2013 Chris Russell

  Distributed under the terms of the Boost Software License Version 1.0
  See included license.txt or http://www.boost.org/LICENSE_1_0.txt

  Sources on GitHub: https://github.com/Encapsule-Project/schema

  Visit http://www.encapsule.org for more information and happy hacking.

###
#
# encapsule-lib-navigator-window.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.modelview = Encapsule.code.lib.modelview? and Encapsule.code.lib.modelview or Encapsule.code.lib.modelview = {}


class Encapsule.code.lib.modelview.ObjectModelNavigatorMenuWindowChrome
      constructor: (objectStore_, objectModelNavigatorWindow_, namespaceSelector_) ->
          # Cache references to this instance's construction parameters.

          @objectModelNavigatorWindow = objectModelNavigatorWindow_
          @namespaceSelector = namespaceSelector_.clone()

          @children = ko.observableArray []
          @isSelected = ko.observable false
          @blipper = Encapsule.runtime.boot.phase0.blipper

          @onClick = =>
              @objectModelNavigatorWindow.selectorStore.setSelector(@namespaceSelector)


class Encapsule.code.lib.modelview.ObjectModelNavigatorMenuWindow extends Encapsule.code.lib.modelview.ObjectModelNavigatorMenuWindowChrome

    constructor: (objectStore_, objectModelNavigatorWindow_, namespaceSelector_) ->

        # \ BEGIN: constructor scope
        try
            # \ BEGIN: constructor try scope
            super(objectStore_, objectModelNavigatorWindow_, namespaceSelector_)

                

            # / END: constructor try scope
        catch exception
            throw "Encapsule.code.lib.modelview.NavigatorWindowMenuLevel failure: : #{exception}"
        # / END: constructor




Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_ObjectModelNavigatorMenuWindow", ( -> """
<span data-bind="if: isSelected()">
    <div class="classObjectModelNavigatorMenuWindow">
        <div class="classMenuSelected">
            <span data-bind="text: namespaceSelector.objectModelDescriptor.label" ></span>
        </div>
        <span data-bind="if: children().length">
            <div class="classObjectModelNavigatorMenuWindowInner">
            <div data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorMenuWindow', foreach: children }"></div>
            </div>
        </span>
    </div>
</span>
<span data-bind="ifnot: isSelected()">
    <div class="classObjectModelNavigatorMenuWindow" data-bind="click: onClick, clickBubble: false" >
        <div class="classMenuUnselected">
            <span data-bind="text: namespaceSelector.objectModelDescriptor.label"></span>
        </div>
        <span data-bind="if: children().length">
            <div class="classObjectModelNavigatorMenuWindowInner">
            <span data-bind="template: { name: 'idKoTemplate_ObjectModelNavigatorMenuWindow', foreach: children }"></span>
            </div>
        </span>
    </div>
</span>
"""))

