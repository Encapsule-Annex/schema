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
        Console.message("Initializing #{appName} data model.")

        #
        # These are the top-level data models for each of Schema's main application windows.
        #      

        @viewToolbar = ko.observable new Encapsule.code.app.SchemaViewModelSvgPlane()
        @viewToolbarMode = ko.observable "full"
        @viewToolbarEnable = ko.observable true

        @viewNavigator = ko.observable new Encapsule.code.app.SchemaViewModelNavigator()
        @viewNavigatorMode = ko.observable "full"
        @viewNavigatorEnable = ko.observable true

        @viewSvgPlane = ko.observable new Encapsule.code.app.SchemaViewModelSvgPlane()
        @viewSvgPlaneMode = ko.observable "full"
        @viewSvgPlaneEnable = ko.observable true


        @viewSelect1 = ko.observable new Encapsule.code.app.SchemaViewModelSvgPlane()
        @viewSelect1Mode = ko.observable "full"
        @viewSelect1Enable = ko.observable true

        @viewSelect2 = ko.observable new Encapsule.code.app.SchemaViewModelSvgPlane()
        @viewSelect2Mode = ko.observable "full"
        @viewSelect2Enable = ko.observable true

        @viewEdit1 = ko.observable new Encapsule.code.app.SchemaViewModelSvgPlane()
        @viewEdit1Mode = ko.observable "full"
        @viewEdit1Enable = ko.observable true

        @viewFrameStack = ko.observable new Encapsule.code.app.SchemaViewModelSvgPlane()
        @viewFrameStackMode = ko.observable "full"
        @viewFrameStackEnable = ko.observable true

        #
        # All of this is to keep track of the inner dimensions of the browser window.
        # The knockout observables should be considered as inputs written by either
        # a 'resize' event or timer (used to catch problems with restore from full-screen).
        #

        @mainViewOffset = 15

        @documentRect = {}
        @documentRect.width = 0
        @documentRect.height = 0
        @observableWidth = ko.observable 0
        @cssWidth = ko.computed => @observableWidth() + "px"
        @observableHeight = ko.observable 0
        @cssHeight = ko.computed => @observableHeight() + "px"
        @observableOffsetLeft = ko.observable 0
        @cssOffsetLeft = ko.computed => @observableOffsetLeft() + "px"
        @observableOffsetTop = ko.observable 0
        @cssOffsetTop = ko.computed => @observableOffsetTop() + "px"
        @documentRectRefresh = =>

            twiddleFactor = 2

            # Determine the total area available for the Schema view model.
            queryEl = $(document) 

            @documentRect.widthActual =  queryEl.innerWidth()
            @documentRect.heightActual = queryEl.innerHeight()

            @documentRect.width = @documentRect.widthActual - twiddleFactor
            @documentRect.height = @documentRect.heightActual - twiddleFactor

            @observableWidth(@documentRect.width)
            @observableHeight(@documentRect.height)
            @observableOffsetLeft(  Math.round (@documentRect.width  / -2 ) - 1 )
            @observableOffsetTop(   Math.round (@documentRect.height / -2 )  )
        
        @viewRect = {}
        @viewRect.width = 0
        @viewRect.height = 0
        @viewRect.offsetLeft = 0
        @viewRect.offsetTop = 0
        @viewRectRefresh = =>
            documentRect = @documentRectRefresh()
            @viewRect.width = @documentRect.width - @mainViewOffset
            @viewRect.height = @documentRect.height - @mainViewOffset
            @viewRect.offsetLeft = Math.round @viewRect.width / -2
            @viewRect.offsetTop = Math.round @viewRect.height / -2
            @viewRect


        @viewJig0 = {}

        # Jig 1 depends on the current window dimensions, and the enable/mode of the toolbar and framestack windows
        @viewJig0Refresh = =>

            viewRect = @viewRectRefresh()

            # Q1 = toolbar
            # Q24 = frame stack
            # Q3 = content

            centerPoint = {}

            # center X is controlled by Q24 frame stack
            if @viewFrameStackEnable()
                if @viewFrameStackMode() == "full"
                    centerPoint.x = @viewRect.width - 300 - 1
                else
                    centerPoint.x = @viewRect.width - 32 - 1
            else
                centerPoint.x = @viewRect.width - 1

            # center Y is controlled by Q1 toolbar

            if @viewToolbarEnable()
                if @viewToolbarMode() == "full"
                    centerPoint.y = 72
                else
                    centerPoint.y = 32
            else
                centerPoint.y = 0
            jig = Encapsule.code.lib.kohelpers.SplitRectIntoQuads "Jig #0 (L)", @viewRect, centerPoint

            @viewJig0 = jig
            @viewJig0

        @viewJig0Rects = {}
        
        @toolbarWidth = ko.observable 0
        @cssToolbarWidth = ko.computed => @toolbarWidth() + "px"
        @toolbarHeight = ko.observable 0
        @cssToolbarHeight = ko.computed => @toolbarHeight() + "px"
        @toolbarOffsetLeft = ko.observable 0
        @cssToolbarOffsetLeft = ko.computed => @toolbarOffsetLeft() + "px"
        @toolbarOffsetTop = ko.observable 0
        @cssToolbarOffsetTop = ko.computed => @toolbarOffsetTop() + "px"

        @framestackWidth = ko.observable 0
        @framestackHeight = ko.observable 0
        @framestackOffsetLeft = ko.observable 0
        @framestackOffsetTop = ko.observable 0


        @refreshJ0Rects = =>
            jig0 = @viewJig0Refresh()

            @viewJig0Rects.toolbarRect = jig0.quad1
            @viewJig0Rects.stackframeRect = jig0.quad2
            @viewJig0Rects.stackframeRect.height += jig0.quad4.height
            @viewJig0Rects.contentRect =jig0.quad3


          



            @viewJig0Rects




        @viewJig1Selections = undefined

        @viewJig1Refresh = =>

            jig0Rects = @refreshJ0Rects()


            centerPoint = {}

            centerPoint.x = 0
            if @viewSelect1Enable()
                centerPoint.x += @viewSelect1Mode() == "full" and 300 or 32

            if @viewSelect2Enable()
                centerPoint.x += @viewSelect2Mode() == "full" and 300 or 32

            if @viewEdit1Enable()
                if @viewEdit1Mode() == "full"
                    centerPoint.y = @viewHeight() - 400 - 1
                else
                    centerPoint.y = @viewHeight() - 32 - 1
            else
                centerPoint.y = @viewHeight() - 1

            jig = Encapsule.code.lib.kohelpers.SplitRectIntoQuads "Jig #1 (L)", @viewJ0ContentGeometry, centerPoint

 



        @documentResizeCallback = (args_) =>
            result = @refreshJ0Rects()

        # setInterval @documentResizeCallback, 5000 # This catches everything (including browser restore) eventually
        window.addEventListener 'resize', @documentResizeCallback


        @documentResizeCallback()



Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SchemaViewModel", ( ->
    """
    Can has content?
    """))


       
