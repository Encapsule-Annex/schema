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

            @blipper = Encapsule.runtime.boot.phase3.blipper


            @navigatorContainer = navigatorContainerObject_
            @parentMenuLevel = parentMenuLevel_
            @layoutObject = yourNewLayoutObject_

            @level =    ko.observable(yourNewLevel_? and yourNewLevel_ or 0)

            @subMenus = ko.observableArray []

            @jsonTag =  yourNewLayoutObject_.jsonTag
            @path =     undefined
            if parentMenuLevel_? and parentMenuLevel_ and parentMenuLevel_.path? and parentMenuLevel_.path
                @path = parentMenuLevel_.path
                if @level() > 0
                    @path += "/"
                @path += @jsonTag
            else
                @path = "#{@jsonTag}?path="


            @generationsFromSelectionPath = 0 # Set dynamically by the navigator container during menu level visibility update.
            @itemVisible = ko.observable true

            @mouseOverChild = ko.observable(false)
            @mouseOverParent = ko.observable(false)
            @mouseOverHighlight = ko.observable(false)

            @showAsSelectedUntilMouseOut = ko.observable(false)
            @selectedItem = ko.observable(false)
            @selectedChild = ko.observable(false)
            @selectedParent = ko.observable(false)

            @labelDefault = yourNewLayoutObject_.label? and yourNewLayoutObject_.label or "no label"
            @label =    ko.observable(@labelDefault)
            @labelHtml = ko.computed =>
                hasChildren = @subMenus().length and true or false
                prefix = ""
                prefixHasChildrenClosed = "control.png"
                prefixHasChildrenOpen = "control-270.png"
                prefixIsLeaf = "control-stop-square-small.png"
                if @selectedChild()
                    prefix = prefixHasChildrenOpen
                else
                    if hasChildren
                        if @selectedItem()
                            prefix = prefixHasChildrenOpen
                        else
                            prefix = prefixHasChildrenClosed
                    else
                        prefix = prefixIsLeaf

                iconHtml = """<img src="./img/#{prefix}" style="width: 16px; height: 16px; vertical-align: middle;">"""
                return "#{iconHtml} #{@label()}"

            @baseBackgroundColorObject = ko.observable undefined
            @resetBaseBackgroundColor = =>
                ratio = @level() * @navigatorContainer.layout.baseBackgroundRatioPercentPerLevel
                @baseBackgroundColorObject(net.brehaut.Color(@navigatorContainer.layout.baseBackgroundColor).lightenByRatio(ratio))

            @resetBaseBackgroundColor()

            itemPathNamespaceObject = {}
            itemPathNamespaceObject.menuLevelModelView = @

            # I want to separate the construction of the menu levels from the construction of the menu item hosts
            # itemPathNamespaceObject.itemHostModelView = new Encapsule.code.lib.modelview.NavigatorMenuItemHostWindow(@navigatorContainer, @)

            @navigatorContainer.menuItemPathNamespace[ @path ] = itemPathNamespaceObject

            Console.message "Constructing new menu level object: level=#{@level()}, path=#{@path}, label=\"#{@label()}\""

            if yourNewLayoutObject_.subMenus? and yourNewLayoutObject_.subMenus

                for subMenuLayout in yourNewLayoutObject_.subMenus
                    # navigatorContainer, parentMenuLevel, layout, level
                    newMenuLevelObject = new Encapsule.code.lib.modelview.NavigatorWindowMenuLevel(@navigatorContainer, @, subMenuLayout, (@level() + 1) )
                    @subMenus.push(newMenuLevelObject)
                    parentItemPath = @path


            @getTooltipText = ko.computed =>
                if @layoutObject.objectDescriptor? and @layoutObject.objectDescriptor and @layoutObject.objectDescriptor.description? and @layoutObject.objectDescriptor.description
                    return @layoutObject.objectDescriptor.description
                else
                    return "Missing object descriptor description field."


            @getCssBackgroundColor = ko.computed =>

                backgroundColorObject = Encapsule.code.lib.js.clone(@baseBackgroundColorObject())
                mouseOverHighlight = @mouseOverHighlight()

                if @selectedItem() or @showAsSelectedUntilMouseOut()
                    if not mouseOverHighlight
                        backgroundColorObject = backgroundColorObject.shiftHue(@navigatorContainer.layout.selectedItemBackgroundShiftHue).lightenByRatio(@navigatorContainer.layout.selectedItemBackgroundLightenRatio)
                else if @selectedChild()
                    backgroundColorObject = backgroundColorObject.shiftHue(@navigatorContainer.layout.selectedChildItemBackgroundShiftHue).lightenByRatio(@navigatorContainer.layout.selectedChildItemBackgroundLightenRatio)

                if mouseOverHighlight
                    backgroundColorObject = backgroundColorObject.shiftHue(@navigatorContainer.layout.mouseOverItemBackgroundShiftHue).lightenByRatio(@navigatorContainer.layout.mouseOverItemBackgroundLightenRatio)

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
                    borderWidth = @navigatorContainer.layout.borderWidthFlat
                if @selectedParent()
                    borderColor = @getBorderColorLight()
                    borderWidth = @navigatorContainer.layout.borderWidthOutset
                if @selectedChild()
                    selected = true
                    borderColor = @getBorderColorDark()
                    borderWidth = @navigatorContainer.layout.borderWidthInset

                # item is outside of selection path

                ###
                if @mouseOverHighlight() and (not selected or @selectedChild())
                    borderColor = @getBorderColorFlat()
                    borderWidth = @navigatorContainer.layout.borderWidthFlat
                ###
                    
                result = "#{borderWidth}px solid #{borderColor}"
                return result

                    
            @getBorderBottomRight = ko.computed =>
                borderColor = @getBorderColorDark()
                borderWidth = @navigatorContainer.layout.borderWidth
                selected = false

                if @selectedItem()
                    selected = true
                    borderColor = (@mouseOverHighlight() and @getBorderColorDark()) or @getBorderColorFlat()
                    borderWidth = @navigatorContainer.layout.borderWidthFlat
                if @selectedParent()
                    borderColor = @getBorderColorDark()
                    borderWidth = @navigatorContainer.layout.borderWidthOutset
                if @selectedChild()
                    selected = true
                    borderColor = @getBorderColorLight()
                    borderWidth = @navigatorContainer.layout.borderWidthInset

                ###
                if @mouseOverHighlight() and (not selected or @selectedChild())
                    borderColor = @getBorderColorFlat()
                    borderWidth = @navigatorContainer.layout.borderWidthFlat
                ###

                result = "#{borderWidth}px solid #{borderColor}"
                return result

            @getCssBoxShadow = ko.computed =>
                selectedItem = @selectedItem()
                selectedChild = @selectedChild()
                mouseOverHighlight = @mouseOverHighlight()
                mouseOverSelected = selectedItem and mouseOverHighlight
                inSelectionPath = selectedItem or selectedChild
                backgroundColorObject = net.brehaut.Color(@getCssBackgroundColor())
                colorObjectDark = backgroundColorObject.darkenByRatio(@navigatorContainer.layout.menuLevelBoxShadowColorDarkenRatio)
                colorObjectLight = backgroundColorObject.lightenByRatio(@navigatorContainer.layout.menuLevelBoxShadowColorLightenRatio)

                colorObject = undefined
                options = undefined

                if not options and mouseOverSelected
                    options = @navigatorContainer.layout.menuLevelBoxShadowNotSelected
                    colorObject = colorObjectLight

                if not options and mouseOverHighlight
                    if not inSelectionPath
                        options = @navigatorContainer.layout.menuLevelBoxShadowMouseOverHighlight
                        colorObject = colorObjectDark

                if not options and inSelectionPath
                    level = @level()
                    options = @navigatorContainer.layout.menuLevelBoxShadowInSelectionPath
                    options.blur = options.blurBase + (level * options.blurPerLevel)
                    options.x = options.xBase + (level * options.xPerLevel)
                    options.y = options.yBase + (level * options.yPerLevel)
                    colorObject = colorObjectDark

                if not options
                    options = @navigatorContainer.layout.menuLevelBoxShadowNotSelected
                    colorObject = colorObjectLight

                cssBoxShadow = "#{options.type} #{options.x}px #{options.y}px #{options.blur}px #{colorObject.toCSS()}"
                return cssBoxShadow


            @getCssTextShadow = ko.computed =>
                selectedItem = @selectedItem()
                selectedChild = @selectedChild()
                mouseOverHighlight = @mouseOverHighlight()
                inSelectionPath = selectedItem or selectedChild

                cssShadow = undefined

                if not inSelectionPath
                    if mouseOverHighlight
                        cssShadow = "1px 1px 5px black"
                    else
                        cssShadow = ""
                else
                    cssShadow = "1px 1px 5px black"

                return cssShadow

                    
            @getCssFontWeight = ko.computed =>
                selectedPathItem = @selectedItem() or @selectedChild()
                return selectedPathItem and "normal" or "normal"

            @getCssColor = ko.computed =>
                selectedItem = @selectedItem()
                mouseOverHighlight = @mouseOverHighlight()
                selectedChild = @selectedChild()

                fontColorObject = net.brehaut.Color(@getCssBackgroundColor())

                if not (selectedItem or mouseOverHighlight or selectedChild)
                    return fontColorObject.darkenByRatio(@navigatorContainer.layout.fontColorRatioDefault).toString()

                if mouseOverHighlight and not selectedChild
                    return fontColorObject.darkenByRatio(@navigatorContainer.layout.fontColorRatioMouseOver).toString()

                if selectedItem
                    return fontColorObject.darkenByRatio(@navigatorContainer.layout.fontColorRatioSelected).toString()

                if selectedChild
                    return fontColorObject.darkenByRatio(@navigatorContainer.layout.fontColorRatioSelectedChild).toString()

                alert("what?")

            @getCssPaddingTop = ko.computed =>
                return "#{@navigatorContainer.layout.menuLevelPaddingTop}px"

            @getCssPaddingBottom = ko.computed =>
                paddingBottom = 2
                subMenus = @subMenus()
                if subMenus? and subMenus and subMenus.length
                    paddingBottom = 3
                    oneOrMoreVisibleChildren = false
                    for subMenu in subMenus
                        if subMenu.itemVisible()
                            oneOrMoreVisibleChildren = true

                    if oneOrMoreVisibleChildren
                        paddingBottom =  @navigatorContainer.layout.menuLevelPaddingBottom or paddingBottom

                return "#{paddingBottom}px"
                
            @getCssPaddingLeft = ko.computed =>
                return "#{@navigatorContainer.layout.menuLevelPaddingLeft}px"
         
            @getCssPaddingRight = ko.computed =>
                return "#{@navigatorContainer.layout.menuLevelPaddingRight}px"


            @onMouseOver = =>
                #@blipper.blip("26")
                @navigatorContainer.updateMouseOverState(@, true)

            @onMouseOut = =>
                @navigatorContainer.updateMouseOverState(@, false)

            @onMouseClick = =>
                @blipper.blip("22")
                return @navigatorContainer.toggleSelectionState(@)

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
    borderBottom: getBorderBottomRight(), borderRight: getBorderBottomRight(), boxShadow: getCssBoxShadow() },
    event: { mouseover: onMouseOver, mouseout: onMouseOut, click: onMouseClick }, mouseoverBubble: false, mouseoutBubble: false, clickBubble: false">
        <span data-bind="html: labelHtml, style: { fontWeight: getCssFontWeight(), color: getCssColor(), textShadow: getCssTextShadow() }"></span>
        <div class="classSchemaViewModelNaviagatorMenuLevel" data-bind="template: { name: 'idKoTemplate_SchemaViewModelNavigatorMenuLevel', foreach: subMenus }"></div>
    </div>
    </span>
    """))

