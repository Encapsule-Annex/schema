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
# schema-view-model.coffee
#
# This is the top-level Knockout.js view model for the Schema SCDL editor application.
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}

namespaceEncapsule_runtime = Encapsule.runtime? and Encapsule.runtime or @Encapsule.runtime = {}
namespaceEncapsule_runtime_app = Encapsule.runtime.app? and Encapsule.runtime.app or @Encapsule.runtime.app = {}


class Encapsule.code.app.SchemaViewModel
    constructor: ->

        @documentWidth = ko.observable $(document).innerWidth()
        @documentHeight = ko.observable $(document).innerHeight()

        @viewWidth = ko.computed => @documentWidth()
        @viewWidthPixels = ko.computed => @viewWidth() + "px"

        @viewHeight = ko.computed => @documentHeight()
        @viewHeightPixels = ko.computed => @viewHeight() + "px"

        @viewMarginLeftOffset = ko.computed => Math.round @viewWidth() / -2
        @viewMarginLeftOffsetPixels = ko.computed => @viewMarginLeftOffset() + "px"

        @viewMarginTopOffset = ko.computed => ( Math.round @viewHeight() / -2 ) - 1
        @viewMarginTopOffsetPixels = ko.computed => @viewMarginTopOffset() + "px"

        @documentResizeCallback = (args_) =>
            width = $(document).innerWidth()
            height = $(document).innerHeight()
            #if width != @documentWidth()
            @documentWidth(width)
            #if height != @documentHeight()
            @documentHeight(height)

        setInterval @documentResizeCallback, 100 # This catches everything (including browser restore) eventually
        window.addEventListener 'resize', @documentResizeCallback

        @viewNavigator = ko.observable new Encapsule.code.app.SchemaViewModelNavigator(@viewHeight())
        @viewNavigationPath = ko.observable undefined
        @viewOperations = ko.observable undefined
  
        @viewScdlCatalogue = ko.observable undefined
        @viewScdlEditor = ko.observable undefined

        @viewScdlVisualize = ko.observable undefined

        @viewAppSettings = ko.observable undefined
        @viewAppAdvanced = ko.observable undefined


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SchemaViewModel", ( ->
    """
    <span data-bind="with: viewNavigator">
        <div id="idSchemaViewModelNavigator" data-bind="template: { name: 'idKoTemplate_SchemaViewModelNavigator' }  , style: { height: viewHeight() }">
        </div>
    </span>
    """))


#
       