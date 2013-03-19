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



class Encapsule.code.lib.kohelpers.observable
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
        @width = width_? and Math.max(0, width_) or 0
        @height = height_? and Math.max(0, height_) or 0
        @visible = @width and @height

class Encapsule.code.lib.kohelpers.OffsetRectangle
    constructor: (rectangle_, bias_) ->

        @bias = {}
        if bias_? and bias_
            @bias = bias_
        else
            @bias.horizontal = 1.0
            @bias.vertical = 1.0

        @rectangle = rectangle_? and rectangle_ or new Encapsule.code.lib.kohelpers.Rectangle()

        #
        # This algorithm models a DIV with postion: fixed, top: 50%, left: 50%; padding: 0px, margin-left: @offset.left, margin-top: @offset.top
        #

        displaceTop = @rectangle.height / -2
        displaceTopBiased = Math.round displaceTop * @bias.horizontal

        displaceLeft = @rectangle.width / -2
        displaceLeftBiased = Math.round displaceLeft * @bias.vertical

        @offset = new Encapsule.code.lib.kohelpers.OffsetPoint(displaceTopBiased, displaceLeftBiased)



#
# WindowModeDescriptor is a function that returns a Javascript object describing X and Y axes
# reserve limits for a given "mode". Limits must be greater than or equal to zero and are in
# assumed pixel units. A reserve value of zero indicates limitless greed. A specific value indicates
# a fixed size request. If the window manager cannot satisfy the contraints requested in a window
# descriptor mode, it will try the next mode. If no modes can be satisfied, the window manager
# disables the window and removes it from the plane layout.
#

Encapsule.code.lib.kohelpers.WindowModeDescriptor = (modeName_, reserveX_, reserveY_) ->

        if not modeName_? and not modeName_ then throw "You must specifiy a mode name"
        if modeName_ != "full" and modeName_ != "min" then throw "Unrecognized mode name"
        windowMode = { name: modeName_, reserveX: reserveX_, reserveY: reserveY_ }
        windowMode


#
# WindowDescriptor is a function that returns a Javascript object that describes what we want the
# the window manager to provide for a specific window within a plane.
#

Encapsule.code.lib.kohelpers.WindowDescriptor = (id_, title_, orientation_, modes_) ->
    windowDescriptor = { id: id_, title: title_, orientation: orientation_, modes: modes_ }
    windowDescriptor

Encapsule.code.lib.kohelpers.WindowDescriptorPair = (firstWindowDescriptor1_, secondWindowDescriptor_2) ->
    windowDescriptorPair = {}
    windowDescriptorPair.first = firstWindowDescriptor1_
    windowDescriptorPair.second = secondWindowDescriptor2_
    windowDescriptorPair



class Encapsule.code.lib.kohelpers.WindowSplitter
    constructor: (type_, q1Descriptor_, q2Descriptor_, windows_) ->

        @type = type_

        @offsetRectangle = undefined

        @q1Descriptor = q1Descriptor_
        @q2Descriptor = q2Descriptor_

        @q1OffsetRectangle = undefined
        @q2OffsetRectangle = undefined

        @q1Window = undefined
        @q2Window = undefined

        @unallocatedOffsetRect = undefined

        if q1Descriptor_? and q1Descriptor_
            @q1Window  = new Encapsule.code.lib.kohelpers.ObservableWindow(q1Descriptor_)
            windowEntry = { id: @q1Window.id, window: @q1Window }
            windows_.push windowEntry

        if q2Descriptor_? and q2Descriptor_
            @q2Window = new Encapsule.code.lib.kohelpers.ObservableWindow(q2Descriptor_)
            windowEntry = { id: @q2Window.id, window: @q2Window }
            windows_.push windowEntry


        # Set the bounding offset rectangle defining the outer dimension of this window splitter.

        @setOffsetRectangle = (offsetRectangle_, forceEval_ ) =>

            # Return false iff no change and not forceEval_

            if offsetRectangle_? and offsetRectangle_ and offsetRectangle_ == @offsetRectangle and not forceEval_
                return false
            
            # The bounding rectangle has been changed.

            @offsetRectangle = offsetRectangle_



            


            





class Encapsule.code.lib.kohelpers.ObservableWindow
    constructor: (sourceDescriptor_) ->
        Console.message("... + WindowManager creating new window id=#{sourceDescriptor_.id} name=#{sourceDescriptor_.name}")
        @sourceDescriptor = sourceDescriptor_

        @id = ko.observable sourceDescriptor_.id
        @name = ko.observable sourceDescriptor_.name


        @offsetRectangle = undefined

        @setOffsetRectangle = (offsetRectangle_) =>
            # We will do some checking here to ensure that a change actually occurred.
            # If so, then we will update the Knockout.js observables contained by thie ObservableWindow instance
            @offsetRectangle = offsetRectangle_


            









class Encapsule.code.lib.kohelpers.ObservableWindowManager

    constructor: (layout_) ->

        try
            if not layout_? or not layout_
                throw "You must specify an array of splitters."

            @offsetRectangle = undefined


            layoutLevel = 0
            @windows = []
            @splits = []

            for splitter in layout_

                try
                    Console.message("Window manager level #{layoutLevel}: #{splitter.name}")
                    Console.message("... type = #{splitter.type}")
                    Console.message("... Q1 window descriptor = #{splitter.Q1WindowDescriptor}")
                    Console.message("... Q2 window descriptor = #{splitter.Q2WindowDescriptor}")

                    newSplit = new Encapsule.code.lib.kohelpers.WindowSplitter( splitter.type, splitter.Q1WindowDescriptor, splitter.Q2WindowDescriptor, @windows )
                    @splits.push newSplit

                    Console.message("... window manager level #{layoutLevel} processing completed.")
                    layoutLevel++

                catch exception
                    throw "Check level #{layoutLevel} for malformed input: #{exception}"

            Console.message("... Done instantiating managed observable windows.")

            @setOffsetRectangle = (offsetRectangle_, forceEval_) =>
                # Return false iff no change and not forceEval_
                
                Console.message("Window manager setOffSetRectangle = #{offsetRectangle_} forceEval=#{forceEval_}")

                if offsetRectangle_? and offsetRectangle_ and offsetRectangle_ == @offsetRectangle and not forceEval_
                    Console.message("... No update necessary.")
                    return false

                Console.message("... Bounding offset rectangle has been updated.")
                @offsetRectangle = offsetRectangle_



            Console.message("... Window manager initialization complete.")



        catch exception
            message = "In Encapsule.code.lib.kohelpers.WindowManager: #{exception}"
            throw message




