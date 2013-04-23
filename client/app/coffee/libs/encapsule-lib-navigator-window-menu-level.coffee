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
    constructor: (navigatorContainerObject_, parentMenuLevel_, yourNewLayoutObject_, yourNewLevel_) ->
        # \ BEGIN: constructor scope
        try
            # \ BEGIN: constructor try scope

            # Cursory validation of the incoming parameters.

            if not navigatorContainerObject_? or not navigatorContainerObject_
                throw "You must specifiy the containing navigator object as the first parameter."

            if not yourNewLayoutObject_? or not yourNewLayoutObject_
                throw "You must specify a layout object as the third parameter."

            # Per-class instance references to construction parameters.

            @navigatorContainer = navigatorContainerObject_
            @parentMenuLevel = parentMenuLevel_
            @layoutObject = yourNewLayoutObject_

            # Not imlemented yet
            # @selectActionCallback = layoutObject_.selectActionCallback? and layoutObject_.selectActionCallback or undefined
            # @unselectActionCallback = layoutObject_.unselectActionCallback? and layoutObject_.unselectActionCallback or undefined
 
            @level =    ko.observable(yourNewLevel_? and yourNewLevel_ or 0)
            @label =    ko.observable(yourNewLayoutObject_.jsonTag? and yourNewLayoutObject_.jsonTag or "Missing menu name!")
            @jsonTag =  yourNewLayoutObject_.jsonTag
            @path =     parentMenuLevel_? and parentMenuLevel_ and parentMenuLevel_.path? and "#{parentMenuLevel_.path}.#{@jsonTag}" or "#{@jsonTag}"

            @itemVisible = ko.observable true

            @subMenus = ko.observableArray []

            @mouseOverChild = ko.observable(false)
            @mouseOverParent = ko.observable(false)
            @mouseOverHighlight = ko.observable(false)

            @showAsSelectedUntilMouseOut = ko.observable(false)
            @selectedItem = ko.observable(false)
            @selectedChild = ko.observable(false)
            @selectedParent = ko.observable(false)

            @currentlySelectedLevel = ko.observable(-1)

            @setCurrentlySelectedLevel = (level_) =>
                @currentlySelectedLevel(level_)
                
            Console.message "New menu item: level #{@level()} #{@label()}"

            itemPathNamespaceObject = {}
            itemPathNamespaceObject.menuLevelModelView = @
            itemPathNamespaceObject.itemHostModelView = new Encapsule.code.lib.modelview.NavigatorMenuItemHostWindow(@navigatorContainer, @)
            @navigatorContainer.menuItemPathNamespace[ @path ] = itemPathNamespaceObject

            if yourNewLayoutObject_.subMenus? and yourNewLayoutObject_.subMenus

                for subMenuLayout in yourNewLayoutObject_.subMenus
                    # navigatorContainer, parentMenuLevel, layout, level
                    @subMenus.push new Encapsule.code.lib.modelview.NavigatorWindowMenuLevel(@navigatorContainer, @, subMenuLayout, (@level() + 1) )
                    parentItemPath = @path

            @getCssBackgroundColor = ko.computed =>

                # Set the default background color.
                base = net.brehaut.Color(@navigatorContainer.layout.baseBackgroundColor) 
                ratio = @level() * @navigatorContainer.layout.baseBackgroundRatioPercentPerLevel
                backgroundColorObject = base.lightenByRatio(ratio)

                if @selectedItem() or @showAsSelectedUntilMouseOut()
                    if @mouseOverHighlight()
                        backgroundColorObject = net.brehaut.Color(@navigatorContainer.layout.currentlySelectedMouseOverHighlightBackgroundColor)
                    else
                        backgroundColorObject = net.brehaut.Color(@navigatorContainer.layout.currentlySelectedBackgroundColor)
                else
                    if @mouseOverHighlight()
                        backgroundColorObject = net.brehaut.Color(@navigatorContainer.layout.mouseOverHighlightBackgroundColor)
                    else
                        if @selectedChild()
                            levelDiff = @navigatorContainer.currentSelectionLevel() - @level()
                            base = net.brehaut.Color(@navigatorContainer.layout.currentlySelectedProximityBackgroundColor)
                            ratio = levelDiff * @navigatorContainer.layout.currentlySelectedProximityRatioPerecentPerLevel
                            backgroundColorObject = base.darkenByRatio(ratio)
                
                return backgroundColorObject.toString()
    
            @getCssFontSize = ko.computed =>
                fontSize = Math.max( (@navigatorContainer.layout.menuLevelFontSizeMax - @level()), @navigatorContainer.layout.menuLevelFontSizeMin)
                "#{fontSize}pt"

            @getBorderColorLight = ko.computed =>
                net.brehaut.Color(@getCssBackgroundColor()).lightenByRatio(@navigatorContainer.layout.borderLightRatio).toString()

            @getBorderColorDark = ko.computed =>
                net.brehaut.Color(@getCssBackgroundColor()).darkenByRatio(@navigatorContainer.layout.borderDarkRatio).toString()

            @getBorderColorFlat = ko.computed =>
                net.brehaut.Color(@getCssBackgroundColor()).darkenByRatio(@navigatorContainer.layout.borderFlatRatio).toString()
       
            @getBorderTopLeft = ko.computed =>

                borderColor = @getBorderColorLight()
                borderWidth = @navigatorContainer.layout.borderWidth
                selected = false

                if @selectedItem()
                    selected = true
                    borderColor = @getBorderColorFlat()
                if @selectedParent()
                    borderColor = @getBorderColorLight()
                if @selectedChild()
                    selected = true
                    borderColor = @getBorderColorDark()

                if @mouseOverHighlight()
                    borderColor = (@selectedItem() and @getBorderColorLight()) or (not selected and @getBorderColorDark()) or @getBorderColorDark()

                if not (borderColor? and borderColor) then return "5px solid pink"

                result = "#{borderWidth}px solid #{borderColor}"
                return result

                    
            @getBorderBottomRight = ko.computed =>
                borderColor = @getBorderColorDark()
                borderWidth = @navigatorContainer.layout.borderWidth
                selected = false

                if @selectedItem()
                    selected = true
                    borderColor = @getBorderColorFlat()
                if @selectedParent()
                    borderColor = @getBorderColorDark()
                if @selectedChild()
                    selected = true
                    borderColor = @getBorderColorLight()

                if @mouseOverHighlight()
                    borderColor = (@selectedItem() and @getBorderColorDark()) or (not selected and @getBorderColorLight()) or @getBorderColorLight()

                if not (borderColor? and borderColor) then return "5px solid pink"

                result = "#{borderWidth}px solid #{borderColor}"
                return result
                    

            @getCssPaddingTop = ko.computed =>
                return "#{@navigatorContainer.layout.menuLevelPaddingTop}px"

            @getCssPaddingBottom = ko.computed =>
                paddingBottom = 0
                subMenus = @subMenus()
                if subMenus? and subMenus and subMenus.length
                    oneOrMoreVisibleChildren = false
                    for subMenu in subMenus
                        if subMenu.itemVisible()
                            oneOrMoreVisibleChildren = true

                    paddingBottom = oneOrMoreVisibleChildren and @navigatorContainer.layout.menuLevelPaddingBottom or 0

                return "#{paddingBottom}px"
                
            @getCssPaddingLeft = ko.computed =>
                return "#{@navigatorContainer.layout.menuLevelPaddingLeft}px"
         
            @getCssPaddingRight = ko.computed =>
                return "#{@navigatorContainer.layout.menuLevelPaddingRight}px"


            @updateMouseOverChild = (flag_) =>
                @mouseOverChild(flag_)
                if @parentMenuLevel? and @parentMenuLevel
                    @parentMenuLevel.updateMouseOverChild(flag_)
                
            @updateMouseOverParent = (flag_) =>
                @mouseOverParent(flag_)
                for subMenuObject in @subMenus()
                    subMenuObject.updateMouseOverParent(flag_)

            @onMouseEventNoAction = =>

            @onMouseOver = => 
                @mouseOverHighlight(true)
                @navigatorContainer.setCurrentMouseOverLevel(@level())
                if @parentMenuLevel? and @parentMenuLevel
                    @parentMenuLevel.updateMouseOverChild(true)
                @updateMouseOverParent(true)
                return false

            @onMouseOut = =>
                @mouseOverHighlight(false)
                @navigatorContainer.setCurrentMouseOverLevel(-1)
                if @parentMenuLevel? and @parentMenuLevel
                    @parentMenuLevel.updateMouseOverChild(false)
                @updateMouseOverParent(false)
                @showAsSelectedUntilMouseOut(false)

            @updateSelectedChild = (flag_, childPath_) =>
                @selectedChild(flag_)
                @itemVisible(true)
                @mouseOverHighlight(false)
                @mouseOverParent(false)
                @mouseOverChild(false)
                @showAsSelectedUntilMouseOut(false)

                for subMenu in @subMenus()
                     subMenuPath = subMenu.path
                     if (subMenuPath != childPath_)
                         # subMenu.itemVisible(false) 
                         subMenu.showYourselfHideYourChildren()
                     else
                         subMenu.itemVisible(true)


                if @parentMenuLevel? and @parentMenuLevel
                    @parentMenuLevel.updateSelectedChild(flag_, @path)


            @showAllChildren = (flag_) =>
                flag = flag_? and flag_ or true
                for subMenu in @subMenus()
                    subMenu.itemVisible(flag)
                    subMenu.showAllChildren(flag)


            @showYourselfHideYourChildren = =>
                @itemVisible(true)
                for subMenu in @subMenus()
                    subMenu.itemVisible(false)

            @updateSelectedParent = (flag_, showYourselfOnly_) =>
                @mouseOverHighlight(false)
                @mouseOverParent(false)
                @mouseOverChild(false)
                @showAsSelectedUntilMouseOut(false)
                for subMenuObject in @subMenus()
                    subMenuObject.selectedParent(flag_)

                    if flag_
                        if showYourselfOnly_? and showYourselfOnly_
                            subMenuObject.itemVisible(true)
                            @mouseOverHighlight(false)
                        else
                            subMenuObject.itemVisible(false)

                    subMenuObject.updateSelectedParent(flag_)


            @onMouseClick = =>
                @selectedItem( not @selectedItem() )
                if @selectedItem() == true
                    @showAsSelectedUntilMouseOut(true)
                    @navigatorContainer.updateSelectedMenuItem(@)
                    if @parentMenuLevel? and @parentMenuLevel
                        @parentMenuLevel.updateSelectedChild(true, @path)
                    @updateSelectedParent(true, true)
                    @updateMouseOverParent(false)
                    if @selectActionCallback? and @selectActionCallback
                        @selectActionCallback()
                else
                    @navigatorContainer.updateSelectedMenuItem(undefined)
                    @showAsSelectedUntilMouseOut(false)
                    if @parentMenuLevel? and @parentMenuLevel
                        @parentMenuLevel.updateSelectedChild(false)
                    @updateSelectedParent(false)
                    if @unselectActionCallback? and @unselectActionCallback
                        @unselectActionCallback()
                    if @parentMenuLevel? and @parentMenuLevel
                        @parentMenuLevel.onMouseClick()


            # / END: constructor try scope
        catch exception
            throw "SchemaScdlNavigatorMenuLevel fail \"#{@jsonTag}\" : #{exception}"
        # / END: constructor


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SchemaViewModelNavigatorMenuLevel", ( ->
    """
    <span data-bind="if: itemVisible">
    <div class="classSchemaViewModelNavigatorMenuLevel classMouseCursorPointer"
    data-bind="style: { fontSize: getCssFontSize(), backgroundColor: getCssBackgroundColor(), paddingBottom: getCssPaddingBottom(),
    paddingTop: getCssPaddingTop(), paddingLeft: getCssPaddingLeft(), paddingRight: getCssPaddingRight(), borderTop: getBorderTopLeft(), borderLeft: getBorderTopLeft(),
    borderBottom: getBorderBottomRight(), borderRight: getBorderBottomRight() },
    event: { mouseover: onMouseOver, mouseout: onMouseOut, click: onMouseClick }, mouseoverBubble: false, mouseoutBubble: false, clickBubble: false">
        <span data-bind="text: label"></span>
    <div class="classSchemaViewModelNaviagatorMenuLevel" data-bind="template: { name: 'idKoTemplate_SchemaViewModelNavigatorMenuLevel', foreach: subMenus }"></div>
    </div>
    </span>
    """))

