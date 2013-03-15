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

        parent = params_.parent? and params_.parent or undefined
        parent_level = parent? and parent and parent.level? and parent.level and parent.level() or -1
        this_level = parent_level + 1
        label = params_.label? and params_.label or ""
        
        Console.message "New menu item: #{label}"

        @parent = ko.observable parent_level
        @level = ko.observable this_level
        @label = ko.observable label
        @subMenus = ko.observableArray []

        @addSubMenu = (params_, callback_) =>
            if not params_? or not params_
                throw "You must specify a params object as the first arguemtn to addSubMenu"

            params = params_
            params.parent = @
            Console.message("adding submenu #{params_.label}")
            newMenuItem =  new Encapsule.code.app.SchemaViewModelNavigatorMenuLevel(params_)
            @subMenus.push newMenuItem
            newMenuItem




Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SchemaViewModelNavigatorMenuLevel", ( ->
    """
    <div class="classSchemaViewModelNavigatorMenuLevel">
        <span data-bind="text: label"></span>
        <div class="classSchemaViewModelNaviagatorMenuLevel" data-bind="template: { name: 'idKoTemplate_SchemaViewModelNavigatorMenuLevel2', foreach: subMenus }"></div>
    </div>
    """))

Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SchemaViewModelNavigatorMenuLevel2", ( ->
    """
    <div class="classSchemaViewModelNavigatorMenuLevel">
        <span data-bind="text: label"></span><br>
        <div class="classSchemaViewModelNaviagatorMenuLevel" data-bind="template: { name: 'idKoTemplate_SchemaViewModelNavigatorMenuLevel', foreach: subMenus }"></div>
    </div>
    """))

class Encapsule.code.app.SchemaViewModelNavigator
    constructor: (initialHeight_) ->
        Console.message "Initializing #{appName} navigator data model."
        @navigatorEl = $("#idSchemaViewModelNavigator")

        @viewHeight = ko.observable initialHeight_

        menuViewModel = new Encapsule.code.app.SchemaViewModelNavigatorMenuLevel( { label: "SCDL Catalogue" } )
        
        scdlSpecs =     menuViewModel.addSubMenu( { label: "Specs" } )
        scdlModels =    menuViewModel.addSubMenu( { label: "Models" } )
        scdlModels.addSubMenu( { label: "Systems" } )

        @menuViewModel = ko.observable menuViewModel


        # For 'show console button click'
        @showConsole = =>
            consoleEl = $("#idConsole")
            if consoleEl? and console
                Console.show()








Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SchemaViewModelNavigator", ( ->
    """
    <h3>Menu</h3>
    <span data-bind="with: menuViewModel"><div data-bind="template: { name: 'idKoTemplate_SchemaViewModelNavigatorMenuLevel' }"></div></span>
    <p style="text-align: center;">
        <button data-bind="click: showConsole" class="button small yellow">Show Console</button>
    </p>
    """))
