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


class Encapsule.code.app.modelview.SchemaScdlNavigatorMenuLevel

    # params = {
    #     label: "Display label"
    #     }

    constructor: (navigatorContainerObject_, params_) ->
        # \ BEGIN: constructor scope
        try
            # \ BEGIN: constructor try scope

            if not navigatorContainerObject_? or not navigatorContainerObject_
                throw "You must specifiy the containing navigator object as the first parameter."

            if not params_? or not params_
                throw "You must specify a parameter object as the second parameter."

            @navigatorContainer = navigatorContainerObject_

            @selectActionCallback = params_.selectActionCallback? and params_.selectActionCallback or undefined
            @unselectActionCallback = params_.unselectActionCallback? and params_.unselectActionCallback or undefined
 
            @level =    ko.observable(params_.level? and params_.level or 0)
            @label =    ko.observable(params_.label? and params_.label or "No label!")
            @subMenus = ko.observableArray []

            @mouseOverHighlight = ko.observable false
            @selectedItem = ko.observable false

            Console.message "New menu item: level #{@level()} #{@label()}"

            @addSubMenu = (params_) =>
                if not params_? or not params_
                    throw "You must specify a params object as the first argument to addSubMenu"

                params_.level = @level() + 1

                Console.message("adding submenu #{params_.label}")
                newMenuItem =  new Encapsule.code.app.modelview.SchemaScdlNavigatorMenuLevel(@navigatorContainer, params_)
                @subMenus.push newMenuItem
                newMenuItem

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
    constructor: ->
        # \ BEGIN: constructor
        try
            # \ BEGIN: constructor try scope
            Console.message "Initializing #{appName} navigator data model."

            menuModelView = new Encapsule.code.app.modelview.SchemaScdlNavigatorMenuLevel(@, { label: "Catalogue" } )
        
            scdlSpecs =     menuModelView.addSubMenu( { label: "Specs" } )
            scdlSpec =      scdlSpecs.addSubMenu( { label: "Spec" } )
            scdlSpecSystems = scdlSpec.addSubMenu( { label: "Systems" } )

            scdlModels =    menuModelView.addSubMenu( { label: "Models" } )

            scdlSystems =   scdlModels.addSubMenu( { label: "Systems" } )
            scdlSystem =    scdlSystems.addSubMenu( { label: "System" } )
            scdlSystemIo =  scdlSystem.addSubMenu( { label: "I/O" } )

            scdlSystemInputs = scdlSystemIo.addSubMenu( { label: "Inputs" } )
            scdlSystemInput = scdlSystemInputs.addSubMenu( { label: "Input" } )
            scdlSystemOutputs = scdlSystemIo.addSubMenu( { label: "Outputs" } )
            scdlSystemOutput = scdlSystemOutputs.addSubMenu( { label: "Output" } )

            scdlMachines =  scdlModels.addSubMenu( { label: "Machines" } )
            scdlMachine =   scdlMachines.addSubMenu( { label: "Machine" } )

            scdlSockets =   scdlModels.addSubMenu( { label: "Sockets" } )
            scdlSocket =    scdlSockets.addSubMenu( { label: "Socket" } )

            scdlContracts = scdlModels.addSubMenu( { label: "Contracts" } )
            scdlContract =  scdlContracts.addSubMenu( { label: "Contract" } )

            @menuViewModel = ko.observable menuModelView

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
    <span data-bind="with: menuViewModel"><div data-bind="template: { name: 'idKoTemplate_SchemaViewModelNavigatorMenuLevel' }"></div></span>
    """))
