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
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}

namespaceEncapsule_runtime = Encapsule.runtime? and Encapsule.runtime or @Encapsule.runtime = {}
namespaceEncapsule_runtime_app = Encapsule.runtime.app? and Encapsule.runtime.app or @Encapsule.runtime.app = {}


class Encapsule.code.app.SchemaViewModelNavigatorMenuLevel

    # options = {
    #     parent: {}
    #     label: ""
    #     
    #     }

    constructor: (params_) ->
        if not params_? or not params_
            throw "You must specify a parameter object as the first argument to SchemaViewModelNavigatorMenuLevel instance constructor."

        @parent =   ko.observable(params_.parent? and params_.parent or undefined)
        @level =    ko.observable(params_.parentLevel? and params_.parentLevel and params_.parentLevel + 1 or 0)
        @label =    ko.observable(params_.label? and params_.label or "No label!")
        @subMenus = ko.observableArray []

        Console.message "New menu item: level #{@level()} #{@label()}"

        self = @

        @addSubMenu = (params_, callback_) =>
            if not params_? or not params_
                throw "You must specify a params object as the first argument to addSubMenu"

            params = params_
            params.parent = self
            params.parentLevel = self.level()

            Console.message("adding submenu #{params.label}")
            newMenuItem =  new Encapsule.code.app.SchemaViewModelNavigatorMenuLevel(params_)
            newMenuItem.parent(self)
            newMenuItem.level(@level() + 1)
            @subMenus.push newMenuItem
            newMenuItem

        @getCssFontSize = =>
            fontSize = 16 - (@level())
            "#{fontSize}pt"

        @getCssBackgroundColor = =>
            base = net.brehaut.Color("#0099CC")
            ratio = @level() / 7
            base.desaturateByRatio(ratio).toString()

        @getCssMarginLeft = =>
            "#{@level() * 10}px"




Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SchemaViewModelNavigatorMenuLevel", ( ->
    """
    <div class="classSchemaViewModelNavigatorMenuLevel" data-bind="style: { fontSize: getCssFontSize(), paddingLeft: getCssMarginLeft(), backgroundColor: getCssBackgroundColor()}" >
    <span data-bind="text: label"></span>
    </div>
    <div class="classSchemaViewModelNaviagatorMenuLevel" data-bind="template: { name: 'idKoTemplate_SchemaViewModelNavigatorMenuLevel', foreach: subMenus }"></div></span>
    """))




class Encapsule.code.app.SchemaViewModelNavigator
    constructor: (initialHeight_) ->
        Console.message "Initializing #{appName} navigator data model."
        @navigatorEl = $("#idSchemaViewModelNavigator")

        @viewHeight = ko.observable initialHeight_

        menuViewModel = new Encapsule.code.app.SchemaViewModelNavigatorMenuLevel( { label: "Catalogues" } )
        
        scdlSpecs =     menuViewModel.addSubMenu( { label: "Specs" } )
        scdlSpec =      scdlSpecs.addSubMenu( { label: "Spec" } )
        scdlSpecSystems = scdlSpec.addSubMenu( { label: "Systems" } )

        scdlModels =    menuViewModel.addSubMenu( { label: "Models" } )

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


        @menuViewModel = ko.observable menuViewModel


        # For 'show console button click'
        @showConsole = =>
            consoleEl = $("#idConsole")
            if consoleEl? and console
                Console.show()








Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SchemaViewModelNavigator", ( ->
    """
    <span data-bind="with: menuViewModel"><div data-bind="template: { name: 'idKoTemplate_SchemaViewModelNavigatorMenuLevel' }"></div></span>
    <p style="text-align: center;"><button data-bind="click: showConsole" class="button small blue">Show Console</button></p>
    """))
