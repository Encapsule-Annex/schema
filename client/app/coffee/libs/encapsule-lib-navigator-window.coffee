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

            @topLevelMenus = ko.observableArray []

            @currentSelectionLevel = ko.observable -1

            @setCurrentSelectionLevel = (selectionLevel_) =>
                @currentSelectionLevel(selectionLevel_)

            @currentSelectionPath = ko.observable "<no selection>"

            # Reference to the currently selected menu item (aka a menu level class instance).
            @currentlySelectedMenuItem = undefined

            for menuObject in layout_.menuHierarchy
                # parameters:
                # 1st: reference to this, the navigator root object.
                # 2nd: reference to menu item's parent. Top-level objects have no parent and are set to undefined.
                # 3rd: menu item level. Top-level objects are set to level=0 by convention.
                # 4th: the parent menu item's expanded path string. Top-level objects that have no parent are set to undefined by convention.
                @topLevelMenus.push new Encapsule.code.lib.modelview.NavigatorWindowMenuLevel(@, undefined, 0, menuObject, undefined)


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
         
                else
                    @setCurrentSelectionLevel(-1)
                    @currentSelectionPath("<no selection>")




            @currentMouseOverLevel = ko.observable(-1)
            @setCurrentMouseOverLevel = (currentLevel_) =>
                if (currentLevel_ == -1)
                    # Reset.
                    @currentMouseOverLevel(-1)
                else
                    if currentLevel_ > @currentMouseOverLevel()
                        @currentMouseOverLevel(currentLevel_)

            # / END: constructor try scope
        catch exception
            throw "SchemaScdlNavigatorWindow fail: #{exception}"
        # / END: constructor




Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SchemaViewModelNavigator", ( ->
    """
    <span data-bind="template: { name: 'idKoTemplate_SchemaViewModelNavigatorMenuLevel', foreach: topLevelMenus }"></span>
    """))

Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SchemaViewModelNavigatorPathWindow", ( ->  """<div><span data-bind="text: title"></span> ::
        <span data-bind="text: currentSelectionPath"></span>
        <span data-bind="text: currentSelectionLevel"></span>
        <span data-bind="text: currentMouseOverLevel"></span></div>"""))