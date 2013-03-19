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

        @viewNavigator = ko.observable new Encapsule.code.app.SchemaViewModelNavigator()
        @viewNavigatorMode = ko.observable "min"
        @viewNavigatorEnable = ko.observable true

        #
        # These are the top-level data models for each of Schema's main application windows.
        #      

        @viewToolbar = ko.observable new Encapsule.code.app.SchemaViewModelSvgPlane()
        @viewToolbarMode = ko.observable "full" # == "full" | "min"
        @viewToolbarEnable = ko.observable true

        @viewFrameStack = ko.observable new Encapsule.code.app.SchemaViewModelSvgPlane()
        @viewFrameStackMode = ko.observable "full" # == "full | "min"
        @viewFrameStackEnable = ko.observable true

        @viewSvgPlane = ko.observable new Encapsule.code.app.SchemaViewModelSvgPlane()
        @viewSvgPlaneMode = ko.observable "full" # == "full | "min"
        @viewSvgPlaneEnable = ko.observable true

        @viewEdit1 = ko.observable new Encapsule.code.app.SchemaViewModelSvgPlane()
        @viewEdit1Mode = ko.observable "full" # == "full | "min"
        @viewEdit1Enable = ko.observable true

        @viewSelect1 = ko.observable new Encapsule.code.app.SchemaViewModelSvgPlane()
        @viewSelect1Mode = ko.observable "full" # == "full | "min"
        @viewSelect1Enable = ko.observable true

        @viewSelect2 = ko.observable new Encapsule.code.app.SchemaViewModelSvgPlane()
        @viewSelect2Mode = ko.observable "full" # == "full | "min"
        @viewSelect2Enable = ko.observable true



        #
        # All of this is to keep track of the inner dimensions of the browser window.
        # The knockout observables should be considered as inputs written by either
        # a 'resize' event or timer (used to catch problems with restore from full-screen).
        #

        @mainViewOffset = 32

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

            twiddleFactor = 32

            # Determine the total area available for the Schema view model.
            queryEl = $(document) 


            @documentRect.widthActual =  queryEl.width()
            @documentRect.heightActual = queryEl.height()

            @documentRect.innerWidthActual = queryEl.innerWidth()
            @documentRect.innerHeightActual = queryEl.innerHeight()

            @documentRect.outerWidthActual = queryEl.outerWidth()
            @documentRect.outerHeightActual = queryEl.outerHeight()

            @documentRect.outerMarginWidthActual = queryEl.outerWidth(true)
            @documentRect.outerMarginHeightActual = queryEl.outerHeight(true)

         


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


        @documentResizeCallback = (args_) =>
            result = @viewRectRefresh()

        # setInterval @documentResizeCallback, 5000 # This catches everything (including browser restore) eventually
        window.addEventListener 'resize', @documentResizeCallback

        @documentResizeCallback()

        @windowManager = new Encapsule.code.lib.kohelpers.ObservableWindowManager @viewRect, [
            {
                name: "Frame Stack Split"
                type: "vertical"
                Q1WindowDescriptor: undefined
                Q2WindowDescriptor: {
                    id: "idFrameStack"
                    name: "Frame Stack Window"
                    modes: { full: { reserve: 300 }, min: { reserve: 64 } }
                    }
                },
            {
                name: "Toolbar Split"
                type: "horizontal"
                Q1WindowDescriptor: {
                    id: "idToolbar"
                    name: "Toolbar Window"
                    modes: { full: { reserve: 128 }, min: { reserve: 64 } }
                    }
                Q2WindowDescriptor: undefined
                },
            {
                name: "Select 1 Split"
                type: "vertical"
                Q1WindowDescriptor: {
                    id: "idSelect1"
                    name: "Select 1 Window"
                    modes: { full: { reserve: 300 }, min: { reserve: 64 } }
                    }
                Q2WindowDescriptor: undefined
                },
            {
                name: "Select 2 Split"
                type: "vertical"
                Q1WindowDescriptor: {
                    id: "idSelect2"
                    name: "Select 1 Window"
                    modes: { full: { reserve: 300 }, min: { reserve: 64 } }
                    }
                Q2WindowDescriptor: undefined
                },
            {
                name: "SVG/Edit Split"
                type: "horizontal"
                Q1WindowDescriptor: {
                    id: "idSVGPlane"
                    name: "SVG Plane"
                    modes: { full: { reserve: 0 }, min: { reserve: 0 } }
                    }
                Q2WindowDescriptor: {
                    id: "idEdit1"
                    name: "Edit 1 Window"
                    modes: { full: { reserve: 0 }, min: { reserve: 64 } }
                    }
                }
            ] # :-)

        





Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SchemaViewModel", ( ->
    """What's up doc?"""))

###

    """

    <div id="idSchemaViewToolbar" class="classSchemaLayerWindow classLayerWindowBorder classRoundedCorners15" data-bind="visible: viewToolbarEnable, style: { width: cssToolbarWidth(), height: cssToolbarHeight(), marginLeft: cssToolbarOffsetLeft(), marginTop: cssToolbarOffsetTop() }">
        Toolbar
    </div>

    <div  id="idSchemaViewSelect1" class="classSchemaLayerWindow classRoundedCorners15" data-bind="visible: viewSelect1Enable, style: { width: cssSelect1Width(), height: cssSelect1Height(), marginLeft: cssSelect1OffsetLeft(), marginTop: cssSelect1OffsetTop() }">
        Select 1
    </div>

    <div id="idSchemaViewSelect2" class="classSchemaLayerWindow classRoundedCorners15" data-bind="visible: viewSelect2Enable, style: { width: cssSelect2Width(), height: cssSelect2Height(), marginLeft: cssSelect2OffsetLeft(), marginTop: cssSelect2OffsetTop() }">
        Select 2
    </div>

    <div id="idSchemaViewFrameStack" class="classSchemaLayerWindow classRoundedCorners15"  data-bind="visible: viewFrameStackEnable, style: { width: cssFrameStackWidth(), height: cssFrameStackHeight(), marginLeft: cssFrameStackOffsetLeft(), marginTop: cssFrameStackOffsetTop() }">
        Frame Stack
    </div>

    <div id="idSchemaViewSvgPlane" class="classSchemaLayerWindow classRoundedCorners15"  data-bind="visible: viewSvgPlaneEnable, style: { width: cssSvgPlaneWidth(), height: cssSvgPlaneHeight(), marginLeft: cssSvgPlaneOffsetLeft(), marginTop: cssSvgPlaneOffsetTop() }">
        SVG Plane
    </div>

    <div  id="idSchemaViewEdit" class="classSchemaLayerWindow classRoundedCorners15" data-bind="visible: viewEdit1Enable, style: { width: cssEdit1Width(), height: cssEdit1Height(), marginLeft: cssEdit1OffsetLeft(), marginTop: cssEdit1OffsetTop() }">
        Edit 1
    </div>

    """))

###

       
