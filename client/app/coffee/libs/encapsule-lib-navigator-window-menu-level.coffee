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


class Encapsule.code.lib.modelview.NavigatorWindowMenuLevel
    constructor: (navigatorContainerObject_, menuObject_, level_) ->
        # \ BEGIN: constructor scope
        try
            # \ BEGIN: constructor try scope

            # Cursory validation of the incoming parameters.

            if not navigatorContainerObject_? or not navigatorContainerObject_
                throw "You must specifiy the containing navigator object as the first parameter."

            if not menuObject_? or not menuObject_
                throw "You must specify a parameter object as the second parameter."

            # Per-class instance references to construction parameters.

            @navigatorContainer = navigatorContainerObject_
            @menuObjectReference = menuObject_

            # Not imlemented yet
            # @selectActionCallback = menuObject_.selectActionCallback? and menuObject_.selectActionCallback or undefined
            # @unselectActionCallback = menuObject_.unselectActionCallback? and menuObject_.unselectActionCallback or undefined
 
            @level =    ko.observable(level_? and level_ or 0)
            @label =    ko.observable(menuObject_.menu? and menuObject_.menu or "Missing menu name!")

            @subMenus = ko.observableArray []

            @mouseOverHighlight = ko.observable(false)
            @showAsSelectedUntilMouseOut = ko.observable(false)
            @selectedItem = ko.observable(false)

            @currentlySelectedLevel = ko.observable(-1)
            @setCurrentlySelectedLevel = (level_) =>
                @currentlySelectedLevel(level_)
                

            Console.message "New menu item: level #{@level()} #{@label()}"

            if menuObject_.subMenus? and menuObject_.subMenus
                for subMenuObject in menuObject_.subMenus
                    @subMenus.push new Encapsule.code.lib.modelview.NavigatorWindowMenuLevel(@navigatorContainer, subMenuObject, @level() + 1)

            @getCssFontSize = ko.computed =>
                fontSize = Math.max( (16 - @level()), 8)
                "#{fontSize}pt"

            @getBorder = ko.computed =>
                if @selectedItem()
                    return "1px solid black"
                else
                    return "0px solid black"

            @getCssBackgroundColor = ko.computed =>
                backgroundColor = undefined
                #@navigatorContainer.currentlySelectedMenuItemLevel()

                currentlySelectedLevel = 
                if @selectedItem()
                    if @mouseOverHighlight() and not @showAsSelectedUntilMouseOut()
                        # Currently selected item and currently under the mouse cursor: Selected highlight
                        if currentlySelectedLevel == @level()
                            backgroundColor = "#FFFFFF"
                        else
                            backgroundColor = "#CCCCCC"


                    else
                        # Currently selected item and not currently under the mouse cursor: Selected color
                        backgroundColor = "#00FF00"

                else
                    if @mouseOverHighlight()
                        # Not currently selected and currently under the mouse cursor: Highlight in bright color
                        backgroundColor = "#FFFF00"

                    else
                        # Not currently selected and not currently under the mouse cursor: Default color based on level)
                        base = net.brehaut.Color("#0099CC")
                        ratio = @level() / 8
                        #base.desaturateByRatio(ratio).toString()
                        backgroundColor = base.lightenByRatio(ratio).toString()

                # (enable to research IE 10 failures) Console.message("Setting navigator menu \"#{@label()}\" background color to #{backgroundColor}")
                return backgroundColor
    
            @getCssMarginLeft = ko.computed =>
                # return "#{@level() * 2}px"
                return "2px"


            @onMouseOver = => 
                @mouseOverHighlight(true)
                return false

            @onMouseOut = =>
                @mouseOverHighlight(false)
                @showAsSelectedUntilMouseOut(false)

            @onMouseClick = =>
                @selectedItem( not @selectedItem() )
                if @selectedItem() == true
                    @showAsSelectedUntilMouseOut(true)
                    @navigatorContainer.updateSelectedMenuItem(@)
                    if @selectActionCallback? and @selectActionCallback
                        @selectActionCallback()
                else
                    @navigatorContainer.updateSelectedMenuItem(undefined)
                    @showAsSelectedUntilMouseOut(false)
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
    <div class="classSchemaViewModelNaviagatorMenuLevel" data-bind="template: { name: 'idKoTemplate_SchemaViewModelNavigatorMenuLevel', foreach: subMenus }"></div>
    </div>
    """))

