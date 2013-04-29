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


            for menuLayout in layout_.menuHierarchy
                # navigatorContainer, parentMenuLevel, layout, level
                @topLevelMenus.push new Encapsule.code.lib.modelview.NavigatorWindowMenuLevel(@, undefined, menuLayout, 0)

            # External API function

            @validatePath = (path_) =>
                try
                    if not path_ then throw "Missing path parameter."
                    if not path_ then throw "Missing path parameter value."
                    return true
                catch exception
                    throw "validatePath fail: #{exception}"
                 
            @getItemPathNamespaceObject = (path_) =>
                try
                    @validatePath(path_)
                    itemHostWindow = @menuItemPathNamespace[path_]
                    if not (itemHostWindow? and itemHostWindow)
                        throw "No menu item for path: #{path_}"
                    return itemHostWindow
                catch exception
                    throw "getItemHostWindowForPath fail: #{exception}"


            @insertArchetype = (path_) =>
                try
                    archetypeItemHostWindow = @getItemHostWindowForPath(path_)
                catch exception
                    throw "insertArchetype fail: #{exception}"




            # Internal menu level traversal helper methods.

            @internalVisitParents = (menuLevel_, action_) =>
                if not (menuLevel_ and menuLevel_) then return
                if not (action_? and action_) then return
                if not (menuLevel_.parentMenuLevel? and menuLevel_.parentMenuLevel) then return
                parentLevel = menuLevel_.parentMenuLevel
                while parentLevel? and parentLevel
                    action_(parentLevel)
                    parentLevel = parentLevel.parentMenuLevel

            @internalVisitChildren = (menuLevel_, action_) =>
                if not (menuLevel_ and menuLevel_) then return
                if not (action_? and action_) then return
                currentSubLevels = menuLevel_.subMenus()
                subLevelsFifo = []
                if currentSubLevels.length then subLevelsFifo.push(currentSubLevels)
                while subLevelsFifo.length
                    currentSubLevels = subLevelsFifo.pop()
                    for subLevel in currentSubLevels
                        action_(subLevel)
                        subLevelSubLevels = subLevel.subMenus()
                        if subLevelSubLevels.length then subLevelsFifo.push(subLevelSubLevels)









            #
            # Internal menu level visibility helper methods.

            @internalExplodeImplodeMenuLevel = (menuLevel_, flag_) =>
                @internalVisitChildren(menuLevel_, ( (level_) => level_.itemVisible(flag_) ))


            # if flag_ and showChildDepth_ == -1 implies show just this menu level
            # if flag_ and showChildDepth_ == 0 implies show this menu level and explode children
            # if flag_ and showChildDepth_ > 0 implies show this menu level and explode to specified depth
            @internalShowMenuLevel = (menuLevel_, flag_, showChildDepth_) =>
                if flag_
                    menuLevel_.itemVisible(true)
                    if showChildDepth_ != 0
                        return
                    if showChildDepth_ == 0
                        @internalExplodeImplodeMenuLevel(menuLevel_, true)
                        return
                else
                    menuLevel_.itemVisible(false)
                    @internalExplodeImplodeMenuLevel(menuLevel_, false)
                    



            #
            # Internal methods called by the menu items in response to various events.
            # These methods should not be called by other methods defined by this class
            # or by consumers of this class for risk of breaking the fragile CSS state
            # model of the menu level class instances.

            @onMenuLevelMouseDoubleClick = (menuLevel_) =>


            # Responsible for updating all required menu level objects' selectedItem, selectedChild, and selectedParent observable flags.
            @internalUpdateLevelsSelectionState = (menuLevel_, flag_) =>
                if not (menuLevel_? and menuLevel_) then throw "You must specify a valid menu level reference."
                menuLevel_.selectedItem(flag_)
                menuLevel_.showAsSelectedUntilMouseOut(flag_)
                @internalVisitParents(menuLevel_, ((level_) -> level_.selectedChild(flag_)))
                @internalVisitChildren(menuLevel_, ((level_) -> level_.selectedParent(flag_)))

            @internalUpdateSelectionState = (menuLevel_, flag_) =>

                if flag_ 
                    # Set the navigator container's selection to the specified menu level.

                    # If the navigator container already as a selection, clear it.
                    if @currentlySelectedMenuLevel
                        @internalUpdateSelectionState(@currentlySelectedMenuLevel, false)

                    @internalUpdateLevelsSelectionState(menuLevel_, true)
                    @currentlySelectedMenuLevel = menuLevel_
                    @currentSelectionPath(menuLevel_.path)
                    currentlySelectedItemHostWindow = @getItemPathNamespaceObject(menuLevel_.path).itemHostModelView
                    @currentlySelectedItemHost(currentlySelectedItemHostWindow)

                else
                    # Unselect the specified menu level and set the navigator container's selection to undefined.

                    @internalUpdateLevelsSelectionState(menuLevel_, false)
                    @currentlySelectedMenuLevel = undefined
                    @currentSelectionPath("<no selection>")
                    @currentlySelectedItemHost(undefined)

            @updateSelectionState = (menuLevel_, flag_) =>
                unselectedSelected = menuLevel_.selectedItem() and not flag_
                @internalUpdateSelectionState(menuLevel_, flag_)
                if unselectedSelected and menuLevel_.parentMenuLevel
                    @internalUpdateSelectionState(menuLevel_.parentMenuLevel, true)
                @updateMouseOverState(menuLevel_, false)


            # Helper method
            @toggleSelectionState = (menuLevel_) =>
                @updateSelectionState(menuLevel_, not menuLevel_.selectedItem())
                
                
            # Responsible for updating all required menu level objects' mouseOverHighlight, mouseOverChild, and mouseOverParent observable flags.
            @internalUpdateLevelsMouseOverState = (menuLevel_, flag_) =>
                menuLevel_.mouseOverHighlight(flag_)
                @internalVisitParents(menuLevel_, ((level_) -> level_.mouseOverChild(flag_)))
                @internalVisitChildren(menuLevel_, ((level_) -> level_.mouseOverParent(flag_)))

            @updateMouseOverState = (menuLevel_, flag_) =>
                @internalUpdateLevelsMouseOverState(menuLevel_, flag_)


            # / END: constructor try scope
        catch exception
            throw "SchemaScdlNavigatorWindow fail: #{exception}"
        # / END: constructor




Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SchemaViewModelNavigator", ( -> """<span data-bind="template: { name: 'idKoTemplate_SchemaViewModelNavigatorMenuLevel', foreach: topLevelMenus }"></span>"""))


