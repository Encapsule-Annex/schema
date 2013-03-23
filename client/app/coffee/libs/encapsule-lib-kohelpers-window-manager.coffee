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

            # ============================================================================
            # NAMESPACE ALIASES
            geo = Encapsule.code.lib.geometry


            # ============================================================================
            # PARAMETER VALIDATION

            if not layout_? or not layout_ then throw "You must specify a layout to construct an ObservableWindowManager instance."
            if not layout_.layout? and not layout_.layout then throw "Expecting a top-level object named layout."


            # ============================================================================
            # NON-OBSERVABLE INTERNAL INSTANCE STATE

            @layout = layout_.layout

            Console.messageRaw("<h2>#{@layout.name}</h2>")
            Console.messageRaw("<h3>INITIALIZING</h3>")

            # An array of plane objects that manager a layout splitter stack.
            @planes = []


            # Written by document resize event callback.
            @documentOffsetRectangle = geo.offsetRectangle.create()
            @windowManagerGlassOffsetRectangle = geo.offsetRectangle.create()
            @windowManagerOffsetRectangle = geo.offsetRectangle.create()

            


            # ============================================================================
            # OBSERVABLES
            #

            #
            # ============================================================================
            # OBSERVABLE WINDOW MANAGER WINDOW PROPERTIES
            #


            # ============================================================================
            # OBSERVABLE WINDOW MANAGER GLASS PROPERTIES

            # Written by the window manager's layout engine.
            @frameGlass = ko.computed => geo.frame.create()

            # Properties from layout (actually don't need to be computed unless we allow for dynamism later)
            @cssGlassOpacity = ko.computed => @layout.glassOpacity
            @cssGlassBackgroundColor = ko.computed => @layout.glassBackgroundColor? and @layout.glassBackgroundColor or undefined
            @cssGlassBackground = ko.computed => @layout.glassBackgroundImage? and @layout.glassBackgroundImage  and "url(img/#{@layout.glassBackgroundImage})" or undefined

            # Properties from the window manager's layout engine
            @cssGlassWidth = ko.computed => @frameGlass().view.rectangle.width + "px"
            @cssGlassHeight = ko.computed => @frameGlass().view.rectangle.height + "px"
            @cssGlassMarginLeft = ko.computed => @frameGlass().view.offset.left + "px"
            @cssGlassMarginTop = ko.computed => @frameGlass().view.offset.top + "px"

            # ============================================================================
            # OBSERVABLE WINDOW MANAGER FRAME PROPERTIES

            # Written by the window manager's layout engine.
            @frameWindowManager = ko.observable geo.frame.create()

            # Properties from layout (actually don't need to be computed unless we allow for dynamism later)
            @cssWindowManagerBackgroundColor = ko.computed => @layout.windowManagerBackgroundColor
            @cssWindowManagerOpacity = ko.computed => @layout.windowManagerOpacity

            # Properties from the window manager's layout engine
            @cssWindowManagerWidth = ko.computed => @frameWindowManager().view.rectangle.width + "px"
            @cssWindowManagerHeight = ko.computed => @frameWindowManager().view.rectangle.height + "px"
            @cssWindowManagerMarginLeft = ko.computed => @frameWindowManager().view.offset.left + "px"
            @cssWindowManagerMarginTop = ko.computed => @frameWindowManager().view.offset.top + "px"

            @observableWindows = ko.observableArray []



            # ============================================================================
            # \ BEGIN RUNTIME CALLBACKS

            @refreshWindowManagerViewGeometriesFromDocument = =>
                try
                    documentEl = $(document)

                    # All extent properties one may obtain from the document object below.
                    # We're actually only using the outerWidth/Height(true) (aka margin extents)
                    # here. The others are left for experimentation and reference.
                    #      
                    # width =  @documentEl.width()
                    # height = @documentEl.height()
                    # innerWidth = @documentEl.innerWidth()
                    # innerHeight = @documentEl.innerHeight()
                    # outerWidth = @documentEl.outerWidth()
                    # outerHeight = @documentEl.outerHeight()
    
                    marginWidth = documentEl.outerWidth(true)
                    marginHeight = documentEl.outerHeight(true)

                    @documentOffsetRectangleObject(geo.offsetRectangle.createFromDimensions(marginWidth, marginHeight))


                catch exception
                    throw "ObservableWindowManager.getDocumentFrameObject: #{exception}"





            #
            # Given a new offset rectangle representing the "view", determine if we need to
            # re-evaluate the split stack.
            #
            
            @refreshWindowManagerViewState = (forceEval_) =>

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

            # / END RUNTIME CALLBACKS
            # ============================================================================


            Console.messageRaw("<h3>BUILDING DATA MODEL</h3>")
             

            ###

            # ============================================================================
            # \ BEGIN OBSERVABLE DATA MODEL INITIALIZATION

            if @layout.pageBackgroundColor? and @layout.pageBackgroundColor
                $("body").css { backgroundColor: @layout.pageBackgroundColor }

            #
            # The Window Manager takes as input a "layout" Javascript object.
            # The layout is declarative and is parsed here to produce this window manager's internal runtime
            # state model: a hierarchy of objects initialized using data from the layout. 
            #

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

            # / END OBSERVABLE DATA MODEL INITIALIZATION
            # ============================================================================

            ###


            # ============================================================================

            Console.messageRaw("<h3>SYNTHESIZING HTML VIEW TEMPLATES</h3>")


            Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_EncapsuleWindowManager", ( => """
                <div id="idWindowManagerGlass" onclick="Console.show()" data-bind="style: { width: cssGlassWidth(), height: cssGlassHeight(), marginLeft: cssGlassMarginLeft(), marginTop: cssGlassMarginTop(), background: cssGlassBackground(), opacity: cssGlassOpacity(), backgroundColor: cssGlassBackgroundColor() }"></div>
                <div id="#{@layout.id}" class="classObservableWindowManager" data-bind="style: { width: cssWindowManagerWidth(), height: cssWindowManagerHeight(), marginLeft: cssWindowManagerMarginLeft(), marginTop: cssWindowManagerMarginTop(), backgroundColor: cssWindowManagerBackgroundColor(), opacity: cssWindowManagerOpacity() }">#{@layout.id}::#{@layout.name}</div>
                """))

            windowManagerHtmlViewRootDocumentElement = Encapsule.code.lib.kohelpers.InstallKnockoutViewTemplates(@layout.id)



            # ============================================================================
            # BIND THE HTML VIEW TO THE WINDOW MANAGER'S OBVSERVABLE DATA MODELS.
            #
            ko.applyBindings @, windowManagerHtmlViewRootDocumentElement

            # ============================================================================
            # PENULTIMATE STEP: Update the view state to power-on defaults.
            #


            # ============================================================================
            # LASTLY, GO LIVE WITH VIEW STATE UPDATES IN RESPONSE TO BROWSER RESIZE EVENTS
            #
            # setInterval @refreshWindowManagerViewState, 5000 # This catches everything (including browser restore) eventually
            window.addEventListener 'resize', @refreshWindowManagerViewGeometriesFromDocument

            # ============================================================================
            Console.messageRaw("<h3>WINDOW MANAGER IS ONLINE</h3>")
            # / END INITIALIZATION OF WINDOW MANAGER OBJECT INSTANCE


        catch exception
            message = "In Encapsule.code.lib.kohelpers.WindowManager: #{exception}"
            throw message


        # / end of constructor

    # / end of class
