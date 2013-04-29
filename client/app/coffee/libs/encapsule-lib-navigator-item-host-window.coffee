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

            if @menuLevelObject.parentMenuLevel? and @menuLevelObject.parentMenuLevel
                parentPath = @menuLevelObject.parentMenuLevel.path
                @parentItemHostWindow = @navigatorContainer.menuItemPathNamespace[parentPath].itemHostModelView
            
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

                switch @itemObjectType

                    when "object"

                        # Figure out how to register this model view (if it's to be registered)
                        switch @itemObjectOrigin

                            when "new"
                                # No registration necessary.
                                @itemObservableModelView = ko.observable {}
                                break

                            when "parent"
                                if not (@parentItemHostWindow? and @parentItemHostWindow)
                                    throw "Can't resolve parent menu item host window reference."

                                switch @parentItemHostWindow.itemObjectType
                                    when "object"

                                        if not (@parentItemHostWindow.itemObservableModelView? and @parentItemHostWindow.itemObservableModelView)
                                            break

                                        @itemObservableModelView = ko.observable {}
                                        currentModelView = @parentItemHostWindow.itemObservableModelView()
                                        currentModelView[@jsonTag] = @itemObservableModelView
                                        @parentItemHostWindow.itemObservableModelView(currentModelView)
                                        break
                                break

                            when "user"
                                @itemObservableModelView = ko.observable {}
                                @itemObservableModelViewFree = ko.observable true
                                colorObject = @menuLevelObject.baseBackgroundColorObject
                                @menuLevelObject.baseBackgroundColorObject = colorObject.darkenByRatio(@navigatorContainer.layout.userObjectDarkenRatio).shiftHue(@navigatorContainer.layout.userObjectShiftHue)
                                break

                        break

                    when "array"

                        colorObject = @menuLevelObject.baseBackgroundColorObject.lightenByRatio(@navigatorContainer.layout.structureArrayLightenRatio).shiftHue(@navigatorContainer.layout.structureArrayShiftHue)
                        @menuLevelObject.baseBackgroundColorObject = colorObject

                        # Figure out how to register this model view (if it's to be registered)
                        switch @itemObjectOrigin

                            when "parent"

                                if not (@parentItemHostWindow? and @parentItemHostWindow)
                                    throw "Can't resolve parent menu item host window reference."

                                switch @parentItemHostWindow.itemObjectType
                                    when "object"

                                        if not (@parentItemHostWindow.itemObservableModelView? and @parentItemHostWindow.itemObservableModelView)
                                            break

                                        @itemObservableModelView = ko.observableArray []
                                        currentModelView = @parentItemHostWindow.itemObservableModelView()
                                        currentModelView[@jsonTag] = @itemObservableModelView
                                        @parentItemHostWindow.itemObservableModelView(currentModelView)
                                        break

                                break



                @toJSON = ko.computed =>
                    jsonWrapper = {}
                    if @itemObjectOrigin == "user" and @itemObservableModelViewFree? and @itemObservableModelViewFree and @itemObservableModelViewFree()
                        jsonWrapper.archetype = {}
                        jsonWrapper.archetype[@jsonTag] = @itemObservableModelView

                    else
                        jsonWrapper[@jsonTag] = @itemObservableModelView
                    ko.toJSON jsonWrapper, undefined, 4

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
    <span data-bind="with: currentlySelectedItemHost">
        <div data-bind="text: menuLevelObject.label"></div>
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
                <strong>SCDL Catalogue <span id="idJSONSourceDownload" data-bind="html: saveJSONAsLinkHtml"></span></strong>
                <pre data-bind="text: toJSON"></pre>
            </span>
        </span>
        <span data-bind="ifnot: currentlySelectedItemHost">
            There is no active navigator selection.
        </span>
    </div>
    """))

