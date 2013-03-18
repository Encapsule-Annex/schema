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
# encapsule-lib-kohelpers-window.coffee
#

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
namespaceEncapsule_code_lib_kohelpers = Encapsule.code.lib.kohelpers? and Encapsule.code.lib.kohelpers or @Encapsule.code.lib.kohelpers = {}

namespaceEncapsule_runtime = Encapsule.runtime? and Encapsule.runtime or @Encapsule.runtime = {}
namespaceEncapsule_runtime_app = Encapsule.runtime.app? and Encapsule.runtime.app or @Encapsule.runtime.app = {}
namespaceEncapsule_runtime_app_kotemplates = Encapsule.runtime.app.kotemplates? and Encapsule.runtime.app.kotemplates or @Encapsule.runtime.app.kotemplates = []

Encapsule.code.lib.kohelpers.util = {}


class Encapsule.code.kohelpers.util.observable
    constructor: (type_) ->
        @type = type_
        @observers = []
        @subscribe = (callback_) =>
            @observers.push callback_
        @read = => @type
        @write = (value_) =>
            @type = value_
            for observer in observers
                observer(@)



class Encapsule.code.lib.kohelpers.Point
    constructor: (x_, y_) ->
        @x = x_
        @y = y_

class Encapsule.code.lib.kohelpers.OffsetPoint
    constructor: (top_, left_) ->
        @top = top_
        @left = left_

class Encapsule.code.lib.kohelpers.Rectangle
    constructor: (width_, height_) ->
        @width = Math.max 0, width_
        @height = Math.max 0, height_
        @visible = => @width and @height

class Encapsule.code.lib.kohelpers.OffsetRectangle
    constructor: (rectangle_, bias_) ->

        @bias = {}
        if bias_? and bias
            @bias = bias_
        else
            @bias.horizontal = 1.0
            @bias.vertical = 1.0

        @rectangle = rectangle_

        #
        # This algorithm models a DIV with postion: fixed, top: 50%, left: 50%; padding: 0px, margin-left: @offset.left, margin-top: @offset.top
        #

        displaceTop = rectangle_.height / -2
        displaceTopBiased = displaceTop * @bias.horizontal

        displaceLeft = rectangle_.width / -2
        displaceLeftBiased = displaceLeft * @bias.vertical

        @offset = new Encapsule.code.lib.kohelpers.OffsetPoint(displaceTopBiased, displaceLeftBiased)



class Encapsule.code.lib.kohelpers.WindowDescriptorMode
    constructor: (modeName_, reserveX_, reserveY_) ->
        if not modeName_? and not modeName_ then throw "You must specifiy a mode name"
        if modeName_ != "full" and modeName_ != "min" then throw "Unrecognized mode name"
        @mode = modeName_
        @reserveX = reserveX_
        @reserveY = reserveY_
        @




class Encapsule.code.lib.kohelpers.WindowDescriptor
    constructor: (title_, orientation_, modes_) ->
        @




test = Encapsule.code.lib.kohelpers.WindowDescriptor( "Test", "column", [ Encapsule.code.lib.kohelpers.WindowDesriptorMode("full", 0, 200) ] )