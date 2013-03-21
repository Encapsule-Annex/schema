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



class Encapsule.code.lib.kohelpers.ObservableWindow
    constructor: (sourceDescriptor_) ->
        Console.message("... + WindowManager creating new window id=#{sourceDescriptor_.id} name=#{sourceDescriptor_.name}")
        @sourceDescriptor = sourceDescriptor_

        @id = sourceDescriptor_.id
        @name = sourceDescriptor_.name


        @offsetRectangle = ko.observable new Encapsule.code.lib.kohelpers.OffsetRectangle()
        @cssVisibility = ko.computed => @offsetRectangle().rectangle.visible
        @cssWidth = ko.computed => @offsetRectangle().rectangle.width
        @cssHeight = ko.computed => @offsetRectangle().rectangle.height
        @cssMarginLeft = ko.computed => @offsetRectangle().offset.left
        @cssMarginTop = ko.computed => @offsetRectangle().offset.top



        @setOffsetRectangle = (offsetRectangle_) =>
            # We will do some checking here to ensure that a change actually occurred.
            # If so, then we will update the Knockout.js observables contained by thie ObservableWindow instance
            @offsetRectangle(offsetRectangle_)


            


