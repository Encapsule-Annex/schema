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


            # INSTANCE STATE

            # OBSERVABLES

            @offsetRect = ko.observable new Encapsule.code.lib.kohelpers.OffsetRectangle()

            # NON-OBSERVABLE INTERNAL INSTANCE STATE

            @layout = layout_.layout
            @planes = []
            @windows = []
            @splits = []
             
            # INTERNAL STATE INITIALIZATION

            $("body").css { backgroundColor: @layout.bodyBackgroundColor }

            # The Window Manager takes as input a "layout" Javascript object.
            # The layout is declarative and is parsed here to produce this window manager's internal runtime
            # state model: a hierarchy of objects initialized using data from the layout. 
            #
            # We intend to bind the internal state of the window manager to the DOM via Knockout.js.
            # As we parse the layout declaration below, build the HTML binding string.
            #

            htmlBindingBegin = """<div id="#{@layout.id}" class="classObservableWindowManager">"""
            htmlBindingEnd = """</div>"""

            @runtimeState = {}
            @runtimeState.planes = []
            @runtimeState.observableWindows = []

            planeIndex = 0
            for planeLayout in @layout.planes
                # begin
                planeRuntime = { id: planeLayout.id, name: planeLayout.name, splitterStack: [] }
                htmlBindingBegin += """<div id="#{planeLayout.id}" class="classObservableManagedPlane">"""
                htmlBindingEnd = """</div>""" + htmlBindingEnd
                splitIndex = 0
                for split in planeLayout.splitterStack
                    # begin split scope
                    try
                        Console.message("Window manager: Starting plane #{planeIndex} split #{splitIndex} ...")
                        Console.message("... type = #{split.type}")
                        Console.message("... Q1 window descriptor = #{split.Q1WindowDescriptor}")
                        Console.message("... Q2 window descriptor = #{split.Q2WindowDescriptor}")

                        splitterObservableWindows = []
                        newSplit = new Encapsule.code.lib.kohelpers.WindowSplitter( split.type, split.Q1WindowDescriptor, split.Q2WindowDescriptor, splitterObservableWindows )
                        planeRuntime.splitterStack.push newSplit
                        for observableWindow in splitterObservableWindows
                            @runtimeState.observableWindows.push observableWindow
                            htmlBindingBegin += """<div id="#{observableWindow.id}" class="classObservableWindow"></div>"""

                        Console.message("... Layout #{planeIndex} #{splitIndex} processed.")
                        splitIndex++
                    catch exception
                        throw "Check level #{layoutLevel} for malformed input: #{exception}"
                    # end split scope
                # back at plane scope
                @runtimeState.planes.push planeRuntime
                Console.message("Layout plane #{planeIndex} processed.")
                planeIndex++
            Console.message("Done transforming layout into view model :)")

            $("body").append( $(htmlBindingBegin + htmlBindingEnd) )





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
                viewRectangle = new Encapsule.code.lib.kohelpers.Rectangle marginWidth - 30, marginHeight - 30
                viewOffsetRectangle = new Encapsule.code.lib.kohelpers.OffsetRectangle viewRectangle, undefined
                viewOffsetRectangle


            #
            # Given a new offset rectangle representing the "view", determine if we need to
            # re-evaluate the split stack.
            #
            
            @updateViewState = (forceEval_) =>

                # Return false iff no change and not forceEval_

                forceEval = forceEval_? and forceEval_ or false

                oldOffsetRectangle = @offsetRect()
                newOffsetRectangle = @getOffsetRectangle()

                if newOffsetRectangle == oldOffsetRectangle and not forceEval
                    return false;

                @offsetRect newOffsetRectangle
                Console.messageRaw(".")


            # Update the view state to power-on defaults.
            # @updateViewState(true)




            # LASTLY, GO LIVE WITH VIEW STATE UPDATES IN RESPONSE TO BROWSER RESIZE EVENTS

            # setInterval @updateViewState, 5000 # This catches everything (including browser restore) eventually
            #window.addEventListener('resize', @updateViewState)

            window.addEventListener 'resize', @updateViewState

            Console.message("... Window manager initialization complete.")



        catch exception
            message = "In Encapsule.code.lib.kohelpers.WindowManager: #{exception}"
            throw message




