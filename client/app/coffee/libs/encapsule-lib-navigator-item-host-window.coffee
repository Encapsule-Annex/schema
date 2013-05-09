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

            @blipper = Encapsule.runtime.boot.phase3.blipper

            @navigatorContainer = navigatorContainerObject_
            @menuLevelObject = menuLevelObject_
            @path = @menuLevelObject.path

            @jsonTagOrigin = "unknown"

            layoutObject = @menuLevelObject.layoutObject
            layoutObjectDescriptor = @menuLevelObject.layoutObject.objectDescriptor
          
            @jsonTag = layoutObjectDescriptor? and layoutObjectDescriptor and layoutObjectDescriptor.jsonTag? and layoutObjectDescriptor.jsonTag or @menuLevelObject.jsonTag

            Console.message("NavigatorMenuItemHostWindow constructing for navigator path #{@path}")

            @parentItemHostWindow = undefined

            @itemMVVMType = undefined

            @itemObservableModelView = ko.observable(undefined)

            @itemSelectState = ko.observable("offline")
            @itemSelectElementOrdinal = ko.observable(-1)

            @isSelectedArchetype = ko.computed =>
                itemMVVMType = @itemMVVMType
                itemSelectState = @itemSelectState()
                result = itemMVVMType? and itemMVVMType and (itemMVVMType == "select") and itemSelectState? and itemSelectState and (itemSelectState == "archetype")
                return result

            @isSelectedElement = ko.computed =>
                itemMVVMType = @itemMVVMType
                itemSelectState = @itemSelectState()
                result = itemMVVMType? and itemMVVMType and (itemMVVMType == "select") and itemSelectState? and itemSelectState and (itemSelectState == "element")
                return result

            
            if @menuLevelObject.parentMenuLevel? and @menuLevelObject.parentMenuLevel
                parentPath = @menuLevelObject.parentMenuLevel.path
                @parentItemHostWindow = @navigatorContainer.menuItemPathNamespace[parentPath].itemHostModelView
            
            if layoutObjectDescriptor? and layoutObjectDescriptor

                layoutObjectDescriptor = @menuLevelObject.layoutObject.objectDescriptor

                if layoutObjectDescriptor.mvvmType? and layoutObjectDescriptor.mvvmType
                    @itemMVVMType = layoutObjectDescriptor.mvvmType
                else
                    throw "Missing objectDescriptor.mvvmType declaration."

                if layoutObjectDescriptor.description? and layoutObjectDescriptor.description
                    @itemObjectDescription = layoutObjectDescriptor.description
                else
                    throw "Missing objectDescriptor.description declaration."

                switch @itemMVVMType

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

                        # Set the MVVM object-type-specific color of the menu level object.
                        colorObject = @menuLevelObject.baseBackgroundColorObject().lightenByRatio(@navigatorContainer.layout.structureArrayLightenRatio).shiftHue(@navigatorContainer.layout.structureArrayShiftHue)
                        @menuLevelObject.baseBackgroundColorObject(colorObject)

                        ###
                        updatedMenuLevelLabel = @menuLevelObject.label() + " EP"
                        @menuLevelObject.label(updatedMenuLevelLabel)
                        ###

                        # Modify the parent menu item host's hosted model view by adding this new array into its object namespace.
                        if (@parentItemHostWindow.itemObservableModelView? and @parentItemHostWindow.itemObservableModelView)
                            @itemObservableModelView([])
                            currentModelView = @parentItemHostWindow.itemObservableModelView()
                            currentModelView[@jsonTag] = @itemObservableModelView
                            @parentItemHostWindow.itemObservableModelView(currentModelView)

                        # Create the select menu item beneath the extension point.
                        if not (layoutObjectDescriptor.archetype? and layoutObjectDescriptor.archetype)
                            alert("#{@path} extension w/no declared archetype.")
                        
                        # Create the select sub menu of this extension.
                        layoutSelectMenuLevel = Encapsule.code.lib.js.clone(layoutObjectDescriptor.archetype)
                        layoutSelectMenuLevel.objectDescriptor.mvvmType = "select"
                        
                        selectMenuLevel = new Encapsule.code.lib.modelview.NavigatorWindowMenuLevel(@navigatorContainer, @menuLevelObject, layoutSelectMenuLevel, @menuLevelObject.level() + 1)
                        @menuLevelObject.subMenus.push(selectMenuLevel)

                        ###

                        # Create the archetype sub menu of this extension.
                        layoutArchetypeMenuLevel = Encapsule.code.lib.js.clone(layoutObjectDescriptor.archetype)
                        layoutArchetypeMenuLevel.jsonTag = "archetype"
                        layoutArchetypeMenuLevel.objectDescriptor.mvvmType = "archetype"

                        archetypeMenuLevel = new Encapsule.code.lib.modelview.NavigatorWindowMenuLevel(@navigatorContainer, @menuLevelObject, layoutArchetypeMenuLevel, @menuLevelObject.level() + 1)
                        @menuLevelObject.subMenus.push(archetypeMenuLevel)

                        ###

                        break

                    when "root"
                        @itemObservableModelView({})
                        break

                    when "select"
                        if not (@parentItemHostWindow? and @parentItemHostWindow)
                            throw "Can't resolve parent menu item host window reference."

                        # Set the MVVM object-type-specific color of the menu level object.
                        colorObject = @menuLevelObject.baseBackgroundColorObject().saturateByRatio(@navigatorContainer.layout.archetypeSaturateRatio).lightenByRatio(@navigatorContainer.layout.archetypeLightenRatio).shiftHue(@navigatorContainer.layout.archetypeShiftHue)
                        @menuLevelObject.baseBackgroundColorObject(colorObject)

                        @itemObservableModelView({})
                        @itemSelectState("archetype")
                        break

                    else
                        throw "Unrecognized mvvmType specified in menu level objectDescriptor.mvvmType: #{@itemMVVMType}"





                @toJSON = ko.computed =>
                    jsonView = {}
                    jsonView[@jsonTag] = @itemObservableModelView
                    ko.toJSON(jsonView, undefined, 1)
                        
                @itemPageTitle = ko.computed =>
                    isExtensionPoint = @itemMVVMType == "extension"
                    isSelectionPoint = @itemMVVMType == "select"
                    isSelectedArchetype = @isSelectedArchetype()
                    isSelectedElement = @isSelectedElement()
                    itemObservableModelView = @itemObservableModelView()

                    pageTitle = @menuLevelObject.labelDefault

                    if isExtensionPoint then pageTitle = "#{@menuLevelObject.labelDefault} (#{itemObservableModelView.length})"
                    if isSelectedArchetype then pageTitle = "#{@menuLevelObject.labelDefault} (new)"
                    if isSelectedElement then pageTitle = "#{@menuLevelObject.labelDefault} (#{@itemSelectElementOrdinal()})"

                    if pageTitle != @menuLevelObject.label()
                        @menuLevelObject.label(pageTitle)

                    return pageTitle

                @saveJSONAsLinkHtml = ko.computed =>
                    # Inpsired by: http://stackoverflow.com/questions/3286423/is-it-possible-to-use-any-html5-fanciness-to-export-local-storage-to-excel/3293101#3293101
                    html = "<a href=\"data:text/json;base64,#{window.btoa(@toJSON())}\" target=\"_blank\">JSON</a>"

                @setSelectState = (selectState_) =>
                    if not (selectState_? and selectState_)
                        throw "Missing select state paramter."
                    if @itemMVVMType != "select"
                        throw "Invalid request. This menu item host is not of MVVM type 'select'."

                    switch selectState_
                        when "element"
                            # Set the MVVM object-type-specific color of the menu level object.
                            @menuLevelObject.resetBaseBackgroundColor()
                            colorObject = @menuLevelObject.baseBackgroundColorObject().saturateByRatio(@navigatorContainer.layout.elementSaturateRatio).lightenByRatio(@navigatorContainer.layout.elementLightenRatio).shiftHue(@navigatorContainer.layout.elementShiftHue)
                            @menuLevelObject.baseBackgroundColorObject(colorObject)
                            @itemSelectState(selectState_)

                    


                # OPERATIONS

                # button click event handler delegates to the navigator container.
                @insertArchetype = =>
                    @blipper.blip("01a")
                    @navigatorContainer.insertArchetypeFromItemHostObject(@)




            # END: / NavigatorMenuItemHostWindow constructor try scope

        catch exception

            throw "NavigatorMenuItemHostWindow constructor fail: #{exception}"


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SchemaNavigatorSelectedItemWindow", ( -> """

<span data-bind="if: currentlySelectedItemHost">
    <span data-bind="with: currentlySelectedItemHost">
        <div class="classNavigatorItemHostWindow">

            <div style="font-size: 10pt; font-weight: normal; background-color: rgba(0, 200, 255, 0.3); padding: 5px;" data-bind="style: { color: menuLevelObject.getCssColor(), textShadow: menuLevelObject.getCssTextShadow() }">
                <span data-bind="text: menuLevelObject.path"></span>
            </div>


            <div style="font-size: 22pt; font-weight: normal; background-color: rgba(0, 200, 255, 0.15); padding: 5px;">
                <div data-bind="style: { color: menuLevelObject.getCssColor(), textShadow: menuLevelObject.getCssTextShadow() }">
                    <span data-bind="text: itemPageTitle"></span>
                </div>
            </div>                

            <h2>Operations</h2>

            <span data-bind="if: isSelectedArchetype">
                <p>New, unmodified instance of <strong><span data-bind="text: menuLevelObject.label"></span></strong> (extends <strong><span data-bind="text: menuLevelObject.parentMenuLevel.label"></span></strong>)</p>
                <button class="button small blue" data-bind="event: { click: insertArchetype }">Add</button>                                                                                    
            </span>

            <span data-bind="if: isSelectedElement">
                <p><i>This namespace represents an unmodified, archetypical extension supporting the following operations:</i></p>
                <button class="button small black" data-bind="event: { click: insertArchetype }">Unselect</button>
                <button class="button small red" data-bind="event: { click: insertArchetype }">Remove</button>
            </span>  

            <span data-bind="if: itemMVVMType == 'extension'">
                <h2><span data-bind="text: menuLevelObject.label"></span> Elements</h2>
                <div data-bind="foreach: itemObservableModelView">
                    <span data-bind="text: $index"></span>
                </div>
            </span>

            <span data-bind="if: itemMVVMType == 'root'">
                <p><i>This namespace cannot be modified by the user.</i></p>
            </span>

            <span data-bind="if: itemMVVMType == 'child'">
                <p><i>This namespace cannot be modified by the user.</i></p>
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

