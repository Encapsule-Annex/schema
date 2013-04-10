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
# schema-view-model-navigator.coffee
#
# Navigation bar view model.
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}
Encapsule.code.app.modelview = Encapsule.code.app.modelview? and Encapsule.code.app.modelview or Encapsule.code.app.modelview = {}

Encapsule.runtime = Encapsule.runtime? and Encapsule.runtime or @Encapsule.runtime = {}
Encapsule.runtime.app = Encapsule.runtime.app? and Encapsule.runtime.app or @Encapsule.runtime.app = {}


Encapsule.code.app.modelview.ScdlNavigatorWindowLayout = {
    title: "SCDL Navigator"
    menuHierarchy: [
        {
            menu: "Catalogues"
            subMenus: [
                {
                    menu: "Catalogue"
                    subMenus: [
                        {
                            menu: "Specifications"
                            subMenus: [
                                {
                                    menu: "Specification"
                                    subMenus: [
                                        {
                                            menu: "Systems"
                                            subMenus: [
                                                {
                                                    menu: "System"
                                                    subMenus: [
                                                        {
                                                            menu: "Sockets"
                                                            subMenus: [
                                                                {
                                                                    menu: "Socket"
                                                                }
                                                            ] # Sockets submenus
                                                        } # 
                                                    ] # System submenus
                                                } # System
                                            ] # Systems submenus
                                        } # Systems
                                    ] # Specification submenus
                                } # Specification
                            ] # Specifications submenu
                        } # Specifications
                        {
                            menu: "Models"
                            subMenus: [
                                {
                                    menu: "Types"
                                    subMenus: [
                                        {
                                            menu: "Type"
                                        } # Type
                                    ] # Types submenus
                                } # Types
                                {
                                    menu: "Machines"
                                    subMenus: [
                                        {
                                            menu: "Machine"
                                            subMenus: [
                                                {
                                                    menu: "Pins"
                                                    subMenus: [
                                                        {
                                                            menu: "Inputs"
                                                            subMenus: [
                                                                {
                                                                    menu: "Input"
                                                                } # Inputs submenus
                                                            ] # Inputs submenus
                                                        } # Inputs
                                                        {
                                                            menu: "Outputs"
                                                            subMenus: [
                                                                {
                                                                    menu: "Output"
                                                                } # Output
                                                            ] # Outputs submenus
                                                        } # Outputs
                                                    ] # Pins submenus
                                                } # Pins
                                                {
                                                    menu: "States"
                                                    subMenus: [
                                                        {
                                                            menu: "State"
                                                            subMenus: [
                                                                {
                                                                    menu: "Actions"
                                                                    subMenus: [
                                                                        {
                                                                            menu: "Entry"
                                                                        } # Entry
                                                                        {
                                                                            menu: "Exit"
                                                                        } # Exit
                                                                    ] # Actions submenus
                                                                } # Actions
                                                                {
                                                                    menu: "Transitions"
                                                                    subMenus: [
                                                                        {
                                                                            menu: "Transition"
                                                                        } # Transition
                                                                    ] # Transitions submenus
                                                                } # Transitions
                                                            ] # State submenus
                                                        } # State
                                                    ] # States submenus
                                                } # States
                                            ] # Machine submenus
                                        } # Machine
                                    ] # Machines submenus
                                } # Machines
                            ] # Models submenus
                        } # Models
                    ] # Catalogue submenu
                } # Catalogue
            ] # Catalogues submenu
        } # Catalogues
    ] # ScdlNavigatorWindowLayout
} # layout object    
    





class Encapsule.code.app.modelview.SchemaScdlNavigatorMenuLevel

    # params = {
    #     label: "Display label"
    #     }

    constructor: (navigatorContainerObject_, menuObject_, level_) ->
        # \ BEGIN: constructor scope
        try
            # \ BEGIN: constructor try scope

            if not navigatorContainerObject_? or not navigatorContainerObject_
                throw "You must specifiy the containing navigator object as the first parameter."

            if not menuObject_? or not menuObject_
                throw "You must specify a parameter object as the second parameter."

            @navigatorContainer = navigatorContainerObject_

            # Not imlemented yet
            # @selectActionCallback = menuObject_.selectActionCallback? and menuObject_.selectActionCallback or undefined
            # @unselectActionCallback = menuObject_.unselectActionCallback? and menuObject_.unselectActionCallback or undefined
 
            @level =    ko.observable(level_? and level_ or 0)
            @label =    ko.observable(menuObject_.menu? and menuObject_.menu or "Missing menu name!")
            @subMenus = ko.observableArray []

            @mouseOverHighlight = ko.observable(false)
            @selectedItem = ko.observable(false)

            Console.message "New menu item: level #{@level()} #{@label()}"

            if menuObject_.subMenus? and menuObject_.subMenus
                for subMenuObject in menuObject_.subMenus
                    @subMenus.push new Encapsule.code.app.modelview.SchemaScdlNavigatorMenuLevel(@navigatorContainer, subMenuObject, @level() + 1)

            @getCssFontSize = =>
                fontSize = Math.max( (14 - @level()), 8)
                "#{fontSize}pt"

            @getCssBackgroundColor = =>
                if @selectedItem()
                    if @mouseOverHighlight()
                        # Currently selected item and currently under the mouse cursor: Selected highlight
                        "#FFFF99"

                    else
                        # Currently selected item and not currently under the mouse cursor: Selected color
                        "#00FF00"

                else
                    if @mouseOverHighlight()
                        # Not currently selected and currently under the mouse cursor: Highlight in bright color
                        "#FFFF00"

                    else
                        # Not currently selected and not currently under the mouse cursor: Default color based on level)
                        base = net.brehaut.Color("#0099CC")
                        ratio = @level() / 10
                        base.desaturateByRatio(ratio).toString()
    
            @getCssMarginLeft = =>
                "#{@level() * 10}px"

            @onMouseOver = => 
                @mouseOverHighlight(true)

            @onMouseOut = =>
                @mouseOverHighlight(false)

            @onMouseClick = =>
                @selectedItem( not @selectedItem() )
                if @selectedItem() == true
                    @navigatorContainer.updateSelectedMenuItem(@)
                    if @selectActionCallback? and @selectActionCallback
                        @selectActionCallback()
                else
                    @navigatorContainer.updateSelectedMenuItem(undefined)
                    if @unselectActionCallback? and @unselectActionCallback
                        @unselectActionCallback()

            # / END: constructor try scope
        catch exception
            throw "SchemaScdlNavigatorMenuLevel fail: #{exception}"
        # / END: constructor


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SchemaViewModelNavigatorMenuLevel", ( ->
    """
    <div class="classSchemaViewModelNavigatorMenuLevel classMouseCursorPointer"
    data-bind="style: { fontSize: getCssFontSize(), paddingLeft: getCssMarginLeft(), backgroundColor: getCssBackgroundColor()},
    event: { mouseover: onMouseOver, mouseout: onMouseOut, click: onMouseClick }">
        <span data-bind="text: label"></span>
    </div>
    <div class="classSchemaViewModelNaviagatorMenuLevel" data-bind="template: { name: 'idKoTemplate_SchemaViewModelNavigatorMenuLevel', foreach: subMenus }"></div>
    """))


class Encapsule.code.app.modelview.SchemaScdlNavigatorWindow
    constructor: (layout_) ->
        # \ BEGIN: constructor
        try
            # \ BEGIN: constructor try scope
            Console.message "Initializing #{appName} navigator data model."

            if not layout_? then throw "Missing layout parameter."
            if not layout_ then throw "Missing layout parameter value."

            @title = layout_.title

            @topLevelMenus = ko.observableArray []

            for menuObject in layout_.menuHierarchy
                @topLevelMenus.push new Encapsule.code.app.modelview.SchemaScdlNavigatorMenuLevel(@, menuObject, 0)


            @currentlySelectedMenuItem = undefined

            @updateSelectedMenuItem = (newSelectedMenuItemObject_) =>
                if @currentlySelectedMenuItem? and @currentlySelectedMenuItem
                    @currentlySelectedMenuItem.selectedItem(false)
                @currentlySelectedMenuItem = newSelectedMenuItemObject_


            # / END: constructor try scope
        catch exception
            throw "SchemaScdlNavigatorWindow fail: #{exception}"
        # / END: constructor




Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SchemaViewModelNavigator", ( ->
    """
    <span data-bind="template: { name: 'idKoTemplate_SchemaViewModelNavigatorMenuLevel', foreach: topLevelMenus }"></span>
    """))
