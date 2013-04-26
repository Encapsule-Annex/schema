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

            @currentSelectionLevel = ko.observable -1

            @setCurrentSelectionLevel = (selectionLevel_) =>
                @currentSelectionLevel(selectionLevel_)

            @currentSelectionPath = ko.observable "<no selection>"

            @currentlySelectedItemHost = ko.observable undefined

            # Reference to the currently selected menu item (aka a menu level class instance).
            @currentlySelectedMenuItem = undefined

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
                 
            @getItemHostWindowForPath = (path_) =>
                try
                    @validatePath(path_)
                    itemHostWindow = @menuItemPathNamespace[path_]
                    if not (itemHostWindow? and itemHostWindow)
                        throw "No menu item for path: #{path_}"
                    return itemHostWindow
                catch exception
                    throw "getItemHostWindowForPath fail: #{exception}"

            @selectItemByPath = (path_) =>
                try
                    # Currently we reach all the way inside and emulate the user.
                    # This should be refactored. Really, the mouse routine should delegate
                    # to this routine so it's exactly backwards currently. :/
                    @getItemHostWindowForPath(path_).menuLevelModelView.onMouseClick()
                catch exception
                    throw "selectItemByPath fail: #{exception}"

            @insertArchetype = (path_) =>
                try
                    archetypeItemHostWindow = @getItemHostWindowForPath(path_)
                catch exception
                    throw "insertArchetype fail: #{exception}"



            # This function is called by a menu level instance (i.e. menu item) in response
            # to a mouse click. In effect we're proxying for the menu levels here maintaining
            # a reference to the last selected menu item in order that we may inform it later
            # that the user has moved on to another selection. 
            #
            @updateSelectedMenuItem = (newSelectedMenuItemObject_) =>

                # If there's a currently selected menu item...

                if @currentlySelectedMenuItem? and @currentlySelectedMenuItem

                    # ... inform the item that it is no longer selected.
                    @currentlySelectedMenuItem.selectedItem(false)
                    if @currentlySelectedMenuItem.parentMenuLevel? and @currentlySelectedMenuItem.parentMenuLevel
                        @currentlySelectedMenuItem.parentMenuLevel.updateSelectedChild(false)
                    @currentlySelectedMenuItem.updateSelectedParent(false)

                # Update reference to currently selected item (which may be undefined)
                @currentlySelectedMenuItem = newSelectedMenuItemObject_

                if @currentlySelectedMenuItem? and @currentlySelectedMenuItem

                   @setCurrentSelectionLevel( @currentlySelectedMenuItem.level() )
                   @currentSelectionPath(@currentlySelectedMenuItem.path)
                   @currentlySelectedItemHost( @menuItemPathNamespace[@currentlySelectedMenuItem.path].itemHostModelView )
         
                else
                    @setCurrentSelectionLevel(-1)
                    @currentSelectionPath("<no selection>")
                    @currentlySelectedItemHost( undefined )

                    for topLevelMenu in @topLevelMenus()
                        topLevelMenu.showAllChildren()

            @currentMouseOverLevel = ko.observable(-1)
            @setCurrentMouseOverLevel = (currentLevel_) =>
                if (currentLevel_ == -1)
                    # Reset.
                    @currentMouseOverLevel(-1)
                else
                    if currentLevel_ > @currentMouseOverLevel()
                        @currentMouseOverLevel(currentLevel_)

            for topLevelMenu in @topLevelMenus()
                topLevelMenu.showYourselfHideYourChildren()

            # / END: constructor try scope
        catch exception
            throw "SchemaScdlNavigatorWindow fail: #{exception}"
        # / END: constructor




Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SchemaViewModelNavigator", ( -> """<span data-bind="template: { name: 'idKoTemplate_SchemaViewModelNavigatorMenuLevel', foreach: topLevelMenus }"></span>"""))


