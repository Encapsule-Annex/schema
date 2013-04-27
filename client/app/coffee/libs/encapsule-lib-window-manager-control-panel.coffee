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
# encapsule-lib-window-manager-control-panel.coffee
#


namespaceEncapsule = Encapsule? and Encapsule or @Encapsule = {}
Encapsule.code = Encapsule.code? and Encapsule.code or @Encapsule.code = {}
Encapsule.code.lib = Encapsule.code.lib? and Encapsule.code.lib or @Encapsule.code.lib = {}
Encapsule.code.lib.kohelpers = Encapsule.code.lib.kohelpers? and Encapsule.code.lib.kohelpers or @Encapsule.code.lib.kohelpers = {}
Encapsule.code.lib.kohelpers.implementation = Encapsule.code.lib.kohelpers.implementation? and Encapsule.code.lib.kohelpers.implementation or @Encapsule.code.lib.kohelpers.implementation = {}


Encapsule.runtime = Encapsule.runtime? and Encapsule.runtime or @Encapsule.runtime = {}
Encapsule.runtime.app = Encapsule.runtime.app? and Encapsule.runtime.app or @Encapsule.runtime.app = {}
Encapsule.runtime.app.kotemplates = Encapsule.runtime.app.kotemplates? and Encapsule.runtime.app.kotemplates or @Encapsule.runtime.app.kotemplates = []


# Data facet is an observable model view object that holds a reference to a more
# complex model view. It's purpose is to provide a simpler surface upon which to
# base different domain-specific view models.


class Encapsule.code.lib.kohelpers.implementation.ObservableWindowManagerControlPanel
    constructor: (windowManagerObject_) ->
        @windowManagerObject = windowManagerObject_
        @planes = windowManagerObject_.planes

        @showPlane = (planeObject_) =>
            Encapsule.runtime.app.SchemaWindowManager.displayPlane(planeObject_.id)


Encapsule.code.lib.kohelpers.RegisterKnockoutViewTemplate("idKoTemplate_WindowManagerControlPanel", ( ->
    """
    <div>
    <span data-bind="foreach: planes">
        <span data-bind="if: windowManagerReservePlane == undefined">
            <span data-bind="if: enabled">
                <button type="button"  data-bind="click: $parent.showPlane" class="button small green"><span data-bind="text: name"></span></button>
            </span>
            <span data-bind="ifnot: enabled">
                <button type="button" data-bind="click: $parent.showPlane" class="button small black"><span data-bind="text: name"></span></button>
            </span>
        </span>
    </span>
    </div>
    """))
