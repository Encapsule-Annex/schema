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
# encapsule-lib-kohelpers-splitter.coffee

namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
namespaceEncapsule_code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
namespaceEncapsule_code_lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
namespaceEncapsule_code_lib_kohelpers = Encapsule.code.lib.kohelpers? and Encapsule.code.lib.kohelpers or @Encapsule.code.lib.kohelpers = {}

namespaceEncapsule_runtime = Encapsule.runtime? and Encapsule.runtime or @Encapsule.runtime = {}
namespaceEncapsule_runtime_app = Encapsule.runtime.app? and Encapsule.runtime.app or @Encapsule.runtime.app = {}
namespaceEncapsule_runtime_app_kotemplates = Encapsule.runtime.app.kotemplates? and Encapsule.runtime.app.kotemplates or @Encapsule.runtime.app.kotemplates = []

backchannel = Encapsule.runtime.backchannel? and Encapsule.runtime.backchannel or throw "Missing expected Encapsule.runtime.backchannel object."


# \ BEGIN: file scope
class Encapsule.code.lib.kohelpers.WindowSplitter
    # \ BEGIN: class scope
    constructor: (splitDescriptor_, globalWindowAttributes_, windows_ ) ->
        # \ BEGIN: constructor scope
        try
            # \ BEGIN: constructor try scope

            if not splitDescriptor_? then throw "Missing split parameter."
            if not splitDescriptor_ then throw "Missing split value."
            if not windows_? then throw "Missing windows parameter."
            if not windows_ then throw "Missing windows value."
            if not globalWindowAttributes_? then throw "Missing global window attributes parameter."
            if not globalWindowAttributes_ then throw "Missing global window attributes value."

            geo = Encapsule.code.lib.geometry
            
            @splitDescriptor = splitDescriptor_
            @globalWindowAttributes = globalWindowAttributes_

            @id = @splitDescriptor.id
            @type = @splitDescriptor.type
            @name = @splitDescriptor.name

            @q1Descriptor = @splitDescriptor.Q1WindowDescriptor
            @q2Descriptor = @splitDescriptor.Q2WindowDescriptor

            if not @q1Descriptor? and not @q1Descriptor and not @q2Descriptor? and not @q2Descriptor
                throw "You need to specifiy at least one window to a splitter."

            if @q1Descriptor then @q1Descriptor.globalWindowAttributes = globalWindowAttributes_
            if @q2Descriptor then @q2Descriptor.globalWindowAttributes = globalWindowAttributes_

            @offsetRectangle = geo.offsetRectangle.create()
            @q1OffsetRectangle = geo.offsetRectangle.create()
            @q2OffsetRectangle = geo.offsetRectangle.create()
            @unallocatedOffsetRectangle = geo.offsetRectangle.create()
    
            @q1Window = undefined
            @q2Window = undefined
        
            try
                # \ BEGIN: try to create new observable windows scope
                if @q1Descriptor? and @q1Descriptor
                    @q1Window  = new Encapsule.code.lib.kohelpers.ObservableWindowHost(@q1Descriptor)
                    windows_.push @q1Window
        
                if @q2Descriptor? and @q2Descriptor
                    @q2Window = new Encapsule.code.lib.kohelpers.ObservableWindowHost(@q2Descriptor)
                    windows_.push @q2Window
        
                if not @q1Window? and not @q1Window and not @q2Window? and @q2Window
                    throw "Expecting at least one window object to be created per splitter instantiation."
                # / END: try to create new observable windows scope
            catch exception
                throw "Attempting to create new observable windows: #{exception}"

            # Set the bounding offset rectangle defining the outer dimension of this window splitter.
    
            @setOffsetRectangle = (offsetRectangle_, forceEval_ ) =>
                # \ BEGIN: setOffsetRectangle function scope
                try
                    # \ BEGIN: setOffsetRectangle function try scope
    
                    # Return false iff no change and not forceEval_
    
                    if not offsetRectangle_? or not offsetRectangle_
                        throw "You must specify an offset rectangle."
    
                    @offsetRectangle = Encapsule.code.lib.js.clone(offsetRectangle_)
    
                    # By convention splitters consider the entire extent of the offset rectangle passed by the caller
                    # to be their "client" area. The splitter may internally allocate an interior margin to offset
                    # two split windows. However, Q1 and Q2 outer edges are always co-incident with the extent of the
                    # splitter's bounding offset rectangle.

                    # The bounding rectangle has been changed.

                    boundingExtent = 0

                    # \ BEGIN: outer bound extent
                    try
                        # \ BEGIN: outer bound try scope
                        switch @type
                            when "horizontal"
                                boundingExtent = offsetRectangle_.rectangle.extent.height
                            when "vertical"
                                boundingExtent = offsetRectangle_.rectangle.extent.width
                            else
                                throw "Unrecogized splitter type=#{@type}"
                        # / END: outer bound try scope
                    catch exception
                        throw "While attempting to determine the outer binding extents of the splitter's client area: #{exception}"
                    # / END: outer bound extents


                    # Reserve = -1 => no reserve, 0 => greedy
                    q1Reserve = -1
                    q1Allocate = 0
                    q2Reserve = -1
                    q2Allocate = 0

                    # \ BEGIN: set reserves
                    try
                        # \ BEGIN: set reserves try scope
                        if @q1Window and @q1Window.windowEnabled()
                            q1Reserve = @q1Window.sourceDescriptor.modes[@q1Window.windowMode()].reserve
                        if @q2Window and @q2Window.windowEnabled()
                            q2Reserve = @q2Window.sourceDescriptor.modes[@q2Window.windowMode()].reserve
                        # / END: set reserves try scope
                    catch exception
                        throw "While attempting to set window pixel reservation dimensions: #{exception}"
                    # / END: set reserves

                    # \ BEGIN: set allocations
                    try
                        # \ BEGIN: set allocations try scope
                        observableWindowPadding = 2 * ( @globalWindowAttributes.hostWindowPadding + @globalWindowAttributes.chromeWindowPadding +
                            @globalWindowAttributes.windowBorderWidth + @globalWindowAttributes.windowPadding)
                        q1ReserveTotal = q1Reserve + observableWindowPadding
                        q2ReserveTotal = q2Reserve + observableWindowPadding

                        if q1Reserve > 0
                            if q1ReserveTotal <= boundingExtent
                                q1Allocate = q1ReserveTotal
                                boundingExtent -= q1Allocate

                        if q2Reserve > 0
                            if q2ReserveTotal <= boundingExtent
                                q2Allocate = q2ReserveTotal
                                boundingExtent -= q2Allocate

                        # / END: set allocations try scope
                    catch exception
                        throw "While attempting to set window pixel allocations: #{exception}"
                    # / END: set allocations

                    # \ BEGIN: balance allocations
                    try
                        # \ BEGIN: balance allocations try scope
                        if boundingExtent > 0 # there's unallocated space remaining in the splitter client
                            # \ BEGIN: if boundingExtent > 0
                            if (q1Reserve == 0) and (q2Reserve == 0)
                                halfRemainingBoundingExtent = boundingExtent / 2
                                q1Allocate += halfRemainingBoundingExtent
                                q2Allocate += halfRemainingBoundingExtent
                                boundingExtent = 0
                            else
                                if q1Reserve == 0
                                    q1Allocate += boundingExtent
                                    boundingExtent = 0
                                if q2Reserve == 0
                                    q2Allocate += boundingExtent
                                    boundingExtent = 0
    
                            if @q1Window and @q1Window.windowEnabled() and @q2Window and @q2Window.windowEnabled() and boundingExtent > 0
                                throw "This looks wrong. We've got two enabled windows in this splitter but have #{boundingExtent} pixels remaining after split."
                                boundingExtent = 0

                            # / END: / if boundExtent > 0
                        # / END: balance allocations try scope
                    # / END: balance allocations

                    q1SplitterFrameMargins = undefined
                    q2SplitterFrameMargins = undefined

                    boundingWidth = offsetRectangle_.rectangle.extent.width
                    boundingHeight = offsetRectangle_.rectangle.extent.height

                    # \ BEGIN: set frame margins
                    try
                        # \ BEGIN: set frame margins try scope
                        switch @type
                            # \ BEGIN: switch @type
                            when "horizontal"
                               if q1Allocate
                                   q1SplitterFrameMargins = geo.margins.createForPixelDimensions(0, 0, boundingHeight - q1Allocate, 0)
                               else
                                   q1SplitterFrameMargins = geo.margins.createForPixelDimensions(0, 0, q2Allocate, 0)
                               if q2Allocate
                                   q2SplitterFrameMargins = geo.margins.createForPixelDimensions(boundingHeight - q2Allocate, 0, 0, 0)
                               else
                                   q2SplitterFrameMargins = geo.margins.createForPixelDimensions(q1Allocate, 0, 0, 0)
                            when "vertical"
                                if q1Allocate
                                    q1SplitterFrameMargins = geo.margins.createForPixelDimensions(0, 0, 0, boundingWidth - q1Allocate)
                                else
                                    q1SplitterFrameMargins = geo.margins.createForPixelDimensions(0, 0, 0, q2Allocate)
                                if q2Allocate
                                    q2SplitterFrameMargins = geo.margins.createForPixelDimensions(0, boundingWidth - q2Allocate, 0, 0)
                                else
                                    q2SplitterFrameMargins = geo.margins.createForPixelDimensions(0, q1Allocate, 0, 0)
                            # / END: switch @type scope
                        # / END: set frame margins try scope
                    catch exception
                        throw "While attempting to set frame margins: #{exception}"
                    # / END: set frame margins

                    # \ BEGIN: create frames
                    try
                        # \ BEGIN: create frames try scope
                        #backchannel.log("... q1SplitterFrame: ")
                        q1SplitterFrame = geo.frame.createFromOffsetRectangleWithMargins(@offsetRectangle, q1SplitterFrameMargins)
                        #backchannel.log("... q2SplitterFrame: ")
                        q2SplitterFrame = geo.frame.createFromOffsetRectangleWithMargins(@offsetRectangle, q2SplitterFrameMargins)
                        # / END: create frames try scope
                    catch exception
                        throw "While attempting to create splitter frames: #{exception}"
                    # / END: create frames

                    # \ BEGIN: update windows
                    try
                        # \ BEGIN: update windows try scope
                        if q1Allocate
                            #backchannel.log("... ... Splitter id=#{@id} updating position of Q1 window id=#{@q1Window.id}")
                            @q1Window.setOffsetRectangle(q1SplitterFrame.view)
                        if q2Allocate
                            #backchannel.log("... ... Splitter id=#{@id} updating position of Q2 window id=#{@q2Window.id}")
                            @q2Window.setOffsetRectangle(q2SplitterFrame.view)
                        # / END: update windows try scope
                    catch exception
                        throw "While attempting to update splitter window geometries: #{exception}"
                    # / END: update windows

                    remainingClientOffsetRectangle = undefined

                    # \ BEGIN: set unallocated space
                    try
                        # \ BEGIN: set unallocated space try scope
                        if q1Allocate and q2Allocate
                            # The splitter has consumed its entire client area
                            #backchannel.log("... ... #{@id} client area exhaused.")
                            remainingClientOffsetRectangle = geo.offsetRectangle.create()
                        else
                            # \ BEGIN: else
                            if q1Allocate
                                #backchannel.log("... ... Assigning q2SplitterFrame.view to unallocated space for next split.")
                                remainingClientOffsetRectangle = q2SplitterFrame.view
                            else
                                # \ BEGIN: else
                                if q2Allocate
                                    #backchannel.log("... ... Assigning q1SplitterFrame.view to unallocated space for next split.")
                                    remainingClientOffsetRectangle = q1SplitterFrame.view
                                else
                                    #backchannel.log("... ... This splitter allocated no client space.")
                                    remainingClientOffsetRectangle = offsetRectangle_
                                # / END: else
                            # / END: else
                        # / END: set unallocated space try scope
                    catch exception
                        throw "While attempting to set unallocated space for next splitter: #{exception}"
                    # / END: set unallocated space

                    remainingClientOffsetRectangle

                    # / END: setOffsetRectangle function try scope
                catch exception
                    throw "Splitter #{@id} fail: #{exception}"
                # / END: setOffsetRectangle function scope

            # / END: constructor try scope
        catch exception
            throw "Splitter constructor fail: #{exception}"
        # / END: constructor scope
    # / END: class scope
# / END: file scope
 



