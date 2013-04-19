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

        @itemObjectType = "undefined"
        @itemObjectClassification = "unknown"
        @itemObjectOrigin = "unknown"
        @itemObjectRole = "unknown"
        @itemObjectDescription = "unspecified"
        @menuItemModelViewObject = ko.observable undefined

        if @menuLevelObject.menuObjectReference.objectDescriptor? and @menuLevelObject.menuObjectReference.objectDescriptor
            objectDescriptor = @menuLevelObject.menuObjectReference.objectDescriptor

            if objectDescriptor.type? and objectDescriptor.type
                @itemObjectType = objectDescriptor.type

            if objectDescriptor.classification? and objectDescriptor.classification
                @itemObjectClassification = objectDescriptor.classification

            if objectDescriptor.role? and objectDescriptor.role
                @itemObjectRole = objectDescriptor.role

            if objectDescriptor.origin? and objectDescriptor.origin
                @itemObjectOrigin = objectDescriptor.origin

            if objectDescriptor.description? and objectDescriptor.description
                @itemObjectDescription = objectDescriptor.description





Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SchemaViewModelNavigatorBrowserWindow", ( -> """
<span data-bind="ifnot: currentlySelectedItemHost">
    <div>
        <span data-bind="text: title"></span> :: <strong>no selection</strong>
    </div>
</span>

<span data-bind="if: currentlySelectedItemHost">
    <table>

    <thead style="font-weight: bold; background-color: #0099FF;">
        <td style="width: 200px">Attribute</td>
        <td>Value</td>
    </thead>

    <tr><td>Label</td><td><span data-bind="with: currentlySelectedItemHost">
        <span data-bind="text: menuLevelObject.label"></span>
    </span></td></tr>

    <tr><td>Path</td><td><span data-bind="with: currentlySelectedItemHost">
        <span data-bind="text: menuLevelObject.path"></span>
    </span></td></tr>

    <tr><td>Description</td><td><span data-bind="with: currentlySelectedItemHost">
        <span data-bind="text: itemObjectDescription"></span>
    </span></td></tr>

    <tr><td>Type</td><td><span data-bind="with: currentlySelectedItemHost">
        <span data-bind="text: itemObjectType"></span>
    </span></td></tr>

    <tr><td>Classification</td><td><span data-bind="with: currentlySelectedItemHost">
        <span data-bind="text: itemObjectClassification"></span>
    </span></td></tr>

    <tr><td>Role</td><td><span data-bind="with: currentlySelectedItemHost">
        <span data-bind="text: itemObjectRole"></span>
    </span></td></tr>

    <tr><td>Origin</td><td><span data-bind="with: currentlySelectedItemHost">
        <span data-bind="text: itemObjectOrigin"></span>
    </span></td></tr>

    </table>
</span>
"""))

    
