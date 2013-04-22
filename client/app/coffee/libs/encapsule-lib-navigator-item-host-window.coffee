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

        # BEGIN: \ NavigatorMenuItemHostWindow constructor
        try
            # BEGIN: \ NavigatorMenuItemHostWindow constructor try scope

            if not navigatorContainerObject_? then throw "Missing navigatorContainerObject parameter."
            if not navigatorContainerObject_ then throw "Missing navigatorContainerObject parameter value."
            if not menuLevelObject_? then throw "Missing menuLevelObject parameter."
            if not menuLevelObject_ then throw "Missing menuLevelObject parameter value."

            @navigatorContainer = navigatorContainerObject_
            @menuLevelObject = menuLevelObject_
            @path = @menuLevelObject.path
            @jsonTag = @menuLevelObject.jsonTag

            @parentItemHostWindow = undefined

            @itemObjectType = "undefined"
            @itemObjectClassification = "unknown"
            @itemObjectOrigin = "unknown"
            @itemObjectRole = "unknown"
            @itemObjectDescription = "unspecified"

            @itemOuterJsonObject = {}
            @itemObservableModelView = undefined
            
            if @menuLevelObject.layoutObject.objectDescriptor? and @menuLevelObject.layoutObject.objectDescriptor

                objectDescriptor = @menuLevelObject.layoutObject.objectDescriptor

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

                if @itemObjectOrigin == "new"

                    if @itemObjectType == "object"

                        @itemObservableModelView = ko.observable {}

                if @itemObjectOrigin == "parent"

                    if not (@menuLevelObject.parentMenuLevel? and @menuLevelObject.parentMenuLevel)
                        throw "Can't resolve parent menu level reference."

                    parentPath = @menuLevelObject.parentMenuLevel.path
                    @parentItemHostWindow = @navigatorContainer.menuItemPathNamespace[parentPath].itemHostModelView

                    if not (@parentItemHostWindow? and @parentItemHostWindow)
                        throw "Can't resolve parent item host window."

                    if @itemObjectType == "object"

                        @itemObservableModelView = ko.observable {}

                        if @parentItemHostWindow.itemObjectType == "object"

                            if @parentItemHostWindow.itemObservableModelView? and @parentItemHostWindow.itemObservableModelView
                                parentModelView = @parentItemHostWindow.itemObservableModelView()
                                parentModelView[@jsonTag] = @itemObservableModelView
                                @parentItemHostWindow.itemObservableModelView(parentModelView)

                @toJSON = ko.computed =>
                    jsonWrapper = {}
                    jsonWrapper[@jsonTag] = @itemObservableModelView
                    ko.toJSON jsonWrapper, undefined, 1

                @saveJSONAsLinkHtml = ko.computed =>
                    # Inpsired by: http://stackoverflow.com/questions/3286423/is-it-possible-to-use-any-html5-fanciness-to-export-local-storage-to-excel/3293101#3293101
                    html = "<a href=\"data:text/json;base64,#{window.btoa(@toJSON())}\" target=\"_blank\">JSON</a>"

                             

            # END: / NavigatorMenuItemHostWindow constructor try scope

        catch exception

            throw "NavigatorMenuItemHostWindow constructor fail: #{exception}"


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SchemaViewModelNavigatorBrowserWindow", ( -> """
<div class="classNavigatorItemHostWindow">
<span data-bind="ifnot: currentlySelectedItemHost">
    <div>
        <span data-bind="text: title"></span> :: <strong>no selection</strong>
    </div>
</span>

<span data-bind="if: currentlySelectedItemHost">
    <table>

    <thead>
        <td style="width: 200px">Attribute</td>
        <td>Value</td>
    </thead>

    <tr><td>Label</td><td><span data-bind="with: currentlySelectedItemHost">
        <span data-bind="text: menuLevelObject.label"></span>
    </span></td></tr>

    <tr><td>Description</td><td><span data-bind="with: currentlySelectedItemHost">
        <span data-bind="text: itemObjectDescription"></span>
    </span></td></tr>

    <tr><td>Type</td><td><span data-bind="with: currentlySelectedItemHost">
        <span data-bind="text: itemObjectOrigin"></span>
        <span data-bind="text: itemObjectClassification"></span>
        <span data-bind="text: itemObjectRole"></span>
        <span data-bind="text: itemObjectType"></span>
    </span></td></tr>

    <tr><td>Path</td><td><span data-bind="with: currentlySelectedItemHost">
        <span data-bind="text: menuLevelObject.path"></span>
    </span></td></tr>

    </table>

    <span data-bind="with: currentlySelectedItemHost">
        <h1 data-bind="text: menuLevelObject.label"></h1>

        <span data-bind="if: itemObjectType == 'object'">
            <span data-bind="if: itemObjectRole == 'namespace'">
            namspace object
            </span>
            <span data-bind="if: itemObjectRole == 'data'">
            data object
            </span>
        </span>

        <span data-bind="if: itemObjectType == 'array'">
            <span data-bind="if: itemObjectRole == 'extension'">
            extension array
            </span>
        </span>


    </span>

</span>
</div>
"""))

    
Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SchemaViewModelNavigatorJSONWindow", ( ->
    """
    <div class="classEncapsuleNavigatorMenuItemJSONWindow">
        <span data-bind="if: currentlySelectedItemHost">
            <span data-bind="with: currentlySelectedItemHost">
                <!-- <strong>SCDL Catalogue <span id="idJSONSourceDownload" data-bind="html: saveJSONAsLinkHtml"></span></strong> -->
                <pre data-bind="text: toJSON"></pre>
            </span>
        </span>
        <span data-bind="ifnot: currentlySelectedItemHost">
            There is no active navigator selection.
        </span>
    </div>
    """))

