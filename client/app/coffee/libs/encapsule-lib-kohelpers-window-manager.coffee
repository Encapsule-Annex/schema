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
            Console.message("#{appPackagePublisher} window manager boot for layout declaration id=#{@layout.id} name=\"#{@layout.name}\"")

            # An array of plane objects that manager a layout splitter stack.
            @planes = []


            # Written by document resize event callback.
            @documentOffsetRectangle = geo.offsetRectangle.create()


            # ============================================================================
            # OBSERVABLES
            #

            #
            # ============================================================================
            # OBSERVABLE WINDOW MANAGER WINDOW PROPERTIES
            #


            # ============================================================================
            # OBSERVABLE WINDOW MANAGER GLASS PROPERTIES

            @glassOffsetRectangle = ko.observable geo.offsetRectangle.create()


            # Properties from layout (actually don't need to be computed unless we allow for dynamism later)
            @cssGlassOpacity = ko.computed => @layout.glassOpacity
            @cssGlassBackgroundColor = ko.computed => @layout.glassBackgroundColor? and @layout.glassBackgroundColor or undefined
            @cssGlassBackground = ko.computed => @layout.glassBackgroundImage? and @layout.glassBackgroundImage  and "url(img/#{@layout.glassBackgroundImage})" or undefined

            # Properties from the window manager's layout engine
            @cssGlassWidth = ko.computed =>  @glassOffsetRectangle().rectangle.extent.width + "px"
            @cssGlassHeight = ko.computed => @glassOffsetRectangle().rectangle.extent.height + "px"
            @cssGlassMarginLeft = ko.computed => @glassOffsetRectangle().offset.left + "px"
            @cssGlassMarginTop = ko.computed => @glassOffsetRectangle().offset.top + "px"

            # ============================================================================
            # OBSERVABLE WINDOW MANAGER FRAME PROPERTIES

            @windowManagerOffsetRectangle = ko.observable geo.offsetRectangle.create()

            # Properties from layout (actually don't need to be computed unless we allow for dynamism later)
            @cssWindowManagerBackgroundColor = ko.computed => @layout.windowManagerBackgroundColor
            @cssWindowManagerOpacity = ko.computed => @layout.windowManagerOpacity

            # Properties from the window manager's layout engine
            @cssWindowManagerWidth = ko.computed => @windowManagerOffsetRectangle().rectangle.extent.width + "px"
            @cssWindowManagerHeight = ko.computed => @windowManagerOffsetRectangle().rectangle.extent.height + "px"
            @cssWindowManagerMarginLeft = ko.computed => @windowManagerOffsetRectangle().offset.left + "px"
            @cssWindowManagerMarginTop = ko.computed => @windowManagerOffsetRectangle().offset.top + "px"

            @observableWindows = ko.observableArray []

            # ============================================================================
            # \ BEGIN: RUNTIME CALLBACKS

            @refreshWindowManagerViewGeometriesFromDocument = =>
                # \ BEGIN: function scope
                try
                    # \ BEGIN: try
                    documentEl = $(document)
                    geo = Encapsule.code.lib.geometry

                    Console.messageRaw("<h4>BASE WINDOW EXTENT UPDATE</h4>")

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

                    if (marginWidth == @documentOffsetRectangle.rectangle.extent.width) and (marginHeight == @documentOffsetRectangle.rectangle.extent.width)
                        Console.message("Callback to document resize handler ignored: no change in base window dimensions.")
                        return;

                    @documentOffsetRectangle = geo.offsetRectangle.createFromDimensions(marginWidth, marginHeight)

                    marginsGlass = geo.margins.createUniform(@layout.glassMargin)
                    frameGlass = geo.frame.createFromOffsetRectangleWithMargins(@documentOffsetRectangle, marginsGlass)
                    @glassOffsetRectangle(frameGlass.view)

                    marginsWindowManager = geo.margins.createUniform(@layout.windowManagerMargin)
                    frameWindowManager = geo.frame.createFromOffsetRectangleWithMargins(frameGlass.view, marginsWindowManager)
                    @windowManagerOffsetRectangle(frameWindowManager.view)

                    @refreshWindowManagerViewState { geometriesUpdated: true }

                    # / END: try

                catch exception
                    Console.messageError "Window geometries refresh failed: #{exception}"

                # / END: function scope

            #
            # Given a new offset rectangle representing the "view", determine if we need to
            # re-evaluate the split stack.
            #
            #
            # request : {
            #    forceEval: false                 # true or false (default if undefined)
            #    geometriesUpdated: true              # true or false (default if undefined)
            #
            
            @refreshWindowManagerViewState = (request_) =>

                # \ BEGIN: refreshWindowManagerViewState function scope
                try

                    # \ BEGIN: refreshWindowManagerViewState try scope

                    if not request_? then throw "Missing refresh request parameter."
                    if not request_ then throw "Missing refresh request value."

                    Console.messageRaw("<h4>WINDOW MANAGER VIEW STATE UPDATE</h4>")

                    request = {
                        forceEval: request_.forceEval? and request_.forceEval or false
                        geometriesUpdated: request_.geometriesUpdated? and request_.geometriesUpdated or false
                    }

                    # \ BEGIN: geometries update section
                    if request.forceEval or request.geometriesUpdated
                        # \ BEGIN: geometries update scope
                        try
                            # \ BEGIN: geometries update try scope

                            runtimeState = @runtimeState
                            windowManagerOffsetRectangle = @windowManagerOffsetRectangle()

                            windowManagerClientMargins = geo.margins.createUniform 10
                            windowManagerClientFrame = geo.frame.createFromOffsetRectangleWithMargins(windowManagerOffsetRectangle, windowManagerClientMargins)
                            windowManagerClientOffsetRectangle = windowManagerClientFrame.view

                            for plane in @planes
                                # \ BEGIN: plane scope
                                try
                                    # \ BEGIN: try plane scope
                                    splitters = plane.splitterStack
                                    for split in splitters
                                        # \ BEGIN: split scope
                                        try
                                            # \ BEGIN: try split scope
                                            Console.message("<strong>Window manager refresh on plane #{plane.id} split #{split.id}</b>")
                                            Console.message("... Available client offset rectangle #{windowManagerClientOffsetRectangle.rectangle.extent.width} x #{windowManagerOffsetRectangle.rectangle.extent.width}")
                                            windowManagerClientOffsetRectangle = split.setOffsetRectangle(windowManagerClientOffsetRectangle, true)
                                            # / END: try split scope
                                        catch exception
                                            throw "Splitter #{split.id} fail: #{exception}"
                                        # / END: split scope
                                     # / END: try plane scope
                                catch exception
                                    throw "Plane #{plane.id} fail: #{exception}"
                                # / END: plane scope
                            # / END: geometries update try scope

                        catch exception
                            throw "Base window manager geometries refresh fail: #{exception}"
                        # / END: geometries update
                    # / END: geometries update section
                    # / END: refreshWindowManagerViewState try scope

                catch exception
                    Console.messageError "Failed to refresh window manager view state: #{exception}"
                # / END: refreshWindowManagerViewState function scope




            # / END RUNTIME CALLBACKS
            # ============================================================================

            Console.messageRaw("<h3>SYNTHESIZING MODEL-VIEW FROM LAYOUT DECLARATION</h3>")
            Console.message("Building observable Javascript object hierarchy...")

            # ============================================================================
            # \ BEGIN: OBSERVABLE DATA MODEL INITIALIZATION
            try
    
                if @layout.pageBackgroundColor? and @layout.pageBackgroundColor
                    $("body").css { backgroundColor: @layout.pageBackgroundColor }
    
                #
                # The Window Manager takes as input a "layout" Javascript object.
                # The layout is declarative and is parsed here to produce this window manager's internal runtime
                # state model: a hierarchy of objects initialized using data from the layout. 
                #
    
                try
                    # @@@
                    # \ BEGIN: try scope (note extensive error checking to catch errors in the input layout declaration)
                    planeIndex = 0
                    for planeLayout in @layout.planes
                        # \ BEGIN: planeLayout scope
                        try
                            # @@@
                            # BEGIN: planeLayout try scope
                            planeRuntime = { id: planeLayout.id, name: planeLayout.name, splitterStack: [] }
                            splitIndex = 0
                            for split in planeLayout.splitterStack
                                # \ BEGIN: split scope
                                try
                                    # @@@
                                    # \ BEGIN: split try scope
                                    Console.message("Window manager: Starting plane #{planeIndex} split #{splitIndex} ...")
                                    Console.message """... id = #{split.id} &bull; #{split.name} &bull; #{split.type} &bull; Q1 window descriptor = #{split.Q1WindowDescriptor} &bull; Q2 window descriptor = #{split.Q2WindowDescriptor}"""
                                    splitterObservableWindows = []
                                    newSplit = undefined
                                    try
                                        newSplit = new Encapsule.code.lib.kohelpers.WindowSplitter( split, splitterObservableWindows )
                                    catch exception
                                        throw "Splitter instantiation failure: #{exception}"
                                    try
                                        planeRuntime.splitterStack.push newSplit
                                    catch exception
                                        throw "Splitter push failure: #{exception}"
                                    try
                                        # \ BEGIN: try
                                        for observableWindow in splitterObservableWindows
                                            # \ BEGIN: observableWindow scope
                                            try
                                                @observableWindows.push observableWindow
                                            catch exception
                                                throw "Observable window pool push failure: #{exception}"
                                            # / END: observableWindow scope
                                        # / END: try
                                    catch exception
                                        throw "Observable window instantiation failure: #{exception}"
                                    #
                                    Console.message("... Layout #{planeIndex} #{splitIndex} processed.")
                                    splitIndex++
                                    # / END: split try scope
                                    # @@@
                                catch exception
                                    throw """Splitter ##{splitIndex} id="#{split.id}" failure: #{exception}"""
                                # / END: split scope
                            # / END: planeLayout try scope
                            # @@@
                        catch exception
                            throw """Layout plane ##{planeIndex} id="#{planeLayout.id}" failure: #{exception}"""
                        @planes.push planeRuntime
                        Console.message("Layout plane #{planeIndex} processed.")
                        planeIndex++
                        # / END: planeLayout scope
                    # / END: try scope
                    # @@@
                catch exception
                        throw exception

            catch exception
                throw "Data model init failure: #{exception}"

            Console.message("Done transforming layout into view model :)")

            # / END OBSERVABLE DATA MODEL (VIEW-MODEL) INITIALIZATION
            # ============================================================================



            # ============================================================================
            try
                Console.messageRaw("<h3>SYNTHESIZING VIEW-MODEL TEMPLATES</h3>")
                try
                    htmlView = """
                        <div id="idWindowManagerGlass" onclick="Console.show()" data-bind="style: { width: cssGlassWidth(), height: cssGlassHeight(), marginLeft: cssGlassMarginLeft(), marginTop: cssGlassMarginTop(), background: cssGlassBackground(), opacity: cssGlassOpacity(), backgroundColor: cssGlassBackgroundColor() }"></div>
                        <div id="#{@layout.id}" class="classObservableWindowManager" data-bind="style: { width: cssWindowManagerWidth(), height: cssWindowManagerHeight(), marginLeft: cssWindowManagerMarginLeft(), marginTop: cssWindowManagerMarginTop(), backgroundColor: cssWindowManagerBackgroundColor(), opacity: cssWindowManagerOpacity() }">
                            #{@layout.id}::#{@layout.name}
                            <span class="classWindowManagerObservableWindowHosts" data-bind="template: { name: 'idKoTemplate_EncapsuleWindowManagerObservableWindowHosts', foreach: observableWindows }"></span>
                        </div>
                        """
                    Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate "idKoTemplate_EncapsuleWindowManager" , => htmlView
                    Console.message("Okay.")
                catch exception
                    throw "Top-level HTML view synthesis failure: #{exception}"
    
                Console.messageRaw("<h3>INSTALLING VIEW-MODEL TEMPLATES</h3>")
                try
                    windowManagerHtmlViewRootDocumentElement = Encapsule.code.lib.kohelpers.InstallKnockoutViewTemplates(@layout.id)
                    Console.message("Okay")
                catch exception
                    throw "View template librarian init failure: #{exception}"
                    
            catch exception
                throw "Window manager view init failure: #{exception}"
    
    

            # ============================================================================
            # BIND THE HTML VIEW TO THE WINDOW MANAGER'S OBVSERVABLE DATA MODELS USING KNOCKOUT.JS
            #
            Console.messageRaw "<h3>BINDING MODEL-VIEW/VIEW-MODEL (MVVM) VIA KNOCKOUT.JS</h3>"
            try
                ko.applyBindings @ , windowManagerHtmlViewRootDocumentElement # <- THIS IS FUCKING AWESOME
                Console.message("#{@layout.id} #{@layout.name} Model-View/View-Model (MVVM) binding completed.")
            catch exception
                throw """Failed MVVM binding. Knockout.js is upset: #{exception}"""

            #
            # At this point the DOM is wired to the window manager's data model via Knockout.js.
            #
            # Window manager's "data model" is a set of "observable objects". An "observable object"
            # is a Javascript object that contains one or more "observables".
            #
            # An "observable" is an instance of ko.observable or ko.observableArray provided by
            # the Knockout.js library.
            #
            # The "binding" above builds the mapping between specific observable object
            # types and specific HTML view templates that are used to "project" a view of an
            # observable object's data into a "view" rendered in HTML5/CSS3.
            #

            # ============================================================================
            # Obtain the current extent of document and update the offset rectangles used to determine
            # the coordinates of the window manager glass and main windows.
            Console.messageRaw("<h3>INITIALIZING SCREEN LAYOUT</h3>")
            try
                @refreshWindowManagerViewGeometriesFromDocument()
                Console.message("Okay")
            catch exception
                throw "Initial window manager geometries refresh failed: #{exception}"

            Console.messageRaw("<h3>REGISTERING EVENT LISTENERS</h3>")
            # Automatically refresh the window manager's geometries when the the browser window resizes.
            window.addEventListener 'resize', @refreshWindowManagerViewGeometriesFromDocument
            Console.message("Okay.")

            # setInterval @refreshWindowManagerViewState, 5000 # This catches everything (including browser restore) eventually
            $("#idEncapsuleWindowManagerHost").fadeIn @layout.windowManagerFadeInTimeout

            Console.messageRaw("<p><strong>#{appPackagePublisher} window manager initialization complete.</strong></p>")

            # ============================================================================
            Console.messageRaw("<h2>#{appName} v#{appVersion} entering interactive mode :)</h2>")
            # / END INITIALIZATION OF WINDOW MANAGER OBJECT INSTANCE


        catch exception
            throw """Window manager initialization failed for layout.id="#{@layout.id}": #{exception}"""



        # / end of constructor

    # / end of class
