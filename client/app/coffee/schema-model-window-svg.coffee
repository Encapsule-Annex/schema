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
# schema-view-model-svg-plane.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_app = Encapsule.code.app? and Encapsule.code.app or @Encapsule.code.app = {}

namespaceEncapsule_runtime = Encapsule.runtime? and Encapsule.runtime or @Encapsule.runtime = {}
namespaceEncapsule_runtime_app = Encapsule.runtime.app? and Encapsule.runtime.app or @Encapsule.runtime.app = {}


class Encapsule.code.app.SchemaViewModelSvgPlane
    constructor: ->

        @planeViewWidth = ko.observable undefined
        @cssWidth = ko.computed => "#{@planeViewWidth()}px"
        @planeViewHeight = ko.observable undefined
        @cssHeight = ko.computed => "#{@planeViewHeight()}px"

        @planeMarginLeftOffset = ko.computed => Math.round @planeViewWidth() / -2
        @cssMarginLeft = ko.computed => "#{@planeMarginLeftOffset()}px"

        @planeMarginTopOffset = ko.computed => Math.round @planeViewHeight() / -2
        @cssMarginTop = ko.computed => "#{@planeMarginTopOffset()}px"

        @selectionPath = ko.observable undefined
        @viewMode = ko.observable undefined



Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SchemaViewModelSvgPlane", ( ->
    """
    Hello!
    """))
