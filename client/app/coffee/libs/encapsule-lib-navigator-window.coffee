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

class Encapsule.code.lib.modelview.NavigatorWindow
    constructor: (layout_) ->
        # \ BEGIN: constructor
        try
            # \ BEGIN: constructor try scope
            Console.message "Initializing #{appName} navigator data model."

            if not layout_? then throw "Missing layout parameter."
            if not layout_ then throw "Missing layout parameter value."
            
            @layout = layout_

            @title = layout_.title

            @selectionUpdatedCallback = layout_.externalIntegration? and layout_.externalIntegration and layout_.externalIntegration.fnNotifyPathChange? and layout_.externalIntegration.fnNotifyPathChange or undefined

            # Instances of NavigatorWindowMenuLevel objects created by this contructor.  
            @menuItemPathNamespace = {}

            @currentlySelectedMenuLevel = undefined
            @currentSelectionPath = ko.observable "<no selection>"
            @currentlySelectedItemHost = ko.observable undefined

            detailBelowSelectDefault = 0
            if layout_.detailBelowSelectDefault?
                value = layout_.detailBelowSelectDefault
                if (value >= 0) and (value < 256)
                    detailBelowSelectDefault = value
            else
                detailBelowSelectDefault = 0

            detailAboveSelectDefault = 0
            if layout_.detailAboveSelectDefault?
                value = layout_.detailAboveSelectDefault
                if (value > 0) and (value < 256)
                    detailAboveSelectDefault = value

            @detailBelowSelect = ko.observable(detailBelowSelectDefault)
            @detailAboveSelect = ko.observable(detailAboveSelectDefault)


            @resetDetailBelowSelect = =>
                @detailBelowSelect(detailBelowSelectDefault)

            @incrementDetailBelowSelect = =>
                detail = @detailBelowSelect()
                if detail < 255
                    @detailBelowSelect(detail + 1)

            @decrementDetailBelowSelect = =>
                detail = @detailBelowSelect()
                if detail > 0
                    @detailBelowSelect(detail - 1)

            @explodeDetailBelowSelect = =>
                @detailBelowSelect(255)

            @resetDetailAboveSelect = =>
                @detailAboveSelect(detailAboveSelectDefault)

            @incrementDetailAboveSelect = =>
                detail = @detailAboveSelect()
                if detail < 255
                    @detailAboveSelect(detail + 1)

            @decrementDetailAboveSelect = =>
                detail = @detailAboveSelect()
                if detail > 1
                    @detailAboveSelect(detail - 1)

            @explodeDetailAboveSelect = =>
                @detailAboveSelect(255)

            @resetDetail = =>
                @resetDetailBelowSelect()
                @resetDetailAboveSelect()


 


            # External API function

            #
            # ============================================================================
            @validatePath = (path_) =>
                try
                    if not path_ then throw "Missing path parameter."
                    if not path_ then throw "Missing path parameter value."
                    return true
                catch exception
                    throw "validatePath fail: #{exception}"
                 


            #
            # ============================================================================
            @getItemPathNamespaceObject = (path_) =>
                try
                    @validatePath(path_)
                    itemHostWindow = @menuItemPathNamespace[path_]
                    if not (itemHostWindow? and itemHostWindow)
                        throw "No menu item for path: #{path_}"
                    return itemHostWindow
                catch exception
                    throw "getItemHostWindowForPath fail: #{exception}"


            #
            # ============================================================================
            @selectItemByPath = (path_) =>
                try
                    targetMenuLevelObject = undefined
                    if (not (path_? and path_)) or (path_ == "")
                        targetMenuLevelObject = @rootMenuLevel
                    else
                        targetMenuLevelObject = @getItemPathNamespaceObject(path_).menuLevelModelView
                    @updateSelectionState(targetMenuLevelObject, true)
                catch exception
                    throw "NavigatorWindow.selectItemByPath fail: #{exception}"
                    
            

            #
            # ============================================================================
            @insertArchetypeFromItemHostObject = (itemHostObject_) =>
                try
                    if not (itemHostObject_? and itemHostObject_)
                        throw "Missing item host object reference parameter."

                    if itemHostObject_.itemMVVMType != "select"
                        throw "Invalid request: The specified item host object is not a selection point."

                    itemSelectState = itemHostObject_.itemSelectState? and itemHostObject_.itemSelectState and itemHostObject_.itemSelectState() or undefined
                    if not (itemSelectState? and itemSelectState)
                        throw "Invalid request: The specified item host object is missing the expected itemSelectState property."

                    parentItemHostObject = itemHostObject_.parentItemHostWindow
                    if not (parentItemHostObject? and parentItemHostObject)
                        throw "Unable to resolve parent item host object reference."

                    if parentItemHostObject.itemMVVMType != "extension"
                        throw "Specified item host's parent object type doesn't support this operation. This is an error in your layout declaration."

                    # Update the parent item host's contained obervable array.

                    # Package reference to this item's hosted observable view to push into parent array.
                    newArrayElement = {}
                    newArrayElement[itemHostObject_.jsonTag] = itemHostObject_.itemObservableModelView

                    # Unbox/modify/rebox the parent array.
                    parentArray = parentItemHostObject.itemObservableModelView()
                    parentArray.push(newArrayElement)
                    parentItemHostObject.itemObservableModelView(parentArray)
 
                    return true

                catch exception
                    throw "NavigatorWindow.insertArchetypeFromItemHostObject fail: #{exception}"


            #
            # ============================================================================
            @insertArchetypeFromPath = (path_) =>
                try
                    @insertArchetypeFromItemHostObject(@getItemHostWindowForPath(path_))
                catch exception
                    throw "NavigatorWindow.insertArchetypeFromPath fail: #{exception}"




            # Internal menu level traversal helper methods.

            #
            # ============================================================================
            @internalVisitParents = (menuLevel_, action_) =>
                if not (menuLevel_ and menuLevel_) then return
                if not (action_? and action_) then return
                if not (menuLevel_.parentMenuLevel? and menuLevel_.parentMenuLevel) then return
                parentLevel = menuLevel_.parentMenuLevel
                while parentLevel? and parentLevel
                    action_(parentLevel)
                    parentLevel = parentLevel.parentMenuLevel

            # BFS visitor.
            #
            #
            # ============================================================================
            @internalVisitChildrenFromChildArray = (childMenuLevelArray_, level_, visitorCallback_, visitorCallbackContext_) =>

                if not (childMenuLevelArray_? and childMenuLevelArray_) then throw "Missing child menu level array."
                subLevelsQueue = [ { subLevels: childMenuLevelArray_, level: level_ + 1 } ]
                while subLevelsQueue.length
                    queueEntry = subLevelsQueue.pop()
                    for subLevel in queueEntry.subLevels
                        evaluateSubLevels = true
                        if visitorCallback_? and visitorCallback_
                            evaluateSubLevels = visitorCallback_(subLevel, visitorCallbackContext_)
                        if evaluateSubLevels
                            subLevelSubLevels = subLevel.subMenus()
                            if subLevelSubLevels.length
                                subLevelsQueue.unshift( { subLevels: subLevelSubLevels, level: subLevel.level() + 1 } )

            #
            # ============================================================================
            @internalVisitChildren = (menuLevel_, visitorCallback_, visitorCallbackContext_) =>
                if not (menuLevel_ and menuLevel_) then throw "Missing menu level object parameter."
                currentSubLevels = menuLevel_.subMenus()
                if not currentSubLevels.length
                    return false
                @internalVisitChildrenFromChildArray(currentSubLevels, menuLevel_.level(), visitorCallback_, visitorCallbackContext_)



            #
            # Internal methods called by the menu items in response to various events.
            # These methods should not be called by other methods defined by this class
            # or by consumers of this class for risk of breaking the fragile CSS state
            # model of the menu level class instances.

            #
            # ============================================================================
            @onMenuLevelMouseDoubleClick = (menuLevel_) =>


            # Responsible for updating all required menu level objects' selectedItem, selectedChild, and selectedParent observable flags.
            #
            # ============================================================================
            @internalUpdateLevelsSelectionState = (menuLevel_, flag_) =>
                if not (menuLevel_? and menuLevel_) then throw "You must specify a valid menu level reference."
                menuLevel_.selectedItem(flag_)
                menuLevel_.showAsSelectedUntilMouseOut(flag_)
                @internalVisitParents(menuLevel_,  ((level_) => level_.selectedChild(flag_)))
                @internalVisitChildren(menuLevel_, ((level_) -> level_.selectedParent(flag_); return true ))

            #
            # ============================================================================
            @internalUpdateSelectionState = (menuLevel_, flag_) =>

                if flag_ 
                    # Set the navigator container's selection to the specified menu level.

                    # If the navigator container already as a selection, clear it.
                    if @currentlySelectedMenuLevel
                        @internalUpdateSelectionState(@currentlySelectedMenuLevel, false)

                    @internalUpdateLevelsSelectionState(menuLevel_, true)

                    @currentlySelectedMenuLevel = menuLevel_
                    @currentSelectionPath(menuLevel_.path)
                    @currentlySelectedItemHost(@getItemPathNamespaceObject(menuLevel_.path).itemHostModelView)


                else
                    # Unselect the specified menu level and set the navigator container's selection to undefined.

                    @internalUpdateLevelsSelectionState(menuLevel_, false)

                    @currentlySelectedMenuLevel = undefined
                    @currentSelectionPath("<no selection>")
                    @currentlySelectedItemHost(undefined)




            #
            # ============================================================================

            @updateMenuLevelVisibilities = =>
                activeSelectionFlag = @currentlySelectedMenuLevel? and @currentlySelectedMenuLevel
                bfsVisitorContext = {}
                @internalVisitChildren(
                    @rootMenuLevel,
                    (levelObject_, bfsContext_) =>
                        selectedItem = levelObject_.selectedItem()
                        selectedChild = levelObject_.selectedChild() # i.e. above the selection
                        selectedParent = levelObject_.selectedParent() # i.e. below the selection
                        inSelectionPath = selectedItem or selectedChild # i.e. the selection and above
                        generationsFromSelectionPath = undefined
                        if (not inSelectionPath) or selectedParent
                            generationsFromSelectionPath = levelObject_.parentMenuLevel.generationsFromSelectionPath + 1
                        else
                            generationsFromSelectionPath = 0
                        levelObject_.generationsFromSelectionPath = generationsFromSelectionPath
                        generationsThreshold = undefined
                        if not selectedParent
                             generationsThreshold = parseInt(@detailBelowSelect())
                        else
                             generationsThreshold = parseInt(@detailAboveSelect())
                        visible = undefined
                        if inSelectionPath
                            visible = true
                        else
                            visible = generationsFromSelectionPath <= generationsThreshold
                        levelObject_.itemVisible(visible)
                        return visible
                    bfsVisitorContext
                    )
                return true


            #
            # ============================================================================
            @updateSelectionState = (menuLevel_, flag_) =>
                unselectedSelected = menuLevel_.selectedItem() and not flag_
                @internalUpdateSelectionState(menuLevel_, flag_)
                if unselectedSelected and menuLevel_.parentMenuLevel
                    @internalUpdateSelectionState(menuLevel_.parentMenuLevel, true)
                @updateMouseOverState(menuLevel_, false)
                @updateMenuLevelVisibilities()
                if @selectionUpdatedCallback? and @selectionUpdatedCallback
                    @selectionUpdatedCallback(@, @currentlySelectedMenuLevel.path)





            # Helper method
            #
            # ============================================================================
            @toggleSelectionState = (menuLevel_) =>
                @updateSelectionState(menuLevel_, not menuLevel_.selectedItem())
                
                
            # Responsible for updating all required menu level objects' mouseOverHighlight, mouseOverChild, and mouseOverParent observable flags.
            #
            # ============================================================================
            @internalUpdateLevelsMouseOverState = (menuLevel_, flag_) =>
                menuLevel_.mouseOverHighlight(flag_)
                @internalVisitParents(menuLevel_, ((level_) -> level_.mouseOverChild(flag_)))
                @internalVisitChildren(menuLevel_, ((level_) -> level_.mouseOverParent(flag_); return true ), -1, undefined)

            #
            # ============================================================================
            @updateMouseOverState = (menuLevel_, flag_) =>
                @internalUpdateLevelsMouseOverState(menuLevel_, flag_)



            newMenuHierarchy = [
                {
                    jsonTag: layout_.jsonTag
                    label: layout_.label
                    objectDescriptor: {
                        mvvmType: "root"
                        description: layout_.description
                    }
                    subMenus: layout_.menuHierarchy
                }
            ]
            # Patch the incoming layout
            @layout.menuHierarchy = newMenuHierarchy

            Console.message("Instantiating root menu level for navigator.")
            @rootMenuLevel = new Encapsule.code.lib.modelview.NavigatorWindowMenuLevel(@, undefined, @layout.menuHierarchy[0], -1)

            createItemHost = (levelObject_) =>
                itemPathNamespaceObject = @getItemPathNamespaceObject(levelObject_.path)
                if not (itemPathNamespaceObject? and itemPathNamespaceObject)
                    throw "Cannot resolve item path namespace object."
                itemPathNamespaceObject.itemHostModelView = new Encapsule.code.lib.modelview.NavigatorMenuItemHostWindow(@, levelObject_)
                return true;

            createItemHost(@rootMenuLevel)

            @internalVisitChildren(@rootMenuLevel, ( (level_) =>

                createItemHost(level_) ), -1, undefined)

            #
            # ============================================================================
            @detailWorker = ko.computed =>
                detailBelowSelect = @detailBelowSelect()
                detailAboveSelect = @detailAboveSelect()
                return @updateMenuLevelVisibilities()


            # Last step in constructor is to set the default view.
            @updateSelectionState(@rootMenuLevel, true)
            if layout_.initialSelectionPath? and layout_.initialSelectionPath
                @selectItemByPath(layout_.initialSelectionPath)


            # / END: constructor try scope
        catch exception
            throw "SchemaScdlNavigatorWindow fail: #{exception}"
        # / END: constructor




Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SchemaViewModelNavigator", ( -> """

<div class="classNavigatorViewDetailControlPanel">

<button style="width: 32px;" size="1" class="button small gray" data-bind="event: { click: decrementDetailBelowSelect }" title="Decrease detail below selection.">&minus;</button>

<button style="width: 32px;" size="1" class="button small black" data-bind="event: { click: resetDetailBelowSelect }" title="Reset detail below selection.">&bull;</button>

<button style="width: 32px;" size="1" class="button small black" data-bind="event: { click: resetDetailAboveSelect }" title="Reset detail above selection.">&bull;</button>

<button style="width: 32px;" size="1" class="button small gray" data-bind="event: { click: decrementDetailAboveSelect }" title="Decrease detail above selection.">-</button>


<br>


<button style="width: 32px;" size="1" class="button small blue" data-bind="event: { click: explodeDetailBelowSelect }" title="Explode detail below selection.">&infin;</button>

<button style="width: 32px;" size="1" class="button small white" data-bind="event: { click: incrementDetailBelowSelect }" title="Increase detail below selection.">+</button>
<span data-bind="text: detailBelowSelect"></span>
&gt;
<button style="width: 32px;" size="1" class="button small black" data-bind="event: { click: resetDetail }" title="Reset detail.">&empty;</button>
&lt;
<span data-bind="text: detailAboveSelect"></span>
<button style="width: 32px;" size="1" class="button small white" data-bind="event: { click: incrementDetailAboveSelect }" title="Increase detail above selection.">+</button>
<button style="width: 32px;" size="1" class="button small blue" data-bind="event: { click: explodeDetailAboveSelect }" title="Explode detail above selection.">&infin;</button>

</div>

<span data-bind="template: { name: 'idKoTemplate_SchemaViewModelNavigatorMenuLevel', foreach: rootMenuLevel.subMenus }"></span>
"""))


