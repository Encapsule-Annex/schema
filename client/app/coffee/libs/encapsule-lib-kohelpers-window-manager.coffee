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
            if not layout_? or not layout_
                throw "You must specify an array of splitters."

            @offsetRectangle = new Encapsule.code.lib.kohelpers.OffsetRectangle()

            layoutLevel = 0
            @windows = []
            @splits = []

            for splitter in layout_

                try
                    Console.message("Window manager level #{layoutLevel}: #{splitter.name}")
                    Console.message("... type = #{splitter.type}")
                    Console.message("... Q1 window descriptor = #{splitter.Q1WindowDescriptor}")
                    Console.message("... Q2 window descriptor = #{splitter.Q2WindowDescriptor}")

                    newSplit = new Encapsule.code.lib.kohelpers.WindowSplitter( splitter.type, splitter.Q1WindowDescriptor, splitter.Q2WindowDescriptor, @windows )
                    @splits.push newSplit

                    Console.message("... window manager level #{layoutLevel} processing completed.")
                    layoutLevel++

                catch exception
                    throw "Check level #{layoutLevel} for malformed input: #{exception}"

            Console.message("... Done instantiating managed observable windows.")

            @setOffsetRectangle = (offsetRectangle_, forceEval_) =>
                # Return false iff no change and not forceEval_
                
                Console.message("Window manager setOffSetRectangle = #{offsetRectangle_} forceEval=#{forceEval_}")

                if offsetRectangle_? and offsetRectangle_ and offsetRectangle_ == @offsetRectangle and not forceEval_
                    Console.message("... No update necessary.")
                    return false

                Console.message("... Bounding offset rectangle has been updated.")
                @offsetRectangle = offsetRectangle_



            Console.message("... Window manager initialization complete.")



        catch exception
            message = "In Encapsule.code.lib.kohelpers.WindowManager: #{exception}"
            throw message




