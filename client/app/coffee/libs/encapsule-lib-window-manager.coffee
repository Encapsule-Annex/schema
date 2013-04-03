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
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.kohelpers = Encapsule.code.lib.kohelpers? and Encapsule.code.lib.kohelpers or @Encapsule.code.lib.kohelpers = {}
Encapsule.code.lib.kohelpers.implementation = Encapsule.code.lib.kohelpers.implementation? and Encapsule.code.lib.kohelpers.implementation or @Encapsule.code.lib.kohelpers.implementation = {}


Encapsule.runtime = Encapsule.runtime? and Encapsule.runtime or @Encapsule.runtime = {}
Encapsule.runtime.app = Encapsule.runtime.app? and Encapsule.runtime.app or @Encapsule.runtime.app = {}

Encapsule.runtime.app.windowmanager = Encapsule.runtime.app.windowmanager? and Encapsule.runtime.app.windowmanager or @Encapsule.runtime.app.windowmanager = {}

Encapsule.runtime.app.kotemplates = Encapsule.runtime.app.kotemplates? and Encapsule.runtime.app.kotemplates or @Encapsule.runtime.app.kotemplates = []


class Encapsule.code.lib.kohelpers.ObservableWindowManager

    constructor: (layout_) ->

        try
            Encapsule.code.app.setBootChrome("schemaStart")


            # ============================================================================
            # PARAMETER VALIDATION

            if not layout_? or not layout_ then throw "You must specify a layout to construct an ObservableWindowManager instance."

            Console.messageRaw("<h2>#{layout_.name}</h2>")
            Console.message("#{appPackagePublisher} window manager boot for layout declaration id=#{layout_.id} name=\"#{layout_.name}\"")

            # ============================================================================
            # NAMESPACE ALIASES
            geo = Encapsule.code.lib.geometry


            # ============================================================================
            # GLOBAL WINDOW MANAGER OBSERVABLE CONTROL KNOBS
            # Initialized from layout data. May be modified by application logic.
            # \ BEGIN: control knobs

            try
                # BEGIN: try scope
                @pageBackgroundColor = ko.observable layout_.pageBackgroundColor? and layout_.pageBackgroundColor or "white"
                @glassOpacity = ko.observable layout_.glassOpacity? and layout_.glassOpacity or undefined
                @glassBackgroundColor = ko.observable layout_.glassBackgroundColor? and layout_.glassBackgroundColor or undefined
                @glassBackgroundImage = ko.observable layout_.glassBackgroundImage? and layout_.glassBackgroundImage  and "url(img/#{layout_.glassBackgroundImage})" or undefined
                @glassMargin = ko.observable undefined
                if layout_.glassMargin? then @glassMargin(layout_.glassMargin) else @glassMargin(10)
                @windowManagerBackgroundColor = ko.observable layout_.windowManagerBackgroundColor? and layout_.windowManagerBackgroundColor or "white"
                @windowManagerMargin = ko.observable undefined
                if layout_.windowManagerMargin? then @windowManagerMargin(layout_.windowManagerMargin) else @windowManagerMargin(10)
                @windowManagerPadding = ko.observable undefined
                if layout_.windowManagerPadding? then @windowManagerPadding(layout_.windowManagerPadding) else @windowManagerPadding(10)
                @windowManagerOpacity = ko.observable layout_.windowManagerOpacity
                # END: try scope
            catch exception
                throw "Check your control knob declaration(s): #{exception}"
            # / END: control knobs

            # ============================================================================
            # NON-OBSERVABLE INTERNAL INSTANCE STATE

            # Deep copy the layout. Changes must be made by calling the CONTROL KNOBS above.
            @layout = Encapsule.code.lib.js.clone(layout_)

            # An array of plane objects that manager a layout splitter stack.
            @planes = []

            @currentDisplayPlaneId = undefined
            @planesDictionary = {}
            @windowsDictionary = {} 

            # Written by document resize event callback.
            @documentOffsetRectangle = geo.offsetRectangle.create()

            # ============================================================================
            # INTERNAL IMPLEMENTATION OBSERVABLE / COMPUTED

            # \ BEGIN: implementation observable/computed
            try
                # \ BEGIN: observable/computed try scope

                @setPageBackgroundColor = ko.computed => 
                    backgroundColor = @pageBackgroundColor()
                    if backgroundColor? and backgroundColor
                        $("body").css { backgroundColor: backgroundColor }

                @glassOffsetRectangle = ko.observable geo.offsetRectangle.create()
                @cssGlassWidth = ko.computed =>  Math.round(@glassOffsetRectangle().rectangle.extent.width) + "px"
                @cssGlassHeight = ko.computed => Math.round(@glassOffsetRectangle().rectangle.extent.height) + "px"
                @cssGlassMarginLeft = ko.computed => Math.round(@glassOffsetRectangle().offset.left) + "px"
                @cssGlassMarginTop = ko.computed => Math.round(@glassOffsetRectangle().offset.top) + "px"
                @cssGlassOpacity = ko.computed => @glassOpacity()
                @cssGlassBackgroundColor = ko.computed => @glassBackgroundColor()
                @cssGlassBackground = ko.computed => @glassBackgroundImage()

                @windowManagerOffsetRectangle = ko.observable geo.offsetRectangle.create()
                @cssWindowManagerBackgroundColor = ko.computed => @windowManagerBackgroundColor()
                @cssWindowManagerOpacity = ko.computed => @windowManagerOpacity()
                @cssWindowManagerWidth = ko.computed => Math.round(@windowManagerOffsetRectangle().rectangle.extent.width) + "px"
                @cssWindowManagerHeight = ko.computed => Math.round(@windowManagerOffsetRectangle().rectangle.extent.height) + "px"
                @cssWindowManagerMarginLeft = ko.computed => Math.round(@windowManagerOffsetRectangle().offset.left) + "px"
                @cssWindowManagerMarginTop = ko.computed => Math.round(@windowManagerOffsetRectangle().offset.top) + "px"

                @observableWindows = ko.observableArray []
                # / END: observable/computed try scope

            catch exception
               throw "Failed evaluating implementation observable/computed declaration: #{exception}"
            # / END: internal observable/computed

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
                    # width =  documentEl.width()
                    # height = documentEl.height()
                    width = documentEl.innerWidth()
                    height = documentEl.innerHeight()
                    # outerWidth = documentEl.outerWidth()
                    # outerHeight = documentEl.outerHeight()
    
                    marginWidth = documentEl.outerWidth(true)
                    marginHeight = documentEl.outerHeight(true)

                    if (width == @documentOffsetRectangle.rectangle.extent.width) and (height == @documentOffsetRectangle.rectangle.extent.width)
                        Console.message("Callback to document resize handler ignored: no change in base window dimensions.")
                        return;

                    @documentOffsetRectangle = geo.offsetRectangle.createFromDimensions(width, height)

                    marginsGlass = geo.margins.createUniform(@glassMargin())
                    frameGlass = geo.frame.createFromOffsetRectangleWithMargins(@documentOffsetRectangle, marginsGlass)
                    @glassOffsetRectangle(frameGlass.view)

                    marginsWindowManager = geo.margins.createUniform(@windowManagerMargin())
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

                            windowManagerClientMargins = geo.margins.createUniform(@windowManagerPadding())
                            windowManagerClientFrame = geo.frame.createFromOffsetRectangleWithMargins(windowManagerOffsetRectangle, windowManagerClientMargins)
                            windowManagerClientOffsetRectangleMinusReserve = Encapsule.code.lib.js.clone windowManagerClientFrame.view

                            for plane in @planes
                                # \ BEGIN: plane scope
                                try
                                    # \ BEGIN: try plane scope
                                    windowManagerClientOffsetRectangle = windowManagerClientOffsetRectangleMinusReserve
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
                                     if plane.windowManagerReservePlane? and (plane.windowManagerReservePlane == true)
                                         windowManagerClientOffsetRectangleMinusReserve = windowManagerClientOffsetRectangle
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
                Encapsule.code.app.setBootChrome("schemaModelView")    
                #
                # The Window Manager takes as input a "layout" Javascript object.
                # The layout is declarative and is parsed here to produce this window manager's internal runtime
                # state model: a hierarchy of objects initialized using data from the layout. 
                #

                # Create the control panel object.
                Encapsule.runtime.app.windowmanager.WindowManagerControlPanel = new Encapsule.code.lib.kohelpers.implementation.ObservableWindowManagerControlPanel(@)
    
                try
                    # Add the special windowManagerReservePlane: true window manager control panel plane to the top
                    # of the plane array.
                    
                    @layout.planes.unshift Encapsule.code.lib.kohelpers.implementation.WindowManagerControlPanelPlane
 

                    # @@@
                    # \ BEGIN: try scope (note extensive error checking to catch errors in the input layout declaration)
                    planeIndex = 0
                    for planeLayout in @layout.planes
                        # \ BEGIN: planeLayout scope
                        try
                            # @@@
                            # BEGIN: planeLayout try scope
                            planeRuntime = { id: planeLayout.id, name: planeLayout.name, splitterStack: [], windowManagerReservePlane: planeLayout.windowManagerReservePlane }
                            planeRuntime.enabled = ko.observable planeLayout.windowManagerReservePlane or planeLayout.initialEnable
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
                                        newSplit = new Encapsule.code.lib.kohelpers.WindowSplitter( split,  @layout.globalWindowAttributes, splitterObservableWindows)
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
                                                @windowsDictionary[observableWindow.id] = { window: observableWindow, plane: planeRuntime }
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
                        @planesDictionary[planeRuntime.id] = planeRuntime
                        planeIndex++
                        Console.message("Layout plane #{planeIndex} processed.")
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
                Encapsule.code.app.setBootChrome("schemaViewModel")
                try
                    Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate "idKoTemplate_EncapsuleWindowManager" , =>
                        Encapsule.code.lib.kohelpers.implementation.SynthesizeWindowManagerViewModelFromLayoutDeclaration(@layout)
                    windowManagerHtmlViewRootDocumentElement = Encapsule.code.lib.kohelpers.InstallKnockoutViewTemplates(@layout.id)
                    Console.message("Okay")
                catch exception
                    throw "View template librarian init failure: #{exception}"
                    
            catch exception
                throw "Window manager view model init failure: #{exception}"
    
    

            # ============================================================================
            # BIND THE HTML VIEW TO THE WINDOW MANAGER'S OBVSERVABLE DATA MODELS USING KNOCKOUT.JS
            #
            Console.messageRaw "<h3>BINDING MODEL-VIEW/VIEW-MODEL (MVVM) VIA KNOCKOUT.JS</h3>"
            Encapsule.code.app.setBootChrome("schemaBind")
            try
                ko.applyBindings @ , windowManagerHtmlViewRootDocumentElement
                Console.message("#{layout_.id} #{layout_.name} Model-View/View-Model (MVVM) binding completed.")
            catch exception
                throw """MVVM binding operation failed. Knockout.js reports: #{exception}"""

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
            Encapsule.code.app.setBootChrome("schemaRender")
            try
                @refreshWindowManagerViewGeometriesFromDocument()
                @setPageBackgroundColor()
                Console.message("Okay")
            catch exception
                throw "Initial window manager geometries refresh failed: #{exception}"

            Console.messageRaw("<h3>REGISTERING EVENT LISTENERS</h3>")
            # Automatically refresh the window manager's geometries when the the browser window resizes.
            window.addEventListener 'resize', @refreshWindowManagerViewGeometriesFromDocument
            Console.message("Okay.")

            # setInterval @refreshWindowManagerViewState, 5000 # This catches everything (including browser restore) eventually
            $("#idEncapsuleWindowManagerHost").fadeIn layout_.fadeinTimeMs

            Console.messageRaw("<p><strong>#{appPackagePublisher} window manager initialization complete.</strong></p>")

            # ============================================================================
            # ENTER INTERACTIVE MODE
            Encapsule.code.app.setBootChrome("schemaWelcome")
            Console.messageRaw("<h2>#{appName} v#{appVersion} entering interactive mode :)</h2>")

            # ============================================================================
            # Window manager methods

            @displayPlane = (planeId_) =>
                try
                    targetPlane = @planesDictionary[planeId_]
                    if not targetPlane? or not targetPlane
                        throw """Unknown plane ID "#{planeId} specified."""

                    if @currentDisplayPlaneId? and @currentDisplayPlaneId
                        if @curreuntDisplayPlaneId == planeId_
                            return false
                        @planesDictionary[@currentDisplayPlaneId].enabled(false)

                    targetPlane.enabled(true)

                    @currentDisplayPlaneId = planeId_

                catch exception
                    Console.messageError("""ObservableWindowManger.displayPlane("#{planeId_}") fail: #{exception}""")


            # / END INITIALIZATION OF WINDOW MANAGER OBJECT INSTANCE


        catch exception
            throw """Window manager initialization failed for layout.id="#{layout_.id}": #{exception}"""

        # / end of constructor

    # / end of class



