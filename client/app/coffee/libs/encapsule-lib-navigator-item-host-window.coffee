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

            @itemMVVMType = undefined

            @itemOuterJsonObject = {}
            @itemObservableModelView = ko.observable(undefined)
            @itemObservableModelViewFree = ko.observable false

            if @menuLevelObject.parentMenuLevel? and @menuLevelObject.parentMenuLevel
                parentPath = @menuLevelObject.parentMenuLevel.path
                @parentItemHostWindow = @navigatorContainer.menuItemPathNamespace[parentPath].itemHostModelView
            
            if @menuLevelObject.layoutObject.objectDescriptor? and @menuLevelObject.layoutObject.objectDescriptor

                objectDescriptor = @menuLevelObject.layoutObject.objectDescriptor

                if objectDescriptor.mvvmType? and objectDescriptor.mvvmType
                    @itemMVVMType = objectDescriptor.mvvmType

                if objectDescriptor.description? and objectDescriptor.description
                    @itemObjectDescription = objectDescriptor.description

                switch @itemMVVMType

                    when "archetype"

                        @itemObservableModelView({})
                        @itemObservableModelViewFree(true)
                        colorObject = @menuLevelObject.baseBackgroundColorObject
                        @menuLevelObject.baseBackgroundColorObject = colorObject.darkenByRatio(@navigatorContainer.layout.userObjectDarkenRatio).shiftHue(@navigatorContainer.layout.userObjectShiftHue)

                        break

                    when "child"
                        if not (@parentItemHostWindow? and @parentItemHostWindow)
                            throw "Can't resolve parent menu item host window reference."

                        if not (@parentItemHostWindow.itemObservableModelView? and @parentItemHostWindow.itemObservableModelView)
                            break

                        @itemObservableModelView({})
                        currentModelView = @parentItemHostWindow.itemObservableModelView()
                        currentModelView[@jsonTag] = @itemObservableModelView
                        @parentItemHostWindow.itemObservableModelView(currentModelView)

                        break

                    when "extension"
                        if not (@parentItemHostWindow? and @parentItemHostWindow)
                            throw "Can't resolve parent menu item host window reference."

                        colorObject = @menuLevelObject.baseBackgroundColorObject.lightenByRatio(@navigatorContainer.layout.structureArrayLightenRatio).shiftHue(@navigatorContainer.layout.structureArrayShiftHue)
                        @menuLevelObject.baseBackgroundColorObject = colorObject

                        if (@parentItemHostWindow.itemObservableModelView? and @parentItemHostWindow.itemObservableModelView)
                            @itemObservableModelView([])
                            currentModelView = @parentItemHostWindow.itemObservableModelView()
                            currentModelView[@jsonTag] = @itemObservableModelView
                            @parentItemHostWindow.itemObservableModelView(currentModelView)

                        break

                    when "root"
                        @itemObservableModelView({})

                        break

                    when "select"
                        if not (@parentItemHostWindow? and @parentItemHostWindow)
                            throw "Can't resolve parent menu item host window reference."
                        break

                    else
                        throw "Unrecognized mvvmType specified in menu level objectDescriptor.mvvmType: #{@itemMVVMType}"





                @toJSON = ko.computed =>
                    jsonWrapper = {}
                    if @itemObjectOrigin == "user" and @itemObservableModelViewFree? and @itemObservableModelViewFree and @itemObservableModelViewFree()
                        jsonWrapper.archetype = {}
                        jsonWrapper.archetype[@jsonTag] = @itemObservableModelView

                    else
                        jsonWrapper[@jsonTag] = @itemObservableModelView
                    ko.toJSON jsonWrapper, undefined, 2

                @saveJSONAsLinkHtml = ko.computed =>
                    # Inpsired by: http://stackoverflow.com/questions/3286423/is-it-possible-to-use-any-html5-fanciness-to-export-local-storage-to-excel/3293101#3293101
                    html = "<a href=\"data:text/json;base64,#{window.btoa(@toJSON())}\" target=\"_blank\">JSON</a>"

                # OPERATIONS

                @insertArchetype = =>
                    @navigatorContainer.insertArchetypeFromItemHostObject(@)




            # END: / NavigatorMenuItemHostWindow constructor try scope

        catch exception

            throw "NavigatorMenuItemHostWindow constructor fail: #{exception}"


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SchemaNavigatorSelectedItemWindow", ( -> """

<span data-bind="if: currentlySelectedItemHost">
    <span data-bind="with: currentlySelectedItemHost">
        <div class="classNavigatorItemHostWindow">

            <span data-bind="with: menuLevelObject">
                <h1 data-bind="style: { color: getCssColor(), textShadow: getCssTextShadow() }">
                    <span data-bind="text: label"></span>
                </h1>
            </span>

            <h2 data-bind="text: itemObjectDescription"></h2>
            <p>MVVM Type: <span data-bind="text: itemMVVMType"></span></p>

            <span data-bind="if: itemMVVMType == 'archetype'">
                This is an archetype entity.
                <p>
                    <span data-bind="with: menuLevelObject.parentMenuLevel">Add this entity to <span data-bind="text: label"></span>:</span>
                    <button class="button small blue" data-bind="event: { click: insertArchetype }">Add</button>
                </p>
            </span>

            <span data-bind="if: itemMVVMType == 'root'">
                root
            </span>

            <span data-bind="if: itemMVVMType == 'child'">
                child
            </span>

            <span data-bind="if: itemMVVMType == 'select'">
               select
            </span>

            <span data-bind="if: itemMVVMType == 'extension'">
                extension
            </span>


        </div><!-- classNavigatorItemHostWindow -->
    </span>
</span>

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

