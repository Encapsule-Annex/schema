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
# encapsule-lib-navigator-item-host.coffee
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

            @blipper = Encapsule.runtime.boot.phase0.blipper

            @navigatorContainer = navigatorContainerObject_
            @menuLevelObject = menuLevelObject_
            @path = @menuLevelObject.path

            layoutObject = @menuLevelObject.layoutObject
            layoutObjectDescriptor = @menuLevelObject.layoutObject.objectDescriptor

            @namespaceMemberInitializer = undefined
            if layoutObjectDescriptor.namespaceDescriptor? and layoutObjectDescriptor.namespaceDescriptor
                @namespaceMemberInitializer = new Encapsule.code.lib.modelview.NavigatorModelViewNamespaceInitializer(@, layoutObjectDescriptor.namespaceDescriptor)

            @namespaceViewModelTemplateName = Encapsule.code.lib.modelview.NavigatorCreateItemHostViewModelHtmlTemplate(layoutObject, @, @path)

            @namespaceUpdateObservableState = =>
                if @namespaceMemberInitializer? and @namespaceMemberInitializer and @namespaceMemberInitializer.updateObservableState?
                    @namespaceMemberInitializer.updateObservableState()
                @updateItemPageTitle()
                @itemObservableModelViewUpdated()
                if @parentItemHostWindow? and @parentItemHostWindow
                    @parentItemHostWindow.namespaceUpdateObservableState()

          
            @jsonTag = layoutObjectDescriptor? and layoutObjectDescriptor and layoutObjectDescriptor.jsonTag? and layoutObjectDescriptor.jsonTag or @menuLevelObject.jsonTag

            Console.message("NavigatorMenuItemHostWindow constructing for navigator path #{@path}")

            @parentItemHostWindow = undefined

            @itemMVVMType = undefined

            @itemObservableModelView = ko.observable({})
            @itemObservableModelViewUpdateCount = ko.observable(0)
            @itemObservableModelViewUpdated = =>
                @itemObservableModelViewUpdateCount(@itemObservableModelViewUpdateCount() + 1)

            # If this item host is an "extension"-type item then these members are
            # used to track the item's state.
            @itemExtensionSelectLabel = "missing archetype label"
            @itemExtensionSelectPath = ""

            # Note that item host objects are initially created via BFS traversal and thus
            # this the child item host object cannot be resolved at construction time. All
            # access within this classes methods to the childSelectItemHostObject must be
            # made via the getChildSelectItemHostObject method consequently.
            @childSelectItemHostObject = undefined
            @getChildSelectItemHostObject = =>
                try
                    if not @childSelectItemHostObject
                        @childSelectItemHostObject = @navigatorContainer.getItemHostObjectFromPath(@itemExtensionSelectPath) # throws
                    return @childSelectItemHostObject

                catch exception
                    throw "There is no child item host object to get! fail: #{exception}"

            # If this item host is a "select"-type item then these members are
            # used to track the item's state.
            @itemSelectState = ko.observable("offline")
            @itemSelectElementOrdinal = ko.observable(-1)

            #
            # ============================================================================
            @isSelectedArchetype = ko.computed =>
                itemMVVMType = @itemMVVMType
                itemSelectState = @itemSelectState()
                result = itemMVVMType? and itemMVVMType and (itemMVVMType == "select") and itemSelectState? and itemSelectState and (itemSelectState == "archetype")
                return result

            #
            # ============================================================================
            @isSelectedElement = ko.computed =>
                itemMVVMType = @itemMVVMType
                itemSelectState = @itemSelectState()
                result = itemMVVMType? and itemMVVMType and (itemMVVMType == "select") and itemSelectState? and itemSelectState and (itemSelectState == "element")
                return result

            #
            # ============================================================================
            @itemPageTitle = ko.observable undefined

            @updateItemPageTitle = =>
                isExtensionPoint = @itemMVVMType == "extension"
                isSelectionPoint = @itemMVVMType == "select"
                isSelectedArchetype = @isSelectedArchetype()
                isSelectedElement = @isSelectedElement()
                itemObservableModelView = @itemObservableModelView()
                pageTitle = @menuLevelObject.labelDefault
                if isExtensionPoint

                    # This doesn't work at all.
                    #selectedElementOrdinal = -1
                    #childItemHost = @getChildSelectItemHostObject()
                    #if childItemHost? and childItemHost
                    #    selectedElementOrdinal = childItemHost.itemSelectElementOrdinal()

                    pageTitle = "#{@menuLevelObject.labelDefault} #{itemObservableModelView.length}"

                if isSelectedArchetype then pageTitle = "#{@menuLevelObject.labelDefault} (archetype)"
                if isSelectedElement then pageTitle = "#{@menuLevelObject.labelDefault} #{@itemSelectElementOrdinal() + 1}"
                if pageTitle != @menuLevelObject.label()
                    @menuLevelObject.label(pageTitle)
                @itemPageTitle(pageTitle)
                @itemObservableModelViewUpdateCount()

            

            if @menuLevelObject.parentMenuLevel? and @menuLevelObject.parentMenuLevel
                parentPath = @menuLevelObject.parentMenuLevel.path
                @parentItemHostWindow = @navigatorContainer.menuItemPathNamespace[parentPath].itemHostModelView

            @itemElementModelView = undefined

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

                        # We want the parent to own the actual data so this object's @itemObservableModelView
                        # will be a reference to the actual object, not the allocated object itself.

                        # Unbox the parent's contained model view.
                        currentModelView = @parentItemHostWindow.itemObservableModelView()
                        # Modify the parent's contained model view.
                        newObject = {}
                        if @namespaceMemberInitializer? and @namespaceMemberInitializer
                            @namespaceMemberInitializer.initializeNamespace(newObject)
                        currentModelView[@jsonTag] = ko.observable(newObject)
                        @itemObservableModelView = currentModelView[@jsonTag]
                        @itemObservableModelViewUpdated()
                        # Update the parent's contained model view.
                        @parentItemHostWindow.itemObservableModelView(currentModelView)

                        @itemElementModelView = new Encapsule.code.lib.modelview.NavigatorChildItemElementModelView(@)

                        break

                    when "extension"
                        if not (@parentItemHostWindow? and @parentItemHostWindow)
                            throw "Can't resolve parent menu item host window reference."

                        # Set the MVVM object-type-specific color of the menu level object.
                        colorObject = @menuLevelObject.baseBackgroundColorObject().lightenByRatio(@navigatorContainer.layout.structureArrayLightenRatio).shiftHue(@navigatorContainer.layout.structureArrayShiftHue)
                        @menuLevelObject.baseBackgroundColorObject(colorObject)

                        # Modify the parent menu item host's hosted model view by adding this new array into its object namespace.
                        if (@parentItemHostWindow.itemObservableModelView? and @parentItemHostWindow.itemObservableModelView)
                            # Unbox the parent's contained model view.
                            currentModelView = @parentItemHostWindow.itemObservableModelView()
                            # Modify the parent's contained model view.
                            currentModelView[@jsonTag] = ko.observableArray()
                            @itemObservableModelView = currentModelView[@jsonTag]
                            @itemObservableModelViewUpdated()
                            # Update the parent's contained model view.
                            @parentItemHostWindow.itemObservableModelView(currentModelView)
                            

                        # Create the select menu item beneath the extension point.
                        if not (layoutObjectDescriptor.archetype? and layoutObjectDescriptor.archetype)
                            alert("#{@path} extension w/no declared archetype.")
                        
                        # Create the select sub menu of this extension.
                        layoutSelectMenuLevel = Encapsule.code.lib.js.clone(layoutObjectDescriptor.archetype)
                        layoutSelectMenuLevel.objectDescriptor.mvvmType = "select"
                        
                        selectMenuLevel = new Encapsule.code.lib.modelview.NavigatorWindowMenuLevel(@navigatorContainer, @menuLevelObject, layoutSelectMenuLevel, @menuLevelObject.level() + 1)
                        @menuLevelObject.subMenus.push(selectMenuLevel)
                        @itemExtensionSelectLabel = layoutSelectMenuLevel.label
                        @itemExtensionSelectPath = "#{@path}.#{layoutSelectMenuLevel.jsonTag}"

                        break

                    when "root"
                        newObject = {}
                        if @namespaceMemberInitializer? and @namespaceMemberInitializer
                            @namespaceMemberInitializer.initializeNamespace(newObject)

                        @itemObservableModelView = ko.observable(newObject)
                        @itemObservableModelViewUpdated()
                        break

                    when "select"
                        if not (@parentItemHostWindow? and @parentItemHostWindow)
                            throw "Can't resolve parent menu item host window reference."

                        # Set the MVVM object-type-specific color of the menu level object.
                        colorObject = @menuLevelObject.baseBackgroundColorObject().saturateByRatio(@navigatorContainer.layout.archetypeSaturateRatio).lightenByRatio(@navigatorContainer.layout.archetypeLightenRatio).shiftHue(@navigatorContainer.layout.archetypeShiftHue)
                        @menuLevelObject.baseBackgroundColorObject(colorObject)
                        newObject = {}
                        if @namespaceMemberInitializer? and @namespaceMemberInitializer
                            @namespaceMemberInitializer.initializeNamespace(newObject)
                        @itemObservableModelView = ko.observable(newObject)
                        @itemObservableModelViewUpdated()
                        @itemSelectState("archetype")
                        @menuLevelObject.itemVisible(false)
                        @menuLevelObject.itemVisibilityLock = true
                        break

                    else
                        throw "Unrecognized mvvmType specified in menu level objectDescriptor.mvvmType: #{@itemMVVMType}"

                @updateItemPageTitle()


            #
            # ============================================================================
            @toJSON = ko.computed =>

                # This is a hack. Because navigator uses references to observable's extensively
                # the fundamental update mechanism is fooled completely and it's not yet clear
                # to me if it even makes sense to leverage computed observables in this scenario
                # where state changes are wholely contained within the navigator subsystem (i.e.
                # a simple function call would suffice to update a simple observable.

                @itemSelectState()
                @itemSelectElementOrdinal()
                @itemObservableModelViewUpdateCount()

                jsonView = {}
                jsonView[@jsonTag] = @itemObservableModelView
                ko.toJSON(jsonView, undefined, 2)

                #ko.toJSON(@itemObservableModelView, undefined, 2)
                        

            #
            # ============================================================================
            @saveJSONAsLinkHtml = ko.computed =>
                # Inpsired by: http://stackoverflow.com/questions/3286423/is-it-possible-to-use-any-html5-fanciness-to-export-local-storage-to-excel/3293101#3293101
                html = "<a href=\"data:text/json;base64,#{window.btoa(@toJSON())}\" target=\"_blank\">JSON</a>"

            #
            # ============================================================================
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


            #
            # ============================================================================
            @internalRelinkSelectToElement = (arrayIndex_) =>
                try
                    Console.message("NavigatorMenuItemHostWindow.internalRelinkSelectToElement start")
                    Console.message("... path=#{@path} arrayIndex=#{arrayIndex_}")

                    if @itemMVVMType != "select" then throw "Invalid item host for request. Must be a select."

                    # We don't care if the item is in the "archetype" or "element" state as we're going to
                    # replace this select item's contained view model with a reference to the parent
                    # extension array's specified element.

                    @itemSelectState("element")
                    @itemSelectElementOrdinal(arrayIndex_)
                    @menuLevelObject.itemVisible(true)
                    @menuLevelObject.itemVisibilityLock = false
                    parentObservableModelView = @parentItemHostWindow.itemObservableModelView()
                    arrayElement = parentObservableModelView[arrayIndex_]
                    thisObservableModelView = arrayElement[@jsonTag]
                    @itemObservableModelView = thisObservableModelView
                    @itemObservableModelViewUpdated()
                    @updateItemPageTitle()
                    

                catch exception
                    throw "NavigatorItemHost.internalRelinkSelectToElement fail: #{exception}"
                


            #
            # ============================================================================
            # forceSelectElementAction_ may be undefined | "detach" | "relink"
            # 
            @internalResetContainedModelView = (forceSelectElementAction_) =>
                
                try
                    forceSelectElementDetach = forceSelectElementAction_? and forceSelectElementAction_ and forceSelectElementAction_ == "detach"
                    forceSelectElementRelink = forceSelectElementAction_? and forceSelectElementAction_ and forceSelectElementAction_ == "relink"

                    Console.message("NavigatorItemHost.internalResetContainedModelView on path #{@path}, detach=#{forceSelectElementDetach}, relink=#{forceSelectElementRelink}")

                    switch @itemMVVMType
                        when "child"
                            Console.message("... processing child")
                            # TODO: reset object members excluding child objects for which an item host exists.

                            # It's possible that this "child"-type item's parent is a "select"-type item that
                            # has just been reset. If so, we need to re-link this item host to it's parent.
                            if not (@parentItemHostWindow? and @parentItemHostWindow) then throw "Internal error. No parent item host set?"

                            parentObservableModelView = @parentItemHostWindow.itemObservableModelView()

                            if forceSelectElementRelink
                                unboxed = parentObservableModelView[@jsonTag]
                                if not (unboxed? and unboxed)
                                    # Recreate the archetype
                                    newObject = {}
                                    if @namespaceMemberInitializer? and @namespaceMemberInitializer
                                        @namespaceMemberInitializer.initializeNamespace(newObject)
                                    unboxed = parentObservableModelView[@jsonTag] = ko.observable(newObject)
                                    @parentItemHostWindow.itemObservableModelView(parentObservableModelView)
                                        
                                @itemObservableModelView = unboxed
                                @itemObservableModelViewUpdated()
                                if not @itemObservableModelView
                                    throw "Internal error!"

                            else
                                if not (parentObservableModelView[@jsonTag]? and parentObservableModelView[@jsonTag])
                                    newObject = {}
                                    if @namespaceMemberInitializer? and @namespaceMemberInitializer
                                        @namespaceMemberInitializer.initializeNamespace(newObject)
                                    parentObservableModelView[@jsonTag] = ko.observable(newObject)
                                    @itemObservableModelView = parentObservableModelView[@jsonTag]
                                    @itemObservableModelViewUpdated()
                                    @parentItemHostWindow.itemObservableModelView(parentObservableModelView)
                            break

                        when "extension"
                            Console.message("... processing extension")
                            # TODO: reset object members excluding child objects for which an item host exists.
                            # Reset the contents of the array

                            if not (@parentItemHostWindow? and @parentItemHostWindow) then throw "Internal error. No parent item host set?"
                            parentObservableModelView = @parentItemHostWindow.itemObservableModelView()

                            if forceSelectElementRelink
                                unboxed = parentObservableModelView[@jsonTag]
                                if not (unboxed? and unboxed)
                                    # Recreate the archetype
                                    unboxed = parentObservableModelView[@jsonTag] = ko.observableArray([])
                                    @parentItemHostWindow.itemObservableModelView(parentObservableModelView)

                                @itemObservableModelView = unboxed
                                @itemObservableModelViewUpdated()
                                if not @itemObservableModelView
                                    throw "Internal error!"

                            else
                                if not (parentObservableModelView[@jsonTag]? and parentObservableModelView[@jsonTag])
                                    parentObservableModelView[@jsonTag] = ko.observableArray([])
                                    @itemObservableModelView = parentObservableModelView[@jsonTag]
                                    @itemObservableModelViewUpdated()
                                    @parentItemHostWindow.itemObservableModelView(parentObservableModelView)
                                else
                                    @itemObservableModelView.removeAll()

                            updatedItemPageTitle = @itemPageTitle()
                            @menuLevelObject.label(updatedItemPageTitle)
                            break

                        when "root"
                            Console.message("... processing root")
                            # TODO: reset object members excluding child objects for which an item host exists.
                            break

                        when "select"
                            Console.message("... processing select")
                            switch @itemSelectState()
                                when "archetype"
                                    # The object is already pristine.
                                    break
                                when "element"
                                    # If the reset originated above this "element" "select"-type item, then logically
                                    # the data associated with this item has been removed and this item must be returned
                                    # to its pristine "archetype" state. Otherwise, the item is to remain as an element
                                    # and its data reset (i.e. it remains linked into the parent array) UNLESS the
                                    # forceSelectElementDetach flag is true. In this case, the attached element
                                    #
                                    
                                    if forceSelectElementDetach or (not @parentItemHostWindow.itemObservableModelView().length) or forceSelectElementRelink
                                        @itemSelectState("archetype")
                                        @itemSelectElementOrdinal(-1)
                                        newObject = {}
                                        if @namespaceMemberInitializer? and @namespaceMemberInitializer
                                            @namespaceMemberInitializer.initializeNamespace(newObject)
                                        @itemObservableModelView = ko.observable(newObject)
                                        @itemObservableModelViewUpdated()
                                        @menuLevelObject.itemVisible(false)
                                        @menuLevelObject.itemVisibilityLock = true
                                        colorObject =colorObject = @menuLevelObject.baseBackgroundColorObject().saturateByRatio(@navigatorContainer.layout.archetypeSaturateRatio).lightenByRatio(@navigatorContainer.layout.archetypeLightenRatio).shiftHue(@navigatorContainer.layout.archetypeShiftHue)
                                        @menuLevelObject.baseBackgroundColorObject(colorObject)
                                    else
                                        newObject = {}
                                        if @namespaceMemberInitializer? and @namespaceMemberInitializer
                                            @namespaceMemberInitializer.initializeNamespace(newObject)
                                        @itemObservableModelView(newObject)

                                    break

                                else
                                    throw "Unrecognized item select state!"
                                    break
                        else
                            throw "Unrecognized mvvmType specified in menu level objectDescriptor.mvvmType: #{@itemMVVMType}"


                    debugName = @itemObservableModelView.name
                    if debugName != "observable"
                        throw "itemHostObservableModelView.name != observable"



                    @updateItemPageTitle()


                catch exception
                    throw "NavigatorMenuItemHost.internalResetContainedModelView fail for item host path=#{@path}, detach=#{forceSelectElementDetach}, relink=#{forceSelectElementRelink} : #{exception}"



            # OPERATIONS

            #
            # ============================================================================
            # button click event handler delegates to the navigator container.
            @onButtonClickInsertExtension = (data_, event_, select_) =>
                try
                    @blipper.blip("28")
                    itemHostObjectToSelect = @navigatorContainer.insertExtensionFromItemHostObject(@)
                    if select_? and select_
                        @navigatorContainer.selectItemByPath(itemHostObjectToSelect.path )

                catch exception
                    Console.messageError("NavigatorMenuItemHost.onButtonClickInsertArchetype fail: #{exception}")

            #
            # ============================================================================
            @onButtonClickCloseExtension = =>
                try
                    @blipper.blip("28")
                    itemHostObjectToSelect = @navigatorContainer.closeExtension(@)
                    @navigatorContainer.selectItemByPath(itemHostObjectToSelect.path )

                catch exception
                    Console.messageError("NavigatorMenuItemHost.onButtonClickCloseExtension fail: #{exception}")

            #
            # ============================================================================
            @onButtonClickCloneExtension = =>
                try
                    @blipper.blip("28")
                    itemHostObjectToSelect = @navigatorContainer.cloneExtension(@)
                    @navigatorContainer.selectItemByPath(itemHostObjectToSelect.path )

                catch exception
                    Console.messageError("NavigatorMenuItemHost.onButtonClickCloneExtension fail: #{exception}")

            #
            # ============================================================================
            @onButtonClickRemoveExtension = =>
                try
                    @blipper.blip("28")
                    itemHostObjectToSelect = @navigatorContainer.removeExtension(@)
                    @navigatorContainer.selectItemByPath(itemHostObjectToSelect.path)
                    
                 catch exception
                    Console.messageError("NavigatorMenuItemHost.onButtonClickRemoveExtension fail: #{exception}")

            #
            # ============================================================================
            @onButtonClickResetExtension = =>
                try
                    @blipper.blip("28")
                    @navigatorContainer.resetExtension(@)

                catch exception
                    Console.messageError("NavigatorMenuItemHost.onButtonClickResetExtensionContainedModelView fail: #{exception}")


            #
            # ============================================================================
            @onLinkClickSelectExtension = (arrayIndex_, data_, event_) =>
                try
                    @blipper.blip("28")
                    # Note that this handler is called in response to clicking a link generated
                    # by a KO foreach data binding and is invoked in the context of the "extension"-type
                    # item host (i.e. the item host that contains the actual array).
                    @navigatorContainer.selectElementInExtensionArray(@, arrayIndex_)

                    @navigatorContainer.selectItemByPath(@itemExtensionSelectPath)

                catch exception
                    Console.messageError("NavigatorMenuItemHost.onLinkClickSelectExtension fail: #{exception}")

            # END: / NavigatorMenuItemHostWindow constructor try scope

        catch exception
            throw "NavigatorMenuItemHostWindow constructor fail: #{exception}"






Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SchemaNavigatorSelectedItemWindow", ( -> """

<span data-bind="if: currentlySelectedItemHost">
    <span data-bind="with: currentlySelectedItemHost">
        <div class="classNavigatorItemHostWindow">

            <span data-bind="template: { name: namespaceViewModelTemplateName }"></span>


            <span data-bind="if: itemMVVMType == 'extension'">

                <div data-bind="foreach: itemObservableModelView">

                    <div style="border-top: 1px solid #666666; padding-top: 5px; padding-bottom: 5px;" >

                    <button class="button small blue" data-bind="click: function(data_, event_) { $parent.onLinkClickSelectExtension($index(), data_, event_) }">
                        <span data-bind="text: $parent.itemExtensionSelectLabel"></span> #<span data-bind="text: $index() + 1"></span>
                    </button>

                    </div>

                </div>

            </span>

        </div><!-- classNavigatorItemHostWindow -->
    </span>
</span>

"""))

    
Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SchemaViewModelNavigatorJSONWindow", ( ->
    """
    <div class="classEncapsuleNavigatorMenuItemJSONWindow">
        <span data-bind="if: currentlySelectedItemHost">
            <img src="./img/json_file-48x48.png" style="width: 24px; heigh: 24px; border: 0px solid black; vertical-align: middle;" >
            <span data-bind="with: currentlySelectedItemHost">
                <span style="font-size: 12pt; font-weight: medium;">#{appName} <span id="idJSONSourceDownload" data-bind="html: saveJSONAsLinkHtml"></span></span>
                <pre data-bind="text: toJSON"></pre>
            </span>
            <br clear="all">
        </span>
        <span data-bind="ifnot: currentlySelectedItemHost">
            There is no active navigator selection.
        </span>
    </div>
    """))

