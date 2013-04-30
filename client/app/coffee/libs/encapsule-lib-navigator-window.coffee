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

            # Instances of NavigatorWindowMenuLevel objects created by this contructor.  
            @topLevelMenus = ko.observableArray []

            @menuItemPathNamespace = {}

            @currentlySelectedMenuLevel = undefined
            @currentSelectionPath = ko.observable "<no selection>"
            @currentlySelectedItemHost = ko.observable undefined

            @outerDetailLevel = ko.observable(0)
            @innerDetailLevel = ko.observable(1)

            for menuLayout in layout_.menuHierarchy
                # navigatorContainer, parentMenuLevel, layout, level
                @topLevelMenus.push new Encapsule.code.lib.modelview.NavigatorWindowMenuLevel(@, undefined, menuLayout, 0)

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
            @insertArchetype = (path_) =>
                try
                    archetypeItemHostWindow = @getItemHostWindowForPath(path_)
                catch exception
                    throw "insertArchetype fail: #{exception}"




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

            # This is a breadth-first visitor with callback dispatching based on a rank filter.
            #
            #
            # ============================================================================
            @internalVisitChildrenFromChildArray = (childMenuLevelArray_, level_, visitorCallbackUnderLimit_, generationsLimit_, visitorCallbackOverLimit_) =>
                if not (childMenuLevelArray_? and childMenuLevelArray_) then throw "Missing child menu level array."
                if not (visitorCallbackUnderLimit_? and visitorCallbackUnderLimit_) then throw "Missing required action under limit visitor callback parameter."
                visitorCallbackUnderLimit = visitorCallbackUnderLimit_? and visitorCallbackUnderLimit_ or undefined
                visitorCallbackOverLimit = visitorCallbackOverLimit_? and visitorCallbackOverLimit_ or undefined

                # If generationsLimit is negative all visited levels will be called w/the action_ callback.
                # If generationsLimit is zero, all visited levels will be called w/the actionOverLimit_
                # callback. If generationsLimit is positive N, then the first N generations of children
                # are called with the action_ callback, and N+1... with the actionOverLimit_ callback.
                #

                generationsLimit = generationsLimit_? and generationsLimit_ or 0
                levelBoundary = level_ + generationsLimit

                subLevelsFifo = [ { subLevels: childMenuLevelArray_, level: level_ + 1 } ]

                while subLevelsFifo.length
                    fifoEntry = subLevelsFifo.pop()

                    visitorCallback = undefined
                    if (generationsLimit_ == -1)
                        visitorCallback = visitorCallbackUnderLimit
                    else if (fifoEntry.level <= levelBoundary)
                        visitorCallback = visitorCallbackUnderLimit
                    else
                        visitorCallback = visitorCallbackOverLimit

                    for subLevel in fifoEntry.subLevels
                        evaluateSubLevels = true
                        if visitorCallback
                            evaluateSubLevels = visitorCallback(subLevel)
                        if evaluateSubLevels
                            subLevelSubLevels = subLevel.subMenus()
                            if subLevelSubLevels.length then subLevelsFifo.push( { subLevels: subLevelSubLevels, level: subLevel.level() + 1 } )



            #
            # ============================================================================
            @internalVisitChildren = (menuLevel_, visitorCallbackUnderLimit_, generationsLimit_, visitorCallbackOverLimit_) =>
                if not (menuLevel_ and menuLevel_) then throw "Missing menu level object parameter."
                if not (visitorCallbackUnderLimit_? and visitorCallbackUnderLimit_) then throw "Missing required action under limit visitor callback parameter."
                currentSubLevels = menuLevel_.subMenus()
                if not currentSubLevels.length then return false
                @internalVisitChildrenFromChildArray(currentSubLevels, menuLevel_.level(), visitorCallbackUnderLimit_, generationsLimit_, visitorCallbackOverLimit_)



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
                @internalVisitChildren(menuLevel_, ((level_) -> level_.selectedParent(flag_); return true ), -1, undefined)

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


            #
            # ============================================================================
            @internalUpdateSelectedMenuLevelVisibility = (selectedMenuLevel_) =>
                @internalVisitChildren(
                    selectedMenuLevel_
                    (level_) =>
                        level_.itemVisible(true)
                        return true
                    parseInt(@innerDetailLevel())
                    (level_) =>
                        level_.itemVisible(false)
                        return false
                    )

            #
            # ============================================================================
            @internalUpdateMenuLevelOuterDetailVisibilityFromChildArray = (childMenuLevelArray_, level_) =>
                Console.message("starting internalUpdateMenuLevelOuterDetailVisibilityFromChildArray on level #{level_}")
                outerDetailLevel = @outerDetailLevel()
                @internalVisitChildrenFromChildArray(
                    childMenuLevelArray_
                    level_
                    (level_) =>
                        level_.itemVisible(true)
                        Console.message("...set #{level_.label()} visible (under limit).")
                        selectedItem = level_.selectedItem()
                        selectedChild = level_.selectedChild()
                        if not (selectedChild or selectedItem)
                            Console.message("... continue traversal")
                            return true
                        if selectedChild
                            Console.message("... discovered #{level_.label()} is a parent of the current selection (under limit).")
                            @internalUpdateMenuLevelOuterDetailVisibility(level_)
                            return false
                        if selectedItem
                            Console.message("... discovered #{level_.label()} is the selected item (under limit).")
                            @internalUpdateSelectedMenuLevelVisibility(level_)
                            return false
                        throw "Shouldn't get here."
                    outerDetailLevel
                    (level_) =>
                        selectedItem = level_.selectedItem()
                        selectedChild = level_.selectedChild()
                        if not (selectedChild or selectedItem)
                            Console.message("... set #{level_.label()} not visible (over limit).")
                            level_.itemVisible(false)
                            return false
                        Console.message("... set #{level_.label()} visible (over limit).")
                        level_.itemVisible(true)
                        if selectedChild
                            Console.message("... discovered #{level_.label()} is a parent of the current selection (over limit).")
                            @internalUpdateMenuLevelOuterDetailVisibility(level_)
                            return false
                        if selectedItem
                            Console.message("... discovered #{level_.label()} is the selected item (over limit).")
                            @internalUpdateSelectedMenuLevelVisibility(level_)
                            return false
                        throw "Shouldn't get here"
                    )
                return true

            #
            # ============================================================================
            @internalUpdateMenuLevelOuterDetailVisibility = (outerMenuLevel_) =>
                @internalUpdateMenuLevelOuterDetailVisibilityFromChildArray(outerMenuLevel_.subMenus, outerMenuLevel_.level())

            #
            # ============================================================================
            @internalUpdateMenuLevelNoSelectionVisibility = =>
                # reference: @internalVisitChildrenFromChildArray = (childMenuLevelArray_, level_, visitorCallbackUnderLimit_, generationsLimit_, visitorCallbackOverLimit_) =>
                @internalVisitChildrenFromChildArray(
                    @topLevelMenus()
                    -1
                    (level_) =>
                        level_.itemVisible(true)
                        return true
                    parseInt(@innerDetailLevel())
                    (level_) =>
                        level_.itemVisible(false)
                        return false
                    )


            #
            # ============================================================================
            @updateMenuLevelVisibilities = =>
                innerDetailLevel = parseInt(@innerDetailLevel())
                outerDetailLevel = parseInt(@outerDetailLevel())

                if not (@currentlySelectedMenuLevel? and @currentlySelectedMenuLevel)
                    Console.message("Setting default navigator visibilities.")
                    @internalUpdateMenuLevelNoSelectionVisibility()
                else
                    Console.message("Setting selected item navigator visibilities.")
                    @internalUpdateMenuLevelOuterDetailVisibilityFromChildArray(@topLevelMenus(), -1)


            #
            # ============================================================================
            @updateSelectionState = (menuLevel_, flag_) =>
                unselectedSelected = menuLevel_.selectedItem() and not flag_
                @internalUpdateSelectionState(menuLevel_, flag_)
                if unselectedSelected and menuLevel_.parentMenuLevel
                    @internalUpdateSelectionState(menuLevel_.parentMenuLevel, true)
                
                @updateMouseOverState(menuLevel_, false)

                @updateMenuLevelVisibilities()



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


            # / END: constructor try scope
        catch exception
            throw "SchemaScdlNavigatorWindow fail: #{exception}"
        # / END: constructor




Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SchemaViewModelNavigator", ( -> """
outer: <input type="number" min="0" max="5" data-bind="value: outerDetailLevel" /> inner: <input type="number" min="1" max="5" data-bind="value: innerDetailLevel" /><br>
<span data-bind="template: { name: 'idKoTemplate_SchemaViewModelNavigatorMenuLevel', foreach: topLevelMenus }"></span>
"""))


