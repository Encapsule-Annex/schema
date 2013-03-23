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



# \ BEGIN: file scope
class Encapsule.code.lib.kohelpers.WindowSplitter
    # \ BEGIN: class scope
    constructor: (splitDescriptor_, windows_) ->
        # \ BEGIN: constructor scope
        try
            # \ BEGIN: constructor try scope

            geo = Encapsule.code.lib.geometry
            
            @splitDescriptor = splitDescriptor_
    
            @id = @splitDescriptor.id
            @type = @splitDescriptor.type
            @name = @splitDescriptor.name
            @offsetRectangle = new geo.offsetRectangle.create()
    
            @q1Descriptor = @splitDescriptor.Q1WindowDescriptor
            @q2Descriptor = @splitDescriptor.Q2WindowDescriptor
    
            if not @q1Descriptor? and not @q1Descriptor and not @q2Descriptor? and not @q2Descriptor
                throw "You need to attach at least one window to a splitter."
    
            @q1OffsetRect = geo.offsetRectangle.create()
            @q2OffsetRect = geo.offsetRectangle.create()
    
            @q1Window = undefined
            @q2Window = undefined
    
            @unallocatedOffsetRect = geo.offsetRectangle.create()
    
            try
                # \ BEGIN: try to create new observable windows scope
                if @q1Descriptor? and @q1Descriptor
                    @q1Window  = new Encapsule.code.lib.kohelpers.ObservableWindow(@q1Descriptor)
                    windowEntry = { id: @q1Window.id, window: @q1Window }
                    windows_.push windowEntry
        
                if @q2Descriptor? and @q2Descriptor
                    @q2Window = new Encapsule.code.lib.kohelpers.ObservableWindow(@q2Descriptor)
                    windowEntry = { id: @q2Window.id, window: @q2Window }
                    windows_.push windowEntry
        
                if not @q1Window? and not @q1Window and not @q2Window? and @q2Window
                    throw "Expecting at least one window object to be created per splitter instantiation."
                # / END: try to create new observable windows scope
            catch exception
                throw "Attempting to create new observable windows: #{exception}"

            # Set the bounding offset rectangle defining the outer dimension of this window splitter.
    
            @setOffsetRectangle = (offsetRectangle_, forceEval_ ) =>
                # \ BEGIN: setOffsetRectangle function scope
    
                # Return false iff no change and not forceEval_
    
                if not offsetRectangle_? or not offsetRectangle_
                    throw "You must specify an offset rectangle."
    
                if (offsetRectangle_.rectangle.width == @offsetRectangle.rectangle.width) and
                    (offsetRectangle_.rectangle.height == @offsetRectangle.rectangle.height) and
                    (offsetRectangle_.offset.left == @offsetRectangle.offset.left) and
                    (offsetRectangle_.offset.top == @offsetRectangle.offset.top)
                        return false;
    
                # The bounding rectangle has been changed.
                @offsetRectangle = offsetRectangle_
    
                @q1OffsetRectangle = offsetRectangle_
                @q2OffsetRectangle = offsetRectangle_
    
                halfWidth = Math.round offsetRectangle_.rectangle.width / 2
                @q1OffsetRectangle.rectangle.width = halfWidth
                @q2OffsetRectangle.rectangle.width = halfWidth
                @q2OffsetRectangle.offset.left += halfWidth
    
                if @q1Window?
                    @q1Window.setOffsetRectangle(@q1OffsetRectangle)
                else
                    @unallocatedOffsetRect = @q1OffsetRectangle
    
                if @q2Window?
                    @q2Window.setOffsetRectangle(@q2OffsetRectangle)
                else
                    if  @unallocatedOffsetRect.rectangle.visible
                        @unallocatedOffsetRect.rectangle.width += @q2OffsetRectangle.rectangle.width
                    else
                        @unallocatedOffsetRect = @q2OffsetRectangle
                # / END: setOffsetRectangle function scope


            # / END: constructor try scope
        catch exception
            throw "Splitter constructor fail: #{exception}"
        # / END: constructor scope
    # / END: class scope
# / END: file scope
 



