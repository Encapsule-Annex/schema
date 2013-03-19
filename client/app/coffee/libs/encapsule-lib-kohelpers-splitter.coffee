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



class Encapsule.code.lib.kohelpers.WindowSplitter
    constructor: (type_, q1Descriptor_, q2Descriptor_, windows_) ->

        @type = type_

        @offsetRectangle = undefined

        @q1Descriptor = q1Descriptor_
        @q2Descriptor = q2Descriptor_

        @q1OffsetRectangle = undefined
        @q2OffsetRectangle = undefined

        @q1Window = undefined
        @q2Window = undefined

        @unallocatedOffsetRect = undefined

        if q1Descriptor_? and q1Descriptor_
            @q1Window  = new Encapsule.code.lib.kohelpers.ObservableWindow(q1Descriptor_)
            windowEntry = { id: @q1Window.id, window: @q1Window }
            windows_.push windowEntry

        if q2Descriptor_? and q2Descriptor_
            @q2Window = new Encapsule.code.lib.kohelpers.ObservableWindow(q2Descriptor_)
            windowEntry = { id: @q2Window.id, window: @q2Window }
            windows_.push windowEntry


        # Set the bounding offset rectangle defining the outer dimension of this window splitter.

        @setOffsetRectangle = (offsetRectangle_, forceEval_ ) =>

            # Return false iff no change and not forceEval_

            if offsetRectangle_? and offsetRectangle_ and offsetRectangle_ == @offsetRectangle and not forceEval_
                return false
            
            # The bounding rectangle has been changed.

            @offsetRectangle = offsetRectangle_

