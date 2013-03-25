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

class Encapsule.code.lib.kohelpers.ObservableWindow
    constructor: (sourceDescriptor_) ->
        try
            # \ BEGIN: constructor try scope
            Console.message("... + WindowManager creating new window id=#{sourceDescriptor_.id} name=#{sourceDescriptor_.name}")

            geo = Encapsule.code.lib.geometry

            @sourceDescriptor = sourceDescriptor_

            @id = sourceDescriptor_.id
            @name = sourceDescriptor_.name

            @offsetRectangle = ko.observable geo.offsetRectangle.create()

            @windowEnabled = ko.observable sourceDescriptor_.initialEnable
            @windowMode = ko.observable sourceDescriptor_.initialMode
            

            try
                # \ BEGIN: try scope
                @cssVisibility = ko.computed =>
                   offsetRectangle = @offsetRectangle()
                   @offsetRectangle().rectangle.hasArea
                @cssWidth = ko.computed => @offsetRectangle().rectangle.extent.width + "px"
                @cssHeight = ko.computed => @offsetRectangle().rectangle.extent.height + "px"
                @cssMarginLeft = ko.computed => @offsetRectangle().offset.left + "px"
                @cssMarginTop = ko.computed => @offsetRectangle().offset.top + "px"
                @cssOpacity = ko.observable 1
                @cssBackgroundColor = ko.observable "red"
                @cssBorder = ko.observable "1px solid black"
                # / END try scope
            catch exception
                throw "Failure on first execution of computed obervable properties: #{exception}"

            @setOffsetRectangle = (offsetRectangle_) =>
                # We will do some checking here to ensure that a change actually occurred.
                # If so, then we will update the Knockout.js observables contained by thie ObservableWindow instance
                Console.message("Observable window offset rectangle updated: #{offsetRectangle_.rectangle.extent.width} x #{offsetRectangle_.rectangle.extent.height} // #{offsetRectangle_.offset.left}, #{offsetRectangle_.offset.top}")
                @offsetRectangle(offsetRectangle_)

            # / END: constructor try scope
        catch exception
            throw "ObservableWindow constructor fail: #{exception}"
        # / END: constructor scope
    # / END: class scope
# / END: file scope
            
Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_EncapsuleWindowManagerObservableWindow", ( -> """
<div class="classObservableWindow" data-bind="style: { width: cssWidth(), height: cssHeight(), marginLeft: cssMarginLeft(), marginTop: cssMarginTop(), opacity: cssOpacity(), backgroundColor: cssBackgroundColor() }">
    ObservableWindow <span data-bind="text: $index"></span>: id=<span data-bind="text: id"></span> &bull; <span data-bind="text: name"></span><br>
</div>
"""))


