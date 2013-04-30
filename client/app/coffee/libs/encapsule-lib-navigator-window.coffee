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

            @menuItemPathNamespace = {}

            @currentlySelectedMenuLevel = undefined
            @currentSelectionPath = ko.observable "<no selection>"
            @currentlySelectedItemHost = ko.observable undefined

            @outerDetailLevel = ko.observable(0)
            @innerDetailLevel = ko.observable(1)

            newMenuHierarchy = [
                {
                    jsonTag: layout_.jsonTag
                    label: layout_.label
                    objectDescriptor: {
                        type: "object"
                        origin: "root"
                        classification: "structure"
                        role: "namespace"
                    }
                    subMenus: layout_.menuHierarchy
                }
            ]
            # Patch the incoming layout
            @layout.menuHierarchy = newMenuHierarchy

            @rootMenuLevel = new Encapsule.code.lib.modelview.NavigatorWindowMenuLevel(@, undefined, @layout.menuHierarchy[0], -1)

            ###
            for menuLayout in @layout.menuHierarchy
                # navigatorContainer, parentMenuLevel, layout, level
                @topLevelMenus.push new Encapsule.code.lib.modelview.NavigatorWindowMenuLevel(@, undefined, menuLayout, 0)
            ###

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
                             generationsThreshold = parseInt(@outerDetailLevel())
                        else
                             generationsThreshold = parseInt(@innerDetailLevel())
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


            #
            # ============================================================================
            @detailWorker = ko.computed =>
                outerDetailLevel = @outerDetailLevel()
                innerDetailLevel = @innerDetailLevel()
                @updateMenuLevelVisibilities()
                return "#{outerDetailLevel} #{innerDetailLevel}"


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


            # Last step in constructor is to set the default view.
            @updateSelectionState(@rootMenuLevel, true)


            # / END: constructor try scope
        catch exception
            throw "SchemaScdlNavigatorWindow fail: #{exception}"
        # / END: constructor




Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SchemaViewModelNavigator", ( -> """
<div style="font-family: Arial; font-size: 8pt; font-weight: normal; text-align: center; margin-bottom: 10px; ">
    view select detail
    above <input type="number" min="0" max="15" data-bind="value: outerDetailLevel" />
    below <input type="number" min="1" max="15" data-bind="value: innerDetailLevel" />
</div>
<span data-bind="template: { name: 'idKoTemplate_SchemaViewModelNavigatorMenuLevel', foreach: rootMenuLevel.subMenus }"></span>
"""))


