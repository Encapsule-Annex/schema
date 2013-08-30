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



# \ BEGIN: file scope

class Encapsule.code.lib.kohelpers.ObservableWindowHost
    constructor: (sourceDescriptor_) ->
        try
            # \ BEGIN: constructor try scope
            Console.message("""... + WindowManager creating new window host id="#{sourceDescriptor_.id}" name="#{sourceDescriptor_.name}""")

            geo = Encapsule.code.lib.geometry

            @sourceDescriptor = sourceDescriptor_

            @id = sourceDescriptor_.id
            @idHost = "#{@id}Host"
            @idChrome = "#{@id}Chrome"

            @name = sourceDescriptor_.name

            @windowEnabled = ko.observable sourceDescriptor_.initialEnable
            @windowMode = ko.observable sourceDescriptor_.initialMode

            @offsetRectangleHost = ko.observable geo.offsetRectangle.create()
            @offsetRectangleChrome = ko.observable geo.offsetRectangle.create()
            @offsetRectangleWindow = ko.observable geo.offsetRectangle.create()

            @hostedModelView = ko.observable undefined
            if sourceDescriptor_.MVVM? and sourceDescriptor_.MVVM

                MVVM = sourceDescriptor_.MVVM
                if not MVVM.viewModelTemplateId? or not MVVM.viewModelTemplateId
                    throw "Missing viewModelTemplateId specifiction in window layout declaration."

                if not MVVM.modelView? and not MVVM.fnModelView?
                    throw "You must specify either the class of the observable model view to instantiate, or a function to be called to retrieve the object instance."

                if MVVM.modelView? and MVVM.fnModelView?
                    throw "modelView and fnModel view are mutually exclusive and you specified both. Please specify one or the other."

                hostedModelView = undefined

                if MVVM.modelView
                    hostedModelView = new sourceDescriptor_.MVVM.modelView
                    if not (hostedModelView? and hostedModelView)
                        throw "Check your MVVM.modelView declaration. We tried to new the object you specified but it didn't work."

                if MVVM.fnModelView
                    hostedModelView = MVVM.fnModelView()
                    if not (hostedModelView? and hostedModelView)
                        throw "Check your MVVM.fnModelView declaration. We called the function you specified but it returned an undefined result."
                    

                if not hostedModelView? or not hostedModelView
                    throw "Unable to obtain object instance of the specified observable class to host in this window."

                @hostedModelView(hostedModelView)


            try
                # \ BEGIN: try scope
               
                # Observable properties of the classObservableWindowHost DIV

                @windowInDOM = ko.computed => @offsetRectangleHost().rectangle.hasArea and @windowEnabled()
                @cssHostWidth = ko.computed => Math.round(@offsetRectangleHost().rectangle.extent.width) + "px"
                @cssHostHeight = ko.computed => Math.round(@offsetRectangleHost().rectangle.extent.height) + "px"
                @cssHostMarginLeft = ko.computed => Math.round(@offsetRectangleHost().offset.left) + "px"
                @cssHostMarginTop = ko.computed => Math.round(@offsetRectangleHost().offset.top) + "px"
                @cssHostOpacity = ko.observable @sourceDescriptor.globalWindowAttributes.hostWindowOpacity
                @cssHostBackgroundColor = ko.observable @sourceDescriptor.globalWindowAttributes.hostWindowBackgroundColor

                # Observable properties of the classObservableWindowChrome DIV

                @cssChromeWidth = ko.computed => Math.round(@offsetRectangleChrome().rectangle.extent.width) + "px"
                @cssChromeHeight = ko.computed => Math.round(@offsetRectangleChrome().rectangle.extent.height) + "px"
                @cssChromeMarginLeft = ko.computed => Math.round(@offsetRectangleChrome().offset.left) + "px"
                @cssChromeMarginTop = ko.computed => Math.round(@offsetRectangleChrome().offset.top) + "px"
                @cssChromeOpacity = ko.observable @sourceDescriptor.globalWindowAttributes.chromeWindowOpacity
                @cssChromeBackgroundColor = ko.observable @sourceDescriptor.globalWindowAttributes.chromeWindowBackgroundColor

                # Observable properties of the classObservableWindow DIV (this is the DIV that contains the actual client window)

                @cssWindowWidth = ko.computed => Math.round(@offsetRectangleWindow().rectangle.extent.width) + "px"
                @cssWindowHeight = ko.computed => Math.round(@offsetRectangleWindow().rectangle.extent.height) + "px"
                @cssWindowMarginLeft = ko.computed => Math.round(@offsetRectangleWindow().offset.left) + "px"
                @cssWindowMarginTop = ko.computed => Math.round(@offsetRectangleWindow().offset.top) + "px"
                @cssWindowOpacity = ko.observable @sourceDescriptor.opacity
                @cssWindowBackgroundColor = ko.observable @sourceDescriptor.backgroundColor
                @cssWindowBorder = ko.observable "#{@sourceDescriptor.globalWindowAttributes.windowBorderWidth}px solid #{@sourceDescriptor.globalWindowAttributes.windowBorderColor}"
                @cssWindowPadding = ko.observable @sourceDescriptor.globalWindowAttributes.windowPadding + "px"
                @cssWindowOverflow = ko.observable "hidden"
                if @sourceDescriptor.overflow? and @sourceDescriptor.overflow
                    @cssWindowOverflow(@sourceDescriptor.overflow)

                # / END try scope
            catch exception
                throw "ObservableWindowHost failed first execution of observable properties: #{exception}"

            # \ BEGIN: toggleWindowMode
            @toggleWindowMode = =>
                # \ BEGIN: toggleWindowMode scope
                try
                    # \ BEGIN: toggleWindowMode try scope
                    currentMode = @windowMode()
                    if currentMode == "full" then @windowMode("min") else @windowMode("full")
                    Encapsule.runtime.app.SchemaWindowManager.refreshWindowManagerViewState( { geometriesUpdated: true } )
                    # / END: toggleWindowMode try scope
                catch exception
                    throw "Error attempting to toggle observable window #{@id}'s mode: #{exception}"
                # / END: toggleWIndowMode scope
            # / END: toggleWindowMode

            # \ BEGIN: onMouseOver
            @onMouseOver = =>
                #Console.message("Mouse over #{@id}")
                @cssHostOpacity(1)
                @cssChromeOpacity(1)
                @cssWindowOpacity(1)
            # / END: onMouseOver

            # \ BEGIN: onMouseOut
            @onMouseOut = =>
                #Console.message("Mouse out #{@id}")
                @cssHostOpacity(@sourceDescriptor.globalWindowAttributes.hostWindowOpacity)
                @cssChromeOpacity( @sourceDescriptor.globalWindowAttributes.chromeWindowOpacity)
                @cssWindowOpacity(@sourceDescriptor.opacity)
            # / END: onMouseOut
           

            # \ BEGIN: setOffsetRectangle scope
            @setOffsetRectangle = (offsetRectangle_) =>
                # \ BEGIN: setOffsetRectangle function scope
                try
                    # \BEGIN: try scope
                        # We will do some checking here to ensure that a change actually occurred.
                        # If so, then we will update the Knockout.js observables contained by thie ObservableWindow instance
                        Console.message("Observable window offset rectangle updated: #{offsetRectangle_.rectangle.extent.width} x #{offsetRectangle_.rectangle.extent.height} // #{offsetRectangle_.offset.left}, #{offsetRectangle_.offset.top}")
                        @offsetRectangleHost(offsetRectangle_)

                        marginsChrome = geo.margins.createUniform(@sourceDescriptor.globalWindowAttributes.hostWindowPadding)
                        chromeFrame = geo.frame.createFromOffsetRectangleWithMargins(offsetRectangle_, marginsChrome)
                        @offsetRectangleChrome(chromeFrame.view)

                        chromePadding = @sourceDescriptor.globalWindowAttributes.chromeWindowPadding
                        windowBorderWidth = @sourceDescriptor.globalWindowAttributes.windowBorderWidth
                        windowPadding = @sourceDescriptor.globalWindowAttributes.windowPadding * 2

                        marginsWindow = geo.margins.createForPixelDimensions(chromePadding, chromePadding, chromePadding + windowBorderWidth + windowPadding, chromePadding + windowBorderWidth + windowPadding)

                        windowFrame = geo.frame.createFromOffsetRectangleWithMargins(chromeFrame.view, marginsWindow)
                        @offsetRectangleWindow(windowFrame.view)

                    # / END: try scope
                catch exception
                    throw "Observable window host failed to set offset rectangle: #{exception}"
                # / END: setOffsetRectangle function scope

            # / END: constructor try scope
        catch exception
            throw "ObservableWindow constructor fail: #{exception}"
        # / END: constructor scope
    # / END: class scope
# / END: file scope
            


