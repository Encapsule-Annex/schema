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

        @parent = ko.observable params_.parent? and params_.parent or undefined

        thisLevel = 1
        if @parent()? and @parent()
            if @parent().level? and @parent().level and @parent().level()
                thisLevel = @parent().level() + 1


        @level = ko.observable thisLevel
        @label = ko.observable params_? and params_ and params_.label? and params_.label or "set label in params"

        @subMenus = ko.observableArray []

        @addSubMenu = (childMenu_) =>
            if not childMenu_? or not childMenu_
                throw "You must specify a valid SchemaViewModelNavigatorMenuLevel object as the first argument to addSubMenu."

            childMenu_.parent(@)
            newLabel = "#{@label()} :: #{childMenu_.label()}"
            childMenu_.label(newLabel)
            @subMenus.push childMenu_



Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SchemaViewModelNavigatorMenuLevel", ( ->
    """
    Level: <span data-bind="text: level"></span><br>
    Label: <span data-bind="text: label"><span><br>
    SubMenus: <span data-bind="text: subMenus.length"></span<br>
    <div style="border: 1px solid black;">
        <div data-bind="template: { name: 'idKoTemplate_SchemaViewModelNavigatorMenuLevelX', foreach: subMenus }"></div>
    </div>
    """))


class Encapsule.code.app.SchemaViewModelNavigator
    constructor: (initialHeight_) ->
        Console.message "Initializing #{appName} navigator data model."
        @navigatorEl = $("#ididSchemaViewModelNavigator")

        @viewHeight = ko.observable initialHeight_

        menuViewModel = new Encapsule.code.app.SchemaViewModelNavigatorMenuLevel( { label: "SCDL Catalogue" } )
        
        scdlSpecs =     new Encapsule.code.app.SchemaViewModelNavigatorMenuLevel( { label: "SCDL Specs" } )
        scdlModels =    new Encapsule.code.app.SchemaViewModelNavigatorMenuLevel( { label: "SCDL Models" } )

        menuViewModel.addSubMenu scdlSpecs
        menuViewModel.addSubMenu scdlModels
        

        @menuViewModel = ko.observable menuViewModel


        # For 'show console button click'
        @showConsole = =>
            consoleEl = $("#idConsole")
            if consoleEl? and console
                Console.show()








Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SchemaViewModelNavigator", ( ->
    """
    <span data-bind="with: menuViewModel"><div data-bind="template: { name: 'idKoTemplate_SchemaViewModelNavigatorMenuLevel' }"></div></span>
    <p style="text-align: center;">
        <button data-bind="click: showConsole" class="button small yellow">Show Console</button>
    </p>
    """))
