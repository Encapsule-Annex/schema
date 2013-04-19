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
# encapsule-lib-navigator-item-host-window.coffee
#
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.modelview = Encapsule.code.lib.modelview? and Encapsule.code.lib.modelview or Encapsule.code.lib.modelview = {}

class Encapsule.code.lib.modelview.NavigatorMenuItemHostWindow
    constructor: (navigatorContainerObject_, menuLevelObject_) ->

        @navigatorContainer = navigatorContainerObject_
        @menuLevelObject = menuLevelObject_

        @itemObjectType = "unspecified"
        @itemObjectDescription = "unspecified"
        @menuItemModelViewObject = ko.observable undefined

        if @menuLevelObject.menuObjectReference.objectDescriptor? and @menuLevelObject.menuObjectReference.objectDescriptor
            objectDescriptor = @menuLevelObject.menuObjectReference.objectDescriptor

            if objectDescriptor.type? and objectDescriptor.type
                @itemObjectType = objectDescriptor.type

            if objectDescriptor.description? and objectDescriptor.description
                @itemObjectDescription = objectDescriptor.description





Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SchemaViewModelNavigatorBrowserWindow", ( -> """
<span data-bind="ifnot: currentlySelectedItemHost">
    <div>
        <span data-bind="text: title"></span> :: <strong>no selection</strong>
    </div>
</span>

<span data-bind="if: currentlySelectedItemHost">
    <span data-bind="with: currentlySelectedItemHost">
        <div>
            <strong><span data-bind="text: itemObjectType"></span> :: <span data-bind="text: menuLevelObject.path"></span></strong><br>
            <span data-bind="text: menuLevelObject.label"></span> :: <span data-bind="text: itemObjectDescription"></span><br>
        </div>
    </span>
</span>
"""))

    
