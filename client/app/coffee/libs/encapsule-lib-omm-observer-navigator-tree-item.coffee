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
# encapsule-lib-omm-observer-navigator-tree-item.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.modelview = Encapsule.code.lib.modelview? and Encapsule.code.lib.modelview or Encapsule.code.lib.modelview = {}


class Encapsule.code.lib.modelview.ObjectModelNavigatorMenuWindowChrome
      constructor: (objectStore_, objectModelNavigatorWindow_, namespaceSelector_) ->
          try
              if not namespaceSelector_.selectKeysReady
                  throw "Internal error: unresolved namespace selector received in OMM store observer callback!"

              # Cache references to this instance's construction parameters.

              @objectModelNavigatorWindow = objectModelNavigatorWindow_
              @namespaceSelector = namespaceSelector_.clone()
              @children = ko.observableArray []

              @isSelected = ko.observable false

              @blipper = Encapsule.runtime.boot.phase0.blipper

              namespace = objectStore_.openNamespace(namespaceSelector_)
              @label = ko.observable namespace.getResolvedLabel()

              @onClick = =>
                  try
                      @objectModelNavigatorWindow.selectorStore.setSelector(@namespaceSelector)
                  catch exception
                      Console.messageError("Encapsule.code.lib.modelview.ObjectModelNavigatorMenuWindowChrome.onClick failure: #{exception}")

          catch exception
              throw "Encapsule.code.lib.modelview.ObjectModelNavigatorMenuWindowChrome failure: #{exception}"


class Encapsule.code.lib.modelview.ObjectModelNavigatorMenuWindow extends Encapsule.code.lib.modelview.ObjectModelNavigatorMenuWindowChrome

    constructor: (objectStore_, objectModelNavigatorWindow_, namespaceSelector_) ->

        # \ BEGIN: constructor scope
        try
            # \ BEGIN: constructor try scope
            if not (objectStore_? and objectStore_)
                throw "Missing object store input parameter."
            if not (objectModelNavigatorWindow_? and objectModelNavigatorWindow_)
                throw "Missing parent object model navigator window input parameter."
            if not (namespaceSelector_? and namespaceSelector_)
                throw "Missing namespace selector input parameter."

            super(objectStore_, objectModelNavigatorWindow_, namespaceSelector_)

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
