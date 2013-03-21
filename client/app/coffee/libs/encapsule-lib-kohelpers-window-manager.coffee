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
# encapsule-lib-kohelpers-window-manager.coffee

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
namespaceEncapsule_code_lib_kohelpers = Encapsule.code.lib.kohelpers? and Encapsule.code.lib.kohelpers or @Encapsule.code.lib.kohelpers = {}

namespaceEncapsule_runtime = Encapsule.runtime? and Encapsule.runtime or @Encapsule.runtime = {}
namespaceEncapsule_runtime_app = Encapsule.runtime.app? and Encapsule.runtime.app or @Encapsule.runtime.app = {}
namespaceEncapsule_runtime_app_kotemplates = Encapsule.runtime.app.kotemplates? and Encapsule.runtime.app.kotemplates or @Encapsule.runtime.app.kotemplates = []








class Encapsule.code.lib.kohelpers.ObservableWindowManager

    constructor: (layout_) ->

        try
            # PARAMETER VALIDATION

            if not layout_? or not layout_
                throw "You must specify a layout to construct an ObservableWindowManager instance."

            if not layout_.layout? and not layout_.layout
                throw "Expecting a top-level object named layout."

            # NON-OBSERVABLE INTERNAL INSTANCE STATE

            @layout = layout_.layout
            @planes = []
            @observableWindows = ko.observableArray []

            # OBSERVABLES

            # This is the offset rectangle of the glass behind the window manager.
            @glassOffsetRect = ko.observable new Encapsule.code.lib.kohelpers.OffsetRectangle()
            @cssGlassWidth = ko.computed => @glassOffsetRect().rectangle.width + "px"
            @cssGlassHeight = ko.computed => @glassOffsetRect().rectangle.height + "px"
            @cssGlassMarginLeft = ko.computed => @glassOffsetRect().offset.left + "px"
            @cssGlassMarginTop = ko.computed => @glassOffsetRect().offset.top + "px"
            @cssGlassOpacity = ko.computed => @layout.glassOpacity
            @cssGlassBackgroundColor = ko.computed => @layout.glassBackgroundColor? and @layout.glassBackgroundColor or undefined
            @cssGlassBackground = ko.computed => @layout.glassBackgroundImage? and @layout.glassBackgroundImage  and "url(img/#{@layout.glassBackgroundImage})" or undefined

            # This is the offset rectangle of the window manager.
            @viewOffsetRect = ko.observable new Encapsule.code.lib.kohelpers.OffsetRectangle()
            @cssWindowManagerBackgroundColor = ko.computed => @layout.windowManagerBackgroundColor
            @cssWindowManagerOpacity = ko.computed => @layout.windowManagerOpacity
            @cssWindowManagerWidth = ko.computed => @viewOffsetRect().rectangle.width + "px"
            @cssWindowManagerHeight = ko.computed => @viewOffsetRect().rectangle.height + "px"
            @cssWindowManagerMarginLeft = ko.computed => @viewOffsetRect().offset.left + "px"
            @cssWindowManagerMarginTop = ko.computed => @viewOffsetRect().offset.top + "px"

             
            # INTERNAL STATE INITIALIZATION

            $("body").css { backgroundColor: @layout.pageBackgroundColor }

            # The Window Manager takes as input a "layout" Javascript object.
            # The layout is declarative and is parsed here to produce this window manager's internal runtime
            # state model: a hierarchy of objects initialized using data from the layout. 
            #
            # We intend to bind the internal state of the window manager to the DOM via Knockout.js.
            # As we parse the layout declaration below, build the HTML binding string.
            #

            htmlBindingBegin = """
                <div id="idWindowManagerGlass" onclick="Console.show()" data-bind="style: { width: cssGlassWidth(), height: cssGlassHeight(), 
                marginLeft: cssGlassMarginLeft(), marginTop: cssGlassMarginTop(), background: cssGlassBackground(),
                opacity: cssGlassOpacity(), backgroundColor: cssGlassBackgroundColor() }"></div>
                <div id="#{@layout.id}" class="classObservableWindowManager"
                data-bind="style: { backgroundColor: cssWindowManagerBackgroundColor(), width: cssWindowManagerWidth(),
                height: cssWindowManagerHeight(), marginLeft: cssWindowManagerMarginLeft(), marginTop: cssWindowManagerMarginTop(),
                opacity: cssWindowManagerOpacity() }">#{@layout.id}::#{@layout.name}
                """

            htmlBindingEnd = """</div>"""

            planeIndex = 0
            for planeLayout in @layout.planes
                # begin
                planeRuntime = { id: planeLayout.id, name: planeLayout.name, splitterStack: [] }
                splitIndex = 0
                for split in planeLayout.splitterStack
                    # begin split scope
                    try
                        Console.message("Window manager: Starting plane #{planeIndex} split #{splitIndex} ...")
                        Console.message("... id = #{split.id}")
                        Console.message("... name = #{split.name}")
                        Console.message("... type = #{split.type}")
                        Console.message("... Q1 window descriptor = #{split.Q1WindowDescriptor}")
                        Console.message("... Q2 window descriptor = #{split.Q2WindowDescriptor}")

                        splitterObservableWindows = []
                        newSplit = new Encapsule.code.lib.kohelpers.WindowSplitter( split, splitterObservableWindows )
                        planeRuntime.splitterStack.push newSplit
                        for observableWindow in splitterObservableWindows
                            @observableWindows.push observableWindow

                        Console.message("... Layout #{planeIndex} #{splitIndex} processed.")
                        splitIndex++
                    catch exception
                        throw "Exception processing layout plane #{planeIndex}, split #{splitIndex} :: #{exception}"
                    # end split scope
                # back at plane scope
                @planes.push planeRuntime
                Console.message("Layout plane #{planeIndex} processed.")
                planeIndex++
            Console.message("Done transforming layout into view model :)")


            # DOM STATE

            bodyEl = $("body")
            bodyEl.append($("""<span id="idEncapsuleWindowManager"></span>"""))
            windowManagerEl = $("#idEncapsuleWindowManager")
            Encapsule.code.lib.kohelpers.InstallKnockoutViewTemplates(windowManagerEl)


            $("body").append( $(htmlBindingBegin + htmlBindingEnd) )

            bindingTargetEl = document.getElementById("#idWindowManagerGlass")
            ko.applyBindings @, bindingTargetEl


            @getOffsetRectangle = =>
                documentEl = $(document)
                # width =  @documentEl.width()
                # height = @documentEl.height()
                # innerWidth = @documentEl.innerWidth()
                # innerHeight = @documentEl.innerHeight()
                # outerWidth = @documentEl.outerWidth()
                # outerHeight = @documentEl.outerHeight()
                marginWidth = documentEl.outerWidth(true)
                marginHeight = documentEl.outerHeight(true)

                glassRectangle = new Encapsule.code.lib.kohelpers.Rectangle(marginWidth, marginHeight)
                @glassOffsetRect(new Encapsule.code.lib.kohelpers.OffsetRectangle(glassRectangle, undefined))

                viewRectangle = new Encapsule.code.lib.kohelpers.Rectangle (marginWidth - @layout.windowManagerOuterOffset), (marginHeight - @layout.windowManagerOuterOffset)
                viewOffsetRectangle = new Encapsule.code.lib.kohelpers.OffsetRectangle viewRectangle, undefined
                viewOffsetRectangle




            #
            # Given a new offset rectangle representing the "view", determine if we need to
            # re-evaluate the split stack.
            #
            
            @updateViewState = (forceEval_) =>

                # Return false iff no change and not forceEval_

                forceEval = forceEval_? and forceEval_ or false

                oldOffsetRectangle = @viewOffsetRect()
                newOffsetRectangle = @getOffsetRectangle()

                if newOffsetRectangle == oldOffsetRectangle and not forceEval
                    return false;

                @viewOffsetRect(newOffsetRectangle)

                runtimeState = @runtimeState
                availableOffsetRect = newOffsetRectangle

                for plane in @planes
                    splitters = plane.splitterStack
                    for split in splitters
                        Console.message("Window manager refresh on plane #{plane.id} split #{split.id}")

                        split.setOffsetRectangle(availableOffsetRect, forceEval)



            # PENULTIMATE STEP:
            # Update the view state to power-on defaults.

            @updateViewState(true)

            # LASTLY, GO LIVE WITH VIEW STATE UPDATES IN RESPONSE TO BROWSER RESIZE EVENTS

            # setInterval @updateViewState, 5000 # This catches everything (including browser restore) eventually
            window.addEventListener 'resize', @updateViewState

            Console.message("... Window manager initialization complete.")



        catch exception
            message = "In Encapsule.code.lib.kohelpers.WindowManager: #{exception}"
            throw message




