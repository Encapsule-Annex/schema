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
                    centerPoint.x = @viewRect.width - 300
                else
                    centerPoint.x = @viewRect.width - 32
            else
                centerPoint.x = @viewRect.width

            # center Y is controlled by Q1 toolbar

            if @viewToolbarEnable()
                if @viewToolbarMode() == "full"
                    centerPoint.y = 72
                else
                    centerPoint.y = 32
            else
                centerPoint.y = 0
            jig = Encapsule.code.lib.kohelpers.SplitRectIntoQuads "Jig #0 (L)", @viewRect, centerPoint, 3

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
        @cssFrameStackWidth = ko.computed => @framestackWidth() + "px"
        @framestackHeight = ko.observable 0
        @cssFrameStackHeight = ko.computed => @framestackHeight() + "px"
        @framestackOffsetLeft = ko.observable 0
        @cssFrameStackOffsetLeft = ko.computed => @framestackOffsetLeft() + "px"
        @framestackOffsetTop = ko.observable 0
        @cssFrameStackOffsetTop = ko.computed => @framestackOffsetTop() + "px"


        @viewJig0RectsRefresh = =>
            jig0 = @viewJig0Refresh()

            @viewJig0Rects.toolbarRect = jig0.quad1
            @viewJig0Rects.framestackRect = jig0.quad2
            @viewJig0Rects.framestackRect.height += jig0.quad4.height
            @viewJig0Rects.contentRect =jig0.quad3

            @toolbarWidth(@viewJig0Rects.toolbarRect.width)
            @toolbarHeight(@viewJig0Rects.toolbarRect.height)
            @toolbarOffsetLeft(@viewJig0Rects.toolbarRect.offsetLeft)
            @toolbarOffsetTop(@viewJig0Rects.toolbarRect.offsetTop)

            @framestackWidth(@viewJig0Rects.framestackRect.width)
            @framestackHeight(@viewJig0Rects.framestackRect.height)
            @framestackOffsetLeft(@viewJig0Rects.framestackRect.offsetLeft)
            @framestackOffsetTop(@viewJig0Rects.framestackRect.offsetTop)

            @viewJig0Rects



        @viewJig1 = {}

        @viewJig1Refresh = =>

            jig0Rects = @viewJig0RectsRefresh()

            centerPoint = {}

            centerPoint.x = 0
            if @viewSelect1Enable()
                centerPoint.x += @viewSelect1Mode() == "full" and 301 or 33

            if @viewSelect2Enable()
                centerPoint.x += @viewSelect2Mode() == "full" and 301 or 33

            if @viewEdit1Enable()
                if @viewEdit1Mode() == "full"
                    centerPoint.y = @viewJig0Rects.contentRect.height - 400
                else
                    centerPoint.y = @viewJig0Rects.contentRect.height - 32
            else
                centerPoint.y = @viewJig0Rects.contentRect.height

            jig = Encapsule.code.lib.kohelpers.SplitRectIntoQuads "Jig #1 (L)", @viewJig0Rects.contentRect, centerPoint

            @viewJig1 = jig
            @viewJig1



         @viewJig1Rects = {}

         @svgPlaneWidth = ko.observable 0
         @cssSvgPlaneWidth = ko.computed => @svgPlaneWidth() + "px"
         @svgPlaneHeight = ko.observable 0
         @cssSvgPlaneHeight = ko.computed => @svgPlaneHeight() + "px"
         @svgPlaneOffsetLeft = ko.observable 0
         @cssSvgPlaneOffsetLeft = ko.computed => @svgPlaneOffsetLeft() + "px"
         @svgPlaneOffsetTop = ko.observable 0
         @cssSvgPlaneOffsetTop = ko.computed => @svgPlaneOffsetTop() + "px"

         @edit1Width = ko.observable 0
         @cssEdit1Width = ko.computed => @edit1Width() + "px"
         @edit1Height = ko.observable 0
         @cssEdit1Height = ko.computed => @edit1Height() + "px"
         @edit1OffsetLeft = ko.observable 0
         @cssEdit1OffsetLeft = ko.computed => @edit1OffsetLeft() + "px"
         @edit1OffsetTop = ko.observable 0
         @cssEdit1OffsetTop = ko.computed => @edit1OffsetTop() + "px"

         @viewJig1RectsRefresh = =>

             viewJig1 = @viewJig1Refresh()

             result = {}
             result.svgplaneRect = viewJig1.quad2
             result.edit1Rect = viewJig1.quad4
             result.selectRect = viewJig1.quad1
             result.selectRect.height += viewJig1.quad3.height

             @svgPlaneWidth(result.svgplaneRect.width)
             @svgPlaneHeight(result.svgplaneRect.height)
             @svgPlaneOffsetLeft(result.svgplaneRect.offsetLeft)
             @svgPlaneOffsetTop(result.svgplaneRect.offsetTop)

             @edit1Width(result.edit1Rect.width)
             @edit1Height(result.edit1Rect.height)
             @edit1OffsetLeft(result.edit1Rect.offsetLeft)
             @edit1OffsetTop(result.edit1Rect.offsetTop)

             @viewJig1Rects = result
             @viewJig1Rects



        @viewJig2 = {}

        @select1Width = ko.observable 0
        @cssSelect1Width = ko.computed => @select1Width() + "px"
        @select1Height = ko.observable 0
        @cssSelect1Height = ko.computed => @select1Height() + "px"
        @select1OffsetLeft = ko.observable 0
        @cssSelect1OffsetLeft = ko.computed => @select1OffsetLeft() + "px"
        @select1OffsetTop = ko.observable 0
        @cssSelect1OffsetTop = ko.computed => @select1OffsetTop() + "px"

        @select2Width = ko.observable 0
        @cssSelect2Width = ko.computed => @select2Width() + "px"
        @select2Height = ko.observable 0
        @cssSelect2Height = ko.computed => @select2Height() + "px"
        @select2OffsetLeft = ko.observable 0
        @cssSelect2OffsetLeft = ko.computed => @select2OffsetLeft() + "px"
        @select2OffsetTop = ko.observable 0
        @cssSelect2OffsetTop = ko.computed => @select2OffsetTop() + "px"


        @viewJig2Refresh = =>
            viewJig1Rects = @viewJig1RectsRefresh()

            centerPoint = {}
            centerPoint.x = 0
            centerPoint.y = @viewJig1Rects.selectRect.height

            if @viewSelect1Enable()
                centerPoint.x += @viewSelect1Mode() == "full" and 300 or 32
          
            jig = Encapsule.code.lib.kohelpers.SplitRectIntoQuads "Jig #2 (L)", @viewJig1Rects.selectRect, centerPoint 

            @select1Height(jig.quad1.height)
            @select1Width(jig.quad1.width)
            @select1OffsetLeft (jig.quad1.offsetLeft)
            @select1OffsetTop (jig.quad1.offsetTop)         

            @select2Height(jig.quad2.height)
            @select2Width(jig.quad2.width)
            @select2OffsetTop(jig.quad2.offsetTop)
            @select2OffsetLeft(jig.quad2.offsetLeft)   

            @viewJigs2 = jig
            @viewJigs2


        


        @documentResizeCallback = (args_) =>
            result = @viewJig2Refresh()

        # setInterval @documentResizeCallback, 5000 # This catches everything (including browser restore) eventually
        window.addEventListener 'resize', @documentResizeCallback


        @documentResizeCallback()



Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_SchemaViewModel", ( ->
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


       
